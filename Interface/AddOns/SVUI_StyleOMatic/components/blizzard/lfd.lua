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
HELPERS
##########################################################
]]--
local LFDFrameList = {
  "LFDQueueFrameRoleButtonHealer",
  "LFDQueueFrameRoleButtonDPS",
  "LFDQueueFrameRoleButtonLeader",
  "LFDQueueFrameRoleButtonTank",
  "RaidFinderQueueFrameRoleButtonHealer",
  "RaidFinderQueueFrameRoleButtonDPS",
  "RaidFinderQueueFrameRoleButtonLeader",
  "RaidFinderQueueFrameRoleButtonTank",
  "LFGInvitePopupRoleButtonTank",
  "LFGInvitePopupRoleButtonHealer",
  "LFGInvitePopupRoleButtonDPS",

};

local function StyleMoneyRewards(frameName)
  local frame = _G[frameName]
  local icon = _G[frameName .. "IconTexture"]
  if(not frame.Panel and icon) then
      local size = frame:GetHeight() - 6
      local texture = icon:GetTexture()
      frame:RemoveTextures()
      frame:SetStylePanel("!_Frame", "Inset")
      icon:SetTexture(texture)
      icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      icon:ClearAllPoints()
      icon:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
      icon:SetSize(size, size)
      if(not frame.IconSlot) then 
        frame.IconSlot = CreateFrame("Frame", nil, frame)
        frame.IconSlot:SetAllPointsOut(icon)
        frame.IconSlot:SetStylePanel("Icon")
        icon:SetParent(frame.IconSlot)
      end
  end
end

local Incentive_OnShow = function(button)
  local parent = button:GetParent()
  local check = parent.checkButton or parent.CheckButton
  ActionButton_ShowOverlayGlow(check)
end 

local Incentive_OnHide = function(button)
  local parent = button:GetParent()
  local check = parent.checkButton or parent.CheckButton
  ActionButton_HideOverlayGlow(check)
end 

local LFDQueueRandom_OnUpdate = function()
  LFDQueueFrame:RemoveTextures()
  for u = 1, LFD_MAX_REWARDS do 
    local t = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u]
    local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u.."IconTexture"]
    if t then
      if not t.restyled then 
        local x = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u.."ShortageBorder"]
        local y = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u.."Count"]
        local z = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u.."NameFrame"]
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetDrawLayer("OVERLAY")
        y:SetDrawLayer("OVERLAY")
        z:SetTexture()
        z:SetSize(118, 39)
        x:SetAlpha(0)
        t.border = CreateFrame("Frame", nil, t)
        t.border:SetStylePanel("!_Frame")
        t.border:SetAllPointsOut(icon)
        icon:SetParent(t.border)
        y:SetParent(t.border)
        t.restyled = true;
        for A = 1, 3 do 
          local B = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..u.."RoleIcon"..A]
          if B then
             B:SetParent(t.border)
          end 
        end 
      end 
    end 
  end 
end 

local ScenarioQueueRandom_OnUpdate = function()
  LFDQueueFrame:RemoveTextures()
  for u = 1, LFD_MAX_REWARDS do 
    local t = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..u]
    local icon = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..u.."IconTexture"]
    if t then
      if not t.restyled then 
        local x = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..u.."ShortageBorder"]
        local y = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..u.."Count"]
        local z = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..u.."NameFrame"]icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetDrawLayer("OVERLAY")
        y:SetDrawLayer("OVERLAY")
        z:SetTexture()
        z:SetSize(118, 39)
        x:SetAlpha(0)
        t.border = CreateFrame("Frame", nil, t)
        t.border:SetStylePanel("!_Frame")
        t.border:SetAllPointsOut(icon)
        icon:SetParent(t.border)
        y:SetParent(t.border)
        t.restyled = true 
      end 
    end 
  end
  StyleMoneyRewards("LFDQueueFrameRandomScrollFrameChildFrameMoneyReward")
  StyleMoneyRewards("RaidFinderQueueFrameScrollFrameChildFrameMoneyReward")
  StyleMoneyRewards("ScenarioQueueFrameRandomScrollFrameChildFrameMoneyReward")
end
--[[ 
########################################################## 
LFD PLUGINR
##########################################################
]]--
local function LFDFrameStyle()
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.lfg ~= true then return end
  
  PLUGIN:ApplyWindowStyle(PVEFrame, true)
  PLUGIN:ApplyWindowStyle(LFGDungeonReadyDialog, true)
  
  PVEFrameLeftInset:RemoveTextures()
  RaidFinderQueueFrame:RemoveTextures(true)
  PVEFrameBg:Hide()
  PVEFrameTitleBg:Hide()
  PVEFramePortrait:Hide()
  PVEFramePortraitFrame:Hide()
  PVEFrameTopRightCorner:Hide()
  PVEFrameTopBorder:Hide()
  PVEFrameLeftInsetBg:Hide()
  PVEFrame.shadows:Hide()

  LFDQueueFramePartyBackfillBackfillButton:SetStylePanel("Button")
  LFDQueueFramePartyBackfillNoBackfillButton:SetStylePanel("Button")
  LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton:SetStylePanel("Button")
  ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton:SetStylePanel("Button")

  PLUGIN:ApplyScrollFrameStyle(ScenarioQueueFrameRandomScrollFrameScrollBar)

  GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
  GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
  GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
  GroupFinderFrameGroupButton4.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\SVUI-ICON")

  LFGDungeonReadyDialogBackground:Die()
  LFGDungeonReadyDialogEnterDungeonButton:SetStylePanel("Button")
  LFGDungeonReadyDialogLeaveQueueButton:SetStylePanel("Button")
  PLUGIN:ApplyCloseButtonStyle(LFGDungeonReadyDialogCloseButton)

  LFGDungeonReadyStatus:RemoveTextures()
  LFGDungeonReadyStatus:SetStylePanel("Frame", "Pattern", true, 2, 4, 4)
  LFGDungeonReadyDialogRoleIconTexture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
  LFGDungeonReadyDialogRoleIconTexture:SetAlpha(0.5)

  -- hooksecurefunc("LFGDungeonReadyPopup_Update", function()
  --   local proposalExists, id, typeID, subtypeID, name, texture, role, hasResponded, totalEncounters, completedEncounters, numMembers, isLeader, isHoliday, proposalCategory = GetLFGProposal();
  --   if LFGDungeonReadyDialogRoleIcon:IsShown() then
  --     if(role == "DAMAGER") then 
  --       LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
  --     elseif(role == "TANK") then 
  --       LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
  --     elseif(role == "HEALER") then 
  --       LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
  --     end 
  --   end 
  -- end)

  LFDQueueFrameRoleButtonTankIncentiveIcon:SetAlpha(0)
  LFDQueueFrameRoleButtonHealerIncentiveIcon:SetAlpha(0)
  LFDQueueFrameRoleButtonDPSIncentiveIcon:SetAlpha(0)
  LFDQueueFrameRoleButtonTankIncentiveIcon:HookScript("OnShow", Incentive_OnShow)
  LFDQueueFrameRoleButtonHealerIncentiveIcon:HookScript("OnShow", Incentive_OnShow)
  LFDQueueFrameRoleButtonDPSIncentiveIcon:HookScript("OnShow", Incentive_OnShow)
  LFDQueueFrameRoleButtonTankIncentiveIcon:HookScript("OnHide", Incentive_OnHide)
  LFDQueueFrameRoleButtonHealerIncentiveIcon:HookScript("OnHide", Incentive_OnHide)
  LFDQueueFrameRoleButtonDPSIncentiveIcon:HookScript("OnHide", Incentive_OnHide)
  LFDQueueFrameRoleButtonTank.shortageBorder:Die()
  LFDQueueFrameRoleButtonDPS.shortageBorder:Die()
  LFDQueueFrameRoleButtonHealer.shortageBorder:Die()
  LFGDungeonReadyDialog.filigree:SetAlpha(0)
  LFGDungeonReadyDialog.bottomArt:SetAlpha(0)
  PLUGIN:ApplyCloseButtonStyle(LFGDungeonReadyStatusCloseButton)

  for _,name in pairs(LFDFrameList) do
    local frame = _G[name];
    if(frame) then
      frame:DisableDrawLayer("BACKGROUND")
      frame:DisableDrawLayer("OVERLAY")
    end
  end

  LFDQueueFrameRoleButtonLeader.leadIcon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
  LFDQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
  LFDQueueFrameRoleButtonLeader.leadIcon:SetPoint(LFDQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
  LFDQueueFrameRoleButtonLeader.leadIcon:SetSizeToScale(50)
  LFDQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)
  RaidFinderQueueFrameRoleButtonLeader.leadIcon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetPoint(RaidFinderQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetSizeToScale(50)
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)

  hooksecurefunc('LFG_DisableRoleButton', function(self)
    local check = self.checkButton or self.CheckButton
    if(check) then
      if(check:GetChecked()) then
         check:SetAlpha(1)
      else
         check:SetAlpha(0)
      end
    end
    if self.background then
       self.background:Show()
    end 
  end)

  hooksecurefunc('LFG_EnableRoleButton', function(self)
    local check = self.checkButton or self.CheckButton
    if(check) then
      check:SetAlpha(1)
    end
  end)

  hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(self)
    if self.background then
       self.background:Show()
       self.background:SetDesaturated(true)
    end 
  end)

  for i = 1, 4 do
    local button = GroupFinderFrame["groupButton"..i]
    if(button) then
      button.ring:Hide()
      button.bg:SetTexture(0,0,0,0)
      button.bg:SetAllPoints()
      button:SetStylePanel("Frame", 'Button')
      button:SetStylePanel("Button")
      button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      button.icon:SetDrawLayer("OVERLAY")
      button.icon:SetSizeToScale(40)
      button.icon:ClearAllPoints()
      button.icon:SetPoint("LEFT", 10, 0)
      button.border = CreateFrame("Frame", nil, button)
      button.border:SetStylePanel("!_Frame", 'Default')
      button.border:SetAllPointsOut(button.icon)
      button.icon:SetParent(button.border)
    end
  end

  for u = 1, 3 do
     PLUGIN:ApplyTabStyle(_G['PVEFrameTab'..u])
  end

  PVEFrameTab1:SetPoint('BOTTOMLEFT', PVEFrame, 'BOTTOMLEFT', 19, -31)
  PLUGIN:ApplyCloseButtonStyle(PVEFrameCloseButton)
  LFDParentFrame:RemoveTextures()
  LFDQueueFrameFindGroupButton:RemoveTextures()
  LFDParentFrameInset:RemoveTextures()
  LFDQueueFrameSpecificListScrollFrame:RemoveTextures()
  LFDQueueFrameFindGroupButton:SetStylePanel("Button")
  hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", LFDQueueRandom_OnUpdate)
  
  PLUGIN:ApplyDropdownStyle(LFDQueueFrameTypeDropDown)

  RaidFinderFrame:RemoveTextures()
  RaidFinderFrameBottomInset:RemoveTextures()
  RaidFinderFrameRoleInset:RemoveTextures()
  LFDQueueFrameRandomScrollFrameScrollBar:RemoveTextures()
  ScenarioQueueFrameSpecificScrollFrame:RemoveTextures()
  RaidFinderFrameBottomInsetBg:Hide()
  RaidFinderFrameBtnCornerRight:Hide()
  RaidFinderFrameButtonBottomBorder:Hide()
  PLUGIN:ApplyDropdownStyle(RaidFinderQueueFrameSelectionDropDown)
  RaidFinderFrameFindRaidButton:RemoveTextures()
  RaidFinderFrameFindRaidButton:SetStylePanel("Button")
  RaidFinderQueueFrame:RemoveTextures()

  for u = 1, LFD_MAX_REWARDS do 
    local t = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u]
    local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."IconTexture"]
    if t then
      if not t.restyled then 
        local x = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."ShortageBorder"]
        local y = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."Count"]
        local z = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."NameFrame"]
        t:RemoveTextures()
        icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        icon:SetDrawLayer("OVERLAY")
        y:SetDrawLayer("OVERLAY")
        z:SetTexture()
        z:SetSize(118, 39)
        x:SetAlpha(0)
        t.border = CreateFrame("Frame", nil, t)
        t.border:SetStylePanel("!_Frame")
        t.border:SetAllPointsOut(icon)
        icon:SetParent(t.border)
        y:SetParent(t.border)
        t.restyled = true 
      end 
    end 
  end

  StyleMoneyRewards("LFDQueueFrameRandomScrollFrameChildFrameMoneyReward")
  StyleMoneyRewards("RaidFinderQueueFrameScrollFrameChildFrameMoneyReward")
  StyleMoneyRewards("ScenarioQueueFrameRandomScrollFrameChildFrameMoneyReward")


  ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
  ScenarioFinderFrame.TopTileStreaks:Hide()
  ScenarioFinderFrameBtnCornerRight:Hide()
  ScenarioFinderFrameButtonBottomBorder:Hide()
  ScenarioQueueFrame.Bg:Hide()
  ScenarioFinderFrameInset:GetRegions():Hide()
  hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", ScenarioQueueRandom_OnUpdate)
  ScenarioQueueFrameFindGroupButton:RemoveTextures()
  ScenarioQueueFrameFindGroupButton:SetStylePanel("Button")
  PLUGIN:ApplyDropdownStyle(ScenarioQueueFrameTypeDropDown)
  LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
  RaidBrowserFrameBg:Hide()
  LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
  LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
  LFRBrowseFrameRoleInsetBg:Hide()

  for u = 1, 14 do 
    if u ~= 6 and u ~= 8 then
       select(u, RaidBrowserFrame:GetRegions()):Hide()
    end 
  end

  RaidBrowserFrame:SetStylePanel("Frame", 'Pattern')
  PLUGIN:ApplyCloseButtonStyle(RaidBrowserFrameCloseButton)
  LFRQueueFrameFindGroupButton:SetStylePanel("Button")
  LFRQueueFrameAcceptCommentButton:SetStylePanel("Button")
  PLUGIN:ApplyScrollFrameStyle(LFRQueueFrameCommentScrollFrameScrollBar)
  PLUGIN:ApplyScrollFrameStyle(LFDQueueFrameSpecificListScrollFrameScrollBar)

  RaidBrowserFrame:HookScript('OnShow', function()
    if not LFRQueueFrameSpecificListScrollFrameScrollBar.styled then
      PLUGIN:ApplyScrollFrameStyle(LFRQueueFrameSpecificListScrollFrameScrollBar)
      LFRBrowseFrame:RemoveTextures()
      for u = 1, 2 do 
        local C = _G['LFRParentFrameSideTab'..u]
        C:DisableDrawLayer('BACKGROUND')
        C:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
        C:GetNormalTexture():SetAllPointsIn()
        C.pushed = true;
        C:SetStylePanel("Frame", "Default")
        C.Panel:SetAllPoints()
        C:SetStylePanel("Frame")
        hooksecurefunc(C:GetHighlightTexture(), "SetTexture", function(o, D)
          if D ~= nil then
             o:SetTexture(0,0,0,0)
          end 
        end)
      end 
      for u = 1, 7 do 
        local C = _G['LFRBrowseFrameColumnHeader'..u]
        C:DisableDrawLayer('BACKGROUND')
      end 
      PLUGIN:ApplyDropdownStyle(LFRBrowseFrameRaidDropDown)
      LFRBrowseFrameRefreshButton:SetStylePanel("Button")
      LFRBrowseFrameInviteButton:SetStylePanel("Button")
      LFRBrowseFrameSendMessageButton:SetStylePanel("Button")
      LFRQueueFrameSpecificListScrollFrameScrollBar.styled = true 
    end 
  end)

  LFGInvitePopup:RemoveTextures()
  LFGInvitePopup:SetStylePanel("Frame", "Pattern", true, 2, 4, 4)
  LFGInvitePopupAcceptButton:SetStylePanel("Button")
  LFGInvitePopupDeclineButton:SetStylePanel("Button")

  _G[LFDQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetStylePanel("Button")
  _G[LFDQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetStylePanel("Button")
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetStylePanel("Button")
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetStylePanel("Button")
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetStylePanel("Button")
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetStylePanel("Button")
  
  PLUGIN:ApplyScrollFrameStyle(LFDQueueFrameRandomScrollFrameScrollBar)
  PLUGIN:ApplyScrollFrameStyle(ScenarioQueueFrameSpecificScrollFrameScrollBar)
  LFDQueueFrameRandomScrollFrame:SetStylePanel("Frame", 'Transparent')
  ScenarioQueueFrameRandomScrollFrame:SetStylePanel("Frame", 'Transparent')
  RaidFinderQueueFrameScrollFrame:SetStylePanel("Frame", 'Transparent')

  -- for u = 1, NUM_LFD_CHOICE_BUTTONS do
  --   local box = _G["LFDQueueFrameSpecificListButton"..u.."EnableButton"]
  --   if(box and (not box.Panel)) then
  --     box:RemoveTextures()
  --     box:SetStylePanel("Checkbox", true, -2, -3)
  --     box:SetFrameLevel(box:GetFrameLevel() + 50)
  --   end
  -- end

  -- for u = 1, NUM_LFR_CHOICE_BUTTONS do 
  --   local box = _G["LFRQueueFrameSpecificListButton"..u.."EnableButton"]
  --   if(box and (not box.Panel)) then
  --     box:RemoveTextures()
  --     box:SetStylePanel("Checkbox", true, -2, -3)
  --     box:SetFrameLevel(box:GetFrameLevel() + 50)
  --   end
  -- end

  LFGListFrame.CategorySelection:RemoveTextures()
  LFGListFrame.CategorySelection.StartGroupButton:RemoveTextures()
  LFGListFrame.CategorySelection.StartGroupButton:SetStylePanel("Button")
  LFGListFrame.CategorySelection.FindGroupButton:RemoveTextures()
  LFGListFrame.CategorySelection.FindGroupButton:SetStylePanel("Button")
end
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(LFDFrameStyle)