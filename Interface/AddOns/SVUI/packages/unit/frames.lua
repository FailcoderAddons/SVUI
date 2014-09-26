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
--]]
--[[ GLOBALS ]]--
local _G        = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local tostring  = _G.tostring;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math, math.ceil;
--[[ STRING METHODS ]]--
local find, format, upper = string.find, string.format, string.upper;
local match, gsub = string.match, string.gsub;
local numMin, ceil = math.min;

local SVUI_ADDON_NAME, SV = ...
local oUF_Villain = SV.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_Villain, "SVUI was unable to locate oUF.")

local L = LibStub("LibSuperVillain-1.0"):Lang();
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVUnit
if(not MOD) then return end 
--[[ 
########################################################## 
LOCAL DATA
##########################################################
]]--
local CONSTRUCTORS, GROUP_UPDATES, PROXY_UPDATES = {}, {}, {}
local lastArenaFrame, lastBossFrame
local sortMapping = {
    ["DOWN_RIGHT"] = {[1]="TOP",[2]="TOPLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=-1,[8]=false},
    ["DOWN_LEFT"] = {[1]="TOP",[2]="TOPRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=1,[7]=-1,[8]=false},
    ["UP_RIGHT"] = {[1]="BOTTOM",[2]="BOTTOMLEFT",[3]="LEFT",[4]="RIGHT",[5]="LEFT",[6]=1,[7]=1,[8]=false},
    ["UP_LEFT"] = {[1]="BOTTOM",[2]="BOTTOMRIGHT",[3]="RIGHT",[4]="LEFT",[5]="RIGHT",[6]=-1,[7]=1,[8]=false},
    ["RIGHT_DOWN"] = {[1]="LEFT",[2]="TOPLEFT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=1,[7]=-1,[8]=true},
    ["RIGHT_UP"] = {[1]="LEFT",[2]="BOTTOMLEFT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=1,[7]=1,[8]=true},
    ["LEFT_DOWN"] = {[1]="RIGHT",[2]="TOPRIGHT",[3]="TOP",[4]="BOTTOM",[5]="TOP",[6]=-1,[7]=-1,[8]=true},
    ["LEFT_UP"] = {[1]="RIGHT",[2]="BOTTOMRIGHT",[3]="BOTTOM",[4]="TOP",[5]="BOTTOM",[6]=-1,[7]=1,[8]=true},
    ["UP"] = {[1]="BOTTOM",[2]="BOTTOM",[3]="BOTTOM",[4]="TOP",[5]="TOP",[6]=1,[7]=1,[8]=false},
    ["DOWN"] = {[1]="TOP",[2]="TOP",[3]="TOP",[4]="BOTTOM",[5]="BOTTOM",[6]=1,[7]=1,[8]=false},
}
local GroupDistributor = {
    ["CLASS"] = function(x)
        x:SetAttribute("groupingOrder","DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK,WARRIOR,MONK")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","CLASS")
    end,
    ["MTMA"] = function(x)
        x:SetAttribute("groupingOrder","MAINTANK,MAINASSIST,NONE")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","ROLE")
    end,
    ["ROLE_TDH"] = function(x)
        x:SetAttribute("groupingOrder","TANK,DAMAGER,HEALER,NONE")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","ASSIGNEDROLE")
    end,
    ["ROLE_HTD"] = function(x)
        x:SetAttribute("groupingOrder","HEALER,TANK,DAMAGER,NONE")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","ASSIGNEDROLE")
    end,
    ["ROLE_HDT"] = function(x)
        x:SetAttribute("groupingOrder","HEALER,DAMAGER,TANK,NONE")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","ASSIGNEDROLE")
    end,
    ["ROLE"] = function(x)
        x:SetAttribute("groupingOrder","TANK,HEALER,DAMAGER,NONE")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy","ASSIGNEDROLE")
    end,
    ["NAME"] = function(x)
        x:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy",nil)
    end,
    ["GROUP"] = function(x)
        x:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        x:SetAttribute("sortMethod","INDEX")
        x:SetAttribute("groupBy","GROUP")
    end,
    ["PETNAME"] = function(x)
        x:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        x:SetAttribute("sortMethod","NAME")
        x:SetAttribute("groupBy", nil)
        x:SetAttribute("filterOnPet", true)
    end
}
--[[ 
########################################################## 
ALL UNIT HELPERS
##########################################################
]]--
local UpdateTargetGlow = function(self)
    if not self.unit then return end 
    local unit = self.unit;
    if(UnitIsUnit(unit, "target")) then 
        self.TargetGlow:Show()
        local reaction = UnitReaction(unit, "player")
        if(UnitIsPlayer(unit)) then 
            local _, class = UnitClass(unit)
            if class then 
                local colors = RAID_CLASS_COLORS[class]
                self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
            else 
                self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
            end 
        elseif(reaction) then 
            local colors = FACTION_BAR_COLORS[reaction]
            self.TargetGlow:SetBackdropBorderColor(colors.r, colors.g, colors.b)
        else 
            self.TargetGlow:SetBackdropBorderColor(1, 1, 1)
        end 
    else 
        self.TargetGlow:Hide()
    end 
end
--[[
########################################################## 
STANDARD UNITS 
########################################################## 
PLAYER
##########################################################
]]--
local UpdatePlayerFrame = function(self)
    local db = MOD.db["player"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    local USE_CLASSBAR = db.classbar.enable;
    local classBarHeight = db.classbar.height;
    local classBarWidth = db.width * 0.4;
    local healthPanel = self.HealthPanel
    local iconDB = db.icons
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")

    MOD.RefreshUnitMedia(self, "player")

    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    local lossSize = UNIT_WIDTH * 0.6
    self.LossOfControl.stunned:SetSize(lossSize, lossSize)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())

    MOD:RefreshUnitLayout(self, "player")

    do 
        local resting = self.Resting;
        if resting then
            if iconDB and iconDB.restIcon and iconDB.restIcon.enable then
                local size = iconDB.restIcon.size;
                resting:ClearAllPoints()
                resting:Size(size)
                SV:ReversePoint(resting, iconDB.restIcon.attachTo, healthPanel, iconDB.restIcon.xOffset, iconDB.restIcon.yOffset)
                if not self:IsElementEnabled("Resting")then 
                    self:EnableElement("Resting")
                end 
            elseif self:IsElementEnabled("Resting")then 
                self:DisableElement("Resting")
                resting:Hide()
            end
        end
    end 
    do 
        local combat = self.Combat;
        if combat then
            if iconDB and iconDB.combatIcon and iconDB.combatIcon.enable then
                local size = iconDB.combatIcon.size;
                combat:ClearAllPoints()
                combat:Size(size)
                SV:ReversePoint(combat, iconDB.combatIcon.attachTo, healthPanel, iconDB.combatIcon.xOffset, iconDB.combatIcon.yOffset)
                if not self:IsElementEnabled("Combat")then 
                    self:EnableElement("Combat")
                end 
            elseif self:IsElementEnabled("Combat")then 
                self:DisableElement("Combat")
                combat:Hide()
            end
        end
    end 
    do 
        local pvp = self.PvPText;
        local point = db.pvp.position;
        pvp:ClearAllPoints()
        pvp:Point(db.pvp.position, healthPanel, db.pvp.position)
        self:Tag(pvp, db.pvp.tags)
    end 
    do 
        if SV.class == "DRUID" and self.DruidAltMana then 
            if db.power.druidMana then 
                self:EnableElement("DruidAltMana")
            else 
                self:DisableElement("DruidAltMana")
                self.DruidAltMana:Hide()
            end 
        end 
        if SV.class == "MONK" then 
            local stagger = self.DrunkenMaster;
            if db.stagger.enable then 
                if not self:IsElementEnabled("DrunkenMaster")then 
                    self:EnableElement("DrunkenMaster")
                end 
            else 
                if self:IsElementEnabled("DrunkenMaster")then 
                    self:DisableElement("DrunkenMaster")
                end 
            end 
        end 
    end 
    do
        if(self.DruidAltMana) then 
            if db.power.druidMana then 
                self:EnableElement("DruidAltMana")
            else 
                self:DisableElement("DruidAltMana")
                self.DruidAltMana:Hide()
            end 
        end 
        if(self.DrunkenMaster) then
            if db.stagger.enable then 
                if not self:IsElementEnabled("DrunkenMaster")then 
                    self:EnableElement("DrunkenMaster")
                end 
            else 
                if self:IsElementEnabled("DrunkenMaster")then 
                    self:DisableElement("DrunkenMaster")
                end 
            end 
        end
        
        if(self.ClassBar or self.HyperCombo) then
            if USE_CLASSBAR and self.ClassBarRefresh then 
                self.ClassBarRefresh(self)
            end 
            if(self.ClassBar) then
                local classBar = self[self.ClassBar];
                if USE_CLASSBAR then
                    if(not self:IsElementEnabled(self.ClassBar)) then 
                        self:EnableElement(self.ClassBar)
                    end
                    classBar:Show()
                else
                    if(self:IsElementEnabled(self.ClassBar)) then 
                        self:DisableElement(self.ClassBar)
                    end
                    classBar:Hide()
                end
            end
            if(self.HyperCombo) then
                if USE_CLASSBAR then
                    if not self:IsElementEnabled("HyperCombo") then 
                        self:EnableElement("HyperCombo")
                    end
                    self.HyperCombo:Show()
                else
                    if self:IsElementEnabled("HyperCombo") then 
                        self:DisableElement("HyperCombo")
                    end
                    self.HyperCombo:Hide()
                end
            end
        end
    end 
    do 
        if db.combatfade and not self:IsElementEnabled("CombatFade")then 
            self:EnableElement("CombatFade")
        elseif 
            not db.combatfade and self:IsElementEnabled("CombatFade")then 
            self:DisableElement("CombatFade")
        end 
    end 
    self:UpdateAllElements()
end

CONSTRUCTORS["player"] = function(self, unit)
    local key = "player"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Health.frequentUpdates = true
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = true
    MOD:CreatePortrait(self, false, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Castbar = MOD:CreateCastbar(self, false, L["Player Castbar"], true, true)
    MOD:CreateExperienceRepBar(self)
    self.ClassBar = MOD:CreateClassBar(self)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Resting = MOD:CreateRestingIndicator(self)
    self.Combat = MOD:CreateCombatIndicator(self)
    self.PvPText = self.InfoPanel:CreateFontString(nil,'OVERLAY')
    self.PvPText:SetFontTemplate(LSM:Fetch("font", MOD.db.font), MOD.db.fontSize, MOD.db.fontOutline)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.HealPrediction = MOD:CreateHealPrediction(self, true)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.CombatFade = true;
    self:Point("BOTTOMLEFT", SV.UIParent, "BOTTOM", -413, 182)
    SV.Mentalo:Add(self, L["Player Frame"], nil, nil, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePlayerFrame
    
    return self 
end
--[[ 
########################################################## 
TARGET
##########################################################
]]--
local UpdateTargetFrame = function(self)
    local db = MOD.db["target"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    local USE_COMBOBAR = db.combobar.enable;
    local comboBarHeight = db.combobar.height;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")

    MOD.RefreshUnitMedia(self, "target")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    if not self:IsElementEnabled("ActionPanel")then 
        self:EnableElement("ActionPanel")
    end
    if not self:IsElementEnabled("Friendship")then 
        self:EnableElement("Friendship")
    end
    MOD:RefreshUnitLayout(self, "target")

    if(MOD.db.xrayFocus) then
        self.XRay:Show()
    else
        self.XRay:Hide()
    end

    if(not IsAddOnLoaded("Clique")) then 
        if db.middleClickFocus then 
            self:SetAttribute("type3", "focus")
        elseif self:GetAttribute("type3") == "focus"then 
            self:SetAttribute("type3", nil)
        end 
    end

    if (SV.class == "ROGUE" or SV.class == "DRUID") and self.HyperCombo then 
        local comboBar = self.HyperCombo;
        if self.ComboRefresh then 
            self.ComboRefresh(self)
        end 
        if db.combobar.autoHide then 
            comboBar:SetParent(self)
        else 
            comboBar:SetParent(SV.UIParent)
        end

        if comboBar.Avatar then
            comboBar.Avatar:SetScale(0.000001)
            comboBar.Avatar:SetAlpha(0)
        end
        
        if USE_COMBOBAR and not self:IsElementEnabled("HyperCombo")then 
            self:EnableElement("HyperCombo")
        elseif not USE_COMBOBAR and self:IsElementEnabled("HyperCombo")then 
            self:DisableElement("HyperCombo")
            comboBar:Hide()
        end 
    end 

    self:UpdateAllElements()
end

CONSTRUCTORS["target"] = function(self, unit)
    local key = "target"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)

    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true
    self.HealPrediction = MOD:CreateHealPrediction(self, true)

    self.Power = MOD:CreatePowerBar(self, true, true)
    self.Power.frequentUpdates = true

    MOD:CreatePortrait(self)

    self.Castbar = MOD:CreateCastbar(self, true, L["Target Castbar"], true)

    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.Afflicted = MOD:CreateAfflicted(self)
    tinsert(self.__elements, MOD.SmartAuraDisplay)
    self:RegisterEvent("PLAYER_TARGET_CHANGED", MOD.SmartAuraDisplay)

    self.RaidIcon = MOD:CreateRaidIcon(self)
    local isSmall = MOD.db[key].combobar.smallIcons
    if(SV.class == "ROGUE") then
        self.HyperCombo = MOD:CreateRogueCombobar(self, isSmall)
    elseif(SV.class == "DRUID") then
        self.HyperCombo = MOD:CreateDruidCombobar(self, isSmall)
    end

    --self.GPS = MOD:CreateGPS(self)
    self.Friendship = MOD:CreateFriendshipBar(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self.XRay = MOD:CreateXRay(self)
    self.XRay:SetPoint("TOPRIGHT", 12, 12)
    self:Point("BOTTOMRIGHT", SV.UIParent, "BOTTOM", 413, 182)
    SV.Mentalo:Add(self, L["Target Frame"], nil, nil, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateTargetFrame
    return self 
end 
--[[ 
########################################################## 
TARGET OF TARGET
##########################################################
]]--
local UpdateTargetTargetFrame = function(self)
    local db = MOD.db["targettarget"]
    local UNIT_WIDTH = db.width
    local UNIT_HEIGHT = db.height
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "targettarget")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "targettarget")
    self:UpdateAllElements()
end

CONSTRUCTORS["targettarget"] = function(self, unit)
    local key = "targettarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    MOD:CreatePortrait(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:Point("BOTTOM", SV.UIParent, "BOTTOM", 0, 213)
    SV.Mentalo:Add(self, L["TargetTarget Frame"], nil, nil, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateTargetTargetFrame
    return self 
end
--[[ 
########################################################## 
PET
##########################################################
]]--
local UpdatePetFrame = function(self)
    local db = MOD.db["pet"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "pet")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "pet")
    do 
        if SVUI_Player and not InCombatLockdown()then 
            self:SetParent(SVUI_Player)
        end 
    end 
    MOD:UpdateAuraWatch(self, "pet")
    self:UpdateAllElements()
end

CONSTRUCTORS["pet"] = function(self, unit)
    local key = "pet"
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Health.frequentUpdates = true;
    self.HealPrediction = MOD:CreateHealPrediction(self)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = false;
    MOD:CreatePortrait(self, true)
    self.Castbar = MOD:CreateCastbar(self, false, nil, false)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:Point("BOTTOM", SV.UIParent, "BOTTOM", 0, 182)
    SV.Mentalo:Add(self, L["Pet Frame"], nil, nil, nil, "ALL, SOLO")
    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePetFrame
    return self 
end 
--[[ 
########################################################## 
TARGET OF PET
##########################################################
]]--
local UpdatePetTargetFrame = function(self)
    local db = MOD.db["pettarget"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "pettarget")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "pettarget")
    do 
        if SVUI_Pet and not InCombatLockdown()then 
            self:SetParent(SVUI_Pet)
        end 
    end 
    self:UpdateAllElements()
end

CONSTRUCTORS["pettarget"] = function(self, unit)
    local key = "pettarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:Point("BOTTOM", SVUI_Pet, "TOP", 0, 7)
    SV.Mentalo:Add(self, L["PetTarget Frame"], nil, -7, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePetTargetFrame
    return self 
end 
--[[ 
########################################################## 
FOCUS
##########################################################
]]--
local UpdateFocusFrame = function(self)
    local db = MOD.db["focus"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "focus")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "focus")

    if(MOD.db.xrayFocus) then
        self.XRay:Show()
    else
        self.XRay:Hide()
    end

    MOD:UpdateAuraWatch(self, "focus")
    self:UpdateAllElements()
end

CONSTRUCTORS["focus"] = function(self, unit)
    local key = "focus"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true

    self.HealPrediction = MOD:CreateHealPrediction(self, true)
    self.Power = MOD:CreatePowerBar(self, true)

    self.Castbar = MOD:CreateCastbar(self, false, L["Focus Castbar"])
    self.Castbar.SafeZone = nil

    self.Castbar.LatencyTexture:Hide()
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    tinsert(self.__elements, MOD.SmartAuraDisplay)
    self:RegisterEvent("PLAYER_FOCUS_CHANGED", MOD.SmartAuraDisplay)

    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self.XRay = MOD:CreateXRay_Closer(self)
    self.XRay:SetPoint("RIGHT", 20, 0)
    self:Point("BOTTOMRIGHT", SVUI_Target, "TOPRIGHT", 0, 220)
    SV.Mentalo:Add(self, L["Focus Frame"], nil, nil, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateFocusFrame
    return self 
end
--[[ 
########################################################## 
TARGET OF FOCUS
##########################################################
]]--
local UpdateFocusTargetFrame = function(self)
    local db = MOD.db["focustarget"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, "focustarget")
    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "focustarget")
    self:UpdateAllElements()
end

CONSTRUCTORS["focustarget"] = function(self, unit)
    local key = "focustarget"
    self.unit = unit
    self.___key = key

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:Point("BOTTOM", SVUI_Focus, "TOP", 0, 7)
    SV.Mentalo:Add(self, L["FocusTarget Frame"], nil, -7, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateFocusTargetFrame
    return self 
end 
--[[ 
########################################################## 
BOSS
##########################################################
]]--
local UpdateBossFrame = function(self)
    local db = MOD.db["boss"]
    local INDEX = self:GetID() or 1;
    local holder = _G["SVUI_Boss_MOVE"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height;

    MOD.RefreshUnitMedia(self, "boss")

    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    self:ClearAllPoints()

    if(tonumber(INDEX) == 1) then
        holder:Width(UNIT_WIDTH)
        holder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
        if db.showBy == "UP"then 
            self:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
        else 
            self:Point("TOPRIGHT", holder, "TOPRIGHT")
        end 
    else
        local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (INDEX - 1)
        if db.showBy == "UP"then 
            self:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
        else 
            self:Point("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
        end 
    end 

    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD:RefreshUnitLayout(self, "boss")
    self:UpdateAllElements()
end

CONSTRUCTORS["boss"] = function(self, unit)
    local key = "boss"
    local selfID = unit:match('boss(%d)')
    self.unit = unit
    self.___key = key
    self:SetID(selfID)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Health.frequentUpdates = true
    self.Power = MOD:CreatePowerBar(self, true, true)
    MOD:CreatePortrait(self)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.Castbar = MOD:CreateCastbar(self, true, nil, true, nil, true)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.AltPowerBar = MOD:CreateAltPowerBar(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetAttribute("type2", "focus")

    if(not _G["SVUI_Boss_MOVE"]) then
        self:Point("RIGHT", SV.UIParent, "RIGHT", -105, 0)
        SV.Mentalo:Add(self, L["Boss Frames"], nil, nil, nil, "ALL, PARTY, RAID10, RAID25, RAID40", "SVUI_Boss")
    else
        self:Point("TOPRIGHT", lastBossFrame, "BOTTOMRIGHT", 0, -20)
    end

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateBossFrame
    lastBossFrame = self
    return self 
end
--[[ 
########################################################## 
ARENA
##########################################################
]]--
local function CreatePrepFrame(frameName, parentFrame, parentID)
    local prep = CreateFrame("Frame", frameName, UIParent)
    prep:SetFrameStrata("MEDIUM")
    prep:SetAllPoints(parentFrame)
    prep:SetID(parentID)
    prep:SetPanelTemplate("Bar", true, 3, 1, 1)

    local health = CreateFrame("StatusBar", nil, prep)
    health:SetAllPoints(prep)
    health:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
    prep.Health = health

    local icon = CreateFrame("Frame", nil, prep)
    icon:SetSize(45,45)
    icon:SetPoint("LEFT", prep, "RIGHT", 2, 0)
    icon:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0, 
        edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeSize = 2, 
        insets = {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0
        }
    })
    icon:SetBackdropColor(0, 0, 0, 0)
    icon:SetBackdropBorderColor(0, 0, 0)
    icon.Icon = icon:CreateTexture(nil, "OVERLAY")
    icon.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    icon.Icon:FillInner(icon, 2, 2)
    prep.SpecIcon = icon

    local text = prep.Health:CreateFontString(nil, "OVERLAY")
    text:SetFont(SV.Media.font.names, 16, "OUTLINE")
    text:SetTextColor(1, 1, 1)
    text:SetPoint("CENTER")
    prep.SpecClass = text

    prep:Hide()
end

local UpdateArenaFrame = function(self)
    local db = MOD.db["arena"]
    local INDEX = self:GetID() or 1;
    local holder = _G["SVUI_Arena_MOVE"]
    local UNIT_WIDTH = db.width;
    local UNIT_HEIGHT = db.height

    MOD.RefreshUnitMedia(self, "arena")

    self.colors = oUF_Villain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")

    self:ClearAllPoints()

    if(tonumber(INDEX) == 1) then
        holder:Width(UNIT_WIDTH)
        holder:Height(UNIT_HEIGHT + (UNIT_HEIGHT + 12 + db.castbar.height) * 4)
        if(db.showBy == "UP") then 
            self:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT")
        else 
            self:Point("TOPRIGHT", holder, "TOPRIGHT")
        end 
    else
        local yOffset = (UNIT_HEIGHT + 12 + db.castbar.height) * (INDEX - 1)
        if(db.showBy == "UP") then 
            self:Point("BOTTOMRIGHT", holder, "BOTTOMRIGHT", 0, yOffset)
        else 
            self:Point("TOPRIGHT", holder, "TOPRIGHT", 0, -yOffset)
        end 
    end

    MOD:RefreshUnitLayout(self, "arena")

    if(self.Combatant) then
        local pvp = self.Combatant
        local trinket = pvp.Trinket
        local badge = pvp.Badge

        local leftAnchor = self
        local rightAnchor = self

        trinket:Size(db.pvp.trinketSize)
        trinket:ClearAllPoints()
        if(db.pvp.trinketPosition == "RIGHT") then 
            trinket:Point("LEFT", rightAnchor, "RIGHT", db.pvp.trinketX, db.pvp.trinketY)
            rightAnchor = trinket
        else 
            trinket:Point("RIGHT", leftAnchor, "LEFT", db.pvp.trinketX, db.pvp.trinketY)
            leftAnchor = trinket
        end

        badge:Size(db.pvp.specSize)
        badge:ClearAllPoints()
        if(db.pvp.specPosition == "RIGHT") then 
            badge:Point("LEFT", rightAnchor, "RIGHT", db.pvp.specX, db.pvp.specY)
            rightAnchor = badge
        else 
            badge:Point("RIGHT", leftAnchor, "LEFT", db.pvp.specX, db.pvp.specY)
            leftAnchor = badge
        end

        pvp:ClearAllPoints()
        pvp:SetPoint("TOPLEFT", leftAnchor, "TOPLEFT", 0, 0)
        pvp:SetPoint("BOTTOMRIGHT", rightAnchor, "BOTTOMRIGHT", 0, 0)

        if(db.pvp.enable and (not self:IsElementEnabled("Combatant"))) then
            self:EnableElement("Combatant")
            pvp:Show()
        elseif((not db.pvp.enable) and self:IsElementEnabled("Combatant")) then 
            self:DisableElement("Combatant")
            pvp:Hide()
        end
    end

    self:UpdateAllElements()
end

CONSTRUCTORS["arena"] = function(self, unit)
    local key = "arena"
    local selfID = unit:match('arena(%d)')
    self.unit = unit
    self.___key = key
    self:SetID(selfID)

    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    self:SetFrameLevel(2)
    
    local selfName = self:GetName()
    local prepName = selfName.."PrepFrame";
    

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true, true)
    self.Power = MOD:CreatePowerBar(self, true)
    MOD:CreatePortrait(self)
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.Castbar = MOD:CreateCastbar(self, true, nil, true, nil, true)
    self.Combatant = MOD:CreateCombatant(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self:SetAttribute("type2", "focus")

    if(not _G[prepName]) then CreatePrepFrame(prepName, self, selfID) end

    if(not _G["SVUI_Arena_MOVE"]) then
        self:Point("RIGHT", SV.UIParent, "RIGHT", -105, 0)
        SV.Mentalo:Add(self, L["Arena Frames"], nil, nil, nil, "ALL, ARENA", "SVUI_Arena")
    else
        self:Point("TOPRIGHT", lastArenaFrame, "BOTTOMRIGHT", 0, -20)
    end

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdateArenaFrame
    lastArenaFrame = self
    return self 
end
--[[ 
########################################################## 
PREP FRAME
##########################################################
]]--
local ArenaPrepHandler = CreateFrame("Frame")
local ArenaPrepHandler_OnEvent = function(self, event)
    local prepframe
    local _, instanceType = IsInInstance()
    if(not MOD.db.arena or not MOD.db.arena.enable or instanceType ~= "arena") then return end
    if event == "PLAYER_LOGIN" then
        for i = 1, 5 do
            prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
            if(prepframe) then
                prepframe:SetAllPoints(_G["SVUI_Arena"..i])
            end
        end
    elseif event == "ARENA_OPPONENT_UPDATE" then
        for i = 1, 5 do
            prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
            if(prepframe and prepframe:IsShown()) then
                prepframe:Hide()
            end
        end
    else
        local numOpps = GetNumArenaOpponentSpecs()
        if numOpps > 0 then
            for i = 1, 5 do
                prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
                if(prepframe) then
                    if i <= numOpps then
                        local s = GetArenaOpponentSpec(i)
                        local _, spec, class = nil, "UNKNOWN", "UNKNOWN"
                        if s and s > 0 then
                            _, spec, _, icon, _, _, class = GetSpecializationInfoByID(s)
                        end
                        if class and spec then
                            prepframe.SpecClass:SetText(spec .. " - " .. LOCALIZED_CLASS_NAMES_MALE[class])
                            prepframe.SpecIcon.Icon:SetTexture(icon or [[INTERFACE\ICONS\INV_MISC_QUESTIONMARK]])

                            local color = SVUI_CLASS_COLORS[class]
                            local textcolor = RAID_CLASS_COLORS[class] or color
                            if color then
                                prepframe.Health:SetStatusBarColor(color.r, color.g, color.b)
                                prepframe.SpecClass:SetTextColor(textcolor.r, textcolor.g, textcolor.b)
                            else
                                prepframe.Health:SetStatusBarColor(0.25, 0.25, 0.25)
                                prepframe.SpecClass:SetTextColor(1, 1, 1)
                            end

                            prepframe:Show()
                        end
                    else
                        prepframe:Hide()
                    end
                end
            end
        else
            for i = 1, 5 do
                prepframe = _G["SVUI_Arena"..i.."PrepFrame"]
                if(prepframe and prepframe:IsShown()) then
                    prepframe:Hide()
                end
            end
        end
    end
end 

ArenaPrepHandler:RegisterEvent("PLAYER_LOGIN")
ArenaPrepHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
ArenaPrepHandler:RegisterEvent("ARENA_OPPONENT_UPDATE")
ArenaPrepHandler:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
ArenaPrepHandler:SetScript("OnEvent", ArenaPrepHandler_OnEvent)
--[[ 
########################################################## 
LOAD/UPDATE METHOD
##########################################################
]]--
function MOD:SetUnitFrame(key)
    if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
    local unit = key
    local realName = unit:gsub("(.)", upper, 1)
    realName = realName:gsub("t(arget)", "T%1")
    local styleName = "SVUI_"..realName
    local frame
    if not self.Units[unit] then
        oUF_Villain:RegisterStyle(styleName, CONSTRUCTORS[key])
        oUF_Villain:SetActiveStyle(styleName)
        frame = oUF_Villain:Spawn(unit, styleName)
        self.Units[unit] = frame
    else
        frame = self.Units[unit]
    end
    if frame:GetParent() ~= SVUI_UnitFrameParent then 
        frame:SetParent(SVUI_UnitFrameParent)
    end
    if(self.db.enable and self.db[key].enable) then 
        frame:Enable()
        frame:Update()
    else
        frame:Disable()
    end
end

function MOD:SetEnemyFrames(key, maxCount)
    if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
    for i = 1, maxCount do
        local unit = key..i
        local realName = unit:gsub("(.)", upper, 1)
        realName = realName:gsub("t(arget)", "T%1")
        local styleName = "SVUI_"..realName
        local frame
        if not self.Units[unit] then
            oUF_Villain:RegisterStyle(styleName, CONSTRUCTORS[key])
            oUF_Villain:SetActiveStyle(styleName)
            frame = oUF_Villain:Spawn(unit, styleName)
            self.Units[unit] = frame
        else
            frame = self.Units[unit]
        end
        if frame:GetParent() ~= SVUI_UnitFrameParent then 
            frame:SetParent(SVUI_UnitFrameParent)
        end
        if frame.isForced then 
            self:AllowElement(frame)
        end
        if(self.db.enable and self.db[key].enable) then 
            frame:Enable()
            frame:Update() 
        else 
            frame:Disable()
        end
    end
end
--[[
##########################################################
HEADER UNITS                                                    
########################################################## 
HEADER FRAME HELPERS
##########################################################
]]--
local GroupMediaUpdate = function(self)
    local key = self.___groupkey
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do
        MOD.RefreshUnitMedia(childFrame, key)
        if(_G[childFrame:GetName().."Pet"]) then 
            MOD.RefreshUnitMedia(_G[childFrame:GetName().."Pet"], key, updateElements)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            MOD.RefreshUnitMedia(_G[childFrame:GetName().."Target"], key, updateElements)
        end
        childFrame:UpdateAllElements()
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

local DetachSubFrames = function(...)
    for i = 1, select("#", ...) do 
        local frame = select(i,...)
        frame:ClearAllPoints()
    end 
end
--[[ 
########################################################## 
RAID 10, 25, 40
##########################################################
]]--
local Raid10Visibility = function(self, event)
    local db = MOD.db["raid10"]
    if (not db or (db and not db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end 

    local instance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
    if(event == "PLAYER_REGEN_ENABLED") then 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end 
    if not InCombatLockdown() then 
        if(instance and (instanceType == "raid") and (maxPlayers == 10)) then 
            UnregisterStateDriver(self, "visibility")
            self:Show()
        elseif(instance and (instanceType == "raid")) then 
            UnregisterStateDriver(self, "visibility")
            self:Hide()
        elseif db.visibility then 
            RegisterStateDriver(self, "visibility", db.visibility)
        end 
    else 
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return 
    end 
end

local Raid25Visibility = function(self, event)
    local db = MOD.db["raid25"]
    if (not db or (db and not db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end 

    local instance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED"then 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end 
    if not InCombatLockdown()then 
        if(instance and (instanceType == "raid") and (maxPlayers == 25)) then 
            UnregisterStateDriver(self, "visibility")
            self:Show()
        elseif(instance and (instanceType == "raid")) then 
            UnregisterStateDriver(self, "visibility")
            self:Hide()
        elseif db.visibility then 
            RegisterStateDriver(self, "visibility", db.visibility)
        end 
    else 
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return 
    end 
end

local Raid40Visibility = function(self, event)
    local db = MOD.db["raid40"]
    if (not db or (db and not db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end 

    local instance, instanceType = IsInInstance()
    local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
    if event == "PLAYER_REGEN_ENABLED"then 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end 
    if not InCombatLockdown()then 
        if(instance and (instanceType == "raid") and (maxPlayers == 40)) then 
            UnregisterStateDriver(self, "visibility")
            self:Show()
        elseif(instance and (instanceType == "raid")) then 
            UnregisterStateDriver(self, "visibility")
            self:Hide()
        elseif db.visibility then 
            RegisterStateDriver(self, "visibility", db.visibility)
        end 
    else 
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return 
    end 
end

local UpdateRaidSubUnit = function(self, key, db)
    self.colors = oUF_Villain.colors;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(db)
    if not InCombatLockdown() then 
        self:Size(UNIT_WIDTH, UNIT_HEIGHT) 
    end 
    do
        local rdBuffs = self.RaidDebuffs;
        if db.rdebuffs.enable then
            if not self:IsElementEnabled('RaidDebuffs')then
                self:EnableElement("RaidDebuffs")
            end
            local actualSz = numMin(db.rdebuffs.size, (UNIT_HEIGHT - 8))
            rdBuffs:Size(actualSz)
            rdBuffs:Point("CENTER", self, "CENTER", db.rdebuffs.xOffset, db.rdebuffs.yOffset)
            rdBuffs:Show()
        else 
            self:DisableElement("RaidDebuffs")
            rdBuffs:Hide()
        end 
    end 
    MOD.RefreshUnitMedia(self, key)
    MOD:UpdateAuraWatch(self, key)
    MOD:RefreshUnitLayout(self, key)
    if(key ~= "raidpet") then
        self:EnableElement("ReadyCheck")
    end
    self:UpdateAllElements()
end

GROUP_UPDATES["raid10"] = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SV.UIParent, "LEFT", 4, 0)
        SV.Mentalo:Add(frame, L["Raid 10 Frames"], nil, nil, nil, "ALL, RAID"..10)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetScript("OnEvent", Raid10Visibility)
        PROXY_UPDATES["raid10"] = function() Raid10Visibility(frame) end;
        frame.positioned = true 
    end 
    Raid10Visibility(frame)
    local key = "raid10"
    local db = MOD.db[key]
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do 
        UpdateRaidSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

GROUP_UPDATES["raid25"] = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SV.UIParent, "LEFT", 4, 0)
        SV.Mentalo:Add(frame, L["Raid 25 Frames"], nil, nil, nil, "ALL, RAID"..25)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetScript("OnEvent", Raid25Visibility)
        PROXY_UPDATES["raid25"] = function() Raid25Visibility(frame) end;
        frame.positioned = true 
    end 
    Raid25Visibility(frame)
    local key = "raid25"
    local db = MOD.db[key]
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do 
        UpdateRaidSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

GROUP_UPDATES["raid40"] = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SV.UIParent, "LEFT", 4, 0)
        SV.Mentalo:Add(frame, L["Raid 40 Frames"], nil, nil, nil, "ALL, RAID"..40)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:SetScript("OnEvent", Raid40Visibility)
        PROXY_UPDATES["raid40"] = function() Raid40Visibility(frame) end;
        frame.positioned = true 
    end 
    Raid40Visibility(frame)
    local key = "raid40"
    local db = MOD.db[key]
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do 
        UpdateRaidSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

local function SetRaidFrame(frame)
    frame:SetScript("OnEnter", UnitFrame_OnEnter)
    frame:SetScript("OnLeave", UnitFrame_OnLeave)

    frame.RaidDebuffs = MOD:CreateRaidDebuffs(frame)
    frame.Afflicted = MOD:CreateAfflicted(frame)
    frame.ResurrectIcon = MOD:CreateResurectionIcon(frame)
    frame.LFDRole = MOD:CreateRoleIcon(frame)
    frame.RaidRoleFramesAnchor = MOD:CreateRaidRoleFrames(frame)
    frame.RaidIcon = MOD:CreateRaidIcon(frame)
    frame.ReadyCheck = MOD:CreateReadyCheckIcon(frame)
    frame.HealPrediction = MOD:CreateHealPrediction(frame)
    frame.Range = { insideAlpha = 1, outsideAlpha = 1 }

    local shadow = CreateFrame("Frame", nil, frame)
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(frame:GetFrameStrata())
    shadow:WrapOuter(frame, 3, 3)
    shadow:SetBackdrop({
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
        edgeSize = 3, 
        insets = {
            left = 5, 
            right = 5, 
            top = 5, 
            bottom = 5
        }
    })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.9)
    shadow:Hide()
    frame.TargetGlow = shadow
    tinsert(frame.__elements, UpdateTargetGlow)
    frame:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetGlow)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateTargetGlow)

    return frame 
end

CONSTRUCTORS["raid10"] = function(self, unit)
    local key = "raid10"
    self.unit = unit
    self.___key = key
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = false
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    return SetRaidFrame(self) 
end

CONSTRUCTORS["raid25"] = function(self, unit)
    local key = "raid25"
    self.unit = unit
    self.___key = key
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = false
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    return SetRaidFrame(self)  
end

CONSTRUCTORS["raid40"] = function(self, unit)
    local key = "raid40"
    self.unit = unit
    self.___key = key
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Power = MOD:CreatePowerBar(self, true)
    self.Power.frequentUpdates = false
    self.Buffs = MOD:CreateBuffs(self, key)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    return SetRaidFrame(self) 
end
--[[ 
########################################################## 
RAID PETS
##########################################################
]]--
local RaidPetVisibility = function(self, event)
    local db = MOD.db["raidpet"]
    if (not db or (db and not db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end
    local inInstance, instanceType = IsInInstance()
    if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
    
    if not InCombatLockdown() then
        if inInstance and instanceType == "raid" then
            UnregisterStateDriver(self, "visibility")
            self:Show()
        elseif db.visibility then
            RegisterStateDriver(self, "visibility", db.visibility)
        end
    else
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
        return
    end
end

GROUP_UPDATES["raidpet"] = function(self)
    local raidPets = self:GetParent()
    if not raidPets.positioned then 
        raidPets:ClearAllPoints()
        raidPets:Point("BOTTOMLEFT", SV.UIParent, "BOTTOMLEFT", 4, 433)
        SV.Mentalo:Add(raidPets, L["Raid Pet Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
        raidPets:RegisterEvent("PLAYER_ENTERING_WORLD")
        raidPets:SetScript("OnEvent", RaidPetVisibility)
        PROXY_UPDATES["raidpet"] = function() RaidPetVisibility(raidPets) end;
        raidPets.positioned = true;
    end 
    RaidPetVisibility(raidPets)
    local key = "raidpet"
    local db = MOD.db[key]
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do 
        UpdateRaidSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateRaidSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

CONSTRUCTORS["raidpet"] = function(self, unit)
    local key = "raidpet"
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.Debuffs = MOD:CreateDebuffs(self, key)
    self.AuraWatch = MOD:CreateAuraWatch(self, key)
    self.RaidDebuffs = MOD:CreateRaidDebuffs(self)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }

    local shadow = CreateFrame("Frame", nil, self)
    shadow:SetFrameLevel(1)
    shadow:SetFrameStrata(self:GetFrameStrata())
    shadow:WrapOuter(self, 3, 3)
    shadow:SetBackdrop({
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
        edgeSize = 3, 
        insets = {
            left = 5, 
            right = 5, 
            top = 5, 
            bottom = 5
        }
    })
    shadow:SetBackdropColor(0, 0, 0, 0)
    shadow:SetBackdropBorderColor(0, 0, 0, 0.9)
    shadow:Hide()
    self.TargetGlow = shadow
    tinsert(self.__elements, UpdateTargetGlow)

    self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetGlow)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateTargetGlow)
    return self 
end 
--[[ 
########################################################## 
PARTY
##########################################################
]]--
local PartyVisibility = function(self, event)
    local db = MOD.db["party"]
    if (not db or (db and not db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end
    local instance, instanceType = IsInInstance()
    if(event == "PLAYER_REGEN_ENABLED") then 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end 
    if(not InCombatLockdown()) then 
        if(instance and instanceType == "raid") then 
            UnregisterStateDriver(self,"visibility")
            self:Hide()
        elseif db.visibility then 
            RegisterStateDriver(self, "visibility", db.visibility)
        end 
    else 
        self:RegisterEvent("PLAYER_REGEN_ENABLED")
    end 
end

local UpdatePartySubUnit = function(self, key, db)
    self.colors = oUF_Villain.colors;
    self:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
    MOD.RefreshUnitMedia(self, key)
    if self.isChild then 
        local altDB = db.petsGroup;
        if self == _G[self.originalParent:GetName()..'Target'] then 
            altDB = db.targetsGroup 
        end 
        if not self.originalParent.childList then 
            self.originalParent.childList = {}
        end 
        self.originalParent.childList[self] = true;
        if not InCombatLockdown()then 
            if altDB.enable then
                local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(altDB) 
                self:SetParent(self.originalParent)
                self:Size(UNIT_WIDTH, UNIT_HEIGHT)
                self:ClearAllPoints()
                SV:ReversePoint(self, altDB.anchorPoint, self.originalParent, altDB.xOffset, altDB.yOffset)
            else 
                self:SetParent(SV.Cloaked)
            end 
        end 
        do 
            local health = self.Health;
            health.Smooth = nil;
            health.frequentUpdates = nil;
            health.colorSmooth = nil;
            health.colorHealth = nil;
            health.colorClass = true;
            health.colorReaction = true;
            health:ClearAllPoints()
            health:Point("TOPRIGHT", self, "TOPRIGHT", -1, -1)
            health:Point("BOTTOMLEFT", self, "BOTTOMLEFT", 1, 1)
        end 
        do 
            local nametext = self.InfoPanel.Name
            self:Tag(nametext, altDB.tags)
        end 
    else 
        if not InCombatLockdown() then
            local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(db)
            self:Size(UNIT_WIDTH, UNIT_HEIGHT) 
        end 
        MOD:RefreshUnitLayout(self, key)
        MOD:UpdateAuraWatch(self, key)
    end 
    self:EnableElement('ReadyCheck')
    self:UpdateAllElements()
end

GROUP_UPDATES["party"] = function(self)
    local group = self:GetParent()
    if not group.positioned then 
        group:ClearAllPoints()
        group:Point("LEFT",SV.UIParent,"LEFT",40,0)
        SV.Mentalo:Add(group, L['Party Frames'], nil, nil, nil, 'ALL,PARTY,ARENA');
        group:RegisterEvent("PLAYER_ENTERING_WORLD")
        group:SetScript("OnEvent", PartyVisibility)
        PROXY_UPDATES["party"] = function() PartyVisibility(group) end;
        group.positioned = true;
    end 
    PartyVisibility(group)
    local key = "party"
    local db = MOD.db[key]
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)

    while childFrame do 
        UpdatePartySubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdatePartySubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdatePartySubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

CONSTRUCTORS["party"] = function(self, unit)
    local key = "party"
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)

    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)

    if self.isChild then 
        self.originalParent = self:GetParent()
    else
        self.Power = MOD:CreatePowerBar(self, true)
        self.Power.frequentUpdates = false
        MOD:CreatePortrait(self, true)
        self.Buffs = MOD:CreateBuffs(self, key)
        self.Debuffs = MOD:CreateDebuffs(self, key)
        self.AuraWatch = MOD:CreateAuraWatch(self, key)
        self.Afflicted = MOD:CreateAfflicted(self)
        self.ResurrectIcon = MOD:CreateResurectionIcon(self)
        self.LFDRole = MOD:CreateRoleIcon(self)
        self.RaidRoleFramesAnchor = MOD:CreateRaidRoleFrames(self)
        self.RaidIcon = MOD:CreateRaidIcon(self)
        self.ReadyCheck = MOD:CreateReadyCheckIcon(self)
        self.HealPrediction = MOD:CreateHealPrediction(self)
        --self.GPS = MOD:CreateGPS(self, true)

        local shadow = CreateFrame("Frame", nil, self)
        shadow:SetFrameLevel(1)
        shadow:SetFrameStrata(self:GetFrameStrata())
        shadow:WrapOuter(self, 3, 3)
        shadow:SetBackdrop({
            edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
            edgeSize = 3, 
            insets = {
                left = 5, 
                right = 5, 
                top = 5, 
                bottom = 5
            }
        })
        shadow:SetBackdropColor(0, 0, 0, 0)
        shadow:SetBackdropBorderColor(0, 0, 0, 0.9)
        shadow:Hide()
        self.TargetGlow = shadow
        tinsert(self.__elements, UpdateTargetGlow)
        self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateTargetGlow)
        self:RegisterEvent("PLAYER_ENTERING_WORLD", UpdateTargetGlow)
        self:RegisterEvent("GROUP_ROSTER_UPDATE", UpdateTargetGlow)
    end 

    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    return self 
end
--[[ 
########################################################## 
TANK
##########################################################
]]--
local UpdateTankSubUnit = function(self, key, db)
    self.colors = oUF_Villain.colors;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, key)
    if self.isChild and self.originalParent then 
        local targets = db.targetsGroup;
        if not self.originalParent.childList then 
            self.originalParent.childList = {}
        end 
        self.originalParent.childList[self] = true;
        if not InCombatLockdown()then 
            if targets.enable then
                local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(targets)
                self:SetParent(self.originalParent)
                self:Size(UNIT_WIDTH, UNIT_HEIGHT)
                self:ClearAllPoints()
                SV:ReversePoint(self, targets.anchorPoint, self.originalParent, targets.xOffset, targets.yOffset)
            else 
                self:SetParent(SV.Cloaked)
            end 
        end 
    elseif not InCombatLockdown() then
        local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(db)
        self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    end 
    MOD:RefreshUnitLayout(self, key)
    do 
        local nametext = self.InfoPanel.Name;
        if oUF_Villain.colors.healthclass then 
            self:Tag(nametext, "[name:10]")
        else 
            self:Tag(nametext, "[name:color][name:10]")
        end 
    end 
    self:UpdateAllElements()
end

local UpdateTankFrame = function(self)
    local key = "tank"
    local db = MOD.db[key]
    if db.enable ~= true then 
        UnregisterAttributeDriver(self, "state-visibility")
        self:Hide()
        return 
    end
    self:Hide()
    DetachSubFrames(self:GetChildren())
    self:SetAttribute("startingIndex", -1)
    RegisterAttributeDriver(self, "state-visibility", "show")
    self.dirtyWidth, self.dirtyHeight = self:GetSize()
    RegisterAttributeDriver(self, "state-visibility", "[@raid1, exists] show;hide")
    self:SetAttribute("startingIndex", 1)
    self:SetAttribute("point", "BOTTOM")
    self:SetAttribute("columnAnchorPoint", "LEFT")
    DetachSubFrames(self:GetChildren())
    self:SetAttribute("yOffset", 7)
    if not self.positioned then 
        self:ClearAllPoints()
        self:Point("TOPLEFT", SV.UIParent, "TOPLEFT", 4, -40)
        SV.Mentalo:Add(self, L["Tank Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
        self.Avatar.positionOverride = "TOPLEFT"
        self:SetAttribute("minHeight", self.dirtyHeight)
        self:SetAttribute("minWidth", self.dirtyWidth)
        self.positioned = true 
    end
    for i = 1, self:GetNumChildren() do 
        local childFrame = select(i, self:GetChildren())
        UpdateTankSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateTankSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateTankSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
    end
end

CONSTRUCTORS["tank"] = function(self, unit)
    local key = "tank"
    local db = MOD.db[key]
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.RaidIcon:SetPoint("BOTTOMRIGHT")
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    UpdateTankSubUnit(self, key, db)
    self.originalParent = self:GetParent()
    return self 
end
--[[ 
########################################################## 
ASSIST
##########################################################
]]--
local UpdateAssistSubUnit = function(self, key, db)
    self.colors = oUF_Villain.colors;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    MOD.RefreshUnitMedia(self, key)
    if self.isChild and self.originalParent then 
        local targets = db.targetsGroup;
        if not self.originalParent.childList then 
            self.originalParent.childList = {}
        end 
        self.originalParent.childList[self] = true;
        if not InCombatLockdown()then 
            if targets.enable then
                local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(targets)
                self:SetParent(self.originalParent)
                self:Size(UNIT_WIDTH, UNIT_HEIGHT)
                self:ClearAllPoints()
                SV:ReversePoint(self, targets.anchorPoint, self.originalParent, targets.xOffset, targets.yOffset)
            else 
                self:SetParent(SV.Cloaked)
            end 
        end 
    elseif not InCombatLockdown() then
        local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(db)
        self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    end 

    MOD:RefreshUnitLayout(self, key)

    do 
        local nametext = self.InfoPanel.Name;
        if oUF_Villain.colors.healthclass then 
            self:Tag(nametext, "[name:10]")
        else 
            self:Tag(nametext, "[name:color][name:10]")
        end 
    end 
    self:UpdateAllElements()
end

local UpdateAssistFrame = function(self)
    local key = "assist"
    local db = MOD.db[key]
    self:Hide()
    DetachSubFrames(self:GetChildren())
    self:SetAttribute("startingIndex", -1)
    RegisterAttributeDriver(self, "state-visibility", "show")
    self.dirtyWidth, self.dirtyHeight = self:GetSize()
    RegisterAttributeDriver(self, "state-visibility", "[@raid1, exists] show;hide")
    self:SetAttribute("startingIndex", 1)
    self:SetAttribute("point", "BOTTOM")
    self:SetAttribute("columnAnchorPoint", "LEFT")
    DetachSubFrames(self:GetChildren())
    self:SetAttribute("yOffset", 7)
    if not self.positioned then 
        self:ClearAllPoints()
        self:Point("TOPLEFT", SV.UIParent, "TOPLEFT", 4, -140)
        SV.Mentalo:Add(self, L["Assist Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
        self.Avatar.positionOverride = "TOPLEFT"
        self:SetAttribute("minHeight", self.dirtyHeight)
        self:SetAttribute("minWidth", self.dirtyWidth)
        self.positioned = true 
    end
    for i = 1, self:GetNumChildren() do 
        local childFrame = select(i, self:GetChildren())
        UpdateAssistSubUnit(childFrame, key, db)
        if(_G[childFrame:GetName().."Pet"]) then 
            UpdateAssistSubUnit(_G[childFrame:GetName().."Pet"], key, db)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            UpdateAssistSubUnit(_G[childFrame:GetName().."Target"], key, db)
        end
    end
end

CONSTRUCTORS["assist"] = function(self, unit)
    local key = "assist"
    local db = MOD.db[key]
    self.unit = unit
    self.___key = key
    self:SetScript("OnEnter", UnitFrame_OnEnter)
    self:SetScript("OnLeave", UnitFrame_OnLeave)
    MOD:SetActionPanel(self, key)
    self.Health = MOD:CreateHealthBar(self, true)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.RaidIcon:SetPoint("BOTTOMRIGHT")
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    UpdateAssistSubUnit(self, key, db)
    self.originalParent = self:GetParent()
    return self 
end
--[[ 
########################################################## 
GROUP HEADER METHODS
##########################################################
]]--
local GroupSetConfigEnvironment = function(self)
    local key = self.___groupkey
    local db = MOD.db[key]
    local UNIT_WIDTH, UNIT_HEIGHT = MOD:GetActiveSize(db)
    local anchorPoint;
    local sorting = db.showBy
    local pointMap = sortMapping[sorting]
    local sortMethod = db.sortMethod
    local widthCalc, heightCalc, xCalc, yCalc = 0, 0, 0, 0;
    local point1, point2, point3, point4, point5, horizontal, vertical, isHorizontal = pointMap[1], pointMap[2], pointMap[3], pointMap[4], pointMap[5], pointMap[6], pointMap[7], pointMap[8];
    for i = 1, db.groupCount do 
        local frame = self.groups[i]
        if frame then
            if(db.showBy == "UP") then 
                db.showBy = "UP_RIGHT"
            end
            if(db.showBy == "DOWN") then 
                db.showBy = "DOWN_RIGHT"
            end 
            if isHorizontal then 
                frame:SetAttribute("xOffset", db.wrapXOffset * horizontal)
                frame:SetAttribute("yOffset", 0)
                frame:SetAttribute("columnSpacing", db.wrapYOffset)
            else 
                frame:SetAttribute("xOffset", 0)
                frame:SetAttribute("yOffset", db.wrapYOffset * vertical)
                frame:SetAttribute("columnSpacing", db.wrapXOffset)
            end
            if not frame.isForced then 
                if not frame.initialized then 
                    frame:SetAttribute("startingIndex", db.customSorting and (-min(db.groupCount * db.gRowCol * 5, MAX_RAID_MEMBERS) + 1) or -4)
                    frame:Show()
                    frame.initialized = true 
                end
                frame:SetAttribute("startingIndex", 1)
            end
            frame:ClearAllPoints()
            if db.customSorting and db.invertGroupingOrder then 
                frame:SetAttribute("columnAnchorPoint", point4)
            else 
                frame:SetAttribute("columnAnchorPoint", point3)
            end
            DetachSubFrames(frame:GetChildren())
            frame:SetAttribute("point", point1)
            if not frame.isForced then
                frame:SetAttribute("maxColumns", db.customSorting and db.groupCount or 1)
                frame:SetAttribute("unitsPerColumn", db.customSorting and (db.gRowCol * 5) or 5)
                GroupDistributor[sortMethod](frame)
                frame:SetAttribute("sortDir", db.sortDir)
                frame:SetAttribute("showPlayer", db.showPlayer)
            end
            if i == 1 and db.customSorting then 
                frame:SetAttribute("groupFilter", "1, 2, 3, 4, 5, 6, 7, 8")
            else 
                frame:SetAttribute("groupFilter", tostring(i))
            end 
        end
        local anchorPoint = point2
        if db.customSorting and db.startFromCenter then 
            anchorPoint = point5
        end
        if (i - 1) % db.gRowCol == 0 then 
            if isHorizontal then 
                if frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, 0, heightCalc * vertical)
                end
                heightCalc = heightCalc + UNIT_HEIGHT + db.wrapYOffset;
                yCalc = yCalc + 1 
            else 
                if frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
                end
                widthCalc = widthCalc + UNIT_WIDTH + db.wrapXOffset;
                xCalc = xCalc + 1 
            end 
        else
            if isHorizontal then 
                if yCalc == 1 then 
                    if frame then 
                        frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
                    end
                    widthCalc = widthCalc + (UNIT_WIDTH + db.wrapXOffset) * 5;
                    xCalc = xCalc + 1 
                elseif frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, (((UNIT_WIDTH + db.wrapXOffset) * 5) * ((i - 1) % db.gRowCol)) * horizontal, ((UNIT_HEIGHT + db.wrapYOffset) * (yCalc - 1)) * vertical)
                end 
            else 
                if xCalc == 1 then 
                    if frame then 
                        frame:SetPoint(anchorPoint, self, anchorPoint, 0, heightCalc * vertical)
                    end
                    heightCalc = heightCalc + (UNIT_HEIGHT + db.wrapYOffset) * 5;
                    yCalc = yCalc + 1 
                elseif frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, ((UNIT_WIDTH + db.wrapXOffset) * (xCalc - 1)) * horizontal, (((UNIT_HEIGHT + db.wrapYOffset) * 5) * ((i - 1) % db.gRowCol)) * vertical)
                end 
            end 
        end
        if heightCalc == 0 then 
            heightCalc = heightCalc + (UNIT_HEIGHT + db.wrapYOffset) * 5 
        elseif widthCalc == 0 then 
            widthCalc = widthCalc + (UNIT_WIDTH + db.wrapXOffset) * 5 
        end 
    end
    self:SetSize(widthCalc - db.wrapXOffset, heightCalc - db.wrapYOffset)
end

local GroupHeaderUpdate = function(self)
    local key = self.___groupkey
    if MOD.db[key].enable ~= true then 
        UnregisterAttributeDriver(self, "state-visibility")
        self:Hide()
        return 
    end
    for i=1,#self.groups do
        self.groups[i]:Update()
    end 
end

local GroupHeaderMediaUpdate = function(self)
    for i=1,#self.groups do
        self.groups[i]:MediaUpdate()
    end
end

local GroupSetActiveState = function(self)
    if not self.isForced then
        local key = self.___groupkey
        local db = MOD.db[key]
        if(db) then
            for i=1,#self.groups do
                local frame = self.groups[i]
                if(i <= db.groupCount and ((db.customSorting and i <= 1) or not db.customSorting)) then

                    frame:Show()
                else 
                    if frame.forceShow then 
                        frame:Hide()
                        MOD:RestrictChildren(frame, frame:GetChildren())
                        frame:SetAttribute('startingIndex',1)
                    else 
                        frame:ClearAllAttributes()
                    end 
                end 
            end
        end 
    end 
end
--[[ 
########################################################## 
SUBUNIT CONSTRUCTORS
##########################################################
]]--
local SecureHeaderClear = function(self)
    self:Hide()
    self:SetAttribute("showPlayer", true)
    self:SetAttribute("showSolo", true)
    self:SetAttribute("showParty", true)
    self:SetAttribute("showRaid", true)
    self:SetAttribute("columnSpacing", nil)
    self:SetAttribute("columnAnchorPoint", nil)
    self:SetAttribute("sortMethod", nil)
    self:SetAttribute("groupFilter", nil)
    self:SetAttribute("groupingOrder", nil)
    self:SetAttribute("maxColumns", nil)
    self:SetAttribute("nameList", nil)
    self:SetAttribute("point", nil)
    self:SetAttribute("sortDir", nil)
    self:SetAttribute("sortMethod", "NAME")
    self:SetAttribute("startingIndex", nil)
    self:SetAttribute("strictFiltering", nil)
    self:SetAttribute("unitsPerColumn", nil)
    self:SetAttribute("xOffset", nil)
    self:SetAttribute("yOffset", nil)
end

function MOD:ConstructGroupHeader(parentFrame, filter, styleName, headerName, template1, groupName, template2, updateFunc)
    local db = self.db[groupName]
    local UNIT_WIDTH, UNIT_HEIGHT = self:GetActiveSize(db)

    oUF_Villain:SetActiveStyle(styleName)
    local groupHeader = oUF_Villain:SpawnHeader(headerName, template2, nil, 
        "oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d); self:SetFrameLevel(5)"):format(UNIT_WIDTH, UNIT_HEIGHT), 
        "groupFilter", filter, 
        "showParty", true, 
        "showRaid", true, 
        "showSolo", true, 
        template1 and "template", template1
    )
    groupHeader.___groupkey = groupName
    groupHeader:SetParent(parentFrame)
    groupHeader:Show()

    groupHeader.Update = updateFunc or GROUP_UPDATES[groupName]
    groupHeader.MediaUpdate = GroupMediaUpdate
    groupHeader.ClearAllAttributes = SecureHeaderClear 

    return groupHeader 
end
--[[ 
########################################################## 
LOAD/UPDATE METHOD
##########################################################
]]--
function MOD:ZONE_CHANGED_NEW_AREA()
    if(not IsInGroup()) then return end;
    if(IsInRaid()) then
        local members = GetNumGroupMembers()
        if(members > 25) then
            PROXY_UPDATES["raid40"]()
        elseif(members > 10) then
            PROXY_UPDATES["raid25"]()
        else
            PROXY_UPDATES["raid10"]()
        end
        PROXY_UPDATES["raidpet"]()
    elseif(IsInParty()) then
        PROXY_UPDATES["party"]()
    end;
end

function MOD:SetGroupFrame(key, filter, template1, forceUpdate, template2)
    if(InCombatLockdown()) then self:RegisterEvent("PLAYER_REGEN_ENABLED"); return end
    if(not self.db.enable or not self.db[key]) then return end
    local db = self.db[key]
    local realName = key:gsub("(.)", upper, 1)
    local styleName = "SVUI_"..realName
    local frame, groupName

    if(not self.Headers[key]) then 
        oUF_Villain:RegisterStyle(styleName, CONSTRUCTORS[key])
        oUF_Villain:SetActiveStyle(styleName)

        if(key == "tank") then
            frame = self:ConstructGroupHeader(SVUI_UnitFrameParent, filter, styleName, styleName, template1, key, template2, UpdateTankFrame)
        elseif(key == "assist") then
            frame = self:ConstructGroupHeader(SVUI_UnitFrameParent, filter, styleName, styleName, template1, key, template2, UpdateAssistFrame)
        else
            frame = CreateFrame("Frame", styleName, SVUI_UnitFrameParent, "SecureHandlerStateTemplate")
            frame.groups = {}
            frame.___groupkey = key;
            frame.Update = GroupHeaderUpdate
            frame.MediaUpdate = GroupHeaderMediaUpdate
            frame.SetActiveState = GroupSetActiveState
            frame.SetConfigEnvironment = GroupSetConfigEnvironment
        end
        frame:Show()
        self.Headers[key] = frame
    else
        frame = self.Headers[key]
    end

    if(key == "tank" or key == "assist") then
        frame:Update()
    else
        if(db.enable ~= true and key ~= "raidpet") then
            UnregisterStateDriver(frame, "visibility")
            frame:Hide()
            return 
        end

        if(db.customSorting) then 
            if(not frame.groups[1]) then 
                groupName = styleName .. "Group1"
                local subunit = self:ConstructGroupHeader(frame, 1, styleName, groupName, template1, key, template2)
                frame.groups[1] = subunit
            end 
        else
            for i = 1, db.groupCount do
                if(not frame.groups[i]) then
                    groupName = styleName .. "Group" .. i
                    local subunit = self:ConstructGroupHeader(frame, i, styleName, groupName, template1, key, template2)
                    frame.groups[i] = subunit
                end
            end 
        end

        frame:SetActiveState()

        if(forceUpdate or not frame.Avatar) then 
            frame:SetConfigEnvironment()
            if(not frame.isForced) then 
                RegisterStateDriver(frame, "visibility", db.visibility)
            end 
        else 
            frame:SetConfigEnvironment()
            frame:Update()
        end

        if(db.enable ~= true and key == "raidpet") then 
            UnregisterStateDriver(frame, "visibility")
            frame:Hide()
            return 
        end 
    end 
end