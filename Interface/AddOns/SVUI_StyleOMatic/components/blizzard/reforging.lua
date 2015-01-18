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
REFORGING PLUGINR
##########################################################
]]--
local function ReforgingStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.reforge ~= true then return end 
	
	PLUGIN:ApplyWindowStyle(ReforgingFrame, true)

	ReforgingFrame.ButtonFrame:RemoveTextures()
	ReforgingFrameReforgeButton:ClearAllPoints()
	ReforgingFrameReforgeButton:SetPointToScale("LEFT", ReforgingFrameRestoreButton, "RIGHT", 2, 0)
	ReforgingFrameReforgeButton:SetPointToScale("BOTTOMRIGHT", -3, 3)
	ReforgingFrame.RestoreMessage:SetTextColor(1, 1, 1)

	ReforgingFrameRestoreButton:RemoveTextures()
	ReforgingFrameReforgeButton:RemoveTextures()
	ReforgingFrameRestoreButton:SetStylePanel("Button")
	ReforgingFrameReforgeButton:SetStylePanel("Button")

	ReforgingFrame.ItemButton:RemoveTextures()
	ReforgingFrame.ItemButton:SetStylePanel("Slot")
	ReforgingFrame.ItemButton.IconTexture:SetAllPointsIn()
	hooksecurefunc("ReforgingFrame_Update", function(k)
		local w, x, u, y, z, A = GetReforgeItemInfo()
		if x then
			 ReforgingFrame.ItemButton.IconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		else
			 ReforgingFrame.ItemButton.IconTexture:SetTexture(0,0,0,0)
		end 
	end)
	PLUGIN:ApplyCloseButtonStyle(ReforgingFrameCloseButton)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ReforgingUI",ReforgingStyle)