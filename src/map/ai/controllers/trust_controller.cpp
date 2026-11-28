/*
===========================================================================

  Copyright (c) 2018 Darkstar Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#include "trust_controller.h"

#include "ai/helpers/gambits_container.h"
#include "ai/states/magic_state.h"
#include "ai/states/range_state.h"
#include "data/enums/mob_mod.h"
#include "enmity_container.h"
#include "entities/char_entity.h"
#include "entities/trust_entity.h"
#include "items/item_weapon.h"
/* LD AI PLAYERS TRUST CONTROLLER */
#include "player_controller.h"
#include "recast_container.h"
#include "utils/charutils.h"
#include "entities/mob_entity.h"
#include "mob_spell_container.h"

#include <algorithm>
#include <cmath>

namespace
{

enum TRUST_MOVEMENT_TYPE : int8
{
    // NOTE: If you need to add special movement types, add descending into the minus values.
    //     : All of the positive values are taken for the ranged movement range.
    // NOTE: You can use any positive value as a distance, and it will act as MID_RANGE or LONG_RANGE, but with the value you've provided.
    //     : For example:
    //     :     mob:setMobMod(xi.mobMod.TRUST_DISTANCE, 20)
    //     : Will set the combat distance the trust tries to stick to to 20'
    // NOTE: If a Trust doesn't immediately sprint to a certain distance at the start of battle, it's probably NO_MOVE or MELEE.
    NO_MOVE    = -1, // Will stand still providing they're within casting distance of their master and target when the fight starts. Otherwise will reposition to be within 9.0' of both
    NON_COMBAT = -2, // Will follow the master if first trust in party and will follow the trust in front if lower in the list.
    MELEE      = 0,  // Default: will continually reposition to stay within melee range of the target
    MID_RANGE  = 6,  // Will path at the start of battle to 6' away from the target, and try to stay at that distance
    LONG_RANGE = 12, // Will path at the start of battle to 12' away from the target, and try to stay at that distance
};

// FFXI Offline squad camp (squad.lua: !squad camp / !squad pull). Squad mates (local var SQUAD_ID) with SQUAD_CAMP
// set hold a spot around the camp instead of following you, fight what comes within CampFightRadius of it (even when
// you are not engaged: a mate pulled it, or you are resting), and let go of anything farther than CampLeash.
// A mate with SQUAD_PULL_PHASE 1 runs out to SQUAD_PULL_TARGET (a mob's targid) and engages it; once the mob is
// engaged (2) it runs back to camp, and at camp the phase goes back to 0 and the fight is on.
// The camp position is in SQUAD_CAMP_X / _Y / _Z, as yalms * 100 + 10000000 (local vars are unsigned).
constexpr float CampHoldRadius  = 2.5f;
constexpr float CampFightRadius = 20.0f;
constexpr float CampLeash       = 30.0f;

auto campDecode(const uint32 value) -> float
{
    return static_cast<float>(static_cast<int64>(value) - 10000000) / 100.0f;
}

auto campOf(const CBaseEntity* PTrust, position_t& camp) -> bool
{
    if (PTrust == nullptr || PTrust->GetLocalVar("SQUAD_ID") == 0 || PTrust->GetLocalVar("SQUAD_CAMP") == 0)
    {
        return false;
    }

    camp   = PTrust->loc.p;
    camp.x = campDecode(PTrust->GetLocalVar("SQUAD_CAMP_X"));
    camp.y = campDecode(PTrust->GetLocalVar("SQUAD_CAMP_Y"));
    camp.z = campDecode(PTrust->GetLocalVar("SQUAD_CAMP_Z"));
    return true;
}

} // namespace

CTrustController::CTrustController(CCharEntity* PChar, CTrustEntity* PTrust)
: CMobController(PTrust)
, m_GambitsContainer(std::make_unique<gambits::CGambitsContainer>(PTrust))
, m_failedRepositionAttempts(0)
, m_InTransit(false)
{
}

CTrustController::~CTrustController()
{
    if (POwner->PAI)
    {
        if (POwner->PAI->IsEngaged())
        {
            POwner->PAI->Internal_Disengage();
        }
        POwner->PAI->PathFind.reset();
    }

    POwner->allegiance = xi::Allegiance::Player;
    POwner->status     = xi::Status::Disappear;
}

void CTrustController::Despawn()
{
    POwner->PMaster   = nullptr;
    POwner->animation = xi::Animation::Despawn;
    CMobController::Despawn();
}

auto CTrustController::Tick(timer::time_point tick) -> Task<void>
{
    TracyZoneScoped;
    TracyZoneString(POwner->getName());

    m_Tick = tick;

    auto* PTrust = static_cast<CTrustEntity*>(POwner);

    if (!PTrust->PMaster)
    {
        co_return;
    }

    if (PTrust->PMaster->isCharmed)
    {
        this->Despawn();
        co_return;
    }

    const bool nonCombatFollowTrust = PTrust->getMobMod(xi::MobMod::TrustDistance) == TRUST_MOVEMENT_TYPE::NON_COMBAT;

    position_t camp{};
    const bool inCamp = campOf(PTrust, camp);
    if (inCamp && PTrust->GetLocalVar("SQUAD_PULL_PHASE") != 0 && !POwner->isDead())
    {
        co_await DoCampPullTick(tick, camp);
    }
    else if (PTrust->PMaster->PAI->IsEngaged() && nonCombatFollowTrust && !inCamp)
    {
        co_await DoNonCombatTick(tick);
    }
    else if (POwner->PAI->IsEngaged())
    {
        co_await DoCombatTick(tick);
    }
    else if (!POwner->isDead())
    {
        co_await DoRoamTick(tick);
    }

    co_return;
}

auto CTrustController::DoCombatTick(timer::time_point tick) -> Task<void>
{
    TracyZoneScoped;

    CTrustEntity* PTrust  = static_cast<CTrustEntity*>(POwner);
    CCharEntity*  PMaster = static_cast<CCharEntity*>(POwner->PMaster);
    CMobEntity*   PMob    = dynamic_cast<CMobEntity*>(PMaster->GetBattleTarget());
    setTarget(POwner->GetBattleTarget());
    auto* PTarget = target().resolve<CBattleEntity>();

    position_t camp{};
    const bool inCamp = campOf(PTrust, camp);
    if (inCamp)
    {
        // camp: the fight at camp goes on without you; anything that wanders off is let go
        if (PTarget == nullptr || PTarget->isDead() || distance(PTarget->loc.p, camp) > CampLeash)
        {
            PTrust->PAI->Internal_Disengage();
            m_CombatEndTime = m_Tick;
        }
    }
    else if (!PMaster->PAI->IsEngaged())
    {
        PTrust->PAI->Internal_Disengage();
        m_CombatEndTime = m_Tick;
    }

    if (inCamp && PMob && distance(PMob->loc.p, camp) > CampFightRadius)
    {
        PMob = nullptr; // (what you are fighting out there is not the camp's fight)
    }

    if (PMaster && PMob && PTrust->battleTarget() != PMaster->battleTarget())
    {
        auto  masterID   = PMaster->id;
        auto* enmityList = PMob->PEnmityContainer->GetEnmityList();
        bool  hasEnmity  = false;

        if (auto it = enmityList->find(masterID); it != enmityList->end())
        {
            const EnmityObject_t& entry = it->second;
            // Only treat as "has enmity" if:
            // the entry is active,
            // the CE+VE is positive,
            // and the master is within enmity range (same checks used when adding enmity).
            if (entry.active && (entry.CE + entry.VE) > 0)
            {
                hasEnmity = true;
            }
        }

        if (hasEnmity)
        {
            PTrust->PAI->Internal_ChangeTarget(PMaster->battleTarget());
        }
    }

    // If busy, don't run around!
    if (PTrust->PAI->IsCurrentState<CMagicState>() || PTrust->PAI->IsCurrentState<CRangeState>())
    {
        co_return;
    }

    if (PTarget)
    {
        if (PTrust->PAI->CanFollowPath() && PTrust->GetSpeed() > 0)
        {
            float currentDistanceToTarget = distance(PTrust->loc.p, PTarget->loc.p);
            float currentDistanceToMaster = distance(PTrust->loc.p, PMaster->loc.p);

            if (!inCamp && !PMaster->PAI->IsEngaged() && currentDistanceToTarget > WarpDistance)
            {
                PTrust->PAI->PathFind->WarpTo(PTarget->loc.p);
            }

            PTrust->PAI->PathFind->LookAt(PTarget->loc.p);

            switch (const int16 movementDistance = PTrust->getMobMod(xi::MobMod::TrustDistance))
            {
                case TRUST_MOVEMENT_TYPE::NO_MOVE:
                {
                    if (currentDistanceToMaster > CastingDistance || currentDistanceToTarget > CastingDistance)
                    {
                        PathOutToDistance(PTarget, 9.0f);
                    }
                    break;
                }
                case TRUST_MOVEMENT_TYPE::NON_COMBAT:
                {
                    // Non-combat followers should not use target-distance positioning.
                    break;
                }
                case TRUST_MOVEMENT_TYPE::MELEE:
                {
                    // CanAttack answers "would a swing land", not "am I standing next to
                    // it": the hitbox sizes are part of GetMeleeRange, so it reads true
                    // from 3+ yalms away and the mate stopped there, looking like it was
                    // swinging from the next camp. Keep closing until it is actually
                    // inside RoamDistance of the mob, whatever CanAttack says.
                    if (PTrust->GetSpeed() > 0 && currentDistanceToTarget > RoamDistance)
                    {
                        if (currentDistanceToTarget < RoamDistance * 3.0f &&
                            PTrust->PAI->PathFind->PathAround(PTarget->loc.p, RoamDistance, PATHFLAG_RUN))
                        {
                            PTrust->PAI->PathFind->FollowPath(m_Tick);
                        }
                        else if (PTrust->GetSpeed() > 0)
                        {
                            PTrust->PAI->PathFind->StepTo(PTarget->loc.p, true);
                        }
                    }
                    break;
                }
                case TRUST_MOVEMENT_TYPE::MID_RANGE:
                    [[fallthrough]];
                case TRUST_MOVEMENT_TYPE::LONG_RANGE:
                    [[fallthrough]];
                default: // Using the positive-non-zero movementDistance mobMod value
                {
                    PathOutToDistance(PTarget, static_cast<float>(movementDistance));
                    break;
                }
            }

            if (!PTrust->PAI->PathFind->IsFollowingPath())
            {
                Declump(PMaster, PTarget);
            }
        }

        if (!m_InTransit)
        {
            PTrust->PAI->PathFind->FollowPath(m_Tick);
        }

        co_await m_GambitsContainer->Tick(tick);

        PTrust->PAI->EventHandler.triggerListener("COMBAT_TICK", PTrust, PMaster, PTarget);
    }

    co_return;
}

auto CTrustController::DoNonCombatTick(const timer::time_point tick) -> Task<void>
{
    TracyZoneScoped;

    auto* PTrust  = static_cast<CTrustEntity*>(POwner);
    auto* PMaster = static_cast<CCharEntity*>(POwner->PMaster);

    if (!PMaster)
    {
        co_return;
    }

    // Keep COMBAT_TICK target valid for listeners/gambits.
    setTarget(PMaster->GetBattleTarget());
    auto* PTarget = target().resolve<CBattleEntity>();

    // Non-combat trust follow order:
    // - first trust follows master
    // - others follow the trust directly in front of them
    uint8 currentPartyPos = GetPartyPosition();

    CBattleEntity* PFollowTarget = PMaster;
    if (currentPartyPos > 0 && static_cast<size_t>(currentPartyPos - 1) < PMaster->PTrusts.size())
    {
        if (auto* PLeadTrust = PMaster->PTrusts.at(currentPartyPos - 1); PLeadTrust && PLeadTrust != PTrust)
        {
            PFollowTarget = PLeadTrust;
        }
    }

    // First trust keeps a bit more space from master.
    constexpr float FirstTrustFollowDistance = 3.0f; // tune as needed
    const float     desiredFollowDistance    = (currentPartyPos == 0) ? FirstTrustFollowDistance : RoamDistance;

    float currentDistance = distance(PTrust->loc.p, PFollowTarget->loc.p);

    // Simple declump so non-combat trusts don't stack on each other.
    for (auto* POtherTrust : PMaster->PTrusts)
    {
        if (POtherTrust != PTrust &&
            distance(POtherTrust->loc.p, PTrust->loc.p) < 1.0f &&
            !PTrust->PAI->PathFind->IsFollowingPath())
        {
            // Sidestep the trust we are stacked on, with odd/even party slots taking opposite sides.
            const float amount  = (currentPartyPos % 2) ? 1.0f : -1.0f;
            const auto  new_pos = sidestepPosition(PTrust->loc.p, POtherTrust->loc.p, amount);

            if (PTrust->PAI->PathFind->ValidPosition(new_pos) &&
                PTrust->PAI->PathFind->PathTo(new_pos, PATHFLAG_RUN))
            {
                PTrust->PAI->PathFind->FollowPath(m_Tick);
            }
            break;
        }
    }

    if (currentDistance > WarpDistance)
    {
        PTrust->PAI->PathFind->WarpTo(PFollowTarget->loc.p);
    }
    else if (currentDistance > desiredFollowDistance)
    {
        if (currentDistance < desiredFollowDistance * 3.0f &&
            PTrust->PAI->PathFind->PathAround(PFollowTarget->loc.p, desiredFollowDistance, PATHFLAG_RUN))
        {
            PTrust->PAI->PathFind->FollowPath(m_Tick);
        }
        else if (PTrust->GetSpeed() > 0)
        {
            PTrust->PAI->PathFind->StepTo(PFollowTarget->loc.p, true);
        }
    }

    if (PTrust->PAI->PathFind->IsFollowingPath())
    {
        PTrust->PAI->PathFind->FollowPath(m_Tick);
    }

    // Keep gambits active in combat, but only while stationary.
    if (PMaster->PAI->IsEngaged() && !PTrust->PAI->PathFind->IsFollowingPath())
    {
        co_await m_GambitsContainer->Tick(tick);
        PTrust->PAI->EventHandler.triggerListener("COMBAT_TICK", PTrust, PMaster, PTarget);
    }

    co_return;
}

auto CTrustController::DoRoamTick(timer::time_point tick) -> Task<void>
{
    TracyZoneScoped;

    auto*      PMaster              = static_cast<CCharEntity*>(POwner->PMaster);

    position_t camp{};
    if (campOf(POwner, camp))
    {
        // camp: fight what reaches the camp (yours, or what another mate is fighting there), else hold the spot
        CBattleEntity* PFight = nullptr;
        if (PMaster->PAI->IsEngaged())
        {
            auto* PTarget = PMaster->GetBattleTarget();
            if (PTarget && !PTarget->isDead() && distance(PTarget->loc.p, camp) <= CampFightRadius)
            {
                PFight = PTarget;
            }
        }

        for (auto* POther : PMaster->PTrusts)
        {
            if (PFight != nullptr)
            {
                break;
            }

            if (POther != nullptr && POther != POwner && POther->PAI->IsEngaged())
            {
                auto* PTarget = POther->GetBattleTarget();
                if (PTarget && !PTarget->isDead() && distance(PTarget->loc.p, camp) <= CampFightRadius)
                {
                    PFight = PTarget;
                }
            }
        }

        if (PFight != nullptr)
        {
            POwner->PAI->Internal_Engage(EntityId(PFight));
        }
        else
        {
            CampHold(camp);
        }

        co_return;
    }

    const auto masterLastAttackTime = static_cast<CPlayerController*>(PMaster->PAI->GetController())->getLastAttackTime();
    const bool masterMeleeSwing     = masterLastAttackTime > timer::now() - 1s;

    bool trustEngageCondition = false;
    // NOTE: charvars are now cached, this is essentially a localvar read now.
    switch (charutils::GetCharVar(PMaster, "TrustEngageType"))
    {
        case 1: // Master engages a monster, no melee swing required
        {
            trustEngageCondition = PMaster->GetBattleTarget();
            break;
        }
        case 0: // Nothing set
            [[fallthrough]];
        default: // Something invalid set
        {
            // Default retail behavior: Master engages a monster and executes a melee swing
            trustEngageCondition = PMaster->GetBattleTarget() && masterMeleeSwing;
            break;
        }
    }

    constexpr uint16 modelID_Cornelia = 3119; // Cornielia does not have an Attack Schedule so do not engage.

    if (PMaster->PAI->IsEngaged() && trustEngageCondition && POwner->GetModelId() != modelID_Cornelia)
    {
        POwner->PAI->Internal_Engage(PMaster->battleTarget());
    }

    const uint8          currentPartyPos = GetPartyPosition();
    const CBattleEntity* PFollowTarget   = (GetPartyPosition() > 0) ? static_cast<CBattleEntity*>(PMaster->PTrusts.at(currentPartyPos - 1)) : POwner->PMaster;
    const float          currentDistance = distance(POwner->loc.p, PFollowTarget->loc.p);

    // Formation following thresholds (in yalms)
    // First trust follows master more closely than other trusts follow each other
    const bool isFirstTrust = (currentPartyPos == 0);

    const float declumpDistance = isFirstTrust ? 1.0f : 1.5f; // Too close, need to move away
    const float followMax       = isFirstTrust ? 2.0f : 3.5f; // Maximum follow distance before moving closer
    const float followTarget    = isFirstTrust ? 1.5f : 3.0f; // Ideal follow distance

    // Handle formation movement based on distance thresholds
    if (currentDistance < declumpDistance)
    {
        // Too close to follow target - push away to maintain formation spacing
        position_t awayFromTarget = PFollowTarget->loc.p;
        awayFromTarget.rotation   = worldAngle(PFollowTarget->loc.p, POwner->loc.p);
        const auto spacedPos      = nearPosition(awayFromTarget, followTarget + 0.5f, 0.0f);

        if (POwner->PAI->PathFind->ValidPosition(spacedPos) &&
            POwner->PAI->PathFind->PathTo(spacedPos, PATHFLAG_RUN))
        {
            POwner->PAI->PathFind->FollowPath(m_Tick);
        }
    }
    else if (currentDistance > followMax)
    {
        // Too far from follow target - move closer to maintain formation
        if (currentDistance > WarpDistance)
        {
            // Warp if extremely too far
            POwner->PAI->PathFind->WarpTo(PFollowTarget->loc.p);
        }
        else
        {
            // Path or step closer to follow target
            if (currentDistance < RoamDistance * 3.0f && POwner->PAI->PathFind->PathAround(PFollowTarget->loc.p, followTarget, PATHFLAG_RUN))
            {
                POwner->PAI->PathFind->FollowPath(m_Tick);
            }
            else if (POwner->GetSpeed() > 0)
            {
                POwner->PAI->PathFind->StepTo(PFollowTarget->loc.p, true);
            }
        }
    }
    else
    {
        // In formation range - stop pathfinding to prevent circling
        if (POwner->PAI->PathFind->IsFollowingPath())
        {
            POwner->PAI->PathFind->Clear();
        }
    }

    // Squad mates (FFXI Offline squad module) only recover while their player rests (/heal): no automatic regen.
    if (POwner->GetLocalVar("SQUAD_ID") == 0 && POwner->CanRest() && m_Tick - POwner->LastAttacked > m_tickDelays.at(0) && m_Tick - m_CombatEndTime > m_tickDelays.at(0) &&
        m_Tick - m_LastHealTickTime > m_tickDelays.at(m_NumHealingTicks))
    {
        if (POwner->health.hp != POwner->health.maxhp || POwner->health.mp != POwner->health.maxmp)
        {
            // recover 5% HP & MP
            const uint32 recoverHP = static_cast<uint32>(POwner->health.maxhp * 0.05);
            const uint32 recoverMP = static_cast<uint32>(POwner->health.maxmp * 0.05);
            POwner->addHP(recoverHP);
            POwner->addMP(recoverMP);
            m_LastHealTickTime = m_Tick;
            POwner->updatemask |= UPDATE_HP;
            m_NumHealingTicks = std::clamp(m_NumHealingTicks + 1, static_cast<std::size_t>(0U), m_tickDelays.size() - 1U);
        }
    }

    co_return;
}

// camp: stand on its own spot around the camp (one per party slot)
void CTrustController::CampHold(const position_t& camp)
{
    const float angle = static_cast<float>(GetPartyPosition()) * 2.0f * 3.14159265f / 5.0f;
    position_t  spot  = camp;
    spot.x            = camp.x + CampHoldRadius * std::cos(angle);
    spot.z            = camp.z + CampHoldRadius * std::sin(angle);
    if (!POwner->PAI->PathFind->ValidPosition(spot))
    {
        spot = camp;
    }

    const float away = distance(POwner->loc.p, spot);
    if (away > 60.0f)
    {
        POwner->PAI->PathFind->WarpTo(spot);
    }
    else if (away > 1.0f)
    {
        if (!POwner->PAI->PathFind->IsFollowingPath() || m_Tick - m_CampRepath > 2s)
        {
            m_CampRepath = m_Tick;
            POwner->PAI->PathFind->PathTo(spot, PATHFLAG_RUN);
        }

        POwner->PAI->PathFind->FollowPath(m_Tick);
    }
    else if (POwner->PAI->PathFind->IsFollowingPath())
    {
        POwner->PAI->PathFind->Clear();
    }
}

// camp: the puller's run - out to the monster, engage it, and back to camp once it comes
// FFXI Offline squad camp: how a puller opens on its target from range, as players did. A caster uses a pull spell it
// knows (Dia, Bio, Poison, then a tier one nuke); a melee job with a ranged weapon (bow, gun, throwing) shoots it.
namespace
{
constexpr float CampPullCastRange  = 18.0f;
constexpr float CampPullShootRange = 20.0f;

auto knows(const std::vector<SpellID>& list, SpellID id) -> bool
{
    return std::find(list.begin(), list.end(), id) != list.end();
}

auto campPullSpell(CTrustEntity* PTrust) -> Maybe<SpellID>
{
    if (PTrust->SpellContainer == nullptr || !PTrust->SpellContainer->HasSpells())
    {
        return std::nullopt;
    }

    // Dia, Dia II, Bio, Poison, Stone, Water, Aero, Fire, Blizzard, Thunder, Banish
    for (const uint16 n : { 23, 24, 230, 220, 159, 169, 154, 144, 149, 164, 28 })
    {
        const auto id = static_cast<SpellID>(n);
        auto*      sc = PTrust->SpellContainer;
        if ((knows(sc->m_debuffList, id) || knows(sc->m_damageList, id)) && sc->GetAvailable(id))
        {
            return id;
        }
    }

    return std::nullopt;
}

auto hasRangedWeapon(const CTrustEntity* PTrust) -> bool
{
    const auto* ranged = dynamic_cast<CItemWeapon*>(PTrust->m_Weapons[SLOT_RANGED]);
    if (ranged && ranged->getID() != 0 && (ranged->getSkillType() == xi::SkillType::Archery || ranged->getSkillType() == xi::SkillType::Marksmanship ||
                                           ranged->getSkillType() == xi::SkillType::Throwing))
    {
        return true;
    }

    const auto* ammo = dynamic_cast<CItemWeapon*>(PTrust->m_Weapons[SLOT_AMMO]);
    return ammo && ammo->getID() != 0 && ammo->isThrowing();
}
} // namespace

auto CTrustController::DoCampPullTick(timer::time_point tick, const position_t& camp) -> Task<void>
{
    auto* PTrust = static_cast<CTrustEntity*>(POwner);
    auto* PMob   = dynamic_cast<CMobEntity*>(PTrust->GetEntity(static_cast<uint16>(PTrust->GetLocalVar("SQUAD_PULL_TARGET")), TYPE_MOB));
    if (PMob == nullptr || PMob->isDead() || PMob->status == xi::Status::Disappear)
    {
        PTrust->SetLocalVar("SQUAD_PULL_PHASE", 0);
        PTrust->SetLocalVar("SQUAD_PULL_TARGET", 0);
        co_return;
    }

    if (!PTrust->PAI->CanFollowPath() || PTrust->GetSpeed() == 0)
    {
        co_return;
    }

    if (PTrust->GetLocalVar("SQUAD_PULL_PHASE") == 1)
    {
        if (PMob->PAI->IsEngaged())
        {
            PTrust->SetLocalVar("SQUAD_PULL_PHASE", 2); // it is coming: back to camp
            PTrust->PAI->PathFind->Clear();
            co_return;
        }

        if (!PTrust->PAI->IsEngaged() || PTrust->GetBattleTarget() != PMob)
        {
            PTrust->PAI->Internal_Engage(EntityId(PMob));
        }

        const float away = distance(PTrust->loc.p, PMob->loc.p);

        // from range: a pull spell (casters) or a shot (a ranged weapon); it waits for it to land before running again
        if (PTrust->PAI->IsCurrentState<CMagicState>() || PTrust->PAI->IsCurrentState<CRangeState>())
        {
            co_return;
        }

        if (away <= CampPullShootRange && tick - m_CampPullTry > 4s)
        {
            if (const auto spell = campPullSpell(PTrust); spell && away <= CampPullCastRange)
            {
                PTrust->PAI->PathFind->Clear();
                m_CampPullTry = tick;
                Cast(EntityId(PMob), *spell);
                co_return;
            }

            if (hasRangedWeapon(PTrust))
            {
                PTrust->PAI->PathFind->Clear();
                m_CampPullTry = tick;
                RangedAttack(EntityId(PMob));
                co_return;
            }
        }

        if (away > 2.5f)
        {
            if (!PTrust->PAI->PathFind->IsFollowingPath() || tick - m_CampRepath > 1s)
            {
                m_CampRepath = tick;
                PTrust->PAI->PathFind->PathAround(PMob->loc.p, 2.0f, PATHFLAG_NONE); // (a player's pace: PATHFLAG_RUN is the mobs' x2.5 run)
            }

            PTrust->PAI->PathFind->FollowPath(tick);
        }

        // casters open from range with their own rules (Dia, Stone, Provoke, Flash...)
        if (away < CastingDistance && !PTrust->PAI->IsCurrentState<CMagicState>())
        {
            co_await m_GambitsContainer->Tick(tick);
        }

        co_return;
    }

    if (!PMob->PAI->IsEngaged())
    {
        PTrust->SetLocalVar("SQUAD_PULL_PHASE", 1); // (it lost interest: go get it again)
        co_return;
    }

    if (distance(PTrust->loc.p, camp) <= 3.0f)
    {
        PTrust->SetLocalVar("SQUAD_PULL_PHASE", 0); // back at camp with it: the fight is on
        PTrust->PAI->PathFind->Clear();
        co_return;
    }

    if (!PTrust->PAI->PathFind->IsFollowingPath() || tick - m_CampRepath > 2s)
    {
        m_CampRepath = tick;
        PTrust->PAI->PathFind->PathTo(camp, PATHFLAG_NONE); // (back at a player's pace, the monster on its heels)
    }

    PTrust->PAI->PathFind->FollowPath(tick);
    co_return;
}

void CTrustController::Declump(const CCharEntity* PMaster, const CBattleEntity* PTarget) const
{
    TracyZoneScoped;

    const uint8 currentPartyPos = GetPartyPosition();
    for (const auto* POtherTrust : PMaster->PTrusts)
    {
        if (POtherTrust == POwner || POtherTrust->PAI->PathFind->IsFollowingPath() || distance(POtherTrust->loc.p, POwner->loc.p) >= 1.5f)
        {
            continue;
        }

        // Sidestep relative to the shared target so trusts spread around the enemy rather than away from each other.
        const float moveAmount = xirand::GetRandomNumber(0.0f, 1.5f) * ((currentPartyPos % 2) ? 1.0f : -1.0f);
        const auto  newPos     = sidestepPosition(POwner->loc.p, PTarget->loc.p, moveAmount);

        if (POwner->PAI->PathFind->ValidPosition(newPos))
        {
            POwner->PAI->PathFind->PathTo(newPos, PATHFLAG_RUN);
        }
        break;
    }
}

void CTrustController::PathOutToDistance(const CBattleEntity* PTarget, const float amount)
{
    TracyZoneScoped;

    const float currentDistanceToTarget = distance(POwner->loc.p, PTarget->loc.p);
    position_t  target_position         = POwner->loc.p;

    if (GetTopEnmity() == POwner)
    {
        ++m_failedRepositionAttempts;
    }
    else
    {
        m_failedRepositionAttempts = 0;
    }

    // Invalidate position and pick new one (limit: every 3s)
    if ((currentDistanceToTarget < amount - 2.5f || currentDistanceToTarget > amount + 2.5f || !POwner->PAI->PathFind->ValidPosition(POwner->loc.p)) &&
        m_Tick - m_LastRepositionTime > 3s && !m_InTransit)
    {
        std::vector<position_t> positions(5);
        for (auto& position : positions)
        {
            const int        random_angle       = xirand::GetRandomNumber(256);
            const position_t potential_position = {
                PTarget->loc.p.x - (cosf(rotationToRadian(random_angle)) * amount),
                PTarget->loc.p.y,
                PTarget->loc.p.z + (sinf(rotationToRadian(random_angle)) * amount),
                0,
                0,
            };
            position = potential_position;
        }

        bool position_found = false;
        for (auto& potential_position : positions)
        {
            // Validate position
            if (!position_found &&
                POwner->PAI->PathFind->ValidPosition(potential_position) &&
                POwner->CanSeeTarget(potential_position))
            {
                position_found  = true;
                target_position = potential_position;
                m_InTransit     = true;
            }
        }

        m_LastRepositionTime = m_Tick;
    }

    // Get somewhat close to the target destination
    if (distance(POwner->loc.p, target_position) > 2.0f && m_failedRepositionAttempts < 3)
    {
        POwner->PAI->PathFind->PathTo(target_position, PATHFLAG_RUN);
    }
    else
    {
        FaceTarget(PTarget->entityId());
        m_InTransit = false;
    }
}

auto CTrustController::Ability(const EntityId target, uint16 abilityid) -> bool
{
    TracyZoneScoped;

    if (POwner->PRecastContainer->HasRecast(xi::RecastType::Ability, static_cast<xi::Recast>(abilityid), 0s))
    {
        return false;
    }

    if (POwner->PAI->CanChangeState())
    {
        return POwner->PAI->Internal_Ability(target, abilityid);
    }

    return false;
}

auto CTrustController::RangedAttack(const EntityId target) -> bool
{
    TracyZoneScoped;

    timer::duration rangedDelay = 10s;
    if (const CItemWeapon* PRange = dynamic_cast<CItemWeapon*>(POwner->m_Weapons[SLOT_RANGED]))
    {
        rangedDelay = std::chrono::milliseconds(PRange->getDelay());
    }

    if (m_Tick - m_LastRangedAttackTime > rangedDelay && !m_InTransit)
    {
        FaceTarget(target);
        if (POwner->PAI->CanChangeState() && POwner->PAI->Internal_RangedAttack(target))
        {
            m_LastRangedAttackTime = m_Tick;
        }
        return true;
    }
    return false;
}

auto CTrustController::Cast(const EntityId target, SpellID spellid) -> bool
{
    TracyZoneScoped;

    FaceTarget(target);

    if (POwner->PRecastContainer->Has(xi::RecastType::Magic, static_cast<xi::Recast>(spellid)))
    {
        return false;
    }

    auto* PSpell = spell::GetSpell(spellid);

    const auto castTarget = PSpell->getValidTarget() == xi::TargetType::Self ? EntityId(POwner) : target;

    const auto PTarget      = castTarget.resolve<CBattleEntity>();
    const auto PSpellFamily = PSpell->getSpellFamily();
    bool       canCast      = true;

    // clang-format off
    static_cast<CCharEntity*>(POwner->PMaster)->ForPartyWithTrusts(
        [&](const CBattleEntity* PMember)
    {
        if (PMember->objtype == TYPE_TRUST && PMember->PAI->IsCurrentState<CMagicState>())
        {
            const auto MState = static_cast<CMagicState*>(PMember->PAI->GetCurrentState());

            if (MState)
            {
                const auto MSpell       = MState->GetSpell();
                const auto MTarget      = MState->target().resolve();
                const auto MSpellFamily = MSpell->getSpellFamily();
                const auto MSpellID     = MSpell->getID();

                if (PSpell->isBuff())
                {
                    if (PSpellFamily == MSpellFamily && spellid <= MSpellID)
                    {
                        canCast = false;
                    }
                }
                if (PSpell->isCure())
                {
                    if (PTarget && PTarget == MTarget && PTarget->GetHPP() > 50)
                    {
                        canCast = false;
                    }
                }
                if (PSpell->isDebuff())
                {
                    if (PSpellFamily == MSpellFamily && spellid <= MSpellID)
                    {
                        canCast = false;
                    }
                }
                if (PSpell->isNa())
                {
                    if (PSpellFamily == MSpellFamily && spellid == MSpellID)
                    {
                        canCast = false;
                    }
                }
            }
        }
    });
    // clang-format on

    if (!canCast)
    {
        return false;
    }

    return CMobController::Cast(castTarget, spellid);
}

auto CTrustController::GetTopEnmity() const -> CBattleEntity*
{
    TracyZoneScoped;

    CBattleEntity* PEntity = nullptr;
    if (const auto* PMob = dynamic_cast<CMobEntity*>(POwner->PMaster->GetBattleTarget()))
    {
        return PMob->PEnmityContainer->GetHighestEnmity();
    }
    return PEntity;
}

auto CTrustController::GetPartyPosition() const -> uint8
{
    TracyZoneScoped;

    const auto& trustList = static_cast<CCharEntity*>(POwner->PMaster)->PTrusts;
    for (std::size_t i = 0; i < trustList.size(); ++i)
    {
        if (trustList.at(i)->id == POwner->id)
        {
            return static_cast<uint8>(i);
        }
    }
    return 0;
}
