if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Rejuvenation was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 774 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local rejuv = self.Rejuvenation

	if rejuv.PreUpdate then rejuv:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		rejuv:Show()
	else
		rejuv:Hide()
	end

	if rejuv.PostUpdate then rejuv:PostUpdate(unit) end
end

local function Enable(self)
	if self.Rejuvenation then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Rejuvenation then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Rejuvenation', Update, Enable, Disable)