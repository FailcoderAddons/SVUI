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
local MOD = SuperVillain.Registry:Expose("SVStyle");
--[[ 
########################################################## 
LOSSOFCONTROL STYLER
##########################################################
]]--
local function LossOfControlStyle()
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.losscontrol ~= true then return end;
  local IconBackdrop = CreateFrame("Frame", nil, LossOfControlFrame)
  IconBackdrop:WrapOuter(LossOfControlFrame.Icon)
  IconBackdrop:SetFrameLevel(LossOfControlFrame:GetFrameLevel()-1)
  IconBackdrop:SetPanelTemplate("Slot")
  LossOfControlFrame.Icon:SetTexCoord(.1, .9, .1, .9)
  LossOfControlFrame:Formula409()
  LossOfControlFrame.AbilityName:ClearAllPoints()
  LossOfControlFrame:Size(LossOfControlFrame.Icon:GetWidth()+50)
  --local bg = CreateFrame("Frame", nil, LossOfControlFrame)

  local font = SuperVillain.Media.font.default;
  hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(o, ...)
    o.Icon:ClearAllPoints()
    o.Icon:SetPoint("CENTER", o, "CENTER", 0, 0)
    o.AbilityName:ClearAllPoints()
    o.AbilityName:SetPoint("BOTTOM", o, 0, -28)
    o.AbilityName.scrollTime = nil;
    o.AbilityName:SetFontTemplate(font, 20, 'OUTLINE')
    o.TimeLeft.NumberText:ClearAllPoints()
    o.TimeLeft.NumberText:SetPoint("BOTTOM", o, 4, -58)
    o.TimeLeft.NumberText.scrollTime = nil;
    o.TimeLeft.NumberText:SetFontTemplate(font, 20, 'OUTLINE')
    o.TimeLeft.SecondsText:ClearAllPoints()
    o.TimeLeft.SecondsText:SetPoint("BOTTOM", o, 0, -80)
    o.TimeLeft.SecondsText.scrollTime = nil;
    o.TimeLeft.SecondsText:SetFontTemplate(font, 20, 'OUTLINE')
    if o.Anim:IsPlaying() then
       o.Anim:Stop()
    end 
  end)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(LossOfControlStyle)