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
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
TRADESKILL STYLER
##########################################################
]]--
local function TradeSkillStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.tradeskill ~= true then
		 return 
	end;
	TradeSkillFrame:Formula409(true)
	TradeSkillListScrollFrame:Formula409()
	TradeSkillDetailScrollFrame:Formula409()
	TradeSkillFrameInset:Formula409()
	TradeSkillExpandButtonFrame:Formula409()
	TradeSkillDetailScrollChildFrame:Formula409()
	TradeSkillFrame:SetPanelTemplate("Action")
	TradeSkillRankFrame:Formula409()
	TradeSkillRankFrame:SetPanelTemplate("Slot", true, 1, 2, 2)
	TradeSkillRankFrame:SetStatusBarTexture(SuperVillain.Media.bar.default)
	TradeSkillListScrollFrame:SetFixedPanelTemplate("Inset")
	TradeSkillDetailScrollFrame:SetFixedPanelTemplate("Inset")
	TradeSkillFilterButton:Formula409(true)
	TradeSkillCreateButton:SetButtonTemplate()
	TradeSkillCancelButton:SetButtonTemplate()
	TradeSkillFilterButton:SetPanelTemplate("Button", true)
	TradeSkillFilterButton.Panel:SetAllPoints()
	TradeSkillCreateAllButton:SetButtonTemplate()
	TradeSkillViewGuildCraftersButton:SetButtonTemplate()
	MOD:ApplyScrollStyle(TradeSkillListScrollFrameScrollBar)
	MOD:ApplyScrollStyle(TradeSkillDetailScrollFrameScrollBar)
	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75)
	TradeSkillLinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)
	TradeSkillLinkButton:GetHighlightTexture():MUNG()
	TradeSkillLinkButton:SetPanelTemplate("Button", true)
	TradeSkillLinkButton:Size(17, 14)
	TradeSkillLinkButton:Point("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
	TradeSkillFrameSearchBox:SetEditboxTemplate()
	TradeSkillInputBox:SetEditboxTemplate()
	MOD:ApplyPaginationStyle(TradeSkillDecrementButton)
	MOD:ApplyPaginationStyle(TradeSkillIncrementButton)
	TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
	MOD:ApplyCloseButtonStyle(TradeSkillFrameCloseButton)
	local internalTest = false;
	hooksecurefunc("TradeSkillFrame_SetSelection", function(_)
		if TradeSkillSkillIcon:GetNormalTexture() then
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			TradeSkillSkillIcon:GetNormalTexture():FillInner()
			if not TradeSkillSkillIcon.Panel then
				TradeSkillSkillIcon:SetPanelTemplate("Slot")
			end 
		end;
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
				end;
				a2:WrapOuter(icon)
				a2:SetFixedPanelTemplate("Slot")
				icon:SetParent(a2)
				icon.backdrop = a2 
			end;
			a1:SetParent(icon.backdrop)
			a1:SetDrawLayer("OVERLAY")
			if i > 2 and internalTest == false then 
				local d, a3, f, g, h = u:GetPoint()
				u:ClearAllPoints()
				u:Point(d, a3, f, g, h-3)
				internalTest = true 
			end;
			_G["TradeSkillReagent"..i.."NameFrame"]:MUNG()
		end 
	end)
	TradeSkillGuildFrame:Formula409()
	TradeSkillGuildFrame:SetPanelTemplate("Halftone")
	TradeSkillGuildFrame:Point("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
	TradeSkillGuildFrameContainer:Formula409()
	TradeSkillGuildFrameContainer:SetPanelTemplate("Inset")
	MOD:ApplyCloseButtonStyle(TradeSkillGuildFrameCloseButton)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_TradeSkillUI",TradeSkillStyle)