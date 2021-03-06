local _, ns = ...
local config = ns.config

-- menu function
local addMenu
do
	local format = string.format
	local gsub = string.gsub
	local upper = string.upper

	local function SpawnMenu(self)
		local dropdown = _G[format('%sFrameDropDown', gsub(self.unit, '(.)', upper, 1))]

		if dropdown then
			ToggleDropDownMenu(1, nil, dropdown, 'cursor')
		elseif (self.unit:match('party')) then
			ToggleDropDownMenu(1, nil, _G[format('PartyMemberFrame%dDropDown', self.id)], 'cursor')
		elseif (self.unit == 'targettarget') then
		else
			FriendsDropDown.unit = self.unit
			FriendsDropDown.id = self.id
			FriendsDropDown.initialize = RaidFrameDropDown_Initialize
			ToggleDropDownMenu(1, nil, FriendsDropDown, 'cursor')
		end
	end

	function addMenu(self)
		self.menu = SpawnMenu
	end
end
ns.addMenu = addMenu

-- health bar function
local function addHealthBar(self)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 0, 0)
	health:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 0)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetHeight(config.HEALTHHEIGHT)
	health:SetStatusBarColor(1 / 4, 1 / 4, 2 / 5)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
	health.bg = healthBG

	self.Health = health
end
ns.addHealthBar = addHealthBar

-- raid icon function
local function addRaidIcon(self)
	local raidicon = self.Health:CreateTexture(nil, 'OVERLAY')
	raidicon:SetPoint('TOP', self, 'TOP', 0, 8)
	raidicon:SetSize(16, 16)

	self.RaidIcon = raidicon
end
ns.addRaidIcon = addRaidIcon

-- DebuffHighlight function
local function addDebuffHighlightBackdrop(self)
	local debuffBackdrop = {
		Alpha = 1,
		Filter = false,
	}

	self.DebuffBackdrop = debuffBackdrop
end
ns.addDebuffHighlightBackdrop = addDebuffHighlightBackdrop

-- Heal Prediction bar function
local function addHealPredictionBars(self, width, allowOverflow)
	local mhpb = CreateFrame('StatusBar', nil, self.Health)
	mhpb:SetPoint('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	mhpb:SetPoint('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	mhpb:SetWidth(width)
	mhpb:SetStatusBarTexture(config.TEXTURE)
	mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

	local ohpb = CreateFrame('StatusBar', nil, self.Health)
	ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
	ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
	ohpb:SetWidth(width)
	ohpb:SetStatusBarTexture(config.TEXTURE)
	ohpb:SetStatusBarColor(0, 1, 0, 0.25)

	self.HealPrediction = {
		myBar = mhpb,
		otherBar = ohpb,
		maxOverflow = allowOverflow and 1.25 or 1,
	}
end
ns.addHealPredictionBars = addHealPredictionBars

-- Range function
local function addRange(self)
	local range = {
		insideAlpha = 1,
		outsideAlpha = 2 / 3,
	}
	self.Range = range
end
ns.addRange = addRange

-- Value truncation function
local shortVal
do
	local format = string.format

	function shortVal(value)
		local returnValue = ''

		if value > 1e6 then
			returnValue = format('%dm', value / 1e6)
		elseif value > 1e3 then
			returnValue = format('%dk', value / 1e3)
		else
			returnValue = format('%d', value)
		end

		return returnValue
	end
end
ns.shortVal = shortVal

-- post update power function
local function PostUpdatePower(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and config.HEALTHHEIGHT or config.UNITHEIGHT)
end
ns.PostUpdatePower = PostUpdatePower
