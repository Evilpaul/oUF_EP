local _, playerClass = UnitClass('player')

oUF_EPConfig = {
	FONT = [=[Fonts\ARIALN.ttf]=],

	TEXTURE = [=[Interface\AddOns\oUF_EP\media\minimalist]=],

	BACKDROP = {
		bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
		insets = {top = -1, bottom = -1, left = -1, right = -1}
	},

	COLORS = setmetatable({
		power = setmetatable({
			MANA = {0, 144/255, 1}
		}, {__index = oUF.colors.power}),
		reaction = setmetatable({
			[2] = {1, 0, 0},
			[4] = {1, 1, 0},
			[5] = {0, 1, 0}
		}, {__index = oUF.colors.reaction}),
	}, {__index = oUF.colors}),

	DEBUFFS = {
		[770]   = playerClass == 'DRUID',	-- Faerie Fire
		[16857] = playerClass == 'DRUID',	-- Faerie Fire (Feral)
		[48564] = playerClass == 'DRUID',	-- Mangle (Bear)
		[48566] = playerClass == 'DRUID',	-- Mangle (Cat)
		[46857] = playerClass == 'DRUID',	-- Trauma
		[6788]  = playerClass == 'PRIEST',	-- Weakened Soul
	},

	BUFFS = {
		[52610] = playerClass == 'DRUID',	-- Druid: Savage Roar
		[16870] = playerClass == 'DRUID',	-- Druid: Clearcast
		[50213] = playerClass == 'DRUID',	-- Druid: Tiger's Fury
		[50334] = playerClass == 'DRUID',	-- Druid: Berserk
		[22842] = playerClass == 'DRUID',	-- Druid: Frenzied Regeneration
		[22812] = playerClass == 'DRUID',	-- Druid: Barkskin
		[62600] = playerClass == 'DRUID',	-- Druid: Savage Defense
		[61336] = playerClass == 'DRUID',	-- Druid: Survival Instincts
		[5229]  = playerClass == 'DRUID',	-- Druid: Enrage
		[70725] = playerClass == 'DRUID',	-- Druid: Enraged Defense (4-part T-10)
		[44401] = playerClass == 'MAGE',	-- Mage: Missile Barrage
		[12536] = playerClass == 'MAGE',	-- Mage: Clearcasting (Arcane Concentration)
		[12043] = playerClass == 'MAGE',	-- Mage: Presence of Mind
		[57531] = playerClass == 'MAGE',	-- Mage: Arcane Potency
		[59891] = playerClass == 'PRIEST',	-- Priest: Borrowed Time
		[63734] = playerClass == 'PRIEST',	-- Priest: Serendipity
		[63725] = playerClass == 'PRIEST',	-- Priest: Holy Concentration
		[33151] = playerClass == 'PRIEST',	-- Priest: Surge of Light
		[14751] = playerClass == 'PRIEST',	-- Priest: Inner Focus
		[60503] = playerClass == 'WARRIOR',	-- Warrior: Taste for Blood
		[12328] = playerClass == 'WARRIOR',	-- Warrior: Sweeping Strikes
		[65156] = playerClass == 'WARRIOR',	-- Warrior: Juggernaut
		[52437] = playerClass == 'WARRIOR',	-- Warrior: Sudden Death
		[57522] = playerClass == 'WARRIOR',	-- Warrior: Enrage (Wrecking Crew)
		[14204] = playerClass == 'WARRIOR',	-- Warrior: Enrage
		[12292] = playerClass == 'WARRIOR',	-- Warrior: Death Wish
		[12970] = playerClass == 'WARRIOR',	-- Warrior: Flurry
		[18499] = playerClass == 'WARRIOR',	-- Warrior: Berserker Rage
		[1719]  = playerClass == 'WARRIOR',	-- Warrior: Recklessness
		[46916] = playerClass == 'WARRIOR',	-- Warrior: Slam
		[32182] = true, -- Buff: Heroism
		[49016] = true, -- Buff: Hysteria
		[47788] = true, -- Buff: Guardian Spirit
		[10060] = true, -- Buff: Power Infusion
		[33206] = true, -- Buff: Pain Suppression
		[15359] = true, -- Buff: Inspiration
		[16240] = true, -- Buff: Ancestral Healing
	},

	SPACING = 4,
}