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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose("SVStyle");
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
	if InCombatLockdown() then return end;
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.raid ~= true then return end;
	for _,group in pairs(RaidGroupList)do 
		if not _G[group] then print(group) end;
		if _G[group] then
			_G[group]:Formula409()
		end 
	end;
	for e = 1, 8 do
		for f = 1, 5 do 
			_G["RaidGroup"..e.."Slot"..f]:Formula409()
			_G["RaidGroup"..e.."Slot"..f]:SetFixedPanelTemplate("Transparent", true)
		end 
	end 
end;

local function RaidInfoStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.nonraid ~= true then
		return 
	end;
	_G["RaidInfoFrame"]:Formula409()
	_G["RaidInfoInstanceLabel"]:Formula409()
	_G["RaidInfoIDLabel"]:Formula409()
	_G["RaidInfoScrollFrameScrollBarBG"]:MUNG()
	_G["RaidInfoScrollFrameScrollBarTop"]:MUNG()
	_G["RaidInfoScrollFrameScrollBarBottom"]:MUNG()
	_G["RaidInfoScrollFrameScrollBarMiddle"]:MUNG()
	for g = 1, #RaidInfoFrameList do 
		if _G[RaidInfoFrameList[g]] then
			_G[RaidInfoFrameList[g]]:SetButtonTemplate()
		end 
	end;
	RaidInfoScrollFrame:Formula409()
	RaidInfoFrame:SetPanelTemplate("Transparent", true)
	RaidInfoFrame.Panel:Point("TOPLEFT", RaidInfoFrame, "TOPLEFT")
	RaidInfoFrame.Panel:Point("BOTTOMRIGHT", RaidInfoFrame, "BOTTOMRIGHT")
	MOD:ApplyCloseButtonStyle(RaidInfoCloseButton, RaidInfoFrame)
	MOD:ApplyScrollStyle(RaidInfoScrollFrameScrollBar)
	RaidFrameRaidBrowserButton:SetButtonTemplate()
	RaidFrameAllAssistCheckButton:SetCheckboxTemplate(true)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_RaidUI",RaidUIStyle)
MOD:SaveCustomStyle(RaidInfoStyle)