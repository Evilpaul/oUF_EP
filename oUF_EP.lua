-- Big thanks to P3lim, a lot of this code is shamelessly ripped off from his work
local _, ns = ...
local config = ns.config
local addHealthBar = ns.addHealthBar
local addRaidIcon = ns.addRaidIcon
local addDebuffHighlightBackdrop = ns.addDebuffHighlightBackdrop
local addHealCommBars = ns.addHealCommBars

-- menu function
local addMenu
do
	local gsub = string.gsub
	local upper = string.upper
	local format = string.format

	local function SpawnMenu(self)
		ToggleDropDownMenu(1, nil, _G[format('%sFrameDropDown', gsub(self.unit, '^.', upper))], 'cursor')
	end

	function addMenu(self)
		self.menu = SpawnMenu
		self:SetAttribute('type2', 'menu')
	end
end

-- power bar function
local addPowerBar
do
	local PostUpdatePower = ns.PostUpdatePower

	function addPowerBar(self, postUpdate, isPet)
		local power = CreateFrame('StatusBar', nil, self)
		power:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', 0, 0)
		power:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', 0, 0)
		power:SetPoint('TOP', self.Health, 'BOTTOM', 0, -1)
		power:SetStatusBarTexture(config.TEXTURE)
		power:SetHeight(4)

		power.colorTapping = true
		power.colorDisconnected = true
		power.colorPower = isPet
		power.colorClass = not isPet
		power.colorReaction = not isPet

		if postUpdate then
			power.PostUpdate = PostUpdatePower
		end

		local powerBG = power:CreateTexture(nil, 'BORDER')
		powerBG:SetAllPoints(power)
		powerBG:SetTexture(1 / 3, 1 / 3, 1 / 3)
		power.bg = powerBG

		self.Power = power
	end
end

-- Generic Aura Tooltip function
local function UpdateTooltip(self)
	GameTooltip:SetUnitAura(self.parent:GetParent().unit, self:GetID(), self.filter)

	if self.owner and UnitExists(self.owner) then
		GameTooltip:AddLine(format('Cast by %s', UnitName(self.owner) or UNKNOWN))
	end

	GameTooltip:Show()
end

-- Generic PostCreateIcon function
local function PostCreateIcon(element, button)
	button:SetBackdrop(config.BACKDROP)
	button:SetBackdropColor(0, 0, 0)

	button.count:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)

	button.UpdateTooltip = UpdateTooltip

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
	buffs.PostCreateIcon = PostCreateIcon

	self.Buffs = buffs
end

-- debuffs function
local addDebuffs
do
	local function PostUpdateIcon(element, unit, button, index)
		if UnitIsUnit('player', unit) or UnitIsFriend('player', unit) or button.isPlayer then
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
		debuffs.PostCreateIcon = PostCreateIcon
		debuffs.PostUpdateIcon = PostUpdateIcon

		self.Debuffs = debuffs
	end
end

-- cast bar function
local addCastBar
do
	local function CustomTimeText(element, duration)
		element.Time:SetFormattedText('%.1f / %.1f', element.channeling and duration or (element.max - duration), element.max)
	end

	local function CustomDelayText(element, duration)
		element.Time:SetFormattedText('%.1f |cffff0000-%.1f|r / %.1f', element.channeling and duration or (element.max - duration), element.delay, element.max)
	end

	local function PostCastStart(element)
		local text = element.Text
		if element.interrupt then
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
		castbar.CustomTimeText = CustomTimeText
		castbar.CustomDelayText = CustomDelayText

		local castbarBG = castbar:CreateTexture(nil, 'BORDER')
		castbarBG:SetAllPoints(castbar)
		castbarBG:SetTexture(1 / 3, 1 / 3, 1 / 3)

		local castbarTime = castbar:CreateFontString(nil, 'OVERLAY')
		castbarTime:SetPoint('RIGHT', castbar, 'RIGHT', -2, 0)
		castbarTime:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		castbarTime:SetJustifyH('RIGHT')
		castbar.Time = castbarTime

		local castbarText = castbar:CreateFontString(nil, 'OVERLAY')
		castbarText:SetPoint('LEFT', castbar, 'LEFT', 2, 0)
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

		if inverted then
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

-- leader function
local function addRaidRole(self)
	local leader = self.Health:CreateTexture(nil, 'OVERLAY')
	leader:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	leader:SetSize(16, 16)

	self.Leader = leader

	local assistant = self.Health:CreateTexture(nil, 'OVERLAY')
	assistant:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	assistant:SetSize(16, 16)

	self.Assistant = assistant
end

-- LFD role function
local function addLFDRole(self)
	local lfdRole = self.Health:CreateTexture(nil, 'OVERLAY')
	lfdRole:SetPoint('TOPLEFT', self, 'TOPLEFT', 20, 8)
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

-- Tag function
local function addTags(self, showPower, showHealComm, showCombo)
	local healthValue = self.Health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetPoint('RIGHT', self.Health, 'RIGHT', -2, 0)
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetJustifyH('RIGHT')
	self:Tag(healthValue, '[ep:health]')

	local info = self.Health:CreateFontString(nil, 'OVERLAY')
	info:SetPoint('LEFT', self.Health, 'LEFT', 2, 0)
	info:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	info:SetJustifyH('LEFT')
	if showPower then
		self:Tag(info, '[ep:power< ][ep:druid]')
	else
		self:Tag(info, '[ep:name][|cff0090ff >rare<|r]')
	end

	if showHealComm then
		local healcommtext = self.Health:CreateFontString(nil, 'OVERLAY')
		healcommtext:SetPoint('RIGHT', healthValue, 'LEFT', -config.SPACING, 0)
		healcommtext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		healcommtext:SetTextColor(0, 1, 0)
		healcommtext:SetJustifyH('RIGHT')
		self.HealCommText = healcommtext

		info:SetPoint('RIGHT', healcommtext, 'LEFT', -config.SPACING, 0)
	else
		info:SetPoint('RIGHT', healthValue, 'LEFT', -config.SPACING, 0)
	end

	if showCombo then
		local cpoints = self:CreateFontString(nil, 'OVERLAY')
		cpoints:SetPoint('RIGHT', self, 'LEFT', -config.SPACING, 0)
		cpoints:SetFont(config.FONT, config.FONTSIZELARGE, config.FONTBORDER)
		cpoints:SetJustifyH('RIGHT')
		self:Tag(cpoints, '|cffffffff[cpoints]|r')
	end
end

-- Rune bar function
local function addRuneBar(self)
	local _, class = UnitClass('player')

	if class == 'DEATHKNIGHT' then
		local runes = CreateFrame('Frame', nil, self)
		runes:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		runes:SetSize(230, 4)
		runes:SetBackdrop(config.BACKDROP)
		runes:SetBackdropColor(0, 0, 0)

		for i = 1, 6 do
			local rune = CreateFrame('StatusBar', nil, runes)
			rune:SetSize((230 / 6) - 1, 4)
			rune:SetStatusBarTexture(config.TEXTURE)
			rune:SetBackdrop(config.BACKDROP)
			rune:SetBackdropColor(0, 0, 0)

			if i > 1 then
				rune:SetPoint('LEFT', runes[i - 1], 'RIGHT', 1, 0)
			else
				rune:SetPoint('BOTTOMLEFT', runes, 'BOTTOMLEFT', 1, 0)
			end

			local runeBG = rune:CreateTexture(nil, 'BACKGROUND')
			runeBG:SetAllPoints(rune)
			runeBG:SetTexture(1 / 3, 1 / 3, 1 / 3)

			rune.bg = runeBG
			runes[i] = rune
		end

		self.Runes = runes
	end
end

local UnitSpecific = {
	player = function(self)
		-- Player specific layout code.
		self:SetAttribute('initial-width', 230)
		addMenu(self)
		addPowerBar(self, false, false)
		addCastBar(self, false, false)
		addRaidRole(self)
		addLFDRole(self)
		addPVPFlag(self)
		addHealCommBars(self, true)
		addTags(self, true, true, false)

		-- Turn off some Blizzard stuff
		BuffFrame:Hide()
		BuffFrame:UnregisterEvent('UNIT_AURA')
		TicketStatusFrame:EnableMouse(false)
		TicketStatusFrame:SetFrameStrata('BACKGROUND')

		addBuffs(self, 'TOPRIGHT', Minimap, 'TOPLEFT', -config.SPACING, 0, 83, 344, 36, 25, 'LEFT', 'DOWN')
		addDebuffs(self, 'BOTTOMRIGHT', Minimap, 'BOTTOMLEFT', -config.SPACING, 0, 54, 344, 24, 25, 'LEFT', 'DOWN', false)
		addDebuffHighlightBackdrop(self)
		addRuneBar(self)
	end,

	target = function(self)
		-- Target specific layout code.
		self:SetAttribute('initial-width', 230)
		addMenu(self)
		addPowerBar(self, true, false)
		addCastBar(self, true, false)
		addRaidIcon(self)
		addLFDRole(self)
		addHealCommBars(self, true)
		addTags(self, false, true, true)
		addBuffs(self, 'BOTTOMLEFT', self, 'BOTTOMRIGHT', config.SPACING, 0, 54, 236, 20, 25, 'RIGHT', 'UP')
		addDebuffs(self, 'TOPLEFT', self, 'BOTTOMRIGHT', config.SPACING, -config.SPACING, 54, 236, 20, 25, 'RIGHT', 'DOWN', false)
		addDebuffHighlightBackdrop(self)
	end,

	pet = function(self)
		-- Pet specific layout code.
		self:SetAttribute('initial-width', 130)
		addMenu(self)
		addPowerBar(self, false, true)
		addCastBar(self, false, true)
		addTags(self, true, true, false)
		addDebuffs(self, 'TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0, 25, 85, 3, 25, 'LEFT', 'UP', false)
	end,

	targettarget = function(self)
		-- Targettarget specific layout code.
		self:SetAttribute('initial-width', 144)
		addPowerBar(self, true, false)
		addDebuffs(self, 'TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0, 25, 85, 3, 25, 'LEFT', 'UP', false)
		addTags(self, false, false, false)
	end,

	focus = function(self)
		-- Focus specific layout code.
		self:SetAttribute('initial-width', 144)
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

	addHealthBar(self)
	addRaidIcon(self)

	if UnitSpecific[unit] then
		return UnitSpecific[unit](self)
	end

	self.disallowVehicleSwap = true
end

oUF:RegisterStyle('oUF_EP', Style)

oUF:Factory(function(self)
	self:SetActiveStyle('oUF_EP')

	self:Spawn('player'):SetPoint('CENTER', UIParent, 'CENTER', -220, -250)
	self:Spawn('target'):SetPoint('CENTER', UIParent, 'CENTER', 220, -250)
	self:Spawn('targettarget'):SetPoint('BOTTOMRIGHT', self.units.target, 'TOPRIGHT', 0, config.SPACING)
	self:Spawn('focus'):SetPoint('BOTTOMLEFT', self.units.player, 'TOPLEFT', 0, config.SPACING)
	self:Spawn('pet'):SetPoint('RIGHT', self.units.player, 'LEFT', -25, 0)
end)
