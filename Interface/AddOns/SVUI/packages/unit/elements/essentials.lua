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
--STRING
local string        = _G.string;
local upper         = string.upper;
local format        = string.format;
local find          = string.find;
local match         = string.match;
local gsub          = string.gsub;
--MATH
local math          = _G.math;
local random        = math.random;
local floor         = math.floor
local ceil         	= math.ceil
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local oUF_Villain = SV.oUF

assert(oUF_Villain, "SVUI was unable to locate oUF.");

local L = SV.L;
local LSM = LibStub("LibSharedMedia-3.0")
local MOD = SV.SVUnit

if(not MOD) then return end 
--[[ 
########################################################## 
LOCALS
##########################################################
]]--
-- local MISSING_MODEL_FILE = [[Spells\Blackmagic_precast_base.m2]];
-- local MISSING_MODEL_FILE = [[Spells\Crow_baked.m2]];
-- local MISSING_MODEL_FILE = [[Spells\monsterlure01.m2]];
-- local MISSING_MODEL_FILE = [[interface\buttons\talktome_gears.m2]];
-- local MISSING_MODEL_FILE = [[creature\Ghostlyskullpet\ghostlyskullpet.m2]];
-- local MISSING_MODEL_FILE = [[creature\ghost\ghost.m2]];
-- local MISSING_MODEL_FILE = [[Spells\Monk_travelingmist_missile.m2]];
local HEALTH_ANIM_FILE = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-HEALTH-ANIMATION]];
local ELITE_TOP = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-TOP]]
local ELITE_BOTTOM = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-BOTTOM]]
local ELITE_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-RIGHT]]
local STUNNED_ANIM = [[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-STUNNED]]
local borderTex = [[Interface\Addons\SVUI\assets\artwork\Template\ROUND]]
local token = {[0] = "MANA", [1] = "RAGE", [2] = "FOCUS", [3] = "ENERGY", [6] = "RUNIC_POWER"}

local Anim_OnUpdate = function(self)
	local parent = self.parent
	local coord = self._coords;
	parent:SetTexCoord(coord[1],coord[2],coord[3],coord[4])
end 

local Anim_OnPlay = function(self)
	local parent = self.parent
	parent:SetAlpha(1)
	if not parent:IsShown() then
		parent:Show()
	end
end 

local Anim_OnStop = function(self)
	local parent = self.parent
	parent:SetAlpha(0)
	if parent:IsShown() then
		parent:Hide()
	end
end 

local function SetNewAnimation(frame, animType, parent)
	local anim = frame:CreateAnimation(animType)
	anim.parent = parent
	return anim
end

local function SetAnim(frame, parent)
	local speed = 0.08
	frame.anim = frame:CreateAnimationGroup("Sprite")
	frame.anim.parent = parent;
	frame.anim:SetScript("OnPlay", Anim_OnPlay)
	frame.anim:SetScript("OnFinished", Anim_OnStop)
	frame.anim:SetScript("OnStop", Anim_OnStop)

	frame.anim[1] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[1]:SetOrder(1)
	frame.anim[1]:SetDuration(speed)
	frame.anim[1]._coords = {0,0.5,0,0.25}
	frame.anim[1]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim[2] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[2]:SetOrder(2)
	frame.anim[2]:SetDuration(speed)
	frame.anim[2]._coords = {0.5,1,0,0.25}
	frame.anim[2]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim[3] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[3]:SetOrder(3)
	frame.anim[3]:SetDuration(speed)
	frame.anim[3]._coords = {0,0.5,0.25,0.5}
	frame.anim[3]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[4] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[4]:SetOrder(4)
	frame.anim[4]:SetDuration(speed)
	frame.anim[4]._coords = {0.5,1,0.25,0.5}
	frame.anim[4]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[5] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[5]:SetOrder(5)
	frame.anim[5]:SetDuration(speed)
	frame.anim[5]._coords = {0,0.5,0.5,0.75}
	frame.anim[5]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[6] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[6]:SetOrder(6)
	frame.anim[6]:SetDuration(speed)
	frame.anim[6]._coords = {0.5,1,0.5,0.75}
	frame.anim[6]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[7] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[7]:SetOrder(7)
	frame.anim[7]:SetDuration(speed)
	frame.anim[7]._coords = {0,0.5,0.75,1}
	frame.anim[7]:SetScript("OnUpdate", Anim_OnUpdate)
	
	frame.anim[8] = SetNewAnimation(frame.anim, "Translation", frame)
	frame.anim[8]:SetOrder(8)
	frame.anim[8]:SetDuration(speed)
	frame.anim[8]._coords = {0.5,1,0.75,1}
	frame.anim[8]:SetScript("OnUpdate", Anim_OnUpdate)

	frame.anim:SetLooping("REPEAT")
end
--[[ 
########################################################## 
ACTIONPANEL
##########################################################
]]--
local UpdateThreat = function(self, event, unit)
	if(unit ~= self.unit) or not unit or not IsLoggedIn() then return end
	local threat = self.Threat
	local status = UnitThreatSituation(unit)
	local r, g, b
	if(status and status > 0) then
		r, g, b = GetThreatStatusColor(status)
		
		threat:SetBackdropBorderColor(r, g, b)
	else
		threat:SetBackdropBorderColor(0, 0, 0, 0.5)
	end
end

local UpdatePlayerThreat = function(self, event, unit)
	if(unit ~= "player") then return end
	local threat = self.Threat
	local status = UnitThreatSituation(unit)
	local r, g, b
	if(status and status > 0) then
		r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b)
		if(status > 1) then
			threat.OhShit:Show()
			threat.OhShit.anim:Play()
		end
	else
		threat:SetBackdropBorderColor(0, 0, 0, 0.5)
		threat.OhShit:Hide()
	end 
end

local OhShit_OnShow = function(self)
	if not self.anim:IsPlaying() then self.anim:Play() end 
end

local function CreateThreat(frame, unit)
	local threat = CreateFrame('Frame', nil, frame)
    threat:Point('TOPLEFT', frame, 'TOPLEFT', -3, 3)
    threat:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 3, -3)
    threat:SetBackdrop({
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]],
        edgeSize = 3,
        insets = {
            left = 2,
            right = 2,
            top = 2,
            bottom = 2
        }
    });
    threat:SetBackdropBorderColor(0,0,0,0.5)

	if(unit == "player") then
		local aggro = CreateFrame("Frame", "SVUI_PlayerThreatAlert", threat)
		aggro:SetFrameStrata("HIGH")
		aggro:SetFrameLevel(30)
		aggro:Size(52,52)
		aggro:SetPoint("TOPRIGHT",frame,"TOPRIGHT",16,16)
		aggro.bg = aggro:CreateTexture(nil, "BORDER")
		aggro.bg:FillInner(aggro)
		aggro.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\UNIT-AGGRO")
		SV.Animate:Pulse(aggro, false)
		--aggro:SetScript("OnShow", OhShit_OnShow)
		
		threat.OhShit = aggro
		threat.Override = UpdatePlayerThreat
	else
		threat.Override = UpdateThreat
	end

	return threat 
end

local function CreateActionPanel(frame, offset)
    if(frame.ActionPanel) then return; end
    offset = offset or 2

    local panel = CreateFrame('Frame', nil, frame)
    panel:Point('TOPLEFT', frame, 'TOPLEFT', -1, 1)
    panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', 1, -1)

    --[[ UNDERLAY BORDER ]]--
    local borderLeft = panel:CreateTexture(nil, "BORDER")
    borderLeft:SetTexture(0, 0, 0)
    borderLeft:SetPoint("TOPLEFT")
    borderLeft:SetPoint("BOTTOMLEFT")
    borderLeft:SetWidth(offset)

    local borderRight = panel:CreateTexture(nil, "BORDER")
    borderRight:SetTexture(0, 0, 0)
    borderRight:SetPoint("TOPRIGHT")
    borderRight:SetPoint("BOTTOMRIGHT")
    borderRight:SetWidth(offset)

    local borderTop = panel:CreateTexture(nil, "BORDER")
    borderTop:SetTexture(0, 0, 0)
    borderTop:SetPoint("TOPLEFT")
    borderTop:SetPoint("TOPRIGHT")
    borderTop:SetHeight(offset)

    local borderBottom = panel:CreateTexture(nil, "BORDER")
    borderBottom:SetTexture(0, 0, 0)
    borderBottom:SetPoint("BOTTOMLEFT")
    borderBottom:SetPoint("BOTTOMRIGHT")
    borderBottom:SetHeight(offset)

    --[[ OVERLAY BORDER ]]--
    panel.border = {}
	panel.border[1] = panel:CreateTexture(nil, "OVERLAY")
	panel.border[1]:SetTexture(0, 0, 0)
	panel.border[1]:SetPoint("TOPLEFT")
	panel.border[1]:SetPoint("TOPRIGHT")
	panel.border[1]:SetHeight(2)

	panel.border[2] = panel:CreateTexture(nil, "OVERLAY")
	panel.border[2]:SetTexture(0, 0, 0)
	panel.border[2]:SetPoint("BOTTOMLEFT")
	panel.border[2]:SetPoint("BOTTOMRIGHT")
	panel.border[2]:SetHeight(2)

	panel.border[3] = panel:CreateTexture(nil, "OVERLAY")
	panel.border[3]:SetTexture(0, 0, 0)
	panel.border[3]:SetPoint("TOPRIGHT")
	panel.border[3]:SetPoint("BOTTOMRIGHT")
	panel.border[3]:SetWidth(2)

	panel.border[4] = panel:CreateTexture(nil, "OVERLAY")
	panel.border[4]:SetTexture(0, 0, 0)
	panel.border[4]:SetPoint("TOPLEFT")
	panel.border[4]:SetPoint("BOTTOMLEFT")
	panel.border[4]:SetWidth(2)

    panel:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
        tile = false, 
        tileSize = 0, 
        edgeSize = 1, 
        insets = 
        {
            left = 0, 
            right = 0, 
            top = 0, 
            bottom = 0, 
        }, 
    })
    panel:SetBackdropColor(0,0,0)
    panel:SetBackdropBorderColor(0,0,0)

    panel:SetFrameStrata("BACKGROUND")
    panel:SetFrameLevel(0)
    return panel
end

local function CreateNameText(frame, unitName)
	local db = SV.db.SVUnit
	if(SV.db.SVUnit[unitName] and SV.db.SVUnit[unitName].name) then
		db = SV.db.SVUnit[unitName].name
	end
	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetFont(LSM:Fetch("font", db.font), db.fontSize, db.fontOutline)
	name:SetShadowOffset(2, -2)
	name:SetShadowColor(0, 0, 0, 1)
	if unitName == "target" then
		name:SetPoint("RIGHT", frame)
		name:SetJustifyH("RIGHT")
    	name:SetJustifyV("MIDDLE")
	else
		name:SetPoint("CENTER", frame)
		name:SetJustifyH("CENTER")
    	name:SetJustifyV("MIDDLE")
	end
	return name;
end

function MOD:SetActionPanel(frame, unit, noHealthText, noPowerText, noMiscText)
	if(unit and (unit == "target" or unit == "player")) then
		frame.ActionPanel = CreateActionPanel(frame, 3)

		local info = CreateFrame("Frame", nil, frame)
		info:SetFrameStrata("BACKGROUND")
		info:SetFrameLevel(0)
		info:Point("TOPLEFT", frame.ActionPanel, "BOTTOMLEFT", -1, 1)
		info:Point("TOPRIGHT", frame.ActionPanel, "BOTTOMRIGHT", 1, 1)
		info:SetHeight(30)

		local bg = info:CreateTexture(nil, "BACKGROUND")
		bg:FillInner(info)
		bg:SetTexture(1, 1, 1, 1)
		bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.7)

		frame.InfoPanel = CreateFrame("Frame", nil, info)
		frame.InfoPanel:SetFrameStrata("LOW")
		frame.InfoPanel:SetFrameLevel(20)
		frame.InfoPanel:SetAllPoints(info)

		if(unit == "target") then
			frame.ActionPanel:SetFrameLevel(1)
			frame.ActionPanel.special = CreateFrame("Frame", nil, frame.ActionPanel)
			frame.ActionPanel.special:SetAllPoints(frame)
			frame.ActionPanel.special:SetFrameStrata("BACKGROUND")
			frame.ActionPanel.special:SetFrameLevel(0)
			frame.ActionPanel.special[1] = frame.ActionPanel.special:CreateTexture(nil, "OVERLAY", nil, 1)
			frame.ActionPanel.special[1]:SetPoint("BOTTOMLEFT", frame.ActionPanel.special, "TOPLEFT", 0, 0)
			frame.ActionPanel.special[1]:SetPoint("BOTTOMRIGHT", frame.ActionPanel.special, "TOPRIGHT", 0, 0)
			frame.ActionPanel.special[1]:SetHeight(frame.ActionPanel:GetWidth() * 0.15)
			frame.ActionPanel.special[1]:SetTexture(ELITE_TOP)
			frame.ActionPanel.special[1]:SetVertexColor(1, 0.75, 0)
			frame.ActionPanel.special[1]:SetBlendMode("BLEND")
			frame.ActionPanel.special[2] = frame.ActionPanel.special:CreateTexture(nil, "OVERLAY", nil, 1)
			frame.ActionPanel.special[2]:SetPoint("TOPLEFT", frame.ActionPanel.special, "BOTTOMLEFT", 0, 0)
			frame.ActionPanel.special[2]:SetPoint("TOPRIGHT", frame.ActionPanel.special, "BOTTOMRIGHT", 0, 0)
			frame.ActionPanel.special[2]:SetHeight(frame.ActionPanel:GetWidth() * 0.15)
			frame.ActionPanel.special[2]:SetTexture(ELITE_BOTTOM)
			frame.ActionPanel.special[2]:SetVertexColor(1, 0.75, 0)
			frame.ActionPanel.special[2]:SetBlendMode("BLEND")
			frame.ActionPanel.special[3] = frame.ActionPanel.special:CreateTexture(nil, "OVERLAY", nil, 1)
			frame.ActionPanel.special[3]:SetPoint("TOPLEFT", frame.ActionPanel.special, "TOPRIGHT", 0, 0)
			frame.ActionPanel.special[3]:SetPoint("BOTTOMLEFT", frame.ActionPanel.special, "BOTTOMRIGHT", 0, 0)
			frame.ActionPanel.special[3]:SetWidth(frame.ActionPanel:GetHeight() * 2.25)
			frame.ActionPanel.special[3]:SetTexture(ELITE_RIGHT)
			frame.ActionPanel.special[3]:SetVertexColor(1, 0.75, 0)
			frame.ActionPanel.special[3]:SetBlendMode("BLEND")
			frame.ActionPanel.special:SetAlpha(0.7)
			frame.ActionPanel.special:Hide()

			frame.ActionPanel.class = CreateFrame("Frame", nil, frame.InfoPanel)
			frame.ActionPanel.class:Size(18)
			frame.ActionPanel.class:Point("TOPLEFT", frame.ActionPanel, "TOPLEFT", 2, -2)
			frame.ActionPanel.class:SetPanelTemplate("Default", true, 2, 0, 0)

			frame.ActionPanel.class.texture = frame.ActionPanel.class.Panel:CreateTexture(nil, "BORDER")
			frame.ActionPanel.class.texture:SetAllPoints(frame.ActionPanel.class.Panel)
			frame.ActionPanel.class.texture:SetTexture([[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]])

			local border1 = frame.ActionPanel.class:CreateTexture(nil, "OVERLAY")
			border1:SetTexture(0, 0, 0)
			border1:SetPoint("TOPLEFT")
			border1:SetPoint("TOPRIGHT")
			border1:SetHeight(2)

			local border2 = frame.ActionPanel.class:CreateTexture(nil, "OVERLAY")
			border2:SetTexture(0, 0, 0)
			border2:SetPoint("BOTTOMLEFT")
			border2:SetPoint("BOTTOMRIGHT")
			border2:SetHeight(2)

			local border3 = frame.ActionPanel.class:CreateTexture(nil, "OVERLAY")
			border3:SetTexture(0, 0, 0)
			border3:SetPoint("TOPRIGHT")
			border3:SetPoint("BOTTOMRIGHT")
			border3:SetWidth(2)

			local border4 = frame.ActionPanel.class:CreateTexture(nil, "OVERLAY")
			border4:SetTexture(0, 0, 0)
			border4:SetPoint("TOPLEFT")
			border4:SetPoint("BOTTOMLEFT")
			border4:SetWidth(2)
		else
			frame.LossOfControl = CreateFrame("Frame", nil, frame.InfoPanel)
			frame.LossOfControl:SetAllPoints(frame)
			frame.LossOfControl:SetFrameStrata("DIALOG")
			frame.LossOfControl:SetFrameLevel(99)

			local stunned = frame.LossOfControl:CreateTexture(nil, "OVERLAY", nil, 1)
			stunned:SetPoint("CENTER", frame, "CENTER", 0, 0)
			stunned:SetSize(96, 96)
			stunned:SetTexture(STUNNED_ANIM)
			stunned:SetBlendMode("ADD")
			SV.Animate:Sprite(stunned, 0.12, false, true)
			stunned:Hide()
			frame.LossOfControl.stunned = stunned

			LossOfControlFrame:HookScript("OnShow", function()
				if(_G["SVUI_Player"] and _G["SVUI_Player"].LossOfControl) then
					_G["SVUI_Player"].LossOfControl:Show()
				end
			end)
			LossOfControlFrame:HookScript("OnHide", function()
				if(_G["SVUI_Player"] and _G["SVUI_Player"].LossOfControl) then
					_G["SVUI_Player"].LossOfControl:Hide()
				end
			end)
		end
	else
		frame.ActionPanel = CreateActionPanel(frame, 2)
		frame.InfoPanel = CreateFrame("Frame", nil, frame)
		frame.InfoPanel:SetFrameStrata("LOW")
		frame.InfoPanel:SetFrameLevel(20)
		frame.InfoPanel:Point("TOPLEFT", frame.ActionPanel, "TOPLEFT", 2, -2)
		frame.InfoPanel:Point("BOTTOMRIGHT", frame.ActionPanel, "BOTTOMRIGHT", -2, 2)
	end

	frame.Threat = CreateThreat(frame.ActionPanel, unit)

	frame.InfoPanel.Name = CreateNameText(frame.InfoPanel, unit)

	local reverse = unit and (unit == "target" or unit == "focus" or unit == "boss" or unit == "arena") or false;
	local offset, direction

	if(not noHealthText) then
		frame.InfoPanel.Health = frame.InfoPanel:CreateFontString(nil, "OVERLAY")
		frame.InfoPanel.Health:SetFont(LSM:Fetch("font", SV.db.SVUnit.font), SV.db.SVUnit.fontSize, SV.db.SVUnit.fontOutline)
		offset = reverse and 2 or -2;
		direction = reverse and "LEFT" or "RIGHT";
		frame.InfoPanel.Health:Point(direction, frame.InfoPanel, direction, offset, 0)
	end

	if(not noPowerText) then
		frame.InfoPanel.Power = frame.InfoPanel:CreateFontString(nil, "OVERLAY")
		frame.InfoPanel.Power:SetFont(LSM:Fetch("font", SV.db.SVUnit.font), SV.db.SVUnit.fontSize, SV.db.SVUnit.fontOutline)
		offset = reverse and -2 or 2;
		direction = reverse and "RIGHT" or "LEFT";
		frame.InfoPanel.Power:Point(direction, frame.InfoPanel, direction, offset, 0)
	end

	if(not noMiscText) then
		frame.InfoPanel.Misc = frame.InfoPanel:CreateFontString(nil, "OVERLAY")
		frame.InfoPanel.Misc:SetFont(LSM:Fetch("font", SV.db.SVUnit.font), SV.db.SVUnit.fontSize, SV.db.SVUnit.fontOutline)
		frame.InfoPanel.Misc:Point("CENTER", frame, "CENTER", 0, 0)
	end

	frame.HealthPanel = CreateFrame("Frame", nil, frame)
	frame.HealthPanel:SetAllPoints(frame)

	frame.StatusPanel = CreateFrame("Frame", nil, frame.HealthPanel)
	frame.StatusPanel:EnableMouse(false)

	if(unit and (unit == "player" or unit == "pet" or unit == "target" or unit == "targettarget" or unit == "focus" or unit == "focustarget")) then
		frame.StatusPanel:SetAllPoints(frame.HealthPanel)
		frame.StatusPanel.media = {
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\TARGET-DC]],
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\TARGET-DEAD]],
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\TARGET-TAPPED]]
		}
	else
		frame.StatusPanel:SetSize(50, 50)
		frame.StatusPanel:SetPoint("CENTER", frame.HealthPanel, "CENTER", 0, 0)
		frame.StatusPanel.media = {
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-DC]],
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-DEAD]],
			[[Interface\Addons\SVUI\assets\artwork\Unitframe\UNIT-TAPPED]]
		}
	end

	frame.StatusPanel.texture = frame.StatusPanel:CreateTexture(nil, "OVERLAY")
	frame.StatusPanel.texture:SetAllPoints()
	-- frame.StatusPanel.texture:SetTexture([[Interface\BUTTONS\WHITE8X8]])
	-- frame.StatusPanel.texture:SetBlendMode("ADD")
	-- frame.StatusPanel.texture:SetGradient("VERTICAL",1,1,0,1,0,0)
	-- frame.StatusPanel.texture:SetAlpha(0)

	frame.StatusPanel:SetFrameStrata("LOW")
	frame.StatusPanel:SetFrameLevel(28)
end
--[[ 
########################################################## 
HEALTH
##########################################################
]]--
function MOD:CreateHealthBar(frame, hasbg, reverse)
	local healthBar = CreateFrame("StatusBar", nil, frame)
	healthBar:SetFrameStrata("LOW")
	healthBar:SetFrameLevel(4)
	healthBar:SetStatusBarTexture(SV.Media.bar.default)
	if hasbg then 
		healthBar.bg = healthBar:CreateTexture(nil, "BORDER")
		healthBar.bg:SetAllPoints()
		healthBar.bg:SetTexture(SV.Media.bar.gradient)
		healthBar.bg:SetVertexColor(0.4, 0.1, 0.1)
		healthBar.bg.multiplier = 0.25
	end 

	local flasher = CreateFrame("Frame", nil, frame)
	flasher:SetFrameLevel(3)
	flasher:SetAllPoints(healthBar)

	flasher[1] = flasher:CreateTexture(nil, "OVERLAY", nil, 1)
	flasher[1]:SetTexture(HEALTH_ANIM_FILE)
	flasher[1]:SetTexCoord(0, 0.5, 0, 0.25)
	flasher[1]:SetVertexColor(1, 0.3, 0.1, 0.5)
	flasher[1]:SetBlendMode("ADD")
	flasher[1]:SetAllPoints(flasher)
	SetAnim(flasher[1], flasher)
	flasher:Hide() 

	healthBar.animation = flasher
	healthBar.noupdate = false;
	healthBar.fillInverted = reverse;
	healthBar.gridMode = false;
	healthBar.colorTapping = true;
	healthBar.colorDisconnected = true;
	healthBar.Override = false;
	return healthBar 
end 

function MOD:RefreshHealthBar(frame, overlay)
	if(overlay) then
		frame.Health.Override = true;
	else
		frame.Health.Override = false;
	end 
end
--[[ 
########################################################## 
POWER
##########################################################
]]--
local PostUpdateAltPower = function(self, min, current, max)
	local remaining = floor(current  /  max  *  100)
	local parent = self:GetParent()
	if remaining < 35 then 
		self:SetStatusBarColor(0, 1, 0)
	elseif remaining < 70 then 
		self:SetStatusBarColor(1, 1, 0)
	else 
		self:SetStatusBarColor(1, 0, 0)
	end 
	local unit = parent.unit;
	if(unit == "player" and self.text) then 
		local apInfo = select(10, UnitAlternatePowerInfo(unit))
		if remaining > 0 then 
			self.text:SetText(apInfo..": "..format("%d%%", remaining))
		else 
			self.text:SetText(apInfo..": 0%")
		end 
	elseif(unit and unit:find("boss%d") and self.text) then 
		self.text:SetTextColor(self:GetStatusBarColor())
		if not parent.InfoPanel.Power:GetText() or parent.InfoPanel.Power:GetText() == "" then 
			self.text:Point("BOTTOMRIGHT", parent.Health, "BOTTOMRIGHT")
		else 
			self.text:Point("RIGHT", parent.InfoPanel.Power, "LEFT", 2, 0)
		end 
		if remaining > 0 then 
			self.text:SetText("|cffD7BEA5[|r"..format("%d%%", remaining).."|cffD7BEA5]|r")
		else 
			self.text:SetText(nil)
		end 
	end 
end

function MOD:CreatePowerBar(frame, bg)
	local power = CreateFrame("StatusBar", nil, frame)
	power:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
	power:SetPanelTemplate("Bar")
	power:SetFrameStrata("LOW")
	power:SetFrameLevel(6)
	if bg then 
		power.bg = power:CreateTexture(nil, "BORDER")
		power.bg:SetAllPoints()
		power.bg:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
		power.bg.multiplier = 0.2 
	end 
	power.colorDisconnected = false;
	power.colorTapping = false;
	power.PostUpdate = MOD.PostUpdatePower;
	return power 
end 

function MOD:CreateAltPowerBar(frame)
	local altPower = CreateFrame("StatusBar", nil, frame)
	altPower:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
	altPower:SetPanelTemplate("Bar")
	altPower:GetStatusBarTexture():SetHorizTile(false)
	altPower:SetFrameStrata("LOW")
	altPower:SetFrameLevel(8)
	altPower.text = altPower:CreateFontString(nil, "OVERLAY")
	altPower.text:SetPoint("CENTER")
	altPower.text:SetJustifyH("CENTER")
	altPower.text:SetFont(LSM:Fetch("font", SV.db.SVUnit.font), SV.db.SVUnit.fontSize, SV.db.SVUnit.fontOutline)
	altPower.PostUpdate = PostUpdateAltPower;
	return altPower 
end

function MOD:PostUpdatePower(unit, value, max)
	local db = SV.db.SVUnit[unit]
	local powerType, _, _, _, _ = UnitPowerType(unit)
	local parent = self:GetParent()
	if parent.isForced then
		value = random(1, max)
		powerType = random(0, 4)
		self:SetValue(value)
	end 
	local colors = oUF_Villain.colors.power[token[powerType]]
	local mult = self.bg.multiplier or 1;
	local isPlayer = UnitPlayerControlled(unit)
	if isPlayer and self.colorClass then 
		local _, class = UnitClassBase(unit);
		colors = oUF_Villain["colors"].class[class]
	elseif not isPlayer then 
		local react = UnitReaction("player", unit)
		colors = oUF_Villain["colors"].reaction[react]
	end 
	if not colors then return end
	self:SetStatusBarColor(colors[1], colors[2], colors[3])
	self.bg:SetVertexColor(colors[1] * mult, colors[2] * mult, colors[3] * mult)
end
--[[ 
########################################################## 
PORTRAIT
##########################################################
]]--
function MOD:CreatePortrait(frame,smallUnit,isPlayer)
	-- 3D Portrait
	local portrait3D = CreateFrame("PlayerModel",nil,frame)
	portrait3D:SetFrameStrata("LOW")
	portrait3D:SetFrameLevel(2)

	if smallUnit then 
		portrait3D:SetPanelTemplate("UnitSmall")
	else 
		portrait3D:SetPanelTemplate("UnitLarge")
	end 

	local overlay = CreateFrame("Frame",nil,portrait3D)
	overlay:SetAllPoints(portrait3D.Panel)
	overlay:SetFrameLevel(3)
	portrait3D.overlay = overlay;
	portrait3D.UserRotation = 0;
	portrait3D.UserCamDistance = 1.3;

	-- 2D Portrait
	local portrait2Danchor = CreateFrame('Frame',nil,frame)
	portrait2Danchor:SetFrameStrata("LOW")
	portrait2Danchor:SetFrameLevel(2)

	local portrait2D = portrait2Danchor:CreateTexture(nil,'OVERLAY')
	portrait2D:SetTexCoord(0.15,0.85,0.15,0.85)
	portrait2D:SetAllPoints(portrait2Danchor)
	portrait2D.anchor = portrait2Danchor;
	if smallUnit then 
		portrait2Danchor:SetFixedPanelTemplate("UnitSmall")
	else 
		portrait2Danchor:SetFixedPanelTemplate("UnitLarge")
	end 
	portrait2D.Panel = portrait2Danchor.Panel;

	local overlay = CreateFrame("Frame",nil,portrait2Danchor)
	overlay:SetAllPoints(portrait2D.Panel)
	overlay:SetFrameLevel(3)
	portrait2D.overlay = overlay;

	-- Assign To Frame
	frame.PortraitModel = portrait3D;
	frame.PortraitTexture = portrait2D;
end