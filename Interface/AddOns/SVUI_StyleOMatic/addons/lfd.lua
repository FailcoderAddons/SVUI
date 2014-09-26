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
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
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
  "LFGInvitePopupRoleButtonDPS"  
};

local Incentive_OnShow = function(button)
  ActionButton_ShowOverlayGlow(button:GetParent().checkButton)
end 

local Incentive_OnHide = function(button)
  ActionButton_HideOverlayGlow(button:GetParent().checkButton)
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
        t.border:SetFixedPanelTemplate()
        t.border:WrapOuter(icon)
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
        t.border:SetFixedPanelTemplate()
        t.border:WrapOuter(icon)
        icon:SetParent(t.border)
        y:SetParent(t.border)
        t.restyled = true 
      end 
    end 
  end 
end 
--[[ 
########################################################## 
LFD STYLER
##########################################################
]]--
local function LFDFrameStyle()
  if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.lfg ~= true then return end
  
  STYLE:ApplyWindowStyle(PVEFrame, true)
  
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

  LFDQueueFramePartyBackfillBackfillButton:SetButtonTemplate()
  LFDQueueFramePartyBackfillNoBackfillButton:SetButtonTemplate()
  LFDQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton:SetButtonTemplate()
  ScenarioQueueFrameRandomScrollFrameChildFrameBonusRepFrame.ChooseButton:SetButtonTemplate()

  STYLE:ApplyScrollFrameStyle(ScenarioQueueFrameRandomScrollFrameScrollBar)

  GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
  GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
  GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
  GroupFinderFrameGroupButton4.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\SVUI-EMBLEM")

  LFGDungeonReadyDialogBackground:Die()
  LFGDungeonReadyDialogEnterDungeonButton:SetButtonTemplate()
  LFGDungeonReadyDialogLeaveQueueButton:SetButtonTemplate()
  STYLE:ApplyCloseButtonStyle(LFGDungeonReadyDialogCloseButton)

  LFGDungeonReadyDialog:RemoveTextures()
  LFGDungeonReadyDialog:SetPanelTemplate("Pattern", true, 2, 4, 4)
  LFGDungeonReadyStatus:RemoveTextures()
  LFGDungeonReadyStatus:SetPanelTemplate("Pattern", true, 2, 4, 4)
  LFGDungeonReadyDialogRoleIconTexture:SetTexture("Interface\\LFGFrame\\UI-LFG-ICONS-ROLEBACKGROUNDS")
  LFGDungeonReadyDialogRoleIconTexture:SetAlpha(0.5)

  hooksecurefunc("LFGDungeonReadyPopup_Update", function()
    local b, c, d, e, f, g, h, i, j, k, l, m = GetLFGProposal()
    if LFGDungeonReadyDialogRoleIcon:IsShown() then
      if h == "DAMAGER" then 
        LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonDPS.background:GetTexCoord())
      elseif h == "TANK" then 
        LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonTank.background:GetTexCoord())
      elseif h == "HEALER" then 
        LFGDungeonReadyDialogRoleIconTexture:SetTexCoord(LFDQueueFrameRoleButtonHealer.background:GetTexCoord())
      end 
    end 
  end)

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
  STYLE:ApplyCloseButtonStyle(LFGDungeonReadyStatusCloseButton)

  for _,name in pairs(LFDFrameList) do
    local frame = _G[name];
    if frame then
      frame.checkButton:RemoveTextures()
      frame.checkButton:SetCheckboxTemplate(true, -4, -4)
      frame.checkButton:SetFrameLevel(frame.checkButton:GetFrameLevel() + 50)
      frame:DisableDrawLayer("BACKGROUND")
      frame:DisableDrawLayer("OVERLAY")
    end
  end

  LFDQueueFrameRoleButtonLeader.leadIcon = LFDQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
  LFDQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
  LFDQueueFrameRoleButtonLeader.leadIcon:SetPoint(LFDQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
  LFDQueueFrameRoleButtonLeader.leadIcon:Size(50)
  LFDQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)
  RaidFinderQueueFrameRoleButtonLeader.leadIcon = RaidFinderQueueFrameRoleButtonLeader:CreateTexture(nil, 'BACKGROUND')
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetTexture([[Interface\GroupFrame\UI-Group-LeaderIcon]])
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetPoint(RaidFinderQueueFrameRoleButtonLeader:GetNormalTexture():GetPoint())
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:Size(50)
  RaidFinderQueueFrameRoleButtonLeader.leadIcon:SetAlpha(0.4)

  hooksecurefunc('LFG_DisableRoleButton', function(self)
    if self.checkButton:GetChecked() then
       self.checkButton:SetAlpha(1)
    else
       self.checkButton:SetAlpha(0)
    end 
    if self.background then
       self.background:Show()
    end 
  end)

  hooksecurefunc('LFG_EnableRoleButton', function(self)
    self.checkButton:SetAlpha(1)
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
      button:SetFixedPanelTemplate('Button')
      button:SetButtonTemplate()
      button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
      button.icon:SetPoint("LEFT", button, "LEFT")
      button.icon:SetDrawLayer("OVERLAY")
      button.icon:Size(40)
      button.icon:ClearAllPoints()
      button.icon:SetPoint("LEFT", 10, 0)
      button.border = CreateFrame("Frame", nil, button)
      button.border:SetFixedPanelTemplate('Default')
      button.border:WrapOuter(button.icon)
      button.icon:SetParent(button.border)
    end
  end

  for u = 1, 2 do
     STYLE:ApplyTabStyle(_G['PVEFrameTab'..u])
  end

  PVEFrameTab1:SetPoint('BOTTOMLEFT', PVEFrame, 'BOTTOMLEFT', 19, -31)
  STYLE:ApplyCloseButtonStyle(PVEFrameCloseButton)
  LFDParentFrame:RemoveTextures()
  LFDQueueFrameFindGroupButton:RemoveTextures()
  LFDParentFrameInset:RemoveTextures()
  LFDQueueFrameSpecificListScrollFrame:RemoveTextures()
  LFDQueueFrameFindGroupButton:SetButtonTemplate()
  hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", LFDQueueRandom_OnUpdate)

  hooksecurefunc("ScenarioQueueFrameSpecific_Update", function()
    for i = 1, NUM_SCENARIO_CHOICE_BUTTONS do 
      local box = _G["ScenarioQueueFrameSpecificButton"..i.."EnableButton"]
      if(box and (not box.Panel)) then
        box:RemoveTextures()
        box:SetCheckboxTemplate(true, -2, -3)
      end
    end 
  end)
  
  STYLE:ApplyDropdownStyle(LFDQueueFrameTypeDropDown)

  RaidFinderFrame:RemoveTextures()
  RaidFinderFrameBottomInset:RemoveTextures()
  RaidFinderFrameRoleInset:RemoveTextures()
  LFDQueueFrameRandomScrollFrameScrollBar:RemoveTextures()
  ScenarioQueueFrameSpecificScrollFrame:RemoveTextures()
  RaidFinderFrameBottomInsetBg:Hide()
  RaidFinderFrameBtnCornerRight:Hide()
  RaidFinderFrameButtonBottomBorder:Hide()
  STYLE:ApplyDropdownStyle(RaidFinderQueueFrameSelectionDropDown)
  RaidFinderFrameFindRaidButton:RemoveTextures()
  RaidFinderFrameFindRaidButton:SetButtonTemplate()
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
        t.border:SetFixedPanelTemplate()
        t.border:WrapOuter(icon)
        icon:SetParent(t.border)
        y:SetParent(t.border)
        t.restyled = true 
      end 
    end 
  end

  ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
  ScenarioFinderFrame.TopTileStreaks:Hide()
  ScenarioFinderFrameBtnCornerRight:Hide()
  ScenarioFinderFrameButtonBottomBorder:Hide()
  ScenarioQueueFrame.Bg:Hide()
  ScenarioFinderFrameInset:GetRegions():Hide()
  hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", ScenarioQueueRandom_OnUpdate)
  ScenarioQueueFrameFindGroupButton:RemoveTextures()
  ScenarioQueueFrameFindGroupButton:SetButtonTemplate()
  STYLE:ApplyDropdownStyle(ScenarioQueueFrameTypeDropDown)
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

  RaidBrowserFrame:SetPanelTemplate('Pattern')
  STYLE:ApplyCloseButtonStyle(RaidBrowserFrameCloseButton)
  LFRQueueFrameFindGroupButton:SetButtonTemplate()
  LFRQueueFrameAcceptCommentButton:SetButtonTemplate()
  STYLE:ApplyScrollFrameStyle(LFRQueueFrameCommentScrollFrameScrollBar)
  STYLE:ApplyScrollFrameStyle(LFDQueueFrameSpecificListScrollFrameScrollBar)

  RaidBrowserFrame:HookScript('OnShow', function()
    if not LFRQueueFrameSpecificListScrollFrameScrollBar.styled then
      STYLE:ApplyScrollFrameStyle(LFRQueueFrameSpecificListScrollFrameScrollBar)
      LFRBrowseFrame:RemoveTextures()
      for u = 1, 2 do 
        local C = _G['LFRParentFrameSideTab'..u]
        C:DisableDrawLayer('BACKGROUND')
        C:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
        C:GetNormalTexture():FillInner()
        C.pushed = true;
        C:SetPanelTemplate("Default")
        C.Panel:SetAllPoints()
        C:SetPanelTemplate()
        hooksecurefunc(C:GetHighlightTexture(), "SetTexture", function(o, D)
          if D ~= nil then
             o:SetTexture(0,0,0,0)
          end 
        end)
        hooksecurefunc(C:GetCheckedTexture(), "SetTexture", function(o, D)
          if D ~= nil then
             o:SetTexture(0,0,0,0)
          end 
        end)
      end 
      for u = 1, 7 do 
        local C = _G['LFRBrowseFrameColumnHeader'..u]
        C:DisableDrawLayer('BACKGROUND')
      end 
      STYLE:ApplyDropdownStyle(LFRBrowseFrameRaidDropDown)
      LFRBrowseFrameRefreshButton:SetButtonTemplate()
      LFRBrowseFrameInviteButton:SetButtonTemplate()
      LFRBrowseFrameSendMessageButton:SetButtonTemplate()
      LFRQueueFrameSpecificListScrollFrameScrollBar.styled = true 
    end 
  end)

  LFGInvitePopup:RemoveTextures()
  LFGInvitePopup:SetPanelTemplate("Pattern", true, 2, 4, 4)
  LFGInvitePopupAcceptButton:SetButtonTemplate()
  LFGInvitePopupDeclineButton:SetButtonTemplate()

  _G[LFDQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[LFDQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  
  STYLE:ApplyScrollFrameStyle(LFDQueueFrameRandomScrollFrameScrollBar)
  STYLE:ApplyScrollFrameStyle(ScenarioQueueFrameSpecificScrollFrameScrollBar)
  LFDQueueFrameRandomScrollFrame:SetBasicPanel()
  ScenarioQueueFrameRandomScrollFrame:SetBasicPanel()
  RaidFinderQueueFrameScrollFrame:SetBasicPanel()

  for u = 1, NUM_LFD_CHOICE_BUTTONS do
    local box = _G["LFDQueueFrameSpecificListButton"..u.."EnableButton"]
    if(box and (not box.Panel)) then
      box:RemoveTextures()
      box:SetCheckboxTemplate(true, -2, -3)
      box:SetFrameLevel(box:GetFrameLevel() + 50)
    end
  end

  for u = 1, NUM_LFR_CHOICE_BUTTONS do 
    local box = _G["LFRQueueFrameSpecificListButton"..u.."EnableButton"]
    if(box and (not box.Panel)) then
      box:RemoveTextures()
      box:SetCheckboxTemplate(true, -2, -3)
      box:SetFrameLevel(box:GetFrameLevel() + 50)
    end
  end
end
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(LFDFrameStyle)