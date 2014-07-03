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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
local DOCK = SuperVillain.Registry:Expose('SVDock');
local activePanels = {};
--[[ 
########################################################## 
SKADA
##########################################################
]]--
local mFrame = CreateFrame("Frame","SkadaHolder",UIParent)
mFrame:SetAllPoints()

local eFrame = CreateFrame("Frame","SkadaHolder2",UIParent)
eFrame:SetAllPoints()

local function StyleSkada()
  function Skada:ShowPopup()
    MOD:LoadAlert(L['Do you want to reset Skada?'], function(self) Skada:Reset() self:GetParent():Hide() end)
  end
  
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
    skada:SetFrameLevel(5)
    skada:SetBackdrop(nil)
    if(window.db.enabletitle and not skada.button.Panel) then
      skada.button:SetFixedPanelTemplate('Default', true)
    end
    if(not skada.Panel) then
      MOD:ApplyFrameStyle(skada)
    end
    if(skada.Panel) then
      skada.Panel:ClearAllPoints()
      skada.Panel:Point('TOPLEFT', window.db.enabletitle and skada.button or skada, 'TOPLEFT', -2, 2)
      skada.Panel:Point('BOTTOMRIGHT', skada, 'BOTTOMRIGHT', 2, -2)
    end
  end)

  hooksecurefunc(Skada, 'ToggleWindow', function()
    if InCombatLockdown() then return end;
    if not DOCK.CurrentlyDocked["SkadaHolder"] or not DOCK.CurrentlyDocked["SkadaHolder2"] then return end
    for index, window in ipairs(Skada:GetWindows()) do
      if window:IsShown() then
        SuperDockWindow:Show()
      else
        SuperDockWindow:Hide()
      end
    end
  end)

  hooksecurefunc(Skada, 'CreateWindow', function()
    if DOCK.CurrentlyDocked["SkadaHolder"] or DOCK.CurrentlyDocked["SkadaHolder2"] then
      MOD:Docklet_Skada()
    end
  end)
  hooksecurefunc(Skada, 'DeleteWindow', function()
    if DOCK.CurrentlyDocked["SkadaHolder"] or DOCK.CurrentlyDocked["SkadaHolder2"] then
      MOD:Docklet_Skada()
    end
  end)
  hooksecurefunc(Skada, 'UpdateDisplay', function()
    if DOCK.CurrentlyDocked["SkadaHolder"] or DOCK.CurrentlyDocked["SkadaHolder2"] then
      MOD:Docklet_Skada()
    end
  end)
end

MOD:SaveAddonStyle("Skada", StyleSkada)

function MOD:Docklet_Skada()
  if not Skada then return end;

  local function skada_panel_loader(holder, window, width, height, parent)
    if not window then return end;

    local bars = Skada.displays['bar']

    holder:SetParent(parent)
    holder:SetAllPoints()

    window.db.barspacing = 1;
    window.db.barwidth = width - 4;
    window.db.background.height = height - (window.db.enabletitle and window.db.title.height or 0) - 1;
    window.db.spark=false;
    window.db.barslocked = true;
    window.bargroup:ClearAllPoints()
    window.bargroup:SetPoint('BOTTOMLEFT',holder,'BOTTOMLEFT',0,0)
    window.bargroup:SetParent(holder)
    window.bargroup:SetFrameStrata('LOW')

    local bgroup = window.bargroup.backdrop;
    if bgroup and not bgroup.Panel then 
      bgroup:Show()
      bgroup:SetFixedPanelTemplate('Transparent',true) 
    end;

    bars.ApplySettings(bars, window)
  end;

  for index,window in pairs(Skada:GetWindows()) do
    local key = "Skada"..window.db.name
    local parent;
    if(SuperVillain.db.SVDock.docklets.DockletMain == key)then 
      parent = SuperDockletMain
      skada_panel_loader(SkadaHolder, window, parent:GetWidth(), parent:GetHeight(), parent)
    elseif(SuperVillain.db.SVDock.docklets.enableExtra and SuperVillain.db.SVDock.docklets.DockletExtra == key) then
      parent = SuperDockletExtra
      skada_panel_loader(SkadaHolder2, window, parent:GetWidth(), parent:GetHeight(), parent)
    else
      window.db.barslocked = false;
    end
  end;
end;