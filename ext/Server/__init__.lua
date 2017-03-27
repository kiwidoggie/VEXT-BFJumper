class 'BFJumperServer'

function BFJumperServer:__init()
	self.m_SaveEvent = NetEvents:Subscribe('bfjumper:save', self, self.OnSave)
	self.m_LoadEvent = NetEvents:Subscribe('bfjumper:load', self, self.OnLoad)
	
	self.m_Positions = { }
end

function BFJumperServer:OnSave(p_Player, p_Transform)
	if p_Player == nil then
		return
	end

	self.m_Positions[p_Player.id] = p_Transform

	print("Player " .. p_Player.name .. " has saved to position " .. tostring(p_Transform.trans))
end

function BFJumperServer:OnLoad(p_Player)
	print("Load Server Requested")
	
	-- Check our player object
	if p_Player == nil then
		return
	end

	-- Check to see if our player has previously saved a position
	if self.m_Positions[p_Player.id] == nil then
		return
	end

	local s_Soldier = p_Player.soldier;
	if s_Soldier == nil then
		return
	end
	
	local s_PlayerTransform = self.m_Positions[p_Player.id]

	s_Soldier:SetPosition(s_PlayerTransform.trans)

	print("Player " .. p_Player.name .. " has loaded to position " .. tostring(s_PlayerTransform.trans))
end

g_BFJumperServer = BFJumperServer()

-- If external class use "return MyModName"