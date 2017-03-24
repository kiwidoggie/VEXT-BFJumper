-- local MyClass = require 'MyFolder/MyClass'
class 'BFJumperClient'

function BFJumperClient:__init()
	self.m_Hook = Hooks:Install("Input:PreUpdate", 999, self.OnUpdateInput)
	
	self.m_MeleeTime = 0.01
	self.m_ReloadTime = 0.01
end

function BFJumperClient:OnUpdateInput(p_Cache, p_DeltaTime)
	local s_Saving = p_Cache[math.floor(InputConceptIdentifiers.ConceptMeleeAttack) + 1]
	local s_Loading = p_Cache[math.floor(InputConceptIdentifiers.ConceptReload) + 1]
	
	print(self.m_MeleeTime)
	print(self.m_ReloadTime)
	
	if s_Saving > 0.0 then
		self.m_MeleeTime = self.m_MeleeTime + p_Delta
	end
	
	if s_Loading > 0.0 then
		self.m_ReloadTime = self.m_ReloadTime + p_Delta
	end
	
	-- Handle Saving
	if self.m_MeleeTime > 1.5 then
		local s_SaveSent = self:RequestSave()
		if s_SaveSent == true then
			print("Save Requested")
		end
		
		self.m_MeleeTime = 0.01
	end
	
	if self.m_ReloadTime > 1.5 then
		local s_LoadSent = self:RequestLoad()
		if s_LoadSent == true then
			print("Load Requested")
		end
		
		self.m_ReloadTime = 0.01
	end
end

function BFJumperClient:RequestSave()
	local s_Player = PlayerManager:GetLocalPlayer()
	if s_Player == nil then
		return false
	end
	
	local s_Soldier = s_Player.soldier
	if s_Soldier == nil then
		return false
	end
	
	local s_Transform = s_Soldier.transform
	
	NetEvents:SendLocal('bfjumper:save', s_Transform.trans.x, s_Transform.trans.y, s_Transform.trans.z)
	
	return true
end

function BFJumperClient:RequestLoad()
	NetEvents:SendLocal('bfjumper:load')
	
	return true
end

g_BFJumperClient = BFJumperClient()

-- If external class use "return MyModName"