-----------------------------------
-- Area: Cloister of Storms
-- BCNM: Trial by Lightning II HTBF
-----------------------------------
require("scripts/globals/battlefield") -- FIXED: Included missing dependencies
require("scripts/globals/npc_util")
-----------------------------------
local cloisterOfStormsID = zones[xi.zone.CLOISTER_OF_STORMS]
-----------------------------------

local content = Battlefield:new({
    id               = "TRIAL_BY_LIGHTNING_II", -- FIXED: Explicit identifier string added
    zoneId           = xi.zone.CLOISTER_OF_STORMS,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.TRIAL_BY_LIGHTNING_II) or 7, -- Fixed nil enum fallback guard
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 5,
    entryNpc         = 'LP_Entrance',
    exitNpc          = 'Lightning_Protocrystal',
    requiredKeyItems = { xi.ki.AVATAR_PHANTOM_GEM, keep = false  },
    allowTrusts      = true,
})

content.groups =
{
    {
        mobIds =
        {
            { cloisterOfStormsID.mob.RAMUH_PRIME_HTBF     },
            { cloisterOfStormsID.mob.RAMUH_PRIME_HTBF + 1 },
            { cloisterOfStormsID.mob.RAMUH_PRIME_HTBF + 2 },
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
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,     weight =  1000},  
    },

    {
        { itemId = xi.item.NONE,                            weight = 750 }, -- nothing
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,     weight = 250}, 
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
        { itemId = xi.item.STACCATO_STAFF,        	weight = 166 },
        { itemId = xi.item.DONAR_GUN,        	    weight = 166},-- 
    },
    --Armor
    {
        { itemId = xi.item.NONE,                weight = 333 }, -- nothing
        { itemId = xi.item.UKKO_SASH,           weight = 250 }, -- 
        { itemId = xi.item.BRONTES_CUISSES,     weight = 250 }, -- 
        { itemId = xi.item.VOLTSURGE_TORQUE,    weight = 167 }, -- 
    },
}

-- FIXED: Registered instance independently to avoid live reloader lookup failure
content:register()
return content
