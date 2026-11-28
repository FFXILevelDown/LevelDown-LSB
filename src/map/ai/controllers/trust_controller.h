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

#pragma once

#include "common/macros.h"
#include <memory>

#include "mob_controller.h"

class CCharEntity;
class CTrustEntity;

namespace gambits
{

class CGambitsContainer;

}

class CTrustController : public CMobController
{
public:
    CTrustController(CCharEntity*, CTrustEntity*);
    ~CTrustController() override;

    DISALLOW_COPY_AND_MOVE(CTrustController);

    auto Tick(timer::time_point) -> Task<void> override;
    void Despawn() override;
    auto Ability(EntityId target, uint16 abilityid) -> bool override;
/* LD AI PLAYERS TRUST CONTROLLER */
    auto Cast(EntityId target, SpellID spellid) -> bool override;
    auto RangedAttack(EntityId target) -> bool override;

    // 1.5: melee trusts used to path around at 3.0 yalms from the mob's centre and
    // then stop there, which is outside real hit range on anything larger than a
    // small mob - the swings simply missed. 1.5 keeps them inside attack range.
    static constexpr float RoamDistance    = { 1.5f };
    static constexpr float SpawnDistance   = { 3.0f };
    static constexpr float CastingDistance = { 15.0f };
    static constexpr float WarpDistance    = { 30.0f };

    auto GetTopEnmity() const -> CBattleEntity*;
    auto GetPartyPosition() const -> uint8;

    std::unique_ptr<gambits::CGambitsContainer> m_GambitsContainer;

protected:
    auto DoCombatTick(timer::time_point tick) -> Task<void> override;
    auto DoRoamTick(timer::time_point tick) -> Task<void> override;

private:
    auto DoNonCombatTick(timer::time_point tick) -> Task<void>;
    auto DoCampPullTick(timer::time_point tick, const position_t& camp) -> Task<void>; // FFXI Offline squad camp
    void CampHold(const position_t& camp);
    void Declump(const CCharEntity* PMaster, const CBattleEntity* PTarget) const;
    void PathOutToDistance(const CBattleEntity* PTarget, float amount);

    timer::time_point m_LastRepositionTime;
    uint8             m_failedRepositionAttempts;
    bool              m_InTransit;

    timer::time_point                 m_CombatEndTime;
    timer::time_point                 m_LastHealTickTime;
    std::vector<std::chrono::seconds> m_tickDelays      = { 15s, 10s, 10s, 3s };
    std::size_t                       m_NumHealingTicks = { 0 };

    timer::time_point m_LastRangedAttackTime;
    timer::time_point m_CampRepath; // FFXI Offline squad camp: last re-path towards the camp spot or the pull target
    timer::time_point m_CampPullTry; // FFXI Offline squad camp: the puller's last pull spell or ranged shot
};
