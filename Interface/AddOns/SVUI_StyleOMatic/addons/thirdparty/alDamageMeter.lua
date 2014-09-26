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
ALDAMAGEMETER
##########################################################
]]--
local function StyleALDamageMeter()
  assert(_G['alDamagerMeterFrame'], "AddOn Not Loaded")
  
  alDamageMeterFrame.bg:Die()
  STYLE:ApplyFrameStyle(alDamageMeterFrame)
  alDamageMeterFrame:HookScript('OnShow', function()
    if InCombatLockdown() then return end 
    if SV.CurrentlyDocked["alDamagerMeterFrame"] then
      SuperDockWindowRight:Show()
    end
  end)
end
STYLE:SaveAddonStyle("alDamageMeter", StyleALDamageMeter)

function STYLE:Docklet_alDamageMeter(parent)
  if not _G['alDamagerMeterFrame'] then return end 
  local parentFrame=_G['alDamagerMeterFrame']:GetParent();
  dmconf.barheight=floor(parentFrame:GetHeight()/dmconf.maxbars-dmconf.spacing)
  dmconf.width=parentFrame:GetWidth()
  alDamageMeterFrame:ClearAllPoints()
  alDamageMeterFrame:SetAllPoints(parent)
  alDamageMeterFrame.backdrop:SetFixedPanelTemplate('Transparent',true)
  alDamageMeterFrame.bg:Die()
  alDamageMeterFrame:SetFrameStrata('LOW')
end 