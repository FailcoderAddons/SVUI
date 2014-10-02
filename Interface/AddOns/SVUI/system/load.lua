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
local type      = _G.type;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format, match = string.format, string.match;
--[[ TABLE METHODS ]]--
local tcopy = table.copy;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local SVLib = LibSuperVillain
local L = SV.L
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
SYSTEM UPDATES
##########################################################
]]--
local playerClass = select(2,UnitClass("player"));

local function DeleteOldSavedVars()
	--[[ BEGIN DEPRECATED ]]--

    --[[ END DEPRECATED ]]--
end

function SV:VersionCheck()
	local minimumVersion = 4.06;
	local installedVersion = SVLib:GetSafeData("install_version");
	if(installedVersion) then
		if(type(installedVersion) == "string") then
			installedVersion = tonumber(installedVersion)
		end
		if(type(installedVersion) == "number" and installedVersion < minimumVersion) then
			--DeleteOldSavedVars()  -- No current deprecated entries to remove
			self.Setup:Install(true)
		end
	else
		self.Setup:Install(true)
	end
end

function SV:RefreshEverything(bypass)
	self:RefreshAllSystemMedia();
	self.UIParent:Hide();
	self.Mentalo:SetPositions();
	SVLib:UpdateAll();
	self.UIParent:Show();
	if not bypass then
		self:VersionCheck()
	end
end 
--[[ 
########################################################## 
SVUI LOAD PROCESS
##########################################################
]]--
function SV:Load()
	self.Timers:ClearAllTimers()

	local rez = GetCVar("gxResolution");
	local gxHeight = tonumber(match(rez,"%d+x(%d+)"));
	local gxWidth = tonumber(match(rez,"(%d+)x%d+"));

    SVLib:Initialize()

    self.DisplaySettings = SVLib:NewGlobal("Display")
    if(not self.DisplaySettings.screenheight or (self.DisplaySettings.screenheight and type(self.DisplaySettings.screenheight) ~= "number")) then 
    	self.DisplaySettings.screenheight = gxHeight 
    end
    if(not self.DisplaySettings.screenwidth or (self.DisplaySettings.screenwidth and type(self.DisplaySettings.screenwidth) ~= "number")) then 
    	self.DisplaySettings.screenwidth = gxWidth 
    end

	self:ScreenCalibration();
	self:RefreshSystemFonts();
	self:LoadSystemAlerts();

	self.UIParent:RegisterEvent('PLAYER_REGEN_DISABLED');
	self.AddonLoaded = true
end 

function SV:Launch()
	SVLib:Launch();

	self:ScreenCalibration("PLAYER_LOGIN");
	self:DefinePlayerRole();

	self.Mentalo:Initialize()

	self:VersionCheck()

	self:RefreshAllSystemMedia();

	NewHook("StaticPopup_Show", self.StaticPopup_Show)

	self.UIParent:RegisterEvent("PLAYER_ENTERING_WORLD");
	self.UIParent:RegisterEvent("UI_SCALE_CHANGED");
	self.UIParent:RegisterEvent("PET_BATTLE_CLOSE");
	self.UIParent:RegisterEvent("PET_BATTLE_OPENING_START");
	self.UIParent:RegisterEvent("ADDON_ACTION_BLOCKED");
	self.UIParent:RegisterEvent("ADDON_ACTION_FORBIDDEN");
	self.UIParent:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	self.UIParent:RegisterEvent("PLAYER_TALENT_UPDATE");
	self.UIParent:RegisterEvent("CHARACTER_POINTS_CHANGED");
	self.UIParent:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self.UIParent:RegisterEvent("UPDATE_BONUS_ACTIONBAR");

	SVLib:Update("SVMap");

	collectgarbage("collect") 

	if self.db.general.loginmessage then
		local logMsg = (L["LOGIN_MSG"]):format("|cffFFFF1A", "|cffAA78FF", self.Version)
		self:AddonMessage(logMsg);
	end

	self.AddonLaunched = true
end 
--[[ 
########################################################## 
EVENT HANDLERS
##########################################################
]]--
local SVUISystem_OnEvent = function(self, event, arg, ...)
	if(event == "ADDON_LOADED" and arg == "SVUI") then
		if(not SV.AddonLoaded) then
			SV:Load()
			self:UnregisterEvent("ADDON_LOADED")
		end
	end
	if(event == "PLAYER_LOGIN") then
		if(not SV.AddonLaunched and IsLoggedIn()) then
			SV:Launch()
			self:UnregisterEvent("PLAYER_LOGIN")
		end
	end
	if(event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "UNIT_INVENTORY_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR") then
		SV:DefinePlayerRole()
	elseif(event == "UI_SCALE_CHANGED") then
		SV:ScreenCalibration("UI_SCALE_CHANGED")
	elseif(event == "PLAYER_ENTERING_WORLD") then
		if(not SV.RoleIsSet) then
			SV:DefinePlayerRole()
		end
		if(not SV.MediaInitialized) then 
			SV:RefreshAllSystemMedia() 
		end 
		local _,instanceType = IsInInstance()
		if(instanceType == "pvp") then 
			SV.BGTimer = SV.Timers:ExecuteLoop(RequestBattlefieldScoreData, 5)
		elseif(SV.BGTimer) then 
			SV.Timers:RemoveLoop(SV.BGTimer)
			SV.BGTimer = nil 
		end
		if(not InCombatLockdown()) then
			collectgarbage("collect") 
		end
	elseif(event == "PET_BATTLE_CLOSE") then
		SV:PushDisplayAudit()
	elseif(event == "PET_BATTLE_OPENING_START") then
		SV:FlushDisplayAudit()
	elseif(event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN") then
		SV:TaintHandler(arg, ...)
	elseif(event == "PLAYER_REGEN_DISABLED") then
		local forceClosed = false;
		if IsAddOnLoaded(SV.ConfigID) then 
			local aceConfig=LibStub("AceConfigDialog-3.0")
			if aceConfig.OpenFrames[SV.NameID] then 
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
				aceConfig:Close(SV.NameID)
				forceClosed = true 
			end 
		end 
		if SV.Mentalo.Frames then 
			for frame,_ in pairs(SV.Mentalo.Frames) do 
				if _G[frame] and _G[frame]:IsShown() then 
					forceClosed = true;
					_G[frame]:Hide()
				end 
			end 
		end 
		if(HenchmenFrameModel and HenchmenFrame and HenchmenFrame:IsShown()) then 
			HenchmenFrame:Hide()
			HenchmenFrameBG:Hide()
			forceClosed = true;
		end
		if forceClosed == true then 
			SV:AddonMessage(ERR_NOT_IN_COMBAT)
		end
	elseif(event == "PLAYER_REGEN_ENABLED") then
		SV:ToggleConfig()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end

SV.UIParent:RegisterEvent("ADDON_LOADED")
SV.UIParent:RegisterEvent("PLAYER_LOGIN")
SV.UIParent:SetScript("OnEvent", SVUISystem_OnEvent)
--[[ 
########################################################## 
THE CLEANING LADY
##########################################################
]]--
local LemonPledge = 0;
local Consuela = CreateFrame("Frame")
Consuela:RegisterAllEvents()
Consuela:SetScript("OnEvent", function(self, event)
	LemonPledge = LemonPledge  +  1
	if(InCombatLockdown()) then return end;
	if(LemonPledge > 10000) then
		collectgarbage("collect");
		LemonPledge = 0;
	end
end)