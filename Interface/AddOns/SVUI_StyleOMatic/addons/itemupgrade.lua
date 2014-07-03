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
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
ITEMUPGRADE UI STYLER
##########################################################
]]--
local function ItemUpgradeStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.itemUpgrade ~= true then
		 return 
	end;
	ItemUpgradeFrame:Formula409()
	ItemUpgradeFrame:SetPanelTemplate("Action")
	MOD:ApplyCloseButtonStyle(ItemUpgradeFrameCloseButton)
	ItemUpgradeFrameUpgradeButton:SetButtonTemplate()
	ItemUpgradeFrame.ItemButton:Formula409()
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
	ItemUpgradeFrameMoneyFrame:Formula409()
	ItemUpgradeFrame.FinishedGlow:MUNG()
	ItemUpgradeFrame.ButtonFrame:DisableDrawLayer('BORDER')
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ItemUpgradeUI",ItemUpgradeStyle)