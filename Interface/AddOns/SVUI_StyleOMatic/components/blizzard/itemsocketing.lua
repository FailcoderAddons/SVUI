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
ITEMSOCKETING PLUGINR
##########################################################
]]--
local function ItemSocketStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.socket ~= true then return end 
	ItemSocketingFrame:RemoveTextures()
	ItemSocketingFrame:SetStylePanel("Frame", "Composite2")
	ItemSocketingFrameInset:Die()
	ItemSocketingScrollFrame:RemoveTextures()
	ItemSocketingScrollFrame:SetStylePanel("Frame", "Inset", true)
	PLUGIN:ApplyScrollFrameStyle(ItemSocketingScrollFrameScrollBar, 2)
	for j = 1, MAX_NUM_SOCKETS do 
		local i = _G[("ItemSocketingSocket%d"):format(j)];
		local C = _G[("ItemSocketingSocket%dBracketFrame"):format(j)];
		local D = _G[("ItemSocketingSocket%dBackground"):format(j)];
		local E = _G[("ItemSocketingSocket%dIconTexture"):format(j)];
		i:RemoveTextures()
		i:SetStylePanel("Button")
		i:SetStylePanel("!_Frame", "Button", true)
		C:Die()
		D:Die()
		E:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		E:SetAllPointsIn()
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
	ItemSocketingSocketButton:SetPointToScale("BOTTOMRIGHT", ItemSocketingFrame, "BOTTOMRIGHT", -5, 5)
	ItemSocketingSocketButton:SetStylePanel("Button")
	PLUGIN:ApplyCloseButtonStyle(ItemSocketingFrameCloseButton)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ItemSocketingUI",ItemSocketStyle)