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
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
TRADESKILL STYLER
##########################################################
]]--
local function TradeSkillStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.tradeskill ~= true then
		 return 
	end

	TradeSkillListScrollFrame:RemoveTextures()
	TradeSkillDetailScrollFrame:RemoveTextures()
	TradeSkillFrameInset:RemoveTextures()
	TradeSkillExpandButtonFrame:RemoveTextures()
	TradeSkillDetailScrollChildFrame:RemoveTextures()
	TradeSkillRankFrame:RemoveTextures()
	TradeSkillCreateButton:RemoveTextures(true)
	TradeSkillCancelButton:RemoveTextures(true)
	TradeSkillFilterButton:RemoveTextures(true)
	TradeSkillCreateAllButton:RemoveTextures(true)
	TradeSkillViewGuildCraftersButton:RemoveTextures(true)

	STYLE:ApplyWindowStyle(TradeSkillFrame, true, true)
	STYLE:ApplyWindowStyle(TradeSkillGuildFrame)

	TradeSkillGuildFrame:Point("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
	TradeSkillGuildFrameContainer:RemoveTextures()
	TradeSkillGuildFrameContainer:SetPanelTemplate("Inset")
	STYLE:ApplyCloseButtonStyle(TradeSkillGuildFrameCloseButton)

	TradeSkillRankFrame:SetPanelTemplate("Bar", true)
	TradeSkillRankFrame:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])
	TradeSkillListScrollFrame:SetPanelTemplate("Inset")
	TradeSkillDetailScrollFrame:SetPanelTemplate("Inset")

	TradeSkillCreateButton:SetButtonTemplate()
	TradeSkillCancelButton:SetButtonTemplate()
	TradeSkillFilterButton:SetButtonTemplate()
	TradeSkillCreateAllButton:SetButtonTemplate()
	TradeSkillViewGuildCraftersButton:SetButtonTemplate()

	STYLE:ApplyScrollFrameStyle(TradeSkillListScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(TradeSkillDetailScrollFrameScrollBar)

	TradeSkillLinkButton:Size(17, 14)
	TradeSkillLinkButton:Point("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
	TradeSkillLinkButton:SetButtonTemplate(nil, nil, nil, nil, true)
	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)

	TradeSkillFrameSearchBox:SetEditboxTemplate()
	TradeSkillInputBox:SetEditboxTemplate()

	STYLE:ApplyPaginationStyle(TradeSkillDecrementButton)
	STYLE:ApplyPaginationStyle(TradeSkillIncrementButton)

	TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
	STYLE:ApplyCloseButtonStyle(TradeSkillFrameCloseButton)

	TradeSkillSkillIcon:SetFixedPanelTemplate("Slot") 

	local internalTest = false;

	hooksecurefunc("TradeSkillFrame_SetSelection", function(_)
		TradeSkillSkillIcon:SetFixedPanelTemplate("Slot") 
		if TradeSkillSkillIcon:GetNormalTexture() then
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
		for i=1, MAX_TRADE_SKILL_REAGENTS do 
			local u = _G["TradeSkillReagent"..i]
			local icon = _G["TradeSkillReagent"..i.."IconTexture"]
			local a1 = _G["TradeSkillReagent"..i.."Count"]
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:SetDrawLayer("OVERLAY")
			if not icon.backdrop then 
				local a2 = CreateFrame("Frame", nil, u)
				if u:GetFrameLevel()-1 >= 0 then
					 a2:SetFrameLevel(u:GetFrameLevel()-1)
				else
					 a2:SetFrameLevel(0)
				end 
				a2:WrapOuter(icon)
				a2:SetFixedPanelTemplate("Slot")
				icon:SetParent(a2)
				icon.backdrop = a2 
			end 
			a1:SetParent(icon.backdrop)
			a1:SetDrawLayer("OVERLAY")
			if i > 2 and internalTest == false then 
				local d, a3, f, g, h = u:GetPoint()
				u:ClearAllPoints()
				u:Point(d, a3, f, g, h-3)
				internalTest = true 
			end 
			_G["TradeSkillReagent"..i.."NameFrame"]:Die()
		end 
	end)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_TradeSkillUI",TradeSkillStyle)