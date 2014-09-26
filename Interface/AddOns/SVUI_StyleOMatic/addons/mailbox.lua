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
HELPERS
##########################################################
]]--
local function MailFrame_OnUpdate()
	for b = 1, ATTACHMENTS_MAX_SEND do 
		local d = _G["SendMailAttachment"..b]
		if not d.styled then
			d:RemoveTextures()d:SetFixedPanelTemplate("Default")
			d:SetButtonTemplate()
			d.styled = true 
		end 
		local e = d:GetNormalTexture()
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:FillInner()
		end 
	end 
end 
--[[ 
########################################################## 
MAILBOX STYLER
##########################################################
]]--
local function MailBoxStyle()
	if SV.db.SVStyle.blizzard.enable ~= true or SV.db.SVStyle.blizzard.mail ~= true then return end 

	STYLE:ApplyWindowStyle(MailFrame)
	
	for b = 1, INBOXITEMS_TO_DISPLAY do 
		local i = _G["MailItem"..b]
		i:RemoveTextures()
		i:SetPanelTemplate("Inset")
		i.Panel:Point("TOPLEFT", 2, 1)
		i.Panel:Point("BOTTOMRIGHT", -2, 2)
		local d = _G["MailItem"..b.."Button"]
		d:RemoveTextures()
		d:SetButtonTemplate()
		local e = _G["MailItem"..b.."ButtonIcon"]
		e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		e:FillInner()
	end 
	STYLE:ApplyCloseButtonStyle(MailFrameCloseButton)
	STYLE:ApplyPaginationStyle(InboxPrevPageButton)
	STYLE:ApplyPaginationStyle(InboxNextPageButton)
	MailFrameTab1:RemoveTextures()
	MailFrameTab2:RemoveTextures()
	STYLE:ApplyTabStyle(MailFrameTab1)
	STYLE:ApplyTabStyle(MailFrameTab2)
	SendMailScrollFrame:RemoveTextures(true)
	SendMailScrollFrame:SetFixedPanelTemplate("Inset")
	STYLE:ApplyScrollFrameStyle(SendMailScrollFrameScrollBar)
	SendMailNameEditBox:SetEditboxTemplate()
	SendMailSubjectEditBox:SetEditboxTemplate()
	SendMailMoneyGold:SetEditboxTemplate()
	SendMailMoneySilver:SetEditboxTemplate()
	SendMailMoneyCopper:SetEditboxTemplate()
	SendMailMoneyBg:Die()
	SendMailMoneyInset:RemoveTextures()

	_G["SendMailMoneySilver"]:SetEditboxTemplate()
	_G["SendMailMoneySilver"].Panel:Point("TOPLEFT", -2, 1)
	_G["SendMailMoneySilver"].Panel:Point("BOTTOMRIGHT", -12, -1)
	_G["SendMailMoneySilver"]:SetTextInsets(-1, -1, -2, -2)

	_G["SendMailMoneyCopper"]:SetEditboxTemplate()
	_G["SendMailMoneyCopper"].Panel:Point("TOPLEFT", -2, 1)
	_G["SendMailMoneyCopper"].Panel:Point("BOTTOMRIGHT", -12, -1)
	_G["SendMailMoneyCopper"]:SetTextInsets(-1, -1, -2, -2)

	SendMailNameEditBox.Panel:Point("BOTTOMRIGHT", 2, 4)
	SendMailSubjectEditBox.Panel:Point("BOTTOMRIGHT", 2, 0)
	SendMailFrame:RemoveTextures()
	
	hooksecurefunc("SendMailFrame_Update", MailFrame_OnUpdate)
	SendMailMailButton:SetButtonTemplate()
	SendMailCancelButton:SetButtonTemplate()
	OpenMailFrame:RemoveTextures(true)
	OpenMailFrame:SetFixedPanelTemplate("Transparent", true)
	OpenMailFrameInset:Die()
	STYLE:ApplyCloseButtonStyle(OpenMailFrameCloseButton)
	OpenMailReportSpamButton:SetButtonTemplate()
	OpenMailReplyButton:SetButtonTemplate()
	OpenMailDeleteButton:SetButtonTemplate()
	OpenMailCancelButton:SetButtonTemplate()
	InboxFrame:RemoveTextures()
	MailFrameInset:Die()
	OpenMailScrollFrame:RemoveTextures(true)
	OpenMailScrollFrame:SetFixedPanelTemplate("Default")
	STYLE:ApplyScrollFrameStyle(OpenMailScrollFrameScrollBar)
	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailArithmeticLine:Die()
	OpenMailLetterButton:RemoveTextures()
	OpenMailLetterButton:SetFixedPanelTemplate("Default")
	OpenMailLetterButton:SetButtonTemplate()
	OpenMailLetterButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailLetterButtonIconTexture:FillInner()
	OpenMailMoneyButton:RemoveTextures()
	OpenMailMoneyButton:SetFixedPanelTemplate("Default")
	OpenMailMoneyButton:SetButtonTemplate()
	OpenMailMoneyButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailMoneyButtonIconTexture:FillInner()
	for b = 1, ATTACHMENTS_MAX_SEND do 
		local d = _G["OpenMailAttachmentButton"..b]
		d:RemoveTextures()
		d:SetButtonTemplate()
		local e = _G["OpenMailAttachmentButton"..b.."IconTexture"]
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:FillInner()
		end 
	end 
	OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)
	OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)
	SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -2, 0)
end 
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
STYLE:SaveCustomStyle(MailBoxStyle)