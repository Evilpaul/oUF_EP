if select(2, UnitClass('player')) ~= 'SHAMAN' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'EarthShield was unable to locate oUF install')

local esRanks = {
	[974] = true,
	[32593] = true,
	[32594] = true,
	[49283] = true,
	[49284] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster, count
	local i = 1
	while true do
		_, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if esRanks[spellId] and unitCaster and UnitIsUnit('player', unitCaster) then
			return true, count
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local es = self.EarthShield

	if es.PreUpdate then es:PreUpdate(unit) end

	local buffExists, stacks = GetBuffInfo(unit)
	if buffExists then
		es:Show()
	else
		es:Hide()
	end

	if es.PostUpdate then es:PostUpdate(unit, stacks) end
end

local function Enable(self)
	if self.EarthShield then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.EarthShield then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('EarthShield', Update, Enable, Disable)