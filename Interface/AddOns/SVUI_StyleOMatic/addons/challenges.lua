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
CHALLENGES UI STYLER
##########################################################
]]--
local function ChallengesFrameStyle()
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.lfg ~= true then return end;
  ChallengesFrameInset:Formula409()
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
  v.NoMedal:MUNG()
  end;
  for u = 1, 3 do 
    local F = ChallengesFrame["RewardRow"..u]
    for A = 1, 2 do 
      local v = F["Reward"..A]
      v:SetPanelTemplate()
      v.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    end 
  end 
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_ChallengesUI",ChallengesFrameStyle)