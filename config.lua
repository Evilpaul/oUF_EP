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

	AURAFILTER = {
		-- General buffs
		[10060] = true, -- Buff: Power Infusion
		[15359] = true, -- Buff: Inspiration
		[16240] = true, -- Buff: Ancestral Healing
		[29166] = true, -- Buff: Innervate
		[32182] = true, -- Buff: Heroism
		[33206] = true, -- Buff: Pain Suppression
		[47788] = true, -- Buff: Guardian Spirit
		[49016] = true, -- Buff: Hysteria
	},

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
		number = 8,
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

local _, playerClass = UnitClass('player')

if playerClass == 'DRUID' then
	-- Class specific buffs
	config.AURAFILTER[5229] = true  -- Druid: Enrage
	config.AURAFILTER[16870] = true -- Druid: Clearcast
	config.AURAFILTER[22812] = true -- Druid: Barkskin
	config.AURAFILTER[22842] = true -- Druid: Frenzied Regeneration
	config.AURAFILTER[33357] = true -- Druid: Dash
	config.AURAFILTER[50213] = true -- Druid: Tiger's Fury
	config.AURAFILTER[50334] = true -- Druid: Berserk
	config.AURAFILTER[52610] = true -- Druid: Savage Roar
	config.AURAFILTER[61336] = true -- Druid: Survival Instincts
	config.AURAFILTER[62606] = true -- Druid: Savage Defense
	config.AURAFILTER[69369] = true -- Druid: Predator's Swiftness

	-- Tier procs
	config.AURAFILTER[70725] = true -- Druid: Enraged Defense (4-part T-10)

	-- Trinket procs
	config.AURAFILTER[60233] = true -- Darkmoon Card: Greatness (Agility)
	config.AURAFILTER[67694] = true -- Glyph of Indomitability
	config.AURAFILTER[67699] = true -- Satrina's Impeding Scarab (normal)
	config.AURAFILTER[71575] = true -- Unidentifiable Organ (normal)
	config.AURAFILTER[71586] = true -- Corroded Skeleton Key
	config.AURAFILTER[71396] = true -- Herkuml War Token
	config.AURAFILTER[71403] = true -- Needle-Encrusted Scorpion

	-- Weapon Proc
	config.AURAFILTER[28093] = true -- Mongoose

	-- Ring proc
	config.AURAFILTER[72414] = true -- ICC Rep Ring (Tank)

	-- Relic
	config.AURAFILTER[71175] = true -- Idol of the Crying Moon

elseif playerClass == 'MAGE' then
	-- Class specific buffs
	config.AURAFILTER[12042] = true -- Mage: Arcane Power
	config.AURAFILTER[12043] = true -- Mage: Presence of Mind
	config.AURAFILTER[12472] = true -- Mage: Icy Veins
	config.AURAFILTER[12536] = true -- Mage: Clearcasting (Arcane Concentration)
	config.AURAFILTER[32612] = true -- Mage: Invisibility
	config.AURAFILTER[36032] = true -- Mage: Arcane Blast (Debuff)
	config.AURAFILTER[44401] = true -- Mage: Missile Barrage
	config.AURAFILTER[45438] = true -- Mage: Ice Block
	config.AURAFILTER[54648] = true -- Mage: Focus Magic
	config.AURAFILTER[55342] = true -- Mage: Mirror Image
	config.AURAFILTER[57531] = true -- Mage: Arcane Potency

	-- Tier procs
	config.AURAFILTER[70747] = true -- Mage: Quad Core (4-part T-10)
	config.AURAFILTER[70753] = true -- Mage: Pushing the Limit (2-part T-10)

	-- Trinket procs
	config.AURAFILTER[67669] = true -- Abyssal Rune
	config.AURAFILTER[67684] = true -- Talisman of Resurgance

	-- Trade skill buffs
	config.AURAFILTER[55637] = true -- Lightweave Embroidery

elseif playerClass == 'PRIEST' then
	-- Class specific buffs
	config.AURAFILTER[14751] = true -- Priest: Inner Focus
	config.AURAFILTER[33151] = true -- Priest: Surge of Light
	config.AURAFILTER[59891] = true -- Priest: Borrowed Time
	config.AURAFILTER[63725] = true -- Priest: Holy Concentration
	config.AURAFILTER[63734] = true -- Priest: Serendipity
	config.AURAFILTER[63944] = true -- Priest: Renewed Hope

	-- Trinket procs
	config.AURAFILTER[60525] = true -- Majestic Dragon Figurine
	config.AURAFILTER[71564] = true -- Nevermelting Ice Crystal
	config.AURAFILTER[71568] = true -- Ephemeral Snowflake

	-- Ring proc
	config.AURAFILTER[72418] = true -- ICC Rep Ring (Healer)

elseif playerClass == 'WARRIOR' then
	-- Class specific buffs
	config.AURAFILTER[871] = true   -- Warrior: Shield Wall
	config.AURAFILTER[2565] = true  -- Warrior: Shield Block
	config.AURAFILTER[12328] = true -- Warrior: Sweeping Strikes
	config.AURAFILTER[12976] = true -- Warrior: Last Stand
	config.AURAFILTER[18499] = true -- Warrior: Berserker Rage
	config.AURAFILTER[23920] = true -- Warrior: Spell Reflection
	config.AURAFILTER[29131] = true -- Warrior: Bloodrage
	config.AURAFILTER[46924] = true -- Warrior: Bladestorm
	config.AURAFILTER[50227] = true -- Warrior: Sword and Board
	config.AURAFILTER[52437] = true -- Warrior: Sudden Death
	config.AURAFILTER[55694] = true -- Warrior: Enraged Regeneration
	config.AURAFILTER[57516] = true -- Warrior: Enrage (Improved Defensive Stance)
	config.AURAFILTER[57522] = true -- Warrior: Enrage (Wrecking Crew)
	config.AURAFILTER[60503] = true -- Warrior: Taste for Blood
	config.AURAFILTER[65156] = true -- Warrior: Juggernaut

	-- Trinket procs
	config.AURAFILTER[67671] = true -- Banner of Victory
	config.AURAFILTER[71403] = true -- Needle-Encrusted Scorpion
	config.AURAFILTER[67631] = true -- The Black Heart
	config.AURAFILTER[67694] = true -- Glyph of Indomitability

	-- Weapon Proc
	config.AURAFILTER[28093] = true -- Mongoose
	config.AURAFILTER[59620] = true -- Berserking

	-- Ring proc
	config.AURAFILTER[72414] = true -- ICC Rep Ring (Tank)

	-- Glyph Proc
	config.AURAFILTER[58363] = true -- Glyph of Revenge
	config.AURAFILTER[58374] = true -- Glyph of Blocking

	-- Trade skill buffs
	config.AURAFILTER[55503] = true -- Lifeblood

end

----------------------------
-- Do not edit below here --
----------------------------
ns.config = config
