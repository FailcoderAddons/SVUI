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
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local GarrisonButtonList = {
	"StartWorkOrderButton"
};
--[[ 
########################################################## 
STYLE
##########################################################
]]--
local function LoadGarrisonStyle()
	if PLUGIN.db.blizzard.enable ~= true then
		return 
	end

	PLUGIN:ApplyScrollFrameStyle(GarrisonLandingPageListListScrollFrameScrollBar)
	PLUGIN:ApplyCloseButtonStyle(GarrisonLandingPage.CloseButton)
	GarrisonLandingPage.CloseButton:SetFrameStrata("HIGH")

	for i = 1, GarrisonLandingPageListListScrollFrameScrollChild:GetNumChildren() do
		local child = select(i, GarrisonLandingPageListListScrollFrameScrollChild:GetChildren())
		for j = 1, child:GetNumChildren() do
			local childC = select(j, child:GetChildren())
			childC.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		end
	end

	local display = GarrisonCapacitiveDisplayFrame
	display:RemoveTextures(true)
	GarrisonCapacitiveDisplayFrameInset:RemoveTextures(true)
	display.CapacitiveDisplay:RemoveTextures(true)
	display.CapacitiveDisplay:SetPanelTemplate('Transparent')
	display.CapacitiveDisplay.ShipmentIconFrame:SetSlotTemplate(true, 2, 0, 0, true)
	display.CapacitiveDisplay.ShipmentIconFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	display:SetPanelTemplate('Action')

	local reagents = display.Reagents;
    for i = 1, C_Garrison.GetNumShipmentReagents() do
        reagents[i]:SetSlotTemplate(true, 2, 0, 0, true)
		reagents[i].Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end

	for i = 1, #GarrisonButtonList do
		local button = GarrisonCapacitiveDisplayFrame[GarrisonButtonList[i]]
		if(button) then
			button:RemoveTextures(true)
			button:SetButtonTemplate()
		end
	end
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_GarrisonUI", LoadGarrisonStyle)