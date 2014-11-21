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
local _G = _G;
local unpack  = _G.unpack;
local select  = _G.select;
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local GarrisonButtonList = {
	"StartWorkOrderButton"
};
--[[ 
########################################################## 
STYLE
##########################################################
]]--
local function AddFadeBanner(frame)
	local bg = frame:CreateTexture(nil, "OVERLAY")
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", frame, "RIGHT", 0, 0)
	bg:SetTexture(1, 1, 1, 1)
	bg:SetGradientAlpha("VERTICAL", 0, 0, 0, 0, 0, 0, 0, 0.9)
end

local _hook_ReagentUpdate = function(self)
	local reagents = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i] and (not reagents[i].Panel)) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetSlotTemplate(true, 2, 0, 0, true)
        	if(reagents[i].Icon) then
				reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
    end
end

local function LoadGarrisonStyle()
	if PLUGIN.db.blizzard.enable ~= true then
		return 
	end

	PLUGIN:ApplyWindowStyle(GarrisonMissionFrame, true)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab1)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab2)

	GarrisonLandingPage:RemoveTextures()
	GarrisonLandingPage:SetPanelTemplate("Paper")
	GarrisonLandingPage:SetPanelColor("tan")

	GarrisonLandingPage.FollowerTab:RemoveTextures()
	GarrisonLandingPage.FollowerTab.AbilitiesFrame:RemoveTextures()
	GarrisonLandingPage.FollowerTab:SetPanelTemplate("ModelBorder")

	GarrisonLandingPage.FollowerTab.Panel:ClearAllPoints()
	GarrisonLandingPage.FollowerTab.Panel:SetPoint("TOPLEFT", GarrisonLandingPage.FollowerList.SearchBox, "TOPRIGHT", 10, 6)
	GarrisonLandingPage.FollowerTab.Panel:SetPoint("BOTTOMRIGHT", GarrisonLandingPage, "BOTTOMRIGHT", -38, 30)

	GarrisonLandingPage.FollowerList:RemoveTextures()
	GarrisonLandingPage.FollowerList:SetPanelTemplate('Inset', false, 4, 0, 0)

	PLUGIN:ApplyTabStyle(GarrisonLandingPageTab1, nil, 10, 4)
	PLUGIN:ApplyTabStyle(GarrisonLandingPageTab2, nil, 10, 4)
	local a1, p, a2, x, y = GarrisonLandingPageTab1:GetPoint()
	GarrisonLandingPageTab1:SetPoint(a1, p, a2, x, (y - 15))

	GarrisonLandingPageReportList:RemoveTextures()
	GarrisonLandingPageReportList:SetPanelTemplate('Inset', false, 4, 0, 0)

	GarrisonLandingPageReport.Available:RemoveTextures(true)
	GarrisonLandingPageReport.Available:SetButtonTemplate()
	GarrisonLandingPageReport.Available:GetNormalTexture().SetAtlas = function() return end

	GarrisonLandingPageReport.InProgress:RemoveTextures(true)
	GarrisonLandingPageReport.InProgress:SetButtonTemplate()
	GarrisonLandingPageReport.InProgress:GetNormalTexture().SetAtlas = function() return end

	GarrisonMissionFrameMissions:RemoveTextures()
	GarrisonMissionFrameMissions:SetFixedPanelTemplate("Inset")
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:RemoveTextures()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:SetPanelTemplate('Halftone', false, 4, 0, 0)
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.Stage:RemoveTextures()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.Stage:SetFixedPanelTemplate("Model")
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:RemoveTextures(true)
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetButtonTemplate()

	GarrisonMissionFrameMissionsListScrollFrame:RemoveTextures()
	PLUGIN:ApplyScrollFrameStyle(GarrisonMissionFrameMissionsListScrollFrame)

	PLUGIN:ApplyTabStyle(GarrisonMissionFrameMissionsTab1, nil, 10, 4)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameMissionsTab2, nil, 10, 4)
	local a1, p, a2, x, y = GarrisonMissionFrameMissionsTab1:GetPoint()
	GarrisonMissionFrameMissionsTab1:SetPoint(a1, p, a2, x, (y + 8))

	GarrisonMissionFrameMissions.MaterialFrame:RemoveTextures()
	GarrisonMissionFrameMissions.MaterialFrame:SetPanelTemplate("Inset", true, 1, -3, -3)

	GarrisonMissionFrame.FollowerTab:RemoveTextures()
	GarrisonMissionFrame.FollowerTab:SetFixedPanelTemplate("ModelBorder")

	GarrisonMissionFrame.MissionTab:RemoveTextures()
	GarrisonMissionFrame.MissionTab.MissionPage:RemoveTextures()
	GarrisonMissionFrame.MissionTab.MissionPage:SetPanelTemplate('Paper', false, 4, 0, 0)
	GarrisonMissionFrame.MissionTab.MissionPage:SetPanelColor("special")


	GarrisonMissionFrame.MissionTab.MissionPage.Panel:ClearAllPoints()
	GarrisonMissionFrame.MissionTab.MissionPage.Panel:SetPoint("TOPLEFT", GarrisonMissionFrame.MissionTab.MissionPage, "TOPLEFT", 0, 4)
	GarrisonMissionFrame.MissionTab.MissionPage.Panel:SetPoint("BOTTOMRIGHT", GarrisonMissionFrame.MissionTab.MissionPage, "BOTTOMRIGHT", 0, -20)

	GarrisonMissionFrame.MissionTab.MissionPage.Stage:RemoveTextures()
	AddFadeBanner(GarrisonMissionFrame.MissionTab.MissionPage.Stage)
	GarrisonMissionFrame.MissionTab.MissionPage.StartMissionButton:RemoveTextures(true)
	GarrisonMissionFrame.MissionTab.MissionPage.StartMissionButton:SetButtonTemplate()

	GarrisonMissionFrameFollowers:RemoveTextures()
	GarrisonMissionFrameFollowers:SetPanelTemplate('Inset', false, 4, 0, 0)
	GarrisonMissionFrameFollowers.MaterialFrame:RemoveTextures()
	GarrisonMissionFrameFollowers.MaterialFrame:SetPanelTemplate("Inset", true, 1, -5, -7)
	PLUGIN:ApplyEditBoxStyle(GarrisonMissionFrameFollowers.SearchBox)

	GarrisonMissionFrame.MissionComplete:RemoveTextures()
	GarrisonMissionFrame.MissionComplete:SetPanelTemplate('Paper', false, 4, 0, 0)
	GarrisonMissionFrame.MissionComplete:SetPanelColor("special")
	GarrisonMissionFrame.MissionComplete.Stage:RemoveTextures()
	GarrisonMissionFrame.MissionComplete.Stage.MissionInfo:RemoveTextures()
	GarrisonMissionFrame.MissionComplete.Stage.FollowersFrame:RemoveTextures()
	AddFadeBanner(GarrisonMissionFrame.MissionComplete.Stage)
	GarrisonMissionFrame.MissionComplete.NextMissionButton:RemoveTextures(true)
	GarrisonMissionFrame.MissionComplete.NextMissionButton:SetButtonTemplate()

	--print("Test")
	local display = GarrisonCapacitiveDisplayFrame
	display:RemoveTextures(true)
	GarrisonCapacitiveDisplayFrameInset:RemoveTextures(true)
	display.CapacitiveDisplay:RemoveTextures(true)
	display.CapacitiveDisplay:SetPanelTemplate('Transparent')
	display.CapacitiveDisplay.ShipmentIconFrame:SetSlotTemplate(true, 2, 0, 0, true)
	display.CapacitiveDisplay.ShipmentIconFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	display:SetPanelTemplate('Action')

	--print("Test")
	local reagents = display.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i]) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetSlotTemplate(true, 2, 0, 0, true)
        	if(reagents[i].Icon) then
				reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
    end

    hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", _hook_ReagentUpdate)

 --    print("Test")
	for i = 1, #GarrisonButtonList do
		local button = GarrisonCapacitiveDisplayFrame[GarrisonButtonList[i]]
		if(button) then
			button:RemoveTextures(true)
			button:SetButtonTemplate()
		end
	end

	--print("Test")
	PLUGIN:ApplyScrollFrameStyle(GarrisonLandingPageReportListListScrollFrameScrollBar)
	PLUGIN:ApplyCloseButtonStyle(GarrisonLandingPage.CloseButton)
	GarrisonLandingPage.CloseButton:SetFrameStrata("HIGH")

	--print("Test")
	for i = 1, GarrisonLandingPageReportListListScrollFrameScrollChild:GetNumChildren() do
		local child = select(i, GarrisonLandingPageReportListListScrollFrameScrollChild:GetChildren())
		for j = 1, child:GetNumChildren() do
			local childC = select(j, child:GetChildren())
			childC.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		end
	end

	--print("Test")
	PLUGIN:ApplyScrollFrameStyle(GarrisonLandingPageListScrollFrameScrollBar)

	--print("Test Done")
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_GarrisonUI", LoadGarrisonStyle)