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
local tremove, wipe, tsort = table.remove, table.wipe, table.sort;
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
local LINE_QUEST_ICON = [[Interface\LFGFRAME\LFGICON-QUEST]];

local LINE_QUEST_COMPLETE = [[Interface\AddOns\SVUI\assets\artwork\Quest\QUEST-COMPLETE]];
local LINE_QUEST_INCOMPLETE = [[Interface\LFGFRAME\LFGICON-QUEST]];
local QUEST_NEAR_TEXT = TRACKER_HEADER_QUESTS .. " Near By";
local QUEST_FAR_TEXT = TRACKER_HEADER_QUESTS .. " Elsewhere";

local QUESTS_ON_MAP = {};
local QUEST_DISTANCES = {};

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
local ActiveButton_OnClick = function(self, button)
	local rowIndex = self:GetID();
	if(rowIndex and (rowIndex ~= 0)) then
		local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(rowIndex);
		local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
		local icon = self.Icon:GetTexture()
		SetSuperTrackedQuestID(questID);
		local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
		MOD.QuestItem:SetItem(link, texture, 'ACTIVE_QUEST_LOADED', title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed)
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
	row.Badge:SetStylePanel("Default", "Headline")

	row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
	row.Badge.Icon:SetAllPoints(row.Badge);
	row.Badge.Icon:SetTexture(LINE_QUEST_INCOMPLETE)
	--row.Badge.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	row.Badge.Button = CreateFrame("Button", nil, row.Badge)
	row.Badge.Button:SetAllPoints(row.Badge);
	row.Badge.Button:SetStylePanel("Button", true, 1, 1, 1)
	row.Badge.Button:SetID(0)
	row.Badge.Button.Icon = row.Badge.Icon;
	row.Badge.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row.Badge.Button:SetScript("OnClick", ActiveButton_OnClick)

	row.Header = CreateFrame("Frame", nil, row)
	row.Header:SetPoint("TOPLEFT", row.Badge, "TOPRIGHT", 2, 0);
	row.Header:SetPoint("TOPRIGHT", row, "TOPRIGHT", -2, 0);
	row.Header:SetHeight(INNER_HEIGHT);
	--row.Header:SetStylePanel("Default", "Headline")

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
	row.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
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
	row.Button:SetStylePanel("Button", "Headline", 1, 1, 1)
	row.Button:SetID(0)
	row.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	row.Button:SetScript("OnClick", ViewButton_OnClick)

	row.Objectives = CreateFrame("Frame", nil, row)
	row.Objectives:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 0, 0);
	row.Objectives:SetPoint("TOPRIGHT", row, "BOTTOMRIGHT", 0, 0);
	row.Objectives:SetHeight(1);

	--row.Objectives.TestID = "Objectives On Row: " .. lineNumber

	row.Objectives.Rows = {}
	row.Objectives.Add = MOD.AddObjectiveRow;

	row.RowID = 0;

	return row;
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local AddQuestRow = function(self, index, title, level, watchIndex, questID, questLogIndex, totalObjectives, duration, elapsed, completed)
	local objectivesShown = 0;
	local nextObjective = 1;

	local row = self.Rows[index];

	if(not row) then
		self.Rows[index] = NewQuestRow(self, index)
		row = self.Rows[index]
		row.RowID = questID
	end

	local icon = completed and LINE_QUEST_COMPLETE or LINE_QUEST_INCOMPLETE

	level = level or 100
	local color = GetQuestDifficultyColor(level)
	
	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)
	row.Header.Text:SetTextColor(color.r, color.g, color.b)
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Badge.Button:SetID(watchIndex)
	row.Button:SetID(questLogIndex)
	row:Show()

	local objectives = row.Objectives;

	local iscomplete = true;
	for i = 1, totalObjectives do
		local description, category, completed = GetQuestObjectiveInfo(questID, i);
		if not completed then iscomplete = false end
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

	local objectiveHeight = (ROW_HEIGHT + 2) * totalObjectives;
	objectives:SetHeight(objectiveHeight + 1);

	return totalObjectives, iscomplete;
end

local RefreshQuests = function(self, event, ...)
	local shortestDistance = 62500;
	local liveLines = GetNumQuestWatches();
	local initObjectives = 0;
	local nearQuests, farQuests = 0, 0;
	local closestQuest, closestLink, closestTexture, closestLevel, closestCount, closestIndex, closestDuration, closestExpiration, closestID;
	local activeQuestIndex = MOD.Active.CurrentQuest;

	if(liveLines > 0) then
		wipe(QUESTS_ON_MAP);

		local closestWatchIndex;

		for i = 1, liveLines do
			local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
			if(questID) then
				local onMap = false;
				local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
				local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
				if(QuestHasPOIInfo(questID)) then
					local areaID = QuestInZone[questID]
					if(areaID and areaID == GetCurrentMapAreaID()) then
						closestWatchIndex = i
						tinsert(QUESTS_ON_MAP, i)
						onMap = true
					else
						if(onContinent) then
							if(distanceSq < shortestDistance) then
								shortestDistance = distanceSq
								closestWatchIndex = i
							end
							tinsert(QUESTS_ON_MAP, {watchIndex = i, distance = distanceSq});
							onMap = true
						end
					end
				elseif(hasLocalPOI) then
					tinsert(QUESTS_ON_MAP, {watchIndex = i, distance = distanceSq});
					onMap = true
				end
				if(not onMap) then
					farQuests = farQuests + 1;
					local newCount, completedQuest = self.Far:Add(farQuests, title, level, i, questID, questLogIndex, numObjectives, duration, elapsed, completed)
					if(completedQuest and (questLogIndex == MOD.QuestItem.CurrentQuest)) then
						MOD.QuestItem:RemoveItem()
					end
					initObjectives = initObjectives + newCount;
				end
				if(questLogIndex == activeQuestIndex) then
					local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
					MOD.Active:Set(title, level, texture, questID, questLogIndex, numObjectives, duration, elapsed, true)
				end
			end
		end
	end

	local farLines = #self.Far.Rows;
	for x = (farQuests + 1), farLines do
		local row = self.Far.Rows[x]
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

	if(farQuests == 0) then
		self.Far.Header.Text:SetText('');
		self.Far:SetHeight(1);
	else
		self.Far.Header.Text:SetText(QUEST_FAR_TEXT);
		local farHeight = ((farQuests + 1) * (ROW_HEIGHT + 2)) + (initObjectives * (INNER_HEIGHT + 2)) + (INNER_HEIGHT * 2);
		self.Far:SetHeight(farHeight);
	end

	local totalObjectives = 0;
	if(closestWatchIndex) then
		local questID, _, questLogIndex, numObjectives, _, completed, _, _, duration, elapsed = GetQuestWatchInfo(closestWatchIndex);
		if(questID) then
			local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
			closestQuest = title
			closestID = questID
			closestLink = link
			closestTexture = texture
			closestLevel = level
			closestCount = numObjectives
			closestIndex = questLogIndex
			closestDuration = failureTime
			closestExpiration = timeElapsed
			nearQuests = nearQuests + 1;
			local newCount, completedQuest = self.Near:Add(nearQuests, title, level, closestWatchIndex, questID, questLogIndex, numObjectives, duration, elapsed, completed)
			if(completedQuest and (questLogIndex == MOD.QuestItem.CurrentQuest)) then
				MOD.QuestItem:RemoveItem()
			end
			totalObjectives = totalObjectives + newCount;
		end
	end

	if(#QUESTS_ON_MAP > 0) then
		tsort(QUESTS_ON_MAP, function(a,b) return a.distance < b.distance end)
		for i = 1, #QUESTS_ON_MAP do
			local watchIndex = QUESTS_ON_MAP[i].watchIndex;
			if(watchIndex ~= closestWatchIndex) then
				local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(watchIndex);
				if(questID) then
					nearQuests = nearQuests + 1;
					local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
					local newCount, completedQuest = self.Near:Add(nearQuests, title, level, watchIndex, questID, questLogIndex, numObjectives, duration, elapsed, completed)
					if(completedQuest and (questLogIndex == MOD.QuestItem.CurrentQuest)) then
						MOD.QuestItem:RemoveItem()
					end
					totalObjectives = totalObjectives + newCount;
				end
			end
		end
	end

	local numLines = #self.Near.Rows;
	for x = (nearQuests + 1), numLines do
		local row = self.Near.Rows[x]
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

	if(nearQuests == 0) then
		self.Near.Header.Text:SetText('');
		self.Near:SetHeight(1);
	else
		self.Near.Header.Text:SetText(QUEST_NEAR_TEXT);
		local nearHeight = ((nearQuests + 1) * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (INNER_HEIGHT * 2);
		self.Near:SetHeight(nearHeight);
	end

	-- if(not activeInProgress) then
	-- 	MOD.Active.Block.Button:CloseMe()
	-- end

	local newHeight = self.Far:GetHeight() + self.Near:GetHeight() + (ROW_HEIGHT + 2);
	self:SetHeight(newHeight);

	if(closestLink) then
		MOD.QuestItem:SetItem(closestLink, closestTexture, 'ACTIVE_QUEST_LOADED', closestQuest, closestLevel, closestTexture, closestID, closestIndex, closestCount, closestDuration, closestExpiration)
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
	if(event == "QUEST_TURNED_IN") then
		local questID, xp, money = ...;
		local button = self.Active.Block.Button;
		local questIndex = button:GetID();
		if(questIndex and (questIndex ~= 0)) then
			local ActiveQuestID = select(8, GetQuestLogTitle(questIndex));
			if(ActiveQuestID == questID) then
				button:CloseMe()
			end
		end
	end
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
					end
				end
			end
		end
	end

	if(closestLink) then
		self.QuestItem:SetItem(closestLink, closestTexture, 'ACTIVE_QUEST_LOADED', closestQuest, closestLevel, closestTexture, closestID, closestIndex, closestCount, closestDuration, closestExpiration)
	elseif(self.QuestItem:IsShown()) then
		self.QuestItem:RemoveItem()
	end
end

local function UpdateQuestLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateQuestLocals", UpdateQuestLocals);

function MOD:InitializeQuests()
	local scrollChild = self.Tracker.ScrollFrame.ScrollChild;

	local quests = CreateFrame("Frame", nil, scrollChild)
	quests:SetWidth(ROW_WIDTH);
	quests:SetHeight(ROW_HEIGHT);
	quests:SetPoint("TOPLEFT", self.Scenario, "BOTTOMLEFT", 0, -4);

	local near = CreateFrame("Frame", nil, quests)
	near:SetPoint("TOPLEFT", quests, "TOPLEFT", 2, -2);
	near:SetPoint("TOPRIGHT", quests, "TOPRIGHT", -2, -2);
	near:SetHeight(ROW_HEIGHT);

	near.Header = CreateFrame("Frame", nil, near)
	near.Header:SetPoint("TOPLEFT", near, "TOPLEFT", 2, -2);
	near.Header:SetPoint("TOPRIGHT", near, "TOPRIGHT", -2, -2);
	near.Header:SetHeight(INNER_HEIGHT);

	near.Header.Text = near.Header:CreateFontString(nil,"OVERLAY")
	near.Header.Text:SetPoint("TOPLEFT", near.Header, "TOPLEFT", 2, 0);
	near.Header.Text:SetPoint("BOTTOMLEFT", near.Header, "BOTTOMLEFT", 2, 0);
	near.Header.Text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
	near.Header.Text:SetJustifyH('LEFT')
	near.Header.Text:SetJustifyV('MIDDLE')
	near.Header.Text:SetTextColor(1,0.6,0.1)
	near.Header.Text:SetShadowOffset(-1,-1)
	near.Header.Text:SetShadowColor(0,0,0,0.5)
	near.Header.Text:SetText(QUEST_NEAR_TEXT)

	-- near.Header.Zone = near.Header:CreateFontString(nil,"OVERLAY")
	-- near.Header.Zone:SetPoint("TOPRIGHT", near.Header, "TOPRIGHT", -2, 0);
	-- near.Header.Zone:SetPoint("BOTTOMRIGHT", near.Header, "BOTTOMRIGHT", -2, 0);
	-- near.Header.Zone:SetFont(SV.Media.font.system, 10, "OUTLINE")
	-- near.Header.Zone:SetJustifyH('RIGHT')
	-- near.Header.Zone:SetJustifyV('MIDDLE')
	-- near.Header.Zone:SetTextColor(1,0.4,0.1)
	-- near.Header.Zone:SetShadowOffset(-1,-1)
	-- near.Header.Zone:SetShadowColor(0,0,0,0.5)
	-- near.Header.Zone:SetText("")

	near.Header.Divider = near.Header:CreateTexture(nil, 'BACKGROUND');
	near.Header.Divider:SetPoint("TOPLEFT", near.Header.Text, "TOPRIGHT", -10, 0);
	near.Header.Divider:SetPoint("BOTTOMRIGHT", near.Header, "BOTTOMRIGHT", 0, 0);
	near.Header.Divider:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DROPDOWN-DIVIDER]]);

	near.Rows = {};
	near.Add = AddQuestRow;

	local far = CreateFrame("Frame", nil, quests)
	far:SetPoint("TOPLEFT", near, "BOTTOMLEFT", 0, -2);
	far:SetPoint("TOPRIGHT", near, "BOTTOMRIGHT", 0, -2);
	far:SetHeight(ROW_HEIGHT);

	far.Header = CreateFrame("Frame", nil, far)
	far.Header:SetPoint("TOPLEFT", far, "TOPLEFT", 2, -2);
	far.Header:SetPoint("TOPRIGHT", far, "TOPRIGHT", -2, -2);
	far.Header:SetHeight(INNER_HEIGHT);

	far.Header.Text = far.Header:CreateFontString(nil,"OVERLAY")
	far.Header.Text:SetPoint("TOPLEFT", far.Header, "TOPLEFT", 2, 0);
	far.Header.Text:SetPoint("BOTTOMLEFT", far.Header, "BOTTOMLEFT", 2, 0);
	far.Header.Text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
	far.Header.Text:SetJustifyH('LEFT')
	far.Header.Text:SetJustifyV('MIDDLE')
	far.Header.Text:SetTextColor(1,0.6,0.1)
	far.Header.Text:SetShadowOffset(-1,-1)
	far.Header.Text:SetShadowColor(0,0,0,0.5)
	far.Header.Text:SetText(QUEST_FAR_TEXT)

	far.Header.Divider = far.Header:CreateTexture(nil, 'BACKGROUND');
	far.Header.Divider:SetPoint("TOPLEFT", far.Header.Text, "TOPRIGHT", -10, 0);
	far.Header.Divider:SetPoint("BOTTOMRIGHT", far.Header, "BOTTOMRIGHT", 0, 0);
	far.Header.Divider:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DROPDOWN-DIVIDER]]);

	far.Rows = {};
	far.Add = AddQuestRow;

	quests.Near = near;
	quests.Far = far;
	quests.Refresh = RefreshQuests;

	self.Quests = quests;

	self:RegisterEvent("QUEST_LOG_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", self.UpdateObjectives);
	self:RegisterEvent("QUEST_ACCEPTED", self.UpdateObjectives);	
	self:RegisterEvent("QUEST_POI_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_TURNED_IN", self.UpdateObjectives);

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.UpdateObjectives);
	self:RegisterEvent("ZONE_CHANGED", self.UpdateObjectives);

	self.Quests:Refresh()
end