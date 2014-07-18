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
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
local AURA_FONT = [[Interface\AddOns\SVUI\assets\fonts\Display.ttf]]
local AURA_FONTSIZE = 10
local AURA_OUTLINE = "OUTLINE"
local LML_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-LML]]
local ROLE_ICON_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-ROLES]]
local BUDDY_ICON = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-FRIENDSHIP]]

local ROLE_ICON_DATA = {
	["TANK"] = {0,0.5,0,0.5, 0.5,0.75,0.5,0.75},
	["HEALER"] = {0,0.5,0.5,1, 0.5,0.75,0.75,1},
	["DAMAGER"] = {0.5,1,0,0.5, 0.75,1,0.5,0.75}
}

local function BasicBG(frame)
	frame:SetBackdrop({
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
    frame:SetBackdropColor(0, 0, 0, 0)
    frame:SetBackdropBorderColor(0, 0, 0)
end
--[[ 
########################################################## 
RAID DEBUFFS / DEBUFF HIGHLIGHT
##########################################################
]]--
function MOD:CreateRaidDebuffs(frame)
	local raidDebuff = CreateFrame("Frame", nil, frame)
	raidDebuff:SetFixedPanelTemplate("Slot")
	raidDebuff.icon = raidDebuff:CreateTexture(nil, "OVERLAY")
	raidDebuff.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	raidDebuff.icon:FillInner(raidDebuff)
	raidDebuff.count = raidDebuff:CreateFontString(nil, "OVERLAY")
	raidDebuff.count:SetFontTemplate(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
	raidDebuff.count:SetPoint("BOTTOMRIGHT", 0, 2)
	raidDebuff.count:SetTextColor(1, .9, 0)
	raidDebuff.time = raidDebuff:CreateFontString(nil, "OVERLAY")
	raidDebuff.time:SetFontTemplate(AURA_FONT, AURA_FONTSIZE, AURA_OUTLINE)
	raidDebuff.time:SetPoint("CENTER")
	raidDebuff.time:SetTextColor(1, .9, 0)
	raidDebuff:SetParent(frame.InfoPanel)
	return raidDebuff
end 

function MOD:CreateAfflicted(frame)
	local holder = CreateFrame("Frame", nil, frame.Health)
	holder:SetFrameLevel(30)
	holder:SetAllPoints(frame.Health)
	local afflicted = holder:CreateTexture(nil, "OVERLAY", nil, 7)
	afflicted:FillInner(holder)
	afflicted:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Unitframe\\UNIT-AFFLICTED")
	afflicted:SetVertexColor(0, 0, 0, 0)
	afflicted:SetBlendMode("ADD")
	frame.AfflictedFilter = true
	frame.AfflictedAlpha = 0.75
	
	return afflicted
end
--[[ 
########################################################## 
VARIOUS ICONS
##########################################################
]]--
function MOD:CreateResurectionIcon(frame)
	local rez = frame.InfoPanel:CreateTexture(nil, "OVERLAY")
	rez:Point("CENTER", frame.InfoPanel.Health, "CENTER")
	rez:Size(30, 25)
	rez:SetDrawLayer("OVERLAY", 7)
	return rez 
end 

function MOD:CreateReadyCheckIcon(frame)
	local rdy = frame.InfoPanel:CreateTexture(nil, "OVERLAY", nil, 7)
	rdy:Size(12)
	rdy:Point("BOTTOM", frame.Health, "BOTTOM", 0, 2)
	return rdy 
end 

function MOD:CreateCombatant(frame)
	local pvp = CreateFrame("Frame", nil, frame)
	pvp:SetFrameLevel(pvp:GetFrameLevel() + 1)

	local trinket = CreateFrame("Frame", nil, pvp)
	BasicBG(trinket)
	trinket.Icon = trinket:CreateTexture(nil, "BORDER")
	trinket.Icon:FillInner(trinket, 2, 2)
	trinket.Icon:SetTexture([[Interface\Icons\INV_MISC_QUESTIONMARK]])
	trinket.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	trinket.Unavailable = trinket:CreateTexture(nil, "OVERLAY")
	trinket.Unavailable:SetAllPoints(trinket)
	trinket.Unavailable:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	trinket.Unavailable:SetTexture([[Interface\BUTTONS\UI-GroupLoot-Pass-Up]])
	trinket.Unavailable:Hide()

	trinket.CD = CreateFrame("Cooldown", nil, trinket)
	trinket.CD:SetAllPoints(trinket)

	pvp.Trinket = trinket

	local badge = CreateFrame("Frame", nil, pvp)
	BasicBG(badge)
	badge.Icon = badge:CreateTexture(nil, "OVERLAY")
	badge.Icon:FillInner(badge, 2, 2)
	badge.Icon:SetTexture([[Interface\Icons\INV_MISC_QUESTIONMARK]])
	badge.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	pvp.Badge = badge

	return pvp 
end

function MOD:CreateFriendshipBar(frame)
	local buddy = CreateFrame("StatusBar", nil, frame.Power)
    buddy:SetAllPoints(frame.Power)
    buddy:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
    buddy:SetStatusBarColor(1,0,0)
    local bg = buddy:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(buddy)
	bg:SetTexture(0.2,0,0)
	local icon = buddy:CreateTexture(nil, "OVERLAY")
	icon:SetPoint("LEFT", buddy, "LEFT", -11, 0)
	icon:SetSize(22,22)
	icon:SetTexture(BUDDY_ICON)

	return buddy 
end
--[[ 
########################################################## 
CONFIGURABLE ICONS
##########################################################
]]--
function MOD:CreateRaidIcon(frame)
	local rIcon = frame.InfoPanel:CreateTexture(nil, "OVERLAY", nil, 2)
	rIcon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	rIcon:Size(18)
	rIcon:Point("CENTER", frame.InfoPanel, "TOP", 0, 2)
	return rIcon 
end 

local UpdateRoleIcon = function(self)
	local key = self.___key
	local db = MOD.db[key]
	if(not db or not db.icons or (db.icons and not db.icons.roleIcon)) then return end 
	local lfd = self.LFDRole
	if(not db.icons.roleIcon.enable) then lfd:Hide() return end 
	local unitRole = UnitGroupRolesAssigned(self.unit)
	if(self.isForced and unitRole == "NONE") then 
		local rng = random(1, 3)
		unitRole = rng == 1 and "TANK" or rng == 2 and "HEALER" or rng == 3 and "DAMAGER" 
	end 
	if(unitRole ~= "NONE" and (self.isForced or UnitIsConnected(self.unit))) then
		local coords = ROLE_ICON_DATA[unitRole]
		lfd:SetTexture(ROLE_ICON_FILE)
		if(lfd:GetHeight() <= 13) then
			lfd:SetTexCoord(coords[5], coords[6], coords[7], coords[8])
		else
			lfd:SetTexCoord(coords[1], coords[2], coords[3], coords[4])
		end
		lfd:Show()
	else
		lfd:Hide()
	end 
end 

function MOD:CreateRoleIcon(frame)
	local parent = frame.InfoPanel or frame;
	local rIconHolder = CreateFrame("Frame", nil, parent)
	rIconHolder:SetAllPoints()
	local rIcon = rIconHolder:CreateTexture(nil, "ARTWORK", nil, 2)
	rIcon:Size(14)
	rIcon:Point("BOTTOMRIGHT", rIconHolder, "BOTTOMRIGHT")
	rIcon.Override = UpdateRoleIcon;
	frame:RegisterEvent("UNIT_CONNECTION", UpdateRoleIcon)
	return rIcon 
end 

function MOD:CreateRaidRoleFrames(frame)
	local parent = frame.InfoPanel or frame;
	local raidRoles = CreateFrame("Frame", nil, frame)
	raidRoles:Size(24, 12)
	raidRoles:Point("TOPLEFT", frame.ActionPanel, "TOPLEFT", -2, 4)
	raidRoles:SetFrameLevel(parent:GetFrameLevel() + 50)

	frame.Leader = raidRoles:CreateTexture(nil, "OVERLAY")
	frame.Leader:Size(12, 12)
	frame.Leader:SetTexture(LML_ICON_FILE)
	frame.Leader:SetTexCoord(0, 0.5, 0, 0.5)
	frame.Leader:SetVertexColor(1, 0.85, 0)
	frame.Leader:Point("LEFT")

	frame.MasterLooter = raidRoles:CreateTexture(nil, "OVERLAY")
	frame.MasterLooter:Size(12, 12)
	frame.MasterLooter:SetTexture(LML_ICON_FILE)
	frame.MasterLooter:SetTexCoord(0.5, 1, 0, 0.5)
	frame.MasterLooter:SetVertexColor(1, 0.6, 0)
	frame.MasterLooter:Point("RIGHT")

	frame.Leader.PostUpdate = MOD.RaidRoleUpdate;
	frame.MasterLooter.PostUpdate = MOD.RaidRoleUpdate;
	return raidRoles 
end 

function MOD:RaidRoleUpdate()
	local frame = self:GetParent()
	local leaderIcon = frame.Leader;
	local looterIcon = frame.MasterLooter;
	if not leaderIcon or not looterIcon then return end 
		local key = frame.___key;
		local db = MOD.db[key];
		local leaderShown = leaderIcon:IsShown()
		local looterShown = looterIcon:IsShown()
		leaderIcon:ClearAllPoints()
		looterIcon:ClearAllPoints()
		if db and db.icons and db.icons.raidRoleIcons then
			local settings = db.icons.raidRoleIcons
			if leaderShown and settings.position == "TOPLEFT"then 
				leaderIcon:Point("LEFT", frame, "LEFT")
				looterIcon:Point("RIGHT", frame, "RIGHT")
			elseif leaderShown and settings.position == "TOPRIGHT" then 
				leaderIcon:Point("RIGHT", frame, "RIGHT")
				looterIcon:Point("LEFT", frame, "LEFT")
			elseif looterShown and settings.position == "TOPLEFT" then 
				looterIcon:Point("LEFT", frame, "LEFT")
			else 
			looterIcon:Point("RIGHT", frame, "RIGHT")
		end 
	end 
end 