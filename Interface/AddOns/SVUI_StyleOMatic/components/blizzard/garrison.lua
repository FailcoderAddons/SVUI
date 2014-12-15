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
local RING_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-RING]]
local LVL_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-LEVEL]]
local DEFAULT_COLOR = {r = 0.25, g = 0.25, b = 0.25};
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

local function StyleItemIcon(item)
	if((not item) or (not item.Icon)) then return end
	item.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	if(not item.IconSlot) then 
		item.IconSlot = CreateFrame("Frame", nil, item)
		item.IconSlot:SetAllPointsOut(item.Icon)
		item.IconSlot:SetStylePanel("Icon")
		item.Icon:SetParent(item.IconSlot)
	end
end

local function StyleListItem(item)
	if(not item) then return; end
    if(item.Icon) then
    	local size = item:GetHeight() - 8
    	local texture = item.Icon:GetTexture()
		item:RemoveTextures()
    	item:SetStylePanel("Inset")
    	item.Icon:SetTexture(texture)
		item.Icon:ClearAllPoints()
		item.Icon:SetPoint("TOPLEFT", item, "TOPLEFT", 4, -4)
		item.Icon:SetSize(size, size)
		item.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		if(not item.IconSlot) then 
			item.IconSlot = CreateFrame("Frame", nil, item)
			item.IconSlot:SetAllPointsOut(item.Icon)
			item.IconSlot:SetStylePanel("Icon")
			item.Icon:SetParent(item.IconSlot)
		end
    end
end

local function StyleFollowerPortrait(frame, color)
	frame.PortraitRing:SetTexture(RING_TEXTURE)
	frame.PortraitRingQuality:SetTexture('')
	frame.LevelBorder:SetTexture('')
	if(not frame.LevelCallout) then
		frame.LevelCallout = frame:CreateTexture(nil, 'BORDER', 4)
		frame.LevelCallout:SetAllPoints(frame)
		frame.LevelCallout:SetTexture(LVL_TEXTURE)
		frame.LevelBorder:SetDrawLayer('OVERLAY')
	end
	if(color) then
		frame.PortraitRing:SetVertexColor(color.r, color.g, color.b)
	end
end

local _hook_ReagentUpdate = function(self)
	local reagents = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i] and (not reagents[i].Panel)) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetStylePanel("Slot", true, 2, 0, 0, 0.5)
        	if(reagents[i].Icon) then
				reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
    end
end

local _hook_GarrisonBuildingListUpdate = function()
	local list = GarrisonBuildingFrame.BuildingList;
	for i=1, GARRISON_NUM_BUILDING_SIZES do
		local tab = list["Tab"..i];
		if(tab and tab.buildings) then
			for i=1, #tab.buildings do
				StyleListItem(list.Buttons[i])
			end
		end
	end
end

local _hook_GarrisonFollowerListUpdate = function(self)
    local buttons = self.FollowerList.listScroll.buttons;
    local followers = self.FollowerList.followers;
    local followersList = self.FollowerList.followersList;
    local numFollowers = #followersList;
    local scrollFrame = self.FollowerList.listScroll;
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local numButtons = #buttons;
 
    for i = 1, numButtons do
        local button = buttons[i];
        local index = offset + i;
        if(index <= numFollowers) then
        	local follower = followers[followersList[index]];
	        if(not button.Panel) then
	            button:RemoveTextures()
	            button:SetStylePanel("Default", 'Blackout', true, 1, 0, 0)
				if(button.XPBar) then
					button.XPBar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
					button.XPBar:SetGradient('HORIZONTAL', 0.5, 0, 1, 1, 0, 1)
				end
	        end
	        if(button.PortraitFrame) then
	        	local color
		        if(follower.isCollected) then
	            	color = ITEM_QUALITY_COLORS[follower.quality]
	            else
	            	color = DEFAULT_COLOR
				end
				StyleFollowerPortrait(button.PortraitFrame, color)
			end
	    end
    end
end

local _hook_GarrisonFollowerTooltipTemplate_SetGarrisonFollower = function(tooltip, data)
	local color = ITEM_QUALITY_COLORS[data.quality];
	StyleFollowerPortrait(tooltip.Portrait, color)
end

local _hook_GarrisonBuildingInfoBoxFollowerPortrait = function(owned, hasFollowerSlot, infoBox, isBuilding, canActivate, ID)
	local portraitFrame = infoBox.FollowerPortrait;
	StyleFollowerPortrait(portraitFrame)
end

local _hook_GarrisonMissionFrame_SetFollowerPortrait = function(portraitFrame, followerInfo)
	local color = ITEM_QUALITY_COLORS[followerInfo.quality];
	StyleFollowerPortrait(portraitFrame, color)
end

local _hook_GarrisonMissionComplete_SetFollowerLevel = function(followerFrame, level, quality)
	local color = ITEM_QUALITY_COLORS[quality];
	followerFrame.PortraitFrame.PortraitRing:SetVertexColor(color.r, color.g, color.b)
end

local _hook_GarrisonFollowerPage_ShowFollower = function(self, followerID)
	local followerInfo = C_Garrison.GetFollowerInfo(followerID);
    if(not self.XPBar.Panel) then
	    self.XPBar:RemoveTextures()
		self.XPBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
		self.XPBar:SetStylePanel("Fixed", "Bar")
	end
 
    for i=1, #self.AbilitiesFrame.Abilities do
        local abilityFrame = self.AbilitiesFrame.Abilities[i];
        abilityFrame.IconButton.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
        if(not abilityFrame.IconButton.Panel) then
			abilityFrame.IconButton:SetStylePanel("Fixed", "Slot", true, 4)
		end
    end
end

local function StyleRewardButtons(rewardButtons)
    for i = 1, #rewardButtons do
        local frame = rewardButtons[i];
        StyleListItem(frame);
    end
end

local function StyleListButtons(listButtons)
    for i = 1, #listButtons do
        local frame = listButtons[i];
        if(frame.Icon and (not frame.Panel)) then
	    	local size = frame:GetHeight() - 6
	    	local texture = frame.Icon:GetTexture()
			frame:RemoveTextures()
	    	frame:SetStylePanel("Fixed", 'Blackout', true, 3)
	    	frame.Icon:SetTexture(texture)
			frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			frame.Icon:ClearAllPoints()
			frame.Icon:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)
			frame.Icon:SetSize(size, size)
	    end
    end
end

local function StyleUpdateRewards(self)
    local missionButtons = self.MissionTab.MissionList.listScroll.buttons;
    for i = 1, #missionButtons do
    	PLUGIN:ApplyItemButtonStyle(missionButtons[i])
        StyleListButtons(missionButtons[i].Rewards)
    end
    StyleRewardButtons(self.MissionTab.MissionPage.RewardsFrame.Rewards);
    StyleRewardButtons(self.MissionComplete.BonusRewards.Rewards);
end

local function LoadGarrisonStyle()
	if PLUGIN.db.blizzard.enable ~= true then
		return 
	end

	PLUGIN:ApplyWindowStyle(GarrisonMissionFrame, true)
	PLUGIN:ApplyWindowStyle(GarrisonBuildingFrame, true)
	PLUGIN:ApplyWindowStyle(GarrisonLandingPage, true)

	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab1)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab2)

	GarrisonBuildingFrameFollowers:RemoveTextures()
	GarrisonBuildingFrameFollowers:SetStylePanel("Default", 'Inset', true, 1, -5, -5)
	GarrisonBuildingFrameFollowers:ClearAllPoints()
	GarrisonBuildingFrameFollowers:SetPoint("LEFT", GarrisonBuildingFrame, "LEFT", 10, 0)
	GarrisonBuildingFrame.BuildingList:RemoveTextures()
	GarrisonBuildingFrame.BuildingList:SetStylePanel("Fixed", 'Inset')
	GarrisonBuildingFrame.TownHallBox:RemoveTextures()
	GarrisonBuildingFrame.TownHallBox:SetStylePanel("Fixed", 'Inset')
	GarrisonBuildingFrame.InfoBox:RemoveTextures()
	GarrisonBuildingFrame.InfoBox:SetStylePanel("Fixed", 'Inset')
	--PLUGIN:ApplyTabStyle(GarrisonBuildingFrame.BuildingList.Tab1)
	GarrisonBuildingFrame.BuildingList.Tab1:GetNormalTexture().SetAtlas = function() return end
	GarrisonBuildingFrame.BuildingList.Tab1:RemoveTextures(true)
	GarrisonBuildingFrame.BuildingList.Tab1:SetStylePanel("Button", false, 1, -4, -10)
	--PLUGIN:ApplyTabStyle(GarrisonBuildingFrame.BuildingList.Tab2)
	GarrisonBuildingFrame.BuildingList.Tab2:GetNormalTexture().SetAtlas = function() return end
	GarrisonBuildingFrame.BuildingList.Tab2:RemoveTextures(true)
	GarrisonBuildingFrame.BuildingList.Tab2:SetStylePanel("Button", false, 1, -4, -10)
	--PLUGIN:ApplyTabStyle(GarrisonBuildingFrame.BuildingList.Tab3)
	GarrisonBuildingFrame.BuildingList.Tab3:GetNormalTexture().SetAtlas = function() return end
	GarrisonBuildingFrame.BuildingList.Tab3:RemoveTextures(true)
	GarrisonBuildingFrame.BuildingList.Tab3:SetStylePanel("Button", false, 1, -4, -10)
	GarrisonBuildingFrame.BuildingList.MaterialFrame:RemoveTextures()
	GarrisonBuildingFrame.BuildingList.MaterialFrame:SetStylePanel("Default", "Inset", true, 1, -5, -7)
	GarrisonBuildingFrameTutorialButton:Die()

	StyleUpdateRewards(GarrisonMissionFrame)

	GarrisonLandingPage.FollowerTab:RemoveTextures()
	GarrisonLandingPage.FollowerTab.AbilitiesFrame:RemoveTextures()
	GarrisonLandingPage.FollowerTab:SetStylePanel("Default", "ModelBorder")

	GarrisonLandingPage.FollowerTab.Panel:ClearAllPoints()
	GarrisonLandingPage.FollowerTab.Panel:SetPoint("TOPLEFT", GarrisonLandingPage.FollowerList.SearchBox, "TOPRIGHT", 10, 6)
	GarrisonLandingPage.FollowerTab.Panel:SetPoint("BOTTOMRIGHT", GarrisonLandingPage, "BOTTOMRIGHT", -38, 30)

	GarrisonLandingPage.FollowerList:RemoveTextures()
	GarrisonLandingPage.FollowerList:SetStylePanel("Default", 'Inset', false, 4, 0, 0)

	PLUGIN:ApplyTabStyle(GarrisonLandingPageTab1, nil, 10, 4)
	PLUGIN:ApplyTabStyle(GarrisonLandingPageTab2, nil, 10, 4)

	local a1, p, a2, x, y = GarrisonLandingPageTab1:GetPoint()
	GarrisonLandingPageTab1:SetPoint(a1, p, a2, x, (y - 15))

	GarrisonLandingPageReportList:RemoveTextures()
	GarrisonLandingPageReportList:SetStylePanel("Default", 'Inset', false, 4, 0, 0)

	GarrisonLandingPageReport.Available:RemoveTextures(true)
	GarrisonLandingPageReport.Available:SetStylePanel("Button")
	GarrisonLandingPageReport.Available:GetNormalTexture().SetAtlas = function() return end

	GarrisonLandingPageReport.InProgress:RemoveTextures(true)
	GarrisonLandingPageReport.InProgress:SetStylePanel("Button")
	GarrisonLandingPageReport.InProgress:GetNormalTexture().SetAtlas = function() return end

	GarrisonMissionFrameMissions:RemoveTextures()
	GarrisonMissionFrameMissions:SetStylePanel("Fixed", "Inset")
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:RemoveTextures()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame:SetStylePanel("Default", 'Halftone', false, 4, 0, 0)
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.Stage:RemoveTextures()
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.Stage:SetStylePanel("Fixed", "Model")
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:RemoveTextures(true)
	GarrisonMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton:SetStylePanel("Button")

	GarrisonMissionFrameMissionsListScrollFrame:RemoveTextures()
	PLUGIN:ApplyScrollFrameStyle(GarrisonMissionFrameMissionsListScrollFrame)

	PLUGIN:ApplyTabStyle(GarrisonMissionFrameMissionsTab1, nil, 10, 4)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameMissionsTab2, nil, 10, 4)
	local a1, p, a2, x, y = GarrisonMissionFrameMissionsTab1:GetPoint()
	GarrisonMissionFrameMissionsTab1:SetPoint(a1, p, a2, x, (y + 8))

	GarrisonMissionFrameMissions.MaterialFrame:RemoveTextures()
	GarrisonMissionFrameMissions.MaterialFrame:SetStylePanel("Default", "Inset", true, 1, -3, -3)

	GarrisonMissionFrame.FollowerTab:RemoveTextures()
	GarrisonMissionFrame.FollowerTab:SetStylePanel("Fixed", "ModelBorder")

	GarrisonMissionFrame.FollowerTab.ItemWeapon:RemoveTextures()
	StyleListItem(GarrisonMissionFrame.FollowerTab.ItemWeapon)
	GarrisonMissionFrame.FollowerTab.ItemArmor:RemoveTextures()
	StyleListItem(GarrisonMissionFrame.FollowerTab.ItemArmor)

	GarrisonMissionFrame.MissionTab:RemoveTextures()
	GarrisonMissionFrame.MissionTab.MissionPage:RemoveTextures()
	GarrisonMissionFrame.MissionTab.MissionPage:SetStylePanel("Default", 'Paper', false, 4, 0, 0)
	GarrisonMissionFrame.MissionTab.MissionPage:SetPanelColor("special")


	GarrisonMissionFrame.MissionTab.MissionPage.Panel:ClearAllPoints()
	GarrisonMissionFrame.MissionTab.MissionPage.Panel:SetPoint("TOPLEFT", GarrisonMissionFrame.MissionTab.MissionPage, "TOPLEFT", 0, 4)
	GarrisonMissionFrame.MissionTab.MissionPage.Panel:SetPoint("BOTTOMRIGHT", GarrisonMissionFrame.MissionTab.MissionPage, "BOTTOMRIGHT", 0, -20)

	GarrisonMissionFrame.MissionTab.MissionPage.Stage:RemoveTextures()
	AddFadeBanner(GarrisonMissionFrame.MissionTab.MissionPage.Stage)
	GarrisonMissionFrame.MissionTab.MissionPage.StartMissionButton:RemoveTextures(true)
	GarrisonMissionFrame.MissionTab.MissionPage.StartMissionButton:SetStylePanel("Button")

	GarrisonMissionFrameFollowers:RemoveTextures()
	GarrisonMissionFrameFollowers:SetStylePanel("Default", 'Inset', false, 4, 0, 0)
	GarrisonMissionFrameFollowers.MaterialFrame:RemoveTextures()
	GarrisonMissionFrameFollowers.MaterialFrame:SetStylePanel("Default", "Inset", true, 1, -5, -7)
	PLUGIN:ApplyEditBoxStyle(GarrisonMissionFrameFollowers.SearchBox)

	--GarrisonMissionFrameFollowersListScrollFrame

	local mComplete = GarrisonMissionFrame.MissionComplete;
	local mStage = mComplete.Stage;
	local mFollowers = mStage.FollowersFrame;

	mComplete:RemoveTextures()
	mComplete:SetStylePanel("Default", 'Paper', false, 4, 0, 0)
	mComplete:SetPanelColor("special")
	mStage:RemoveTextures()
	mStage.MissionInfo:RemoveTextures()

	if(mFollowers.Follower1 and mFollowers.Follower1.PortraitFrame) then
		StyleFollowerPortrait(mFollowers.Follower1.PortraitFrame)
	end
	if(mFollowers.Follower2 and mFollowers.Follower2.PortraitFrame) then
		StyleFollowerPortrait(mFollowers.Follower2.PortraitFrame)
	end
	if(mFollowers.Follower3 and mFollowers.Follower3.PortraitFrame) then
		StyleFollowerPortrait(mFollowers.Follower3.PortraitFrame)
	end

	AddFadeBanner(mStage)
	mComplete.NextMissionButton:RemoveTextures(true)
	mComplete.NextMissionButton:SetStylePanel("Button")

	--GarrisonMissionFrame.MissionComplete.BonusRewards:RemoveTextures()
	--GarrisonMissionFrame.MissionComplete.BonusRewards:SetStylePanel("Fixed", "Model")

	--print("Test")
	local display = GarrisonCapacitiveDisplayFrame
	display:RemoveTextures(true)
	GarrisonCapacitiveDisplayFrameInset:RemoveTextures(true)
	display.CapacitiveDisplay:RemoveTextures(true)
	display.CapacitiveDisplay:SetStylePanel("Default", 'Transparent')
	display.CapacitiveDisplay.ShipmentIconFrame:SetStylePanel("Slot", true, 2, 0, 0, 0.5)
	display.CapacitiveDisplay.ShipmentIconFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	display:SetStylePanel("Default", 'Action')

	--print("Test")
	local reagents = display.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i]) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetStylePanel("Slot", true, 2, 0, 0, 0.5)
        	if(reagents[i].Icon) then
				reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			end
		end
    end

    hooksecurefunc("GarrisonCapacitiveDisplayFrame_Update", _hook_ReagentUpdate)
    hooksecurefunc("GarrisonFollowerList_Update", _hook_GarrisonFollowerListUpdate)
    hooksecurefunc("GarrisonMissionFrame_SetFollowerPortrait", _hook_GarrisonMissionFrame_SetFollowerPortrait)
    hooksecurefunc("GarrisonMissionComplete_SetFollowerLevel", _hook_GarrisonMissionComplete_SetFollowerLevel)
    hooksecurefunc("GarrisonFollowerPage_ShowFollower", _hook_GarrisonFollowerPage_ShowFollower)
    hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", StyleListItem)
    hooksecurefunc("GarrisonBuildingTab_Select", _hook_GarrisonBuildingListUpdate)
    hooksecurefunc("GarrisonBuildingList_SelectTab", _hook_GarrisonBuildingListUpdate)
    hooksecurefunc("GarrisonBuildingInfoBox_ShowFollowerPortrait", _hook_GarrisonBuildingInfoBoxFollowerPortrait)
    hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", _hook_GarrisonFollowerTooltipTemplate_SetGarrisonFollower)

 	--print("Test")
	if(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton) then
		GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:RemoveTextures(true)
		GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:SetStylePanel("Button")
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