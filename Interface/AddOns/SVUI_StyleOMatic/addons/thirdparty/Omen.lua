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
OMEN
##########################################################
]]--
local function StyleOmen()
  Omen.db.profile.Scale = 1
  Omen.db.profile.Bar.Spacing = 1
  Omen.db.profile.Background.EdgeSize = 2
  Omen.db.profile.Background.BarInset = 2
  Omen.db.profile.TitleBar.UseSameBG = true

  hooksecurefunc(Omen, 'UpdateBackdrop', function(self)
    if not DOCK.CurrentlyDocked["OmenAnchor"] then
      MOD:ApplyFrameStyle(self.BarList, 'Transparent')
      self.Title:Formula409()
      self.Title:SetPanelTemplate("Default")
      self.Title:SetPanelColor("class")
    end
    self.BarList:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, 1)
  end)

  hooksecurefunc(Omen, 'Toggle', function(self)
    if InCombatLockdown() then return end;
    if not DOCK.CurrentlyDocked["OmenAnchor"] then return end
    if self.Anchor:IsShown() then
      SuperDockWindow:Show()
    else
      SuperDockWindow:Hide()
    end
  end)

  Omen:UpdateBackdrop()
  Omen:ReAnchorBars()
  Omen:ResizeBars()
end
MOD:SaveAddonStyle("Omen", StyleOmen)

function MOD:Docklet_Omen(parent)
  if not Omen then return end;
  local db=Omen.db;
  db.profile.Scale=1;
  db.profile.Bar.Spacing=1;
  db.profile.Background.EdgeSize=2;
  db.profile.Background.BarInset=2;
  db.profile.TitleBar.UseSameBG=true;
  db.profile.ShowWith.UseShowWith=false;
  db.profile.Locked=true;
  db.profile.TitleBar.ShowTitleBar=true;
  db.profile.FrameStrata='2-LOW'
  Omen:OnProfileChanged(nil,db)
  OmenTitle:Formula409()
  OmenTitle.Panel = nil
  OmenTitle:SetPanelTemplate("Default")
  OmenTitle:SetPanelColor("class")
  OmenBarList:Formula409()
  OmenBarList.Panel = nil
  OmenBarList:SetFixedPanelTemplate('Transparent')
  OmenAnchor:ClearAllPoints()
  OmenAnchor:SetAllPoints(parent)
end;