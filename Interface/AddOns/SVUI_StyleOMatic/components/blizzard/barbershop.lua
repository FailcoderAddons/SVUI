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
BARBERSHOP PLUGINR
##########################################################
]]--
local function BarberShopStyle()
	if PLUGIN.db.blizzard.enable~=true or PLUGIN.db.blizzard.barber~=true then return end

	local buttons = {"BarberShopFrameOkayButton", "BarberShopFrameCancelButton", "BarberShopFrameResetButton"}

	BarberShopFrameOkayButton:SetPointToScale("RIGHT", BarberShopFrameSelector4, "BOTTOM", 2, -50)

	for b = 1, #buttons do 
		_G[buttons[b]]:RemoveTextures()
		_G[buttons[b]]:SetStylePanel("Button")
	end

	BarberShopFrame:RemoveTextures()
	BarberShopFrame:SetStylePanel("Frame", "Composite1")
	BarberShopFrame:SetSizeToScale(BarberShopFrame:GetWidth()-30, BarberShopFrame:GetHeight()-56)

	local lastframe;
	for i = 1, 5 do 
		local selector = _G["BarberShopFrameSelector"..i] 
		if selector then
			PLUGIN:ApplyPaginationStyle(_G["BarberShopFrameSelector"..i.."Prev"])
			PLUGIN:ApplyPaginationStyle(_G["BarberShopFrameSelector"..i.."Next"])
			selector:ClearAllPoints()

			if lastframe then 
				selector:SetPointToScale("TOP", lastframe, "BOTTOM", 0, -3)
			else
				selector:SetPointToScale("TOP", BarberShopFrame, "TOP", 0, -12)
			end

			selector:RemoveTextures()
			if(selector:IsShown()) then
				lastframe = selector
			end
		end 
	end

	BarberShopFrameMoneyFrame:RemoveTextures()
	BarberShopFrameMoneyFrame:SetStylePanel("Frame", "Inset")
	BarberShopFrameMoneyFrame:SetPointToScale("TOP", lastframe, "BOTTOM", 0, -10)

	BarberShopFrameBackground:Die()
	BarberShopBannerFrameBGTexture:Die()
	BarberShopBannerFrame:Die()

	BarberShopAltFormFrameBorder:RemoveTextures()
	BarberShopAltFormFrame:SetPointToScale("BOTTOM", BarberShopFrame, "TOP", 0, 5)
	BarberShopAltFormFrame:RemoveTextures()
	BarberShopAltFormFrame:SetStylePanel("Frame", "Composite2")

	BarberShopFrameResetButton:ClearAllPoints()
	BarberShopFrameResetButton:SetPointToScale("BOTTOM", BarberShopFrame.Panel, "BOTTOM", 0, 4)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_BarbershopUI",BarberShopStyle)