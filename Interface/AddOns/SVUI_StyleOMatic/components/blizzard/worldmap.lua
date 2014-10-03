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
local SV = _G.SVUI;
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function AdjustMapLevel()
  if InCombatLockdown()then return end 
    WorldMapFrame:SetFrameLevel(4)
    WorldMapDetailFrame:SetFrameLevel(6)
    WorldMapFrame:SetFrameStrata('HIGH')
    WorldMapArchaeologyDigSites:SetFrameLevel(8)
    WorldMapArchaeologyDigSites:SetFrameStrata('DIALOG')
end

local function WorldMap_SmallView()
  WorldMapFrame.Panel:ClearAllPoints()
  WorldMapFrame.Panel:WrapOuter(WorldMapFrame, 4, 4)
  WorldMapFrame.Panel.Panel:WrapOuter(WorldMapFrame.Panel)
end 

local function WorldMap_FullView()
  WorldMapFrame.Panel:ClearAllPoints()

  if(SV.GameVersion >= 60000) then
    WorldMapFrame.Panel:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -12, 74)
    WorldMapFrame.Panel:Point("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 12, -24)
  else
    WorldMapFrame.Panel:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -12, 74)
    WorldMapFrame.Panel:Point("BOTTOMRIGHT", WorldMapShowDropDown, "BOTTOMRIGHT", 4, -4)
  end
  WorldMapFrame.Panel.Panel:SetAllPoints(SV.UIParent)
end 

local function WorldMap_QuestView()
  WorldMap_FullView()
  if not WorldMapQuestDetailScrollFrame.Panel then
    WorldMapQuestDetailScrollFrame:SetFixedPanelTemplate("Inset")
    WorldMapQuestDetailScrollFrame.Panel:Point("TOPLEFT", -22, 2)
    WorldMapQuestDetailScrollFrame.Panel:Point("BOTTOMRIGHT", WorldMapShowDropDown, 4, -4)
    WorldMapQuestDetailScrollFrame.spellTex = WorldMapQuestDetailScrollFrame:CreateTexture(nil, 'ARTWORK')
    WorldMapQuestDetailScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
    WorldMapQuestDetailScrollFrame.spellTex:SetPoint("TOPLEFT", WorldMapQuestDetailScrollFrame.Panel, 'TOPLEFT', 2, -2)
    WorldMapQuestDetailScrollFrame.spellTex:Size(586, 310)
    WorldMapQuestDetailScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
  end 
  if not WorldMapQuestRewardScrollFrame.Panel then
    WorldMapQuestRewardScrollFrame:SetPanelTemplate("Inset")
    WorldMapQuestRewardScrollFrame.Panel:Point("BOTTOMRIGHT", 22, -4)
    WorldMapQuestRewardScrollFrame.spellTex = WorldMapQuestRewardScrollFrame:CreateTexture(nil, 'ARTWORK')
    WorldMapQuestRewardScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
    WorldMapQuestRewardScrollFrame.spellTex:SetPoint("TOPLEFT", WorldMapQuestRewardScrollFrame.Panel, 'TOPLEFT', 2, -2)
    WorldMapQuestRewardScrollFrame.spellTex:Size(585, 310)
    WorldMapQuestRewardScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
  end 
  if not WorldMapQuestScrollFrame.Panel then
    WorldMapQuestScrollFrame:SetPanelTemplate("Inset")
    WorldMapQuestScrollFrame.Panel:Point("TOPLEFT", 0, 2)
    WorldMapQuestScrollFrame.Panel:Point("BOTTOMRIGHT", 25, -3)
    WorldMapQuestScrollFrame.spellTex = WorldMapQuestScrollFrame:CreateTexture(nil, 'ARTWORK')
    WorldMapQuestScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
    WorldMapQuestScrollFrame.spellTex:SetPoint("TOPLEFT", WorldMapQuestScrollFrame.Panel, 'TOPLEFT', 2, -2)
    WorldMapQuestScrollFrame.spellTex:Size(520, 1033)
    WorldMapQuestScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
  end 
end

local function StripQuestMapFrame()
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
  WorldMapFrameNavBar:Point("TOPLEFT", WorldMapFrame.Panel, "TOPLEFT", 12, -22)
  WorldMapFrameNavBar:SetPanelTemplate("Blackout")
end

local function WorldMap_OnShow()

  if(SV.GameVersion >= 60000) then
    --StripQuestMapFrame()
    if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
      WorldMap_FullView()
    elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
      WorldMap_SmallView()
    end 
  else
    WorldMapFrame:RemoveTextures()
    if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
      WorldMap_FullView()
    elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
      WorldMap_SmallView()
    elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
      WorldMap_QuestView()
    end 
  end

  if not SV.db.SVMap.tinyWorldMap then
    BlackoutWorld:SetTexture(0, 0, 0, 1)
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
WORLDMAP STYLER
##########################################################
]]--
local function WorldMapStyle()
  if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.worldmap ~= true then return end

  WorldMapFrame:SetFrameLevel(4)
  STYLE:ApplyWindowStyle(WorldMapFrame, true, true)
  WorldMapFrame.Panel:SetPanelTemplate("Blackout")

  STYLE:ApplyScrollFrameStyle(WorldMapQuestScrollFrameScrollBar)
  STYLE:ApplyScrollFrameStyle(WorldMapQuestDetailScrollFrameScrollBar, 4)
  STYLE:ApplyScrollFrameStyle(WorldMapQuestRewardScrollFrameScrollBar, 4)

  WorldMapDetailFrame:SetFrameLevel(6)
  WorldMapDetailFrame:SetPanelTemplate("Blackout")

  WorldMapArchaeologyDigSites:SetFrameLevel(8)
  
  WorldMapFrameSizeDownButton:SetFrameLevel(999)
  WorldMapFrameSizeUpButton:SetFrameLevel(999)
  WorldMapFrameCloseButton:SetFrameLevel(999)

  STYLE:ApplyCloseButtonStyle(WorldMapFrameCloseButton)
  STYLE:ApplyArrowButtonStyle(WorldMapFrameSizeDownButton, "down")
  STYLE:ApplyArrowButtonStyle(WorldMapFrameSizeUpButton, "up")

  STYLE:ApplyDropdownStyle(WorldMapLevelDropDown)
  STYLE:ApplyDropdownStyle(WorldMapZoneMinimapDropDown)
  STYLE:ApplyDropdownStyle(WorldMapContinentDropDown)
  STYLE:ApplyDropdownStyle(WorldMapZoneDropDown)
  STYLE:ApplyDropdownStyle(WorldMapShowDropDown)

  if(SV.GameVersion < 60000) then
    WorldMapZoomOutButton:SetButtonTemplate()
    WorldMapTrackQuest:SetCheckboxTemplate(true)
    hooksecurefunc("WorldMapFrame_SetFullMapView", WorldMap_FullView)
    hooksecurefunc("WorldMapFrame_SetQuestMapView", WorldMap_QuestView)
  else
    StripQuestMapFrame()
  end

  WorldMapFrame:HookScript("OnShow", WorldMap_OnShow)
  hooksecurefunc("WorldMap_ToggleSizeUp", WorldMap_OnShow)
  BlackoutWorld:SetParent(WorldMapFrame.Panel.Panel)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(WorldMapStyle)

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