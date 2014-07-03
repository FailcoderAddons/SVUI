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
local StealthFrame = CreateFrame("Frame");
StealthFrame:Hide();

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
BUILD FUNCTION
##########################################################
]]--
function MOD.Construct:party(frame)
	MOD:SetActionPanel(self)

	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)

	if self.isChild then 
		self.Health = MOD:CreateHealthBar(self, true)
		self.Name = MOD:CreateNameText(self, "party")
		self.originalParent = self:GetParent()
	else 
		self.Health = MOD:CreateHealthBar(self,true,true)
		self.Power = MOD:CreatePowerBar(self,true,false,'LEFT')
		self.Power.frequentUpdates = false;
		self.Name = MOD:CreateNameText(self, "party")
		MOD:CreatePortrait(self,true)
		self.Buffs = MOD:CreateBuffs(self)
		self.Debuffs = MOD:CreateDebuffs(self)
		self.AuraWatch = MOD:CreateAuraWatch(self)
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
		self:RegisterEvent('GROUP_ROSTER_UPDATE', UpdateTargetGlow)
	end 

	self.Range = { insideAlpha = 1, outsideAlpha = 1 }

	return self 
end 
--[[ 
########################################################## 
UPDATE
##########################################################
]]--
function MOD.HeaderUpdate:party(frame,db)
	frame.db = db;

	local group = frame:GetParent()
	group.db = db;

	if not group.positioned then 
		group:ClearAllPoints()
		group:Point("LEFT",SuperVillain.UIParent,"LEFT",40,0)

		SuperVillain:SetSVMovable(group, group:GetName()..'_MOVE', L['Party Frames'], nil, nil, nil, 'ALL,PARTY,ARENA');
		group.positioned = true;

		group:RegisterEvent("PLAYER_ENTERING_WORLD")
		group:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		group:SetScript("OnEvent", MOD.VisibilityUpdate.party)
	end 

	MOD.VisibilityUpdate.party(group)
end 

function MOD.VisibilityUpdate:party(event)
	if (not self.db or (self.db and not self.db.enable) or (MOD.db and not MOD.db.smartRaidFilter) or self.isForced) then return end 
	local instance, instanceType = IsInInstance()
	if(event == "PLAYER_REGEN_ENABLED") then 
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end 
	if(not InCombatLockdown()) then 
		if(instance and instanceType == "raid") then 
			UnregisterStateDriver(self,"visibility")
			self:Hide()
		elseif self.db.visibility then 
			RegisterStateDriver(self,"visibility", self.db.visibility)
		end 
	else 
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	end 
end 

function MOD.FrameUpdate:party(frame,db)
	frame.db = db;
	local OFFSET = SuperVillain:Scale(1);
	frame.colors = oUF_SuperVillain.colors;
	frame:RegisterForClicks(MOD.db.fastClickTarget and 'AnyDown' or 'AnyUp')
	if frame.isChild then 
		local altDB = db.petsGroup;
		if frame == _G[frame.originalParent:GetName()..'Target'] then 
			altDB = db.targetsGroup 
		end 
		if not frame.originalParent.childList then 
			frame.originalParent.childList = {}
		end 
		frame.originalParent.childList[frame] = true;
		if not InCombatLockdown()then 
			if altDB.enable then 
				frame:SetParent(frame.originalParent)
				frame:Size(altDB.width,altDB.height)
				frame:ClearAllPoints()
				SuperVillain:ReversePoint(frame, altDB.anchorPoint, frame.originalParent, altDB.xOffset, altDB.yOffset)
			else 
				frame:SetParent(StealthFrame)
			end 
		end 
		do 
			local health = frame.Health;
			health.Smooth = nil;
			health.frequentUpdates = nil;
			health.colorSmooth = nil;
			health.colorHealth = nil;
			health.colorClass = true;
			health.colorReaction = true;
			health:ClearAllPoints()
			health:Point("TOPRIGHT", frame, "TOPRIGHT", -OFFSET, -OFFSET)
			health:Point("BOTTOMLEFT", frame, "BOTTOMLEFT", OFFSET, OFFSET)
		end 
		do 
			local name=frame.Name;
			name:ClearAllPoints()
			name:SetPoint('CENTER', frame.Health, 'CENTER', 0, 0)
			frame:Tag(name, altDB.tags)
		end 
	else 
		if not InCombatLockdown()then frame:Size(db.width,db.height) end 
		MOD:RefreshUnitLayout(frame,"party")
		MOD:UpdateAuraWatch(frame)
	end 
	frame:EnableElement('ReadyCheck')
	frame:UpdateAllElements()
end 