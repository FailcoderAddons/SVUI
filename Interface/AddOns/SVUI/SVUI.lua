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
############################################################################## ]]-- 

--[[ GLOBALS ]]--

local _G = _G;
--LUA
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
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local floor         = math.floor
--TABLE
local table         = _G.table;
local tsort         = table.sort;
local tconcat       = table.concat;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--BLIZZARD API
local ReloadUI              = _G.ReloadUI;
local GetLocale             = _G.GetLocale;
local CreateFrame           = _G.CreateFrame;
local IsAddOnLoaded         = _G.IsAddOnLoaded;
local InCombatLockdown      = _G.InCombatLockdown;
local GetAddOnInfo          = _G.GetAddOnInfo;
local LoadAddOn             = _G.LoadAddOn;
local SendAddonMessage      = _G.SendAddonMessage;
local LibStub               = _G.LibStub;
local GetAddOnMetadata      = _G.GetAddOnMetadata;
local GetCVarBool           = _G.GetCVarBool;
local GameTooltip           = _G.GameTooltip;
local StaticPopup_Hide      = _G.StaticPopup_Hide;
local ERR_NOT_IN_COMBAT     = _G.ERR_NOT_IN_COMBAT;

--[[  CONSTANTS ]]--

_G.BINDING_HEADER_SVUI = "Supervillain UI";
_G.BINDING_NAME_SVUI_MARKERS = "Raid Markers";
_G.BINDING_NAME_SVUI_DOCKS = "Toggle Docks";
_G.BINDING_NAME_SVUI_RIDE = "Let's Ride";

_G.SlashCmdList.RELOADUI = ReloadUI
_G.SLASH_RELOADUI1 = "/rl"
_G.SLASH_RELOADUI2 = "/reloadui"

--[[ GET THE REGISTRY LIB ]]--

local SVLib = _G.LibSuperVillain;

--[[ LOCALS ]]--

local callbacks = {};
local numCallbacks = 0;
local playerClass = select(2, UnitClass("player"));

local actualWidth, actualHeight = UIParent:GetSize()

--[[ CLASS COLOR LOCALS ]]--

local function RegisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :RegisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = h or true
    numCallbacks = numCallbacks + 1
end

local function UnregisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :UnregisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = nil
    numCallbacks = numCallbacks + 1
end

local function DispatchCallbacks()
    if (numCallbacks < 1) then return end 
    for m, h in pairs(callbacks) do
        local ok, err = pcall(m, h ~= true and h or nil)
        if not ok then
            print("ERROR:", err)
        end
    end
end

--[[ BUILD CLASS COLOR GLOBAL ]]--

local SVUI_CLASS_COLORS;

do
    local env = getfenv(0)
    env.SVUI_CLASS_COLORS = {}
    SVUI_CLASS_COLORS = env.SVUI_CLASS_COLORS

    local classes = {};
    local supercolors = {
        ["HUNTER"]        = { r = 0.454, g = 0.698, b = 0 },
        ["WARLOCK"]       = { r = 0.286, g = 0,     b = 0.788 },
        ["PRIEST"]        = { r = 0.976, g = 1,     b = 0.839 },
        ["PALADIN"]       = { r = 0.956, g = 0.207, b = 0.733 },
        ["MAGE"]          = { r = 0,     g = 0.796, b = 1 },
        ["ROGUE"]         = { r = 1,     g = 0.894, b = 0.117 },
        ["DRUID"]         = { r = 1,     g = 0.513, b = 0 },
        ["SHAMAN"]        = { r = 0,     g = 0.38,  b = 1 },
        ["WARRIOR"]       = { r = 0.698, g = 0.36,  b = 0.152 },
        ["DEATHKNIGHT"]   = { r = 0.847, g = 0.117, b = 0.074 },
        ["MONK"]          = { r = 0.015, g = 0.886, b = 0.38 },
    };
    for class in pairs(RAID_CLASS_COLORS) do
        tinsert(classes, class)
    end
    tsort(classes)
    setmetatable(SVUI_CLASS_COLORS,{
        __index = function(t, k)
            if k == "RegisterCallback" then return RegisterCallback end
            if k == "UnregisterCallback" then return UnregisterCallback end
            if k == "DispatchCallbacks" then return DispatchCallbacks end
        end
    });
    for i, class in ipairs(classes) do
        local color = supercolors[class]
        local r, g, b = color.r, color.g, color.b
        local hex = ("ff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
        if not SVUI_CLASS_COLORS[class] or not SVUI_CLASS_COLORS[class].r or not SVUI_CLASS_COLORS[class].g or not SVUI_CLASS_COLORS[class].b then
            SVUI_CLASS_COLORS[class] = {
                r = r,
                g = g,
                b = b,
                colorStr = hex,
            }
        end
    end
    classes = nil
end

--[[ CORE ENGINE CONSTRUCT ]]--

local messagePattern = "|cffFF2F00%s:|r";
local debugPattern = "|cffFF2F00%s|r [|cff992FFF%s|r]|cffFF2F00:|r";
local errorPattern = "|cffff0000Error -- |r|cffff9900Required addon '|r|cffffff00%s|r|cffff9900' is %s.|r"

local function _sendmessage(msg, prefix)
    if(type(msg) == "table") then 
         msg = tostring(msg) 
    end
    if(not msg) then return end
    if(prefix) then
        local outbound = ("%s %s"):format(prefix, msg);
        print(outbound)
    else
        print(msg)
    end
end

local Core_DeadFunction = function() return end

local Core_StaticPopup_Show = function(self, arg)
    if arg == "ADDON_ACTION_FORBIDDEN" then 
        StaticPopup_Hide(arg)
    end
end

local Core_Debugger = function(self, msg)
    if(not self.DebugMode) then return end
    local outbound = (debugPattern):format(self.NameID, "DEBUG")
    _sendmessage(msg, outbound) 
end

local Core_AddonMessage = function(self, msg)
    local outbound = (messagePattern):format(self.NameID)
    _sendmessage(msg, outbound) 
end

local Core_ResetAllUI = function(self, confirmed)
    if InCombatLockdown()then 
        SendAddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end 
    if(not confirmed) then 
        self:StaticPopup_Show('RESET_UI_CHECK')
        return 
    end 
    self.Setup:Reset()
end 

local Core_ResetUI = function(self, confirmed)
    if InCombatLockdown()then 
        SendAddonMessage(ERR_NOT_IN_COMBAT)
        return 
    end 
    if(not confirmed) then 
        self:StaticPopup_Show('RESETMOVERS_CHECK')
        return 
    end 
    self.Mentalo:Reset()
end

local Core_ImportProfile = function(self, key)
    self.SystemAlert["COPY_PROFILE_PROMPT"].text = "Are you sure you want to copy the profile '" .. key .. "'?"
    self.SystemAlert["COPY_PROFILE_PROMPT"].OnAccept = function() SVLib:ImportDatabase(key) end
    self:StaticPopup_Show("COPY_PROFILE_PROMPT")
end

local Core_ToggleConfig = function(self)
    if InCombatLockdown() then 
        SendAddonMessage(ERR_NOT_IN_COMBAT) 
        self.UIParent:RegisterEvent('PLAYER_REGEN_ENABLED')
        return 
    end 
    if not IsAddOnLoaded(self.ConfigID) then 
        local _,_,_,_,_,state = GetAddOnInfo(self.ConfigID)
        if state ~= "MISSING" and state ~= "DISABLED" then 
            LoadAddOn(self.ConfigID)
            local config_version = GetAddOnMetadata(self.ConfigID, "Version")
            if(tonumber(config_version) < 4) then 
                self:StaticPopup_Show("CLIENT_UPDATE_REQUEST")
            end 
        else
            local errorMessage = (errorPattern):format(self.ConfigID, state)
            self:AddonMessage(errorMessage)
            return 
        end 
    end 
    local aceConfig = LibStub("AceConfigDialog-3.0")
    local switch = not aceConfig.OpenFrames[self.NameID] and "Open" or "Close"
    aceConfig[switch](aceConfig, self.NameID)
    GameTooltip:Hide()
end 

local Core_TaintHandler = function(self, taint, sourceName, sourceFunc)
    if GetCVarBool('scriptErrors') ~= 1 then return end
    local errorString = ("Error Captured: %s->%s->{%s}"):format(taint, sourceName or "Unknown", sourceFunc or "Unknown")
    self:AddonMessage(errorString)
    self:StaticPopup_Show("TAINT_RL")
end
--[[ 
#####################################################################################
  /$$$$$$  /$$    /$$ /$$   /$$ /$$$$$$        /$$$$$$   /$$$$$$  /$$$$$$$  /$$$$$$$$
 /$$__  $$| $$   | $$| $$  | $$|_  $$_/       /$$__  $$ /$$__  $$| $$__  $$| $$_____/
| $$  \__/| $$   | $$| $$  | $$  | $$        | $$  \__/| $$  \ $$| $$  \ $$| $$      
|  $$$$$$ |  $$ / $$/| $$  | $$  | $$        | $$      | $$  | $$| $$$$$$$/| $$$$$   
 \____  $$ \  $$ $$/ | $$  | $$  | $$        | $$      | $$  | $$| $$__  $$| $$__/   
 /$$  \ $$  \  $$$/  | $$  | $$  | $$        | $$    $$| $$  | $$| $$  \ $$| $$      
|  $$$$$$/   \  $/   |  $$$$$$/ /$$$$$$      |  $$$$$$/|  $$$$$$/| $$  | $$| $$$$$$$$
 \______/     \_/     \______/ |______/       \______/  \______/ |__/  |__/|________/
#####################################################################################
]]--

--[[ INITIALIZE THE CORE OBJECT ]]--

-- We have to send the names of our three SavedVariables files since the WoW API
-- has no method for parsing them in LUA.
local SVUI = SVLib:NewCore("SVUI_Global", "SVUI_Profile", "SVUI_Cache")

SVUI.ConfigID           = "SVUI_ConfigOMatic";

SVUI.Media              = {}

SVUI.class              = playerClass
SVUI.ClassRole          = ""
SVUI.UnitRole           = "NONE"
SVUI.ConfigurationMode  = false
SVUI.EffectiveScale     = 1
SVUI.ActualHeight       = actualHeight
SVUI.ActualWidth        = actualWidth
SVUI.yScreenArea        = (actualHeight * 0.33)
SVUI.xScreenArea        = (actualWidth * 0.33)

SVUI.fubar              = Core_DeadFunction
SVUI.ResetAllUI         = Core_ResetAllUI
SVUI.ResetUI            = Core_ResetUI
SVUI.ToggleConfig       = Core_ToggleConfig
SVUI.TaintHandler       = Core_TaintHandler
SVUI.ImportProfile      = Core_ImportProfile
SVUI.AddonMessage       = Core_AddonMessage
SVUI.Debugger           = Core_Debugger
SVUI.StaticPopup_Show   = Core_StaticPopup_Show

--[[ UTILITY FRAMES ]]--

SVUI.UIParent = CreateFrame("Frame", "SVUIParent", UIParent);
SVUI.UIParent:SetFrameLevel(UIParent:GetFrameLevel());
SVUI.UIParent:SetPoint("CENTER", UIParent, "CENTER");
SVUI.UIParent:SetSize(UIParent:GetSize());

SVUI.Cloaked = CreateFrame("Frame", nil, UIParent);
SVUI.Cloaked:Hide();

SVUI.Options = { 
    type = "group", 
    name = "|cff339fffConfig-O-Matic|r", 
    args = {
        plugins = {
            order = -2,
            type = "group",
            name = "Plugins",
            childGroups = "tab",
            args = {
                pluginheader = {
                    order = 1,
                    type = "header",
                    name = "Supervillain Plugins",
                },
                pluginOptions = {
                    order = 2,
                    type = "group",
                    name = "",
                    args = {
                        pluginlist = {
                            order = 1,
                            type = "group",
                            name = "Summary",
                            args = {
                                active = {
                                    order = 1,
                                    type = "description",
                                    name = function() return SVLib:GetPlugins() end
                                }
                            }
                        },
                    }
                }
            }
        }
    }
}