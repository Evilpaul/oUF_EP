local _, ns = ...
local config = ns.config

-- power bar function
local addPowerBar
do
	local PostUpdatePower = ns.PostUpdatePower

	function addPowerBar(self, isTarget)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(config.POWERHEIGHT)

		power.colorTapping = isTarget
		power.colorDisconnected = true
		power.colorClass = true
		power.colorReaction = isTarget

		power.PostUpdate = PostUpdatePower

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
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

local Style
do
	local addHealthBar = ns.addHealthBar
	local addRaidIcon = ns.addRaidIcon
	local addRange = ns.addRange
	local addMenu = ns.addMenu

	function Style(self, unit)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)

		self:SetBackdrop(config.BACKDROP)
		self:SetBackdropColor(0, 0, 0)

		addMenu(self)
		addHealthBar(self)
		addPowerBar(self, self:GetAttribute('unitsuffix') == 'target')
		addRaidIcon(self)
		addTags(self)

		if self:GetAttribute('unitsuffix') ~= 'target' then
			addRange(self)
		end
	end
end

oUF:RegisterStyle('oUF_EPMT', Style)

oUF:Factory(function(self)
	self:SetActiveStyle('oUF_EPMT')

	local frame = self:SpawnHeader(nil, nil, 'raid',
					'showRaid', true,
					'yOffset', -10,
					'template', 'oUF_MT',
					'groupFilter', 'MAINTANK',
					'oUF-initialConfigFunction', ([[
						self:SetSize(%d, %d)
					]]):format(config.TERTIARYUNITWIDTH, config.UNITHEIGHT)
	)
	frame:SetPoint('TOPLEFT', UIParent, 'TOPLEFT', 15, -350)
end)
