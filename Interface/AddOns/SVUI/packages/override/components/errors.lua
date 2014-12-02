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
local unpack        = _G.unpack;
local select        = _G.select;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...);
local MOD = SV.SVOverride;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local UIErrorsFrame = _G.UIErrorsFrame;
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function MOD:UI_ERROR_MESSAGE(event, msg)
	if((not msg) or SV.db.SVOverride.errorFilters[msg]) then return end
	UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0);
end

local ErrorFrameHandler = function(self, event)
	if(event == 'PLAYER_REGEN_DISABLED') then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
	else
		UIErrorsFrame:RegisterEvent('UI_ERROR_MESSAGE')
	end
end
--[[ 
########################################################## 
PACKAGE CALL
##########################################################
]]--
function MOD:SetErrorFilters()
	if(SV.db.SVOverride.filterErrors) then
		UIErrorsFrame:UnregisterEvent('UI_ERROR_MESSAGE')
		self:RegisterEvent('UI_ERROR_MESSAGE')
	elseif(SV.db.SVOverride.hideErrorFrame) then
		self:RegisterEvent('PLAYER_REGEN_DISABLED', ErrorFrameHandler)
		self:RegisterEvent('PLAYER_REGEN_ENABLED', ErrorFrameHandler)
	end
end