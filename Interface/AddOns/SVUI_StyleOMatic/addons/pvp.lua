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
PVP STYLER
##########################################################
]]--
local function PVPFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.pvp ~= true then
		return 
	end;
	PVPUIFrame:Formula409()
	PVPUIFrame:SetPanelTemplate("Action")
	PVPUIFrame.Shadows:Formula409()
	MOD:ApplyCloseButtonStyle(PVPUIFrameCloseButton)
	for g = 1, 2 do
		MOD:ApplyTabStyle(_G["PVPUIFrameTab"..g])
	end;
	for g = 1, 3 do 
		local M = _G["PVPQueueFrameCategoryButton"..g]M:SetFixedPanelTemplate("Button")
		M.Background:MUNG()
		M.Ring:MUNG()
		M.Icon:Size(45)
		M.Icon:SetTexCoord(.15, .85, .15, .85)
		M.Panel:WrapOuter(M.Icon)
		M.Panel:SetFrameLevel(M:GetFrameLevel())
		M.Icon:SetDrawLayer("OVERLAY", nil, 7)
		M:SetButtonTemplate()
	end;
	MOD:ApplyDropdownStyle(HonorFrameTypeDropDown)
	HonorFrame.Inset:Formula409()
	HonorFrame.Inset:SetFixedPanelTemplate("Inset")
	MOD:ApplyScrollStyle(HonorFrameSpecificFrameScrollBar)
	HonorFrameSoloQueueButton:Formula409()
	HonorFrameGroupQueueButton:Formula409()
	HonorFrameSoloQueueButton:SetButtonTemplate()
	HonorFrameGroupQueueButton:SetButtonTemplate()
	HonorFrame.BonusFrame:Formula409()
	HonorFrame.BonusFrame.ShadowOverlay:Formula409()
	HonorFrame.BonusFrame.RandomBGButton:Formula409()
	HonorFrame.BonusFrame.RandomBGButton:SetFixedPanelTemplate("Button")
	HonorFrame.BonusFrame.RandomBGButton:SetButtonTemplate()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:FillInner()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	HonorFrame.BonusFrame.CallToArmsButton:Formula409()
	HonorFrame.BonusFrame.CallToArmsButton:SetFixedPanelTemplate("Button")
	HonorFrame.BonusFrame.CallToArmsButton:SetButtonTemplate()
	HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:FillInner()
	HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	HonorFrame.BonusFrame.DiceButton:DisableDrawLayer("ARTWORK")
	HonorFrame.BonusFrame.DiceButton:SetHighlightTexture("")
	HonorFrame.RoleInset:Formula409()
	HonorFrame.RoleInset.DPSIcon.checkButton:SetCheckboxTemplate(true)
	HonorFrame.RoleInset.TankIcon.checkButton:SetCheckboxTemplate(true)
	HonorFrame.RoleInset.HealerIcon.checkButton:SetCheckboxTemplate(true)
	HonorFrame.RoleInset.TankIcon:DisableDrawLayer("OVERLAY")
	HonorFrame.RoleInset.TankIcon:DisableDrawLayer("BACKGROUND")
	HonorFrame.RoleInset.HealerIcon:DisableDrawLayer("OVERLAY")
	HonorFrame.RoleInset.HealerIcon:DisableDrawLayer("BACKGROUND")
	HonorFrame.RoleInset.DPSIcon:DisableDrawLayer("OVERLAY")
	HonorFrame.RoleInset.DPSIcon:DisableDrawLayer("BACKGROUND")
	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(n)
		if n.bg then
			n.bg:SetDesaturated(true)
		end
	end)
	for g = 1, 2 do 
		local I = HonorFrame.BonusFrame["WorldPVP"..g.."Button"]
		I:Formula409()
		I:SetFixedPanelTemplate("Button", true)
		I:SetButtonTemplate()
		I.SelectedTexture:FillInner()
		I.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	end;
	ConquestFrame.Inset:Formula409()
	ConquestPointsBarLeft:MUNG()
	ConquestPointsBarRight:MUNG()
	ConquestPointsBarMiddle:MUNG()
	ConquestPointsBarBG:MUNG()
	ConquestPointsBarShadow:MUNG()
	ConquestPointsBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ConquestPointsBar:SetFixedPanelTemplate('Inset')
	ConquestPointsBar.Panel:WrapOuter(ConquestPointsBar, nil, -2)
	ConquestFrame:Formula409()
	ConquestFrame.ShadowOverlay:Formula409()
	ConquestJoinButton:Formula409()
	ConquestJoinButton:SetButtonTemplate()
	ConquestFrame.RatedBG:Formula409()
	ConquestFrame.RatedBG:SetFixedPanelTemplate("Inset")
	ConquestFrame.RatedBG:SetButtonTemplate()
	ConquestFrame.RatedBG.SelectedTexture:FillInner()
	ConquestFrame.RatedBG.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	WarGamesFrame:Formula409()
	WarGamesFrame.RightInset:Formula409()
	WarGamesFrameInfoScrollFrame:Formula409()
	WarGamesFrameInfoScrollFrameScrollBar:Formula409()
	WarGameStartButton:Formula409()
	WarGameStartButton:SetButtonTemplate()
	MOD:ApplyScrollStyle(WarGamesFrameScrollFrameScrollBar)
	MOD:ApplyScrollStyle(WarGamesFrameInfoScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:Formula409()
	PVPReadyDialog:Formula409()
	PVPReadyDialog:SetPanelTemplate("Pattern", true)
	PVPReadyDialogEnterBattleButton:SetButtonTemplate()
	PVPReadyDialogLeaveQueueButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(PVPReadyDialogCloseButton)
	PVPReadyDialogRoleIcon.texture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
	PVPReadyDialogRoleIcon.texture:SetAlpha(0.5)
	PVPUIFrame.LeftInset:Formula409()
	ConquestFrame.Inset:SetFixedPanelTemplate("Inset")
	WarGamesFrameScrollFrame:SetPanelTemplate("Inset",false,2,2,6)
	hooksecurefunc("PVPReadyDialog_Display", function(n, l, N, O, P, Q, R)
		if R == "DAMAGER" then
			PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
		elseif R == "TANK" then 
			PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
		elseif R == "HEALER" then 
			PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
		end;
		if P == "ARENA" then
			n:SetHeight(100)
		end;
		n.background:Hide()
	end)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle('Blizzard_PVPUI',PVPFrameStyle)