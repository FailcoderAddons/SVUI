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
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
PVP PLUGINR
##########################################################
]]--
local _hook_PVPReadyDialogDisplay = function(self, _, _, _, queueType, _, queueRole)
	if(queueRole == "DAMAGER") then
		PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
	elseif(queueRole == "TANK") then
		PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
	elseif(queueRole == "HEALER") then
		PVPReadyDialogRoleIcon.texture:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
	end
	if(queueType == "ARENA") then
		self:SetHeight(100)
	end
end

local function PVPFrameStyle()
	if (PLUGIN.db and (PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.pvp ~= true)) then
		return 
	end

	local HonorFrame = _G.HonorFrame;
	local ConquestFrame = _G.ConquestFrame;
	local PVPUIFrame = _G.PVPUIFrame;
	local WarGamesFrame = _G.WarGamesFrame;
	local PVPReadyDialog = _G.PVPReadyDialog;

	PLUGIN:ApplyWindowStyle(PVPUIFrame, true)
	
	PLUGIN:ApplyCloseButtonStyle(PVPUIFrameCloseButton)

	for g = 1, 2 do
		PLUGIN:ApplyTabStyle(_G["PVPUIFrameTab"..g])
	end

	for i = 1, 4 do 
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

	PLUGIN:ApplyDropdownStyle(HonorFrameTypeDropDown)
	HonorFrame.Inset:RemoveTextures()
	HonorFrame.Inset:SetFixedPanelTemplate("Inset")
	PLUGIN:ApplyScrollFrameStyle(HonorFrameSpecificFrameScrollBar)
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
	PLUGIN:ApplyScrollFrameStyle(WarGamesFrameScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(WarGamesFrameInfoScrollFrameScrollBar)
	WarGamesFrame.HorizontalBar:RemoveTextures()
	
	PVPReadyDialog:RemoveTextures()
	PVPReadyDialog:SetPanelTemplate("Pattern")
	PVPReadyDialogEnterBattleButton:SetButtonTemplate()
	PVPReadyDialogLeaveQueueButton:SetButtonTemplate()
	PLUGIN:ApplyCloseButtonStyle(PVPReadyDialogCloseButton)
	PVPReadyDialogRoleIcon.texture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
	PVPReadyDialogRoleIcon.texture:SetAlpha(0.5)
	
	ConquestFrame.Inset:SetFixedPanelTemplate("Inset")
	WarGamesFrameScrollFrame:SetPanelTemplate("Inset",false,2,2,6)

	hooksecurefunc("PVPReadyDialog_Display", _hook_PVPReadyDialogDisplay)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle('Blizzard_PVPUI', PVPFrameStyle, true)

-- /script StaticPopupSpecial_Show(PVPReadyDialog)