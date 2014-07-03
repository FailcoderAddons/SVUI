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
local DOCK = SuperVillain.Registry:Expose('SVDock');
--[[ 
########################################################## 
TINYDPS
##########################################################
]]--
local function StyleTinyDPS()
  MOD:ApplyFrameStyle(tdpsFrame)

  tdpsFrame:HookScript('OnShow', function()
    if InCombatLockdown() then return end;
    if DOCK.CurrentlyDocked["tdpsFrame"] then
      SuperDockWindow:Show()
    end
  end)

  if tdpsStatusBar then
    tdpsStatusBar:SetBackdrop({bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], edgeFile = S.Blank, tile = false, tileSize = 0, edgeSize = 1})
    tdpsStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
  end
  tdpsRefresh()
end

MOD:SaveAddonStyle("TinyDPS", StyleTinyDPS)

function MOD:Docklet_TinyDPS(parent)
  if not tdpsFrame then return end;
  tdpsFrame:SetFixedPanelTemplate('Transparent',true)
  tdpsFrame:SetFrameStrata('LOW')
  tdps.hideOOC=false;
  tdps.hideIC=false;
  tdps.hideSolo=false;
  tdps.hidePvP=false;
  tdpsFrame:ClearAllPoints()
  tdpsFrame:SetAllPoints(parent)
  tdpsRefresh()
end;