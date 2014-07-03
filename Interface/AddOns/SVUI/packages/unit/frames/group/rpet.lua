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
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.")
local ceil,tinsert = math.ceil,table.insert

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

local RaidPets_OnEvent = function(self, event)
	if not self.db or (self.db and not self.db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced then return; end
	local inInstance, instanceType = IsInInstance()
	local _, _, _, _, maxPlayers, _, _ = GetInstanceInfo()
	if event == "PLAYER_REGEN_ENABLED" then self:UnregisterEvent("PLAYER_REGEN_ENABLED") end
	
	if not InCombatLockdown() then
		if inInstance and instanceType == "raid" then
			UnregisterStateDriver(self, "visibility")
			self:Show()
		elseif self.db.visibility then
			RegisterStateDriver(self, "visibility", self.db.visibility)
		end
	else
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
end 
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD.Construct:raidpet(frame)
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	MOD:SetActionPanel(self)
	self.Health = MOD:CreateHealthBar(self, true, true)
	self.Name = MOD:CreateNameText(self, "raidpet")
	self.Buffs = MOD:CreateBuffs(self)
	self.Debuffs = MOD:CreateDebuffs(self)
	self.AuraWatch = MOD:CreateAuraWatch(self)
	self.RaidDebuffs = MOD:CreateRaidDebuffs(self)
	self.Afflicted = MOD:CreateAfflicted(self)
	self.RaidIcon = MOD:CreateRaidIcon(self)
	self.HealPrediction = MOD:CreateHealPrediction(self)
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
UPDATE
##########################################################
]]--
function MOD.VisibilityUpdate:raidpet(arg)
	if (not MOD.db or (MOD.db and not SuperVillain.db.SVUnit.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end 
	local instance, group = IsInInstance()
	if arg == "PLAYER_REGEN_ENABLED"then 
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end 
	if not InCombatLockdown()then 
		if instance and group == "raid" then 
			UnregisterStateDriver(self, "visibility")
			self:Hide()
		elseif MOD.db.visibility then 
			RegisterStateDriver(self, "visibility", MOD.db.visibility)
		end 
	else 
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end
end 

function MOD.HeaderUpdate:raidpet(frame, db)
	frame.db = db;
	local raidPets = frame:GetParent()
	raidPets.db = db;
	if not raidPets.positioned then 
		raidPets:ClearAllPoints()
		raidPets:Point("BOTTOMLEFT", SuperVillain.UIParent, "BOTTOMLEFT", 4, 433)
		SuperVillain:SetSVMovable(raidPets, raidPets:GetName().."_MOVE", L["Raid Pet Frames"], nil, nil, nil, "ALL, RAID10, RAID25, RAID40")
		raidPets.positioned = true;
		raidPets:RegisterEvent("PLAYER_ENTERING_WORLD")
		raidPets:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		raidPets:SetScript("OnEvent", RaidPets_OnEvent)
	end 
	RaidPets_OnEvent(raidPets)
end 

function MOD.FrameUpdate:raidpet(frame, db)
	frame.db = db;
    frame.colors = oUF_SuperVillain.colors;
    frame:RegisterForClicks(MOD.db.fastClickTarget and"AnyDown"or"AnyUp")
    if not InCombatLockdown()then frame:Size(db.width, db.height)end 
    MOD:RefreshUnitLayout(frame, "raidpet")
    do
      local rdBuffs = frame.RaidDebuffs;
      if db.rdebuffs.enable then 
        frame:EnableElement("RaidDebuffs")
        rdBuffs:Size(db.rdebuffs.size)
        rdBuffs:Point("CENTER", frame, "CENTER", db.rdebuffs.xOffset, db.rdebuffs.yOffset)
        rdBuffs.count:SetFontTemplate(nil, db.rdebuffs.fontSize, "OUTLINE")
        rdBuffs.time:SetFontTemplate(nil, db.rdebuffs.fontSize, "OUTLINE")
      else 
        frame:DisableElement("RaidDebuffs")
        rdBuffs:Hide()
      end 
    end 
	MOD:UpdateAuraWatch(frame, true)
	frame:UpdateAllElements()
end 