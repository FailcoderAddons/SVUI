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
CHALLENGES UI STYLER
##########################################################
]]--
local function ChallengesFrameStyle()
  if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.lfg ~= true then return end 
  ChallengesFrameInset:RemoveTextures()
  ChallengesFrameInsetBg:Hide()
  ChallengesFrameDetails.bg:Hide()
  ChallengesFrameLeaderboard:SetButtonTemplate()
  select(2, ChallengesFrameDetails:GetRegions()):Hide()
  select(9, ChallengesFrameDetails:GetRegions()):Hide()
  select(10, ChallengesFrameDetails:GetRegions()):Hide()
  select(11, ChallengesFrameDetails:GetRegions()):Hide()
  ChallengesFrameDungeonButton1:SetPoint("TOPLEFT", ChallengesFrame, "TOPLEFT", 8, -83)
  for u = 1, 9 do 
    local v = ChallengesFrame["button"..u]
    v:SetButtonTemplate()
    v:SetButtonTemplate()
    v:SetHighlightTexture("")
    v.selectedTex:SetAlpha(.2)
    v.selectedTex:SetPoint("TOPLEFT", 1, -1)
    v.selectedTex:SetPoint("BOTTOMRIGHT", -1, 1)
  v.NoMedal:Die()
  end 
  for u = 1, 3 do 
    local F = ChallengesFrame["RewardRow"..u]
    for A = 1, 2 do 
      local v = F["Reward"..A]
      v:SetPanelTemplate()
      v.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end 
  end 
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveBlizzardStyle("Blizzard_ChallengesUI",ChallengesFrameStyle)