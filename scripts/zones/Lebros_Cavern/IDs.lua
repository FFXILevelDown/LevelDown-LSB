-----------------------------------
-- Area: Lebros_Cavern
-----------------------------------
zones = zones or {}

zones[xi.zone.LEBROS_CAVERN] =
{
    text =
    {
        YOU_RECOVERED_MOG_TABLET      = 0,    -- A mog tablet has been discovered in ${choice: 0}[West Ronfaure/East Ronfaure/the La Theine Plateau/the Valkurm Dunes/Jugner Forest/the Batallia Downs/North Gustaberg/South Gustaberg/the Konschtat Highlands/the Pashhow Marshlands/the Rolanberry Fields/Beaucedine Glacier/Xarcabard/West Sarutabaruta/East Sarutabaruta/the Tahrongi Canyon/the Buburimu Peninsula/the Meriphataud Mountains/the Sauromugue Champaign/Qufim Island/Behemoth''s Dominion/Cape Teriggan/the Eastern Altepa Desert/the Sanctuary of Zi''Tah/Ro''Maeve/the Yuhtunga Jungle/the Yhoator Jungle/the Western Altepa Desert/the Valley of Sorrows]!
        ALL_MOG_TABLETS_FOUND         = 1,    -- The complete set of mog tablets has been restored to RuLude Gardens! The ancient magic of King Kupofried permeates the air to instill adventurers in this area with its Super Kupowers!
        FIND_THE_MOG_TABLETS          = 2,    -- The strength of the ancient moogle magic has weakened, and the tablets have been scattered to the winds once more. You can feel your Super Kupowers begin to fade away...
        ITEM_CANNOT_BE_OBTAINED       = 6384, -- You cannot obtain the <item>. Come back after sorting your inventory.
        FULL_INVENTORY_AFTER_TRADE    = 6388, -- You cannot obtain the <item>. Try trading again after sorting your inventory.
        ITEM_OBTAINED                 = 6390, -- Obtained: <item>.
        GIL_OBTAINED                  = 6391, -- Obtained <number> gil.
        KEYITEM_OBTAINED              = 6393, -- Obtained key item: <keyitem>.
        KEYITEM_LOST                  = 6394, -- Lost key item: <keyitem>.
        NOT_HAVE_ENOUGH_GIL           = 6395, -- You do not have enough gil.
        ITEMS_OBTAINED                = 6399, -- You obtain <number> <item>!
        MINE_COUNTDOWN                = 6982, -- <number>...
        CARRIED_OVER_POINTS           = 7001, -- You have carried over <number> login point[/s].
        LOGIN_CAMPAIGN_UNDERWAY       = 7002, -- The [/January/February/March/April/May/June/July/August/September/October/November/December] <number> Login Campaign is currently underway!
        LOGIN_NUMBER                  = 7003, -- In celebration of your most recent login (login no. <number>), we have provided you with <number> points! You currently have a total of <number> points.
        MEMBERS_LEVELS_ARE_RESTRICTED = 7023, -- Your party is unable to participate because certain members' levels are restricted.
        TEMP_ITEM                     = 7222, -- Obtained temporary item: <item>!
        PLAYER_OBTAINS_ITEM           = 7223, -- <name> obtains <item>!
        ASSAULT_START_OFFSET          = 7358, -- Max MP Down removed for <name>.
        TIME_TO_COMPLETE              = 7419, -- You have <number> [minute/minutes] (Earth time) to complete this mission.
        MISSION_FAILED                = 7420, -- The mission has failed. Leaving area.
        RUNE_UNLOCKED_POS             = 7421, -- ission objective completed. Unlocking Rune of Release ([A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z]-#).
        ASSAULT_POINTS_OBTAINED       = 7423, -- You gain <number> [Assault point/Assault points]!
        TIME_REMAINING_MINUTES        = 7424, -- ime remaining: <number> [minute/minutes] (Earth time).
        TIME_REMAINING_SECONDS        = 7425, -- ime remaining: <number> [second/seconds] (Earth time).
        PARTY_FALLEN                  = 7427, -- ll party members have fallen in battle. Mission failure in <number> [minute/minutes].
    },

    mob =
    {
        WAMOURA_OFFSET = GetTableOfIDs('Ranch_Wamoura'),
        [xi.assault.mission.EXCAVATION_DUTY] =
        {
            MOBS_START =
            {
                17035265, 17035266, 17035267, 17035268, 17035269, 17035270, 17035271, 17035272, 17035273,
                17035274, 17035275, 17035276, 17035277, 17035278, 17035279, 17035280, 17035281,
                BRITTLE_ROCK1 = 17035283, BRITTLE_ROCK2 = 17035285, BRITTLE_ROCK3 = 17035287, BRITTLE_ROCK4 = 17035289, BRITTLE_ROCK5 = 17035291,
            },
        },
        [xi.assault.mission.LEBROS_SUPPLIES] =
        {
            MOBS_START =
            {
                17035292, 17035293, 17035294, 17035295, 17035296, 17035297, 17035298, 17035299, 17035300, 17035301,
                17035302, 17035303, 17035304, 17035305, 17035306, 17035307, 17035308, 17035309,
            }
        },
        [xi.assault.mission.TROLL_FUGITIVES] =
        {
            MOBS_START =
            {
                17035310, 17035311, 17035312, 17035313, 17035314, 17035315, 17035316, 17035317,
                17035318, 17035319, 17035320, 17035321, 17035322, 17035323, 17035324,
            },
        },
        [xi.assault.mission.WAMOURA_FARM_RAID] =
        {
            MOBS_START =
            {
                17035359, 17035360, 17035361, 17035362, 17035363, 17035364, 17035365, 17035366, 17035367, 17035368,
                17035369, 17035370, 17035371, 17035372, 17035373, 17035374, 17035375, 17035376, 17035377, 17035378,
            },
        }
    },

    npc =
    {
        ANCIENT_LOCKBOX = GetFirstID('Ancient_Lockbox'),
        RUNE_OF_RELEASE = GetFirstID('Rune_of_Release'),
        _1rx            = GetFirstID('_1rx'),
        _1ry            = GetFirstID('_1ry'),
        _1rz            = GetFirstID('_1rz'),
        _jr0            = GetFirstID('_jr0'),
        _jr1            = GetFirstID('_jr1'),
    }
}

return zones[xi.zone.LEBROS_CAVERN]
