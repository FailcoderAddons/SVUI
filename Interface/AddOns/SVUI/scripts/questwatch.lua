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
local QuestDocklet = CreateFrame("Frame", "SVQuestFrameEventListener", UIParent)
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local WatchFrame = _G["WatchFrame"];
local SuperDockWindowRight;
local currentQuestItems = {};
local QuestDockletFrame, QuestDockletFrameTitle, QuestDockletFrameList, QuestDockletFrameSlider;
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-QUESTS]]
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local IsTrackingCompletedQuests = function()
	return band(WATCHFRAME_FILTER_TYPE, WATCHFRAME_FILTER_COMPLETED_QUESTS) == WATCHFRAME_FILTER_COMPLETED_QUESTS or false;
end 
local IsTrackingRemoteQuests = function()
	return ( band(WATCHFRAME_FILTER_TYPE, WATCHFRAME_FILTER_REMOTE_ZONES) == WATCHFRAME_FILTER_REMOTE_ZONES ) or false;
end 
local IsTrackingAchievements = function()
	return ( band(WATCHFRAME_FILTER_TYPE, WATCHFRAME_FILTER_ACHIEVEMENTS) == WATCHFRAME_FILTER_ACHIEVEMENTS ) or false;
end 
local IsUsingFilters = function()
	if ( WATCHFRAME_FILTER_COMPLETED_QUESTS == nil ) then return false; end
	return true;
end 
--[[
QUEST ITEM MACRO

/target [@mouseover]
/click WatchFrameItem1
/click WatchFrameItem2
/click WatchFrameItem3
/click WatchFrameItem4
/click WatchFrameItem5
/click WatchFrameItem6
]]--

-- poiWatchFrameLines1_1
-- poiWatchFrameLines2_1
-- poiWatchFrameLines3_1
-- poiButton:SetPoint("TOPRIGHT", questTitle, "TOPLEFT", 0, 5)

local function QWQuestItems()
	for i=1, WATCHFRAME_NUM_ITEMS do
		local button = _G["WatchFrameItem"..i]
		if button then
			local point, relativeTo, relativePoint, xOffset, yOffset = button:GetPoint(1)
			button:SetFrameStrata("LOW")
			button:SetPoint("TOPRIGHT", relativeTo, "TOPLEFT", -31, -2);
			if not button.styled then
				button:SetSlotTemplate()
				button:SetBackdropColor(0,0,0,0)
				_G["WatchFrameItem"..i.."NormalTexture"]:SetAlpha(0)
				_G["WatchFrameItem"..i.."IconTexture"]:FillInner()
				_G["WatchFrameItem"..i.."IconTexture"]:SetTexCoord(0.1,0.9,0.1,0.9)
				SV.Timers:AddCooldown(_G["WatchFrameItem"..i.."Cooldown"])
				button.styled = true
			end
		end
	end	
end 

local function QWCheckTimers()
	local lstTimers = GetQuestTimers();
	local numTimers = 0;
	local filterOK = false;
	if ( lstTimers ) then
		filterOK = true;
		numTimers = 1;
	else
		numTimers = 0;
	end
	return filterOK,numTimers;
end 

local function QWCheckQuests()
	local numQuestWatches = GetNumQuestWatches();
	local playerMoney = GetMoney();
	local numQuests = QuestMapUpdateAllQuests();
	local currentMapZone = GetCurrentMapZone();
	local questIndex = 0;
	local numCurrentMapQuests = 0;
	local numLocalQuests = 0;
	local numToShow = 0;
	local filterOK = false;
	local usingFilters = IsUsingFilters();
	if ( not usingFilters ) then
		filterOK = true;
		return filterOK, numQuestWatches or 0;
	elseif ( numQuestWatches == 0 ) then
		return filterOK, numQuestWatches or 0;
	end
	local trackingCompleted = IsTrackingCompletedQuests();
	local trackingRemote = IsTrackingRemoteQuests();
	local localQuests = {};
	local currentMapQuests = {};
	twipe(currentQuestItems);
	localQuests["zone"] = currentMapZone;	
	for i = 1, numQuests do
		local questId = QuestPOIGetQuestIDByVisibleIndex(i);
		currentMapQuests[questId] = i;
		numCurrentMapQuests = numCurrentMapQuests + 1;
	end
	for id in pairs(currentMapQuests) do	
		localQuests[id] = true;
		numLocalQuests = numLocalQuests + 1;
	end	
	for i = 1, numQuestWatches do
		questIndex = GetQuestIndexForWatch(i);
		if ( questIndex ) then
			local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questIndex);
			local requiredMoney = GetQuestLogRequiredMoney(questIndex);			
			local numObjectives = GetNumQuestLeaderBoards(questIndex);
			local itemLink,itemIcon,itemCharges = GetQuestLogSpecialItemInfo(questIndex);
			if ( isComplete and isComplete < 0 ) then
				isComplete = false;
			elseif ( numObjectives == 0 and playerMoney >= requiredMoney ) then
				isComplete = true;		
			end
			if ( itemLink ) then
				local _,itemID,_,_,_,_,_,_,_,_,_,_ = split(":", itemLink)
				local itemName = GetItemInfo(itemLink)
				currentQuestItems[itemName] = { ['id'] = itemID, ['icon'] = itemIcon, ['charge'] = itemCharges, ['macro'] = "/use item:"..itemID };
			end	
			local isLocal = localQuests[questID];
			filterOK = true;
			if ( isComplete and not trackingCompleted ) then 
				filterOK = false;
			elseif ( not isLocal and not trackingRemote ) then
				filterOK = false;
			end
			if ( filterOK ) then
				numToShow = numToShow + 1;
			end
		end
	end
	filterOK = false;
	if ( numToShow > 0 ) then
		filterOK = true;
	end
	return filterOK, numQuestWatches or 0;
end 

local function QWSetAllLevels()
    local i = 1
    local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
    for i,button in pairs(QuestLogScrollFrame.buttons) do
        local questIndex = i + scrollOffset
        local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle(questIndex)
        if ( not isHeader ) and questTitle then
            local newTitle = string.format("[%d] %s", level or "?", questTitle)
            button:SetText(newTitle)
            QuestLogTitleButton_Resize(button)
        end
        i = i + 1
    end
end

local function QWCheckAchievements()
	local numAchievementWatches = GetNumTrackedAchievements();
	local lstAchievementWatches = GetTrackedAchievements();
	local filterOK = false;	
	local usingFilters = IsUsingFilters();	
	if ( not usingFilters ) then
		filterOK = true;
		return filterOK, numAchievementWatches or 0;
	end		
	local trackingAchievements = IsTrackingAchievements();
	filterOK = false;
	if ( numAchievementWatches > 0 and trackingAchievements ) then
		filterOK = true;
	end	
	return filterOK, numAchievementWatches or 0;
end 

local function QWSetWatchFrameTitle()
	local _, numQuests, numAchievements, numTimers
	_, numQuests = QWCheckQuests()
	_, numAchievements = QWCheckAchievements()
	_, numTimers = QWCheckTimers()
	local numTracked = numQuests + numAchievements + numTimers;
	if WatchFrameTitle then
		WatchFrameTitle:SetText(OBJECTIVES_TRACKER_LABEL.." ("..numTracked ..")")
	end  
end 

local function QWCheckAutoShow(self)
	if not self then return end 
	if self:IsShown() then
		if WatchFrameHeader then 
			WatchFrameHeader:Show()
		end 
		WatchFrameTitle:Show()
		WatchFrameCollapseExpandButton:Show()
		WatchFrameLines:Show()
	end 
end 

local function SetQuestDockEvents()
	WatchFrame:HookScript("OnEvent", QWQuestItems)
	WatchFrame.ScrollListUpdate = function()
		QWSetWatchFrameTitle();
		WATCHFRAME_MAXLINEWIDTH = WatchFrame:GetWidth();
		if QuestDockletFrameList then 
			WATCHFRAME_MAXLINEWIDTH = QuestDockletFrameList:GetWidth() - 62
		end 
	end 
	WatchFrame.OnUpdate = function()
		WATCHFRAME_MAXLINEWIDTH = WatchFrame:GetWidth()
		if QuestDockletFrameList then 
			WATCHFRAME_MAXLINEWIDTH = QuestDockletFrameList:GetWidth() - 62
		end 
		QWQuestItems();
		--QWSetAllLevels()
		WatchFrame.ScrollListUpdate()
	end 
	WatchFrame.OnShow = function()
		Collapsed = (WatchFrame.collapsed or false);
		if WatchFrameHeader == nil then 
			WatchFrame.userCollapsed = true 
		end 
		UserCollapsed = (WatchFrame.userCollapsed or false);
		if Collapsed then 
			WatchFrame_Collapse(WatchFrame)
			WatchFrame.userCollapsed=UserCollapsed 
		else 
			WatchFrame_Expand(WatchFrame)
		end 
		WatchFrame.OnUpdate();
	end 
	WatchFrame.OnShow()

	hooksecurefunc("QuestLog_Update", WatchFrame.OnUpdate)
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
local QuestDocklet_OnEvent = function(self, event)
	if event == "CVAR_UPDATE" then
		if action == "WATCH_FRAME_WIDTH_TEXT"then 
			if WatchFrame then 
				WatchFrame.OnUpdate()
			end 
		end
	elseif event == "QUEST_AUTOCOMPLETE" then
		if SuperDockWindowRight.FrameName and _G[SuperDockWindowRight.FrameName] and _G[SuperDockWindowRight.FrameName]:IsShown() then return end 
			local button = _G["QuestDockletFrame_ToolBarButton"]
		if not QuestDockletFrame:IsShown() then
			SuperDockWindowRight.FrameName = "QuestDockletFrame"
			if not SuperDockWindowRight:IsShown()then
				SuperDockWindowRight:Show()
			end
			SV:CycleDocklets()
			QuestDockletFrame:Show()
			if button then
				button.IsOpen = true;
				button:SaveColors("green", "green")
			end
		end
	end
end

local function CreateQuestDocklet()
	SuperDockWindowRight = _G["SuperDockWindowRight"]
	if(SV.GameVersion >= 60000) then

		ObjectiveTrackerFrame:RemoveTextures(true)

		local frame = CreateFrame("Frame", "SVUI_QuestFrame", UIParent);
		frame:SetSize(200, ObjectiveTrackerFrame:GetHeight());
		frame:SetPoint("TOPRIGHT", UIParent, "RIGHT", -200, 100);
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetClampedToScreen(false)
		ObjectiveTrackerFrame:SetParent(SVUI_QuestFrame)
		ObjectiveTrackerFrame:SetAllPoints(SVUI_QuestFrame)
		ObjectiveTrackerFrame:SetFrameLevel(SVUI_QuestFrame:GetFrameLevel()  +  1)
		ObjectiveTrackerFrame.ClearAllPoints = SV.fubar;
		ObjectiveTrackerFrame.SetPoint = SV.fubar;
		ObjectiveTrackerFrame.SetAllPoints = SV.fubar;

		ObjectiveTrackerFrame.BlocksFrame:RemoveTextures(true)
		ObjectiveTrackerFrame.BlocksFrame.QuestHeader:RemoveTextures(true)
		ObjectiveTrackerFrame.BlocksFrame.AchievementHeader:RemoveTextures(true)
		ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader:RemoveTextures(true)
		ObjectiveTrackerFrame.HeaderMenu:RemoveTextures(true)
		ObjectiveTrackerFrame.BlockDropDown:RemoveTextures(true)

		SV.Mentalo:Add(frame, "Quest Watch");
	elseif(not SV.db.general.questWatch) then
		local frame = CreateFrame("Frame", "SVUI_QuestFrame", UIParent);
		frame:SetSize(200, WatchFrame:GetHeight());
		frame:SetPoint("RIGHT", UIParent, "RIGHT", -100, 0);
		WatchFrame:ClearAllPoints()
		WatchFrame:SetClampedToScreen(false)
		WatchFrame:SetParent(SVUI_QuestFrame)
		WatchFrame:SetAllPoints(SVUI_QuestFrame)
		WatchFrame:SetFrameLevel(SVUI_QuestFrame:GetFrameLevel()  +  1)
		WatchFrame.ClearAllPoints = SV.fubar;
		WatchFrame.SetPoint = SV.fubar;
		WatchFrame.SetAllPoints = SV.fubar;
		WatchFrameLines.ClearAllPoints = SV.fubar;
		WatchFrameLines.SetPoint = SV.fubar;
		WatchFrameLines.SetAllPoints = SV.fubar;

		SV.Mentalo:Add(frame, "Quest Watch");
	else
		local bgTex = [[Interface\BUTTONS\WHITE8X8]]
		local bdTex = SV.Media.bar.glow
		QuestDockletFrame = CreateFrame("Frame", "QuestDockletFrame", SuperDockWindowRight);
		QuestDockletFrame:SetFrameStrata("BACKGROUND");
		SV:RegisterDocklet("QuestDockletFrame", "Quest Watch", ICON_FILE, false, true)

		QuestDockletFrameList = CreateFrame("ScrollFrame", nil, QuestDockletFrame);
		QuestDockletFrameList:SetPoint("TOPLEFT", QuestDockletFrame, -62, 0);
		QuestDockletFrameList:SetPoint("BOTTOMRIGHT", QuestDockletFrame, -31, 21);
		QuestDockletFrameList:EnableMouseWheel(true);

		QuestDockletFrameSlider = CreateFrame("Slider", nil, QuestDockletFrameList);
		QuestDockletFrameSlider:SetHeight(QuestDockletFrameList:GetHeight());
		QuestDockletFrameSlider:SetWidth(18);
		QuestDockletFrameSlider:SetPoint("TOPRIGHT", QuestDockletFrame, "TOPRIGHT", -3, 0);
		QuestDockletFrameSlider:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
		QuestDockletFrameSlider:SetFrameLevel(6)
		QuestDockletFrameSlider:SetFixedPanelTemplate("Transparent", true);
		QuestDockletFrameSlider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
		QuestDockletFrameSlider:SetOrientation("VERTICAL");
		QuestDockletFrameSlider:SetValueStep(5);
		QuestDockletFrameSlider:SetMinMaxValues(1, 420);
		QuestDockletFrameSlider:SetValue(1);

		QuestDockletFrameList.slider = QuestDockletFrameSlider;
		QuestDockletFrameList:SetScript("OnMouseWheel", function(self, delta)
			local scroll = self:GetVerticalScroll();
			local value = (scroll - (20  *  delta));
			if value < -1 then 
				value = 0
			end 
			if value > 420 then 
				value = 420
			end 
			self:SetVerticalScroll(value)
			self.slider:SetValue(value)
		end)

		local QuestDockletFrameTitle = CreateFrame("Frame", nil, QuestDockletFrame);
		QuestDockletFrameTitle:Point("TOPLEFT", QuestDockletFrameList, "BOTTOMLEFT", 0, 0);
		QuestDockletFrameTitle:Point("TOPRIGHT", QuestDockletFrameList, "BOTTOMRIGHT", 0, 0);
		QuestDockletFrameTitle:SetHeight(18)
		
		WatchFrame:ClearAllPoints()
		WatchFrame:SetClampedToScreen(false)
		WatchFrame:SetParent(QuestDockletFrameList)
		WatchFrame:SetHeight(500)
		WatchFrame:SetPoint("TOPRIGHT", QuestDockletFrameList, "TOPRIGHT", -31, 0)
		WatchFrame:SetFrameLevel(QuestDockletFrameList:GetFrameLevel()  +  1)
		if QuestDockletFrameList then 
			WATCHFRAME_MAXLINEWIDTH = (QuestDockletFrameList:GetWidth() - 100);
			WATCHFRAME_EXPANDEDWIDTH = (QuestDockletFrameList:GetWidth() - 100); 
		else 
			WATCHFRAME_MAXLINEWIDTH = (WatchFrame:GetWidth() - 100);
			WATCHFRAME_EXPANDEDWIDTH = (WatchFrame:GetWidth() - 100);
		end 
		WatchFrame:SetWidth(WATCHFRAME_MAXLINEWIDTH)

		WatchFrameHeader:SetParent(QuestDockletFrame)
		WatchFrameHeader:ClearAllPoints()
		WatchFrameHeader:FillInner(QuestDockletFrameTitle)
		WatchFrameHeader:SetFrameLevel(2)

		WatchFrameTitle:SetParent(QuestDockletFrame)
		WatchFrameTitle:ClearAllPoints()
		WatchFrameTitle:FillInner(QuestDockletFrameTitle)

		WatchFrameCollapseExpandButton:SetParent(QuestDockletFrame)
		WatchFrameCollapseExpandButton:ClearAllPoints()
		WatchFrameCollapseExpandButton:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
		WatchFrameCollapseExpandButton:Hide()

		QuestDockletFrameList:SetScrollChild(WatchFrame)
		QuestDockletFrameSlider:SetScript("OnValueChanged", function(self, argValue)
			QuestDockletFrameList:SetVerticalScroll(argValue)
		end)
		QuestDockletFrameSlider:ClearAllPoints()
		QuestDockletFrameSlider:SetPoint("TOPRIGHT", QuestDockletFrame, "TOPRIGHT", -3, 0)

		WatchFrameLines:RemoveTextures(true)
		WatchFrameLines:SetPoint("TOPLEFT", WatchFrame, "TOPLEFT", 87, 0)
		WatchFrameLines:SetPoint("BOTTOMLEFT", WatchFrame, "BOTTOMLEFT", 87, 0)
		WatchFrameLines:SetWidth(WATCHFRAME_MAXLINEWIDTH - 100)
		--[[Lets murder some internals to prevent overriding]]--
		WatchFrame.ClearAllPoints = SV.fubar;
		WatchFrame.SetPoint = SV.fubar;
		WatchFrame.SetAllPoints = SV.fubar;
		WatchFrameLines.ClearAllPoints = SV.fubar;
		WatchFrameLines.SetPoint = SV.fubar;
		WatchFrameLines.SetAllPoints = SV.fubar;
		WatchFrameLines.SetWidth = SV.fubar;
		WatchFrameCollapseExpandButton.ClearAllPoints = SV.fubar;
		WatchFrameCollapseExpandButton.SetPoint = SV.fubar;
		WatchFrameCollapseExpandButton.SetAllPoints = SV.fubar;

		SetQuestDockEvents()

		QuestDocklet:RegisterEvent("CVAR_UPDATE")
		QuestDocklet:RegisterEvent("QUEST_AUTOCOMPLETE")
		QuestDocklet:SetScript("OnEvent", QuestDocklet_OnEvent)
	end
end 

SV:NewScript(CreateQuestDocklet)