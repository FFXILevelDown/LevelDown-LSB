-----------------------------------
-- Global Matrix Passives System
-- 100% Mod-Based (No Status Icons / No Expirations)
-----------------------------------
xi = xi or {}
xi.matrixPassives = xi.matrixPassives or {}

-- Safe modifier helper using addMod and delMod
local applyMod = function(player, modId, targetVal)
    local varName    = "MatrixMod_" .. tostring(modId)
    local currentVal = player:getLocalVar(varName)

    if currentVal ~= targetVal then
        if currentVal ~= 0 then
            player:delMod(modId, currentVal)
        end
        if targetVal ~= 0 then
            player:addMod(modId, targetVal)
        end
        player:setLocalVar(varName, targetVal)
    end
end

local clearPassives = function(player)
    -- Remove all custom matrix modifiers cleanly via delMod
    applyMod(player, xi.mod.EXP_BONUS, 0)
    applyMod(player, xi.mod.CAPACITY_BONUS, 0)
    applyMod(player, xi.mod.ACC, 0)
    applyMod(player, xi.mod.ATT, 0)
    applyMod(player, xi.mod.RACC, 0)
    applyMod(player, xi.mod.RATT, 0)
    applyMod(player, xi.mod.MATT, 0)
    applyMod(player, xi.mod.MACC, 0)
    applyMod(player, xi.mod.DEF, 0)
    applyMod(player, xi.mod.MDEF, 0)
    applyMod(player, xi.mod.RDEF, 0)
    applyMod(player, xi.mod.REGEN, 0)
    applyMod(player, xi.mod.REFRESH, 0)
    applyMod(player, xi.mod.REGAIN, 0)

    player:recalculateStats()
end

xi.matrixPassives.update = function(player)
    if not player or not player:isPC() then return end

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
    local cpPower      = 200

    -----------------------------------
    -- LEVEL 99 ENDGAME CAP MODE
    -----------------------------------
    if mainLvl == 99 then
        applyMod(player, xi.mod.CAPACITY_BONUS, cpPower)
        applyMod(player, xi.mod.EXP_BONUS, 0)

        -- Clear combat stats & regens for L99 Cap Mode
        applyMod(player, xi.mod.ACC, 0)
        applyMod(player, xi.mod.ATT, 0)
        applyMod(player, xi.mod.RACC, 0)
        applyMod(player, xi.mod.RATT, 0)
        applyMod(player, xi.mod.MATT, 0)
        applyMod(player, xi.mod.MACC, 0)
        applyMod(player, xi.mod.DEF, 0)
        applyMod(player, xi.mod.MDEF, 0)
        applyMod(player, xi.mod.RDEF, 0)
        applyMod(player, xi.mod.REGEN, 0)
        applyMod(player, xi.mod.REFRESH, 0)
        applyMod(player, xi.mod.REGAIN, 0)

    -----------------------------------
    -- LEVEL 75 MODE (COMBAT BUFFS + CP)
    -----------------------------------
    elseif mainLvl == 75 then
        applyMod(player, xi.mod.CAPACITY_BONUS, cpPower)
        applyMod(player, xi.mod.EXP_BONUS, expPower)

        -- Apply Combat Stats & Regens via Raw Modifiers
        applyMod(player, xi.mod.ACC, power)
        applyMod(player, xi.mod.ATT, power)
        applyMod(player, xi.mod.RACC, power)
        applyMod(player, xi.mod.RATT, power)
        applyMod(player, xi.mod.MATT, power)
        applyMod(player, xi.mod.MACC, power)
        applyMod(player, xi.mod.DEF, power)
        applyMod(player, xi.mod.MDEF, power)
        applyMod(player, xi.mod.RDEF, power)
        applyMod(player, xi.mod.REGEN, regenPower)
        applyMod(player, xi.mod.REFRESH, refreshPower)
        applyMod(player, xi.mod.REGAIN, regainPower)

    -----------------------------------
    -- LEVELING MODE (1–74, 76–98)
    -----------------------------------
    else
        applyMod(player, xi.mod.EXP_BONUS, expPower)
        applyMod(player, xi.mod.CAPACITY_BONUS, 0)

        -- Apply Combat Stats & Regens via Raw Modifiers
        applyMod(player, xi.mod.ACC, power)
        applyMod(player, xi.mod.ATT, power)
        applyMod(player, xi.mod.RACC, power)
        applyMod(player, xi.mod.RATT, power)
        applyMod(player, xi.mod.MATT, power)
        applyMod(player, xi.mod.MACC, power)
        applyMod(player, xi.mod.DEF, power)
        applyMod(player, xi.mod.MDEF, power)
        applyMod(player, xi.mod.RDEF, power)
        applyMod(player, xi.mod.REGEN, regenPower)
        applyMod(player, xi.mod.REFRESH, refreshPower)
        applyMod(player, xi.mod.REGAIN, regainPower)
    end

    player:recalculateStats()
end