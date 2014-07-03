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
WORLDSTATE STYLER
##########################################################
]]--
local function WorldStateStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.bgscore ~= true then return end;
	WorldStateScoreScrollFrame:Formula409()
	WorldStateScoreFrame:Formula409()
	WorldStateScoreFrame:SetPanelTemplate("Halftone")
	MOD:ApplyCloseButtonStyle(WorldStateScoreFrameCloseButton)
	MOD:ApplyScrollStyle(WorldStateScoreScrollFrameScrollBar)
	WorldStateScoreFrameInset:SetAlpha(0)
	WorldStateScoreFrameLeaveButton:SetButtonTemplate()
	for b = 1, 3 do 
		MOD:ApplyTabStyle(_G["WorldStateScoreFrameTab"..b])
	end 
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(WorldStateStyle)