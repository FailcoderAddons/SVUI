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
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local ceil,tinsert = math.ceil,table.insert
--[[ 
########################################################## 
LOCAL DATA
##########################################################
]]--
local CONSTRUCTORS, UPDATERS = {}, {}
local _POINTMAP = {
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

local _GSORT = {
    ['CLASS']=function(self)
        self:SetAttribute("groupingOrder","DEATHKNIGHT,DRUID,HUNTER,MAGE,PALADIN,PRIEST,SHAMAN,WARLOCK,WARRIOR,MONK")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'CLASS')
    end,
    ['MTMA']=function(self)
        self:SetAttribute("groupingOrder","MAINTANK,MAINASSIST,NONE")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'ROLE')
    end,
    ['ROLE']=function(self)
        self:SetAttribute("groupingOrder","TANK,HEALER,DAMAGER,NONE")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'ASSIGNEDROLE')
    end,
    ['ROLE_TDH']=function(self)
        self:SetAttribute("groupingOrder","TANK,DAMAGER,HEALER,NONE")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'ASSIGNEDROLE')
    end,
    ['ROLE_HTD']=function(self)
        self:SetAttribute("groupingOrder","HEALER,TANK,DAMAGER,NONE")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'ASSIGNEDROLE')
    end,
    ['ROLE_HDT']=function(self)
        self:SetAttribute("groupingOrder","HEALER,DAMAGER,TANK,NONE")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",'ASSIGNEDROLE')
    end,
    ['NAME']=function(self)
        self:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",nil)
    end,
    ['GROUP']=function(self)
        self:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        self:SetAttribute('sortMethod','INDEX')
        self:SetAttribute("sortMethod",'GROUP')
    end,
    ['PETNAME']=function(self)
        self:SetAttribute("groupingOrder","1,2,3,4,5,6,7,8")
        self:SetAttribute('sortMethod','NAME')
        self:SetAttribute("sortMethod",nil)
        self:SetAttribute("filterOnPet",true)
    end
}
--[[ 
########################################################## 
ALL UNIT HELPERS
##########################################################
]]--
local GroupMediaUpdate = function(self, updateElements)
    local key = self.___key
    local index = 1;
    local childFrame = self:GetAttribute("child"..index)
    while childFrame do 
        MOD.RefreshUnitMedia(childFrame, key, updateElements)
        if(_G[childFrame:GetName().."Pet"]) then 
            MOD.RefreshUnitMedia(_G[childFrame:GetName().."Pet"], key, updateElements)
        end
        if(_G[childFrame:GetName().."Target"]) then 
            MOD.RefreshUnitMedia(_G[childFrame:GetName().."Target"], key, updateElements)
        end
        index = index + 1;
        childFrame = self:GetAttribute("child"..index)
    end
end

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
    if event == "PLAYER_REGEN_ENABLED"then 
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
    end 
    if not InCombatLockdown()then 
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
    self.colors = oUF_SuperVillain.colors;
    self:RegisterForClicks(MOD.db.fastClickTarget and "AnyDown" or "AnyUp")
    if not InCombatLockdown() then self:Size(db.width, db.height) end 
    do
        local rdBuffs = self.RaidDebuffs;
        if db.rdebuffs.enable then 
            self:EnableElement("RaidDebuffs")
            rdBuffs:Size(db.rdebuffs.size)
            rdBuffs:Point("CENTER", self, "CENTER", db.rdebuffs.xOffset, db.rdebuffs.yOffset)
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

local Raid10Update = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SuperVillain.UIParent, "LEFT", 4, 0)
        SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Raid 10 Frames"], nil, nil, nil, "ALL, RAID"..10)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        frame:SetScript("OnEvent", Raid10Visibility)
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
UPDATERS["raid10"] = Raid10Update

local Raid25Update = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SuperVillain.UIParent, "LEFT", 4, 0)
        SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Raid 25 Frames"], nil, nil, nil, "ALL, RAID"..25)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        frame:SetScript("OnEvent", Raid25Visibility)
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
UPDATERS["raid25"] = Raid25Update

local Raid40Update = function(self)
    local frame = self:GetParent()
    if not frame.positioned then 
        frame:ClearAllPoints()
        frame:Point("LEFT", SuperVillain.UIParent, "LEFT", 4, 0)
        SuperVillain:SetSVMovable(frame, frame:GetName().."_MOVE", L["Raid 40 Frames"], nil, nil, nil, "ALL, RAID"..40)
        frame:RegisterEvent("PLAYER_ENTERING_WORLD")
        frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        frame:SetScript("OnEvent", Raid40Visibility)
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
UPDATERS["raid40"] = Raid40Update

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
        edgeSize = SuperVillain:Scale(3), 
        insets = {
            left = SuperVillain:Scale(5), 
            right = SuperVillain:Scale(5), 
            top = SuperVillain:Scale(5), 
            bottom = SuperVillain:Scale(5)
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

local UpdateRaidPetFrame = function(self)
    local raidPets = self:GetParent()
    if not raidPets.positioned then 
        raidPets:ClearAllPoints()
        raidPets:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 4, 433)
        SuperVillain:SetSVMovable(raidPets, raidPets:GetName().."_MOVE", L["Raid Pet Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
        raidPets.positioned = true;
        raidPets:RegisterEvent("PLAYER_ENTERING_WORLD")
        raidPets:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        raidPets:SetScript("OnEvent", RaidPetVisibility)
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
UPDATERS["raidpet"] = UpdateRaidPetFrame

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
        edgeSize = SuperVillain:Scale(3), 
        insets = {
            left = SuperVillain:Scale(5), 
            right = SuperVillain:Scale(5), 
            top = SuperVillain:Scale(5), 
            bottom = SuperVillain:Scale(5)
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
    self.colors = oUF_SuperVillain.colors;
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
                self:SetParent(self.originalParent)
                self:Size(altDB.width,altDB.height)
                self:ClearAllPoints()
                SuperVillain:ReversePoint(self, altDB.anchorPoint, self.originalParent, altDB.xOffset, altDB.yOffset)
            else 
                self:SetParent(SuperVillain.Cloaked)
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
            self:Size(db.width,db.height) 
        end 
        MOD:RefreshUnitLayout(self, key)
        MOD:UpdateAuraWatch(self, key)
    end 
    self:EnableElement('ReadyCheck')
    self:UpdateAllElements()
end

local UpdatePartyFrame = function(self)
    local group = self:GetParent()
    if not group.positioned then 
        group:ClearAllPoints()
        group:Point("LEFT",SuperVillain.UIParent,"LEFT",40,0)
        SuperVillain:SetSVMovable(group, group:GetName()..'_MOVE', L['Party Frames'], nil, nil, nil, 'ALL,PARTY,ARENA');
        group.positioned = true;
        group:RegisterEvent("PLAYER_ENTERING_WORLD")
        group:RegisterEvent("ZONE_CHANGED_NEW_AREA")
        group:SetScript("OnEvent", PartyVisibility)
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
UPDATERS["party"] = UpdatePartyFrame

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

        local shadow = CreateFrame("Frame", nil, self)
        shadow:SetFrameLevel(1)
        shadow:SetFrameStrata(self:GetFrameStrata())
        shadow:WrapOuter(self, 3, 3)
        shadow:SetBackdrop({
            edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
            edgeSize = SuperVillain:Scale(3), 
            insets = {
                left = SuperVillain:Scale(5), 
                right = SuperVillain:Scale(5), 
                top = SuperVillain:Scale(5), 
                bottom = SuperVillain:Scale(5)
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
    self.colors = oUF_SuperVillain.colors;
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
                self:SetParent(self.originalParent)
                self:Size(targets.width, targets.height)
                self:ClearAllPoints()
                SuperVillain:ReversePoint(self, targets.anchorPoint, self.originalParent, targets.xOffset, targets.yOffset)
            else 
                self:SetParent(SuperVillain.Cloaked)
            end 
        end 
    elseif not InCombatLockdown()then 
        self:Size(db.width, db.height)
    end 
    MOD:RefreshUnitLayout(self, key)
    do 
        local nametext = self.InfoPanel.Name;
        if oUF_SuperVillain.colors.healthclass then 
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
        self:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", 4, -40)
        SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Tank Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
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
UPDATERS["tank"] = UpdateTankFrame

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
    self.colors = oUF_SuperVillain.colors;
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
                self:SetParent(self.originalParent)
                self:Size(targets.width, targets.height)
                self:ClearAllPoints()
                SuperVillain:ReversePoint(self, targets.anchorPoint, self.originalParent, targets.xOffset, targets.yOffset)
            else 
                self:SetParent(SuperVillain.Cloaked)
            end 
        end 
    elseif not InCombatLockdown()then
        self:Size(db.width, db.height)
    end 

    MOD:RefreshUnitLayout(self, key)

    do 
        local nametext = self.InfoPanel.Name;
        if oUF_SuperVillain.colors.healthclass then 
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
        self:Point("TOPLEFT", SuperVillain.UIParent, "TOPLEFT", 4, -140)
        SuperVillain:SetSVMovable(self, self:GetName().."_MOVE", L["Assist Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
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
UPDATERS["assist"] = UpdateAssistFrame

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

local function ConstructGroupHeader(parentFrame, filter, styleName, headerName, template1, groupName, template2)
    local db = MOD.db[groupName]
    oUF_SuperVillain:SetActiveStyle(styleName)
    local groupHeader = oUF_SuperVillain:SpawnHeader(headerName, template2, nil, 
        "oUF-initialConfigFunction", ("self:SetWidth(%d); self:SetHeight(%d); self:SetFrameLevel(5)"):format(db.width, db.height), 
        "groupFilter", filter, 
        "showParty", true, 
        "showRaid", true, 
        "showSolo", true, 
        template1 and "template", template1
    )
    groupHeader.___groupkey = groupName
    groupHeader:SetParent(parentFrame)
    groupHeader:Show()

    groupHeader.Update = UPDATERS[groupName]
    groupHeader.MediaUpdate = GroupMediaUpdate
    groupHeader.ClearAllAttributes = SecureHeaderClear 

    return groupHeader 
end
--[[ 
########################################################## 
GROUP HEADER METHODS
##########################################################
]]--
local GroupSetConfigEnvironment = function(self)
    local key = self.___groupkey
    local db = MOD.db[key]
    local anchorPoint;
    local widthCalc, heightCalc, xCalc, yCalc = 0, 0, 0, 0;
    local sorting = db.showBy;
    local pointMap = _POINTMAP[sorting]
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
                _GSORT[db.sortMethod](frame)
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
                heightCalc = heightCalc + db.height + db.wrapYOffset;
                yCalc = yCalc + 1 
            else 
                if frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
                end
                widthCalc = widthCalc + db.width + db.wrapXOffset;
                xCalc = xCalc + 1 
            end 
        else 
            if isHorizontal then 
                if yCalc == 1 then 
                    if frame then 
                        frame:SetPoint(anchorPoint, self, anchorPoint, widthCalc * horizontal, 0)
                    end
                    widthCalc = widthCalc + (db.width + db.wrapXOffset) * 5;
                    xCalc = xCalc + 1 
                elseif frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, (((db.width + db.wrapXOffset) * 5) * ((i - 1) % db.gRowCol)) * horizontal, ((db.height + db.wrapYOffset) * (yCalc - 1)) * vertical)
                end 
            else 
                if xCalc == 1 then 
                    if frame then 
                        frame:SetPoint(anchorPoint, self, anchorPoint, 0, heightCalc * vertical)
                    end
                    heightCalc = heightCalc + (db.height + db.wrapYOffset) * 5;
                    yCalc = yCalc + 1 
                elseif frame then 
                    frame:SetPoint(anchorPoint, self, anchorPoint, ((db.width + db.wrapXOffset) * (xCalc - 1)) * horizontal, (((db.height + db.wrapYOffset) * 5) * ((i - 1) % db.gRowCol)) * vertical)
                end 
            end 
        end
        if heightCalc == 0 then 
            heightCalc = heightCalc + (db.height + db.wrapYOffset) * 5 
        elseif widthCalc == 0 then 
            widthCalc = widthCalc + (db.width + db.wrapXOffset) * 5 
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
LOAD/UPDATE METHOD
##########################################################
]]--
function MOD:SetGroupFrame(key, filter, template1, forceUpdate, template2)
    if not self.db[key] then return end
    local db = self.db[key]
    local realName = key:gsub("(.)", upper, 1)
    local styleName = "SVUI_"..realName
    local frame, groupName
    if(not self.Headers[key]) then 
        oUF_SuperVillain:RegisterStyle(styleName, CONSTRUCTORS[key])
        oUF_SuperVillain:SetActiveStyle(styleName)

        if(key == "tank" or key == "assist") then
            frame = ConstructGroupHeader(SVUI_UnitFrameParent, filter, styleName, styleName, template1, key, template2)
        else
            frame = CreateFrame("Frame", styleName, SVUI_UnitFrameParent, "SecureHandlerStateTemplate")
            frame.groups = {}
            frame.___groupkey = key;
            frame.Update = GroupHeaderUpdate
            frame.MediaUpdate = GroupMediaUpdate
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
                frame.groups[1] = ConstructGroupHeader(frame, 1, styleName, groupName, template1, key, template2)
            end 
        else
            for i = 1, db.groupCount do
                if(not frame.groups[i]) then
                    groupName = styleName .. "Group" .. i
                    frame.groups[i] = ConstructGroupHeader(frame, i, styleName, groupName, template1, key, template2)
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