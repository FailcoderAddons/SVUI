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
local rawset    = _G.rawset;
local rawget    = _G.rawget;
local tinsert   = _G.tinsert;
local tremove   = _G.tremove;
local string    = _G.string;
local table     = _G.table;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ TABLE METHODS ]]--
local tdump = table.dump;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MAJOR = "SuperVillain Plugins";
local MINOR = GetAddOnMetadata(..., "Version");

local INFO_BY = "by";
local INFO_VERSION = "Version:";
local INFO_NEW = "Newest:";
local INFO_NAME = "Plugins";
local INFO_HEADER = "SuperVillain UI (version %.3f): Plugins";

if GetLocale() == "ruRU" then
    INFO_BY = "от";
    INFO_VERSION = "Версия:";
    INFO_NEW = "Последняя:";
    INFO_NAME = "Плагины";
    INFO_HEADER = "SuperVillain UI (устарела %.3f): Плагины";
end

local function SetPrototype(obj)
    obj.db = {}
    obj._loaded = false
    obj.CombatLocked = false
    obj.ChangeDBVar = function(obj, value, key, sub1, sub2, sub3)
        if((sub1 and sub2 and sub3) and (obj.db[sub1] and obj.db[sub1][sub2] and obj.db[sub1][sub2][sub3])) then
            obj.db[sub1][sub2][sub3][key] = value;
            SuperVillain.db[obj._name][sub1][sub2][sub3][key] = value;
        elseif((sub1 and sub2) and (obj.db[sub1] and obj.db[sub1][sub2])) then
            obj.db[sub1][sub2][key] = value;
            SuperVillain.db[obj._name][sub1][sub2][key] = value;
        elseif(sub1 and obj.db[sub1]) then
            obj.db[sub1][key] = value;
            SuperVillain.db[obj._name][sub1][key] = value;
        else
            obj.db[key] = value;
            SuperVillain.db[obj._name][key] = value;
        end
    end
    obj.Protect = function(obj, fnKey, autorun)
        SuperVillain.Security:Register(obj, fnKey, autorun);
    end
    obj.UnProtect = function(obj, fnKey) 
        SuperVillain.Security:UnRegister(obj, fnKey);
    end
    obj.RegisterEvent = function(obj, eventname, eventfunc)
        if not obj.___eventframe then
            obj.___eventframe = CreateFrame("Frame", nil)
            obj.___eventframe:SetScript("OnEvent", function(self, event, ...)
                if self[event] and type(self[event]) == "function" then
                    self[event](obj, event, ...)
                end
            end)
        end
        local fn = eventfunc
        if type(eventfunc) == "string" then
            fn = obj[eventfunc]
        elseif(not fn and obj[eventname]) then
            fn = obj[eventname]
        end
        obj.___eventframe[eventname] = fn
        obj.___eventframe:RegisterEvent(eventname)
    end
    obj.UnregisterEvent = function(obj, event, func)
        if(obj.___eventframe) then
            obj.___eventframe:UnregisterEvent(event)
        end
    end
    return obj
end
--[[ 
########################################################## 
REGISTRY MASTER METATABLE
##########################################################
]]--
local METAREGISTRY = function()
    local _nameindex = {}
    local _queue = {[1] = {}, [2] = {}, [3] = {}}
    local tempScripts, tempMethods = {}, {}
    local _addontostring = function(t)
        return t._name
    end
    local methods = {
        _packages = {},
        _plugins = {},
        _callbacks = {},
        _loadPkg = function(_, priority)
            if not _queue[priority] then return end;
            local pkgList = _queue[priority]
            for i=1,#pkgList do 
                local name = pkgList[i]
                local obj = _._packages[name]
                if obj and not obj._loaded then
                    if SuperVillain.db[name] then
                        obj.db = SuperVillain.db[name]
                    end
                    if obj.Load then
                        obj:Load()
                        obj.Load = nil
                    end
                    obj._loaded = true;
                end 
            end
            _queue[priority] = nil
        end,
        Expose = function(_, name)
            --assert(_._packages[name], "Expose: The package " .. name .. " does not exist");
            return _._packages[name] or false
        end,
        SetCallback = function(_, fn)
            if(fn and type(fn) == "function") then
                _._callbacks[#_._callbacks  +  1] = fn
            end 
        end,
        NewScript = function(_, fn)
            if(fn and type(fn) == "function") then
                tempScripts[#tempScripts  +  1] = fn
            end 
        end,
        NewPackage = function(_, obj, name, priority)
            if _._packages[name] then return end
            obj._name = name
            if(priority == "pre") then
                tinsert(_queue[1], name)
            elseif(priority == "post") then
                tinsert(_queue[3], name)
            else
                tinsert(_queue[2], name)
            end

            local addonmeta = {}
            local oldmeta = getmetatable(obj)
            if oldmeta then
                for k, v in pairs(oldmeta) do addonmeta[k] = v end
            end
            addonmeta.__tostring = _addontostring

            setmetatable( obj, addonmeta )
            _._packages[name] = SetPrototype(obj)

            if(SuperVillain.CoreEnabled) then 
                if(_._packages[name].Load) then 
                    _._packages[name]:Load()
                end
            end
        end,
        FetchPlugins = function(_)
            local list = "";
            for _, plugin in pairs(_._plugins) do
                if plugin.name ~= MAJOR then
                    local author = GetAddOnMetadata(plugin.name, "Author")
                    local Pname = GetAddOnMetadata(plugin.name, "Title") or plugin.name
                    local color = plugin.old and SuperVillain:HexColor(1,0,0) or SuperVillain:HexColor(0,1,0)
                    list = list .. Pname 
                    if author then
                      list = list .. " ".. INFO_BY .." " .. author
                    end
                    list = list .. color .. " - " .. INFO_VERSION .." " .. plugin.version
                    if plugin.old then
                      list = list .. INFO_NEW .. plugin.newversion .. ")"
                    end
                    list = list .. "|r\n"
                end
            end
            return list
        end,
        NewPlugin = function(_, name, func)
            local plugin = _._plugins[name] or {}
            plugin.name = name
            plugin.version = name == MAJOR and MINOR or GetAddOnMetadata(name, "Version")
            plugin.callback = func
            local enable, loadable = select(4,GetAddOnInfo("SVUI_ConfigOMatic"))
            local loaded = IsAddOnLoaded("SVUI_ConfigOMatic")
            if(enable and loadable and not loaded) then
                if not plugin.PluginTempFrame then
                    local tempframe = CreateFrame("Frame")
                    tempframe:RegisterEvent("ADDON_LOADED")
                    tempframe:SetScript("OnEvent", function(self, event, addon)
                        if addon == "SVUI_ConfigOMatic" then
                            for i, plugin in pairs(_._plugins) do
                                if(plugin.callback) then
                                    plugin.callback()
                                end
                            end
                        end
                    end)
                    plugin.PluginTempFrame = tempframe
                end
            elseif(enable and loadable) then
                if name ~= MAJOR then
                    SuperVillain.Options.args.plugins.args.pluginlist.name = _:FetchPlugins()
                end
                if(func) then
                    func()
                end
            end
            _._plugins[name] = plugin
        end,
        RunTemp = function(_, name)
            local t = _._packages[name]
            for i,fn in pairs(tempMethods[name]) do
                if(fn and type(fn) == "function") then
                    fn(t)
                end 
            end
            tempMethods[name] = nil
        end,
        RunCallbacks = function(_)
            for i=1, #_._callbacks do 
                local fn = _._callbacks[i]
                if(fn and type(fn) == "function") then
                    fn()
                end
            end
        end,
        Temp = function(_, name, func)
            --assert(_._packages[name], "Temp: The package " .. name .. " does not exist");
            if(not tempMethods[name]) then
                tempMethods[name] = {}
            end
            local t = tempMethods[name]
            t[#t + 1] = func
        end,
        Update = function(_, name, dataOnly)
            --assert(_._packages[name], "Update: The package " .. name .. " does not exist");
            local obj = _._packages[name]
            if obj then
                if SuperVillain.db[name] then
                    obj.db = SuperVillain.db[name]
                end
                if obj.ReLoad and not dataOnly then
                    obj:ReLoad()
                end
            end
        end,
        UpdateAll = function(_)
            print("Registry: Updating")
            local pkgList = _._packages
            for name,obj in pairs(pkgList) do
                print(name)
                local name = obj._name
                if obj and obj.ReLoad then
                    if SuperVillain.db[name] then
                        obj.db = SuperVillain.db[name]
                    end
                    obj:ReLoad()
                end
            end
        end,

        --construct stored classes
        
        Lights = function(_)
            _:_loadPkg(1)
        end,
        Camera = function(_)
            _:_loadPkg(2)
            _:_loadPkg(3)
        end,
        Action = function(_)
            local count = #tempScripts
            for i=1, count do 
                local fn = tempScripts[i]
                if(fn and type(fn) == "function") then
                    fn()
                end 
            end
        end,
    };
    local mt ={
        __index = function(t,  k)
            v = rawget(_nameindex,  k)
            if v then 
                return v
            end
        end, 
        __tostring = function(t) return "SuperVillain.Registry >>> [" .. tdump(_nameindex) .. "]" end, 
    };
    setmetatable(methods,  mt)
    return methods
end;
do
    SuperVillain.Registry = METAREGISTRY();
end;
--[[ 
########################################################## 
LIB FUNCTIONS
##########################################################
]]--
local GetOptions = function()
    SuperVillain.Options.args.plugins = {
        order = -10,
        type = "group",
        name = INFO_NAME,
        guiInline = false,
        args = {
            pluginheader = {
                order = 1,
                type = "header",
                name = format(INFO_HEADER, MINOR),
            },
            pluginlist = {
                order = 2,
                type = "description",
                name = SuperVillain.Registry:FetchPlugins(),
            },
        }
    }
end;

SuperVillain.Registry:NewPlugin("SuperVillain Plugins", GetOptions)