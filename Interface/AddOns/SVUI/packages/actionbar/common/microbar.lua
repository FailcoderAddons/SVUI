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
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVBar');
local NewFrame = CreateFrame;
local NewHook = hooksecurefunc;
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\MICROMENU]]
local ICON_DATA = {
  {"CharacterMicroButton",0,0.25,0,0.25},     -- MICRO-CHARACTER
  {"SpellbookMicroButton",0.25,0.5,0,0.25},   -- MICRO-SPELLBOOK
  {"TalentMicroButton",0.5,0.75,0,0.25},      -- MICRO-TALENTS
  {"AchievementMicroButton",0.75,1,0,0.25},   -- MICRO-ACHIEVEMENTS
  {"QuestLogMicroButton",0,0.25,0.25,0.5},    -- MICRO-QUESTS
  {"GuildMicroButton",0.25,0.5,0.25,0.5},     -- MICRO-GUILD
  {"PVPMicroButton",0.5,0.75,0.25,0.5},       -- MICRO-PVP
  {"LFDMicroButton",0.75,1,0.25,0.5},         -- MICRO-LFD
  {"EJMicroButton",0,0.25,0.5,0.75},          -- MICRO-ENCOUNTER
  {"StoreMicroButton",0.25,0.5,0.5,0.75},     -- MICRO-STORE
  {"CompanionsMicroButton",0.5,0.75,0.5,0.75},-- MICRO-COMPANION
  {"MainMenuMicroButton",0.75,1,0.5,0.75},    -- MICRO-SYSTEM
  {"HelpMicroButton",0,0.25,0.75,1},          -- MICRO-HELP
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function RefreshMicrobar()
  if not SVUI_MicroBar then return end;
  local lastParent = SVUI_MicroBar;
  local buttonSize =  MOD.db.Micro.buttonsize or 30;
  local spacing =  MOD.db.Micro.buttonspacing or 1;
  local barWidth = (buttonSize + spacing) * 13;
  SVUI_MicroBar_MOVE:Size(barWidth, buttonSize + 6)
  SVUI_MicroBar:SetAllPoints(SVUI_MicroBar_MOVE)
  for i=1,13 do
    local data = ICON_DATA[i]
    local button = _G[data[1]]
    button:ClearAllPoints()
    button:Size(buttonSize, buttonSize + 28)
    button._fade = MOD.db.Micro.mouseover
    if lastParent == SVUI_MicroBar then 
      button:SetPoint("BOTTOMLEFT",lastParent,"BOTTOMLEFT",1,1)
    else 
      button:SetPoint('LEFT',lastParent,'RIGHT',spacing,0)
    end;
    lastParent = button;
    button:Show()
  end;
end;

local SVUIMicroButton_SetNormal = function()
  local level = MainMenuMicroButton:GetFrameLevel()
  if(level > 0) then 
      MainMenuMicroButton:SetFrameLevel(level - 1)
  else 
      MainMenuMicroButton:SetFrameLevel(0)
  end
  MainMenuMicroButton:SetFrameStrata("BACKGROUND")
  MainMenuMicroButton.overlay:SetFrameLevel(level + 1)
  MainMenuMicroButton.overlay:SetFrameStrata("HIGH")
  MainMenuBarPerformanceBar:Hide()
  HelpMicroButton:Show()
end;

local SVUIMicroButtonsParent = function(self)
  if self ~= SVUI_MicroBar then 
    self = SVUI_MicroBar 
  end;
  for i=1,13 do
    local data = ICON_DATA[i] 
    _G[data[1]]:SetParent(SVUI_MicroBar)
  end 
end;

local MicroButton_OnEnter = function(self)
  if InCombatLockdown()then return end;
  self.overlay:SetPanelColor("highlight")
  self.overlay.icon:SetGradient("VERTICAL", 0.75, 0.75, 0.75, 1, 1, 1)
  if(self._fade) then
    SuperVillain:SecureFadeIn(SVUI_MicroBar,0.2,SVUI_MicroBar:GetAlpha(),1)
    SuperVillain:SecureFadeOut(SVUI_MicroBar.screenMarker,0.1,SVUI_MicroBar:GetAlpha(),0)
  end
end

local MicroButton_OnLeave = function(self)
  if InCombatLockdown()then return end;
  self.overlay:SetPanelColor("special")
  self.overlay.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  if(self._fade) then
    SuperVillain:SecureFadeOut(SVUI_MicroBar,1,SVUI_MicroBar:GetAlpha(),0)
    SuperVillain:SecureFadeIn(SVUI_MicroBar.screenMarker,5,SVUI_MicroBar:GetAlpha(),1)
  end
end
--[[ 
########################################################## 
PACKAGE PLUGIN
##########################################################
]]--
function MOD:UpdateMicroButtons()
  if(not MOD.db.Micro.mouseover) then
    SVUI_MicroBar:SetAlpha(1)
    SVUI_MicroBar.screenMarker:SetAlpha(0)
  else
    SVUI_MicroBar:SetAlpha(0)
    SVUI_MicroBar.screenMarker:SetAlpha(1)
  end
  GuildMicroButtonTabard:ClearAllPoints();
  GuildMicroButtonTabard:Hide();
  RefreshMicrobar()
end;

local MicroButton_OnUpdate = function()
  MOD:UpdateMicroButtons()
end;

local CreateMicroBar = function(self)
  local buttonSize = self.db.Micro.buttonsize or 30;
  local spacing =  self.db.Micro.buttonspacing or 1;
  local barWidth = (buttonSize + spacing) * 13;
  local microBar = NewFrame('Frame','SVUI_MicroBar',SuperVillain.UIParent)
  microBar:Size(barWidth,buttonSize + 6)
  microBar:SetFrameStrata("HIGH")
  microBar:SetFrameLevel(0)
  microBar:Point('TOP',SuperVillain.UIParent,'TOP',0,4)
  SuperVillain:AddToDisplayAudit(microBar)

  for i=1,13 do
    local data = ICON_DATA[i] 
  	local button = _G[data[1]]
  	button:SetParent(SVUI_MicroBar)
  	button:Size(buttonSize, buttonSize + 28)
  	button.Flash:SetTexture("")
  	if button.SetPushedTexture then 
  		button:SetPushedTexture("")
  	end;
  	if button.SetNormalTexture then 
  		button:SetNormalTexture("")
  	end;
  	if button.SetDisabledTexture then 
  		button:SetDisabledTexture("")
  	end;
    if button.SetHighlightTexture then 
      button:SetHighlightTexture("")
    end;
    button:Formula409()

  	local buttonMask = NewFrame("Frame",nil,button)
  	buttonMask:SetPoint("TOPLEFT",button,"TOPLEFT",0,-28)
  	buttonMask:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",0,0)
  	buttonMask:SetFramedButtonTemplate()
    buttonMask:SetPanelColor()
  	buttonMask.icon = buttonMask:CreateTexture(nil,"OVERLAY",nil,2)
  	buttonMask.icon:FillInner(buttonMask,2,2)
  	buttonMask.icon:SetTexture(ICON_FILE)
    buttonMask.icon:SetTexCoord(data[2],data[3],data[4],data[5])
  	buttonMask.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  	button.overlay = buttonMask;
    button._fade = self.db.Micro.mouseover
  	button:HookScript('OnEnter', MicroButton_OnEnter)
  	button:HookScript('OnLeave', MicroButton_OnLeave)
    button:Show()
  end;

  MicroButtonPortrait:ClearAllPoints()
  MicroButtonPortrait:Hide()
  MainMenuBarPerformanceBar:ClearAllPoints()
  MainMenuBarPerformanceBar:Hide()

  NewHook('MainMenuMicroButton_SetNormal', SVUIMicroButton_SetNormal)
  NewHook('UpdateMicroButtonsParent', SVUIMicroButtonsParent)
  NewHook('MoveMicroButtons', RefreshMicrobar)
  NewHook('UpdateMicroButtons', MicroButton_OnUpdate)

  SVUIMicroButtonsParent(microBar)
  SVUIMicroButton_SetNormal()

  SuperVillain:SetSVMovable(microBar, "SVUI_MicroBar_MOVE", L["Micro Bar"])

  RefreshMicrobar()

  microBar.screenMarker = NewFrame('Frame',nil,SuperVillain.UIParent)
  microBar.screenMarker:Point('TOP',SuperVillain.UIParent,'TOP',0,2)
  microBar.screenMarker:Size(20,20)
  microBar.screenMarker:SetFrameStrata("BACKGROUND")
  microBar.screenMarker:SetFrameLevel(4)
  microBar.screenMarker.icon = microBar.screenMarker:CreateTexture(nil,'OVERLAY')
  microBar.screenMarker.icon:SetAllPoints(microBar.screenMarker)
  microBar.screenMarker.icon:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\ARROW-DOWN")
  microBar.screenMarker.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)

  SVUI_MicroBar:SetAlpha(0)
end;

SuperVillain.Registry:Temp("SVBar", CreateMicroBar)