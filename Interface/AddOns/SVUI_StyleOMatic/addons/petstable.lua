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
PETSTABLE STYLER
##########################################################
]]--
local function PetStableStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.stable ~= true then return end;
	PetStableFrame:Formula409()
	PetStableFrameInset:Formula409()
	PetStableLeftInset:Formula409()
	PetStableBottomInset:Formula409()
	PetStableFrame:SetPanelTemplate("Halftone")
	PetStableFrameInset:SetFixedPanelTemplate('Inset')
	MOD:ApplyCloseButtonStyle(PetStableFrameCloseButton)
	PetStablePrevPageButton:SetButtonTemplate()
	PetStableNextPageButton:SetButtonTemplate()
	MOD:ApplyPaginationStyle(PetStablePrevPageButton)
	MOD:ApplyPaginationStyle(PetStableNextPageButton)
	for j = 1, NUM_PET_ACTIVE_SLOTS do
		 MOD:ApplyLinkButtonStyle(_G['PetStableActivePet'..j], true)
	end;
	for j = 1, NUM_PET_STABLE_SLOTS do
		 MOD:ApplyLinkButtonStyle(_G['PetStableStabledPet'..j], true)
	end;
	PetStableSelectedPetIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(PetStableStyle)