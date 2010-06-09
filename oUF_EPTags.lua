local _, ns = ...
local shortVal = ns.shortVal
local unpack = unpack
local format = string.format

local function utf8sub(string, i)
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while pos <= bytes do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 194 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 244 then
				pos = pos + 4
			end
			if len == i then break end
		end

		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)
		else
			return string
		end
	end
end

for name, func in pairs({
	['ep:health'] = function(unit)
		local min, max = UnitHealth(unit), UnitHealthMax(unit)
		local status = not UnitIsConnected(unit) and 'Offline' or UnitIsGhost(unit) and 'Ghost' or UnitIsDead(unit) and 'Dead'

		if status then
			return status
		elseif unit == 'target' and UnitCanAttack('player', unit) then
			return format('%s (%d|cff0090ff%%|r)', shortVal(min), min / max * 100)
		elseif unit == 'player' and min ~= max then
			return format('|cffff8080%d|r %d|cff0090ff%%|r', min - max, min / max * 100)
		elseif min ~= max then
			return format('%s |cff0090ff/|r %s', shortVal(min), shortVal(max))
		else
			return max
		end
	end,
	['ep:smallhealth'] = function(unit)
		return _TAGS['status'](unit) or format('%s%%', _TAGS['perhp'](unit))
	end,
	['ep:power'] = function(unit)
		local power = UnitPower(unit)

		if power > 0 then
			local _, type = UnitPowerType(unit)
			local colors = _COLORS.power
			return format('%s%d|r', Hex(colors[type] or colors['FUEL']), power)
		end
	end,
	['ep:druid'] = function(unit)
		local min, max = UnitPower(unit, 0), UnitPowerMax(unit, 0)

		if UnitPowerType(unit) ~= 0 and min ~= max then
			return format('|cff0090ff%d%%|r', min / max * 100)
		end
	end,
	['ep:name'] = function(unit)
		local reaction = UnitReaction(unit, 'player')

		local r, g, b = 1, 1, 1
		if (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) or not UnitIsConnected(unit) then
			r, g, b = 3 / 5, 3 / 5, 3 / 5
		elseif not UnitIsPlayer(unit) and reaction then
			r, g, b = unpack(_COLORS.reaction[reaction])
		elseif UnitFactionGroup(unit) and UnitIsEnemy(unit, 'player') and UnitIsPVP(unit) then
			r, g, b = 1, 0, 0
		end

		return format('%s%s|r', Hex(r, g, b), UnitName(unit))
	end,
	['ep:raidname'] = function(unit)
		local r, g, b = 1, 1, 1
		local unitName = UnitName(unit)

		if not UnitIsConnected(unit) then
			r, g, b = 3 / 5, 3 / 5, 3 / 5
			unitName = 'Offline'
		elseif UnitIsDead(unit) then
			r, g, b = 3 / 5, 3 / 5, 3 / 5
			unitName = 'Dead'
		elseif UnitIsGhost(unit) then
			r, g, b = 3 / 5, 3 / 5, 3 / 5
			unitName = 'Ghost'
		else
			local min, max = UnitHealth(unit), UnitHealthMax(unit)
			local perHP = min / max * 100
			if(perHP < 90) then
				unitName = format('-%s', shortVal(max - min))
			end
		end

		return format('%s%s|r', Hex(r, g, b), utf8sub(unitName, 4))
	end,
}) do
	oUF.Tags[name] = func
end

oUF.TagEvents['ep:health'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.TagEvents['ep:smallhealth'] = 'UNIT_HEALTH UNIT_MAXHEALTH'
oUF.TagEvents['ep:power'] = 'UNIT_ENERGY UNIT_FOCUS UNIT_MANA UNIT_RAGE UNIT_RUNIC_POWER'
oUF.TagEvents['ep:druid'] = 'UNIT_MANA'
oUF.TagEvents['ep:name'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION'
oUF.TagEvents['ep:raidname'] = 'UNIT_NAME_UPDATE UNIT_REACTION UNIT_FACTION UNIT_HEALTH UNIT_MAX_HEALTH'