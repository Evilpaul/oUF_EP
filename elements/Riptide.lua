if select(2, UnitClass('player')) ~= 'SHAMAN' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Riptide was unable to locate oUF install')

local riptideRanks = {
	[61295] = true,
	[61299] = true,
	[61300] = true,
	[61301] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster
	local i = 1
	while true do
		_, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if riptideRanks[spellId] and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	end
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