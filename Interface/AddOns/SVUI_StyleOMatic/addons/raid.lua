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
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local RaidGroupList = {
	"RaidGroup1",
	"RaidGroup2",
	"RaidGroup3",
	"RaidGroup4",
	"RaidGroup5",
	"RaidGroup6",
	"RaidGroup7",
	"RaidGroup8"
};

local RaidInfoFrameList = {
	"RaidFrameConvertToRaidButton",
	"RaidFrameRaidInfoButton",
	"RaidFrameNotInRaidRaidBrowserButton",
	"RaidInfoExtendButton",
	"RaidInfoCancelButton" 
};
--[[ 
########################################################## 
RAID STYLERS
##########################################################
]]--
local function RaidUIStyle()
	if InCombatLockdown() then return end 
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.raid ~= true then return end 
	for _,group in pairs(RaidGroupList)do 
		if _G[group] then
			_G[group]:RemoveTextures()
			for i = 1, 5 do
				local name = ("%sSlot%d"):format(group, i)
				local slot = _G[name]
				if(slot) then
					slot:RemoveTextures()
					slot:SetPanelTemplate("Inset", true)
				end
			end
		end 
	end
end 

local function RaidInfoStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.nonraid ~= true then
		return 
	end

	_G["RaidInfoFrame"]:RemoveTextures()
	_G["RaidInfoInstanceLabel"]:RemoveTextures()
	_G["RaidInfoIDLabel"]:RemoveTextures()
	_G["RaidInfoScrollFrameScrollBarBG"]:Die()
	_G["RaidInfoScrollFrameScrollBarTop"]:Die()
	_G["RaidInfoScrollFrameScrollBarBottom"]:Die()
	_G["RaidInfoScrollFrameScrollBarMiddle"]:Die()

	for g = 1, #RaidInfoFrameList do 
		if _G[RaidInfoFrameList[g]] then
			_G[RaidInfoFrameList[g]]:SetButtonTemplate()
		end 
	end

	RaidInfoScrollFrame:RemoveTextures()
	RaidInfoFrame:SetBasicPanel()
	RaidInfoFrame.Panel:Point("TOPLEFT", RaidInfoFrame, "TOPLEFT")
	RaidInfoFrame.Panel:Point("BOTTOMRIGHT", RaidInfoFrame, "BOTTOMRIGHT")

	STYLE:ApplyCloseButtonStyle(RaidInfoCloseButton, RaidInfoFrame)
	STYLE:ApplyScrollFrameStyle(RaidInfoScrollFrameScrollBar)
	
	RaidFrameRaidBrowserButton:SetButtonTemplate()
	RaidFrameAllAssistCheckButton:SetCheckboxTemplate(true)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_RaidUI", RaidUIStyle)
STYLE:SaveCustomStyle(RaidInfoStyle)