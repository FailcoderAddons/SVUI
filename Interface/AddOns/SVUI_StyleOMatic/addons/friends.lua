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
HELPERS
##########################################################
]]--
local FrameSuffix = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right"
};
local FriendsFrameList1 = {
	"ScrollOfResurrectionSelectionFrame",
	"ScrollOfResurrectionSelectionFrameList",
	"FriendsListFrame",
	"FriendsTabHeader",
	"FriendsFrameFriendsScrollFrame",
	"WhoFrameColumnHeader1",
	"WhoFrameColumnHeader2",
	"WhoFrameColumnHeader3",
	"WhoFrameColumnHeader4",
	"ChannelListScrollFrame",
	"ChannelRoster",
	"FriendsFramePendingButton1",
	"FriendsFramePendingButton2",
	"FriendsFramePendingButton3",
	"FriendsFramePendingButton4",
	"ChannelFrameDaughterFrame",
	"AddFriendFrame",
	"AddFriendNoteFrame"
};
local FriendsFrameList2 = {
	"FriendsFrameBroadcastInputLeft",
	"FriendsFrameBroadcastInputRight",
	"FriendsFrameBroadcastInputMiddle",
	"ChannelFrameDaughterFrameChannelNameLeft",
	"ChannelFrameDaughterFrameChannelNameRight",
	"ChannelFrameDaughterFrameChannelNameMiddle",
	"ChannelFrameDaughterFrameChannelPasswordLeft",
	"ChannelFrameDaughterFrameChannelPasswordRight",
	"ChannelFrameDaughterFrameChannelPasswordMiddle"
};
local FriendsFrameButtons = {
	"FriendsFrameAddFriendButton",
	"FriendsFrameSendMessageButton",
	"WhoFrameWhoButton",
	"WhoFrameAddFriendButton",
	"WhoFrameGroupInviteButton",
	"ChannelFrameNewButton",
	"FriendsFrameIgnorePlayerButton",
	"FriendsFrameUnsquelchButton",
	"FriendsFramePendingButton1AcceptButton",
	"FriendsFramePendingButton1DeclineButton",
	"FriendsFramePendingButton2AcceptButton",
	"FriendsFramePendingButton2DeclineButton",
	"FriendsFramePendingButton3AcceptButton",
	"FriendsFramePendingButton3DeclineButton",
	"FriendsFramePendingButton4AcceptButton",
	"FriendsFramePendingButton4DeclineButton",
	"ChannelFrameDaughterFrameOkayButton",
	"ChannelFrameDaughterFrameCancelButton",
	"AddFriendEntryFrameAcceptButton",
	"AddFriendEntryFrameCancelButton",
	"AddFriendInfoFrameContinueButton",
	"ScrollOfResurrectionSelectionFrameAcceptButton",
	"ScrollOfResurrectionSelectionFrameCancelButton"
};

local function TabCustomHelper(this)
	if not this then return end;
	for _,prop in pairs(FrameSuffix) do 
		local frame = _G[this:GetName()..prop]
		frame:SetTexture(nil)
	end;
	this:GetHighlightTexture():SetTexture(nil)
	this.backdrop = CreateFrame("Frame", nil, this)
	this.backdrop:SetFixedPanelTemplate("Default")
	this.backdrop:SetFrameLevel(this:GetFrameLevel()-1)
	this.backdrop:Point("TOPLEFT", 3, -8)
	this.backdrop:Point("BOTTOMRIGHT", -6, 0)
end;

local function ChannelList_OnUpdate()
	for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do 
		local btn = _G["ChannelButton"..i]
		if btn then
			btn:Formula409()
			btn:SetHighlightTexture("Interface\\PaperDollInfoFrame\\UI-Character-Tab-Highlight")
			_G["ChannelButton"..i.."Text"]:SetFontTemplate(nil, 12)
		end 
	end 
end;
--[[ 
########################################################## 
FRIENDSFRAME STYLER
##########################################################
]]--FriendsFrameBattlenetFrameScrollFrame
local function FriendsFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.friends ~= true then
		 return 
	end;
	MOD:ApplyScrollStyle(FriendsFrameFriendsScrollFrameScrollBar, 5)
	MOD:ApplyScrollStyle(WhoListScrollFrameScrollBar, 5)
	MOD:ApplyScrollStyle(ChannelRosterScrollFrameScrollBar, 5)
	MOD:ApplyScrollStyle(FriendsFriendsScrollFrameScrollBar)
	FriendsFrameInset:Formula409()
	WhoFrameListInset:Formula409()
	WhoFrameEditBoxInset:Formula409()
	WhoFrameEditBoxInset:SetEditboxTemplate()
	ChannelFrameRightInset:Formula409()
	ChannelFrameLeftInset:Formula409()
	ChannelFrameRightInset:SetFixedPanelTemplate("Inset", true)
	ChannelFrameLeftInset:SetFixedPanelTemplate("Inset", true)
	LFRQueueFrameListInset:Formula409()
	LFRQueueFrameRoleInset:Formula409()
	LFRQueueFrameCommentInset:Formula409()
	LFRQueueFrameListInset:SetFixedPanelTemplate("Inset", true)
	FriendsFrameFriendsScrollFrame:SetPanelTemplate("Transparent", true)
	FriendsFrameFriendsScrollFrame.Panel:Point("TOPRIGHT", -4, 0)
	WhoFrameListInset:SetPanelTemplate("Transparent", true, 1, -2, -2)
	for c, e in pairs(FriendsFrameButtons)do
		 _G[e]:SetButtonTemplate()
	end;
	for c, texture in pairs(FriendsFrameList2)do
		 _G[texture]:MUNG()
	end;
	for c, V in pairs(FriendsFrameList1)do
		 _G[V]:Formula409()
	end;
	for u = 1, FriendsFrame:GetNumRegions()do 
		local a1 = select(u, FriendsFrame:GetRegions())
		if a1:GetObjectType() == "Texture"then
			a1:SetTexture(nil)
			a1:SetAlpha(0)
		end 
	end;
	FriendsFrameStatusDropDown:SetPoint('TOPLEFT', FriendsTabHeader, 'TOPLEFT', 0, -27)
	MOD:ApplyDropdownStyle(FriendsFrameStatusDropDown, 70)
	FriendsFrameBattlenetFrame:Formula409()
	FriendsFrameBattlenetFrame:SetHeight(22)
	FriendsFrameBattlenetFrame:SetPoint('TOPLEFT', FriendsFrameStatusDropDown, 'TOPRIGHT', 0, -1)
	FriendsFrameBattlenetFrame:SetFixedPanelTemplate("Inset")
	FriendsFrameBattlenetFrame:SetBackdropColor(0,0,0,0.8)
	
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetNormalTexture():SetTexCoord(.28, .72, .28, .72)
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetPushedTexture():SetTexCoord(.28, .72, .28, .72)
	-- FriendsFrameBattlenetFrame.BroadcastButton:GetHighlightTexture():SetTexCoord(.28, .72, .28, .72)
	FriendsFrameBattlenetFrame.BroadcastButton:Formula409()
	FriendsFrameBattlenetFrame.BroadcastButton:SetSize(22,22)
	FriendsFrameBattlenetFrame.BroadcastButton:SetPoint('TOPLEFT', FriendsFrameBattlenetFrame, 'TOPRIGHT', 8, 0)
	FriendsFrameBattlenetFrame.BroadcastButton:SetButtonTemplate()
	FriendsFrameBattlenetFrame.BroadcastButton:SetBackdropColor(0.4,0.4,0.4)
	FriendsFrameBattlenetFrame.BroadcastButton:SetNormalTexture([[Interface\FriendsFrame\UI-Toast-BroadcastIcon]])
	FriendsFrameBattlenetFrame.BroadcastButton:SetPushedTexture([[Interface\FriendsFrame\UI-Toast-BroadcastIcon]])
	FriendsFrameBattlenetFrame.BroadcastButton:SetScript('OnClick', function()
		SuperVillain:StaticPopup_Show("SET_BN_BROADCAST")
	end)
	FriendsFrameBattlenetFrame.Tag:SetFontTemplate(SuperVillain.Media.font.narrator,16,"NONE")
	AddFriendNameEditBox:SetEditboxTemplate()
	AddFriendFrame:SetFixedPanelTemplate("Transparent", true)
	ScrollOfResurrectionSelectionFrame:SetFixedPanelTemplate('Transparent')
	ScrollOfResurrectionSelectionFrameList:SetFixedPanelTemplate('Default')
	MOD:ApplyScrollStyle(ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar, 4)
	ScrollOfResurrectionSelectionFrameTargetEditBox:SetEditboxTemplate()
	FriendsFrameBroadcastInput:SetPanelTemplate("Default")
	ChannelFrameDaughterFrameChannelName:SetPanelTemplate("Default")
	ChannelFrameDaughterFrameChannelPassword:SetPanelTemplate("Default")
	ChannelFrame:HookScript("OnShow", function()
		ChannelRosterScrollFrame:Formula409()
	end)
	hooksecurefunc("FriendsFrame_OnEvent", function()
		ChannelRosterScrollFrame:Formula409()
	end)
	WhoFrame:HookScript("OnShow", function()
		ChannelRosterScrollFrame:Formula409()
	end)
	hooksecurefunc("FriendsFrame_OnEvent", function()
		WhoListScrollFrame:Formula409()
	end)
	ChannelFrameDaughterFrame:SetPanelTemplate("Transparent", true)
	FriendsFrame:SetPanelTemplate("Halftone")
	MOD:ApplyCloseButtonStyle(ChannelFrameDaughterFrameDetailCloseButton, ChannelFrameDaughterFrame)
	MOD:ApplyCloseButtonStyle(FriendsFrameCloseButton, FriendsFrame.Panel)
	MOD:ApplyDropdownStyle(WhoFrameDropDown, 150)
	for i = 1, 4 do
		 MOD:ApplyTabStyle(_G["FriendsFrameTab"..i])
	end;
	for i = 1, 3 do
		 TabCustomHelper(_G["FriendsTabHeaderTab"..i])
	end;
	hooksecurefunc("ChannelList_Update", ChannelList_OnUpdate)
	FriendsFriendsFrame:SetPanelTemplate("Transparent", true)
	_G["FriendsFriendsFrame"]:Formula409()
	_G["FriendsFriendsList"]:Formula409()
	_G["FriendsFriendsNoteFrame"]:Formula409()
	_G["FriendsFriendsSendRequestButton"]:SetButtonTemplate()
	_G["FriendsFriendsCloseButton"]:SetButtonTemplate()
	FriendsFriendsList:SetEditboxTemplate()
	FriendsFriendsNoteFrame:SetEditboxTemplate()
	MOD:ApplyDropdownStyle(FriendsFriendsFrameDropDown, 150)
	BNConversationInviteDialog:Formula409()
	BNConversationInviteDialog:SetPanelTemplate('Transparent')
	BNConversationInviteDialogList:Formula409()
	BNConversationInviteDialogList:SetFixedPanelTemplate('Default')
	BNConversationInviteDialogInviteButton:SetButtonTemplate()
	BNConversationInviteDialogCancelButton:SetButtonTemplate()
	for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
		 _G["BNConversationInviteDialogListFriend"..i].checkButton:SetCheckboxTemplate(true)
	end;
	FriendsTabHeaderSoRButton:SetFixedPanelTemplate('Default')
	FriendsTabHeaderSoRButton:SetButtonTemplate()
	FriendsTabHeaderSoRButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderSoRButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderSoRButtonIcon:FillInner()
	FriendsTabHeaderSoRButton:Point('TOPRIGHT', FriendsTabHeader, 'TOPRIGHT', -8, -56)
	FriendsTabHeaderRecruitAFriendButton:SetFixedPanelTemplate('Default')
	FriendsTabHeaderRecruitAFriendButton:SetButtonTemplate()
	FriendsTabHeaderRecruitAFriendButtonIcon:SetDrawLayer('OVERLAY')
	FriendsTabHeaderRecruitAFriendButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	FriendsTabHeaderRecruitAFriendButtonIcon:FillInner()
	FriendsTabHeaderRecruitAFriendButton:Point('TOPRIGHT', FriendsTabHeaderSoRButton, 'TOPLEFT', -4, 0)
	FriendsFrameIgnoreScrollFrame:SetFixedPanelTemplate("Inset")
	MOD:ApplyScrollStyle(FriendsFrameIgnoreScrollFrameScrollBar, 4)
	FriendsFramePendingScrollFrame:SetFixedPanelTemplate("Inset")
	MOD:ApplyScrollStyle(FriendsFramePendingScrollFrameScrollBar, 4)
	IgnoreListFrame:Formula409()
	PendingListFrame:Formula409()
	ScrollOfResurrectionFrame:Formula409()
	ScrollOfResurrectionFrameAcceptButton:SetButtonTemplate()
	ScrollOfResurrectionFrameCancelButton:SetButtonTemplate()
	ScrollOfResurrectionFrameTargetEditBoxLeft:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxMiddle:SetTexture(nil)
	ScrollOfResurrectionFrameTargetEditBoxRight:SetTexture(nil)
	ScrollOfResurrectionFrameNoteFrame:Formula409()
	ScrollOfResurrectionFrameNoteFrame:SetFixedPanelTemplate()
	ScrollOfResurrectionFrameTargetEditBox:SetFixedPanelTemplate()
	ScrollOfResurrectionFrame:SetFixedPanelTemplate('Transparent')
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(FriendsFrameStyle)