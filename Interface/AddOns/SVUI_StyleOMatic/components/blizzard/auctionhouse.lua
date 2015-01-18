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
local pairs   = _G.pairs;
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
local AuctionSortLinks = {
	"BrowseQualitySort", 
	"BrowseLevelSort", 
	"BrowseDurationSort", 
	"BrowseHighBidderSort", 
	"BrowseCurrentBidSort", 
	"BidQualitySort", 
	"BidLevelSort", 
	"BidDurationSort", 
	"BidBuyoutSort", 
	"BidStatusSort", 
	"BidBidSort", 
	"AuctionsQualitySort", 
	"AuctionsDurationSort", 
	"AuctionsHighBidderSort", 
	"AuctionsBidSort"
}
local AuctionBidButtons = {
	"BrowseBidButton", 
	"BidBidButton", 
	"BrowseBuyoutButton", 
	"BidBuyoutButton", 
	"BrowseCloseButton", 
	"BidCloseButton", 
	"BrowseSearchButton", 
	"AuctionsCreateAuctionButton", 
	"AuctionsCancelAuctionButton", 
	"AuctionsCloseButton", 
	"BrowseResetButton", 
	"AuctionsStackSizeMaxButton", 
	"AuctionsNumStacksMaxButton",
}

local AuctionTextFields = {
	"BrowseName", 
	"BrowseMinLevel", 
	"BrowseMaxLevel", 
	"BrowseBidPriceGold", 
	"BidBidPriceGold", 
	"AuctionsStackSizeEntry", 
	"AuctionsNumStacksEntry", 
	"StartPriceGold", 
	"BuyoutPriceGold",
	"BrowseBidPriceSilver", 
	"BrowseBidPriceCopper", 
	"BidBidPriceSilver", 
	"BidBidPriceCopper", 
	"StartPriceSilver", 
	"StartPriceCopper", 
	"BuyoutPriceSilver", 
	"BuyoutPriceCopper"
}
--[[ 
########################################################## 
AUCTIONFRAME PLUGINR
##########################################################
]]--
local function AuctionStyle()
	--PLUGIN.Debugging = true
	if(PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.auctionhouse ~= true) then return end 

	PLUGIN:ApplyWindowStyle(AuctionFrame, false, true)
	
	BrowseFilterScrollFrame:RemoveTextures()
	BrowseScrollFrame:RemoveTextures()
	AuctionsScrollFrame:RemoveTextures()
	BidScrollFrame:RemoveTextures()

	PLUGIN:ApplyCloseButtonStyle(AuctionFrameCloseButton)
	PLUGIN:ApplyScrollFrameStyle(AuctionsScrollFrameScrollBar)

	PLUGIN:ApplyDropdownStyle(BrowseDropDown)
	PLUGIN:ApplyDropdownStyle(PriceDropDown)
	PLUGIN:ApplyDropdownStyle(DurationDropDown)
	PLUGIN:ApplyScrollFrameStyle(BrowseFilterScrollFrameScrollBar)
	PLUGIN:ApplyScrollFrameStyle(BrowseScrollFrameScrollBar)
	IsUsableCheckButton:SetStylePanel("Checkbox", true)
	ShowOnPlayerCheckButton:SetStylePanel("Checkbox", true)
	
	--ExactMatchCheckButton:SetStylePanel("Checkbox", true)
	--SideDressUpFrame:SetPoint("LEFT", AuctionFrame, "RIGHT", 16, 0)

	AuctionProgressFrame:RemoveTextures()
	AuctionProgressFrame:SetStylePanel("!_Frame", "Transparent", true)
	AuctionProgressFrameCancelButton:SetStylePanel("Button")
	AuctionProgressFrameCancelButton:SetStylePanel("!_Frame", "Default")
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():SetAllPointsIn()
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
	AuctionProgressFrameCancelButton:SetSizeToScale(28, 28)
	AuctionProgressFrameCancelButton:SetPointToScale("LEFT", AuctionProgressBar, "RIGHT", 8, 0)
	AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)

	local AuctionProgressBarBG = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
	AuctionProgressBarBG:SetAllPointsOut(AuctionProgressBarIcon)
	AuctionProgressBarBG:SetStylePanel("!_Frame", "Default")
	AuctionProgressBarIcon:SetParent(AuctionProgressBarBG)

	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint("CENTER")
	AuctionProgressBar:RemoveTextures()
	AuctionProgressBar:SetStylePanel("Frame", "Default")
	AuctionProgressBar:SetStatusBarTexture(SV.Media.bar.default)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)

	PLUGIN:ApplyPaginationStyle(BrowseNextPageButton)
	PLUGIN:ApplyPaginationStyle(BrowsePrevPageButton)

	for _,gName in pairs(AuctionBidButtons) do
		if(_G[gName]) then
			_G[gName]:RemoveTextures()
			_G[gName]:SetStylePanel("Button")
		end
	end 

	AuctionsCloseButton:SetPointToScale("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
	AuctionsCancelAuctionButton:SetPointToScale("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)

	BidBuyoutButton:SetPointToScale("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:SetPointToScale("RIGHT", BidBuyoutButton, "LEFT", -4, 0)

	BrowseBuyoutButton:SetPointToScale("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:SetPointToScale("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)

	AuctionsItemButton:RemoveTextures()
	AuctionsItemButton:SetStylePanel("Button")
	AuctionsItemButton:SetScript("OnUpdate", function()
		if AuctionsItemButton:GetNormalTexture()then 
			AuctionsItemButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			AuctionsItemButton:GetNormalTexture():SetAllPointsIn()
		end 
	end)
	
	for _,frame in pairs(AuctionSortLinks)do 
		_G[frame.."Left"]:Die()
		_G[frame.."Middle"]:Die()
		_G[frame.."Right"]:Die()
	end 

	PLUGIN:ApplyTabStyle(_G["AuctionFrameTab1"])
	PLUGIN:ApplyTabStyle(_G["AuctionFrameTab2"])
	PLUGIN:ApplyTabStyle(_G["AuctionFrameTab3"])

	AuctionFrameBrowse.bg1 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg1:SetPointToScale("TOPLEFT", 20, -103)
	AuctionFrameBrowse.bg1:SetPointToScale("BOTTOMRIGHT", -575, 40)
	AuctionFrameBrowse.bg1:SetStylePanel("!_Frame", "Inset")

	BrowseNoResultsText:SetParent(AuctionFrameBrowse.bg1)
	BrowseSearchCountText:SetParent(AuctionFrameBrowse.bg1)

	BrowseSearchButton:SetPointToScale("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)
	BrowseResetButton:SetPointToScale("TOPRIGHT", BrowseSearchButton, "TOPLEFT", -4, 0)

	AuctionFrameBrowse.bg1:SetFrameLevel(AuctionFrameBrowse.bg1:GetFrameLevel()-1)
	BrowseFilterScrollFrame:SetHeightToScale(300)
	AuctionFrameBrowse.bg2 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg2:SetStylePanel("!_Frame", "Inset")
	AuctionFrameBrowse.bg2:SetPointToScale("TOPLEFT", AuctionFrameBrowse.bg1, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.bg2:SetPointToScale("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 40)
	AuctionFrameBrowse.bg2:SetFrameLevel(AuctionFrameBrowse.bg2:GetFrameLevel() - 1)

	for i = 1, NUM_FILTERS_TO_DISPLAY do 
		local header = _G[("AuctionFilterButton%d"):format(i)]
		if(header) then
			header:RemoveTextures()
			header:SetStylePanel("Button")
		end
	end 

	for _,field in pairs(AuctionTextFields)do
		_G[field]:SetStylePanel("Editbox")
		_G[field]:SetTextInsets(-1, -1, -2, -2)
	end

	BrowseMinLevel:ClearAllPoints()
	BrowseMinLevel:SetPointToScale("LEFT", BrowseName, "RIGHT", 8, 0)
	BrowseMaxLevel:ClearAllPoints()
	BrowseMaxLevel:SetPointToScale("LEFT", BrowseMinLevel, "RIGHT", 8, 0)
	AuctionsStackSizeEntry.Panel:SetAllPoints()
	AuctionsNumStacksEntry.Panel:SetAllPoints()

	for h = 1, NUM_BROWSE_TO_DISPLAY do 
		local button = _G["BrowseButton"..h];
		local buttonItem = _G["BrowseButton"..h.."Item"];
		local buttonTex = _G["BrowseButton"..h.."ItemIconTexture"];

		if(button and (not button.Panel)) then 
			button:RemoveTextures()
			button:SetStylePanel("Button", false, 1, 1, 1)
			button.Panel:ClearAllPoints()
			button.Panel:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
			button.Panel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 5)

			if(buttonItem) then
				buttonItem:RemoveTextures()
				buttonItem:SetStylePanel("Icon", false, 2, 0, 0)
				if(buttonTex) then
					buttonTex:SetParent(buttonItem.Panel)
					buttonTex:SetAllPointsIn(buttonItem.Panel, 2, 2)
					buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
					buttonTex:SetDesaturated(false)
				end

				local highLight = button:GetHighlightTexture()
				highLight:ClearAllPoints()
				highLight:SetPointToScale("TOPLEFT", buttonItem, "TOPRIGHT", 2, -2)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 7)
				button:GetPushedTexture():SetAllPoints(highLight)
				_G["BrowseButton"..h.."Highlight"] = highLight
			end 
		end 
	end 

	for h = 1, NUM_AUCTIONS_TO_DISPLAY do 
		local button = _G["AuctionsButton"..h];
		local buttonItem = _G["AuctionsButton"..h.."Item"];
		local buttonTex = _G["AuctionsButton"..h.."ItemIconTexture"];

		if(button) then
			if(buttonTex) then 
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:SetAllPointsIn()
				buttonTex:SetDesaturated(false)
			end 

			button:RemoveTextures()
			button:SetStylePanel("Button")

			if(buttonItem) then 
				buttonItem:SetStylePanel("Button")
				buttonItem.Panel:SetAllPoints()
				buttonItem:HookScript("OnUpdate", function()
					buttonItem:GetNormalTexture():Die()
				end)

				local highLight = button:GetHighlightTexture()
				_G["AuctionsButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:SetPointToScale("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end 
		end
	end 

	for h = 1, NUM_BIDS_TO_DISPLAY do 	
		local button = _G["BidButton"..h];
		local buttonItem = _G["BidButton"..h.."Item"];
		local buttonTex = _G["BidButton"..h.."ItemIconTexture"];

		if(button) then
			if(buttonTex) then 
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:SetAllPointsIn()
				buttonTex:SetDesaturated(false)
			end 

			button:RemoveTextures()
			button:SetStylePanel("Button")

			if(buttonItem) then 
				buttonItem:SetStylePanel("Button")
				buttonItem.Panel:SetAllPoints()
				buttonItem:HookScript("OnUpdate", function()
					buttonItem:GetNormalTexture():Die()
				end)

				local highLight = button:GetHighlightTexture()
				_G["BidButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:SetPointToScale("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end 
		end
	end 

	BrowseScrollFrame:SetHeightToScale(300)
	AuctionFrameBid.bg = CreateFrame("Frame", nil, AuctionFrameBid)
	AuctionFrameBid.bg:SetStylePanel("!_Frame", "Inset")
	AuctionFrameBid.bg:SetPointToScale("TOPLEFT", 22, -72)
	AuctionFrameBid.bg:SetPointToScale("BOTTOMRIGHT", 66, 39)
	AuctionFrameBid.bg:SetFrameLevel(AuctionFrameBid.bg:GetFrameLevel()-1)
	BidScrollFrame:SetHeightToScale(332)
	AuctionsScrollFrame:SetHeightToScale(336)
	AuctionFrameAuctions.bg1 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg1:SetStylePanel("!_Frame", "Inset")
	AuctionFrameAuctions.bg1:SetPointToScale("TOPLEFT", 15, -70)
	AuctionFrameAuctions.bg1:SetPointToScale("BOTTOMRIGHT", -545, 35)
	AuctionFrameAuctions.bg1:SetFrameLevel(AuctionFrameAuctions.bg1:GetFrameLevel() - 2)
	AuctionFrameAuctions.bg2 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg2:SetStylePanel("!_Frame", "Inset")
	AuctionFrameAuctions.bg2:SetPointToScale("TOPLEFT", AuctionFrameAuctions.bg1, "TOPRIGHT", 3, 0)
	AuctionFrameAuctions.bg2:SetPointToScale("BOTTOMRIGHT", AuctionFrame, -8, 35)
	AuctionFrameAuctions.bg2:SetFrameLevel(AuctionFrameAuctions.bg2:GetFrameLevel() - 2)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_AuctionUI", AuctionStyle)