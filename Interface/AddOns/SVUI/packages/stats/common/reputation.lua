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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local tinsert 	= _G.tinsert;
local table     = _G.table;
local twipe     = table.wipe; 
--[[ STRING METHODS ]]--
local format, gsub = string.format, string.gsub;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVStats');
--[[ 
########################################################## 
REPUTATION STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD","UPDATE_FACTION"};
local RepMenuList = {};
local standingName = {
	[1] = "Hated",
	[2] = "Hostile",
	[3] = "Unfriendly",
	[4] = "Neutral",
	[5] = "Friendly",
	[6] = "Honored",
	[7] = "Revered",
	[8] = "Exalted"
};

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

local function CacheRepData()
	twipe(RepMenuList)
	for factionIndex = 1, GetNumFactions() do
		local factionName = GetFactionInfo(factionIndex)	
		local fn = function()
			local active = GetWatchedFactionInfo()
			if factionName ~= active then
				SetWatchedFactionIndex(factionIndex)
			end
		end; 
		tinsert(RepMenuList, {text = factionName, func = fn});
	end
end

local function Reputation_OnEvent(self, ...)
	if self.barframe:IsShown()then 
		self.text:SetAllPoints(self)
		self.text:SetJustifyH("CENTER")
		self.barframe:Hide()
		self.text:SetAlpha(1)
		self.text:SetFontTemplate(SuperVillain.Shared:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,SuperVillain.db.SVStats.fontOutline)
	end;
	local ID = 100
	local isFriend, friendText
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local numFactions = GetNumFactions();
	local txt = ""
	if not name then 
		txt = "No watched factions"
	else
		for i=1, numFactions do
			local factionName, _, standingID,_,_,_,_,_,_,_,_,_,_, factionID = GetFactionInfo(i);
			local friendID, friendRep, friendMaxRep, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
			if factionName == name then
				if friendID ~= nil then
					isFriend = true
					friendText = friendTextLevel
				else
					ID = standingID
				end
			end
		end
		txt = format("%s: %s - %d%% [%s]", name, TruncateString(value - min), ((value - min) / (max - min) * 100), isFriend and friendText or _G["FACTION_STANDING_LABEL"..ID])
	end;
	self.text:SetText(txt)
end;

local function ReputationBar_OnEvent(self, ...)
	if not self.barframe:IsShown()then 
		self.barframe:Show()
		self.barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\STAT-REP")
		self.text:SetAlpha(0.5)
		self.text:SetFontTemplate(SuperVillain.Shared:Fetch("font",SuperVillain.db.SVStats.font),SuperVillain.db.SVStats.fontSize,"NONE")
	end;
	local bar = self.barframe.bar;
	local name, reaction, min, max, value = GetWatchedFactionInfo()
	local j = GetNumFactions()
	if not name then 
		bar:SetStatusBarColor(0,0,0)
		bar:SetMinMaxValues(0,1)
		bar:SetValue(0)
		self.text:SetText("No Faction")
	else 
		local txt = standingName[reaction];
		local color = FACTION_BAR_COLORS[reaction]
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar:SetMinMaxValues(min, max)
		bar:SetValue(value)
		self.text:SetText(txt)
	end;
end;

local function Reputation_OnEnter(self)
	MOD:Tip(self)
	local name, reaction, min, max, value, factionID = GetWatchedFactionInfo()
	local friendID, _, _, _, _, _, friendTextLevel = GetFriendshipReputation(factionID);
	if not name then
		MOD.tooltip:AddLine("No Watched Factions")
	else
		MOD.tooltip:AddLine(name)
		MOD.tooltip:AddLine(' ')
		MOD.tooltip:AddDoubleLine(STANDING..':', friendID and friendTextLevel or _G['FACTION_STANDING_LABEL'..reaction], 1, 1, 1)
		MOD.tooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', value - min, max - min, (value - min) / (max - min) * 100), 1, 1, 1)
	end;
	MOD:ShowTip()
end;

local function Reputation_OnClick(self, button)
	CacheRepData()
	MOD:SetStatMenu(self, RepMenuList) 
end;

MOD:Extend("Reputation", StatEvents, Reputation_OnEvent, nil, Reputation_OnClick, Reputation_OnEnter)
MOD:Extend("Reputation Bar", StatEvents, ReputationBar_OnEvent, nil, Reputation_OnClick, Reputation_OnEnter)

SuperVillain.Registry:Temp("SVStats", CacheRepData)