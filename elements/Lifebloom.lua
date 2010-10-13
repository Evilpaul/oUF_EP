if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Lifebloom was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local i = 1
	repeat
		local_, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		if spellId == 33763 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true, count
		end

		i = i + 1
	until not spellId
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local lb = self.Lifebloom

	if lb.PreUpdate then lb:PreUpdate(unit) end

	local buffExists, stacks = GetBuffInfo(unit)
	if buffExists then
		lb:Show()
	else
		lb:Hide()
	end

	if lb.PostUpdate then lb:PostUpdate(unit, stacks) end
end

local function Enable(self)
	if self.Lifebloom then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Lifebloom then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Lifebloom', Update, Enable, Disable)