local _, ns = ...
local config = ns.config

-- health bar function
local function addHealthBar(self)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
	health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetHeight(21)
	health:SetStatusBarColor(1 / 4, 1 / 4, 2 / 5)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
	health.bg = healthBG

	self.Health = health
end

-- power bar function
local addPowerBar
do
	local function PostUpdatePower(element, unit, min, max)
		element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
	end

	function addPowerBar(self, isTarget)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(4)

		power.colorTapping = isTarget
		power.colorDisconnected = true
		power.colorClass = true
		power.colorReaction = isTarget

		power.PostUpdate = isTarget and PostUpdatePower or nil

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
end

-- raid icon function
local function addRaidIcon(self)
	local raidicon = self.Health:CreateTexture(nil, 'OVERLAY')
	raidicon:SetPoint('TOP', self, 'TOP', 0, 8)
	raidicon:SetSize(16, 16)

	self.RaidIcon = raidicon
end

-- Tag function
local function addTags(self)
	local healthValue = self.Health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetJustifyH('RIGHT')
	self:Tag(healthValue, '[ep:smallhealth]')

	local name = self.Health:CreateFontString(nil, 'OVERLAY')
	name:SetPoint('LEFT', self.Health, 'LEFT', 2, 0)
	name:SetPoint('RIGHT', healthValue, 'LEFT', -config.SPACING, 0)
	name:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	name:SetJustifyH('LEFT')
	self:Tag(name, '[ep:name]')
end

-- Range function
local function addRange(self)
	local range = {
		insideAlpha = 1.0,
		outsideAlpha = 0.65
	}
	self.Range = range
end

local function Style(self, unit)
	self.colors = config.COLORS

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	self:SetAttribute('initial-height', 25)
	self:SetAttribute('initial-width', 100)

	addHealthBar(self)
	addPowerBar(self, self:GetAttribute('unitsuffix') == 'target')
	addRaidIcon(self)
	addTags(self)

	if self:GetAttribute('unitsuffix') ~= 'target' then
		addRange(self)
	end

	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('oUF_EPMT', Style)

oUF:Factory(function(self)
	self:SetActiveStyle('oUF_EPMT')

	local frame = self:SpawnHeader(nil, nil, 'raid', 'showRaid', true, 'groupFilter', 'MAINTANK')
	frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 15, -350)
	frame:SetAttribute('yOffset', -10)
	frame:SetAttribute('template', 'oUF_MT')
	frame:Show()
end)
