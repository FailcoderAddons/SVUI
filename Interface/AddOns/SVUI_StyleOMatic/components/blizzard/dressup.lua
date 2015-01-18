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
DRESSUP PLUGINR
##########################################################
]]--
local function DressUpStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.dressingroom ~= true then
		 return 
	end

	DressUpFrame:SetSizeToScale(500, 600)
	PLUGIN:ApplyWindowStyle(DressUpFrame, true, true)

	DressUpModel:ClearAllPoints()
	DressUpModel:SetPointToScale("TOPLEFT", DressUpFrame, "TOPLEFT", 12, -76)
	DressUpModel:SetPointToScale("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -12, 36)

	DressUpModel:SetStylePanel("!_Frame", "Model")

	DressUpFrameCancelButton:SetPointToScale("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -12, 12)
	DressUpFrameCancelButton:SetStylePanel("Button")

	DressUpFrameResetButton:SetPointToScale("RIGHT", DressUpFrameCancelButton, "LEFT", -12, 0)
	DressUpFrameResetButton:SetStylePanel("Button")

	PLUGIN:ApplyCloseButtonStyle(DressUpFrameCloseButton, DressUpFrame.Panel)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(DressUpStyle)