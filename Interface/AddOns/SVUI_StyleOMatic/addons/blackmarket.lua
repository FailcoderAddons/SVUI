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
BLACKMARKET STYLER
##########################################################
]]--
local function BlackMarketStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.bmah ~= true then 
		return 
	end;

	local ChangeTab = function(p)
		p.Left:SetAlpha(0)
		if p.Middle then 
			p.Middle:SetAlpha(0)
		end;
		p.Right:SetAlpha(0)
	end;

	BlackMarketFrame:Formula409()
	BlackMarketFrame:SetPanelTemplate("Halftone")
	BlackMarketFrame.Inset:Formula409()
	BlackMarketFrame.Inset:SetFixedPanelTemplate("Inset")
	MOD:ApplyCloseButtonStyle(BlackMarketFrame.CloseButton)
	MOD:ApplyScrollStyle(BlackMarketScrollFrameScrollBar, 4)

	ChangeTab(BlackMarketFrame.ColumnName)
	ChangeTab(BlackMarketFrame.ColumnLevel)
	ChangeTab(BlackMarketFrame.ColumnType)
	ChangeTab(BlackMarketFrame.ColumnDuration)
	ChangeTab(BlackMarketFrame.ColumnHighBidder)
	ChangeTab(BlackMarketFrame.ColumnCurrentBid)

	BlackMarketFrame.MoneyFrameBorder:Formula409()
	BlackMarketBidPriceGold:SetEditboxTemplate()
	BlackMarketBidPriceGold.Panel:Point("TOPLEFT", -2, 0)
	BlackMarketBidPriceGold.Panel:Point("BOTTOMRIGHT", -2, 0)
	BlackMarketFrame.BidButton:SetButtonTemplate()
	hooksecurefunc("BlackMarketScrollFrame_Update", function()
		local buttons = BlackMarketScrollFrame.buttons;
		local r = #buttons;
		local s = HybridScrollFrame_GetOffset(BlackMarketScrollFrame)
		local t = C_BlackMarket.GetNumItems()
		for b = 1, r do 
			local u = buttons[b]
			local v = s+b;
			if not u.styled then 
				u:Formula409()
				u:SetButtonTemplate()
				MOD:ApplyLinkButtonStyle(u.Item)
				u.styled = true 
			end;
			if v <= t then 
				local w, x = C_BlackMarket.GetItemInfoByIndex(v)
				if w then 
					u.Item.IconTexture:SetTexture(x)
				end 
			end 
		end 
	end)
	BlackMarketFrame.HotDeal:Formula409()
	MOD:ApplyLinkButtonStyle(BlackMarketFrame.HotDeal.Item)
	for b = 1, BlackMarketFrame:GetNumRegions()do 
		local y = select(b, BlackMarketFrame:GetRegions())
		if y and y:GetObjectType() == "FontString" and y:GetText() == BLACK_MARKET_TITLE then 
			y:ClearAllPoints()y:SetPoint("TOP", BlackMarketFrame, "TOP", 0, -4)
		end 
	end 
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_BlackMarketUI",BlackMarketStyle)