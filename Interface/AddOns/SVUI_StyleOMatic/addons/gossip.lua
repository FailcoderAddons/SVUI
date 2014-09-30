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
local L = SV.L;
local STYLE = select(2, ...);
local Schema = STYLE.Schema;
--[[ 
########################################################## 
GOSSIP STYLER
##########################################################
]]--
local function GossipStyle()
	if SV.db[Schema].blizzard.enable ~= true or SV.db[Schema].blizzard.gossip ~= true then return end 
	ItemTextFrame:RemoveTextures(true)
	ItemTextScrollFrame:RemoveTextures()
	STYLE:ApplyCloseButtonStyle(GossipFrameCloseButton)
	STYLE:ApplyPaginationStyle(ItemTextPrevPageButton)
	STYLE:ApplyPaginationStyle(ItemTextNextPageButton)
	ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(ItemTextPageText, "SetTextColor", function(q, k, l, m)
		if k ~= 1 or l ~= 1 or m ~= 1 then 
			ItemTextPageText:SetTextColor(1, 1, 1)
		end 
	end)
	ItemTextFrame:SetPanelTemplate("Pattern")
	ItemTextFrameInset:Die()
	STYLE:ApplyScrollFrameStyle(ItemTextScrollFrameScrollBar)
	STYLE:ApplyCloseButtonStyle(ItemTextFrameCloseButton)
	local r = {"GossipFrameGreetingPanel", "GossipFrame", "GossipFrameInset", "GossipGreetingScrollFrame"}
	STYLE:ApplyScrollFrameStyle(GossipGreetingScrollFrameScrollBar, 5)
	for s, t in pairs(r)do 
		_G[t]:RemoveTextures()
	end 
	GossipFrame:SetPanelTemplate("Halftone")
	GossipGreetingScrollFrame:SetFixedPanelTemplate("Inset", true)
	GossipGreetingScrollFrame.spellTex = GossipGreetingScrollFrame:CreateTexture(nil, "ARTWORK")
	GossipGreetingScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	GossipGreetingScrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
	GossipGreetingScrollFrame.spellTex:Size(506, 615)
	GossipGreetingScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
	_G["GossipFramePortrait"]:Die()
	_G["GossipFrameGreetingGoodbyeButton"]:RemoveTextures()
	_G["GossipFrameGreetingGoodbyeButton"]:SetButtonTemplate()
	STYLE:ApplyCloseButtonStyle(GossipFrameCloseButton, GossipFrame.Panel)
	NPCFriendshipStatusBar:RemoveTextures()
	NPCFriendshipStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	NPCFriendshipStatusBar:SetPanelTemplate("Default")
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(GossipStyle)