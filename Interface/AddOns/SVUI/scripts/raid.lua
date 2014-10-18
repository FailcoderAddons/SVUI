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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
--[[ 
########################################################## 
RAID UTILITY By: Elv
##########################################################
]]--
local PANEL_HEIGHT = 120
local find = string.find
local RaidUtilFrame = CreateFrame("Frame");
--Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local inInstance, instanceType = IsInInstance()
	if ((IsInGroup() and not IsInRaid()) or UnitIsGroupLeader('player') or UnitIsGroupAssistant("player")) and not (inInstance and (instanceType == "pvp" or instanceType == "arena")) then
		return true
	else
		return false
	end
end

local function ButtonEnter(self)
	self:SetPanelColor("highlight")

	if(self.TText) then
		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self.TText, 1, 1, 1)
		GameTooltip:Show()
	end
end

local function ButtonLeave(self)
	self:SetPanelColor("inverse")

	GameTooltip:Hide()
end

local function CreateUtilButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text, texture)
	local b = CreateFrame("Button", name, parent, template)
	b:Width(width)
	b:Height(height)
	b:Point(point, relativeto, point2, xOfs, yOfs)

	if text then
		local t = b:CreateFontString(nil,"OVERLAY")
		t:SetFont(SV.Media.font.roboto, 14, "NONE")
		t:SetAllPoints(b)
		t:SetJustifyH("CENTER")
		t:SetText(text)
		b:SetFontString(t)
	elseif texture then
		local t = b:CreateTexture(nil,"OVERLAY",nil)
		t:SetTexture(texture)
		t:Point("TOPLEFT", b, "TOPLEFT", 1, -1)
		t:Point("BOTTOMRIGHT", b, "BOTTOMRIGHT", -1, 1)	
	end
	b:HookScript("OnEnter", ButtonEnter)
	b:HookScript("OnLeave", ButtonLeave)
end

local function ToggleRaidUtil(event)
	if(not SVUI_RaidTools) then return end
	if InCombatLockdown() then
		RaidUtilFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if CheckRaidStatus() then
		local width = SuperDockToolBarTop.openWidth
		SuperDockToolBarTop:SetWidth(width)
		if RaidUtilityPanel.toggled == true then
			SVUI_RaidTools:Hide()
			RaidUtilityPanel:Show()		
		else
			SVUI_RaidTools:Show()
			RaidUtilityPanel:Hide()
		end
	else
		SuperDockToolBarTop:SetWidth(1)
		SVUI_RaidTools:Hide()
		RaidUtilityPanel:Hide()
	end
	
	if event == "PLAYER_REGEN_ENABLED" then
		RaidUtilFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

RaidUtilFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
RaidUtilFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
RaidUtilFrame:SetScript("OnEvent", ToggleRaidUtil)

local function LoadRaidUtility()
	local buttonsize = SV.db.SVDock.buttonSize or 22;
	--Create main frame
	local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", SV.UIParent, "SecureHandlerClickTemplate")
	RaidUtilityPanel:SetPanelTemplate('Transparent')
	RaidUtilityPanel:Width(120)
	RaidUtilityPanel:Height(PANEL_HEIGHT)
	RaidUtilityPanel:SetPoint("TOPLEFT", SuperDockToolBarTop, "BOTTOMLEFT", 0, -2)
	RaidUtilityPanel:SetFrameLevel(3)
	RaidUtilityPanel.toggled = false
	RaidUtilityPanel:SetFrameStrata("HIGH")
	SV:AddToDisplayAudit(RaidUtilityPanel)
	
	--Show Button
	local SVUI_RaidTools = CreateFrame("Button", "SVUI_RaidTools", SV.UIParent, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate")
	SVUI_RaidTools:Size(buttonsize, buttonsize)
	SVUI_RaidTools:Point("CENTER", SuperDockToolBarTop, "CENTER", 0, 0)
	SVUI_RaidTools.icon = SVUI_RaidTools:CreateTexture(nil,"OVERLAY",nil)
	SVUI_RaidTools.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-RAIDTOOL]])
	SVUI_RaidTools.icon:Point("TOPLEFT", SVUI_RaidTools, "TOPLEFT", 1, -1)
	SVUI_RaidTools.icon:Point("BOTTOMRIGHT", SVUI_RaidTools, "BOTTOMRIGHT", -1, 1)

	SVUI_RaidTools.TText = RAID_CONTROL .. " [Click to Open]"

	SVUI_RaidTools:HookScript("OnEnter", ButtonEnter)
	SVUI_RaidTools:HookScript("OnLeave", ButtonLeave)

	SVUI_RaidTools:SetFrameRef("RaidUtilityPanel", RaidUtilityPanel)
	SVUI_RaidTools:SetAttribute("_onclick", [=[
		local raidUtil = self:GetFrameRef("RaidUtilityPanel")
		local closeButton = raidUtil:GetFrameRef("RaidUtility_CloseButton")
		self:Hide(); 
		raidUtil:Show(); 

		local point = self:GetPoint();		
		local raidUtilPoint, raidUtilRelative, closeButtonPoint, closeButtonRelative, yOffset
		if string.find(point, "BOTTOM") then
			raidUtilPoint = "BOTTOMLEFT"
			raidUtilRelative = "TOPLEFT"
			closeButtonPoint = "TOP"
			closeButtonRelative = "BOTTOM"
			yOffset = 1						
		else
			raidUtilPoint = "TOPLEFT"
			raidUtilRelative = "BOTTOMLEFT"
			closeButtonPoint = "BOTTOM"
			closeButtonRelative = "TOP"
			yOffset = -1			
		end
		
		raidUtil:ClearAllPoints()
		closeButton:ClearAllPoints()
		raidUtil:SetPoint(raidUtilPoint, self, raidUtilRelative, 2, -2)
		closeButton:SetPoint(closeButtonRelative, raidUtil, closeButtonPoint, 0, yOffset)
	]=])

	SVUI_RaidTools:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = true end)
	SVUI_RaidTools:SetMovable(true)
	SVUI_RaidTools:SetClampedToScreen(true)
	SVUI_RaidTools:SetClampRectInsets(0, 0, -1, 1)
	SVUI_RaidTools:RegisterForDrag("RightButton")
	SVUI_RaidTools:SetFrameStrata("HIGH")
	SVUI_RaidTools:SetScript("OnDragStart", function(self) 
		self:StartMoving()
	end)

	SV:AddToDisplayAudit(SVUI_RaidTools)
	
	SVUI_RaidTools:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing()
		local point = self:GetPoint()
		local xOffset = self:GetCenter()
		local screenWidth = SV.UIParent:GetWidth() / 2
		xOffset = xOffset - screenWidth
		self:ClearAllPoints()
		if find(point, "BOTTOM") then
			self:SetPoint('BOTTOM', SV.UIParent, 'BOTTOM', xOffset, -1)
		else
			self:SetPoint('TOP', SV.UIParent, 'TOP', xOffset, 1)		
		end
	end)

	--Close Button
	CreateUtilButton("RaidUtility_CloseButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate, SecureHandlerClickTemplate", 30, 18, "TOP", RaidUtilityPanel, "BOTTOM", 0, -1, "X", nil)
	RaidUtility_CloseButton:SetFrameRef("SVUI_RaidTools", SVUI_RaidTools)
	RaidUtility_CloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide(); self:GetFrameRef("SVUI_RaidTools"):Show();]=])
	RaidUtility_CloseButton:SetScript("OnMouseUp", function(self) RaidUtilityPanel.toggled = false end)
	RaidUtilityPanel:SetFrameRef("RaidUtility_CloseButton", RaidUtility_CloseButton)
	
	local buttonWidth = RaidUtilityPanel:GetWidth() * 0.9

	--Disband Raid button
	CreateUtilButton("DisbandRaidButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", buttonWidth, 18, "TOP", RaidUtilityPanel, "TOP", 0, -5, L['Disband Group'], nil)
	DisbandRaidButton:SetScript("OnMouseUp", function(self)
		if CheckRaidStatus() then
			SV:StaticPopup_Show("DISBAND_RAID")
		end
	end)

	--Role Check button
	CreateUtilButton("RoleCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", buttonWidth, 18, "TOP", DisbandRaidButton, "BOTTOM", 0, -5, ROLE_POLL, nil)
	RoleCheckButton:SetScript("OnMouseUp", function(self)
		if CheckRaidStatus() then
			InitiateRolePoll()
		end
	end)

	--Ready Check button
	CreateUtilButton("ReadyCheckButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", buttonWidth, 18, "TOP", RoleCheckButton, "BOTTOM", 0, -5, READY_CHECK, nil)
	ReadyCheckButton:SetScript("OnMouseUp", function(self)
		if CheckRaidStatus() then
			DoReadyCheck()
		end
	end)

	--Raid Control Panel
	CreateUtilButton("RaidControlButton", RaidUtilityPanel, "UIMenuButtonStretchTemplate", buttonWidth, 18, "TOP", ReadyCheckButton, "BOTTOM", 0, -5, L['Raid Menu'], nil)
	RaidControlButton:SetScript("OnMouseUp", function(self)
		ToggleFriendsFrame(4)
	end)

	--Reposition/Resize and Reuse the World Marker Button
	if(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton) then
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetPoint("TOP", RaidControlButton, "BOTTOM", 0, -5)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetParent("RaidUtilityPanel")
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:Height(18)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetWidth(buttonWidth)
		local markersText = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:CreateFontString(nil,"OVERLAY")
		markersText:SetFont(SV.Media.font.roboto, 14, "NONE")
		markersText:SetAllPoints(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton)
		markersText:SetJustifyH("CENTER")
		markersText:SetText("World Markers")
		CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetFontString(markersText)
	end

	--Put other stuff back
	if(CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck) then
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLockedModeToggle, "TOPLEFT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameHiddenModeToggle, "TOPRIGHT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:ClearAllPoints()
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMLEFT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPLEFT", 0, 1)
		CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll:SetPoint("BOTTOMRIGHT", CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck, "TOPRIGHT", 0, 1)
	end
	do
		--[[NEEDS TESTING]]--
		local buttons = {
			"CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton",
			"DisbandRaidButton",
			"RoleCheckButton",
			"ReadyCheckButton",
			"RaidControlButton",
			"SVUI_RaidTools",
			"RaidUtility_CloseButton"
		}

		for i, gName in pairs(buttons) do
			local button = _G[gName]
			if(button) then
				button:RemoveTextures()
				button:SetFramedButtonTemplate()
				button:HookScript("OnEnter", ButtonEnter)
				button:HookScript("OnLeave", ButtonLeave)
			end
		end

		SVUI_RaidTools.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-RAIDTOOL]])
	end
end
SV:NewScript(LoadRaidUtility);