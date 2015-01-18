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
			d:RemoveTextures()d:SetStylePanel("!_Frame", "Default")
			d:SetStylePanel("Button")
			d.styled = true 
		end 
		local e = d:GetNormalTexture()
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:SetAllPointsIn()
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
		i:SetStylePanel("Frame", "Inset")
		i.Panel:SetPointToScale("TOPLEFT", 2, 1)
		i.Panel:SetPointToScale("BOTTOMRIGHT", -2, 2)
		local d = _G["MailItem"..b.."Button"]
		d:RemoveTextures()
		d:SetStylePanel("Button")
		local e = _G["MailItem"..b.."ButtonIcon"]
		e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		e:SetAllPointsIn()
	end 
	PLUGIN:ApplyCloseButtonStyle(MailFrameCloseButton)
	PLUGIN:ApplyPaginationStyle(InboxPrevPageButton)
	PLUGIN:ApplyPaginationStyle(InboxNextPageButton)
	MailFrameTab1:RemoveTextures()
	MailFrameTab2:RemoveTextures()
	PLUGIN:ApplyTabStyle(MailFrameTab1)
	PLUGIN:ApplyTabStyle(MailFrameTab2)
	SendMailScrollFrame:RemoveTextures(true)
	SendMailScrollFrame:SetStylePanel("!_Frame", "Inset")
	PLUGIN:ApplyScrollFrameStyle(SendMailScrollFrameScrollBar)
	SendMailNameEditBox:SetStylePanel("Editbox")
	SendMailSubjectEditBox:SetStylePanel("Editbox")
	SendMailMoneyGold:SetStylePanel("Editbox")
	SendMailMoneySilver:SetStylePanel("Editbox")
	SendMailMoneyCopper:SetStylePanel("Editbox")
	SendMailMoneyBg:Die()
	SendMailMoneyInset:RemoveTextures()

	_G["SendMailMoneySilver"]:SetStylePanel("Editbox")
	_G["SendMailMoneySilver"].Panel:SetPointToScale("TOPLEFT", -2, 1)
	_G["SendMailMoneySilver"].Panel:SetPointToScale("BOTTOMRIGHT", -12, -1)
	_G["SendMailMoneySilver"]:SetTextInsets(-1, -1, -2, -2)

	_G["SendMailMoneyCopper"]:SetStylePanel("Editbox")
	_G["SendMailMoneyCopper"].Panel:SetPointToScale("TOPLEFT", -2, 1)
	_G["SendMailMoneyCopper"].Panel:SetPointToScale("BOTTOMRIGHT", -12, -1)
	_G["SendMailMoneyCopper"]:SetTextInsets(-1, -1, -2, -2)

	SendMailNameEditBox.Panel:SetPointToScale("BOTTOMRIGHT", 2, 4)
	SendMailSubjectEditBox.Panel:SetPointToScale("BOTTOMRIGHT", 2, 0)
	SendMailFrame:RemoveTextures()
	
	hooksecurefunc("SendMailFrame_Update", MailFrame_OnUpdate)
	SendMailMailButton:SetStylePanel("Button")
	SendMailCancelButton:SetStylePanel("Button")
	OpenMailFrame:RemoveTextures(true)
	OpenMailFrame:SetStylePanel("!_Frame", "Transparent", true)
	OpenMailFrameInset:Die()
	PLUGIN:ApplyCloseButtonStyle(OpenMailFrameCloseButton)
	OpenMailReportSpamButton:SetStylePanel("Button")
	OpenMailReplyButton:SetStylePanel("Button")
	OpenMailDeleteButton:SetStylePanel("Button")
	OpenMailCancelButton:SetStylePanel("Button")
	InboxFrame:RemoveTextures()
	MailFrameInset:Die()
	OpenMailScrollFrame:RemoveTextures(true)
	OpenMailScrollFrame:SetStylePanel("!_Frame", "Default")
	PLUGIN:ApplyScrollFrameStyle(OpenMailScrollFrameScrollBar)
	SendMailBodyEditBox:SetTextColor(1, 1, 1)
	OpenMailBodyText:SetTextColor(1, 1, 1)
	InvoiceTextFontNormal:SetTextColor(1, 1, 1)
	OpenMailArithmeticLine:Die()
	OpenMailLetterButton:RemoveTextures()
	OpenMailLetterButton:SetStylePanel("!_Frame", "Default")
	OpenMailLetterButton:SetStylePanel("Button")
	OpenMailLetterButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailLetterButtonIconTexture:SetAllPointsIn()
	OpenMailMoneyButton:RemoveTextures()
	OpenMailMoneyButton:SetStylePanel("!_Frame", "Default")
	OpenMailMoneyButton:SetStylePanel("Button")
	OpenMailMoneyButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	OpenMailMoneyButtonIconTexture:SetAllPointsIn()
	for b = 1, ATTACHMENTS_MAX_SEND do 
		local d = _G["OpenMailAttachmentButton"..b]
		d:RemoveTextures()
		d:SetStylePanel("Button")
		local e = _G["OpenMailAttachmentButton"..b.."IconTexture"]
		if e then
			e:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e:SetAllPointsIn()
		end 
	end 
	OpenMailReplyButton:SetPointToScale("RIGHT", OpenMailDeleteButton, "LEFT", -2, 0)
	OpenMailDeleteButton:SetPointToScale("RIGHT", OpenMailCancelButton, "LEFT", -2, 0)
	SendMailMailButton:SetPointToScale("RIGHT", SendMailCancelButton, "LEFT", -2, 0)
end 
--[[ 
########################################################## 
PLUGIN LOADING
##########################################################
]]--
PLUGIN:SaveCustomStyle(MailBoxStyle)