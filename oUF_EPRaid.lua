local _, ns = ...
local config = ns.config

local mmax = math.max

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

	function addPowerBar(self, isPet)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(4)

		power.colorDisconnected = true
		power.colorPower = isPet
		power.colorClass = not isPet

		power.PostUpdate = PostUpdatePower

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
end

-- EP debuff function
local function addEPDebuff(self)
	self.EPDebuffBackdrop = true
	self.EPDebuffBackdropFilter = false

	-- add center icon for player removable debuff
	local debuffIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	debuffIcon:SetSize(16, 16)
	debuffIcon:SetPoint('CENTER', self, 'CENTER', 0, 0)
	self.EPDebuffIconFilter = true

	self.EPDebuffIcon = debuffIcon
end

-- Healcomm bar function
local function addHealCommBars(self)
	local healcommbar = CreateFrame('StatusBar', nil, self.Health)
	healcommbar:SetStatusBarTexture(config.TEXTURE)
	healcommbar:SetStatusBarColor(0, 1, 0, 0.25)
	healcommbar:SetPoint('LEFT', self.Health, 'LEFT', 0, 0)
	self.allowHealCommOverflow = false

	self.HealCommBar = healcommbar
end

-- Tag function
local addTags
do
	local format = string.format

	local function shortVal(value)
		local returnValue = ""

		if (value > 1e6) then
			returnValue = format("%dm", value / 1e6)
		elseif (value > 1e3) then
			returnValue = format("%dk", value / 1e3)
		else
			returnValue = format("%d", value)
		end

		return returnValue
	end

	function addTags(self)
		local info = self.Health:CreateFontString(nil, 'OVERLAY')
		info:SetPoint('TOP', self.Health, 'TOP', 0, -3)
		info:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		self:Tag(info, '[ep:raidname]')

		local healcommtext = self.Health:CreateFontString(nil, 'OVERLAY')
		healcommtext:SetPoint('TOP', info, 'BOTTOM', 0, 0)
		healcommtext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		healcommtext:SetTextColor(0, 1, 0)

		self.HealCommTextFormat = shortVal

		self.HealCommText = healcommtext
	end
end

-- Range function
local function addRange(self)
	local range = {
		insideAlpha = 1.0,
		outsideAlpha = 0.65
	}
	self.Range = range
end

-- Ready Check function
local function addReadyCheck(self)
	local readycheck = self.Health:CreateTexture(nil, 'OVERLAY')
	readycheck:SetPoint('CENTER', self, 'CENTER', 0, 0)
	readycheck:SetSize(16, 16)

	self.ReadyCheck = readycheck
end

-- Threat function
local function addThreat(self)
	local threat = self.Health:CreateTexture(nil, 'OVERLAY')
	threat:SetPoint('TOPLEFT', self.Health, 'TOPLEFT', 0, 0)
	threat:SetSize(5, 5)
	threat:SetTexture([[Interface\Minimap\ObjectIcons]])
	threat:SetTexCoord(6 / 8, 7 / 8, 1 / 2, 1)

	self.Threat = threat
end

local function Style(self, unit)
	self.colors = config.COLORS

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	self:SetAttribute('initial-height', 25)
	self:SetAttribute('initial-width', 25)

	addHealthBar(self)
	addPowerBar(self, self:GetAttribute('unitsuffix') == 'pet')
	addEPDebuff(self)
	addHealCommBars(self)
	addTags(self)
	addRange(self)
	addReadyCheck(self)
	addThreat(self)

	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('oUF_EPRaid', Style)
oUF:SetActiveStyle('oUF_EPRaid')

-- define the raid groups
local raid = {}
for group = 1, NUM_RAID_GROUPS do
	local header = oUF:SpawnHeader(nil, nil, 'party,raid', 'showPlayer', group == 1, 'showParty', group == 1, 'showRaid', true)
	header:SetAttribute('groupFilter', group)
	header:SetAttribute('yOffset', -config.SPACING)

	if group > 1 then
		header:SetPoint('TOPLEFT', raid[group - 1], 'TOPRIGHT', config.SPACING, 0)
	else
		header:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', 15, 350)
	end
	header:Show()
	raid[group] = header
end

-- define the pet header
local petHeader = oUF:SpawnHeader(nil, 'SecureGroupPetHeaderTemplate', 'party,raid', 'showPlayer', true, 'ShowParty', true, 'showRaid', true)
petHeader:SetAttribute('yOffset', -config.SPACING)
petHeader:SetAttribute('xOffset', config.SPACING)
petHeader:SetAttribute('maxColumns', 8)
petHeader:SetAttribute('unitsPerColumn', 5)
petHeader:SetAttribute('columnSpacing', 5)
petHeader:SetAttribute('columnAnchorPoint', 'LEFT')
petHeader:Show()

-- move the pet header to after the last non-empty raid group
local function UpdateLayout(...)
	if InCombatLockdown() then return end

	local lastGroup = 1
	local numRaidMembers = GetNumRaidMembers()
	if numRaidMembers > 0 then
		-- loop through ALL raid members and find the last group (blargh)
		local playerGroup
		for member = 1, numRaidMembers do
			_, _, playerGroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(member)
			lastGroup = mmax(lastGroup, playerGroup)
		end
	end

	petHeader:SetPoint('TOPLEFT', raid[lastGroup], 'TOPRIGHT', config.SPACING, 0)
end

local updateFrame = CreateFrame('Frame')
updateFrame:SetScript('OnEvent', UpdateLayout)
updateFrame:RegisterEvent('PARTY_MEMBERS_CHANGED')
updateFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
updateFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
updateFrame:RegisterEvent('RAID_ROSTER_UPDATE')
updateFrame:RegisterEvent('VARIABLES_LOADED')
updateFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
updateFrame:RegisterEvent('UNIT_EXITED_VEHICLE')
