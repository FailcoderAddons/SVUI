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
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
PETSTABLE PLUGINR
##########################################################
]]--
local function PetStableStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.stable ~= true then return end 
	PetStableFrame:RemoveTextures()
	PetStableFrameInset:RemoveTextures()
	PetStableLeftInset:RemoveTextures()
	PetStableBottomInset:RemoveTextures()
	PetStableFrame:SetStylePanel("Frame", "Composite1")
	PetStableFrameInset:SetStylePanel("!_Frame", 'Inset')
	PLUGIN:ApplyCloseButtonStyle(PetStableFrameCloseButton)
	PetStablePrevPageButton:SetStylePanel("Button")
	PetStableNextPageButton:SetStylePanel("Button")
	PLUGIN:ApplyPaginationStyle(PetStablePrevPageButton)
	PLUGIN:ApplyPaginationStyle(PetStableNextPageButton)
	for j = 1, NUM_PET_ACTIVE_SLOTS do
		 PLUGIN:ApplyItemButtonStyle(_G['PetStableActivePet'..j], true)
	end 
	for j = 1, NUM_PET_STABLE_SLOTS do
		 PLUGIN:ApplyItemButtonStyle(_G['PetStableStabledPet'..j], true)
	end 
	PetStableSelectedPetIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(PetStableStyle)