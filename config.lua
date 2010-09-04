local _, ns = ...

local spacing = 4
local unitHeight = 25 -- should always equal healthHeight + powerHeight

local config = {
	FONT = [=[Interface\AddOns\oUF_EP\fonts\Sansation_Regular.ttf]=],
	FONTSIZE = 12,
	FONTSIZESMALL = 10,
	FONTSIZELARGE = 20,
	FONTBORDER = 'THINOUTLINE',

	TEXTURE = [=[Interface\AddOns\oUF_EP\media\minimalist]=],

	BACKDROP = {
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		insets = {
			top = -1 * (768 / 1080),
			bottom = -1 * (768 / 1080),
			left = -1 * (768 / 1080),
			right = -1 * (768 / 1080)
		}
	},

	SPACING = spacing,

	HEALTHHEIGHT = 21,
	POWERHEIGHT = 4,
	UNITHEIGHT = unitHeight,

	PRIMARYUNITWIDTH = 230, -- primary frames (player & target)
	SECONDARYUNITWIDTH = 144, -- secondary frames (pet, focus & targettarget)
	TERTIARYUNITWIDTH = 100, -- tertiary frames (maintank, maintanktarget, boss, arena, arenatarget)
	RAIDUNITWIDTH = 25, -- raid frames

	AURAFILTER = {}, -- values are set within aurafilter.lua

	BUFFPOSITIONS = {
		player = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = Minimap,
			relativePoint = 'TOPLEFT',
			offsetX = -spacing,
			offsetY = 0,
			height = 83,
			width = 344,
			number = 36,
			size = unitHeight,
			growthX = 'LEFT',
			growthY = 'DOWN',
			filter = true,
		},
		target = {
			anchorPoint = 'BOTTOMLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'BOTTOMRIGHT',
			offsetX = spacing,
			offsetY = 0,
			height = 54,
			width = 236,
			number = 20,
			size = unitHeight,
			growthX = 'RIGHT',
			growthY = 'UP',
			filter = false,
		},
	},

	DEBUFFPOSITIONS = {
		player = {
			anchorPoint = 'BOTTOMRIGHT',
			relativeFrame = Minimap,
			relativePoint = 'BOTTOMLEFT',
			offsetX = -spacing,
			offsetY = 0,
			height = 54,
			width = 344,
			number = 24,
			size = unitHeight,
			growthX = 'LEFT',
			growthY = 'DOWN',
			playerOnly = false,
			filter = true,
		},
		target = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'BOTTOMRIGHT',
			offsetX = spacing,
			offsetY = -spacing,
			height = 54,
			width = 236,
			number = 20,
			size = unitHeight,
			growthX = 'RIGHT',
			growthY = 'DOWN',
			playerOnly = false,
			filter = false,
		},
		pet = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = -spacing,
			offsetY = 0,
			height = 25,
			width = 85,
			number = 3,
			size = unitHeight,
			growthX = 'LEFT',
			growthY = 'UP',
			playerOnly = false,
			filter = false,
		},
		targettarget = {
			anchorPoint = 'TOPRIGHT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPLEFT',
			offsetX = -spacing,
			offsetY = 0,
			height = 25,
			width = 85,
			number = 3,
			size = unitHeight,
			growthX = 'LEFT',
			growthY = 'UP',
			playerOnly = false,
			filter = false,
		},
		focus = {
			anchorPoint = 'TOPLEFT',
			relativeFrame = nil, -- default to self
			relativePoint = 'TOPRIGHT',
			offsetX = spacing,
			offsetY = 0,
			height = 25,
			width = 85,
			number = 3,
			size = unitHeight,
			growthX = 'RIGHT',
			growthY = 'UP',
			playerOnly = true,
			filter = false,
		},
	},

	AURAPOSITIONS = {
		anchorPoint = 'BOTTOMLEFT',
		relativeFrame = nil, -- default to self
		relativePoint = 'BOTTOMRIGHT',
		offsetX = spacing,
		offsetY = 0,
		height = 83,
		width = 112,
		numBuffs = 8,
		numDebuffs = 1, -- only arcane mage cares, so far
		size = unitHeight,
		growthX = 'RIGHT',
		growthY = 'UP',
		filter = true,
	},

	TEMPENCHANTPOSITIONS = {
		anchorPoint = 'BOTTOMRIGHT',
		relativeFrame = Minimap,
		relativePoint = 'BOTTOMLEFT',
		offsetX = -spacing,
		offsetY = -54,
		height = 25,
		width = 54,
		number = 2,
		size = unitHeight,
		growthX = 'LEFT',
		growthY = 'DOWN',
	},
}

----------------------------
-- Do not edit below here --
----------------------------
ns.config = config
