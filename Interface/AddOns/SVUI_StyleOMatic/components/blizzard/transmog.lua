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
local unpack  	= _G.unpack;
local select  	= _G.select;
local ipairs  	= _G.ipairs;
local pairs   	= _G.pairs;
local type 		= _G.type;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local TransmogFrameList = {
	"TransmogrifyModelFrameLines",
	"TransmogrifyModelFrameMarbleBg",
	"TransmogrifyFrameButtonFrameButtonBorder",
	"TransmogrifyFrameButtonFrameButtonBottomBorder",
	"TransmogrifyFrameButtonFrameMoneyLeft",
	"TransmogrifyFrameButtonFrameMoneyRight",
	"TransmogrifyFrameButtonFrameMoneyMiddle"
};
local TransmogSlotList = {
	"Head",
	"Shoulder",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Back",
	"MainHand",
	"SecondaryHand"
};
--[[ 
########################################################## 
TRANSMOG PLUGINR
##########################################################
]]--
local function TransmogStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.transmogrify ~= true then return end

	TransmogrifyFrame:SetSizeToScale(500, 600)
	PLUGIN:ApplyWindowStyle(TransmogrifyFrame, true)

	for p, texture in pairs(TransmogFrameList)do
		 _G[texture]:Die()
	end

	select(2, TransmogrifyModelFrame:GetRegions()):Die()

	TransmogrifyModelFrame:ClearAllPoints()
	TransmogrifyModelFrame:SetPointToScale("TOPLEFT", TransmogrifyFrame, "TOPLEFT", 12, -22)
	TransmogrifyModelFrame:SetPointToScale("BOTTOMRIGHT", TransmogrifyFrame, "BOTTOMRIGHT", -12, 36)
	TransmogrifyModelFrame:SetStylePanel("!_Frame", "Model")

	TransmogrifyFrameButtonFrame:GetRegions():Die()
	TransmogrifyApplyButton:RemoveTextures()
	TransmogrifyApplyButton:SetStylePanel("Button")
	TransmogrifyApplyButton:SetPointToScale("BOTTOMRIGHT", TransmogrifyFrame, "BOTTOMRIGHT", -4, 4)
	PLUGIN:ApplyCloseButtonStyle(TransmogrifyArtFrameCloseButton)
	TransmogrifyArtFrame:RemoveTextures()

	for p, a9 in pairs(TransmogSlotList)do 
		local icon = _G["TransmogrifyFrame"..a9 .."SlotIconTexture"]
		local a9 = _G["TransmogrifyFrame"..a9 .."Slot"]
		if a9 then
			a9:RemoveTextures()
			a9:SetStylePanel("Slot")
			a9:SetFrameLevel(a9:GetFrameLevel()+2)
			
			a9.Panel:SetAllPoints()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetAllPointsIn()
		end 
	end
	
	TransmogrifyConfirmationPopup:SetParent(UIParent)
	TransmogrifyConfirmationPopup:RemoveTextures()
	TransmogrifyConfirmationPopup:SetStylePanel("Frame", "Pattern")
	TransmogrifyConfirmationPopup.Button1:SetStylePanel("Button")
	TransmogrifyConfirmationPopup.Button2:SetStylePanel("Button")
	PLUGIN:ApplyItemButtonStyle(TransmogrifyConfirmationPopupItemFrame1, true)
	PLUGIN:ApplyItemButtonStyle(TransmogrifyConfirmationPopupItemFrame2, true)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ItemAlterationUI", TransmogStyle)