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
RAID PLUGINRS
##########################################################
]]--
local function RaidUIStyle()
	if InCombatLockdown() then return end 
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.raid ~= true then return end 
	for _,group in pairs(RaidGroupList)do 
		if _G[group] then
			_G[group]:RemoveTextures()
			for i = 1, 5 do
				local name = ("%sSlot%d"):format(group, i)
				local slot = _G[name]
				if(slot) then
					slot:RemoveTextures()
					slot:SetStylePanel("Frame", "Inset", true)
				end
			end
		end 
	end
end 

local function RaidInfoStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.nonraid ~= true then
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
			_G[RaidInfoFrameList[g]]:SetStylePanel("Button")
		end 
	end

	RaidInfoScrollFrame:RemoveTextures()
	RaidInfoFrame:SetStylePanel("Frame", 'Transparent')
	RaidInfoFrame.Panel:SetPointToScale("TOPLEFT", RaidInfoFrame, "TOPLEFT")
	RaidInfoFrame.Panel:SetPointToScale("BOTTOMRIGHT", RaidInfoFrame, "BOTTOMRIGHT")

	PLUGIN:ApplyCloseButtonStyle(RaidInfoCloseButton, RaidInfoFrame)
	PLUGIN:ApplyScrollFrameStyle(RaidInfoScrollFrameScrollBar)
	
	if RaidFrameRaidBrowserButton then RaidFrameRaidBrowserButton:SetStylePanel("Button") end
	RaidFrameAllAssistCheckButton:SetStylePanel("Checkbox", true)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_RaidUI", RaidUIStyle)
PLUGIN:SaveCustomStyle(RaidInfoStyle)