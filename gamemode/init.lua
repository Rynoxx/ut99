include("teams.lua")
include("sh_init.lua")
AddCSLuaFile("teams.lua")
AddCSLuaFile("sh_init.lua")

util.AddNetworkString("GamemodeChanged")
util.AddNetworkString("PlayerInitialized")

CreateConVar( "ut_gamemode", "ctf", bit.bor, "Which gamemode should the server run?" )

game.ConsoleCommand("mp_falldamage 1\n")

cvars.AddChangeCallback("ut_gamemode", function(cvar, old, new)
	local gm = (GM or GAMEMODE or gmod.GetGamemode())

	if gm.Gamemodes[new] then
		gm.Gamemode = new
		gm:SendGamemode()
	end
end)

// Uses the default values from Source
function MPFallDamage( ply, vel )
	if GetConVarNumber("mp_falldamage") == 1 then
		vel = vel - 580
		return vel*(100/(1024-580))
	end
	return 10
end
hook.Add( "GetFallDamage", "MPFallDamage", MPFallDamage )

function GM:SendGamemode(ply)
	net.Start("GamemodeChanged")
		net.WriteString(self.Gamemode)
	net.Send(ply or player.GetHumans())
end

function GM:PlayerInitialSpawn(ply)

	net.Start("PlayerInitialized")
	net.Send(ply)

	self:SendGamemode()
end

function GM:PlayerLoadout(ply)
	ply:StripWeapons()
	ply:StripAmmo()

	ply:SetWalkSpeed(GM.PlayerSpeed)
	ply:SetRunSpeed(GM.PlayerSpeed)

	if string.find(GM.Gamemode, "instagib") then
		ply:Give(self.Weapons.hammer)
	else

	end

	if GM.Gamemode == "tdm" or GM.Gamemode == "ctf" then
		ply:Give(self.Weapons.teleporter)
	end
end