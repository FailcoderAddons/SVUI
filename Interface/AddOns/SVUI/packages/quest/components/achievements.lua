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

local NO_ICON = [[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]];
local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];
local LINE_ACHIEVEMENT_ICON = [[Interface\ICONS\Achievement_General]];
--[[ 
########################################################## 
SCRIPT HANDLERS
##########################################################
]]--
local TimerBar_OnUpdate = function(self, elapsed)
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
	self.Timer.TimeLeft:SetText(GetTimeStringFromSeconds(timeRemaining, nil, true));
	self.Timer.TimeLeft:SetTextColor(r,g,b);
end

local ViewButton_OnClick = function(self, button)
	local achievementID = self:GetID();
	if(achievementID and (achievementID ~= 0)) then
		if(IsModifiedClick("CHATLINK") and ChatEdit_GetActiveWindow()) then
			local achievementLink = GetAchievementLink(achievementID);
			if(achievementLink) then
				ChatEdit_InsertLink(achievementLink);
			end
		else
			CloseDropDownMenus();
			if(not AchievementFrame ) then
				AchievementFrame_LoadUI();
			end
			if(IsModifiedClick("QUESTWATCHTOGGLE") ) then
				AchievementObjectiveTracker_UntrackAchievement(_, achievementID);
			elseif(not AchievementFrame:IsShown()) then
				AchievementFrame_ToggleAchievementFrame();
				AchievementFrame_SelectAchievement(achievementID);
			else
				if(AchievementFrameAchievements.selection ~= achievementID) then
					AchievementFrame_SelectAchievement(achievementID);
				else
					AchievementFrame_ToggleAchievementFrame();
				end
			end
		end
	end
end
--[[ 
########################################################## 
TRACKER FUNCTIONS
##########################################################
]]--
local StartTimer = function(self, duration, elapsed)
	local timeNow = GetTime();
	local startTime = timeNow - elapsed;
	local timeRemaining = duration - startTime;
	if(timeRemaining < 0) then
		-- hold at 0 for a moment
		if(timeRemaining > -1) then
			timeRemaining = 0;
		else
			self:StopTimer();
		end
	end
	self.Timer:SetHeightToScale(INNER_HEIGHT);
	self.Timer:FadeIn();
	self.Timer.Bar.duration = duration or 1;
	self.Timer.Bar.startTime = startTime;
	self.Timer.Bar:SetMinMaxValues(0, self.Timer.Bar.duration);
	self.Timer.Bar:SetValue(timeRemaining);
	self.Timer.TimeLeft:SetText(GetTimeStringFromSeconds(duration, nil, true));
	self.Timer.TimeLeft:SetTextColor(MOD:GetTimerTextColor(duration, duration - timeRemaining));

	self:SetScript("OnUpdate", TimerBar_OnUpdate);
end

local StopTimer = function(self)
	self.Timer:SetHeight(1);
	self.Timer:SetAlpha(0);
	self.Timer.Bar.duration = 1;
	self.Timer.Bar.startTime = 0;
	self.Timer.Bar:SetMinMaxValues(0, self.Timer.Bar.duration);
	self.Timer.Bar:SetValue(0);
	self.Timer.TimeLeft:SetText('');
	self.Timer.TimeLeft:SetTextColor(1,1,1);

	self:SetScript("OnUpdate", nil);
end

local function AddTimerFrame(parent)
	local timer = CreateFrame("Frame", nil, parent)
	timer:SetPoint("TOPLEFT", parent.Icon, "TOPRIGHT", 4, 0);
	timer:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0);

	timer.Holder = CreateFrame("Frame", nil, timer)
	timer.Holder:SetPointToScale("TOPLEFT", timer, "TOPLEFT", 2, -1);
	timer.Holder:SetPointToScale("BOTTOMRIGHT", timer, "BOTTOMRIGHT", -2, 1);
	MOD:StyleStatusBar(timer.Holder)

	timer.Bar = CreateFrame("StatusBar", nil, timer.Holder);
	timer.Bar:SetAllPointsIn(timer.Holder);
	timer.Bar:SetStatusBarTexture(SV.Media.bar.default)
	timer.Bar:SetStatusBarColor(0.5,0,1) --1,0.15,0.08
	timer.Bar:SetMinMaxValues(0, 1)
	timer.Bar:SetValue(0)

	timer.TimeLeft = timer.Bar:CreateFontString(nil,"OVERLAY");
	timer.TimeLeft:SetAllPointsIn(timer.Bar);
	timer.TimeLeft:SetFont(SV.Media.font.numbers, 12, "OUTLINE")
	timer.TimeLeft:SetTextColor(1,1,1)
	timer.TimeLeft:SetShadowOffset(-1,-1)
	timer.TimeLeft:SetShadowColor(0,0,0,0.5)
	timer.TimeLeft:SetJustifyH('CENTER')
	timer.TimeLeft:SetJustifyV('MIDDLE')
	timer.TimeLeft:SetText('')

	timer:SetHeight(1);
	timer:SetAlpha(0);

	return timer;
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
			objective:SetHeight(1);
			objective:SetAlpha(0);
			objective.Timer:SetAlpha(0);
			--objective:StopTimer();
		end
	end
	self:SetAlpha(0);
	self:SetHeight(1);
end

local GetObjectiveRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows];
		local yOffset = ((index * (INNER_HEIGHT)) - INNER_HEIGHT) + 1;

		local objective = CreateFrame("Frame", nil, self)
		objective:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -yOffset);
		objective:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, -yOffset);
		objective:SetHeightToScale(INNER_HEIGHT);

		objective.Icon = objective:CreateTexture(nil,"OVERLAY")
		objective.Icon:SetPoint("TOPLEFT", objective, "TOPLEFT", 4, -2);
		objective.Icon:SetPoint("BOTTOMLEFT", objective, "BOTTOMLEFT", 4, 2);
		objective.Icon:SetWidth(INNER_HEIGHT - 4);
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)

		objective.Timer = AddTimerFrame(objective);
		objective.StartTimer = StartTimer;
		objective.StopTimer = StopTimer;

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

local SetObjectiveRow = function(self, index, description, completed, duration, elapsed)
	index = index + 1;
	local objective = self:Get(index);

	if(completed) then
		objective.Text:SetTextColor(0.1,0.9,0.1)
		objective.Icon:SetTexture(OBJ_ICON_COMPLETE)
	else
		objective.Text:SetTextColor(1,1,1)
		objective.Icon:SetTexture(OBJ_ICON_INCOMPLETE)
	end

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

local GetAchievementRow = function(self, index)
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
		row.Badge.Icon:SetTexture(LINE_ACHIEVEMENT_ICON)
		row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		row.Header = CreateFrame("Frame", nil, row)
		row.Header:SetPoint("TOPLEFT", row.Badge, "TOPRIGHT", 2, 0);
		row.Header:SetPoint("TOPRIGHT", row, "TOPRIGHT", -2, 0);
		row.Header:SetHeightToScale(INNER_HEIGHT);
		row.Header.Text = row.Header:CreateFontString(nil,"OVERLAY")
		row.Header.Text:SetFont(SV.Media.font.roboto, 13, "NONE")
		row.Header.Text:SetTextColor(1,1,0)
		row.Header.Text:SetShadowOffset(-1,-1)
		row.Header.Text:SetShadowColor(0,0,0,0.5)
		row.Header.Text:SetJustifyH('LEFT')
		row.Header.Text:SetJustifyV('MIDDLE')
		row.Header.Text:SetText('')
		row.Header.Text:SetPoint("TOPLEFT", row.Header, "TOPLEFT", 4, 0);
		row.Header.Text:SetPoint("BOTTOMRIGHT", row.Header, "BOTTOMRIGHT", 0, 0);
		row.Button = CreateFrame("Button", nil, row.Header)
		row.Button:SetAllPoints(row.Header);
		row.Button:SetStylePanel("Button", "Headline", 1, 1, 1)
		row.Button:SetID(0)
		row.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		row.Button:SetScript("OnClick", ViewButton_OnClick)
		row.Objectives = CreateFrame("Frame", nil, row)
		row.Objectives:SetPoint("TOPLEFT", row, "BOTTOMLEFT", 0, 0);
		row.Objectives:SetPoint("TOPRIGHT", row, "BOTTOMRIGHT", 0, 0);
		row.Objectives:SetHeightToScale(1);
		row.Objectives.Rows = {}

		row.Objectives.Get = GetObjectiveRow;
		row.Objectives.Set = SetObjectiveRow;
		row.Objectives.SetTimer = SetObjectiveTimer;
		row.Objectives.Reset = ResetObjectiveBlock;

		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetAchievementRow = function(self, index, title, details, icon, achievementID)
	index = index + 1;
	icon = icon or LINE_ACHIEVEMENT_ICON;

	local fill_height = 0;
	local shown_objectives = 0;
	local objective_rows = 0;

	local row = self:Get(index);
	row.RowID = achievementID
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon);
	row.Badge:SetAlpha(1);
	row.Button:Enable();
	row.Button:SetID(achievementID);
	row:SetHeightToScale(ROW_HEIGHT);
	row:FadeIn();
	row.Header:FadeIn();

	local objective_block = row.Objectives;
	local subCount = GetAchievementNumCriteria(achievementID);

	for i = 1, subCount do
		local description, category, completed, quantity, totalQuantity, _, flags, assetID, quantityString, criteriaID, eligible, duration, elapsed = GetAchievementCriteriaInfo(achievementID, i);
		if(not ((not completed) and (shown_objectives > 5))) then
			if(shown_objectives == 5 and subCount > (6)) then
				shown_objectives = shown_objectives + 1;
			else
				if(description and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
					if(string.find(strlower(quantityString), "interface\\moneyframe")) then
						description = quantityString.."\n"..description;
					else
						description = string.gsub(quantityString, " / ", "/").." "..description;
					end
				else
					if(category == CRITERIA_TYPE_ACHIEVEMENT and assetID) then
						_, description = GetAchievementInfo(assetID);
					end
				end
				shown_objectives = shown_objectives + 1;					
			end
			objective_rows = objective_block:Set(objective_rows, description, completed, duration, elapsed)
			fill_height = fill_height + (INNER_HEIGHT + 2);
			if(duration and elapsed and elapsed < duration and (not completed)) then
				objective_rows = objective_block:SetTimer(objective_rows, duration, elapsed);
				fill_height = fill_height + (INNER_HEIGHT + 2);
			end
		end
	end

	if(objective_rows > 0) then
		objective_block:SetHeightToScale(fill_height);
		objective_block:FadeIn();
	end

	fill_height = fill_height + (ROW_HEIGHT + 2);

	return index, fill_height;
end

local RefreshAchievements = function(self, event, ...)
	local list = { GetTrackedAchievements() };
	local fill_height = 0;
	local rows = 0;

	if(#list > 0) then
		for i = 1, #list do
			local achievementID = list[i];
			local _, title, _, completed, _, _, _, details, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achievementID);
			if(not wasEarnedByMe) then
				local add_height = 0;
				rows, add_height = self:Set(rows, title, details, icon, achievementID)
				fill_height = fill_height + add_height
			end
		end
	end

	if(rows == 0 or (fill_height <= 1)) then
		self:SetHeight(1);
		self.Header.Text:SetText('');
		self.Header:SetAlpha(0);
		self:SetAlpha(0);
	else
		self:SetHeightToScale(fill_height + 2);
		self.Header.Text:SetText(TRACKER_HEADER_ACHIEVEMENTS);
		self:FadeIn();
		self.Header:FadeIn();
	end
end

local ResetAchievementBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Header:SetAlpha(0);
			row.Button:Disable();
			row.Button:SetID(0);
			row.Badge.Icon:SetTexture(NO_ICON);
			row.Badge:SetAlpha(0);
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
function MOD:UpdateAchievements(event, ...)
	self.Headers["Achievements"]:Reset()
	self.Headers["Achievements"]:Refresh(event, ...)
	self:UpdateDimensions();
end

local function UpdateAchievementLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateAchievementLocals", UpdateAchievementLocals);

function MOD:InitializeAchievements()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

    local achievements = CreateFrame("Frame", nil, scrollChild)
    achievements:SetWidth(ROW_WIDTH);
	achievements:SetHeightToScale(ROW_HEIGHT);
	achievements:SetPoint("TOPLEFT", self.Headers["Bonus"], "BOTTOMLEFT", 0, -6);

	achievements.Header = CreateFrame("Frame", nil, achievements)
	achievements.Header:SetPoint("TOPLEFT", achievements, "TOPLEFT", 2, -2);
	achievements.Header:SetPoint("TOPRIGHT", achievements, "TOPRIGHT", -2, -2);
	achievements.Header:SetHeightToScale(INNER_HEIGHT);

	achievements.Header.Text = achievements.Header:CreateFontString(nil,"OVERLAY")
	achievements.Header.Text:SetPoint("TOPLEFT", achievements.Header, "TOPLEFT", 2, 0);
	achievements.Header.Text:SetPoint("BOTTOMLEFT", achievements.Header, "BOTTOMLEFT", 2, 0);
	achievements.Header.Text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
	achievements.Header.Text:SetJustifyH('LEFT')
	achievements.Header.Text:SetJustifyV('MIDDLE')
	achievements.Header.Text:SetTextColor(1,0.6,0.1)
	achievements.Header.Text:SetShadowOffset(-1,-1)
	achievements.Header.Text:SetShadowColor(0,0,0,0.5)
	achievements.Header.Text:SetText(TRACKER_HEADER_ACHIEVEMENTS)

	achievements.Header.Divider = achievements.Header:CreateTexture(nil, 'BACKGROUND');
	achievements.Header.Divider:SetPoint("TOPLEFT", achievements.Header.Text, "TOPRIGHT", -10, 0);
	achievements.Header.Divider:SetPoint("BOTTOMRIGHT", achievements.Header, "BOTTOMRIGHT", 0, 0);
	achievements.Header.Divider:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DROPDOWN-DIVIDER]]);

	achievements.Rows = {};

	achievements.Get = GetAchievementRow;
	achievements.Set = SetAchievementRow;
	achievements.Refresh = RefreshAchievements;
	achievements.Reset = ResetAchievementBlock;

	self.Headers["Achievements"] = achievements;

	self:RegisterEvent("TRACKED_ACHIEVEMENT_UPDATE", self.UpdateAchievements);
	self:RegisterEvent("TRACKED_ACHIEVEMENT_LIST_CHANGED", self.UpdateAchievements);

	self.Headers["Achievements"]:Refresh()
end