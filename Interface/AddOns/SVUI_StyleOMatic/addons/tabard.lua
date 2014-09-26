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
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function cleanT(a,b)
	for c=1,a:GetNumRegions()do 
		local d=select(c,a:GetRegions())
		if d and d:GetObjectType()=="Texture"then 
			local n=d:GetName();
			if n=='TabardFrameEmblemTopRight' or n=='TabardFrameEmblemTopLeft' or n=='TabardFrameEmblemBottomRight' or n=='TabardFrameEmblemBottomLeft' then return end 
			if b and type(b)=='boolean'then 
				d:Die()
			elseif d:GetDrawLayer()==b then 
				d:SetTexture(0,0,0,0)
			elseif b and type(b)=='string'and d:GetTexture()~=b then 
				d:SetTexture(0,0,0,0)
			else 
				d:SetTexture(0,0,0,0)
			end 
		end 
	end 
end
--[[ 
########################################################## 
TABARDFRAME STYLER
##########################################################
]]--
local function TabardFrameStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.tabard ~= true then
		 return 
	end 
	cleanT(TabardFrame, true)
	TabardFrame:SetPanelTemplate("Action", false)
	TabardModel:SetFixedPanelTemplate("Transparent")
	TabardFrameCancelButton:SetButtonTemplate()
	TabardFrameAcceptButton:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(TabardFrameCloseButton)
	TabardFrameCostFrame:RemoveTextures()
	TabardFrameCustomizationFrame:RemoveTextures()
	TabardFrameInset:Die()
	TabardFrameMoneyInset:Die()
	TabardFrameMoneyBg:RemoveTextures()
	for b = 1, 5 do 
		local c = "TabardFrameCustomization"..b;_G[c]:RemoveTextures()
		STYLE:ApplyPaginationStyle(_G[c.."LeftButton"])
		STYLE:ApplyPaginationStyle(_G[c.."RightButton"])
		if b>1 then
			 _G[c]:ClearAllPoints()
			_G[c]:Point("TOP", _G["TabardFrameCustomization"..b-1], "BOTTOM", 0, -6)
		else
			local d, e, f, g, h = _G[c]:GetPoint()
			_G[c]:Point(d, e, f, g, h+4)
		end 
	end 
	TabardCharacterModelRotateLeftButton:Point("BOTTOMLEFT", 4, 4)
	TabardCharacterModelRotateRightButton:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
	hooksecurefunc(TabardCharacterModelRotateLeftButton, "SetPoint", function(i, d, j, k, l, m)
		if d ~= "BOTTOMLEFT"or l ~= 4 or m ~= 4 then
			 i:Point("BOTTOMLEFT", 4, 4)
		end 
	end)
	hooksecurefunc(TabardCharacterModelRotateRightButton, "SetPoint", function(i, d, j, k, l, m)
		if d ~= "TOPLEFT"or l ~= 4 or m ~= 0 then
			 i:Point("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 4, 0)
		end 
	end)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(TabardFrameStyle)