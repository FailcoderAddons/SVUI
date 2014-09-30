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
local SV = _G["SVUI"];
local L = SV.L;
local STYLE = _G.StyleOMatic
--[[ 
########################################################## 
AUCTIONLITE
##########################################################
]]--
local function BGHelper(parent)
  parent.bg = CreateFrame("Frame", nil, parent)
  parent.bg:SetFixedPanelTemplate("Inset")
  parent.bg:Point("TOPLEFT", parent, "TOPLEFT", 16, -103)
  parent.bg:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 36)
  parent.bg:SetFrameLevel(parent.bg:GetFrameLevel() - 1)
end

local function StyleAuctionLite(event, ...)
  assert(AuctionFrameTab4, "AddOn Not Loaded")
  if(not event or (event and event == 'PLAYER_ENTERING_WORLD')) then return; end

  BuyName:SetEditboxTemplate()
  BuyQuantity:SetEditboxTemplate()
  SellStacks:SetEditboxTemplate()
  SellSize:SetEditboxTemplate()
  SellBidPriceGold:SetEditboxTemplate()
  SellBidPriceSilver:SetEditboxTemplate()
  SellBidPriceCopper:SetEditboxTemplate()
  SellBuyoutPriceGold:SetEditboxTemplate()
  SellBuyoutPriceSilver:SetEditboxTemplate()
  SellBuyoutPriceCopper:SetEditboxTemplate()

  BuySearchButton:SetButtonTemplate()
  BuyBidButton:SetButtonTemplate()
  BuyBuyoutButton:SetButtonTemplate()
  BuyCancelSearchButton:SetButtonTemplate()
  BuyCancelAuctionButton:SetButtonTemplate()
  BuyScanButton:SetButtonTemplate()
  SellCreateAuctionButton:SetButtonTemplate()

  STYLE:ApplyPaginationStyle(BuyAdvancedButton)
  STYLE:ApplyPaginationStyle(SellRememberButton)

  STYLE:ApplyTabStyle(AuctionFrameTab4)
  STYLE:ApplyTabStyle(AuctionFrameTab5)

  if(_G["AuctionFrameBuy"]) then
    BGHelper(_G["AuctionFrameBuy"])
  end
  if(_G["AuctionFrameSell"]) then
    BGHelper(_G["AuctionFrameSell"])
  end

  STYLE:SafeEventRemoval("AuctionLite", event)
end

STYLE:SaveAddonStyle("AuctionLite", StyleAuctionLite, nil, nil, "AUCTION_HOUSE_SHOW")