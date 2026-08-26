-----------------------------------
-- LevelDown Ambuscade Globals
-----------------------------------
xi = xi or {}
xi.ld_ambuscade = xi.ld_ambuscade or {}

local startingIntenseDifficulty = 119
local startingRegularDifficulty = 109

local intenseHallmarks = { 200, 600, 1200, 2400, 3600 }
local regularHallmarks = { 100, 150,  200,  250,  300 }

local intenseGallantry = { 20, 80, 180, 240, 300 }
local regularGallantry = { 10, 15,  20,  25,  30 }

-----------------------------------
-- CONCURRENCY & AUTO-QUEUE SYSTEM
-----------------------------------
xi.ld_ambuscade.activeInstances = xi.ld_ambuscade.activeInstances or {}
xi.ld_ambuscade.queue           = xi.ld_ambuscade.queue or {}
local MAX_CONCURRENT_INSTANCES   = 3

function xi.ld_ambuscade.getActiveInstanceCount()
    local count = 0
    for id, instanceObj in pairs(xi.ld_ambuscade.activeInstances) do
        if instanceObj and instanceObj:getZone() then
            count = count + 1
        else
            xi.ld_ambuscade.activeInstances[id] = nil
        end
    end
    return count
end

function xi.ld_ambuscade.registerInstance(instance)
    if instance then
        xi.ld_ambuscade.activeInstances[instance:getID()] = instance
        print(string.format("[Ambuscade Tracker] Registered Instance ID: %d | Active: %d/%d",
            instance:getID(), xi.ld_ambuscade.getActiveInstanceCount(), MAX_CONCURRENT_INSTANCES))
    end
end

function xi.ld_ambuscade.unregisterInstance(instance)
    if instance and instance:getID() then
        xi.ld_ambuscade.activeInstances[instance:getID()] = nil
        print(string.format("[Ambuscade Tracker] Unregistered Instance ID: %d | Active: %d/%d",
            instance:getID(), xi.ld_ambuscade.getActiveInstanceCount(), MAX_CONCURRENT_INSTANCES))
        
        -- Trigger next party in queue
        xi.ld_ambuscade.processQueue()
    end
end

function xi.ld_ambuscade.addToQueue(player, diff, volume)
    -- Check for duplicate entry in queue
    for pos, entry in ipairs(xi.ld_ambuscade.queue) do
        if entry.playerId == player:getID() then
            player:printToPlayer(string.format("You are already in queue at Position #%d.", pos), xi.msg.channel.SYSTEM_3)
            return
        end
    end

    table.insert(xi.ld_ambuscade.queue, {
        player   = player,
        playerId = player:getID(),
        diff     = diff,
        volume   = volume,
    })

    local pos = #xi.ld_ambuscade.queue
    player:printToPlayer(string.format("All arenas occupied (3/3). You were added to the queue! Position: #%d", pos), xi.msg.channel.SYSTEM_3)
    player:printToPlayer("Please stay in Mhaura. You will be automatically warped when an arena opens.", xi.msg.channel.SYSTEM_3)
    print(string.format("[Ambuscade Queue] Queued %s at Position #%d (Diff: %d | Vol: %d)", player:getName(), pos, diff, volume))
end

function xi.ld_ambuscade.processQueue()
    if xi.ld_ambuscade.getActiveInstanceCount() >= MAX_CONCURRENT_INSTANCES then
        return
    end

    while #xi.ld_ambuscade.queue > 0 do
        local entry  = table.remove(xi.ld_ambuscade.queue, 1)
        local player = entry.player

        -- Validate player is still online and in Mhaura
        if player and player:getZoneID() == xi.zone.MHAURA then
            player:setLocalVar("ambuscade_selected_diff", entry.diff)
            player:setLocalVar("ambuscade_selected_volume", entry.volume)

            player:printToPlayer("An Ambuscade arena is now available! Transporting party...", xi.msg.channel.SYSTEM_3)
            print(string.format("[Ambuscade Queue] Processing Queue Entry for %s (Diff: %d)", player:getName(), entry.diff))

            player:createInstance(40003)
            break
        else
            print(string.format("[Ambuscade Queue] Skipped %s (Left zone or logged off)", entry.player and entry.player:getName() or "Unknown"))
        end
    end
end

-----------------------------------
-- Gorpa-Masorpa
-----------------------------------
xi.ld_ambuscade.onTradeGorpaMasorpa = function(player, npc, trade)
    if player:getEminenceCompleted(499) then
        -- Custom Trade Logic
    end
end

xi.ld_ambuscade.onTriggerGorpaMasorpa = function(player, npc)
    if player:getEminenceCompleted(499) then
        local mainMenuOptions = 0
        local currentHallmarks = player:getCurrency('current_hallmarks')
        local totalHallmarks   = player:getCurrency('total_hallmarks')
        local gallantry        = player:getCurrency('gallantry')

        player:startEvent(386, mainMenuOptions, currentHallmarks, totalHallmarks, 0, 8, gallantry, 0, 0)
    else
        if player:getEminenceProgress(499) then
            player:startEvent(385)
        else
            player:startEvent(384)
        end
    end
end

xi.ld_ambuscade.onEventUpdateGorpaMasorpa = function(player, csid, option, npc)
    if csid == 386 then
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end
end

xi.ld_ambuscade.onEventFinishGorpaMasorpa = function(player, csid, option, npc)
    if csid == 385 then
        xi.roe.onRecordTrigger(player, 499)
    end
end

-----------------------------------
-- Ambuscade Tome
-----------------------------------
xi.ld_ambuscade.onTradeTome = function(player, npc, trade)
end

xi.ld_ambuscade.onTriggerTome = function(player, npc)
    local menuOptions = 8
    local currentPage = 735

    player:setLocalVar("ambuscade_selected_diff", 0)
    player:setLocalVar("ambuscade_selected_volume", 0)

    player:startEvent(374, menuOptions, startingIntenseDifficulty, startingRegularDifficulty, currentPage, 5, 0, 0, 0)
end

xi.ld_ambuscade.onEventUpdateTome = function(player, csid, option, npc)
    if csid == 374 then
        player:updateEvent(0, 0, 0, 0, 0, 0, 0, 0)
    end
end

xi.ld_ambuscade.onEventFinishTome = function(player, csid, option, npc)
    if csid == 374 then
        local rawChoice = bit.band(option, 0xFF)
        if rawChoice == 0 then rawChoice = option end

        if rawChoice >= 1 and rawChoice <= 10 then
            local isRegular = rawChoice > 5
            local subOpt    = isRegular and (rawChoice - 5) or rawChoice

            local diff   = 6 - subOpt
            local volume = isRegular and 2 or 1

            -- CHECK INSTANCE CAPACITY: Add to queue if 3/3 active
            if xi.ld_ambuscade.getActiveInstanceCount() >= MAX_CONCURRENT_INSTANCES then
                xi.ld_ambuscade.addToQueue(player, diff, volume)
                return
            end

            player:setLocalVar("ambuscade_selected_diff", diff)
            player:setLocalVar("ambuscade_selected_volume", volume)

            print(string.format("[Ambuscade Launch] Choice %d -> Difficulty Level: %d | Volume: %d", rawChoice, diff, volume))

            player:createInstance(40003)
        end
    end
end

-----------------------------------
-- Instance Completion & Failure
-----------------------------------
xi.ld_ambuscade.onInstanceComplete = function(instance)
    xi.ld_ambuscade.unregisterInstance(instance)

    if instance:getLocalVar("rewards_given") == 1 then return end
    instance:setLocalVar("rewards_given", 1)

    local chars      = instance:getChars()
    local numChars   = #chars
    local difficulty = instance:getLocalVar("difficulty")
    local volume     = instance:getLocalVar("volume")
    if not difficulty or difficulty == 0 then difficulty = 1 end

    local hallmarksTable = (volume == 2) and regularHallmarks or intenseHallmarks
    local gallantryTable = (volume == 2) and regularGallantry or intenseGallantry

    for _, player in pairs(chars) do
        local sealMultiplier = 1
        if player:hasStatusEffect(xi.effect.ABDHALJS_SEAL) then
            sealMultiplier = 2
            player:delStatusEffect(xi.effect.ABDHALJS_SEAL)
            player:printToPlayer("Abdhaljs Seal consumed! Rewards doubled.", xi.msg.channel.SYSTEM_3)
        end

        local baseHallmarks   = hallmarksTable[difficulty] or 200
        local hallmarksEarned = baseHallmarks * sealMultiplier

        player:addCurrency('current_hallmarks', hallmarksEarned)
        player:addCurrency('total_hallmarks', hallmarksEarned)
        player:printToPlayer(string.format("Obtained %d Hallmarks!", hallmarksEarned), xi.msg.channel.SYSTEM_3)

        if numChars > 1 then
            local baseGallantry   = gallantryTable[difficulty] or 20
            local gallantryEarned = baseGallantry * (numChars - 1) * sealMultiplier

            player:addCurrency('gallantry', gallantryEarned)
            player:printToPlayer(string.format("Obtained %d Gallantry!", gallantryEarned), xi.msg.channel.SYSTEM_3)
        end

        player:printToPlayer("Ambuscade clear! Evacuating battlefield in 20 seconds...", xi.msg.channel.SYSTEM_3)

        player:timer(20000, function(p)
            if p and p:getZoneID() == xi.zone.MAQUETTE_ABDHALJS_LEGION_B then
                p:setPos(-34.2, -16, 58, 32, xi.zone.MHAURA)
            end
        end)
    end
end

xi.ld_ambuscade.onInstanceFailure = function(instance)
    xi.ld_ambuscade.unregisterInstance(instance)

    local chars = instance:getChars()
    for _, player in pairs(chars) do
        player:printToPlayer("Instance failed! Evacuating battlefield in 10 seconds...", xi.msg.channel.SYSTEM_3)

        player:timer(10000, function(p)
            if p and p:getZoneID() == xi.zone.MAQUETTE_ABDHALJS_LEGION_B then
                p:setPos(-34.2, -16, 58, 32, xi.zone.MHAURA)
            end
        end)
    end
end