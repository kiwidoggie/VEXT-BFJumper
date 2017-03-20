-- local MyClass = require 'MyFolder/MyClass'
class 'bfjumper'

function bfjumper:__init()
	--print("Hello World")
	-- Client Input
	self.m_ClientUpdateInputEvent = Events:Subscribe('Client:UpdateInput', self, self.OnUpdateInput)
	
	self.m_MeleeTime = 0
	self.m_ReloadTime = 0
end

function bfjumper:OnUpdateInput(p_Delta)
	local s_Attack = InputManager:IsDown(InputConceptIdentifiers.ConceptMeleeAttack)
	if s_Attack == true then
		self.m_MeleeTime = self.m_MeleeTime + p_Delta
	end
	
	local s_Reload = InputManager:IsDown(InputConceptIdentifiers.ConceptReload)
	if s_Reload == true then
		self.m_ReloadTime = self.m_ReloadTime + p_Delta
	end
	
	if self.m_MeleeTime > 30 then
		-- send teleport request coordinates
		local s_Sent = self.RequestSave()
		if s_Sent == true then
			print("Save Requested.")
		end
		self.m_MeleeTime = 0
	end
	
	if self.m_ReloadTime > 30 then
		-- send teleport request coordinates
		local s_Sent = self.RequestLoad()
		if s_Sent == true then
			print("Load Requested.")
		end
		self.m_ReloadTime = 0
	end
end

function bfjumper:RequestSave()
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

function bfjumper:RequestLoad()
	NetEvents:SendLocal('bfjumper:load')
end
local bfjumper = bfjumper()

-- If external class use "return MyModName"