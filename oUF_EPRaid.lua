local format = string.format
local mmax = math.max

local config = oUF_EPConfig

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

	local info = health:CreateFontString(nil, 'OVERLAY')
	info:SetPoint('TOP', health,'TOP', 0, -3)
	info:SetFont(config.FONT, 10, config.FONTBORDER)

	-- ReadyCheck
	local readycheck = health:CreateTexture(nil, 'OVERLAY')
	readycheck:SetPoint('CENTER', self, 'CENTER', 0, 0)
	readycheck:SetHeight(16)
	readycheck:SetWidth(16)
	self.ReadyCheck = readycheck

	-- add corner indicator for threat status
	local threat = health:CreateTexture(nil, 'OVERLAY')
	threat:SetPoint('TOPLEFT', health, 'TOPLEFT', 0, 0)
	threat:SetHeight(5)
	threat:SetWidth(5)
	threat:SetTexture([[Interface\Minimap\ObjectIcons]])
	threat:SetTexCoord(6/8, 7/8, 1/2, 1)

	-- add border colouring for any debuff
	self.EPDebuffBackdrop = true
	self.EPDebuffBackdropFilter = false

	-- add center icon for player removable debuff
	local debuffIcon = health:CreateTexture(nil, 'OVERLAY')
	debuffIcon:SetWidth(16)
	debuffIcon:SetHeight(16)
	debuffIcon:SetPoint('CENTER', self, 'CENTER', 0, 0)
	self.EPDebuffIconFilter = true

	local healcommbar = CreateFrame('StatusBar', nil, health)
	healcommbar:SetStatusBarTexture(config.TEXTURE)
	healcommbar:SetStatusBarColor(0, 1, 0, 0.25)
	healcommbar:SetPoint('LEFT', health, 'LEFT')

	self.allowHealCommOverflow = false

	local healcommtext = health:CreateFontString(nil, 'OVERLAY')
	healcommtext:SetTextColor(0, 1, 0)
	healcommtext:SetPoint('TOP', info, 'BOTTOM', 0, 0)
	healcommtext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	self.HealCommTextFormat = shortVal

	self.Health = health
	self.Threat = threat
	self.EPDebuffIcon = debuffIcon
	self.HealCommBar = healcommbar
	self.HealCommText = healcommtext
	self:Tag(info, '[ep:raidname]')

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

	power.colorTapping = true
	power.colorDisconnected = true
	power.colorHappiness = self:GetAttribute('unitsuffix') == 'pet'
	power.colorPower = self:GetAttribute('unitsuffix') == 'pet'
	power.colorClass = true
	power.colorReaction = self:GetAttribute('unitsuffix') ~= 'pet'

	self.Power = power

	-- Range checking
	self.Range = true
	self.inRangeAlpha = 1.0
	self.outsideRangeAlpha = 0.5

	self:SetAttribute('initial-height', 25)	-- the frames' height
	self:SetAttribute('initial-width', 25)	-- the frames' width
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
