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
BARBERSHOP STYLER
##########################################################
]]--
local function BarberShopStyle()
	if SV.db[Schema].blizzard.enable~=true or SV.db[Schema].blizzard.barber~=true then return end

	local buttons = {"BarberShopFrameOkayButton", "BarberShopFrameCancelButton", "BarberShopFrameResetButton"}

	BarberShopFrameOkayButton:Point("RIGHT", BarberShopFrameSelector4, "BOTTOM", 2, -50)

	for b = 1, #buttons do 
		_G[buttons[b]]:RemoveTextures()
		_G[buttons[b]]:SetButtonTemplate()
	end

	BarberShopFrame:RemoveTextures()
	BarberShopFrame:SetPanelTemplate("Halftone")
	BarberShopFrame:Size(BarberShopFrame:GetWidth()-30, BarberShopFrame:GetHeight()-56)

	local lastframe;
	for i = 1, 5 do 
		local selector = _G["BarberShopFrameSelector"..i] 
		if selector then
			STYLE:ApplyPaginationStyle(_G["BarberShopFrameSelector"..i.."Prev"])
			STYLE:ApplyPaginationStyle(_G["BarberShopFrameSelector"..i.."Next"])
			selector:ClearAllPoints()

			if lastframe then 
				selector:Point("TOP", lastframe, "BOTTOM", 0, -3)
			else
				selector:Point("TOP", BarberShopFrame, "TOP", 0, -12)
			end

			selector:RemoveTextures()
			if(selector:IsShown()) then
				lastframe = selector
			end
		end 
	end

	BarberShopFrameMoneyFrame:RemoveTextures()
	BarberShopFrameMoneyFrame:SetPanelTemplate("Inset")
	BarberShopFrameMoneyFrame:Point("TOP", lastframe, "BOTTOM", 0, -10)

	BarberShopFrameBackground:Die()
	BarberShopBannerFrameBGTexture:Die()
	BarberShopBannerFrame:Die()

	BarberShopAltFormFrameBorder:RemoveTextures()
	BarberShopAltFormFrame:Point("BOTTOM", BarberShopFrame, "TOP", 0, 5)
	BarberShopAltFormFrame:RemoveTextures()
	BarberShopAltFormFrame:SetPanelTemplate("Action")

	BarberShopFrameResetButton:ClearAllPoints()
	BarberShopFrameResetButton:Point("BOTTOM", BarberShopFrame.Panel, "BOTTOM", 0, 4)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_BarbershopUI",BarberShopStyle)