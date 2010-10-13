if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Regrowth was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 8936 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local regrowth = self.Regrowth

	if regrowth.PreUpdate then regrowth:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		regrowth:Show()
	else
		regrowth:Hide()
	end

	if regrowth.PostUpdate then regrowth:PostUpdate(unit) end
end

local function Enable(self)
	if self.Regrowth then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Regrowth then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Regrowth', Update, Enable, Disable)