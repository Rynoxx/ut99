include("teams.lua")
include("sh_init.lua")
AddCSLuaFile("teams.lua")
AddCSLuaFile("sh_init.lua")

util.AddNetworkString("GamemodeChanged")
util.AddNetworkString("PlayerInitialized")

resource.AddWorkshop("255053951") -- UT99 PlayerModels
resource.AddWorkshop("422221058") -- Unreal Tournament Music
resource.AddWorkshop("189453748") -- Unreal Tournament SWEPs

CreateConVar( "ut_gamemode", "ctf", bit.bor(FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE, FCVAR_UNLOGGED), "Which gamemode should the server run?" )

GM.Gamemode = GetConVarString("ut_gamemode")

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
		net.WriteString(self.Gamemode or "")
	net.Send(ply or player.GetHumans())
end

function GM:PlayerInitialSpawn(ply)

	net.Start("PlayerInitialized")
	net.Send(ply)

	self:SendGamemode()
end

game.ConsoleCommand("ut_gamemode ctf\n")

function GM:PlayerLoadout(ply)
	ply:SetModel(self.PlayerModels[ply:GetInfoNum("ut_playermodel", 1)])
	ply:SetSkin(ply:GetInfoNum("ut_playermodel_skin", 0))
	ply:StripWeapons()
	ply:StripAmmo()

	ply:SetWalkSpeed(self.PlayerSpeed)
	ply:SetRunSpeed(self.PlayerSpeed)

	if string.find(self.Gamemode, "instagib") then
		ply:Give(self.Weapons.instagib)
	else
		ply:Give(self.Weapons.hammer)
	end

	if self.Gamemode == "tdm" or self.Gamemode == "ctf" then
		ply:Give(self.Weapons.teleporter)
	end
end

timer.Simple(0.5, function()
	hook.Add("Think", "StartMatch", function()
		if table.Count(player.GetHumans()) > 0 then
			hook.Call("MatchStart")
			hook.Remove("Think", "StartMatch")
		end
	end)
end)