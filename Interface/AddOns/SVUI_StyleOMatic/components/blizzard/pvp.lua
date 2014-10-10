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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
PVP STYLER
##########################################################
]]--
local _hook_PVPReadyDialogDisplay = function(self, _, _, _, queueType, _, queueRole)
	if(queueRole == "DAMAGER") then
		local coords = _G.LFDQueueFrameRoleButtonDPS.background:GetTexCoord()
		_G.PVPReadyDialogRoleIcon.texture:SetTexCoord(coords)
	elseif(queueRole == "TANK") then
		local coords = _G.LFDQueueFrameRoleButtonTank.background:GetTexCoord()
		_G.PVPReadyDialogRoleIcon.texture:SetTexCoord(coords)
	elseif(queueRole == "HEALER") then
		local coords = _G.LFDQueueFrameRoleButtonHealer.background:GetTexCoord()
		_G.PVPReadyDialogRoleIcon.texture:SetTexCoord(coords)
	end
	if(queueType == "ARENA") then
		self:SetHeight(100)
	end
end

local function PVPFrameStyle()
	if (SV.db[Schema] and (SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.pvp ~= true)) then
		return 
	end

	local HonorFrame = _G.HonorFrame;
	local ConquestFrame = _G.ConquestFrame;
	local PVPUIFrame = _G.PVPUIFrame;
	local WarGamesFrame = _G.WarGamesFrame;
	local PVPReadyDialog = _G.PVPReadyDialog;

	STYLE:ApplyWindowStyle(PVPUIFrame, true)
	
	STYLE:ApplyCloseButtonStyle(PVPUIFrameCloseButton)

	for g = 1, 2 do
		STYLE:ApplyTabStyle(_G["PVPUIFrameTab"..g])
	end

	for i = 1, 3 do 
		local btn = _G["PVPQueueFrameCategoryButton"..i]
		if(btn) then
			btn.Background:Die()
			btn.Ring:Die()
			btn:SetButtonTemplate()
			btn.Icon:Size(45)
			btn.Icon:SetTexCoord(.15, .85, .15, .85)
			btn.Icon:SetDrawLayer("OVERLAY", nil, 7)
			btn.Panel:WrapOuter(btn.Icon)
		end
	end

	STYLE:ApplyDropdownStyle(HonorFrameTypeDropDown)
	HonorFrame.Inset:RemoveTextures()
	HonorFrame.Inset:SetFixedPanelTemplate("Inset")
	STYLE:ApplyScrollFrameStyle(HonorFrameSpecificFrameScrollBar)
	HonorFrameSoloQueueButton:RemoveTextures()
	HonorFrameGroupQueueButton:RemoveTextures()
	HonorFrameSoloQueueButton:SetButtonTemplate()
	HonorFrameGroupQueueButton:SetButtonTemplate()
	HonorFrame.BonusFrame:RemoveTextures()
	HonorFrame.BonusFrame.ShadowOverlay:RemoveTextures()
	HonorFrame.BonusFrame.RandomBGButton:RemoveTextures()
	HonorFrame.BonusFrame.RandomBGButton:SetFixedPanelTemplate("Button")
	HonorFrame.BonusFrame.RandomBGButton:SetButtonTemplate()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:FillInner()
	HonorFrame.BonusFrame.RandomBGButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)

	if(SV.GameVersion < 60000) then
		PVPUIFrame.Shadows:RemoveTextures()
		HonorFrame.BonusFrame.CallToArmsButton:RemoveTextures()
		HonorFrame.BonusFrame.CallToArmsButton:SetFixedPanelTemplate("Button")
		HonorFrame.BonusFrame.CallToArmsButton:SetButtonTemplate()
		HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:FillInner()
		HonorFrame.BonusFrame.CallToArmsButton.SelectedTexture:SetTexture(1, 1, 0, 0.1)
		for g = 1, 2 do 
			local I = HonorFrame.BonusFrame["WorldPVP"..g.."Button"]
			I:RemoveTextures()
			I:SetFixedPanelTemplate("Button", true)
			I:SetButtonTemplate()
			I.SelectedTexture:FillInner()
			I.SelectedTexture:SetTexture(1, 1, 0, 0.1)
		end
		PVPUIFrame.LeftInset:RemoveTextures()
	end
		
	HonorFrame.BonusFrame.DiceButton:DisableDrawLayer("ARTWORK")
	HonorFrame.BonusFrame.DiceButton:SetHighlightTexture("")
	HonorFrame.RoleInset:RemoveTextures()
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
	
	local ConquestPointsBar = _G.ConquestPointsBar;
	
	ConquestFrame.Inset:RemoveTextures()
	ConquestPointsBarLeft:Die()
	ConquestPointsBarRight:Die()
	ConquestPointsBarMiddle:Die()
	ConquestPointsBarBG:Die()
	ConquestPointsBarShadow:Die()
	ConquestPointsBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	ConquestPointsBar:SetFixedPanelTemplate('Inset')
	ConquestPointsBar.Panel:WrapOuter(ConquestPointsBar, nil, -2)
	ConquestFrame:RemoveTextures()
	ConquestFrame.ShadowOverlay:RemoveTextures()
	ConquestJoinButton:RemoveTextures()
	ConquestJoinButton:SetButtonTemplate()
	ConquestFrame.RatedBG:RemoveTextures()
	ConquestFrame.RatedBG:SetFixedPanelTemplate("Inset")
	ConquestFrame.RatedBG:SetButtonTemplate()
	ConquestFrame.RatedBG.SelectedTexture:FillInner()
	ConquestFrame.RatedBG.SelectedTexture:SetTexture(1, 1, 0, 0.1)
	WarGamesFrame:RemoveTextures()
	WarGamesFrame.RightInset:RemoveTextures()
	WarGamesFrameInfoScrollFrame:RemoveTextures()
	WarGamesFrameInfoScrollFrameScrollBar:RemoveTextures()
	WarGameStartButton:RemoveTextures()
	WarGameStartButton:SetButtonTemplate()
	STYLE:ApplyScrollFrameStyle(WarGamesFrameScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(WarGamesFrameInfoScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:RemoveTextures()
	
	PVPReadyDialog:RemoveTextures()
	PVPReadyDialog:SetPanelTemplate("Pattern")
	PVPReadyDialogEnterBattleButton:SetButtonTemplate()
	PVPReadyDialogLeaveQueueButton:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(PVPReadyDialogCloseButton)
	PVPReadyDialogRoleIcon.texture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
	PVPReadyDialogRoleIcon.texture:SetAlpha(0.5)
	
	ConquestFrame.Inset:SetFixedPanelTemplate("Inset")
	WarGamesFrameScrollFrame:SetPanelTemplate("Inset",false,2,2,6)

	hooksecurefunc("PVPReadyDialog_Display", _hook_PVPReadyDialogDisplay)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle('Blizzard_PVPUI', PVPFrameStyle, true)

-- /script StaticPopupSpecial_Show(PVPReadyDialog)