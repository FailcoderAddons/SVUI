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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
TSDW
##########################################################
]]--
local function StyleTradeSkillDW()
	assert(TradeSkillDW_QueueFrame, "AddOn Not Loaded")

	TradeSkillFrame:SetPanelTemplate("Action")
	TradeSkillListScrollFrame:RemoveTextures(true)
	TradeSkillDetailScrollFrame:RemoveTextures(true)
	TradeSkillFrameInset:RemoveTextures(true)
	TradeSkillExpandButtonFrame:RemoveTextures(true)
	TradeSkillDetailScrollChildFrame:RemoveTextures(true)
	TradeSkillListScrollFrame:RemoveTextures(true)
	PLUGIN:ApplyFrameStyle(TradeSkillGuildFrame,"Transparent")
	PLUGIN:ApplyFrameStyle(TradeSkillGuildFrameContainer,"Transparent")
	TradeSkillGuildFrame:Point("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
	PLUGIN:ApplyCloseButtonStyle(TradeSkillGuildFrameCloseButton)

	TradeSkillFrame:HookScript("OnShow", function() 
		PLUGIN:ApplyFrameStyle(TradeSkillFrame) 
		TradeSkillListScrollFrame:RemoveTextures() 
		if not TradeSkillDWExpandButton then return end 
		if not TradeSkillDWExpandButton.styled then 
			PLUGIN:ApplyPaginationStyle(TradeSkillDWExpandButton) 
			TradeSkillDWExpandButton.styled = true 
		end
	end)
	
	TradeSkillFrame:Height(TradeSkillFrame:GetHeight() + 12)
	TradeSkillRankFrame:SetBasicPanel()
	TradeSkillRankFrame:SetStatusBarTexture(SV.Media.bar.default)
	TradeSkillCreateButton:SetButtonTemplate()
	TradeSkillCancelButton:SetButtonTemplate()
	TradeSkillFilterButton:SetButtonTemplate()
	TradeSkillCreateAllButton:SetButtonTemplate()
	TradeSkillViewGuildCraftersButton:SetButtonTemplate()
	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.37, 0.75)
	TradeSkillLinkButton:GetPushedTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)
	TradeSkillLinkButton:GetHighlightTexture():Die()
	PLUGIN:ApplyFrameStyle(TradeSkillLinkButton,"Transparent")
	TradeSkillLinkButton:Size(17, 14)
	TradeSkillLinkButton:Point("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
	TradeSkillFrameSearchBox:SetEditboxTemplate()
	TradeSkillInputBox:SetEditboxTemplate()
	TradeSkillIncrementButton:Point("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
	PLUGIN:ApplyCloseButtonStyle(TradeSkillFrameCloseButton)
	PLUGIN:ApplyScrollFrameStyle(TradeSkillDetailScrollFrameScrollBar)
	local once = false
	hooksecurefunc("TradeSkillFrame_SetSelection", function(id)
		TradeSkillSkillIcon:SetButtonTemplate()

		if TradeSkillSkillIcon:GetNormalTexture() then
			TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(0.1,0.9,0.1,0.9)
			TradeSkillSkillIcon:GetNormalTexture():ClearAllPoints()
			TradeSkillSkillIcon:GetNormalTexture():Point("TOPLEFT", 2, -2)
			TradeSkillSkillIcon:GetNormalTexture():Point("BOTTOMRIGHT", -2, 2)
		end

		for i = 1, MAX_TRADE_SKILL_REAGENTS do
			local button = _G["TradeSkillReagent"..i]
			local icon = _G["TradeSkillReagent"..i.."IconTexture"]
			local count = _G["TradeSkillReagent"..i.."Count"]
			icon:SetTexCoord(0.1,0.9,0.1,0.9)
			icon:SetDrawLayer("OVERLAY")
			if not icon.backdrop then
				icon.backdrop = CreateFrame("Frame", nil, button)
				icon.backdrop:SetFrameLevel(button:GetFrameLevel() - 1)
				PLUGIN:ApplyFrameStyle(icon.backdrop,"Transparent")
				icon.backdrop:Point("TOPLEFT", icon, "TOPLEFT", -2, 2)
				icon.backdrop:Point("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
			end
			icon:SetParent(icon.backdrop)
			count:SetParent(icon.backdrop)
			count:SetDrawLayer("OVERLAY")
			if i > 2 and once == false then
				local point, anchoredto, point2, x, y = button:GetPoint()
				button:ClearAllPoints()
				button:Point(point, anchoredto, point2, x, y - 3)
				once = true
			end
			_G["TradeSkillReagent"..i.."NameFrame"]:Die()
		end
	end)

	TradeSkillDW_QueueFrame:HookScript("OnShow", function() PLUGIN:ApplyFrameStyle(TradeSkillDW_QueueFrame,"Transparent") end)

	PLUGIN:ApplyCloseButtonStyle(TradeSkillDW_QueueFrameCloseButton)

	TradeSkillDW_QueueFrameInset:RemoveTextures()
	TradeSkillDW_QueueFrameClear:SetButtonTemplate()
	TradeSkillDW_QueueFrameDown:SetButtonTemplate()
	TradeSkillDW_QueueFrameUp:SetButtonTemplate()
	TradeSkillDW_QueueFrameDo:SetButtonTemplate()
	TradeSkillDW_QueueFrameDetailScrollFrame:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrame:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent1:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent2:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent3:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent4:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent5:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent6:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent7:RemoveTextures()
	TradeSkillDW_QueueFrameDetailScrollFrameChildFrameReagent8:RemoveTextures()
	PLUGIN:ApplyScrollFrameStyle(TradeSkillDW_QueueFrameDetailScrollFrameScrollBar)
	TradeSkillListScrollFrame:RemoveTextures()
end
PLUGIN:SaveAddonStyle("TradeSkillDW", StyleTradeSkillDW)