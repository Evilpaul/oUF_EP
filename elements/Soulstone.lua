if select(2, UnitClass('player')) ~= 'WARLOCK' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Soulstone was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local _, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 20707 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local ss = self.Soulstone

	if ss.PreUpdate then ss:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		ss:Show()
	else
		ss:Hide()
	end

	if ss.PostUpdate then ss:PostUpdate(unit) end
end

local function Enable(self)
	if self.Soulstone then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Soulstone then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Soulstone', Update, Enable, Disable)