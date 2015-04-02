--[[
##############################################################################
S V U I   By: Munglunch
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
local ipairs 	= _G.ipairs;
local type 		= _G.type;
local error 	= _G.error;
local pcall 	= _G.pcall;
local assert 	= _G.assert;
local tostring 	= _G.tostring;
local tonumber 	= _G.tonumber;
local tinsert 	= _G.tinsert;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
--[[ TABLE METHODS ]]--
local wipe, sort = table.wipe, table.sort;

local SetItemRef          	= _G.SetItemRef;
local GetNumFriends         = _G.GetNumFriends;
local BNGetNumFriends       = _G.BNGetNumFriends;
local GetFriendInfo         = _G.GetFriendInfo;
local BNGetFriendInfo       = _G.BNGetFriendInfo;
local BNGetToonInfo         = _G.BNGetToonInfo;
local GetRealmName          = _G.GetRealmName;
local GetRealZoneText       = _G.GetRealZoneText;
local InviteUnit            = _G.InviteUnit;
local BNInviteFriend        = _G.BNInviteFriend;
local BNSetCustomMessage    = _G.BNSetCustomMessage;
local BNGetInfo          	= _G.BNGetInfo;
local IsChatDND             = _G.IsChatDND;
local IsChatAFK             = _G.IsChatAFK;
local UnitInRaid            = _G.UnitInRaid;
local UnitInParty           = _G.UnitInParty;
local SendChatMessage       = _G.SendChatMessage;

local AFK       = _G.AFK;
local DND       = _G.DND;
local GetQuestDifficultyColor 		= _G.GetQuestDifficultyColor;
local LOCALIZED_CLASS_NAMES_MALE 	= _G.LOCALIZED_CLASS_NAMES_MALE;
local LOCALIZED_CLASS_NAMES_FEMALE 	= _G.LOCALIZED_CLASS_NAMES_FEMALE;
local WORLD_OF_WARCRAFT 			= _G.WORLD_OF_WARCRAFT;
local BATTLENET_OPTIONS_LABEL 		= _G.BATTLENET_OPTIONS_LABEL;
local BNET_CLIENT_WOW  				= _G.BNET_CLIENT_WOW;
local BNET_CLIENT_SC2  				= _G.BNET_CLIENT_SC2;
local BNET_CLIENT_D3  				= _G.BNET_CLIENT_D3;
local BNET_CLIENT_WTCG  			= _G.BNET_CLIENT_WTCG;
local RAID_CLASS_COLORS 			= _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L
local Reports = SV.Reports;
--[[ 
########################################################## 
FRIENDS STATS
##########################################################
]]--
local HEX_COLOR = "22FFFF";
local TEXT_PATTERN1 = "%s: |cff%s%d|r";
local TEXT_PATTERN2 = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r";
local TEXT_PATTERN3 = "|cff%02x%02x%02x%d|r %s%s%s";
local totalOnlineString = join("", FRIENDS_LIST_ONLINE, ": %s/%s");
local statusTable = { "|cffFFFFFF[|r|cffFF0000"..L['AFK'].."|r|cffFFFFFF]|r", "|cffFFFFFF[|r|cffFF0000"..L['DND'].."|r|cffFFFFFF]|r", "" };
local groupedTable = { "|cffaaaaaa*|r", "" };
local friendTable, BNTable, BNTableWoW, BNTableD3, BNTableSC, BNTableWTCG = {}, {}, {}, {}, {}, {};
local tableList = {[BNET_CLIENT_WOW] = BNTableWoW, [BNET_CLIENT_D3] = BNTableD3, [BNET_CLIENT_SC2] = BNTableSC, [BNET_CLIENT_WTCG] = BNTableWTCG};
local friendOnline, friendOffline = gsub(ERR_FRIEND_ONLINE_SS,"\124Hplayer:%%s\124h%[%%s%]\124h",""), gsub(ERR_FRIEND_OFFLINE_S,"%%s","");
local dataValid = false;

SV.SystemAlert.SET_BN_BROADCAST={
	text = BN_BROADCAST_TOOLTIP,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	editBoxWidth = 350,
	maxLetters = 127,
	OnAccept = function(self) BNSetCustomMessage(self.editBox:GetText()) end,
	OnShow = function(self) self.editBox:SetText(select(4, BNGetInfo()) ) self.editBox:SetFocus() end,
	OnHide = ChatEdit_FocusActiveWindow,
	EditBoxOnEnterPressed = function(self) BNSetCustomMessage(self:GetText()) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3
};

local menuFrame = CreateFrame("Frame", "FriendDatatextRightClickMenu", SV.Screen, "UIDropDownMenuTemplate")
local menuList = {
	{ text = OPTIONS_MENU, isTitle = true,notCheckable=true},
	{ text = INVITE, hasArrow = true,notCheckable=true, },
	{ text = CHAT_MSG_WHISPER_INFORM, hasArrow = true,notCheckable=true, },
	{ text = PLAYER_STATUS, hasArrow = true, notCheckable=true,
		menuList = {
			{ text = "|cff2BC226"..AVAILABLE.."|r", notCheckable=true, func = function() if IsChatAFK() then SendChatMessage("", "AFK") elseif IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffE7E716"..DND.."|r", notCheckable=true, func = function() if not IsChatDND() then SendChatMessage("", "DND") end end },
			{ text = "|cffFF0000"..AFK.."|r", notCheckable=true, func = function() if not IsChatAFK() then SendChatMessage("", "AFK") end end },
		},
	},
	{ text = BN_BROADCAST_TOOLTIP, notCheckable=true, func = function() SV:StaticPopup_Show("SET_BN_BROADCAST") end },
}

local function inviteClick(self, name)
	menuFrame:Hide()
	
	if type(name) ~= 'number' then
		InviteUnit(name)
	else
		BNInviteFriend(name);
	end
end

local function whisperClick(self, name, battleNet)
	menuFrame:Hide() 
	
	if battleNet then
		ChatFrame_SendSmartTell(name)
	else
		SetItemRef( "player:"..name, ("|Hplayer:%1$s|h[%1$s]|h"):format(name), "LeftButton" )		 
	end
end

local function BuildFriendTable(total)
	wipe(friendTable)
	local name, level, class, area, connected, status, note
	for i = 1, total do
		name, level, class, area, connected, status, note = GetFriendInfo(i)

		if status == "<"..AFK..">" then
			status = "|cffFFFFFF[|r|cffFF0000"..L['AFK'].."|r|cffFFFFFF]|r"
		elseif status == "<"..DND..">" then
			status = "|cffFFFFFF[|r|cffFF0000"..L['DND'].."|r|cffFFFFFF]|r"
		end
		
		if connected then 
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do if class == v then class = k end end
			friendTable[i] = { name, level, class, area, connected, status, note }
		end
	end
	sort(friendTable, function(a, b)
		if a[1] and b[1] then
			return a[1] < b[1]
		end
	end)
end

local function Sort(a, b)
	if a[2] and b[2] and a[3] and b[3] then
		if a[2] == b[2] then return a[3] < b[3] end
		return a[2] < b[2]
	end
end

local function BuildBNTable(total)
	wipe(BNTable)
	wipe(BNTableWoW)
	wipe(BNTableD3)
	wipe(BNTableSC)
	wipe(BNTableWTCG)

	local _, presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR
	local toonName, client, realmName, realmID, faction, race, class, zoneName, level, gameText, broadcastText, broadcastTime
	for i = 1, total do
	--  presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR
		presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i)
	--  unknown, toonName, client, realmName, realmID, faction, race, class, unknown, zoneName, level, gameText, broadcastText, broadcastTime, unknown, presenceID
		_, _, _, realmName, realmID, faction, race, class, _, zoneName, level, gameText, broadcastText, broadcastTime, _, _ = BNGetToonInfo(presenceID);
		
		if isOnline then 
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do if class == v then class = k end end
			BNTable[i] = { presenceID, presenceName, battleTag, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }

			if client == BNET_CLIENT_SC2 then
				BNTableSC[#BNTableSC + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			elseif client == BNET_CLIENT_D3 then
				BNTableD3[#BNTableD3 + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			elseif client == BNET_CLIENT_WTCG then
				BNTableWTCG[#BNTableWTCG + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			else
				BNTableWoW[#BNTableWoW + 1] = { presenceID, presenceName, toonName, toonID, client, isOnline, isAFK, isDND, noteText, realmName, faction, race, class, zoneName, level }
			end
		end
	end
	
	--sort(BNTable, Sort)	
	sort(BNTableWoW, Sort)
	sort(BNTableSC, Sort)
	sort(BNTableD3, Sort)
	sort(BNTableWTCG, Sort)
end

local REPORT_NAME = "Friends";

local Report = Reports:NewReport(REPORT_NAME, {
	type = "data source",
	text = REPORT_NAME .. " Info",
	icon = [[Interface\Addons\SVUI_!Core\assets\icons\SVUI]]
});

Report.events = {
	"PLAYER_ENTERING_WORLD",
	"BN_FRIEND_ACCOUNT_ONLINE",
	"BN_FRIEND_ACCOUNT_OFFLINE",
	"BN_FRIEND_INFO_CHANGED",
	"BN_FRIEND_TOON_ONLINE",
	"BN_FRIEND_TOON_OFFLINE",
	"BN_TOON_NAME_UPDATED",
	"FRIENDLIST_UPDATE",
	"CHAT_MSG_SYSTEM"
};

Report.OnEvent = function(self, event, ...)
	local _, onlineFriends = GetNumFriends()
	local _, numBNetOnline = BNGetNumFriends()
	if event == "CHAT_MSG_SYSTEM" then
		local message = select(1, ...)
		if not (find(message, friendOnline) or find(message, friendOffline)) then return end
	end
	dataValid = false
	local amt = onlineFriends + numBNetOnline
	self.text:SetFormattedText(TEXT_PATTERN1, L['Friends'], HEX_COLOR, amt)
end

Report.OnClick = function(self, button)
	Reports.ToolTip:Hide()

	if button == "RightButton" then
		local menuCountWhispers = 0
		local menuCountInvites = 0
		local classc, levelc, info
		
		menuList[2].menuList = {}
		menuList[3].menuList = {}
		
		if #friendTable > 0 then
			for i = 1, #friendTable do
				info = friendTable[i]
				if (info[5]) then
					menuCountInvites = menuCountInvites + 1
					menuCountWhispers = menuCountWhispers + 1
		
					classc, levelc = RAID_CLASS_COLORS[info[3]], GetQuestDifficultyColor(info[2])
					classc = classc or GetQuestDifficultyColor(info[2]);
		
					menuList[2].menuList[menuCountInvites] = {text = format(TEXT_PATTERN2,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = inviteClick}
					menuList[3].menuList[menuCountWhispers] = {text = format(TEXT_PATTERN2,levelc.r*255,levelc.g*255,levelc.b*255,info[2],classc.r*255,classc.g*255,classc.b*255,info[1]), arg1 = info[1],notCheckable=true, func = whisperClick}
				end
			end
		end
		if #BNTable > 0 then
			local realID, grouped
			for i = 1, #BNTable do
				info = BNTable[i]
				if (info[5]) then
					realID = info[2]
					menuCountWhispers = menuCountWhispers + 1
					menuList[3].menuList[menuCountWhispers] = {text = realID, arg1 = realID, arg2 = true, notCheckable=true, func = whisperClick}

					if info[6] == BNET_CLIENT_WOW and UnitFactionGroup("player") == info[12] then
						classc, levelc = RAID_CLASS_COLORS[info[14]], GetQuestDifficultyColor(info[16])
						classc = classc or GetQuestDifficultyColor(info[16])

						if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end
						menuCountInvites = menuCountInvites + 1
						
						menuList[2].menuList[menuCountInvites] = {text = format(TEXT_PATTERN2,levelc.r*255,levelc.g*255,levelc.b*255,info[16],classc.r*255,classc.g*255,classc.b*255,info[4]), arg1 = info[5], notCheckable=true, func = inviteClick}
					end
				end
			end
		end

		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)	
	else
		ToggleFriendsFrame()
	end
end

Report.OnEnter = function(self)
	Reports:SetDataTip(self)
	local grouped
	local numberOfFriends, onlineFriends = GetNumFriends()
	local totalBNet, numBNetOnline = BNGetNumFriends()
		
	local totalonline = onlineFriends + numBNetOnline
	
	-- no friends online, quick exit
	if totalonline == 0 then return end

	if not dataValid then
		-- only retrieve information for all on-line members when we actually view the tooltip
		if numberOfFriends > 0 then BuildFriendTable(numberOfFriends) end
		if totalBNet > 0 then BuildBNTable(totalBNet) end
		dataValid = true
	end

	local totalfriends = numberOfFriends + totalBNet
	local zonec, classc, levelc, realmc, info
	Reports.ToolTip:AddDoubleLine(L['Friends List'], format(totalOnlineString, totalonline, totalfriends), 0.4,0.78,1, 0.4,0.78,1)
	if onlineFriends > 0 then
		Reports.ToolTip:AddLine(' ')
		Reports.ToolTip:AddLine(WORLD_OF_WARCRAFT)
		for i = 1, #friendTable do
			info = friendTable[i]
			if info[5] then
				if GetRealZoneText() == info[4] then zonec = SV.media.color.green else zonec = SV.media.color.medium end
				classc, levelc = RAID_CLASS_COLORS[info[3]], GetQuestDifficultyColor(info[2])
				
				classc = classc or GetQuestDifficultyColor(info[2])
				
				if UnitInParty(info[1]) or UnitInRaid(info[1]) then grouped = 1 else grouped = 2 end
				Reports.ToolTip:AddDoubleLine(format(TEXT_PATTERN3,levelc.r*255,levelc.g*255,levelc.b*255,info[2],info[1],groupedTable[grouped]," "..info[6]),info[4],classc.r,classc.g,classc.b,zonec.r,zonec.g,zonec.b)
			end
		end
	end

	if numBNetOnline > 0 then
		local status = 0
		for client, list in pairs(tableList) do
			if #list > 0 then
				Reports.ToolTip:AddLine(' ')
				Reports.ToolTip:AddLine(BATTLENET_OPTIONS_LABEL..' ('..client..')')			
				for i = 1, #list do
					info = list[i]
					-- for x = 1, #info do
					-- 	print(x)
					-- 	print(info[x])
					-- 	print("-----")
					-- end
					if info[6] then
						if info[5] == BNET_CLIENT_WOW then
							if (info[7] == true) then status = 1 elseif (info[8] == true) then status = 2 else status = 3 end
							classc = RAID_CLASS_COLORS[info[13]]

							if UnitInParty(info[4]) or UnitInRaid(info[4]) then grouped = 1 else grouped = 2 end

							if info[15] ~= '' then
								levelc = GetQuestDifficultyColor(info[15])
								Reports.ToolTip:AddDoubleLine(format(TEXT_PATTERN2, levelc.r*255, levelc.g*255, levelc.b*255, info[15], classc.r*255, classc.g*255, classc.b*255, info[3], groupedTable[grouped], 255, 0, 0, statusTable[status]), info[2], 238, 238, 238, 238, 238, 238)
							else
								classc = classc or RAID_CLASS_COLORS["PRIEST"]
								Reports.ToolTip:AddDoubleLine(format("|cff%02x%02x%02x%s|r", classc.r*255, classc.g*255, classc.b*255, info[3], groupedTable[grouped], 255, 0, 0, statusTable[status]), info[2], 238, 238, 238, 238, 238, 238)
							end

							if IsShiftKeyDown() then
								if GetRealZoneText() == info[14] then zonec = SV.media.color.green else zonec = SV.media.color.medium end
								if GetRealmName() == info[10] then realmc = SV.media.color.green else realmc = SV.media.color.medium end
								Reports.ToolTip:AddDoubleLine(info[14], info[10], zonec.r, zonec.g, zonec.b, realmc.r, realmc.g, realmc.b)
							end
						else
							Reports.ToolTip:AddDoubleLine(info[3], info[2], .9, .9, .9, .9, .9, .9)
						end
					end
				end
			end
		end
	end	
	
	Reports:ShowDataTip()
end