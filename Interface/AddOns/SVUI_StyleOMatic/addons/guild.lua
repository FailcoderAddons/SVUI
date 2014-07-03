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
local format = string.format;

local GuildFrameList = {	
	"GuildNewPerksFrame",
	"GuildFrameInset",
	"GuildFrameBottomInset",
	"GuildAllPerksFrame",
	"GuildMemberDetailFrame",
	"GuildMemberNoteBackground",
	"GuildInfoFrameInfo",
	"GuildLogContainer",
	"GuildLogFrame",
	"GuildRewardsFrame",
	"GuildMemberOfficerNoteBackground",
	"GuildTextEditContainer",
	"GuildTextEditFrame",
	"GuildRecruitmentRolesFrame",
	"GuildRecruitmentAvailabilityFrame",
	"GuildRecruitmentInterestFrame",
	"GuildRecruitmentLevelFrame",
	"GuildRecruitmentCommentFrame",
	"GuildRecruitmentCommentInputFrame",
	"GuildInfoFrameApplicantsContainer",
	"GuildInfoFrameApplicants",
	"GuildNewsBossModel",
	"GuildNewsBossModelTextFrame"
};

local GuildButtonList = {
	"GuildPerksToggleButton",
	"GuildMemberRemoveButton",
	"GuildMemberGroupInviteButton",
	"GuildAddMemberButton",
	"GuildViewLogButton",
	"GuildControlButton",
	"GuildRecruitmentListGuildButton",
	"GuildTextEditFrameAcceptButton",
	"GuildRecruitmentInviteButton",
	"GuildRecruitmentMessageButton",
	"GuildRecruitmentDeclineButton"
};

local GuildCheckBoxList = {
	"Quest",
	"Dungeon",
	"Raid",
	"PvP",
	"RP",
	"Weekdays",
	"Weekends",
	"LevelAny",
	"LevelMax"
};

local CalendarIconList = {
	[CALENDAR_EVENTTYPE_PVP] = "Interface\\Calendar\\UI-Calendar-Event-PVP",
	[CALENDAR_EVENTTYPE_MEETING] = "Interface\\Calendar\\MeetingIcon",
	[CALENDAR_EVENTTYPE_OTHER] = "Interface\\Calendar\\UI-Calendar-Event-Other"
};

local LFGFrameList = {  
  "LookingForGuildPvPButton",
  "LookingForGuildWeekendsButton",
  "LookingForGuildWeekdaysButton",
  "LookingForGuildRPButton",
  "LookingForGuildRaidButton",
  "LookingForGuildQuestButton",
  "LookingForGuildDungeonButton"
};

local function GCTabHelper(tab)
	tab.Panel:Hide()
	tab.bg1 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg1:SetDrawLayer("BACKGROUND",4)
	tab.bg1:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	tab.bg1:SetVertexColor(unpack(SuperVillain.Media.color.default))
	tab.bg1:FillInner(tab.Panel,1)
	tab.bg3 = tab:CreateTexture(nil,"BACKGROUND")
	tab.bg3:SetDrawLayer("BACKGROUND",2)
	tab.bg3:SetTexture(0,0,0,1)
	tab.bg3:SetAllPoints(tab.Panel) 
end;

local RankOrder_OnUpdate = function()
	for b=1,GuildControlGetNumRanks()do 
		local frame = _G["GuildControlUIRankOrderFrameRank"..b]
		if frame then 
			frame.downButton:SetButtonTemplate()
			frame.upButton:SetButtonTemplate()
			frame.deleteButton:SetButtonTemplate()
			if not frame.nameBox.Panel then 
				frame.nameBox:SetEditboxTemplate()
			end;
			frame.nameBox.Panel:Point("TOPLEFT",-2,-4)
			frame.nameBox.Panel:Point("BOTTOMRIGHT",-4,4)
		end 
	end 
end;

function GuildInfoEvents_SetButton(button, eventIndex)
	local dateData = date("*t")
	local month, day, weekday, hour, minute, eventType, title, calendarType, textureName = CalendarGetGuildEventInfo(eventIndex)
	local formattedTime = GameTime_GetFormattedTime(hour, minute, true)
	local unformattedText;
	if dateData["day"] == day and dateData["month"] == month then
		unformattedText = NORMAL_FONT_COLOR_CODE..GUILD_EVENT_TODAY..FONT_COLOR_CODE_CLOSE 
	else
		local year = dateData["year"]
		if month < dateData["month"] then
			year = year + 1 
		end;
		local newTime = time{year = year, month = month, day = day}
		if(((newTime - time()) < 518400) and CALENDAR_WEEKDAY_NAMES[weekday]) then
			unformattedText = CALENDAR_WEEKDAY_NAMES[weekday]
		elseif CALENDAR_WEEKDAY_NAMES[weekday]and day and month then 
			unformattedText = format(GUILD_NEWS_DATE, CALENDAR_WEEKDAY_NAMES[weekday], day, month)
		end 
	end;
	if button.text and unformattedText then
		button.text:SetFormattedText(GUILD_EVENT_FORMAT, unformattedText, formattedTime, title)
	end;
	button.index = eventIndex;
	if button.icon.type ~= "event" then
		button.icon.type = "event"
		button.icon:SetTexCoord(0, 1, 0, 1)
		button.icon:SetWidth(14)
		button.icon:SetHeight(14)
	end;
	if CalendarIconList[eventType] then
		button.icon:SetTexture(CalendarIconList[eventType])
	else
		button.icon:SetTexture("Interface\\LFGFrame\\LFGIcon-"..textureName)
	end 
end
--[[ 
########################################################## 
GUILDFRAME STYLERS
##########################################################
]]--
local function GuildBankStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.gbank ~= true then
		return 
	end;
	GuildBankFrame:Formula409()
	GuildBankFrame:SetPanelTemplate("Halftone")
	GuildBankEmblemFrame:Formula409(true)
	GuildBankMoneyFrameBackground:MUNG()
	MOD:ApplyScrollStyle(GuildBankPopupScrollFrameScrollBar)
	for b = 1, GuildBankFrame:GetNumChildren()do 
		local c = select(b, GuildBankFrame:GetChildren())
		if c.GetPushedTexture and c:GetPushedTexture() and not c:GetName() then
			MOD:ApplyCloseButtonStyle(c)
		end 
	end;
	GuildBankFrameDepositButton:SetButtonTemplate()
	GuildBankFrameWithdrawButton:SetButtonTemplate()
	GuildBankInfoSaveButton:SetButtonTemplate()
	GuildBankFramePurchaseButton:SetButtonTemplate()
	GuildBankFrameWithdrawButton:Point("RIGHT", GuildBankFrameDepositButton, "LEFT", -2, 0)
	GuildBankInfoScrollFrame:Point('TOPLEFT', GuildBankInfo, 'TOPLEFT', -10, 12)
	GuildBankInfoScrollFrame:Formula409()
	GuildBankInfoScrollFrame:Width(GuildBankInfoScrollFrame:GetWidth()-8)
	GuildBankTransactionsScrollFrame:Formula409()
	
	for b = 1, NUM_GUILDBANK_COLUMNS do
		_G["GuildBankColumn"..b]:Formula409()
		for d = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do 
			local e = _G["GuildBankColumn"..b.."Button"..d]
			local icon = _G["GuildBankColumn"..b.."Button"..d.."IconTexture"]
			local texture = _G["GuildBankColumn"..b.."Button"..d.."NormalTexture"]
			if texture then
				texture:SetTexture(nil)
			end;
			e:SetSlotTemplate()
			icon:FillInner()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end 
	end;
	for b = 1, 8 do 
		local e = _G["GuildBankTab"..b.."Button"]
		local texture = _G["GuildBankTab"..b.."ButtonIconTexture"]
		_G["GuildBankTab"..b]:Formula409(true)
		e:Formula409()
		e:SetButtonTemplate()
		e:SetFixedPanelTemplate("Default")
		texture:FillInner()
		texture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end;
	for b = 1, 4 do
		MOD:ApplyTabStyle(_G["GuildBankFrameTab"..b])
	end;
	hooksecurefunc('GuildBankFrame_Update', function()
		if GuildBankFrame.mode ~= "bank" then
			return 
		end;
		local f = GetCurrentGuildBankTab()
		local e, g, h, i, j, k, l, m;
		for b = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
			g = mod(b, NUM_SLOTS_PER_GUILDBANK_GROUP)
			if g == 0 then
				g = NUM_SLOTS_PER_GUILDBANK_GROUP 
			end;
			h = ceil((b-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
			e = _G["GuildBankColumn"..h.."Button"..g]
			i = GetGuildBankItemLink(f, b)
			if i then
				j = select(3, GetItemInfo(i))
				if j > 1 then
					k, l, m = GetItemQualityColor(j)
				else
					k, l, m = 0,0,0,1
				end 
			else
				k, l, m = 0,0,0,1
			end;
			e:SetBackdropBorderColor(k, l, m)
		end 
	end)
	GuildBankPopupFrame:Formula409()
	GuildBankPopupScrollFrame:Formula409()
	GuildBankPopupFrame:SetFixedPanelTemplate("Transparent", true)
	GuildBankPopupFrame:Point("TOPLEFT", GuildBankFrame, "TOPRIGHT", 1, -30)
	GuildBankPopupOkayButton:SetButtonTemplate()
	GuildBankPopupCancelButton:SetButtonTemplate()
	GuildBankPopupEditBox:SetEditboxTemplate()
	GuildBankPopupNameLeft:MUNG()
	GuildBankPopupNameRight:MUNG()
	GuildBankPopupNameMiddle:MUNG()
	GuildItemSearchBox:Formula409()
	GuildItemSearchBox:SetPanelTemplate("Overlay")
	GuildItemSearchBox.Panel:Point("TOPLEFT", 10, -1)
	GuildItemSearchBox.Panel:Point("BOTTOMRIGHT", 4, 1)
	for b = 1, 16 do 
		local e = _G["GuildBankPopupButton"..b]
		local icon = _G[e:GetName().."Icon"]
		e:Formula409()
		e:SetFixedPanelTemplate("Default")
		e:SetButtonTemplate()
		icon:FillInner()
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end;
	MOD:ApplyScrollStyle(GuildBankTransactionsScrollFrameScrollBar)
	MOD:ApplyScrollStyle(GuildBankInfoScrollFrameScrollBar)
end;

local function GuildFrameStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.guild ~= true then
		return 
	end;
	GuildFrame:Formula409(true)
	GuildFrame:SetPanelTemplate("Halftone")
	GuildLevelFrame:MUNG()
	MOD:ApplyCloseButtonStyle(GuildMemberDetailCloseButton)
	MOD:ApplyCloseButtonStyle(GuildFrameCloseButton)
	GuildRewardsFrameVisitText:ClearAllPoints()
	GuildRewardsFrameVisitText:SetPoint("TOP", GuildRewardsFrame, "TOP", 0, 30)
	for s, y in pairs(GuildFrameList)do
		_G[y]:Formula409()
	end;
	GuildNewsBossModel:SetPanelTemplate("Transparent", true)
	GuildNewsBossModelTextFrame:SetPanelTemplate("Default")
	GuildNewsBossModelTextFrame.Panel:Point("TOPLEFT", GuildNewsBossModel.Panel, "BOTTOMLEFT", 0, -1)
	GuildNewsBossModel:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -43)
	for b, e in pairs(GuildButtonList)do 
		if b == 1 then
			_G[e]:SetButtonTemplate()
		else
			_G[e]:SetButtonTemplate()
		end 
	end;
	for s, y in pairs(GuildCheckBoxList)do
		_G["GuildRecruitment"..y.."Button"]:SetCheckboxTemplate(true)
	end;
	GuildRecruitmentTankButton.checkButton:SetCheckboxTemplate(true)
	GuildRecruitmentHealerButton.checkButton:SetCheckboxTemplate(true)
	GuildRecruitmentDamagerButton.checkButton:SetCheckboxTemplate(true)
	for b = 1, 5 do
		MOD:ApplyTabStyle(_G["GuildFrameTab"..b])
		if b == 1 then
			_G["GuildFrameTab"..b]:Point("TOPLEFT", GuildFrame, "BOTTOMLEFT", -10, 3)
		end;
	end;
	GuildXPFrame:ClearAllPoints()
	GuildXPFrame:Point("TOP", GuildFrame, "TOP", 0, -40)
	MOD:ApplyScrollStyle(GuildPerksContainerScrollBar, 4)
	GuildNewPerksFrame:SetFixedPanelTemplate("Pattern")
	GuildFactionBar:Formula409()
	GuildFactionBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	GuildFactionBar:SetPanelTemplate("Inset")
	GuildFactionBar.Panel:Point("TOPLEFT", GuildFactionBar.progress, "TOPLEFT", -1, 1)
	GuildFactionBar.Panel:Point("BOTTOMRIGHT", GuildFactionBar, "BOTTOMRIGHT", 1, 1)
	GuildXPBar:Formula409()
	GuildXPBar.progress:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]])
	GuildXPBar:SetPanelTemplate("Inset")
	GuildXPBar.Panel:Point("TOPLEFT", GuildXPBar, "TOPLEFT", -1, -3)
	GuildXPBar.Panel:Point("BOTTOMRIGHT", GuildXPBar, "BOTTOMRIGHT", 0, 1)
	GuildLatestPerkButton:Formula409()
	GuildLatestPerkButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	GuildLatestPerkButtonIconTexture:ClearAllPoints()
	GuildLatestPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildLatestPerkButton:SetPanelTemplate("Inset")
	GuildLatestPerkButton.Panel:WrapOuter(GuildLatestPerkButtonIconTexture)
	GuildNextPerkButton:Formula409()
	GuildNextPerkButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	GuildNextPerkButtonIconTexture:ClearAllPoints()
	GuildNextPerkButtonIconTexture:Point("TOPLEFT", 2, -2)
	GuildNextPerkButton:SetPanelTemplate("Inset")
	GuildNextPerkButton.Panel:WrapOuter(GuildNextPerkButtonIconTexture)
	for b = 1, 8 do 
		local e = _G["GuildPerksContainerButton"..b]
		e:Formula409()
		if e.icon then
			e.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			e.icon:ClearAllPoints()
			e.icon:Point("TOPLEFT", 2, -2)
			e:SetFixedPanelTemplate("Button")
			e.Panel:WrapOuter(e.icon)
			e.icon:SetParent(e.Panel)
		end 
	end;
	GuildRosterContainer:SetFixedPanelTemplate("Pattern")
	MOD:ApplyScrollStyle(GuildRosterContainerScrollBar, 5)
	GuildRosterShowOfflineButton:SetCheckboxTemplate(true)
	for b = 1, 4 do
		_G["GuildRosterColumnButton"..b]:Formula409(true)
	end;
	MOD:ApplyDropdownStyle(GuildRosterViewDropdown, 200)
	for b = 1, 14 do
		_G["GuildRosterContainerButton"..b.."HeaderButton"]:SetButtonTemplate()
	end;
	GuildMemberDetailFrame:SetFixedPanelTemplate("Transparent", true)
	GuildMemberNoteBackground:SetFixedPanelTemplate("Default")
	GuildMemberOfficerNoteBackground:SetFixedPanelTemplate("Default")
	GuildMemberRankDropdown:SetFrameLevel(GuildMemberRankDropdown:GetFrameLevel()+5)
	MOD:ApplyDropdownStyle(GuildMemberRankDropdown, 175)
	GuildNewsFrame:Formula409()
	GuildNewsContainer:SetFixedPanelTemplate("Pattern")
	for b = 1, 17 do 
		if _G["GuildNewsContainerButton"..b]then
			_G["GuildNewsContainerButton"..b].header:MUNG()
		end 
	end;
	GuildNewsFiltersFrame:Formula409()
	GuildNewsFiltersFrame:SetFixedPanelTemplate("Transparent", true)
	MOD:ApplyCloseButtonStyle(GuildNewsFiltersFrameCloseButton)
	for b = 1, 7 do
		_G["GuildNewsFilterButton"..b]:SetCheckboxTemplate(true)
	end;
	GuildNewsFiltersFrame:Point("TOPLEFT", GuildFrame, "TOPRIGHT", 4, -20)
	MOD:ApplyScrollStyle(GuildNewsContainerScrollBar, 4)
	MOD:ApplyScrollStyle(GuildInfoDetailsFrameScrollBar, 4)
	for b = 1, 3 do
		_G["GuildInfoFrameTab"..b]:Formula409()
	end;
	local A = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	A:SetFixedPanelTemplate("Inset")
	A:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel()-1)
	A:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -22)
	A:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 200)
	local B = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	B:SetFixedPanelTemplate("Inset")
	B:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel()-1)
	B:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -158)
	B:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 118)
	local C = CreateFrame("Frame", nil, GuildInfoFrameInfo)
	C:SetFixedPanelTemplate("Inset")
	C:SetFrameLevel(GuildInfoFrameInfo:GetFrameLevel()-1)
	C:Point("TOPLEFT", GuildInfoFrameInfo, "TOPLEFT", 2, -233)
	C:Point("BOTTOMRIGHT", GuildInfoFrameInfo, "BOTTOMRIGHT", 0, 3)
	GuildRecruitmentCommentInputFrame:SetFixedPanelTemplate("Default")
	GuildTextEditFrame:SetFixedPanelTemplate("Transparent", true)
	MOD:ApplyScrollStyle(GuildTextEditScrollFrameScrollBar, 5)
	GuildTextEditContainer:SetFixedPanelTemplate("Default")
	for b = 1, GuildTextEditFrame:GetNumChildren()do 
		local c = select(b, GuildTextEditFrame:GetChildren())
		if c:GetName() == "GuildTextEditFrameCloseButton"and c:GetWidth() < 33 then
			MOD:ApplyCloseButtonStyle(c)
		elseif c:GetName() == "GuildTextEditFrameCloseButton" then 
			c:SetButtonTemplate()
		end 
	end;
	MOD:ApplyScrollStyle(GuildLogScrollFrameScrollBar, 4)
	GuildLogFrame:SetFixedPanelTemplate("Transparent", true)
	for b = 1, GuildLogFrame:GetNumChildren()do 
		local c = select(b, GuildLogFrame:GetChildren())
		if c:GetName() == "GuildLogFrameCloseButton"and c:GetWidth() < 33 then
			MOD:ApplyCloseButtonStyle(c)
		elseif c:GetName() == "GuildLogFrameCloseButton" then 
			c:SetButtonTemplate()
		end 
	end;
	GuildRewardsFrame:SetFixedPanelTemplate("Pattern")
	MOD:ApplyScrollStyle(GuildRewardsContainerScrollBar, 5)
	for b = 1, 8 do 
		local button = _G["GuildRewardsContainerButton"..b]
		button:Formula409()
		if button.icon then
			button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			button.icon:ClearAllPoints()
			button.icon:Point("TOPLEFT", 2, -2)
			button:SetFixedPanelTemplate("Button")
			button.Panel:WrapOuter(button.icon)
			button.icon:SetParent(button.Panel)
		end 
	end;
	local maxCalendarEvents = CalendarGetNumGuildEvents();
	local scrollFrame = GuildInfoFrameApplicantsContainer;
  	local offset = HybridScrollFrame_GetOffset(scrollFrame);
  	local buttonIndex,counter = 0,0;
	for _,button in next, GuildInfoFrameApplicantsContainer.buttons do
		counter = counter + 1;
		buttonIndex = offset + counter;
		button.selectedTex:MUNG()
		button:GetHighlightTexture():MUNG()
		button:SetBackdrop(nil);
		-- if ( buttonIndex <= maxCalendarEvents ) then
  --     		GuildInfoEvents_SetButton(button, buttonIndex);
  --     	end
	end;
end;

local function GuildControlStyle()
	if SuperVillain.db.SVStyle.blizzard.enable~=true or SuperVillain.db.SVStyle.blizzard.guildcontrol~=true then return end;
	GuildControlUI:Formula409()
	GuildControlUIHbar:Formula409()
	GuildControlUI:SetFixedPanelTemplate("Halftone")
	GuildControlUIRankBankFrameInset:Formula409()
	GuildControlUIRankBankFrameInsetScrollFrame:Formula409()
	MOD:ApplyScrollStyle(GuildControlUIRankBankFrameInsetScrollFrameScrollBar)
	hooksecurefunc("GuildControlUI_RankOrder_Update",RankOrder_OnUpdate)
	GuildControlUIRankOrderFrameNewButton:HookScript("OnClick",function()
		SuperVillain:ExecuteTimer(1,RankOrder_OnUpdate)
	end)
	MOD:ApplyDropdownStyle(GuildControlUINavigationDropDown)
	MOD:ApplyDropdownStyle(GuildControlUIRankSettingsFrameRankDropDown,180)
	GuildControlUINavigationDropDownButton:Width(20)
	GuildControlUIRankSettingsFrameRankDropDownButton:Width(20)
	for b=1,NUM_RANK_FLAGS do 
		if _G["GuildControlUIRankSettingsFrameCheckbox"..b]then 
			_G["GuildControlUIRankSettingsFrameCheckbox"..b]:SetCheckboxTemplate(true)
		end 
	end;
	GuildControlUIRankOrderFrameNewButton:SetButtonTemplate()
	GuildControlUIRankSettingsFrameGoldBox:SetEditboxTemplate()
	GuildControlUIRankSettingsFrameGoldBox.Panel:Point("TOPLEFT",-2,-4)
	GuildControlUIRankSettingsFrameGoldBox.Panel:Point("BOTTOMRIGHT",2,4)
	GuildControlUIRankSettingsFrameGoldBox:Formula409()
	GuildControlUIRankBankFrame:Formula409()
	local Z=false;
	hooksecurefunc("GuildControlUI_BankTabPermissions_Update",function()
		local tabs = GetNumGuildBankTabs()
		if tabs < MAX_BUY_GUILDBANK_TABS then 
			tabs = tabs + 1 
		end;
		for b=1,tabs do 
			local f=_G["GuildControlBankTab"..b.."Owned"]
			local icon=f.tabIcon;
			local a0=f.editBox;icon:SetTexCoord(0.1,0.9,0.1,0.9 )
			if Z==false then 
				_G["GuildControlBankTab"..b.."BuyPurchaseButton"]:SetButtonTemplate()
				_G["GuildControlBankTab"..b.."OwnedStackBox"]:SetEditboxTemplate()
				_G["GuildControlBankTab"..b.."OwnedViewCheck"]:SetCheckboxTemplate(true)
				_G["GuildControlBankTab"..b.."OwnedDepositCheck"]:SetCheckboxTemplate(true)
				_G["GuildControlBankTab"..b.."OwnedUpdateInfoCheck"]:SetCheckboxTemplate(true)
				GCTabHelper(_G["GuildControlBankTab"..b.."OwnedStackBox"])
				GCTabHelper(_G["GuildControlBankTab"..b.."OwnedViewCheck"])
				GCTabHelper(_G["GuildControlBankTab"..b.."OwnedDepositCheck"])
				GCTabHelper(_G["GuildControlBankTab"..b.."OwnedUpdateInfoCheck"])
			end 
		end;
		Z=true 
	end)
	MOD:ApplyDropdownStyle(GuildControlUIRankBankFrameRankDropDown,180)
	GuildControlUIRankBankFrameRankDropDownButton:Width(20)
end;


local function GuildRegistrarStyle()
	if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.guildregistrar ~= true then
		return 
	end;
	GuildRegistrarFrame:Formula409(true)
	GuildRegistrarFrame:SetPanelTemplate("Action")
	GuildRegistrarFrameInset:MUNG()
	GuildRegistrarFrameEditBox:Formula409()
	GuildRegistrarGreetingFrame:Formula409()
	GuildRegistrarFrameGoodbyeButton:SetButtonTemplate()
	GuildRegistrarFrameCancelButton:SetButtonTemplate()
	GuildRegistrarFramePurchaseButton:SetButtonTemplate()
	MOD:ApplyCloseButtonStyle(GuildRegistrarFrameCloseButton)
	GuildRegistrarFrameEditBox:SetEditboxTemplate()
	for b = 1, GuildRegistrarFrameEditBox:GetNumRegions()do 
		local a2 = select(b, GuildRegistrarFrameEditBox:GetRegions())
		if a2 and a2:GetObjectType() == "Texture"then
			if a2:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Left" or a2:GetTexture() == "Interface\\ChatFrame\\UI-ChatInputBorder-Right" then 
				a2:MUNG()
			end 
		end 
	end;
	GuildRegistrarFrameEditBox:Height(20)
	for b = 1, 2 do
		_G["GuildRegistrarButton"..b]:GetFontString():SetTextColor(1, 1, 1)
	end;
	GuildRegistrarPurchaseText:SetTextColor(1, 1, 1)
	AvailableServicesText:SetTextColor(1, 1, 0)
end;

local function LFGuildFrameStyle()
  if SuperVillain.db.SVStyle.blizzard.enable ~= true or SuperVillain.db.SVStyle.blizzard.lfguild ~= true then return end;
  for r, I in pairs(LFGFrameList)do
     _G[I]:SetCheckboxTemplate(true)
  end;
  LookingForGuildTankButton.checkButton:SetCheckboxTemplate(true)
  LookingForGuildHealerButton.checkButton:SetCheckboxTemplate(true)
  LookingForGuildDamagerButton.checkButton:SetCheckboxTemplate(true)
  LookingForGuildFrameInset:Formula409(false)
  LookingForGuildFrame:Formula409()
  LookingForGuildFrame:SetPanelTemplate("Action")
  LookingForGuildBrowseButton_LeftSeparator:MUNG()
  LookingForGuildRequestButton_RightSeparator:MUNG()
  MOD:ApplyScrollStyle(LookingForGuildBrowseFrameContainerScrollBar)
  LookingForGuildBrowseButton:SetButtonTemplate()
  LookingForGuildRequestButton:SetButtonTemplate()
  MOD:ApplyCloseButtonStyle(LookingForGuildFrameCloseButton)
  LookingForGuildCommentInputFrame:SetPanelTemplate("Default")
  LookingForGuildCommentInputFrame:Formula409(false)
  for u = 1, 5 do 
    local J = _G["LookingForGuildBrowseFrameContainerButton"..u]
    local K = _G["LookingForGuildAppsFrameContainerButton"..u]
    J:SetBackdrop(nil)
    K:SetBackdrop(nil)
  end;
  for u = 1, 3 do
  	local tab = _G["LookingForGuildFrameTab"..u]
  	MOD:ApplyTabStyle(tab)
    tab:SetFrameStrata("HIGH")
    tab:SetFrameLevel(99)
  end;
  GuildFinderRequestMembershipFrame:Formula409(true)
  GuildFinderRequestMembershipFrame:SetFixedPanelTemplate("Transparent", true)
  GuildFinderRequestMembershipFrameAcceptButton:SetButtonTemplate()
  GuildFinderRequestMembershipFrameCancelButton:SetButtonTemplate()
  GuildFinderRequestMembershipFrameInputFrame:Formula409()
  GuildFinderRequestMembershipFrameInputFrame:SetFixedPanelTemplate("Default")
end;
--[[ 
########################################################## 
STYLE LOADING
##########################################################
]]--
MOD:SaveBlizzardStyle("Blizzard_GuildBankUI",GuildBankStyle)
MOD:SaveBlizzardStyle("Blizzard_GuildUI",GuildFrameStyle)
MOD:SaveBlizzardStyle("Blizzard_GuildControlUI",GuildControlStyle)
MOD:SaveCustomStyle(GuildRegistrarStyle)
MOD:SaveBlizzardStyle("Blizzard_LookingForGuildUI",LFGuildFrameStyle)