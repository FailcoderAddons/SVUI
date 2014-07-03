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
	point.backdrop:SetTexture(SuperVillain.Media.bar.default)
	point.backdrop:SetVertexColor(unpack(SuperVillain.Media.color.default))	
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
	for _,slotName in pairs(CharacterSlotNames)do 
		local charSlot = _G["Character"..slotName]
		local slotID,_,_ = GetInventorySlotInfo(slotName)
		local itemID = GetInventoryItemID("player",slotID)
		if itemID then 
			local _,_,info = GetItemInfo(itemID)
			if info and info > 1 then
				 charSlot:SetBackdropBorderColor(GetItemQualityColor(info))
			else
				 charSlot:SetBackdropBorderColor(0,0,0,1)
			end 
		else
			 charSlot:SetBackdropBorderColor(0,0,0,1)
		end 
	end 
end;

local function EquipmentFlyout_OnShow()
	EquipmentFlyoutFrameButtons:Formula409()
	local counter = 1;
	local button = _G["EquipmentFlyoutFrameButton"..counter]
	while button do 
		local texture = _G["EquipmentFlyoutFrameButton"..counter.."IconTexture"]
		button:SetButtonTemplate()
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		button:GetNormalTexture():SetTexture(nil)
		texture:FillInner()
		button:SetFrameLevel(button:GetFrameLevel() + 2)
		if not button.Panel then
			button:SetPanelTemplate("Default")
			button.Panel:SetAllPoints()
		end;
		counter = counter + 1;
		button = _G["EquipmentFlyoutFrameButton"..counter]
	end 
end;

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
			tab.TabBg:MUNG()
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
			end;
			tab:SetPanelTemplate("Default", true, 2)
			tab.Panel:Point("TOPLEFT", 2, -3)
			tab.Panel:Point("BOTTOMRIGHT", 0, -2)
		end 
	end 
end;

local function Reputation_OnShow()
	for i = 1, GetNumFactions()do 
		local bar = _G["ReputationBar"..i.."ReputationBar"]
		if bar then
			 bar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
			if not bar.Panel then
				 bar:SetPanelTemplate("Inset")
			end;
			_G["ReputationBar"..i.."Background"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
			_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
		end 
	end 
end;
--[[ 
########################################################## 
CHARACTERFRAME STYLER
##########################################################
]]--
local function CharacterFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.character ~= true then
		 return 
	end;
	MOD:ApplyCloseButtonStyle(CharacterFrameCloseButton)
	MOD:ApplyScrollStyle(CharacterStatsPaneScrollBar)
	MOD:ApplyScrollStyle(ReputationListScrollFrameScrollBar)
	MOD:ApplyScrollStyle(TokenFrameContainerScrollBar)
	MOD:ApplyScrollStyle(GearManagerDialogPopupScrollFrameScrollBar)
	
	for _,slotName in pairs(CharacterSlotNames) do
		local charSlot = _G["Character"..slotName]
		local iconTex = _G["Character"..slotName.."IconTexture"]
		local cd = _G["Character"..slotName.."Cooldown"]
		charSlot:Formula409()
		charSlot:SetSlotTemplate(true)
		charSlot.Panel:SetFrameLevel(charSlot.Panel:GetFrameLevel() + 1)
		charSlot.ignoreTexture:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]])
		iconTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		iconTex:FillInner(charSlot, 0, 0)
		if cd then
			 SuperVillain:AddCD(cd)
		end 
	end;

	local eqSlotListener = CreateFrame("Frame")
	eqSlotListener:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	eqSlotListener:SetScript("OnEvent", StyleCharacterSlots)

	CharacterFrame:HookScript("OnShow", StyleCharacterSlots)

	StyleCharacterSlots()

	CharacterFrameExpandButton:Size(CharacterFrameExpandButton:GetWidth() - 7, CharacterFrameExpandButton:GetHeight() - 7)
	MOD:ApplyPaginationStyle(CharacterFrameExpandButton)

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
	end;

	MOD:ApplyCloseButtonStyle(ReputationDetailCloseButton)
	MOD:ApplyCloseButtonStyle(TokenFramePopupCloseButton)
	ReputationDetailAtWarCheckBox:SetCheckboxTemplate(true)
	ReputationDetailMainScreenCheckBox:SetCheckboxTemplate(true)
	ReputationDetailInactiveCheckBox:SetCheckboxTemplate(true)
	ReputationDetailLFGBonusReputationCheckBox:SetCheckboxTemplate(true)
	TokenFramePopupInactiveCheckBox:SetCheckboxTemplate(true)
	TokenFramePopupBackpackCheckBox:SetCheckboxTemplate(true)
	EquipmentFlyoutFrameHighlight:MUNG()
	EquipmentFlyoutFrame:HookScript("OnShow", EquipmentFlyout_OnShow)
	hooksecurefunc("EquipmentFlyout_Show", EquipmentFlyout_OnShow)
	CharacterFramePortrait:MUNG()
	MOD:ApplyScrollStyle(_G["PaperDollTitlesPaneScrollBar"], 5)
	MOD:ApplyScrollStyle(_G["PaperDollEquipmentManagerPaneScrollBar"], 5)
	for _,btn in pairs(CharFrameList)do
		 _G[btn]:Formula409(true)
	end;
	CharacterModelFrameBackgroundTopLeft:SetTexture(nil)
	CharacterModelFrameBackgroundTopRight:SetTexture(nil)
	CharacterModelFrameBackgroundBotLeft:SetTexture(nil)
	CharacterModelFrameBackgroundBotRight:SetTexture(nil)
	CharacterFrame:SetPanelTemplate("Action")
	CharacterModelFrame:SetPanelTemplate("Comic", false, 0)
	CharacterFrameExpandButton:SetFrameLevel(CharacterModelFrame:GetFrameLevel() + 5)
	CharacterStatsPane:SetFixedPanelTemplate("Inset")
	PaperDollTitlesPane:SetFixedPanelTemplate("Inset")
	PaperDollTitlesPane:HookScript("OnShow", function(f)
		for _,btn in pairs(PaperDollTitlesPane.buttons)do
			btn.BgTop:SetTexture(nil)
			btn.BgBottom:SetTexture(nil)
			btn.BgMiddle:SetTexture(nil)
			btn.Check:SetTexture(nil)
			btn.text:FillInner(btn)
			btn.text:SetFontTemplate(SuperVillain.Media.font.roboto,10,"NONE","LEFT")
		end 
	end)
	PaperDollEquipmentManagerPane:SetFixedPanelTemplate("Inset")
	PaperDollEquipmentManagerPaneEquipSet:SetButtonTemplate()
	PaperDollEquipmentManagerPaneSaveSet:SetButtonTemplate()
	PaperDollEquipmentManagerPaneEquipSet:Width(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneSaveSet:Width(PaperDollEquipmentManagerPaneSaveSet:GetWidth()-8)
	PaperDollEquipmentManagerPaneEquipSet:Point("TOPLEFT", PaperDollEquipmentManagerPane, "TOPLEFT", 8, 0)
	PaperDollEquipmentManagerPaneSaveSet:Point("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 4, 0)
	PaperDollEquipmentManagerPaneEquipSet.ButtonBackground:SetTexture(nil)
	PaperDollEquipmentManagerPane:HookScript("OnShow", function(f)
		for _,btn in pairs(PaperDollEquipmentManagerPane.buttons)do
			btn.BgTop:SetTexture(nil)
			btn.BgBottom:SetTexture(nil)
			btn.BgMiddle:SetTexture(nil)
			btn.icon:Size(36, 36)
			btn.Check:SetTexture(nil)
			btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			btn.icon:SetPoint("LEFT", btn, "LEFT", 4, 0)
			hooksecurefunc(btn.icon, "SetPoint", function(f, g, h, i, j, k, X)
				if X ~= true then
					 f:SetPoint("LEFT", btn, "LEFT", 4, 0, true)
				end 
			end)
			hooksecurefunc(btn.icon, "SetSize", function(f, Y, Z)
				if Y == 30 or Z == 30 then
					 f:Size(36, 36)
				end 
			end)
			if not btn.icon.bordertop then
				 SetItemFrame(btn, btn.icon)
			end 
		end;
		GearManagerDialogPopup:Formula409()
		GearManagerDialogPopup:SetFixedPanelTemplate("Transparent", true)
		GearManagerDialogPopup:Point("LEFT", PaperDollFrame, "RIGHT", 4, 0)
		GearManagerDialogPopupScrollFrame:Formula409()
		GearManagerDialogPopupEditBox:Formula409()
		GearManagerDialogPopupEditBox:SetFixedPanelTemplate("Default")
		GearManagerDialogPopupOkay:SetButtonTemplate()
		GearManagerDialogPopupCancel:SetButtonTemplate()
		for i = 1, NUM_GEARSET_ICONS_SHOWN do 
			local e = _G["GearManagerDialogPopupButton"..i]
			local texture = e.icon;
			if e then
				e:Formula409()
				e:SetButtonTemplate()
				texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				_G["GearManagerDialogPopupButton"..i.."Icon"]:SetTexture(nil)
				texture:FillInner()
				e:SetFrameLevel(e:GetFrameLevel() + 2)
				if not e.Panel then
					e:SetPanelTemplate("Default")
					e.Panel:SetAllPoints()
				end 
			end 
		end 
	end)
	for i = 1, 4 do
		 MOD:ApplyTabStyle(_G["CharacterFrameTab"..i])
	end;
	hooksecurefunc("PaperDollFrame_UpdateSidebarTabs", PaperDoll_UpdateTabs)
	for i = 1, 7 do
		 _G["CharacterStatsPaneCategory"..i]:Formula409()
	end;
	ReputationFrame:Formula409(true)
	ReputationListScrollFrame:Formula409()
	ReputationDetailFrame:Formula409()
	ReputationDetailFrame:SetFixedPanelTemplate("Pattern")
	ReputationDetailFrame:Point("TOPLEFT", ReputationFrame, "TOPRIGHT", 4, -28)
	ReputationFrame:HookScript("OnShow", Reputation_OnShow)
	hooksecurefunc("ExpandFactionHeader", Reputation_OnShow)
	hooksecurefunc("CollapseFactionHeader", Reputation_OnShow)
	TokenFrameContainer:SetFixedPanelTemplate("Transparent")
	TokenFrame:HookScript("OnShow", function()
		for i = 1, GetCurrencyListSize()do 
			local e = _G["TokenFrameContainerButton"..i]
			if e then
				 e.highlight:MUNG()
				e.categoryMiddle:MUNG()
				e.categoryLeft:MUNG()
				e.categoryRight:MUNG()
				if e.icon then
					 e.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end 
			end 
		end;
		TokenFramePopup:Formula409()
		TokenFramePopup:SetFixedPanelTemplate("Transparent", true)
		TokenFramePopup:Point("TOPLEFT", TokenFrame, "TOPRIGHT", 4, -28)
	end)
	PetModelFrame:SetPanelTemplate("Comic",false,1,-7,-7)
	PetPaperDollPetInfo:GetRegions():SetTexCoord(.12, .63, .15, .55)
	PetPaperDollPetInfo:SetFrameLevel(PetPaperDollPetInfo:GetFrameLevel() + 10)
	PetPaperDollPetInfo:SetPanelTemplate("Slot")
	PetPaperDollPetInfo.Panel:SetFrameLevel(0)
	PetPaperDollPetInfo:Size(24, 24)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(CharacterFrameStyle)