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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
ZYGOR
##########################################################
]]--
local function StyleZygorTabs()
	if(not ZGVCharacterGearFinderButton) then return end
	ZGVCharacterGearFinderButton.Highlight:SetTexture(1, 1, 1, 0.3)
	ZGVCharacterGearFinderButton.Highlight:SetPointToScale("TOPLEFT", 3, -4)
	ZGVCharacterGearFinderButton.Highlight:SetPointToScale("BOTTOMRIGHT", -1, 0)
	ZGVCharacterGearFinderButton.Hider:SetTexture(0.4, 0.4, 0.4, 0.4)
	ZGVCharacterGearFinderButton.Hider:SetPointToScale("TOPLEFT", 3, -4)
	ZGVCharacterGearFinderButton.Hider:SetPointToScale("BOTTOMRIGHT", -1, 0)
	ZGVCharacterGearFinderButton.TabBg:Die()
	if i == 1 then
		for x = 1, ZGVCharacterGearFinderButton:GetNumRegions()do 
			local texture = select(x, ZGVCharacterGearFinderButton:GetRegions())
			texture:SetTexCoord(0.16, 0.86, 0.16, 0.86)
		end 
	end 
	ZGVCharacterGearFinderButton:SetStylePanel("Frame", "Default", true, 2)
	ZGVCharacterGearFinderButton.Panel:SetPointToScale("TOPLEFT", 2, -3)
	ZGVCharacterGearFinderButton.Panel:SetPointToScale("BOTTOMRIGHT", 0, -2)
end 

local function StyleZygor()
	--PLUGIN.Debugging = true;
	local ZygorGuidesViewer = LibStub('AceAddon-3.0'):GetAddon('ZygorGuidesViewer')
	assert(ZygorGuidesViewer, "AddOn Not Loaded")

	PLUGIN:ApplyWindowStyle(ZygorGuidesViewerFrame)
	ZygorGuidesViewerFrame_Border:RemoveTextures(true)
	PLUGIN:ApplyFrameStyle(ZygorGuidesViewer_CreatureViewer, 'ModelBorder')

	for i = 1, 6 do
		PLUGIN:ApplyFrameStyle(_G['ZygorGuidesViewerFrame_Step'..i], 'Default')
	end

	CharacterFrame:HookScript("OnShow", StyleZygorTabs)

	ZygorGuidesViewerFrame_Border:HookScript('OnHide', function(self) self:RemoveTextures(true) end)
	ZygorGuidesViewerFrame_Border:HookScript('OnShow', function(self) self:RemoveTextures(true) end)
	if(SV.db.SVMap.customIcons) then
		Minimap:SetBlipTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\MINIMAP-OBJECTICONS")
		Minimap.SetBlipTexture = function() return end
	else
		Minimap:SetBlipTexture("Interface\\AddOns\\SVUI\\assets\\artwork\\Minimap\\DEFAULT-OBJECTICONS")
		Minimap.SetBlipTexture = function() return end
	end
end

PLUGIN:SaveAddonStyle("ZygorGuidesViewer", StyleZygor)