local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'WeaponEnchant was unable to locate oUF install')

-- Set playerGUID after PEW.
local playerGUID
local pending
local frame = CreateFrame('Frame')
frame.elapsed = 0
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
frame:SetScript('OnEvent', function(self, event)
	playerGUID = UnitGUID('player')

	self:UnregisterEvent('PLAYER_ENTERING_WORLD')
	self:SetScript('OnEvent', nil)
end)

local UpdateTooltip = function(self)
	GameTooltip:SetInventoryItem(self.parent:GetParent().unit, self:GetID())
end

local OnEnter = function(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	self:UpdateTooltip()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnClick = function(self, button, down)
	local id = self:GetID()
	if id == 16 then
		CancelItemTempEnchantment(1)
	elseif id == 17 then
		CancelItemTempEnchantment(2)
	end
end

local createIcon = function(icons, index)
	local button = CreateFrame('Button', nil, icons)
	button:EnableMouse(true)
	button:RegisterForClicks('RightButtonUp')

	button:SetWidth(icons.size or 16)
	button:SetHeight(icons.size or 16)

	local icon = button:CreateTexture(nil, 'BACKGROUND')
	icon:SetAllPoints(button)

	local count = button:CreateFontString(nil, 'OVERLAY')
	count:SetFontObject(NumberFontNormal)
	count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 0)

	local overlay = button:CreateTexture(nil, 'OVERLAY')
	overlay:SetTexture('Interface\\Buttons\\UI-TempEnchant-Border')
	overlay:SetAllPoints(button)
	button.overlay = overlay

	button.UpdateTooltip = UpdateTooltip
	button:SetScript('OnEnter', OnEnter)
	button:SetScript('OnLeave', OnLeave)
	button:SetScript('OnClick', OnClick)

	table.insert(icons, button)

	button.parent = icons
	button.icon = icon
	button.count = count
	button.cd = cd

	if(icons.PostCreateIcon) then icons:PostCreateIcon(button) end

	return button
end

local SetPosition = function(icons)
	if icons then
		local col = 0
		local row = 0
		local gap = icons.gap
		local sizex = (icons.size or 16) + (icons['spacing-x'] or icons.spacing or 0)
		local sizey = (icons.size or 16) + (icons['spacing-y'] or icons.spacing or 0)
		local anchor = icons.initialAnchor or 'BOTTOMLEFT'
		local growthx = (icons['growth-x'] == 'LEFT' and -1) or 1
		local growthy = (icons['growth-y'] == 'DOWN' and -1) or 1
		local cols = math.floor(icons:GetWidth() / sizex + .5)
		local rows = math.floor(icons:GetHeight() / sizey + .5)

		for i = 1, #icons do
			local button = icons[i]
			if(button and button:IsShown()) then
				if gap then
					if(col > 0) then
						col = col + 1
					end

					gap = false
				end

				if(col >= cols) then
					col = 0
					row = row + 1
				end
				button:ClearAllPoints()
				button:SetPoint(anchor, icons, anchor, col * sizex * growthx, row * sizey * growthy)

				col = col + 1
			elseif(not button) then
				break
			end
		end
	end
end

local updateIcon = function(unit, icons, index, hasEnchant, charges)
	if(index == 0) then index = 2 end

	local id = index + 15

	local icon = icons[index]
	if(not icon) then
		icon = (icons.CreateIcon or createIcon) (icons, index)
	end

	if hasEnchant then
		if icons.showType then
			icon.overlay:Show()
		else
			icon.overlay:Hide()
		end

		local textureName = GetInventoryItemTexture(unit, id)
		icon.icon:SetTexture(textureName)
		icon.count:SetText((charges > 1 and charges))

		icon:SetID(id)
		icon:Show()

		if(icons.PostUpdateIcon) then
			icons:PostUpdateIcon(unit, icon, index)
		end
	else
		-- Hide the icon in-case we are in the middle of the stack.
		icon:Hide()
	end
end

local Update = function(self, event, unit)
	if(self.unit ~= unit) then return end

	local icons = self.Enchants
	if(icons) then
		if(icons.PreUpdate) then icons:PreUpdate(unit) end

		local hasMainHandEnchant, _, mainHandCharges, hasOffHandEnchant, _, offHandCharges = GetWeaponEnchantInfo()

		updateIcon(unit, icons, 1, hasMainHandEnchant, mainHandCharges)
		updateIcon(unit, icons, 2, hasOffHandEnchant, offHandCharges)

		if(icons.PreSetPosition) then icons:PreSetPosition() end
		(icons.SetPosition or SetPosition) (icons)

		if(icons.PostUpdate) then icons:PostUpdate(unit) end
	end
end

-- Work around the annoying delay between casting and GetWeaponEnchantInfo's information being updated.
frame:SetScript('OnUpdate', function(self, elapsed)
	if pending then
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > 1 then
			Update(pending)
			self.elapsed = 0
			pending = nil
		end
	end
end)

local function CLEU(self, event, timestamp, subevent, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if subevent:sub(1, 7) ~= 'ENCHANT' or destGUID ~= playerGUID then
		return
	elseif subevent:sub(9) == 'REMOVED' then
		return Update(self)
	end

	pending = self
end

local Enable = function(self)
	if(self.Enchants and self.unit == 'player') then
		self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED', CLEU)
		self:RegisterEvent('UNIT_INVENTORY_CHANGED', Update)

		-- make sure we update for any already applied enchants
		pending = self

		return true
	end
end

local Disable = function(self)
	if self.Enchants then
		self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED', CLEU)
		self:UnregisterEvent('UNIT_INVENTORY_CHANGED', Update)
	end
end

oUF:AddElement('WeaponEnchant', Update, Enable, Disable)