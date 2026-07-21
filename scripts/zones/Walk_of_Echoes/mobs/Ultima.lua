-----------------------------------
-- Area: Walk of Echoes (Shattered Domain)
--  Mob: Proto-Ultima
-----------------------------------
---@type TMobEntity
local entity = {}

local citadelBusterTimers =
{
    [0] = 0,
    [1] = 8000,
    [2] = 8000,
    [3] = 4000,
    [4] = 3000,
    [5] = 3000,
    [6] = 2000,
    [7] = 2000,
    [8] = 1000,
}

local citadelMessages = {
    [1] = "Proto-Ultima is charging antimatter!",
    [2] = "Antimatter concentrations rising!",
    [3] = "10 seconds to discharge.",
    [4] = "Defensive barriers recommended!",
    [5] = "Energy signatures capping!",
    [6] = "3 seconds to discharge.",
    [7] = "2 seconds to discharge.",
    [8] = "1 second to discharge."
}

local function broadcastCitadelMessage(mob, state)
    local msg = citadelMessages[state + 1]
    if msg then
        local players = mob:getZone():getPlayers()
        for _, p in pairs(players) do
            p:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
        end
    end
end

local executeCitadelBusterState
executeCitadelBusterState = function(mob)
    if mob:isDead() then return end

    local state = mob:getLocalVar('citadelBusterState')

    if state < 8 then
        broadcastCitadelMessage(mob, state)
    elseif state == 8 then
        mob:useMobAbility(1540)
    else
        mob:setLocalVar('citadelBusterState', 0)
        mob:setMagicCastingEnabled(true)
        mob:setAutoAttackEnabled(true)
        mob:setMobAbilityEnabled(true)
        mob:setLocalVar('citadelBusterTime', os.time() + math.random(45, 60))
        return
    end

    state = state + 1
    mob:setLocalVar('citadelBusterState', state)
    mob:timer(citadelBusterTimers[state], function(mobArg)
        executeCitadelBusterState(mobArg)
    end)
end

entity.onMobSpawn = function(mob)
    mob:setMagicCastingEnabled(false)
    mob:setAutoAttackEnabled(true)
    mob:setMobAbilityEnabled(true)
    mob:setMobMod(xi.mobMod.SKILL_LIST, 729)
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)
    mob:setMod(xi.mod.ATTP, 25)
    mob:setMod(xi.mod.UDMGPHYS, -1500)
end

entity.onMobRoam = function(mob)
    mob:setMobMod(xi.mobMod.NO_MOVE, 0)
end

entity.onMobFight = function(mob, target)
    local now = os.time()

    if mob:getHPP() > 25 and target:checkDistance(mob) > 20 then
        utils.drawIn(target, { position = mob:getPos(), wait = 2 })
    end

    if xi.combat.behavior.isEntityBusy(mob) then return end

    local phase = mob:getLocalVar('phase')
    if mob:getHPP() < (5 - (phase + 1)) * 20 then
        mob:useMobAbility(1524)
        phase = phase + 1

        if phase == 1 then
            mob:setMobMod(xi.mobMod.SKILL_LIST, 1193)
        elseif phase == 2 then
            mob:setMobMod(xi.mobMod.SKILL_LIST, 1194)
            mob:timer(1000, function(mobArg)
                if mobArg:isAlive() then mobArg:setMagicCastingEnabled(true) end
            end)
        elseif phase == 3 then
            mob:setMobMod(xi.mobMod.SKILL_LIST, 1195)
        elseif phase == 4 then
            mob:setMobMod(xi.mobMod.SKILL_LIST, 1196)
            mob:setMod(xi.mod.REGAIN, 20)
            mob:setLocalVar('citadelBusterTime', now + 15)
        end

        mob:setLocalVar('phase', phase)
    elseif phase == 4 and now >= mob:getLocalVar('citadelBusterTime') and mob:getLocalVar('citadelBusterState') == 0 then
        mob:setMobAbilityEnabled(false)
        mob:setMagicCastingEnabled(false)
        mob:setAutoAttackEnabled(false)
        
        utils.drawIn(target, { position = mob:getPos() })
        executeCitadelBusterState(mob)
    end
end

entity.onMobWeaponSkill = function(target, mob, skill)
    if skill:getID() == 1268 then
        mob:timer(4000, function(mobArg)
            if mobArg:isAlive() then
                local ability = math.random(1262, 1267)
                mobArg:useMobAbility(ability)
            end
        end)
    end
end

entity.onMobDeath = function(mob, player, optParams)
    if player then player:addTitle(xi.title.TEMENOS_LIBERATOR) end
end

return entity