--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
--[[ STRING METHODS ]]--
local find, format, len, split = string.find, string.format, string.len, string.split;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVOverride');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local NewHook = hooksecurefunc;
local POSITION, ANCHOR_POINT, YOFFSET = "TOP", "BOTTOM", -10
local FORCE_POSITION = false;
--[[ 
########################################################## 
HOOKS
##########################################################
]]--
local _hook_AlertFrame_SetLootAnchors = function(self)
	if MissingLootFrame:IsShown() then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, self, ANCHOR_POINT)
		if GroupLootContainer:IsShown() then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end 
	elseif GroupLootContainer:IsShown() or FORCE_POSITION then 
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, self, ANCHOR_POINT)
	end 
end;

local _hook_AlertFrame_SetLootWonAnchors = function(self)
	for i = 1, #LOOT_WON_ALERT_FRAMES do 
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end;

local _hook_AlertFrame_SetMoneyWonAnchors = function(self)
	for i = 1, #MONEY_WON_ALERT_FRAMES do 
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
			self = frame 
		end 
	end 
end;

local _hook_AlertFrame_SetAchievementAnchors = function(self)
	if AchievementAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["AchievementAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end;

local _hook_AlertFrame_SetCriteriaAnchors = function(self)
	if CriteriaAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do 
			local frame = _G["CriteriaAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
				self = frame 
			end 
		end 
	end 
end;

local _hook_AlertFrame_SetChallengeModeAnchors = function(self)
	local frame = ChallengeModeAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

local _hook_AlertFrame_SetDungeonCompletionAnchors = function(self)
	local frame = DungeonCompletionAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

local _hook_AlertFrame_SetStorePurchaseAnchors = function(self)
	local frame = StorePurchaseAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

local _hook_AlertFrame_SetScenarioAnchors = function(self)
	local frame = ScenarioAlertFrame1;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end;

local _hook_AlertFrame_SetGuildChallengeAnchors = function(self)
	local frame = GuildChallengeAlertFrame;
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, self, ANCHOR_POINT, 0, YOFFSET)
	end 
end;
--[[ 
########################################################## 
TEMP LOADER
##########################################################
]]--
local afrm = CreateFrame("Frame", "SVUI_AlertFrame", UIParent);
afrm:SetWidth(180);
afrm:SetHeight(20);

local AlertFramePostMove_Hook = function(forced)
	local b, c = SVUI_AlertFrame_MOVE:GetCenter()
	local d = SuperVillain.UIParent:GetTop()
	if(c > (d  /  2)) then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = -10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Down)")
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = 10;
		SVUI_AlertFrame_MOVE:SetText(SVUI_AlertFrame_MOVE.textString.." (Grow Up)")
	end;
	if SuperVillain.db.SVOverride.lootRoll then 
		local f, g;
		for h, i in pairs(MOD.LewtRollz) do
			i:ClearAllPoints()
			if h   ~= 1 then
				if POSITION == "TOP" then 
					i:Point("TOP", f, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", f, "TOP", 0, 4)
				end 
			else
				if POSITION == "TOP" then
					i:Point("TOP", SVUI_AlertFrame, "BOTTOM", 0, -4)
				else
					i:Point("BOTTOM", SVUI_AlertFrame, "TOP", 0, 4)
				end 
			end;
			f = i;
			if i:IsShown() then
				g = i 
			end 
		end;
		AlertFrame:ClearAllPoints()
		if g then
			AlertFrame:SetAllPoints(g)
		else
			AlertFrame:SetAllPoints(SVUI_AlertFrame)
		end 
	else
		AlertFrame:ClearAllPoints()
		AlertFrame:SetAllPoints(SVUI_AlertFrame)
	end;
	if forced then
		FORCE_POSITION = true;
		AlertFrame_FixAnchors()
		FORCE_POSITION = false 
	end 
end;

local OverrideAlerts = function(self)
	SVUI_AlertFrame:SetParent(SuperVillain.UIParent)
	SVUI_AlertFrame:SetPoint("TOP", SuperVillain.UIParent, "TOP", 0, -18);
	SuperVillain:SetSVMovable(SVUI_AlertFrame, "SVUI_AlertFrame_MOVE", L["Loot  /  Alert Frames"], nil, nil, AlertFramePostMove_Hook)

	NewHook('AlertFrame_FixAnchors', AlertFramePostMove_Hook)
	NewHook('AlertFrame_SetLootAnchors', _hook_AlertFrame_SetLootAnchors)
	NewHook('AlertFrame_SetLootWonAnchors', _hook_AlertFrame_SetLootWonAnchors)
	NewHook('AlertFrame_SetMoneyWonAnchors', _hook_AlertFrame_SetMoneyWonAnchors)
	NewHook('AlertFrame_SetAchievementAnchors', _hook_AlertFrame_SetAchievementAnchors)
	NewHook('AlertFrame_SetCriteriaAnchors', _hook_AlertFrame_SetCriteriaAnchors)
	NewHook('AlertFrame_SetChallengeModeAnchors', _hook_AlertFrame_SetChallengeModeAnchors)
	NewHook('AlertFrame_SetDungeonCompletionAnchors', _hook_AlertFrame_SetDungeonCompletionAnchors)
	NewHook('AlertFrame_SetScenarioAnchors', _hook_AlertFrame_SetScenarioAnchors)
	NewHook('AlertFrame_SetGuildChallengeAnchors', _hook_AlertFrame_SetGuildChallengeAnchors)
	NewHook('AlertFrame_SetStorePurchaseAnchors', _hook_AlertFrame_SetStorePurchaseAnchors)
end

SuperVillain.Registry:Temp("SVOverride", OverrideAlerts)