
AddCSLuaFile()

ENT.PrintName = "Flag"
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category = "Unreal Tournament"

local function AttachEntToBone(ply, attachment, strbone, vecboneoffset, angboneoffset)

	local boneindex = ply:LookupAttachment( strbone );
	local vecang = ply:GetAttachment( boneindex );
	local vecorigin, angorigin = vecang.Pos, vecang.Ang
	attachment:SetPos( vecorigin + vecboneoffset );
	attachment:SetAngles( angorigin + angboneoffset );
	attachment:SetParent(ply);
    attachment:Fire("setparentattachmentmaintainoffset", strbone, 0.01)
end

function ENT:Initialize()
	self:OnSpawn()
end

function ENT:OnSpawn()
	self.team = self.team or TEAM_RED
	self:SetModel("models/items/ut99/flag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self.boneList = { 0, 1, 2, 3, 4, 5, 6, 7, 8 }
	self.sinNum = 0
	self.sinStep = 1
	self.maxAng = 30

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

	local mins, maxs = self:GetModelBounds()

	self.pickedup = true
	AttachEntToBone(toucher, self, "chest", (toucher:GetForward() * -16) + Vector(0, 0, -(mins.z + maxs.z) * 0.5), Angle(0, 0, 0))
	self:SetSolid(SOLID_NONE)
	--[[self:SetParent(toucher, toucher:LookupAttachment( "chest" ))
	self:SetAngles(Angle(0, 0, 0))
	self:SetPos(toucher:LocalToWorld(Vector(0, -16, 0)))--]]
end

function ENT:Drop()
	self.pickedup = false
	self:SetSolid(SOLID_VPHYSICS)
	self:SetParent()

	self:SetAngles(Angle(0, 0, 0))
	self:DropToFloor()
end

function ENT:Return()
	if CLIENT then return end

	self:Drop()
	local teamStr = (self.team == TEAM_BLUE and "blue") or "red"
	self:SetPos(gmod.GetGamemode().FlagSpawns[teamStr])
end

if SERVER then
	function ENT:Think()
		if self.pickedup and IsValid(self:GetParent()) and !self:GetParent():Alive() then
			self:Drop()
		end

		if self.pickedup and !IsValid(self:GetParent()) then
			self:Drop()
		end

		if !self.pickedup then
			self:DropToFloor()
		end
	end
else
	function ENT:Draw()
		self.sinNum = (self.sinNum + (self.sinStep * RealFrameTime()))

		for i = 1, #self.boneList do
			local num = self.sinNum--(self.sinNum + (i * RealFrameTime()))

			if i % 2 == 0 then
				--num = -num
			end

			self:ManipulateBoneAngles(self.boneList[i], Angle(math.sin(num) * self.maxAng, 0, 0))
		end

		self:DrawModel()
	end
end
