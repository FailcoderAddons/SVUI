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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
TIMEMANAGER STYLER
##########################################################
]]--
local function TimeManagerStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.timemanager ~= true then
		 return 
	end 
	
	STYLE:ApplyWindowStyle(TimeManagerFrame, true)

	STYLE:ApplyCloseButtonStyle(TimeManagerFrameCloseButton)
	TimeManagerFrameInset:Die()
	STYLE:ApplyDropdownStyle(TimeManagerAlarmHourDropDown, 80)
	STYLE:ApplyDropdownStyle(TimeManagerAlarmMinuteDropDown, 80)
	STYLE:ApplyDropdownStyle(TimeManagerAlarmAMPMDropDown, 80)
	TimeManagerAlarmMessageEditBox:SetEditboxTemplate()
	TimeManagerAlarmEnabledButton:SetCheckboxTemplate(true)
	TimeManagerMilitaryTimeCheck:SetCheckboxTemplate(true)
	TimeManagerLocalTimeCheck:SetCheckboxTemplate(true)
	TimeManagerStopwatchFrame:RemoveTextures()
	TimeManagerStopwatchCheck:SetFixedPanelTemplate("Default")
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	TimeManagerStopwatchCheck:GetNormalTexture():FillInner()
	local sWatch = TimeManagerStopwatchCheck:CreateTexture(nil, "OVERLAY")
	sWatch:SetTexture(1, 1, 1, 0.3)
	sWatch:Point("TOPLEFT", TimeManagerStopwatchCheck, 2, -2)
	sWatch:Point("BOTTOMRIGHT", TimeManagerStopwatchCheck, -2, 2)
	TimeManagerStopwatchCheck:SetHighlightTexture(sWatch)

	StopwatchFrame:RemoveTextures()
	StopwatchFrame:SetBasicPanel()
	StopwatchFrame.Panel:Point("TOPLEFT", 0, -17)
	StopwatchFrame.Panel:Point("BOTTOMRIGHT", 0, 2)

	StopwatchTabFrame:RemoveTextures()
	
	STYLE:ApplyCloseButtonStyle(StopwatchCloseButton)
	STYLE:ApplyPaginationStyle(StopwatchPlayPauseButton)
	STYLE:ApplyPaginationStyle(StopwatchResetButton)
	StopwatchPlayPauseButton:Point("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
	StopwatchResetButton:Point("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_TimeManager",TimeManagerStyle)