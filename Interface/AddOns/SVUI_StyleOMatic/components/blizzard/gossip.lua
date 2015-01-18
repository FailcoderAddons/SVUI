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
local ipairs  = _G.ipairs;
local pairs   = _G.pairs;
--[[ ADDON ]]--
local SV = _G.SVUI;
local L = SV.L;
local PLUGIN = select(2, ...);
local Schema = PLUGIN.Schema;
--[[ 
########################################################## 
GOSSIP PLUGINR
##########################################################
]]--
local function GossipStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.gossip ~= true then return end 

	PLUGIN:ApplyWindowStyle(GossipFrame, true, true)

	ItemTextFrame:RemoveTextures(true)
	ItemTextScrollFrame:RemoveTextures()
	PLUGIN:ApplyCloseButtonStyle(GossipFrameCloseButton)
	PLUGIN:ApplyPaginationStyle(ItemTextPrevPageButton)
	PLUGIN:ApplyPaginationStyle(ItemTextNextPageButton)
	ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(ItemTextPageText, "SetTextColor", function(q, k, l, m)
		if k ~= 1 or l ~= 1 or m ~= 1 then 
			ItemTextPageText:SetTextColor(1, 1, 1)
		end 
	end)
	ItemTextFrame:SetStylePanel("Frame", "Pattern")
	ItemTextFrameInset:Die()
	PLUGIN:ApplyScrollFrameStyle(ItemTextScrollFrameScrollBar)
	PLUGIN:ApplyCloseButtonStyle(ItemTextFrameCloseButton)
	local r = {"GossipFrameGreetingPanel", "GossipFrameInset", "GossipGreetingScrollFrame"}
	PLUGIN:ApplyScrollFrameStyle(GossipGreetingScrollFrameScrollBar, 5)
	for s, t in pairs(r)do 
		_G[t]:RemoveTextures()
	end 
	GossipFrame:SetStylePanel("Frame", "Composite1")
	GossipGreetingScrollFrame:SetStylePanel("!_Frame", "Inset", true)
	GossipGreetingScrollFrame.spellTex = GossipGreetingScrollFrame:CreateTexture(nil, "ARTWORK")
	GossipGreetingScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	GossipGreetingScrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
	GossipGreetingScrollFrame.spellTex:SetSizeToScale(506, 615)
	GossipGreetingScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
	_G["GossipFramePortrait"]:Die()
	_G["GossipFrameGreetingGoodbyeButton"]:RemoveTextures()
	_G["GossipFrameGreetingGoodbyeButton"]:SetStylePanel("Button")
	PLUGIN:ApplyCloseButtonStyle(GossipFrameCloseButton, GossipFrame.Panel)

	NPCFriendshipStatusBar:RemoveTextures()
	NPCFriendshipStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	NPCFriendshipStatusBar:SetStylePanel("Frame", "Bar")

	NPCFriendshipStatusBar:ClearAllPoints()
	NPCFriendshipStatusBar:SetPoint("TOPLEFT", GossipFrame, "TOPLEFT", 58, -34)

	NPCFriendshipStatusBar.icon:SetSizeToScale(32,32)
	NPCFriendshipStatusBar.icon:ClearAllPoints()
	NPCFriendshipStatusBar.icon:SetPoint("RIGHT", NPCFriendshipStatusBar, "LEFT", 0, -2)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(GossipStyle)