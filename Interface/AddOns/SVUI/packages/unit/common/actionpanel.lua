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
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");

local ELITE_TOP = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-TOP]]
local ELITE_BOTTOM = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-BOTTOM]]
local ELITE_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\ELITE-RIGHT]]

-- local STATUS_BG = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\STATUS-BG]]
-- local STATUS_LEFT = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\STATUS-LEFT]]
-- local STATUS_RIGHT = [[Interface\Addons\SVUI\assets\artwork\Unitframe\Border\STATUS-RIGHT]]
--[[ 
########################################################## 
LOCAL FUNCTIONS
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
	if(unit ~= self.unit) or not unit or not IsLoggedIn() then return end
	local threat = self.Threat
	local status = UnitThreatSituation(unit)
	local r, g, b
	if(status and status > 0) then
		r, g, b = GetThreatStatusColor(status)
		threat:SetBackdropBorderColor(r, g, b)
		if(status > 1) then
			threat.OhShit:Show()
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
		local aggro = CreateFrame("Frame", nil, threat)
		aggro:SetFrameStrata("HIGH")
		aggro:SetFrameLevel(30)
		aggro:Size(52,52)
		aggro:Point("TOPRIGHT",frame,16,16)
		aggro.bg = aggro:CreateTexture(nil, "BORDER")
		aggro.bg:FillInner(aggro)
		aggro.bg:SetTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Unitframe\\UNIT-AGGRO")
		SuperVillain.Animate:Pulse(aggro)
		aggro:Hide()
		aggro:SetScript("OnShow", OhShit_OnShow)
		
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
end;
--[[ 
########################################################## 
ACTIONPANEL / INFOPANEL
##########################################################
]]--
function MOD:SetActionPanel(frame, unit)
	if(unit and (unit == "target" or unit == "player")) then
		frame.ActionPanel = CreateActionPanel(frame, 3)
		frame.Threat = CreateThreat(frame.ActionPanel, unit)

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
		frame.InfoPanel:SetFrameStrata("MEDIUM")
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
		end
	else
		frame.ActionPanel = CreateActionPanel(frame, 2)
		frame.InfoPanel = CreateFrame("Frame", nil, frame)
		frame.InfoPanel:SetFrameStrata("MEDIUM")
		frame.InfoPanel:Point("TOPLEFT", frame.ActionPanel, "TOPLEFT", 2, -2)
		frame.InfoPanel:Point("BOTTOMRIGHT", frame.ActionPanel, "BOTTOMRIGHT", -2, 2)
		frame.InfoPanel:SetFrameLevel(frame.InfoPanel:GetFrameLevel() + 30)
	end

	local miscText = frame.InfoPanel:CreateFontString(nil, "OVERLAY")
	MOD:SetUnitFont(miscText)
	miscText:Point("CENTER", frame, "CENTER", 0, 0)

	frame.InfoPanel.Misc = miscText

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
	frame.StatusPanel.texture:SetTexture([[Interface\BUTTONS\WHITE8X8]])
	frame.StatusPanel.texture:SetBlendMode("ADD")
	frame.StatusPanel.texture:SetGradient("VERTICAL",1,1,0,1,0,0)
	frame.StatusPanel.texture:SetAlpha(0)

	frame.StatusPanel:SetFrameStrata("LOW")
	frame.StatusPanel:SetFrameLevel(20)
end;