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
local twipe = table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
local activePanels = {};
local StupidSkada = function() return end
--[[ 
########################################################## 
SKADA
##########################################################
]]--
local function skada_panel_loader(holder, window)
  if(not window) then return end 

  local bars = Skada.displays['bar']

  if(not bars) then return end
  local width,height = holder:GetSize()

  window.db.barspacing = 1;
  window.db.barwidth = width - 4;
  window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0) - 1;
  window.db.spark = false;
  window.db.barslocked = true;
  window.bargroup:ClearAllPoints()
  window.bargroup:SetAllPoints(holder)
  window.bargroup:SetFrameStrata('LOW')

  local bgroup = window.bargroup.backdrop;
  if bgroup then 
    bgroup:Show()
    bgroup:SetFixedPanelTemplate('Transparent', true) 
  end

  holder.FrameLink = window;
end

function PLUGIN:Docklet_Skada()
  if not Skada then return end 
  for index,window in pairs(Skada:GetWindows()) do
    local wname = window.db.name or "Skada"
    local key = "SkadaBarWindow" .. wname
    if(PLUGIN.cache.Docks[1] == key) then
      skada_panel_loader(PLUGIN.Docklet.Dock1, window)
    elseif(SVUI.db.Dock.docklets.enableExtra and PLUGIN.cache.Docks[2] == key) then
      skada_panel_loader(PLUGIN.Docklet.Dock2, window)
    else
      window.db.barslocked = false;
    end
  end

  PLUGIN.Docklet.Parent.Bar:GetDefault()
end

local function Skada_ShowPopup(self)
  PLUGIN:LoadAlert('Do you want to reset Skada?', function(self) Skada:Reset() self:GetParent():Hide() end)
end

local function StyleSkada()
  assert(Skada, "AddOn Not Loaded")
  Skada.ShowPopup = Skada_ShowPopup
  
  local SkadaDisplayBar = Skada.displays['bar']

  hooksecurefunc(SkadaDisplayBar, 'AddDisplayOptions', function(self, window, options)
    options.baroptions.args.barspacing = nil
    options.titleoptions.args.texture = nil
    options.titleoptions.args.bordertexture = nil
    options.titleoptions.args.thickness = nil
    options.titleoptions.args.margin = nil
    options.titleoptions.args.color = nil
    options.windowoptions = nil
  end)

  hooksecurefunc(SkadaDisplayBar, 'ApplySettings', function(self, window)
    local skada = window.bargroup
    if not skada then return end
    local panelAnchor = skada
    skada:SetSpacing(1)
    skada:SetFrameLevel(5)
    skada:SetBackdrop(nil)

    if(window.db.enabletitle) then
      panelAnchor = skada.button
      skada.button:SetHeight(18)
      skada.button:SetButtonTemplate()
      skada.button:GetFontString():SetFont(SVUI.Media.font.names, 15, "OUTLINE")
    end

    skada:SetPanelTemplate("Transparent")
    skada.Panel:ClearAllPoints()
    skada.Panel:SetPoint('TOPLEFT', panelAnchor, 'TOPLEFT', -2, 2)
    skada.Panel:SetPoint('BOTTOMRIGHT', skada, 'BOTTOMRIGHT', 2, -2)
  end)

  hooksecurefunc(Skada, 'CreateWindow', function()
    if PLUGIN:ValidateDocklet("Skada") then
      PLUGIN:Docklet_Skada()
    end
  end)

  hooksecurefunc(Skada, 'DeleteWindow', function()
    if PLUGIN:ValidateDocklet("Skada") then
      PLUGIN:Docklet_Skada()
    end
  end)
end

PLUGIN:SaveAddonStyle("Skada", StyleSkada, nil, true)