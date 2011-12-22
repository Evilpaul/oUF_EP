local _, ns = ...
local config = ns.config

----------------------------


local RaceSpecific = {
	BloodElf = function()
	end,

	Draenei = function()
	end,

	Dwarf = function()
		config.AURAFILTER[65116] = true -- Stoneform
	end,

	Gnome = function()
	end,

	Goblin = function()
	end,

	Human = function()
	end,

	NightElf = function()
	end,

	Orc = function()
	end,

	Tauren = function()
	end,

	Troll = function()
	end,

	Undead = function()
	end,

	Worgen = function()
	end,
}

local RoleSpecific = {
	CASTER = function()
		-- Enchant Proc
		config.AURAFILTER[74241] = true -- Power Torrent

		-- Trinket procs
		config.AURAFILTER[102662] = true -- Foul Gift of the Demon Lord
		config.AURAFILTER[109908] = true -- Foul Gift of the Demon Lord

		-- ICC Ring proc
	end,

	HEALER = function()
		-- Enchant Proc
		config.AURAFILTER[74241] = true -- Power Torrent

		-- Trinket procs
		config.AURAFILTER[102662] = true -- Foul Gift of the Demon Lord
		config.AURAFILTER[109908] = true -- Foul Gift of the Demon Lord

		-- ICC Ring proc
	end,

	MELEE = function()
		-- Enchant Proc

		-- Weapon Proc

		-- Trinket procs
		config.AURAFILTER[92104] = true -- Fluid Death
		config.AURAFILTER[96977] = true -- Matrix Restabilizer
		config.AURAFILTER[96978] = true -- Matrix Restabilizer
		config.AURAFILTER[96979] = true -- Matrix Restabilizer
	end,

	TANK = function()
		-- Enchant Proc

		-- Weapon Proc

		-- Trinket procs
		config.AURAFILTER[101492] = true -- Moonwell Phial

		-- ICC Ring proc
	end,
}

local ClassSpecific = {
	DEATHKNIGHT = function()
		-- Blood auras

		-- Frost auras

		-- Unholy auras

		-- Tier procs

		-- Relic

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,

	DRUID = function()
		-- Balance auras
		config.AURAFILTER[22812] = true -- Barkskin

		-- Feral Combat auras
		config.AURAFILTER[1850] = true  -- Dash
		config.AURAFILTER[5217] = true  -- Tiger's Fury
		config.AURAFILTER[5229] = true  -- Enrage
		config.AURAFILTER[22842] = true -- Frenzied Regeneration
		config.AURAFILTER[50334] = true -- Berserk
		config.AURAFILTER[52610] = true -- Savage Roar
		config.AURAFILTER[61336] = true -- Survival Instincts
		config.AURAFILTER[62606] = true -- Savage Defense
		config.AURAFILTER[69369] = true -- Predator's Swiftness
		config.AURAFILTER[80951] = true -- Pulverize

		-- Restoration auras
		config.AURAFILTER[16870] = true -- Clearcast

		-- Tier procs
		config.AURAFILTER[90165] = true -- Druid T11 Feral 4P Bonus
		config.AURAFILTER[99009] = true -- Druid T12 Feral 4P Bonus

		-- Relic

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
		RoleSpecific['HEALER']()
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,

	HUNTER = function()
		-- Beast Mastery auras

		-- Marksmanship auras

		-- Survival auras

		-- Tier procs

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
	end,

	MAGE = function()
		-- Arcane auras

		-- Fire auras

		-- Frost auras

		-- Tier procs

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
	end,

	PALADIN = function()
		-- Holy auras

		-- Protection auras

		-- Retribution auras

		-- Tier procs

		-- Relic

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['HEALER']()
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,

	PRIEST = function()
		-- Discipline auras
		config.AURAFILTER[89485] = true -- Inner Focus
		config.AURAFILTER[59887] = true -- Borrowed Time (Rank 1)
		config.AURAFILTER[59888] = true -- Borrowed Time (Rank 1)
		config.AURAFILTER[96266] = true -- Strength of Soul (Rank 1)
		config.AURAFILTER[96267] = true -- Strength of Soul (Rank 2)
		config.AURAFILTER[45241] = true -- Focused Will (Rank 1)
		config.AURAFILTER[45242] = true -- Focused Will (Rank 2)

		-- Holy auras
		config.AURAFILTER[88688] = true -- Surge of Light

		-- Shadow auras

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
		RoleSpecific['HEALER']()
	end,

	ROGUE = function()
		-- Assassination auras

		-- Combat auras

		-- Subtlety auras

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
	end,

	SHAMAN = function()
		-- Elemental auras

		-- Enhancement auras

		-- Restoration auras

		-- Tier procs

		-- Relic

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
		RoleSpecific['HEALER']()
		RoleSpecific['MELEE']()
	end,

	WARLOCK = function()
		-- Affliction auras

		-- Demonology auras
		config.AURAFILTER[63165] = true -- Decimation (Rank 1)
		config.AURAFILTER[63167] = true -- Decimation (Rank 2)
		config.AURAFILTER[47383] = true -- Molten Core (Rank 1)
		config.AURAFILTER[71162] = true -- Molten Core (Rank 2)
		config.AURAFILTER[71165] = true -- Molten Core (Rank 3)

		-- Destruction auras

		-- Tier procs

		-- Glyph Proc
		config.AURAFILTER[17941] = true -- Glyph of Corruption

		-- Role specific auras
		RoleSpecific['CASTER']()
	end,

	WARRIOR = function()
		-- Arms auras

		-- Fury auras

		-- Protection auras

		-- Tier procs

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,
}

-- General auras
config.AURAFILTER[10060] = true -- Power Infusion
config.AURAFILTER[14893] = true -- Inspiration (Rank 1)
config.AURAFILTER[15357] = true -- Inspiration (Rank 2)
config.AURAFILTER[16240] = true -- Ancestral Healing
config.AURAFILTER[29166] = true -- Innervate
config.AURAFILTER[32182] = true -- Heroism
config.AURAFILTER[12443] = true -- Bloodlust
config.AURAFILTER[80353] = true -- Time Warp
config.AURAFILTER[33206] = true -- Pain Suppression
config.AURAFILTER[47788] = true -- Guardian Spirit
config.AURAFILTER[49016] = true -- Hysteria

-- Potion auras

-- Racial auras
local _, playerRace = UnitRace('player')
if RaceSpecific[playerRace] then RaceSpecific[playerRace]() end

-- Class specific auras
local _, playerClass = UnitClass('player')
if ClassSpecific[playerClass] then ClassSpecific[playerClass]() end

----------------------------
-- Do not edit below here --
----------------------------
ns.config = config