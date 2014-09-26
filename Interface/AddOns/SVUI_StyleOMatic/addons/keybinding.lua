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
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
KEYBINDING STYLER
##########################################################
]]--
local BindButtons = {
	"KeyBindingFrameDefaultButton", 
	"KeyBindingFrameUnbindButton", 
	"KeyBindingFrameOkayButton", 
	"KeyBindingFrameCancelButton"
}

local function BindingStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.binding ~= true then return end 

	for _, gName in pairs(BindButtons)do 
		local btn = _G[gName]
		if(btn) then
			btn:RemoveTextures()
			btn:SetButtonTemplate()
		end
	end

	for i = 1, KEY_BINDINGS_DISPLAYED do 
		local button1 = _G["KeyBindingFrameBinding"..i.."Key1Button"]
		if(button1) then
			button1:RemoveTextures(true)
			button1:SetEditboxTemplate()
		end

		local button2 = _G["KeyBindingFrameBinding"..i.."Key2Button"]
		if(button2) then
			button2:RemoveTextures(true)
			button2:SetEditboxTemplate()
		end
	end

	STYLE:ApplyScrollFrameStyle(KeyBindingFrameScrollFrameScrollBar)
	KeyBindingFrame:RemoveTextures()
	KeyBindingFrame:SetPanelTemplate("Halftone")
end
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_BindingUI", BindingStyle)