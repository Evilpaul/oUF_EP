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

-- Generic PostCreateIcon function
local PostCreateIcon
do
	local format = string.format

	local function UpdateTooltip(self)
		GameTooltip:SetUnitAura(self.parent:GetParent().unit, self:GetID(), self.filter)

		if self.owner and UnitExists(self.owner) then
			GameTooltip:AddLine(format('Cast by %s', UnitName(self.owner) or UNKNOWN))
		end

		GameTooltip:Show()
	end

	function PostCreateIcon(element, button)
		button:SetBackdrop(config.BACKDROP)
		button:SetBackdropColor(0, 0, 0)

		button.count:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)

		button.UpdateTooltip = UpdateTooltip

		button.cd:SetReverse()

		button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon:SetDrawLayer('ARTWORK')
	end
end

-- auras function
local addAuras
do
	local spellIDs = config.AURAFILTER

	local function CustomAuraFilter(icons, _, icon, name, _, _, _, _, _, _, caster, _, _, spellID)
		local isPlayer

		if(caster == 'player' or caster == 'vehicle') then
			isPlayer = true
		end

		if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
			icon.isPlayer = isPlayer
			icon.owner = caster
		end

		return spellIDs[spellID]
	end

	function addAuras(self, position)
		local auras = CreateFrame('Frame', nil, self)
		auras:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or self, position.relativePoint, position.offsetX, position.offsetY)
		auras:SetSize(position.width, position.height)
		auras.numBuffs = position.numBuffs
		auras.numDebuffs = position.numDebuffs
		auras.size = position.size
		auras.spacing = config.SPACING
		auras.initialAnchor = position.anchorPoint
		auras['growth-x'] = position.growthX
		auras['growth-y'] = position.growthY
		auras.PostCreateIcon = PostCreateIcon

		if position.filter then
			auras.CustomFilter = CustomAuraFilter
		end

		self.Auras = auras
	end
end

-- filter function (buffs and debuffs)
local CustomBuffFilter
do
	local spellIDs = config.AURAFILTER

	function CustomBuffFilter(icons, _, icon, name, _, _, _, _, _, _, caster, _, _, spellID)
		local isPlayer

		if(caster == 'player' or caster == 'vehicle') then
			isPlayer = true
		end

		if((icons.onlyShowPlayer and isPlayer) or (not icons.onlyShowPlayer and name)) then
			icon.isPlayer = isPlayer
			icon.owner = caster
		end

		return not spellIDs[spellID]
	end
end

-- buffs function
local function addBuffs(self, position)
	local buffs = CreateFrame('Frame', nil, self)
	buffs:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or self, position.relativePoint, position.offsetX, position.offsetY)
	buffs:SetSize(position.width, position.height)
	buffs.num = position.number
	buffs.size = position.size
	buffs.spacing = config.SPACING
	buffs.initialAnchor = position.anchorPoint
	buffs['growth-x'] = position.growthX
	buffs['growth-y'] = position.growthY
	buffs.PostCreateIcon = PostCreateIcon

	if position.filter then
		buffs.CustomFilter = CustomBuffFilter
	end

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

	function addDebuffs(self, position)
		local debuffs = CreateFrame('Frame', nil, self)
		debuffs:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or self, position.relativePoint, position.offsetX, position.offsetY)
		debuffs:SetSize(position.width, position.height)
		debuffs.num = position.number
		debuffs.size = position.size
		debuffs.spacing = config.SPACING
		debuffs.initialAnchor = position.anchorPoint
		debuffs['growth-x'] = position.growthX
		debuffs['growth-y'] = position.growthY
		debuffs.onlyShowPlayer = position.playerOnly
		debuffs.PostCreateIcon = PostCreateIcon
		debuffs.PostUpdateIcon = PostUpdateIcon

		if position.filter then
			debuffs.CustomFilter = CustomBuffFilter
		end

		self.Debuffs = debuffs
	end
end

-- temporary enchants function
local addWeaponEnchants
do
	local function PostCreateEnchantIcon(element, button)
		button:SetBackdrop(config.BACKDROP)
		button:SetBackdropColor(0, 0, 0)

		button.count:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)

		button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon:SetDrawLayer('ARTWORK')
	end

	function addWeaponEnchants(self, position)
		local enchants = CreateFrame('Frame', nil, self)
		enchants:SetPoint(position.anchorPoint, position.relativeFrame and position.relativeFrame or self, position.relativePoint, position.offsetX, position.offsetY)
		enchants:SetSize(position.width, position.height)
		enchants.num = position.number
		enchants.size = position.size
		enchants.spacing = config.SPACING
		enchants.initialAnchor = position.anchorPoint
		enchants['growth-x'] = position.growthX
		enchants['growth-y'] = position.growthY
		enchants.PostCreateIcon = PostCreateEnchantIcon

		self.Enchants = enchants
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
		local relativeFrame = self.VengeanceBar and self.VengeanceBar or
					self.Runes and self.Runes or
					self.TotemBar and self.TotemBar or
					self.SoulShards and self.SoulShards or
					self.HolyPower and self.HolyPower or
					self.EclipseBar and self.EclipseBar or
					self

		local castbar = CreateFrame('StatusBar', nil, self)
		castbar:SetSize((isPet and config.SECONDARYUNITWIDTH or config.PRIMARYUNITWIDTH) - 25, 16)
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
		castbarText:SetPoint('RIGHT', castbarTime, 'LEFT', -config.SPACING, 0)
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
			castbar:SetPoint('TOPLEFT', relativeFrame, 'BOTTOMLEFT', 0, -config.SPACING)
			castbarDummy:SetPoint('TOPLEFT', castbar, 'TOPRIGHT', config.SPACING, 0)
		else
			castbar:SetPoint('TOPRIGHT', relativeFrame, 'BOTTOMRIGHT', 0, -config.SPACING)
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

-- quest icon function
local function addQuestIcon(self)
	local qicon = self.Health:CreateTexture(nil, 'OVERLAY')
	qicon:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	qicon:SetSize(16, 16)

	self.QuestIcon = qicon
end

-- phase icon function
local function addPhaseIcon(self)
	local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	picon:SetPoint('TOPLEFT', self, 'TOPLEFT', 40, 8)
	picon:SetSize(16, 16)

	self.PhaseIcon = picon
end

-- pvp flag function
local function addPVPFlag(self)
	local pvpFlag = self.Health:CreateTexture(nil, 'OVERLAY')
	pvpFlag:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 16, 12)
	pvpFlag:SetSize(32, 32)

	self.PvP = pvpFlag
end

-- Tag function
local function addTags(self, showPower, showHealPrediction, showCombo)
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

	if showHealPrediction then
		local healpredictiontext = self.Health:CreateFontString(nil, 'OVERLAY')
		healpredictiontext:SetPoint('RIGHT', healthValue, 'LEFT', -config.SPACING, 0)
		healpredictiontext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		healpredictiontext:SetJustifyH('RIGHT')
		self:Tag(healpredictiontext, '[|cff00ff00 >ep:healprediction<|r]')

		info:SetPoint('RIGHT', healpredictiontext, 'LEFT', -config.SPACING, 0)
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
		runes:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		runes:SetBackdrop(config.BACKDROP)
		runes:SetBackdropColor(0, 0, 0)

		for i = 1, 6 do
			local rune = CreateFrame('StatusBar', nil, runes)
			rune:SetSize((config.PRIMARYUNITWIDTH / 6) - 1, config.SPACING)
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

-- Totem bar function
local function addTotemBar(self)
	local _, class = UnitClass('player')

	if IsAddOnLoaded('oUF_TotemBar') and class == 'SHAMAN' then
		local totems = CreateFrame('Frame', nil, self)
		totems:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		totems:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		totems:SetBackdrop(config.BACKDROP)
		totems:SetBackdropColor(0, 0, 0)

		totems.Destroy = true

		for i = 1, MAX_TOTEMS do
			local totem = CreateFrame('StatusBar', nil, self)
			totem:SetSize((config.PRIMARYUNITWIDTH / MAX_TOTEMS) - 1, config.SPACING)
			totem:SetStatusBarTexture(config.TEXTURE)
			totem:SetBackdrop(config.BACKDROP)
			totem:SetBackdropColor(0, 0, 0)
			totem:SetMinMaxValues(0, 1)

			if i > 1 then
				totem:SetPoint('LEFT', totems[i - 1], 'RIGHT', 1, 0)
			else
				totem:SetPoint('BOTTOMLEFT', totems, 'BOTTOMLEFT', 1, 0)
			end

			local totemBG = totem:CreateTexture(nil, 'BACKGROUND')
			totemBG:SetAllPoints(totem)
			totemBG:SetTexture(1 / 3, 1 / 3, 1/ 3)

			totem.bg = totemBG
			totems[i] = totem
		end

		self.TotemBar = totems
	end
end

-- Soul Shards function
local function addSoulShards(self)
	local _, class = UnitClass('player')

	if class == 'WARLOCK' then
		local shards = CreateFrame('Frame', nil, self)
		shards:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		shards:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		shards:SetBackdrop(config.BACKDROP)
		shards:SetBackdropColor(0, 0, 0)

		for i = 1, SHARD_BAR_NUM_SHARDS do
			local shard = shards:CreateTexture(nil, 'OVERLAY')
			shard:SetSize((config.PRIMARYUNITWIDTH / SHARD_BAR_NUM_SHARDS) - 1, config.SPACING)
			shard:SetTexture(1, 3 / 5, 0)

			if i > 1 then
				shard:SetPoint('LEFT', shards[i - 1], 'RIGHT', 1, 0)
			else
				shard:SetPoint('BOTTOMLEFT', shards, 'BOTTOMLEFT', 1, 0)
			end

			shards[i] = shard
		end

		self.SoulShards = shards
	end
end

-- Holy Power function
local function addHolyPower(self)
	local _, class = UnitClass('player')

	if class == 'PALADIN' then
		local holypower = CreateFrame('Frame', nil, self)
		holypower:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		holypower:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		holypower:SetBackdrop(config.BACKDROP)
		holypower:SetBackdropColor(0, 0, 0)

		for i = 1, MAX_HOLY_POWER do
			local holyRune = holypower:CreateTexture(nil, 'OVERLAY')
			holyRune:SetSize((config.PRIMARYUNITWIDTH / MAX_HOLY_POWER) - 1, config.SPACING)
			holyRune:SetTexture(1, 3 / 5, 0)

			if i > 1 then
				holyRune:SetPoint('LEFT', holypower[i - 1], 'RIGHT', 1, 0)
			else
				holyRune:SetPoint('BOTTOMLEFT', holypower, 'BOTTOMLEFT', 1, 0)
			end

			holypower[i] = holyRune
		end

		self.HolyPower = holypower
	end
end

-- Eclipse Bar function
local function addEclipseBar(self)
	local _, class = UnitClass('player')

	if class == 'DRUID' then
		local eclipseBar = CreateFrame('Frame', nil, self)
		eclipseBar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -1)
		eclipseBar:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		eclipseBar:SetBackdrop(config.BACKDROP)
		eclipseBar:SetBackdropColor(0, 0, 0)

		local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
		lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
		lunarBar:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		lunarBar:SetStatusBarTexture(config.TEXTURE)
		lunarBar:SetStatusBarColor(0, 0, 1)
		eclipseBar.LunarBar = lunarBar

		local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
		solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
		solarBar:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		solarBar:SetStatusBarTexture(config.TEXTURE)
		solarBar:SetStatusBarColor(1, 3/5, 0)
		eclipseBar.SolarBar = solarBar

		local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
		eclipseBarText:SetPoint('CENTER', eclipseBar, 'CENTER', 0, 0)
		eclipseBarText:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		self:Tag(eclipseBarText, '[pereclipse]%')

		self.EclipseBar = eclipseBar
	end
end

-- Vengeance Bar function
local function addVengeanceBar(self)
	local _, class = UnitClass('player')

	if class == 'DEATHKNIGHT' or class == 'DRUID' or class == 'PALADIN' or class == 'WARRIOR'then
		local anchor = self.Runes and self.Runes or self.HolyPower and self.HolyPower or self

		local vengeanceBar = CreateFrame('Frame', nil, self)
		vengeanceBar:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -1)
		vengeanceBar:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		vengeanceBar:SetBackdrop(config.BACKDROP)
		vengeanceBar:SetBackdropColor(0, 0, 0)

		local statusBar = CreateFrame('StatusBar', nil, vengeanceBar)
		statusBar:SetPoint('LEFT', vengeanceBar, 'LEFT', 0, 0)
		statusBar:SetSize(config.PRIMARYUNITWIDTH, config.SPACING)
		statusBar:SetStatusBarTexture(config.TEXTURE)
		statusBar:SetStatusBarColor(0, 0, 1)
		vengeanceBar.Bar = statusBar

		local vengeanceBarText = statusBar:CreateFontString(nil, 'OVERLAY')
		vengeanceBarText:SetPoint('CENTER', statusBar, 'CENTER', 0, 0)
		vengeanceBarText:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		vengeanceBar.Text = vengeanceBarText

		self.VengeanceBar = vengeanceBar
	end
end

local UnitSpecific
do
	local addDebuffHighlightBackdrop = ns.addDebuffHighlightBackdrop
	local addHealPredictionBars = ns.addHealPredictionBars
	local addMenu = ns.addMenu

	UnitSpecific = {
		player = function(self)
			-- Player specific layout code.
			self:SetWidth(config.PRIMARYUNITWIDTH)
			addMenu(self)
			addPowerBar(self)
			addRaidRole(self)
			addLFDRole(self)
			addPVPFlag(self)
			addHealPredictionBars(self, config.PRIMARYUNITWIDTH, true)
			addTags(self, true, true, false)

			-- Turn off some Blizzard stuff
			BuffFrame:Hide()
			BuffFrame:UnregisterEvent('UNIT_AURA')
			TemporaryEnchantFrame:Hide()
			TicketStatusFrame:EnableMouse(false)
			TicketStatusFrame:SetFrameStrata('BACKGROUND')

			addAuras(self, config.AURAPOSITIONS)
			addBuffs(self, config.BUFFPOSITIONS.player)
			addDebuffs(self, config.DEBUFFPOSITIONS.player)
			addWeaponEnchants(self, config.TEMPENCHANTPOSITIONS)
			addDebuffHighlightBackdrop(self)
			addRuneBar(self)
			addTotemBar(self)
			addSoulShards(self)
			addHolyPower(self)
			addEclipseBar(self)
			addVengeanceBar(self)

			addCastBar(self, false, false)
		end,

		target = function(self)
			-- Target specific layout code.
			self:SetWidth(config.PRIMARYUNITWIDTH)
			addMenu(self)
			addPowerBar(self)
			addLFDRole(self)
			addQuestIcon(self)
			addPhaseIcon(self)
			addHealPredictionBars(self, config.PRIMARYUNITWIDTH, true)
			addTags(self, false, true, true)
			addBuffs(self, config.BUFFPOSITIONS.target)
			addDebuffs(self, config.DEBUFFPOSITIONS.target)
			addDebuffHighlightBackdrop(self)

			addCastBar(self, true, false)
		end,

		pet = function(self)
			-- Pet specific layout code.
			self:SetWidth(config.SECONDARYUNITWIDTH)
			addMenu(self)
			addPowerBar(self)
			addTags(self, true, true, false)
			addDebuffs(self, config.DEBUFFPOSITIONS.pet)

			addCastBar(self, false, true)
		end,

		targettarget = function(self)
			-- Targettarget specific layout code.
			self:SetWidth(config.SECONDARYUNITWIDTH)
			addMenu(self)
			addPowerBar(self)
			addDebuffs(self, config.DEBUFFPOSITIONS.targettarget)
			addTags(self, false, false, false)
		end,

		focus = function(self)
			-- Focus specific layout code.
			self:SetWidth(config.SECONDARYUNITWIDTH)
			addMenu(self)
			addPowerBar(self)
			addQuestIcon(self)
			addDebuffs(self, config.DEBUFFPOSITIONS.focus)
			addTags(self, false, false, false)
		end,
	}
end

local Style
do
	local addHealthBar = ns.addHealthBar
	local addRaidIcon = ns.addRaidIcon

	function Style(self, unit)
		-- Shared layout code.
		self:RegisterForClicks('AnyUp')
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)

		self:SetBackdrop(config.BACKDROP)
		self:SetBackdropColor(0, 0, 0)

		self:SetHeight(config.UNITHEIGHT)

		addHealthBar(self)
		addRaidIcon(self)

		if UnitSpecific[unit] then
			return UnitSpecific[unit](self)
		end
	end
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
