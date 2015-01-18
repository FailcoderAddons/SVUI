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
BATTLEFIELD PLUGINR
##########################################################
]]--
local function BattlefieldStyle()
	if PLUGIN.db.blizzard.enable~=true or PLUGIN.db.blizzard.bgmap~=true then return end 
	BattlefieldMinimap:SetClampedToScreen(true)
	BattlefieldMinimapCorner:Die()
	BattlefieldMinimapBackground:Die()
	BattlefieldMinimapTab:Die()
	BattlefieldMinimapTabLeft:Die()
	BattlefieldMinimapTabMiddle:Die()
	BattlefieldMinimapTabRight:Die()
	BattlefieldMinimap:SetStylePanel("!_Frame", "Transparent")
	BattlefieldMinimap.Panel:SetPointToScale("BOTTOMRIGHT", -4, 2)
	BattlefieldMinimap:SetFrameStrata("LOW")
	BattlefieldMinimapCloseButton:ClearAllPoints()
	BattlefieldMinimapCloseButton:SetPoint("TOPRIGHT", -4, 0)
	PLUGIN:ApplyCloseButtonStyle(BattlefieldMinimapCloseButton)
	BattlefieldMinimapCloseButton:SetFrameStrata("MEDIUM")
	BattlefieldMinimap:EnableMouse(true)
	BattlefieldMinimap:SetMovable(true)
	BattlefieldMinimap:SetScript("OnMouseUp", function(f, g)
		if g == "LeftButton"then 
			BattlefieldMinimapTab:StopMovingOrSizing()BattlefieldMinimapTab:SetUserPlaced(true)
			if OpacityFrame:IsShown()then 
				OpacityFrame:Hide()
			end 
		elseif g == "RightButton"then 
			ToggleDropDownMenu(1, nil, BattlefieldMinimapTabDropDown, f:GetName(), 0, -4)
			if OpacityFrame:IsShown()then 
				OpacityFrame:Hide()
			end 
		end 
	end)
	BattlefieldMinimap:SetScript("OnMouseDown", function(f, g)
		if g == "LeftButton"then 
			if BattlefieldMinimapOptions and BattlefieldMinimapOptions.locked then 
				return 
			else 
				BattlefieldMinimapTab:StartMoving()
			end 
		end 
	end)
	hooksecurefunc("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local h = 1.0-BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap.Panel:SetAlpha(h)
	end)
	local i;
	BattlefieldMinimap:HookScript("OnEnter", function()
		i = BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap_UpdateOpacity(0)
	end)
	BattlefieldMinimap:HookScript("OnLeave", function()
		if i then 
			BattlefieldMinimap_UpdateOpacity(i)i = nil 
		end 
	end)
	BattlefieldMinimapCloseButton:HookScript("OnEnter", function()
		i = BattlefieldMinimapOptions.opacity or 0;
		BattlefieldMinimap_UpdateOpacity(0)
	end)
	BattlefieldMinimapCloseButton:HookScript("OnLeave", function()
		if i then 
			BattlefieldMinimap_UpdateOpacity(i)i = nil 
		end 
	end)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_BattlefieldMinimap",BattlefieldStyle)