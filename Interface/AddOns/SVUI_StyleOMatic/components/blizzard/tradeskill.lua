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
TRADESKILL PLUGINR
##########################################################
]]--
local function TradeSkillStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.tradeskill ~= true then
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

	for i = 9, 18 do
		local lastLine = "TradeSkillSkill" .. (i - 1);
		local newLine = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
		newLine:SetPoint("TOPLEFT", lastLine, "BOTTOMLEFT", 0, 0)
	end
	_G.TRADE_SKILLS_DISPLAYED = 18;

	local curWidth,curHeight = TradeSkillFrame:GetSize()
	local enlargedHeight = curHeight + 170;
	TradeSkillFrame:SetSizeToScale(curWidth + 30, curHeight + 166)
	PLUGIN:ApplyWindowStyle(TradeSkillFrame, true, true)
	PLUGIN:ApplyWindowStyle(TradeSkillGuildFrame)

	TradeSkillGuildFrame:SetPointToScale("BOTTOMLEFT", TradeSkillFrame, "BOTTOMRIGHT", 3, 19)
	TradeSkillGuildFrameContainer:RemoveTextures()
	TradeSkillGuildFrameContainer:SetStylePanel("Frame", "Inset")
	PLUGIN:ApplyCloseButtonStyle(TradeSkillGuildFrameCloseButton)

	TradeSkillRankFrame:SetStylePanel("Frame", "Bar", true)
	TradeSkillRankFrame:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Bars\DEFAULT]])

	TradeSkillListScrollFrame:SetSizeToScale(327, 290)
	TradeSkillListScrollFrame:SetStylePanel("Frame", "Inset")
	TradeSkillDetailScrollFrame:SetSizeToScale(327, 180)
	TradeSkillDetailScrollFrame:SetStylePanel("Frame", "Inset")

	TradeSkillCreateButton:SetStylePanel("Button")
	TradeSkillCancelButton:SetStylePanel("Button")
	TradeSkillFilterButton:SetStylePanel("Button")
	TradeSkillCreateAllButton:SetStylePanel("Button")
	TradeSkillViewGuildCraftersButton:SetStylePanel("Button")

	PLUGIN:ApplyScrollFrameStyle(TradeSkillListScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(TradeSkillDetailScrollFrameScrollBar)

	TradeSkillLinkButton:SetSizeToScale(17, 14)
	TradeSkillLinkButton:SetPointToScale("LEFT", TradeSkillLinkFrame, "LEFT", 5, -1)
	TradeSkillLinkButton:SetStylePanel("Button", nil, nil, nil, nil, true)
	TradeSkillLinkButton:GetNormalTexture():SetTexCoord(0.25, 0.7, 0.45, 0.8)

	TradeSkillFrameSearchBox:SetStylePanel("Editbox")
	TradeSkillInputBox:SetStylePanel("Editbox")

	PLUGIN:ApplyPaginationStyle(TradeSkillDecrementButton)
	PLUGIN:ApplyPaginationStyle(TradeSkillIncrementButton)

	TradeSkillIncrementButton:SetPointToScale("RIGHT", TradeSkillCreateButton, "LEFT", -13, 0)
	PLUGIN:ApplyCloseButtonStyle(TradeSkillFrameCloseButton)

	TradeSkillSkillIcon:SetStylePanel("!_Frame", "Slot") 

	local internalTest = false;

	hooksecurefunc("TradeSkillFrame_SetSelection", function(_)
		TradeSkillSkillIcon:SetStylePanel("!_Frame", "Slot") 
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
				a2:SetAllPointsOut(icon)
				a2:SetStylePanel("!_Frame", "Slot")
				icon:SetParent(a2)
				icon.backdrop = a2 
			end 
			a1:SetParent(icon.backdrop)
			a1:SetDrawLayer("OVERLAY")
			if i > 2 and internalTest == false then 
				local d, a3, f, g, h = u:GetPoint()
				u:ClearAllPoints()
				u:SetPointToScale(d, a3, f, g, h-3)
				internalTest = true 
			end 
			_G["TradeSkillReagent"..i.."NameFrame"]:Die()
		end 
	end)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_TradeSkillUI",TradeSkillStyle)