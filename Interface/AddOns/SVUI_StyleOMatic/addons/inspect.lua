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
local InspectSlotList = {
	"HeadSlot",
	"NeckSlot",
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
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"MainHandSlot",
	"SecondaryHandSlot"
};
--[[ 
########################################################## 
INSPECT UI STYLER
##########################################################
]]--
local function InspectStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.inspect ~= true then
		return 
	end;
	InspectFrame:Formula409(true)
	InspectFrameInset:Formula409(true)
	InspectFrame:SetPanelTemplate('Action')
	MOD:ApplyCloseButtonStyle(InspectFrameCloseButton)
	for d = 1, 4 do
		MOD:ApplyTabStyle(_G["InspectFrameTab"..d])
	end;
	InspectModelFrameBorderTopLeft:MUNG()
	InspectModelFrameBorderTopRight:MUNG()
	InspectModelFrameBorderTop:MUNG()
	InspectModelFrameBorderLeft:MUNG()
	InspectModelFrameBorderRight:MUNG()
	InspectModelFrameBorderBottomLeft:MUNG()
	InspectModelFrameBorderBottomRight:MUNG()
	InspectModelFrameBorderBottom:MUNG()
	InspectModelFrameBorderBottom2:MUNG()
	InspectModelFrameBackgroundOverlay:MUNG()
	InspectModelFrame:SetPanelTemplate("Default")
	for _, slot in pairs(InspectSlotList)do 
		local texture = _G["Inspect"..slot.."IconTexture"]
		local frame = _G["Inspect"..slot]
		frame:Formula409()
		frame:SetButtonTemplate()
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		texture:FillInner()
		frame:SetFrameLevel(frame:GetFrameLevel() + 1)
		frame:SetFixedPanelTemplate()
	end;
	hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(q)
		local unit = InspectFrame.unit;
		local r = GetInventoryItemQuality(unit, q:GetID())
		if r and q.Panel then 
			local s, t, f = GetItemQualityColor(r)
			q.Panel:SetBackdropBorderColor(s, t, f)
		elseif q.Panel then 
			q.Panel:SetBackdropBorderColor(0,0,0,1)
		end 
	end)
	InspectGuildFrameBG:MUNG()
	InspectTalentFrame:Formula409()
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_InspectUI",InspectStyle)