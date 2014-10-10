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
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
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
AUCTIONFRAME STYLER
##########################################################
]]--
local function AuctionStyle()
	--STYLE.Debugging = true
	if(SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.auctionhouse ~= true) then return end 

	STYLE:ApplyWindowStyle(AuctionFrame, false, true)
	
	BrowseFilterScrollFrame:RemoveTextures()
	BrowseScrollFrame:RemoveTextures()
	AuctionsScrollFrame:RemoveTextures()
	BidScrollFrame:RemoveTextures()

	STYLE:ApplyCloseButtonStyle(AuctionFrameCloseButton)
	STYLE:ApplyScrollFrameStyle(AuctionsScrollFrameScrollBar)

	STYLE:ApplyDropdownStyle(BrowseDropDown)
	STYLE:ApplyDropdownStyle(PriceDropDown)
	STYLE:ApplyDropdownStyle(DurationDropDown)
	STYLE:ApplyScrollFrameStyle(BrowseFilterScrollFrameScrollBar)
	STYLE:ApplyScrollFrameStyle(BrowseScrollFrameScrollBar)
	IsUsableCheckButton:SetCheckboxTemplate(true)
	ShowOnPlayerCheckButton:SetCheckboxTemplate(true)
	
	--ExactMatchCheckButton:SetCheckboxTemplate(true)
	
	SideDressUpFrame:RemoveTextures(true)
	SideDressUpFrame:Size(300, 400)
	SideDressUpFrame:SetPoint("LEFT", AuctionFrame, "RIGHT", 16, 0)
	SideDressUpFrame.SetPoint = SV.fubar
	SideDressUpModel:RemoveTextures(true)
	SideDressUpModel:SetAllPoints(SideDressUpFrame)
	SideDressUpModel:SetFixedPanelTemplate("ModelComic")
	SideDressUpModelResetButton:SetButtonTemplate()
	SideDressUpModelResetButton:SetPoint("BOTTOM", SideDressUpModel, "BOTTOM", 0, 20)
	STYLE:ApplyCloseButtonStyle(SideDressUpModelCloseButton)

	AuctionProgressFrame:RemoveTextures()
	AuctionProgressFrame:SetFixedPanelTemplate("Transparent", true)
	AuctionProgressFrameCancelButton:SetButtonTemplate()
	AuctionProgressFrameCancelButton:SetFixedPanelTemplate("Default")
	AuctionProgressFrameCancelButton:SetHitRectInsets(0, 0, 0, 0)
	AuctionProgressFrameCancelButton:GetNormalTexture():FillInner()
	AuctionProgressFrameCancelButton:GetNormalTexture():SetTexCoord(0.67, 0.37, 0.61, 0.26)
	AuctionProgressFrameCancelButton:Size(28, 28)
	AuctionProgressFrameCancelButton:Point("LEFT", AuctionProgressBar, "RIGHT", 8, 0)
	AuctionProgressBarIcon:SetTexCoord(0.67, 0.37, 0.61, 0.26)

	local AuctionProgressBarBG = CreateFrame("Frame", nil, AuctionProgressBarIcon:GetParent())
	AuctionProgressBarBG:WrapOuter(AuctionProgressBarIcon)
	AuctionProgressBarBG:SetFixedPanelTemplate("Default")
	AuctionProgressBarIcon:SetParent(AuctionProgressBarBG)

	AuctionProgressBarText:ClearAllPoints()
	AuctionProgressBarText:SetPoint("CENTER")
	AuctionProgressBar:RemoveTextures()
	AuctionProgressBar:SetPanelTemplate("Default")
	AuctionProgressBar:SetStatusBarTexture(SV.Media.bar.default)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)

	STYLE:ApplyPaginationStyle(BrowseNextPageButton)
	STYLE:ApplyPaginationStyle(BrowsePrevPageButton)

	for _,gName in pairs(AuctionBidButtons) do
		if(_G[gName]) then
			_G[gName]:RemoveTextures()
			_G[gName]:SetButtonTemplate()
		end
	end 

	AuctionsCloseButton:Point("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)

	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)

	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)

	AuctionsItemButton:RemoveTextures()
	AuctionsItemButton:SetButtonTemplate()
	AuctionsItemButton:SetScript("OnUpdate", function()
		if AuctionsItemButton:GetNormalTexture()then 
			AuctionsItemButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			AuctionsItemButton:GetNormalTexture():FillInner()
		end 
	end)
	
	for _,frame in pairs(AuctionSortLinks)do 
		_G[frame.."Left"]:Die()
		_G[frame.."Middle"]:Die()
		_G[frame.."Right"]:Die()
	end 

	STYLE:ApplyTabStyle(_G["AuctionFrameTab1"])
	STYLE:ApplyTabStyle(_G["AuctionFrameTab2"])
	STYLE:ApplyTabStyle(_G["AuctionFrameTab3"])

	AuctionFrameBrowse.bg1 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg1:Point("TOPLEFT", 20, -103)
	AuctionFrameBrowse.bg1:Point("BOTTOMRIGHT", -575, 40)
	AuctionFrameBrowse.bg1:SetFixedPanelTemplate("Inset")

	BrowseNoResultsText:SetParent(AuctionFrameBrowse.bg1)
	BrowseSearchCountText:SetParent(AuctionFrameBrowse.bg1)

	BrowseResetButton:Point("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 81, -74)
	BrowseSearchButton:Point("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)

	AuctionFrameBrowse.bg1:SetFrameLevel(AuctionFrameBrowse.bg1:GetFrameLevel()-1)
	BrowseFilterScrollFrame:Height(300)
	AuctionFrameBrowse.bg2 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg2:SetFixedPanelTemplate("Inset")
	AuctionFrameBrowse.bg2:Point("TOPLEFT", AuctionFrameBrowse.bg1, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.bg2:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 40)
	AuctionFrameBrowse.bg2:SetFrameLevel(AuctionFrameBrowse.bg2:GetFrameLevel() - 1)

	for i = 1, NUM_FILTERS_TO_DISPLAY do 
		local header = _G[("AuctionFilterButton%d"):format(i)]
		if(header) then
			header:RemoveTextures()
			header:SetButtonTemplate()
		end
	end 

	for _,field in pairs(AuctionTextFields)do
		_G[field]:SetEditboxTemplate()
		_G[field]:SetTextInsets(-1, -1, -2, -2)
	end

	BrowseMaxLevel:Point("LEFT", BrowseMinLevel, "RIGHT", 8, 0)
	AuctionsStackSizeEntry.Panel:SetAllPoints()
	AuctionsNumStacksEntry.Panel:SetAllPoints()

	for h = 1, NUM_BROWSE_TO_DISPLAY do 
		local button = _G["BrowseButton"..h];
		local buttonItem = _G["BrowseButton"..h.."Item"];
		local buttonTex = _G["BrowseButton"..h.."ItemIconTexture"];

		if(button) then
			if(buttonTex) then 
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:FillInner()
			end 

			button:RemoveTextures()
			button:SetButtonTemplate()

			if(buttonItem) then 
				buttonItem:SetButtonTemplate()
				buttonItem.Panel:SetAllPoints()
				buttonItem:HookScript("OnUpdate", function()
					buttonItem:GetNormalTexture():Die()
				end)

				local highLight = button:GetHighlightTexture()
				_G["BrowseButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
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
				buttonTex:FillInner()
			end 

			button:RemoveTextures()
			button:SetButtonTemplate()

			if(buttonItem) then 
				buttonItem:SetButtonTemplate()
				buttonItem.Panel:SetAllPoints()
				buttonItem:HookScript("OnUpdate", function()
					buttonItem:GetNormalTexture():Die()
				end)

				local highLight = button:GetHighlightTexture()
				_G["AuctionsButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
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
				buttonTex:FillInner()
			end 

			button:RemoveTextures()
			button:SetButtonTemplate()

			if(buttonItem) then 
				buttonItem:SetButtonTemplate()
				buttonItem.Panel:SetAllPoints()
				buttonItem:HookScript("OnUpdate", function()
					buttonItem:GetNormalTexture():Die()
				end)

				local highLight = button:GetHighlightTexture()
				_G["BidButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end 
		end
	end 

	BrowseScrollFrame:Height(300)
	AuctionFrameBid.bg = CreateFrame("Frame", nil, AuctionFrameBid)
	AuctionFrameBid.bg:SetFixedPanelTemplate("Inset")
	AuctionFrameBid.bg:Point("TOPLEFT", 22, -72)
	AuctionFrameBid.bg:Point("BOTTOMRIGHT", 66, 39)
	AuctionFrameBid.bg:SetFrameLevel(AuctionFrameBid.bg:GetFrameLevel()-1)
	BidScrollFrame:Height(332)
	AuctionsScrollFrame:Height(336)
	AuctionFrameAuctions.bg1 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg1:SetFixedPanelTemplate("Inset")
	AuctionFrameAuctions.bg1:Point("TOPLEFT", 15, -70)
	AuctionFrameAuctions.bg1:Point("BOTTOMRIGHT", -545, 35)
	AuctionFrameAuctions.bg1:SetFrameLevel(AuctionFrameAuctions.bg1:GetFrameLevel() - 2)
	AuctionFrameAuctions.bg2 = CreateFrame("Frame", nil, AuctionFrameAuctions)
	AuctionFrameAuctions.bg2:SetFixedPanelTemplate("Inset")
	AuctionFrameAuctions.bg2:Point("TOPLEFT", AuctionFrameAuctions.bg1, "TOPRIGHT", 3, 0)
	AuctionFrameAuctions.bg2:Point("BOTTOMRIGHT", AuctionFrame, -8, 35)
	AuctionFrameAuctions.bg2:SetFrameLevel(AuctionFrameAuctions.bg2:GetFrameLevel() - 2)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_AuctionUI", AuctionStyle)