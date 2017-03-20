class 'bfjumper'

function bfjumper:__init()
	self.m_SaveEvent = NetEvents:Subscribe('bfjumper:save', self, self.OnSave)
	self.m_LoadEvent = NetEvents:Subscribe('bfjumper:load', self, self.OnLoad)
	
	self.m_LastPosition = Vec3(0, 0, 0)
	self.m_HasSaved = false
end

function bfjumper:OnSave(p_X, p_Y, p_Z)
	self.m_LastPosition = Vec3(p_X, p_Y, p_Z)
	self.m_HasSaved = true
end

function bfjumper:OnLoad()
	if self.m_HasSaved == false then
		return
	end
	
	local s_Player = PlayerManager:GetPlayerById(0)
	if s_Player == nil then
		return
	end
	
	local s_Soldier = s_Player.soldier;
	if s_Soldier == nill then
		return
	end
	
	s_Soldier.SetPosition(self.m_LastPosition)
end

local bfjumper = bfjumper()

-- If external class use "return MyModName"