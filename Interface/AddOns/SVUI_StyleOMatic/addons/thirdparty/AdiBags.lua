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
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
ADIBAGS
##########################################################
]]--
local function StyleAdiBags(event)
	local AdiBags = LibStub('AceAddon-3.0'):GetAddon('AdiBags')
	assert(AdiBags, "AddOn Not Loaded")
	--hooksecurefunc(AdiBags, 'HookBagFrameCreation', function(self) print(self) end)

	local function SkinFrame(frame)
		local region = frame.HeaderRightRegion
		frame:SetBasicPanel()
		_G[frame:GetName()..'Bags']:SetPanelTemplate("Default")
		for i = 1, 3 do
			region.widgets[i].widget:SetButtonTemplate()
		end
	end

	if event == 'PLAYER_ENTERING_WORLD' then
		SV.Timers:ExecuteTimer(function()
			if not AdiBagsContainer1 then ToggleBackpack() ToggleBackpack() end
			if AdiBagsContainer1 then
				SkinFrame(AdiBagsContainer1)
				AdiBagsContainer1SearchBox:SetEditboxTemplate()
				AdiBagsContainer1SearchBox:Point('TOPRIGHT', AdiBagsSimpleLayeredRegion2, 'TOPRIGHT', -75, -1)
			end
		end, 1)
	elseif event == 'BANKFRAME_OPENED' then
		SV.Timers:ExecuteTimer(function()
			if AdiBagsContainer2 then
				SkinFrame(AdiBagsContainer2)
				STYLE:SafeEventRemoval("AdiBags", event)
			end
		end, 1)
	end
end

STYLE:SaveAddonStyle("AdiBags", StyleAdiBags, nil, nil, 'BANKFRAME_OPENED')