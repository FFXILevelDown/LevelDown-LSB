-----------------------------------
-- xi.effect.IMPETUS
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    target:addListener('MELEE_SWING_HIT', 'IMPETUS_HIT', function(actorArg, targetArg, attack)
        local effectArg = actorArg:getStatusEffect(xi.effect.IMPETUS)
        if not effectArg then
            return
        end

        local mainPower = effectArg:getPower()
        if mainPower >= 50 then
            return
        end

        mainPower = mainPower + 1
        effectArg:setPower(mainPower)

        -- Apply stack bonuses directly to the entity (actorArg)
        actorArg:addMod(xi.mod.ATT, 2)
        actorArg:addMod(xi.mod.CRITHITRATE, 1)

        local subPower = effectArg:getSubPower()
        if subPower ~= 0 then
            actorArg:addMod(xi.mod.ACC, 2)
            actorArg:addMod(xi.mod.CRIT_DMG_INCREASE, math.floor(subPower / 2))
        end
    end)

    target:addListener('MELEE_SWING_MISS', 'IMPETUS_MISS', function(actorArg, targetArg, attack)
        local effectArg = actorArg:getStatusEffect(xi.effect.IMPETUS)
        if not effectArg then
            return
        end

        local power = effectArg:getPower()
        if power == 0 then
            return
        end

        effectArg:setPower(0)

        -- Remove accumulated stack bonuses directly from the entity (actorArg)
        actorArg:delMod(xi.mod.ATT, 2 * power)
        actorArg:delMod(xi.mod.CRITHITRATE, power)

        local subPower = effectArg:getSubPower()
        if subPower ~= 0 then
            actorArg:delMod(xi.mod.ACC, 2 * power)
            actorArg:delMod(xi.mod.CRIT_DMG_INCREASE, math.floor(subPower / 2) * power)
        end
    end)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:removeListener('IMPETUS_MISS')
    target:removeListener('IMPETUS_HIT')

    -- Clean up any remaining stack modifiers from target if buff wears off with stacks active
    local power = effect:getPower()
    if power > 0 then
        target:delMod(xi.mod.ATT, 2 * power)
        target:delMod(xi.mod.CRITHITRATE, power)

        local subPower = effect:getSubPower()
        if subPower ~= 0 then
            target:delMod(xi.mod.ACC, 2 * power)
            target:delMod(xi.mod.CRIT_DMG_INCREASE, math.floor(subPower / 2) * power)
        end
    end
end

return effectObject