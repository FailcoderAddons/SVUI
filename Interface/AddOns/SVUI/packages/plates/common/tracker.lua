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
local find, format, split = string.find, string.format, string.split;
local match, gmatch, gsub = string.match, string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local floor = math.floor;  -- Basic
--[[ BINARY METHODS ]]--
local band, bor = bit.band, bit.bor;
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVPlate');
--[[ 
########################################################## 
LOCALS AND TRACKER FRAME
##########################################################
]]--
local NextUpdate = 0;
local SpellIDTest = {
  [47540]=true,[88625]=true,[88684]=true,[88685]=true,
  [89485]=true,[10060]=true,[33206]=true,[62618]=true,
  [724]=true,[14751]=true,[34861]=true,[47788]=true,
  [18562]=true,[17116]=true,[48438]=true,[33891]=true,
  [974]=true,[17116]=true,[16190]=true,[61295]=true,
  [20473]=true,[31842]=true,[53563]=true,[31821]=true,
  [85222]=true,[115175]=true,[115294]=true,[115310]=true,
  [116670]=true,[116680]=true,[116849]=true,[116995]=true,
  [119611]=true,[132120]=true
};
local SpellEventTest = {
  ["SPELL_HEAL"] = true,
  ["SPELL_AURA_APPLIED"] = true,
  ["SPELL_CAST_START"] = true,
  ["SPELL_CAST_SUCCESS"] = true,
  ["SPELL_PERIODIC_HEAL"] = true,
};

local HealSpecs = {
  [L['Restoration']] = true,
  [L['Holy']] = true,
  [L['Discipline']] = true, 
  [L['Mistweaver']] = true
};

local TrackingManager = CreateFrame("Frame");
local CPoints = {};
local TrackedPlatesCP = {};
local LastKnownTarget = false;
local LastKnownPoints = 0;
local Healers = {};
local Events = {};
--[[ 
########################################################## 
PARSE FUNCTIONS
##########################################################
]]--
local function TrackViaScores()
  local curTime = GetTime()
  if curTime > NextUpdate then NextUpdate = curTime + 3; else return; end
  local ready = false
  local scores = GetNumBattlefieldScores()
  if(scores > 0) then
    for i = 1, scores do
      local name, _, _, _, _, faction, _, class, _, _, _, _, _, _, _, talentSpec = GetBattlefieldScore(i)

      if name and talentSpec then
        if(HealSpecs[talentSpec]) then
          Healers[name] = true
          ready = true
        elseif(Healers[name]) then
          Healers[name] = nil
        end
      end
    end
    if(ready) then 
      MOD:RequestScanUpdate(false, false, name, "UpdateHealerIcon")
    end
  end
end

local function PlateIsHealer(name)
  if name then
    if Healers[name] then
      return true
    else
      RequestBattlefieldScoreData()
    end
  end
end

local function PlateIsEnemy(flags)
  if (band(flags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == 0) and (band(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0) then
    return true
  end
end

local function ParseArenaHealers()
  local numOps = GetNumArenaOpponentSpecs()
  if not (numOps > 1) then return end
  for i=1, 5 do
    local name = UnitName(format('arena%d', i))
    if name and name ~= UNKNOWN then
      local s = GetArenaOpponentSpec(i)
      local _, talentSpec = nil, UNKNOWN
      if s and s > 0 then
        _, talentSpec = GetSpecializationInfoByID(s)
      end
      if talentSpec and HealSpecs[talentSpec] then
        Healers[name] = true
      end
    end
  end
end

local function ClearTracking()
  CPoints = twipe(CPoints)
  Healers = twipe(Healers)
end

local function ClearExpiredPoints()
  local saved
  for plate,_ in pairs(TrackedPlatesCP) do
    if(plate.guid ~= LastKnownTarget) then
      for i=1, MAX_COMBO_POINTS do
        plate.frame.combo[i]:Hide()
      end
    else
      saved = plate
    end
  end
  CPoints = {}
  TrackedPlatesCP = {}

  if(saved) then
    TrackedPlatesCP[saved] = true
  end

  if(LastKnownTarget) then
    CPoints[LastKnownTarget] = LastKnownPoints;
  end
end

local function TrackingEventHandler(self, event, ...)
    local handler = Events[event]
    if handler then handler(...) end
end
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function Events.UNIT_COMBO_POINTS(unit)
  MOD:UpdateComboPointsByUnitID(unit)
end


function Events.PLAYER_ENTERING_WORLD()
  ClearTracking()
  local inInstance, instanceType = IsInInstance()
  if inInstance and instanceType == 'arena' then
    TrackingManager:RegisterEvent("UNIT_NAME_UPDATE")
    TrackingManager:RegisterEvent("ARENA_OPPONENT_UPDATE");
    ParseArenaHealers()  
  else
    TrackingManager:UnregisterEvent("UNIT_NAME_UPDATE")
    TrackingManager:UnregisterEvent("ARENA_OPPONENT_UPDATE")
  end
  return
end

function Events.UNIT_NAME_UPDATE()
  ParseArenaHealers()
  return
end

function Events.PLAYER_TARGET_CHANGED()
  ClearExpiredPoints()
  return
end

function Events.ARENA_OPPONENT_UPDATE()
  ParseArenaHealers()
  return
end

function Events.UPDATE_BATTLEFIELD_SCORE()
  TrackViaScores()
  return
end

function Events.COMBAT_LOG_EVENT_UNFILTERED(...)
  local timestamp, combatevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlag, spellid  = ...
  if PlateIsEnemy(sourceFlags) and sourceGUID and sourceName then
    if SpellEventTest[combatevent] then
      if SpellIDTest[spellid] then
        local rawName = split("-", sourceName)
        if not Healers[rawName] then
          Healers[rawName] = true
          MOD:RequestScanUpdate(destGUID, false, false, "UpdateHealerIcon")
        end
      end
    end
  end
end
--[[ 
########################################################## 
MODULE FUNCTIONS
##########################################################
]]--
function MOD:EnableTracking()
  TrackingManager:SetScript("OnEvent", TrackingEventHandler)
  TrackingManager:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  TrackingManager:RegisterEvent("PLAYER_ENTERING_WORLD")
  TrackingManager:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
  if (MOD.UseCombo) then
    TrackingManager:RegisterEvent("UNIT_COMBO_POINTS")
    TrackingManager:RegisterEvent("PLAYER_TARGET_CHANGED")
  end
  ClearTracking()
end

function MOD:DisableTracking()
  TrackingManager:SetScript("OnEvent", nil)
  TrackingManager:UnregisterAllEvents()
  ClearTracking()
end

function MOD:UpdateHealerIcon(plate)
  local rawName = plate.ref.nametext
  if rawName then
    local healerIcon = plate.frame.health.icon
    if PlateIsHealer(rawName) then
      healerIcon:Show()
    else
      healerIcon:Hide()
    end
  end
end

function MOD:UpdateComboPoints(plate)
  local frame = plate.frame
  local numPoints = CPoints[plate.guid] or 0
  if(numPoints == 0) then
    TrackedPlatesCP[plate] = nil
  else
    TrackedPlatesCP[plate] = true
  end
  for i=1, MAX_COMBO_POINTS do
    if(i <= numPoints) then
      frame.combo[i]:Show()
    else
      frame.combo[i]:Hide()
    end
  end
end

function MOD:UpdateComboPointsByUnitID(unit)
  if(unit == "player" or unit == "vehicle") then
    local guid = UnitGUID("target")
    if (not guid) then return end
    local numPoints = GetComboPoints(UnitHasVehicleUI('player') and 'vehicle' or 'player', 'target')
    if(numPoints > 0) then
      if(LastKnownTarget ~= guid) then
        CPoints[LastKnownTarget] = nil
      end
    end
    LastKnownTarget = guid
    LastKnownPoints = numPoints
    CPoints[guid] = numPoints
    MOD:RequestScanUpdate(guid, false, false, "UpdateComboPoints")
  end
end