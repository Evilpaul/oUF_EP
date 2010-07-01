local _, ns = ...

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

	SPACING = 4,

	HEALTHHEIGHT = 21,
	POWERHEIGHT = 4,
	UNITHEIGHT = 25, -- should always equal healthHeight + powerHeight

	PRIMARYUNITWIDTH = 230, -- primary frames (player & target)
	SECONDARYUNITWIDTH = 144, -- secondary frames (pet, focus & targettarget)
	TERTIARYUNITWIDTH = 100, -- tertiary frames (maintank, maintanktarget, boss)
	RAIDUNITWIDTH = 25, -- raid frames

}
ns.config = config
