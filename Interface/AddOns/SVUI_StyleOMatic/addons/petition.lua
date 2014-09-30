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
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
PETITIONFRAME STYLER
##########################################################
]]--
local function PetitionFrameStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.petition ~= true then
		return 
	end 
	PetitionFrame:RemoveTextures(true)
	PetitionFrame:SetFixedPanelTemplate("Transparent", true)
	PetitionFrameInset:Die()
	PetitionFrameSignButton:SetButtonTemplate()
	PetitionFrameRequestButton:SetButtonTemplate()
	PetitionFrameRenameButton:SetButtonTemplate()
	PetitionFrameCancelButton:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(PetitionFrameCloseButton)
	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)
	for g = 1, 9 do
		_G["PetitionFrameMemberName"..g]:SetTextColor(1, 1, 1)
	end 
	PetitionFrameInstructions:SetTextColor(1, 1, 1)
	PetitionFrameRenameButton:Point("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:Point("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(PetitionFrameStyle)