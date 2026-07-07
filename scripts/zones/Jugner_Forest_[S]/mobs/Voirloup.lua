-----------------------------------
-- Area: Jugner Forest [S]
--  NM: Voirloup
-----------------------------------
local ID = zones[xi.zone.JUGNER_FOREST_S]
-----------------------------------
---@type TMobEntity
local entity = {}

-- ── 🛡️ DEFENSIVE ID BOUND CHECK ──
local voirloupId = (ID and ID.mob) and ID.mob.VOIRLOUP or nil

if voirloupId then
    entity.phList =
    {
        [voirloupId - 1] = voirloupId
    }
else
    -- Server will boot up fine and print this clean alarm instead of dropping to desktop
    print("[NMHunt Warning] Voirloup ID is missing or undefined in Jugner Forest [S] IDs.lua!")
end

-- TODO: has enstun, but rate is extremely low on testing characters so cannot give a great rate.
entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.BIND)
    mob:addImmunity(xi.immunity.STUN)
    mob:addImmunity(xi.immunity.GRAVITY)
    mob:addImmunity(xi.immunity.TERROR)
    mob:addImmunity(xi.immunity.PLAGUE)
end

-- TODO: check regain, store tp, MAB (nox blast?), MDB, PDT/MDT/DT
-- Doesn't seem to have a base damage multiplier?
entity.onMobSpawn = function(mob)
    -- Ballparked, before AGI/DEX.
    -- This needs double checking, but they were pretty high.
    mob:setMod(xi.mod.ACC, 590)
    mob:setMod(xi.mod.EVA, 590)
    mob:setMod(xi.mod.KICK_ATTACK_RATE, 5)               -- 5% KA
end

entity.onMobDeath = function(mob, player, optParams)
    xi.hunts.checkHunt(mob, player, 486)
end

entity.onMobMobskillChoose = function(mob, target, skillId)
    return xi.mobSkill.NOX_BLAST
end

return entity
