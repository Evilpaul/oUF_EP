if select(2, UnitClass('player')) ~= 'MAGE' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'FocusMagic was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 54646 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local fm = self.FocusMagic

	if fm.PreUpdate then fm:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		fm:Show()
	else
		fm:Hide()
	end

	if fm.PostUpdate then fm:PostUpdate(unit) end
end

local function Enable(self)
	if self.FocusMagic then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.FocusMagic then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('FocusMagic', Update, Enable, Disable)