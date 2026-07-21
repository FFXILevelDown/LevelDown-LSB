-----------------------------------
-- Area: Sealion's Den
-- Name: The Warrior's Path HTBF
-----------------------------------
require("scripts/globals/battlefield") -- FIXED: Added missing dependencies
require("scripts/globals/npc_util")
-----------------------------------
local sealionsDenID = zones[xi.zone.SEALIONS_DEN]
-----------------------------------

local content = Battlefield:new({
    id            = "WARRIORS_PATH_II", -- FIXED: Added explicit string tracking identifier
    zoneId        = xi.zone.SEALIONS_DEN,
    battlefieldId = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.WARRIORS_PATH_II) or 23, -- Protected prefix guard
    canLoseExp    = false,
    allowTrusts   = true,
    maxPlayers    = 6,
    levelCap      = 99,
    timeLimit     = utils.minutes(30),
    index         = 2,
    entryNpc      = '_0w0',
    exitNpc       = 'Airship_Door',
    requiredKeyItems = { xi.ki.WARRIORS_PATH_PHANTOM_GEM, keep = false  },
})

-- Database drift protection fallback chain mapping
local tenzenBase    = sealionsDenID.mob.TENZEN_HTBF or sealionsDenID.mob.TENZEN or 0
local cherukikiBase = sealionsDenID.mob.CHERUKIKI_HTBF or sealionsDenID.mob.CHERUKIKI or 0
local kukkiBase     = sealionsDenID.mob.KUKKI_CHEBUKKI_HTBF or sealionsDenID.mob.KUKKI_CHEBUKKI or 0
local makkiBase     = sealionsDenID.mob.MAKKI_CHEBUKKI_HTBF or sealionsDenID.mob.MAKKI_CHEBUKKI or 0

content.groups =
{
    {
        mobIds =
        {
            { tenzenBase     },
            { tenzenBase + 4 },
            { tenzenBase + 8 },
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

    {
        mobIds =
        {
            {
                cherukikiBase,
                kukkiBase,
                makkiBase,
            },

            {
                cherukikiBase + 4,
                kukkiBase     + 4,
                makkiBase     + 4,
            },

            {
                cherukikiBase + 8,
                kukkiBase     + 8,
                makkiBase     + 8,
            },
        },
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
        { itemId = xi.item.NONE,                    weight = 143 }, -- nothing
        { itemId = ld.item.EXALTED_LOG,             weight = 142 }, -- Exalted Log
        { itemId = ld.item.HEPATIZON_ORE,           weight = 142 }, -- Hepatizon Ore
        { itemId = ld.item.MALIYAKALEYA_ORB,        weight = 142 }, -- Maliyakaleya Coral
        { itemId = ld.item.CHUNK_OF_BERYLLIUM_ORE,  weight = 142 }, -- Beryllium Ore
        { itemId = ld.item.SIFS_LOCK,               weight = 142 }, -- Sif's Lock
        { itemId = xi.item.SCARLETITE_INGOT,        weight = 142 }, -- Scarletite Ingot
    },
    --Weapons
    {
        { itemId = xi.item.NONE,                weight = 250 }, -- nothing
        { itemId = xi.item.DIVINATOR,        	weight = 150 },
        { itemId = xi.item.DIVINATOR_II,        weight = 150 },
        { itemId = xi.item.GINSEN,        	    weight = 150 },
        { itemId = xi.item.HANGAKU_NO_YUMI,     weight = 150 }, 
        { itemId = xi.item.SERAPHICALLER,       weight = 150 }, 
    },
    --Armor
    {
        { itemId = xi.item.NONE,                    weight = 334 }, -- nothing
        { itemId = xi.item.SUKEROKU_HACHIMAKI,      weight = 222 },
        { itemId = xi.item.BATTLECAST_GAITERS,      weight = 222 },
        { itemId = xi.item.MIZUKAGE_NO_KUBIKAZARI,  weight = 222 },
    },
}

-- FIXED: Decoupled code execution registration layout from final module return target
content:register()
return content
