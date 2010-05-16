if select(2, UnitClass("player")) ~= "PRIEST" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'WeakenedSoul was unable to locate oUF install')

local function GetDebuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId
	local i = 1
	while true do
		_, _, _, _, _, _, _, _, _, _, spellId = UnitAura(unit, i, 'HARMFUL')

		-- debuff does not exist, quit out of the loop
		if not spellId then return end

		if spellId == 6788 then
			return true
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit  then return end

	local ws = self.WeakenedSoul

	if ws.PreUpdate then ws:PreUpdate(unit) end

	if GetDebuffInfo(unit) then
		ws:Show()
	else
		ws:Hide()
	end

	if ws.PostUpdate then ws:PostUpdate(unit) end
end

local function Enable(self)
	if self.WeakenedSoul then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.WeakenedSoul then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('WeakenedSoul', Update, Enable, Disable)