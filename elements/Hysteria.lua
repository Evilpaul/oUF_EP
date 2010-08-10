if select(2, UnitClass('player')) ~= 'DEATHKNIGHT' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Hysteria was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster
	local i = 1
	while true do
		_, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if spellId == 49016 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local hys = self.Hysteria

	if hys.PreUpdate then hys:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		hys:Show()
	else
		hys:Hide()
	end

	if hys.PostUpdate then hys:PostUpdate(unit) end
end

local function Enable(self)
	if self.Hysteria then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Hysteria then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Hysteria', Update, Enable, Disable)