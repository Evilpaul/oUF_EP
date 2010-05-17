local _, ns = ...
local config = ns.config
local addHealthBar = ns.addHealthBar
local addDebuffHighlightBackdrop = ns.addDebuffHighlightBackdrop
local addHealCommBars = ns.addHealCommBars
local addRange = ns.addRange

-- power bar function
local addPowerBar
do
	local function PostUpdatePower(element, unit, min, max)
		element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
	end

	function addPowerBar(self)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(4)

		power.colorDisconnected = true
		power.colorClass = true
		power.colorReaction = true

		power.PostUpdate = PostUpdatePower

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
end

local function addDebuffHighlightIcon(self)
	local debuffIcon = self.Health:CreateTexture(nil, 'OVERLAY')
	debuffIcon:SetSize(16, 16)
	debuffIcon:SetPoint('CENTER', self, 'CENTER', 0, 0)
	debuffIcon.Filter = true

	self.DebuffIcon = debuffIcon
end

-- Tag function
local addTags
do
	local shortVal = ns.shortVal

	function addTags(self)
		local info = self.Health:CreateFontString(nil, 'OVERLAY')
		info:SetPoint('TOP', self.Health, 'TOP', 0, -3)
		info:SetFont(config.FONT, config.FONTSIZESMALL, config.FONTBORDER)
		self:Tag(info, '[ep:raidname]')

		local healcommtext = self.Health:CreateFontString(nil, 'OVERLAY')
		healcommtext:SetPoint('TOP', info, 'BOTTOM', 0, 0)
		healcommtext:SetFont(config.FONT, config.FONTSIZESMALL, config.FONTBORDER)
		healcommtext:SetTextColor(0, 1, 0)

		self.HealCommTextFormat = shortVal

		self.HealCommText = healcommtext
	end
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
	threat:SetSize(3, 3)
	threat:SetTexture(1, 1, 1)

	self.Threat = threat
end

local ClassSpecific = {
	DRUID = function(self)
		local rejuv = self.Health:CreateTexture(nil, 'OVERLAY')
		rejuv:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		rejuv:SetSize(3, 3)
		rejuv:SetTexture(1, 0.6, 0)

		self.Rejuvenation = rejuv

		local regrowth = self.Health:CreateTexture(nil, 'OVERLAY')
		regrowth:SetPoint('TOPRIGHT', self.Rejuvenation, 'TOPLEFT', -1, 0)
		regrowth:SetSize(3, 3)
		regrowth:SetTexture(0, 1, 0)

		self.Regrowth = regrowth

		local lb = self.Health:CreateTexture(nil, 'OVERLAY')
		lb:SetPoint('TOPRIGHT', self.Regrowth, 'TOPLEFT', -1, 0)
		lb:SetSize(3, 3)
		lb:SetTexture(0, 1, 1)

		self.Lifebloom = lb

	MAGE = function(self)
		local fm = self.Health:CreateTexture(nil, 'OVERLAY')
		fm:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		fm:SetSize(3, 3)
		fm:SetTexture(1, 0.6, 0)

		self.FocusMagic = fm
	end,

	end,

	PRIEST = function(self)
		local ws = self.Health:CreateTexture(nil, 'OVERLAY')
		ws:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		ws:SetSize(3, 3)
		ws:SetTexture(1, 0.6, 0)

		self.WeakenedSoul = ws

		local renew = self.Health:CreateTexture(nil, 'OVERLAY')
		renew:SetPoint('TOPRIGHT', self.WeakenedSoul, 'TOPLEFT', -1, 0)
		renew:SetSize(3, 3)
		renew:SetTexture(0, 1, 0)

		self.Renew = renew

		local pom = self.Health:CreateTexture(nil, 'OVERLAY')
		pom:SetPoint('TOPRIGHT', self.Renew, 'TOPLEFT', -1, 0)
		pom:SetSize(3, 3)
		pom:SetTexture(0, 1, 1)

		self.PrayerOfMending = pom

	end,
}

local function Style(self, unit)
	self.colors = config.COLORS

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	self:SetAttribute('initial-height', 25)
	self:SetAttribute('initial-width', 25)

	addHealthBar(self)
	addPowerBar(self)
	addDebuffHighlightBackdrop(self)
	addHealCommBars(self, false)
	addTags(self)
	addRange(self)
	addReadyCheck(self)
	addThreat(self)

	local _, class = UnitClass('player')
	if ClassSpecific[class] then
		return ClassSpecific[class](self)
	end

	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('oUF_EPRaid', Style)

local spawnFunction
do
	local mmax = math.max

	function spawnFunction(self)
		self:SetActiveStyle('oUF_EPRaid')

		-- define the raid groups
		local raid = {}
		for group = 1, NUM_RAID_GROUPS do
			local header = self:SpawnHeader(nil, nil, 'party,raid', 'showPlayer', group == 1, 'showParty', group == 1, 'showRaid', true)
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
		local petHeader = self:SpawnHeader(nil, 'SecureGroupPetHeaderTemplate', 'party,raid', 'showPlayer', true, 'ShowParty', true, 'showRaid', true)
		petHeader:SetAttribute('yOffset', -config.SPACING)
		petHeader:SetAttribute('xOffset', config.SPACING)
		petHeader:SetAttribute('maxColumns', 8)
		petHeader:SetAttribute('unitsPerColumn', 5)
		petHeader:SetAttribute('columnSpacing', 5)
		petHeader:SetAttribute('columnAnchorPoint', 'LEFT')
		petHeader:Show()

		local updateFrame = CreateFrame('Frame')
		updateFrame:SetScript('OnEvent', function(...)
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
		end)
		updateFrame:RegisterEvent('PARTY_MEMBERS_CHANGED')
		updateFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
		updateFrame:RegisterEvent('PLAYER_REGEN_ENABLED')
		updateFrame:RegisterEvent('RAID_ROSTER_UPDATE')
		updateFrame:RegisterEvent('VARIABLES_LOADED')
		updateFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
		updateFrame:RegisterEvent('UNIT_EXITED_VEHICLE')
	end
end

oUF:Factory(spawnFunction)
