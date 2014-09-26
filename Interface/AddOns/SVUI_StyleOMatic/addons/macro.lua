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
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
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
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.macro ~= true then return end 
	STYLE:ApplyCloseButtonStyle(MacroFrameCloseButton)
	STYLE:ApplyScrollFrameStyle(MacroButtonScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(MacroFrameScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(MacroPopupScrollFrameScrollBar)
	MacroFrame:Width(360)
	for b = 1, #MacroButtonList do
		_G[MacroButtonList[b]]:RemoveTextures()
		_G[MacroButtonList[b]]:SetButtonTemplate()
	end 
	for b = 1, #MacroButtonList2 do
		local a1,p,a2,x,y = _G[MacroButtonList2[b]]:GetPoint()
		_G[MacroButtonList2[b]]:SetPoint(a1,p,a2,x,-25)
	end 
	for b = 1, 2 do
		tab = _G[format("MacroFrameTab%s", b)]
		tab:Height(22)
	end 
	MacroFrameTab1:Point("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
	MacroFrameTab2:Point("LEFT", MacroFrameTab1, "RIGHT", 4, 0)
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