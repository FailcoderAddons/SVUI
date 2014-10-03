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
local MissingLootFrame_OnShow = function()
  local N = GetNumMissingLootItems()
  for u = 1, N do 
    local O = _G["MissingLootFrameItem"..u]
    local icon = O.icon;
    STYLE:ApplyItemButtonStyle(O, true)
    local g, f, y, P = GetMissingLootItemInfo(u)
    local color = GetItemQualityColor(P) or 0,0,0,1
    icon:SetTexture(g)
    M:SetBackdropBorderColor(color)
  end 
  local Q = ceil(N/2)
  MissingLootFrame:SetHeight(Q * 43 + 38 + MissingLootFrameLabel:GetHeight())
end 

local LootHistoryFrame_OnUpdate = function(o)
  local N = C_LootHistory.GetNumItems()
  for u = 1, N do   
    local M = LootHistoryFrame.itemFrames[u]
    if not M.isStyled then 
      local Icon = M.Icon:GetTexture()
      M:RemoveTextures()
      M.Icon:SetTexture(Icon)
      M.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      M:SetFixedPanelTemplate("Button")
      M.Panel:WrapOuter(M.Icon)
      M.Icon:SetParent(M.Panel)
      M.isStyled = true 
    end 
  end 
end 
--[[ 
########################################################## 
LOOTHISTORY STYLER
##########################################################
]]--
local function LootHistoryStyle()
  LootHistoryFrame:SetFrameStrata('HIGH')
  if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.loot ~= true then return end 
  local M = MissingLootFrame;
  M:RemoveTextures()
  M:SetPanelTemplate("Pattern")
  STYLE:ApplyCloseButtonStyle(MissingLootFramePassButton)
  hooksecurefunc("MissingLootFrame_Show", MissingLootFrame_OnShow)
  LootHistoryFrame:RemoveTextures()
  STYLE:ApplyCloseButtonStyle(LootHistoryFrame.CloseButton)
  LootHistoryFrame:RemoveTextures()
  LootHistoryFrame:SetFixedPanelTemplate('Transparent')
  STYLE:ApplyCloseButtonStyle(LootHistoryFrame.ResizeButton)
  LootHistoryFrame.ResizeButton:SetFixedPanelTemplate()
  LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
  LootHistoryFrame.ResizeButton:Height(19)
  LootHistoryFrame.ResizeButton:ClearAllPoints()
  LootHistoryFrame.ResizeButton:Point("TOP", LootHistoryFrame, "BOTTOM", 0, -2)
  LootHistoryFrame.ResizeButton:SetNormalTexture("")

  local txt = LootHistoryFrame.ResizeButton:CreateFontString(nil,"OVERLAY")
  txt:SetFont(SV.Media.font.roboto, 14, "NONE")
  txt:SetAllPoints(LootHistoryFrame.ResizeButton)
  txt:SetJustifyH("CENTER")
  txt:SetText("RESIZE")

  LootHistoryFrameScrollFrame:RemoveTextures()
  STYLE:ApplyScrollFrameStyle(LootHistoryFrameScrollFrameScrollBar)
  hooksecurefunc("LootHistoryFrame_FullUpdate", LootHistoryFrame_OnUpdate)
  MasterLooterFrame:RemoveTextures()
  MasterLooterFrame:SetFixedPanelTemplate()
  MasterLooterFrame:SetFrameStrata('FULLSCREEN_DIALOG')
  hooksecurefunc("MasterLooterFrame_Show", function()
    local J = MasterLooterFrame.Item;
    if J then 
      local u = J.Icon;
      local icon = u:GetTexture()
      local S = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]
      J:RemoveTextures()
      u:SetTexture(icon)
      u:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      J:SetPanelTemplate("Pattern")
      J.Panel:WrapOuter(u)
      J.Panel:SetBackdropBorderColor(S.r, S.g, S.b)
    end 
    for u = 1, MasterLooterFrame:GetNumChildren()do 
      local T = select(u, MasterLooterFrame:GetChildren())
      if T and not T.isStyled and not T:GetName() then
        if T:GetObjectType() == "Button" then 
          if T:GetPushedTexture() then
            STYLE:ApplyCloseButtonStyle(T)
          else
            T:SetFixedPanelTemplate()
            T:SetButtonTemplate()
          end 
          T.isStyled = true 
        end 
      end 
    end 
  end)
  BonusRollFrame:RemoveTextures()
  STYLE:ApplyAlertStyle(BonusRollFrame)
  BonusRollFrame.PromptFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(SV.Media.bar.default)
  BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(0.1, 1, 0.1)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(LootHistoryStyle)