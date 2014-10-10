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
local GetShapeshiftForm         = _G.GetShapeshiftForm;
local UnitHasVehicleUI 			= _G.UnitHasVehicleUI;
local UnitBuff         			= _G.UnitBuff;
local CombatText_AddMessage 	= _G.CombatText_AddMessage;
local CombatText_StandardScroll = _G.CombatText_StandardScroll;
local MAX_COMBO_POINTS      	= _G.MAX_COMBO_POINTS;
local GetSpellInfo      		= _G.GetSpellInfo;
local GetComboPoints  			= _G.GetComboPoints;

local class = select(2, UnitClass("player"));
if(class ~= "ROGUE" and class ~= "DRUID") then return end

local parent, ns = ...
local oUF = ns.oUF

local GUILE1 = GetSpellInfo(84745)
local GUILE2 = GetSpellInfo(84746)
local GUILE3 = GetSpellInfo(84747)
local ANTICIPATION = GetSpellInfo(115189)
local ALERTED = false
local TextColors = {
	[1]={1,0.1,0.1},
	[2]={1,0.5,0.1},
	[3]={1,1,0.1},
	[4]={0.5,1,0.1},
	[5]={0.1,1,0.1}
};

local function UpdateGuile()
	local _, _, _, one = UnitBuff("player", GUILE1, nil, "HELPFUL")
	local _, _, _, two = UnitBuff("player", GUILE2, nil, "HELPFUL")
	local _, _, _, three = UnitBuff("player", GUILE3, nil, "HELPFUL")
	if one or two or three then
		if one then return 1; end
		if two then return 2; end
		if three then return 3; end
	else
		return 0;
	end
end

local function FivePointsAlarm(frame, points)
	if not CombatText_AddMessage then return end
	if(points == 5 and not frame.ALERTED) then
		CombatText_AddMessage("5 Points", CombatText_StandardScroll, 0.1, 0.5, 1, "crit")
		frame.ALERTED = true
	elseif(frame.ALERTED and points < 5) then
		frame.ALERTED = false
	end
end 

local Update = function(self, event, unit)
	if(unit == 'pet') then return end
	local bar = self.HyperCombo;
	local cpoints = bar.CPoints;
	local tracker = bar.Tracking;

	if(bar.PreUpdate) then
		bar:PreUpdate()
	end

	local current = 0
	if(UnitHasVehicleUI'player') then
		current = GetComboPoints('vehicle', 'target')
	else
		current = GetComboPoints('player', 'target')
	end

	if(cpoints) then
		for i=1, MAX_COMBO_POINTS do
			if(i <= current) then
				cpoints[i]:Show()
				if(bar.PointShow) then
					bar.PointShow(cpoints[i])
				end
			else
				cpoints[i]:Hide()
				if(bar.PointHide) then
					bar.PointHide(cpoints[i], i)
				end
			end
		end
	end

	if(class == "ROGUE") then
		if(tracker) then
			if(current > 0) then
				tracker.Text:SetText(current)
				tracker.Text:SetTextColor(unpack(TextColors[current]))
				FivePointsAlarm(tracker, current)
			elseif(bar.LAST_COMBO_POINTS > 0) then
				tracker.Text:SetText(bar.LAST_COMBO_POINTS)
				tracker.Text:SetTextColor(0.5,0.5,1)
			else
				tracker.Text:SetText("0")
				tracker.Text:SetTextColor(0.3,0.3,0.3)
			end
		end

		local anticipation = bar.Anticipation;
		if(anticipation) then
			local anti = select(4, UnitBuff("player", ANTICIPATION)) -- Anticipation stacks
			if(anti and anti > 0) then
				anticipation.Text:SetText(anti)
				anticipation.Text:SetTextColor(unpack(TextColors[anti]))
			else
				anticipation.Text:SetText("")
			end
		end
		local guile = bar.Guile;
		if(guile) then
			local insight = UpdateGuile()
			if(insight and insight > 0) then
				guile.Text:SetText(insight)
				guile.Text:SetTextColor(unpack(TextColors[insight]))
			else
				guile.Text:SetText("")
			end
		end
	else
		if(tracker) then
			if(GetShapeshiftForm() == 3) then
				if(current > 0) then
					tracker.Text:SetText(current)
					tracker.Text:SetTextColor(unpack(TextColors[current]))
					FivePointsAlarm(tracker, current)
				elseif(bar.LAST_COMBO_POINTS > 0) then
					tracker.Text:SetText(bar.LAST_COMBO_POINTS)
					tracker.Text:SetTextColor(0.5,0.5,1)
				else
					tracker.Text:SetText("0")
					tracker.Text:SetTextColor(0.3,0.3,0.3)
				end
			else
				tracker.Text:SetText("")
			end
		end
	end

	if(bar.PostUpdate) then
		return bar:PostUpdate(current)
	end
end

local Path = function(self, ...)
	return (self.HyperCombo.Override or Update) (self, ...)
end

local Tracker = function(self, ...)
	local bar = self.HyperCombo
	if(UnitHasVehicleUI'player') then
		bar.LAST_COMBO_POINTS = GetComboPoints('vehicle', 'target')
	else
		bar.LAST_COMBO_POINTS = GetComboPoints('player', 'target')
	end
	return Path(self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(self)
	local bar = self.HyperCombo
	if(bar) then
		bar.__owner = self
		bar.ForceUpdate = ForceUpdate
		bar.EXISTING_COMBO_POINTS = 0
		bar.LAST_COMBO_POINTS = 0

		self:RegisterEvent('UNIT_COMBO_POINTS', Tracker, true)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', Path, true)
		self:RegisterEvent('UNIT_AURA', Path, true)
		
		local cpoints = bar.CPoints;
		if(cpoints) then
			for index = 1, MAX_COMBO_POINTS do
				local cpoint = cpoints[index]
				if(cpoint:IsObjectType'Texture' and not cpoint:GetTexture()) then
					cpoint:SetTexture[[Interface\ComboFrame\ComboPoint]]
					cpoint:SetTexCoord(0, 0.375, 0, 1)
				end
			end
		end
		return true
	end
end

local Disable = function(self)
	local bar = self.HyperCombo
	if(bar) then
		local cpoints = bar.CPoints;
		if(cpoints) then
			for index = 1, MAX_COMBO_POINTS do
				cpoints[index]:Hide()
			end
		end
		self:UnregisterEvent('UNIT_COMBO_POINTS', Tracker)
		self:UnregisterEvent('PLAYER_TARGET_CHANGED', Path)
		self:UnregisterEvent('UNIT_AURA', Path)
	end
end

oUF:AddElement('HyperCombo', Path, Enable, Disable)
