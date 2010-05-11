-- Big thanks to P3lim, a lot of this code is shamelessly ripped off from his work
local _, ns = ...
local config = ns.oUF_EP_Config

-- menu function
local addMenu
do
	local function SpawnMenu(self)
		ToggleDropDownMenu(1, nil, _G[string.gsub(self.unit, '^.', string.upper) .. 'FrameDropDown'], 'cursor')
	end

	function addMenu(self)
		self.menu = SpawnMenu
		self:SetAttribute('type2', 'menu')
	end
end

-- health bar function
local function addHealthBar(self)
	local health = CreateFrame('StatusBar', nil, self)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetHeight(21)
	health:SetStatusBarColor(1 / 4, 1 / 4, 2 / 5)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
	health.bg = healthBG

	health:SetPoint('TOPRIGHT', self)
	health:SetPoint('TOPLEFT', self)

	self.Health = health
end

-- power bar function
local addPowerBar
do
	local function PostUpdatePower(element, unit, min, max)
		element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
	end

	function addPowerBar(self, postUpdate, isPet)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self)
		power:SetPoint('BOTTOMLEFT', self)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(4)

		power.colorClass = true
		power.colorTapping = true
		power.colorDisconnected = true
		power.colorReaction = not isPet
		power.colorHappiness = isPet
		power.colorPower = isPet

		if(postUpdate) then
			power.PostUpdate = PostUpdatePower
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
end

-- Generic PostCreateAura function
local function PostCreateAura(element, button)
	button:SetBackdrop(config.BACKDROP)
	button:SetBackdropColor(0, 0, 0)

	button.cd:SetReverse()

	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
end

-- buffs function
local function addBuffs(self, point, relativeFrame, relativePoint, ofsx, ofsy, height, width, num, size, growthx, growthy)
	local buffs = CreateFrame('Frame', nil, self)
	buffs:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	buffs:SetSize(width, height)
	buffs.num = num
	buffs.size = size
	buffs.spacing = config.SPACING
	buffs.initialAnchor = point
	buffs['growth-x'] = growthx
	buffs['growth-y'] = growthy
	buffs.PostCreateIcon = PostCreateAura

	self.Buffs = buffs
end

-- debuffs function
local addDebuffs
do
	local function PostUpdateDebuff(element, unit, button, index)
		if(UnitIsUnit('player', unit) or UnitIsFriend('player', unit) or button.isPlayer) then
			local _, _, _, _, type = UnitAura(unit, index, button.filter)
			local colour = DebuffTypeColor[type] or DebuffTypeColor.none

			button:SetBackdropColor(colour.r * 3 / 5, colour.g * 3 / 5, colour.b * 3 / 5)
			button.icon:SetDesaturated(false)
		else
			button:SetBackdropColor(0, 0, 0)
			button.icon:SetDesaturated(true)
		end
	end

	function addDebuffs(self, point, relativeFrame, relativePoint, ofsx, ofsy, height, width, num, size, growthx, growthy, playerOnly)
		local debuffs = CreateFrame('Frame', nil, self)
		debuffs:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
		debuffs:SetSize(width, height)
		debuffs.num = num
		debuffs.size = size
		debuffs.spacing = config.SPACING
		debuffs.initialAnchor = point
		debuffs['growth-x'] = growthx
		debuffs['growth-y'] = growthy
		debuffs.onlyShowPlayer = playerOnly
		debuffs.PostCreateIcon = PostCreateAura
		debuffs.PostUpdateIcon = PostUpdateAura

		self.Debuffs = debuffs
	end
end

-- auras function
local function addAuras(self, point, relativeFrame, relativePoint, ofsx, ofsy, height, width, num, size, growthx, growthy)
	local auras = CreateFrame('Frame', nil, self)
	auras:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
	auras:SetSize(width, height)
	auras.num = num
	auras.size = size
	auras.spacing = config.SPACING
	auras.initialAnchor = point
	auras['growth-x'] = growthx
	auras['growth-y'] = growthy
	auras.PostCreateIcon = PostCreateAura

	self.Auras = auras
end

-- cast bar function
local addCastBar
do
	local function CustomCastText(element, duration)
		element.Time:SetFormattedText('%.1f / %.1f', element.channeling and duration or (element.max - duration), element.max)
	end

	local function PostCastStart(element)
		local text = element.Text
		if(element.interrupt) then
			text:SetTextColor(1, 0, 0)
		else
			text:SetTextColor(1, 1, 1)
		end
	end

	function addCastBar(self, inverted, isPet)
		local castbar = CreateFrame('StatusBar', nil, self)
		castbar:SetSize(isPet and 105 or 205, 16)
		castbar:SetStatusBarTexture(config.TEXTURE)
		castbar:SetStatusBarColor(1 / 4, 1 / 4, 2 / 5)
		castbar:SetBackdrop(config.BACKDROP)
		castbar:SetBackdropColor(0, 0, 0)
		castbar.CustomTimeText = CustomCastText

		local castbarBG = castbar:CreateTexture(nil, 'BORDER')
		castbarBG:SetAllPoints(castbar)
		castbarBG:SetTexture(1 / 3, 1 / 3, 1 / 3)

		local castbarTime = castbar:CreateFontString(nil, 'OVERLAY')
		castbarTime:SetPoint('RIGHT', -2, 0)
		castbarTime:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		castbarTime:SetJustifyH('RIGHT')
		castbar.Time = castbarTime

		local castbarText = castbar:CreateFontString(nil, 'OVERLAY')
		castbarText:SetPoint('LEFT', 2, 0)
		castbarText:SetPoint('RIGHT', castbarTime, 'LEFT', -5, 0)
		castbarText:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		castbarText:SetJustifyH('LEFT')
		castbar.Text = castbarText

		local castbarDummy = CreateFrame('Frame', nil, castbar)
		castbarDummy:SetSize(21, 21)
		castbarDummy:SetBackdrop(config.BACKDROP)
		castbarDummy:SetBackdropColor(0, 0, 0)

		local castbarIcon = castbarDummy:CreateTexture(nil, 'ARTWORK')
		castbarIcon:SetAllPoints(castbarDummy)
		castbarIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		castbar.Icon = castbarIcon

		if(inverted) then
			castbar.PostCastStart = PostCastStart
			castbar.PostChannelStart = PostCastStart
			castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -config.SPACING)
			castbarDummy:SetPoint('TOPLEFT', castbar, 'TOPRIGHT', config.SPACING, 0)
		else
			castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -config.SPACING)
			castbarDummy:SetPoint('TOPRIGHT', castbar, 'TOPLEFT', -config.SPACING, 0)
			castbar.SafeZone = castbar:CreateTexture(nil, 'ARTWORK')
		end

		self.Castbar = castbar
	end
end

-- raid icon function
local function addRaidIcon(self)
	local raidicon = self.Health:CreateTexture(nil, 'OVERLAY')
	raidicon:SetPoint('TOP', self, 0, 8)
	raidicon:SetSize(16, 16)

	self.RaidIcon = raidicon
end

-- leader function
local function addRaidRole(self)
	local leader = self.Health:CreateTexture(nil, 'OVERLAY')
	leader:SetPoint('TOPLEFT', self, 0, 8)
	leader:SetSize(16, 16)

	self.Leader = leader

	local assistant = self.Health:CreateTexture(nil, 'OVERLAY')
	assistant:SetPoint('TOPLEFT', self, 0, 8)
	assistant:SetSize(16, 16)

	self.Assistant = assistant
end

-- LFD role function
local function addLFDRole(self)
	local lfdRole = self.Health:CreateTexture(nil, 'OVERLAY')
	lfdRole:SetPoint('TOPLEFT', self, 20, 8)
	lfdRole:SetSize(16, 16)

	self.LFDRole = lfdRole
end

-- pvp flag function
local function addPVPFlag(self)
	local pvpFlag = self.Health:CreateTexture(nil, 'OVERLAY', 0, 8)
	pvpFlag:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 16, 12)
	pvpFlag:SetSize(32, 32)

	self.PvP = pvpFlag
end

-- EP debuff function
local function addEPDebuff(self)
	self.EPDebuffBackdrop = true
	self.EPDebuffBackdropFilter = false
end

-- Healcomm bar function
local function addHealCommBars(self)
	local healcommbar = CreateFrame('StatusBar', nil, self.Health)
	healcommbar:SetStatusBarTexture(config.TEXTURE)
	healcommbar:SetStatusBarColor(0, 1, 0, 0.25)
	healcommbar:SetPoint('LEFT', self.Health, 'LEFT')
	self.allowHealCommOverflow = true

	self.HealCommBar = healcommbar
end

-- Tag function
local function addTags(self, showPower, showHealComm, showCombo)
	local healthValue = self.Health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetPoint('RIGHT', self.Health, -2, 0)
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetJustifyH('RIGHT')
	self:Tag(healthValue, '[ep:health]')

	local powerName = self.Health:CreateFontString(nil, 'OVERLAY')
	powerName:SetPoint('LEFT', self.Health, 2, 0)
	powerName:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	powerName:SetJustifyH('LEFT')
	if showPower then
		self:Tag(powerName, '[ep:power< ][ep:druid]')
	else
		self:Tag(powerName, '[ep:name][|cff0090ff >rare<|r]')
	end

	if showHealComm then
		local healcommtext = self.Health:CreateFontString(nil, 'OVERLAY')
		healcommtext:SetPoint('LEFT', powerName, 2, 0)
		healcommtext:SetPoint('RIGHT', healthValue, 'LEFT', -5, 0)
		healcommtext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		healcommtext:SetTextColor(0, 1, 0)
		healcommtext:SetJustifyH('RIGHT')
		self.HealCommText = healcommtext
	end

	if showCombo then
		local cpoints = self:CreateFontString(nil, 'OVERLAY', 'SubZoneTextFont')
		cpoints:SetPoint('RIGHT', self, 'LEFT', -config.SPACING, 0)
		cpoints:SetJustifyH('RIGHT')
		self:Tag(cpoints, '|cffffffff[cpoints]|r')
	end
end

local UnitSpecific = {
	player = function(self)
		-- Player specific layout code.
		self:SetAttribute('initial-width', 230)
		addMenu(self)
		addHealthBar(self)
		addPowerBar(self, false, false)
		addCastBar(self, false, false)
		addRaidIcon(self)
		addRaidRole(self)
		addLFDRole(self)
		addPVPFlag(self)
		addHealCommBars(self)
		addTags(self, true, true, false)

		-- Turn off some Blizzard stuff
		BuffFrame:Hide()
		BuffFrame:UnregisterEvent('UNIT_AURA')
		TicketStatusFrame:EnableMouse(false)
		TicketStatusFrame:SetFrameStrata('BACKGROUND')

		addBuffs(self, 'TOPRIGHT', Minimap, 'TOPLEFT', -config.SPACING, 0, 54, 344, 24, 25, 'LEFT', 'DOWN')
		addDebuffs(self, 'BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -config.SPACING, 0, 54, 344, 24, 25, 'LEFT', 'DOWN', false)
		addEPDebuff(self)
	end,

	target = function(self)
		-- Target specific layout code.
		self:SetAttribute('initial-width', 230)
		addMenu(self)
		addHealthBar(self)
		addPowerBar(self, true, false)
		addCastBar(self, true, false)
		addRaidIcon(self)
		addRaidRole(self)
		addLFDRole(self)
		addHealCommBars(self)
		addTags(self, false, true, true)
		addBuffs(self, 'BOTTOMLEFT', self, 'BOTTOMRIGHT', config.SPACING, 0, 54, 236, 20, 25, 'RIGHT', 'UP')
		addDebuffs(self, 'TOPLEFT', self, 'BOTTOMRIGHT', config.SPACING, -config.SPACING, 54, 236, 20, 25, 'RIGHT', 'DOWN', false)
		addEPDebuff(self)
	end,

	pet = function(self)
		-- Pet specific layout code.
		self:SetAttribute('initial-width', 130)
		addMenu(self)
		addHealthBar(self)
		addPowerBar(self, false, true)
		addCastBar(self, false, true)
		addRaidIcon(self)
		addTags(self, true, true, false)
		addAuras(self, 'TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0, 25, 85, 3, 25, 'LEFT', 'UP')
	end,

	targettarget = function(self)
		-- Targettarget specific layout code.
		self:SetAttribute('initial-width', 140)
		addHealthBar(self)
		addPowerBar(self, true, false)
		addDebuffs(self, 'TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0, 25, 85, 3, 25, 'LEFT', 'UP', false)
		addTags(self, false, false, false)
	end,

	focus = function(self)
		-- Focus specific layout code.
		self:SetAttribute('initial-width', 140)
		addHealthBar(self)
		addPowerBar(self, true, false)
		addDebuffs(self, 'TOPLEFT', self, 'TOPRIGHT', config.SPACING, 0, 25, 85, 3, 25, 'RIGHT', 'UP', true)
		addTags(self, false, false, false)
	end,
}

local function Style(self, unit)
	-- Shared layout code.
	self.colors = config.COLORS

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	self:SetAttribute('initial-height', 25)

	if(UnitSpecific[unit]) then
		return UnitSpecific[unit](self)
	end
end

oUF:RegisterStyle('oUF_EP', Style)
oUF:SetActiveStyle('oUF_EP')

oUF:Spawn('player'):SetPoint('CENTER', -220, -250)
oUF:Spawn('target'):SetPoint('CENTER', 220, -250)
oUF:Spawn('targettarget'):SetPoint('BOTTOMRIGHT', oUF.units.target, 'TOPRIGHT', 0, config.SPACING)
oUF:Spawn('focus'):SetPoint('BOTTOMLEFT', oUF.units.player, 'TOPLEFT', 0, config.SPACING)
oUF:Spawn('pet'):SetPoint('RIGHT', oUF.units.player, 'LEFT', -25, 0)
