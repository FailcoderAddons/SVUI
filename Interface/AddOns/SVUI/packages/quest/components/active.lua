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
local MOD = SV.SVQuest;
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
local ActiveButton_OnClick = function(self, button)
	MOD.Headers["Active"]:Unset();
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

local CloseButton_OnEnter = function(self)
    self:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local CloseButton_OnLeave = function(self)
    self:SetBackdropBorderColor(0,0,0,1)
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local GetObjectiveRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local yOffset = (index * (ROW_HEIGHT)) - ROW_HEIGHT

		local objective = CreateFrame("Frame", nil, self)
		objective:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -yOffset);
		objective:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -yOffset);
		objective:SetHeight(INNER_HEIGHT);

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

		self.Rows[index] = objective;
	end

	return self.Rows[index];
end

local SetObjectiveRow = function(self, index, description, completed, duration, elapsed)
	local objective = self:Get(index);
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

local UnsetActiveData = function(self)
	local block = self.Block;
	block:SetHeight(1);
	block.Header.Text:SetText('');
	block.Header.Level:SetText('');
	block.Badge.Icon:SetTexture(0,0,0,0);
	block.Button:SetID(0);
	MOD.CurrentQuest = 0;
	block:Hide();
	self:SetHeight(1);
end

local SetActiveData = function(self, title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed, bypass)
	local nextObjective = 0;

	local block = self.Block;
	if((not bypass) and block.RowID == questID) then
		return
	end

	icon = icon or LINE_QUEST_ICON;
	block.RowID = questID

	level = level or 100
	local color = GetQuestDifficultyColor(level)
	block.Header.Level:SetTextColor(color.r, color.g, color.b)
	block.Header.Level:SetText(level)
	block.Header.Text:SetText(title)
	block.Badge.Icon:SetTexture(icon)
	block.Button:SetID(questLogIndex)
	block:Show()
	MOD.CurrentQuest = questLogIndex;

	local objectives = block.Objectives;

	for i = 1, numObjectives do
		local description, category, completed = GetQuestObjectiveInfo(questID, i);
		if(description) then
			nextObjective = nextObjective + 1;
			objectives:Set(i, description, completed, duration, elapsed)
		end
	end

	local objectiveHeight = (INNER_HEIGHT + 2) * nextObjective;
	local newHeight = (LARGE_ROW_HEIGHT + 2) + (nextObjective * (INNER_HEIGHT + 2)) + 2;
	nextObjective = nextObjective + 1;

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

	objectives:SetHeight(objectiveHeight + 1);
	block:SetHeight(newHeight);

	MOD.Docklet.ScrollFrame.ScrollBar:SetValue(0)

	-- local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
	-- if(link and (questLogIndex ~= MOD.CurrentQuest)) then
	-- 	MOD.QuestItem:SetItem(link, texture, questLogIndex)
	-- end

	self:RefreshHeight()
end

local RefreshActiveHeight = function(self)
	if(self.Block.RowID == 0) then
		self:Unset()
	else
		self:SetHeight(self.Block:GetHeight())
	end
end

local RefreshActiveObjective = function(self, event, ...)
	if(event) then 
		if(event == 'ACTIVE_QUEST_LOADED') then
			self.Block.RowID = 0
			self:Set(...)
		elseif(event == 'SUPER_TRACKED_QUEST_CHANGED') then
			local questID = ...;
			local questLogIndex = GetQuestLogIndexByID(questID)
			local questWatchIndex = GetQuestWatchIndex(questLogIndex)
			local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(questWatchIndex);
			self:Set(title, level, nil, questID, questLogIndex, numObjectives, duration, elapsed)
		end
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateActiveObjective(event, ...)
	self.Headers["Active"]:Refresh(event, ...)
	self:UpdateDimensions();
end

local function UpdateActiveLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateActiveLocals", UpdateActiveLocals);

function MOD:InitializeActive()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

	local active = CreateFrame("Frame", nil, scrollChild)
    active:SetWidth(ROW_WIDTH);
	active:SetHeight(1);
	active:SetPoint("TOPLEFT", self.Headers["Popups"], "BOTTOMLEFT", 0, 0);

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
	block.CloseButton:RemoveTextures()
	block.CloseButton:SetStylePanel("Button", nil, 1, -7, -7, nil, "red")
	block.CloseButton:SetFrameLevel(block.CloseButton:GetFrameLevel() + 4)
	block.CloseButton:SetNormalTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\CLOSE-BUTTON]])
    block.CloseButton:HookScript("OnEnter", CloseButton_OnEnter)
    block.CloseButton:HookScript("OnLeave", CloseButton_OnLeave)
	block.CloseButton:SetPointToScale("RIGHT", block.Header, "RIGHT", (ROW_HEIGHT + 8), 0);
	block.CloseButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	block.CloseButton.Parent = active;
	block.CloseButton:SetScript("OnClick", ActiveButton_OnClick)

	block.Objectives = CreateFrame("Frame", nil, block)
	block.Objectives:SetPointToScale("TOPLEFT", block.Header, "BOTTOMLEFT", 0, -2);
	block.Objectives:SetPointToScale("TOPRIGHT", block.Header, "BOTTOMRIGHT", 0, -2);
	block.Objectives:SetHeightToScale(1);

	block.Objectives.Rows = {}
	block.Objectives.Get = GetObjectiveRow;
	block.Objectives.Set = SetObjectiveRow;
	block.RowID = 0;

	active.Block = block;

	active.Set = SetActiveData;
	active.Unset = UnsetActiveData;
	active.Refresh = RefreshActiveObjective;
	active.RefreshHeight = RefreshActiveHeight;

	self.Headers["Active"] = active;

	self.Headers["Active"]:RefreshHeight()

	self:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED", self.UpdateActiveObjective);
end