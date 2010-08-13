local _, ns = ...
local playerName, _ = UnitName('player')

local spacing = 4
local unitHeight = 25 -- should always equal healthHeight + powerHeight
local auraFilter = {
	-- General buffs
	[10060] = true, -- Buff: Power Infusion
	[15359] = true, -- Buff: Inspiration
	[16240] = true, -- Buff: Ancestral Healing
	[29166] = true, -- Buff: Innervate
	[32182] = true, -- Buff: Heroism
	[33206] = true, -- Buff: Pain Suppression
	[47788] = true, -- Buff: Guardian Spirit
	[49016] = true, -- Buff: Hysteria
}

if playerName == 'Evilbadger' then
	-- Class specific buffs
	auraFilter[5229] = true  -- Druid: Enrage
	auraFilter[16870] = true -- Druid: Clearcast
	auraFilter[22812] = true -- Druid: Barkskin
	auraFilter[22842] = true -- Druid: Frenzied Regeneration
	auraFilter[33357] = true -- Druid: Dash
	auraFilter[50213] = true -- Druid: Tiger's Fury
	auraFilter[50334] = true -- Druid: Berserk
	auraFilter[52610] = true -- Druid: Savage Roar
	auraFilter[61336] = true -- Druid: Survival Instincts
	auraFilter[62606] = true -- Druid: Savage Defense
	auraFilter[69369] = true -- Druid: Predator's Swiftness

	-- Tier procs
	auraFilter[70725] = true -- Druid: Enraged Defense (4-part T-10)

	-- Trinket procs
	auraFilter[60233] = true -- Darkmoon Card: Greatness (Agility)
	auraFilter[67694] = true -- Glyph of Indomitability
	auraFilter[67699] = true -- Satrina's Impeding Scarab (normal)
	auraFilter[71575] = true -- Unidentifiable Organ (normal)
	auraFilter[71586] = true -- Corroded Skeleton Key
	auraFilter[71396] = true -- Herkuml War Token
	auraFilter[71403] = true -- Needle-Encrusted Scorpion

	-- Weapon Proc
	auraFilter[28093] = true -- Mongoose

	-- Ring proc
	auraFilter[72414] = true -- ICC Rep Ring

	-- Relic
	auraFilter[71175] = true -- Idol of the Crying Moon

elseif playerName == 'Evilmagic' then
	-- Class specific buffs
	auraFilter[12042] = true -- Mage: Arcane Power
	auraFilter[12043] = true -- Mage: Presence of Mind
	auraFilter[12472] = true -- Mage: Icy Veins
	auraFilter[12536] = true -- Mage: Clearcasting (Arcane Concentration)
	auraFilter[32612] = true -- Mage: Invisibility
	auraFilter[36032] = true -- Mage: Arcane Blast (Debuff)
	auraFilter[44401] = true -- Mage: Missile Barrage
	auraFilter[45438] = true -- Mage: Ice Block
	auraFilter[54648] = true -- Mage: Focus Magic
	auraFilter[55342] = true -- Mage: Mirror Image
	auraFilter[57531] = true -- Mage: Arcane Potency

	-- Tier procs
	auraFilter[70747] = true -- Mage: Quad Core (4-part T-10)
	auraFilter[70753] = true -- Mage: Pushing the Limit (2-part T-10)

	-- Trinket procs
	auraFilter[67669] = true -- Abyssal Rune
	auraFilter[67684] = true -- Talisman of Resurgance

	-- Trade skill buffs
	auraFilter[55637] = true -- Lightweave Embroidery

elseif playerName == 'Evilpaul' then
	-- Class specific buffs
	auraFilter[14751] = true -- Priest: Inner Focus
	auraFilter[33151] = true -- Priest: Surge of Light
	auraFilter[59891] = true -- Priest: Borrowed Time
	auraFilter[63725] = true -- Priest: Holy Concentration
	auraFilter[63734] = true -- Priest: Serendipity
	auraFilter[63944] = true -- Priest: Renewed Hope

	-- Trinket procs
	auraFilter[60525] = true -- Majestic Dragon Figurine
	auraFilter[71564] = true -- Nevermelting Ice Crystal
	auraFilter[71568] = true -- Ephemeral Snowflake

	-- Ring proc
	auraFilter[72418] = true -- ICC Rep Ring

elseif playerName == 'Evilundead' then
	-- Class specific buffs
	auraFilter[871] = true   -- Warrior: Shield Wall
	auraFilter[2565] = true  -- Warrior: Shield Block
	auraFilter[12328] = true -- Warrior: Sweeping Strikes
	auraFilter[12976] = true -- Warrior: Last Stand
	auraFilter[18499] = true -- Warrior: Berserker Rage
	auraFilter[23920] = true -- Warrior: Spell Reflection
	auraFilter[29131] = true -- Warrior: Bloodrage
	auraFilter[46924] = true -- Warrior: Bladestorm
	auraFilter[50227] = true -- Warrior: Sword and Board
	auraFilter[52437] = true -- Warrior: Sudden Death
	auraFilter[55694] = true -- Warrior: Enraged Regeneration
	auraFilter[57516] = true -- Warrior: Enrage (Improved Defensive Stance)
	auraFilter[57522] = true -- Warrior: Enrage (Wrecking Crew)
	auraFilter[60503] = true -- Warrior: Taste for Blood
	auraFilter[65156] = true -- Warrior: Juggernaut

	-- Trinket procs
	auraFilter[67671] = true -- Banner of Victory
	auraFilter[71403] = true -- Needle-Encrusted Scorpion
	auraFilter[67631] = true -- The Black Heart
	auraFilter[67694] = true -- Glyph of Indomitability

	-- Weapon Proc
	auraFilter[28093] = true -- Mongoose
	auraFilter[59620] = true -- Berserking

	-- Ring proc
	auraFilter[72414] = true -- ICC Rep Ring

	-- Glyph Proc
	auraFilter[58363] = true -- Glyph of Revenge
	auraFilter[58374] = true -- Glyph of Blocking

	-- Trade skill buffs
	auraFilter[55503] = true -- Lifeblood

end

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
			offsetX = -spacing,
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

----------------------------
-- Do not edit below here --
----------------------------
ns.config = config
