local _, ns = ...
local _, playerClass = UnitClass('player')

local config = {
	FONT = [=[Interface\AddOns\oUF_EP\fonts\Sansation_Regular.ttf]=],
	FONTSIZE = 12,
	FONTBORDER = 'OUTLINE',

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

	COLORS = setmetatable({
		power = setmetatable({
			MANA = {0, 144 / 255, 1}
		}, {__index = oUF.colors.power}),
		reaction = setmetatable({
			[2] = {1, 0, 0},
			[4] = {1, 1, 0},
			[5] = {0, 1, 0}
		}, {__index = oUF.colors.reaction}),
		runes = setmetatable({
			[1] = {0.8, 0, 0},
			[3] = {0, 0.4, 0.7},
			[4] = {0.8, 0.8, 0.8}
		}, {__index = oUF.colors.runes})
	}, {__index = oUF.colors}),

	SPACING = 4,
}

ns.config = config
