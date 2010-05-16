if select(2, UnitClass("player")) ~= "PRIEST" then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'PrayerOfMending was unable to locate oUF install')

local pomRanks = {
	[41635] = true,
	[48110] = true,
	[48111] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster, count
	local i = 1
	while true do
		_, _, _, count, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if pomRanks[spellId] and UnitIsUnit('player', unitCaster) then
			return true, count
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit  then return end

	local pom = self.PrayerOfMending

	if pom.PreUpdate then pom:PreUpdate(unit) end

	local buffExists, stacks = GetBuffInfo(unit)
	if buffExists then
		pom:Show()
	else
		pom:Hide()
	end

	if pom.PostUpdate then pom:PostUpdate(unit, stacks) end
end

local function Enable(self)
	if self.PrayerOfMending then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.PrayerOfMending then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('PrayerOfMending', Update, Enable, Disable)