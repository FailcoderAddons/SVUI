--[[
##########################################################
S V U I   By: Munglunch
##########################################################
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
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
local tinsert       = _G.tinsert;
local tremove       = _G.tremove;
local twipe         = _G.wipe;
--STRING
local string        = _G.string;
local format        = string.format;
local find          = string.find;
local match         = string.match;
--MATH
local math          = _G.math;
local min, random   = math.min, math.random;
--TABLE
local table         = _G.table;
local bit 					= _G.bit;
local band, bor 		= bit.band, bit.bor
--[[ LOCALIZED BLIZZ FUNCTIONS ]]--
local NewHook = hooksecurefunc;
--[[
##########################################################
GET ADDON DATA AND TEST FOR oUF
##########################################################
]]--
local SV = _G['SVUI']
local L = SV.L;
local LSM = _G.LibStub("LibSharedMedia-3.0")
local MOD = SV.UnitFrames

if(not MOD) then return end

local oUF_SVUI = MOD.oUF
assert(oUF_SVUI, "SVUI UnitFrames: unable to locate oUF.")
--[[
##########################################################
LOCALS
##########################################################
]]--
local BodyGuard = {};

local defeated_spells = {
    [173663] = true, -- Aeda Brightdawn
    [173662] = true, -- Defender Illona
    [173664] = true, -- Delvar Ironfist
    [173977] = true, -- Leorajh
    [173665] = true, -- Talonpriest Ishaal
    [173656] = true, -- Tormmok
    [173666] = true  -- Vivianne
}

local defeated_debuffs = {
    [173660] = true, -- Aeda Brightdawn
    [173657] = true, -- Defender Illona
    [173658] = true, -- Delvar Ironfist
    [173976] = true, -- Leorajh
    [173659] = true, -- Talonpriest Ishaal
    [173649] = true, -- Tormmok
    [173661] = true  -- Vivianne
}

local defeated_pattern = "^([%w%s]+) %w+"

-- Get follower names for the defeated spells
for id, _ in pairs(defeated_spells) do
    local spellName = GetSpellInfo(id)
    local name = spellName:match(defeated_pattern)
    if name then
        defeated_spells[id] = name
    end
end

-- Do the same for debuffs
for id, _ in pairs(defeated_debuffs) do
    local spellName = GetSpellInfo(id)
    local name = spellName:match(defeated_pattern)
    if name then
        defeated_debuffs[id] = name
    end
end

-- Valid barracks IDs, 27 = lvl 2 barracks, 28 = lvl 3 barracks
local barracks_ids = {[27] = true, [28] = true}

--- Bodyguard status values.
-- @class table
-- @name BodyGuard.Status
-- @field Inactive Bodyguard is not with the player (stationed at barracks).
-- @field Active Bodyguard is with the player.
-- @field Unknown Status of bodyguard is unknown (this includes death).
BodyGuard.Status = {
    Inactive = 0,
    Active = 1,
    Unknown = 2
}

local bodyguard = {}

local function ResetBodyguard()
    bodyguard.name = nil
    bodyguard.level = 0
    bodyguard.health = 0
    bodyguard.max_health = 0
    bodyguard.npc_id = 0
    bodyguard.follower_id = 0
    bodyguard.last_known_guid = nil
    bodyguard.status = BodyGuard.Status.Unknown
    bodyguard.loaded_from_building = false
end

ResetBodyguard()

local callbacks = {
    guid = {},
    name = {},
    level = {},
    health = {},
    status = {},
    gossip_opened = {},
    gossip_closed = {}
}

local function RunCallback(cb_type, ...)
    for func, enabled in pairs(callbacks[cb_type]) do
        if enabled then pcall(func, BodyGuard, ...) end
    end
end

local frame = CreateFrame("Frame")

local events = {
    player = {}
}

local function UpdateFromBuildings()
    ResetBodyguard()
    bodyguard.loaded_from_building = true
    local buildings = C_Garrison.GetBuildings()
    for i = 1, #buildings do
        local building = buildings[i]
        local building_id = building.buildingID
        local plot_id = building.plotID
        if barracks_ids[building_id] then
            local name, level, quality, displayID, followerID, garrFollowerID, status, portraitIconID = C_Garrison.GetFollowerInfoForBuilding(plot_id)
            if not name then
                bodyguard.status = BodyGuard.Status.Inactive
                RunCallback("status", bodyguard.status)
                return
            end
            bodyguard.name = name
            bodyguard.level = level
            bodyguard.follower_id = type(garrFollowerID) == "string" and tonumber(garrFollowerID, 16) or garrFollowerID
            RunCallback("name", bodyguard.name)
            RunCallback("level", bodyguard.level)
            break
        end
    end
end

local function UpdateFromUnit(unit)
    local name = UnitName(unit)
    if name ~= bodyguard.name then return end
    bodyguard.last_known_guid = UnitGUID(unit)
    bodyguard.health = UnitHealth(unit)
    bodyguard.max_health = UnitHealthMax(unit)
    RunCallback("guid", bodyguard.last_known_guid)
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

function events.GARRISON_BUILDINGS_SWAPPED()
    UpdateFromBuildings()
end

function events.GARRISON_BUILDING_ACTIVATED()
    UpdateFromBuildings()
end

function events.GARRISON_BUILDING_UPDATE(buildingID)
    if barracks_ids[buildingID] then UpdateFromBuildings() end
end

function events.GARRISON_FOLLOWER_REMOVED()
    UpdateFromBuildings()
end

function events.GARRISON_UPDATE()
    UpdateFromBuildings()
end

function events.PLAYER_TARGET_CHANGED(cause)
    if not bodyguard.name then return end
    if cause ~= "LeftButton" and cause ~= "up" then return end
    UpdateFromUnit("target")
end

function events.UPDATE_MOUSEOVER_UNIT()
    if not bodyguard.name then return end
    UpdateFromUnit("mouseover")
end

function events.UNIT_HEALTH(unit)
    if not bodyguard.name then return end
    UpdateFromUnit(unit)
end

local FLAGMASK = bor(COMBATLOG_OBJECT_TYPE_GUARDIAN, COMBATLOG_OBJECT_CONTROL_PLAYER, COMBATLOG_OBJECT_REACTION_FRIENDLY, COMBATLOG_OBJECT_AFFILIATION_MINE)
function events.COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, ...)
    if not bodyguard.name or (not sourceName and not destName) then return end
    if sourceName == bodyguard.name then
        local isBodyguard = band(sourceFlags, FLAGMASK) == FLAGMASK
        if not isBodyguard then return end
        bodyguard.status = BodyGuard.Status.Active
        bodyguard.last_known_guid = sourceGUID
        RunCallback("guid", bodyguard.last_known_guid)
        RunCallback("status", bodyguard.status)
    elseif destName == bodyguard.name and bodyguard.status ~= BodyGuard.Status.Inactive then
        local isBodyguard = band(destFlags, FLAGMASK) == FLAGMASK
        if not isBodyguard then return end
        local prefix, suffix = event:match("^([A-Z_]+)_([A-Z]+)$")

        local amount = 0;
        if prefix:match("^SPELL") then
					amount = select(4, ...);
        elseif prefix == "ENVIRONMENTAL" then
					amount = select(2, ...);
				else
					amount = select(1, ...);
        end

        local changed = false

        if suffix == "DAMAGE" then
            bodyguard.health = bodyguard.health - amount
            changed = true
        elseif suffix == "HEAL" then
            bodyguard.health = bodyguard.health + amount
            if bodyguard.health >= bodyguard.max_health then
                bodyguard.health = bodyguard.max_health
            end
            changed = true
        elseif suffix == "INSTAKILL" then
            bodyguard.health = 0
            changed = true
        end

        if changed then
            if bodyguard.health <= 0 then
                bodyguard.health = 0
                bodyguard.status = BodyGuard.Status.Unknown
            else
                bodyguard.status = BodyGuard.Status.Active
            end
            RunCallback("health", bodyguard.health, bodyguard.max_health)
            RunCallback("status", bodyguard.status)
        end
    end
end

function events.PLAYER_REGEN_ENABLED()
    if bodyguard.health <= 0 then return end
    bodyguard.health = bodyguard.max_health
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

local bodyguard_gossip_open = false
local bodyguard_confirm_showing = false

function events.GOSSIP_SHOW()
    if not BodyGuard:Exists() or UnitName("target") ~= bodyguard.name then return end
    bodyguard_gossip_open = true
    RunCallback("gossip_opened")
end

function events.GOSSIP_CLOSED()
    if bodyguard_gossip_open then RunCallback("gossip_closed") end
    bodyguard_gossip_open = false
    bodyguard_confirm_showing = false
end

function events.GOSSIP_CONFIRM(index, message, cost)
    if not bodyguard_gossip_open or cost ~= 0 then return end
    bodyguard_confirm_showing = true
end

function events.player.UNIT_AURA()
    for i = 1, 40 do
        local _, _, _, _, _, duration, expireTime, _, _, _, id = UnitDebuff("player", i)
        if not defeated_debuffs[id] then return end
        local name = defeated_debuffs[id]
        if name == bodyguard.name then
            bodyguard.status = BodyGuard.Status.Inactive
            bodyguard.health = 0
            RunCallback("status", bodyguard.status)
            RunCallback("health", bodyguard.health, bodyguard.max_health)
            return
        end
    end
end

function event:PLAYER_ENTERING_WORLD(event)
	self:Update_AllFrames()

    local showing = BodyGuard:IsShowing()

    if not BodyGuard:Exists() and not BodyGuard.db.Active then
        if showing then BodyGuard:HideFrame() end
        return
    end

    if(not BodyGuard:IsValidZone()) then
		BodyGuard:HideFrame()
    elseif showing then
        BodyGuard:UpdateSettings()
    elseif BodyGuard:GetStatus() ~= BodyGuard.Status.Inactive and BodyGuard.db.Active then
        BodyGuard:ShowFrame()
    end
end

function event:ZONE_CHANGED_NEW_AREA()
    local validZone = BodyGuard:IsValidZone()
    if not validZone then
        if not BodyGuard:IsShowing() then return end
		BodyGuard:HideFrame()
    elseif BodyGuard.db.Active and BodyGuard:GetStatus() ~= BodyGuard.Status.Inactive then
        BodyGuard:ShowFrame()
    end
end

frame:SetScript("OnEvent", function(f, e, ...)
    if events[e] then events[e](...) return end

    for key, val in pairs(events) do
        if type(val) == "table" then
            if val[e] then val[e](...) return end
        end
    end
end)

for key, val in pairs(events) do
    if key:match("^[A-Z0-9_]+$") then
        frame:RegisterEvent(key)
    else
        for event, _ in pairs(events[key]) do
            frame:RegisterUnitEvent(event, key)
        end
    end
end

-- Function hooks

function BodyGuard:GOSSIP_CONFIRM_Hook(s, data)
    if not bodyguard_confirm_showing then return end

    bodyguard.status = BodyGuard.Status.Inactive
    bodyguard.health = bodyguard.max_health
    RunCallback("status", bodyguard.status)
    RunCallback("health", bodyguard.health, bodyguard.max_health)
end

if not BodyGuard.GOSSIP_CONFIRM_Hooked then
    hooksecurefunc(StaticPopupDialogs.GOSSIP_CONFIRM, "OnAccept", function(self, data)
			BodyGuard:GOSSIP_CONFIRM_Hook(self, data)
    end)

		BodyGuard.GOSSIP_CONFIRM_Hooked = true
end

function BodyGuard:Exists()
    return bodyguard.name and bodyguard.loaded_from_building
end

function BodyGuard:UpdateFromBuilding()
    UpdateFromBuildings()
end

function BodyGuard:GetInfo()
    return setmetatable({}, {__index = function(t, k) return bodyguard[k] end, __metatable = 'Forbidden'})
end

function BodyGuard:GetGUID()
    return bodyguard.last_known_guid
end

function BodyGuard:GetStatus()
    return bodyguard.status
end

function BodyGuard:GetName()
    return bodyguard.name
end

function BodyGuard:GetLevel()
    return bodyguard.level
end

function BodyGuard:GetHealth()
    return bodyguard.health
end

function BodyGuard:GetMaxHealth()
    return bodyguard.max_health
end

function BodyGuard:IsAlive()
    return self:GetHealth() > 0
end

function BodyGuard:RegisterCallback(cb_type, cb_func)
    if not callbacks[cb_type] then error("Invalid callback type: " .. tostring(cb_type)) end
    if callbacks[cb_type][cb_func] then return end
    callbacks[cb_type][cb_func] = true
end

function BodyGuard:UnregisterCallback(cb_type, cb_func)
    if not callbacks[cb_type] then error("Invalid callback type: " .. tostring(cb_type)) end
    callbacks[cb_type][cb_func] = nil
end


local CONTINENT_DRAENOR = 7
local BODYGUARD_BANNED_ZONES = {
    [978] = true,  -- Ashran
    [1009] = true, -- Stormshield
    [1011] = true  -- Warspear
}

function BodyGuard:IsValidZone()
    SetMapToCurrentZone()
    local currentContinent = GetCurrentMapContinent()
    local currentMapAreaID = GetCurrentMapAreaID()
    local valid = currentContinent == CONTINENT_DRAENOR and not BODYGUARD_BANNED_ZONES[currentMapAreaID]
    BodyGuard.db.IsInValidZone = valid

    return valid
end

function BodyGuard:IsShowing()
	if(self.frame:IsShown() or self.combatEvent == self.showFrame) then
		return true
	else
		return false
	end
end

function BodyGuard:HideFrame()
	if(InCombatLockdown()) then
		self.frame:RegisterEvent("COMBAT_REGEN_ENABLED")
		self.combatEvent = self.HideFrame
		return
	elseif(self.frame:IsEventRegistered("COMBAT_REGEN_ENABLED")) then
		self.frame:UnregisterEvent("COMBAT_REGEN_ENABLED")
	end

	self.frame:Hide()
end

function BodyGuard:ShowFrame()
	if(InCombatLockdown()) then
		self.frame:RegisterEvent("COMBAT_REGEN_ENABLED")
		self.combatEvent = self.ShowFrame
		return
	elseif(self.frame:IsEventRegistered("COMBAT_REGEN_ENABLED")) then
		self.frame:UnregisterEvent("COMBAT_REGEN_ENABLED")
	end

	self.frame:Show()
end

local function OnEvent(self, event)
	if(event == "PLAYER_REGEN_ENABLED") then
		self.combatEvent(BodyGuard, event)
	elseif(event == "PLAYER_TARGET_CHANGED") then
		if(UnitExists("target") and UnitName("target") == BodyGuard:GetName()) then
			self.targetGlow:Show()
		else
			self.targetGlow:Hide()
		end
	end
end

local isCreated = false

function BodyGuard:CreateFrame()
	if(isCreated) then return end
	local frame = CreateFrame("Button", "SVUI_BodyGuard", SV.Screen, "SecureActionButtonTemplate")
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")

	frame:SetStyle("Frame", "Icon")
	frame.targetGlow = frame.Panel.Shadow
	frame.targetGlow:SetBackdropBorderColor(0, 1, 0, 0.5)
	frame.targetGlow:Hide()

	BodyGuard.frame = frame
	local name = self:GetName()
	frame:SetAttribute("type1", "macro")
	if name then
		frame:SetAttribute("macrotext1", "/targetexact " .. name)
	end

	self:HideFrame()

	frame:SetTemplate("Default", nil, true)
	frame:SetPoint("CENTER", SV.Screen, "CENTER")
	frame:SetWidth(SV.db.UnitFrames.bodyguard.width)
	frame:SetHeight(SV.db.UnitFrames.bodyguard.height)

	frame.healthBar = CreateFrame("StatusBar", nil, frame)
	frame.healthBar:InsetPoints(frame)
	frame.healthBar:SetMinMaxValues(0, 1)
	frame.healthBar:SetValue(1)
	frame.healthBar:SetStatusBarTexture(LSM:Fetch("statusbar", SV.db.UnitFrames.statusbar))

	frame.healthBar.name = frame.healthBar:CreateFontString(nil, 'OVERLAY')
	SV:FontManager(frame.healthBar.name, "unitsecondary")
	frame.healthBar.name:SetPoint("CENTER", frame, "CENTER")

	frame.healthBar.name:SetTextColor(unpack(oUF_SVUI.colors.reaction[5]))

	SV:NewAnchor(frame, L["BodyGuard Frame"])

	isCreated = true
end

function BodyGuard:UpdateSettings()
	if(SV.db.UnitFrames.bodyguard.enable) then
		self.frame:SetParent(SV.Screen)
	else
		self.frame:SetParent(SV.Hidden)
	end

	self:HealthUpdate(self.db.Health, self.db.MaxHealth)
	self.frame:SetWidth(SV.db.UnitFrames.bodyguard.width)
	self.frame:SetHeight(SV.db.UnitFrames.bodyguard.height)
end


function BodyGuard:GUIDUpdate(GUID)

end

function BodyGuard:StatusUpdate(status)
	if status == self.Status.Active then
		self:NameUpdate(self:GetName())
		self:HealthUpdate(self.db.Health, self.db.MaxHealth)
		self:ShowFrame()
	elseif status == self.Status.Inactive then
		self:HideFrame()
	end

	self.db.Active = status ~= self.Status.Inactive
end

function BodyGuard:NameUpdate(name)
	if(not InCombatLockdown() and name) then
		self.frame:SetAttribute("macrotext1", "/targetexact " .. name)
	end

	self.frame.healthBar.name:SetText(name)
end

function BodyGuard:LevelUpdate(...)

end

function BodyGuard:HealthUpdate(health, maxHealth)
	self.frame.healthBar:SetMinMaxValues(0, maxHealth)
	self.frame.healthBar:SetValue(health)

	local r, g, b = unpack(oUF_SVUI.colors.health)
	if SV.db.UnitFrames.colors.healthclass then
		r, g, b = unpack(oUF_SVUI.colors.reaction[5])
	end

	if SV.db.UnitFrames.colors.colorhealthbyvalue then
		r, g, b = oUF_SVUI.ColorGradient(health, maxHealth, 1, 0, 0, 1, 1, 0, r, g, b)
	end

	self.frame.healthBar:SetStatusBarColor(r, g, b)

	if(SV.db.UnitFrames.colors.customhealthbackdrop) then
		self.frame.backdropTexture:SetVertexColor(SV.db.UnitFrames.colors.health_backdrop.r, SV.db.UnitFrames.colors.health_backdrop.g, SV.db.UnitFrames.colors.health_backdrop.b)
	else
		self.frame.backdropTexture:SetVertexColor(r * 0.35, g * 0.35, b * 0.35)
	end

	self.db.Health = health
	self.db.MaxHealth = maxHealth
end

-- function BodyGuard:GossipOpened(...)
--
-- end
--
-- function BodyGuard:GossipClosed(...)
--
-- end

function BodyGuard:Init(...)
	self:UpdateFromBuilding()

	self:CreateFrame()
	self.LoginHealth = true
	self:RegisterCallback('guid', self.GUIDUpdate)
	self:RegisterCallback('status', self.StatusUpdate)
	self:RegisterCallback('name', self.NameUpdate)
	self:RegisterCallback('level', self.LevelUpdate)
	self:RegisterCallback('health', self.HealthUpdate)
	--self:RegisterCallback('gossip_opened', self.GossipOpened)
	--self:RegisterCallback('gossip_closed', self.GossipClosed)

    if type(self.db.IsInValidZone) ~= "boolean" then
			self.db.IsInValidZone = self:IsValidZone()
    end

	if self.db.Active and self.db.IsInValidZone then
		self:ShowFrame()
		self:HealthUpdate(self.db.Health, self.db.MaxHealth)
  end
end
