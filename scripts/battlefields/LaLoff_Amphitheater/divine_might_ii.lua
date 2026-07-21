-----------------------------------
-- Area: LaLoff Amphitheater
-- Name: Divine Might II
-----------------------------------
require("scripts/globals/battlefield")
require("scripts/globals/npc_util")
-----------------------------------
local laLoffID = zones[xi.zone.LALOFF_AMPHITHEATER]
-----------------------------------

local content = Battlefield:new({
    id               = "DIVINE_MIGHT_II",
    zoneId           = xi.zone.LALOFF_AMPHITHEATER,
    battlefieldId    = (xi.battlefield and xi.battlefield.id and xi.battlefield.id.DIVINE_MIGHT_II) or 21,
    canLoseExp       = false,
    allowTrusts      = true,
    maxPlayers       = 18,
    levelCap         = 99,
    timeLimit        = utils.minutes(30),
    index            = 11,
    entryNpcs        = { 'qm1_1', 'qm1_2', 'qm1_3', 'qm1_4', 'qm1_5' },
    exitNpc          = 'qm2',
    requiredKeyItems = { xi.ki.P_PERPETRATOR_PHANTOM_GEM, keep = false  },
})

-- Safe-guard assignment mapping for all 5 Ark Angels to protect arithmetic operators
local hmBase = laLoffID.mob.ARK_ANGEL_HM_HTBF or laLoffID.mob.ARK_ANGEL_HM or 0
local mrBase = laLoffID.mob.ARK_ANGEL_MR_HTBF or laLoffID.mob.ARK_ANGEL_MR or 0
local evBase = laLoffID.mob.ARK_ANGEL_EV_HTBF or laLoffID.mob.ARK_ANGEL_EV or 0
local ttBase = laLoffID.mob.ARK_ANGEL_TT_HTBF or laLoffID.mob.ARK_ANGEL_TT or 0
local gkBase = laLoffID.mob.ARK_ANGEL_GK_HTBF or laLoffID.mob.ARK_ANGEL_GK or 0

content.groups =
{
    {
        mobIds =
        {
            {
                hmBase + 40,      
                mrBase + 38,
                evBase + 80,
                ttBase + 78,
                gkBase + 76,
            },
        },

        allDeath = function(battlefield, mob)
            local players = battlefield:getPlayers()
            if battlefield:getStatus() == xi.battlefield.status.WON then
                return
            end

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

    -- AAMR: Tiger
    {
        mobIds =
        {
            { mrBase + 39 },
        },

        spawned = false,
    },

    -- AAMR: Mandragora
    {
        mobIds =
        {
            { mrBase + 40 },
        },

        spawned = false,
    },

    -- AAGK: Wyvern
    {
        mobIds =
        {
            { gkBase + 77 },
        },

        spawned = false,
    },
}

content.loot =
{ 
    {
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_6,     weight =  166},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,     weight =  166},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight =  166},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_9,     weight =  166},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_10,    weight =  166},        
    },

    { 
        { itemId = xi.item.NONE,                            weight = 250 },
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_6,     weight = 125},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_7,     weight = 125},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_8,     weight = 125},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_9,     weight = 125},
        { itemId = xi.item.COPY_OF_REMS_TALE_CHAPTER_10,    weight = 125},
    },
    --Unique Materials
    { 
        { itemId = xi.item.NONE,                        weight = 250 },
        { itemId = xi.item.VESTIGE_OF_A_BURIED_TRAIT,   weight = 125 },
        { itemId = ld.item.EXALTED_LOG,                 weight = 125 },
        { itemId = ld.item.HEPATIZON_ORE,               weight = 125 },
        { itemId = ld.item.MALIYAKALEYA_ORB,            weight = 125 },
        { itemId = ld.item.CHUNK_OF_BERYLLIUM_ORE,      weight = 125 },
        { itemId = ld.item.SIFS_LOCK,                   weight = 125 },
    },
    --Weapons
    {
        { itemId = xi.item.NONE,                weight = 333 },
        { itemId = xi.item.SERAPHICALLER,       weight = 222 },
        { itemId = xi.item.DIVINATOR,           weight = 222 },
        { itemId = xi.item.DIVINATOR_II,         weight = 222 },
    },
    --Armor (TT)
    {
        { itemId = xi.item.NONE,                weight = 500 },
        { itemId = xi.item.CREMATIO_EARRING,    weight = 250 },
        { itemId = xi.item.FRAVASHI_MANTLE,     weight = 250 },
    },
    --Armor (HM)
    {
        { itemId = xi.item.NONE,                weight = 500 },
        { itemId = xi.item.LENTUS_GRIP,         weight = 250 },
        { itemId = xi.item.TRUX_EARRING,        weight = 250 },
    },
    --Armor (MR)
    {
        { itemId = xi.item.NONE,                weight = 500 },
        { itemId = xi.item.KYUJUTSUGI,          weight = 250 },
        { itemId = xi.item.GELAI_EARRING,       weight = 250 },
    },
    --Armor (GK)
    {
        { itemId = xi.item.NONE,                weight = 750 },
        { itemId = xi.item.TRIPUDIO_EARRING,    weight = 250 },
    },
    --Armor (EV)
    {
        { itemId = xi.item.NONE,                weight = 750 },
        { itemId = xi.item.SANARE_EARRING,      weight = 250 },
    },
}

content:register()
return content
