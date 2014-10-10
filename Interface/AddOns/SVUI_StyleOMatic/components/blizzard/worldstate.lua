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
WORLDSTATE STYLER
##########################################################
]]--
local function WorldStateStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.bgscore ~= true then return end 
	WorldStateScoreScrollFrame:RemoveTextures()
	WorldStateScoreFrame:RemoveTextures()
	WorldStateScoreFrame:SetPanelTemplate("Halftone")
	STYLE:ApplyCloseButtonStyle(WorldStateScoreFrameCloseButton)
	STYLE:ApplyScrollFrameStyle(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrameInset:SetAlpha(0)
	WorldStateScoreFrameLeaveButton:SetButtonTemplate()
	for b = 1, 3 do 
		STYLE:ApplyTabStyle(_G["WorldStateScoreFrameTab"..b])
	end 
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(WorldStateStyle)