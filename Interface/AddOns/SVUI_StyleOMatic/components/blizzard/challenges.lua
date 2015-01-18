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
CHALLENGES UI PLUGINR
##########################################################
]]--
local function ChallengesFrameStyle()
  if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.lfg ~= true then return end 
  ChallengesFrameInset:RemoveTextures()
  ChallengesFrameInsetBg:Hide()
  ChallengesFrameDetails.bg:Hide()
  ChallengesFrameDetails:SetStylePanel("Frame", "Inset")
  ChallengesFrameLeaderboard:SetStylePanel("Button")
  select(2, ChallengesFrameDetails:GetRegions()):Hide()
  select(9, ChallengesFrameDetails:GetRegions()):Hide()
  select(10, ChallengesFrameDetails:GetRegions()):Hide()
  select(11, ChallengesFrameDetails:GetRegions()):Hide()
  ChallengesFrameDungeonButton1:SetPoint("TOPLEFT", ChallengesFrame, "TOPLEFT", 8, -83)

  for u = 1, 9 do 
    local v = ChallengesFrame["button"..u]
    v:SetStylePanel("Button")
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
      v:SetStylePanel("Frame")
      v.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end 
  end 
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveBlizzardStyle("Blizzard_ChallengesUI",ChallengesFrameStyle)