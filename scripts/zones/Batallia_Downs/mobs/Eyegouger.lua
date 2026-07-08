-----------------------------------
-- Area: Batallia Downs
--   NM: Eyegouger
-----------------------------------
local ID = zones[xi.zone.BATALLIA_DOWNS]
-----------------------------------
---@type TMobEntity
local entity = {}

entity.spawnPoints =
{
    { x =  177.300, y = -2.100, z = -54.540 }
}

-- ── 🛡️ DEFENSIVE ID BOUND CHECK ──
local eyegougerId = (ID and ID.mob) and ID.mob.EYEGOUGER or nil -- Fixed spelling typo

if eyegougerId then
    entity.phList =
    {
        [eyegougerId - 9] = eyegougerId -- Confirmed on retail
    }
else
    print("[NMHunt Warning] EYEGOUGER ID is missing or misspelled in Batallia Downs IDs.lua!")
end

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
end

entity.onAdditionalEffect = function(mob, target, damage)
    local pTable =
    {
        chance   = 25,
        effectId = xi.effect.BLINDNESS,
        power    = 20,
        duration = 60,
    }

    return xi.combat.action.executeAddEffectEnfeeblement(mob, target, pTable)
end

entity.onMobDeath = function(mob, player, optParams)
    xi.hunts.checkHunt(mob, player, 163)
end

return entity