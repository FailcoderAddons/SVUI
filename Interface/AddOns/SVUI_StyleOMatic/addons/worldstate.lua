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
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
WORLDSTATE STYLER
##########################################################
]]--
local function WorldStateStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.bgscore ~= true then return end 
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