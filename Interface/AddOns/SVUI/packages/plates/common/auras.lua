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
local AuraFont = SuperVillain.Media.font.numbers;
local AuraFSize = 7;
local AuraFOutline = "OUTLINE";
local AuraExtraFilter = "CC";
local AuraMaxCount = 5;

local RIconData = {["STAR"] = 0x00000001, ["CIRCLE"] = 0x00000002, ["DIAMOND"] = 0x00000004, ["TRIANGLE"] = 0x00000008, ["MOON"] = 0x00000010, ["SQUARE"] = 0x00000020, ["CROSS"] = 0x00000040, ["SKULL"] = 0x00000080};
local RIconNames = {"STAR", "CIRCLE", "DIAMOND", "TRIANGLE", "MOON", "SQUARE", "CROSS", "SKULL"}
local NPAuraType = {
  ["Buff"] = 1,
  ["Curse"] = 2,
  ["Disease"] = 3,
  ["Magic"] = 4,
  ["Poison"] = 5,
  ["Debuff"] = 6,
};
local NPAuraEvents = {
  ["SPELL_AURA_APPLIED"] = 1,
  ["SPELL_AURA_REFRESH"] = 1,
  ["SPELL_AURA_APPLIED_DOSE"] = 2, 
  ["SPELL_AURA_REMOVED_DOSE"] = 2,
  ["SPELL_AURA_BROKEN"] = 3,
  ["SPELL_AURA_BROKEN_SPELL"] = 3,
  ["SPELL_AURA_REMOVED"] = 3
};
local HealSpecs = {
  [L['Restoration']] = true,
  [L['Holy']] = true,
  [L['Discipline']] = true, 
  [L['Mistweaver']] = true
};

local AuraList = {}
local AuraSpellID = {}
local AuraExpiration = {}
local AuraStacks = {}
local AuraCaster = {}
local AuraDuration = {}
local AuraTexture = {}
local AuraType = {}
local AuraTarget = {}
local AuraByRaidIcon = {}
local AuraByName = {}
local CachedAuraDurations = {};
local AurasCache = {};
local AuraClockManager = CreateFrame("Frame");
AuraClockManager.Clocks = {};
AuraClockManager.Events = {};
AuraClockManager.IsActive = false;
AuraClockManager.UpdateClock = 0;
--[[ 
########################################################## 
PARSE FUNCTIONS
##########################################################
]]--
--SVUI_PlateClockHandler
local function ClockUpdateHandler(self)
  local curTime = GetTime()
  if curTime < self.UpdateClock then return end
  local deactivate = true;
  self.UpdateClock = curTime + 0.1
  for frame, expiration in pairs(self.Clocks) do
    local calc = 0;
    local expires = expiration - curTime;
    if expiration < curTime then 
      frame:Hide(); 
      self.Clocks[frame] = nil
    else 
      if expires < 60 then 
        calc = floor(expires)
        if expires >= 4 then
          frame.TimeLeft:SetFormattedText("|cffffff00%d|r", calc)
        elseif expires >= 1 then
          frame.TimeLeft:SetFormattedText("|cffff0000%d|r", calc)
        else
          frame.TimeLeft:SetFormattedText("|cffff0000%.1f|r", expires)
        end 
      elseif expires < 3600 then
        calc = ceil(expires / 60);
        frame.TimeLeft:SetFormattedText("|cffffffff%.1f|r", calc)
      elseif expires < 86400 then
        calc = ceil(expires / 3600);
        frame.TimeLeft:SetFormattedText("|cff66ffff%.1f|r", calc)
      else
        calc = ceil(expires / 86400);
        frame.TimeLeft:SetFormattedText("|cff6666ff%.1f|r", calc)
      end
      deactivate = false
    end
  end
  if deactivate then 
    self:SetScript("OnUpdate", nil); 
    self.IsActive = false 
  end
end

local function RegisterAuraClock(frame, expiration)
  if(not frame) then return end
  if expiration == 0 then 
    frame:Hide()
    AuraClockManager.Clocks[frame] = nil
  else
    AuraClockManager.Clocks[frame] = expiration
    frame:Show()
    if not AuraClockManager.IsActive then 
      AuraClockManager:SetScript("OnUpdate", ClockUpdateHandler)
      AuraClockManager.IsActive = true
    end
  end
end

local function DropAura(guid, spellID)
  if guid and spellID and AuraList[guid] then
    local instanceID = tostring(guid)..tostring(spellID)..(tostring(caster or "UNKNOWN_CASTER"))
    local auraID = spellID..(tostring(caster or "UNKNOWN_CASTER"))
    if AuraList[guid][auraID] then
      AuraSpellID[instanceID] = nil
      AuraExpiration[instanceID] = nil
      AuraStacks[instanceID] = nil
      AuraCaster[instanceID] = nil
      AuraDuration[instanceID] = nil
      AuraTexture[instanceID] = nil
      AuraType[instanceID] = nil
      AuraTarget[instanceID] = nil
      AuraList[guid][auraID] = nil
    end
  end
end

local function DropAllAuras(guid)
  if guid and AuraList[guid] then
    local unitAuraList = AuraList[guid]
    for auraID, instanceID in pairs(unitAuraList) do
      AuraSpellID[instanceID] = nil
      AuraExpiration[instanceID] = nil
      AuraStacks[instanceID] = nil
      AuraCaster[instanceID] = nil
      AuraDuration[instanceID] = nil
      AuraTexture[instanceID] = nil
      AuraType[instanceID] = nil
      AuraTarget[instanceID] = nil
      AuraList[guid][auraID] = nil
    end
  end
end

local function GetAuraList(guid)
  if guid and AuraList[guid] then return AuraList[guid] end
end

local function GetAuraInstance(guid, auraID)
  if guid and auraID then
    local aura = {}
    local aura_instance_id = guid..auraID
    aura.spellID = AuraSpellID[aura_instance_id]
    aura.expiration = AuraExpiration[aura_instance_id] or 0
    aura.stacks = AuraStacks[aura_instance_id]
    aura.caster = AuraCaster[aura_instance_id]
    aura.duration = AuraDuration[aura_instance_id]
    aura.texture = AuraTexture[aura_instance_id]
    aura.type  = AuraType[aura_instance_id]
    aura.target  = AuraTarget[aura_instance_id]
    return aura
  end
end

local function SetAuraInstance(guid, spellID, expiration, stacks, caster, duration, texture, auratype, auratarget)
  local filter = true;
  if (caster == UnitGUID('player')) then
    filter = nil;
  end

  local extraFilter = SuperVillain.Filters[AuraExtraFilter]
  if AuraExtraFilter and extraFilter then
    local name = GetSpellInfo(spellID)
    if AuraExtraFilter == 'Blocked' then
      if extraFilter[name] and extraFilter[name].enable then
        filter = true;
      end
    elseif AuraExtraFilter == 'Strict' then
      if extraFilter[name].spellID and not extraFilter[name].spellID == spellID then
        filter = true;
      end
    else
      if extraFilter[name] and extraFilter[name].enable then
        filter = nil;
      end
    end
  end
  if(filter or (spellID == 65148)) then
    return;
  end
  if guid and spellID and caster and texture then
    local auraID = spellID..(tostring(caster or "UNKNOWN_CASTER"))
    local instanceID = guid..auraID
    AuraList[guid] = AuraList[guid] or {}
    AuraList[guid][auraID] = instanceID
    AuraSpellID[instanceID] = spellID
    AuraExpiration[instanceID] = expiration or 0
    AuraStacks[instanceID] = stacks
    AuraCaster[instanceID] = caster
    AuraDuration[instanceID] = duration
    AuraTexture[instanceID] = texture
    AuraType[instanceID] = auratype
    AuraTarget[instanceID] = auratarget
  end
end

local function UpdateAuraIcon(aura, texture, expiration, stacks, test)
  if aura and texture and expiration then
    aura.Icon:SetTexture(texture)
    if stacks > 1 then 
      aura.Stacks:SetText(stacks)
    else 
      aura.Stacks:SetText("") 
    end
    aura:Show()
    RegisterAuraClock(aura, expiration)
  else 
    RegisterAuraClock(aura, 0)
  end
end

local function SortExpires(t)
  tsort(t, function(a,b) return a.expiration < b.expiration end)
  return t
end

local function UpdateAuraIconGrid(plate)
  local frame = plate.frame;
  local guid = plate.guid;
  local iconCache = frame.auraicons;
  local AurasOnUnit = GetAuraList(guid);
  local AuraSlotIndex = 1;
  local auraID;

  if AurasOnUnit then
    frame.auras:Show()
    local auraCount = 1
    for auraID in pairs(AurasOnUnit) do
      local aura = GetAuraInstance(guid, auraID)
      if tonumber(aura.spellID) then
        aura.name = GetSpellInfo(tonumber(aura.spellID))
        aura.unit = plate.unit
        if aura.expiration > GetTime() then
          AurasCache[auraCount] = aura
          auraCount = auraCount + 1
        end
      end
    end
  end
  AurasCache = SortExpires(AurasCache)
  for index = 1,  #AurasCache do
    local cachedaura = AurasCache[index]
    local gridaura = iconCache[AuraSlotIndex]
    if gridaura and cachedaura.spellID and cachedaura.expiration then
      UpdateAuraIcon(gridaura, cachedaura.texture, cachedaura.expiration, cachedaura.stacks) 
      AuraSlotIndex = AuraSlotIndex + 1
    end
    if(AuraSlotIndex > AuraMaxCount) then 
      break 
    end
  end
  if iconCache[AuraSlotIndex] then
    RegisterAuraClock(iconCache[AuraSlotIndex], 0)
  end
  AurasCache = twipe(AurasCache)
end

local function LoadDuration(spellID)
  if spellID then 
    return CachedAuraDurations[spellID] or 0
  end
  return 0
end

local function SaveDuration(spellID, duration)
  duration = duration or 0
  if spellID then CachedAuraDurations[spellID] = duration end
end

local function CleanAuraLists()
  local currentTime = GetTime()
  for guid, instanceList in pairs(AuraList) do
    local auracount = 0
    for auraID, instanceID in pairs(instanceList) do
      local expiration = Aura_Expiration[instanceID]
      if expiration and expiration < currentTime then
        AuraList[guid][auraID] = nil
        AuraSpellID[instanceID] = nil
        AuraExpiration[instanceID] = nil
        AuraStacks[instanceID] = nil
        AuraCaster[instanceID] = nil
        AuraDuration[instanceID] = nil
        AuraTexture[instanceID] = nil
        AuraType[instanceID] = nil
        AuraTarget[instanceID] = nil
      else
        auracount = auracount + 1
      end
    end
    if auracount == 0 then
      AuraList[guid] = nil
    end
  end
end

local function ClearClocks()
  AuraClockManager.Clocks = twipe(AuraClockManager.Clocks)
end

local function GetCombatEventResults(...)
  local timestamp, combatevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlag, spellid, spellname  = ...
  local auraType, stackCount = select(15, ...)
  return timestamp, combatevent, sourceGUID, destGUID, destName, destFlags, destRaidFlag, auraType, spellid, spellname, stackCount
end
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function MOD:UNIT_AURA(event, unit)
  if unit == "target" then
    self:UpdateAurasByUnitID("target")
  elseif unit == "focus" then
    self:UpdateAurasByUnitID("focus")
  end
end
-- guid, spellID, expiration, stacks, caster, duration, texture, auratype, auratarget
function MOD:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
  local timestamp, combatevent, sourceGUID, destGUID, destName, destFlags, destRaidFlag, auraType, spellID, spellName, stackCount = GetCombatEventResults(...)
  if NPAuraEvents[combatevent] then 
    if NPAuraEvents[combatevent] == 1 then
      local duration = LoadDuration(spellID)
      local texture = GetSpellTexture(spellID)
      SetAuraInstance(destGUID, spellID, (GetTime() + duration), 1, sourceGUID, duration, texture, auraType, AURA_TARGET_HOSTILE)
    elseif NPAuraEvents[combatevent] == 2 then
      local duration = LoadDuration(spellID)
      local texture = GetSpellTexture(spellID)
      SetAuraInstance(destGUID, spellID, (GetTime() + duration), stackCount, sourceGUID, duration, texture, auraType, AURA_TARGET_HOSTILE)
    elseif NPAuraEvents[combatevent] == 3 then
      DropAura(destGUID, spellID)
    end 
    local rawName, raidIcon
    if(destName and (band(destFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) > 0)) then 
      rawName = split("-", destName)
      AuraByName[rawName] = destGUID
    end
    for iconName, bitmask in pairs(RIconData) do
      if band(destRaidFlag, bitmask) > 0  then
        raidIcon = iconName
        AuraByRaidIcon[raidIcon] = destGUID
        break
      end
    end
    MOD:RequestScanUpdate(destGUID, raidIcon, rawName, "UpdateAuras")
  end 
end
--[[ 
########################################################## 
MODULE FUNCTIONS
##########################################################
]]--
function MOD:UpdateAuraLocals()
  AuraFont = SuperVillain.Shared:Fetch("font", self.db.auras.font);
  AuraFSize = self.db.auras.fontSize;
  AuraFOutline = self.db.auras.fontOutline;
  AuraExtraFilter = self.db.auras.additionalFilter;
  AuraMaxCount = self.db.auras.numAuras;
end

function MOD:UpdateAurasByUnitID(unitid)
  local unitType
  if UnitIsFriend("player", unitid) then unitType = AURA_TARGET_FRIENDLY else unitType = AURA_TARGET_HOSTILE end
  local guid = UnitGUID(unitid)
  DropAllAuras(guid)

  local index

  for index = 1, 40 do
    local spellname , _, texture, count, dispelType, duration, expirationTime, unitCaster, _, _, spellid, _, isBossDebuff = UnitDebuff(unitid, index)
    if not spellname then break end
    SaveDuration(spellid, duration)
    SetAuraInstance(guid, spellid, expirationTime, count, UnitGUID(unitCaster or ""), duration, texture, NPAuraType[dispelType or "Debuff"], unitType)
  end

  if unitType == AURA_TARGET_FRIENDLY then
    for index = 1, 40 do
      local spellname , _, texture, count, dispelType, duration, expirationTime, unitCaster, _, _, spellid, _, isBossDebuff = UnitBuff(unitid, index)
      if not spellname then break end
      SaveDuration(spellid, duration)
      SetAuraInstance(guid, spellid, expirationTime, count, UnitGUID(unitCaster or ""), duration, texture, AURA_TYPE_BUFF, AURA_TARGET_FRIENDLY)

    end
  end

  local raidIcon, name;
  if UnitPlayerControlled(unitid) then 
    name = UnitName(unitid)
    AuraByName[name] = guid
  end
  raidIcon = RIconNames[GetRaidTargetIndex(unitid) or ""];
  if raidIcon then
    AuraByRaidIcon[raidIcon] = guid
  end
  MOD:RequestScanUpdate(guid, raidIcon, name, "UpdateAuras")
end

function MOD:UpdateAuras(plate)
  if plate.setting.tiny then return end;
  local guid = plate.guid
  local frame = plate.frame
  if not guid then
    if RAID_CLASS_COLORS[plate.setting.unitcategory] then
      local name = gsub(plate.name:GetText(), '%s%(%*%)','')
      guid = AuraByName[name]
    elseif plate.ref.raidicon:IsShown() then 
      guid = AuraByRaidIcon[plate.ref.raidicontype] 
    end
    if guid then
      plate.guid = guid
    else
      frame.auras:Hide()
      return
    end
  end
  UpdateAuraIconGrid(plate)
  if(MOD.UseCombo) then
    MOD:UpdateComboPoints(plate)
  end
end

function MOD:CreateAuraIcon(auras, plate)
  local noscalemult = 2 * UIParent:GetScale()
  local button = CreateFrame("Frame", nil, auras)
  button:SetScript('OnHide', function()
    if plate.guid then
      UpdateAuraIconGrid(plate)
    end
  end)
  button.bord = button:CreateTexture(nil, "BACKGROUND")
  button.bord:SetDrawLayer('BACKGROUND', 2)
  button.bord:SetTexture(0,0,0,1)
  button.bord:SetPoint("TOPLEFT", button, "TOPLEFT", -noscalemult, noscalemult)
  button.bord:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", noscalemult, -noscalemult)
  button.Icon = button:CreateTexture(nil, "BORDER")
  button.Icon:SetPoint("TOPLEFT",button,"TOPLEFT")
  button.Icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT")
  button.Icon:SetTexCoord(.1, .9, .2, .8)
  button.TimeLeft = button:CreateFontString(nil, 'OVERLAY')
  button.TimeLeft:SetFont(AuraFont, AuraFSize, AuraFOutline)
  button.TimeLeft:SetPoint("BOTTOMLEFT",button,"TOPLEFT",-3,-1)
  button.TimeLeft:SetJustifyH('CENTER') 
  button.Stacks = button:CreateFontString(nil,"OVERLAY")
  button.Stacks:SetFont(AuraFont, AuraFSize + 2, AuraFOutline)
  button.Stacks:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",3,-3)
  button:Hide()
  return button
end

MOD.RegisterAuraClock = RegisterAuraClock;