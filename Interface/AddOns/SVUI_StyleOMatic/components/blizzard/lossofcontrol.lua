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
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
LOSSOFCONTROL PLUGINR
##########################################################
]]--
local _hook_LossOfControl = function(self, ...)
  self.Icon:ClearAllPoints()
  self.Icon:SetPoint("CENTER", self, "CENTER", 0, 0)
  self.AbilityName:ClearAllPoints()
  self.AbilityName:SetPoint("BOTTOM", self, 0, -28)
  self.AbilityName.scrollTime = nil;
  self.AbilityName:SetFont(SV.Media.font.dialog, 20, 'OUTLINE')
  self.TimeLeft.NumberText:ClearAllPoints()
  self.TimeLeft.NumberText:SetPoint("BOTTOM", self, 4, -58)
  self.TimeLeft.NumberText.scrollTime = nil;
  self.TimeLeft.NumberText:SetFont(SV.Media.font.numbers, 20, 'OUTLINE')
  self.TimeLeft.SecondsText:ClearAllPoints()
  self.TimeLeft.SecondsText:SetPoint("BOTTOM", self, 0, -80)
  self.TimeLeft.SecondsText.scrollTime = nil;
  self.TimeLeft.SecondsText:SetFont(SV.Media.font.default, 20, 'OUTLINE')
  if self.Anim:IsPlaying() then
     self.Anim:Stop()
  end 
end

local function LossOfControlStyle()
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.losscontrol ~= true then return end 
  local IconBackdrop = CreateFrame("Frame", nil, LossOfControlFrame)
  IconBackdrop:SetAllPointsOut(LossOfControlFrame.Icon)
  IconBackdrop:SetFrameLevel(LossOfControlFrame:GetFrameLevel()-1)
  IconBackdrop:SetStylePanel("Frame", "Slot")
  LossOfControlFrame.Icon:SetTexCoord(.1, .9, .1, .9)
  LossOfControlFrame:RemoveTextures()
  LossOfControlFrame.AbilityName:ClearAllPoints()
  LossOfControlFrame:SetSizeToScale(LossOfControlFrame.Icon:GetWidth() + 50)
  --local bg = CreateFrame("Frame", nil, LossOfControlFrame)
  hooksecurefunc("LossOfControlFrame_SetUpDisplay", _hook_LossOfControl)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(LossOfControlStyle)