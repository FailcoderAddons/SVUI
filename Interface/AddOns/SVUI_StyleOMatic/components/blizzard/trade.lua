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
local unpack  	= _G.unpack;
local select  	= _G.select;
local ipairs  	= _G.ipairs;
local pairs   	= _G.pairs;
local type 		= _G.type;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
TRADEFRAME PLUGINR
##########################################################
]]--
local function TradeFrameStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.trade ~= true then
		 return 
	end 
	
	PLUGIN:ApplyWindowStyle(TradeFrame, true)

	TradeFrameInset:Die()
	TradeFrameTradeButton:SetStylePanel("Button")
	TradeFrameCancelButton:SetStylePanel("Button")
	PLUGIN:ApplyCloseButtonStyle(TradeFrameCloseButton, TradeFrame.Panel)
	TradePlayerInputMoneyFrameGold:SetStylePanel("Editbox")
	TradePlayerInputMoneyFrameSilver:SetStylePanel("Editbox")
	TradePlayerInputMoneyFrameCopper:SetStylePanel("Editbox")
	TradeRecipientItemsInset:Die()
	TradePlayerItemsInset:Die()
	TradePlayerInputMoneyInset:Die()
	TradePlayerEnchantInset:Die()
	TradeRecipientEnchantInset:Die()
	TradeRecipientMoneyInset:Die()
	TradeRecipientMoneyBg:Die()
	local inputs = {
		"TradePlayerInputMoneyFrameSilver",
		"TradePlayerInputMoneyFrameCopper"
	}
	for _,frame in pairs(inputs)do
		_G[frame]:SetStylePanel("Editbox")
		_G[frame].Panel:SetPointToScale("TOPLEFT", -2, 1)
		_G[frame].Panel:SetPointToScale("BOTTOMRIGHT", -12, -1)
		_G[frame]:SetTextInsets(-1, -1, -2, -2)
	end 
	for i = 1, 7 do 
		local W = _G["TradePlayerItem"..i]
		local X = _G["TradeRecipientItem"..i]
		local Y = _G["TradePlayerItem"..i.."ItemButton"]
		local Z = _G["TradeRecipientItem"..i.."ItemButton"]
		local b = _G["TradePlayerItem"..i.."ItemButtonIconTexture"]
		local z = _G["TradeRecipientItem"..i.."ItemButtonIconTexture"]
		if Y and Z then
			W:RemoveTextures()
			X:RemoveTextures()
			Y:RemoveTextures()
			Z:RemoveTextures()
			b:SetAllPointsIn(Y)
			b:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			Y:SetStylePanel("!_Frame", "Button", true)
			Y:SetStylePanel("Button")
			Y.bg = CreateFrame("Frame", nil, Y)
			Y.bg:SetStylePanel("Frame", "Inset")
			Y.bg:SetPoint("TOPLEFT", Y, "TOPRIGHT", 4, 0)
			Y.bg:SetPoint("BOTTOMRIGHT", _G["TradePlayerItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			Y.bg:SetFrameLevel(Y:GetFrameLevel()-3)
			Y:SetFrameLevel(Y:GetFrameLevel()-1)
			z:SetAllPointsIn(Z)
			z:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			Z:SetStylePanel("!_Frame", "Button", true)
			Z:SetStylePanel("Button")
			Z.bg = CreateFrame("Frame", nil, Z)
			Z.bg:SetStylePanel("Frame", "Inset")
			Z.bg:SetPoint("TOPLEFT", Z, "TOPRIGHT", 4, 0)
			Z.bg:SetPoint("BOTTOMRIGHT", _G["TradeRecipientItem"..i.."NameFrame"], "BOTTOMRIGHT", 0, 14)
			Z.bg:SetFrameLevel(Z:GetFrameLevel()-3)
			Z:SetFrameLevel(Z:GetFrameLevel()-1)
		end 
	end 
	TradeHighlightPlayerTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayer:SetFrameStrata("HIGH")
	TradeHighlightPlayerEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightPlayerEnchant:SetFrameStrata("HIGH")
	TradeHighlightRecipientTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipient:SetFrameStrata("HIGH")
	TradeHighlightRecipientEnchantTop:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantBottom:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchantMiddle:SetTexture(0, 1, 0, 0.2)
	TradeHighlightRecipientEnchant:SetFrameStrata("HIGH")
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(TradeFrameStyle)