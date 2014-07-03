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
local pcall     = _G.pcall;
local rawset    = _G.rawset;
local rawget    = _G.rawget;
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
--[[ 
########################################################## 
SECURITY MASTER METATABLE
##########################################################
]]--
local METASECURITY = function()
    local _db = {l = {},q = {},s = {}};
    local _rc = 0;
    local _lc = 0;
    local methods = {
        Register = function(_, ns, f, a)
            local name = ns._name;
            local func = ns[f];
            assert(type(func) == "function", "Can only Register a valid function. " .. f .. "!")
            if not _db.q[name] then _db.q[name] = {} end;
            if not _db.s[name] then _db.s[name] = {} end;
            _db.s[name][f] = func;
            local handler = _G[name.."SecurityHandler"] or CreateFrame("Frame", name.."SecurityHandler", UIParent);
            local new_function = function(this,...)
                _rc = _rc + 1
                _db.q[name][_rc] = {...}
                if(InCombatLockdown()) then
                    if not handler:IsEventRegistered('PLAYER_REGEN_ENABLED') then
                        handler:RegisterEvent('PLAYER_REGEN_ENABLED')
                    end;
                    return
                else
                    for k in pairs(_db.q[name]) do
                        local _, catch = pcall(func, this, _db.q[name][k])
                        if catch then
                            _lc = _lc + 1
                            _db.l[_lc] = catch
                        end
                    end
                end
            end;
            ns[f] = new_function;
            handler.callback = ns[f];
            handler:SetScript("OnEvent", function(this,event,...)
                if(InCombatLockdown()) then
                    ns.CombatLocked = true;
                elseif event == 'PLAYER_REGEN_ENABLED' then
                    ns.CombatLocked = false;
                    this:UnregisterEvent('PLAYER_REGEN_ENABLED')
                    this:callback()
                end
            end)
            if a then new_function(ns) end;
        end,
        UnRegister = function(_, ns, f)
            local name = ns._name;
            local handler = _G[name.."SecurityHandler"];
            if not handler then return end;
            handler.callback = nil;
            handler:SetScript("OnEvent", nil);
            if _db.s[name][f] then
                ns[f] = _db.s[name][f]
                _db.s[name][f] = nil
            end
        end,
        ErrorLogs = function(t) print("SuperVillain.Security >>> [" .. tdump(_db.l) .. "]") end,
    };
    local mt ={
        __index = function(t,  k)
            v=rawget(_db.q,  k)
            if v then return v end
        end, 
        __newindex = function(t,  k,  v)
            if rawget(_db.q,  k) then rawset(_db.q,  k,  v) return end
        end, 
        __metatable = {}, 
        __pairs = function(t,  k,  v) return next,  _db.q,  nil end, 
        __ipairs = function()
            local function iter(a,  i)
                i = i + 1
                local v = a[i]
                if v then return i, v end
            end
            return iter, _db.q, 0
        end, 
        __len = function(t)
            local count = 0
            for _ in pairs(_db.q) do count = count + 1 end
            return count
        end, 
        __tostring = function(t) return "SuperVillain.Security >>> [" .. tdump(_db.q) .. "]" end, 
    };
    setmetatable(methods,  mt)
    return methods
end;
do
    SuperVillain.Security = METASECURITY();
end;
