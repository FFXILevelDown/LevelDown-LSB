-----------------------------------
-- Area: Cloister of Flames
-- BCNM: Trial by Fire II HTBF
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/npc_util")
-----------------------------------
local cloisterOfFlamesID = zones[xi.zone.CLOISTER_OF_FLAMES]
-----------------------------------

local content = Battlefield:new({
    id               = "TRIAL_BY_FIRE_II",
    zoneId           = xi.zone.CLOISTER_OF_FLAMES,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.TRIAL_BY_FIRE_II) or 4, 
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 4,
    entryNpc         = 'FP_Entrance',
    exitNpc          = 'Fire_Protocrystal',
    requiredKeyItems = { xi.ki.AVATAR_PHANTOM_GEM, keep = false  },
    allowTrusts      = true,
})

content.groups =
{
    {
        mobIds =
        {
            -- FIXED: Indexed the table elements explicitly instead of performing arithmetic on the table object
            { cloisterOfFlamesID.mob.IFRIT_PRIME_HTBF[1] },
            { cloisterOfFlamesID.mob.IFRIT_PRIME_HTBF[2] },
            { cloisterOfFlamesID.mob.IFRIT_PRIME_HTBF[3] },
        },

        allDeath = function(battlefield, mob)
            local players = battlefield:getPlayers()
            battlefield:setStatus(xi.battlefield.status.WON)

            local rewardItems = { xi.item.BOULDER_CASE, xi.item.PLUTON_CASE, xi.item.BEITETSU_PARCEL }
            for _, player in ipairs(players) do
                local randomItem = rewardItems[math.random(#rewardItems)]
                npcUtil.giveItem(player, randomItem)
            end

            if #players > 0 then
                players[1]:timer(7000, function(p) -- timer to drop loot
                    local selectedLoot = utils.selectFromLootGroups(p, content.loot)
                    for _, item in ipairs(selectedLoot) do
                        if item.itemId ~= xi.item.NONE then
                            -- Add to treasure pool of the first player (shared with party)
                            p:addTreasure(item.itemId, mob)
                        end
                    end
                end)
            end
        end,
    },
}

content.loot =
{
    {
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_9,     weight =  1000}, 
    },

    {
        { itemId = xi.item.NONE,                            weight = 750 }, -- nothing
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_9,     weight = 250}, 
    },
    --Unique Materials
    {
        { itemId = xi.item.NONE,                    weight = 167 }, -- nothing
        { itemId = ld.item.EXALTED_LOG,             weight = 166 }, -- Exalted Log
        { itemId = ld.item.HEPATIZON_ORE,           weight = 166 }, -- Hepatizon Ore
        { itemId = ld.item.MALIYAKALEYA_ORB,        weight = 166 }, -- Maliyakaleya Coral
        { itemId = ld.item.CHUNK_OF_BERYLLIUM_ORE,  weight = 166 }, -- Beryllium Ore
        { itemId = ld.item.SIFS_LOCK,               weight = 166 }, -- Sif's Lock
    },
    --Weapons
    {
        { itemId = xi.item.NONE,                    weight = 667 }, -- nothing
        { itemId = xi.item.PERFERVID_SWORD,         weight = 167 },
        { itemId = xi.item.ATAKIGIRI,               weight = 166 }, 
    },
    --Armor
    {
        { itemId = xi.item.NONE,                   weight = 250 }, -- nothing
        { itemId = xi.item.COALRAKE_SABOTS,        weight = 250 }, 
        { itemId = xi.item.ANNEALED_MANTLE,        weight = 500 }, 
    },
}

content:register()
return content
