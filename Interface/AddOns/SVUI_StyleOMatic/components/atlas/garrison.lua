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
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local RING_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-RING]]
local LVL_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Unitframe\FOLLOWER-LEVEL]]
local HIGHLIGHT_TEXTURE = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]]
local DEFAULT_COLOR = {r = 0.25, g = 0.25, b = 0.25};
--[[ 
########################################################## 
STYLE
##########################################################
]]--
local GarrMission_PortraitsFromLevel = function(self)
	local parent = self:GetParent()
	if(parent.PortraitRing) then
  		parent.PortraitRing:SetTexture(RING_TEXTURE)
  	end
end
SV:SetAtlasFunc("GarrMission_PortraitsFromLevel", GarrMission_PortraitsFromLevel)

local GarrMission_MaterialFrame = function(self)
  local frame = self:GetParent()
  frame:RemoveTextures()
  frame:SetStylePanel("Frame", "Inset", true, 1, -5, -7)
end
SV:SetAtlasFunc("GarrMission_MaterialFrame", GarrMission_MaterialFrame)

SV:SetAtlasFilter("GarrMission_PortraitRing_LevelBorder", "GarrMission_PortraitsFromLevel")
SV:SetAtlasFilter("GarrMission_PortraitRing_iLvlBorder", "GarrMission_PortraitsFromLevel")
SV:SetAtlasFilter("Garr_Mission_MaterialFrame", "GarrMission_MaterialFrame")

SV:SetAtlasFilter("Garr_FollowerToast-Uncommon");
SV:SetAtlasFilter("Garr_FollowerToast-Epic");
SV:SetAtlasFilter("Garr_FollowerToast-Rare");
SV:SetAtlasFilter("GarrLanding-MinimapIcon-Horde-Up");
SV:SetAtlasFilter("GarrLanding-MinimapIcon-Horde-Down");
SV:SetAtlasFilter("GarrLanding-MinimapIcon-Alliance-Up");
SV:SetAtlasFilter("GarrLanding-MinimapIcon-Alliance-Down");