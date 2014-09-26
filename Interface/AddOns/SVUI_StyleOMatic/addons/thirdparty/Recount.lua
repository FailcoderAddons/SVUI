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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
RECOUNT
##########################################################
]]--
local function NoColor(a)
  for p=1,a:GetNumRegions()do 
    local q=select(p,a:GetRegions())
    if q:GetObjectType()=='Texture'then 
      q:SetDesaturated(true)
      if q:GetTexture()=='Interface\\DialogFrame\\UI-DialogBox-Corner'then 
        q:SetTexture(0,0,0,0)
        q:Die()
      end 
    end 
  end 
end 

local function StyleRecount()
  assert(Recount, "AddOn Not Loaded")
  
  function Recount:ShowReset()
    STYLE:LoadAlert(L['Reset Recount?'], function(self) Recount:ResetData() self:GetParent():Hide() end)
  end

  local function StyleFrame(frame)
    STYLE:ApplyFrameStyle(frame,"Transparent")
    frame.Panel:SetAllPoints()
    frame.Panel:SetPoint('TOPLEFT', frame, 'TOPLEFT', 0, -6)
    frame.CloseButton:SetPoint('TOPRIGHT', frame, 'TOPRIGHT', -1, -9)
    frame:SetBackdrop(nil)

    frame.TitleBackground = CreateFrame('Frame', nil, frame)
    frame.TitleBackground:SetFixedPanelTemplate("Default")
    frame.TitleBackground:SetPanelColor("class")
    frame.TitleBackground:SetPoint('TOP', frame, 'TOP', 0, -8)
    frame.TitleBackground.timeLapse = 0
    frame.TitleBackground:SetScript('OnUpdate', function(self,elapsed)
      self.timeLapse = self.timeLapse + elapsed
      if(self.timeLapse < 0.2) then 
        return 
      else
        self.timeLapse = 0
      end
      self:SetSize(frame:GetWidth() - 4, 22) 
    end)
    frame.TitleBackground:SetFrameLevel(frame:GetFrameLevel())
    frame.Title:SetPoint('TOPLEFT', frame, 'TOPLEFT', 6, -12)
    NoColor(frame.CloseButton)
    if frame.ConfigButton then NoColor(frame.ConfigButton) end
    if frame.FileButton then NoColor(frame.FileButton) end
    if frame.LeftButton then NoColor(frame.LeftButton) end
    if frame.ResetButton then NoColor(frame.ResetButton) end
    if frame.RightButton then NoColor(frame.RightButton) end
    if frame.ReportButton then NoColor(frame.ReportButton) end
    if frame.SummaryButton then NoColor(frame.SummaryButton) end
  end

  local RecountFrames = {
    Recount.MainWindow,
    Recount.ConfigWindow,
    Recount.GraphWindow,
    Recount.DetailWindow,
  }

  for _, frame in pairs(RecountFrames) do
    if frame then 
      StyleFrame(frame) 
    end
  end

  STYLE:ApplyScrollFrameStyle(Recount_MainWindow_ScrollBarScrollBar)

  Recount_MainWindow:HookScript('OnShow', function(self) if InCombatLockdown() then return end if SV.CurrentlyDocked["Recount_MainWindow"] then SuperDockWindowRight:Show() end end)
  Recount.MainWindow.FileButton:HookScript('OnClick', function(self) if LibDropdownFrame0 then STYLE:ApplyFrameStyle(LibDropdownFrame0) end end)

  hooksecurefunc(Recount, 'ShowScrollbarElements', function(self, name) Recount_MainWindow_ScrollBarScrollBar:Show() end)
  hooksecurefunc(Recount, 'HideScrollbarElements', function(self, name) Recount_MainWindow_ScrollBarScrollBar:Hide() end)
  hooksecurefunc(Recount, 'CreateFrame', function(self, frame) StyleFrame(_G[frame]) end)

  hooksecurefunc(Recount, 'ShowReport', function(self)
    if Recount_ReportWindow.isStyled then return end
    Recount_ReportWindow.isStyled = true
    STYLE:ApplyFrameStyle(Recount_ReportWindow.Whisper)
    Recount_ReportWindow.ReportButton:SetButtonTemplate()
    STYLE:ApplyScrollBarStyle(Recount_ReportWindow_Slider)
    Recount_ReportWindow_Slider:GetThumbTexture():Size(6,6)
  end)
end
STYLE:SaveAddonStyle("Recount", StyleRecount)

function STYLE:Docklet_Recount(parent)
  if not Recount then return end 
  local n=Recount.MainWindow.Panel;
  if n and not n.Panel then 
    n:Show()
    n:SetFixedPanelTemplate('Transparent',true)
  end 
  Recount.db.profile.Locked=true;
  Recount.db.profile.Scaling=1;
  Recount.db.profile.ClampToScreen=true;
  Recount.db.profile.FrameStrata='2-LOW'
  Recount.MainWindow:ClearAllPoints()
  Recount.MainWindow:SetAllPoints(parent)
  Recount:SetStrataAndClamp()
  Recount:LockWindows(true)
  Recount:ResizeMainWindow()
  Recount_MainWindow_ScrollBar:Hide()
end 