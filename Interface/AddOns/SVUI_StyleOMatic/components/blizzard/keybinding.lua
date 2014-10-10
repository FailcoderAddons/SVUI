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
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
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
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.binding ~= true then return end 

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