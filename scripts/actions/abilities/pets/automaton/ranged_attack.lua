-----------------------------------
-- Ranged Attack
-- Family: Automaton
-- Description: Deals a ranged attack to a single target.
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    return 0
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    local params = {}

    params.baseDamage       = xi.automaton.getRangedBaseDamage(automaton)
    params.numHits          = 1
    params.fTP               = { 1.0, 1.0, 1.0 }
    params.str_wSC          = 0.50
    params.dex_wSC          = 0.25
    params.attackType       = xi.attackType.RANGED
    params.damageType       = xi.damageType.PIERCING
    params.shadowBehavior   = xi.mobskills.shadowBehavior.NUMSHADOWS_1
    params.skipParry        = true
    params.skipGuard        = true
    params.skipBlock        = true

    -- Check for Repeater.
    local doubleShotRate = automaton:getMod(xi.mod.DOUBLE_SHOT_RATE)
    if
        doubleShotRate > 0 and
        math.randomInt(1, 100) <= doubleShotRate
    then
        -- For players these shots are separate, like double attack, but for automatons, they are added together.
        params.numHits = 2
        params.shadowBehavior = xi.mobskills.shadowBehavior.NUMSHADOWS_2
    end

    -- Ensure resolveMissMessage exists in mobskills globally before calling mobRangedMove
    if xi.mobskills and xi.mobskills.resolveMissMessage == nil then
        xi.mobskills.resolveMissMessage = function(mob, targetObj, skillObj, actionObj, hitmatrix)
            if hitmatrix == xi.mobskills.shadowBehavior.SHADOW_ABSORB then
                return xi.msg.basic.SHADOW_ABSORB
            end
            return xi.msg.basic.SKILL_MISS
        end
    end

    local info = xi.mobskills.mobRangedMove(automaton, target, skill, action, params)

    if xi.mobskills.processDamage(automaton, target, skill, action, info) then
        target:takeDamage(info.damage, automaton, info.attackType, info.damageType)
    end

    return info.damage
end

return abilityObject