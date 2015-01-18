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
HELPERS
##########################################################
]]--
local MacroButtonList = {
	"MacroSaveButton", "MacroCancelButton", "MacroDeleteButton", "MacroNewButton", "MacroExitButton", "MacroEditButton", "MacroFrameTab1", "MacroFrameTab2", "MacroPopupOkayButton", "MacroPopupCancelButton"
}
local MacroButtonList2 = {
	"MacroDeleteButton", "MacroNewButton", "MacroExitButton"
}
--[[ 
########################################################## 
MACRO UI PLUGINR
##########################################################
]]--
local function MacroUIStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.macro ~= true then return end

	PLUGIN:ApplyWindowStyle(MacroFrame, true)

	PLUGIN:ApplyCloseButtonStyle(MacroFrameCloseButton)
	PLUGIN:ApplyScrollFrameStyle(MacroButtonScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(MacroFrameScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(MacroPopupScrollFrameScrollBar)

	MacroFrame:SetWidthToScale(360)

	local parentStrata = MacroFrame:GetFrameStrata()
	local parentLevel = MacroFrame:GetFrameLevel()

	for i = 1, #MacroButtonList do
		local button = _G[MacroButtonList[i]]
		if(button) then
			button:SetFrameStrata(parentStrata)
			button:SetFrameLevel(parentLevel + 1)
			button:RemoveTextures()
			button:SetStylePanel("Button", false, 1, 1, 1)
		end
	end 

	for i = 1, #MacroButtonList2 do
		local button = _G[MacroButtonList2[i]]
		if(button) then
			local a1,p,a2,x,y = button:GetPoint()
			button:SetPoint(a1,p,a2,x,-25)
		end
	end 

	local firstTab
	for i = 1, 2 do
		local tab = _G[("MacroFrameTab%d"):format(i)]
		if(tab) then
			tab:SetHeightToScale(22)
			if(i == 1) then
				tab:SetPointToScale("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
				firstTab = tab
			elseif(firstTab) then
				tab:SetPointToScale("LEFT", firstTab, "RIGHT", 4, 0)
			end
		end
	end 

	MacroFrameText:SetFont(SV.Media.font.default, 10, "OUTLINE")
	MacroFrameTextBackground:RemoveTextures()
	MacroFrameTextBackground:SetStylePanel("Frame", 'Transparent')

	MacroPopupFrame:RemoveTextures()
	MacroPopupFrame:SetStylePanel("Frame", 'Transparent')

	MacroPopupScrollFrame:RemoveTextures()
	MacroPopupScrollFrame:SetStylePanel("Frame", "Pattern")
	MacroPopupScrollFrame.Panel:SetPointToScale("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.Panel:SetPointToScale("BOTTOMRIGHT", -4, 4)
	MacroPopupEditBox:SetStylePanel("Editbox")
	MacroPopupNameLeft:SetTexture(0,0,0,0)
	MacroPopupNameMiddle:SetTexture(0,0,0,0)
	MacroPopupNameRight:SetTexture(0,0,0,0)

	MacroFrameInset:Die()

	MacroButtonContainer:RemoveTextures()
	PLUGIN:ApplyScrollFrameStyle(MacroButtonScrollFrame)
	MacroButtonScrollFrame:SetStylePanel("!_Frame", "Inset")

	MacroPopupFrame:HookScript("OnShow", function(c)
		c:ClearAllPoints()
		c:SetPointToScale("TOPLEFT", MacroFrame, "TOPRIGHT", 5, -2)
	end)

	MacroFrameSelectedMacroButton:SetFrameStrata(parentStrata)
	MacroFrameSelectedMacroButton:SetFrameLevel(parentLevel + 1)
	MacroFrameSelectedMacroButton:RemoveTextures()
	MacroFrameSelectedMacroButton:SetStylePanel("Slot")
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MacroFrameSelectedMacroButtonIcon:SetAllPointsIn()

	MacroEditButton:ClearAllPoints()
	MacroEditButton:SetPointToScale("BOTTOMLEFT", MacroFrameSelectedMacroButton.Panel, "BOTTOMRIGHT", 10, 0)

	MacroFrameCharLimitText:ClearAllPoints()
	MacroFrameCharLimitText:SetPointToScale("BOTTOM", MacroFrameTextBackground, -25, -35)

	for i = 1, MAX_ACCOUNT_MACROS do 
		local button = _G["MacroButton"..i]
		if(button) then
			button:RemoveTextures()
			button:SetStylePanel("Slot")

			local icon = _G["MacroButton"..i.."Icon"]
			if(icon) then
				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:SetAllPointsIn()
				icon:SetDrawLayer("OVERLAY")
			end

			local popup = _G["MacroPopupButton"..i]
			if(popup) then
				popup:RemoveTextures()
				popup:SetStylePanel("Button")
				popup:SetBackdropColor(0, 0, 0, 0)

				local popupIcon = _G["MacroPopupButton"..i.."Icon"]
				if(popupIcon) then
					popupIcon:SetAllPointsIn()
					popupIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				end
			end 
		end  
	end 
end 

--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_MacroUI", MacroUIStyle)