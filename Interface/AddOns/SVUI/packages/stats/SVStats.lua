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
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local string    = _G.string;
local math      = _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local join, len = string.join, string.len;
--[[ MATH METHODS ]]--
local min = math.min;
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local LSM = LibStub("LibSharedMedia-3.0")
local LDB = LibStub("LibDataBroker-1.1", true)
local MOD = SV:NewPackage("SVStats", L["Statistics"]);

MOD.Anchors = {};
MOD.Statistics = {};
MOD.DisabledList = {};
MOD.StatListing = {[""] = "None"};
MOD.tooltip = CreateFrame("GameTooltip", "StatisticTooltip", UIParent, "GameTooltipTemplate")
MOD.BGPanels = {
	["SVUI_DockTopCenterLeft"] = {left = "Honor", middle = "Kills", right = "Assists"},
	["SVUI_DockTopCenterRight"] = {left = "Damage", middle = "Healing", right = "Deaths"}
};
MOD.BGStats = {
	["Name"] = {1, NAME}, 
	["Kills"] = {2, KILLS},
	["Assists"] = {3, PET_ASSIST},
	["Deaths"] = {4, DEATHS},
	["Honor"] = {5, HONOR},
	["Faction"] = {6, FACTION},
	["Race"] = {7, RACE},
	["Class"] = {8, CLASS},
	["Damage"] = {10, DAMAGE},
	["Healing"] = {11, SHOW_COMBAT_HEALING},
	["Rating"] = {12, BATTLEGROUND_RATING},
	["Changes"] = {13, RATING_CHANGE},
	["Spec"] = {16, SPECIALIZATION}
};
MOD.ListNeedsUpdate = true
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local playerName = UnitName("player");
local playerRealm = GetRealmName();
local BGStatString = "%s: %s"
local myName = UnitName("player");
local myClass = select(2,UnitClass("player"));
local classColor = RAID_CLASS_COLORS[myClass];
local SCORE_CACHE = {};
local hexHighlight = "FFFFFF";
local StatMenuListing = {}
-- When its vertical then "left" = "top" and "right" = "bottom". Yes I know thats ghetto, bite me!
local positionIndex = {{"middle", "left", "right"}, {"middle", "top", "bottom"}};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function GrabPlot(parent, slot, max)
	if max == 1 then 
		return"CENTER", parent, "CENTER"
	else
		if(parent.vertical) then
			if slot == 1 then 
				return "CENTER", parent, "CENTER"
			elseif slot == 2 then 
				return "BOTTOM", parent.holders["middle"], "TOP", 0, 4 
			elseif slot == 3 then 
				return "TOP", parent.holders["middle"], "BOTTOM", 0, -4 
			end
		else
			if slot == 1 then 
				return "CENTER", parent, "CENTER"
			elseif slot == 2 then 
				return "RIGHT", parent.holders["middle"], "LEFT", -4, 0 
			elseif slot == 3 then 
				return "LEFT", parent.holders["middle"], "RIGHT", 4, 0 
			end
		end 
	end 
end

local UpdateAnchor = function()
	local backdrops, width, height = SV.db.SVStats.showBackground
	for _, anchor in pairs(MOD.Anchors) do
		local numPoints = anchor.numPoints
		if(anchor.vertical) then
			width = anchor:GetWidth() - 4;
			height = anchor:GetHeight() / numPoints - 4;
		else
			width = anchor:GetWidth() / numPoints - 4;
			height = anchor:GetHeight() - 4;
			if(backdrops) then
				height = height + 6
			end
		end

		for i = 1, numPoints do 
			local this = positionIndex[anchor.useIndex][i]
			anchor.holders[this]:Width(width)
			anchor.holders[this]:Height(height)
			anchor.holders[this]:Point(GrabPlot(anchor, i, numPoints))
		end 
	end 
end

local _hook_TooltipOnShow = function(self)
	self:SetBackdrop({
		bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
		edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
		tile = false, 
		edgeSize = 1
		})
	self:SetBackdropColor(0, 0, 0, 0.8)
	self:SetBackdropBorderColor(0, 0, 0)
end 

local function TruncateString(value)
	if value >= 1e9 then 
		return ("%.1fb"):format(value/1e9):gsub("%.?0+([kmb])$","%1")
	elseif value >= 1e6 then 
		return ("%.1fm"):format(value/1e6):gsub("%.?0+([kmb])$","%1")
	elseif value >= 1e3 or value <= -1e3 then 
		return ("%.1fk"):format(value/1e3):gsub("%.?0+([kmb])$","%1")
	else 
		return value 
	end 
end 
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:Tip(stat)
	local parent = stat:GetParent()
	MOD.tooltip:Hide()
	MOD.tooltip:SetOwner(parent, parent.anchor)
	MOD.tooltip:ClearLines()
	GameTooltip:Hide()
end 

function MOD:ShowTip(noSpace)
	if(not noSpace) then
		MOD.tooltip:AddLine(" ")
	end
	MOD.tooltip:AddDoubleLine("[Alt + Click]", "Swap Stats", 0, 1, 0, 0.5, 1, 0.5)
	MOD.tooltip:Show()
end 

function MOD:NewAnchor(parent, maxCount, tipAnchor, isTop, customTemplate, isVertical)
	self.ListNeedsUpdate = true

	local activeIndex = isVertical and 2 or 1
	local template, strata

	if(customTemplate) then
		template = customTemplate
		strata = "LOW"
	else
		template = isTop and "FramedTop" or "FramedBottom"
		strata = "MEDIUM"
	end

	local parentName = parent:GetName();

	MOD.Anchors[parentName] = parent;
	parent.holders = {};
	parent.vertical = isVertical;
	parent.numPoints = maxCount;
	parent.anchor = tipAnchor;
	parent.useIndex = activeIndex

	local statName = parentName .. 'StatSlot';

	for i = 1, maxCount do 
		local position = positionIndex[activeIndex][i]
		if not parent.holders[position] then
			parent.holders[position] = CreateFrame("Button", statName..i, parent)
			parent.holders[position]:RegisterForClicks("AnyUp")
			parent.holders[position].barframe = CreateFrame("Frame", nil, parent.holders[position])
			if(SV.db.SVStats.showBackground) then
				parent.holders[position].barframe:Point("TOPLEFT", parent.holders[position], "TOPLEFT", 24, -2)
				parent.holders[position].barframe:Point("BOTTOMRIGHT", parent.holders[position], "BOTTOMRIGHT", -2, 2)
				if(customTemplate) then
					parent.holders[position]:SetFixedPanelTemplate(template)
				else
					parent.holders[position]:SetFramedButtonTemplate(template)
				end
			else
				parent.holders[position].barframe:Point("TOPLEFT", parent.holders[position], "TOPLEFT", 24, 2)
				parent.holders[position].barframe:Point("BOTTOMRIGHT", parent.holders[position], "BOTTOMRIGHT", 2, -2)
				parent.holders[position].barframe.bg = parent.holders[position].barframe:CreateTexture(nil, "BORDER")
				parent.holders[position].barframe.bg:FillInner(parent.holders[position].barframe, 2, 2)
				parent.holders[position].barframe.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
				parent.holders[position].barframe.bg:SetGradient(unpack(SV.Media.gradient.dark))
			end
			parent.holders[position].barframe:SetFrameLevel(parent.holders[position]:GetFrameLevel()-1)
			parent.holders[position].barframe:SetBackdrop({
				bgFile = [[Interface\BUTTONS\WHITE8X8]], 
				edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
				tile = false, 
				tileSize = 0, 
				edgeSize = 2, 
				insets = {left = 0, right = 0, top = 0, bottom = 0}
				})
			parent.holders[position].barframe:SetBackdropColor(0, 0, 0, 0.5)
			parent.holders[position].barframe:SetBackdropBorderColor(0, 0, 0, 0.8)
			parent.holders[position].barframe.icon = CreateFrame("Frame", nil, parent.holders[position].barframe)
			parent.holders[position].barframe.icon:Point("TOPLEFT", parent.holders[position], "TOPLEFT", 0, 6)
			parent.holders[position].barframe.icon:Point("BOTTOMRIGHT", parent.holders[position], "BOTTOMLEFT", 26, -6)
			parent.holders[position].barframe.icon.texture = parent.holders[position].barframe.icon:CreateTexture(nil, "OVERLAY")
			parent.holders[position].barframe.icon.texture:FillInner(parent.holders[position].barframe.icon, 2, 2)
			parent.holders[position].barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\PLACEHOLDER")
			parent.holders[position].barframe.bar = CreateFrame("StatusBar", nil, parent.holders[position].barframe)
			parent.holders[position].barframe.bar:FillInner(parent.holders[position].barframe, 2, 2)
			parent.holders[position].barframe.bar:SetStatusBarTexture(SV.Media.bar.default)
				
			parent.holders[position].barframe.bar.extra = CreateFrame("StatusBar", nil, parent.holders[position].barframe.bar)
			parent.holders[position].barframe.bar.extra:SetAllPoints()
			parent.holders[position].barframe.bar.extra:SetStatusBarTexture(SV.Media.bar.default)
			parent.holders[position].barframe.bar.extra:Hide()
			parent.holders[position].barframe:Hide()
			parent.holders[position].textframe = CreateFrame("Frame", nil, parent.holders[position])
			parent.holders[position].textframe:SetAllPoints(parent.holders[position])
			parent.holders[position].textframe:SetFrameStrata(strata)
			parent.holders[position].text = parent.holders[position].textframe:CreateFontString(nil, "OVERLAY", nil, 7)
			parent.holders[position].text:SetAllPoints()
			if(SV.db.SVStats.showBackground) then
				parent.holders[position].text:FontManager(LSM:Fetch("font", SV.db.SVStats.font), SV.db.SVStats.fontSize, "NONE", "CENTER", "MIDDLE")
				parent.holders[position].text:SetShadowColor(0, 0, 0, 0.5)
				parent.holders[position].text:SetShadowOffset(2, -4)
			else
				parent.holders[position].text:FontManager(LSM:Fetch("font", SV.db.SVStats.font), SV.db.SVStats.fontSize, SV.db.SVStats.fontOutline)
				parent.holders[position].text:SetJustifyH("CENTER")
				parent.holders[position].text:SetJustifyV("MIDDLE")
			end
		end
		parent.holders[position].SlotKey = statName..i;
		parent.holders[position].TokenKey = 738;
		parent.holders[position].MenuList = {};
		parent.holders[position].TokenList = {};
		parent.holders[position]:Point(GrabPlot(parent, i, maxCount))
	end 
	parent:SetScript("OnSizeChanged", UpdateAnchor)
	UpdateAnchor(parent)
end 

function MOD:Extend(newStat, eventList, onEvents, update, click, focus, blur, init)
	if not newStat then return end 
	self.Statistics[newStat] = {}
	self.StatListing[newStat] = newStat
	tinsert(StatMenuListing, newStat)
	if type(eventList) == "table" then 
		self.Statistics[newStat]["events"] = eventList;
		self.Statistics[newStat]["event_handler"] = onEvents 
	end 
	if update and type(update) == "function" then 
		self.Statistics[newStat]["update_handler"] = update 
	end 
	if click and type(click) == "function" then 
		self.Statistics[newStat]["click_handler"] = click 
	end 
	if focus and type(focus) == "function" then 
		self.Statistics[newStat]["focus_handler"] = focus 
	end 
	if blur and type(blur) == "function" then 
		self.Statistics[newStat]["blur_handler"] = blur 
	end 
	if init and type(init) == "function" then 
		self.Statistics[newStat]["init_handler"] = init 
	end 
end

do
	local dataStrings = {
		NAME, 
		KILLING_BLOWS,
		HONORABLE_KILLS,
		DEATHS,
		HONOR,
		FACTION,
		RACE,
		CLASS,
		"None",
		DAMAGE,
		SHOW_COMBAT_HEALING,
		BATTLEGROUND_RATING,
		RATING_CHANGE,
		"None",
		"None",
		SPECIALIZATION
	};

	local Stat_OnLeave = function()
		MOD.tooltip:Hide()
	end

	local Parent_OnClick = function(self, button)
		if IsAltKeyDown() then
			SV.Dropdown:Open(self, self.MenuList);
		elseif(self.onClick) then
			self.onClick(self, button);
		end
	end

	local function _load(parent, name, config)
		parent.StatParent = name

		if config["init_handler"]then 
			config["init_handler"](parent)
		end

		if config["events"]then 
			for _, event in pairs(config["events"])do 
				parent:RegisterEvent(event)
			end 
		end 

		if config["event_handler"]then 
			parent:SetScript("OnEvent", config["event_handler"])
			config["event_handler"](parent, "SVUI_FORCE_RUN")
		end 

		if config["update_handler"]then 
			parent:SetScript("OnUpdate", config["update_handler"])
			config["update_handler"](parent, 20000)
		end 

		if config["click_handler"]then
			parent.onClick = config["click_handler"]
		end
		parent:SetScript("OnClick", Parent_OnClick)

		if config["focus_handler"]then 
			parent:SetScript("OnEnter", config["focus_handler"])
		end 

		if config["blur_handler"]then 
			parent:SetScript("OnLeave", config["blur_handler"])
		else 
			parent:SetScript("OnLeave", Stat_OnLeave)
		end

		parent:Show()
	end

	local BG_OnUpdate = function(self)
		local scoreString;
		local parentName = self:GetParent():GetName();
		local lookup = self.pointIndex
		local pointIndex = MOD.BGPanels[parentName][lookup]
		local scoreindex = MOD.BGStats[pointIndex][1]
		local scoreType = MOD.BGStats[pointIndex][2]
		local scoreCount = GetNumBattlefieldScores()
		for i = 1, scoreCount do
			SCORE_CACHE = {GetBattlefieldScore(i)}
			if(SCORE_CACHE[1] and SCORE_CACHE[1] == myName and SCORE_CACHE[scoreindex]) then
				scoreString = TruncateString(SCORE_CACHE[scoreindex])
				self.text:SetFormattedText(BGStatString, scoreType, scoreString)
				break 
			end 
		end 
	end

	local BG_OnEnter = function(self)
		MOD:Tip(self)
		local bgName;
		local mapToken = GetCurrentMapAreaID()
		local r, g, b;
		if(classColor) then
			r, g, b = classColor.r, classColor.g, classColor.b
		else
			r, g, b = 1, 1, 1
		end

		local scoreCount = GetNumBattlefieldScores()

		for i = 1, scoreCount do 
			bgName = GetBattlefieldScore(i)
			if(bgName and bgName == myName) then 
				MOD.tooltip:AddDoubleLine(L["Stats For:"], bgName, 1, 1, 1, r, g, b)
				MOD.tooltip:AddLine(" ")
				if(mapToken == 443 or mapToken == 626) then 
					MOD.tooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Flags Returned"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 482) then 
					MOD.tooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
				elseif(mapToken == 401) then 
					MOD.tooltip:AddDoubleLine(L["Graveyards Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Graveyards Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Towers Assaulted"], GetBattlefieldStatData(i, 3), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Towers Defended"], GetBattlefieldStatData(i, 4), 1, 1, 1)
				elseif(mapToken == 512) then 
					MOD.tooltip:AddDoubleLine(L["Demolishers Destroyed"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Gates Destroyed"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 540 or mapToken == 736 or mapToken == 461) then 
					MOD.tooltip:AddDoubleLine(L["Bases Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Bases Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 856) then 
					MOD.tooltip:AddDoubleLine(L["Orb Possessions"], GetBattlefieldStatData(i, 1), 1, 1, 1)
					MOD.tooltip:AddDoubleLine(L["Victory Points"], GetBattlefieldStatData(i, 2), 1, 1, 1)
				elseif(mapToken == 860) then 
					MOD.tooltip:AddDoubleLine(L["Carts Controlled"], GetBattlefieldStatData(i, 1), 1, 1, 1)
				end 
				break 
			end 
		end 
		MOD:ShowTip()
	end

	local ForceHideBGStats;
	local BG_OnClick = function()
		ForceHideBGStats = true;
		MOD:Generate()
		SV:AddonMessage(L["Battleground statistics temporarily hidden, to show type \"/sv bg\" or \"/sv pvp\""])
	end

	local sortMenuList = function(a, b) return a < b end

	function MOD:SetMenuLists()
		local stats = self.Anchors;
		local list = StatMenuListing;
		local disabled = self.DisabledList;

		tsort(list)

		for place,parent in pairs(stats)do
			for i = 1, parent.numPoints do 
				local this = positionIndex[parent.useIndex][i]
				local subList = twipe(parent.holders[this].MenuList)

				tinsert(subList,{text = NONE, func = function() MOD:ChangeDBVar("", this, "docks", place); MOD:Generate() end});
				for _,name in pairs(list) do
					if(not disabled[name]) then
						tinsert(subList,{text = name, func = function() MOD:ChangeDBVar(name, this, "docks", place); MOD:Generate() end});
					end
				end
			end
			self.ListNeedsUpdate = false;
		end
	end 

	function MOD:Generate()
		if(self.ListNeedsUpdate) then
			self:SetMenuLists()
		end
		
		local instance, groupType = IsInInstance()
		local anchorTable = self.Anchors
		local statTable = self.Statistics
		local db = SV.db.SVStats
		local allowPvP = (db.battleground and not ForceHideBGStats) or false
		for place, parent in pairs(anchorTable) do
			local pvpTable = allowPvP and self.BGPanels[place]
			for i = 1, parent.numPoints do 
				local position = positionIndex[parent.useIndex][i]

				parent.holders[position]:UnregisterAllEvents()
				parent.holders[position]:SetScript("OnUpdate", nil)
				parent.holders[position]:SetScript("OnEnter", nil)
				parent.holders[position]:SetScript("OnLeave", nil)
				parent.holders[position]:SetScript("OnClick", nil)

				if(db.showBackground) then
					parent.holders[position].text:SetFont(LSM:Fetch("font", db.font), db.fontSize, "NONE")
				else
					parent.holders[position].text:SetFont(LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
				end
				
				parent.holders[position].text:SetText(nil)

				if parent.holders[position].barframe then 
					parent.holders[position].barframe:Hide()
				end 

				parent.holders[position].pointIndex = position;
				parent.holders[position]:Hide()

				if(pvpTable and ((instance and groupType == "pvp") or parent.lockedOpen)) then 
					parent.holders[position]:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
					parent.holders[position]:SetScript("OnEvent", BG_OnUpdate)
					parent.holders[position]:SetScript("OnEnter", BG_OnEnter)
					parent.holders[position]:SetScript("OnLeave", Stat_OnLeave)
					parent.holders[position]:SetScript("OnClick", BG_OnClick)

					BG_OnUpdate(parent.holders[position])

					parent.holders[position]:Show()
				else 
					for name, config in pairs(statTable)do
						for panelName, panelData in pairs(db.docks) do 
							if(panelData and type(panelData) == "table") then 
								if(panelName == place and panelData[position] and panelData[position] == name) then 
									_load(parent.holders[position], name, config)
								end 
							elseif(panelData and type(panelData) == "string" and panelData == name) then 
								if(name == place) then 
									_load(parent.holders[position], name, config)
								end 
							end 
						end
					end 
				end 
			end
		end 
		if ForceHideBGStats then ForceHideBGStats = nil end
	end
end

function MOD:UnSet(parent)
	parent:UnregisterAllEvents()
	parent:SetScript("OnUpdate", nil)
	parent:SetScript("OnEnter", nil)
	parent:SetScript("OnLeave", nil)
	parent:SetScript("OnClick", nil)
	self.DisabledList[parent.StatParent] = true
	self:SetMenuLists()
end
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ReLoad()
	self:Generate()
end 

function MOD:Load()
	hexHighlight = SV:HexColor("highlight") or "FFFFFF"
	local hexClass = classColor.colorStr
	BGStatString = "|cff" .. hexHighlight .. "%s: |c" .. hexClass .. "%s|r";

	self.Accountant = LibSuperVillain("Registry"):NewGlobal("Accountant")

	self.Accountant[playerRealm] = self.Accountant[playerRealm] or {};
	self.Accountant[playerRealm]["gold"] = self.Accountant[playerRealm]["gold"] or {};
	self.Accountant[playerRealm]["gold"][playerName] = self.Accountant[playerRealm]["gold"][playerName] or 0;
	self.Accountant[playerRealm]["tokens"] = self.Accountant[playerRealm]["tokens"] or {};
	if(not self.Accountant[playerRealm]["tokens"][playerName] or (self.Accountant[playerRealm]["tokens"][playerName] and type(self.Accountant[playerRealm]["tokens"][playerName]) ~= "table")) then
		self.Accountant[playerRealm]["tokens"][playerName] = {};
	end

	self:NewAnchor(SV.Dock.BottomCenter.Left, 3, "ANCHOR_CURSOR")
	self:NewAnchor(SV.Dock.BottomCenter.Right, 3, "ANCHOR_CURSOR")
	self:NewAnchor(SV.Dock.TopCenter.Left, 3, "ANCHOR_CURSOR")
	self:NewAnchor(SV.Dock.TopCenter.Right, 3, "ANCHOR_CURSOR")

	self:LoadServerGold()
	self:CacheRepData()
	
	-- self.tooltip:SetParent(SV.Screen)
	self.tooltip:SetFrameStrata("DIALOG")
	self.tooltip:HookScript("OnShow", _hook_TooltipOnShow)

	if(LDB) then
	  	for dataName, dataObj in LDB:DataObjectIterator() do

		    local OnEnter, OnLeave, OnClick, lastObj;

		    if dataObj.OnTooltipShow then 
		      	function OnEnter(self)
					MOD:Tip(self)
					dataObj.OnTooltipShow(MOD.tooltip)
					MOD:ShowTip()
				end
		    end

		    if dataObj.OnEnter then 
		      	function OnEnter(self)
					MOD:Tip(self)
					dataObj.OnEnter(MOD.tooltip)
					MOD:ShowTip()
				end
		    end

		    if dataObj.OnLeave then 
				function OnLeave(self)
					dataObj.OnLeave(self)
					MOD.tooltip:Hide()
				end 
		    end

		    if dataObj.OnClick then
		    	function OnClick(self, button)
			      	dataObj.OnClick(self, button)
			    end
			end

			local function textUpdate(event, name, key, value, dataobj)
				if value == nil or (len(value) > 5) or value == 'n/a' or name == value then
					lastObj.text:SetText(value ~= 'n/a' and value or name)
				else
					lastObj.text:SetText(name..': '.. '|cff' .. hexHighlight ..value..'|r')
				end
			end

		    local function OnEvent(self)
				lastObj = self;
				LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_text", textUpdate)
				LDB:RegisterCallback("LibDataBroker_AttributeChanged_"..dataName.."_value", textUpdate)
				LDB.callbacks:Fire("LibDataBroker_AttributeChanged_"..dataName.."_text", dataName, nil, dataObj.text, dataObj)
		    end

		    MOD:Extend(dataName, {"PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, OnEnter, OnLeave)
	  	end
	end

	self:Generate()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Generate")

	myName = UnitName("player");
end