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
local LINE_ACHIEVEMENT_ICON = [[Interface\ICONS\Achievement_General]];

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
HELPERS
##########################################################
]]--
local function NewAchievementRow(parent, lineNumber)
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
	row.Badge.Icon:SetTexture(LINE_ACHIEVEMENT_ICON)
	row.Badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	row.Header = CreateFrame("Frame", nil, row)
	row.Header:SetPoint("TOPLEFT", row.Badge, "TOPRIGHT", 2, 0);
	row.Header:SetPoint("TOPRIGHT", row, "TOPRIGHT", -2, 0);
	row.Header:SetHeight(INNER_HEIGHT);
	--row.Header:SetStylePanel("Default", "Headline")

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
	row.Objectives:SetHeight(1);

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
local AddAchievementRow = function(self, index, title, details, icon, achievementID)
	local objectivesShown = 0;
	local nextObjective = 1;

	local row = self.Rows[index];
	if(not row) then
		self.Rows[index] = NewAchievementRow(self, index)
		row = self.Rows[index]
		row.RowID = achievementID
	end

	icon = icon or LINE_ACHIEVEMENT_ICON;

	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon)
	row.Button:SetID(achievementID)
	row:Show()

	local objectives = row.Objectives;

	local totalObjectives = GetAchievementNumCriteria(achievementID);

	for i = 1, totalObjectives do
		local description, category, completed, quantity, totalQuantity, _, flags, assetID, quantityString, criteriaID, eligible, duration, elapsed = GetAchievementCriteriaInfo(achievementID, i);
		if(not ((not completed) and (objectivesShown > 5))) then
			if(objectivesShown == 5 and totalObjectives > (6)) then
				objectivesShown = objectivesShown + 1;
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
				objectivesShown = objectivesShown + 1;					
			end

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

local RefreshAchievements = function(self, event, ...)
	local trackedAchievements = { GetTrackedAchievements() };
	local liveLines = #trackedAchievements;
	local totalObjectives = 0;
	local nextLine = 1;

	if(liveLines > 0) then
		for i = 1, liveLines do
			local achievementID = trackedAchievements[i];
			local _, title, _, completed, _, _, _, details, _, icon, _, _, wasEarnedByMe = GetAchievementInfo(achievementID);
			if(not wasEarnedByMe) then
				local newCount = self:Add(i, title, details, icon, achievementID)
				totalObjectives = totalObjectives + newCount
				nextLine = nextLine + 1;
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
			if(row:IsShown()) then
				row:Hide()
			end
		end
	end

	local newHeight = (liveLines * (ROW_HEIGHT + 2)) + (totalObjectives * (INNER_HEIGHT + 2)) + (ROW_HEIGHT + (liveLines * 2));
	self:SetHeight(newHeight);
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateAchievements(event, ...)
	self.Achievements:Refresh(event, ...)
	self.Tracker:Refresh()
end

local function UpdateAchievementLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateAchievementLocals", UpdateAchievementLocals);

function MOD:InitializeAchievements()
	local scrollChild = self.Tracker.ScrollFrame.ScrollChild;

    local achievements = CreateFrame("Frame", nil, scrollChild)
    achievements:SetWidth(ROW_WIDTH);
	achievements:SetHeight(ROW_HEIGHT);
	achievements:SetPoint("TOPLEFT", self.Bonus, "BOTTOMLEFT", 0, 0);

	achievements.Header = CreateFrame("Frame", nil, achievements)
	achievements.Header:SetPoint("TOPLEFT", achievements, "TOPLEFT", 2, -2);
	achievements.Header:SetPoint("TOPRIGHT", achievements, "TOPRIGHT", -2, -2);
	achievements.Header:SetHeight(INNER_HEIGHT);

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

	achievements.Add = AddAchievementRow;
	achievements.Refresh = RefreshAchievements;

	self.Achievements = achievements;

	self:RegisterEvent("TRACKED_ACHIEVEMENT_UPDATE", self.UpdateAchievements);
	self:RegisterEvent("TRACKED_ACHIEVEMENT_LIST_CHANGED", self.UpdateAchievements);

	self.Achievements:Refresh()
end