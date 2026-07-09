-----------------------------------
xi = xi or {}
xi.combat = xi.combat or {}
xi.combat.treasureHunter = xi.combat.treasureHunter or {}
-----------------------------------

-- https://forum.square-enix.com/ffxi/threads/56550
xi.combat.treasureHunter.treasureHunterTable =
{
-- TH lvl    VC    C     UC    R     VR    SR   UR
    [ 0] = { 2400, 1500, 1000,  500,  100,  50,  10 },
    [ 1] = { 4800, 3000, 1200,  600,  150,  75,  20 },
    [ 2] = { 5600, 4000, 1500,  700,  200, 100,  30 },
    [ 3] = { 6000, 4250, 1650,  750,  225, 120,  35 },
    [ 4] = { 6400, 4500, 1800,  800,  250, 140,  40 },
    [ 5] = { 6666, 4750, 1900,  850,  300, 160,  45 },
    [ 6] = { 6800, 5000, 2000,  900,  350, 180,  50 },
    [ 7] = { 6900, 5250, 2100,  950,  400, 200,  60 },
    [ 8] = { 7050, 5500, 2250, 1050,  475, 230,  70 },
    [ 9] = { 7200, 5750, 2400, 1150,  550, 260,  80 },
    [10] = { 7350, 6000, 2650, 1250,  650, 300,  90 },
    [11] = { 7400, 6250, 2800, 1350,  750, 350, 100 },
    [12] = { 7600, 6500, 2950, 1550,  825, 400, 115 },
    [13] = { 7800, 6750, 3100, 1750,  900, 450, 130 },
    [14] = { 8000, 7000, 3250, 2000, 1000, 500, 150 },
	[15] = { 8200, 7250, 3400, 2100, 1100, 550, 160 },
    [16] = { 8400, 7500, 3550, 2200, 1200, 600, 170 },
    [17] = { 8600, 7750, 3700, 2300, 1300, 650, 180 },
    [18] = { 8800, 8000, 3850, 2400, 1400, 700, 190 },
    [19] = { 9000, 8250, 4000, 2500, 1500, 750, 200 },
    [20] = { 9200, 8500, 4150, 2600, 1600, 800, 210 },
    [21] = { 9400, 8750, 4300, 2700, 1700, 850, 220 },
    [22] = { 9550, 9000, 4450, 2800, 1800, 900, 230 },
    [23] = { 9700, 9250, 4600, 2900, 1900, 950, 240 },
    [24] = { 9850, 9500, 4750, 3000, 2000, 1000, 250 },
    [25] = {10000, 9750, 4900, 3100, 2100, 1050, 260 },
}

xi.combat.treasureHunter.dropBracketTable =
{
    [1] = { 2400 },
    [2] = { 1500 },
    [3] = { 1000 },
    [4] = {  500 },
    [5] = {  100 },
    [6] = {   50 },
    [7] = {    0 }, -- Set to 0, for weird cases in DB.
}

xi.combat.treasureHunter.getDropRate = function(thLevel, dropRate)
    -- Sanitize parameters
    local thTier     = utils.defaultIfNil(thLevel, 0)
    local thDropRate = utils.defaultIfNil(dropRate, 0)

    thTier     = utils.clamp(thTier, 0, 14)
    thDropRate = utils.clamp(thDropRate, 0, 10000)

    -- Early returns: Drop is guaranteed or non-existant.
    if thDropRate == 10000 then
        return 10000
    elseif thDropRate == 0 then
        return 0
    end

    -- Calculate original drop rate bracket.
    local thBracket = 0

    for i = 1, #xi.combat.treasureHunter.dropBracketTable do
        if thDropRate >= xi.combat.treasureHunter.dropBracketTable[i][1] then
            thBracket = i

            break
        end
    end

    -- Calculate TH drop rate
    local newDropRate = xi.combat.treasureHunter.treasureHunterTable[thTier][thBracket]

    return newDropRate
end
