xi = xi or {}
xi.custom_mastery = xi.custom_mastery or {}

local jobBonusMatrix = {
    [1]  = function(player, tier) -- WARRIOR
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.DOUBLE_ATTACK, tier * 1)
        player:addMod(xi.mod.WAR_CRY_DURATION, tier * 3)
    end,
    [2]  = function(player, tier) -- MONK
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.COUNTER, tier * 1)
        player:addMod(xi.mod.KICK_ATTACK_RATE, tier * 2)
    end,
    [3]  = function(player, tier) -- WHITE MAGE
        player:addMod(xi.mod.MND, tier * 2)
        player:addMod(xi.mod.CURE_POTENCY, tier * 2)
        player:addMod(xi.mod.ENMITY, tier * -1)
    end,
    [4]  = function(player, tier) -- BLACK MAGE
        player:addMod(xi.mod.INT, tier * 2)
        player:addMod(xi.mod.MAGIC_DAMAGE, tier * 5)
        player:addMod(xi.mod.ELEMENTAL_BURST_DMG, tier * 2)
    end,
    [5]  = function(player, tier) -- RED MAGE
        player:addMod(xi.mod.INT, tier * 1)
        player:addMod(xi.mod.MND, tier * 1)
        player:addMod(xi.mod.FAST_CAST, tier * 2)
        player:addMod(xi.mod.ENSPELL_DMG, tier * 3)
    end,
    [6]  = function(player, tier) -- THIEF
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.TRIPLE_ATTACK, tier * 1)
        player:addMod(xi.mod.STEAL, tier * 2)
    end,
    [7]  = function(player, tier) -- PALADIN
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.DEF, tier * 4)
        player:addMod(xi.mod.SHIELD_BLOCK_RATE, tier * 1)
        player:addMod(xi.mod.ENMITY, tier * 2)
    end,
    [8]  = function(player, tier) -- DARK KNIGHT
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.ATT, tier * 5)
        player:addMod(xi.mod.WEAPON_SKILL_DAMAGE, tier * 1)
    end,
    [9]  = function(player, tier) -- BEASTMASTER
        player:addMod(xi.mod.CHR, tier * 2)
        player:addMod(xi.mod.PET_ACC, tier * 3)
        player:addMod(xi.mod.PET_ATT, tier * 3)
    end,
    [10] = function(player, tier) -- BARD
        player:addMod(xi.mod.CHR, tier * 2)
        player:addMod(xi.mod.SONG_DURATION_BONUS, tier * 2)
        player:addMod(xi.mod.ENMITY, tier * -1)
    end,
    [11] = function(player, tier) -- RANGER
        player:addMod(xi.mod.AGI, tier * 2)
        player:addMod(xi.mod.RACC, tier * 4)
        player:addMod(xi.mod.RATT, tier * 4)
    end,
    [12] = function(player, tier) -- SAMURAI
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.STORE_TP, tier * 2)
        player:addMod(xi.mod.MEDITATE_DURATION, tier * 2)
    end,
    [13] = function(player, tier) -- NINJA
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.DUAL_WIELD, tier * -1)
        player:addMod(xi.mod.SUBTLE_BLOW, tier * 2)
    end,
    [14] = function(player, tier) -- DRAGOON
        player:addMod(xi.mod.STR, tier * 2)
        player:addMod(xi.mod.HASTE_ABILITY, tier * 100)
        player:addMod(xi.mod.PET_ACC, tier * 3)          
    end,
    [15] = function(player, tier) -- SMN
        player:addMod(xi.mod.MP, tier * 10)
        player:addMod(xi.mod.AVATAR_TP_GAIN_BONUS, tier * 20)
        player:addMod(xi.mod.BLOOD_PACT_DAMAGE, tier * 2)
    end,
    [16] = function(player, tier) -- BLUE MAGE
        player:addMod(xi.mod.STR, tier * 1)
        player:addMod(xi.mod.DEX, tier * 1)
        player:addMod(xi.mod.BLUE_MAGIC_SKILL, tier * 3)
    end,
    [17] = function(player, tier) -- CORSAIR
        player:addMod(xi.mod.AGI, tier * 2)
        player:addMod(xi.mod.PHANTOM_DURATION, tier * 12)
        player:addMod(xi.mod.RACC, tier * 3)
    end,
    [18] = function(player, tier) -- PUPPETMASTER
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.PET_HASTE, tier * 100)
        player:addMod(xi.mod.PET_REGEN, tier * 2)
    end,
    [19] = function(player, tier) -- DANCER
        player:addMod(xi.mod.DEX, tier * 2)
        player:addMod(xi.mod.WALTZ_POTENCY, tier * 2)
        player:addMod(xi.mod.REVERSE_FLOURISH, tier * 5)
    end,
    [20] = function(player, tier) -- SCHOLAR
        player:addMod(xi.mod.INT, tier * 1)
        player:addMod(xi.mod.MND, tier * 1)
        player:addMod(xi.mod.CONSERVE_MP, tier * 2)
    end,
    [21] = function(player, tier) -- GEOMANCER
        player:addMod(xi.mod.INT, tier * 2)
        player:addMod(xi.mod.LUOPAN_DT, tier * -100)
        player:addMod(xi.mod.GEOMANCY_SKILL, tier * 3)
    end,
    [22] = function(player, tier) -- RUNEFENCER
        player:addMod(xi.mod.VIT, tier * 2)
        player:addMod(xi.mod.MAGIC_EVASION, tier * 4)
        player:addMod(xi.mod.PARRY, tier * 2)
    end
}

-- The C++ core now feeds player AND totalJpSpent straight into this method!
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

    local questTier = player:getCharVar("[CQ]MASTERY_" .. jobName)
    
    -- Safe C++ Parameter Fallback: No unbound function errors can happen here anymore!
    if questTier == 0 and totalJpSpent and totalJpSpent >= 2100 then
        questTier = 5
    end
    
    if questTier > 0 and questTier <= 5 then
        player:setMod(xi.mod.SUPERIOR_LEVEL, questTier)

        -- UNIVERSAL STATS
        player:addMod(xi.mod.HP,   questTier * 15)
		player:addMod(xi.mod.MP,   questTier * 15)
        player:addMod(xi.mod.ACC,  questTier * 3)
        player:addMod(xi.mod.ATT,  questTier * 3)
        player:addMod(xi.mod.MACC, questTier * 2)
        player:addMod(xi.mod.MATT, questTier * 2)
        -- 3. CAPACITY POINTS PROGRESSION BONUS 
        -- Values scale as: Tier 1 = +10%, Tier 2 = +20% ... Tier 5 = +50%
        player:addMod(xi.mod.CAPACITY_BONUS, questTier * 90)
        -- JOB SPECIFIC STATS
        if jobBonusMatrix[mjob] then
            jobBonusMatrix[mjob](player, questTier)
        end
    end
end

