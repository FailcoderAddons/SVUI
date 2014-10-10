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
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
FRAME STYLER
##########################################################
]]--
local function MerchantStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.merchant ~= true then return end 
	MerchantFrame:RemoveTextures(true)
	MerchantFrame:SetPanelTemplate("Halftone", false, nil, 2, 4)
	local level = MerchantFrame:GetFrameLevel()
	if(level > 0) then 
		MerchantFrame:SetFrameLevel(level - 1)
	else 
		MerchantFrame:SetFrameLevel(0)
	end
	MerchantBuyBackItem:RemoveTextures(true)
	MerchantBuyBackItem:SetPanelTemplate("Inset", true, 2, 2, 3)
	MerchantBuyBackItem.Panel:SetFrameLevel(MerchantBuyBackItem.Panel:GetFrameLevel() + 1)
	MerchantBuyBackItemItemButton:RemoveTextures()
	MerchantBuyBackItemItemButton:SetButtonTemplate()
	MerchantExtraCurrencyInset:RemoveTextures()
	MerchantExtraCurrencyBg:RemoveTextures()
	MerchantFrameInset:RemoveTextures()
	MerchantMoneyBg:RemoveTextures()
	MerchantMoneyInset:RemoveTextures()
	MerchantFrameInset:SetPanelTemplate("Inset")
	MerchantFrameInset.Panel:SetFrameLevel(MerchantFrameInset.Panel:GetFrameLevel() + 1)
	STYLE:ApplyDropdownStyle(MerchantFrameLootFilter)
	for b = 1, 2 do
		STYLE:ApplyTabStyle(_G["MerchantFrameTab"..b])
	end 
	for b = 1, 12 do 
		local d = _G["MerchantItem"..b.."ItemButton"]
		local e = _G["MerchantItem"..b.."ItemButtonIconTexture"]
		local o = _G["MerchantItem"..b]o:RemoveTextures(true)
		o:SetFixedPanelTemplate("Inset")
		d:RemoveTextures()
		d:SetButtonTemplate()
		d:Point("TOPLEFT", o, "TOPLEFT", 4, -4)
		e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		e:FillInner()
		_G["MerchantItem"..b.."MoneyFrame"]:ClearAllPoints()
		_G["MerchantItem"..b.."MoneyFrame"]:Point("BOTTOMLEFT", d, "BOTTOMRIGHT", 3, 0)
	end 
	MerchantBuyBackItemItemButton:RemoveTextures()
	MerchantBuyBackItemItemButton:SetButtonTemplate()
	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MerchantBuyBackItemItemButtonIconTexture:FillInner()
	MerchantRepairItemButton:SetButtonTemplate()
	for b = 1, MerchantRepairItemButton:GetNumRegions()do 
		local p = select(b, MerchantRepairItemButton:GetRegions())
		if p:GetObjectType() == "Texture"then
			p:SetTexCoord(0.04, 0.24, 0.06, 0.5)
			p:FillInner()
		end 
	end MerchantGuildBankRepairButton:SetButtonTemplate()
	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	MerchantGuildBankRepairButtonIcon:FillInner()
	MerchantRepairAllButton:SetButtonTemplate()
	MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	MerchantRepairAllIcon:FillInner()
	MerchantFrame:Width(360)
	STYLE:ApplyCloseButtonStyle(MerchantFrameCloseButton, MerchantFrame.Panel)
	STYLE:ApplyPaginationStyle(MerchantNextPageButton)
	STYLE:ApplyPaginationStyle(MerchantPrevPageButton)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(MerchantStyle)