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
ITEMUPGRADE UI STYLER
##########################################################
]]--
local function ItemUpgradeStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.itemUpgrade ~= true then
		 return 
	end 
	
	STYLE:ApplyWindowStyle(ItemUpgradeFrame, true)

	STYLE:ApplyCloseButtonStyle(ItemUpgradeFrameCloseButton)
	ItemUpgradeFrameUpgradeButton:RemoveTextures()
	ItemUpgradeFrameUpgradeButton:SetButtonTemplate()
	ItemUpgradeFrame.ItemButton:RemoveTextures()
	ItemUpgradeFrame.ItemButton:SetSlotTemplate(true)
	ItemUpgradeFrame.ItemButton.IconTexture:FillInner()
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
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_ItemUpgradeUI",ItemUpgradeStyle)