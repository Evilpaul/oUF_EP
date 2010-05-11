local _, ns = ...
local config = ns.oUF_EP_Config

local function PostUpdatePower(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
end

local function Style(self, unit)
	self.colors = config.COLORS

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	self:SetAttribute('initial-height', 25)
	self:SetAttribute('initial-width', 100)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint('TOPRIGHT', self)
	health:SetPoint('TOPLEFT', self)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetStatusBarColor(1 / 4, 1 / 4, 2 / 5)
	health:SetHeight(21)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
	health.bg = healthBG

	local healthValue = health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetPoint('RIGHT', health, -2, -1)
	healthValue:SetJustifyH('RIGHT')
	self:Tag(healthValue, '[ep:smallhealth]')

	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	name:SetPoint('LEFT', health, 2, -1)
	name:SetPoint('RIGHT', healthValue, 'LEFT')
	name:SetJustifyH('LEFT')
	self:Tag(name, '[ep:name]')

	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('BOTTOMRIGHT', self)
	power:SetPoint('BOTTOMLEFT', self)
	power:SetPoint('TOP', health, 'BOTTOM', 0, -1)
	power:SetStatusBarTexture(config.TEXTURE)
	power:SetHeight(4)
	power.PostUpdate = self:GetAttribute('unitsuffix') == 'target' and PostUpdatePower

	local powerBG = power:CreateTexture(nil, 'BORDER')
	powerBG:SetAllPoints(power)
	powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
	power.bg = powerBG

	power.colorTapping = self:GetAttribute('unitsuffix') == 'target'
	power.colorDisconnected = true
	power.colorClass = true
	power.colorReaction = self:GetAttribute('unitsuffix') == 'target'

	self.Health = health
	self.Power = power

	local raidIcon = health:CreateTexture(nil, 'OVERLAY')
	raidIcon:SetPoint('CENTER', self, 'TOP', 1, 0)
	raidIcon:SetSize(16, 16)

	self.RaidIcon = raidIcon

	-- Range checking to tone down tanks that you cannot heal
	if not(self:GetAttribute('unitsuffix') == 'target') then
		self.Range = true
		self.inRangeAlpha = 1.0
		self.outsideRangeAlpha = 0.65
	end

	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('oUF_EPMT', Style)
oUF:SetActiveStyle('oUF_EPMT')

local frame = oUF:SpawnHeader(nil, nil, 'raid', 'showRaid', true, 'groupFilter', 'MAINTANK')
frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 15, -350)
frame:SetAttribute('yOffset', -10)
frame:SetAttribute('template', 'oUF_MT')
frame:Show()
