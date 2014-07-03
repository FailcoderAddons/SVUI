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
local unpack        = _G.unpack;
local select        = _G.select;
local pairs         = _G.pairs;
local type          = _G.type;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local tostring      = _G.tostring;
local error         = _G.error;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local upper = string.upper;
local format, find, match, gsub = string.format, string.find, string.match, string.gsub;
--[[ MATH METHODS ]]--
local floor = math.floor
--[[ TABLE METHODS ]]--
local tsort, tconcat = table.sort, table.concat;
--[[ 
########################################################## 
CONSTANTS
##########################################################
]]--
SVUI_LOCALE = {}
BINDING_HEADER_SVUI = GetAddOnMetadata(..., "Title");
SLASH_RELOADUI1="/rl"
SLASH_RELOADUI2="/reloadui"
SlashCmdList.RELOADUI=ReloadUI
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local callbacks = {};
local numCallbacks = 0;
--[[ 
########################################################## 
MUNGLUNCH's FASTER ASSERT FUNCTION
##########################################################
]]--
function enforce(condition, ...)
   if not condition then
      if next({...}) then
         local fn = function (...) return(string.format(...)) end
         local s,r = pcall(fn, ...)
         if s then
            error("Error!: " .. r, 2)
         end
      end
      error("Error!", 2)
   end
end
local assert = enforce;
--[[ 
########################################################## 
LOCALIZATION GLOBAL
##########################################################
]]--
local failsafe = function() assert(false) end

local metaread = {
    __index = function(self, key)
        rawset(self, key, key)
        return key
    end
}

local activeLocale

local defaultwrite = setmetatable({}, {
    __newindex = function(self, key, value)
        if not rawget(activeLocale, key) then
            rawset(activeLocale, key, value == true and key or value)
        end
    end,
    __index = failsafe
})

local metawrite = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(activeLocale, key, value == true and key or value)
    end,
    __index = failsafe
})

function SVUI_LOCALE:SetLocalStrings(locale, isDefault)
    local gameLocale = GetLocale()
    if gameLocale == "enGB" then gameLocale = "enUS" end

    if not SVUI_LOCALE["LANG"] then
        SVUI_LOCALE["LANG"] = setmetatable({}, metaread)
    end

    activeLocale = SVUI_LOCALE["LANG"]

    if isDefault then
        return defaultwrite
    elseif(locale == GAME_LOCALE or locale == gameLocale) then
        return metawrite
    end
end

function SVUI_LOCALE:SetObject()
    return SVUI_LOCALE["LANG"]
end
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function formatValueString(text)
    if "string" == type(text) then 
        text = gsub(text,"\n","\\n")
        if match(gsub(text,"[^'\"]",""),'^"+$') then 
            return "'"..text.."'"; 
        else 
            return '"'..gsub(text,'"','\\"')..'"';
        end;
    else 
        return tostring(text);
    end
end;
local function formatKeyString(text)
    if "string"==type(text) and match(text,"^[_%a][_%a%d]*$") then 
        return text;
    else 
        return "["..formatValueString(text).."]";
    end
end;
local function RegisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :RegisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = h or true
    numCallbacks = numCallbacks + 1
end;
local function UnregisterCallback(self, m, h)
    assert(type(m) == "string" or type(m) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
    if type(m) == "string" then
        assert(type(h) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
        assert(type(h[m]) == "function", "Bad argument #1 to :UnregisterCallback (m \"" .. m .. "\" not found)")
        m = h[m]
    end
    callbacks[m] = nil
    numCallbacks = numCallbacks + 1
end;
local function DispatchCallbacks()
    if (numCallbacks < 1) then return end;
    for m, h in pairs(callbacks) do
        local ok, err = pcall(m, h ~= true and h or nil)
        if not ok then
            print("ERROR:", err)
        end
    end
end;
--[[ 
########################################################## 
BUILD CLASS COLOR GLOBAL
##########################################################
]]--
SVUI_CLASS_COLORS = {};
do
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
        local hex = format("ff%02x%02x%02x", r * 255, g * 255, b * 255)
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
end;
--[[ 
########################################################## 
APPENDED GLOBAL FUNCTIONS
##########################################################
]]--
function math.parsefloat(value,decimal)
    if decimal and decimal > 0 then 
        local calc1 = 10 ^ decimal;
        local calc2 = (value * calc1) + 0.5;
        return floor(calc2) / calc1
    end;
    return floor(value + 0.5)
end

function table.dump(targetTable)
    local dumpTable = {};
    local dumpCheck = {};
    for key,value in ipairs(targetTable) do 
        tinsert(dumpTable, formatValueString(value));
        dumpCheck[key] = true; 
    end;
    for key,value in pairs(targetTable) do 
        if not dumpCheck[key] then 
            tinsert(dumpTable, "\n    "..formatKeyString(key).." = "..formatValueString(value));
        end 
    end;
    local output = tconcat(dumpTable, ", ");
    return "{ "..output.." }";
end

function table.copy(targetTable,deepCopy,mergeTable)
    mergeTable = mergeTable or {};
    if targetTable==nil then return nil end;
    if mergeTable[targetTable] then return mergeTable[targetTable] end;
    local replacementTable = {}
    for key,value in pairs(targetTable)do 
        if deepCopy and type(value) == "table" then 
            replacementTable[key] = table.copy(value, deepCopy, mergeTable)
        else 
            replacementTable[key] = value 
        end 
    end;
    setmetatable(replacementTable, table.copy(getmetatable(targetTable), deepCopy, mergeTable))
    mergeTable[targetTable] = replacementTable;
    return replacementTable 
end

function string.trim(this)
    return this:find'^%s*$' and '' or this:match'^%s*(.*%S)'
end

function string.color(this,color)
    return "|cff"..color..this.."|r";
end

function string.link(this,prefix,text,color)
    return "|H"..prefix..":"..tostring(text).."|h"..tostring(this):color(color or"ffffff").."|h";
end