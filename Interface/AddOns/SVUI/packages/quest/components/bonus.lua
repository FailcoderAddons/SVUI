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
		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetBonusRow = function(self, index, questID, numObjectives)
	local nextObjective = 0;

	local row = self:Get(index);
	row.RowID = questID
	row.Header.Text:SetText(TRACKER_HEADER_OBJECTIVE .. ": " .. index)
	row:Show()

	local objectives = row.Objectives;

	for i = 1, numObjectives do
		local text, category, completed = GetCachedQuestObjectiveInfo(questID, i);
		if(text and text ~= '') then
			nextObjective = nextObjective + 1;
			objectives:Set(i, text, completed, category)
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
end

local UpdateScenarioBonusObjectives = function(self)
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
			local blockKey = -bonusStepIndex;			
			local stepFinished = true;
			for criteriaIndex = 1, numCriteria do
				local criteriaString, criteriaType, criteriaCompleted, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed = C_Scenario.GetCriteriaInfoByStep(bonusStepIndex, criteriaIndex);		
				if(criteriaString) then
					if(criteriaCompleted) then
						-- DO STUFF
					elseif(criteriaFailed) then
						-- DO STUFF
					else
						-- DO STUFF
					end
					
					if(duration > 0 and elapsed <= duration and not (criteriaFailed or criteriaCompleted)) then
						-- DO STUFF
					end
				end
			end
			if(stepFailed) then
				-- DO STUFF
			elseif(stepFinished) then
				-- DO STUFF
			else
				-- DO STUFF
			end
		end
	else
		wipe(CACHED_SCENARIO_DATA);
	end
end

local UpdateQuestBonusObjectives = function(self)
	local totalObjectives = 0;
	local nextLine = 0;

	local cache = GetBonusCache();
	for i = 1, #cache do
		local questID = cache[i];
		local isInArea, isOnMap, numObjectives = GetCachedTaskInfo(questID);
		local existingTask = ENABLED_BONUS_IDS[questID];
		if(isInArea or (isOnMap and existingTask)) then
			nextLine = nextLine + 1;
			local newCount = self:Set(nextLine, questID, numObjectives)
			totalObjectives = totalObjectives + newCount;
		end
	end

	nextLine = nextLine + 1;

	local numLines = #self.Rows;
	for x = nextLine, numLines do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end

	local newHeight = (nextLine * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (ROW_HEIGHT + (nextLine * 2));
	self:SetHeight(newHeight);
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

	--self:UpdateScenarios();
	self:UpdateQuests();
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateBonusObjective(event, ...)
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
	bonus.Refresh = RefreshBonusObjectives;
	bonus.UpdateQuests = UpdateQuestBonusObjectives;
	bonus.UpdateScenarios = UpdateScenarioBonusObjectives;

	self.Headers["Bonus"] = bonus

	self:RegisterEvent("CRITERIA_COMPLETE", self.UpdateBonusObjective);
end