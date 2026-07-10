-----------------------------------
-- func: ah
-- desc: opens the Auction House menu anywhere in the world
-----------------------------------
local commandObj = {}

commandObj.cmdprops =
{
    permission = 0,
    parameters = ''
}

commandObj.onTrigger = function(player)
    -- LOCKOUT: Traditional Path Banned From Remote Auction House access
    if player:getCharVar("Ratio") == 1 then
        player:printToPlayer("Nice try, but this won't work! Traditionalists must visit an authentic town Auction House.", xi.msg.channel.SYSTEM_3)
        return
    end

    player:sendMenu(3)
end

return commandObj