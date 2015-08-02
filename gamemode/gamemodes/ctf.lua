DATA.Name = "Capture The Flag"
DATA.TeamBased = true

-- "self" being the DATA table
function DATA.Hooks.MatchStart(self)
	local gm = GM or GAMEMODE or gmod.GetGamemode()

	--[[if gm.FlagSpawns then
		local redFlag = ents.Create(gm.Flag)
		redFlag.team = TEAM_RED
		redFlag:Spawn()
		redFlag:Activate()
		redFlag:Respawn()

		local blueFlag = ents.Create(gm.Flag)
		blueFlag.team = TEAM_RED
		blueFlag:Spawn()
		blueFlag:Activate()
		blueFlag:Respawn()
	end--]]
end

function DATA.Hooks.PlayerInitialSpawn(self, ply)
	ply:ChatPrint("Test.")
end
