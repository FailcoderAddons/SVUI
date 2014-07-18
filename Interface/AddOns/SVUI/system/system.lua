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
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local bit       = _G.bit;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local fmod, modf, sqrt = math.fmod, math.modf, math.sqrt;   -- Algebra
local atan2, cos, deg, rad, sin = math.atan2, math.cos, math.deg, math.rad, math.sin;  -- Trigonometry
local parsefloat, huge, random = math.parsefloat, math.huge, math.random;  -- Uncommon
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat, tdump = table.remove, table.copy, table.wipe, table.sort, table.concat, table.dump;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SVUINameSpace, SVUICore = ...;
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
local bld = select(2,GetBuildInfo());
local toonClass = select(2,UnitClass("player"));
local rez = GetCVar("gxResolution");
local gxHeight = tonumber(match(rez,"%d+x(%d+)"));
local gxWidth = tonumber(match(rez,"(%d+)x%d+"));
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
BUILD ADDON OBJECTS
##########################################################
]]--
local SuperVillain = SVUI_LIB:SetObject(SVUINameSpace)
local L = SVUI_LOCALE:SetObject()

SVUICore[1] = SuperVillain;
SVUICore[2] = L;
--[[ 
########################################################## 
CREATE GLOBAL NAMESPACE
##########################################################
]]--
_G[SVUINameSpace] = SVUICore;
--[[ 
########################################################## 
SET MANY VARIABLES
##########################################################
]]--
local SVUISystemEventHandler = CreateFrame("Frame", "SVUISystemEventHandler")
local SVUIParent = CreateFrame("Frame", "SVUIParent", UIParent);
local StealthFrame = CreateFrame("Frame", nil, UIParent);
StealthFrame:Hide();
SVUIParent:SetFrameLevel(UIParent:GetFrameLevel());
SVUIParent:SetPoint("CENTER", UIParent, "CENTER");
SVUIParent:SetSize(UIParent:GetSize());

SuperVillain.db = {};
SuperVillain.Media = {};
SuperVillain.Filters = {};
SuperVillain.DisplayAudit = {};
SuperVillain.DynamicOptions = {};
SuperVillain.snaps = {};
SuperVillain.Dispellable = {};
SuperVillain.Options = { type="group", name="|cff339fffConfig-O-Matic|r", args={}, };
SuperVillain.Shared = LibStub("LibSharedMedia-3.0")
SuperVillain.version = GetAddOnMetadata(..., "Version");
SuperVillain.class = toonClass;
SuperVillain.name = UnitName("player");
SuperVillain.realm = GetRealmName();
SuperVillain.build = tonumber(bld);
SuperVillain.guid = UnitGUID('player');
SuperVillain.mult = 1;
SuperVillain.ConfigurationMode = false;
SuperVillain.ClassRole = "";
SuperVillain.UIParent = SVUIParent;
SuperVillain.Cloaked = StealthFrame;
SuperVillain.snaps[#SuperVillain.snaps + 1] = SuperVillain.UIParent;
--[[ 
########################################################## 
THE CLEANING LADY
##########################################################
]]--
local LemonPledge = 0;
local Consuela = CreateFrame("Frame")
--[[ 
########################################################## 
DISPEL MECHANICS
##########################################################
]]--
local droodSpell1, droodSpell2 = GetSpellInfo(110309), GetSpellInfo(4987);
local RefClassRoles;
local RefMagicSpec;
do
	if(toonClass == "PRIEST") then
		RefClassRoles = {"C", "C", "C"}
		SuperVillain.Dispellable = {["Magic"] = true, ["Disease"] = true}
	elseif(toonClass == "WARLOCK") then
		RefClassRoles = {"C", "C", "C"}
	elseif(toonClass == "WARRIOR") then
		RefClassRoles = {"M", "M", "T"}
	elseif(toonClass == "HUNTER") then
		RefClassRoles = {"M", "M", "M"}
	elseif(toonClass == "ROGUE") then
		RefClassRoles = {"M", "M", "M"}
	elseif(toonClass == "MAGE") then
		RefClassRoles = {"C", "C", "C"}
		SuperVillain.Dispellable = {["Curse"] = true}
	elseif(toonClass == "DEATHKNIGHT") then
		RefClassRoles = {"T", "M", "M"}
	elseif(toonClass == "DRUID") then
		RefMagicSpec = 4
		RefClassRoles = {"C", "M", "T", "C"}
		SuperVillain.Dispellable = {["Curse"] = true, ["Poison"] = true}
	elseif(toonClass == "SHAMAN") then
		RefMagicSpec = 3
		RefClassRoles = {"C", "M", "C"}
		SuperVillain.Dispellable = {["Curse"] = true}
	elseif(toonClass == "MONK") then
		RefMagicSpec = 2
		RefClassRoles = {"T", "C", "M"}
		SuperVillain.Dispellable = {["Disease"] = true, ["Poison"] = true}
	elseif(toonClass == "PALADIN") then
		RefMagicSpec = 1
		RefClassRoles = {"C", "T", "M"}
		SuperVillain.Dispellable = {["Poison"] = true, ["Disease"] = true}
	end
end

local function GetTalentInfo(arg)
	if type(arg) == "number" then 
		return arg == GetActiveSpecGroup();
	else
		return false;
	end 
end

function SuperVillain:DefinePlayerRole()
	local spec = GetSpecialization()
	local role;
	if spec then
		role = RefClassRoles[spec]
		if role == "T" and UnitLevel("player") == MAX_PLAYER_LEVEL then
			local bonus, pvp = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN), false;
			if bonus > GetDodgeChance() and bonus > GetParryChance() then 
				role = "M"
			end 
		end 
	else
		local intellect = select(2, UnitStat("player", 4))
		local agility = select(2, UnitStat("player", 2))
		local baseAP, posAP, negAP = UnitAttackPower("player")
		local totalAP = baseAP  +  posAP  +  negAP;
		if totalAP > intellect or agility > intellect then 
			role = "M"
		else 
			role = "C"
		end 
	end 
	if self.ClassRole ~= role then 
		self.ClassRole = role;
		self.RoleChangedCallback()
	end 
	if RefMagicSpec then 
		if(GetTalentInfo(RefMagicSpec)) then 
			self.Dispellable["Magic"] = true 
		elseif(self.Dispellable["Magic"]) then
			self.Dispellable["Magic"] = nil 
		end 
	end
end 
--[[ 
########################################################## 
SYSTEM FUNCTIONS
##########################################################
]]--
function SuperVillain:TableSplice(targetTable, mergeTable)
    if type(targetTable) ~= "table" then targetTable = {} end

    if type(mergeTable) == 'table' then 
        for key,val in pairs(mergeTable) do 
            if type(val) == "table" then 
                val = self:TableSplice(targetTable[key], val)
            end 
            targetTable[key] = val 
        end 
    end 
    return targetTable 
end

function SuperVillain:StaticPopup_Show(arg)
	if arg == "ADDON_ACTION_FORBIDDEN" then 
		StaticPopup_Hide(arg)
	end
end 

function SuperVillain:ResetAllUI(confirmed)
	if InCombatLockdown()then 
		SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
		return 
	end 
	if(not confirmed) then 
		self:StaticPopup_Show('RESET_UI_CHECK')
		return 
	end 
	self:ResetInstallation()
end 

function SuperVillain:ResetUI(confirmed)
	if InCombatLockdown()then 
		SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
		return 
	end 
	if(not confirmed) then 
		self:StaticPopup_Show('RESETMOVERS_CHECK')
		return 
	end 
	self:ResetMovables()
end 

function SuperVillain:ToggleConfig()
	if InCombatLockdown() then 
		SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT) 
		SVUISystemEventHandler:RegisterEvent('PLAYER_REGEN_ENABLED')
		return 
	end 
	if not IsAddOnLoaded("SVUI_ConfigOMatic") then 
		local _,_,_,_,_,state = GetAddOnInfo("SVUI_ConfigOMatic")
		if state ~= "MISSING" and state ~= "DISABLED" then 
			LoadAddOn("SVUI_ConfigOMatic")
			local config_version = GetAddOnMetadata("SVUI_ConfigOMatic","Version")
			if(tonumber(config_version) < 4) then 
				self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
			end 
		else 
			SuperVillain:AddonMessage("|cffff0000Error -- Addon 'SVUI_ConfigOMatic' not found or is disabled.|r")
			return 
		end 
	end 
	local aceConfig = LibStub("AceConfigDialog-3.0")
	local switch = not aceConfig.OpenFrames[SVUINameSpace] and "Open" or "Close"
	aceConfig[switch](aceConfig,SVUINameSpace)
	GameTooltip:Hide()
end 

function SuperVillain:TaintHandler(taint, sourceName, sourceFunc)
	if GetCVarBool('scriptErrors') ~= 1 then return end 
	ScriptErrorsFrame_OnError(L["%s: %s has lost it's damn mind and is destroying '%s'."]:format(taint, sourceName or "<name>", sourceFunc or "<func>"),false)
end 
--[[ 
########################################################## 
SYSTEM UPDATES
##########################################################
]]--
function SuperVillain:VersionCheck()
	local minimumVersion = 4.06;
	if(not SVUI_Profile.SAFEDATA.install_version or (SVUI_Profile.SAFEDATA.install_version and (tonumber(SVUI_Profile.SAFEDATA.install_version) < minimumVersion))) then
		self:Install(true)
	end
end

function SuperVillain:RefreshEverything(bypass)
	self:RefreshAllSystemMedia();

	SuperVillain.UIParent:Hide();

	self:SetSVMovablesPositions();
	self.Registry:Update('SVUnit');
	self.Registry:UpdateAll();

	SuperVillain.UIParent:Show();

	collectgarbage("collect");

	if not bypass then
		self:VersionCheck()
	end
end 
--[[ 
########################################################## 
SVUI LOAD PROCESS
##########################################################
]]--
local function PreLoad(self)
	--[[ BEGIN DEPRECATED ]]--
    if SVUI_DATA then SVUI_DATA = nil end 
    if SVUI_SAFE_DATA then SVUI_SAFE_DATA = nil end 
    if SVUI_TRACKER then SVUI_TRACKER = nil end 
    if SVUI_ENEMIES then SVUI_ENEMIES = nil end 
    if SVUI_JOURNAL then SVUI_JOURNAL = nil end 
    if SVUI_CHARACTER_LOG then SVUI_CHARACTER_LOG = nil end 
    if SVUI_MOVED_FRAMES then SVUI_MOVED_FRAMES = nil end 
    if SVUI_SystemData then SVUI_SystemData = nil end 
    if SVUI_ProfileData then SVUI_ProfileData = nil end 
    --[[ END DEPRECATED ]]--
    
	if not SVUI_Global then SVUI_Global = {} end 
    if not SVUI_Global["profiles"] then SVUI_Global["profiles"] = {} end 

    if SVUI_Global["gold"] then SVUI_Global["gold"] = nil end 
    if SVUI_Global["profileKeys"] then SVUI_Global["profileKeys"] = nil end 

    if not SVUI_Profile then SVUI_Profile = {} end 
    if not SVUI_Profile.SAFEDATA then SVUI_Profile.SAFEDATA = {} end 
    if(SVUI_Profile.SAFEDATA.install_complete) then SVUI_Profile.SAFEDATA.install_complete = nil end

    if SVUI_Filters then SVUI_Filters = nil end
    if not SVUI_AuraFilters then SVUI_AuraFilters = {} end

    if not SVUI_Cache then SVUI_Cache = {} end 
    if not SVUI_Cache["Dock"] then SVUI_Cache["Dock"] = {} end 
    if not SVUI_Cache["Mentalo"] then SVUI_Cache["Mentalo"] = {} end 
    if(not SVUI_Cache["screenheight"] or (SVUI_Cache["screenheight"] and type(SVUI_Cache["screenheight"]) ~= "number")) then 
    	SVUI_Cache["screenheight"] = gxHeight 
    end
    if(not SVUI_Cache["screenwidth"] or (SVUI_Cache["screenwidth"] and type(SVUI_Cache["screenwidth"]) ~= "number")) then 
    	SVUI_Cache["screenwidth"] = gxWidth 
    end

    --[[ MORE DEPRECATED ]]--
    if SVUI_Cache["Mentalo"]["Blizzard"] then SVUI_Cache["Mentalo"]["Blizzard"] = nil end 
    if SVUI_Cache["Mentalo"]["UI"] then SVUI_Cache["Mentalo"]["UI"] = nil end 
    --[[ END DEPRECATED ]]--

    self:SetDatabaseObjects(true)

	self:UIScale();
	self:RefreshSystemFonts();
	SVUISystemEventHandler:RegisterEvent('PLAYER_REGEN_DISABLED');
	self:LoadSystemAlerts();
	self.Registry:Lights();
end 

local function FullLoad(self)
	self:SetDatabaseObjects()
	self:UIScale("PLAYER_LOGIN");
	self.Registry:Camera();
	self.Registry:Action();
	self:DefinePlayerRole();
	self:LoadMovables();
	self:SetSVMovablesPositions();
	self.CoreEnabled = true;

	self:VersionCheck()

	self:RefreshAllSystemMedia();
	NewHook("StaticPopup_Show", self.StaticPopup_Show)

	SVUISystemEventHandler:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	SVUISystemEventHandler:RegisterEvent("PLAYER_TALENT_UPDATE");
	SVUISystemEventHandler:RegisterEvent("CHARACTER_POINTS_CHANGED");
	SVUISystemEventHandler:RegisterEvent("UNIT_INVENTORY_CHANGED");
	SVUISystemEventHandler:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	SVUISystemEventHandler:RegisterEvent("UI_SCALE_CHANGED");
	SVUISystemEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD");
	SVUISystemEventHandler:RegisterEvent("PET_BATTLE_CLOSE");
	SVUISystemEventHandler:RegisterEvent("PET_BATTLE_OPENING_START");
	SVUISystemEventHandler:RegisterEvent("ADDON_ACTION_BLOCKED");
	SVUISystemEventHandler:RegisterEvent("ADDON_ACTION_FORBIDDEN");
	SVUISystemEventHandler:RegisterEvent("SPELLS_CHANGED");

	self.Registry:Update("SVMap");
	self.Registry:Update("SVUnit", true);

	_G["SVUI_Mentalo"]:SetFixedPanelTemplate("Component")
	_G["SVUI_Mentalo"]:SetPanelColor("yellow")
	_G["SVUI_MentaloPrecision"]:SetPanelTemplate("Transparent")
	
	Consuela:RegisterAllEvents()
	Consuela:SetScript("OnEvent", function(self, event)
		LemonPledge = LemonPledge  +  1
		if (InCombatLockdown() and LemonPledge > 25000) or (not InCombatLockdown() and LemonPledge > 10000) or event == "PLAYER_ENTERING_WORLD" then
			collectgarbage("collect");
			LemonPledge = 0;
		end
	end)

	if self.db.system.loginmessage then 
		self:AddonMessage(format(L["LOGIN_MSG"], "|cffffcc1a", "|cffff801a", self.version));
	end 
end 

SVUISystemEventHandler:RegisterEvent("ADDON_LOADED")
SVUISystemEventHandler:RegisterEvent("PLAYER_LOGIN")
--[[ 
########################################################## 
EVENT HANDLER
##########################################################
]]--
local Registry_OnEvent = function(self, event, arg, ...)
	if(event == "ADDON_LOADED"  and arg ~= "Blizzard_DebugTools") then
		PreLoad(SuperVillain)
		self:UnregisterEvent("ADDON_LOADED")
	elseif(event == "PLAYER_LOGIN" and IsLoggedIn()) then
		FullLoad(SuperVillain)
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif(event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "UNIT_INVENTORY_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR") then
		SuperVillain:DefinePlayerRole()
	elseif(event == "UI_SCALE_CHANGED") then
		SuperVillain:UIScale("UI_SCALE_CHANGED")
	elseif(event == "PLAYER_ENTERING_WORLD") then
		SuperVillain:DefinePlayerRole()
		if(not SuperVillain.MediaUpdated) then 
			SuperVillain:RefreshAllSystemMedia()
			SuperVillain.MediaUpdated = true 
		end 
		local a,b = IsInInstance()
		if(b == "pvp") then 
			SuperVillain.BGTimer = SuperVillain:ExecuteLoop(RequestBattlefieldScoreData, 5)
		elseif(SuperVillain.BGTimer) then 
			SuperVillain:RemoveLoop(SuperVillain.BGTimer)
			SuperVillain.BGTimer = nil 
		end
	elseif(event == "SPELLS_CHANGED") then
		if (toonClass ~= "DRUID") then
			self:UnregisterEvent("SPELLS_CHANGED")
			return 
		end 
		if GetSpellInfo(droodSpell1) == droodSpell2 then 
			SuperVillain.Dispellable["Disease"] = true 
		elseif(SuperVillain.Dispellable["Disease"]) then
			SuperVillain.Dispellable["Disease"] = nil 
		end
	elseif(event == "PET_BATTLE_CLOSE") then
		SuperVillain:PushDisplayAudit()
	elseif(event == "PET_BATTLE_OPENING_START") then
		SuperVillain:FlushDisplayAudit()
	elseif(event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN") then
		SuperVillain:TaintHandler(arg, ...)
	elseif(event == "PLAYER_REGEN_DISABLED") then
		local forceClosed=false;
		if IsAddOnLoaded("SVUI_ConfigOMatic") then 
			local aceConfig=LibStub("AceConfigDialog-3.0")
			if aceConfig.OpenFrames[SVUINameSpace] then 
				self:RegisterEvent('PLAYER_REGEN_ENABLED')
				aceConfig:Close(SVUINameSpace)
				forceClosed = true 
			end 
		end 
		if SuperVillain.MentaloFrames then 
			for frame,_ in pairs(SuperVillain.MentaloFrames) do 
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
		if forceClosed==true then 
			SuperVillain:AddonMessage(ERR_NOT_IN_COMBAT)
		end
	elseif(event == "PLAYER_REGEN_ENABLED") then
		SuperVillain:ToggleConfig()
		self:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end
SVUISystemEventHandler:SetScript("OnEvent", Registry_OnEvent)