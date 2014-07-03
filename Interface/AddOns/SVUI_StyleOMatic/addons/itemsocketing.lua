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
ITEMSOCKETING STYLER
##########################################################
]]--
local function ItemSocketStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.socket ~= true then return end;
	ItemSocketingFrame:Formula409()
	ItemSocketingFrame:SetPanelTemplate("Action")
	ItemSocketingFrameInset:MUNG()
	ItemSocketingScrollFrame:Formula409()
	ItemSocketingScrollFrame:SetPanelTemplate("Inset", true)
	MOD:ApplyScrollStyle(ItemSocketingScrollFrameScrollBar, 2)
	for j = 1, MAX_NUM_SOCKETS do 
		local i = _G[("ItemSocketingSocket%d"):format(j)];
		local C = _G[("ItemSocketingSocket%dBracketFrame"):format(j)];
		local D = _G[("ItemSocketingSocket%dBackground"):format(j)];
		local E = _G[("ItemSocketingSocket%dIconTexture"):format(j)];
		i:Formula409()
		i:SetButtonTemplate()
		i:SetFixedPanelTemplate("Button", true)
		C:MUNG()
		D:MUNG()
		E:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		E:FillInner()
	end;
	hooksecurefunc("ItemSocketingFrame_Update", function()
		local max = GetNumSockets()
		for j=1, max do 
			local i = _G[("ItemSocketingSocket%d"):format(j)];
			local G = GetSocketTypes(j);
			local color = GEM_TYPE_INFO[G]
			i:SetBackdropColor(color.r, color.g, color.b, 0.15);
			i:SetBackdropBorderColor(color.r, color.g, color.b)
		end 
	end)
	ItemSocketingFramePortrait:MUNG()
	ItemSocketingSocketButton:ClearAllPoints()
	ItemSocketingSocketButton:Point("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -5, 5)
	ItemSocketingSocketButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(ItemSocketingFrameCloseButton)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ItemSocketingUI",ItemSocketStyle)