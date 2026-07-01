-----------------------------------
-- Drops Allied Notes
-----------------------------------
require('modules/module_utils')

g_mixins = g_mixins or {}

g_mixins.drop_allied_notes = function(mob)
    mob:addListener('DEATH', 'ALLIED_MOB_DEATH', function(mob, player)
        if player and (player:isPet() or player:isTrust()) then
            player = player:getMaster()
        end

        if player and player:isPC() then
            local modifier = 12 * player:checkDifficulty(mob)
            local alliance = player:getAlliance()
            if modifier > 0 then
                for _, member in pairs(alliance) do
                    if member:hasStatusEffect(xi.effect.SIGIL) and member:getZoneID() == mob:getZoneID() then
                        member:addCurrency('allied_notes', modifier)
                        member:printToPlayer(string.format('You obtained %d Allied Notes.', modifier), xi.msg.channel.SYSTEM_3))
                    end
                end
            end
        end
    end)
end

return g_mixins.drop_allied_notes