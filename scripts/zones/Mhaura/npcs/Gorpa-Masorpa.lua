-----------------------------------
-- Area: Mhaura (249)
-- Gorpa-Masorpa  : !pos -27.584 -15.990 52.565 249
-----------------------------------
---@type TNpcEntity
local entity = {}

local pulseTrades =
{
    xi.item.SAGASINGER,
    xi.item.EPHEMERON,
    xi.item.CORUSCANTI,
    xi.item.MURASAMEMARU,
    xi.item.BOREALIS,
    xi.item.ASTERIA,
    xi.item.DELPHINIUS,
    xi.item.AYTANRI,
    xi.item.GIRRU,
    xi.item.IKARIGIRI,
    xi.item.TENKOMARU,
    xi.item.HIMTHIGE,
    xi.item.ADFLICTIO,
    xi.item.GUSTERION,
    xi.item.DUKKHA,
    xi.item.CHASTISERS,
    xi.item.ROUTER,
    xi.item.ANNEALED_LANCE,
}

local ambuscadeTrade =
{
    [390] = -- csid
    {
        [1] = { trade = { xi.item.AMBUSCADE_VOUCHER_WEAPON } },
        [2] = { trade = { xi.item.AMBUSCADE_VOUCHER_BACK } },
        [3] = { trade = { xi.item.AMBUSCADE_VOUCHER_REPLICA } },
        [4] = { trade = { xi.item.AMBUSCADE_CHIT_HEADGEAR } },
        [5] = { trade = { xi.item.AMBUSCADE_CHIT_BODYGEAR } },
        [6] = { trade = { xi.item.AMBUSCADE_CHIT_HANDGEAR } },
        [7] = { trade = { xi.item.AMBUSCADE_CHIT_LEGGEAR } },
        [8] = { trade = { xi.item.AMBUSCADE_CHIT_FOOTGEAR } },
        [9] = { trade = { xi.item.AMBUSCADE_CHIT_HEADGEAR_P1 } },
        [10] = { trade = { xi.item.AMBUSCADE_CHIT_BODYGEAR_P1 } },
        [11] = { trade = { xi.item.AMBUSCADE_CHIT_HANDGEAR_P1 } },
        [12] = { trade = { xi.item.AMBUSCADE_CHIT_LEGGEAR_P1 } },
        [13] = { trade = { xi.item.AMBUSCADE_CHIT_FOOTGEAR_P1 } },
        [14] = { trade = { xi.item.AMBUSCADE_CHIT_RING } },
        [15] = { trade = { xi.item.AMBUSCADE_VOUCHER_HEAD } },
        [16] = { trade = { xi.item.AMBUSCADE_VOUCHER_BODY } },
        [17] = { trade = { xi.item.AMBUSCADE_VOUCHER_HANDS } },
        [18] = { trade = { xi.item.AMBUSCADE_VOUCHER_LEGS } },
        [19] = { trade = { xi.item.AMBUSCADE_VOUCHER_FEET } },
    },
    [393] = -- csid
    {
        [1] = { trade = { xi.item.FLAMMA_ZUCCHETTO, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.FLAMMA_ZUCCHETTO_P1 },
        [2] = { trade = { xi.item.FLAMMA_ZUCCHETTO_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.FLAMMA_ZUCCHETTO_P2 },
        [3] = { trade = { xi.item.FLAMMA_KORAZIN, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.FLAMMA_KORAZIN_P1 },
        [4] = { trade = { xi.item.FLAMMA_KORAZIN_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.FLAMMA_KORAZIN_P2 },
        [5] = { trade = { xi.item.FLAMMA_MANOPOLAS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.FLAMMA_MANOPOLAS_P1 },
        [6] = { trade = { xi.item.FLAMMA_MANOPOLAS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.FLAMMA_MANOPOLAS_P2 },
        [7] = { trade = { xi.item.FLAMMA_DIRS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.FLAMMA_DIRS_P1 },
        [8] = { trade = { xi.item.FLAMMA_DIRS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.FLAMMA_DIRS_P2 },
        [9] = { trade = { xi.item.FLAMMA_GAMBIERAS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.FLAMMA_GAMBIERAS_P1 },
        [10] = { trade = { xi.item.FLAMMA_GAMBIERAS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.FLAMMA_GAMBIERAS_P2 },
        [11] = { trade = { xi.item.TALIAH_TURBAN, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.TALIAH_TURBAN_P1 },
        [12] = { trade = { xi.item.TALIAH_TURBAN_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.TALIAH_TURBAN_P2 },
        [13] = { trade = { xi.item.TALIAH_MANTEEL, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.TALIAH_MANTEEL_P1 },
        [14] = { trade = { xi.item.TALIAH_MANTEEL_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.TALIAH_MANTEEL_P2 },
        [15] = { trade = { xi.item.TALIAH_GAGES, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.TALIAH_GAGES_P1 },
        [16] = { trade = { xi.item.TALIAH_GAGES_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.TALIAH_GAGES_P2 },
        [17] = { trade = { xi.item.TALIAH_SERAWEELS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.TALIAH_SERAWEELS_P1 },
        [18] = { trade = { xi.item.TALIAH_SERAWEELS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.TALIAH_SERAWEELS_P2 },
        [19] = { trade = { xi.item.TALIAH_CRACKOWS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.TALIAH_CRACKOWS_P1 },
        [20] = { trade = { xi.item.TALIAH_CRACKOWS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.TALIAH_CRACKOWS_P2 },
        [21] = { trade = { xi.item.MUMMU_BONNET, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MUMMU_BONNET_P1 },
        [22] = { trade = { xi.item.MUMMU_BONNET_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MUMMU_BONNET_P2 },
        [23] = { trade = { xi.item.MUMMU_JACKET, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MUMMU_JACKET_P1 },
        [24] = { trade = { xi.item.MUMMU_JACKET_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MUMMU_JACKET_P2 },
        [25] = { trade = { xi.item.MUMMU_WRISTS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MUMMU_WRISTS_P1 },
        [26] = { trade = { xi.item.MUMMU_WRISTS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MUMMU_WRISTS_P2 },
        [27] = { trade = { xi.item.MUMMU_KECKS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MUMMU_KECKS_P1 },
        [28] = { trade = { xi.item.MUMMU_KECKS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MUMMU_KECKS_P2 },
        [29] = { trade = { xi.item.MUMMU_GAMASHES, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MUMMU_GAMASHES_P1 },
        [30] = { trade = { xi.item.MUMMU_GAMASHES_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MUMMU_GAMASHES_P2 },
        [31] = { trade = { xi.item.AYANMO_ZUCCHETTO, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.AYANMO_ZUCCHETTO_P1 },
        [32] = { trade = { xi.item.AYANMO_ZUCCHETTO_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.AYANMO_ZUCCHETTO_P2 },
        [33] = { trade = { xi.item.AYANMO_CORAZZA, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.AYANMO_CORAZZA_P1 },
        [34] = { trade = { xi.item.AYANMO_CORAZZA_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.AYANMO_CORAZZA_P2 },
        [35] = { trade = { xi.item.AYANMO_MANOPOLAS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.AYANMO_MANOPOLAS_P1 },
        [36] = { trade = { xi.item.AYANMO_MANOPOLAS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.AYANMO_MANOPOLAS_P2 },
        [37] = { trade = { xi.item.AYANMO_COSCIALES, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.AYANMO_COSCIALES_P1 },
        [38] = { trade = { xi.item.AYANMO_COSCIALES_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.AYANMO_COSCIALES_P2 },
        [39] = { trade = { xi.item.AYANMO_GAMBIERAS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.AYANMO_GAMBIERAS_P1 },
        [40] = { trade = { xi.item.AYANMO_GAMBIERAS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.AYANMO_GAMBIERAS_P2 },
        [41] = { trade = { xi.item.MALLQUIS_CHAPEAU, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MALLQUIS_CHAPEAU_P1 },
        [42] = { trade = { xi.item.MALLQUIS_CHAPEAU_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MALLQUIS_CHAPEAU_P2 },
        [43] = { trade = { xi.item.MALLQUIS_SAIO, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MALLQUIS_SAIO_P1 },
        [44] = { trade = { xi.item.MALLQUIS_SAIO_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MALLQUIS_SAIO_P2 },
        [45] = { trade = { xi.item.MALLQUIS_CUFFS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MALLQUIS_CUFFS_P1 },
        [46] = { trade = { xi.item.MALLQUIS_CUFFS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MALLQUIS_CUFFS_P2 },
        [47] = { trade = { xi.item.MALLQUIS_TREWS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MALLQUIS_TREWS_P1 },
        [48] = { trade = { xi.item.MALLQUIS_TREWS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MALLQUIS_TREWS_P2 },
        [49] = { trade = { xi.item.MALLQUIS_CLOGS, { xi.item.LOOP_OF_ABDHALJS_FIBER, 5 } }, reward = xi.item.MALLQUIS_CLOGS_P1 },
        [50] = { trade = { xi.item.MALLQUIS_CLOGS_P1, { xi.item.LOOP_OF_ABDHALJS_FIBER, 10 } }, reward = xi.item.MALLQUIS_CLOGS_P2 },
        [51] = { trade = { xi.item.SULEVIAS_MASK, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.SULEVIAS_MASK_P1 },
        [52] = { trade = { xi.item.SULEVIAS_MASK_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.SULEVIAS_MASK_P2 },
        [53] = { trade = { xi.item.SULEVIAS_PLATEMAIL, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.SULEVIAS_PLATEMAIL_P1 },
        [54] = { trade = { xi.item.SULEVIAS_PLATEMAIL_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.SULEVIAS_PLATEMAIL_P2 },
        [55] = { trade = { xi.item.SULEVIAS_GAUNTLETS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.SULEVIAS_GAUNTLETS_P1 },
        [56] = { trade = { xi.item.SULEVIAS_GAUNTLETS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.SULEVIAS_GAUNTLETS_P2 },
        [57] = { trade = { xi.item.SULEVIAS_CUISSES, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.SULEVIAS_CUISSES_P1 },
        [58] = { trade = { xi.item.SULEVIAS_CUISSES_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.SULEVIAS_CUISSES_P2 },
        [59] = { trade = { xi.item.SULEVIAS_LEGGINGS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.SULEVIAS_LEGGINGS_P1 },
        [60] = { trade = { xi.item.SULEVIAS_LEGGINGS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.SULEVIAS_LEGGINGS_P2 },
        [61] = { trade = { xi.item.MEGHANADA_VISOR, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.MEGHANADA_VISOR_P1 },
        [62] = { trade = { xi.item.MEGHANADA_VISOR_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.MEGHANADA_VISOR_P2 },
        [63] = { trade = { xi.item.MEGHANADA_CUIRIE, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.MEGHANADA_CUIRIE_P1 },
        [64] = { trade = { xi.item.MEGHANADA_CUIRIE_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.MEGHANADA_CUIRIE_P2 },
        [65] = { trade = { xi.item.MEGHANADA_GLOVES, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.MEGHANADA_GLOVES_P1 },
        [66] = { trade = { xi.item.MEGHANADA_GLOVES_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.MEGHANADA_GLOVES_P2 },
        [67] = { trade = { xi.item.MEGHANADA_CHAUSSES, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.MEGHANADA_CHAUSSES_P1 },
        [68] = { trade = { xi.item.MEGHANADA_CHAUSSES_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.MEGHANADA_CHAUSSES_P2 },
        [69] = { trade = { xi.item.MEGHANADA_JAMBEAUX, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.MEGHANADA_JAMBEAUX_P1 },
        [70] = { trade = { xi.item.MEGHANADA_JAMBEAUX_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.MEGHANADA_JAMBEAUX_P2 },
        [71] = { trade = { xi.item.HIZAMARU_SOMEN, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.HIZAMARU_SOMEN_P1 },
        [72] = { trade = { xi.item.HIZAMARU_SOMEN_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.HIZAMARU_SOMEN_P2 },
        [73] = { trade = { xi.item.HIZAMARU_HARAMAKI, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.HIZAMARU_HARAMAKI_P1 },
        [74] = { trade = { xi.item.HIZAMARU_HARAMAKI_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.HIZAMARU_HARAMAKI_P2 },
        [75] = { trade = { xi.item.HIZAMARU_KOTE, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.HIZAMARU_KOTE_P1 },
        [76] = { trade = { xi.item.HIZAMARU_KOTE_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.HIZAMARU_KOTE_P2 },
        [77] = { trade = { xi.item.HIZAMARU_HIZAYOROI, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.HIZAMARU_HIZAYOROI_P1 },
        [78] = { trade = { xi.item.HIZAMARU_HIZAYOROI_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.HIZAMARU_HIZAYOROI_P2 },
        [79] = { trade = { xi.item.HIZAMARU_SUNE_ATE, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.HIZAMARU_SUNE_ATE_P1 },
        [80] = { trade = { xi.item.HIZAMARU_SUNE_ATE_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.HIZAMARU_SUNE_ATE_P2 },
        [81] = { trade = { xi.item.INYANGA_TIARA, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.INYANGA_TIARA_P1 },
        [82] = { trade = { xi.item.INYANGA_TIARA_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.INYANGA_TIARA_P2 },
        [83] = { trade = { xi.item.INYANGA_JUBBAH, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.INYANGA_JUBBAH_P1 },
        [84] = { trade = { xi.item.INYANGA_JUBBAH_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.INYANGA_JUBBAH_P2 },
        [85] = { trade = { xi.item.INYANGA_DASTANAS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.INYANGA_DASTANAS_P1 },
        [86] = { trade = { xi.item.INYANGA_DASTANAS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.INYANGA_DASTANAS_P2 },
        [87] = { trade = { xi.item.INYANGA_SHALWAR, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.INYANGA_SHALWAR_P1 },
        [88] = { trade = { xi.item.INYANGA_SHALWAR_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.INYANGA_SHALWAR_P2 },
        [89] = { trade = { xi.item.INYANGA_CRACKOWS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.INYANGA_CRACKOWS_P1 },
        [90] = { trade = { xi.item.INYANGA_CRACKOWS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.INYANGA_CRACKOWS_P2 },
        [91] = { trade = { xi.item.JHAKRI_CORONAL, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.JHAKRI_CORONAL_P1 },
        [92] = { trade = { xi.item.JHAKRI_CORONAL_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.JHAKRI_CORONAL_P2 },
        [93] = { trade = { xi.item.JHAKRI_ROBE, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.JHAKRI_ROBE_P1 },
        [94] = { trade = { xi.item.JHAKRI_ROBE_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.JHAKRI_ROBE_P2 },
        [95] = { trade = { xi.item.JHAKRI_CUFFS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.JHAKRI_CUFFS_P1 },
        [96] = { trade = { xi.item.JHAKRI_CUFFS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.JHAKRI_CUFFS_P2 },
        [97] = { trade = { xi.item.JHAKRI_SLOPS, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.JHAKRI_SLOPS_P1 },
        [98] = { trade = { xi.item.JHAKRI_SLOPS_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.JHAKRI_SLOPS_P2 },
        [99] = { trade = { xi.item.JHAKRI_PIGACHES, { xi.item.VIAL_OF_ABDHALJS_METAL, 5 } }, reward = xi.item.JHAKRI_PIGACHES_P1 },
        [100] = { trade = { xi.item.JHAKRI_PIGACHES_P1, { xi.item.VIAL_OF_ABDHALJS_METAL, 10 } }, reward = xi.item.JHAKRI_PIGACHES_P2 },
        [101] = { trade = { xi.item.PAIR_OF_TOKKO_KNUCKLES, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.PAIR_OF_AJJA_KNUCKLES },
        [102] = { trade = { xi.item.PAIR_OF_AJJA_KNUCKLES, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.PAIR_OF_ELETTA_KNUCKLES },
        [103] = { trade = { xi.item.PAIR_OF_ELETTA_KNUCKLES, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.PAIR_OF_KAJA_KNUCKLES },
        [104] = { trade = { xi.item.PAIR_OF_KAJA_KNUCKLES, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.KARAMBIT },
        [105] = { trade = { xi.item.TOKKO_KNIFE, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_KNIFE },
        [106] = { trade = { xi.item.AJJA_KNIFE, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_KNIFE },
        [107] = { trade = { xi.item.ELETTA_KNIFE, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_KNIFE },
        [108] = { trade = { xi.item.KAJA_KNIFE, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.TAURET },
        [109] = { trade = { xi.item.TOKKO_SWORD, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_SWORD },
        [110] = { trade = { xi.item.AJJA_SWORD, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_SWORD },
        [111] = { trade = { xi.item.ELETTA_SWORD, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_SWORD },
        [112] = { trade = { xi.item.KAJA_SWORD, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.NAEGLING },
        [113] = { trade = { xi.item.TOKKO_CLAYMORE, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_CLAYMORE },
        [114] = { trade = { xi.item.AJJA_CLAYMORE, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_CLAYMORE },
        [115] = { trade = { xi.item.ELETTA_CLAYMORE, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_CLAYMORE },
        [116] = { trade = { xi.item.KAJA_CLAYMORE, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.NANDAKA },
        [117] = { trade = { xi.item.TOKKO_AXE, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_AXE },
        [118] = { trade = { xi.item.AJJA_AXE, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_AXE },
        [119] = { trade = { xi.item.ELETTA_AXE, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_AXE },
        [120] = { trade = { xi.item.KAJA_AXE, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.DOLICHENUS },
        [121] = { trade = { xi.item.TOKKO_CHOPPER, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_CHOPPER },
        [122] = { trade = { xi.item.AJJA_CHOPPER, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_CHOPPER },
        [123] = { trade = { xi.item.ELETTA_CHOPPER, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_CHOPPER },
        [124] = { trade = { xi.item.KAJA_CHOPPER, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.LYCURGOS },
        [125] = { trade = { xi.item.TOKKO_SCYTHE, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_SCYTHE },
        [126] = { trade = { xi.item.AJJA_SCYTHE, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_SCYTHE },
        [127] = { trade = { xi.item.ELETTA_SCYTHE, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_SCYTHE },
        [128] = { trade = { xi.item.KAJA_SCYTHE, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.DREPANUM },
        [129] = { trade = { xi.item.TOKKO_LANCE, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_LANCE },
        [130] = { trade = { xi.item.AJJA_LANCE, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_LANCE },
        [131] = { trade = { xi.item.ELETTA_LANCE, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_LANCE },
        [132] = { trade = { xi.item.KAJA_LANCE, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.SHINING_ONE },
        [133] = { trade = { xi.item.TOKKO_KATANA, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_KATANA },
        [134] = { trade = { xi.item.AJJA_KATANA, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_KATANA },
        [135] = { trade = { xi.item.ELETTA_KATANA, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_KATANA },
        [136] = { trade = { xi.item.KAJA_KATANA, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.GOKOTAI  },
        [137] = { trade = { xi.item.TOKKO_TACHI, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_TACHI },
        [138] = { trade = { xi.item.AJJA_TACHI, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_TACHI },
        [139] = { trade = { xi.item.ELETTA_TACHI, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_TACHI },
        [140] = { trade = { xi.item.KAJA_TACHI, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.HACHIMONJI },
        [141] = { trade = { xi.item.TOKKO_ROD, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_ROD },
        [142] = { trade = { xi.item.AJJA_ROD, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_ROD },
        [143] = { trade = { xi.item.ELETTA_ROD, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_ROD },
        [144] = { trade = { xi.item.KAJA_ROD, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.MAXENTIUS },
        [145] = { trade = { xi.item.TOKKO_STAFF, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_STAFF },
        [146] = { trade = { xi.item.AJJA_STAFF, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_STAFF },
        [147] = { trade = { xi.item.ELETTA_STAFF, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_STAFF },
        [148] = { trade = { xi.item.KAJA_STAFF, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.XOANON },
        [149] = { trade = { xi.item.TOKKO_BOW, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_BOW },
        [150] = { trade = { xi.item.AJJA_BOW, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_BOW },
        [151] = { trade = { xi.item.ELETTA_BOW, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_BOW },
        [152] = { trade = { xi.item.KAJA_BOW, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.ULLR },
        [153] = { trade = { xi.item.TOKKO_GRIP, { xi.item.ABDHALJS_NUGGETS, 5 } }, reward = xi.item.AJJA_GRIP },
        [154] = { trade = { xi.item.AJJA_GRIP, { xi.item.ABDHALJS_GEM, 5 } }, reward = xi.item.ELETTA_GRIP },
        [155] = { trade = { xi.item.ELETTA_GRIP, { xi.item.ABDHALJS_ANIMA, 5 } }, reward = xi.item.KAJA_GRIP },
        [156] = { trade = { xi.item.KAJA_GRIP, { xi.item.CHUNK_OF_ABDHALJS_MATTER, 5 } }, reward = xi.item.KHONSU },
    },
}

local hallmarkRewards =
{
    [1] = -- option 1
    {
        [1] = { item = xi.item.TUKUKU_WHITESHELL, quantity = 150, minimumHallmarksNeeded = 20, bitIndex = 1, param = 1 },
        [2] = { item = xi.item.LUNGO_NANGO_JADESHELL, quantity = 2, minimumHallmarksNeeded = 2000, bitIndex = 17, param = 1 },
        [3] = { item = xi.item.ORDELLE_BRONZEPIECE, quantity = 150, minimumHallmarksNeeded = 20, bitIndex = 1, param = 2 },
        [4] = { item = xi.item.MONTIONT_SILVERPIECE, quantity = 2, minimumHallmarksNeeded = 2000, bitIndex = 17, param = 2 },
        [5] = { item = xi.item.ONE_BYNE_BILL, quantity = 150, minimumHallmarksNeeded = 20, bitIndex = 1, param = 3 },
        [6] = { item = xi.item.ONE_HUNDRED_BYNE_BILL, quantity = 2, minimumHallmarksNeeded = 2000, bitIndex = 17, param = 3 },
        [7] = { item = xi.item.ALEXANDRITE, quantity = 1750, minimumHallmarksNeeded = 15, bitIndex = 1, param = 4 },
        [8] = { item = xi.item.PLATE_OF_HEAVY_METAL, quantity = 100, minimumHallmarksNeeded = 200, bitIndex = 17, param = 4 },
        [9] = { item = xi.item.CLUMP_OF_RIFTDROSS, quantity = 3, minimumHallmarksNeeded = 1500, bitIndex = 1, param = 5 },
        [10] = { item = xi.item.PINCH_OF_RIFTCINDER, quantity = 3, minimumHallmarksNeeded = 1500, bitIndex = 17, param = 5 },
        [11] = { item = xi.item.PLUTON, quantity = 500, minimumHallmarksNeeded = 50, bitIndex = 1, param = 6 },
        [12] = { item = xi.item.BEITETSU, quantity = 500, minimumHallmarksNeeded = 50, bitIndex = 17, param = 6 },
        [13] = { item = xi.item.RIFTBORN_BOULDER, quantity = 500, minimumHallmarksNeeded = 50, bitIndex = 1, param = 7 },
        [14] = { item = xi.item.PINCH_OF_HIGH_PURITY_BAYLD, quantity = 750, minimumHallmarksNeeded = 35, bitIndex = 17, param = 7 },
        [15] = { item = xi.item.VIAL_OF_UMBRAL_MARROW, quantity = 2, minimumHallmarksNeeded = 30000, bitIndex = 1, param = 8 },
        [16] = { item = xi.item.MULCIBARS_SCORIA, quantity = 1, minimumHallmarksNeeded = 50000, bitIndex = 17, param = 8 },
    },
    [2] = -- option 2
    {
        [1] = { item = xi.item.SPOOL_OF_ABDHALJS_THREAD, quantity = 40, minimumHallmarksNeeded = 100, bitIndex = 1, param = 9 },
        [2] = { item = xi.item.PINCH_OF_ABDHALJS_DUST, quantity = 40, minimumHallmarksNeeded = 100, bitIndex = 17, param = 9 },
        [3] = { item = xi.item.BOTTLE_OF_ABDHALJS_SAP, quantity = 20, minimumHallmarksNeeded = 200, bitIndex = 1, param = 10 },
        [4] = { item = xi.item.POT_OF_ABDHALJS_DYE, quantity = 15, minimumHallmarksNeeded = 800, bitIndex = 17, param = 10 },
        [5] = { item = xi.item.CONTAINER_OF_ABDHALJS_RESIN, quantity = 10, minimumHallmarksNeeded = 1500, bitIndex = 1, param = 11 },
        [6] = { item = xi.item.AMBUSCADE_CHIT_FOOTGEAR, quantity = 9, minimumHallmarksNeeded = 100, bitIndex = 17, param = 11 },
        [7] = { item = xi.item.AMBUSCADE_CHIT_HANDGEAR, quantity = 9, minimumHallmarksNeeded = 150, bitIndex = 1, param = 12 },
        [8] = { item = xi.item.AMBUSCADE_CHIT_HEADGEAR, quantity = 9, minimumHallmarksNeeded = 250, bitIndex = 17, param = 12 },
        [9] = { item = xi.item.AMBUSCADE_CHIT_LEGGEAR, quantity = 9, minimumHallmarksNeeded = 400, bitIndex = 1, param = 13 },
        [10] = { item = xi.item.AMBUSCADE_CHIT_BODYGEAR, quantity = 9, minimumHallmarksNeeded = 600, bitIndex = 17, param = 13 },
        [11] = { item = xi.item.AMBUSCADE_CHIT_RING, quantity = 9, minimumHallmarksNeeded = 1000, bitIndex = 1, param = 14 },
        [12] = { item = xi.item.AMBUSCADE_VOUCHER_WEAPON, quantity = 1, minimumHallmarksNeeded = 2000, bitIndex = 17, param = 14 },
        [13] = { item = xi.item.AMBUSCADE_VOUCHER_BACK, quantity = 3, minimumHallmarksNeeded = 500, bitIndex = 1, param = 15 },
        [14] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 125, minimumHallmarksNeeded = 100, bitIndex = 17, param = 15 },
        [15] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 125, minimumHallmarksNeeded = 100, bitIndex = 1, param = 16 },
        [16] = { item = xi.item.ABDHALJS_NUGGETS, quantity = 10, minimumHallmarksNeeded = 300, bitIndex = 17, param = 16 },
    },
    [3] = -- option 3
    {
        [1] = { item = xi.item.ABDHALJS_GEM, quantity = 10, minimumHallmarksNeeded = 500, bitIndex = 1, param = 17 },
        [2] = { item = xi.item.ABDHALJS_ANIMA, quantity = 10, minimumHallmarksNeeded = 800, bitIndex = 17, param = 17 },
        [3] = { item = xi.item.CHUNK_OF_ABDHALJS_MATTER, quantity = 10, minimumHallmarksNeeded = 1200, bitIndex = 1, param = 18 },
        [4] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_1, quantity = 10, minimumHallmarksNeeded = 100, bitIndex = 17, param = 18 },
        [5] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_2, quantity = 10, minimumHallmarksNeeded = 100, bitIndex = 1, param = 19 },
        [6] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_3, quantity = 10, minimumHallmarksNeeded = 100, bitIndex = 17, param = 19 },
        [7] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_4, quantity = 10, minimumHallmarksNeeded = 100, bitIndex = 1, param = 20 },
        [8] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_5, quantity = 10, minimumHallmarksNeeded = 100, bitIndex = 17, param = 20 },
        [9] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_6, quantity = 8, minimumHallmarksNeeded = 300, bitIndex = 1, param = 21 },
        [10] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_7, quantity = 8, minimumHallmarksNeeded = 300, bitIndex = 17, param = 21 },
        [11] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_8, quantity = 8, minimumHallmarksNeeded = 300, bitIndex = 1, param = 22 },
        [12] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_9, quantity = 8, minimumHallmarksNeeded = 300, bitIndex = 17, param = 22 },
        [13] = { item = xi.item.COPY_OF_REMS_TALE_CHAPTER_10, quantity = 8, minimumHallmarksNeeded = 300, bitIndex = 1, param = 23 },
    }
}

local totalHallmarkRewards =
    {
    [1] =
    {
        [1] = { item = xi.item.ABDHALJS_SEAL, quantity = 1, totalHallmarksNeeded = 100, bitIndex = 1 },
        [2] = { item = xi.item.AMBUSCADE_CHIT_FOOTGEAR, quantity = 1, totalHallmarksNeeded = 120, bitIndex = 2 },
        [3] = { item = xi.item.REMEDY, quantity = 12, totalHallmarksNeeded = 150, bitIndex = 3 },
        [4] = { item = xi.item.AMBUSCADE_CHIT_HANDGEAR, quantity = 1, totalHallmarksNeeded = 190, bitIndex = 4 },
        [5] = { item = xi.item.SUPER_RERAISER, quantity = 1, totalHallmarksNeeded = 240, bitIndex = 5 },
        [6] = { item = xi.item.AMBUSCADE_CHIT_HEADGEAR, quantity = 1, totalHallmarksNeeded = 300, bitIndex = 6 },
        [7] = { item = xi.item.CALIBER_RING, quantity = 1, totalHallmarksNeeded = 370, bitIndex = 7 },
        [8] = { item = xi.item.AMBUSCADE_CHIT_LEGGEAR, quantity = 1, totalHallmarksNeeded = 450, bitIndex = 8 },
        [9] = { item = xi.item.FACILITY_RING, quantity = 1, totalHallmarksNeeded = 540, bitIndex = 9 },
        [10] = { item = xi.item.AMBUSCADE_CHIT_BODYGEAR, quantity = 1, totalHallmarksNeeded = 640, bitIndex = 10 },
        [11] = { item = xi.item.AMBUSCADE_VOUCHER_REPLICA, quantity = 1, totalHallmarksNeeded = 750, bitIndex = 11 },
        [12] = { item = xi.item.AMBUSCADE_CHIT_RING, quantity = 1, totalHallmarksNeeded = 870, bitIndex = 12 },
        [13] = { item = xi.item.AMBUSCADE_VOUCHER_WEAPON, quantity = 1, totalHallmarksNeeded = 1000, bitIndex = 13 },
        [14] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 5, totalHallmarksNeeded = 1100, bitIndex = 14 },
        [15] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 5, totalHallmarksNeeded = 1100, bitIndex = 15 },
        [16] = { item = xi.item.ABDHALJS_NUGGETS, quantity = 5, totalHallmarksNeeded = 1400, bitIndex = 16 },
    },
    [2] =
    {
        [1] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 5, totalHallmarksNeeded = 1900, bitIndex = 17 },
        [2] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 5, totalHallmarksNeeded = 1900, bitIndex = 18 },
        [3] = { item = xi.item.ABDHALJS_GEM, quantity = 5, totalHallmarksNeeded = 2700, bitIndex = 19 },
        [4] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 5, totalHallmarksNeeded = 3800, bitIndex = 20 },
        [5] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 5, totalHallmarksNeeded = 3800, bitIndex = 21 },
        [6] = { item = xi.item.ABDHALJS_ANIMA, quantity = 5, totalHallmarksNeeded = 5300, bitIndex = 22 },
        [7] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 5, totalHallmarksNeeded = 7200, bitIndex = 23 },
        [8] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 5, totalHallmarksNeeded = 7200, bitIndex = 24 },
        [9] = { item = xi.item.CHUNK_OF_ABDHALJS_MATTER, quantity = 5, totalHallmarksNeeded = 9600, bitIndex = 25 },
        [10] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 5, totalHallmarksNeeded = 12500, bitIndex = 26 },
        [11] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 5, totalHallmarksNeeded = 12500, bitIndex = 27 },
        [12] = { item = xi.item.SPECIAL_GOBBIEDIAL_KEY, quantity = 1, totalHallmarksNeeded = 16000, bitIndex = 28 },
    },
}

local gallantryRewards =
    {
    [1] = -- option 8 
    {
        [1] = { item = xi.item.TUKUKU_WHITESHELL, quantity = 90, minimumHallmarksNeeded = 20, bitIndex = 1, param = 1 },
        [2] = { item = xi.item.ORDELLE_BRONZEPIECE, quantity = 90, minimumHallmarksNeeded = 20, bitIndex = 17, param = 1 },
        [3] = { item = xi.item.ONE_BYNE_BILL, quantity = 90, minimumHallmarksNeeded = 20, bitIndex = 1, param = 2 },
        [4] = { item = xi.item.PLUTON, quantity = 125, minimumHallmarksNeeded = 50, bitIndex = 17, param = 2 },
        [5] = { item = xi.item.VIAL_OF_UMBRAL_MARROW, quantity = 1, minimumHallmarksNeeded = 30000, bitIndex = 1, param = 3 },
        [6] = { item = xi.item.ALEXANDRITE, quantity = 450, minimumHallmarksNeeded = 15, bitIndex = 17, param = 3 },
        [7] = { item = xi.item.BEITETSU, quantity = 125, minimumHallmarksNeeded = 50, bitIndex = 1, param = 4 },
        [8] = { item = xi.item.PINCH_OF_HIGH_PURITY_BAYLD, quantity = 190, minimumHallmarksNeeded = 35, bitIndex = 17, param = 4 },
        [9] = { item = xi.item.MULCIBARS_SCORIA, quantity = 1, minimumHallmarksNeeded = 50000, bitIndex = 1, param = 5 },
        [10] = { item = xi.item.PLATE_OF_HEAVY_METAL, quantity = 25, minimumHallmarksNeeded = 200, bitIndex = 17, param = 5 },
        [11] = { item = xi.item.CLUMP_OF_RIFTDROSS, quantity = 1, minimumHallmarksNeeded = 1500, bitIndex = 1, param = 6 },
        [12] = { item = xi.item.PINCH_OF_RIFTCINDER, quantity = 1, minimumHallmarksNeeded = 1500, bitIndex = 17, param = 6 },
        [13] = { item = xi.item.RIFTBORN_BOULDER, quantity = 125, minimumHallmarksNeeded = 50, bitIndex = 1, param = 7 },
        [14] = { item = xi.item.SPOOL_OF_ABDHALJS_THREAD, quantity = 20, minimumHallmarksNeeded = 100, bitIndex = 17, param = 7 },
        [15] = { item = xi.item.PINCH_OF_ABDHALJS_DUST, quantity = 20, minimumHallmarksNeeded = 100, bitIndex = 1, param = 8 },
        [16] = { item = xi.item.BOTTLE_OF_ABDHALJS_SAP, quantity = 10, minimumHallmarksNeeded = 200, bitIndex = 17, param = 8 },
    },
    [2] = -- option 9
    {
        [1] = { item = xi.item.POT_OF_ABDHALJS_DYE, quantity = 5, minimumHallmarksNeeded = 800, bitIndex = 1, param = 9 },
        [2] = { item = xi.item.CONTAINER_OF_ABDHALJS_RESIN, quantity = 5, minimumHallmarksNeeded = 1500, bitIndex = 17, param = 9 },
        [3] = { item = xi.item.ABDHALJS_NEEDLE, quantity = 2, minimumHallmarksNeeded = 1000, bitIndex = 1, param = 10 },
        [4] = { item = xi.item.AMBUSCADE_CHIT_FOOTGEAR_P1, quantity = 10, minimumHallmarksNeeded = 300, bitIndex = 17, param = 10 },
        [5] = { item = xi.item.AMBUSCADE_CHIT_HANDGEAR_P1, quantity = 10, minimumHallmarksNeeded = 450, bitIndex = 1, param = 11 },
        [6] = { item = xi.item.AMBUSCADE_CHIT_HEADGEAR_P1, quantity = 10, minimumHallmarksNeeded = 750, bitIndex = 17, param = 11 },
        [7] = { item = xi.item.AMBUSCADE_CHIT_LEGGEAR_P1, quantity = 10, minimumHallmarksNeeded = 1200, bitIndex = 1, param = 12 },
        [8] = { item = xi.item.AMBUSCADE_CHIT_BODYGEAR_P1, quantity = 10, minimumHallmarksNeeded = 1800, bitIndex = 17, param = 12 },
        [9] = { item = xi.item.AMBUSCADE_VOUCHER_WEAPON, quantity = 1, minimumHallmarksNeeded = 6000, bitIndex = 1, param = 13 },
        [10] = { item = xi.item.VIAL_OF_ABDHALJS_METAL, quantity = 245, minimumHallmarksNeeded = 300, bitIndex = 17, param = 13 },
        [11] = { item = xi.item.LOOP_OF_ABDHALJS_FIBER, quantity = 245, minimumHallmarksNeeded = 300, bitIndex = 1, param = 14 },
        [12] = { item = xi.item.ABDHALJS_NUGGETS, quantity = 5, minimumHallmarksNeeded = 900, bitIndex = 17, param = 14 },
        [13] = { item = xi.item.ABDHALJS_GEM, quantity = 5, minimumHallmarksNeeded = 1500, bitIndex = 1, param = 15 },
        [14] = { item = xi.item.ABDHALJS_ANIMA, quantity = 5, minimumHallmarksNeeded = 2400, bitIndex = 17, param = 15 },
        [15] = { item = xi.item.CHUNK_OF_ABDHALJS_MATTER, quantity = 5, minimumHallmarksNeeded = 3600, bitIndex = 1, param = 16 },
    }
}

---------------------------------------------------------
--------------- Functions to set bits for char variables
---------------------------------------------------------

local function setPurchaseAmountGallantry(player, reward, amount)
    local key = '[AmubGal]ItemsObtainedParam' .. reward.param
    local current = player:getCharVar(key)
    local baseBit = reward.bitIndex - 1

    amount = math.min(amount, 0xFFFF)  -- clamp to 16-bit max
    local clearMask = bit.bnot(bit.lshift(0xFFFF, baseBit))
    current = bit.band(current, clearMask)  -- clear existing bits
    local shifted = bit.lshift(amount, baseBit)
    player:setCharVar(key, bit.bor(current, shifted))
end

local function addPurchaseAmountGallantry(player, reward, amountToAdd)
    local key = '[AmubGal]ItemsObtainedParam' .. reward.param
    local current = player:getCharVar(key)
    local baseBit = reward.bitIndex - 1
    local existing = bit.band(bit.rshift(current, baseBit), 0xFFFF)

    local newAmount = math.min(existing + amountToAdd, reward.quantity)
    setPurchaseAmountGallantry(player, reward, newAmount)
end

local function setPurchaseAmountHallmark(player, reward, amount)
    local key = '[AmubHal]ItemsObtainedParam' .. reward.param
    local current = player:getCharVar(key)
    local baseBit = reward.bitIndex - 1

    amount = math.min(amount, 0xFFFF)  -- clamp to 16-bit max
    local clearMask = bit.bnot(bit.lshift(0xFFFF, baseBit))
    current = bit.band(current, clearMask)  -- clear existing bits
    local shifted = bit.lshift(amount, baseBit)
    player:setCharVar(key, bit.bor(current, shifted))
end

local function addPurchaseAmountHallmark(player, reward, amountToAdd)
    local key = '[AmubHal]ItemsObtainedParam' .. reward.param
    local current = player:getCharVar(key)
    local baseBit = reward.bitIndex - 1
    local existing = bit.band(bit.rshift(current, baseBit), 0xFFFF)

    local newAmount = math.min(existing + amountToAdd, reward.quantity)
    setPurchaseAmountHallmark(player, reward, newAmount)
end

local unpack = unpack or table.unpack

local function packn(...)
    return { n = select('#', ...), ... }
end

local function unpackn(t)
    return unpack(t, 1, t.n)
end

---------------------------------------------------------
---------------------------------------------------------
--------------------------------------------------------_

entity.onTrade = function(player, npc, trade)
    local csid = 0
    local tradedItemP1 = 0
    local tradedItemP2 = 0
    local tradedItemP3 = 0
    local pulseItem = 0

    if player:getFreeSlotsCount() < 1 then
        player:messageSpecial(zones[xi.zone.MHAURA].text.FREEUP_INV_SPACE, 1)
        return
    end
        for i = 1, #pulseTrades do -- Determine if trade has a Pulse Weapon
            if npcUtil.tradeHas(trade, pulseTrades[i]) then
                pulseItem = pulseTrades[i]
            end
        end

        if pulseItem ~= 0 then -- rebuild table inserting pulse item to kaja weapons
            for i, items in ipairs(ambuscadeTrade[393]) do
                if items.trade[2][1] == xi.item.CHUNK_OF_ABDHALJS_MATTER then
                    items.trade[3] = pulseItem
                end
            end
        end

        if npcUtil.tradeHas(trade, xi.item.CHUNK_OF_ABDHALJS_MATTER) and -- ensure the trade for final stage contains a pulse weapon and abd matter
            pulseItem == 0 then
            return
        end

        for i, itemsTraded in pairs(ambuscadeTrade[390]) do -- voucher / chit trade
            if npcUtil.tradeHasExactly(trade, itemsTraded.trade) then
                csid = 390
                tradedItemP1 = itemsTraded.trade[1]
                player:setCharVar('Gorpa-MasorpaTrade', 1)
            end
        end

        for i, itemsTraded in pairs(ambuscadeTrade[393]) do -- armor weapon upgrade trade
            if npcUtil.tradeHasExactly(trade, itemsTraded.trade) then
                csid = 393
                tradedItemP1 = itemsTraded.trade[2][1]
                tradedItemP2 = itemsTraded.reward
                tradedItemP3 = itemsTraded.trade[1] -- this is for pulse weapon upgrades
                player:setCharVar('Gorpa-MasorpaTrade', 1)
            end
        end

        player:startEvent(csid, tradedItemP1, tradedItemP2, tradedItemP3)
end



entity.onTrigger = function(player, npc)
    local resetToken = player:getCharVar("Ambuscade_Reset_Token")
    if resetToken > 0 then
        for i = 1, 24 do
            player:setCharVar('[AmubHal]ItemsObtainedParam' .. i, 0)
        end
        for i = 1, 16 do
            player:setCharVar('[AmubGal]ItemsObtainedParam' .. i, 0)
        end
        player:setCharVar('[AmbusTH]ItemsObtained', 0)
        player:setCharVar("Ambuscade_Reset_Token", resetToken - 1)
        player:printToPlayer("Your Ambuscade purchase limits have been reset!", xi.msg.channel.SYSTEM_3)
    end

    local gallantry = player:getCurrency('gallantry')
    local current_hallmarks = player:getCurrency('current_hallmarks')
    local total_hallmarks = player:getCurrency('total_hallmarks')
    local currentAmbuId = 306 -- current Page of the tome flared up **TODO** adjust based on current ambuscade id announced

    if player:getEminenceCompleted(499) then
        player:startEvent(386, 0, current_hallmarks, total_hallmarks, currentAmbuId, 8, gallantry, 0, 4)
    else
        if player:getEminenceProgress(499) then
            -- Intro CS
            player:startEvent(385)
        else
            -- Reminder to set RoE
            player:startEvent(384)
        end
    end
end

entity.onEventUpdate = function(player, csid, option, npc)
    local alternativeOption = bit.band(bit.lshift(option, 0), 0xFF) -- acceptance menus are alternative and do not show up as normal options
    local total_hallmarks = player:getCurrency('total_hallmarks')
    local amountEntered = bit.band(bit.rshift(option, 24), 0xFFFF)
    local currentAmbuId = 306 -- current Ambuscade Page of the tome flared up
    local itemPage = bit.band(bit.rshift(option, 8), 0x0F) +1 -- starts a 0 adding +1
    local itemSelected = bit.band(bit.rshift(option, 16), 0x0F) +1 -- starts at 0 adding +1

    if csid == 386 then
        -- Present Hallmarks menu
        if alternativeOption == 1 then -- this is the update event to option 1, getting a item returns the parameter option not option 1, this is needed to update option 1 with the correct data
            local params = packn()

            for i = 1, 8 do
                params[i] = player:getCharVar('[AmubHal]ItemsObtainedParam' .. i)
            end
            params.n = 8  -- important to match argument count

            player:updateEvent(unpackn(params))

            --[[ 
            param 1
                327830 = ( 0000 0000 0000 0101 )( 0000 0000 1001 0110 )
                          Lungo-Nango jadeshell    Tukuku whiteshells
            param 2
                327830 = ( 0000 0000 0000 0101 )( 0000 0000 1001 0110 )
                          Montiont silverpiece    Ordelle bronzepiece
            param 3 
                327830 = ( 0000 0000 0000 0101 )( 0000 0000 1001 0110 )
                          one hundred byne bill   One byne bill
            param 4
                6555350 = ( 0000 0000 0110 0100 )( 0000 0110 1101 0110 )
                            heavy metals            alexandrite
            param 5
                196611 = ( 0000 0000 0000 0011 )( 0000 0000 0000 0011 ) 
                            pinch of riftcinder   clump of riftdross
            param 6
                32768500 = ( 0000 0001 1111 0100 )( 0000 0001 1111 0100 )
                              chunk of beitetsu         pluton
            param 7
                49152500 = ( 0000 0010 1110 1110 )( 0000 0001 1111 0100 )  
                             high purity bayld     riftborn boulder
            param 8
                65538 =  ( 0000 0000 0000 0001 )( 0000 0000 0000 0010 )
                            mulcibars scoria        umbral marrow

                Hallmarks menu
                page 1 - option 1
                1. tukuku whiteshells total amount can purchase 150 param 1
                2. Lungo-Nango jadeshell total amount can purchase 2 param 1
                3. Ordelle bronzepiece total amount can purchase 150 param 2
                4. Montiont silverpiece total amount can purchase 2 param 2
                5. one byne bill total amount can purchase 150 param 3
                6. one hundred byne bill total amount can purchase 2 param 3
                7. piece of alexandrite total amount can purchase 1750 param 4
                8. plate of heavy metal total amount can purchase 100 param 4
                9. clump of riftdross total amount can purchase 3 param 5
                10. pinch of riftcinder total amount can purchase 3 param 5
                11. pluton total amount can purchase 500 param 6
                12. chunk of beitetsu total amount can purchase 500 param 6
                13. riftborn boulder total amount can purchase 500 param 7
                14. pinch of high purity bayld total amount can purchase 750 param 7
                15. vial of umbral marrow total amount can purchase 2 param 8
                16. chunk of mulcibars scoria total amount can purchase 1 param 8
            ]]--       
        elseif alternativeOption == 2 then -- this is the update event to option 2, getting a item returns the parameter option not option 2, this is needed to update option 2 with the correct data
            local params = packn()

            for i = 1, 8 do
                params[i] = player:getCharVar('[AmubHal]ItemsObtainedParam' .. i +8)
            end
            params.n = 8  -- important to match argument count
            print(unpackn(params))
            player:updateEvent(unpackn(params))
           
            --[[
            param 1
                2621480 = ( 0000 0000 0010 1000 )( 0000 0000 0010 1000 )
                         Pinch of Abdhaljs dust  Spool of Abdhaljs thread
            param 2
                983060 = ( 0000 0000 0000 1111 )( 0000 0000 0001 0100 )
                          Pot of Abdhaljs dye    Bottle of Abdhaljs sap
            param 3 
                589834 = ( 0000 0000 0000 1001 )( 0000 0000 0000 1010 )
                       Ambuscade chit: footgear   Container of Abdhaljs resin
            param 4
                589833 = ( 0000 0000 0000 1001 )( 0000 0000 0000 1001 )
                         Ambuscade chit: headgear  Ambuscade chit: handgear 
            param 5
                589833 = ( 0000 0000 0000 1001 )( 0000 0000 0000 1001 ) 
                        Ambuscade chit: bodygear  Ambuscade chit: leggear 
            param 6
                16842761 = ( 0000 0001 0000 0001 )( 0000 0000 0000 1001 )
                         Ambuscade voucher: weapon Ambuscade chit: ring 
            param 7
                8192259 = ( 0000 0000 0111 1101 )( 0000 0001 0000 0011 )  
                          Vial of Abdhaljs metal    Ambuscade voucher: back  
            param 8
                655485 =  ( 0000 0000 0000 1010 )( 0000 0000 0111 1101 )
                            Abdhaljs Nugget       Loop of Abdhaljs fiber

             Hallmarks menu
                Page 2 - option 2
                1. Spool of Abdhaljs thread total amount can purchase 40
                2. Pinch of Abdhaljs dust total amount can purchase 40
                3. Bottle of Abdhaljs sap total amount can purchase 20
                4. Pot of Abdhaljs dye total amount can purchase 15
                5. Container of Abdhaljs resin total amount can purchase 10
                6. Ambuscade chit: footgear total amount can purchase 9
                7. Ambuscade chit: handgear total amount can purchase 9
                8. Ambuscade chit: headgear total amount can purchase 9
                9. Ambuscade chit: leggear total amount can purchase 9
                10. Ambuscade chit: bodygear total amount can purchase 9
                11. Ambuscade chit: ring total amount can purchase 9
                12. Ambuscade voucher: weapon total amount can purchase 1
                13. Ambuscade voucher: back total amount can purchase 3
                14. Vial of Abdhaljs metal total amount can purchase 125
                15. Loop of Abdhaljs fiber total amount can purchase 125
                16. Abdhaljs Nugget total amount can purchase 10
            ]]--
        elseif alternativeOption == 3 then -- this is the update event to option 3, getting a item returns the parameter option not option 3, this is needed to update option 3 with the correct data
            local params = packn()

            for i = 1, 8 do
                params[i] = player:getCharVar('[AmubHal]ItemsObtainedParam' .. i +16)
            end
            params.n = 8  -- important to match argument count
            print(unpackn(params))
            player:updateEvent(unpackn(params))

            --[[ *************** NNED TO UPDATE FOR REM TALE CHAPTERS
            param 1
                655370 = ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                             Abdhaljs anima              Abdhaljs gem
            param 2
                655370 =    ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                      COPY_OF_REMS_TALE_CHAPTER_1  Chunk of Abdhaljs matter
            param 3
                655370 =    ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                      COPY_OF_REMS_TALE_CHAPTER_3  COPY_OF_REMS_TALE_CHAPTER_2
            param 4
                655370 =    ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                      COPY_OF_REMS_TALE_CHAPTER_5  COPY_OF_REMS_TALE_CHAPTER_4
            param 5
                524296 =    ( 0000 0000 0000 1000 )( 0000 0000 0000 1000 )
                      COPY_OF_REMS_TALE_CHAPTER_7  COPY_OF_REMS_TALE_CHAPTER_6
            param 6
                524296 =    ( 0000 0000 0000 1000 )( 0000 0000 0000 1000 )
                      COPY_OF_REMS_TALE_CHAPTER_9  COPY_OF_REMS_TALE_CHAPTER_8
            param 7
                8 =    ( 0000 0000 0000 0000 )( 0000 0000 0000 1000 )
                                  NONE       COPY_OF_REMS_TALE_CHAPTER_10

             Hallmarks menu
                Page 3 - option 3
                1. Abdhaljs gem total amount can purchase 10
                2. Abdhaljs anima total amount can purchase 10
                3. Chunk of Abdhaljs matter total amount can purchase 10
            ]]--

        -- Present Total Hallmarks menu
        elseif option == 5 then
            local totalRewardsReceived = player:getCharVar('[AmbusTH]ItemsObtained')

            player:updateEvent(player:getCharVar('[AmbusTH]ItemsObtained'), 0, 0, currentAmbuId, 0, 0, 0, 0)
            --[[
            Page 1 - 
            1. Abdhaljs Seal total amount can given 1 param 1  -              0000 0000 0000 0000 0000 0000 0000 0001 bit 0
            2. Ambuscade chit: footgear total amount can given 1 param 1  -   0000 0000 0000 0000 0000 0000 0000 0010 bit 1
            3. Remedy total amount can given 12 param 1  -                    0000 0000 0000 0000 0000 0000 0000 0100 bit 2
            4. Ambuscade chit: handgear total amount can given 1 param 1  -   0000 0000 0000 0000 0000 0000 0000 1000 bit 3
            5. Super reraiser total amount can given 1 param 1  -             0000 0000 0000 0000 0000 0000 0001 0000 bit 4
            6. Ambuscade chit: headgear total amount can given 1 param 1  -   0000 0000 0000 0000 0000 0000 0010 0000 bit 5
            7. Caliber ring total amount can given 1 param 1  -               0000 0000 0000 0000 0000 0000 0100 0000 bit 6
            8. Ambuscade chit: leggear total amount can given 1 param 1  -    0000 0000 0000 0000 0000 0000 1000 0000 bit 7
            9. Facility ring total amount can given 1 param 1  -              0000 0000 0000 0000 0000 0001 0000 0000 bit 8
            10. Ambuscade chit: bodygear total amount can given 1 param 1  -  0000 0000 0000 0000 0000 0010 0000 0000 bit 9
            11. Ambuscade voucher: relica total amount can given 1 param 1  - 0000 0000 0000 0000 0000 0100 0000 0000 bit 10
            12. Ambuscade chit: ring total amount can given 1 param 1  -      0000 0000 0000 0000 0000 1000 0000 0000 bit 11
            13. Ambuscade voucher: weapon total amount can given 1 param 1  - 0000 0000 0000 0000 0001 0000 0000 0000 bit 12
            14. Vial of Abdhaljs metal total amount can given 5 param 1  -    0000 0000 0000 0000 0010 0000 0000 0000 bit 13
            15. Loop of Abdhaljs fiber total amount can given 5 param 1  -    0000 0000 0000 0000 0100 0000 0000 0000 bit 14
            16. Abdhaljs Nugget total amount can given 5 param 1  -           0000 0000 0000 0000 1000 0000 0000 0000 bit 15

            Page 2 -
            1. Vial of Abdhaljs metal total amount can given 5 param 1  -     0000 0000 0000 0001 0000 0000 0000 0000 bit 16
            2. Loop of Abdhaljs fiber total amount can given 5 param 1  -     0000 0000 0000 0010 0000 0000 0000 0000 bit 17
            3. Abdhaljs gem total amount can given 5 param 1  -               0000 0000 0000 0100 0000 0000 0000 0000 bit 18
            4. Vial of Abdhaljs metal total amount can given 5 param 1  -     0000 0000 0000 1000 0000 0000 0000 0000 bit 19
            5. Loop of Abdhaljs fiber total amount can given 5 param 1  -     0000 0000 0001 0000 0000 0000 0000 0000 bit 20
            6. Abdhaljs anima total amount can given 5 param 1  -             0000 0000 0010 0000 0000 0000 0000 0000 bit 21
            7. Vial of Abdhaljs metal total amount can given 5 param 1  -     0000 0000 0100 0000 0000 0000 0000 0000 bit 22
            8. Loop of Abdhaljs fiber total amount can given 5 param 1  -     0000 0000 1000 0000 0000 0000 0000 0000 bit 23
            9. Chunk of Abdhaljs matter total amount can given 5 param 1  -   0000 0001 0000 0000 0000 0000 0000 0000 bit 24
            10. Vial of Abdhaljs metal total amount can given 5 param 1  -    0000 0010 0000 0000 0000 0000 0000 0000 bit 25
            11. Loop of Abdhaljs fiber total amount can given 5 param 1  -    0000 0100 0000 0000 0000 0000 0000 0000 bit 26
            12. Special gobbiedial key total amount can given 1 param 1  -    0000 1000 0000 0000 0000 0000 0000 0000 bit 27
            ]]--
        elseif alternativeOption == 5 then -- this is the update event to option 5, getting a item returns the parameter option not option 5, this is needed to update option 5 with the correct data
            player:updateEvent(player:getCharVar('[AmbusTH]ItemsObtained'), 0, 0, 0, 0, 0, 0, 0)

        elseif alternativeOption == 6 then -- Option 1, 2, 3 sub option 6 Hallmarks
            local hallmarkRewards = hallmarkRewards[itemPage][itemSelected] -- hallmarkRewards table of rewards
                if player:getCurrency('current_hallmarks') >= hallmarkRewards.minimumHallmarksNeeded * amountEntered then -- items already received will not show up in dialog once parameters are set correctly
                    if npcUtil.giveItem(player, { { hallmarkRewards.item, amountEntered } }) then
                        player:delCurrency('current_hallmarks', hallmarkRewards.minimumHallmarksNeeded * amountEntered)
                        addPurchaseAmountHallmark(player, hallmarkRewards, amountEntered)
                        player:updateEvent(player:getCurrency('current_hallmarks')) -- had to use getCurrency() so it would pull the updated currency
                    else
                        player:messageSpecial(zones[xi.zone.MHAURA].text.ITEM_CANNOT_BE_OBTAINED, hallmarkRewards.item )
                    return
                    end
                end

        elseif alternativeOption == 7 then -- Option 5 sub option 7 Total Hallmarks
            local totalHallMarkReward = totalHallmarkRewards[itemPage][itemSelected] -- totalHallmarkRewards table of rewards
                if total_hallmarks >= totalHallMarkReward.totalHallmarksNeeded then -- items alread received will not show up in dialog once parameters are set correctly
                    if npcUtil.giveItem(player, { { totalHallMarkReward.item, totalHallMarkReward.quantity } }) then
                        player:setCharVar('[AmbusTH]ItemsObtained', utils.mask.setBit(player:getCharVar('[AmbusTH]ItemsObtained'), totalHallMarkReward.bitIndex -1, true))
                        player:updateEvent(player:getCharVar('[AmbusTH]ItemsObtained'), totalHallMarkReward.quantity)
                    else
                        player:messageSpecial(zones[xi.zone.MHAURA].text.ITEM_CANNOT_BE_OBTAINED, totalHallMarkReward.item )
                    return
                    end
                end

        -- Present Gallantry menu
        elseif alternativeOption == 8 then -- this is the update event to option 8, getting a item returns the parameter option not option 8, this is needed to update option 8 with the correct data
            local params = packn()

            for i = 1, 8 do
                params[i] = player:getCharVar('[AmubGal]ItemsObtainedParam' .. i)
            end
            params.n = 8  -- important to match argument count

            player:updateEvent(unpackn(params))
            --[[
            param 1
                5898330 = ( 0000 0000 0101 1010 )( 0000 0000 0101 1010)
                       Ordelle bronzepiece    tukuku whiteshells
            param 2
                8192090 = ( 0000 0000 0111 1101 )( 0000 0000 0101 1010 ) 
                           pluton             one byne bill
            param 3 
                29491201 = ( 0000 0001 1100 0010 )( 0000 0000 0000 0001 )
                       piece of alexandrite  vial of umbral marrow
            param 4
                12451965 = ( 0000 0000 1011 1110 )( 0000 0000 0111 1101 )
                         pinch of high purity bayld     chunk of beitetsu
            param 5
                1638401 = ( 0000 0000 0001 1001 )( 0000 0000 0000 0001 ) 
                         plate of heavy metal  chunk of mulcibars scoria
            param 6
                65537 = ( 0000 0000 0000 0001 )( 0000 0000 0000 0001 )
                           pinch of riftcinder     clump of riftdross
            param 7
                1310845 = ( 0000 0000 0001 0100 )( 0000 0000 0111 1101 )  
                          Spool of Abdhaljs thread     riftborn boulder
            param 8
                655380 =  ( 0000 0000 0000 1010 )( 0000 0000 0001 0100 )
                        Bottle of Abdhaljs sap        Pinch of Abdhaljs dust

                Gallantry menu
                page 1 - option 8
                1. tukuku whiteshells total amount can purchase 90
                2. Ordelle bronzepiece total amount can purchase 90
                3. one byne bill total amount can purchase 90
                4. pluton total amount can purchase 125
                5. vial of umbral marrow total amount can purchase 1
                6. piece of alexandrite total amount can purchase 450
                7. chunk of beitetsu total amount can purchase 125
                8. pinch of high purity bayld total amount can purchase 190
                9. chunk of mulcibars scoria total amount can purchase 1
                10. plate of heavy metal total amount can purchase 25
                11. clump of riftdross total amount can purchase 1
                12. pinch of riftcinder total amount can purchase 1
                13. riftborn boulder total amount can purchase 125
                14. Spool of Abdhaljs thread total amount can purchase 20
                15. Pinch of Abdhaljs dust total amount can purchase 20
                16. Bottle of Abdhaljs sap total amount can purchase 10
            ]]--

        elseif alternativeOption == 9 then -- this is the update event to option 9, getting a item returns the parameter option not option 9, this is needed to update option 9 with the correct data
            local params = packn()

            for i = 1, 8 do
                params[i] = player:getCharVar('[AmubGal]ItemsObtainedParam' .. i +8)
            end
            params.n = 8  -- important to match argument count

            player:updateEvent(unpackn(params))

            --[[
            player:updateEvent(param1, param2, param3, param4, param5, param6, param7, param8)

            0000 0000 0000 0101 )( 0000 0000 0000 0101
                              ^                      ^
                              bit 16                bit 0

            param 1
                327685 = ( 0000 0000 0000 0101 )( 0000 0000 0000 0101 )
                       Container of Abdhaljs resin   Pot of Abdhaljs dye
            param 2
                655362 = ( 0000 0000 0000 1010 )( 0000 0000 0000 0010 )
                       Ambuscade chit: footgear +1   Abdhaljs needle
            param 3 
                655370 = ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                       Ambuscade chit: headgear +1   Ambuscade chit: handgear +1
            param 4
                655370 = ( 0000 0000 0000 1010 )( 0000 0000 0000 1010 )
                         Ambuscade chit: bodygear +1     Ambuscade chit: leggear +1
            param 5
                16056321 = ( 0000 0000 1111 0101 )( 0000 0000 0000 0001 ) 
                         Vial of Abdhaljs metal  Ambuscade voucher: weapon 
            param 6
                327925 = ( 0000 0000 0000 0101 )( 0000 0000 1111 0101 )
                           Abdhaljs Nugget         Loop of Abdhaljs fiber
            param 7
                327685 = ( 0000 0000 0000 0101 )( 0000 0000 0000 0101 )  
                          Abdhaljs anima             Abdhaljs gem
            param 8
                5 =  ( 0000 0000 0000 0000 )( 0000 0000 0000 0101 )
                            NONE               Chunk of Abdhaljs matter

                Gallantry menu
                Page 2 - option 9
                1. Pot of Abdhaljs dye total amount can purchase 5
                2. Container of Abdhaljs resin total amount can purchase 5
                3. Abdhaljs needle total amount can purchase 2
                4. Ambuscade chit: footgear +1 total amount can purchase 10
                5. Ambuscade chit: handgear +1 total amount can purchase 10
                6. Ambuscade chit: headgear +1 total amount can purchase 10
                7. Ambuscade chit: leggear +1 total amount can purchase 10
                8. Ambuscade chit: bodygear +1 total amount can purchase 10
                9. Ambuscade voucher: weapon total amount can purchase 1
                10. Vial of Abdhaljs metal total amount can purchase 245
                11. Loop of Abdhaljs fiber total amount can purchase 245
                12. Abdhaljs Nugget total amount can purchase 5
                13. Abdhaljs gem total amount can purchase 5
                14. Abdhaljs anima total amount can purchase 5
                15. Chunk of Abdhaljs matter total amount can purchase 5

            ]]--
        elseif alternativeOption == 10 then -- Option 8, 9 sub option 10 Gallantry
            local gallantryRewards = gallantryRewards[itemPage][itemSelected] -- gallantryRewards table of rewards
                if player:getCurrency('gallantry') >= gallantryRewards.minimumHallmarksNeeded * amountEntered then -- items alread received will not show up in dialog once parameters are set correctly
                    if npcUtil.giveItem(player, { { gallantryRewards.item, amountEntered } }) then
                        player:delCurrency('gallantry', gallantryRewards.minimumHallmarksNeeded * amountEntered)
                        addPurchaseAmountGallantry(player, gallantryRewards, amountEntered)
                        player:updateEvent(player:getCurrency('gallantry')) -- had to use getCurrency() so it would pull the updated currency
                    else
                        player:messageSpecial(zones[xi.zone.MHAURA].text.ITEM_CANNOT_BE_OBTAINED, gallantryRewards.item )
                    return
                    end
                end
        -- Update player
        else
            player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)  
        end
    end
end

entity.onEventFinish = function(player, csid, option, npc)
    local cancel = bit.band(bit.rshift(option, 0), 0xFFFF)

    if csid == 385 then
        xi.roe.onRecordTrigger(player, 499)
    end

    if cancel == 0 then -- canceling out of the trade options
        player:setCharVar('Gorpa-MasorpaTrade', 0)
        return
    end

    if player:getCharVar('Gorpa-MasorpaTrade') == 1 then -- giving items to players after trade
        if npcUtil.giveItem(player, option) then
            player:tradeComplete()
        end

        player:setCharVar('Gorpa-MasorpaTrade', 0)
    end
end

return entity
