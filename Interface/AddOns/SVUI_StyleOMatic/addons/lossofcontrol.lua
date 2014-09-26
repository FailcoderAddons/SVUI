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
LOSSOFCONTROL STYLER
##########################################################
]]--
local _hook_LossOfControl = function(self, ...)
  self.Icon:ClearAllPoints()
  self.Icon:SetPoint("CENTER", self, "CENTER", 0, 0)
  self.AbilityName:ClearAllPoints()
  self.AbilityName:SetPoint("BOTTOM", self, 0, -28)
  self.AbilityName.scrollTime = nil;
  self.AbilityName:SetFont(SV.Media.font.names, 20, 'OUTLINE')
  self.TimeLeft.NumberText:ClearAllPoints()
  self.TimeLeft.NumberText:SetPoint("BOTTOM", self, 4, -58)
  self.TimeLeft.NumberText.scrollTime = nil;
  self.TimeLeft.NumberText:SetFont(SV.Media.font.numbers, 20, 'OUTLINE')
  self.TimeLeft.SecondsText:ClearAllPoints()
  self.TimeLeft.SecondsText:SetPoint("BOTTOM", self, 0, -80)
  self.TimeLeft.SecondsText.scrollTime = nil;
  self.TimeLeft.SecondsText:SetFont(SV.Media.font.roboto, 20, 'OUTLINE')
  if self.Anim:IsPlaying() then
     self.Anim:Stop()
  end 
end

local function LossOfControlStyle()
  if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.losscontrol ~= true then return end 
  local IconBackdrop = CreateFrame("Frame", nil, LossOfControlFrame)
  IconBackdrop:WrapOuter(LossOfControlFrame.Icon)
  IconBackdrop:SetFrameLevel(LossOfControlFrame:GetFrameLevel()-1)
  IconBackdrop:SetPanelTemplate("Slot")
  LossOfControlFrame.Icon:SetTexCoord(.1, .9, .1, .9)
  LossOfControlFrame:RemoveTextures()
  LossOfControlFrame.AbilityName:ClearAllPoints()
  LossOfControlFrame:Size(LossOfControlFrame.Icon:GetWidth() + 50)
  --local bg = CreateFrame("Frame", nil, LossOfControlFrame)
  hooksecurefunc("LossOfControlFrame_SetUpDisplay", _hook_LossOfControl)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(LossOfControlStyle)