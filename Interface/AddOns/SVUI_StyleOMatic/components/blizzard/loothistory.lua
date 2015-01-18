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
local math    = _G.math;
--[[ MATH METHODS ]]--
local ceil = math.ceil;  -- Basic
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
local MissingLootFrame_OnShow = function(self)
  local numMissing = GetNumMissingLootItems()
  for i = 1, numMissing do 
    local slot = _G["MissingLootFrameItem"..i]
    local icon = slot.icon;
    PLUGIN:ApplyItemButtonStyle(slot, true)
    local texture, name, count, quality = GetMissingLootItemInfo(i);
    local r,g,b,hex = GetItemQualityColor(quality)
    if(not r) then
      r,g,b = 0,0,0
    end
    icon:SetTexture(texture)
    _G.MissingLootFrame:SetBackdropBorderColor(r,g,b)
  end 
  local calc = (ceil(numMissing * 0.5) * 43) + 38
  _G.MissingLootFrame:SetHeight(calc + _G.MissingLootFrameLabel:GetHeight())
end 

local LootHistoryFrame_OnUpdate = function(self)
  local numItems = _G.C_LootHistory.GetNumItems()
  for i = 1, numItems do   
    local frame = _G.LootHistoryFrame.itemFrames[i]
    if not frame.isStyled then 
      local Icon = frame.Icon:GetTexture()
      frame:RemoveTextures()
      frame.Icon:SetTexture(Icon)
      frame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

      frame:SetStylePanel("!_Frame", "Button")
      frame.Panel:SetAllPointsOut(frame.Icon)
      frame.Icon:SetParent(frame.Panel)

      frame.isStyled = true 
    end 
  end 
end

local _hook_MasterLootFrame_OnShow = function()
  local MasterLooterFrame = _G.MasterLooterFrame;
  local item = MasterLooterFrame.Item;
  local LootFrame = _G.LootFrame;
  if item then 
    local icon = item.Icon;
    local tex = icon:GetTexture()
    local colors = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]
    item:RemoveTextures()
    icon:SetTexture(tex)
    icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    item:SetStylePanel("Frame", "Pattern")
    item.Panel:SetAllPointsOut(icon)
    item:SetBackdropBorderColor(colors.r, colors.g, colors.b)
  end 
  for i = 1, MasterLooterFrame:GetNumChildren()do 
    local child = select(i, MasterLooterFrame:GetChildren())
    if child and not child.isStyled and not child:GetName() then
      if child:GetObjectType() == "Button" then 
        if child:GetPushedTexture() then
          PLUGIN:ApplyCloseButtonStyle(child)
        else
          child:SetStylePanel("!_Frame")
          child:SetStylePanel("Button")
        end 
        child.isStyled = true 
      end 
    end 
  end 
end
--[[ 
########################################################## 
LOOTHISTORY PLUGINR
##########################################################
]]--
local function LootHistoryStyle()
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.loot ~= true then return end 

  local MasterLooterFrame = _G.MasterLooterFrame;
  local MissingLootFrame = _G.MissingLootFrame;
  local LootHistoryFrame = _G.LootHistoryFrame;
  local BonusRollFrame = _G.BonusRollFrame;
  local MissingLootFramePassButton = _G.MissingLootFramePassButton;

  LootHistoryFrame:SetFrameStrata('HIGH')

  MissingLootFrame:RemoveTextures()
  MissingLootFrame:SetStylePanel("Frame", "Pattern")

  PLUGIN:ApplyCloseButtonStyle(MissingLootFramePassButton)
  hooksecurefunc("MissingLootFrame_Show", MissingLootFrame_OnShow)
  LootHistoryFrame:RemoveTextures()
  PLUGIN:ApplyCloseButtonStyle(LootHistoryFrame.CloseButton)
  LootHistoryFrame:RemoveTextures()
  LootHistoryFrame:SetStylePanel("!_Frame", 'Transparent')
  PLUGIN:ApplyCloseButtonStyle(LootHistoryFrame.ResizeButton)
  LootHistoryFrame.ResizeButton:SetStylePanel("!_Frame")
  LootHistoryFrame.ResizeButton:SetWidthToScale(LootHistoryFrame:GetWidth())
  LootHistoryFrame.ResizeButton:SetHeightToScale(19)
  LootHistoryFrame.ResizeButton:ClearAllPoints()
  LootHistoryFrame.ResizeButton:SetPointToScale("TOP", LootHistoryFrame, "BOTTOM", 0, -2)
  LootHistoryFrame.ResizeButton:SetNormalTexture("")

  local txt = LootHistoryFrame.ResizeButton:CreateFontString(nil,"OVERLAY")
  txt:SetFont(SV.Media.font.default, 14, "NONE")
  txt:SetAllPoints(LootHistoryFrame.ResizeButton)
  txt:SetJustifyH("CENTER")
  txt:SetText("RESIZE")

  LootHistoryFrameScrollFrame:RemoveTextures()
  PLUGIN:ApplyScrollFrameStyle(LootHistoryFrameScrollFrameScrollBar)
  hooksecurefunc("LootHistoryFrame_FullUpdate", LootHistoryFrame_OnUpdate)

  MasterLooterFrame:RemoveTextures()
  MasterLooterFrame:SetStylePanel("!_Frame")
  MasterLooterFrame:SetFrameStrata('FULLSCREEN_DIALOG')

  hooksecurefunc("MasterLooterFrame_Show", _hook_MasterLootFrame_OnShow)

  BonusRollFrame:RemoveTextures()
  PLUGIN:ApplyAlertStyle(BonusRollFrame)
  BonusRollFrame.PromptFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(SV.Media.bar.default)
  BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(0.1, 1, 0.1)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(LootHistoryStyle)