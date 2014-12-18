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

local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];
local LINE_QUEST_ICON = [[Interface\ICONS\Ability_Hisek_Aim]];

local ENABLED_BONUS_IDS = {};
local CACHED_BONUS_DATA = {};
local CACHED_SCENARIO_DATA = {};
--[[ 
########################################################## 
DATA CACHE HANDLERS
##########################################################
]]--
local function CacheBonusData(questID, xp, money)
	if(not questID or (questID and questID <= 0)) then return; end

	local data = {};
	data.objectives = {};
	local isInArea, isOnMap, numObjectives = GetTaskInfo(questID);
	for objectiveIndex = 1, numObjectives do
		local text, objectiveType, finished = GetQuestObjectiveInfo(questID, objectiveIndex);
		tinsert(data.objectives, text);
		data.objectiveType = objectiveType;
	end

	data.rewards = {};
	if(not xp) then
		xp = GetQuestLogRewardXP(questID);
	end
	if(xp > 0 and UnitLevel("player") < MAX_PLAYER_LEVEL) then
		local t = {};
		t.label = xp;
		t.texture = "Interface\\Icons\\XP_Icon";
		t.count = 0;
		t.font = "NumberFontNormal";
		tinsert(data.rewards, t);
	end

	local numCurrencies = GetNumQuestLogRewardCurrencies(questID);
	for i = 1, numCurrencies do
		local name, texture, count = GetQuestLogRewardCurrencyInfo(i, questID);
		local t = {};
		t.label = name;
		t.texture = texture;
		t.count = count;
		t.font = "GameFontHighlightSmall";
		tinsert(data.rewards, t);
	end

	local numItems = GetNumQuestLogRewards(questID);
	for i = 1, numItems do
		local name, texture, count, quality, isUsable = GetQuestLogRewardInfo(i, questID);
		local t = {};
		t.label = name;
		t.texture = texture;
		t.count = count;
		t.font = "GameFontHighlightSmall";
		tinsert(data.rewards, t);
	end	

	if(not money) then
		money = GetQuestLogRewardMoney(questID);
	end
	if(money > 0) then
		local t = {};
		t.label = GetMoneyString(money);
		t.texture = "Interface\\Icons\\inv_misc_coin_01";
		t.count = 0;
		t.font = "GameFontHighlight";
		tinsert(data.rewards, t);
	end
	CACHED_BONUS_DATA[questID] = data;

	if(#data.rewards <= 0) then
		CACHED_BONUS_DATA[questID] = nil;
	else
		ENABLED_BONUS_IDS[questID] = true;
	end
end

local function GetBonusCache()
	local cache = GetTasksTable();
	for questID, data in pairs(CACHED_BONUS_DATA) do
		if(questID > 0) then
			local found = false;
			for i = 1, #cache do
				if(cache[i] == questID) then
					found = true;
					break;
				end
			end
			if(not found) then
				tinsert(cache, questID);
			end
		end
	end
	return cache;
end

local function GetCachedTaskInfo(questID)
	if(CACHED_BONUS_DATA[questID]) then
		return true, true, #CACHED_BONUS_DATA[questID].objectives;
	else
		return GetTaskInfo(questID);
	end
end

local function GetCachedQuestObjectiveInfo(questID, objectiveIndex)
	if(CACHED_BONUS_DATA[questID]) then
		return CACHED_BONUS_DATA[questID].objectives[objectiveIndex], CACHED_BONUS_DATA[questID].objectiveType, true;
	else
		return GetQuestObjectiveInfo(questID, objectiveIndex);
	end
end

local function GetScenarioBonusStep(index)
	local cachedObjectives = C_Scenario.GetSupersededObjectives();
	for i = 1, #cachedObjectives do
		local pairs = cachedObjectives[i];
		local k,v = unpack(pairs);
		if(v == index) then
			return k;
		end
	end
end
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local ObjectiveTimer_OnUpdate = function(self, elapsed)
	local statusbar = self.Timer.Bar
	local timeNow = GetTime();
	local timeRemaining = statusbar.duration - (timeNow - statusbar.startTime);
	statusbar:SetValue(timeRemaining);
	if(timeRemaining < 0) then
		-- hold at 0 for a moment
		if(timeRemaining > -1) then
			timeRemaining = 0;
		else
			self:StopTimer();
		end
	end
	local r,g,b = MOD:GetTimerTextColor(statusbar.duration, statusbar.duration - timeRemaining)
	statusbar.Label:SetText(GetTimeStringFromSeconds(timeRemaining, nil, true));
	statusbar.Label:SetTextColor(r,g,b);
end

local ObjectiveProgressBar_OnEvent = function(self, event, ...)
	local statusbar = self.Progress.Bar;
	local percent = 100;
	if(not statusbar.finished) then
		percent = GetQuestProgressBarPercent(statusbar.questID);
	end
	statusbar:SetValue(percent);
	statusbar.Label:SetFormattedText(PERCENTAGE_STRING, percent);
end

local ViewButton_OnClick = function(self, button)
	local questIndex = self:GetID();
	if(questIndex and (questIndex ~= 0)) then
		local questID = select(8, GetQuestLogTitle(questIndex));
	end
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local StartObjectiveTimer = function(self, duration, elapsed)
	local timeNow = GetTime();
	local startTime = timeNow - elapsed;
	local timeRemaining = duration - startTime;
	local statusbar = self.Timer.Bar;

	self.Timer:FadeIn();
	statusbar.duration = duration or 1;
	statusbar.startTime = startTime;
	statusbar:SetMinMaxValues(0, statusbar.duration);
	statusbar:SetValue(timeRemaining);
	statusbar.Label:SetText(GetTimeStringFromSeconds(duration, nil, true));
	statusbar.Label:SetTextColor(MOD:GetTimerTextColor(duration, duration - timeRemaining));

	self:SetScript("OnUpdate", ObjectiveTimer_OnUpdate);
end

local StopObjectiveTimer = function(self)
	local statusbar = self.Timer.Bar;

	self.Timer:SetAlpha(0);
	statusbar.duration = 1;
	statusbar.startTime = 0;
	statusbar:SetMinMaxValues(0, statusbar.duration);
	statusbar:SetValue(0);
	statusbar.Label:SetText('');
	statusbar.Label:SetTextColor(1,1,1);

	self:SetScript("OnUpdate", nil);
end

local StartObjectiveProgressBar = function(self, questID, finished)
	local statusbar = self.Progress.Bar;
	self.Progress:FadeIn();
	statusbar.questID = questID;
	statusbar.finished = finished;
	statusbar:SetMinMaxValues(0, 100);
	local percent = 100;
	if(not finished) then
		percent = GetQuestProgressBarPercent(questID);
	end
	statusbar:SetValue(percent);
	statusbar.Label:SetFormattedText(PERCENTAGE_STRING, percent);
	self.Progress:RegisterEvent("QUEST_LOG_UPDATE")
end

local StopObjectiveProgressBar = function(self)
	local statusbar = self.Progress.Bar;
	self.Progress:SetAlpha(0);
	statusbar:SetValue(0);
	statusbar.Label:SetText('');
	self.Progress:UnregisterEvent("QUEST_LOG_UPDATE")
end

local function AddStatusBar(parent)
	local element = CreateFrame("Frame", nil, parent)
	element:SetPoint("TOPLEFT", parent.Icon, "TOPRIGHT", 4, 0);
	element:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0);

	element.Holder = CreateFrame("Frame", nil, element)
	element.Holder:SetPointToScale("TOPLEFT", element, "TOPLEFT", 4, -2);
	element.Holder:SetPointToScale("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, 2);
	MOD:StyleStatusBar(element.Holder)

	element.Bar = CreateFrame("StatusBar", nil, element.Holder);
	element.Bar:SetAllPointsIn(element.Holder);
	element.Bar:SetStatusBarTexture(SV.Media.bar.default)
	element.Bar:SetStatusBarColor(0.15,0.5,1) --1,0.15,0.08
	element.Bar:SetMinMaxValues(0, 1)
	element.Bar:SetValue(0)

	element.Bar.Label = element.Bar:CreateFontString(nil,"OVERLAY");
	element.Bar.Label:SetAllPointsIn(element.Bar);
	element.Bar.Label:SetFont(SV.Media.font.numbers, 12, "OUTLINE")
	element.Bar.Label:SetTextColor(1,1,1)
	element.Bar.Label:SetShadowOffset(-1,-1)
	element.Bar.Label:SetShadowColor(0,0,0,0.5)
	element.Bar.Label:SetJustifyH('CENTER')
	element.Bar.Label:SetJustifyV('MIDDLE')
	element.Bar.Label:SetText('')

	element:SetAlpha(0);

	return element;
end

local ResetObjectiveBlock = function(self)
	for x = 1, #self.Rows do
		local objective = self.Rows[x]
		if(objective) then
			if(not objective:IsShown()) then
				objective:Show()
			end
			objective.Text:SetText('')
			objective.Icon:SetTexture(NO_ICON)
			objective:StopTimer();
			objective:StopProgress();
			objective:SetHeight(1);
			objective:SetAlpha(0);
		end
	end
	self:SetHeight(1);
end

local GetObjectiveRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local yOffset = (index * (ROW_HEIGHT)) - ROW_HEIGHT

		local objective = CreateFrame("Frame", nil, self)
		objective:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -yOffset);
		objective:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -yOffset);
		objective:SetHeightToScale(INNER_HEIGHT);

		objective.Icon = objective:CreateTexture(nil,"OVERLAY")
		objective.Icon:SetPoint("TOPLEFT", objective, "TOPLEFT", 4, -2);
		objective.Icon:SetPoint("BOTTOMLEFT", objective, "BOTTOMLEFT", 4, 2);
		objective.Icon:SetWidth(INNER_HEIGHT - 4);
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)

		objective.Progress = AddStatusBar(objective);
		objective.StartProgress = StartObjectiveProgressBar;
		objective.StopProgress = StopObjectiveProgressBar;
		objective.Progress:SetScript("OnEvent", ObjectiveProgressBar_OnEvent);

		objective.Timer = AddStatusBar(objective);
		objective.StartTimer = StartObjectiveTimer;
		objective.StopTimer = StopObjectiveTimer;

		objective.Text = objective:CreateFontString(nil,"OVERLAY")
		objective.Text:SetPoint("TOPLEFT", objective, "TOPLEFT", INNER_HEIGHT + 6, -2);
		objective.Text:SetPoint("TOPRIGHT", objective, "TOPRIGHT", 0, -2);
		objective.Text:SetHeightToScale(INNER_HEIGHT - 2)
		objective.Text:SetFont(SV.Media.font.roboto, 12, "NONE")
		objective.Text:SetTextColor(1,1,1)
		objective.Text:SetShadowOffset(-1,-1)
		objective.Text:SetShadowColor(0,0,0,0.5)
		objective.Text:SetJustifyH('LEFT')
		objective.Text:SetJustifyV('MIDDLE')
		objective.Text:SetText('')

		self.Rows[index] = objective;
		return objective;
	end

	return self.Rows[index];
end

local SetObjectiveRow = function(self, index, description, completed, failed)
	index = index + 1;
	local objective = self:Get(index);

	if(failed) then
		objective.Text:SetTextColor(1,0,0)
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
	elseif(completed) then
		objective.Text:SetTextColor(0.1,0.9,0.1)
		objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
	else
		objective.Text:SetTextColor(1,1,1)
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
	end
	objective.Text:SetText(description);
	objective:SetHeightToScale(INNER_HEIGHT);
	objective:FadeIn();

	return index;
end

local SetObjectiveTimer = function(self, index, duration, elapsed)
	index = index + 1;
	local objective = self:Get(index);
	objective:StartTimer(duration, elapsed)
	objective.Text:SetText('')
	objective:SetHeightToScale(INNER_HEIGHT);
	objective:FadeIn();
	return index;
end

local SetObjectiveProgress = function(self, index, questID, completed)
	index = index + 1;
	local objective = self:Get(index);
	objective:StartProgress(questID, completed)
	objective.Text:SetText('')
	objective:SetHeightToScale(INNER_HEIGHT);
	objective:FadeIn();

	return index;
end

local GetBonusRow = function(self, index)
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
		row.Header = CreateFrame("Frame", nil, row)
		row.Header:SetPointToScale("TOPLEFT", row, "TOPLEFT", 2, -2);
		row.Header:SetPointToScale("TOPRIGHT", row, "TOPRIGHT", -2, -2);
		row.Header:SetHeightToScale(INNER_HEIGHT);
		row.Header:SetStylePanel("Default", "Headline");
		row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
		row.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
		row.Header.Text:SetTextColor(0.2,0.75,1)
		row.Header.Text:SetShadowOffset(-1,-1)
		row.Header.Text:SetShadowColor(0,0,0,0.5)
		row.Header.Text:SetJustifyH('LEFT')
		row.Header.Text:SetJustifyV('MIDDLE')
		row.Header.Text:SetText('')
		row.Header.Text:SetPointToScale("TOPLEFT", row.Header, "TOPLEFT", 0, 0);
		row.Header.Text:SetPointToScale("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", 0, 0);
		row.Objectives = CreateFrame("Frame", nil, row)
		row.Objectives:SetPointToScale("TOPLEFT", row.Header, "BOTTOMLEFT", 0, -2);
		row.Objectives:SetPointToScale("TOPRIGHT", row.Header, "BOTTOMRIGHT", 0, -2);
		row.Objectives:SetHeightToScale(1);
		row.Objectives.Rows = {}
		row.Objectives.Get = GetObjectiveRow;
		row.Objectives.Set = SetObjectiveRow;
		row.Objectives.SetTimer = SetObjectiveTimer;
		row.Objectives.SetProgress = SetObjectiveProgress;
		block.Objectives.Reset = ResetObjectiveBlock;

		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetCriteriaRow = function(self, index, bonusStepIndex, subCount, hasFailed)
	index = index + 1
	local objective_rows = 0;
	local fill_height = 0;
	local iscomplete = true;

	local row = self:Get(index);
	row.RowID = questID
	row.Header.Text:SetText(TRACKER_HEADER_OBJECTIVE .. ": " .. index)
	row:SetHeightToScale(ROW_HEIGHT);
	row:SetAlpha(1);

	local objective_block = row.Objectives;
	objective_block:Reset()

	for i = 1, subCount do
		local text, category, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, failed = C_Scenario.GetCriteriaInfoByStep(bonusStepIndex, i);		
		if(text and text ~= '') then
			if not completed then iscomplete = false end
			objective_rows = objective_block:Set(objective_rows, text, completed, failed, duration, elapsed);
			fill_height = fill_height + (INNER_HEIGHT + 2);
			if(duration > 0 and elapsed <= duration and not (failed or completed)) then
				objective_rows = objective_block:SetTimer(objective_rows, duration, elapsed);
				fill_height = fill_height + (INNER_HEIGHT + 2);
			end
		end
	end

	if(hasFailed) then
		row.Header.Text:SetTextColor(1,0,0)
	elseif(iscomplete) then
		row.Header.Text:SetTextColor(0.1,0.9,0.1)
	else
		row.Header.Text:SetTextColor(1,1,1)
	end

	if(objective_rows > 0) then
		objective_block:SetHeightToScale(fill_height);
	end

	fill_height = fill_height + (ROW_HEIGHT + 2);

	return index, fill_height;
end

local SetBonusRow = function(self, index, questID, subCount)
	index = index + 1
	local objective_rows = 0;
	local fill_height = 0;

	local row = self:Get(index);
	row.RowID = questID
	row.Header.Text:SetText(TRACKER_HEADER_OBJECTIVE .. ": " .. index)
	row:SetHeightToScale(ROW_HEIGHT);
	row:SetAlpha(1);

	local objective_block = row.Objectives;

	for i = 1, subCount do
		local text, category, completed = GetCachedQuestObjectiveInfo(questID, i);
		if(text and text ~= '') then
			if not completed then iscomplete = false end
			objective_rows = objective_block:Set(objective_rows, text, completed);
			fill_height = fill_height + (INNER_HEIGHT + 2);
		end
		if(category and category ~= 'progressbar') then
			if not completed then iscomplete = false end
			objective_rows = objective_block:SetProgress(objective_rows, questID, completed);
			fill_height = fill_height + (INNER_HEIGHT + 2);
		end
	end

	if(objective_rows > 0) then
		objective_block:SetHeightToScale(fill_height);
	end

	fill_height = fill_height + (ROW_HEIGHT + 2);

	return index, fill_height;
end

local UpdateBonusObjectives = function(self)
	local fill_height = 0;
	local rows = 0;

	if(C_Scenario.IsInScenario()) then
		local tblBonusSteps = C_Scenario.GetBonusSteps();
		local cachedToRemove = {};
		for i = 1, #tblBonusSteps do
			local bonusStepIndex = tblBonusSteps[i];
			local cachedIndex = GetScenarioBonusStep(bonusStepIndex);
			if(cachedIndex) then
				local name, description, numCriteria, stepFailed, isBonusStep, isForCurrentStepOnly = C_Scenario.GetStepInfo(bonusStepIndex);
				local completed = true;
				for criteriaIndex = 1, numCriteria do
					local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed = C_Scenario.GetCriteriaInfoByStep(bonusStepIndex, criteriaIndex);
					if(criteriaString) then
						if(not criteriaCompleted) then
							completed = false;
							break;
						end
					end
				end
				if(not completed) then
					tinsert(cachedToRemove, cachedIndex);
				else
					if(tContains(CACHED_SCENARIO_DATA, bonusStepIndex)) then
						tinsert(cachedToRemove, bonusStepIndex);
					end
				end
			end
		end
		for i = 1, #cachedToRemove do
			tDeleteItem(tblBonusSteps, cachedToRemove[i]);
		end

		for i = 1, #tblBonusSteps do
			local bonusStepIndex = tblBonusSteps[i];
			local name, description, numCriteria, stepFailed, isBonusStep, isForCurrentStepOnly = C_Scenario.GetStepInfo(bonusStepIndex);			
			local add_height = 0;
			rows, add_height = self:SetCriteria(rows, bonusStepIndex, numCriteria, stepFailed)
			fill_height = fill_height + add_height;
		end
	else
		wipe(CACHED_SCENARIO_DATA);
		local cache = GetBonusCache();
		for i = 1, #cache do
			local questID = cache[i];
			local isInArea, isOnMap, numObjectives = GetCachedTaskInfo(questID);
			local existingTask = ENABLED_BONUS_IDS[questID];
			if(isInArea or (isOnMap and existingTask)) then
				local add_height = 0;
				rows, add_height = self:Set(rows, questID, numObjectives)
				fill_height = fill_height + add_height;
			end
		end
	end

	if(rows == 0 or (fill_height <= 1)) then
		self:SetHeight(1);
	else
		self:SetHeightToScale(fill_height + 2);
	end
end

local RefreshBonusObjectives = function(self, event, ...)
	if(event == "CRITERIA_COMPLETE") then
		local id = ...;
		if(id > 0) then
			local tblBonusSteps = C_Scenario.GetBonusSteps();
			for i = 1, #tblBonusSteps do
				local bonusStepIndex = tblBonusSteps[i];
				local _, _, numCriteria = C_Scenario.GetStepInfo(bonusStepIndex);
				local blockKey = -bonusStepIndex;
				for criteriaIndex = 1, numCriteria do
					local _, _, _, _, _, _, _, _, criteriaID = C_Scenario.GetCriteriaInfoByStep(bonusStepIndex, criteriaIndex);		
					if(id == criteriaID) then
						local questID = C_Scenario.GetBonusStepRewardQuestID(bonusStepIndex);
						if(questID ~= 0) then
							CacheBonusData(questID);
							return;
						end
					end
				end
			end
		end
	end
	self:UpdateAll();
end

local ResetBonusBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Objectives:SetHeight(1);
			row:SetHeight(1);
			row:SetAlpha(0);
			row.Objectives:Reset();
		end
	end
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateBonusObjective(event, ...)
	self.Headers["Bonus"]:Reset()
	self.Headers["Bonus"]:Refresh(event, ...)
	self:UpdateDimensions();
end

function MOD:InitializeBonuses()
	local bonus = CreateFrame("Frame", nil, scrollChild)
	bonus:SetWidth(ROW_WIDTH);
	bonus:SetHeight(1);
	bonus:SetPoint("TOPLEFT", self.Headers["Quests"], "BOTTOMLEFT", 0, 0);

	bonus.Rows = {};

	bonus.Get = GetBonusRow;
	bonus.Set = SetBonusRow;
	bonus.SetCriteria = SetCriteriaRow;
	bonus.Refresh = RefreshBonusObjectives;
	bonus.Reset = ResetBonusBlock;
	bonus.UpdateAll = UpdateBonusObjectives;

	self.Headers["Bonus"] = bonus

	self:RegisterEvent("CRITERIA_COMPLETE", self.UpdateBonusObjective);
end