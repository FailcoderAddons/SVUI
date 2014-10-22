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
local SlotListener = CreateFrame("Frame")

local CharacterSlotNames = {
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

local CharFrameList = {
	"CharacterFrame",
	"CharacterModelFrame",
	"CharacterFrameInset",
	"CharacterStatsPane",
	"CharacterFrameInsetRight",
	"PaperDollFrame",
	"PaperDollSidebarTabs",
	"PaperDollEquipmentManagerPane"
};

local function SetItemFrame(frame, point)
	point = point or frame
	local noscalemult = 2 * UIParent:GetScale()
	if point.bordertop then return end
	point.backdrop = frame:CreateTexture(nil, "BORDER")
	point.backdrop:SetDrawLayer("BORDER", -4)
	point.backdrop:SetAllPoints(point)
	point.backdrop:SetTexture(SV.Media.bar.default)
	point.backdrop:SetVertexColor(unpack(SV.Media.color.default))	
	point.bordertop = frame:CreateTexture(nil, "BORDER")
	point.bordertop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.bordertop:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.bordertop:SetHeight(noscalemult)
	point.bordertop:SetTexture(0,0,0)	
	point.bordertop:SetDrawLayer("BORDER", 1)
	point.borderbottom = frame:CreateTexture(nil, "BORDER")
	point.borderbottom:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", -noscalemult, -noscalemult)
	point.borderbottom:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
	point.borderbottom:SetHeight(noscalemult)
	point.borderbottom:SetTexture(0,0,0)	
	point.borderbottom:SetDrawLayer("BORDER", 1)
	point.borderleft = frame:CreateTexture(nil, "BORDER")
	point.borderleft:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	point.borderleft:SetPoint("BOTTOMLEFT", point, "BOTTOMLEFT", noscalemult, -noscalemult)
	point.borderleft:SetWidth(noscalemult)
	point.borderleft:SetTexture(0,0,0)	
	point.borderleft:SetDrawLayer("BORDER", 1)
	point.borderright = frame:CreateTexture(nil, "BORDER")
	point.borderright:SetPoint("TOPRIGHT", point, "TOPRIGHT", noscalemult, noscalemult)
	point.borderright:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", -noscalemult, -noscalemult)
	point.borderright:SetWidth(noscalemult)
	point.borderright:SetTexture(0,0,0)	
	point.borderright:SetDrawLayer("BORDER", 1)	
end

local function StyleCharacterSlots()
	for _,slotName in pairs(CharacterSlotNames) do
		local globalName = ("Character%s"):format(slotName)
		local charSlot = _G[globalName]
		if(charSlot) then
			if(not charSlot.Panel) then
				charSlot:RemoveTextures()
				charSlot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
				charSlot:SetSlotTemplate(true, 2, 0, 0)

				local iconTex = _G[globalName.."IconTexture"]
				if(iconTex) then
					iconTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					iconTex:SetParent(charSlot.Panel)
					iconTex:FillInner(charSlot.Panel, 2, 2)
				end
			end

			local slotID = GetInventorySlotInfo(slotName)
			if(slotID) then
				local itemID = GetInventoryItemID("player", slotID)
				if(itemID) then 
					local info = select(3, GetItemInfo(itemID))
					if info and info > 1 then
						 charSlot:SetBackdropBorderColor(GetItemQualityColor(info))
					else
						 charSlot:SetBackdropBorderColor(0,0,0,1)
					end 
				else
					 charSlot:SetBackdropBorderColor(0,0,0,1)
				end
			end
		end 
	end 
end 

local function EquipmentFlyout_OnShow()
	EquipmentFlyoutFrameButtons:RemoveTextures()
	local counter = 1;
	local button = _G["EquipmentFlyoutFrameButton"..counter]
	while button do 
		local texture = _G["EquipmentFlyoutFrameButton"..counter.."IconTexture"]
		button:SetButtonTemplate()
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button:GetNormalTexture():SetTexture(0,0,0,0)
		texture:FillInner()
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		if not button.Panel then
			button:SetPanelTemplate("Default")
			button.Panel:SetAllPoints()
		end 
		counter = counter + 1;
		button = _G["EquipmentFlyoutFrameButton"..counter]
	end 
end 

local function PaperDoll_UpdateTabs()
	for i = 1, #PAPERDOLL_SIDEBARS do 
		local tab = _G["PaperDollSidebarTab"..i]
		if tab then
			tab.Highlight:SetTexture(1, 1, 1, 0.3)
			tab.Highlight:Point("TOPLEFT", 3, -4)
			tab.Highlight:Point("BOTTOMRIGHT", -1, 0)
			tab.Hider:SetTexture(0.4, 0.4, 0.4, 0.4)
			tab.Hider:Point("TOPLEFT", 3, -4)
			tab.Hider:Point("BOTTOMRIGHT", -1, 0)
			tab.TabBg:Die()
			if i == 1 then 
				for i = 1, tab:GetNumRegions()do 
					local texture = select(i, tab:GetRegions())
					texture:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					hooksecurefunc(texture, "SetTexCoord", function(f, v, w, x, y)
						if v ~= 0.16001 then
							 f:SetTexCoord(0.16001, 0.86, 0.16, 0.86)
						end 
					end)
				end 
			end 
			tab:SetPanelTemplate("Default", true, 2)
			tab.Panel:Point("TOPLEFT", 2, -3)
			tab.Panel:Point("BOTTOMRIGHT", 0, -2)
		end 
	end 
end 

local function Reputation_OnShow()
	for i = 1, GetNumFactions()do 
		local bar = _G["ReputationBar"..i.."ReputationBar"]
		if bar then
			 bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			if not bar.Panel then
				 bar:SetPanelTemplate("Inset")
			end 
			_G["ReputationBar"..i.."Background"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(0,0,0,0)
			_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(0,0,0,0)
		end 
	end 
end

local function PaperDollTitlesPane_OnShow()
	for _,gName in pairs(PaperDollTitlesPane.buttons) do
		local btn = _G[gName]
		if(btn) then
			btn.BgTop:SetTexture(0,0,0,0)
			btn.BgBottom:SetTexture(0,0,0,0)
			btn.BgMiddle:SetTexture(0,0,0,0)
			btn.Check:SetTexture(0,0,0,0)
			btn.text:FillInner(btn)
			btn.text:SetFont(SV.Media.font.roboto,10,"NONE","LEFT")
		end
	end 
end

local function PaperDollEquipmentManagerPane_OnShow()
		for _,gName in pairs(PaperDollEquipmentManagerPane.buttons) do
			local btn = _G[gName]
			if(btn) then
				btn.BgTop:SetTexture(0,0,0,0)
				btn.BgBottom:SetTexture(0,0,0,0)
				btn.BgMiddle:SetTexture(0,0,0,0)
				btn.icon:Size(36, 36)
				btn.Check:SetTexture(0,0,0,0)
				btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)
				if not btn.icon.bordertop then
					 SetItemFrame(btn, btn.icon)
				end 
			end
		end

		GearManagerDialogPopup:RemoveTextures()
		GearManagerDialogPopup:SetPanelTemplate("Inset", true)
		GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 4, 0)
		GearManagerDialogPopupScrollFrame:RemoveTextures()
		GearManagerDialogPopupEditBox:RemoveTextures()
		GearManagerDialogPopupEditBox:SetBasicPanel()
		GearManagerDialogPopupOkay:SetButtonTemplate()
		GearManagerDialogPopupCancel:SetButtonTemplate()

		for i = 1, NUM_GEARSET_ICONS_SHOWN do 
			local btn = _G["GearManagerDialogPopupButton"..i]
			if(btn and (not btn.Panel)) then
				btn:RemoveTextures()
				btn:SetFrameLevel(btn:GetFrameLevel() + 2)
				btn:SetButtonTemplate()
				if(btn.icon) then
					btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					btn.icon:SetTexture(0,0,0,0)
					btn.icon:FillInner()
				end 
			end 
		end 
	end
--[[ 
########################################################## 
CHARACTERFRAME PLUGINR
##########################################################
]]--
local function CharacterFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.character ~= true then
		 return 
	end

	PLUGIN:ApplyWindowStyle(CharacterFrame, true)

	PLUGIN:ApplyCloseButtonStyle(CharacterFrameCloseButton)
	PLUGIN:ApplyScrollFrameStyle(CharacterStatsPaneScrollBar)
	PLUGIN:ApplyScrollFrameStyle(ReputationListScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(TokenFrameContainerScrollBar)
	PLUGIN:ApplyScrollFrameStyle(GearManagerDialogPopupScrollFrameScrollBar)
	
	StyleCharacterSlots()

	SlotListener:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	SlotListener:SetScript("OnEvent", StyleCharacterSlots)
	CharacterFrame:HookScript("OnShow", StyleCharacterSlots)

	CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
	PLUGIN:ApplyPaginationStyle(CharacterFrameExpandButton)

	hooksecurefunc('CharacterFrame_Collapse', function()
		CharacterFrameExpandButton:SetNormalTexture(nil)
		CharacterFrameExpandButton:SetPushedTexture(nil)
		CharacterFrameExpandButton:SetDisabledTexture(nil)
		SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	end)

	hooksecurefunc('CharacterFrame_Expand', function()
		CharacterFrameExpandButton:SetNormalTexture(nil)
		CharacterFrameExpandButton:SetPushedTexture(nil)
		CharacterFrameExpandButton:SetDisabledTexture(nil)
		SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT')
	end)

	if GetCVar("characterFrameCollapsed") ~= "0" then
		 SquareButton_SetIcon(CharacterFrameExpandButton, 'RIGHT')
	else
		 SquareButton_SetIcon(CharacterFrameExpandButton, 'LEFT')
	end 

	PLUGIN:ApplyCloseButtonStyle(ReputationDetailCloseButton)
	PLUGIN:ApplyCloseButtonStyle(TokenFramePopupCloseButton)
	ReputationDetailAtWarCheckBox:SetCheckboxTemplate(true)
	ReputationDetailMainScreenCheckBox:SetCheckboxTemplate(true)
	ReputationDetailInactiveCheckBox:SetCheckboxTemplate(true)
	ReputationDetailLFGBonusReputationCheckBox:SetCheckboxTemplate(true)
	TokenFramePopupInactiveCheckBox:SetCheckboxTemplate(true)
	TokenFramePopupBackpackCheckBox:SetCheckboxTemplate(true)
	EquipmentFlyoutFrameHighlight:Die()
	EquipmentFlyoutFrame:HookScript("OnShow", EquipmentFlyout_OnShow)
	hooksecurefunc("EquipmentFlyout_Show", EquipmentFlyout_OnShow)
	CharacterFramePortrait:Die()
	PLUGIN:ApplyScrollFrameStyle(_G["PaperDollTitlesPaneScrollBar"], 5)
	PLUGIN:ApplyScrollFrameStyle(_G["PaperDollEquipmentManagerPaneScrollBar"], 5)

	for _,gName in pairs(CharFrameList) do
		local frame = _G[gName]
		if(frame) then
			frame:RemoveTextures(true)
		end
	end 

	CharacterModelFrameBackgroundTopLeft:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundTopRight:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundBotLeft:SetTexture(0,0,0,0)
	CharacterModelFrameBackgroundBotRight:SetTexture(0,0,0,0)

	CharacterModelFrame:SetFixedPanelTemplate("Model")
	CharacterFrameExpandButton:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 5)

	PaperDollTitlesPane:SetBasicPanel()

	PaperDollTitlesPane:HookScript("OnShow", PaperDollTitlesPane_OnShow)

	PaperDollEquipmentManagerPane:SetBasicPanel()
	PaperDollEquipmentManagerPaneEquipSet:SetButtonTemplate()
	PaperDollEquipmentManagerPaneSaveSet:SetButtonTemplate()
	PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(0,0,0,0)

	PaperDollEquipmentManagerPane:HookScript("OnShow", PaperDollEquipmentManagerPane_OnShow)

	for i = 1, 4 do
		 PLUGIN:ApplyTabStyle(_G["CharacterFrameTab"..i])
	end

	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", PaperDoll_UpdateTabs)

	for i = 1, 7 do
		local category = _G["CharacterStatsPaneCategory"..i]
		if(category) then
			category:RemoveTextures()
			category:SetButtonTemplate()
		end
	end

	ReputationFrame:RemoveTextures(true)
	ReputationListScrollFrame:RemoveTextures()
	ReputationDetailFrame:RemoveTextures()
	ReputationDetailFrame:SetPanelTemplate("Inset", true)
	ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)
	ReputationFrame:HookScript("OnShow", Reputation_OnShow)
	hooksecurefunc("ExpandFactionHeader", Reputation_OnShow)
	hooksecurefunc("CollapseFactionHeader", Reputation_OnShow)
	TokenFrameContainer:SetBasicPanel()

	TokenFrame:HookScript("OnShow", function()
		for i = 1, GetCurrencyListSize() do 
			local currency = _G["TokenFrameContainerButton"..i]
			if(currency) then
				currency.highlight:Die()
				currency.categoryMiddle:Die()
				currency.categoryLeft:Die()
				currency.categoryRight:Die()
				if currency.icon then
					 currency.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end 
			end 
		end 
		TokenFramePopup:RemoveTextures()
		TokenFramePopup:SetPanelTemplate("Inset", true)
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)
	end)

	PetModelFrame:SetPanelTemplate("Comic",false,1,-7,-7)
	PetPaperDollPetInfo:GetRegions():SetTexCoord(.12, .63, .15, .55)
	PetPaperDollPetInfo:SetFrameLevel(PetPaperDollPetInfo:GetFrameLevel() + 10)
	PetPaperDollPetInfo:SetPanelTemplate("Slot")
	PetPaperDollPetInfo.Panel:SetFrameLevel(0)
	PetPaperDollPetInfo:Size(24, 24)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(CharacterFrameStyle)