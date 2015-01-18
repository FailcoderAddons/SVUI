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
ITEMUPGRADE UI PLUGINR
##########################################################
]]--
local function ItemUpgradeStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.itemUpgrade ~= true then
		 return 
	end 
	
	PLUGIN:ApplyWindowStyle(ItemUpgradeFrame, true)

	PLUGIN:ApplyCloseButtonStyle(ItemUpgradeFrameCloseButton)
	ItemUpgradeFrameUpgradeButton:RemoveTextures()
	ItemUpgradeFrameUpgradeButton:SetStylePanel("Button")
	ItemUpgradeFrame.ItemButton:RemoveTextures()
	ItemUpgradeFrame.ItemButton:SetStylePanel("Slot")
	ItemUpgradeFrame.ItemButton.IconTexture:SetAllPointsIn()
	hooksecurefunc('ItemUpgradeFrame_Update', function()
		if GetItemUpgradeItemInfo() then
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
			ItemUpgradeFrame.ItemButton.IconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		else
			ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
		end 
	end)
	ItemUpgradeFrameMoneyFrame:RemoveTextures()
	ItemUpgradeFrame.FinishedGlow:Die()
	ItemUpgradeFrame.ButtonFrame:DisableDrawLayer('BORDER')
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ItemUpgradeUI",ItemUpgradeStyle)