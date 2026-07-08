-----------------------------------
-- Area: Shrouded Maw
-- BCNM: Waking Dreams II HTBF
-----------------------------------
require("scripts/globals/battlefield") -- FIXED: Added missing dependencies
require("scripts/globals/npc_util")
-----------------------------------
local shroudedMawID = zones[xi.zone.THE_SHROUDED_MAW]
-----------------------------------

local content = Battlefield:new({
    id               = "WAKING_DREAMS_II", -- FIXED: Added explicit string tracking identifier
    zoneId           = xi.zone.THE_SHROUDED_MAW,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.WAKING_DREAMS_II) or 26, -- Protected prefix guard
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 3,
    entryNpc         = 'MC_Entrance',
    exitNpc          = 'Memento_Circle',
    requiredKeyItems = { xi.ki.WAKING_DREAMS_PHANTOM_GEM, keep = false  },
    allowTrusts      = true,
})

-- Database drift protection guard
local baseId = shroudedMawID.mob.DIABOLOS_PRIME_HTBF or shroudedMawID.mob.DIABOLOS_PRIME or 0

content.groups =
{
    {
        mobIds =
        {
            { baseId     },
            { baseId + 1 },
            { baseId + 2 },
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
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight =  1000}, -- 
    },

    {
        { itemId = xi.item.NONE,                            weight = 750 }, -- nothing
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight = 250}, -- 
    },
    -- Unique Materials
    {
        { itemId = xi.item.NONE,                    weight = 167 }, -- nothing
        { itemId = xi.item.EXALTED_LOG,             weight = 166 }, -- Exalted Log
        { itemId = xi.item.HEPATIZON_ORE,           weight = 166 }, -- Hepatizon Ore
        { itemId = xi.item.MALIYAKALEYA_ORB,        weight = 166 }, -- Maliyakaleya Coral
        { itemId = xi.item.CHUNK_OF_BERYLLIUM_ORE,  weight = 166 }, -- Beryllium Ore
        { itemId = xi.item.SIFS_LOCK,               weight = 166 }, -- Sif's Lock
    },
    -- Weapons
    {
        { itemId = xi.item.NONE,                   	weight = 667 }, -- nothing
        { itemId = xi.item.SHUHANSADAMUNE,        	weight = 333 }, 
    },
    -- Armor
    {
        { itemId = xi.item.NONE,                    weight = 333 }, -- nothing
        { itemId = xi.item.CHOZORON_COSELETE,       weight = 83 }, 
        { itemId = xi.item.LOAGAETH_CUFFS,          weight = 84 }, 
        { itemId = xi.item.DARKSIDE_EARRING,        weight = 250 }, 
        { itemId = xi.item.PERNICIOUS_RING,         weight = 250 }, 
    },
}

-- FIXED: Split core registration deployment logic away from direct return execution
content:register()
return content