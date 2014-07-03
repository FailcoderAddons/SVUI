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
end;

local Incentive_OnHide = function(button)
  ActionButton_HideOverlayGlow(button:GetParent().checkButton)
end;

local LFDQueueRandom_OnUpdate = function()
  LFDQueueFrame:Formula409()
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
end;

local ScenarioQueueRandom_OnUpdate = function()
  LFDQueueFrame:Formula409()
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
end;
--[[ 
########################################################## 
LFD STYLER
##########################################################
]]--
local function LFDFrameStyle()
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.lfg ~= true then return end;
  PVEFrame:Formula409()
  PVEFrame:SetPanelTemplate("Action")
  PVEFrameLeftInset:Formula409()
  RaidFinderQueueFrame:Formula409(true)
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
  MOD:ApplyScrollStyle(ScenarioQueueFrameRandomScrollFrameScrollBar)
  GroupFinderFrameGroupButton1.icon:SetTexture("Interface\\Icons\\INV_Helmet_08")
  GroupFinderFrameGroupButton2.icon:SetTexture("Interface\\Icons\\inv_helmet_06")
  GroupFinderFrameGroupButton3.icon:SetTexture("Interface\\Icons\\Icon_Scenarios")
  GroupFinderFrameGroupButton4.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\SVUI-EMBLEM")
  LFGDungeonReadyDialogBackground:MUNG()
  LFGDungeonReadyDialogEnterDungeonButton:SetButtonTemplate()
  LFGDungeonReadyDialogLeaveQueueButton:SetButtonTemplate()
  MOD:ApplyCloseButtonStyle(LFGDungeonReadyDialogCloseButton)
  LFGDungeonReadyDialog:Formula409()
  LFGDungeonReadyDialog:SetPanelTemplate("Pattern", true, 2, 4, 4)
  LFGDungeonReadyStatus:Formula409()
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
  LFDQueueFrameRoleButtonTank.shortageBorder:MUNG()
  LFDQueueFrameRoleButtonDPS.shortageBorder:MUNG()
  LFDQueueFrameRoleButtonHealer.shortageBorder:MUNG()
  LFGDungeonReadyDialog.filigree:SetAlpha(0)
  LFGDungeonReadyDialog.bottomArt:SetAlpha(0)
  MOD:ApplyCloseButtonStyle(LFGDungeonReadyStatusCloseButton)
  for _,name in pairs(LFDFrameList) do
    local frame = _G[name];
    if frame then
      frame.checkButton:SetCheckboxTemplate(true)
      frame:DisableDrawLayer("BACKGROUND")
      frame:DisableDrawLayer("OVERLAY")
      frame.checkButton:SetFrameLevel(frame.checkButton:GetFrameLevel() + 50)
    end
  end;
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
  hooksecurefunc('LFG_DisableRoleButton', function(t)
    if t.checkButton:GetChecked() then
       t.checkButton:SetAlpha(1)
    else
       t.checkButton:SetAlpha(0)
    end;
    if t.background then
       t.background:Show()
    end 
  end)
  hooksecurefunc('LFG_EnableRoleButton', function(t)
    t.checkButton:SetAlpha(1)
  end)
  hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(o)
    if o.background then
       o.background:Show()o.background:SetDesaturated(true)
    end 
  end)
  for u = 1, 4 do 
    local v = GroupFinderFrame["groupButton"..u]
    v.ring:Hide()
    v.bg:SetTexture("")
    v.bg:SetAllPoints()
    v:SetFixedPanelTemplate('Button')
    v:SetButtonTemplate()
    v.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    v.icon:SetPoint("LEFT", v, "LEFT")
    v.icon:SetDrawLayer("OVERLAY")
    v.icon:Size(40)
    v.icon:ClearAllPoints()
    v.icon:SetPoint("LEFT", 10, 0)
    v.border = CreateFrame("Frame", nil, v)
    v.border:SetFixedPanelTemplate('Default')
    v.border:WrapOuter(v.icon)
    v.icon:SetParent(v.border)
  end;
  for u = 1, 2 do
     MOD:ApplyTabStyle(_G['PVEFrameTab'..u])
  end;
  PVEFrameTab1:SetPoint('BOTTOMLEFT', PVEFrame, 'BOTTOMLEFT', 19, -31)
  MOD:ApplyCloseButtonStyle(PVEFrameCloseButton)
  LFDParentFrame:Formula409()
  LFDQueueFrameFindGroupButton:Formula409()
  LFDParentFrameInset:Formula409()
  LFDQueueFrameFindGroupButton:SetButtonTemplate()
  hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", LFDQueueRandom_OnUpdate)
  for u = 1, NUM_LFD_CHOICE_BUTTONS do
     _G["LFDQueueFrameSpecificListButton"..u].enableButton:SetCheckboxTemplate(true)
  end;
  hooksecurefunc("ScenarioQueueFrameSpecific_Update", function()
    for u = 1, NUM_SCENARIO_CHOICE_BUTTONS do 
      local t = _G["ScenarioQueueFrameSpecificButton"..u]
      if t and not t.styled then
        t.enableButton:SetCheckboxTemplate(true)
        t.styled = true 
      end 
    end 
  end)
  for u = 1, NUM_LFR_CHOICE_BUTTONS do 
    local v = _G["LFRQueueFrameSpecificListButton"..u].enableButton;
    v:SetCheckboxTemplate(true)
  end;
  MOD:ApplyDropdownStyle(LFDQueueFrameTypeDropDown)
  FlexRaidFrameScrollFrame:Formula409()
  FlexRaidFrameBottomInset:Formula409()
  hooksecurefunc("FlexRaidFrame_Update", function()
    FlexRaidFrame.ScrollFrame.Background:SetTexture(nil)
  end)
  MOD:ApplyDropdownStyle(FlexRaidFrameSelectionDropDown)
  FlexRaidFrameStartRaidButton:SetButtonTemplate()
  RaidFinderFrame:Formula409()
  RaidFinderFrameBottomInset:Formula409()
  RaidFinderFrameRoleInset:Formula409()
  RaidFinderFrameBottomInsetBg:Hide()
  RaidFinderFrameBtnCornerRight:Hide()
  RaidFinderFrameButtonBottomBorder:Hide()
  MOD:ApplyDropdownStyle(RaidFinderQueueFrameSelectionDropDown)
  RaidFinderFrameFindRaidButton:Formula409()
  RaidFinderFrameFindRaidButton:SetButtonTemplate()
  RaidFinderQueueFrame:Formula409()
  for u = 1, LFD_MAX_REWARDS do 
    local t = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u]
    local icon = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."IconTexture"]
    if t then
      if not t.restyled then 
        local x = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."ShortageBorder"]
        local y = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."Count"]
        local z = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..u.."NameFrame"]
        t:Formula409()
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
  end;
  ScenarioFinderFrameInset:DisableDrawLayer("BORDER")
  ScenarioFinderFrame.TopTileStreaks:Hide()
  ScenarioFinderFrameBtnCornerRight:Hide()
  ScenarioFinderFrameButtonBottomBorder:Hide()
  ScenarioQueueFrame.Bg:Hide()
  ScenarioFinderFrameInset:GetRegions():Hide()
  hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", ScenarioQueueRandom_OnUpdate)
  ScenarioQueueFrameFindGroupButton:Formula409()
  ScenarioQueueFrameFindGroupButton:SetButtonTemplate()
  MOD:ApplyDropdownStyle(ScenarioQueueFrameTypeDropDown)
  LFRBrowseFrameRoleInset:DisableDrawLayer("BORDER")
  RaidBrowserFrameBg:Hide()
  LFRQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
  LFRQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
  LFRBrowseFrameRoleInsetBg:Hide()
  for u = 1, 14 do 
    if u ~= 6 and u ~= 8 then
       select(u, RaidBrowserFrame:GetRegions()):Hide()
    end 
  end;
  RaidBrowserFrame:SetPanelTemplate('Pattern')
  MOD:ApplyCloseButtonStyle(RaidBrowserFrameCloseButton)
  LFRQueueFrameFindGroupButton:SetButtonTemplate()
  LFRQueueFrameAcceptCommentButton:SetButtonTemplate()
  MOD:ApplyScrollStyle(LFRQueueFrameCommentScrollFrameScrollBar)
  MOD:ApplyScrollStyle(LFDQueueFrameSpecificListScrollFrameScrollBar)
  LFDQueueFrameSpecificListScrollFrame:Formula409()
  RaidBrowserFrame:HookScript('OnShow', function()
    if not LFRQueueFrameSpecificListScrollFrameScrollBar.styled then
      MOD:ApplyScrollStyle(LFRQueueFrameSpecificListScrollFrameScrollBar)
      local list = {LFRQueueFrameRoleButtonHealer, LFRQueueFrameRoleButtonDPS, LFRQueueFrameRoleButtonTank}
      LFRBrowseFrame:Formula409()
      for _,s in pairs(list) do
        s.checkButton:SetCheckboxTemplate(true)
        s:GetChildren():SetFrameLevel(s:GetChildren():GetFrameLevel() + 1)
      end;
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
             o:SetTexture(nil)
          end 
        end)
        hooksecurefunc(C:GetCheckedTexture(), "SetTexture", function(o, D)
          if D ~= nil then
             o:SetTexture(nil)
          end 
        end)
      end;
      for u = 1, 7 do 
        local C = _G['LFRBrowseFrameColumnHeader'..u]
        C:DisableDrawLayer('BACKGROUND')
      end;
      MOD:ApplyDropdownStyle(LFRBrowseFrameRaidDropDown)
      LFRBrowseFrameRefreshButton:SetButtonTemplate()
      LFRBrowseFrameInviteButton:SetButtonTemplate()
      LFRBrowseFrameSendMessageButton:SetButtonTemplate()
      LFRQueueFrameSpecificListScrollFrameScrollBar.styled = true 
    end 
  end)
  LFGInvitePopup:Formula409()
  LFGInvitePopup:SetPanelTemplate("Pattern", true, 2, 4, 4)
  LFGInvitePopupAcceptButton:SetButtonTemplate()
  LFGInvitePopupDeclineButton:SetButtonTemplate()
  _G[LFDQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[LFDQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[RaidFinderQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."BackfillButton"]:SetButtonTemplate()
  _G[ScenarioQueueFrame.PartyBackfill:GetName().."NoBackfillButton"]:SetButtonTemplate()
  LFDQueueFrameRandomScrollFrameScrollBar:Formula409()
  ScenarioQueueFrameSpecificScrollFrame:Formula409()
  MOD:ApplyScrollStyle(LFDQueueFrameRandomScrollFrameScrollBar)
  MOD:ApplyScrollStyle(ScenarioQueueFrameSpecificScrollFrameScrollBar)
  LFDQueueFrameRandomScrollFrame:SetFixedPanelTemplate("Inset")
  ScenarioQueueFrameRandomScrollFrame:SetFixedPanelTemplate("Inset")
  RaidFinderQueueFrameScrollFrame:SetFixedPanelTemplate("Inset")
  FlexRaidFrameScrollFrame:SetFixedPanelTemplate("Inset")
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(LFDFrameStyle)