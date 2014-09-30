--[[
  /$$$$$$  /$$   /$$ /$$$$$$$  /$$$$$$$$ /$$$$$$$                  
 /$$__  $$| $$  | $$| $$__  $$| $$_____/| $$__  $$                 
| $$  \__/| $$  | $$| $$  \ $$| $$      | $$  \ $$                 
|  $$$$$$ | $$  | $$| $$$$$$$/| $$$$$   | $$$$$$$/                 
 \____  $$| $$  | $$| $$____/ | $$__/   | $$__  $$                 
 /$$  \ $$| $$  | $$| $$      | $$      | $$  \ $$                 
|  $$$$$$/|  $$$$$$/| $$      | $$$$$$$$| $$  | $$                 
 \______/  \______/ |__/      |________/|__/  |__/                 
 /$$    /$$ /$$$$$$ /$$       /$$        /$$$$$$  /$$$$$$ /$$   /$$
| $$   | $$|_  $$_/| $$      | $$       /$$__  $$|_  $$_/| $$$ | $$
| $$   | $$  | $$  | $$      | $$      | $$  \ $$  | $$  | $$$$| $$
|  $$ / $$/  | $$  | $$      | $$      | $$$$$$$$  | $$  | $$ $$ $$
 \  $$ $$/   | $$  | $$      | $$      | $$__  $$  | $$  | $$  $$$$
  \  $$$/    | $$  | $$      | $$      | $$  | $$  | $$  | $$\  $$$
   \  $/    /$$$$$$| $$$$$$$$| $$$$$$$$| $$  | $$ /$$$$$$| $$ \  $$
    \_/    |______/|________/|________/|__/  |__/|______/|__/  \__/
                                                                   

LibSuperVillain is a library used to manage localization, packages, scripts and data embedded
into the SVUI core addon.

It's main purpose is to keep all methods and logic needed to properly keep
core add-ins functioning outside of the core object.                                                                     
--]]

--[[ LOCALIZED GLOBALS ]]--
local _G            = getfenv(0);
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local pairs         = _G.pairs;
local type          = _G.type;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local error         = _G.error;
local next          = _G.next;
local pcall         = _G.pcall;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
local assert        = _G.assert;
--BLIZZARD
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
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

--[[ LIB CONSTRUCT ]]--
local lib = _G["LibSuperVillain"]
if not lib then
    _G["LibSuperVillain"] = {}
    lib = _G["LibSuperVillain"]
end

--[[ ADDON DATA ]]--

local CoreName, CoreObject  = ...
local AddonVersion          = GetAddOnMetadata(..., "Version");
local SchemaFromMeta        = "X-" .. CoreName .. "-Schema";
local HeaderFromMeta        = "X-" .. CoreName .. "-Header";
local InterfaceVersion      = select(4, GetBuildInfo());

--[[ COMMON LOCAL VARS ]]--

local GLOBAL_FILENAME       = CoreName.."_Global";
local PROFILE_FILENAME      = CoreName.."_Profile";
local CACHE_FILENAME        = CoreName.."_Cache";
local SOURCE_KEY            = 1;
local GLOBAL_SV, PROFILE_SV, CACHE_SV, PLUGINS, MODULES;
local PluginString = ""
local AllowedIndexes, LoadOnDemand = {},{};
local Callbacks, ScriptQueue = {},{};

AllowedIndexes.G = {}
AllowedIndexes.C = {}
AllowedIndexes.P = {}

local playerClass = select(2,UnitClass("player"));

local INFO_FORMAT = "|cffFFFF00%s|r\n        |cff33FF00Version: %s|r |cff0099FFby %s|r";

if GetLocale() == "ruRU" then
    INFO_FORMAT = "|cffFFFF00%s|r\n        |cff33FF00Версия: %s|r |cff0099FFот %s|r";
end

--[[ LIB EVENT LISTENER ]]--

lib.EventManager = CreateFrame("Frame", nil)

--[[ COMMON META METHODS ]]--

local rootstring = function(self) return self.NameID end

--[[ CUSTOM LUA METHODS ]]--

--LOCAL HELPERS
local function formatValueString(text)
    if "string" == type(text) then 
        text = gsub(text,"\n","\\n")
        if match(gsub(text,"[^'\"]",""),'^"+$') then 
            return "'"..text.."'"; 
        else 
            return '"'..gsub(text,'"','\\"')..'"';
        end 
    else 
        return tostring(text);
    end
end

local function formatKeyString(text)
    if "string"==type(text) and match(text,"^[_%a][_%a%d]*$") then 
        return text;
    else 
        return "["..formatValueString(text).."]";
    end
end

--APPENDED METHODS
function table.dump(targetTable)
    local dumpTable = {};
    local dumpCheck = {};
    for key,value in ipairs(targetTable) do 
        tinsert(dumpTable, formatValueString(value));
        dumpCheck[key] = true; 
    end 
    for key,value in pairs(targetTable) do 
        if not dumpCheck[key] then 
            tinsert(dumpTable, "\n    "..formatKeyString(key).." = "..formatValueString(value));
        end 
    end 
    local output = tconcat(dumpTable, ", ");
    return "{ "..output.." }";
end

function math.parsefloat(value,decimal)
    if decimal and decimal > 0 then 
        local calc1 = 10 ^ decimal;
        local calc2 = (value * calc1) + 0.5;
        return floor(calc2) / calc1
    end 
    return floor(value + 0.5)
end

function table.copy(targetTable,deepCopy,mergeTable)
    mergeTable = mergeTable or {};
    if targetTable==nil then return nil end 
    if mergeTable[targetTable] then return mergeTable[targetTable] end 
    local replacementTable = {}
    for key,value in pairs(targetTable)do 
        if deepCopy and type(value) == "table" then 
            replacementTable[key] = table.copy(value, deepCopy, mergeTable)
        else 
            replacementTable[key] = value 
        end 
    end 
    setmetatable(replacementTable, table.copy(getmetatable(targetTable), deepCopy, mergeTable))
    mergeTable[targetTable] = replacementTable;
    return replacementTable 
end

function string.trim(this)
    return find(this, '^%s*$') and '' or match(this, '^%s*(.*%S)')
end

function string.color(this, color)
    return format("|cff%s%s|r", color, this)
end

function string.link(this, prefix, text, color)
    text = tostring(text)
    local colorstring = tostring(this):color(color or "ffffff")
    return format("|H%s:%s|h%s|h", prefix, text, colorstring)
end

function string.explode(str, delim)
   local res = { }
   local pattern = format("([^%s]+)%s()", delim, delim)
   while (true) do
      line, pos = match(str, pattern, pos)
      if line == nil then break end
      tinsert(res, line)
   end
   return res
end

--[[
 /$$       /$$                               /$$            /$$    
| $$      |__/                              |__/           | $$    
| $$       /$$ /$$$$$$$   /$$$$$$  /$$   /$$ /$$  /$$$$$$$/$$$$$$  
| $$      | $$| $$__  $$ /$$__  $$| $$  | $$| $$ /$$_____/_  $$_/  
| $$      | $$| $$  \ $$| $$  \ $$| $$  | $$| $$|  $$$$$$  | $$    
| $$      | $$| $$  | $$| $$  | $$| $$  | $$| $$ \____  $$ | $$ /$$
| $$$$$$$$| $$| $$  | $$|  $$$$$$$|  $$$$$$/| $$ /$$$$$$$/ |  $$$$/
|________/|__/|__/  |__/ \____  $$ \______/ |__/|_______/   \___/  
                         /$$  \ $$                                 
                        |  $$$$$$/                                 
                        \______/   

Linguist is a simple localization component. Seriously, thats it!                               
--]]

--LINGUIST HELPERS
local activeLocale

local failsafe = function() assert(false) end

--LINGUIST META METHODS
local metaread = {
    __index = function(self, key)
        rawset(self, key, key)
        return key
    end
}

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

--LINGUIST STORAGE
lib.Localization = setmetatable({}, metaread);

--LINGUIST PUBLIC METHOD
function lib:Lang(locale, isDefault)
    if(not locale) then
        return self.Localization
    else
        local gameLocale = GetLocale()
        if gameLocale == "enGB" then gameLocale = "enUS" end

        activeLocale = self.Localization

        if isDefault then
            return defaultwrite
        elseif(locale == GAME_LOCALE or locale == gameLocale) then
            return metawrite
        end
    end
end

--[[
 /$$$$$$$             /$$              /$$                                   
| $$__  $$           | $$             | $$                                   
| $$  \ $$ /$$$$$$  /$$$$$$   /$$$$$$ | $$$$$$$  /$$$$$$   /$$$$$$$  /$$$$$$ 
| $$  | $$|____  $$|_  $$_/  |____  $$| $$__  $$|____  $$ /$$_____/ /$$__  $$
| $$  | $$ /$$$$$$$  | $$     /$$$$$$$| $$  \ $$ /$$$$$$$|  $$$$$$ | $$$$$$$$
| $$  | $$/$$__  $$  | $$ /$$/$$__  $$| $$  | $$/$$__  $$ \____  $$| $$_____/
| $$$$$$$/  $$$$$$$  |  $$$$/  $$$$$$$| $$$$$$$/  $$$$$$$ /$$$$$$$/|  $$$$$$$
|_______/ \_______/   \___/  \_______/|_______/ \_______/|_______/  \_______/
                                                                             
                                                                             
DataBase is a component used to create and manage SVUI data objects.

It's main purpose is to keep all methods and logic needed to properly maintain 
valid data outside of the core object.
--]]

--DATABASE STORAGE
local IndexExceptions = {};

--DATABASE LOCAL HELPERS
local function tablecopy(d, s)
    if(type(s) ~= "table") then return end
    if(type(d) ~= "table") then return end
    for k, v in pairs(s) do
        local saved = rawget(d, k)
        if type(v) == "table" then
            if not saved then rawset(d, k, {}) end
            tablecopy(d[k], v)
        elseif(saved == nil or (saved and type(saved) ~= type(v))) then
            rawset(d, k, v)
        end
    end
end

local function tablesplice(targetTable, mergeTable)
    if type(targetTable) ~= "table" then targetTable = {} end

    if type(mergeTable) == 'table' then 
        for key,val in pairs(mergeTable) do 
            if type(val) == "table" then 
                val = tablesplice(targetTable[key], val)
            end 
            targetTable[key] = val 
        end 
    end 
    return targetTable 
end

local function importdata(s, d)
    if type(d) ~= "table" then d = {} end
    if type(s) == "table" then
        for k,v in pairs(s) do
            if type(v) == "table" then
                v = importdata(v, d[k])
            end
            d[k] = v
        end
    end
    return d
end

local function removedefaults(db, src, nometa)
    if(type(src) ~= "table") then
        if(db == src) then db = nil end 
        return 
    end
    if(not nometa) then
        setmetatable(db, nil)
    end
    for k,v in pairs(src) do
        if type(v) == "table" and type(db[k]) == "table" then
            removedefaults(db[k], v, nometa)
            if next(db[k]) == nil then
                db[k] = nil
            end
        else
            if db[k] == v then
                db[k] = nil
            end
        end
    end
end

--DATABASE META METHODS
local meta_database = { 
  __index = function(t, k)
    if(not k or k == "") then return end
    local sv = rawget(t, "data")
    local dv = rawget(t, "defaults")
    local src = dv and dv[k]

    if(src ~= nil) then
        if(type(src) == "table") then 
          if(sv[k] == nil or (sv[k] ~= nil and type(sv[k]) ~= "table")) then sv[k] = {} end
          tablecopy(sv[k], src)
        else
          if(sv[k] == nil or (sv[k] ~= nil and type(sv[k]) ~= type(src))) then sv[k] = src end
        end
    end

    rawset(t, k, sv[k])
    return rawget(t, k)  
  end,
}

--DATABASE PUBLIC METHODS
function lib:Remove(key)
    if(GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = nil end
    twipe(GLOBAL_SV.profileKeys)
    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end
end

function lib:GetProfiles()
    local list = GLOBAL_SV.profileKeys or {}
    return list
end

function lib:CheckProfiles()
    local hasProfile = false
    local list = GLOBAL_SV.profileKeys or {}
    for key,_ in pairs(list) do
        hasProfile = true
    end
    return hasProfile
end

function lib:ImportDatabase(key)
    if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
    local import = GLOBAL_SV.profiles[key];
    local saved = CoreObject.db;

    import.importTest = true; --Testing value, will be removed next time the UI is reloaded
    tablecopy(saved, import);

    --Ensure that import was successful
    if(not CoreObject.db.importTest) then
        --If no test value found, might need reloading
        --Not the most clever thing in the world but....
        ReloadUI()
    else
        print("Profile Successfully Copied")
    end
end

function lib:ExportDatabase(key)
    if(not GLOBAL_SV.profiles[key]) then GLOBAL_SV.profiles[key] = {} end;
    local export = rawget(CoreObject.db, "data");
    local saved = GLOBAL_SV.profiles[key];
    tablecopy(saved, export);

    twipe(GLOBAL_SV.profileKeys)
    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end
end

function lib:WipeDatabase()
    local sv = rawget(CoreObject.db, "data")
    for k,v in pairs(sv) do
        sv[k] = nil
    end
end

function lib:WipeCache()
    for k,v in pairs(CACHE_SV) do
        CACHE_SV[k] = nil
    end
end

function lib:WipeGlobal()
    for k,v in pairs(GLOBAL_SV) do
        GLOBAL_SV[k] = nil
    end
end

function lib:UpdateDatabase(event)
    if event == "PLAYER_LOGOUT" then
        local sv = rawget(CoreObject.db, "data")
        local src = rawget(CoreObject.db, "defaults")
        for k,v in pairs(sv) do
            if(not src[k]) then
                sv[k] = nil
            elseif(src[k] ~= nil and (not LoadOnDemand[k])) then
                removedefaults(sv[k], src[k])
            end
        end
        for k,v in pairs(CACHE_SV) do
            if(not AllowedIndexes.C[k]) then
                CACHE_SV[k] = nil
            end
        end
        for k,v in pairs(GLOBAL_SV) do
            if(not AllowedIndexes.G[k]) then
                GLOBAL_SV[k] = nil
            end
        end
    elseif(event == "ACTIVE_TALENT_GROUP_CHANGED") then
        if(PROFILE_SV.SAFEDATA and PROFILE_SV.SAFEDATA.dualSpecEnabled) then 
            SOURCE_KEY = GetSpecialization() or 1
            self.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
        else
            SOURCE_KEY = 1
            self.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
        end

        local data = CoreObject.db
        local source = PROFILE_SV.STORED[SOURCE_KEY]
        rawset(data, "data", source)
    end
end

function lib:GetSafeData(index)
    if(index) then
        return PROFILE_SV.SAFEDATA[index]
    else
        return PROFILE_SV.SAFEDATA
    end
end

function lib:SaveSafeData(index, value)
    PROFILE_SV.SAFEDATA[index] = value
end

function lib:CheckData(schema, key)
    local file = PROFILE_SV.STORED[SOURCE_KEY][schema]
    print("______" .. schema .. ".db[" .. key .. "]_____")
    print(file[key])
    print("______SAVED_____")
end

function lib:NewCache(index)
    index = index or CoreObject.Schema
    AllowedIndexes.C[index] = true
    if(not CACHE_SV[index]) then
        CACHE_SV[index] = {}
    end
    return CACHE_SV[index]
end

function lib:NewGlobal(index)
    index = index or CoreObject.Schema
    AllowedIndexes.G[index] = true
    if(not GLOBAL_SV[index]) then
        GLOBAL_SV[index] = {}
    end
    return GLOBAL_SV[index]
end

--[[
 /$$$$$$$                      /$$            /$$                        
| $$__  $$                    |__/           | $$                        
| $$  \ $$  /$$$$$$   /$$$$$$  /$$  /$$$$$$$/$$$$$$    /$$$$$$  /$$   /$$
| $$$$$$$/ /$$__  $$ /$$__  $$| $$ /$$_____/_  $$_/   /$$__  $$| $$  | $$
| $$__  $$| $$$$$$$$| $$  \ $$| $$|  $$$$$$  | $$    | $$  \__/| $$  | $$
| $$  \ $$| $$_____/| $$  | $$| $$ \____  $$ | $$ /$$| $$      | $$  | $$
| $$  | $$|  $$$$$$$|  $$$$$$$| $$ /$$$$$$$/ |  $$$$/| $$      |  $$$$$$$
|__/  |__/ \_______/ \____  $$|__/|_______/   \___/  |__/       \____  $$
                     /$$  \ $$                                  /$$  | $$
                    |  $$$$$$/                                 |  $$$$$$/
                     \______/                                   \______/ 

Registry is a component used to manage packages and scripts embedded
into the SVUI core addon.

It's main purpose is to keep all methods and logic needed to properly keep
core add-ins functioning outside of the core object.
--]]

--REGISTRY LOCAL HELPERS
local changeDBVar = function(self, value, key, sub1, sub2, sub3)
    local db = CoreObject.db[self.Schema]
    if((sub1 and sub2 and sub3) and (db[sub1] and db[sub1][sub2] and db[sub1][sub2][sub3])) then
        db[sub1][sub2][sub3][key] = value
    elseif((sub1 and sub2) and (db[sub1] and db[sub1][sub2])) then
        db[sub1][sub2][key] = value
    elseif(sub1 and db[sub1]) then
        db[sub1][key] = value
    else
        db[key] = value
    end

    if(self.UpdateLocals) then
        self:UpdateLocals()
    end
end

local innerOnEvent = function(self, event, ...)
    local obj = self.module
    if self[event] and type(self[event]) == "function" then
        self[event](obj, event, ...)
    end
end

local registerEvent = function(self, eventname, eventfunc)
    if not self.___eventframe then
        self.___eventframe = CreateFrame("Frame", nil)
        self.___eventframe.module = self
        self.___eventframe:SetScript("OnEvent", innerOnEvent)
    end

    if(not self.___eventframe[eventname]) then
        local fn = eventfunc
        if type(eventfunc) == "string" then
            fn = self[eventfunc]
        elseif(not fn and self[eventname]) then
            fn = self[eventname]
        end
        self.___eventframe[eventname] = fn
    end
    
    self.___eventframe:RegisterEvent(eventname)
end

local unregisterEvent = function(self, event, ...)
    if(self.___eventframe) then
        self.___eventframe:UnregisterEvent(event)
    end
end

local innerOnUpdate = function(self, elapsed)
    if self.elapsed and self.elapsed > (self.throttle) then
        local obj = self.module
        local callbacks = self.callbacks

        for name, fn in pairs(callbacks) do
            local _, error = pcall(fn, obj)
            if(error and CoreObject.Debugging) then
                print(error)
            end
        end

        self.elapsed = 0
    else
        self.elapsed = (self.elapsed or 0) + elapsed
    end
end

local registerUpdate = function(self, updatefunc, throttle)
    if not self.___updateframe then
        self.___updateframe = CreateFrame("Frame", nil);
        self.___updateframe.module = self;
        self.___updateframe.callbacks = {};
        self.___updateframe.elapsed = 0;
        self.___updateframe.throttle = throttle or 0.2;
    end

    if(updatefunc and type(updatefunc) == "string" and self[updatefunc]) then
        self.___updateframe.callbacks[updatefunc] = self[updatefunc]
    end

    self.___updateframe:SetScript("OnUpdate", innerOnUpdate)
end

local unregisterUpdate = function(self, updatefunc)
    if(updatefunc and type(updatefunc) == "string" and self.___updateframe.callbacks[updatefunc]) then
        self.___updateframe.callbacks[updatefunc] = nil
        if(#self.___updateframe.callbacks == 0) then
            self.___updateframe:SetScript("OnUpdate", nil)
        end
    else
        self.___updateframe:SetScript("OnUpdate", nil)
    end
end

local appendOptions = function(self, index, data)
    local addonName = self.NameID
    local schema = self.Schema
    local header = GetAddOnMetadata(addonName, HeaderFromMeta)

    CoreObject.Options.args.plugins.args.pluginOptions.args[schema].args[index] = data
end

local function SetPluginString(addonName)
    local author = GetAddOnMetadata(addonName, "Author") or "Unknown"
    local name = GetAddOnMetadata(addonName, "Title") or addonName
    local version = GetAddOnMetadata(addonName, "Version") or "???"
    return INFO_FORMAT:format(name, version, author)
end

--REGISTRY PUBLIC METHODS

function lib:RunCallbacks()
    for i=1, #Callbacks do 
        local fn = Callbacks[i]
        if(fn and type(fn) == "function") then
            fn()
        end
    end
end

function lib:Update(schema)
    local obj = CoreObject[schema]
    if obj and obj.ReLoad then
        obj:ReLoad()
    end
end

function lib:UpdateAll()
    for _,schema in pairs(MODULES) do
        local obj = CoreObject[schema]
        if obj and obj.ReLoad then
            obj:ReLoad()
        end
    end
end

function lib:UpdatePlugins()
    for _,schema in pairs(PLUGINS) do
        local obj = _G[schema]
        if obj and obj.ReLoad then
            obj:ReLoad()
        end
    end
end

function lib:GetModuletable()
    return MODULES
end

function lib:GetPlugins()
    return PluginString
end

function lib:CheckDualProfile()
    return PROFILE_SV.SAFEDATA.dualSpecEnabled
end

function lib:ToggleDualProfile(enabled)
    PROFILE_SV.SAFEDATA.dualSpecEnabled = enabled
    if(enabled) then
        self.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
        self:UpdateDatabase()
    else
        self.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    end
end

function lib:LoadQueuedModules()
    if MODULES then
        for i=1,#MODULES do 
            local schema = MODULES[i]
            local obj = CoreObject[schema]
            if obj and not obj.initialized then
                obj.initialized = true;
                local halt = false
                local data = CoreObject.db[schema]
                if(data and data.incompatible) then
                    for addon,_ in pairs(data.incompatible) do
                        if IsAddOnLoaded(addon) then halt = true end
                    end
                end
                if(obj.Load) then
                    if(not halt) then
                        obj:Load()
                        obj.Load = nil
                    end
                end
            end 
        end
    end
end

function lib:LoadQueuedPlugins()
    if PLUGINS then
        for i=1,#PLUGINS do 
            local schema = PLUGINS[i]
            local obj = _G[schema]
            if obj and not obj.initialized then
                obj.initialized = true;
                local halt = false
                local data = CoreObject.db[schema]
                if(data and data.incompatible) then
                    for addon,_ in pairs(data.incompatible) do
                        if IsAddOnLoaded(addon) then halt = true end
                    end
                end
                if(obj.Load) then
                    if(not halt) then
                        obj:Load()
                        obj.Load = nil
                    end
                end
            end 
        end
    end
end

--[[ CONSTRUCTORS ]]--

function lib:NewPlugin(addonName, addonObject)
    local version   = GetAddOnMetadata(addonName, "Version")
    local header    = GetAddOnMetadata(addonName, HeaderFromMeta)
    local schema    = GetAddOnMetadata(addonName, SchemaFromMeta)
    local lod       = IsAddOnLoadOnDemand(addonName)

    local addonmeta = {}
    local oldmeta = getmetatable(addonObject)
    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end
    addonmeta.__tostring = rootstring
    setmetatable( addonObject, addonmeta )

    addonObject.Version             = version
    addonObject.NameID              = addonName
    addonObject.TitleID             = header
    addonObject.Schema              = schema
    addonObject.LoD                 = lod
    addonObject.initialized         = false
    addonObject.CombatLocked        = false
    addonObject.ChangeDBVar         = changeDBVar
    addonObject.RegisterEvent       = registerEvent
    addonObject.UnregisterEvent     = unregisterEvent
    addonObject.RegisterUpdate      = registerUpdate
    addonObject.UnregisterUpdate    = unregisterUpdate
    addonObject.AddOption           = appendOptions

    if(IsAddOnLoaded(addonName) and not lod) then
        CoreObject.Options.args.plugins.args.pluginOptions.args[schema] = {
            type = "group", 
            name = header, 
            childGroups = "tree", 
            args = {
                enable = {
                    order = 1,
                    type = "toggle",
                    name = "Enable",
                    get = function() 
                        return CoreObject.db[schema].enable 
                    end,
                    set = function(key, value) 
                        addonObject:ChangeDBVar(value, "enable"); 
                        CoreObject:StaticPopup_Show("RL_CLIENT") 
                    end,
                }
            }
        }
    end

    _G[schema] = addonObject

    if(not PLUGINS) then PLUGINS = {} end

    PLUGINS[#PLUGINS+1] = schema
    AllowedIndexes.P[schema] = true

    local infoString = SetPluginString(addonName)
    local oldString = PluginString
    PluginString = ("%s%s\n"):format(oldString, infoString)

    return addonObject
end

local function NewLoadOnDemand(addonName, schema, header)
    LoadOnDemand[schema] = addonName;
    PROFILE_SV.SAFEDATA[schema] = PROFILE_SV.SAFEDATA[schema] or {["enable"] = false}
    CoreObject.configs[schema] = {["enable"] = false}
    CoreObject.Options.args.plugins.args.pluginOptions.args[schema] = {
        type = "group", 
        name = header, 
        childGroups = "tree", 
        args = {
            enable = {
                order = 1,
                type = "execute",
                width = "full",
                name = function() 
                    local nameString = "Disable"
                    if(not IsAddOnLoaded(addonName)) then 
                        nameString = "Enable" 
                    end
                    return nameString
                end,
                func = function()
                    if(not IsAddOnLoaded(addonName)) then
                        local loaded, reason = LoadAddOn(addonName)
                        PROFILE_SV.SAFEDATA[schema].enable = true
                        lib:LoadQueuedPlugins()
                    else
                        PROFILE_SV.SAFEDATA[schema].enable = false
                        CoreObject:StaticPopup_Show("RL_CLIENT")
                    end
                end,
            }
        }
    }
end

local function SanitizeStorage(data)
    for k,v in pairs(data) do
        if(k == "STORED" or k == "SAFEDATA" or k == "LAYOUT") then
            data[k] = nil
        end
    end
end

--DATABASE EVENT HANDLER
local DataBase_OnEvent = function(self, event)
    if(event == "PLAYER_LOGOUT" or event == "ACTIVE_TALENT_GROUP_CHANGED") then
        lib:UpdateDatabase(event)
    end
end

-- CORE OBJECT CONSTRUCT
local Core_NewCallback = function(self, fn)
    if(fn and type(fn) == "function") then
        Callbacks[#Callbacks+1] = fn
    end 
end

local Core_NewScript = function(self, fn)
    if(fn and type(fn) == "function") then
        ScriptQueue[#ScriptQueue+1] = fn
    end 
end

local Core_NewPackage = function(self, schema, header)
    if(self[schema]) then return end

    if(not MODULES) then MODULES = {} end
    MODULES[#MODULES+1] = schema

    AllowedIndexes.P[schema] = true

    local addonName = ("SVUI [%s]"):format(schema)

    local obj = {
        NameID              = addonName,
        TitleID             = header,
        Schema              = schema,
        initialized         = false,
        CombatLocked        = false,
        ChangeDBVar         = changeDBVar,
        RegisterEvent       = registerEvent,
        UnregisterEvent     = unregisterEvent,
        RegisterUpdate      = registerUpdate,
        UnregisterUpdate    = unregisterUpdate
    }

    local addonmeta = {}
    local oldmeta = getmetatable(obj)
    if oldmeta then
        for k, v in pairs(oldmeta) do addonmeta[k] = v end
    end
    addonmeta.__tostring = rootstring
    setmetatable( obj, addonmeta )

    self[schema] = obj
    
    return self[schema]
end

local Core_ResetData = function(self, sub, sub2)
    local data = self.db
    local sv = rawget(data, "data")
    local src = rawget(data, "defaults")
    local targetData
    if(sub2 and sv and sv[sub]) then
        targetData = sv[sub][sub2]
    elseif(sub and sv) then
        targetData = sv[sub]
    else
        targetData = sv
    end
    if(targetData) then
        for k,v in pairs(targetData) do
            targetData[k] = nil
        end
    else
        sv = {}
    end
    tablecopy(sv, src)
end

function lib:NewCore(gfile, pfile, cfile)
    --meta assurance
    local mt = {};
    local old = getmetatable(CoreObject);
    if old then
        for k, v in pairs(old) do mt[k] = v end
    end
    mt.__tostring = rootstring;
    setmetatable(CoreObject, mt);

    --database
    GLOBAL_FILENAME = gfile or GLOBAL_FILENAME
    PROFILE_FILENAME = pfile or PROFILE_FILENAME
    CACHE_FILENAME  = cfile or CACHE_FILENAME

    --events
    if(not self.EventManager.Initialized) then
        self.EventManager:RegisterEvent("PLAYER_LOGOUT")
        self.EventManager:SetScript("OnEvent", DataBase_OnEvent)
        self.EventManager.Initialized = true
    end

    --internals
    CoreObject.NameID       = CoreName;
    CoreObject.Version      = AddonVersion;
    CoreObject.GameVersion  = tonumber(InterfaceVersion);
    CoreObject.DebugMode    = false;
    CoreObject.Schema       = GetAddOnMetadata(CoreName, SchemaFromMeta);
    CoreObject.TitleID      = GetAddOnMetadata(CoreName, HeaderFromMeta);
    CoreObject.NewCallback  = Core_NewCallback
    CoreObject.NewScript    = Core_NewScript
    CoreObject.NewPackage   = Core_NewPackage
    CoreObject.ResetData    = Core_ResetData
    CoreObject.db           = tablesplice(CoreObject.configs, {})
    CoreObject.L            = self:Lang()

    --set global
    _G[CoreName] = CoreObject;

    return _G[CoreName]
end

-- INITIALIZE AND LAUNCH

function lib:Initialize()
    local coreSchema = CoreObject.Schema
    --GLOBAL SAVED VARIABLES
    if not _G[GLOBAL_FILENAME] then _G[GLOBAL_FILENAME] = {} end
    GLOBAL_SV = _G[GLOBAL_FILENAME]

    if(GLOBAL_SV.profileKeys) then 
      twipe(GLOBAL_SV.profileKeys) 
    else
      GLOBAL_SV.profileKeys = {}
    end

    GLOBAL_SV.profiles = GLOBAL_SV.profiles or {}

    for k,v in pairs(GLOBAL_SV.profiles) do
        GLOBAL_SV.profileKeys[k] = k
    end

    AllowedIndexes.G["profileKeys"] = true
    AllowedIndexes.G["profiles"] = true

    --CACHE SAVED VARIABLES
    if not _G[CACHE_FILENAME] then _G[CACHE_FILENAME] = {} end
    CACHE_SV = _G[CACHE_FILENAME]

    --PROFILE SAVED VARIABLES
    if not _G[PROFILE_FILENAME] then _G[PROFILE_FILENAME] = {} end
    PROFILE_SV = _G[PROFILE_FILENAME]
    PROFILE_SV.SAFEDATA = PROFILE_SV.SAFEDATA or {dualSpecEnabled = false}

    if(PROFILE_SV.SAFEDATA and PROFILE_SV.SAFEDATA.dualSpecEnabled) then 
        SOURCE_KEY = GetSpecialization() or 1
        self.EventManager:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    else
        SOURCE_KEY = 1
        self.EventManager:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    end

    if(not PROFILE_SV.STORED) then
        PROFILE_SV.STORED = {}
        PROFILE_SV.STORED[1] = {}
        PROFILE_SV.STORED[1][coreSchema] = {}
        PROFILE_SV.STORED[2] = {}
        PROFILE_SV.STORED[2][coreSchema] = {}
        PROFILE_SV.STORED[3] = {}
        PROFILE_SV.STORED[3][coreSchema] = {}
        if playerClass == "DRUID" then
            PROFILE_SV.STORED[4] = {}
            PROFILE_SV.STORED[4][coreSchema] = {}
        end

        --Attempt to copy any prior variables, even outdated
        if(PROFILE_SV.system or (MODULES[1] and PROFILE_SV[MODULES[1]])) then
            for k,v in pairs(PROFILE_SV) do
                if(k == "system") then
                    tablecopy(v, PROFILE_SV.STORED[1][coreSchema])
                elseif(k == "media" or k == "filter") then
                    PROFILE_SV.STORED[1][coreSchema][k] = v
                elseif(AllowedIndexes.P[k]) then
                    PROFILE_SV.STORED[1][k] = v
                end
            end
        end
    else
        PROFILE_SV.STORED[1] = PROFILE_SV.STORED[1] or {}
        PROFILE_SV.STORED[1][coreSchema] = PROFILE_SV.STORED[1][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[1])

        PROFILE_SV.STORED[2] = PROFILE_SV.STORED[2] or {}
        PROFILE_SV.STORED[2][coreSchema] = PROFILE_SV.STORED[2][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[2])

        PROFILE_SV.STORED[3] = PROFILE_SV.STORED[3] or {}
        PROFILE_SV.STORED[3][coreSchema] = PROFILE_SV.STORED[3][coreSchema] or {}
        SanitizeStorage(PROFILE_SV.STORED[3])

        if playerClass == "DRUID" then
            PROFILE_SV.STORED[4] = PROFILE_SV.STORED[4] or {}
            PROFILE_SV.STORED[4][coreSchema] = PROFILE_SV.STORED[4][coreSchema] or {}
            SanitizeStorage(PROFILE_SV.STORED[4])
        elseif PROFILE_SV.STORED[4] then
            PROFILE_SV.STORED[4] = nil
        end

    end

    for k,v in pairs(PROFILE_SV) do
        if(k ~= "STORED" and k ~= "SAFEDATA") then
            PROFILE_SV[k] = nil
        end
    end

    --construct core dataset
    local db        = setmetatable({}, meta_database)
    db.data         = PROFILE_SV.STORED[SOURCE_KEY]
    db.defaults     = CoreObject.configs
    CoreObject.db   = db

    --check for LOD plugins
    local addonCount = GetNumAddOns()

    for i = 1, addonCount do
        local addonName, _, _, _, _, reason = GetAddOnInfo(i)
        local lod = IsAddOnLoadOnDemand(i)
        local header = GetAddOnMetadata(i, HeaderFromMeta)
        local schema = GetAddOnMetadata(i, SchemaFromMeta)

        if(lod and schema) then
            NewLoadOnDemand(addonName, schema, header)
        end
    end
end

function lib:Launch()
    if LoadOnDemand then
        for schema,name in pairs(LoadOnDemand) do
            local db = PROFILE_SV.SAFEDATA[schema]
            if(db and (db.enable or db.enable ~= false)) then
                CoreObject.db[schema].enable = PROFILE_SV.SAFEDATA[schema].enable
                if(not IsAddOnLoaded(name)) then
                    local loaded, reason = LoadAddOn(name)
                end
                EnableAddOn(name)
            end
        end
    end

    self:LoadQueuedModules()
    self:LoadQueuedPlugins()

    if ScriptQueue then
        for i=1, #ScriptQueue do 
            local fn = ScriptQueue[i]
            if(fn and type(fn) == "function") then
                fn()
            end 
        end

        ScriptQueue = nil
    end
end