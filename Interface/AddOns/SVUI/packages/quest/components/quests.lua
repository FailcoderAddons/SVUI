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
local abs, ceil, floor, round, maxNum = math.abs, math.ceil, math.floor, math.round, math.max;
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
local QUEST_ROW_HEIGHT = ROW_HEIGHT + 2;
local INNER_HEIGHT = ROW_HEIGHT - 4;
local LARGE_ROW_HEIGHT = ROW_HEIGHT * 2;
local LARGE_INNER_HEIGHT = LARGE_ROW_HEIGHT - 4;

local NO_ICON = [[Interface\AddOns\SVUI\assets\artwork\Template\EMPTY]];
local OBJ_ICON_ACTIVE = [[Interface\COMMON\Indicator-Yellow]];
local OBJ_ICON_COMPLETE = [[Interface\COMMON\Indicator-Green]];
local OBJ_ICON_INCOMPLETE = [[Interface\COMMON\Indicator-Gray]];

local QUEST_ICON = [[Interface\AddOns\SVUI\assets\artwork\Quest\QUEST-INCOMPLETE-ICON]];
local QUEST_ICON_COMPLETE = [[Interface\AddOns\SVUI\assets\artwork\Quest\QUEST-COMPLETE-ICON]];

local CACHED_QUESTS = {};
local USED_QUESTIDS = {};
local CURRENT_MAP_ID = 0;
local WORLDMAP_UPDATE = false;

local DEFAULT_COLOR = {r = 1, g = 0.68, b = 0.1}

local QuestInZone = {
	[14108] = 541,
	[13998] = 11,
	[25798] = 61,
	[25799] = 61,
	[25112] = 161,
	[25111] = 161,
	[24735] = 201,
};

local function UpdateCachedQuests()
	local s = 62500;
	local x = 1;
	local c = 0;
	local li = 0;

	local numWatch = GetNumQuestWatches();
	local numCache = #CACHED_QUESTS;
	local numItems = maxNum(numWatch, numCache)

	wipe(USED_QUESTIDS);
	wipe(CACHED_QUESTS);

	for i = 1, GetNumQuestWatches() do
		local questID, _, questLogIndex, numObjectives, _, completed, _, _, duration, elapsed, questType, isTask, isStory, isOnMap, hasLocalPOI = GetQuestWatchInfo(i);
		if(questID and (not USED_QUESTIDS[questID])) then
			local title, level, suggestedGroup = GetQuestLogTitle(questLogIndex)
			local link, texture, _, showCompleted = GetQuestLogSpecialItemInfo(questLogIndex)
			local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)
			local mapID, floorNumber = 0,0
			if(not WorldMapFrame:IsShown()) then
				mapID, floorNumber = GetQuestWorldMapAreaID(questID)
			else
				WORLDMAP_UPDATE = true;
			end
			if(QuestHasPOIInfo(questID)) then
				local areaID = QuestInZone[questID]
				if(areaID and (areaID == CURRENT_MAP_ID)) then
					c = x
					li = questLogIndex
				elseif(onContinent and (distanceSq < s)) then
					s = distanceSq
					c = x
					li = questLogIndex
				end
			end

			if(not CACHED_QUESTS[x]) then
				CACHED_QUESTS[x] = { 0, false, 0, 0, 0, false, {"", 100, QUEST_ICON, 0, 0, 0, 0, 0, false, 0} };
			end

			CACHED_QUESTS[x][1] = i;				-- quest watch index
			CACHED_QUESTS[x][2] = link;				-- quest item link
			CACHED_QUESTS[x][3] = mapID;			-- quest location map id
			CACHED_QUESTS[x][4] = floorNumber;		-- quest location floor number
			CACHED_QUESTS[x][5] = distanceSq;		-- quest distance from player
			CACHED_QUESTS[x][6] = false;			-- quest closest to player
			CACHED_QUESTS[x][7][1] = title;			-- args: quest title
			CACHED_QUESTS[x][7][2] = level;			-- args: quest level
			CACHED_QUESTS[x][7][3] = texture;		-- args: quest item icon
			CACHED_QUESTS[x][7][4] = questID;		-- args: quest id
			CACHED_QUESTS[x][7][5] = questLogIndex;	-- args: quest log index
			CACHED_QUESTS[x][7][6] = numObjectives;	-- args: quest objective count
			CACHED_QUESTS[x][7][7] = duration;		-- args: quest timer duration
			CACHED_QUESTS[x][7][8] = elapsed;		-- args: quest timer elapsed
			CACHED_QUESTS[x][7][9] = completed;		-- args: quest is completed
			CACHED_QUESTS[x][7][10] = questType;	-- args: quest type

			USED_QUESTIDS[questID] = true;

			x = x + 1;
		end
	end

	if(c ~= 0 and CACHED_QUESTS[c]) then
		CACHED_QUESTS[c][6] = true;
		MOD.ClosestQuest = li;
	end

	tsort(CACHED_QUESTS, function(a,b) 
		if(a[5] and b[5]) then
			return a[5] < b[5] 
		else
			return false
		end
	end);
end

local function UpdateCachedDistance()
	local s = 62500;
	local c = 0;
	local li = 0;

	for i = 1, #CACHED_QUESTS do
		local data = CACHED_QUESTS[i][7];
		local questID = data[4];
		local questLogIndex = data[5];
		local distanceSq, onContinent = GetDistanceSqToQuest(questLogIndex)

		if(QuestHasPOIInfo(questID)) then
			local areaID = QuestInZone[questID]
			if(areaID and (areaID == CURRENT_MAP_ID)) then
				c = i
				li = questLogIndex
			elseif(onContinent and (distanceSq < s)) then
				s = distanceSq
				c = i
				li = questLogIndex
			end
		end

		CACHED_QUESTS[i][5] = distanceSq;		-- quest distance from player
		CACHED_QUESTS[i][6] = false;			-- quest closest to player
	end

	if(c ~= 0 and CACHED_QUESTS[c]) then
		CACHED_QUESTS[c][6] = true;
		MOD.ClosestQuest = li;
	end

	tsort(CACHED_QUESTS, function(a,b) 
		if(a[5] and b[5]) then
			return a[5] < b[5] 
		else
			return false
		end
	end);
end
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
			if(IsQuestComplete(questID) and GetQuestLogIsAutoComplete(questIndex)) then
				AutoQuestPopupTracker_RemovePopUp(questID);
				ShowQuestComplete(questIndex);
			else
				QuestLogPopupDetailFrame_Show(questIndex);
			end
		elseif(questID) then
			if(IsShiftKeyDown()) then
				QuestMapFrame_OpenToQuestDetails(questID);
			else
				RemoveQuestWatch(questIndex);
				if(questID == superTrackedQuestID) then
					QuestSuperTracking_OnQuestUntracked();
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

local GetQuestRow = function(self, index)
	if(not self.Rows[index]) then 
		local previousFrame = self.Rows[#self.Rows]
		local index = #self.Rows + 1;
		local yOffset = 0;

		local anchorFrame;
		if(previousFrame and previousFrame.Objectives) then
			anchorFrame = previousFrame.Objectives;
			yOffset = -6;
		else
			anchorFrame = self.Header;
		end

		local row = CreateFrame("Frame", nil, self)
		row:SetPoint("TOPLEFT", anchorFrame, "BOTTOMLEFT", 0, yOffset);
		row:SetPoint("TOPRIGHT", anchorFrame, "BOTTOMRIGHT", 0, yOffset);
		row:SetHeightToScale(QUEST_ROW_HEIGHT);

		row.Badge = CreateFrame("Frame", nil, row)
		row.Badge:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0);
		row.Badge:SetSizeToScale(QUEST_ROW_HEIGHT, QUEST_ROW_HEIGHT);
		row.Badge:SetStylePanel("Default", "Headline")

		row.Badge.Icon = row.Badge:CreateTexture(nil,"OVERLAY")
		row.Badge.Icon:SetAllPoints(row.Badge);
		row.Badge.Icon:SetTexture(QUEST_ICON)
		row.Badge.Icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)

		row.Badge.Button = CreateFrame("Button", nil, row.Badge)
		row.Badge.Button:SetAllPoints(row.Badge);
		row.Badge.Button:SetStylePanel("Button", true, 1, 1, 1)
		row.Badge.Button:SetID(0)
		row.Badge.Button.Icon = row.Badge.Icon;
		row.Badge.Button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		row.Badge.Button:SetScript("OnClick", ActiveButton_OnClick)

		row.Header = CreateFrame("Frame", nil, row)
		row.Header:SetPoint("TOPLEFT", row, "TOPLEFT", (QUEST_ROW_HEIGHT + 6), 0);
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
		row.Button:SetScript("OnClick", ViewButton_OnClick);

		row.Timer = CreateFrame("Frame", nil, row)
		row.Timer:SetPointToScale("TOPLEFT", row, "BOTTOMLEFT", 0, 4);
		row.Timer:SetPointToScale("TOPRIGHT", row, "BOTTOMRIGHT", 0, 4);
		row.Timer:SetHeightToScale(INNER_HEIGHT);

		row.Timer.Bar = CreateFrame("StatusBar", nil, row.Timer);
		row.Timer.Bar:SetPointToScale("TOPLEFT", row.Timer, "TOPLEFT", 4, -2);
		row.Timer.Bar:SetPointToScale("BOTTOMRIGHT", row.Timer, "BOTTOMRIGHT", -4, 2);
		row.Timer.Bar:SetStatusBarTexture(SV.Media.bar.default)
		row.Timer.Bar:SetStatusBarColor(0.5,0,1) --1,0.15,0.08
		row.Timer.Bar:SetMinMaxValues(0, 1)
		row.Timer.Bar:SetValue(0)
		
		local bgFrame = CreateFrame("Frame", nil, row.Timer.Bar)
		bgFrame:SetAllPointsIn(row.Timer.Bar, -2, -2)
		bgFrame:SetFrameLevel(bgFrame:GetFrameLevel() - 1)
		
		bgFrame.bg = bgFrame:CreateTexture(nil, "BACKGROUND")
		bgFrame.bg:SetAllPoints(bgFrame)
		bgFrame.bg:SetTexture(SV.Media.bar.default)
	  	bgFrame.bg:SetVertexColor(0,0,0,0.5)

		local borderB = bgFrame:CreateTexture(nil,"OVERLAY")
		borderB:SetTexture(0,0,0)
		borderB:SetPoint("BOTTOMLEFT")
		borderB:SetPoint("BOTTOMRIGHT")
		borderB:SetHeight(2)

		local borderT = bgFrame:CreateTexture(nil,"OVERLAY")
		borderT:SetTexture(0,0,0)
		borderT:SetPoint("TOPLEFT")
		borderT:SetPoint("TOPRIGHT")
		borderT:SetHeight(2)

		local borderL = bgFrame:CreateTexture(nil,"OVERLAY")
		borderL:SetTexture(0,0,0)
		borderL:SetPoint("TOPLEFT")
		borderL:SetPoint("BOTTOMLEFT")
		borderL:SetWidth(2)

		local borderR = bgFrame:CreateTexture(nil,"OVERLAY")
		borderR:SetTexture(0,0,0)
		borderR:SetPoint("TOPRIGHT")
		borderR:SetPoint("BOTTOMRIGHT")
		borderR:SetWidth(2)

		row.Timer.TimeLeft = row.Timer.Bar:CreateFontString(nil,"OVERLAY");
		row.Timer.TimeLeft:SetAllPointsIn(row.Timer.Bar);
		row.Timer.TimeLeft:SetFont(SV.Media.font.numbers, 12, "OUTLINE")
		row.Timer.TimeLeft:SetTextColor(1,1,1)
		row.Timer.TimeLeft:SetShadowOffset(-1,-1)
		row.Timer.TimeLeft:SetShadowColor(0,0,0,0.5)
		row.Timer.TimeLeft:SetJustifyH('CENTER')
		row.Timer.TimeLeft:SetJustifyV('MIDDLE')
		row.Timer.TimeLeft:SetText('')

		row.Timer:SetHeight(1);
		row.Timer:SetAlpha(0);

		row.StartTimer = StartTimer;
		row.StopTimer = StopTimer;

		row.Objectives = MOD:NewObjectiveHeader(row);
		row.Objectives:SetPoint("TOPLEFT", row.Timer, "BOTTOMLEFT", 0, 0);
		row.Objectives:SetPoint("TOPRIGHT", row.Timer, "BOTTOMRIGHT", 0, 0);
		row.Objectives:SetHeight(1);

		row.RowID = 0;
		self.Rows[index] = row;
		return row;
	end

	return self.Rows[index];
end

local SetQuestRow = function(self, index, watchIndex, title, level, icon, questID, questLogIndex, subCount, duration, elapsed, completed, questType)
	index = index + 1;

	local fill_height = 0;
	local iscomplete = true;
	local objective_rows = 0;
	local row = self:Get(index);

	if(not icon) then
		icon = completed and QUEST_ICON_COMPLETE or QUEST_ICON
	end
	local color = DEFAULT_COLOR
	if(level and type(level) == 'number') then
		color = GetQuestDifficultyColor(level);
	end

	row.RowID = questID

	row.Header:SetAlpha(1);
	row.Header.Zone:SetText('')
	row.Header.Level:SetTextColor(color.r, color.g, color.b)
	row.Header.Level:SetText(level)
	row.Header.Text:SetTextColor(color.r, color.g, color.b)
	row.Header.Text:SetText(title)
	row.Badge.Icon:SetTexture(icon);
	row.Badge.Button:Enable();
	row.Badge.Button:SetID(watchIndex);
	row.Badge:SetAlpha(1);
	row.Button:Enable();
	row.Button:SetID(questLogIndex);
	row:SetHeightToScale(QUEST_ROW_HEIGHT);
	row:FadeIn();

	local objective_block = row.Objectives;
	objective_block:Reset();

	for i = 1, subCount do
		local description, category, objective_completed = GetQuestObjectiveInfo(questID, i);
		if not objective_completed then iscomplete = false end
		if(description) then
			fill_height = fill_height + (INNER_HEIGHT + 2);
			objective_rows = objective_block:SetInfo(objective_rows, description, objective_completed);
		end
	end

	if(duration) then
		if(elapsed and elapsed < duration) then
			fill_height = fill_height + (INNER_HEIGHT + 2);
			row:StartTimer(duration, elapsed)
		end
	end

	if(objective_rows > 0) then
		objective_block:SetHeightToScale(fill_height);
		objective_block:FadeIn();
	end

	if(iscomplete) then MOD.QuestItem:RemoveItem(questLogIndex) end

	fill_height = fill_height + (QUEST_ROW_HEIGHT + 6);

	return index, fill_height;
end

local SetZoneHeader = function(self, index, mapID)
	index = index + 1;
	local row = self:Get(index);
	row.Header.Level:SetText('');
	row.Header.Text:SetText('');
	row.Badge.Icon:SetTexture(NO_ICON);
	row.Badge.Button:SetID(0);
	row.Badge:SetAlpha(0);
	row.Button:SetID(0);
	row.Button:Disable();
	row.Button:SetAlpha(0);
	row.Badge.Button:Disable();
	if(not mapID or (mapID and mapID == 0)) then 
		return index, 4
	end
	local zoneName = GetMapNameByID(mapID);
--0.75,0.31,1
	row.Header.Zone:SetTextColor(1,0.31,0.1)

	row.RowID = mapID;
	row.Header.Zone:SetText(zoneName);
	row:SetHeightToScale(ROW_HEIGHT);
	row:SetAlpha(1);

	local objective_block = row.Objectives;
	objective_block:Reset();
	return index, mapID;
end

local RefreshQuests = function(self, event, ...)
	local rows = 0;
	local fill_height = 0;
	local zone = 0;

	for i = 1, #CACHED_QUESTS do
		local quest = CACHED_QUESTS[i];
		local args = quest[7];
		if(quest[1] ~= 0 and args[4] ~= 0) then
			local add_height = 0;
			if(not WorldMapFrame:IsShown()) then
				if(quest[6] and (not args[9]) and (MOD.CurrentQuest == 0)) then
					rows, zone = self:SetZone(rows, quest[3]);
					fill_height = fill_height + QUEST_ROW_HEIGHT;
					rows, add_height = self:Set(rows, quest[1], unpack(args))
					fill_height = fill_height + add_height;
					if(quest[2] and quest[2] ~= '') then
						MOD.QuestItem:SetItem(quest[2], args[3], unpack(args))
					end
				end
			end

			if(not MOD:CheckActiveQuest(nil, unpack(args))) then
				if(zone ~= quest[3]) then
					rows, zone = self:SetZone(rows, quest[3]);
					fill_height = fill_height + QUEST_ROW_HEIGHT;
				end
				rows, add_height = self:Set(rows, quest[1], unpack(args))
				fill_height = fill_height + add_height;
			end
		end
	end

	if(rows == 0 or (fill_height <= 1)) then
		self:SetHeight(1);
		self:SetAlpha(0);
	else
		self:SetHeightToScale(fill_height + 2);
		self:FadeIn();
	end
end

local ResetQuestBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.RowID = 0;
			row.Header.Text:SetText('');
			row.Header:SetAlpha(0);
			row.Header.Zone:SetText('');
			row.Button:SetID(0);
			row.Button:Disable();
			row.Badge.Button:SetID(0);
			row.Badge.Icon:SetTexture(NO_ICON);
			row.Badge:SetAlpha(0);
			row.Badge.Button:Disable();
			row:SetHeight(1);
			row:SetAlpha(0);
			row.Objectives:Reset();
		end
	end
end

local LiteResetQuestBlock = function(self)
	for x = 1, #self.Rows do
		local row = self.Rows[x]
		if(row) then
			row.Objectives:Reset(true);
		end
	end
end

local _hook_WorldMapFrameOnHide = function()
	if(not WORLDMAP_UPDATE) then return end
	UpdateCachedQuests();
	MOD.Headers["Quests"]:Reset()
	MOD.Headers["Quests"]:Refresh()
	MOD:UpdateDimensions();
end
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:UpdateObjectives(event, ...)
	if(event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA") then
		CURRENT_MAP_ID = GetCurrentMapAreaID();
		UpdateCachedDistance();
		self.Headers["Quests"]:LiteReset()
	else
		self.Headers["Quests"]:Reset()
		if(event == "QUEST_ACCEPTED" and (AUTO_QUEST_WATCH == "1")) then
			local questLogIndex, questID = ...;
			AddQuestWatch(questLogIndex);
			QuestSuperTracking_OnQuestTracked(questID);
		elseif(event == "QUEST_TURNED_IN") then
			local questID, XP, Money = ...
			self:CheckActiveQuest(questID)
		else
			self:UpdateBonusObjective(event, ...)
		end
		UpdateCachedQuests();
	end
	self.Headers["Quests"]:Refresh(event, ...)
	self:UpdateDimensions();
end

local function UpdateQuestLocals(...)
	ROW_WIDTH, ROW_HEIGHT, INNER_HEIGHT, LARGE_ROW_HEIGHT, LARGE_INNER_HEIGHT = ...;
	QUEST_ROW_HEIGHT = ROW_HEIGHT + 2;
end

SV.Events:On("QUEST_UPVALUES_UPDATED", "UpdateQuestLocals", UpdateQuestLocals);

function MOD:InitializeQuests()
	local scrollChild = self.Docklet.ScrollFrame.ScrollChild;

	local quests = CreateFrame("Frame", nil, scrollChild)
	quests:SetWidth(ROW_WIDTH);
	quests:SetHeightToScale(ROW_HEIGHT);
	quests:SetPoint("TOPLEFT", self.Headers["Bonus"], "BOTTOMLEFT", 0, -4);
	--quests:SetStylePanel()

	quests.Header = CreateFrame("Frame", nil, quests)
	quests.Header:SetPoint("TOPLEFT", quests, "TOPLEFT", 2, -2);
	quests.Header:SetPoint("TOPRIGHT", quests, "TOPRIGHT", -2, -2);
	quests.Header:SetHeightToScale(INNER_HEIGHT);

	quests.Header.Text = quests.Header:CreateFontString(nil,"OVERLAY")
	quests.Header.Text:SetPoint("TOPLEFT", quests.Header, "TOPLEFT", 2, 0);
	quests.Header.Text:SetPoint("BOTTOMLEFT", quests.Header, "BOTTOMLEFT", 2, 0);
	quests.Header.Text:SetFont(SV.Media.font.dialog, 16, "OUTLINE")
	quests.Header.Text:SetJustifyH('LEFT')
	quests.Header.Text:SetJustifyV('MIDDLE')
	quests.Header.Text:SetTextColor(0.28,0.75,1)
	quests.Header.Text:SetShadowOffset(-1,-1)
	quests.Header.Text:SetShadowColor(0,0,0,0.5)
	quests.Header.Text:SetText(TRACKER_HEADER_QUESTS)

	quests.Header.Divider = quests.Header:CreateTexture(nil, 'BACKGROUND');
	quests.Header.Divider:SetPoint("TOPLEFT", quests.Header.Text, "TOPRIGHT", -10, 0);
	quests.Header.Divider:SetPoint("BOTTOMRIGHT", quests.Header, "BOTTOMRIGHT", 0, 0);
	quests.Header.Divider:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DROPDOWN-DIVIDER]]);

	quests.Rows = {};

	quests.Get = GetQuestRow;
	quests.Set = SetQuestRow;
	quests.SetZone = SetZoneHeader;
	quests.Refresh = RefreshQuests;
	quests.Reset = ResetQuestBlock;
	quests.LiteReset = LiteResetQuestBlock;

	self.Headers["Quests"] = quests;

	self:RegisterEvent("QUEST_LOG_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_WATCH_LIST_CHANGED", self.UpdateObjectives);
	self:RegisterEvent("QUEST_ACCEPTED", self.UpdateObjectives);	
	self:RegisterEvent("QUEST_POI_UPDATE", self.UpdateObjectives);
	self:RegisterEvent("QUEST_TURNED_IN", self.UpdateObjectives);

	self:RegisterEvent("ZONE_CHANGED_NEW_AREA", self.UpdateObjectives);
	self:RegisterEvent("ZONE_CHANGED", self.UpdateObjectives);

	self.Headers["Quests"]:Refresh()

	WorldMapFrame:HookScript("OnHide", _hook_WorldMapFrameOnHide)
end