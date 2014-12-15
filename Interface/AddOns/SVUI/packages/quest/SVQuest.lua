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
SCRIPT HANDLERS
##########################################################
]]--
local function unset_row(row)
	row:SetHeight(1)
	row.Header.Text:SetText('')
	row.Header.Level:SetText('')
	row.Badge.Icon:SetTexture(0,0,0,0)
	row.Button:SetID(0)
	row:Hide()
end

local ActiveButton_OnClick = function(self, button)
	local parent = self.Parent;
	local row = parent.Block;
	unset_row(row);
	parent:RefreshHeight();
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

local PopUpButton_OnClick = function(self, button)
	local questIndex = self:GetID();
	if(questIndex and (questIndex ~= 0) and self.PopUpType) then
		local questID = select(8, GetQuestLogTitle(questIndex));
		if(self.PopUpType == "OFFER") then
			ShowQuestOffer(questID);
		else
			ShowQuestComplete(questID);
		end
		AutoQuestPopupTracker_RemovePopUp(questID);
	end
end

local CloseButton_OnEnter = function(self)
    self:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local CloseButton_OnLeave = function(self)
    self:SetBackdropBorderColor(0,0,0,1)
end
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
function MOD:NewObjectiveRow(parent, lineNumber)
	local lastRowNumber = lineNumber - 1;
	local previousFrame = parent.Rows[lastRowNumber]
	local yOffset = (lineNumber * (ROW_HEIGHT)) - ROW_HEIGHT

	local objective = CreateFrame("Frame", nil, parent)
	objective:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -yOffset);
	objective:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -yOffset);
	objective:SetHeight(INNER_HEIGHT);
	--objective:SetStylePanel("Default")

	objective.Icon = objective:CreateTexture(nil,"OVERLAY")
	objective.Icon:SetPoint("TOPLEFT", objective, "TOPLEFT", 4, -2);
	objective.Icon:SetPoint("BOTTOMLEFT", objective, "BOTTOMLEFT", 4, 2);
	objective.Icon:SetWidth(INNER_HEIGHT - 4);
	objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)

	objective.Bar = CreateFrame("StatusBar", nil, objective)
	objective.Bar:SetPoint("TOPLEFT", objective.Icon, "TOPRIGHT", 4, 0);
	objective.Bar:SetPoint("BOTTOMRIGHT", objective, "BOTTOMRIGHT", -2, 2);
	objective.Bar:SetStatusBarTexture(SV.Media.bar.default)
	objective.Bar:SetStatusBarColor(0.5,0,1)
	objective.Bar:SetMinMaxValues(0, 1)
	objective.Bar:SetValue(0)

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

function MOD:AddObjectiveRow(index, description, completed, duration, elapsed)
	local objective = self.Rows[index];

	if(not objective) then
		self.Rows[index] = MOD:NewObjectiveRow(self, index)
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

	duration = duration or 1;
	elapsed = (elapsed and elapsed <= duration) and elapsed or 0;
	objective.Bar:SetMinMaxValues(0, duration)
	objective.Bar:SetValue(elapsed)	

	objective:Show()

	return objective;
end
--[[ 
########################################################## 
ACTIVE FUNCTIONS
##########################################################
]]--
local SetActiveData = function(self, title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed)
	local nextObjective = 1;

	local block = self.Block;
	if(block.RowID == questID) then
		return
	end

	icon = icon or LINE_QUEST_ICON;
	block.RowID = questID

	local color = GetQuestDifficultyColor(level)
	block.Header.Level:SetTextColor(color.r, color.g, color.b)
	block.Header.Level:SetText(level)
	block.Header.Text:SetText(title)
	block.Badge.Icon:SetTexture(icon)
	block.Button:SetID(questLogIndex)
	block:Show()

	local objectives = block.Objectives;

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
	block:SetHeight(newHeight);

	MOD.Tracker.ScrollFrame.ScrollBar:SetValue(0)
end

local RefreshActiveHeight = function(self)
	if(self.Block.RowID == 0) then
		unset_row(self.Block)
	end
	self:SetHeight(self.Block:GetHeight())
end

local RefreshActiveObjective = function(self, event, ...)
	if(event and (event == 'ACTIVE_QUEST_LOADED')) then
		self.Block.RowID = 0
		self:Set(...)
	end

	self:RefreshHeight()
end
--[[ 
########################################################## 
POPUP FUNCTIONS
##########################################################
]]--
local function NewPopUpRow(lineNumber)
	local parent = MOD.Popup;
	local lastRowNumber = lineNumber - 1;
	local previousFrame = parent.Rows[lastRowNumber]

	local row = CreateFrame("Frame", nil, parent)
	if(previousFrame) then
		row:SetPoint("TOPLEFT", previousFrame, "BOTTOMLEFT", 0, -2);
		row:SetPoint("TOPRIGHT", previousFrame, "BOTTOMRIGHT", 0, -2);
	else
		row:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -2);
		row:SetPoint("TOPRIGHT", parent, "TOPRIGHT", 0, -2);
	end
	row:SetHeightToScale(LARGE_ROW_HEIGHT);

	row.Button = CreateFrame("Button", nil, row)
	row.Button:SetPointToScale("TOPLEFT", row, "TOPLEFT", 0, 0);
	row.Button:SetPointToScale("BOTTOMRIGHT", row, "BOTTOMRIGHT", 0, 8);
	row.Button:SetStylePanel("Framed", "FramedTop")
	row.Button:SetPanelColor("yellow")
	row.Button:SetID(0)
	row.Button.PopUpType = nil;
	row.Button:SetScript("OnClick", PopUpButton_OnClick)

	row.Badge = CreateFrame("Frame", nil, row.Button)
	row.Badge:SetPointToScale("TOPLEFT", row.Button, "TOPLEFT", 4, -4);
	row.Badge:SetSizeToScale((LARGE_INNER_HEIGHT - 4), (LARGE_INNER_HEIGHT - 4));
	row.Badge:SetStylePanel("Fixed", "Inset")

	row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
	row.Badge.Icon:SetAllPointsIn(row.Badge);
	row.Badge.Icon:SetTexture(LINE_QUEST_ICON)
	row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	row.Header = CreateFrame("Frame", nil, row.Button)
	row.Header:SetPointToScale("TOPLEFT", row.Badge, "TOPRIGHT", 4, -1);
	row.Header:SetPointToScale("BOTTOMRIGHT", row.Button, "BOTTOMRIGHT", -2, 2);
	row.Header:SetStylePanel("Default")

	row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
	row.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
	row.Header.Text:SetTextColor(1,1,0)
	row.Header.Text:SetShadowOffset(-1,-1)
	row.Header.Text:SetShadowColor(0,0,0,0.5)
	row.Header.Text:SetJustifyH('LEFT')
	row.Header.Text:SetJustifyV('MIDDLE')
	row.Header.Text:SetText('')
	row.Header.Text:SetPointToScale("TOPLEFT", row.Header, "TOPLEFT", 0, 0);
	row.Header.Text:SetPointToScale("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", 0, 0);

	row.RowID = 0;

	return row;
end

local AddPopupRow = function(self, title, popUpType, questID, questLogIndex)
	local index = #self.Rows + 1;

	local row = self.Rows[index];
	if(not row) then
		self.Rows[index] = NewPopUpRow(index)
		row = self.Rows[index]
	end
	row.RowID = questID

	local icon = (popUpType == 'COMPLETED') and LINE_POPUP_COMPLETE or LINE_POPUP_OFFER

	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button.PopUpType = popUpType
	row.Button:SetID(questLogIndex)
	row:Show()
end

local RefreshPopupObjective = function(self, event, ...)
	local nextLine = 1;
	for i = 1, GetNumAutoQuestPopUps() do
		local questID, popUpType = GetAutoQuestPopUp(i);
		local questLogIndex = GetQuestLogIndexByID(questID);
		local title = GetQuestLogTitle(questLogIndex);
		if(title and title ~= '') then
			self:Add(title, popUpType, questID, questLogIndex)
			nextLine = nextLine + 1;
		end
	end

	local numLines = #self.Rows;
	for x = nextLine, numLines do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Button:SetID(0);
			row.Button.PopUpType = nil;
			row.Badge.Icon:SetTexture(0,0,0,0)
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end

	local newHeight = (nextLine * (LARGE_ROW_HEIGHT + 2)) + (ROW_HEIGHT + (nextLine * 2));
	self:SetHeight(newHeight);
end

local _hook_AutoPopUpQuests = function(...)
	self.Active:Refresh('AUTO_QUEST_ADD', ...)
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local UpdateScrollFrame = function(self)
	local h1 = MOD.Popup:GetHeight()
	local h2 = MOD.Active:GetHeight()
	local h3 = MOD.Scenario:GetHeight()
	local h4 = MOD.Quests:GetHeight()
	local h5 = MOD.Bonus:GetHeight()
	local h6 = MOD.Achievements:GetHeight()
	local NEWHEIGHT = h1 + h2 + h3 + h4 + h5 + h6 + 6;
	local scrollHeight = self.ScrollFrame:GetHeight();
	local scrollWidth = self.ScrollFrame:GetWidth();

	self.ScrollFrame.MaxVal = NEWHEIGHT;
	self.ScrollFrame.ScrollBar:SetMinMaxValues(1, NEWHEIGHT);
	self.ScrollFrame.ScrollBar:SetHeight(scrollHeight);
	self.ScrollFrame.ScrollChild:SetWidth(scrollWidth);
	self.ScrollFrame.ScrollChild:SetHeight(NEWHEIGHT);

	MOD.Popup:SetWidth(scrollWidth);
	MOD.Active:SetWidth(scrollWidth);
	MOD.Scenario:SetWidth(scrollWidth);
	MOD.Quests:SetWidth(scrollWidth);
	MOD.Bonus:SetWidth(scrollWidth);
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
	SV.Events:Trigger("QUEST_UPVALUES_UPDATED", ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT);
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
	--scrollChild:SetStylePanel("Default");

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

	self.Tracker.Refresh = UpdateScrollFrame;

	self:UpdateLocals();

	local popups = CreateFrame("Frame", nil, scrollChild)
	popups:SetWidth(ROW_WIDTH);
	popups:SetHeight(1);
	popups:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);
	--popups:SetStylePanel("Default");

	popups.Rows = {};
	popups.Refresh = RefreshPopupObjective;
	popups.Add = AddPopupRow;

	local active = CreateFrame("Frame", nil, scrollChild)
    active:SetWidth(ROW_WIDTH);
	active:SetHeight(1);
	active:SetPoint("TOPLEFT", popups, "BOTTOMLEFT", 0, 0);
	--active:SetStylePanel("Default");

	active.Set = SetActiveData;
	active.Refresh = RefreshActiveObjective;
	active.RefreshHeight = RefreshActiveHeight;

	local block = CreateFrame("Frame", nil, active)
	block:SetPointToScale("TOPLEFT", active, "TOPLEFT", 2, -4);
	block:SetPointToScale("TOPRIGHT", active, "TOPRIGHT", -2, -4);
	block:SetHeightToScale(LARGE_ROW_HEIGHT);

	block.Button = CreateFrame("Button", nil, block)
	block.Button:SetPointToScale("TOPLEFT", block, "TOPLEFT", 0, 0);
	block.Button:SetPointToScale("BOTTOMRIGHT", block, "BOTTOMRIGHT", 0, 8);
	block.Button:SetStylePanel("Framed", "Headline")
	block.Button:SetID(0)
	block.Button.Parent = active;
	block.Button:SetScript("OnClick", ViewButton_OnClick)
	block.Button.CloseMe = ActiveButton_OnClick

	block.Badge = CreateFrame("Frame", nil, block.Button)
	block.Badge:SetPointToScale("TOPLEFT", block.Button, "TOPLEFT", 4, -4);
	block.Badge:SetSizeToScale((LARGE_INNER_HEIGHT - 4), (LARGE_INNER_HEIGHT - 4));
	block.Badge:SetStylePanel("Fixed", "Inset")

	block.Badge.Icon = block.Badge:CreateTexture(nil,"OVERLAY")
	block.Badge.Icon:SetAllPointsIn(block.Badge);
	block.Badge.Icon:SetTexture(LINE_QUEST_ICON)
	block.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	block.Header = CreateFrame("Frame", nil, block.Button)
	block.Header:SetPointToScale("TOPLEFT", block.Badge, "TOPRIGHT", 4, -1);
	block.Header:SetPointToScale("TOPRIGHT", block.Button, "TOPRIGHT", -(ROW_HEIGHT + 4), 0);
	block.Header:SetHeightToScale(INNER_HEIGHT);
	block.Header:SetStylePanel("Default")

	block.Header.Level = block.Header:CreateFontString(nil,"OVERLAY")
	block.Header.Level:SetFont(SV.Media.font.roboto, 10, "NONE")
	block.Header.Level:SetShadowOffset(-1,-1)
	block.Header.Level:SetShadowColor(0,0,0,0.5)
	block.Header.Level:SetJustifyH('LEFT')
	block.Header.Level:SetJustifyV('MIDDLE')
	block.Header.Level:SetText('')
	block.Header.Level:SetPointToScale("TOPLEFT", block.Header, "TOPLEFT", 4, 0);
	block.Header.Level:SetPointToScale("BOTTOMLEFT", block.Header, "BOTTOMLEFT", 4, 0);

	block.Header.Text = block.Header:CreateFontString(nil,"OVERLAY")
	block.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
	block.Header.Text:SetTextColor(1,1,0)
	block.Header.Text:SetShadowOffset(-1,-1)
	block.Header.Text:SetShadowColor(0,0,0,0.5)
	block.Header.Text:SetJustifyH('LEFT')
	block.Header.Text:SetJustifyV('MIDDLE')
	block.Header.Text:SetText('')
	block.Header.Text:SetPointToScale("TOPLEFT", block.Header.Level, "TOPRIGHT", 4, 0);
	block.Header.Text:SetPointToScale("BOTTOMRIGHT", block.Header, "BOTTOMRIGHT", 0, 0);

	block.CloseButton = CreateFrame("Button", nil, block.Header, "UIPanelCloseButton")
	--block.CloseButton:SetSizeToScale(INNER_HEIGHT, INNER_HEIGHT);
	block.CloseButton:RemoveTextures()
	block.CloseButton:SetStylePanel("Button", nil, 1, -7, -7, nil, "red")
	block.CloseButton:SetFrameLevel(block.CloseButton:GetFrameLevel() + 4)
	block.CloseButton:SetNormalTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\CLOSE-BUTTON]])
    block.CloseButton:HookScript("OnEnter", CloseButton_OnEnter)
    block.CloseButton:HookScript("OnLeave", CloseButton_OnLeave)
	block.CloseButton:SetPointToScale("RIGHT", block.Header, "RIGHT", (ROW_HEIGHT + 8), 0);
	block.CloseButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	block.CloseButton.Parent = parent;
	block.CloseButton:SetScript("OnClick", ActiveButton_OnClick)

	block.Objectives = CreateFrame("Frame", nil, block)
	block.Objectives:SetPointToScale("TOPLEFT", block.Header, "BOTTOMLEFT", 0, -2);
	block.Objectives:SetPointToScale("TOPRIGHT", block.Header, "BOTTOMRIGHT", 0, -2);
	block.Objectives:SetHeightToScale(1);
	--block.Objectives:SetStylePanel("Default", "Inset");

	block.Objectives.Rows = {}
	block.Objectives.Add = MOD.AddObjectiveRow;

	block.RowID = 0;

	active.Block = block;

	self.Popup = popups;
	self.Active = active;

	self.Active:RefreshHeight()

	hooksecurefunc("AddAutoQuestPopUp", _hook_AutoPopUpQuests)
	hooksecurefunc("RemoveAutoQuestPopUp", _hook_AutoPopUpQuests)

	self:InitializeScenarios()
	self:InitializeQuestItem()
	self:InitializeQuests()
	self:InitializeBonuses()
	self:InitializeAchievements()

	self.Tracker:Refresh();
	self.Tracker.DockButton:MakeDefault();
	self.Tracker:Show();

	ObjectiveTrackerFrame:UnregisterAllEvents();
	ObjectiveTrackerFrame:SetParent(SV.Hidden);
end