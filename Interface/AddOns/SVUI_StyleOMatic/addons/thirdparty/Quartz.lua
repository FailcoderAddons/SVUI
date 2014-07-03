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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
QUARTZ
##########################################################
]]--
local function StyleQuartz()
	local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
	local GCD = Quartz3.Registry:Expose("GCD")
	local CastBar = Quartz3.CastBarTemplate.template
	local function StyleQuartzBar(self)
		if not self.isStyled then
			self.IconBorder = CreateFrame("Frame", nil, self)
			MOD:ApplyFrameStyle(self.IconBorder,"Transparent")
			self.IconBorder:SetFrameLevel(0)
			self.IconBorder:WrapOuter(self.Icon)
			MOD:ApplyFrameStyle(self.Bar,"Transparent",true)
			self.isStyled = true
		end
 		if self.config.hideicon then
 			self.IconBorder:Hide()
 		else
 			self.IconBorder:Show()
 		end
	end
	hooksecurefunc(CastBar, 'ApplySettings', StyleQuartzBar)
	hooksecurefunc(CastBar, 'UNIT_SPELLCAST_START', StyleQuartzBar)
	hooksecurefunc(CastBar, 'UNIT_SPELLCAST_CHANNEL_START', StyleQuartzBar)
	if GCD then
		hooksecurefunc(GCD, 'CheckGCD', function()
			if not Quartz3GCDBar.backdrop then
				MOD:ApplyFrameStyle(Quartz3GCDBar,"Transparent",true)
			end
		end)
	end
end
MOD:SaveAddonStyle("Quartz", StyleQuartz)