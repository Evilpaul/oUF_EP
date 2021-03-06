local _, ns = ...
local config = ns.config

-- power bar function
local addPowerBar
do
	local PostUpdatePower = ns.PostUpdatePower

	function addPowerBar(self)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(config.POWERHEIGHT)

		power.colorTapping = true
		power.colorReaction = true

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
	local addMenu = ns.addMenu

	function Style(self, unit)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)

		self:SetBackdrop(config.BACKDROP)
		self:SetBackdropColor(0, 0, 0)

		self:SetSize(config.TERTIARYUNITWIDTH, config.UNITHEIGHT)

		addMenu(self)
		addHealthBar(self)
		addPowerBar(self)
		addRaidIcon(self)
		addTags(self)
	end
end

oUF:RegisterStyle('oUF_EPBoss', Style)

oUF:Factory(function(self)
	self:SetActiveStyle('oUF_EPBoss')

	local bossFrames = {}
	for i = 1, MAX_BOSS_FRAMES do
		local unit = self:Spawn('boss' .. i)

		if i > 1 then
			unit:SetPoint('TOPRIGHT', bossFrames[i - 1], 'BOTTOMRIGHT', 0, -10)
		else
			unit:SetPoint('TOPRIGHT', UIParent, 'TOPRIGHT', -15, -350)
		end

		bossFrames[i] = unit
	end
end)
