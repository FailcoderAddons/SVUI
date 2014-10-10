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
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
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
TRANSMOG STYLER
##########################################################
]]--
local function TransmogStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.transmogrify ~= true then return end

	STYLE:ApplyWindowStyle(TransmogrifyFrame, true)

	for p, texture in pairs(TransmogFrameList)do
		 _G[texture]:Die()
	end

	select(2, TransmogrifyModelFrame:GetRegions()):Die()

	TransmogrifyModelFrame:SetFixedPanelTemplate("ModelComic")
	TransmogrifyFrameButtonFrame:GetRegions():Die()
	TransmogrifyApplyButton:RemoveTextures()
	TransmogrifyApplyButton:SetButtonTemplate()
	TransmogrifyApplyButton:Point("BOTTOMRIGHT", TransmogrifyFrame, "BOTTOMRIGHT", -4, 4)
	STYLE:ApplyCloseButtonStyle(TransmogrifyArtFrameCloseButton)
	TransmogrifyArtFrame:RemoveTextures()

	for p, a9 in pairs(TransmogSlotList)do 
		local icon = _G["TransmogrifyFrame"..a9 .."SlotIconTexture"]
		local a9 = _G["TransmogrifyFrame"..a9 .."Slot"]
		if a9 then
			a9:RemoveTextures()
			a9:SetSlotTemplate(true)
			a9:SetFrameLevel(a9:GetFrameLevel()+2)
			
			a9.Panel:SetAllPoints()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:FillInner()
		end 
	end
	
	TransmogrifyConfirmationPopup:SetParent(UIParent)
	TransmogrifyConfirmationPopup:RemoveTextures()
	TransmogrifyConfirmationPopup:SetPanelTemplate("Pattern")
	TransmogrifyConfirmationPopup.Button1:SetButtonTemplate()
	TransmogrifyConfirmationPopup.Button2:SetButtonTemplate()
	STYLE:ApplyItemButtonStyle(TransmogrifyConfirmationPopupItemFrame1, true)
	STYLE:ApplyItemButtonStyle(TransmogrifyConfirmationPopupItemFrame2, true)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_ItemAlterationUI", TransmogStyle)