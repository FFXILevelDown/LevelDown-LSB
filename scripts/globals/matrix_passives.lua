-----------------------------------
-- Global Matrix Passives System
-- Replaces !buff command entirely
-----------------------------------
xi = xi or {}
xi.matrixPassives = xi.matrixPassives or {}

local clearPassives = function(player)
    -- Reset all custom modifiers
    player:setMod(xi.mod.EXP_BONUS, 0)
    player:setMod(xi.mod.CAPACITY_BONUS, 0)
    player:setMod(xi.mod.ACC, 0)
    player:setMod(xi.mod.ATT, 0)
    player:setMod(xi.mod.RACC, 0)
    player:setMod(xi.mod.RATT, 0)
    player:setMod(xi.mod.MATT, 0)
    player:setMod(xi.mod.MACC, 0)
    player:setMod(xi.mod.DEF, 0)
    player:setMod(xi.mod.MDEF, 0)
    player:setMod(xi.mod.RDEF, 0)

    -- Remove status effects and visual icons
    player:delStatusEffect(xi.effect.REGAIN)
    player:delStatusEffect(xi.effect.REFRESH)
    player:delStatusEffect(xi.effect.REGEN)
    player:delStatusEffect(xi.effect.DEDICATION)
    player:delStatusEffect(xi.effect.COMMITMENT)
end

xi.matrixPassives.update = function(player)
    -- LOCKOUT 1: Traditionalists (Ratio == 1)
    if player:getCharVar("Ratio") == 1 then
        clearPassives(player)
        return
    end

    -- LOCKOUT 2: Battlefield Instancing
    if player:hasStatusEffect(xi.effect.BATTLEFIELD) then
        clearPassives(player)
        return
    end

    local mainLvl = player:getMainLvl()

    -- Full Baseline Powers
    local power        = 50
    local regainPower  = 25
    local refreshPower = 10
    local regenPower   = 10
    local expPower     = 500

    -----------------------------------
    -- LEVEL 99 ENDGAME CAP MODE
    -----------------------------------
    if mainLvl == 99 then
        player:setMod(xi.mod.CAPACITY_BONUS, 200)
        player:setMod(xi.mod.EXP_BONUS, expPower)

        -- Clear combat stats & regens for L99 Cap Mode
        player:setMod(xi.mod.ACC, 0)
        player:setMod(xi.mod.ATT, 0)
        player:setMod(xi.mod.RACC, 0)
        player:setMod(xi.mod.RATT, 0)
        player:setMod(xi.mod.MATT, 0)
        player:setMod(xi.mod.MACC, 0)
        player:setMod(xi.mod.DEF, 0)
        player:setMod(xi.mod.MDEF, 0)
        player:setMod(xi.mod.RDEF, 0)

        player:delStatusEffect(xi.effect.REGAIN)
        player:delStatusEffect(xi.effect.REFRESH)
        player:delStatusEffect(xi.effect.REGEN)
        player:delStatusEffect(xi.effect.DEDICATION)

        if not player:hasStatusEffect(xi.effect.COMMITMENT) then
            xi.itemUtils.addItemExpEffect(player, xi.effect.COMMITMENT, 200, 43200, 30000)
        end

    -----------------------------------
    -- LEVEL 75 MODE (COMBAT BUFFS + CP)
    -----------------------------------
    elseif mainLvl == 75 then
        player:setMod(xi.mod.CAPACITY_BONUS, 200)
        player:setMod(xi.mod.EXP_BONUS, expPower)

        -- Apply Full Combat Stats
        player:setMod(xi.mod.ACC, power)
        player:setMod(xi.mod.ATT, power)
        player:setMod(xi.mod.RACC, power)
        player:setMod(xi.mod.RATT, power)
        player:setMod(xi.mod.MATT, power)
        player:setMod(xi.mod.MACC, power)
        player:setMod(xi.mod.DEF, power)
        player:setMod(xi.mod.MDEF, power)
        player:setMod(xi.mod.RDEF, power)

        player:delStatusEffect(xi.effect.DEDICATION)

        -- Apply Regeneratives
        if not player:hasStatusEffect(xi.effect.REGAIN) then
            player:addStatusEffect(xi.effect.REGAIN, { power = regainPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.REFRESH) then
            player:addStatusEffect(xi.effect.REFRESH, { power = refreshPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.REGEN) then
            player:addStatusEffect(xi.effect.REGEN, { power = regenPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.COMMITMENT) then
            xi.itemUtils.addItemExpEffect(player, xi.effect.COMMITMENT, 200, 43200, 30000)
        end

    -----------------------------------
    -- LEVELING MODE (1–74, 76–98)
    -----------------------------------
    else
        player:setMod(xi.mod.EXP_BONUS, expPower)
        player:setMod(xi.mod.CAPACITY_BONUS, 0)

        -- Apply Full Combat Stats
        player:setMod(xi.mod.ACC, power)
        player:setMod(xi.mod.ATT, power)
        player:setMod(xi.mod.RACC, power)
        player:setMod(xi.mod.RATT, power)
        player:setMod(xi.mod.MATT, power)
        player:setMod(xi.mod.MACC, power)
        player:setMod(xi.mod.DEF, power)
        player:setMod(xi.mod.MDEF, power)
        player:setMod(xi.mod.RDEF, power)

        player:delStatusEffect(xi.effect.COMMITMENT)

        -- Apply Regeneratives
        if not player:hasStatusEffect(xi.effect.REGAIN) then
            player:addStatusEffect(xi.effect.REGAIN, { power = regainPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.REFRESH) then
            player:addStatusEffect(xi.effect.REFRESH, { power = refreshPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.REGEN) then
            player:addStatusEffect(xi.effect.REGEN, { power = regenPower, duration = 0, origin = player })
        end

        if not player:hasStatusEffect(xi.effect.DEDICATION) then
            xi.itemUtils.addItemExpEffect(player, xi.effect.DEDICATION, expPower, 43200, 30000)
        end
    end
end