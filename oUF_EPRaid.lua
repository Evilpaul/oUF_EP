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

		local healpredictiontext = self.Health:CreateFontString(nil, 'OVERLAY')
		healpredictiontext:SetPoint('TOP', info, 'BOTTOM', 0, 0)
		healpredictiontext:SetFont(config.FONT, config.FONTSIZESMALL, config.FONTBORDER)
		self:Tag(healpredictiontext, '[|cff00ff00 >ep:healprediction<|r]')
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
		rejuv:SetTexture(1, 3 / 5, 0)

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

		addDebuffHighlightIcon(self)
	end,

	MAGE = function(self)
		local fm = self.Health:CreateTexture(nil, 'OVERLAY')
		fm:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		fm:SetSize(3, 3)
		fm:SetTexture(1, 3 / 5, 0)

		self.FocusMagic = fm

		addDebuffHighlightIcon(self)
	end,

	PALADIN = function(self)
		local bol = self.Health:CreateTexture(nil, 'OVERLAY')
		bol:SetPoint('TOPRIGHT', self.Health, 'TOPLEFT', 0, 0)
		bol:SetSize(3, 3)
		bol:SetTexture(1, 3 / 5, 0)

		self.BeaconOfLight = bol

		addDebuffHighlightIcon(self)
	end,

	PRIEST = function(self)
		local ws = self.Health:CreateTexture(nil, 'OVERLAY')
		ws:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		ws:SetSize(3, 3)
		ws:SetTexture(1, 3 / 5, 0)

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

		addDebuffHighlightIcon(self)
	end,

	SHAMAN = function(self)
		local es = self.Health:CreateTexture(nil, 'OVERLAY')
		es:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		es:SetSize(3, 3)
		es:SetTexture(1, 3 / 5, 0)

		self.EarthShield = es

		local riptide = self.Health:CreateTexture(nil, 'OVERLAY')
		riptide:SetPoint('TOPRIGHT', self.EarthShield, 'TOPLEFT', -1, 0)
		riptide:SetSize(3, 3)
		riptide:SetTexture(0, 1, 0)

		self.Riptide = riptide

		addDebuffHighlightIcon(self)
	end,

	WARLOCK = function(self)
		local ss = self.Health:CreateTexture(nil, 'OVERLAY')
		ss:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		ss:SetSize(3, 3)
		ss:SetTexture(1, 3 / 5, 0)

		self.Soulstone = ss
	end,

	WARRIOR = function(self)
		local vig = self.Health:CreateTexture(nil, 'OVERLAY')
		vig:SetPoint('TOPRIGHT', self.Health, 'TOPRIGHT', 0, 0)
		vig:SetSize(3, 3)
		vig:SetTexture(1, 3 / 5, 0)

		self.Vigilance = vig
	end,
}

local Style
do
	local addHealthBar = ns.addHealthBar
	local addHealPredictionBars = ns.addHealPredictionBars
	local addRange = ns.addRange
	local addDebuffHighlightBackdrop = ns.addDebuffHighlightBackdrop
	local addMenu = ns.addMenu

	function Style(self, unit)
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)

		self:SetBackdrop(config.BACKDROP)
		self:SetBackdropColor(0, 0, 0)

		addMenu(self)
		addHealthBar(self)
		addPowerBar(self)
		addDebuffHighlightBackdrop(self)
		addHealPredictionBars(self, config.RAIDUNITWIDTH, false)
		addTags(self)
		addRange(self)
		addReadyCheck(self)
		addThreat(self)

		local _, class = UnitClass('player')
		if ClassSpecific[class] then
			return ClassSpecific[class](self)
		end
	end
end
oUF:RegisterStyle('oUF_EPRaid', Style)

local spawnFunction
do
	local mmax = math.max
	local toStr = tostring

	local function DisableBlizzard()
		CompactRaidFrameManager:UnregisterAllEvents()
		CompactRaidFrameContainer:UnregisterAllEvents()
		CompactRaidFrameManager:Hide()
		CompactRaidFrameContainer:Hide()
	end

	function spawnFunction(self)
		self:SetActiveStyle('oUF_EPRaid')

		-- define the raid groups
		local raid = {}
		for group = 1, NUM_RAID_GROUPS do
			local header = self:SpawnHeader(nil, nil, 'party,raid',
							'showPlayer', true,
							'showParty', true,
							'showRaid', true,
							'groupFilter', toStr(group),
							'yOffset', -config.SPACING,
							'oUF-initialConfigFunction', ([[
								local unit = ...
								self:SetWidth(%d)
								self:SetHeight(%d)
							]]):format(config.RAIDUNITWIDTH, config.UNITHEIGHT)
			)

			if group > 1 then
				header:SetPoint('TOPLEFT', raid[group - 1], 'TOPRIGHT', config.SPACING, 0)
			else
				header:SetPoint('TOPLEFT', UIParent, 'BOTTOMLEFT', 15, 350)
			end
			raid[group] = header
		end

		-- define the pet header
		local petHeader = self:SpawnHeader(nil, 'SecureGroupPetHeaderTemplate', 'party,raid',
							'showPlayer', true,
							'showParty', true,
							'showRaid', true,
							'maxColumns', NUM_RAID_GROUPS,
							'unitsPerColumn', MEMBERS_PER_RAID_GROUP,
							'columnSpacing', config.SPACING,
							'columnAnchorPoint', 'LEFT',
							'yOffset', -config.SPACING,
							'xOffset', config.SPACING,
							'initial-width', config.RAIDUNITWIDTH,
							'initial-height', config.UNITHEIGHT,
							'oUF-initialConfigFunction', ([[
								local unit = ...
								self:SetWidth(%d)
								self:SetHeight(%d)
							]]):format(config.RAIDUNITWIDTH, config.UNITHEIGHT)
		)

		-- update script to move the petheader dependant upon which is the last raid group
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
		updateFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
		updateFrame:RegisterEvent('UNIT_EXITED_VEHICLE')

		DisableBlizzard()
	end
end
oUF:Factory(spawnFunction)
