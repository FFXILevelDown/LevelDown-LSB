xi = xi or {}
xi.custom_mastery = xi.custom_mastery or {}

-- =========================================================================
-- MASTERY BASELINE CONFIGURATION
-- =========================================================================
local HP_PER_TIER       = 100  -- +100 HP per tier (+500 max at Tier V)
local MP_PER_TIER       = 100  -- +100 MP per tier (+500 max at Tier V)
local CP_BONUS_PER_TIER = 120  -- +120% Capacity Bonus per tier (+600% max at Tier V)

-- Base offset for each job's 10 retail JP categories (from scripts/enum/job_points.lua)
local jobCategoryBase = {
    [1]  = 0x020, -- WAR
    [2]  = 0x040, -- MNK
    [3]  = 0x060, -- WHM
    [4]  = 0x080, -- BLM
    [5]  = 0x0A0, -- RDM
    [6]  = 0x0C0, -- THF
    [7]  = 0x0E0, -- PLD
    [8]  = 0x100, -- DRK
    [9]  = 0x120, -- BST
    [10] = 0x140, -- BRD
    [11] = 0x160, -- RNG
    [12] = 0x180, -- SAM
    [13] = 0x1A0, -- NIN
    [14] = 0x1C0, -- DRG
    [15] = 0x1E0, -- SMN
    [16] = 0x200, -- BLU
    [17] = 0x220, -- COR
    [18] = 0x240, -- PUP
    [19] = 0x260, -- DNC
    [20] = 0x280, -- SCH
    [21] = 0x2A0, -- GEO
    [22] = 0x2C0, -- RUN
}

local jpThresholds = { 420, 840, 1260, 1680, 2100 }

-- Helper function to set or clear all 10 retail JP categories for a job
local function applyRetailJpCategories(player, mjob, targetRank)
    local baseID = jobCategoryBase[mjob]
    if not baseID then return end

    -- Set all 10 category offsets (0x00 through 0x09) to the target rank
    for offset = 0, 9 do
        local catID = baseID + offset
        player:setJobPointLevel(catID, targetRank)
    end
end

xi.custom_mastery.onRefreshGiftMods = function(player, totalJpSpent)
    local jobShortNames = {
        [1] = "WAR", [2] = "MNK", [3] = "WHM", [4] = "BLM", [5] = "RDM",
        [6] = "THF", [7] = "PLD", [8] = "DRK", [9] = "BST", [10] = "BRD",
        [11] = "RNG", [12] = "SAM", [13] = "NIN", [14] = "DRG", [15] = "SMN",
        [16] = "BLU", [17] = "COR", [18] = "PUP", [19] = "DNC", [20] = "SCH",
        [21] = "GEO", [22] = "RUN"
    }

    local mjob = player:getMainJob()
    local jobName = jobShortNames[mjob]
    if not jobName then return end

    local mainLvl = player:getMainLvl()

    -- HARD BLOCK: Level 99s get no custom 75 mastery mods/categories
    if mainLvl > 75 then
        local prevTier = player:getLocalVar("[CQ]APPLIED_TIER") or 0
        if prevTier > 0 then
            -- Strip baseline mods
            player:delMod(xi.mod.HP,             prevTier * HP_PER_TIER)
            player:delMod(xi.mod.MP,             prevTier * MP_PER_TIER)
            player:delMod(xi.mod.CAPACITY_BONUS, prevTier * CP_BONUS_PER_TIER)

            -- Clear retail category ranks
            applyRetailJpCategories(player, mjob, 0)
            player:setLocalVar("[CQ]APPLIED_TIER", 0)
        end
        return
    end

    totalJpSpent = totalJpSpent or 0

    -- Calculate Tiers 1-5 every 420 JP
    local activeTier = math.min(5, math.floor(totalJpSpent / 420))

    -- CLEANUP PASS: Strip previously applied tier stats
    local prevTier = player:getLocalVar("[CQ]APPLIED_TIER") or 0
    if prevTier > 0 and prevTier <= 5 then
        player:delMod(xi.mod.HP,             prevTier * HP_PER_TIER)
        player:delMod(xi.mod.MP,             prevTier * MP_PER_TIER)
        player:delMod(xi.mod.CAPACITY_BONUS, prevTier * CP_BONUS_PER_TIER)
    end

    -- APPLY NEW TIER REWARDS (For Level <= 75)
    if activeTier > 0 and activeTier <= 5 then
        player:setLocalVar("[CQ]APPLIED_TIER", activeTier)

        -- 1. Apply Baseline HP, MP, and Capacity Bonus Modifiers
        player:addMod(xi.mod.HP,             activeTier * HP_PER_TIER)
        player:addMod(xi.mod.MP,             activeTier * MP_PER_TIER)
        player:addMod(xi.mod.CAPACITY_BONUS, activeTier * CP_BONUS_PER_TIER)

        -- 2. Automatically grant Stock Retail Category Ranks (4 Ranks per Tier)
        local targetRank = activeTier * 4
        applyRetailJpCategories(player, mjob, targetRank)

        -- VISUAL & CHAT NOTIFICATION PASS
        local lastNotified = player:getCharVar("[CQ]NOTIFIED_TIER_" .. jobName) or 0
        if activeTier > lastNotified then
            player:setCharVar("[CQ]NOTIFIED_TIER_" .. jobName, activeTier)

            player:showAnimation(171)

            local currentCpBonus = activeTier * CP_BONUS_PER_TIER
            if activeTier < 5 then
                local nextReq = jpThresholds[activeTier + 1]
                local remaining = nextReq - totalJpSpent
                player:printToPlayer(string.format("[Mastery] Tier %d Unlocked for %s! (+%d%% CP Bonus). Spend %d more JP for Tier %d.", activeTier, jobName, currentCpBonus, remaining, activeTier + 1), 29)
            else
                player:printToPlayer(string.format("[Mastery] ★ JOB MASTER ★ You have fully mastered %s at Level 75! (+%d%% CP Bonus & 20/20 Categories)!", jobName, currentCpBonus), 30)
            end
        end
    else
        -- 0 JP spent: Ensure category ranks are cleared
        applyRetailJpCategories(player, mjob, 0)
        player:setLocalVar("[CQ]APPLIED_TIER", 0)
    end
end