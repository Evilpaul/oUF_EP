-- Big thanks to P3lim, a lot of this code is shamelessly ripped off from his work

local config = oUF_EPConfig

local function SpawnMenu(self)
	ToggleDropDownMenu(1, nil, _G[string.gsub(self.unit, '^.', string.upper) .. 'FrameDropDown'], 'cursor')
end

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

local function PostUpdatePower(element, unit, min, max)
	element:GetParent().Health:SetHeight(max ~= 0 and 21 or 25)
end

local function PostCreateAura(element, button)
	button:SetBackdrop(config.BACKDROP)
	button:SetBackdropColor(0, 0, 0)
	button.cd:SetReverse()
	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer('ARTWORK')
end

local PostUpdateDebuff
do
	local units = {
		vehicle = true,
		player = true,
	}

	local spells = config.DEBUFFS

	function PostUpdateDebuff(element, unit, button, index)
		local _, _, _, _, type, _, _, owner, _, _, spell = UnitAura(unit, index, button.filter)

		if(UnitIsFriend('player', unit) or spells[spell] or units[owner]) then
			local color = DebuffTypeColor[type] or DebuffTypeColor.none
			button:SetBackdropColor(color.r * 3/5, color.g * 3/5, color.b * 3/5)
			button.icon:SetDesaturated(false)
		else
			button:SetBackdropColor(0, 0, 0)
			button.icon:SetDesaturated(true)
		end
	end
end

local CustomBuffFilter
do
	local spells = config.BUFFS

	function CustomBuffFilter(element, ...)
		local _, _, _, _, _, _, _, _, _, _, _, _, spell = ...
		return spells[spell]
	end
end

local function Style(self, unit)
	self.colors = config.COLORS

	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	self:SetBackdrop(config.BACKDROP)
	self:SetBackdropColor(0, 0, 0)

	local petUnit = unit == 'pet'
	local slimUnit = (unit == 'focus' or unit == 'targettarget')

	local health = CreateFrame('StatusBar', nil, self)
	health:SetStatusBarTexture(config.TEXTURE)
	health:SetHeight(21)
	health:SetStatusBarColor(1/4, 1/4, 2/5)

	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints(health)
	healthBG:SetTexture(1/3, 1/3, 1/3)
	health.bg = healthBG

	health:SetPoint('TOPRIGHT', self)
	health:SetPoint('TOPLEFT', self)
	health:SetHeight(21)

	local healthValue = health:CreateFontString(nil, 'OVERLAY')
	healthValue:SetPoint('RIGHT', health, -2, 0)
	healthValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healthValue:SetJustifyH('RIGHT')

	local power = CreateFrame('StatusBar', nil, self)
	power:SetPoint('BOTTOMRIGHT', self)
	power:SetPoint('BOTTOMLEFT', self)
	power:SetPoint('TOP', health, 'BOTTOM', 0, -1)
	power:SetStatusBarTexture(config.TEXTURE)
	power:SetHeight(4)

	power.colorClass = true
	power.colorTapping = true
	power.colorDisconnected = true
	power.colorReaction = not petUnit
	power.colorHappiness = petUnit
	power.colorPower = petUnit

	local powerBG = power:CreateTexture(nil, 'BORDER')
	powerBG:SetAllPoints(power)
	powerBG:SetTexture([=[Interface\ChatFrame\ChatFrameBackground]=])
	powerBG.multiplier = 1 / 3
	power.bg = powerBG

	self:SetAttribute('initial-height', 25)

	if(slimUnit) then
		local debuffs = CreateFrame('Frame', nil, self)
		debuffs:SetHeight(21)
		debuffs:SetWidth(72)
		debuffs.num = 3
		debuffs.size = 21
		debuffs.spacing = config.SPACING
		debuffs.PostCreateIcon = PostCreateAura

		if(unit == 'focus') then
			debuffs:SetPoint('TOPLEFT', self, 'TOPRIGHT', config.SPACING, 0)
			debuffs.initialAnchor = 'TOPLEFT'
			debuffs.onlyShowPlayer = true
		else
			debuffs:SetPoint('TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0)
			debuffs.initialAnchor = 'TOPRIGHT'
			debuffs['growth-x'] = 'LEFT'
		end

		self.Debuffs = debuffs
		self:SetAttribute('initial-width', 161)
	else
		local castbar = CreateFrame('StatusBar', nil, self)
		castbar:SetHeight(16)
		castbar:SetStatusBarTexture(config.TEXTURE)
		castbar:SetStatusBarColor(1/4, 1/4, 2/5)
		castbar:SetBackdrop(config.BACKDROP)
		castbar:SetBackdropColor(0, 0, 0)
		castbar.CustomTimeText = CustomCastText

		local castbarBG = castbar:CreateTexture(nil, 'BORDER')
		castbarBG:SetAllPoints(castbar)
		castbarBG:SetTexture(1/3, 1/3, 1/3)

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
		castbarDummy:SetHeight(21)
		castbarDummy:SetWidth(21)
		castbarDummy:SetBackdrop(config.BACKDROP)
		castbarDummy:SetBackdropColor(0, 0, 0)

		local castbarIcon = castbarDummy:CreateTexture(nil, 'ARTWORK')
		castbarIcon:SetAllPoints(castbarDummy)
		castbarIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		castbar.Icon = castbarIcon

		if(unit == 'target') then
			castbar.PostCastStart = PostCastStart
			castbar.PostChannelStart = PostCastStart
			castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -config.SPACING)
			castbarDummy:SetPoint('TOPLEFT', castbar, 'TOPRIGHT', config.SPACING, 0)
		else
			castbar:SetPoint('TOPRIGHT', self, 'BOTTOMRIGHT', 0, -config.SPACING)
			castbarDummy:SetPoint('TOPRIGHT', castbar, 'TOPLEFT', -config.SPACING, 0)
			castbar.SafeZone = castbar:CreateTexture(nil, 'ARTWORK')
		end

		local raidicon = health:CreateTexture(nil, 'OVERLAY')
		raidicon:SetPoint('TOP', self, 0, 8)
		raidicon:SetHeight(16)
		raidicon:SetWidth(16)

		self.Castbar = castbar
		self.RaidIcon = raidicon

		self.menu = SpawnMenu
		self:SetAttribute('type2', 'menu')
	end

	self.Power = power
	self.Health = health
	self:Tag(healthValue, '[ep:health]')

	if(petUnit or unit == 'player') then
		local powerValue = health:CreateFontString(nil, 'OVERLAY')
		powerValue:SetPoint('LEFT', health, 2, 0)
		powerValue:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		powerValue:SetJustifyH('LEFT')
		self:Tag(powerValue, '[ep:power< ][ep:druid]')
	else
		local name = health:CreateFontString(nil, 'OVERLAY')
		name:SetPoint('LEFT', health, 2, 0)
		name:SetPoint('RIGHT', healthValue, 'LEFT')
		name:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
		name:SetJustifyH('LEFT')
		self:Tag(name, '[ep:name][|cff0090ff >rare<|r]')
	end

	if(unit == 'player' or unit == 'target') then
		local buffs = CreateFrame('Frame', nil, self)
		buffs:SetPoint('BOTTOMLEFT', self, 'BOTTOMRIGHT', config.SPACING, 0)
		buffs:SetHeight(54)
		buffs:SetWidth(236)
		buffs.num = 20
		buffs.size = 25
		buffs.spacing = config.SPACING
		buffs.initialAnchor = 'BOTTOMLEFT'
		buffs['growth-y'] = 'UP'
		buffs.PostCreateIcon = PostCreateAura

		if(unit == 'target') then
			local debuffs = CreateFrame('Frame', nil, self)
			debuffs:SetPoint('TOPLEFT', self, 'BOTTOMRIGHT', config.SPACING, -config.SPACING)
			debuffs:SetHeight(25)
			debuffs:SetWidth(230)
			debuffs.num = 20
			debuffs.size = 25
			debuffs.spacing = config.SPACING
			debuffs.initialAnchor = 'TOPLEFT'
			debuffs['growth-y'] = 'DOWN'
			debuffs.PostCreateIcon = PostCreateAura
			debuffs.PostUpdateIcon = PostUpdateDebuff

			local cpoints = self:CreateFontString(nil, 'OVERLAY')
			cpoints:SetPoint('RIGHT', self, 'LEFT', -config.SPACING, 0)
			cpoints:SetFont(config.FONT, 20, config.FONTBORDER)
			cpoints:SetTextColor(1, 1, 1)
			cpoints:SetJustifyH('RIGHT')

			self.Debuffs = debuffs
			self.CPoints = cpoints
			self.Power.PostUpdate = PostUpdatePower
		else
			buffs.CustomFilter = CustomBuffFilter
			
			local pvpFlag = self.Health:CreateTexture(nil, 'OVERLAY', 0, 8)
			pvpFlag:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 16, 12)
			pvpFlag:SetHeight(32)
			pvpFlag:SetWidth(32)
			self.PvP = pvpFlag
		end

		local leader = health:CreateTexture(nil, 'OVERLAY')
		leader:SetPoint('TOPLEFT', self, 0, 8)
		leader:SetHeight(16)
		leader:SetWidth(16)

		local assistant = health:CreateTexture(nil, 'OVERLAY')
		assistant:SetPoint('TOPLEFT', self, 0, 8)
		assistant:SetHeight(16)
		assistant:SetWidth(16)

		local lfdRole = health:CreateTexture(nil, 'OVERLAY')
		lfdRole:SetPoint('TOPLEFT', self, 20, 8)
		lfdRole:SetHeight(16)
		lfdRole:SetWidth(16)

		self.Leader = leader
		self.Assistant = assistant
		self.LFDRole = lfdRole

		self.Buffs = buffs
		self:SetAttribute('initial-width', 230)
	end

	if(petUnit) then
		local auras = CreateFrame('Frame', nil, self)
		auras:SetPoint('TOPRIGHT', self, 'TOPLEFT', -config.SPACING, 0)
		auras:SetHeight(44)
		auras:SetWidth(256)
		auras.size = 22
		auras.spacing = config.SPACING
		auras.initialAnchor = 'TOPRIGHT'
		auras['growth-x'] = 'LEFT'
		auras.PostCreateIcon = PostCreateAura

		self.Auras = auras
		self:SetAttribute('initial-width', 130)
	end

	-- add border colouring for any debuff
	self.EPDebuffBackdrop = true
	self.EPDebuffBackdropFilter = false

	local healcommbar = CreateFrame('StatusBar', nil, health)
	healcommbar:SetStatusBarTexture(config.TEXTURE)
	healcommbar:SetStatusBarColor(0, 1, 0, 0.25)
	healcommbar:SetPoint('LEFT', health, 'LEFT')
	self.HealCommBar = healcommbar
	self.allowHealCommOverflow = true

	local healcommtext = health:CreateFontString(nil, 'OVERLAY')
	healcommtext:SetPoint('LEFT', name and name or health, 2, 0)
	healcommtext:SetPoint('RIGHT', healthValue, 'LEFT', -5, 0)
	healcommtext:SetFont(config.FONT, config.FONTSIZE, config.FONTBORDER)
	healcommtext:SetTextColor(0, 1, 0)
	healcommtext:SetJustifyH('RIGHT')
	self.HealCommText = healcommtext
end

oUF:RegisterStyle('oUF_EP', Style)
oUF:SetActiveStyle('oUF_EP')

oUF:Spawn('player'):SetPoint('CENTER', -220, -250)
oUF:Spawn('target'):SetPoint('CENTER', 220, -250)
oUF:Spawn('targettarget'):SetPoint('BOTTOMRIGHT', oUF.units.target, 'TOPRIGHT', 0, config.SPACING)
oUF:Spawn('focus'):SetPoint('BOTTOMLEFT', oUF.units.player, 'TOPLEFT', 0, config.SPACING)
oUF:Spawn('pet'):SetPoint('RIGHT', oUF.units.player, 'LEFT', -25, 0)
