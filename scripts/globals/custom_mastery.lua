xi = xi or {}
xi.custom_mastery = xi.custom_mastery or {}

-- ==========================================================
-- PER-JOB CUSTOM MODIFIER MATRIX
-- ==========================================================
-- Each entry defines a unique function that applies stats.
-- "tier" scales dynamically from 1 to 5 based on quest progress.
local jobBonusMatrix = {
    [1]  = function(player, tier) -- WARRIOR
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.DOUBLE_ATTACK, tier * 1)    -- Tier 5: +5% Double Attack
        player:addMod(xi.mod.WAR_CRY_DURATION, tier * 3) -- Tier 5: +15s Warcry
    end,
    [2]  = function(player, tier) -- MONK
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.COUNTER, tier * 1)          -- Tier 5: +5% Counter Rate
        player:addMod(xi.mod.KICK_ATTACK_RATE, tier * 2) -- Tier 5: +10% Kick Attacks
    end,
    [3]  = function(player, tier) -- WHITE MAGE
        player:addMod(xi.mod.MND, tier * 2)
        player:addMod(xi.mod.CURE_POTENCY, tier * 2)     -- Tier 5: +10% Cure Potency
        player:addMod(xi.mod.ENMITY, tier * -1)          -- Tier 5: -5 Enmity
    end,
    [4]  = function(player, tier) -- BLACK MAGE
        player:addMod(xi.mod.INT, tier * 2)
        player:addMod(xi.mod.MAGIC_DAMAGE, tier * 5)     -- Tier 5: +25 Magic Damage
        player:addMod(xi.mod.ELEMENTAL_BURST_DMG, tier * 2) -- Tier 5: +10% Magic Burst
    end,
    [5]  = function(player, tier) -- RED MAGE
        player:addMod(xi.mod.INT, tier * 1)
        player:addMod(xi.mod.MND, tier * 1)
        player:addMod(xi.mod.FAST_CAST, tier * 2)        -- Tier 5: +10% Fast Cast
        player:addMod(xi.mod.ENSPELL_DMG, tier * 3)      -- Tier 5: +15 Enspell Damage
    end,
    [6]  = function(player, tier) -- THIEF
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.TRIPLE_ATTACK, tier * 1)    -- Tier 5: +5% Triple Attack
        player:addMod(xi.mod.STEAL, tier * 2)            -- Tier 5: +10 Steal Success
    end,
    [7]  = function(player, tier) -- PALADIN
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.DEF, tier * 4)              -- Tier 5: +20 Defense
        player:addMod(xi.mod.SHIELD_BLOCK_RATE, tier * 1) -- Tier 5: +5% Block Rate
        player:addMod(xi.mod.ENMITY, tier * 2)           -- Tier 5: +10 Enmity
    end,
    [8]  = function(player, tier) -- DARK MAGE
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.ATT, tier * 5)              -- Tier 5: +25 Attack
        player:addMod(xi.mod.WEAPON_SKILL_DAMAGE, tier * 1) -- Tier 5: +5% WSD
    end,
    [9]  = function(player, tier) -- BEASTMASTER
        player:addMod(xi.mod.CHR, tier * 2)
        player:addMod(xi.mod.PET_ACC, tier * 3)          -- Tier 5: +15 Pet Accuracy
        player:addMod(xi.mod.PET_ATT, tier * 3)          -- Tier 5: +15 Pet Attack
    end,
    [10] = function(player, tier) -- BARD
        player:addMod(xi.mod.CHR, tier * 2)
        player:addMod(xi.mod.SONG_DURATION_BONUS, tier * 2) -- Tier 5: +10% Song Duration
        player:addMod(xi.mod.ENMITY, tier * -1)          -- Tier 5: -5 Enmity
    end,
    [11] = function(player, tier) -- RANGER
        player:addMod(xi.mod.AGI, tier * 2)
        player:addMod(xi.mod.RACC, tier * 4)             -- Tier 5: +20 Ranged Accuracy
        player:addMod(xi.mod.RATT, tier * 4)             -- Tier 5: +20 Ranged Attack
    end,
    [12] = function(player, tier) -- SAMURAI
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.STORE_TP, tier * 2)         -- Tier 5: +10 Store TP
        player:addMod(xi.mod.MEDITATE_DURATION, tier * 2) -- Tier 5: +10s Meditate
    end,
    [13] = function(player, tier) -- NINJA
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.DUAL_WIELD, tier * -1)      -- Tier 5: -5% Dual Wield Delay
        player:addMod(xi.mod.SUBTLE_BLOW, tier * 2)      -- Tier 5: +10 Subtle Blow
    end,
    [14] = function(player, tier) -- DRAGOON
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.HASTE_ABILITY, tier * 100)  -- Tier 5: +5% JA Haste
        player:addMod(xi.mod.PET_ACC, tier * 3)          -- Scales Wyvern accuracy
    end,
    [15] = function(player, tier) -- SMN
        player:addMod(xi.mod.MP, tier * 10)              -- Tier 5: +50 Max MP
        player:addMod(xi.mod.AVATAR_TP_GAIN_BONUS, tier * 20) -- Tier 5: +100 Regain for Avatar
        player:addMod(xi.mod.BLOOD_PACT_DAMAGE, tier * 2) -- Tier 5: +10% BP Damage
    end,
    [16] = function(player, tier) -- BLUE MAGE
        player:addMod(xi.mod.STR, tier * 1)
        player:addMod(xi.mod.DEX, tier * 1)
        player:addMod(xi.mod.BLUE_MAGIC_SKILL, tier * 3) -- Tier 5: +15 Blue Magic Skill
    end,
    [17] = function(player, tier) -- CORSAIR
        player:addMod(xi.mod.AGI, tier * 2)
        player:addMod(xi.mod.PHANTOM_DURATION, tier * 12) -- Tier 5: +60s Roll Duration
        player:addMod(xi.mod.RACC, tier * 3)             -- Tier 5: +15 Ranged Accuracy
    end,
    [18] = function(player, tier) -- PUPPETMASTER
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.PET_HASTE, tier * 100)      -- Tier 5: +5% Auto Haste
        player:addMod(xi.mod.PET_REGEN, tier * 2)        -- Tier 5: +10 Auto Regen
    end,
    [19] = function(player, tier) -- DANCER
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.WALTZ_POTENCY, tier * 2)    -- Tier 5: +10% Waltz Healing
        player:addMod(xi.mod.REVERSE_FLOURISH, tier * 5) -- Tier 5: Extra TP back
    end,
    [20] = function(player, tier) -- SCHOLAR
        player:addMod(xi.mod.INT, tier * 1)
        player:addMod(xi.mod.MND, tier * 1)
        player:addMod(xi.mod.CONSERVE_MP, tier * 2)      -- Tier 5: +10 Conserve MP
        player:addMod(xi.mod.STRATEGEM_RECOUNT, tier * 1) 
    end,
    [21] = function(player, tier) -- GEOMANCER
        player:addMod(xi.mod.INT, tier * 2)
        player:addMod(xi.mod.LUOPAN_DT, tier * -100)     -- Tier 5: -5% Luopan Damage Taken
        player:addMod(xi.mod.GEOMANCY_SKILL, tier * 3)   -- Tier 5: +15 Geo Skill
    end,
    [22] = function(player, tier) -- RUNEFENCER
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.MAGIC_EVASION, tier * 4)    -- Tier 5: +20 Magic Evasion
        player:addMod(xi.mod.PARRY, tier * 2)            -- Tier 5: +10 Parry Skill
    end
}

-- ==========================================================
-- GLOBAL SYSTEM ENTRYPOINT (Triggered by C++)
-- ==========================================================
xi.custom_mastery.onRefreshGiftMods = function(player)
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

    -- Check character database tracker for this specific job
    local questTier = player:getCharVar("[CQ]MASTERY_" .. jobName)
    
    if questTier > 0 and questTier <= 5 then
        -- 1. Natively grant equipment tier safety (Su1 - Su5)
        player:setMod(xi.mod.SUPERIOR_LEVEL, questTier)

        -- 2. BASE CORE ATTRIBUTES (Granted universally to every job)
        player:addMod(xi.mod.HP,   questTier * 30) -- Tier 5: +75 HP
		player:addMod(xi.mod.MP,   questTier * 30) -- Tier 5: +75 MP
        player:addMod(xi.mod.ACC,  questTier * 3)  -- Tier 5: +15 Accuracy
        player:addMod(xi.mod.ATT,  questTier * 3)  -- Tier 5: +15 Attack
        player:addMod(xi.mod.MACC, questTier * 2)  -- Tier 5: +10 Magic Accuracy
        player:addMod(xi.mod.MATT, questTier * 2)  -- Tier 5: +10 Magic Attack

        -- 3. CHOOSE AND EXECUTE SPECIFIC UNIQUE JOB MODS
        if jobBonusMatrix[mjob] then
            jobBonusMatrix[mjob](player, questTier)
        end
    end
end