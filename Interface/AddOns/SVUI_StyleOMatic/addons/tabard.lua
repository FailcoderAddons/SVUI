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
local function cleanT(a,b)
	for c=1,a:GetNumRegions()do 
		local d=select(c,a:GetRegions())
		if d and d:GetObjectType()=="Texture"then 
			local n=d:GetName();
			if n=='TabardFrameEmblemTopRight' or n=='TabardFrameEmblemTopLeft' or n=='TabardFrameEmblemBottomRight' or n=='TabardFrameEmblemBottomLeft' then return end;
			if b and type(b)=='boolean'then 
				d:MUNG()
			elseif d:GetDrawLayer()==b then 
				d:SetTexture(nil)
			elseif b and type(b)=='string'and d:GetTexture()~=b then 
				d:SetTexture(nil)
			else 
				d:SetTexture(nil)
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
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.tabard ~= true then
		 return 
	end;
	cleanT(TabardFrame, true)
	TabardFrame:SetPanelTemplate("Action", false)
	TabardModel:SetFixedPanelTemplate("Transparent")
	TabardFrameCancelButton:SetButtonTemplate()
	TabardFrameAcceptButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(TabardFrameCloseButton)
	TabardFrameCostFrame:Formula409()
	TabardFrameCustomizationFrame:Formula409()
	TabardFrameInset:MUNG()
	TabardFrameMoneyInset:MUNG()
	TabardFrameMoneyBg:Formula409()
	for b = 1, 5 do 
		local c = "TabardFrameCustomization"..b;_G[c]:Formula409()
		MOD:ApplyPaginationStyle(_G[c.."LeftButton"])
		MOD:ApplyPaginationStyle(_G[c.."RightButton"])
		if b>1 then
			 _G[c]:ClearAllPoints()
			_G[c]:Point("TOP", _G["TabardFrameCustomization"..b-1], "BOTTOM", 0, -6)
		else
			local d, e, f, g, h = _G[c]:GetPoint()
			_G[c]:Point(d, e, f, g, h+4)
		end 
	end;
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
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(TabardFrameStyle)