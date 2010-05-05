local config = oUF_EPConfig

local function PostUpdatePower(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
end

local function Style(self, unit)
	self.colors = config.COLORS

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint('TOPRIGHT', self)
	health:SetPoint('TOPLEFT', self)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetStatusBarColor(0.25, 0.25, 0.35)
	health:SetHeight(21)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(0.3, 0.3, 0.3)
	health.bg = healthBG

	local healthValue = health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetPoint('RIGHT', health, -2, -1)
	healthValue:SetJustifyH('RIGHT')

	local info = health:CreateFontString(nil, 'OVERLAY')
	info:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	info:SetPoint('LEFT', health, 2, -1)
	info:SetPoint('RIGHT', healthValue, 'LEFT')
	info:SetJustifyH('LEFT')

	local raidIcon = health:CreateTexture(nil, 'OVERLAY')
	raidIcon:SetPoint('CENTER', self, 'TOP', 1, 0)
	raidIcon:SetSize(16, 16)

	self.Health = health
	self.RaidIcon = raidIcon
	self:Tag(healthValue, '[ep:smallhealth]')
	self:Tag(info, '[ep:name]')

	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('BOTTOMRIGHT', self)
	power:SetPoint('BOTTOMLEFT', self)
	power:SetPoint('TOP', health, 'BOTTOM', 0, -1)
	power:SetStatusBarTexture(config.TEXTURE)
	power:SetHeight(4)
	power.PostUpdate = PostUpdatePower

	local powerBG = power:CreateTexture(nil, 'BORDER')
	powerBG:SetAllPoints(power)
	powerBG:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
	powerBG.multiplier = 0.3
	power.bg = powerBG

	power.colorTapping = self:GetAttribute('unitsuffix') == 'target'
	power.colorDisconnected = true
	power.colorClass = true
	power.colorReaction = self:GetAttribute('unitsuffix') == 'target'

	self.Power = power

	-- Range checking to tone down tanks that you cannot heal
	if not(self:GetAttribute('unitsuffix') == 'target') then
		self.Range = true
		self.inRangeAlpha = 1.0
		self.outsideRangeAlpha = 0.65
	end

	self.disallowVehicleSwap = true

	self:SetAttribute('initial-height', 25)	-- the frames' height
	self:SetAttribute('initial-width', 100)	-- the frames' width
end

oUF:RegisterStyle('oUF_EPMT', Style)
oUF:SetActiveStyle('oUF_EPMT')

local frame = oUF:SpawnHeader(nil, nil, 'raid', 'showRaid', true, 'groupFilter', 'MAINTANK')
frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 15, -350)
frame:SetAttribute('yOffset', -10)
frame:SetAttribute('template', 'oUF_EPMT')
frame:Show()
