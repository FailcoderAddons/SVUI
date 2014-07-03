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
REFORGING STYLER
##########################################################
]]--
local function ReforgingStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.reforge ~= true then return end;
	ReforgingFrame:Formula409()
	ReforgingFrame:SetPanelTemplate("Action")
	ReforgingFrame.ButtonFrame:Formula409()
	ReforgingFrameReforgeButton:ClearAllPoints()
	ReforgingFrameReforgeButton:Point("LEFT", ReforgingFrameRestoreButton, "RIGHT", 2, 0)
	ReforgingFrameReforgeButton:Point("BOTTOMRIGHT", -3, 3)
	ReforgingFrame.RestoreMessage:SetTextColor(1, 1, 1)
	ReforgingFrameRestoreButton:SetButtonTemplate()
	ReforgingFrameReforgeButton:SetButtonTemplate()
	ReforgingFrame.ItemButton:Formula409()
	ReforgingFrame.ItemButton:SetSlotTemplate(true)
	ReforgingFrame.ItemButton.IconTexture:FillInner()
	hooksecurefunc("ReforgingFrame_Update", function(k)
		local w, x, u, y, z, A = GetReforgeItemInfo()
		if x then
			 ReforgingFrame.ItemButton.IconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		else
			 ReforgingFrame.ItemButton.IconTexture:SetTexture(nil)
		end 
	end)
	MOD:ApplyCloseButtonStyle(ReforgingFrameCloseButton)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ReforgingUI",ReforgingStyle)