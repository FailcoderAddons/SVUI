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
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
HELPERS
##########################################################
]]--
local function AdjustMapLevel()
  if InCombatLockdown()then return end 
    WorldMapFrame:SetFrameLevel(2)
    WorldMapDetailFrame:SetFrameLevel(4)
    WorldMapFrame:SetFrameStrata('HIGH')
    WorldMapArchaeologyDigSites:SetFrameLevel(6)
    WorldMapArchaeologyDigSites:SetFrameStrata('DIALOG')
end
local function WorldMap_SmallView()
  WorldMapFrame.Panel:ClearAllPoints()
  WorldMapFrame.Panel:SetAllPoints(WorldMapFrame)
  WorldMapFrame.backdrop:ClearAllPoints()
  WorldMapFrame.backdrop:Point("TOPLEFT", WorldMapFrame.Panel, 2, 2)
  WorldMapFrame.backdrop:Point("BOTTOMRIGHT", WorldMapFrame.Panel, 2, -2)
end 
local function WorldMap_FullView()
  WorldMapFrame.Panel:ClearAllPoints()
  WorldMapFrame.Panel:Point("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -12, 70)
  WorldMapFrame.Panel:Point("BOTTOMRIGHT", WorldMapShowDropDown, "BOTTOMRIGHT", 4, -4)
  WorldMapFrame.backdrop:ClearAllPoints()
  WorldMapFrame.backdrop:Point("TOPLEFT", WorldMapFrame.Panel, 2, 2)
  WorldMapFrame.backdrop:Point("BOTTOMRIGHT", WorldMapFrame.Panel, 2, -2)
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
local function WorldMap_OnShow()
  WorldMapFrame:Formula409()
  if not SuperVillain.db.SVMap.tinyWorldMap then
    BlackoutWorld:SetTexture(0, 0, 0, 1)
  else
    BlackoutWorld:SetTexture(nil)
  end 
  if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
    WorldMap_FullView()
  elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then 
    WorldMap_SmallView()
  elseif WORLDMAP_SETTINGS.size == WORLDMAP_QUESTLIST_SIZE then
    WorldMap_QuestView()
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
  WorldMapFrame:SetFrameLevel(2)
  WorldMapDetailFrame:SetFrameLevel(4)
  WorldMapFrame:SetFrameStrata('HIGH')
  WorldMapArchaeologyDigSites:SetFrameLevel(6)
  WorldMapArchaeologyDigSites:SetFrameStrata('DIALOG')
  AdjustMapLevel()
end 
--[[ 
########################################################## 
WORLDMAP STYLER
##########################################################
]]--
local function WorldMapQuestStyle()
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.worldmap ~= true then return end 
  WorldMapFrame:SetFrameLevel(2)
  MOD:ApplyScrollStyle(WorldMapQuestScrollFrameScrollBar)
  MOD:ApplyScrollStyle(WorldMapQuestDetailScrollFrameScrollBar, 4)
  MOD:ApplyScrollStyle(WorldMapQuestRewardScrollFrameScrollBar, 4)
  WorldMapFrame:SetPanelTemplate("Transparent")
  WorldMapFrame.Panel:SetFrameLevel(1)
  WorldMapFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
  WorldMapFrame.backdrop:SetAllPoints(WorldMapFrame)
  WorldMapFrame.backdrop:SetFrameLevel(0)
  WorldMapFrame.backdrop:SetPanelTemplate("Action");
  WorldMapDetailFrame:SetFrameLevel(4)
  WorldMapArchaeologyDigSites:SetFrameLevel(6)
  WorldMapDetailFrame:SetPanelTemplate("Inset")
  WorldMapDetailFrame.Panel:SetFrameLevel(3)
  MOD:ApplyCloseButtonStyle(WorldMapFrameCloseButton)
  MOD:ApplyCloseButtonStyle(WorldMapFrameSizeDownButton)
  MOD:ApplyCloseButtonStyle(WorldMapFrameSizeUpButton)
  WorldMapFrameSizeDownButton:SetFrameLevel(50)
  WorldMapFrameSizeUpButton:SetFrameLevel(50)
  WorldMapFrameCloseButton:SetFrameLevel(50)
  MOD:ApplyDropdownStyle(WorldMapLevelDropDown)
  MOD:ApplyDropdownStyle(WorldMapZoneMinimapDropDown)
  MOD:ApplyDropdownStyle(WorldMapContinentDropDown)
  MOD:ApplyDropdownStyle(WorldMapZoneDropDown)
  MOD:ApplyDropdownStyle(WorldMapShowDropDown)
  WorldMapZoomOutButton:SetButtonTemplate()
  WorldMapTrackQuest:SetCheckboxTemplate(true)
  WorldMapFrame:HookScript("OnShow", WorldMap_OnShow)
  hooksecurefunc("WorldMapFrame_SetFullMapView", WorldMap_FullView)
  hooksecurefunc("WorldMapFrame_SetQuestMapView", WorldMap_QuestView)
  hooksecurefunc("WorldMap_ToggleSizeUp", WorldMap_OnShow)
  BlackoutWorld:SetParent(WorldMapFrame.backdrop)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(WorldMapQuestStyle)

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