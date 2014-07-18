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
--[[ STRING METHODS ]]--
local find, format, upper = string.find, string.format, string.upper;
local match, gsub = string.match, string.gsub;

local SuperVillain, L = unpack(select(2, ...));
local _, ns = ...
local oUF_SuperVillain = ns.oUF
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end
local ceil,tinsert = math.ceil,table.insert
--[[ 
########################################################## 
LOCAL DATA
##########################################################
]]--
local CONSTRUCTORS, UPDATERS = {}, {}
local lastArenaFrame, lastBossFrame
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
                local colors = SVUI_CLASS_COLORS[class]
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

    self.colors = oUF_SuperVillain.colors;
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
                SuperVillain:ReversePoint(resting, iconDB.restIcon.attachTo, healthPanel, iconDB.restIcon.xOffset, iconDB.restIcon.yOffset)
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
                SuperVillain:ReversePoint(combat, iconDB.combatIcon.attachTo, healthPanel, iconDB.combatIcon.xOffset, iconDB.combatIcon.yOffset)
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
        if SuperVillain.class == "DRUID" and self.DruidAltMana then 
            if db.power.druidMana then 
                self:EnableElement("DruidAltMana")
            else 
                self:DisableElement("DruidAltMana")
                self.DruidAltMana:Hide()
            end 
        end 
        if SuperVillain.class == "MONK" then 
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
            if self.ClassBarRefresh then 
                self.ClassBarRefresh(self)
            end 
            if(self.ClassBar) then
                local classBar = self[self.ClassBar];
                     
                if USE_CLASSBAR then
                    if not db.classbar.detachFromFrame then
                        if classBar.Avatar then 
                            classBar.Avatar:SetScale(0.000001)
                            classBar.Avatar:SetAlpha(0)
                        end 
                    else 
                        classBarWidth = db.classbar.detachedWidth;
                        if not classBar.Avatar then 
                            classBar:Point("TOPLEFT", self, "BOTTOMLEFT", 0, -2)
                            SuperVillain:SetSVMovable(classBar, "ClassBar_MOVE", L["Classbar"], nil, nil, nil, "ALL, SOLO")
                        else
                            classBar.Avatar:SetScale(1)
                            classBar.Avatar:SetAlpha(1)
                        end 
                    end
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
UPDATERS["player"] = UpdatePlayerFrame

local ConstructPlayer = function(self, unit)
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
    MOD:GetClassResources(self)
    self.RaidIcon = MOD:CreateRaidIcon(self)
    self.Resting = MOD:CreateRestingIndicator(self)
    self.Combat = MOD:CreateCombatIndicator(self)
    self.PvPText = self.InfoPanel:CreateFontString(nil,'OVERLAY')
    self.PvPText:SetFontTemplate(SuperVillain.Shared:Fetch("font", MOD.db.font), MOD.db.fontSize, MOD.db.fontOutline)
    self.Afflicted = MOD:CreateAfflicted(self)
    self.HealPrediction = MOD:CreateHealPrediction(self, true)
    self.AuraBars = MOD:CreateAuraBarHeader(self, key)
    self.CombatFade = true;
    self:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOM", -413, 182)
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Player Frame"], nil, nil, nil, "ALL, SOLO")

    self.MediaUpdate = MOD.RefreshUnitMedia
    self.Update = UpdatePlayerFrame
    
    return self 
end
CONSTRUCTORS["player"] = ConstructPlayer
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
    self.colors = oUF_SuperVillain.colors;
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

    if not IsAddOnLoaded("Clique")then 
        if db.middleClickFocus then 
            self:SetAttribute("type3", "focus")
        elseif self:GetAttribute("type3") == "focus"then 
            self:SetAttribute("type3", nil)
        end 
    end

    if (SuperVillain.class == "ROGUE" or SuperVillain.class == "DRUID") and self.HyperCombo then 
        local comboBar = self.HyperCombo;
        if self.ComboRefresh then 
            self.ComboRefresh(self)
        end 
        if db.combobar.autoHide then 
            comboBar:SetParent(self)
        else 
            comboBar:SetParent(SuperVillain.UIParent)
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

    do 
        local gps = self.GPS;
        if not self:IsElementEnabled("GPS") then
            self:EnableElement("GPS")
        end
    end 
    self:UpdateAllElements()
end
UPDATERS["target"] = UpdateTargetFrame

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
    if(SuperVillain.class == "ROGUE") then
        self.HyperCombo = MOD:CreateRogueCombobar(self, isSmall)
    elseif(SuperVillain.class == "DRUID") then
        self.HyperCombo = MOD:CreateDruidCombobar(self, isSmall)
    end

    self.GPS = MOD:CreateGPS(self)
    self.Friendship = MOD:CreateFriendshipBar(self)
    self.Range = { insideAlpha = 1, outsideAlpha = 1 }
    self.XRay = MOD:CreateXRay(self)
    self.XRay:SetPoint("TOPRIGHT", 12, 12)
    self:Point("BOTTOMRIGHT", SuperVillain.UIParent, "BOTTOM", 413, 182)
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Target Frame"], nil, nil, nil, "ALL, SOLO")

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
    self.colors = oUF_SuperVillain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "targettarget")
    self:UpdateAllElements()
end
UPDATERS["targettarget"] = UpdateTargetTargetFrame

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
    self:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 213)
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["TargetTarget Frame"], nil, nil, nil, "ALL, SOLO")

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
    self.colors = oUF_SuperVillain.colors;
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
UPDATERS["pet"] = UpdatePetFrame

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
    self:Point("BOTTOM", SuperVillain.UIParent, "BOTTOM", 0, 182)
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Pet Frame"], nil, nil, nil, "ALL, SOLO")
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
    self.colors = oUF_SuperVillain.colors;
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
UPDATERS["pettarget"] = UpdatePetTargetFrame

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
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["PetTarget Frame"], nil, -7, nil, "ALL, SOLO")

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
    self.colors = oUF_SuperVillain.colors;
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
UPDATERS["focus"] = UpdateFocusFrame

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
    self.XRay:SetPoint("BOTTOMRIGHT", 20, -10)
    self:Point("BOTTOMRIGHT", SVUI_Target, "TOPRIGHT", 0, 220)
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Focus Frame"], nil, nil, nil, "ALL, SOLO")

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
    self.colors = oUF_SuperVillain.colors;
    self:Size(UNIT_WIDTH, UNIT_HEIGHT)
    _G[self:GetName().."_MOVE"]:Size(self:GetSize())
    MOD:RefreshUnitLayout(self, "focustarget")
    self:UpdateAllElements()
end
UPDATERS["focustarget"] = UpdateFocusTargetFrame

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
    SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["FocusTarget Frame"], nil, -7, nil, "ALL, SOLO")

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

    self.colors = oUF_SuperVillain.colors;
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
UPDATERS["boss"] = UpdateBossFrame

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
        self:Point("RIGHT", SuperVillain.UIParent, "RIGHT", -105, 0)
        SuperVillain:SetSVMovable(self, "SVUI_Boss_MOVE", L["Boss Frames"], nil, nil, nil, "ALL, PARTY, RAID10, RAID25, RAID40")
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
    prep:SetPanelTemplate("Bar", true, 3, 3, 3)

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
    text:SetFont(SuperVillain.Media.font.names, 12, "OUTLINE")
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

    self.colors = oUF_SuperVillain.colors;
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
UPDATERS["arena"] = UpdateArenaFrame

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
        self:Point("RIGHT", SuperVillain.UIParent, "RIGHT", -105, 0)
        SuperVillain:SetSVMovable(self, "SVUI_Arena_MOVE", L["Arena Frames"], nil, nil, nil, "ALL, ARENA")
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
    if(not MOD.db.arena.enable or instanceType ~= "arena") then return end
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

                            local color = RAID_CLASS_COLORS[class]
                            local textcolor = SVUI_CLASS_COLORS[class] or color
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
    if InCombatLockdown() then self:FrameForge() return end
    local unit = key
    local realName = unit:gsub("(.)", upper, 1)
    realName = realName:gsub("t(arget)", "T%1")
    local styleName = "SVUI_"..realName
    local frame
    if not self.Units[unit] then
        oUF_SuperVillain:RegisterStyle(styleName, CONSTRUCTORS[key])
        oUF_SuperVillain:SetActiveStyle(styleName)
        frame = oUF_SuperVillain:Spawn(unit, styleName)
        self.Units[unit] = frame
    else
        frame = self.Units[unit]
    end
    if frame:GetParent() ~= SVUI_UnitFrameParent then 
        frame:SetParent(SVUI_UnitFrameParent)
    end
    if self.db[key].enable then
        frame:Enable()
        frame:Update()
    else
        frame:Disable()
    end
end

function MOD:SetEnemyFrames(key, maxCount)
    if InCombatLockdown() then self:FrameForge() return end
    for i = 1, maxCount do
        local unit = key..i
        local realName = unit:gsub("(.)", upper, 1)
        realName = realName:gsub("t(arget)", "T%1")
        local styleName = "SVUI_"..realName
        local frame
        if not self.Units[unit] then
            oUF_SuperVillain:RegisterStyle(styleName, CONSTRUCTORS[key])
            oUF_SuperVillain:SetActiveStyle(styleName)
            frame = oUF_SuperVillain:Spawn(unit, styleName)
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
        if self.db[key].enable then 
            frame:Enable()
            frame:Update() 
        else 
            frame:Disable()
        end
    end
end