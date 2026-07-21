-----------------------------------
-- func: capallskills
-- desc: Caps all the players skills (or a specified target player).
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = 's' -- 👈 Modified to accept a string parameter (playername)
}

commandObj.onTrigger = function(player, targetName)
    local target = player

    -- 🔍 Check if a player name parameter was passed
    if targetName and targetName ~= "" then
        target = GetPlayerByName(targetName)
        
        -- 🛑 Break out if the requested player can't be found online
        if not target then
            player:printToPlayer(string.format("Player '%s' could not be found online.", targetName))
            return
        end
    end

    -- ✨ Execute skill capping on the validated target
    target:capAllSkills()

    local automatonSkills =
    {
        xi.skill.AUTOMATON_MELEE,
        xi.skill.AUTOMATON_RANGED,
        xi.skill.AUTOMATON_MAGIC,
    }

    for _, skillId in ipairs(automatonSkills) do
        target:setSkillLevel(skillId, 5000)
    end

    -- 💬 Contextual notifications depending on who was targeted
    if target == player then
        player:printToPlayer('All your skills have been capped!')
    else
        target:printToPlayer('All your skills have been capped by an administrator!')
        player:printToPlayer(string.format("Successfully capped all skills for %s.", target:getName()))
    end
end

return commandObj
