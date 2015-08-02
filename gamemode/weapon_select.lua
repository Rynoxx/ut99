local alias = {
	[1] = "weapon_ut99_impacthammer",
	[2] = "weapon_ut99_translocator",
	[3] = "weapon_ut99_enforcer",
	[4] = "weapon_ut99_dualenforcers",
	[5] = "weapon_ut99_biorifle",
	[6] = "weapon_ut99_shock",
	[7] = "weapon_ut99_pulsegun",
	[8] = "weapon_ut99_ripper",
	[9] = "weapon_ut99_minigun",
	[10] = "weapon_ut99_flak",
	[11] = "weapon_ut99_eight",
	[12] = "weapon_ut99_rifle",
	[13] = "weapon_ut99_redeemer"
}

if(CLIENT) then
	local select = {"slot1", "slot2", "slot3", "slot4", "slot5", "slot6"}
	
	local keys = {
		{key = KEY_1, pushed = false, weps = {1, 2}},
		{key = KEY_2, pushed = false, weps = {3, 4}},
		{key = KEY_3, pushed = false, weps = {5}},
		{key = KEY_4, pushed = false, weps = {6}},
		{key = KEY_5, pushed = false, weps = {7}},
		{key = KEY_6, pushed = false, weps = {8}},
		{key = KEY_7, pushed = false, weps = {9}},
		{key = KEY_8, pushed = false, weps = {10}},
		{key = KEY_9, pushed = false, weps = {11}},
		{key = KEY_0, pushed = false, weps = {12, 13}}
	}
	
	local currentWeapon = 1

	if IsValid(LocalPlayer()) then
		 table.KeyFromValue(alias, LocalPlayer():GetActiveWeapon():GetClass())
	end

	print(currentWeapon)
	
	local function CanEquip(swep)
		return swep:Ammo1() + swep:Clip1() + 1 > 0 || swep.Primary.Ammo == "none"
	end
	
	local function keyPress(ply, bind, pressed)
		if !pressed then
			return
		end

		for k,v in pairs(select) do
			if(string.find(bind, v)) then
				return true
			end
		end

		if(string.find(bind, "invprev")) then
			for i = 1, #alias do
				if(currentWeapon < #alias) then
					currentWeapon = currentWeapon + 1	
				else
					currentWeapon = 1
				end
				
				local swep = LocalPlayer():GetWeapon(alias[currentWeapon])
				if(!IsValid(swep) or !CanEquip(swep)) then
					continue
				end
				
				net.Start("SelectWeapon")
					net.WriteInt(currentWeapon, 8)
				net.SendToServer()
				
				break
			end
			
			return true
		end

		if(string.find(bind, "invnext")) then
			for i = 1, #alias do
				if(currentWeapon > 1) then
					currentWeapon = currentWeapon - 1	
				else
					currentWeapon = #alias
				end
				
				local swep = LocalPlayer():GetWeapon(alias[currentWeapon])
				if(!IsValid(swep) or !CanEquip(swep)) then
					continue
				end
				
				net.Start("SelectWeapon")
					net.WriteInt(currentWeapon, 8)
				net.SendToServer()
				
				break
			end
			
			return true
		end
	end
	
	hook.Add("PlayerBindPress", "BindPress", keyPress)
	
	hook.Add("Think", "BindPress", function(ply, mv)
		for k,v in pairs(keys) do
			if(input.IsKeyDown(v.key)) then
				if(v.pushed) then continue end

				v.pushed = true
				
				local class = v.weps[1]

				local swep = LocalPlayer():GetWeapon(alias[v.weps[1]])
				if(!IsValid(swep) or LocalPlayer():GetActiveWeapon() == swep) then
					if(#v.weps > 1) then
						swep = LocalPlayer():GetWeapon(alias[v.weps[2]])
					end
				
					if(!IsValid(swep) or !v.weps[2]) then
						break
					end

					class = v.weps[2]
				end

				net.Start("SelectWeapon")
					net.WriteInt(class, 8)
				net.SendToServer()
				
				break
			else
				v.pushed = false
			end
		end
	end)

	hook.Add( "HUDShouldDraw", "HideThings", function( name )
		if(name == "CHudWeaponSelection") then
			return false
		end
	end)
	
else
	util.AddNetworkString( "SelectWeapon" )
	
	net.Receive("SelectWeapon", function(data, ply)
		local weapon = net.ReadInt(8)
		
		ply:SelectWeapon(alias[weapon])
	end)
end
