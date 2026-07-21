-----------------------------------
-- Area: Cloister of Gales
-- BCNM: Trial by Wind II HTBF
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/npc_util")
-----------------------------------
local cloisterOfGalesID = zones[xi.zone.CLOISTER_OF_GALES]
-----------------------------------

local content = Battlefield:new({
    id               = "TRIAL_BY_WIND_II",
    zoneId           = xi.zone.CLOISTER_OF_GALES,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.TRIAL_BY_WIND_II) or 6, -- Prefix guard
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 5,
    entryNpc         = 'WP_Entrance',
    exitNpc          = 'Wind_Protocrystal',
    requiredKeyItems = { xi.ki.AVATAR_PHANTOM_GEM, keep = false  },
    allowTrusts      = true,
})

content.groups =
{
    {
        mobIds =
        {
            -- FIXED: Reverted to addition math because GARUDA_PRIME_HTBF is a raw number in this specific zone
            { cloisterOfGalesID.mob.GARUDA_PRIME_HTBF     },
            { cloisterOfGalesID.mob.GARUDA_PRIME_HTBF + 1 },
            { cloisterOfGalesID.mob.GARUDA_PRIME_HTBF + 2 },
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
                players[1]:timer(7000, function(p) -- loot drop timer
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
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_6,     weight =  1000},  
    },

    {
        { itemId = xi.item.NONE,                            weight = 750 }, -- nothing
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_6,     weight = 250}, 
    },
    -- Unique Materials
    {
        { itemId = xi.item.NONE,                    weight = 167 }, -- nothing
        { itemId = ld.item.EXALTED_LOG,             weight = 166 }, 
        { itemId = ld.item.HEPATIZON_ORE,           weight = 166 }, 
        { itemId = ld.item.MALIYAKALEYA_ORB,        weight = 166 }, 
        { itemId = ld.item.CHUNK_OF_BERYLLIUM_ORE,  weight = 166 }, 
        { itemId = ld.item.SIFS_LOCK,               weight = 166 }, 
    },
    -- Weapons
    {
        { itemId = xi.item.NONE,                   	weight = 667 }, -- nothing
        { itemId = xi.item.LEVANTE_DAGGER,        	weight = 167 },
        { itemId = xi.item.TRAMONTANE_AXE,        	weight = 166 },  
    },
    -- Armor
    {
        { itemId = xi.item.NONE,                    weight = 333 }, -- nothing
        { itemId = xi.item.LEBECHE_RING,            weight = 167 },
        { itemId = xi.item.PONENTE_SASH,            weight = 250 }, 
        { itemId = xi.item.OSTRO_GREAVES,           weight = 250 }, 
    },
}

-- Separate registration layer from the return statement
content:register()
return content
