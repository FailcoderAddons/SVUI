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
ITEMSOCKETING STYLER
##########################################################
]]--
local function ItemSocketStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.socket ~= true then return end 
	ItemSocketingFrame:RemoveTextures()
	ItemSocketingFrame:SetPanelTemplate("Action")
	ItemSocketingFrameInset:Die()
	ItemSocketingScrollFrame:RemoveTextures()
	ItemSocketingScrollFrame:SetPanelTemplate("Inset", true)
	STYLE:ApplyScrollFrameStyle(ItemSocketingScrollFrameScrollBar, 2)
	for j = 1, MAX_NUM_SOCKETS do 
		local i = _G[("ItemSocketingSocket%d"):format(j)];
		local C = _G[("ItemSocketingSocket%dBracketFrame"):format(j)];
		local D = _G[("ItemSocketingSocket%dBackground"):format(j)];
		local E = _G[("ItemSocketingSocket%dIconTexture"):format(j)];
		i:RemoveTextures()
		i:SetButtonTemplate()
		i:SetFixedPanelTemplate("Button", true)
		C:Die()
		D:Die()
		E:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		E:FillInner()
	end 
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
	ItemSocketingFramePortrait:Die()
	ItemSocketingSocketButton:ClearAllPoints()
	ItemSocketingSocketButton:Point("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -5, 5)
	ItemSocketingSocketButton:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(ItemSocketingFrameCloseButton)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_ItemSocketingUI",ItemSocketStyle)