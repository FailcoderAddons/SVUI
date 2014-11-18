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
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;

--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--TABLE
local table 		= _G.table; 
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe 		= _G.wipe;
--MATH
local math      	= _G.math;
local min 			= math.min;
local floor         = math.floor
local ceil          = math.ceil
--BLIZZARD API
local GameTooltip          	= _G.GameTooltip;
local InCombatLockdown     	= _G.InCombatLockdown;
local CreateFrame          	= _G.CreateFrame;
local GetTime         		= _G.GetTime;
local GetItemCooldown       = _G.GetItemCooldown;
local GetItemCount         	= _G.GetItemCount;
local GetItemInfo          	= _G.GetItemInfo;
local GetSpellInfo         	= _G.GetSpellInfo;
local IsSpellKnown         	= _G.IsSpellKnown;
local GetGarrison       	= _G.GetGarrison;
local GetProfessionInfo    	= _G.GetProfessionInfo;
local hooksecurefunc     	= _G.hooksecurefunc;
--[[ 
########################################################## 
ADDON
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L

local MOD = SV.SVTools;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local GARRISON_ICON = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-GARRISON]];

local function GetDockCooldown(itemID)
	local start,duration = GetItemCooldown(itemID)
	local expires = duration - (GetTime() - start)
	if expires > 0.05 then 
		local timeLeft = 0;
		local calc = 0;
		if expires < 4 then
			return format("|cffff0000%.1f|r", expires)
		elseif expires < 60 then 
			return format("|cffffff00%d|r", floor(expires)) 
		elseif expires < 3600 then
			timeLeft = ceil(expires / 60);
			calc = floor((expires / 60) + .5);
			return format("|cffff9900%dm|r", timeLeft)
		elseif expires < 86400 then
			timeLeft = ceil(expires / 3600);
			calc = floor((expires / 3600) + .5);
			return format("|cff66ffff%dh|r", timeLeft)
		else
			timeLeft = ceil(expires / 86400);
			calc = floor((expires / 86400) + .5);
			return format("|cff6666ff%dd|r", timeLeft)
		end
	else 
		return "|cff6666ffReady|r"
	end 
end

local function GarrisonButton_OnEvent(self, event, ...)
    if (event == "GARRISON_HIDE_LANDING_PAGE") then
        if(not InCombatLockdown()) then SVUI_Garrison:Hide() end;
    elseif (event == "GARRISON_SHOW_LANDING_PAGE") then
    	if(not InCombatLockdown()) then SVUI_Garrison:Show() end;
    elseif ( event == "GARRISON_BUILDING_ACTIVATABLE" ) then
        SVUI_Garrison:StartAlert();
    elseif ( event == "GARRISON_BUILDING_ACTIVATED" or event == "GARRISON_ARCHITECT_OPENED") then
        SVUI_Garrison:StopAlert();
    elseif ( event == "GARRISON_MISSION_FINISHED" ) then
        SVUI_Garrison:StartAlert();
    elseif ( event == "GARRISON_MISSION_NPC_OPENED" ) then
        SVUI_Garrison:StopAlert();
    elseif (event == "GARRISON_INVASION_AVAILABLE") then
        SVUI_Garrison:StartAlert();
    elseif (event == "GARRISON_INVASION_UNAVAILABLE") then
        SVUI_Garrison:StopAlert();
    elseif (event == "SHIPMENT_UPDATE") then
        local shipmentStarted = ...;
        if (shipmentStarted) then
            SVUI_Garrison:StartAlert();
        end
    end
end

local function getColoredString(text, color)
	local hex = SV:HexColor(color)
	return ("|cff%s%s|r"):format(hex, text)
end

local function GetActiveMissions()
	GameTooltip:AddLine(" ", 1, 1, 1)
	for key,data in pairs(C_Garrison.GetInProgressMissions()) do
		local mission = ("%s - %s"):format(data.level, data.name);

		local remaining
		if (data.start == -1) then
			remaining = ("~%s %s"):format(data.timeLeft, getColoredString("("..SV:ParseSeconds(data.duration)..")", "lightgrey"))
		elseif (data.start == 0 or timeLeft < 0) then
			remaining = L["Complete!"]
		else
			remaining = ("%s %s"):format(SV:ParseSeconds(timeLeft), getColoredString("("..SV:ParseSeconds(data.duration)..")", "lightgrey"))
		end

		GameTooltip:AddDoubleLine(mission, remaining, 0, 1, 0, 1, 1, 1)
	end

	-- for key,garrisonMission in pairs(C_Garrison.GetCompleteMissions()) do
		-- DO STUFF
	-- end
end

local SetGarrisonTooltip = function(self)
	local text1 = self:GetAttribute("tipText")
	local text2 = self:GetAttribute("tipExtraText")
	GameTooltip:AddDoubleLine("[Left-Click]", text1, 0, 1, 0, 1, 1, 1)
	if InCombatLockdown() then return end
	if(text2) then
		local remaining = GetDockCooldown(110560)
		GameTooltip:AddLine(" ", 1, 1, 1)
		GameTooltip:AddDoubleLine("[Right Click]", text2, 0, 1, 0, 1, 1, 1)
		GameTooltip:AddDoubleLine(L["Time Remaining"], remaining, 1, 1, 1, 0, 1, 1)
	end
	GetActiveMissions()
end

local function LoadToolBarGarrison()
	if((not SV.db.SVTools.garrison) or MOD.GarrisonLoaded) then return end
	if(InCombatLockdown()) then 
		MOD.GarrisonNeedsUpdate = true; 
		MOD:RegisterEvent("PLAYER_REGEN_ENABLED"); 
		return 
	end

	local garrison = SV.Dock:SetDockButton("TopLeft", L["Garrison"], GARRISON_ICON, nil, "SVUI_Garrison", SetGarrisonTooltip, "SecureActionButtonTemplate")
	garrison:SetAttribute("type1", "click")
	garrison:SetAttribute("clickbutton", GarrisonLandingPageMinimapButton)

	local garrisonStone = GetItemInfo(110560);
	if(garrisonStone and type(garrisonStone) == "string") then
		garrison:SetAttribute("tipExtraText", L["Garrison Hearthstone"])
		garrison:SetAttribute("type2", "macro")
		garrison:SetAttribute("macrotext", "/use [nomod] " .. garrisonStone)
	end

	GarrisonLandingPageMinimapButton:RemoveTextures()
	GarrisonLandingPageMinimapButton:ClearAllPoints()
	GarrisonLandingPageMinimapButton:SetAllPoints(garrison)
	GarrisonLandingPageMinimapButton:SetNormalTexture("")
	GarrisonLandingPageMinimapButton:SetPushedTexture("")
	GarrisonLandingPageMinimapButton:SetHighlightTexture("")

	GarrisonLandingPageMinimapButton:HookScript("OnEvent", GarrisonButton_OnEvent)

	MOD.GarrisonLoaded = true
end
--[[ 
########################################################## 
BUILD/UPDATE
##########################################################
]]--
function MOD:UpdateGarrisonTool() 
	if((not SV.db.SVTools.garrison) or self.GarrisonLoaded) then return end
	LoadToolBarGarrison()
end 

function MOD:LoadGarrisonTool()
	if((not SV.db.SVTools.garrison) or self.GarrisonLoaded) then return end
	SV.Timers:ExecuteTimer(LoadToolBarGarrison, 5)
end