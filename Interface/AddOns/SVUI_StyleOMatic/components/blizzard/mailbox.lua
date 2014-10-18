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
MAILBOX PLUGINR
##########################################################
]]--
local function MailBoxStyle()
	if PLUGIN.db.blizzard.enable ~= true or PLUGIN.db.blizzard.mail ~= true then return end 

	PLUGIN:ApplyWindowStyle(MailFrame)
	
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
	PLUGIN:ApplyCloseButtonStyle(MailFrameCloseButton)
	PLUGIN:ApplyPaginationStyle(InboxPrevPageButton)
	PLUGIN:ApplyPaginationStyle(InboxNextPageButton)
	MailFrameTab1:RemoveTextures()
	MailFrameTab2:RemoveTextures()
	PLUGIN:ApplyTabStyle(MailFrameTab1)
	PLUGIN:ApplyTabStyle(MailFrameTab2)
	SendMailScrollFrame:RemoveTextures(true)
	SendMailScrollFrame:SetFixedPanelTemplate("Inset")
	PLUGIN:ApplyScrollFrameStyle(SendMailScrollFrameScrollBar)
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
	PLUGIN:ApplyCloseButtonStyle(OpenMailFrameCloseButton)
	OpenMailReportSpamButton:SetButtonTemplate()
	OpenMailReplyButton:SetButtonTemplate()
	OpenMailDeleteButton:SetButtonTemplate()
	OpenMailCancelButton:SetButtonTemplate()
	InboxFrame:RemoveTextures()
	MailFrameInset:Die()
	OpenMailScrollFrame:RemoveTextures(true)
	OpenMailScrollFrame:SetFixedPanelTemplate("Default")
	PLUGIN:ApplyScrollFrameStyle(OpenMailScrollFrameScrollBar)
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
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(MailBoxStyle)