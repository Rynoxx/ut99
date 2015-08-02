
local map = game.GetMap()

if file.Exists(GM.FolderName .. "/gamemode/maps/" .. map, "lua") then
	include(GM.FolderName .. "/gamemode/maps/" .. map)
end

GM.Gamemodes = {
	--[[
	["ctf"] = "Capture The Flag",
	["tdm"] = "Team DeathMatch",
	["ffa"] = "Free For All",
	["instagib_tdm"] = "Instagib Team DeathMatch",
	["instagib_ffa"] = "Instagib Free For All",
	["as"] = "Assault",
	--]]
}

GM.Maps = {}

local maps, folders = file.Find(GM.FolderName .. "/gamemode/gamemodes/*.lua", "LUA")

for k, v in pairs(maps) do
	table.insert(GM.Maps, string.Replace(v, ".lua", ""))
end

function GM:RegisterGamemode(DATA)
	self.Gamemodes[DATA.id] = DATA
end

local files, folders = file.Find(GM.FolderName .. "/gamemode/gamemodes/*.lua", "LUA")

for k, v in pairs(files) do
	DATA = {id = string.Replace(v, ".lua", ""), Hooks = {}}

	include(GM.FolderName .. "/gamemode/gamemodes/" .. v)

	if SERVER then
		AddCSLuaFile(GM.FolderName .. "/gamemode/gamemodes/" .. v)
	end

	GM:RegisterGamemode(DATA)

	DATA = nil
end

hook.OldCall = hook.OldCall or hook.Call

--[[
	Function: hook.Call
	Replaces the default hook.Call
	Allows us to call Plugin hooks, Schema hooks and all those goodies

	Parameters:
		name - The unique name for the hook to call
		gamemode - The table to call the last hook from (if none is returned)
		... - All the other arguments passed

	Returns:
		mixed - Whatever the hook(s) returns.

	See Also: 
		<http://wiki.garrysmod.com/page/hook/Call>
]]
function hook.Call(name, gamemode, ...)
	if name == "PlayerSpawn" then
		local arguments = {...}
		local client = arguments[1]

		if !IsValid(client) --[[or (IsValid(client) and !client:GetPSWData("character_tbl", nil))--]] then
			return
		end
	end

	local gm = GAMEMODE.Gamemodes[GAMEMODE.Gamemode]

	if gm then
		if gm.Hooks then
			if gm.Hooks[name] and type(gm.Hooks[name]) == "function" then
				local result = gm.Hooks[name](gm, ...)

				if result != nil then
					return result
				end
			end
		end
	end

	return hook.OldCall(name, gamemode, ...)
end
 
GM.Weapons = { -- This is mainly so that the weapons can easily be swapped out for anything else, or a fixed version
	["teleporter"] = "weapon_ut99_translocator",
	["hammer"] = "weapon_ut99_impacthammer",
	["enforcer"] = "weapon_ut99_enforcer",
	["biorifle"] = "weapon_ut99_biorifle",
	["shockrifle"] = "weapon_ut99_shock",
	["pulsegun"] = "weapon_ut99_pulsegun",
	["ripper"] = "weapon_ut99_ripper",
	["minigun"] = "weapon_ut99_minigun",
	["flakcannon"] = "weapon_ut99_flak",
	["rocketlauncher"] = "weapon_ut99_eight",
	["sniper"] = "weapon_ut99_rifle",
	["redeemer"] = "weapon_ut99_redeemer",
	["instagib"] = "weapon_ut99_instagib"
}

GM.Items = {
	["jumpboots"] = "ut99_jumpboots",
	["udamage"] = "ut99_udamage",
	["health100"] = "ut99_health_box",
	["health20"] = "ut99_health_medkit",
	["health5"] = "ut99_health_vial",
	["armor"] = "ut99_armor",
	["shieldbelt"] = "ut99_shieldbelt",
	["thighpads"] = "ut99_thighpads",
	["shockrifle_spawn"] = "ut99_pickup_shock",
	["biorifle_spawn"] = "ut99_pickup_biorifle",
	["flakcannon_spawn"] = "ut99_pickup_flak",
	["minigun_spawn"] = "ut99_pickup_minigun",
	["pulsegun_spawn"] = "ut99_pickup_pulsegun",
	["redeemer_spawn"] = "ut99_pickup_redeemer",
	["ripper_spawn"] = "ut99_pickup_ripper",
	["rocketlauncher_spawn"] = "ut99_pickup_rocket",
	["sniper_spawn"] = "ut99_pickup_rifle"
}

GM.Flag = "ut99_flag"

GM.PlayerSpeed = 400 -- The speed of the player, walking and running will be the same speed.

GM.PlayerModels = {
	"models/ut/commando.mdl",
	"models/ut/commandofemale.mdl",
	"models/ut/soldier.mdl",
	"models/ut/soldierfemale.mdl"
}

