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
BARBERSHOP STYLER
##########################################################
]]--
local function BarberShopStyle()
	if SuperVillain.db.SVStyle.blizzard.enable~=true or SuperVillain.db.SVStyle.blizzard.barber~=true then return end;
	local buttons = {"BarberShopFrameOkayButton", "BarberShopFrameCancelButton", "BarberShopFrameResetButton"}
	BarberShopFrameOkayButton:Point("RIGHT", BarberShopFrameSelector4, "BOTTOM", 2, -50)
	for b = 1, #buttons do 
		_G[buttons[b]]:Formula409()
		_G[buttons[b]]:SetButtonTemplate()
	end;
	for b = 1, 4 do 
		local c = _G["BarberShopFrameSelector"..b]
		local d = _G["BarberShopFrameSelector"..b-1]
		MOD:ApplyPaginationStyle(_G["BarberShopFrameSelector"..b.."Prev"])
		MOD:ApplyPaginationStyle(_G["BarberShopFrameSelector"..b.."Next"])
		if b ~= 1 then 
			c:ClearAllPoints()c:Point("TOP", d, "BOTTOM", 0, -3)
		end;
		if c then 
			c:Formula409()
		end 
	end;
	BarberShopFrameSelector1:ClearAllPoints()
	BarberShopFrameSelector1:Point("TOP", 0, -12)
	BarberShopFrameResetButton:ClearAllPoints()
	BarberShopFrameResetButton:Point("BOTTOM", 0, 12)
	BarberShopFrame:Formula409()
	BarberShopFrame:SetPanelTemplate("Halftone")
	BarberShopFrame:Size(BarberShopFrame:GetWidth()-30, BarberShopFrame:GetHeight()-56)
	BarberShopFrameMoneyFrame:Formula409()
	BarberShopFrameMoneyFrame:SetPanelTemplate()
	BarberShopFrameBackground:MUNG()
	BarberShopBannerFrameBGTexture:MUNG()
	BarberShopBannerFrame:MUNG()
	BarberShopAltFormFrameBorder:Formula409()
	BarberShopAltFormFrame:Point("BOTTOM", BarberShopFrame, "TOP", 0, 5)
	BarberShopAltFormFrame:Formula409()
	BarberShopAltFormFrame:SetPanelTemplate("Transparent", true)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_BarbershopUI",BarberShopStyle)