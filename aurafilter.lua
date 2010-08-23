local _, ns = ...
local config = ns.config

----------------------------


local RaceSpecific = {
	Orc = function()
		config.AURAFILTER[20572] = true -- Blood Fury (Orc death knight, hunter, rogue, warrior)
		config.AURAFILTER[33697] = true -- Blood Fury (Orc shaman)
		config.AURAFILTER[33702] = true -- Blood Fury (Orc warlock)
	end,

	Troll = function()
		config.AURAFILTER[26297] = true -- Berserking (Troll)
	end,

	Dwarf = function()
		config.AURAFILTER[65116] = true -- Stoneform (Dwarf)
	end,
}

local RoleSpecific = {
	CASTER = function()
		-- Enchant Proc
		config.AURAFILTER[59626] = true -- Black Magic
		config.AURAFILTER[55637] = true -- Lightweave Embroidery

		-- Trinket procs
		config.AURAFILTER[67669] = true -- Abyssal Rune
		config.AURAFILTER[67684] = true -- Talisman of Resurgance
		config.AURAFILTER[71570] = true -- Muradin's Spyglass (normal)
		config.AURAFILTER[71572] = true -- Muradin's Spyglass (heroic)
		config.AURAFILTER[71601] = true -- Dislodged Foreign Object (normal)
		config.AURAFILTER[71600] = true -- Dislodged Foreign Object (normal)
		config.AURAFILTER[71644] = true -- Dislodged Foreign Object (heroic)
		config.AURAFILTER[71643] = true -- Dislodged Foreign Object (heroic)
		config.AURAFILTER[71605] = true -- Phylactry of the Nameless Lich (normal)
		config.AURAFILTER[71636] = true -- Phylactry of the Nameless Lich (heroic)
		config.AURAFILTER[71579] = true -- Maghia's Misguided Quill
		config.AURAFILTER[71584] = true -- Purified Lunar Dust

		-- ICC Ring proc
		config.AURAFILTER[72416] = true -- Frostforged Sage
	end,

	HEALER = function()
		-- Enchant Proc
		config.AURAFILTER[59626] = true -- Black Magic
		config.AURAFILTER[55767] = true -- Darkglow Embroidery

		-- Trinket procs
		config.AURAFILTER[60525] = true -- Majestic Dragon Figurine
		config.AURAFILTER[71564] = true -- Nevermelting Ice Crystal
		config.AURAFILTER[71568] = true -- Ephemeral Snowflake
		config.AURAFILTER[67684] = true -- Talisman of Resurgance
		config.AURAFILTER[71584] = true -- Purified Lunar Dust

		-- ICC Ring proc
		config.AURAFILTER[72418] = true -- ICC Rep Ring (Healer)
	end,

	MELEE = function()
		-- Enchant Proc
		config.AURAFILTER[28093] = true -- Mongoose
		config.AURAFILTER[59620] = true -- Berserking
		config.AURAFILTER[55775] = true -- Swordguard Embroidery

		-- Weapon Proc
		config.AURAFILTER[71881] = true -- Heartpierce - mana (normal)
		config.AURAFILTER[71883] = true -- Heartpierce - rage (normal)
		config.AURAFILTER[71882] = true -- Heartpierce - energy (normal)
		config.AURAFILTER[71884] = true -- Heartpierce - rune (normal)
		config.AURAFILTER[71888] = true -- Heartpierce - mana (heroic)
		config.AURAFILTER[71886] = true -- Heartpierce - rage (heroic)
		config.AURAFILTER[71887] = true -- Heartpierce - energy (heroic)
		config.AURAFILTER[71885] = true -- Heartpierce - rune (heroic)
		config.AURAFILTER[71875] = true -- Black Bruise (normal)
		config.AURAFILTER[71877] = true -- Black Bruise (heroic)
		config.AURAFILTER[71905] = true -- Shadowmourne (part 1)
		config.AURAFILTER[73422] = true -- Shadowmourne (part 2)

		-- Trinket procs
		config.AURAFILTER[60233] = true -- Darkmoon Card: Greatness (Agility)
		config.AURAFILTER[71396] = true -- Herkuml War Token
		config.AURAFILTER[71403] = true -- Needle-Encrusted Scorpion
		config.AURAFILTER[67671] = true -- Banner of Victory
		config.AURAFILTER[71401] = true -- Whispering Fanged Skull (normal)
		config.AURAFILTER[71541] = true -- Whispering Fanged Skull (heroic)
		config.AURAFILTER[71492] = true -- Deathbringer's Will - Strength of the Vrykul (normal)
		config.AURAFILTER[71560] = true -- Deathbringer's Will - Strength of the Vrykul (heroic)
		config.AURAFILTER[71485] = true -- Deathbringer's Will - Agility of the Vrykul (normal)
		config.AURAFILTER[71556] = true -- Deathbringer's Will - Agility of the Vrykul (heroic)
		config.AURAFILTER[71486] = true -- Deathbringer's Will - Power of the Taunka (normal)
		config.AURAFILTER[71558] = true -- Deathbringer's Will - Power of the Taunka (heroic)
		config.AURAFILTER[71487] = true -- Deathbringer's Will - Precision of the Iron Dwarves (normal)
		config.AURAFILTER[71557] = true -- Deathbringer's Will - Precision of the Iron Dwarves (heroic)
		config.AURAFILTER[71491] = true -- Deathbringer's Will - Aim of the Iron Dwarves (normal)
		config.AURAFILTER[71559] = true -- Deathbringer's Will - Aim of the Iron Dwarves (heroic)
		config.AURAFILTER[71492] = true -- Deathbringer's Will - Speed of the Vrykul (normal)
		config.AURAFILTER[71560] = true -- Deathbringer's Will - Speed of the Vrykul (heroic)
		config.AURAFILTER[71432] = true -- Tiny Abomination in a Jar (normal)
--		config.AURAFILTER[] = true -- Tiny Abomination in a Jar (heroic)

		-- ICC Ring proc
		config.AURAFILTER[72412] = true -- ICC Rep Ring (melee)
	end,

	TANK = function()
		-- Enchant Proc
		config.AURAFILTER[64440] = true -- Blade Ward
		config.AURAFILTER[64568] = true -- Blood Draining

		-- Weapon Proc
		config.AURAFILTER[71870] = true -- Last Word (normal)
		config.AURAFILTER[71872] = true -- Last Word (heroic)

		-- Trinket procs
		config.AURAFILTER[67631] = true -- The Black Heart
		config.AURAFILTER[67694] = true -- Glyph of Indomitability
		config.AURAFILTER[67699] = true -- Satrina's Impeding Scarab (normal)
		config.AURAFILTER[67753] = true -- Satrina's Impeding Scarab (heroic)
		config.AURAFILTER[71575] = true -- Unidentifiable Organ (normal)
		config.AURAFILTER[71577] = true -- Unidentifiable Organ (heroic)
		config.AURAFILTER[71586] = true -- Corroded Skeleton Key
		config.AURAFILTER[71633] = true -- Corpse Tongue Coin (normal)
		config.AURAFILTER[71639] = true -- Corpse Tongue Coin (heroic)
		config.AURAFILTER[71635] = true -- Sindragosa's Flawless Fang (normal)
		config.AURAFILTER[71638] = true -- Sindragosa's Flawless Fang (heroic)

		-- ICC Ring proc
		config.AURAFILTER[72414] = true -- ICC Rep Ring (Tank)
	end,
}

local ClassSpecific = {
	DEATHKNIGHT = function()
		-- Blood auras

		-- Frost auras

		-- Unholy auras

		-- Tier procs
--		config.AURAFILTER[] = true --  (4-part T-10 - tank)
--		config.AURAFILTER[] = true --  (4-part T-10 - melee)

		-- Relic
--		config.AURAFILTER[] = true -- Sigil of the Hanged Man (melee)
--		config.AURAFILTER[] = true -- Sigil of the Bone Gryphon (tank)

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,

	DRUID = function()
		-- Balance auras
		config.AURAFILTER[22812] = true -- Barkskin

		-- Feral Combat auras
		config.AURAFILTER[5229] = true  -- Enrage
		config.AURAFILTER[22842] = true -- Frenzied Regeneration
		config.AURAFILTER[33357] = true -- Dash
		config.AURAFILTER[50213] = true -- Tiger's Fury
		config.AURAFILTER[50334] = true -- Berserk
		config.AURAFILTER[52610] = true -- Savage Roar
		config.AURAFILTER[61336] = true -- Survival Instincts
		config.AURAFILTER[62606] = true -- Savage Defense
		config.AURAFILTER[69369] = true -- Predator's Swiftness

		-- Restoration auras
		config.AURAFILTER[16870] = true -- Clearcast

		-- Tier procs
		config.AURAFILTER[70725] = true -- Enraged Defense (4-part T-10 - feral)
--		config.AURAFILTER[] = true --  (2-part T-10 - balance)

		-- Relic
		config.AURAFILTER[71175] = true -- Idol of the Crying Moon (feral)
--		config.AURAFILTER[] = true -- Idol of the Black Willow (resto)
--		config.AURAFILTER[] = true -- Idol of the Lunar Eclipse (balance)

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
--		config.AURAFILTER[] = true --  (2-part T-10)
--		config.AURAFILTER[] = true --  (4-part T-10)

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
	end,

	MAGE = function()
		-- Arcane auras
		config.AURAFILTER[12042] = true -- Arcane Power
		config.AURAFILTER[12043] = true -- Presence of Mind
		config.AURAFILTER[12536] = true -- Clearcasting (Arcane Concentration)
		config.AURAFILTER[32612] = true -- Invisibility
		config.AURAFILTER[36032] = true -- Arcane Blast (Debuff)
		config.AURAFILTER[44401] = true -- Missile Barrage
		config.AURAFILTER[54648] = true -- Focus Magic
		config.AURAFILTER[55342] = true -- Mirror Image
		config.AURAFILTER[57531] = true -- Arcane Potency

		-- Fire auras
		config.AURAFILTER[43010] = true -- Fire Ward
		config.AURAFILTER[48108] = true -- Hot Streak
		config.AURAFILTER[28682] = true -- Combustion

		-- Frost auras
		config.AURAFILTER[12472] = true -- Icy Veins
		config.AURAFILTER[45438] = true -- Ice Block
		config.AURAFILTER[57761] = true -- Fireball!
		config.AURAFILTER[74396] = true -- Fingers of Frost

		-- Tier procs
		config.AURAFILTER[70747] = true -- Quad Core (4-part T-10)
		config.AURAFILTER[70753] = true -- Pushing the Limit (2-part T-10)

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
	end,

	PALADIN = function()
		-- Holy auras

		-- Protection auras

		-- Retribution auras

		-- Tier procs
--		config.AURAFILTER[] = true --  (4-part T-10 - prot)
--		config.AURAFILTER[] = true --  (2-part T-10 - holy) ???
--		config.AURAFILTER[] = true --  (4-part T-10 - holy)

		-- Relic
--		config.AURAFILTER[] = true -- Libram of Blinding Light (holy)
--		config.AURAFILTER[] = true -- Libram of the Eternal Tower (prot)
--		config.AURAFILTER[] = true -- Libram of Three Truths (ret)

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['HEALER']()
		RoleSpecific['MELEE']()
		RoleSpecific['TANK']()
	end,

	PRIEST = function()
		-- Discipline auras
		config.AURAFILTER[14751] = true -- Inner Focus
		config.AURAFILTER[59891] = true -- Borrowed Time
		config.AURAFILTER[63944] = true -- Renewed Hope

		-- Holy auras
		config.AURAFILTER[33151] = true -- Surge of Light
		config.AURAFILTER[63725] = true -- Holy Concentration
		config.AURAFILTER[63734] = true -- Serendipity

		-- Shadow auras

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
		RoleSpecific['HEALER']()
	end,

	ROGUE = function()
		-- Assassination auras
--		config.AURAFILTER[] = true -- Slice and Dice

		-- Combat auras
--		config.AURAFILTER[] = true -- Adrenaline Rush
--		config.AURAFILTER[] = true -- Blade Flurry
--		config.AURAFILTER[] = true -- Sprint
--		config.AURAFILTER[] = true -- Killing Spree
--		config.AURAFILTER[] = true -- Evasion

		-- Subtlety auras
--		config.AURAFILTER[] = true -- Cloak of shadows

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['MELEE']()
	end,

	SHAMAN = function()
		-- Elemental auras

		-- Enhancement auras

		-- Restoration auras

		-- Tier procs
--		config.AURAFILTER[] = true --  (2-part T-10 - enhance)
--		config.AURAFILTER[] = true --  (4-part T-10 - enhance)
--		config.AURAFILTER[] = true --  (2-part T-10 - resto)

		-- Relic
--		config.AURAFILTER[] = true -- Bizuri's Totem of Shattered Ice (elemental)
--		config.AURAFILTER[] = true -- Totem of the Avalanche (enhance)
--		config.AURAFILTER[] = true -- Totem of the Surging Sea (resto)

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
--		config.AURAFILTER[] = true --  (4-part T-10)

		-- Glyph Proc

		-- Role specific auras
		RoleSpecific['CASTER']()
	end,

	WARRIOR = function()
		-- Arms auras
		config.AURAFILTER[12328] = true -- Sweeping Strikes
		config.AURAFILTER[46924] = true -- Bladestorm
		config.AURAFILTER[52437] = true -- Sudden Death
		config.AURAFILTER[57522] = true -- Enrage (Wrecking Crew)
		config.AURAFILTER[60503] = true -- Taste for Blood
		config.AURAFILTER[65156] = true -- Juggernaut

		-- Fury auras
		config.AURAFILTER[1719] = true  -- Recklessness
		config.AURAFILTER[12292] = true -- Death Wish
		config.AURAFILTER[12970] = true -- Flurry
		config.AURAFILTER[18499] = true -- Berserker Rage
		config.AURAFILTER[23885] = true -- Bloodthirst
		config.AURAFILTER[46916] = true -- Slam!
		config.AURAFILTER[55694] = true -- Enraged Regeneration

		-- Protection auras
		config.AURAFILTER[871] = true   -- Shield Wall
		config.AURAFILTER[2565] = true  -- Shield Block
		config.AURAFILTER[12976] = true -- Last Stand
		config.AURAFILTER[23920] = true -- Spell Reflection
		config.AURAFILTER[29131] = true -- Bloodrage
		config.AURAFILTER[50227] = true -- Sword and Board
		config.AURAFILTER[57516] = true -- Enrage (Improved Defensive Stance)

		-- Tier procs
		config.AURAFILTER[70855] = true -- Blood Drinker (2-part T-10 - melee)
--		config.AURAFILTER[] = true --  (4-part T-10 - tank)

		-- Glyph Proc
		config.AURAFILTER[58363] = true -- Glyph of Revenge
		config.AURAFILTER[58374] = true -- Glyph of Blocking

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
config.AURAFILTER[33206] = true -- Pain Suppression
config.AURAFILTER[47788] = true -- Guardian Spirit
config.AURAFILTER[49016] = true -- Hysteria

-- Potion auras
config.AURAFILTER[53753] = true -- Speed (Potion of Nightmares)
config.AURAFILTER[53762] = true -- Speed (Indestructable Potion)
config.AURAFILTER[53908] = true -- Speed (Potion of Speed)
config.AURAFILTER[53909] = true -- Speed (Potion of Wild Magic)

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