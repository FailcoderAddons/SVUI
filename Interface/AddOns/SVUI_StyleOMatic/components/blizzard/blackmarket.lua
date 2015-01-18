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
local function ChangeTab(tab)
	tab.Left:SetAlpha(0)
	if tab.Middle then 
		tab.Middle:SetAlpha(0)
	end 
	tab.Right:SetAlpha(0)
end

local _hook_ScrollFrameUpdate = function()
	local self = BlackMarketScrollFrame;
	local buttons = self.buttons;
	local offset = HybridScrollFrame_GetOffset(self)
	local itemCount = C_BlackMarket.GetNumItems()
	for i = 1, #buttons do 
		local button = buttons[i];
		if(button) then
			local indexOffset = offset + i;
			if(not button.Panel) then 
				button:RemoveTextures()
				button:SetStylePanel("Button")
				PLUGIN:ApplyItemButtonStyle(button.Item)
			end 
			if indexOffset <= itemCount then 
				local name, texture = C_BlackMarket.GetItemInfoByIndex(indexOffset)
				if(name) then 
					button.Item.IconTexture:SetTexture(texture)
				end 
			end
		end
	end 
end

local function BlackMarketStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.bmah ~= true then 
		return 
	end 

	PLUGIN:ApplyWindowStyle(BlackMarketFrame)

	BlackMarketFrame.Inset:RemoveTextures()
	BlackMarketFrame.Inset:SetStylePanel("!_Frame", "Inset")

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

	hooksecurefunc("BlackMarketScrollFrame_Update", _hook_ScrollFrameUpdate)

	BlackMarketFrame.HotDeal:RemoveTextures()
	PLUGIN:ApplyItemButtonStyle(BlackMarketFrame.HotDeal.Item)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_BlackMarketUI",BlackMarketStyle)