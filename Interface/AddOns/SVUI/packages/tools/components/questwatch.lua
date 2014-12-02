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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local error 	= _G.error;
local pcall 	= _G.pcall;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local bit 		= _G.bit;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;	-- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local huge, random = math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

local MOD = SV.SVTools;
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-QUESTS]];
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local ShowSubDocklet = function(self)
	if(InCombatLockdown()) then return end
	if(not ObjectiveTrackerFrame:IsShown()) then ObjectiveTrackerFrame:Show() end
end

local HideSubDocklet = function(self)
	if(InCombatLockdown()) then return end
	if(ObjectiveTrackerFrame:IsShown()) then ObjectiveTrackerFrame:Hide() end
end

function MOD:LoadQuestWatch()
	if(not ObjectiveTrackerFrame) then return end

	if(not SV.db.general.questWatch) then
		ObjectiveTrackerFrame:RemoveTextures(true)

		self.QuestWatch = CreateFrame("Frame", "SVUI_QuestWatchFrame", UIParent);
		self.QuestWatch:SetSize(200, ObjectiveTrackerFrame:GetHeight());
		self.QuestWatch:SetPoint("TOPRIGHT", UIParent, "RIGHT", -200, 100);

		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetClampedToScreen(false)
		ObjectiveTrackerFrame:SetAllPoints(self.QuestWatch)
		ObjectiveTrackerFrame:SetFrameLevel(self.QuestWatch:GetFrameLevel()  +  1)
		ObjectiveTrackerFrame.ClearAllPoints = SV.fubar;
		ObjectiveTrackerFrame.SetPoint = SV.fubar;
		ObjectiveTrackerFrame.SetAllPoints = SV.fubar;

		ObjectiveTrackerFrame.BlocksFrame:RemoveTextures(true)
		ObjectiveTrackerFrame.HeaderMenu:RemoveTextures(true)
		ObjectiveTrackerFrame.BlockDropDown:RemoveTextures(true)

		if(SV.db.general.questHeaders) then
			ObjectiveTrackerFrame.BlocksFrame.QuestHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.QuestHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.QuestHeader:SetBackdropColor(0, 0, 0, 0.5)

			ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:SetBackdropColor(0, 0, 0, 0.5)

			ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:SetBackdropColor(0, 0, 0, 0.5)
	  	end

		SV.Mentalo:Add(self.QuestWatch, "Quest Watch");
	else
		local bgTex = [[Interface\BUTTONS\WHITE8X8]]
		local bdTex = SV.Media.bar.glow

		self.QuestWatch = SV.Dock:NewDocklet("BottomRight", "SVUI_QuestWatchFrame", "Quest Watch", ICON_FILE)

		local WIDTH, HEIGHT = self.QuestWatch:GetSize()

		local listFrame = CreateFrame("ScrollFrame", "SVUI_QuestWatchFrameScrollFrame", self.QuestWatch);
		listFrame:SetPoint("TOPLEFT", self.QuestWatch, -62, 0);
		listFrame:SetPoint("BOTTOMRIGHT", self.QuestWatch, -31, 21);
		listFrame:EnableMouseWheel(true);

		local scrollFrame = CreateFrame("Slider", "SVUI_QuestWatchFrameScrollBar", listFrame);
		scrollFrame:SetHeight(listFrame:GetHeight());
		scrollFrame:SetWidth(18);
		scrollFrame:SetPoint("TOPRIGHT", self.QuestWatch, "TOPRIGHT", -3, 0);
		scrollFrame:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
		scrollFrame:SetFrameLevel(6)
		scrollFrame:SetFixedPanelTemplate("Transparent", true);
		scrollFrame:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
		scrollFrame:SetOrientation("VERTICAL");
		scrollFrame:SetValueStep(5);
		scrollFrame:SetMinMaxValues(1, 420);
		scrollFrame:SetValue(1);
		scrollFrame:SetScript("OnValueChanged", function(self, argValue)
			listFrame:SetVerticalScroll(argValue)
		end)

		listFrame.slider = scrollFrame;
		listFrame:SetScript("OnMouseWheel", function(self, delta)
			local scroll = self:GetVerticalScroll();
			local value = (scroll - (20  *  delta));
			if value < -1 then 
				value = 0
			end 
			if value > 420 then 
				value = 420
			end 
			--self:SetVerticalScroll(value)
			self.slider:SetValue(value)
		end)
		
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetClampedToScreen(false)
		ObjectiveTrackerFrame:SetHeight(500)
		ObjectiveTrackerFrame:SetWidth(WIDTH)
		ObjectiveTrackerFrame:SetPoint("TOPRIGHT", listFrame, "TOPRIGHT", -31, 0)
		ObjectiveTrackerFrame:SetFrameLevel(listFrame:GetFrameLevel() + 1)

		hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(self, a1, p, a2, x, y)
			if(p ~= SVUI_QuestWatchFrameScrollFrame) then
				self:SetPoint("TOPRIGHT", SVUI_QuestWatchFrameScrollFrame, "TOPRIGHT", -31, 0)
			end
		end)
		--ObjectiveTrackerFrame.SetPoint = function() return end;

		ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:Hide()

		ObjectiveTrackerFrame.BlocksFrame:RemoveTextures(true)
		ObjectiveTrackerFrame.BlocksFrame:SetPoint("TOPLEFT", ObjectiveTrackerFrame, "TOPLEFT", 87, 0)
		ObjectiveTrackerFrame.BlocksFrame:SetPoint("BOTTOMLEFT", ObjectiveTrackerFrame, "BOTTOMLEFT", 87, 0)
		ObjectiveTrackerFrame.BlocksFrame:SetWidth(WIDTH)

		ObjectiveTrackerFrame.BlocksFrame.QuestHeader:SetWidth((WIDTH - 60))
		ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:SetWidth((WIDTH - 60))
		ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:SetWidth((WIDTH - 60))

		if(SV.db.general.questHeaders) then
			ObjectiveTrackerFrame.BlocksFrame.QuestHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.QuestHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.QuestHeader:SetBackdropColor(0, 0, 0, 0.5)

			ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:SetBackdropColor(0, 0, 0, 0.5)

			ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:RemoveTextures(true)
			ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:SetFixedPanelTemplate("Headline", true)
	  		ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:SetBackdropColor(0, 0, 0, 0.5)
	  	end

		self.QuestWatch.DockButton:MakeDefault();
		self.QuestWatch:Show();
		self.QuestWatch:SetScript('OnShow', ShowSubDocklet);
		self.QuestWatch:SetScript('OnHide', HideSubDocklet);

		listFrame:SetScrollChild(ObjectiveTrackerFrame)
		SV.Timers:ExecuteTimer(function() SVUI_QuestWatchFrameScrollBar:SetValue(10) SVUI_QuestWatchFrameScrollBar:SetValue(0) end, 5)
	end
end