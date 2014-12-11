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
local ROW_HEIGHT = 20;
local INNER_HEIGHT = ROW_HEIGHT - 4;
local LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
local LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;

local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];
local LINE_QUEST_ICON = [[Interface\LFGFRAME\LFGICON-QUEST]]

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

local function GetTimerTextColor(duration, elapsed)
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

local function CheckAndHideHeader(moduleHeader)
	if(moduleHeader and not moduleHeader.added and moduleHeader:IsShown()) then
		moduleHeader:Hide();
		if(moduleHeader.animating) then
			moduleHeader.animating = nil;
			moduleHeader.HeaderOpenAnim:Stop();
		end
	end
end
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local ActiveButton_OnClick = function(self, button)
	local rowIndex = self:GetID();
	if(rowIndex and (rowIndex ~= 0)) then
		local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(rowIndex);
		local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
		local icon = self.Icon:GetTexture()
		MOD.Active:Refresh('ACTIVE_QUEST_LOADED', title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed)
	end
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
	local yOffset = (lineNumber * (ROW_HEIGHT)) - ROW_HEIGHT;

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
	objective.Text:SetFont(SV.Media.font.roboto, 11, "NONE")
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

local function NewQuestRow(parent, lineNumber)
	local lastRowNumber = lineNumber - 1;
	local previousFrame = parent.Rows[lastRowNumber]
	local anchorFrame;
	if(previousFrame and previousFrame.Objectives) then
		anchorFrame = previousFrame.Objectives;
	else
		anchorFrame = parent.Header;
	end

	local row = CreateFrame("Frame", nil, parent)
	row:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -2);
	row:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -2);
	row:SetHeight(ROW_HEIGHT);

	row.Badge = CreateFrame("Frame", nil, row)
	row.Badge:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -2);
	row.Badge:SetSize(INNER_HEIGHT, INNER_HEIGHT);
	row.Badge:SetPanelTemplate("Headline")

	row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
	row.Badge.Icon:SetAllPoints(row.Badge);
	row.Badge.Icon:SetTexture(LINE_QUEST_ICON)
	row.Badge.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	row.Badge.Button = CreateFrame("Button", nil, row.Badge)
	row.Badge.Button:SetAllPoints(row.Badge);
	row.Badge.Button:SetButtonTemplate(true, 1, 1, 1)
	row.Badge.Button:SetID(0)
	row.Badge.Button.Icon = row.Badge.Icon;
	row.Badge.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row.Badge.Button:SetScript("OnClick", ActiveButton_OnClick)

	row.Header = CreateFrame("Frame", nil, row)
	row.Header:SetPoint("TOPLEFT", row.Badge, "TOPRIGHT", 2, 0);
	row.Header:SetPoint("TOPRIGHT", row, "TOPRIGHT", -2, 0);
	row.Header:SetHeight(INNER_HEIGHT);
	--row.Header:SetPanelTemplate("Headline")

	row.Header.Level = row.Header:CreateFontString(nil,"OVERLAY")
	row.Header.Level:SetFont(SV.Media.font.numbers, 11, "NONE")
	row.Header.Level:SetShadowOffset(-1,-1)
	row.Header.Level:SetShadowColor(0,0,0,0.5)
	row.Header.Level:SetJustifyH('RIGHT')
	row.Header.Level:SetJustifyV('MIDDLE')
	row.Header.Level:SetText('')
	row.Header.Level:SetPoint("TOPRIGHT", row.Header, "TOPRIGHT", -4, 0);
	row.Header.Level:SetPoint("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", -4, 0);

	row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
	row.Header.Text:SetFont(SV.Media.font.roboto, 14, "NONE")
	row.Header.Text:SetTextColor(1,1,0)
	row.Header.Text:SetShadowOffset(-1,-1)
	row.Header.Text:SetShadowColor(0,0,0,0.5)
	row.Header.Text:SetJustifyH('LEFT')
	row.Header.Text:SetJustifyV('MIDDLE')
	row.Header.Text:SetText('')
	row.Header.Text:SetPoint("TOPLEFT", row.Header, "TOPLEFT", 4, 0);
	row.Header.Text:SetPoint("BOTTOMRIGHT", row.Header.Level, "BOTTOMLEFT", 0, 0);

	row.Button = CreateFrame("Button", nil, row.Header)
	row.Button:SetAllPoints(row.Header);
	row.Button:SetButtonTemplate("Headline", 1, 1, 1)
	row.Button:SetID(0)
	row.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row.Button:SetScript("OnClick", ViewButton_OnClick)

	row.Objectives = CreateFrame("Frame", nil, row)
	row.Objectives:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 0, 0);
	row.Objectives:SetPoint("TOPRIGHT", row, "BOTTOMRIGHT", 0, 0);
	row.Objectives:SetHeight(1);

	--row.Objectives.TestID = "Objectives On Row: " .. lineNumber

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
local AddQuestRow = function(self, index, title, level, details, icon, questID, questLogIndex, totalObjectives, duration, elapsed)
	local objectivesShown = 0;
	local nextObjective = 1;

	local row = self.Rows[index];

	if(not row) then
		self.Rows[index] = NewQuestRow(self, index)
		row = self.Rows[index]
		row.RowID = questID
	end

	icon = icon or LINE_QUEST_ICON;

	local color = GetQuestDifficultyColor(level)
	
	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)
	row.Header.Text:SetTextColor(color.r, color.g, color.b)
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Badge.Button:SetID(index)
	row.Button:SetID(questLogIndex)
	row:Show()

	local objectives = row.Objectives;

	for i = 1, totalObjectives do
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

	local objectiveHeight = (INNER_HEIGHT + 2) * totalObjectives;
	objectives:SetHeight(objectiveHeight + 1);

	return totalObjectives;
end

local RefreshQuests = function(self, event, ...)
	local shortestDistance = 62500;
	local liveLines = GetNumQuestWatches();
	local totalObjectives = 0;
	local nextLine = 1;
	local closestQuest, closestLink, closestTexture, closestLevel, closestCount, closestIndex, closestDuration, closestExpiration, closestID;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
			if(questID) then
				nextLine = nextLine + 1;
				local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
				local icon = LINE_QUEST_ICON;
				if(QuestHasPOIInfo(questID)) then
					local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
					local areaID = QuestInZone[questID]
					if(areaID and areaID == GetCurrentMapAreaID()) then
						closestQuest = title
						closestID = questID
						closestLink = link
						closestTexture = texture
						closestLevel = level
						closestCount = numObjectives
						closestIndex = questLogIndex
						closestDuration = failureTime
						closestExpiration = timeElapsed

						icon = texture
					elseif(not completed or (completed and showCompleted)) then
						local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq < shortestDistance) then
							shortestDistance = distanceSq
							closestQuest = title
							closestID = questID
							closestLink = link
							closestTexture = texture
							closestLevel = level
							closestCount = numObjectives
							closestIndex = questLogIndex
							closestDuration = failureTime
							closestExpiration = timeElapsed

							icon = texture
						end
					end
				end
				local newCount = self:Add(i, title, level, details, icon, questID, questLogIndex, numObjectives, duration, elapsed)
				totalObjectives = totalObjectives + newCount;
			end
		end
	end

	local numLines = #self.Rows;
	for x = nextLine, numLines do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Button:SetID(0);
			row.Badge.Button:SetID(0);
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end

	local newHeight = (nextLine * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (ROW_HEIGHT + (nextLine * 2));
	self:SetHeight(newHeight);

	if(closestQuest) then
		MOD.Active:Refresh('ACTIVE_QUEST_LOADED', closestQuest, closestLevel, closestTexture, closestID, closestIndex, closestCount, closestDuration, closestExpiration)
	end

	if(closestLink) then
		MOD.QuestItem:SetItem(closestLink, closestTexture)
	elseif(MOD.QuestItem:IsShown()) then
		MOD.QuestItem:RemoveItem()
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateObjectives(event, ...)
	self.Quests:Refresh(event, ...)
	self.Tracker:Refresh()
end

function MOD:UpdateProximity(event, ...)
	local shortestDistance = 62500;
	local liveLines = GetNumQuestWatches();
	local closestQuest, closestLink, closestTexture, closestLevel, closestCount, closestIndex, closestDuration, closestExpiration, closestID;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local questID, _, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
			if(questID) then
				local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
				if(QuestHasPOIInfo(questID)) then
					local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
					local areaID = QuestInZone[questID]
					if(areaID and areaID == GetCurrentMapAreaID()) then
						closestQuest = title
						closestID = questID
						closestLink = link
						closestTexture = texture
						closestLevel = level
						closestCount = numObjectives
						closestIndex = questLogIndex
						closestDuration = failureTime
						closestExpiration = timeElapsed
					elseif(not completed or (completed and showCompleted)) then
						local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
						if(onContinent and distanceSq < shortestDistance) then
							shortestDistance = distanceSq
							closestQuest = title
							closestID = questID
							closestLink = link
							closestTexture = texture
							closestLevel = level
							closestCount = numObjectives
							closestIndex = questLogIndex
							closestDuration = failureTime
							closestExpiration = timeElapsed
						end
					end
				end
			end
		end
	end

	if(closestQuest) then
		self.Active:Refresh('ACTIVE_QUEST_LOADED', closestQuest, closestLevel, closestTexture, closestID, closestIndex, closestCount, closestDuration, closestExpiration)
	end

	if(closestLink) then
		self.QuestItem:SetItem(closestLink, closestTexture)
	elseif(self.QuestItem:IsShown()) then
		self.QuestItem:RemoveItem()
	end
end

local function UpdateQuestLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

LibSuperVillain("Registry"):NewCallback("QUEST_UPVALUES_UPDATED", "UpdateQuestLocals", UpdateQuestLocals);

function MOD:InitializeQuests()
	local scrollChild = self.Tracker.ScrollFrame.ScrollChild;

	local quests = CreateFrame("Frame", nil, scrollChild)
	quests:SetWidth(ROW_WIDTH);
	quests:SetHeight(ROW_HEIGHT);
	quests:SetPoint("TOPLEFT", self.Active, "BOTTOMLEFT", 0, 0);

	quests.Header = CreateFrame("Frame", nil, quests)
	quests.Header:SetPoint("TOPLEFT", quests, "TOPLEFT", 2, -2);
	quests.Header:SetPoint("TOPRIGHT", quests, "TOPRIGHT", -2, -2);
	quests.Header:SetHeight(INNER_HEIGHT);

	quests.Header.Text = quests.Header:CreateFontString(nil,"OVERLAY")
	quests.Header.Text:SetPoint("TOPLEFT", quests.Header, "TOPLEFT", 2, 0);
	quests.Header.Text:SetPoint("BOTTOMLEFT", quests.Header, "BOTTOMLEFT", 2, 0);
	quests.Header.Text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
	quests.Header.Text:SetJustifyH('LEFT')
	quests.Header.Text:SetJustifyV('MIDDLE')
	quests.Header.Text:SetTextColor(1,0.6,0.1)
	quests.Header.Text:SetShadowOffset(-1,-1)
	quests.Header.Text:SetShadowColor(0,0,0,0.5)
	quests.Header.Text:SetText(TRACKER_HEADER_QUESTS)

	quests.Header.Divider = quests.Header:CreateTexture(nil, 'BACKGROUND');
	quests.Header.Divider:SetPoint("TOPLEFT", quests.Header.Text, "TOPRIGHT", -10, 0);
	quests.Header.Divider:SetPoint("BOTTOMRIGHT", quests.Header, "BOTTOMRIGHT", 0, 0);
	quests.Header.Divider:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DROPDOWN-DIVIDER]]);

	quests.Rows = {};
	quests.Refresh = RefreshQuests;
	quests.Add = AddQuestRow;

	self.Quests = quests;

	self:RegisterEvent("QUEST_LOG_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", self.UpdateObjectives);
	self:RegisterEvent("QUEST_ACCEPTED", self.UpdateObjectives);	
	self:RegisterEvent("QUEST_POI_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_TURNED_IN", self.UpdateObjectives);

	--self:RegisterEvent("PLAYER_MONEY", self.UpdateObjectives);
	--self:RegisterEvent("QUEST_AUTOCOMPLETE", self.UpdateObjectives);
	--self:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED", self.UpdateObjectives);

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.UpdateProximity);
	self:RegisterEvent("ZONE_CHANGED", self.UpdateProximity);

	self.Quests:Refresh()
end