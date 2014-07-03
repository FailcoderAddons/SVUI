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
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.transmogrify ~= true then return end;
	TransmogrifyFrame:Formula409()
	TransmogrifyFrame:SetPanelTemplate("Action")
	TransmogrifyModelFrame:SetFrameLevel(TransmogrifyFrame:GetFrameLevel()+2)
	for p, texture in pairs(TransmogFrameList)do
		 _G[texture]:MUNG()
	end;
	select(2, TransmogrifyModelFrame:GetRegions()):MUNG()
	TransmogrifyModelFrame:SetFixedPanelTemplate("Comic")
	TransmogrifyFrameButtonFrame:GetRegions():MUNG()
	TransmogrifyApplyButton:SetButtonTemplate()
	TransmogrifyApplyButton:Point("BOTTOMRIGHT", TransmogrifyFrame, "BOTTOMRIGHT", -4, 4)
	MOD:ApplyCloseButtonStyle(TransmogrifyArtFrameCloseButton)
	TransmogrifyArtFrame:Formula409()
	for p, a9 in pairs(TransmogSlotList)do 
		local icon = _G["TransmogrifyFrame"..a9 .."SlotIconTexture"]
		local a9 = _G["TransmogrifyFrame"..a9 .."Slot"]
		if a9 then
			a9:Formula409()
			a9:SetSlotTemplate(true)
			a9:SetFrameLevel(a9:GetFrameLevel()+2)
			
			a9.Panel:SetAllPoints()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:FillInner()
		end 
	end;
	TransmogrifyConfirmationPopup:SetParent(UIParent)
	TransmogrifyConfirmationPopup:Formula409()
	TransmogrifyConfirmationPopup:SetPanelTemplate("Pattern")
	TransmogrifyConfirmationPopup.Button1:SetButtonTemplate()
	TransmogrifyConfirmationPopup.Button2:SetButtonTemplate()
	MOD:ApplyLinkButtonStyle(TransmogrifyConfirmationPopupItemFrame1, true)
	MOD:ApplyLinkButtonStyle(TransmogrifyConfirmationPopupItemFrame2, true)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ItemAlterationUI",TransmogStyle)