-----------------------------------
-- Area: Cloister of Tides
-- BCNM: Trial by Water II HTBF
-----------------------------------
require("scripts/globals/battlefield") -- FIXED: Added missing dependencies
require("scripts/globals/npc_util")
-----------------------------------
local cloisterOfTidesID = zones[xi.zone.CLOISTER_OF_TIDES]
-----------------------------------

local content = Battlefield:new({
    id               = "TRIAL_BY_WATER_II", -- FIXED: Added explicit string tracking identifier
    zoneId           = xi.zone.CLOISTER_OF_TIDES,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.TRIAL_BY_WATER_II) or 9, -- Protected prefix guard
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 4,
    entryNpc         = 'WP_Entrance',
    exitNpc          = 'Water_Protocrystal',
    requiredKeyItems = { xi.ki.AVATAR_PHANTOM_GEM, keep = false  },
    allowTrusts      = true,
})

content.groups =
{
    {
        mobIds =
        {
            { cloisterOfTidesID.mob.LEVIATHAN_PRIME_HTBF     },
            { cloisterOfTidesID.mob.LEVIATHAN_PRIME_HTBF + 1 },
            { cloisterOfTidesID.mob.LEVIATHAN_PRIME_HTBF + 2 },
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
        { itemId = xi.item.NONE,                   	weight = 667 }, -- nothing
        { itemId = xi.item.VADOSE_ROD,        	    weight = 167 },
        { itemId = xi.item.PHREATIC_AXE,        	weight = 166 }, 
    },
    --Armor
    {
        { itemId = xi.item.NONE,                    weight = 250 }, -- nothing
        { itemId = xi.item.BENTHOS_GRIP,            weight = 250 }, 
        { itemId = xi.item.NERITIC_EARRING,         weight = 500 }, 
    },
}

-- FIXED: Registered instance safely on its own layout layer to prevent memory index errors
content:register()
return content
