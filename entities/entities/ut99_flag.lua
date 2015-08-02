
AddCSLuaFile()

ENT.PrintName = "Flag"
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Unreal Tournament"

function ENT:Initialize()
	self:OnSpawn()
end

function ENT:OnSpawn()
	self.team = self.team or TEAM_RED
	self:SetModel("models/items/ut99/flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:SetTrigger(true)
	end
	
	local pObject = self:GetPhysicsObject()
	
	if (IsValid( pObject )) then
		pObject:Wake()
	end

	local gm = gmod.GetGamemode()

	if !gm.FlagSpawns then
		gm.FlagSpawns = {}		
	end

	local teamStr = (self.team == TEAM_BLUE and "blue") or "red"

	if !gm.FlagSpawns[teamStr] then
		gm.FlagSpawns[teamStr] = self:GetPos()
	end

	if self.team == TEAM_BLUE then
		self:SetSkin(1)
	end
end

function ENT:Touch( toucher )
	if CLIENT then return end
	if !toucher:IsPlayer() then return false end
	if self.pickedup then return end

	if toucher:Team() == self.team then
		self:Return()

		return
	end

	self.pickedup = true
	self:SetParent(toucher)
	self:SetSolid(SOLID_NONE)
end

function ENT:Drop()
	if CLIENT then return end
	self.pickedup = false
	self:SetSolid(SOLID_VPHYSICS)
	self:SetParent()
	self:DropToFloor()
end

function ENT:Return()
	if CLIENT then return end

	local teamStr = (self.team == TEAM_BLUE and "blue") or "red"
	self:SetSolid(SOLID_VPHYSICS)
	self:SetPos(gmod.GetGamemode().FlagSpawns[teamStr])
	self:DropToFloor()
end
