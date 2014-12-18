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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV:NewPackage("SVQuest", L['Questing']);
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local ROW_WIDTH = 300;
local ROW_HEIGHT = 24;
local INNER_HEIGHT = ROW_HEIGHT - 4;
local LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
local LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;
local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];
local LINE_QUEST_ICON = [[Interface\ICONS\Ability_Hisek_Aim]];
local LINE_POPUP_COMPLETE = [[Interface\ICONS\Ability_Hisek_Aim]];
local LINE_POPUP_OFFER = [[Interface\ICONS\Ability_Hisek_Aim]];
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:StyleStatusBar(bar)
	local bgFrame = CreateFrame("Frame", nil, bar)
	bgFrame:SetAllPointsIn(bar, -2, -2)
	bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)
	
	bgFrame.bg = bgFrame:CreateTexture(nil, "BACKGROUND")
	bgFrame.bg:SetAllPoints(bgFrame)
	bgFrame.bg:SetTexture(SV.Media.bar.default)
  	bgFrame.bg:SetVertexColor(0,0,0,0.5)

	local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
	borderB:SetTexture(0,0,0)
	borderB:SetPoint("BOTTOMLEFT")
	borderB:SetPoint("BOTTOMRIGHT")
	borderB:SetHeight(2)

	local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
	borderT:SetTexture(0,0,0)
	borderT:SetPoint("TOPLEFT")
	borderT:SetPoint("TOPRIGHT")
	borderT:SetHeight(2)

	local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
	borderL:SetTexture(0,0,0)
	borderL:SetPoint("TOPLEFT")
	borderL:SetPoint("BOTTOMLEFT")
	borderL:SetWidth(2)

	local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
	borderR:SetTexture(0,0,0)
	borderR:SetPoint("TOPRIGHT")
	borderR:SetPoint("BOTTOMRIGHT")
	borderR:SetWidth(2)
end

function MOD:GetTimerTextColor(duration, elapsed)
	local yellowPercent = .66
	local redPercent = .33
	
	local percentageLeft = 1 - ( elapsed / duration )
	if(percentageLeft > yellowPercent) then
		return 1, 1, 1;
	elseif(percentageLeft > redPercent) then
		local blueOffset = (percentageLeft - redPercent) / (yellowPercent - redPercent);
		return 1, 1, blueOffset;
	else
		local greenOffset = percentageLeft / redPercent;
		return 1, greenOffset, 0;
	end
end

function MOD:UpdateDimensions()
	local totalHeight = 1;
	local scrollHeight = self.Docklet.ScrollFrame:GetHeight();
	local scrollWidth = self.Docklet.ScrollFrame:GetWidth();

	for headerName, headerFrame in pairs(self.Headers) do
		totalHeight = totalHeight + headerFrame:GetHeight()
		headerFrame:SetWidth(scrollWidth)
	end

	self.Docklet.ScrollFrame.MaxVal = totalHeight;
	self.Docklet.ScrollFrame.ScrollBar:SetMinMaxValues(1, totalHeight);
	self.Docklet.ScrollFrame.ScrollBar:SetHeight(scrollHeight);
	self.Docklet.ScrollFrame.ScrollChild:SetWidth(scrollWidth);
	self.Docklet.ScrollFrame.ScrollChild:SetHeight(totalHeight);
end

function MOD:UpdateLocals()
	ROW_WIDTH = self.Docklet.ScrollFrame:GetWidth();
	ROW_HEIGHT = SV.db.SVQuest.rowHeight;
	INNER_HEIGHT = ROW_HEIGHT - 4;
	LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
	LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;
	SV.Events:Trigger("QUEST_UPVALUES_UPDATED", ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT);
end

function MOD:ReLoad()
	-- DO STUFF
	self:UpdateDimensions()
end 

function MOD:Load()
	self.Docklet = SV.Dock:NewDocklet("BottomRight", "SVUI_QuestTracker", "Quest Tracker", [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-QUESTS]]);

	local scrollFrame = CreateFrame("ScrollFrame", "SVUI_QuestTrackerScrollFrame", self.Docklet);
	scrollFrame:SetPoint("TOPLEFT", self.Docklet, "TOPLEFT", 4, -2);
	scrollFrame:SetPoint("BOTTOMRIGHT", self.Docklet, "BOTTOMRIGHT", -30, 2);
	scrollFrame:EnableMouseWheel(true);
	scrollFrame.MaxVal = 420;

	local scrollBar = CreateFrame("Slider", "SVUI_QuestTrackerScrollFrameScrollBar", scrollFrame);
	scrollBar:SetHeight(scrollFrame:GetHeight());
	scrollBar:SetWidth(18);
	scrollBar:SetPoint("TOPRIGHT", self.Docklet, "TOPRIGHT", -4, -2);
	scrollBar:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
	scrollBar:SetFrameLevel(6)
	scrollBar:SetStylePanel("Fixed", "Transparent", true);
	scrollBar:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
	scrollBar:SetOrientation("VERTICAL");
	scrollBar:SetValueStep(5);
	scrollBar:SetMinMaxValues(1, 420);
	scrollBar:SetValue(1);
	scrollBar:SetScript("OnValueChanged", function(self, argValue)
		SVUI_QuestTrackerScrollFrame:SetVerticalScroll(argValue)
	end)

	local scrollChild = CreateFrame("Frame", "SVUI_QuestTrackerScrollFrameScrollChild", scrollFrame);
	scrollChild:SetWidth(scrollFrame:GetWidth());
	scrollChild:SetClampedToScreen(false)
	scrollChild:SetHeight(500)
	scrollChild:SetPoint("TOPRIGHT", scrollFrame, "TOPRIGHT", -2, 0)
	scrollChild:SetFrameLevel(scrollFrame:GetFrameLevel() + 1)

	scrollFrame:SetScrollChild(scrollChild);
	scrollFrame.ScrollBar = scrollBar;
	scrollFrame.ScrollChild = scrollChild;
	scrollFrame:SetScript("OnMouseWheel", function(self, delta)
		local scroll = self:GetVerticalScroll();
		local value = (scroll - (20  *  delta));
		if value < -1 then 
			value = 0
		end 
		if value > self.MaxVal then 
			value = self.MaxVal
		end 
		self:SetVerticalScroll(value)
		self.ScrollBar:SetValue(value)
	end)

	self.Docklet.ScrollFrame = scrollFrame;
	self:UpdateLocals();

	self.ClosestQuest = 0;
	self.CurrentQuest = 0;
	self.Headers = {}

	self:InitializePopups()
	self:InitializeActive()
	self:InitializeScenarios()
	self:InitializeQuestItem()
	self:InitializeQuests()
	self:InitializeBonuses()
	self:InitializeAchievements()

	self:UpdateDimensions();
	self.Docklet.DockButton:MakeDefault();
	self.Docklet:Show();

	ObjectiveTrackerFrame:UnregisterAllEvents();
	ObjectiveTrackerFrame:SetParent(SV.Hidden);

	self.Headers["Popups"]:Refresh()
end