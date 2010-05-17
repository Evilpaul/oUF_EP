if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Regrowth was unable to locate oUF install')

local regrowthRanks = {
	[8936] = true,
	[8938] = true,
	[8939] = true,
	[8940] = true,
	[8941] = true,
	[9750] = true,
	[9856] = true,
	[9857] = true,
	[9858] = true,
	[26980] = true,
	[48442] = true,
	[48443] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster
	local i = 1
	while true do
		_, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if regrowthRanks[spellId] and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	end
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