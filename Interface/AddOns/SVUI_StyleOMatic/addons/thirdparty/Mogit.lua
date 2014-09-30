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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
MOGIT
##########################################################
]]--
local function StyleMogItPreview()
	for i = 1, 99 do
		local MogItGearSlots = {
			"HeadSlot",
			"ShoulderSlot",
			"BackSlot",
			"ChestSlot",
			"ShirtSlot",
			"TabardSlot",
			"WristSlot",
			"HandsSlot",
			"WaistSlot",
			"LegsSlot",
			"FeetSlot",
			"MainHandSlot",
			"SecondaryHandSlot",
		}
		for _, object in pairs(MogItGearSlots) do
			if _G["MogItPreview"..i..object] then
				STYLE:ApplyItemButtonStyle(_G["MogItPreview"..i..object])
				_G["MogItPreview"..i..object]:SetPushedTexture(nil)
				_G["MogItPreview"..i..object]:SetHighlightTexture(nil)
			end
		end
		if _G["MogItPreview"..i] then STYLE:ApplyFrameStyle(_G["MogItPreview"..i]) end
		if _G["MogItPreview"..i.."CloseButton"] then STYLE:ApplyCloseButtonStyle(_G["MogItPreview"..i.."CloseButton"]) end
		if _G["MogItPreview"..i.."Inset"] then _G["MogItPreview"..i.."Inset"]:RemoveTextures(true) end
		if _G["MogItPreview"..i.."Activate"] then _G["MogItPreview"..i.."Activate"]:SetButtonTemplate() end
	end
end

local function StyleMogIt()
	assert(MogItFrame, "AddOn Not Loaded")
	
	STYLE:ApplyFrameStyle(MogItFrame)
	MogItFrameInset:RemoveTextures(true)
	STYLE:ApplyFrameStyle(MogItFilters)
	MogItFiltersInset:RemoveTextures(true)

	hooksecurefunc(MogIt, "CreatePreview", StyleMogItPreview)
	STYLE:ApplyTooltipStyle(MogItTooltip)
	STYLE:ApplyCloseButtonStyle(MogItFrameCloseButton)
	STYLE:ApplyCloseButtonStyle(MogItFiltersCloseButton)
	MogItFrameFiltersDefaults:RemoveTextures(true)
	MogItFrameFiltersDefaults:SetButtonTemplate()
	STYLE:ApplyScrollFrameStyle(MogItScroll)
	STYLE:ApplyScrollFrameStyle(MogItFiltersScrollScrollBar)
end
STYLE:SaveAddonStyle("MogIt", StyleMogIt)