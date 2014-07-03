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
local resolution = GetCVar("gxResolution");
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
BUILD ADDON OBJECTS
##########################################################
]]--
local SuperVillain = {};
SuperVillain.Filters = {};
SuperVillain.db = {};
SuperVillain.Media = {};
SuperVillain.DisplayAudit = {};
SuperVillain.DynamicOptions = {};
SuperVillain.snaps = {};
SuperVillain.Options = { type="group", name="|cff339fffConfig-O-Matic|r", args={}, };

local svui_meta = {}
local base_meta = getmetatable(SuperVillain)
if base_meta then
	for k, v in pairs(base_meta) do svui_meta[k] = v end
end
svui_meta._name = "SuperVillain"
svui_meta.__tostring = function(self) return self._name end
setmetatable(SuperVillain, svui_meta)

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
CREATE GLOBAL NAMESPACE
##########################################################
]]--
SuperVillain.version = GetAddOnMetadata(..., "Version");
SuperVillain.HVAL = format("|cff%02x%02x%02x",0.2*255,0.5*255,1*255);
SuperVillain.class = select(2,UnitClass("player"));
SuperVillain.name = UnitName("player");
SuperVillain.realm = GetRealmName();
SuperVillain.build = tonumber(bld);
SuperVillain.race = select(2,UnitRace("player"));
SuperVillain.faction = select(2,UnitFactionGroup('player'));
SuperVillain.guid = UnitGUID('player');
SuperVillain.mac = IsMacClient();
SuperVillain.screenheight = tonumber(match(resolution,"%d+x(%d+)"));
SuperVillain.screenwidth = tonumber(match(resolution,"(%d+)x%d+"));
SuperVillain.macheight = tonumber(match(resolution,"%d+x(%d+)"));
SuperVillain.macwidth = tonumber(match(resolution,"(%d+)x%d+"));
SuperVillain.mult = 1;
--[[ INTERNAL TEMP STORAGE ]]--
SuperVillain.ConfigurationMode = false;
SuperVillain.ClassRole = "";
--[[ INTERNAL HANDLER FRAMES ]]--
local SVUISystemEventHandler = CreateFrame("Frame", "SVUISystemEventHandler")
local SVUIParent = CreateFrame('Frame','SVUIParent',UIParent);
SVUIParent:SetFrameLevel(UIParent:GetFrameLevel());
SVUIParent:SetPoint('CENTER',UIParent,'CENTER');
SVUIParent:SetSize(UIParent:GetSize());
SuperVillain.UIParent = SVUIParent;
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
local RefClassData = {
	PALADIN = {
		["ROLE"] = {"C", "T", "M"}, 
		["DISPELL"] = {["Poison"] = true, ["Magic"] = false, ["Disease"] = true}, 
		["MagicSpec"] = 1
	}, 
	PRIEST = {
		["ROLE"] = {"C", "C", "C"}, 
		["DISPELL"] = {["Magic"] = true, ["Disease"] = true}, 
		["MagicSpec"] = false
	}, 
	WARLOCK = {
		["ROLE"] = {"C", "C", "C"}, 
		["DISPELL"] = false, 
		["MagicSpec"] = false
	}, 
	WARRIOR = {
		["ROLE"] = {"M", "M", "T"}, 
		["DISPELL"] = false, 
		["MagicSpec"] = false
	}, 
	HUNTER = {
		["ROLE"] = {"M", "M", "M"}, 
		["DISPELL"] = false, 
		["MagicSpec"] = false
	}, 
	SHAMAN = {
		["ROLE"] = {"C", "M", "C"}, 
		["DISPELL"] = {["Magic"] = false, ["Curse"] = true}, 
		["MagicSpec"] = 3
	}, 
	ROGUE = {
		["ROLE"] = {"M", "M", "M"}, 
		["DISPELL"] = false, 
		["MagicSpec"] = false
	}, 
	MAGE = {
		["ROLE"] = {"C", "C", "C"}, 
		["DISPELL"] = {["Curse"] = true}, 
		["MagicSpec"] = false
	}, 
	DEATHKNIGHT = {
		["ROLE"] = {"T", "M", "M"}, 
		["DISPELL"] = false, 
		["MagicSpec"] = false
	}, 
	DRUID = {
		["ROLE"] = {"C", "M", "T", "C"}, 
		["DISPELL"] = {["Magic"] = false, ["Curse"] = true, ["Poison"] = true, ["Disease"] = false}, 
		["MagicSpec"] = 4
	}, 
	MONK = {
		["ROLE"] = {"T", "C", "M"}, 
		["DISPELL"] = {["Magic"] = false, ["Disease"] = true, ["Poison"] = true}, 
		["MagicSpec"] = 2
	}
}

local DispellData = RefClassData[SuperVillain.class]["DISPELL"];

local function GetTalentInfo(arg)
	if type(arg) == "number" then 
		return arg == GetActiveSpecGroup();
	else
		return false;
	end 
end

function SuperVillain:DispellAvailable(debuffType)
	if not DispellData then return end 
	if DispellData[debuffType] then 
		return true 
	end 
end

function SuperVillain:DefinePlayerRole()
	local spec = GetSpecialization()
	local role;
	if spec then
		role = RefClassData[self.class]["ROLE"][spec]
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
	if RefClassData[self.class]["MagicSpec"] then 
		if GetTalentInfo(RefClassData[self.class]["MagicSpec"]) then 
			DispellData.Magic = true 
		else 
			DispellData.Magic = false 
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
            end;
            targetTable[key] = val 
        end 
    end;
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
			if(tonumber(config_version) < self.version) then 
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

function SuperVillain:TaintHandler(taint,sourceName,sourceFunc)
	if GetCVarBool('scriptErrors') ~= 1 then return end 
	ScriptErrorsFrame_OnError(L["%s: %s has lost it's damn mind and is destroying '%s'."]:format(taint, sourceName or "<name>", sourceFunc or "<func>"),false)
end 
--[[ 
########################################################## 
SYSTEM UPDATES
##########################################################
]]--
function SuperVillain:RefreshEverything(bypass)
	self:RefreshAllSystemMedia();

	SuperVillain.UIParent:Hide();

	self:SetSVMovablesPositions();
	self.Registry:Update('SVUnit');
	self.Registry:UpdateAll();

	SuperVillain.UIParent:Show();

	collectgarbage("collect");

	if not bypass then
		if(SVUI_Profile.SAFEDATA.install_complete == nil or (SVUI_Profile.SAFEDATA.install_complete and type(SVUI_Profile.SAFEDATA.install_complete) == 'boolean') or (SVUI_Profile.SAFEDATA.install_complete and type(tonumber(SVUI_Profile.SAFEDATA.install_complete)) == 'number' and tonumber(SVUI_Profile.SAFEDATA.install_complete) < self.version)) then 
			self:Install(); 
		end
	end
end 
--[[ 
########################################################## 
SVUI LOAD PROCESS
##########################################################
]]--
local function PreLoad(self)
	--[[ BEGIN DEPRECATED ]]--
    if SVUI_DATA then SVUI_DATA = nil end;
    if SVUI_SAFE_DATA then SVUI_SAFE_DATA = nil end;
    if SVUI_TRACKER then SVUI_TRACKER = nil end;
    if SVUI_ENEMIES then SVUI_ENEMIES = nil end;
    if SVUI_JOURNAL then SVUI_JOURNAL = nil end;
    if SVUI_CHARACTER_LOG then SVUI_CHARACTER_LOG = nil end;
    if SVUI_MOVED_FRAMES then SVUI_MOVED_FRAMES = nil end;
    if SVUI_SystemData then SVUI_SystemData = nil end;
    if SVUI_ProfileData then SVUI_ProfileData = nil end;
    --[[ END DEPRECATED ]]--
    
	if not SVUI_Global then SVUI_Global = {} end;
    if not SVUI_Global["profiles"] then SVUI_Global["profiles"] = {} end;
    if not SVUI_Global["profileKeys"] then SVUI_Global["profileKeys"] = {} end;
    if not SVUI_Global["gold"] then SVUI_Global["gold"] = 0 end;

    if not SVUI_Profile then SVUI_Profile = {} end;
    if not SVUI_Profile.SAFEDATA then SVUI_Profile.SAFEDATA = {} end;

    if not SVUI_Filters then SVUI_Filters = {} end;

    if not SVUI_Cache then SVUI_Cache = {} end;
    if not SVUI_Cache["Dock"] then SVUI_Cache["Dock"] = {} end;
    if not SVUI_Cache["Mentalo"] then SVUI_Cache["Mentalo"] = {} end;

    --[[ MORE DEPRECATED ]]--
    if SVUI_Cache["Mentalo"]["Blizzard"] then SVUI_Cache["Mentalo"]["Blizzard"] = nil end;
    if SVUI_Cache["Mentalo"]["UI"] then SVUI_Cache["Mentalo"]["UI"] = nil end;
    --[[ END DEPRECATED ]]--

    self:SetDatabaseObjects(true)

	self:UIScale();
	self:RefreshSystemFonts();
	SVUISystemEventHandler:RegisterEvent('PLAYER_REGEN_DISABLED');
	self:LoadSystemAlerts();
	self.Registry:PreLoad();
end 

local function FullLoad(self)
	self:SetDatabaseObjects()
	self:SetFilterObjects()
	self:UIScale("PLAYER_LOGIN");
	self.Registry:Load();
	self:DefinePlayerRole();
	self:LoadMovables();
	self:SetSVMovablesPositions();
	self.CoreEnabled = true;

	if (SVUI_Profile.SAFEDATA.install_complete == nil or not SVUI_Profile.install_version or SVUI_Profile.install_version  ~= self.version) then 
		self:Install()
		SVUI_Profile.install_version = self.version 
	end 

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
	_G["SVUI_MentaloPrecision"]:SetFixedPanelTemplate("Default")

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
local Registry_OnEvent = function(self, event, arg1)
	if(event == "ADDON_LOADED"  and arg1 ~= "Blizzard_DebugTools") then
		PreLoad(SuperVillain)
		self:UnregisterEvent("ADDON_LOADED")
	elseif(event == "PLAYER_LOGIN" and IsLoggedIn()) then
		FullLoad(SuperVillain)
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif(event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "UNIT_INVENTORY_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR") then
		SuperVillain:DefinePlayerRole()
	elseif(event == "UI_SCALE_CHANGED") then
		SuperVillain:UIScale()
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
		if (SuperVillain.class ~= "DRUID") then
			self:UnregisterEvent("SPELLS_CHANGED")
			return 
		end 
		if GetSpellInfo(droodSpell1) == droodSpell2 then 
			DispellData.Disease = true 
		else 
			DispellData.Disease = false 
		end
	elseif(event == "PET_BATTLE_CLOSE") then
		SuperVillain:PushDisplayAudit()
	elseif(event == "PET_BATTLE_OPENING_START") then
		SuperVillain:FlushDisplayAudit()
	elseif(event == "ADDON_ACTION_BLOCKED" or event == "ADDON_ACTION_FORBIDDEN") then
		SuperVillain:TaintHandler()
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