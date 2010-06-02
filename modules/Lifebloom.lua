if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Lifebloom was unable to locate oUF install')

local lbRanks = {
	[33763] = true,
	[48450] = true,
	[48451] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster, count
	local i = 1
	while true do
		_, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if lbRanks[spellId] and unitCaster and UnitIsUnit('player', unitCaster) then
			return true, count
		end

		i = i + 1
	end
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