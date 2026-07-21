-----------------------------------
-- Area: LaLoff Amphitheater
-- Name: Ark Angels HTBF (Mithra)
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/npc_util")
-----------------------------------
local laLoffID = zones[xi.zone.LALOFF_AMPHITHEATER]
-----------------------------------

local content = Battlefield:new({
    id                    = "ARK_ANGELS_MR_II",
    zoneId                = xi.zone.LALOFF_AMPHITHEATER,
    battlefieldId         = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.ARK_ANGELS_MR_II) or 19,
    allowTrusts           = true,
    maxPlayers            = 6,
    timeLimit             = utils.minutes(30),
    index                 = 8,
    entryNpc              = 'qm1_3',
    exitNpc               = 'qm2',
    requiredKeyItems      = { xi.ki.PHANTOM_GEM_OF_ENVY, keep = false  },
})

-- Database drift protection guards
local baseId = laLoffID.mob.ARK_ANGEL_MR_HTBF or laLoffID.mob.ARK_ANGEL_MR or 0
local petId  = laLoffID.mob.ARK_ANGEL_MR or laLoffID.mob.ARK_ANGEL_MR_HTBF or 0

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

    -- Tiger Pets
    {
        mobIds =
        {
            { petId + 3 },
            { petId + 4 },
            { petId + 5 },
        },

        spawned = false,
    },

    -- Mandragora Pets
    {
        mobIds =
        {
            { petId + 6 },
            { petId + 7 },
            { petId + 8 },
        },

        spawned = false,
    },
}

content.loot =
{
    {
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight =  1000},  
    },

    {
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight = 1000}, 
    },
    --Unique Materials
    {
        { itemId = xi.item.NONE,                           weight = 250 },
        { itemId = xi.item.VESTIGE_OF_A_BURIED_TRAIT,      weight = 375 }, 
        { itemId = ld.item.CHUNK_OF_BERYLLIUM_ORE,         weight = 375 }, 
    },
    --Weapons
    {
        { itemId = xi.item.NONE,              weight = 500 },
        { itemId = xi.item.RAIMITSUKANE,      weight = 250 },
        { itemId = xi.item.ANAHERA_TABAR,     weight = 250 },  
    },
    --Armor
    {
        { itemId = xi.item.NONE,              weight = 334 },
        { itemId = xi.item.REGIMEN_MITTENS,   weight = 250 },
        { itemId = xi.item.FELISTRIS_MASK,    weight = 250 }, 
        { itemId = xi.item.SEKHMET_CORSET,    weight = 167 }, 
    },
}

content:register()
return content
