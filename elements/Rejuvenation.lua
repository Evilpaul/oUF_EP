if select(2, UnitClass('player')) ~= 'DRUID' then return end

local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'Rejuvenation was unable to locate oUF install')

local rejuvRanks = {
	[774] = true,
	[1058] = true,
	[1430] = true,
	[2090] = true,
	[2091] = true,
	[3627] = true,
	[8910] = true,
	[9839] = true,
	[9840] = true,
	[9841] = true,
	[25299] = true,
	[26981] = true,
	[26982] = true,
	[48440] = true,
	[48441] = true,
}

local function GetBuffInfo(unit)
	if not UnitCanAssist('player', unit) then return end

	local spellId, unitCaster
	local i = 1
	while true do
		_, _, _, _, _, _, _, unitCaster, _, _, spellId = UnitAura(unit, i, 'HELPFUL')

		-- buff does not exist, quit out of the loop
		if not spellId then return end

		if rejuvRanks[spellId] and unitCaster and UnitIsUnit('player', unitCaster) then
			return true
		end

		i = i + 1
	end
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