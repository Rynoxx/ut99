include("teams.lua")
include("sh_init.lua")
include("weapon_select.lua")

RunConsoleCommand("ut_hud", "1")
RunConsoleCommand("ut_hud_weapons", "1")
RunConsoleCommand("ut_lighting", "1")

hook.Add("SetupMove", "ChangeControls", function(ply, cmd)
	if bit.band(cmd:GetButtons(), IN_SPEED) == IN_SPEED then
		cmd:SetButtons(cmd:GetButtons() - IN_SPEED)

		return true
	end
end)

net.Receive("GamemodeChanged", function(len)
	(GM or GAMEMODE or gmod.GetGamemode()).Gamemode = net.ReadString()
end)

CreateClientConVar( "ut_playermodel", 1, true, true)
CreateClientConVar( "ut_playermodel_skin", 0, true, true)

local hideThese = {
	"CHudWeaponSelection",
	"CHudWeapon"
}

hook.Add("HUDShouldDraw", "HideThings", function(name)
	if hideThese[name] then return false end
end)