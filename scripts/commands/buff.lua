---------------------------------------------------------------------------------------------------
-- func: Regen
-- desc: Toggles Regen and Refresh on the player, granting them several special abilities.
---------------------------------------------------------------------------------------------------
local commandObj = {}

commandObj.cmdprops =
{
    permission = 0,
    parameters = ""
}

commandObj.onTrigger = function(player)
    if (player:getCharVar("Regen") == 0) then
        -- Toggle Regen on..
        player:setCharVar("Regen", 1)
		
        -- Add bonus effects to the player..
		player:addStatusEffect(xi.effect.REGAIN,    { power = 1, duration = 0, origin = player })
        player:addStatusEffect(xi.effect.REGEN,     { power = 4, duration = 0, origin = player })
        player:addStatusEffect(xi.effect.REFRESH,   { power = 4, duration = 0, origin = player })
        player:addStatusEffect(xi.effect.HASTE,     { power = 5, duration = 0, origin = player })
        player:addStatusEffect(xi.effect.COMPOSURE, { power = 1, duration = 0, origin = player })
        player:setMod(249, 350 )
        player:setMod(579, 350 )
		
		-- Add bonus mods..
        player:addMod(xi.mod.RACC, 10)
        player:addMod(xi.mod.RATT, 10)
        player:addMod(xi.mod.ACC, 10)
        player:addMod(xi.mod.ATT, 10)
        player:addMod(xi.mod.MATT, 10)
        player:addMod(xi.mod.MACC, 10)
        player:addMod(xi.mod.RDEF, 10)
        player:addMod(xi.mod.DEF, 10)
        player:addMod(xi.mod.MDEF, 10)
		
	else
        -- Toggle Regen off..
        player:setCharVar("Regen", 0)

        -- Remove bonus effects..
        player:delStatusEffect(xi.effect.REGAIN)
        player:delStatusEffect(xi.effect.REFRESH)
        player:delStatusEffect(xi.effect.REGEN)
		player:delStatusEffect(xi.effect.HASTE)
		player:delStatusEffect(xi.effect.COMPOSURE)
		-- Remove bonus mods..
        player:delMod(xi.mod.RACC, 10)
        player:delMod(xi.mod.RATT, 10)
        player:delMod(xi.mod.ACC, 10)
        player:delMod(xi.mod.ATT, 10)
        player:delMod(xi.mod.MATT, 10)
        player:delMod(xi.mod.MACC, 10)
        player:delMod(xi.mod.RDEF, 10)
        player:delMod(xi.mod.DEF, 10)
        player:delMod(xi.mod.MDEF, 10)

    end
end
return commandObj