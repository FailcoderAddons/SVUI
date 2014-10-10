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
DRESSUP STYLER
##########################################################
]]--
local function DressUpStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.dressingroom ~= true then
		 return 
	end

	STYLE:ApplyWindowStyle(DressUpFrame, true, true)

	DressUpModel:ClearAllPoints()
	DressUpModel:SetPoint("TOPLEFT", DressUpFrame, "TOPLEFT", 12, -76)
	DressUpModel:SetPoint("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -12, 36)

	DressUpModel:SetFixedPanelTemplate("ModelComic")

	DressUpFrameCancelButton:Point("BOTTOMRIGHT", DressUpFrame, "BOTTOMRIGHT", -12, 12)
	DressUpFrameCancelButton:SetButtonTemplate()

	DressUpFrameResetButton:Point("RIGHT", DressUpFrameCancelButton, "LEFT", -12, 0)
	DressUpFrameResetButton:SetButtonTemplate()

	STYLE:ApplyCloseButtonStyle(DressUpFrameCloseButton, DressUpFrame.Panel)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(DressUpStyle)