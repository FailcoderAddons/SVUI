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

local function StyleFollowerPortrait(frame)
	frame.PortraitRing:SetTexture(RING_TEXTURE)
	frame.PortraitRingQuality:SetTexture('')
	frame.LevelBorder:SetTexture('')
	if(not frame.LevelCallout) then
		frame.LevelCallout = frame:CreateTexture(nil, 'BORDER', 4)
		frame.LevelCallout:SetAllPoints(frame)
		frame.LevelCallout:SetTexture(LVL_TEXTURE)
		frame.LevelBorder:SetDrawLayer('OVERLAY')
	end
end

local _hook_ReagentUpdate = function(self)
	local reagents = GarrisonCapacitiveDisplayFrame.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i] and (not reagents[i].Panel)) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetSlotTemplate(true, 2, 0, 0, 0.5)
        	if(reagents[i].Icon) then
				reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
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
	            button:SetPanelTemplate('Blackout', true, 1, 0, 0)
	            if(button.PortraitFrame) then
	            	StyleFollowerPortrait(button.PortraitFrame)
				end
				if(button.XPBar) then
					button.XPBar:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
					button.XPBar:SetGradient('HORIZONTAL', 0.5, 0, 1, 1, 0, 1)
				end
	        end
	        if(button.PortraitFrame) then
		        if (follower.isCollected) then
	            	local color = ITEM_QUALITY_COLORS[follower.quality];
					button.PortraitFrame.PortraitRing:SetVertexColor(color.r, color.g, color.b)
				else
					button.PortraitFrame.PortraitRing:SetVertexColor(0.25, 0.25, 0.25)
				end
			end
	    end
    end
end

local _hook_GarrisonMissionFrame_SetFollowerPortrait = function(portraitFrame, followerInfo)
	StyleFollowerPortrait(portraitFrame)
	local color = ITEM_QUALITY_COLORS[followerInfo.quality];
	portraitFrame.PortraitRing:SetVertexColor(color.r, color.g, color.b)
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
		self.XPBar:SetFixedPanelTemplate("Bar")
	end
 
    for i=1, #self.AbilitiesFrame.Abilities do
        local abilityFrame = self.AbilitiesFrame.Abilities[i];
        abilityFrame.IconButton.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9);
        if(not abilityFrame.IconButton.Panel) then
			abilityFrame.IconButton:SetFixedPanelTemplate("Slot", true, 4)
		end
    end
end

local _hook_GarrisonMissionFrame_SetItemRewardDetails = function(self)
    if(self.Icon and (not self.Panel)) then
    	local size = self:GetHeight() - 4
    	local texture = self.Icon:GetTexture()
		self:RemoveTextures()
    	self:SetSlotTemplate(true, 2, 0, 0, 0.5)
    	self.Icon:SetTexture(texture)
		self.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		self.Icon:ClearAllPoints()
		self.Icon:SetPoint("TOPLEFT", self, "TOPLEFT", 2, -2)
		self.Icon:SetSize(size, size)
    end
end

local function StyleRewardButtons(rewardButtons)
    for i = 1, #rewardButtons do
        local frame = rewardButtons[i];
        _hook_GarrisonMissionFrame_SetItemRewardDetails(frame);
    end
end

local function StyleListButtons(listButtons)
    for i = 1, #listButtons do
        local frame = listButtons[i];
        if(frame.Icon and (not frame.Panel)) then
	    	local size = frame:GetHeight() - 6
	    	local texture = frame.Icon:GetTexture()
			frame:RemoveTextures()
	    	frame:SetFixedPanelTemplate('Blackout', true, 3)
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
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab1)
	PLUGIN:ApplyTabStyle(GarrisonMissionFrameTab2)

	StyleUpdateRewards(GarrisonMissionFrame)

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

	--GarrisonMissionFrameFollowersListScrollFrame

	local mComplete = GarrisonMissionFrame.MissionComplete;
	local mStage = mComplete.Stage;
	local mFollowers = mStage.FollowersFrame;

	mComplete:RemoveTextures()
	mComplete:SetPanelTemplate('Paper', false, 4, 0, 0)
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
	mComplete.NextMissionButton:SetButtonTemplate()

	--GarrisonMissionFrame.MissionComplete.BonusRewards:RemoveTextures()
	--GarrisonMissionFrame.MissionComplete.BonusRewards:SetFixedPanelTemplate("Model")

	--print("Test")
	local display = GarrisonCapacitiveDisplayFrame
	display:RemoveTextures(true)
	GarrisonCapacitiveDisplayFrameInset:RemoveTextures(true)
	display.CapacitiveDisplay:RemoveTextures(true)
	display.CapacitiveDisplay:SetPanelTemplate('Transparent')
	display.CapacitiveDisplay.ShipmentIconFrame:SetSlotTemplate(true, 2, 0, 0, 0.5)
	display.CapacitiveDisplay.ShipmentIconFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	display:SetPanelTemplate('Action')

	--print("Test")
	local reagents = display.CapacitiveDisplay.Reagents;
    for i = 1, #reagents do
    	if(reagents[i]) then
    		reagents[i]:RemoveTextures()
        	reagents[i]:SetSlotTemplate(true, 2, 0, 0, 0.5)
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
    hooksecurefunc("GarrisonMissionFrame_SetItemRewardDetails", _hook_GarrisonMissionFrame_SetItemRewardDetails)

 	--print("Test")
	if(GarrisonCapacitiveDisplayFrame.StartWorkOrderButton) then
		GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:RemoveTextures(true)
		GarrisonCapacitiveDisplayFrame.StartWorkOrderButton:SetButtonTemplate()
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