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
local MOD = SuperVillain.Registry:Expose("SVStyle");
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
	"AuctionsNumStacksMaxButton"
}
local AuctionMoneyFields = {
	"BrowseBidPriceSilver", 
	"BrowseBidPriceCopper", 
	"BidBidPriceSilver", 
	"BidBidPriceCopper", 
	"StartPriceSilver", 
	"StartPriceCopper", 
	"BuyoutPriceSilver", 
	"BuyoutPriceCopper"
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
	"BuyoutPriceGold"
}
--[[ 
########################################################## 
AUCTIONFRAME STYLER
##########################################################
]]--
local function AuctionStyle()
	if(SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.auctionhouse ~= true) then return end;
	MOD:ApplyCloseButtonStyle(AuctionFrameCloseButton)
	MOD:ApplyScrollStyle(AuctionsScrollFrameScrollBar)
	AuctionFrame:Formula409(true)
	AuctionFrame:SetPanelTemplate("Halftone", false, 2)
	BrowseFilterScrollFrame:Formula409()
	BrowseScrollFrame:Formula409()
	AuctionsScrollFrame:Formula409()
	BidScrollFrame:Formula409()
	MOD:ApplyDropdownStyle(BrowseDropDown)
	MOD:ApplyDropdownStyle(PriceDropDown)
	MOD:ApplyDropdownStyle(DurationDropDown)
	MOD:ApplyScrollStyle(BrowseFilterScrollFrameScrollBar)
	MOD:ApplyScrollStyle(BrowseScrollFrameScrollBar)
	IsUsableCheckButton:SetCheckboxTemplate(true)
	ShowOnPlayerCheckButton:SetCheckboxTemplate(true)
	SideDressUpFrame:Formula409(true)
	SideDressUpFrame:SetPanelTemplate("Halftone")
	SideDressUpFrame:Point("TOPLEFT", AuctionFrame, "TOPRIGHT", 7, 0)
	SideDressUpModel:Formula409(true)
	SideDressUpModel:SetFixedPanelTemplate("Comic")
	SideDressUpModel:SetPanelColor("special")
	SideDressUpModelResetButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(SideDressUpModelCloseButton)

	AuctionProgressFrame:Formula409()
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
	AuctionProgressBar:Formula409()
	AuctionProgressBar:SetPanelTemplate("Default")
	AuctionProgressBar:SetStatusBarTexture(SuperVillain.Media.bar.default)
	AuctionProgressBar:SetStatusBarColor(1, 1, 0)

	MOD:ApplyPaginationStyle(BrowseNextPageButton)
	MOD:ApplyPaginationStyle(BrowsePrevPageButton)

	for _,button in pairs(AuctionBidButtons) do 
		_G[button]:SetButtonTemplate()
	end;

	AuctionsCloseButton:Point("BOTTOMRIGHT", AuctionFrameAuctions, "BOTTOMRIGHT", 66, 10)
	AuctionsCancelAuctionButton:Point("RIGHT", AuctionsCloseButton, "LEFT", -4, 0)

	BidBuyoutButton:Point("RIGHT", BidCloseButton, "LEFT", -4, 0)
	BidBidButton:Point("RIGHT", BidBuyoutButton, "LEFT", -4, 0)

	BrowseBuyoutButton:Point("RIGHT", BrowseCloseButton, "LEFT", -4, 0)
	BrowseBidButton:Point("RIGHT", BrowseBuyoutButton, "LEFT", -4, 0)
	BrowseResetButton:Point("TOPLEFT", AuctionFrameBrowse, "TOPLEFT", 81, -74)
	BrowseSearchButton:Point("TOPRIGHT", AuctionFrameBrowse, "TOPRIGHT", 25, -34)

	AuctionsItemButton:Formula409()
	AuctionsItemButton:SetButtonTemplate()
	AuctionsItemButton:SetScript("OnUpdate", function()
		if AuctionsItemButton:GetNormalTexture()then 
			AuctionsItemButton:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
			AuctionsItemButton:GetNormalTexture():FillInner()
		end 
	end)
	
	for _,frame in pairs(AuctionSortLinks)do 
		_G[frame.."Left"]:MUNG()
		_G[frame.."Middle"]:MUNG()
		_G[frame.."Right"]:MUNG()
	end;

	MOD:ApplyTabStyle(_G["AuctionFrameTab1"])
	MOD:ApplyTabStyle(_G["AuctionFrameTab2"])
	MOD:ApplyTabStyle(_G["AuctionFrameTab3"])

	for h = 1, NUM_FILTERS_TO_DISPLAY do 
		local i = _G["AuctionFilterButton"..h]i:Formula409()
		i:SetButtonTemplate()
	end;

	for _,field in pairs(AuctionTextFields)do 
		_G[field]:SetEditboxTemplate()
		_G[field]:SetTextInsets(-1, -1, -2, -2)
	end;

	for _,field in pairs(AuctionMoneyFields)do
		local frame = _G[field]
		frame:SetEditboxTemplate()
		frame.Panel:Point("TOPLEFT", -2, 1)
		frame.Panel:Point("BOTTOMRIGHT", -12, -1)
		frame:SetTextInsets(-1, -1, -2, -2)
	end;

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
			end;

			if(not button.styled) then 
				button:Formula409()
				button:SetButtonTemplate()
			end

			if(buttonItem) then 
				if(not buttonItem.styled) then 
					buttonItem:SetButtonTemplate()
					buttonItem.Panel:SetAllPoints()
					buttonItem:HookScript("OnUpdate", function()
						buttonItem:GetNormalTexture():MUNG()
					end)
				end;

				local highLight = button:GetHighlightTexture()
				_G["BrowseButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end;
		end 
	end;

	for h = 1, NUM_AUCTIONS_TO_DISPLAY do 
		local button = _G["AuctionsButton"..h];
		local buttonItem = _G["AuctionsButton"..h.."Item"];
		local buttonTex = _G["AuctionsButton"..h.."ItemIconTexture"];

		if(button) then
			if(buttonTex) then 
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:FillInner()
			end;

			if(not button.styled) then 
				button:Formula409()
				button:SetButtonTemplate()
			end

			if(buttonItem) then 
				if(not buttonItem.styled) then 
					buttonItem:SetButtonTemplate()
					buttonItem.Panel:SetAllPoints()
					buttonItem:HookScript("OnUpdate", function()
						buttonItem:GetNormalTexture():MUNG()
					end)
				end;

				local highLight = button:GetHighlightTexture()
				_G["AuctionsButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end;
		end
	end;

	for h = 1, NUM_BIDS_TO_DISPLAY do 	
		local button = _G["BidButton"..h];
		local buttonItem = _G["BidButton"..h.."Item"];
		local buttonTex = _G["BidButton"..h.."ItemIconTexture"];

		if(button) then
			if(buttonTex) then 
				buttonTex:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				buttonTex:FillInner()
			end;

			if(not button.styled) then 
				button:Formula409()
				button:SetButtonTemplate()
			end

			if(buttonItem) then 
				if(not buttonItem.styled) then 
					buttonItem:SetButtonTemplate()
					buttonItem.Panel:SetAllPoints()
					buttonItem:HookScript("OnUpdate", function()
						buttonItem:GetNormalTexture():MUNG()
					end)
				end;

				local highLight = button:GetHighlightTexture()
				_G["BidButton"..h.."Highlight"] = highLight
				highLight:ClearAllPoints()
				highLight:Point("TOPLEFT", buttonItem, "TOPRIGHT", 2, 0)
				highLight:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 5)
				button:GetPushedTexture():SetAllPoints(highLight)
			end;
		end
	end;

	AuctionFrameBrowse.bg1 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg1:SetFixedPanelTemplate("Inset")
	AuctionFrameBrowse.bg1:Point("TOPLEFT", 20, -103)
	AuctionFrameBrowse.bg1:Point("BOTTOMRIGHT", -575, 40)
	BrowseNoResultsText:SetParent(AuctionFrameBrowse.bg1)
	BrowseSearchCountText:SetParent(AuctionFrameBrowse.bg1)
	AuctionFrameBrowse.bg1:SetFrameLevel(AuctionFrameBrowse.bg1:GetFrameLevel()-1)
	BrowseFilterScrollFrame:Height(300)
	AuctionFrameBrowse.bg2 = CreateFrame("Frame", nil, AuctionFrameBrowse)
	AuctionFrameBrowse.bg2:SetFixedPanelTemplate("Inset")
	AuctionFrameBrowse.bg2:Point("TOPLEFT", AuctionFrameBrowse.bg1, "TOPRIGHT", 4, 0)
	AuctionFrameBrowse.bg2:Point("BOTTOMRIGHT", AuctionFrame, "BOTTOMRIGHT", -8, 40)
	AuctionFrameBrowse.bg2:SetFrameLevel(AuctionFrameBrowse.bg2:GetFrameLevel() - 1)
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
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_AuctionUI", AuctionStyle)