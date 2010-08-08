if select(2, UnitClass('player')) ~= 'PRIEST' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Renew was unable to locate oUF install')

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster
	local i = 1
	while true do
		_, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if spellId == 139 and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit then return end

	local renew = self.Renew

	if renew.PreUpdate then renew:PreUpdate(unit) end

	if GetBuffInfo(unit) then
		renew:Show()
	else
		renew:Hide()
	end

	if renew.PostUpdate then renew:PostUpdate(unit) end
end

local function Enable(self)
	if self.Renew then
		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.Renew then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('Renew', Update, Enable, Disable)