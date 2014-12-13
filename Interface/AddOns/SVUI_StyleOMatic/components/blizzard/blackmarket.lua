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
BLACKMARKET PLUGINR
##########################################################
]]--
local function BlackMarketStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.bmah ~= true then 
		return 
	end 

	local ChangeTab = function(p)
		p.Left:SetAlpha(0)
		if p.Middle then 
			p.Middle:SetAlpha(0)
		end 
		p.Right:SetAlpha(0)
	end 

	BlackMarketFrame:RemoveTextures()
	BlackMarketFrame:SetStylePanel("Default", "Halftone")
	BlackMarketFrame.Inset:RemoveTextures()
	BlackMarketFrame.Inset:SetStylePanel("Fixed", "Inset")
	PLUGIN:ApplyCloseButtonStyle(BlackMarketFrame.CloseButton)
	PLUGIN:ApplyScrollFrameStyle(BlackMarketScrollFrameScrollBar, 4)

	ChangeTab(BlackMarketFrame.ColumnName)
	ChangeTab(BlackMarketFrame.ColumnLevel)
	ChangeTab(BlackMarketFrame.ColumnType)
	ChangeTab(BlackMarketFrame.ColumnDuration)
	ChangeTab(BlackMarketFrame.ColumnHighBidder)
	ChangeTab(BlackMarketFrame.ColumnCurrentBid)

	BlackMarketFrame.MoneyFrameBorder:RemoveTextures()
	BlackMarketBidPriceGold:SetStylePanel("Editbox")
	BlackMarketBidPriceGold.Panel:SetPointToScale("TOPLEFT", -2, 0)
	BlackMarketBidPriceGold.Panel:SetPointToScale("BOTTOMRIGHT", -2, 0)
	BlackMarketFrame.BidButton:SetStylePanel("Button")
	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons;
		local r = #buttons;
		local s = HybridScrollFrame_GetOffset(BlackMarketScrollFrame)
		local t = C_BlackMarket.GetNumItems()
		for b = 1, r do 
			local u = buttons[b]
			local v = s+b;
			if not u.styled then 
				u:RemoveTextures()
				u:SetStylePanel("Button")
				PLUGIN:ApplyItemButtonStyle(u.Item)
				u.styled = true 
			end 
			if v <= t then 
				local w, x = C_BlackMarket.GetItemInfoByIndex(v)
				if w then 
					u.Item.IconTexture:SetTexture(x)
				end 
			end 
		end 
	end)
	BlackMarketFrame.HotDeal:RemoveTextures()
	PLUGIN:ApplyItemButtonStyle(BlackMarketFrame.HotDeal.Item)
	for b = 1, BlackMarketFrame:GetNumRegions()do 
		local y = select(b, BlackMarketFrame:GetRegions())
		if y and y:GetObjectType() == "FontString" and y:GetText() == BLACK_MARKET_TITLE then 
			y:ClearAllPoints()y:SetPoint("TOP", BlackMarketFrame, "TOP", 0, -4)
		end 
	end 
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_BlackMarketUI",BlackMarketStyle)