-- local MyClass = require 'MyFolder/MyClass'
class 'BFJumperClient'

function BFJumperClient:__init()
	self.m_Hook = Hooks:Install("Input:PreUpdate", 999, self, self.OnUpdateInput)
	
	self.m_MeleeTime = 0.0
	self.m_ReloadTime = 0.0
end

function BFJumperClient:OnUpdateInput(p_Hook, p_Cache, p_DeltaTime)
	local s_Saving = p_Cache[math.floor(InputConceptIdentifiers.ConceptMeleeAttack) + 1]
	local s_Loading = p_Cache[math.floor(InputConceptIdentifiers.ConceptReload) + 1]
	
	if s_Saving > 0.0 then
		self.m_MeleeTime = self.m_MeleeTime + p_DeltaTime
	end

	if s_Loading > 0.0 then
		self.m_ReloadTime = self.m_ReloadTime + p_DeltaTime
	end
	
	-- Handle Saving
	if self.m_MeleeTime > 1.5 then
		local s_SaveSent = self:RequestSave()
		if s_SaveSent == true then
			print("Save Requested")
		end
		
		self.m_MeleeTime = 0.0
	end
	
	if self.m_ReloadTime > 1.5 then
		local s_LoadSent = self:RequestLoad()
		if s_LoadSent == true then
			print("Load Requested")
		end
		
		self.m_ReloadTime = 0.0
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

	print(tostring(s_Transform))

	
	NetEvents:SendLocal('bfjumper:save', s_Transform)
	
	return true
end

function BFJumperClient:RequestLoad()
	NetEvents:SendLocal('bfjumper:load')
	
	return true
end

g_BFJumperClient = BFJumperClient()

-- If external class use "return MyModName"