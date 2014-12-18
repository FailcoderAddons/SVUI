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
local tinsert   = _G.tinsert;
local tremove   = _G.tremove;
local wipe      = _G.wipe;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;
--[[ TABLE METHODS ]]--
local tsort, tcopy = table.sort, table.copy;
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

local QUESTS_BY_DISTANCE = {};
local QUEST_ID_CACHE = {};
local CLOSEST_QUEST = {};
local CURRENT_MAP_ID = 0;

local QuestInZone = {
	[14108] = 541,
	[13998] = 11,
	[25798] = 61,
	[25799] = 61,
	[25112] = 161,
	[25111] = 161,
	[24735] = 201,
};

local function GetCachedQuests()
	local shortestDistance = 62500;
	local validIndex = 1;
	local closest = 0;

	wipe(QUEST_ID_CACHE);

	for i = 1, GetNumQuestWatches() do
		local questID, _, questLogIndex, numObjectives, requiredMoney, completed, startEvent, isAutoComplete, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
		local title, level, suggestedGroup, link, texture, _, showCompleted, distanceSq, onContinent = "",100;
		local mapID,floorNumber = 0,0;
		if(questID and (not QUEST_ID_CACHE[questID])) then
			title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
			distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
			mapID, floorNumber = GetQuestWorldMapAreaID(questID)
			if(QuestHasPOIInfo(questID)) then
				local areaID = QuestInZone[questID]
				if(areaID and (areaID == CURRENT_MAP_ID)) then
					closest = validIndex
				elseif(onContinent and (distanceSq < shortestDistance)) then
					shortestDistance = distanceSq
					closest = validIndex
				end
			end

			if(not QUESTS_BY_DISTANCE[validIndex]) then
				QUESTS_BY_DISTANCE[validIndex] = {watchIndex = i, item = false, range = 0, mapID = 0, floorNumber = 0, values = {"", 100, LINE_QUEST_ICON, 0, 0, 0, 0, 0, false}}
			end

			QUESTS_BY_DISTANCE[validIndex].watchIndex = i;
			QUESTS_BY_DISTANCE[validIndex].item = link;
			QUESTS_BY_DISTANCE[validIndex].mapID = mapID;
			QUESTS_BY_DISTANCE[validIndex].floorNumber = floorNumber;
			QUESTS_BY_DISTANCE[validIndex].range = distanceSq;
			QUESTS_BY_DISTANCE[validIndex].values[1] = title;
			QUESTS_BY_DISTANCE[validIndex].values[2] = level;
			QUESTS_BY_DISTANCE[validIndex].values[3] = texture;
			QUESTS_BY_DISTANCE[validIndex].values[4] = questID;
			QUESTS_BY_DISTANCE[validIndex].values[5] = questLogIndex;
			QUESTS_BY_DISTANCE[validIndex].values[6] = numObjectives;
			QUESTS_BY_DISTANCE[validIndex].values[7] = duration;
			QUESTS_BY_DISTANCE[validIndex].values[8] = elapsed;
			QUESTS_BY_DISTANCE[validIndex].values[9] = completed;

			QUEST_ID_CACHE[questID] = true;
			validIndex = validIndex + 1;
		end
	end

	local foundClosest = false;
	if(closest ~= 0 and QUESTS_BY_DISTANCE[closest]) then
		CLOSEST_QUEST = QUESTS_BY_DISTANCE[closest]
		tremove(QUESTS_BY_DISTANCE, closest);
		foundClosest = true;
	end
	MOD.ClosestQuest = closest;

	tsort(QUESTS_BY_DISTANCE, function(a,b) return a.range < b.range end);

	if(foundClosest) then
		return QUESTS_BY_DISTANCE, CLOSEST_QUEST
	end

	return QUESTS_BY_DISTANCE;
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
		if(questID) then
			local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			local icon = self.Icon:GetTexture()
			SetSuperTrackedQuestID(questID);
			local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
			MOD.QuestItem:SetItem(link, texture, title, level, icon, questID, questLogIndex, numObjectives, duration, elapsed)
		end
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
		elseif(questID and button ~= "RightButton") then
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
		elseif(questID) then
			QuestMapFrame_OpenToQuestDetails(questID);
		end
	end
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local GetObjectiveRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local yOffset = ((index * (ROW_HEIGHT)) - ROW_HEIGHT) + 3

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

local GetQuestRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local index = #self.Rows + 1;

		local anchorFrame;
		if(previousFrame and previousFrame.Objectives) then
			anchorFrame = previousFrame.Objectives;
		else
			anchorFrame = self.Header;
		end

		local row = CreateFrame("Frame", nil, self)
		row:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -2);
		row:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -2);
		row:SetHeightToScale(ROW_HEIGHT);

		row.Badge = CreateFrame("Frame", nil, row)
		row.Badge:SetPoint("TOPLEFT", row, "TOPLEFT", 2, -2);
		row.Badge:SetSize(INNER_HEIGHT, INNER_HEIGHT);
		row.Badge:SetStylePanel("Default", "Headline")

		row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
		row.Badge.Icon:SetAllPoints(row.Badge);
		row.Badge.Icon:SetTexture(LINE_QUEST_INCOMPLETE)

		row.Badge.Button = CreateFrame("Button", nil, row.Badge)
		row.Badge.Button:SetAllPoints(row.Badge);
		row.Badge.Button:SetStylePanel("Button", true, 1, 1, 1)
		row.Badge.Button:SetID(0)
		row.Badge.Button.Icon = row.Badge.Icon;
		row.Badge.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		row.Badge.Button:SetScript("OnClick", ActiveButton_OnClick)

		row.Header = CreateFrame("Frame", nil, row)
		row.Header:SetPoint("TOPLEFT", row, "TOPLEFT", (INNER_HEIGHT + 6), -2);
		row.Header:SetPoint("TOPRIGHT", row, "TOPRIGHT", -2, 0);
		row.Header:SetHeightToScale(INNER_HEIGHT);

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

		row.Header.Zone = row:CreateFontString(nil,"OVERLAY")
		row.Header.Zone:SetAllPoints(row);
		row.Header.Zone:SetFont(SV.Media.font.system, 11, "OUTLINE")
		row.Header.Zone:SetJustifyH('LEFT')
		row.Header.Zone:SetJustifyV('MIDDLE')
		row.Header.Zone:SetTextColor(0.75,0.25,1)
		row.Header.Zone:SetShadowOffset(-1,-1)
		row.Header.Zone:SetShadowColor(0,0,0,0.5)
		row.Header.Zone:SetText("")

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

		row.Objectives.Rows = {}
		row.Objectives.Get = GetObjectiveRow;
		row.Objectives.Set = SetObjectiveRow;

		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetQuestRow = function(self, index, watchIndex, title, level, icon, questID, questLogIndex, totalObjectives, duration, elapsed, completed)
	level = level or 100;
	local objectivesShown = 0;
	local nextObjective = 0;
	local row = self:Get(index);
	if(not icon) then
		icon = completed and LINE_QUEST_COMPLETE or LINE_QUEST_INCOMPLETE
	end
	local color = GetQuestDifficultyColor(level)
	row:Show()
	row.RowID = questID
	row.Button:Show()
	row.Badge:Show()

	row.Header.Zone:SetText('')

	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)

	row.Header.Text:SetTextColor(color.r, color.g, color.b)
	row.Header.Text:SetText(title)

	row.Badge.Icon:SetTexture(icon)
	row.Badge.Button:SetID(watchIndex)
	row.Button:SetID(questLogIndex)

	local objectives = row.Objectives;

	local iscomplete = true;
	for i = 1, totalObjectives do
		local description, category, completed = GetQuestObjectiveInfo(questID, i);
		if not completed then iscomplete = false end
		if(description) then
			nextObjective = nextObjective + 1;
			objectives:Set(i, description, completed, duration, elapsed)
		end
	end

	local objectiveHeight = (INNER_HEIGHT * nextObjective) + 1;
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

	if(iscomplete) then MOD.QuestItem:RemoveItem(questLogIndex) end

	return totalObjectives;
end

local SetZoneHeader = function(self, index, mapID)
	if(not mapID or (mapID and mapID == 0)) then 
		return 0,index
	end
	index = index + 1;
	local row = self:Get(index);
	local zoneName = GetMapNameByID(mapID);
	self.ZoneCount = self.ZoneCount + 1;

	if(self.ZoneCount == 1) then
		row.Header.Zone:SetTextColor(0.15,1,0.08)
	elseif(self.ZoneCount == 2) then
		row.Header.Zone:SetTextColor(0.08,0.5,1)
	else
		row.Header.Zone:SetTextColor(1,0.25,0.08)
	end
	row:Show()
	row.RowID = mapID
	row.Button:Hide()
	row.Badge:Hide()
	row.Header.Level:SetText('')
	row.Header.Text:SetText('')
	row.Header.Zone:SetText(zoneName)
	row.Badge.Button:SetID(0)
	row.Button:SetID(0)

	local objectives = row.Objectives;
	local numLineObjectives = #objectives.Rows;
	for x = 1, numLineObjectives do
		local objective = objectives.Rows[x]
		if(objective) then
			objective.Text:SetText('')
			objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
			if(objective:IsShown()) then
				objective:Hide()
			end
		end
	end

	objectives:SetHeight(1);
	return mapID, index;
end

local ResetQuestBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			if(not row:IsShown()) then
				row:Show()
			end
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Header.Zone:SetText('');
			row.Button:SetID(0);
			row.Badge.Button:SetID(0);
			row.Objectives:SetHeight(1);
		end
	end
end

local RemoveUnusedBlocks = function(self, lastIndex)
	for x = lastIndex, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Header.Zone:SetText('');
			row.Button:SetID(0);
			row.Badge.Button:SetID(0);
			row.Objectives:SetHeight(1);
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end
end

local RefreshQuests = function(self, event, ...)
	local nextLine = 0;
	local totalObjectives = 0;
	local CACHE, CLOSEST = GetCachedQuests()
	local zoneID = 0;
	self.ZoneCount = 0;

	--wipe(QUEST_ID_CACHE);

	if(CLOSEST) then
		local watchIndex = CLOSEST.watchIndex;
		local args = CLOSEST.values;
		local questID = args[4];
		if(questID) then
			zoneID, nextLine = self:SetZone(nextLine, CLOSEST.mapID);

			nextLine = nextLine + 1;
			local newCount = self:Set(nextLine, watchIndex, unpack(args))
			totalObjectives = totalObjectives + newCount;
			if(CLOSEST.item) then
				MOD.QuestItem:SetItem(CLOSEST.item, args[3], unpack(args))
			--elseif(MOD.QuestItem:IsShown()) then
			--	MOD.QuestItem:RemoveItem()
			end
			--QUEST_ID_CACHE[questID] = true;
		end
	end

	for i = 1, #CACHE do
		local questData = CACHE[i];
		local watchIndex = questData.watchIndex;
		local args = questData.values;
		local questID = args[4];
		if(questID) then
			if(watchIndex == MOD.CurrentQuest) then
				MOD.Headers["Active"]:Set(unpack(args));
			else
				if(zoneID ~= questData.mapID) then
					zoneID, nextLine = self:SetZone(nextLine, questData.mapID)
				end
				nextLine = nextLine + 1;
				local newCount = self:Set(nextLine, watchIndex, unpack(args))
				totalObjectives = totalObjectives + newCount;
			end
			--QUEST_ID_CACHE[questID] = true;
		end
	end

	self:RemoveUnused(nextLine + 1)

	if(nextLine == 0) then
		self:SetHeight(1);
		return
	end

	local newHeight = (nextLine * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (INNER_HEIGHT * 2);

	self:SetHeight(newHeight);
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateObjectives(event, ...)
	if(event == "QUEST_ACCEPTED" and (AUTO_QUEST_WATCH == "1")) then
		local questLogIndex, questID = ...;
		AddQuestWatch(questLogIndex);
		QuestSuperTracking_OnQuestTracked(questID);
	elseif(event == "QUEST_TURNED_IN") then
		local questID, xp, money = ...;
		if(questID) then
			local button = self.Headers["Active"].Block.Button;
			local questIndex = button:GetID();
			if(questIndex and (questIndex ~= 0)) then
				local ActiveQuestID = select(8, GetQuestLogTitle(questIndex));
				if(ActiveQuestID == questID) then
					button:CloseMe()
				end
			end
		end
	elseif(event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA") then
		CURRENT_MAP_ID = GetCurrentMapAreaID();
	end
	self.Headers["Quests"]:Reset()
	self.Headers["Quests"]:Refresh(event, ...)
	self:UpdateDimensions();
end

local function UpdateQuestLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateQuestLocals", UpdateQuestLocals);

function MOD:InitializeQuests()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

	local quests = CreateFrame("Frame", nil, scrollChild)
	quests:SetWidth(ROW_WIDTH);
	quests:SetHeight(ROW_HEIGHT);
	quests:SetPoint("TOPLEFT", self.Headers["Scenario"], "BOTTOMLEFT", 0, -4);

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

	quests.ZoneCount = 0;
	quests.Get = GetQuestRow;
	quests.Set = SetQuestRow;
	quests.SetZone = SetZoneHeader;
	quests.Refresh = RefreshQuests;
	quests.Reset = ResetQuestBlock;
	quests.RemoveUnused = RemoveUnusedBlocks;

	self.Headers["Quests"] = quests;

	self:RegisterEvent("QUEST_LOG_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", self.UpdateObjectives);
	self:RegisterEvent("QUEST_ACCEPTED", self.UpdateObjectives);	
	self:RegisterEvent("QUEST_POI_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_TURNED_IN", self.UpdateObjectives);

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.UpdateObjectives);
	self:RegisterEvent("ZONE_CHANGED", self.UpdateObjectives);

	self.Headers["Quests"]:Refresh()
end