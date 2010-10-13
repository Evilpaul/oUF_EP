if select(2, UnitClass('player')) ~= 'SHAMAN' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Riptide was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 61295 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local riptide = self.Riptide

	if riptide.PreUpdate then riptide:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		riptide:Show()
	else
		riptide:Hide()
	end

	if riptide.PostUpdate then riptide:PostUpdate(unit) end
end

local function Enable(self)
	if self.Riptide then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Riptide then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Riptide', Update, Enable, Disable)