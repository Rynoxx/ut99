
AddCSLuaFile()

ENT.PrintName = "Flag (Red)"
ENT.Base = "ut99_flag"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Unreal Tournament"

function ENT:Initialize()
	self.team = TEAM_RED
	self:OnSpawn()

	-- Maybe some blue specific things here.
end

--[[
function ENT:Touch( toucher )
	if (!toucher:IsPlayer()) then return false end
	if self.pickedup then return end

	if toucher:Team() == self.team then
		self:Return()
	end
end

function ENT:Drop()
	self.pickedup = false
	self:SetParent()
	self:DropToFloor()
end

function ENT:Return()
	if self.team == TEAM_RED then
		self:SetPos(gmod.GetGamemode().FlagSpawns["red"])
		self:DropToFloor()
	elseif self.team == TEAM_BLUE then
		self:SetPos(gmod.GetGamemode().FlagSpawns["blue"])
		self:DropToFloor()
	end
end
--]]
