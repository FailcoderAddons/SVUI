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
PETITIONFRAME PLUGINR
##########################################################
]]--
local function PetitionFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.petition ~= true then
		return 
	end

	PLUGIN:ApplyWindowStyle(PetitionFrame, nil, true)
	PetitionFrameInset:Die()

	PetitionFrameSignButton:SetStylePanel("Button")
	PetitionFrameRequestButton:SetStylePanel("Button")
	PetitionFrameRenameButton:SetStylePanel("Button")
	PetitionFrameCancelButton:SetStylePanel("Button")

	PLUGIN:ApplyCloseButtonStyle(PetitionFrameCloseButton)

	PetitionFrameCharterTitle:SetTextColor(1, 1, 0)
	PetitionFrameCharterName:SetTextColor(1, 1, 1)
	PetitionFrameMasterTitle:SetTextColor(1, 1, 0)
	PetitionFrameMasterName:SetTextColor(1, 1, 1)
	PetitionFrameMemberTitle:SetTextColor(1, 1, 0)

	for i=1, 9 do
		local frameName = ("PetitionFrameMemberName%d"):format(i)
		local frame = _G[frameName];
		if(frame) then
			frame:SetTextColor(1, 1, 1)
		end
	end 

	PetitionFrameInstructions:SetTextColor(1, 1, 1)
	
	PetitionFrameRenameButton:SetPointToScale("LEFT", PetitionFrameRequestButton, "RIGHT", 3, 0)
	PetitionFrameRenameButton:SetPointToScale("RIGHT", PetitionFrameCancelButton, "LEFT", -3, 0)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(PetitionFrameStyle)