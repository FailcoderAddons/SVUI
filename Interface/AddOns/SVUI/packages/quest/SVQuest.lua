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
local LINE_QUEST_ICON = [[Interface\ICONS\Ability_Hisek_Aim]]

local ClosestQuestName, ClosestQuestLink, ClosestQuestTexture;
local QuestInZone = {
	[14108] = 541,
	[13998] = 11,
	[25798] = 61,
	[25799] = 61,
	[25112] = 161,
	[25111] = 161,
	[24735] = 201,
};
--[[ 
########################################################## 
SCRIPT HANDLERS
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

local ViewButton_OnClick = function(self, button)
	local questIndex = self:GetID();
	if(questIndex and (questIndex ~= 0)) then
		local questID = select(8, GetQuestLogTitle(questIndex));
		if(IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
			local questLink = GetQuestLink(questIndex);
			if(questLink) then
				ChatEdit_InsertLink(questLink);
			end
		elseif(button ~= "RightButton") then
			CloseDropDownMenus();
			if(IsModifiedClick("QUESTWATCHTOGGLE")) then
				local superTrackedQuestID = GetSuperTrackedQuestID();
				RemoveQuestWatch(questIndex);
				if(questID == superTrackedQuestID) then
					QuestSuperTracking_OnQuestUntracked();
				end
			else
				if(IsQuestComplete(questID) and GetQuestLogIsAutoComplete(questIndex)) then
					AutoQuestPopupTracker_RemovePopUp(questID);
					ShowQuestComplete(questIndex);
				else
					QuestLogPopupDetailFrame_Show(questIndex);
				end
			end
			return;
		else
			QuestMapFrame_OpenToQuestDetails(questID);
		end
	end
end
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function NewObjectiveRow(parent, lineNumber)
	local lastRowNumber = lineNumber - 1;
	local previousFrame = parent.Rows[lastRowNumber]
	local yOffset = (lineNumber * (ROW_HEIGHT)) - ROW_HEIGHT

	local objective = CreateFrame("Frame", nil, parent)
	objective:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -yOffset);
	objective:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -yOffset);
	objective:SetHeight(INNER_HEIGHT);
	--objective:SetPanelTemplate()

	objective.Icon = objective:CreateTexture(nil,"OVERLAY")
	objective.Icon:SetPoint("TOPLEFT", objective, "TOPLEFT", 4, -2);
	objective.Icon:SetPoint("BOTTOMLEFT", objective, "BOTTOMLEFT", 4, 2);
	objective.Icon:SetWidth(INNER_HEIGHT - 4);
	objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)

	objective.Text = objective:CreateFontString(nil,"OVERLAY")
	objective.Text:SetPoint("TOPLEFT", objective, "TOPLEFT", INNER_HEIGHT + 6, -2);
	objective.Text:SetPoint("TOPRIGHT", objective, "TOPRIGHT", 0, -2);
	objective.Text:SetHeight(INNER_HEIGHT - 2)
	objective.Text:SetFont(SV.Media.font.roboto, 12, "NONE")
	objective.Text:SetTextColor(1,1,1)
	objective.Text:SetShadowOffset(-1,-1)
	objective.Text:SetShadowColor(0,0,0,0.5)
	objective.Text:SetJustifyH('LEFT')
	objective.Text:SetJustifyV('MIDDLE')
	objective.Text:SetText('')

	return objective;
end

local AddObjectiveRow = function(self, index, description, completed, duration, elapsed)
	local objective = self.Rows[index];

	if(not objective) then
		self.Rows[index] = NewObjectiveRow(self, index)
		objective = self.Rows[index]
	end

	objective.Text:SetText(description)

	if(completed) then
		objective.Text:SetTextColor(0.1,0.9,0.1)
		objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
	else
		objective.Text:SetTextColor(1,1,1)
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
	end

	if(duration and elapsed) then
		if(duration > 0 and elapsed <= duration ) then
			--DO STUFF	
		else
			--DO STUFF	
		end
	end

	objective:Show()

	return objective;
end

local function NewActiveRow(anchorFrame)
	local parent = MOD.Active

	local row = CreateFrame("Frame", nil, parent)
	if(anchorFrame) then
		row:Point("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -4);
		row:Point("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -4);
	else
		row:Point("TOPLEFT", parent, "TOPLEFT", 2, -4);
		row:Point("TOPRIGHT", parent, "TOPRIGHT", -2, -4);
	end
	row:Height(LARGE_ROW_HEIGHT);

	row.Badge = CreateFrame("Frame", nil, row)
	row.Badge:Point("TOPLEFT", row, "TOPLEFT", 4, -4);
	row.Badge:Size((LARGE_INNER_HEIGHT - 4), (LARGE_INNER_HEIGHT - 4));
	row.Badge:SetPanelTemplate("Inset")

	row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
	row.Badge.Icon:FillInner(row.Badge);
	row.Badge.Icon:SetTexture(LINE_QUEST_ICON)
	row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	row.Header = CreateFrame("Frame", nil, row)
	row.Header:Point("TOPLEFT", row.Badge, "TOPRIGHT", 4, -1);
	row.Header:Point("TOPRIGHT", row, "TOPRIGHT", -2, 0);
	row.Header:Height(INNER_HEIGHT);
	row.Header:SetPanelTemplate("Headline")

	row.Header.Level = row.Header:CreateFontString(nil,"OVERLAY")
	row.Header.Level:SetFont(SV.Media.font.roboto, 10, "NONE")
	row.Header.Level:SetShadowOffset(-1,-1)
	row.Header.Level:SetShadowColor(0,0,0,0.5)
	row.Header.Level:SetJustifyH('CENTER')
	row.Header.Level:SetJustifyV('MIDDLE')
	row.Header.Level:SetText('')
	row.Header.Level:Point("TOPLEFT", row.Header, "TOPLEFT", 4, 0);
	row.Header.Level:Point("BOTTOMLEFT", row.Header, "BOTTOMLEFT", 4, 0);

	row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
	row.Header.Text:SetFont(SV.Media.font.roboto, 14, "NONE")
	row.Header.Text:SetTextColor(1,1,0)
	row.Header.Text:SetShadowOffset(-1,-1)
	row.Header.Text:SetShadowColor(0,0,0,0.5)
	row.Header.Text:SetJustifyH('LEFT')
	row.Header.Text:SetJustifyV('MIDDLE')
	row.Header.Text:SetText('')
	row.Header.Text:Point("TOPLEFT", row.Header.Level, "TOPRIGHT", 4, 0);
	row.Header.Text:Point("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", 0, 0);

	row.Button = CreateFrame("Button", nil, row.Header)
	row.Button:SetAllPoints(row.Header);
	row.Button:SetButtonTemplate(true, 1, 1, 1)
	row.Button:SetID(0)
	row.Button:SetScript("OnClick", ViewButton_OnClick)

	row.Objectives = CreateFrame("Frame", nil, row)
	row.Objectives:Point("TOPLEFT", row.Header, "BOTTOMLEFT", 0, -2);
	row.Objectives:Point("TOPRIGHT", row.Header, "BOTTOMRIGHT", 0, -2);
	row.Objectives:Height(1);
	--row.Objectives:SetPanelTemplate("Inset");

	row.Objectives.Rows = {}
	row.Objectives.Add = AddObjectiveRow;

	row.RowID = 0;

	return row;
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local AddActiveScenarioRow = function(self, title, level, details, icon, questID, questLogIndex, numObjectives, duration, elapsed)
	local objectivesShown = 0;
	local nextObjective = 1;

	local row = self.Rows.Scenario;
	if(row.RowID == questID) then
		return
	end

	row.RowID = questID
	icon = icon or LINE_QUEST_ICON;

	local color = GetQuestDifficultyColor(level)
	
	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button:SetID(questLogIndex)
	row:Show()

	local objectives = row.Objectives;
	for i = 1, numObjectives do
		local description, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed = C_Scenario.GetCriteriaInfo(i);
		if(description) then
			description = string.format("%d/%d %s", quantity, totalQuantity, description);
			objectives:Add(i, description, completed, duration, elapsed)
			nextObjective = nextObjective + 1;
		end
	end

	local numLineObjectives = #objectives.Rows;
	for x = nextObjective, numLineObjectives do
		local objective = objectives.Rows[x]
		if(objective) then
			objective.Text:SetText('')
			objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
			if(objective:IsShown()) then
				objective:Hide()
			end
		end
	end

	local objectiveHeight = (INNER_HEIGHT + 2) * numObjectives;
	objectives:SetHeight(objectiveHeight + 1);

	local newHeight = (nextObjective * (LARGE_ROW_HEIGHT + 2)) + (numObjectives * (INNER_HEIGHT + 2)) + (LARGE_INNER_HEIGHT + (nextObjective * 2));
	row:SetHeight(newHeight);

	MOD.Tracker.ScrollFrame.ScrollBar:SetValue(0)
end

local AddActivePopupRow = function(self, title, flag, questID, questLogIndex)
	local objectivesShown = 0;
	local nextObjective = 1;

	local row = self.Rows.Popup;
	if(row.RowID == questID) then
		return
	end

	row.RowID = questID

	icon = icon or LINE_QUEST_ICON;

	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button:SetID(questLogIndex)
	row:Show()

	-- local objectives = row.Objectives;
	-- local numLineObjectives = #objectives.Rows;

	-- for x = 1, numLineObjectives do
	-- 	local objective = objectives.Rows[x]
	-- 	if(objective) then
	-- 		objective.Text:SetText('')
	-- 		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
	-- 		if(objective:IsShown()) then
	-- 			objective:Hide()
	-- 		end
	-- 	end
	-- end

	-- objectives:SetHeight(1);
	local newHeight = LARGE_ROW_HEIGHT + 2;
	row:SetHeight(newHeight);
end

local AddActiveRow = function(self, title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed)
	local nextObjective = 1;

	local row = self.Rows.Quest;
	if(row.RowID == questID) then
		return
	end

	icon = icon or LINE_QUEST_ICON;
	row.RowID = questID

	local color = GetQuestDifficultyColor(level)
	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button:SetID(questLogIndex)
	row:Show()

	local objectives = row.Objectives;

	for i = 1, numObjectives do
		local description, category, completed = GetQuestObjectiveInfo(questID, i);
		if(description) then
			objectives:Add(i, description, completed, duration, elapsed)
			nextObjective = nextObjective + 1;
		end
	end

	local numLineObjectives = #objectives.Rows;

	for x = nextObjective, numLineObjectives do
		local objective = objectives.Rows[x]
		if(objective) then
			objective.Text:SetText('')
			objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
			if(objective:IsShown()) then
				objective:Hide()
			end
		end
	end

	local objectiveHeight = (INNER_HEIGHT + 2) * numObjectives;
	objectives:SetHeight(objectiveHeight + 1);

	local newHeight = (LARGE_ROW_HEIGHT + 2) + (numObjectives * (INNER_HEIGHT + 2)) + 2;
	row:SetHeight(newHeight);

	MOD.Tracker.ScrollFrame.ScrollBar:SetValue(0)
end

local unset_row = function(row)
	row:SetHeight(1)
	row.Header.Text:SetText('')
	row.Header.Level:SetText('')
	row.Badge.Icon:SetTexture(0,0,0,0)
	row.Button:SetID(0)
	row:Hide()
end

local RefreshActiveHeight = function(self)
	if(self.Rows.Scenario.RowID == 0) then
		unset_row(self.Rows.Scenario)
	end
	if(self.Rows.Popup.RowID == 0) then
		unset_row(self.Rows.Popup)
	end
	if(self.Rows.Quest.RowID == 0) then
		unset_row(self.Rows.Quest)
	end

	local h1 = self.Rows.Scenario:GetHeight()
	local h2 = self.Rows.Popup:GetHeight()
	local h3 = self.Rows.Quest:GetHeight()
	local NEWHEIGHT = h1 + h2 + h3 + 6;
	self:SetHeight(NEWHEIGHT)
end

local RefreshActiveObjective = function(self, event, ...)
	if(C_Scenario.IsInScenario()) then
		if(event and (event == 'SCENARIO_UPDATE' or event == 'SCENARIO_CRITERIA_UPDATE')) then
			local scenarioName, currentStage, numStages, flags, _, _, _, xp, money = C_Scenario.GetInfo();
			if(scenarioName) then
				local stageName, stageDescription, numObjectives = C_Scenario.GetStepInfo();
				-- local inChallengeMode = bit.band(flags, SCENARIO_FLAG_CHALLENGE_MODE) == SCENARIO_FLAG_CHALLENGE_MODE;
				-- local inProvingGrounds = bit.band(flags, SCENARIO_FLAG_PROVING_GROUNDS) == SCENARIO_FLAG_PROVING_GROUNDS;
				-- local dungeonDisplay = bit.band(flags, SCENARIO_FLAG_USE_DUNGEON_DISPLAY) == SCENARIO_FLAG_USE_DUNGEON_DISPLAY;
				local scenariocompleted = currentStage > numStages;
				if(not scenariocompleted) then
					self:AddScenario(title, level, details, icon, questID, questLogIndex, numObjectives, duration, elapsed)
				else
					self.Rows.Scenario.RowID = 0
				end
			end
		end
	else
		self.Rows.Scenario.RowID = 0
	end

	if(event) then
		if(event == 'AUTO_QUEST_ADD') then
			self.Rows.Popup.RowID = 0
			for i = 1, GetNumAutoQuestPopUps() do
				local questID, popUpType = GetAutoQuestPopUp(i);
				if(questID) then
					local questLogIndex = GetQuestLogIndexByID(questID);
					local title = GetQuestLogTitle(questLogIndex);
					self:AddPopup(title, popUpType, questID, questLogIndex)
				end
			end
			MOD.Tracker.ScrollFrame.ScrollBar:SetValue(0)
		elseif(event == 'AUTO_QUEST_REMOVE') then
			self.Rows.Popup.RowID = 0
		elseif(event == 'ACTIVE_QUEST_LOADED') then
			self.Rows.Quest.RowID = 0
			self:AddGeneral(...)
		end
	end

	self:RefreshHeight()
end

local _hook_AutoPopAdd = function(questID, popUpType)
	self.Active:Refresh('AUTO_QUEST_ADD')
end

local _hook_AutoPopRemove = function(questID)
	self.Active:Refresh('AUTO_QUEST_REMOVE')
end

local UpdateScrollFrame = function(self)
	local h1 = MOD.Active:GetHeight()
	local h2 = MOD.Quests:GetHeight()
	local h3 = MOD.Achievements:GetHeight()
	local NEWHEIGHT = h1 + h2 + h3 + 6;
	local scrollHeight = self.ScrollFrame:GetHeight();
	local scrollWidth = self.ScrollFrame:GetWidth();

	self.ScrollFrame.MaxVal = NEWHEIGHT;
	self.ScrollFrame.ScrollBar:SetMinMaxValues(1, NEWHEIGHT);
	self.ScrollFrame.ScrollBar:SetHeight(scrollHeight);
	self.ScrollFrame.ScrollChild:SetWidth(scrollWidth);
	self.ScrollFrame.ScrollChild:SetHeight(NEWHEIGHT);

	MOD.Active:SetWidth(scrollWidth);
	MOD.Quests:SetWidth(scrollWidth);
	MOD.Achievements:SetWidth(scrollWidth);
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateActiveObjective(event, ...)
	self.Active:Refresh(event, ...)
	self.Tracker:Refresh()
end

function MOD:UpdateLocals()
	ROW_WIDTH = self.Tracker.ScrollFrame:GetWidth();
	ROW_HEIGHT = SV.db.SVQuest.rowHeight;
	INNER_HEIGHT = ROW_HEIGHT - 4;
	LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
	LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;
end

function MOD:ReLoad()
	-- DO STUFF
end 

function MOD:Load()
	self.Tracker = SV.Dock:NewDocklet("BottomRight", "SVUI_QuestTracker", "Quest Tracker", [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-QUESTS]]);

	local scrollFrame = CreateFrame("ScrollFrame", "SVUI_QuestTrackerScrollFrame", self.Tracker);
	scrollFrame:SetPoint("TOPLEFT", self.Tracker, "TOPLEFT", 4, -2);
	scrollFrame:SetPoint("BOTTOMRIGHT", self.Tracker, "BOTTOMRIGHT", -30, 2);
	scrollFrame:EnableMouseWheel(true);
	scrollFrame.MaxVal = 420;

	self.Tracker.ScrollFrame = scrollFrame;

	self:UpdateLocals();

	local scrollBar = CreateFrame("Slider", "SVUI_QuestTrackerScrollFrameScrollBar", scrollFrame);
	scrollBar:SetHeight(scrollFrame:GetHeight());
	scrollBar:SetWidth(18);
	scrollBar:SetPoint("TOPRIGHT", self.Tracker, "TOPRIGHT", -4, -2);
	scrollBar:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
	scrollBar:SetFrameLevel(6)
	scrollBar:SetFixedPanelTemplate("Transparent", true);
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
	--scrollChild:SetPanelTemplate();

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
		--self:SetVerticalScroll(value)
		self.ScrollBar:SetValue(value)
	end)

	self.Tracker.Refresh = UpdateScrollFrame;

	self:UpdateLocals();

	local active = CreateFrame("Frame", nil, scrollChild)
    active:SetWidth(ROW_WIDTH);
	active:SetHeight(1);
	active:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);
	active:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, 0);
	--active:SetPanelTemplate();

	active.Rows = {};
	active.Refresh = RefreshActiveObjective;
	active.RefreshHeight = RefreshActiveHeight;
	--active.Refresh = SV.fubar
	
	active.AddScenario = AddActiveScenarioRow;
	active.AddPopup = AddActivePopupRow;
	--active.AddBonus = AddActiveBonusRow;
	active.AddGeneral = AddActiveRow;

	self.Active = active;

	self.Active.Rows.Scenario = NewActiveRow()
	self.Active.Rows.Popup = NewActiveRow(self.Active.Rows.Scenario)
	self.Active.Rows.Quest = NewActiveRow(self.Active.Rows.Popup)
	self.Active:RefreshHeight()

	self:InitializeQuestItem()
	self:InitializeQuests()
	self:InitializeAchievements()

	self:RegisterEvent("SCENARIO_UPDATE", self.UpdateActiveObjective);
	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE", self.UpdateActiveObjective);

	--hooksecurefunc("AddAutoQuestPopUp", _hook_AutoPopAdd)
	--hooksecurefunc("RemoveAutoQuestPopUp", _hook_AutoPopRemove)

	self.Tracker.DockButton:MakeDefault();
	self.Tracker:Show();
	self.Tracker:Refresh();

	ObjectiveTrackerFrame:UnregisterAllEvents();
	ObjectiveTrackerFrame:SetParent(SV.Hidden);
end