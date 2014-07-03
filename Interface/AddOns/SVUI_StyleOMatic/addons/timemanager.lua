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
TIMEMANAGER STYLER
##########################################################
]]--
local function TimeManagerStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.timemanager ~= true then
		 return 
	end;
	TimeManagerFrame:Formula409()
	TimeManagerFrame:SetPanelTemplate("Action", false)
	MOD:ApplyCloseButtonStyle(TimeManagerFrameCloseButton)
	TimeManagerFrameInset:MUNG()
	MOD:ApplyDropdownStyle(TimeManagerAlarmHourDropDown, 80)
	MOD:ApplyDropdownStyle(TimeManagerAlarmMinuteDropDown, 80)
	MOD:ApplyDropdownStyle(TimeManagerAlarmAMPMDropDown, 80)
	TimeManagerAlarmMessageEditBox:SetEditboxTemplate()
	TimeManagerAlarmEnabledButton:SetCheckboxTemplate(true)
	TimeManagerMilitaryTimeCheck:SetCheckboxTemplate(true)
	TimeManagerLocalTimeCheck:SetCheckboxTemplate(true)
	TimeManagerStopwatchFrame:Formula409()
	TimeManagerStopwatchCheck:SetFixedPanelTemplate("Default")
	TimeManagerStopwatchCheck:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	TimeManagerStopwatchCheck:GetNormalTexture():FillInner()
	local sWatch = TimeManagerStopwatchCheck:CreateTexture(nil, "OVERLAY")
	sWatch:SetTexture(1, 1, 1, 0.3)
	sWatch:Point("TOPLEFT", TimeManagerStopwatchCheck, 2, -2)
	sWatch:Point("BOTTOMRIGHT", TimeManagerStopwatchCheck, -2, 2)
	TimeManagerStopwatchCheck:SetHighlightTexture(sWatch)
	StopwatchFrame:Formula409()
	StopwatchFrame:SetPanelTemplate("Transparent", true)
	StopwatchFrame.Panel:Point("TOPLEFT", 0, -17)
	StopwatchFrame.Panel:Point("BOTTOMRIGHT", 0, 2)
	StopwatchTabFrame:Formula409()
	MOD:ApplyCloseButtonStyle(StopwatchCloseButton)
	MOD:ApplyPaginationStyle(StopwatchPlayPauseButton)
	MOD:ApplyPaginationStyle(StopwatchResetButton)
	StopwatchPlayPauseButton:Point("RIGHT", StopwatchResetButton, "LEFT", -4, 0)
	StopwatchResetButton:Point("BOTTOMRIGHT", StopwatchFrame, "BOTTOMRIGHT", -4, 6)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_TimeManager",TimeManagerStyle)