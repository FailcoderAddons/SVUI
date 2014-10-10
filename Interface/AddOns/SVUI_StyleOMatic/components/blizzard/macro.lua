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
MACRO UI STYLER
##########################################################
]]--
local function MacroUIStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.macro ~= true then return end

	local MacroFrame = _G.MacroFrame;
	local MacroFrameCloseButton = _G.MacroFrameCloseButton;
	local MacroButtonScrollFrameScrollBar = _G.MacroButtonScrollFrameScrollBar;
	local MacroFrameScrollFrameScrollBar = _G.MacroFrameScrollFrameScrollBar;
	local MacroPopupScrollFrameScrollBar = _G.MacroPopupScrollFrameScrollBar;

	local MacroPopupScrollFrame = _G.MacroPopupScrollFrame;
	local MacroPopupFrame = _G.MacroPopupFrame;
	local MacroFrameSelectedMacroButton = _G.MacroFrameSelectedMacroButton;
	local MacroFrameSelectedMacroButtonIcon = _G.MacroFrameSelectedMacroButtonIcon;

	STYLE:ApplyCloseButtonStyle(MacroFrameCloseButton)
	STYLE:ApplyScrollFrameStyle(MacroButtonScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(MacroFrameScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(MacroPopupScrollFrameScrollBar)

	MacroFrame:Width(360)

	for i = 1, #MacroButtonList do
		local button = _G[MacroButtonList[i]]
		if(button) then
			button:RemoveTextures()
			button:SetButtonTemplate()
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
			tab:Height(22)
			if(i == 1) then
				tab:Point("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
				firstTab = tab
			elseif(firstTab) then
				tab:Point("LEFT", firstTab, "RIGHT", 4, 0)
			end
		end
	end 

	MacroFrame:RemoveTextures()
	MacroFrame:SetPanelTemplate("Action")
	MacroFrame.Panel:SetPoint("BOTTOMRIGHT",MacroFrame,"BOTTOMRIGHT",0,-25)
	MacroFrameText:SetFont(SV.Media.font.roboto, 10, "OUTLINE")
	MacroFrameTextBackground:RemoveTextures()
	MacroFrameTextBackground:SetBasicPanel()

	MacroPopupFrame:RemoveTextures()
	MacroPopupFrame:SetBasicPanel()

	MacroPopupScrollFrame:RemoveTextures()
	MacroPopupScrollFrame:SetPanelTemplate("Pattern")
	MacroPopupScrollFrame.Panel:Point("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.Panel:Point("BOTTOMRIGHT", -4, 4)
	MacroButtonScrollFrame:SetBasicPanel()
	MacroPopupEditBox:SetEditboxTemplate()
	MacroPopupNameLeft:SetTexture(0,0,0,0)
	MacroPopupNameMiddle:SetTexture(0,0,0,0)
	MacroPopupNameRight:SetTexture(0,0,0,0)

	MacroFrameInset:Die()
	MacroEditButton:ClearAllPoints()
	MacroEditButton:Point("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)

	STYLE:ApplyScrollFrameStyle(MacroButtonScrollFrame)

	MacroPopupFrame:HookScript("OnShow", function(c)
		c:ClearAllPoints()
		c:Point("TOPLEFT", MacroFrame, "TOPRIGHT", 5, -2)
	end)

	MacroFrameSelectedMacroButton:RemoveTextures()
	MacroFrameSelectedMacroButton:SetSlotTemplate()
	MacroFrameSelectedMacroButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MacroFrameSelectedMacroButtonIcon:FillInner()
	MacroFrameCharLimitText:ClearAllPoints()
	MacroFrameCharLimitText:Point("BOTTOM", MacroFrameTextBackground, -25, -35)

	for b = 1, MAX_ACCOUNT_MACROS do 
		local d = _G["MacroButton"..b]
		local e = _G["MacroButton"..b.."Icon"]
		local f = _G["MacroPopupButton"..b]
		local g = _G["MacroPopupButton"..b.."Icon"]
		if d then
			d:RemoveTextures()
			d:SetButtonTemplate()
			local level = d:GetFrameLevel()
			if(level > 0) then 
				d.Panel:SetFrameLevel(level - 1)
			else 
				d.Panel:SetFrameLevel(0)
			end
			d:SetBackdropColor(0, 0, 0, 0)
		end 
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:FillInner()
			e:SetDrawLayer("OVERLAY")
		end 
		if f then
			f:RemoveTextures()
			f:SetButtonTemplate()
			f:SetBackdropColor(0, 0, 0, 0)
		end 
		if g then
			g:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			g:FillInner()
		end 
	end 
end 

--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_MacroUI", MacroUIStyle)