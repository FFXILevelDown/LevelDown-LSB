-----------------------------------
-- Area: LaLoff Amphitheater
-- Name: Ark Angels HTBF (Elvaan)
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/npc_util")
-----------------------------------
local laLoffID = zones[xi.zone.LALOFF_AMPHITHEATER]
-----------------------------------

local content = Battlefield:new({
    id                    = "ARK_ANGELS_EV_II",
    zoneId                = xi.zone.LALOFF_AMPHITHEATER,
    battlefieldId         = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.ARK_ANGELS_EV_II) or 16,
    allowTrusts           = true,
    maxPlayers            = 6,
    timeLimit             = utils.minutes(30),
    index                 = 9,
    entryNpc              = 'qm1_4',
    exitNpc               = 'qm2',
    requiredKeyItems      = { xi.ki.PHANTOM_GEM_OF_ARROGANCE, keep = false  },
})

-- Database drift protection guard
local baseId = laLoffID.mob.ARK_ANGEL_EV_HTBF or laLoffID.mob.ARK_ANGEL_EV or 0

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
                players[1]:timer(7000, function(p)
                    local selectedLoot = utils.selectFromLootGroups(p, content.loot)
                    for _, item in ipairs(selectedLoot) do
                        if item.itemId ~= xi.item.NONE then
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
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,    weight =  1000},  
    },

    {
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,    weight = 1000}, 
    },
    --Unique Materials
    {
        { itemId = xi.item.NONE,                            weight = 250 },
        { itemId = xi.item.VESTIGE_OF_A_BURIED_TRAIT,       weight = 375 },
        { itemId = ld.item.EXALTED_LOG,                     weight = 375 },
    },
    --Weapons
    {
        { itemId = xi.item.NONE,                    weight = 500 },
        { itemId = xi.item.ANAHERA_SWORD,           weight = 250 },
        { itemId = xi.item.CAGLIOSTROS_ROD,         weight = 250 },  
    },
    --Armor
    {
        { itemId = xi.item.NONE,                weight = 334 },
        { itemId = xi.item.OSMIUM_CUISSES,      weight = 222 },
        { itemId = xi.item.PATRICIUS_RING,      weight = 222 }, 
        { itemId = xi.item.DYNASTY_MITTS,       weight = 222 }, 
    },
}

content:register()
return content
