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
local function MailFrame_OnUpdate()
	for b = 1, ATTACHMENTS_MAX_SEND do 
		local d = _G["SendMailAttachment"..b]
		if not d.styled then
			d:Formula409()d:SetFixedPanelTemplate("Default")
			d:SetButtonTemplate()
			d.styled = true 
		end;
		local e = d:GetNormalTexture()
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:FillInner()
		end 
	end 
end;
--[[ 
########################################################## 
MAILBOX STYLER
##########################################################
]]--
local function MailBoxStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.mail ~= true then return end;
	MailFrame:Formula409(true)
	MailFrame:SetPanelTemplate("Halftone")
	for b = 1, INBOXITEMS_TO_DISPLAY do 
		local i = _G["MailItem"..b]
		i:Formula409()
		i:SetPanelTemplate("Inset")
		i.Panel:Point("TOPLEFT", 2, 1)
		i.Panel:Point("BOTTOMRIGHT", -2, 2)
		local d = _G["MailItem"..b.."Button"]
		d:Formula409()
		d:SetButtonTemplate()
		local e = _G["MailItem"..b.."ButtonIcon"]
		e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		e:FillInner()
	end;
	MOD:ApplyCloseButtonStyle(MailFrameCloseButton)
	MOD:ApplyPaginationStyle(InboxPrevPageButton)
	MOD:ApplyPaginationStyle(InboxNextPageButton)
	MailFrameTab1:Formula409()
	MailFrameTab2:Formula409()
	MOD:ApplyTabStyle(MailFrameTab1)
	MOD:ApplyTabStyle(MailFrameTab2)
	SendMailScrollFrame:Formula409(true)
	SendMailScrollFrame:SetFixedPanelTemplate("Inset")
	MOD:ApplyScrollStyle(SendMailScrollFrameScrollBar)
	SendMailNameEditBox:SetEditboxTemplate()
	SendMailSubjectEditBox:SetEditboxTemplate()
	SendMailMoneyGold:SetEditboxTemplate()
	SendMailMoneySilver:SetEditboxTemplate()
	SendMailMoneyCopper:SetEditboxTemplate()
	SendMailMoneyBg:MUNG()
	SendMailMoneyInset:Formula409()

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
	SendMailFrame:Formula409()
	
	hooksecurefunc("SendMailFrame_Update", MailFrame_OnUpdate)
	SendMailMailButton:SetButtonTemplate()
	SendMailCancelButton:SetButtonTemplate()
	OpenMailFrame:Formula409(true)
	OpenMailFrame:SetFixedPanelTemplate("Transparent", true)
	OpenMailFrameInset:MUNG()
	MOD:ApplyCloseButtonStyle(OpenMailFrameCloseButton)
	OpenMailReportSpamButton:SetButtonTemplate()
	OpenMailReplyButton:SetButtonTemplate()
	OpenMailDeleteButton:SetButtonTemplate()
	OpenMailCancelButton:SetButtonTemplate()
	InboxFrame:Formula409()
	MailFrameInset:MUNG()
	OpenMailScrollFrame:Formula409(true)
	OpenMailScrollFrame:SetFixedPanelTemplate("Default")
	MOD:ApplyScrollStyle(OpenMailScrollFrameScrollBar)
	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailArithmeticLine:MUNG()
	OpenMailLetterButton:Formula409()
	OpenMailLetterButton:SetFixedPanelTemplate("Default")
	OpenMailLetterButton:SetButtonTemplate()
	OpenMailLetterButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailLetterButtonIconTexture:FillInner()
	OpenMailMoneyButton:Formula409()
	OpenMailMoneyButton:SetFixedPanelTemplate("Default")
	OpenMailMoneyButton:SetButtonTemplate()
	OpenMailMoneyButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailMoneyButtonIconTexture:FillInner()
	for b = 1, ATTACHMENTS_MAX_SEND do 
		local d = _G["OpenMailAttachmentButton"..b]
		d:Formula409()
		d:SetButtonTemplate()
		local e = _G["OpenMailAttachmentButton"..b.."IconTexture"]
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:FillInner()
		end 
	end;
	OpenMailReplyButton:Point("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)
	OpenMailDeleteButton:Point("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)
	SendMailMailButton:Point("RIGHT", SendMailCancelButton, "LEFT", -2, 0)
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveCustomStyle(MailBoxStyle)