-----------------------------------
-- Area: Walk of Echoes (Shattered Domain)
--  Mob: Proto-Omega
-----------------------------------
---@type TMobEntity
local entity = {}

local quadrupedForm = function(mob)
    mob:setAnimationSub(1)
    mob:setMod(xi.mod.ATTP, 20)          -- Fast Farm: Balanced +20% Attack
    mob:setMod(xi.mod.UDMGPHYS, -2000)   -- Fast Farm: Only 20% Physical Shield
    mob:setMod(xi.mod.UDMGRANGE, -2000)  
    mob:setMod(xi.mod.UDMGMAGIC, -1000)  -- Fast Farm: Only 10% Magic Shield
    mob:setMobMod(xi.mobMod.SKILL_LIST, 727)
end

local bipedForm = function(mob)
    mob:setAnimationSub(2)
    mob:setMod(xi.mod.ATTP, 40)          -- Fast Farm: Balanced +40% Attack
    mob:setMod(xi.mod.UDMGPHYS, -1000)   
    mob:setMod(xi.mod.UDMGRANGE, -1000)  
    mob:setMod(xi.mod.UDMGMAGIC, -2000)  
    mob:setMobMod(xi.mobMod.SKILL_LIST, 1188)
end

local finalForm = function(mob)
    mob:setLocalVar('final', 1)
    mob:setAnimationSub(2)
    mob:setMod(xi.mod.ATTP, 50)          -- Fast Farm: Max +50% Attack
    mob:setMod(xi.mod.UDMGPHYS, -2500)   -- Fast Farm: Max 25% Physical Shield
    mob:setMod(xi.mod.UDMGRANGE, -2500)  
    mob:setMod(xi.mod.UDMGMAGIC, -2500)  
    mob:setMod(xi.mod.REGAIN, 25)        -- Fast Farm: Slower TP generation
    mob:setMobMod(xi.mobMod.SKILL_LIST, 1189)
end

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.ADD_EFFECT, 1)
    mob:setMobMod(xi.mobMod.SOUND_RANGE, 25)
    mob:addImmunity(xi.immunity.GRAVITY)
    mob:addImmunity(xi.immunity.BIND)
    mob:addImmunity(xi.immunity.SILENCE)
    mob:addImmunity(xi.immunity.BLIND)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.TERROR)
end

entity.onMobSpawn = function(mob)
    mob:setMobMod(xi.mobMod.CANNOT_GUARD, 1)
    mob:setMod(xi.mod.COUNTER, 10)
    mob:setMod(xi.mod.REGAIN, 30)        
    mob:setMod(xi.mod.REGEN, 15)         
    mob:setBehavior(bit.bor(mob:getBehavior(), xi.behavior.NO_TURN))
    mob:setBaseSpeed(60)
    quadrupedForm(mob)
end

entity.onMobEngage = function(mob, target)
    mob:setLocalVar('formTime', os.time() + 120)
end

entity.onMobFight = function(mob, target)
    local now = os.time()

    if mob:getLocalVar('final') == 1 then
        if now >= mob:getLocalVar('gunpodTime') and mob:getCurrentAction() == xi.action.category.BASIC_ATTACK then
            mob:setLocalVar('gunpodTime', now + 180)
            mob:useMobAbility(1532)
        end
        return
    end

    if mob:getHPP() <= 25 then
        finalForm(mob)
        return
    end

    local form = mob:getLocalVar('formTime')
    if now >= form and mob:getCurrentAction() == xi.action.category.BASIC_ATTACK then
        mob:setLocalVar('formTime', now + 90)
        if mob:getAnimationSub() == 1 then
            bipedForm(mob)
            mob:wait(4500)
            mob:timer(4500, function(mobArg)
                if mob:isAlive() and mob:getLocalVar('initialGunpod') == 0 then
                    mob:setLocalVar('initialGunpod', 1)
                    mob:useMobAbility(1532)
                end
            end)
        else
            quadrupedForm(mob)
            mob:wait(4500)
        end
    end
end

entity.onAdditionalEffect = function(mob, target, damage)
    return xi.mob.onAddEffect(mob, target, damage, xi.mob.ae.STUN)
end

entity.onMobDeath = function(mob, player, optParams)
    if player then player:addTitle(xi.title.APOLLYON_RAVAGER) end
end

return entity