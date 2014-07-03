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
GOSSIP STYLER
##########################################################
]]--
local function GossipStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.gossip ~= true then return end;
	ItemTextFrame:Formula409(true)
	ItemTextScrollFrame:Formula409()
	MOD:ApplyCloseButtonStyle(GossipFrameCloseButton)
	MOD:ApplyPaginationStyle(ItemTextPrevPageButton)
	MOD:ApplyPaginationStyle(ItemTextNextPageButton)
	ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(ItemTextPageText, "SetTextColor", function(q, k, l, m)
		if k ~= 1 or l ~= 1 or m ~= 1 then 
			ItemTextPageText:SetTextColor(1, 1, 1)
		end 
	end)
	ItemTextFrame:SetPanelTemplate("Pattern")
	ItemTextFrameInset:MUNG()
	MOD:ApplyScrollStyle(ItemTextScrollFrameScrollBar)
	MOD:ApplyCloseButtonStyle(ItemTextFrameCloseButton)
	local r = {"GossipFrameGreetingPanel", "GossipFrame", "GossipFrameInset", "GossipGreetingScrollFrame"}
	MOD:ApplyScrollStyle(GossipGreetingScrollFrameScrollBar, 5)
	for s, t in pairs(r)do 
		_G[t]:Formula409()
	end;
	GossipFrame:SetPanelTemplate("Halftone")
	GossipGreetingScrollFrame:SetFixedPanelTemplate("Inset", true)
	GossipGreetingScrollFrame.spellTex = GossipGreetingScrollFrame:CreateTexture(nil, "ARTWORK")
	GossipGreetingScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
	GossipGreetingScrollFrame.spellTex:SetPoint("TOPLEFT", 2, -2)
	GossipGreetingScrollFrame.spellTex:Size(506, 615)
	GossipGreetingScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
	_G["GossipFramePortrait"]:MUNG()
	_G["GossipFrameGreetingGoodbyeButton"]:Formula409()
	_G["GossipFrameGreetingGoodbyeButton"]:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(GossipFrameCloseButton, GossipFrame.Panel)
	NPCFriendshipStatusBar:Formula409()
	NPCFriendshipStatusBar:SetStatusBarTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	NPCFriendshipStatusBar:SetPanelTemplate("Default")
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(GossipStyle)