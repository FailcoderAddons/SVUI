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

local ShowSubDocklet = function(self)
	if(InCombatLockdown()) then return end
	if(not ObjectiveTrackerFrame:IsShown()) then ObjectiveTrackerFrame:Show() end
end

local HideSubDocklet = function(self)
	if(InCombatLockdown()) then return end
	if(ObjectiveTrackerFrame:IsShown()) then ObjectiveTrackerFrame:Hide() end
end

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
local ViewButton_OnClick = function(self)
	local questID = self:GetID();
	if(questID and (questID ~= 0)) then
		QuestMapFrame_OpenToQuestDetails(questID);
	end
end
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function AddTrackingRow(parent, lineNumber)
	local lastRowNumber = lineNumber - 1;
	local previousFrame = parent.Rows[lastRowNumber]
	local anchorFrame, anchorOffset_1, anchorOffset_2;
	if(previousFrame and previousFrame.Objectives) then
		anchorFrame = previousFrame.Objectives;
		anchorOffset_1 = -2;
		anchorOffset_2 = 2;
	else
		anchorFrame = parent.Header;
		anchorOffset_1 = 0;
		anchorOffset_2 = 0;
	end

	local newLine = CreateFrame("Frame", nil, parent)
	newLine:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, -2);
	newLine:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, -2);
	newLine:SetHeight(ROW_HEIGHT);

	newLine.Badge = CreateFrame("Frame", nil, newLine)
	newLine.Badge:SetPoint("TOPLEFT", newLine, "TOPLEFT", 2, -2);
	newLine.Badge:SetPoint("BOTTOMLEFT", newLine, "BOTTOMLEFT", 2, 2);
	newLine.Badge:SetWidth(INNER_HEIGHT);
	newLine.Badge:SetPanelTemplate("Headline")

	newLine.Badge.Icon = newLine.Badge:CreateTexture(nil,"OVERLAY")
	newLine.Badge.Icon:SetAllPoints(newLine.Badge);
	newLine.Badge.Icon:SetTexture(LINE_QUEST_ICON)
	newLine.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	newLine.Header = CreateFrame("Frame", nil, newLine)
	newLine.Header:SetPoint("TOPLEFT", newLine.Badge, "TOPRIGHT", 2, 0);
	newLine.Header:SetPoint("TOPRIGHT", newLine, "TOPRIGHT", -2, 0);
	newLine.Header:SetHeight(INNER_HEIGHT);
	newLine.Header:SetPanelTemplate("Headline")

	newLine.Header.Level = newLine.Header:CreateFontString(nil,"OVERLAY")
	newLine.Header.Level:SetFont(SV.Media.font.roboto, 10, "NONE")
	newLine.Header.Level:SetShadowOffset(-1,-1)
	newLine.Header.Level:SetShadowColor(0,0,0,0.5)
	newLine.Header.Level:SetJustifyH('CENTER')
	newLine.Header.Level:SetJustifyV('MIDDLE')
	newLine.Header.Level:SetText('')
	newLine.Header.Level:SetPoint("TOPLEFT", newLine.Header, "TOPLEFT", 4, 0);
	newLine.Header.Level:SetPoint("BOTTOMLEFT", newLine.Header, "BOTTOMLEFT", 4, 0);
	--newLine.Header.Level:SetWidth(INNER_HEIGHT);

	newLine.Header.Text = newLine.Header:CreateFontString(nil,"OVERLAY")
	newLine.Header.Text:SetFont(SV.Media.font.roboto, 14, "NONE")
	newLine.Header.Text:SetTextColor(1,1,0)
	newLine.Header.Text:SetShadowOffset(-1,-1)
	newLine.Header.Text:SetShadowColor(0,0,0,0.5)
	newLine.Header.Text:SetJustifyH('LEFT')
	newLine.Header.Text:SetJustifyV('MIDDLE')
	newLine.Header.Text:SetText('')
	newLine.Header.Text:SetPoint("TOPLEFT", newLine.Header.Level, "TOPRIGHT", 4, 0);
	newLine.Header.Text:SetPoint("BOTTOMRIGHT", newLine.Header, "BOTTOMRIGHT", 0, 0);

	newLine.Button = CreateFrame("Button", nil, newLine.Header)
	newLine.Button:SetAllPoints(newLine.Header);
	newLine.Button:SetButtonTemplate(true)
	newLine.Button:SetID(0)
	newLine.Button:SetScript("OnClick", ViewButton_OnClick)

	newLine.Objectives = CreateFrame("Frame", nil, newLine)
	newLine.Objectives:SetPoint("TOPLEFT", newLine, "BOTTOMLEFT", 0, 0);
	newLine.Objectives:SetPoint("TOPRIGHT", newLine, "BOTTOMRIGHT", 0, 0);
	newLine.Objectives:SetHeight(1);

	newLine.Objectives.Rows = {}

	return newLine;
end

local function AddRowObjective(parent, lineNumber)
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
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local UpdateQuestRows = function(self, event, ...)
	local shortestDistance = 62500;
	local liveLines = GetNumQuestWatches();
	local nextLine = 1;
	local totalObjectives = 0;
	local closestQuest, closestLink, closestTexture;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local questID, _, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
			if(questID) then
				local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
				if(QuestHasPOIInfo(questID)) then
					local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
					if(link) then
						local areaID = QuestInZone[questID]
						if(areaID and areaID == GetCurrentMapAreaID()) then
							closestQuest = title
							closestLink = link
							closestTexture = texture
						elseif(not isComplete or (isComplete and showCompleted)) then
							local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
							if(onContinent and distanceSq < shortestDistance) then
								shortestDistance = distanceSq
								closestQuest = title
								closestLink = link
								closestTexture = texture
							end
						end
					end
				end

				local entry = self.Rows[nextLine];

				if(not entry) then
					self.Rows[nextLine] = AddTrackingRow(self, nextLine)
					entry = self.Rows[nextLine]
				end

				nextLine = nextLine + 1;
				local color = GetQuestDifficultyColor(level)
				entry.Header.Level:SetTextColor(color.r, color.g, color.b)
				entry.Header.Level:SetText(level)
				entry.Header.Text:SetText(title)
				entry.Button:SetID(questID)
				entry:Show()

				local objectives = entry.Objectives;
				local numLineObjectives = #objectives.Rows;
				local nextObjective = 1;
				local objectiveHeight = 1;

				if(numObjectives > 0) then
					for o = 1, numObjectives do
						local objectiveText, objectiveType, objectiveFinished = GetQuestObjectiveInfo(questID, o);
						if(objectiveText) then
							local objective = objectives.Rows[o]
							if(not objective) then
								objectives.Rows[o] = AddRowObjective(objectives, o)
								objective = objectives.Rows[o]
							end

							objective.Text:SetText(objectiveText)
							objective:Show()

							if(objectiveFinished) then
								objective.Text:SetTextColor(0.1,0.9,0.1)
								objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
							else
								objective.Text:SetTextColor(1,1,1)
								objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
							end
							nextObjective = nextObjective + 1;
							totalObjectives = totalObjectives + 1;
						end
					end

					objectiveHeight = (INNER_HEIGHT + 2) * numObjectives + 2;
				end

				objectives:SetHeight(objectiveHeight);

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
			end
		end

		local numLines = #self.Rows;
		for x = nextLine, numLines do
			local entry = self.Rows[x]
			if(entry) then
				entry.Header.Level:SetText('')
				--entry.Badge.Icon:SetTexture(0,0,0,0)
				entry.Header.Text:SetText('')
				entry.Button:SetID(0)
				if(entry:IsShown()) then
					entry:Hide()
				end
			end
		end
	end

	local newHeight = (liveLines * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (ROW_HEIGHT + (liveLines * 2));
	self:SetHeight(newHeight);

	ClosestQuestName = closestQuest;
	ClosestQuestLink = closestLink;
	ClosestQuestTexture = closestTexture;
end

local UpdateAchievementRows = function(self, event, ...)
	local trackedAchievements = { GetTrackedAchievements() };
	local liveLines = #trackedAchievements;
	local totalObjectives = 0;
	local nextLine = 1;
	local newHeight = 1;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local achievementID = trackedAchievements[i];
			local _, achievementName, _, completed, _, _, _, description, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achievementID);
			if(not wasEarnedByMe) then
				local entry = self.Rows[nextLine];
				if(not entry) then
					self.Rows[nextLine] = AddTrackingRow(self, nextLine)
					entry = self.Rows[nextLine]
				end

				entry.Header.Level:SetText('')
				entry.Badge.Icon:SetTexture(icon)
				entry.Header.Text:SetText(achievementName)
				--entry.Button:Hide()
				entry.Button:SetID(0)
				entry:Show()

				local numObjectives = GetAchievementNumCriteria(achievementID);

				if(numObjectives > 0) then
					local numShownCriteria = 0;
					local objectives = entry.Objectives;
					local numLineObjectives = #objectives.Rows;
					local nextObjective = 1;

					for o = 1, numObjectives do
						local objectiveText, objectiveType, objectiveFinished, quantity, totalQuantity, _, flags, assetID, quantityString, criteriaID, eligible, duration, elapsed = GetAchievementCriteriaInfo(achievementID, o);
						if(not ((not objectiveFinished) and (numShownCriteria > 5))) then
							if(numShownCriteria == 5 and numObjectives > (5 + 1)) then
								numShownCriteria = numShownCriteria + 1;
							else
								if(description and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
									if(string.find(strlower(quantityString), "interface\\moneyframe")) then
										objectiveText = quantityString.."\n"..description;
									else
										objectiveText = string.gsub(quantityString, " / ", "/").." "..description;
									end
								else
									if(objectiveType == CRITERIA_TYPE_ACHIEVEMENT and assetID) then
										_, objectiveText = GetAchievementInfo(assetID);
									end
								end
								numShownCriteria = numShownCriteria + 1;					
							end

							local objective = objectives.Rows[o];
							if(not objective) then
								objectives.Rows[o] = AddRowObjective(objectives, o)
								objective = objectives.Rows[o]
							end
							objective.Text:SetText(objectiveText)
							objective:Show()
							if(objectiveFinished) then
								objective.Text:SetTextColor(0.1,0.9,0.1)
								objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
							else
								objective.Text:SetTextColor(1,1,1)
								objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
							end

							if(duration and elapsed and elapsed < duration) then
								-- MAKE BAR
							elseif(objective.TimerBar) then
								-- UPDATE BAR
							end

							nextObjective = nextObjective + 1;

							totalObjectives = totalObjectives + 1;
						end

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
						objectives:SetHeight(objectiveHeight);

						nextLine = nextLine + 1;
					end

				end
			end
		end

		local numLines = #self.Rows;

		for x = nextLine, numLines do
			local entry = self.Rows[x]
			if(entry) then
				entry.Header.Level:SetText('')
				entry.Header.Text:SetText('')
				entry.Button:SetID(0)
				if(entry:IsShown()) then
					entry:Hide()
				end
			end
		end
	end

	local newHeight = (liveLines * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (ROW_HEIGHT + (liveLines * 2));
	self:SetHeight(newHeight);
end

local UpdateScenarioRows = function(self, event, ...)
	local newHeight = 1;
	local nextLine = 1;
	local scenarioName, currentStage, numStages, flags, _, _, _, xp, money = C_Scenario.GetInfo();
	if(scenarioName) then
		local stageName, stageDescription, numCriteria = C_Scenario.GetStepInfo();
		local inChallengeMode = bit.band(flags, SCENARIO_FLAG_CHALLENGE_MODE) == SCENARIO_FLAG_CHALLENGE_MODE;
		local inProvingGrounds = bit.band(flags, SCENARIO_FLAG_PROVING_GROUNDS) == SCENARIO_FLAG_PROVING_GROUNDS;
		local dungeonDisplay = bit.band(flags, SCENARIO_FLAG_USE_DUNGEON_DISPLAY) == SCENARIO_FLAG_USE_DUNGEON_DISPLAY;
		local scenariocompleted = currentStage > numStages;
		if(not scenariocompleted) then
			-- do the criteria
			self.Header.Text:SetText(scenarioName)
			for criteriaIndex = 1, numCriteria do
				local criteriaString, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed = C_Scenario.GetCriteriaInfo(criteriaIndex);
				criteriaString = string.format("%d/%d %s", quantity, totalQuantity, criteriaString);

				local objective = self.Objectives.Rows[criteriaIndex];
				if(not objective) then
					self.Objectives.Rows[criteriaIndex] = AddRowObjective(self.Objectives, criteriaIndex)
					objective = self.Objectives.Rows[criteriaIndex]
				end
				objective.Text:SetText(criteriaString)
				objective:Show()

				if(completed) then
					objective.Text:SetTextColor(0.1,0.9,0.1)
					objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
				else
					objective.Text:SetTextColor(1,1,1)
					objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
				end
				-- if(duration > 0 and elapsed <= duration ) then
					-- DO STUFF	
				-- else
					-- DO STUFF	
				-- end
				nextLine = nextLine + 1;
			end

			newHeight = ((ROW_HEIGHT + 2) + (numCriteria * (INNER_HEIGHT + 2)));
		end
	else
		self.Header.Text:SetText('')
	end

	local numLines = #self.Objectives.Rows;
	for x = nextLine, numLines do
		local objective = self.Objectives.Rows[x]
		if(objective) then
			objective.Text:SetText('')
			objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
			if(objective:IsShown()) then
				objective:Hide()
			end
		end
	end

	self:SetHeight(newHeight);
end

local UpdateQuestProximity = function()
	local shortestDistance = 62500;
	local liveLines = GetNumQuestWatches();
	local closestQuest, closestLink, closestTexture;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local questID, _, questLogIndex, numObjectives, requiredMoney, isComplete, startEvent, isAutoComplete, failureTime, timeElapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
			if(questID) then
				local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
				if(QuestHasPOIInfo(questID)) then
					local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
					if(link) then
						local areaID = QuestInZone[questID]
						if(areaID and areaID == GetCurrentMapAreaID()) then
							closestQuest = title
							closestLink = link
							closestTexture = texture
						elseif(not isComplete or (isComplete and showCompleted)) then
							local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
							if(onContinent and distanceSq < shortestDistance) then
								shortestDistance = distanceSq
								closestQuest = title
								closestLink = link
								closestTexture = texture
							end
						end
					end
				end
			end
		end
	end

	ClosestQuestName = closestQuest;
	ClosestQuestLink = closestLink;
	ClosestQuestTexture = closestTexture;
end

local UpdateActiveQuest = function()
	if(ClosestQuestName) then
		MOD.Active.Header.Text:SetText(ClosestQuestName)
		if(ClosestQuestLink) then
			MOD.QuestItem:SetItem(ClosestQuestLink, ClosestQuestTexture)
		elseif(MOD.QuestItem:IsShown()) then
			MOD.QuestItem:RemoveItem()
		end
	else
		MOD.Active.Header.Text:SetText('')
	end
end

local UpdateScrollSize = function()
	local h1 = MOD.Active:GetHeight()
	local h2 = MOD.Quests:GetHeight()
	local h3 = MOD.Achievements:GetHeight()
	local h4 = MOD.Scenario:GetHeight()
	local NEWHEIGHT = h1 + h2 + h3 + h4 + 6;
	local scrollHeight = NEWHEIGHT - 80;

	SVUI_QuestWatchFrameScrollFrame.MaxVal = scrollHeight;
	SVUI_QuestWatchFrameScrollBar:SetMinMaxValues(1, scrollHeight);
	SVUI_QuestWatchFrameScrollBar:SetHeight(SVUI_QuestWatchFrameScrollFrame:GetHeight());
	SVUI_QuestWatchFrameScrollFrameScrollChild:SetHeight(NEWHEIGHT);
end
--[[ 
########################################################## 
EVENT HANDLERS
##########################################################
]]--
local UpdateScenarios = function(self, event, ...)
	MOD.Scenario:UpdateRows(event, ...)
	UpdateActiveQuest()
	UpdateScrollSize()
end

local UpdateObjectives = function(self, event, ...)
	MOD.Quests:UpdateRows(event, ...)
	MOD.Scenario:UpdateRows(event, ...)
	UpdateActiveQuest()
	UpdateScrollSize()
end

local UpdateAchievements = function(self, event, ...)
	MOD.Achievements:UpdateRows(event, ...)
	UpdateScrollSize()
end

local UpdateProximity = function(self, event, ...)
	UpdateQuestProximity()
	UpdateActiveQuest()
	UpdateScrollSize()
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateLocals()
	ROW_WIDTH = SVUI_QuestWatchFrameScrollFrame:GetWidth();
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

	local active = CreateFrame("Frame", nil, self.Tracker)
	active:SetPoint("TOPLEFT", self.Tracker, "TOPLEFT", 0, 0);
	active:SetPoint("TOPRIGHT", self.Tracker, "TOPRIGHT", 0, 0);
	active:SetHeight(LARGE_ROW_HEIGHT);

	local listFrame = CreateFrame("ScrollFrame", "SVUI_QuestWatchFrameScrollFrame", self.Tracker);
	listFrame:SetPoint("TOPLEFT", active, "BOTTOMLEFT", 4, -2);
	listFrame:SetPoint("BOTTOMRIGHT", self.Tracker, "BOTTOMRIGHT", -30, 2);
	listFrame:EnableMouseWheel(true);
	listFrame.MaxVal = 420;

	self:UpdateLocals();

	local scrollFrame = CreateFrame("Slider", "SVUI_QuestWatchFrameScrollBar", listFrame);
	scrollFrame:SetHeight(listFrame:GetHeight());
	scrollFrame:SetWidth(18);
	scrollFrame:SetPoint("TOPRIGHT", active, "BOTTOMRIGHT", 0, -2);
	scrollFrame:SetBackdrop({bgFile = bgTex, edgeFile = bdTex, edgeSize = 4, insets = {left = 3, right = 3, top = 3, bottom = 3}});
	scrollFrame:SetFrameLevel(6)
	scrollFrame:SetFixedPanelTemplate("Transparent", true);
	scrollFrame:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob");
	scrollFrame:SetOrientation("VERTICAL");
	scrollFrame:SetValueStep(5);
	scrollFrame:SetMinMaxValues(1, 420);
	scrollFrame:SetValue(1);

	local scrollChild = CreateFrame("Frame", "SVUI_QuestWatchFrameScrollFrameScrollChild", UIParent)
	scrollChild:SetWidth(ROW_WIDTH);
	scrollChild:SetClampedToScreen(false)
	scrollChild:SetHeight(500)
	scrollChild:SetPoint("TOPRIGHT", listFrame, "TOPRIGHT", -2, 0)
	scrollChild:SetFrameLevel(listFrame:GetFrameLevel() + 1)

	listFrame:SetScrollChild(scrollChild)
	listFrame.slider = scrollFrame;
	listFrame:SetScript("OnMouseWheel", function(self, delta)
		local scroll = self:GetVerticalScroll();
		local value = (scroll - (20  *  delta));
		if value < -1 then 
			value = 0
		end 
		if value > self.MaxVal then 
			value = self.MaxVal
		end 
		self:SetVerticalScroll(value)
		self.slider:SetValue(value)
	end)

	local scenario = CreateFrame("Frame", nil, scrollChild)
    scenario:SetWidth(ROW_WIDTH);
	scenario:SetHeight(1);
	scenario:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0);
	scenario:SetPoint("TOPRIGHT", scrollChild, "TOPRIGHT", 0, 0);

	scenario.Header = CreateFrame("Frame", nil, scenario)
	scenario.Header:SetPoint("TOPLEFT", scenario, "TOPLEFT", 2, -2);
	scenario.Header:SetPoint("TOPRIGHT", scenario, "TOPRIGHT", -2, -2);
	scenario.Header:SetHeight(INNER_HEIGHT);
	scenario.Header:SetPanelTemplate("Inset");
	scenario.Header.Text = scenario.Header:CreateFontString(nil,"OVERLAY")
	scenario.Header.Text:SetFont(SV.Media.font.roboto, 16, "OUTLINE")
	scenario.Header.Text:SetJustifyH('CENTER')
	scenario.Header.Text:SetJustifyV('MIDDLE')
	scenario.Header.Text:SetTextColor(1,0.6,0.1)
	scenario.Header.Text:SetShadowOffset(-1,-1)
	scenario.Header.Text:SetShadowColor(0,0,0,0.5)
	scenario.Header.Text:SetText(TRACKER_HEADER_SCENARIOS)
	scenario.Header.Text:SetAllPoints(scenario.Header)

	scenario.Objectives = CreateFrame("Frame", nil, scenario)
	scenario.Objectives:SetPoint("TOPLEFT", scenario.Header, "BOTTOMLEFT", 0, 0);
	scenario.Objectives:SetPoint("TOPRIGHT", scenario.Header, "BOTTOMRIGHT", 0, 0);
	scenario.Objectives:SetHeight(1);

	scenario.Objectives.Rows = {}
	scenario.UpdateRows = UpdateScenarioRows;

	local quests = CreateFrame("Frame", nil, scrollChild)
	quests:SetWidth(ROW_WIDTH);
	quests:SetHeight(ROW_HEIGHT);
	quests:SetPoint("TOP", scenario, "BOTTOM", 0, 0);
	--quests:SetPanelTemplate();

	quests.Header = CreateFrame("Frame", nil, quests)
	quests.Header:SetPoint("TOPLEFT", quests, "TOPLEFT", 2, -2);
	quests.Header:SetPoint("TOPRIGHT", quests, "TOPRIGHT", -2, -2);
	quests.Header:SetHeight(INNER_HEIGHT);
	quests.Header:SetPanelTemplate("Inset");
	quests.Header.Text = quests.Header:CreateFontString(nil,"OVERLAY")
	quests.Header.Text:SetFont(SV.Media.font.roboto, 16, "OUTLINE")
	quests.Header.Text:SetJustifyH('CENTER')
	quests.Header.Text:SetJustifyV('MIDDLE')
	quests.Header.Text:SetTextColor(1,0.6,0.1)
	quests.Header.Text:SetShadowOffset(-1,-1)
	quests.Header.Text:SetShadowColor(0,0,0,0.5)
	quests.Header.Text:SetText(TRACKER_HEADER_QUESTS)
	quests.Header.Text:SetAllPoints(quests.Header)
	quests.Rows = {};
	quests.UpdateRows = UpdateQuestRows;

    local achievements = CreateFrame("Frame", nil, scrollChild)
    achievements:SetWidth(ROW_WIDTH);
	achievements:SetHeight(ROW_HEIGHT);
	achievements:SetPoint("TOP", quests, "BOTTOM", 0, 0);

	achievements.Header = CreateFrame("Frame", nil, achievements)
	achievements.Header:SetPoint("TOPLEFT", achievements, "TOPLEFT", 2, -2);
	achievements.Header:SetPoint("TOPRIGHT", achievements, "TOPRIGHT", -2, -2);
	achievements.Header:SetHeight(INNER_HEIGHT);
	achievements.Header:SetPanelTemplate("Inset");
	achievements.Header.Text = achievements.Header:CreateFontString(nil,"OVERLAY")
	achievements.Header.Text:SetFont(SV.Media.font.roboto, 16, "OUTLINE")
	achievements.Header.Text:SetJustifyH('CENTER')
	achievements.Header.Text:SetJustifyV('MIDDLE')
	achievements.Header.Text:SetTextColor(1,0.6,0.1)
	achievements.Header.Text:SetShadowOffset(-1,-1)
	achievements.Header.Text:SetShadowColor(0,0,0,0.5)
	achievements.Header.Text:SetText(TRACKER_HEADER_ACHIEVEMENTS)
	achievements.Header.Text:SetAllPoints(achievements.Header)
	achievements.Rows = {};
	achievements.UpdateRows = UpdateAchievementRows;

	self.Quests = quests;
	self.Scenario = scenario;
	self.Achievements = achievements;

	active.Badge = CreateFrame("Frame", nil, active);
	active.Badge:SetPoint("TOPLEFT", active, "TOPLEFT", 2, -2);
	active.Badge:SetPoint("BOTTOMLEFT", active, "BOTTOMLEFT", 2, 2);
	active.Badge:SetWidth(LARGE_INNER_HEIGHT);

	active.Header = CreateFrame("Frame", nil, active)
	active.Header:SetPoint("TOPLEFT", active, "TOPLEFT", 46, -2);
	active.Header:SetPoint("BOTTOMLEFT", active, "BOTTOMLEFT", 46, 2);
	active.Header:SetPoint("TOPRIGHT", active, "TOPRIGHT", -2, -2);
	active.Header:SetPoint("BOTTOMRIGHT", active, "BOTTOMRIGHT", -2, 2);
	active.Header:SetPanelTemplate("Headline");

	active.Header.Text = active.Header:CreateFontString(nil,"OVERLAY")
	active.Header.Text:SetFont(SV.Media.font.names, 20, "OUTLINE")
	active.Header.Text:SetJustifyH('LEFT')
	active.Header.Text:SetJustifyV('MIDDLE')
	active.Header.Text:SetTextColor(1,0.6,0.1)
	active.Header.Text:SetShadowOffset(-1,-1)
	active.Header.Text:SetShadowColor(0,0,0,0.5)
	active.Header.Text:SetText('')
	active.Header.Text:SetAllPoints(active.Header)
	active:SetHeight(1);

	self.Active = active;

	self.QuestItem = self:CreateQuestItemButton()
	self.QuestItem:SetAllPoints(active.Badge)
	self.QuestItem:HookScript("OnShow", function() MOD.Active:SetHeight(LARGE_ROW_HEIGHT); end)
	self.QuestItem:HookScript("OnHide", function() MOD.Active:SetHeight(1); end)

	self.Tracker.DockButton:MakeDefault();
	self.Tracker:Show();

	self:RegisterEvent("QUEST_LOG_UPDATE", UpdateObjectives);
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", UpdateObjectives);
	--self:RegisterEvent("QUEST_AUTOCOMPLETE", UpdateObjectives);
	self:RegisterEvent("QUEST_ACCEPTED", UpdateObjectives);	
	--self:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED", UpdateObjectives);
	self:RegisterEvent("SCENARIO_UPDATE", UpdateScenarios);
	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE", UpdateScenarios);
	self:RegisterEvent("QUEST_POI_UPDATE", UpdateObjectives);
	self:RegisterEvent("QUEST_TURNED_IN", UpdateObjectives);
	--self:RegisterEvent("PLAYER_MONEY", UpdateObjectives);

	self:RegisterEvent("TRACKED_ACHIEVEMENT_UPDATE", UpdateAchievements);
	self:RegisterEvent("TRACKED_ACHIEVEMENT_LIST_CHANGED", UpdateAchievements);

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", UpdateProximity);
	self:RegisterEvent("ZONE_CHANGED", UpdateProximity);

	UpdateObjectives(self)
	UpdateAchievements(self)

	--ObjectiveTrackerFrame:HookScript("OnEvent", UpdateObjectives)
	ObjectiveTrackerFrame:SetParent(SV.Hidden)
end