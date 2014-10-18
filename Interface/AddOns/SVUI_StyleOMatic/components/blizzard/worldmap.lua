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
local function AdjustMapLevel()
  if InCombatLockdown()then return end
    local WorldMapFrame = _G.WorldMapFrame;
    WorldMapFrame:SetFrameLevel(4)
    WorldMapDetailFrame:SetFrameLevel(6)
    WorldMapFrame:SetFrameStrata('HIGH')
    WorldMapArchaeologyDigSites:SetFrameLevel(8)
    WorldMapArchaeologyDigSites:SetFrameStrata('DIALOG')
end

local function WorldMap_SmallView()
  local WorldMapFrame = _G.WorldMapFrame;
  WorldMapFrame.Panel:ClearAllPoints()
  WorldMapFrame.Panel:WrapOuter(WorldMapFrame, 4, 4)
  WorldMapFrame.Panel.Panel:WrapOuter(WorldMapFrame.Panel)
end 

local function WorldMap_FullView()
  local WorldMapFrame = _G.WorldMapFrame;
  WorldMapFrame.Panel:ClearAllPoints()
  local w, h = WorldMapDetailFrame:GetSize()
  WorldMapFrame.Panel:Size(w + 24, h + 98)
  WorldMapFrame.Panel:Point("TOP", WorldMapFrame, "TOP", 0, 0)
  WorldMapFrame.Panel.Panel:WrapOuter(WorldMapFrame.Panel)
end 

local function StripQuestMapFrame()
  local WorldMapFrame = _G.WorldMapFrame;

  WorldMapFrame.BorderFrame:RemoveTextures(true)
  WorldMapFrame.BorderFrame.ButtonFrameEdge:SetTexture(0,0,0,0)
  WorldMapFrame.BorderFrame.InsetBorderTop:SetTexture(0,0,0,0)
  WorldMapFrame.BorderFrame.Inset:RemoveTextures(true)
  WorldMapTitleButton:RemoveTextures(true)
  WorldMapFrameNavBar:RemoveTextures(true)
  WorldMapFrameNavBarOverlay:RemoveTextures(true)
  QuestMapFrame:RemoveTextures(true)
  QuestMapFrame.DetailsFrame:RemoveTextures(true)

  QuestMapFrame.DetailsFrame:SetPanelTemplate("Paper")

  QuestMapFrame.DetailsFrame.CompleteQuestFrame:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:SetButtonTemplate()

  QuestMapFrame.DetailsFrame.BackButton:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.BackButton:SetButtonTemplate()

  QuestMapFrame.DetailsFrame.AbandonButton:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.AbandonButton:SetButtonTemplate()

  QuestMapFrame.DetailsFrame.ShareButton:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.ShareButton:SetButtonTemplate()

  QuestMapFrame.DetailsFrame.TrackButton:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.TrackButton:SetButtonTemplate()

  QuestMapFrame.DetailsFrame.RewardsFrame:RemoveTextures(true)
  QuestMapFrame.DetailsFrame.RewardsFrame:SetPanelTemplate("Paper")
  QuestMapFrame.DetailsFrame.RewardsFrame:SetPanelColor("dark")

  QuestScrollFrame:RemoveTextures(true)
  QuestScrollFrame:SetFixedPanelTemplate("Paper")
  QuestScrollFrame:SetPanelColor("special")

  QuestScrollFrame.ViewAll:RemoveTextures(true)
  QuestScrollFrame.ViewAll:SetButtonTemplate()

  local w,h = WorldMapFrame.UIElementsFrame:GetSize()
  local underlay = CreateFrame("Frame", nil, WorldMapFrame)
  underlay:Size(w,h)
  underlay:SetAllPoints(WorldMapFrame.UIElementsFrame)
  underlay:SetPanelTemplate("Blackout")

  WorldMapFrame.UIElementsFrame:SetParent(underlay)

  local detailWidth = QuestMapFrame.DetailsFrame.RewardsFrame:GetWidth()
  QuestMapFrame.DetailsFrame:ClearAllPoints()
  QuestMapFrame.DetailsFrame:SetPoint("TOPLEFT", underlay, "TOPRIGHT", 2, 0)
  QuestMapFrame.DetailsFrame:SetWidth(detailWidth)

  WorldMapFrameNavBar:ClearAllPoints()
  WorldMapFrameNavBar:Point("TOPLEFT", WorldMapFrame.Panel, "TOPLEFT", 12, -26)
  WorldMapFrameTutorialButton:ClearAllPoints()
  WorldMapFrameTutorialButton:Point("LEFT", WorldMapFrameNavBar.Panel, "RIGHT", -50, 0)
end

local function WorldMap_OnShow()
  local WorldMapFrame = _G.WorldMapFrame;
  
  if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
    WorldMap_FullView()
  elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
    WorldMap_SmallView()
  end
  -- WorldMap_SmallView()
  if not SV.db.SVMap.tinyWorldMap then
    BlackoutWorld:SetTexture(0,0,0,1)
  else
    BlackoutWorld:SetTexture(0,0,0,0)
  end

  WorldMapFrameAreaLabel:SetFontTemplate(nil, 50, "OUTLINE")
  WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
  WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)
  WorldMapFrameAreaDescription:SetFontTemplate(nil, 40, "OUTLINE")
  WorldMapFrameAreaDescription:SetShadowOffset(2, -2)
  WorldMapFrameAreaPetLevels:SetFontTemplate(nil, 25, 'OUTLINE')
  WorldMapZoneInfo:SetFontTemplate(nil, 27, "OUTLINE")
  WorldMapZoneInfo:SetShadowOffset(2, -2)

  if InCombatLockdown() then return end 
  AdjustMapLevel()
end 
--[[ 
########################################################## 
WORLDMAP PLUGINR
##########################################################
]]--
local function WorldMapStyle()
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.worldmap ~= true then return end

  WorldMapFrame:SetFrameLevel(4)
  PLUGIN:ApplyWindowStyle(WorldMapFrame, true, true)
  WorldMapFrame.Panel:SetPanelTemplate("Blackout")

  PLUGIN:ApplyScrollFrameStyle(WorldMapQuestScrollFrameScrollBar)
  PLUGIN:ApplyScrollFrameStyle(WorldMapQuestDetailScrollFrameScrollBar, 4)
  PLUGIN:ApplyScrollFrameStyle(WorldMapQuestRewardScrollFrameScrollBar, 4)

  WorldMapDetailFrame:SetFrameLevel(6)
  WorldMapDetailFrame:SetPanelTemplate("Blackout")

  WorldMapArchaeologyDigSites:SetFrameLevel(8)
  
  WorldMapFrameSizeDownButton:SetFrameLevel(999)
  WorldMapFrameSizeUpButton:SetFrameLevel(999)
  WorldMapFrameCloseButton:SetFrameLevel(999)

  PLUGIN:ApplyCloseButtonStyle(WorldMapFrameCloseButton)
  PLUGIN:ApplyArrowButtonStyle(WorldMapFrameSizeDownButton, "down")
  PLUGIN:ApplyArrowButtonStyle(WorldMapFrameSizeUpButton, "up")

  PLUGIN:ApplyDropdownStyle(WorldMapLevelDropDown)
  PLUGIN:ApplyDropdownStyle(WorldMapZoneMinimapDropDown)
  PLUGIN:ApplyDropdownStyle(WorldMapContinentDropDown)
  PLUGIN:ApplyDropdownStyle(WorldMapZoneDropDown)
  PLUGIN:ApplyDropdownStyle(WorldMapShowDropDown)

  StripQuestMapFrame()

  WorldMapFrame:HookScript("OnShow", WorldMap_OnShow)
  hooksecurefunc("WorldMap_ToggleSizeUp", WorldMap_OnShow)
  BlackoutWorld:SetParent(WorldMapFrame.Panel.Panel)

  WorldMapFrameNavBar:ClearAllPoints()
  WorldMapFrameNavBar:Point("TOPLEFT", WorldMapFrame.Panel, "TOPLEFT", 12, -26)
  WorldMapFrameNavBar:SetPanelTemplate("Blackout")
  WorldMapFrameTutorialButton:ClearAllPoints()
  WorldMapFrameTutorialButton:Point("LEFT", WorldMapFrameNavBar.Panel, "RIGHT", -50, 0)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(WorldMapStyle)

--[[
function ArchaeologyDigSiteFrame_OnUpdate()
    WorldMapArchaeologyDigSites:DrawNone();
    local numEntries = ArchaeologyMapUpdateAll();
    for i = 1, numEntries do
        local blobID = ArcheologyGetVisibleBlobID(i);
        WorldMapArchaeologyDigSites:DrawBlob(blobID, true);
    end
end
]]