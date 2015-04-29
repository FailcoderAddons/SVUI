--[[
##########################################################
S V U I   By: Munglunch
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
local SV = _G['SVUI'];
local L = SV.L;
local MOD = SV.Skins;
local Schema = MOD.Schema;
--[[ 
########################################################## 
OUTFITTER
##########################################################
]]--
local function StyleOutfitter()
	assert(OutfitterFrame, "AddOn Not Loaded")
	
	CharacterFrame:HookScript("OnShow", function(self) PaperDollSidebarTabs:SetPoint("BOTTOMRIGHT", CharacterFrameInsetRight, "TOPRIGHT", -14, 0) end)
	OutfitterFrame:HookScript("OnShow", function(self) 
		SV.API:Set("Frame", OutfitterFrame)
		OutfitterFrameTab1:SetSize(60, 25)
		OutfitterFrameTab2:SetSize(60, 25)
		OutfitterFrameTab3:SetSize(60, 25)
		OutfitterMainFrame:RemoveTextures(true)
		for i = 0, 13 do
			if _G["OutfitterItem"..i.."OutfitSelected"] then 
				_G["OutfitterItem"..i.."OutfitSelected"]:SetStyle("Button")
				_G["OutfitterItem"..i.."OutfitSelected"]:ClearAllPoints()
				_G["OutfitterItem"..i.."OutfitSelected"]:SetSize(16, 16)
				_G["OutfitterItem"..i.."OutfitSelected"]:SetPoint("LEFT", _G["OutfitterItem"..i.."Outfit"], "LEFT", 8, 0)
			end
		end
	end)
	OutfitterMainFrameScrollbarTrench:RemoveTextures(true)
	OutfitterFrameTab1:ClearAllPoints()
	OutfitterFrameTab2:ClearAllPoints()
	OutfitterFrameTab3:ClearAllPoints()
	OutfitterFrameTab1:SetPoint("TOPLEFT", OutfitterFrame, "BOTTOMRIGHT", -65, -2)
	OutfitterFrameTab2:SetPoint("LEFT", OutfitterFrameTab1, "LEFT", -65, 0)
	OutfitterFrameTab3:SetPoint("LEFT", OutfitterFrameTab2, "LEFT", -65, 0)
	OutfitterFrameTab1:SetStyle("Button")
	OutfitterFrameTab2:SetStyle("Button")
	OutfitterFrameTab3:SetStyle("Button")
	SV.API:Set("ScrollBar", OutfitterMainFrameScrollFrameScrollBar)
	SV.API:Set("CloseButton", OutfitterCloseButton)
	OutfitterNewButton:SetStyle("Button")
	OutfitterEnableNone:SetStyle("Button")
	OutfitterEnableAll:SetStyle("Button")
	OutfitterButton:ClearAllPoints()
	OutfitterButton:SetPoint("RIGHT", PaperDollSidebarTabs, "RIGHT", 26, -2)
	OutfitterButton:SetHighlightTexture(nil)
	OutfitterSlotEnables:SetFrameStrata("HIGH")
	OutfitterEnableHeadSlot:SetStyle("Checkbox")
	OutfitterEnableNeckSlot:SetStyle("Checkbox")
	OutfitterEnableShoulderSlot:SetStyle("Checkbox")
	OutfitterEnableBackSlot:SetStyle("Checkbox")
	OutfitterEnableChestSlot:SetStyle("Checkbox")
	OutfitterEnableShirtSlot:SetStyle("Checkbox")
	OutfitterEnableTabardSlot:SetStyle("Checkbox")
	OutfitterEnableWristSlot:SetStyle("Checkbox")
	OutfitterEnableMainHandSlot:SetStyle("Checkbox")
	OutfitterEnableSecondaryHandSlot:SetStyle("Checkbox")
	OutfitterEnableHandsSlot:SetStyle("Checkbox")
	OutfitterEnableWaistSlot:SetStyle("Checkbox")
	OutfitterEnableLegsSlot:SetStyle("Checkbox")
	OutfitterEnableFeetSlot:SetStyle("Checkbox")
	OutfitterEnableFinger0Slot:SetStyle("Checkbox")
	OutfitterEnableFinger1Slot:SetStyle("Checkbox")
	OutfitterEnableTrinket0Slot:SetStyle("Checkbox")
	OutfitterEnableTrinket1Slot:SetStyle("Checkbox")
	OutfitterItemComparisons:SetStyle("Button")
	OutfitterTooltipInfo:SetStyle("Button")
	OutfitterShowHotkeyMessages:SetStyle("Button")
	OutfitterShowMinimapButton:SetStyle("Button")
	OutfitterShowOutfitBar:SetStyle("Button")
	OutfitterAutoSwitch:SetStyle("Button")
	OutfitterItemComparisons:SetSize(20, 20)
	OutfitterTooltipInfo:SetSize(20, 20)
	OutfitterShowHotkeyMessages:SetSize(20, 20)
	OutfitterShowMinimapButton:SetSize(20, 20)
	OutfitterShowOutfitBar:SetSize(20, 20)
	OutfitterAutoSwitch:SetSize(20, 20)
	OutfitterShowOutfitBar:SetPoint("TOPLEFT", OutfitterAutoSwitch, "BOTTOMLEFT", 0, -5)
	OutfitterEditScriptDialogDoneButton:SetStyle("Button")
	OutfitterEditScriptDialogCancelButton:SetStyle("Button")
	SV.API:Set("ScrollBar", OutfitterEditScriptDialogSourceScriptScrollBar)
	SV.API:Set("Frame", OutfitterEditScriptDialogSourceScript,"Transparent")
	SV.API:Set("Frame", OutfitterEditScriptDialog)
	SV.API:Set("CloseButton", OutfitterEditScriptDialog.CloseButton)
	SV.API:Set("Tab", OutfitterEditScriptDialogTab1)
	SV.API:Set("Tab", OutfitterEditScriptDialogTab2)
end
MOD:SaveAddonStyle("Outfitter", StyleOutfitter)