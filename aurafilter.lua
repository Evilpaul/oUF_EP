local _, ns = ...
local config = ns.config

----------------------------


local RaceSpecific = {
	BloodElf = function()
	end,

	Draenei = function()
	end,

	Dwarf = function()
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

		-- Trinket procs

		-- ICC Ring proc
	end,

	HEALER = function()
		-- Enchant Proc

		-- Trinket procs

		-- ICC Ring proc
	end,

	MELEE = function()
		-- Enchant Proc

		-- Weapon Proc

		-- Trinket procs
		config.AURAFILTER[92104] = true -- Fluid Death
		config.AURAFILTER[96976] = true -- Matrix Restabilizer
	end,

	TANK = function()
		-- Enchant Proc

		-- Weapon Proc

		-- Trinket procs

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

		-- Holy auras

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

		-- Destruction auras

		-- Tier procs

		-- Glyph Proc

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
config.AURAFILTER[15359] = true -- Inspiration
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