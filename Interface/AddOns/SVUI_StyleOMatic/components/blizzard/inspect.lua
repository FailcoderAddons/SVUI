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
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
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
INSPECT UI PLUGINR
##########################################################
]]--
local function InspectStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.inspect ~= true then
		return 
	end 
	InspectFrame:RemoveTextures(true)
	InspectFrameInset:RemoveTextures(true)
	InspectFrame:SetStylePanel("Frame", "Composite2")
	PLUGIN:ApplyCloseButtonStyle(InspectFrameCloseButton)
	for d = 1, 4 do
		PLUGIN:ApplyTabStyle(_G["InspectFrameTab"..d])
	end 
	InspectModelFrameBorderTopLeft:Die()
	InspectModelFrameBorderTopRight:Die()
	InspectModelFrameBorderTop:Die()
	InspectModelFrameBorderLeft:Die()
	InspectModelFrameBorderRight:Die()
	InspectModelFrameBorderBottomLeft:Die()
	InspectModelFrameBorderBottomRight:Die()
	InspectModelFrameBorderBottom:Die()
	InspectModelFrameBorderBottom2:Die()
	InspectModelFrameBackgroundOverlay:Die()
	InspectModelFrame:SetStylePanel("Frame", "Default")
	for _, slot in pairs(InspectSlotList)do 
		local texture = _G["Inspect"..slot.."IconTexture"]
		local frame = _G["Inspect"..slot]
		frame:RemoveTextures()
		frame:SetStylePanel("Button")
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		texture:SetAllPointsIn()
		frame:SetFrameLevel(frame:GetFrameLevel() + 1)
		frame:SetStylePanel("!_Frame")
	end 
	hooksecurefunc('InspectPaperDollItemSlotButton_Update', function(q)
		local unit = InspectFrame.unit;
		local r = GetInventoryItemQuality(unit, q:GetID())
		if r and q.Panel then 
			local s, t, f = GetItemQualityColor(r)
			q:SetBackdropBorderColor(s, t, f)
		elseif q.Panel then 
			q:SetBackdropBorderColor(0,0,0,1)
		end 
	end)
	InspectGuildFrameBG:Die()
	InspectTalentFrame:RemoveTextures()
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_InspectUI",InspectStyle)