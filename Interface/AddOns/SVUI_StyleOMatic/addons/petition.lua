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
PETITIONFRAME STYLER
##########################################################
]]--
local function PetitionFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.petition ~= true then
		return 
	end;
	PetitionFrame:Formula409(true)
	PetitionFrame:SetFixedPanelTemplate("Transparent", true)
	PetitionFrameInset:MUNG()
	PetitionFrameSignButton:SetButtonTemplate()
	PetitionFrameRequestButton:SetButtonTemplate()
	PetitionFrameRenameButton:SetButtonTemplate()
	PetitionFrameCancelButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(PetitionFrameCloseButton)
	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)
	for g = 1, 9 do
		_G["PetitionFrameMemberName"..g]:SetTextColor(1, 1, 1)
	end;
	PetitionFrameInstructions:SetTextColor(1, 1, 1)
	PetitionFrameRenameButton:Point("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:Point("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(PetitionFrameStyle)