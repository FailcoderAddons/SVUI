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
local MissingLootFrame_OnShow = function()
  local N = GetNumMissingLootItems()
  for u = 1, N do 
    local O = _G["MissingLootFrameItem"..u]
    local icon = O.icon;
    MOD:ApplyLinkButtonStyle(O, true)
    local g, f, y, P = GetMissingLootItemInfo(u)
    local color = GetItemQualityColor(P) or 0,0,0,1
    icon:SetTexture(g)
    M:SetBackdropBorderColor(color)
  end;
  local Q = ceil(N/2)
  MissingLootFrame:SetHeight(Q * 43 + 38 + MissingLootFrameLabel:GetHeight())
end;

local LootHistoryFrame_OnUpdate = function(o)
  local N = C_LootHistory.GetNumItems()
  for u = 1, N do   
    local M = LootHistoryFrame.itemFrames[u]
    if not M.isStyled then 
      local Icon = M.Icon:GetTexture()
      M:Formula409()
      M.Icon:SetTexture(Icon)
      M.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      M:SetFixedPanelTemplate("Button")
      M.Panel:WrapOuter(M.Icon)
      M.Icon:SetParent(M.Panel)
      M.isStyled = true 
    end 
  end 
end;
--[[ 
########################################################## 
LOOTHISTORY STYLER
##########################################################
]]--
local function LootHistoryStyle()
  LootHistoryFrame:SetFrameStrata('HIGH')
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.loot ~= true then return end;
  local M = MissingLootFrame;M:Formula409()
  M:SetPanelTemplate("Pattern")
  MOD:ApplyCloseButtonStyle(MissingLootFramePassButton)
  hooksecurefunc("MissingLootFrame_Show", MissingLootFrame_OnShow)
  LootHistoryFrame:Formula409()
  MOD:ApplyCloseButtonStyle(LootHistoryFrame.CloseButton)
  LootHistoryFrame:Formula409()
  LootHistoryFrame:SetFixedPanelTemplate('Transparent')
  MOD:ApplyCloseButtonStyle(LootHistoryFrame.ResizeButton)
  LootHistoryFrame.ResizeButton:SetFixedPanelTemplate()
  LootHistoryFrame.ResizeButton:Width(LootHistoryFrame:GetWidth())
  LootHistoryFrame.ResizeButton:Height(19)
  LootHistoryFrame.ResizeButton:ClearAllPoints()
  LootHistoryFrame.ResizeButton:Point("TOP", LootHistoryFrame, "BOTTOM", 0, -2)
  LootHistoryFrameScrollFrame:Formula409()
  MOD:ApplyScrollStyle(LootHistoryFrameScrollFrameScrollBar)
  hooksecurefunc("LootHistoryFrame_FullUpdate", LootHistoryFrame_OnUpdate)
  MasterLooterFrame:Formula409()
  MasterLooterFrame:SetFixedPanelTemplate()
  MasterLooterFrame:SetFrameStrata('FULLSCREEN_DIALOG')
  hooksecurefunc("MasterLooterFrame_Show", function()
    local J = MasterLooterFrame.Item;
    if J then 
      local u = J.Icon;
      local icon = u:GetTexture()
      local S = ITEM_QUALITY_COLORS[LootFrame.selectedQuality]
      J:Formula409()
      u:SetTexture(icon)
      u:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      J:SetPanelTemplate("Pattern")
      J.Panel:WrapOuter(u)
      J.Panel:SetBackdropBorderColor(S.r, S.g, S.b)
    end;
    for u = 1, MasterLooterFrame:GetNumChildren()do 
      local T = select(u, MasterLooterFrame:GetChildren())
      if T and not T.isStyled and not T:GetName() then
        if T:GetObjectType() == "Button" then 
          if T:GetPushedTexture() then
            MOD:ApplyCloseButtonStyle(T)
          else
            T:SetFixedPanelTemplate()
            T:SetButtonTemplate()
          end;
          T.isStyled = true 
        end 
      end 
    end 
  end)
  BonusRollFrame:Formula409()
  MOD:ApplyAlertStyle(BonusRollFrame)
  BonusRollFrame.PromptFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
  BonusRollFrame.PromptFrame.IconBackdrop = CreateFrame("Frame", nil, BonusRollFrame.PromptFrame)
  BonusRollFrame.PromptFrame.IconBackdrop:SetFrameLevel(BonusRollFrame.PromptFrame.IconBackdrop:GetFrameLevel()-1)
  BonusRollFrame.PromptFrame.IconBackdrop:WrapOuter(BonusRollFrame.PromptFrame.Icon)
  BonusRollFrame.PromptFrame.IconBackdrop:SetFixedPanelTemplate()
  BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(SuperVillain.Media.bar.default)
  BonusRollFrame.PromptFrame.Timer.Bar:SetVertexColor(0.1, 1, 0.1)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(LootHistoryStyle)