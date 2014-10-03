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
PETSTABLE STYLER
##########################################################
]]--
local function PetStableStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.stable ~= true then return end 
	PetStableFrame:RemoveTextures()
	PetStableFrameInset:RemoveTextures()
	PetStableLeftInset:RemoveTextures()
	PetStableBottomInset:RemoveTextures()
	PetStableFrame:SetPanelTemplate("Halftone")
	PetStableFrameInset:SetFixedPanelTemplate('Inset')
	STYLE:ApplyCloseButtonStyle(PetStableFrameCloseButton)
	PetStablePrevPageButton:SetButtonTemplate()
	PetStableNextPageButton:SetButtonTemplate()
	STYLE:ApplyPaginationStyle(PetStablePrevPageButton)
	STYLE:ApplyPaginationStyle(PetStableNextPageButton)
	for j = 1, NUM_PET_ACTIVE_SLOTS do
		 STYLE:ApplyItemButtonStyle(_G['PetStableActivePet'..j], true)
	end 
	for j = 1, NUM_PET_STABLE_SLOTS do
		 STYLE:ApplyItemButtonStyle(_G['PetStableStabledPet'..j], true)
	end 
	PetStableSelectedPetIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(PetStableStyle)