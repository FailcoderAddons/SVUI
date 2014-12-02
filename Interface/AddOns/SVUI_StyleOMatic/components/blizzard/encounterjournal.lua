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
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
ENCOUNTERJOURNAL PLUGINR
##########################################################
]]--
local PVP_LOST = [[Interface\WorldMap\Skull_64Red]]

local function Tab_OnEnter(this)
  this.backdrop:SetPanelColor("highlight")
  this.backdrop:SetBackdropBorderColor(0.1, 0.8, 0.8)
end

local function Tab_OnLeave(this)
  this.backdrop:SetPanelColor("dark")
  this.backdrop:SetBackdropBorderColor(0,0,0,1)
end

local function ChangeTabHelper(this, xOffset, yOffset)
  this:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
  this:GetNormalTexture():FillInner()
  this.backdrop = CreateFrame("Frame", nil, this)
  this.backdrop:FillInner(this)

  local level = this:GetFrameLevel()
  if(level > 0) then 
    this.backdrop:SetFrameLevel(level - 1)
  else 
    this.backdrop:SetFrameLevel(0)
  end

  this.backdrop:SetPanelTemplate("Component", true)
  this.backdrop:SetPanelColor("dark")
  this:HookScript("OnEnter",Tab_OnEnter)
  this:HookScript("OnLeave",Tab_OnLeave)

  local initialAnchor, anchorParent, relativeAnchor, xPosition, yPosition = this:GetPoint()
  this:Point(initialAnchor, anchorParent, relativeAnchor, xOffset or 7, yOffset or yPosition)
end

local function Outline(frame, noHighlight)
    if(frame.Outlined) then return; end
    local offset = noHighlight and 30 or 5
    local mod = noHighlight and 50 or 5

    local panel = CreateFrame('Frame', nil, frame)
    panel:Point('TOPLEFT', frame, 'TOPLEFT', 1, -1)
    panel:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -1, 1)

    --[[ UNDERLAY BORDER ]]--
    local borderLeft = panel:CreateTexture(nil, "BORDER")
    borderLeft:SetTexture(0, 0, 0)
    borderLeft:SetPoint("TOPLEFT")
    borderLeft:SetPoint("BOTTOMLEFT")
    borderLeft:SetWidth(offset)

    local borderRight = panel:CreateTexture(nil, "BORDER")
    borderRight:SetTexture(0, 0, 0)
    borderRight:SetPoint("TOPRIGHT")
    borderRight:SetPoint("BOTTOMRIGHT")
    borderRight:SetWidth(offset)

    local borderTop = panel:CreateTexture(nil, "BORDER")
    borderTop:SetTexture(0, 0, 0)
    borderTop:SetPoint("TOPLEFT")
    borderTop:SetPoint("TOPRIGHT")
    borderTop:SetHeight(mod)

    local borderBottom = panel:CreateTexture(nil, "BORDER")
    borderBottom:SetTexture(0, 0, 0)
    borderBottom:SetPoint("BOTTOMLEFT")
    borderBottom:SetPoint("BOTTOMRIGHT")
    borderBottom:SetHeight(mod)

    if(not noHighlight) then
      local highlight = frame:CreateTexture(nil, "HIGHLIGHT")
      highlight:SetTexture(0, 1, 1, 0.35)
      highlight:SetAllPoints(panel)
    end

    frame.Outlined = true
end

local function _hook_EncounterJournal_DisplayEncounter()
    local parent = EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild;
    if (parent.Bullets and #parent.Bullets > 0) then
      print(#parent.Bullets)
        for i = 1, #parent.Bullets do
            local bullet = parent.Bullets[1];
            bullet.Text:SetTextColor(1,1,1)
        end
    end
end

local function EncounterJournalStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.encounterjournal ~= true then
		 return 
	end 

	EncounterJournal:RemoveTextures(true)
  EncounterJournalInstanceSelect:RemoveTextures(true)
  EncounterJournalNavBar:RemoveTextures(true)
  EncounterJournalNavBarOverlay:RemoveTextures(true)
  EncounterJournalNavBarHomeButton:RemoveTextures(true)
  EncounterJournalInset:RemoveTextures(true)

  EncounterJournalEncounterFrame:RemoveTextures(true)
  EncounterJournalEncounterFrameInfo:RemoveTextures(true)
  EncounterJournalEncounterFrameInfoDifficulty:RemoveTextures(true)
  EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:RemoveTextures(true)
  EncounterJournalEncounterFrameInfoBossesScrollFrame:RemoveTextures(true)
  EncounterJournalInstanceSelectDungeonTab:RemoveTextures(true)
  EncounterJournalInstanceSelectRaidTab:RemoveTextures(true)
  ChangeTabHelper(EncounterJournalEncounterFrameInfoOverviewTab)
  ChangeTabHelper(EncounterJournalEncounterFrameInfoLootTab, 0, -10)

  EncounterJournalEncounterFrameInfoOverviewScrollFrame:RemoveTextures()
  EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetTextColor(1,1,0)
  EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildLoreDescription:SetTextColor(1,1,1)
  EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild.overviewDescription.Text:SetTextColor(1,1,1)
  local bulletParent = EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChild;
  if (bulletParent.Bullets and #bulletParent.Bullets > 0) then
      for i = 1, #bulletParent.Bullets do
          local bullet = bulletParent.Bullets[1];
          bullet.Text:SetTextColor(1,1,1)
      end
  end

  EncounterJournalSearchResults:RemoveTextures(true)

  EncounterJournal:SetPanelTemplate("Action")
  EncounterJournal:SetPanelColor("dark")
  EncounterJournalInset:SetFixedPanelTemplate("Inset")

  EncounterJournalInstanceSelectScrollFrameScrollChild:SetFixedPanelTemplate("Default")
  EncounterJournalInstanceSelectScrollFrameScrollChild:SetPanelColor("dark")
  EncounterJournalInstanceSelectScrollDownButton:SetButtonTemplate()
  EncounterJournalInstanceSelectScrollDownButton:SetNormalTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\MOVE-DOWN]])

  EncounterJournalEncounterFrameInstanceFrame:SetFixedPanelTemplate("Inset")

  local comicHolder = CreateFrame('Frame', nil, EncounterJournal.encounter)
  comicHolder:SetPoint("TOPLEFT", EncounterJournalEncounterFrameInfoBossesScrollFrame, "TOPLEFT", -20, 40)
  comicHolder:SetPoint("BOTTOMRIGHT", EncounterJournalEncounterFrameInfoBossesScrollFrame, "BOTTOMRIGHT", 0, 0)
  comicHolder:SetPanelTemplate("Comic")
  comicHolder:SetPanelColor("dark")
  EncounterJournal.encounter.info.encounterTitle:SetParent(comicHolder)
  EncounterJournal.searchResults.TitleText:SetParent(comicHolder)

  EncounterJournalNavBarHomeButton:SetButtonTemplate()
  EncounterJournalEncounterFrameInfoDifficulty:SetButtonTemplate()
  EncounterJournalEncounterFrameInfoDifficulty:SetFrameLevel(EncounterJournalEncounterFrameInfoDifficulty:GetFrameLevel() + 10)
  EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:SetButtonTemplate()
  EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:SetFrameLevel(EncounterJournalEncounterFrameInfoLootScrollFrameFilterToggle:GetFrameLevel() + 10)

  EncounterJournalInstanceSelectDungeonTab:SetButtonTemplate()
  EncounterJournalInstanceSelectRaidTab:SetButtonTemplate()

  PLUGIN:ApplyScrollBarStyle(EncounterJournalEncounterFrameInfoLootScrollBar)

  local bgParent = EncounterJournal.encounter.instance
  local loreParent = EncounterJournal.encounter.instance.loreScroll

  bgParent.loreBG:SetPoint("TOPLEFT", bgParent, "TOPLEFT", 0, 0)
  bgParent.loreBG:SetPoint("BOTTOMRIGHT", bgParent, "BOTTOMRIGHT", 0, 90)

  loreParent:SetPanelTemplate("Pattern", true, 1, 1, 5)
  loreParent:SetPanelColor("dark")
  loreParent.child.lore:SetTextColor(1, 1, 1)
  EncounterJournal.encounter.infoFrame.description:SetTextColor(1, 1, 1)

  loreParent:SetFrameLevel(loreParent:GetFrameLevel() + 10)

  local frame = EncounterJournal.instanceSelect.scroll.child
  local index = 1
  local instanceButton = frame["instance"..index];
  while instanceButton do
      Outline(instanceButton)
      index = index + 1;
      instanceButton = frame["instance"..index]
  end

  --hooksecurefunc("EncounterJournal_DisplayEncounter", _hook_EncounterJournal_DisplayEncounter)

  hooksecurefunc("EncounterJournal_ListInstances", function()
    local frame = EncounterJournal.instanceSelect.scroll.child
    local index = 1
    local instanceButton = frame["instance"..index];
    while instanceButton do
        Outline(instanceButton)
        index = index + 1;
        instanceButton = frame["instance"..index]
    end
  end)

  EncounterJournal.instanceSelect.raidsTab:GetFontString():SetTextColor(1, 1, 1);
  hooksecurefunc("EncounterJournal_ToggleHeaders", function()
    local usedHeaders = EncounterJournal.encounter.usedHeaders
    for key,used in pairs(usedHeaders) do
      if(not used.button.Panel) then
          used:RemoveTextures(true)
          used.button:RemoveTextures(true)
          used.button:SetButtonTemplate()
      end
      used.description:SetTextColor(1, 1, 1)
      used.button.portrait.icon:Hide()
    end
  end)
    
  hooksecurefunc("EncounterJournal_LootUpdate", function()
    local scrollFrame = EncounterJournal.encounter.info.lootScroll;
    local offset = HybridScrollFrame_GetOffset(scrollFrame);
    local items = scrollFrame.buttons;
    local item, index;

    local numLoot = EJ_GetNumLoot()

    for i = 1,#items do
      item = items[i];
      index = offset + i;
      if index <= numLoot then
          item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
          if(not item.Panel) then
            item:SetFixedPanelTemplate("Slot")
          end
          item.slot:SetTextColor(0.5, 1, 0)
          item.armorType:SetTextColor(1, 1, 0)
          item.boss:SetTextColor(0.7, 0.08, 0)
      end
    end
  end)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle('Blizzard_EncounterJournal', EncounterJournalStyle)