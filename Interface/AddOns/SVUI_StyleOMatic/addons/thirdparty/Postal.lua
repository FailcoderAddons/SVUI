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
########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G.SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local STYLE = _G.StyleVillain;
--[[ 
########################################################## 
POSTAL
##########################################################
]]--
local function StylePostal()
	assert(PostalOpenAllButton, "AddOn Not Loaded")

	InboxPrevPageButton:Point("CENTER", InboxFrame, "BOTTOMLEFT", 45, 112)
	InboxNextPageButton:Point("CENTER", InboxFrame, "BOTTOMLEFT", 295, 112)

	for i = 1, INBOXITEMS_TO_DISPLAY do
		local b = _G["MailItem"..i.."ExpireTime"]
		b:SetPoint("TOPRIGHT", "MailItem"..i, "TOPRIGHT", -5, -10)
		if b.returnicon then
			b.returnicon:SetPoint("TOPRIGHT", b, "TOPRIGHT", 20, 0)
		end
		if _G['PostalInboxCB'..i] and not _G['PostalInboxCB'..i].handled then
			_G['PostalInboxCB'..i]:SetCheckboxTemplate(true)
			_G['PostalInboxCB'..i].handled = true
		end
	end
	if PostalSelectOpenButton and not PostalSelectOpenButton.handled then
		PostalSelectOpenButton:SetButtonTemplate()
		PostalSelectOpenButton.handled = true
		PostalSelectOpenButton:Point("RIGHT", InboxFrame, "TOP", -41, -48)
	end
	if Postal_OpenAllMenuButton and not Postal_OpenAllMenuButton.handled then
		STYLE:ApplyPaginationStyle(Postal_OpenAllMenuButton, true)
		Postal_OpenAllMenuButton:SetPoint('LEFT', PostalOpenAllButton, 'RIGHT', 5, 0)
		Postal_OpenAllMenuButton.handled = true
	end
	if PostalOpenAllButton and not PostalOpenAllButton.handled then
		PostalOpenAllButton:SetButtonTemplate()
		PostalOpenAllButton.handled = true
		PostalOpenAllButton:Point("CENTER", InboxFrame, "TOP", -34, -400)
	end
	if PostalSelectReturnButton and not PostalSelectReturnButton.handled then
		PostalSelectReturnButton:SetButtonTemplate()
		PostalSelectReturnButton.handled = true
		PostalSelectReturnButton:Point("LEFT", InboxFrame, "TOP", -5, -48)
	end
	if Postal_PackageMenuButton and not Postal_PackageMenuButton.handled then
		STYLE:ApplyPaginationStyle(Postal_PackageMenuButton, true)
		Postal_PackageMenuButton.handled = true
		Postal_PackageMenuButton:SetPoint('TOPRIGHT', MailFrame, -53, -6)
	end
	if Postal_BlackBookButton and not Postal_BlackBookButton.handled then
		STYLE:ApplyPaginationStyle(Postal_BlackBookButton, true)
		Postal_BlackBookButton.handled = true
		Postal_BlackBookButton:SetPoint('LEFT', SendMailNameEditBox, 'RIGHT', 5, 2)
	end
end
STYLE:SaveAddonStyle("Postal", StylePostal, nil, nil, 'MAIL_SHOW')