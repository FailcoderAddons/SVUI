--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local error         = _G.error;
local print         = _G.print;
local pairs         = _G.pairs;
local next          = _G.next;
local tostring      = _G.tostring;
local type  		= _G.type;
--STRING
local string        = _G.string;
local format        = string.format;
--MATH
local math          = _G.math;
local floor         = math.floor
local ceil          = math.ceil
--TABLE
local table         = _G.table;
local wipe          = _G.wipe;
--BLIZZARD API
local BEAR_FORM       		= _G.BEAR_FORM;
local CAT_FORM 				= _G.CAT_FORM;
local SPELL_POWER_MANA      = _G.SPELL_POWER_MANA;
local UnitClass         	= _G.UnitClass;
local UnitPower         	= _G.UnitPower;
local UnitReaction         	= _G.UnitReaction;
local UnitPowerMax         	= _G.UnitPowerMax;
local UnitIsPlayer      	= _G.UnitIsPlayer;
local UnitPlayerControlled  = _G.UnitPlayerControlled;
local GetShapeshiftFormID 	= _G.GetShapeshiftFormID;

if(select(2, UnitClass('player')) ~= 'DRUID') then return end

local _, ns = ...
local oUF = ns.oUF or oUF

local UPDATE_VISIBILITY = function(self, event)
	local druidmana = self.DruidAltMana
	-- check form
	local form = GetShapeshiftFormID()
	local min, max = druidmana.ManaBar:GetMinMaxValues()

	if druidmana.ManaBar:GetValue() == max then
		druidmana:Hide()
	elseif (form == BEAR_FORM or form == CAT_FORM) then
		druidmana:Show()
	else
		druidmana:Hide()
	end
	
	if(druidmana.PostUpdateVisibility) then
		return druidmana:PostUpdateVisibility(self.unit)
	end	
end

local UNIT_POWER = function(self, event, unit, powerType)
	if(self.unit ~= unit) then return end
	local druidmana = self.DruidAltMana
	
	if not (druidmana.ManaBar) then return end
	
	if(druidmana.PreUpdate) then
		druidmana:PreUpdate(unit)
	end
	local min, max = UnitPower('player', SPELL_POWER_MANA), UnitPowerMax('player', SPELL_POWER_MANA)

	druidmana.ManaBar:SetMinMaxValues(0, max)
	druidmana.ManaBar:SetValue(min)

	local r, g, b, t
	if(druidmana.colorPower) then
		t = self.colors.power["MANA"]
	elseif(druidmana.colorClass and UnitIsPlayer(unit)) or
		(druidmana.colorClassNPC and not UnitIsPlayer(unit)) or
		(druidmana.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = self.colors.class[class]
	elseif(druidmana.colorReaction and UnitReaction(unit, 'player')) then
		t = self.colors.reaction[UnitReaction(unit, "player")]
	elseif(druidmana.colorSmooth) then
		r, g, b = self.ColorGradient(min / max, unpack(druidmana.smoothGradient or self.colors.smooth))
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		druidmana.ManaBar:SetStatusBarColor(r, g, b)

		local bg = druidmana.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end
	
	UPDATE_VISIBILITY(self)
	
	if(druidmana.PostUpdatePower) then
		return druidmana:PostUpdatePower(unit, min, max)
	end
end

local Update = function(self, ...)
	UNIT_POWER(self, ...)
	return UPDATE_VISIBILITY(self, ...)
end

local ForceUpdate = function(element)
	return Update(element.__owner, 'ForceUpdate')
end

local Enable = function(self, unit)
	local druidmana = self.DruidAltMana
	if(druidmana and unit == 'player') then
		druidmana.__owner = self
		druidmana.ForceUpdate = ForceUpdate

		self:RegisterEvent('UNIT_POWER', UNIT_POWER)
		self:RegisterEvent('UNIT_MAXPOWER', UNIT_POWER)
		self:RegisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY)
		
		return true
	end
end

local Disable = function(self)
	local druidmana = self.DruidAltMana
	if(druidmana) then
		self:UnregisterEvent('UNIT_POWER', UNIT_POWER)
		self:UnregisterEvent('UNIT_MAXPOWER', UNIT_POWER)
		self:UnregisterEvent('UPDATE_SHAPESHIFT_FORM', UPDATE_VISIBILITY)
	end
end

oUF:AddElement("DruidAltMana", Update, Enable, Disable)