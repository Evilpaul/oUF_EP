local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'EPDebuff was unable to locate oUF install')

local _, playerClass = UnitClass('player')
local CanDispel = {
	PRIEST = { Magic = true, Disease = true },
	SHAMAN = { Curse = true, Poison = true, Disease = true },
	PALADIN = { Magic = true, Poison = true, Disease = true },
	MAGE = { Curse = true },
	DRUID = { Curse = true, Poison = true }
}
local unfilteredList = { Magic = true, Curse = true, Poison = true, Disease = true }
local dispellist = CanDispel[playerClass] or {}
local origColor = {}

local function StoreOriginalColors(self)
	if self.EPDebuffBackdrop then
		origColor[self] = {}

		local r, g, b, a = self:GetBackdropColor()
		origColor[self].bg = { r = r, g = g, b = b, a = a}

		r, g, b, a = self:GetBackdropBorderColor()
		origColor[self].border = { r = r, g = g, b = b, a = a}
	end
end

local function GetDebuffInfo(unit, dispelTypes)
	if not UnitCanAssist('player', unit) then return end

	local debuffType, texture
	local i = 1
	while true do
		_, _, texture, _, debuffType, _, _, _, _ = UnitAura(unit, i, 'HARMFUL')

		-- debuff does not exist, quit out of the loop
		if not texture then return end

		if dispelTypes[debuffType] then
			return debuffType, texture
		end

		i = i + 1
	end
end

local function Update(self, event, unit)
	if self.unit ~= unit  then return end

	local backdrop = self.EPDebuffBackdrop
	if backdrop then
		if backdrop.PreUpdate then backdrop:PreUpdate(unit) end

		local dispelList = backdrop.Filter and dispellist or unfilteredList
		local debuffType, _ = GetDebuffInfo(unit, dispelList)

		if debuffType then
			local color = DebuffTypeColor[debuffType]
			self:SetBackdropColor(color.r, color.g, color.b, backdrop.Alpha or 1)
		else
			self:SetBackdropColor(origColor[self].bg.r, origColor[self].bg.g, origColor[self].bg.b, origColor[self].bg.a)
			self:SetBackdropBorderColor(origColor[self].border.r, origColor[self].border.g, origColor[self].border.b, origColor[self].border.a)
		end

		if backdrop.PostUpdate then backdrop:PostUpdate(unit, debuffType) end
	end

	local icon = self.EPDebuffIcon
	if icon then
		if icon.PreUpdate then icon:PreUpdate(unit) end

		local dispelList = icon.Filter and dispellist or unfilteredList
		local _, debuffIcon = GetDebuffInfo(unit, dispelList)

		if debuffIcon then
			icon:SetTexture(debuffIcon)
		else
			icon:SetTexture(nil)
		end

		if icon.PostUpdate then icon:PostUpdate(unit, debuffIcon) end
	end
end

local function Enable(self)
	local edb, edi = self.EPDebuffBackdrop, self.EPDebuffIcon
	if edb or edi then
		StoreOriginalColors(self)

		self:RegisterEvent('UNIT_AURA', Update)

		return true
	end
end

local function Disable(self)
	if self.EPDebuff then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('EPDebuff', Update, Enable, Disable)