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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local string 	= _G.string;
local math 		= _G.math;
local table 	= _G.table;
--[[ STRING METHODS ]]--
local format, join, gsub = string.format, string.join, string.gsub;
--[[ MATH METHODS ]]--
local ceil = math.ceil;  -- Basic
local twipe, tsort = table.wipe, table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVStats');
--[[ 
########################################################## 
GUILD STATS
##########################################################
]]--
local StatEvents = {"PLAYER_ENTERING_WORLD","GUILD_ROSTER_UPDATE","GUILD_XP_UPDATE","PLAYER_GUILD_UPDATE","GUILD_MOTD"};

local updatedString = "";
local updatedString2 = "";
local guildFormattedName = join("", GUILD, ": %d/%d");
local guildFormattedXP = gsub(join("",SuperVillain:HexColor(0.75,0.9,1),GUILD_EXPERIENCE_CURRENT),": ",":|r |cffffffff",1);
local guildFormattedDailyXP = gsub(join("",SuperVillain:HexColor(0.75,0.9,1),GUILD_EXPERIENCE_DAILY),": ",":|r |cffffffff",1);
local guildFormattedFaction = join("",SuperVillain:HexColor(0.75,0.9,1),"%s:|r |cFFFFFFFF%s/%s (%s%%)");
local guildFormattedOnline = join("","+ %d ",FRIENDS_LIST_ONLINE,"...");
local guildFormattedNote = join("","|cff999999   ",LABEL_NOTE,":|r %s");
local guildFormattedRank = join("","|cff999999   ",GUILD_RANK1_DESC,":|r %s");
local GuildStatMembers,GuildStatXP,GuildStatMOTD={},{},"";
local currentObject;

local UnitFlagFormat = {
	[0] = function()return "" end,
	[1] = function()return format("|cffFFFFFF[|r|cffFF0000%s|r|cffFFFFFF]|r", L["AFK"])end,
	[2] = function()return format("|cffFFFFFF[|r|cffFF0000%s|r|cffFFFFFF]|r", L["DND"])end
};

local MobileFlagFormat = {
	[0] = function()return ChatFrame_GetMobileEmbeddedTexture(73/255, 177/255, 73/255) end,
	[1] = function()return "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t" end,
	[2] = function()return "|TInterface\\ChatFrame\\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t" end
};

local GuildDatatTextRightClickMenu = CreateFrame("Frame", "GuildDatatTextRightClickMenu", SuperVillain.UIParent, "UIDropDownMenuTemplate")

local MenuMap = {
	{text = OPTIONS_MENU,  isTitle = true,  notCheckable = true}, 
	{text = INVITE,  hasArrow = true,  notCheckable = true}, 
	{text = CHAT_MSG_WHISPER_INFORM,  hasArrow = true,  notCheckable = true}
};

local function TruncateString(value)
    if value >= 1e9 then 
        return ("%.1fb"):format(value/1e9):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e6 then 
        return ("%.1fm"):format(value/1e6):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e3 or value <= -1e3 then 
        return ("%.1fk"):format(value/1e3):gsub("%.?0+([kmb])$","%1")
    else 
        return value 
    end 
end

local function SortGuildStatMembers(shift)
	tsort(GuildStatMembers, function(arg1, arg2)
		if arg1 and arg2 then
			if shift then 
				return arg1[10] < arg2[10]
			else
				return arg1[1] < arg2[1]
			end 
		end 
	end)
end;

local function GetGuildStatMembers()
	twipe(GuildStatMembers)
	local statusFormat;
	local _, name, rank, level, zone, note, officernote, online, status, classFileName, isMobile;
	for i = 1, GetNumGuildMembers() do
		name, rank, rankIndex, level, _, zone, note, officernote, online, status, classFileName, _, _, isMobile = GetGuildRosterInfo(i)
		statusFormat = isMobile and MobileFlagFormat[status]() or UnitFlagFormat[status]()
		zone = isMobile and not online and REMOTE_CHAT or zone;
		if online or isMobile then
			GuildStatMembers[#GuildStatMembers + 1] = { name, rank, level, zone, note, officernote, online, statusFormat, classFileName, rankIndex, isMobile}
		end 
	end 
end;

local function GetGuildStatXP()
	local currentXP, nextLevelXP = UnitGetGuildXP("player")
	local totalXP = currentXP + nextLevelXP;
	local percent;
	if currentXP > 0 and totalXP > 0 then
		percent = ceil(currentXP / totalXP * 100)
	else
		percent = 0 
	end;
	GuildStatXP[0] = { currentXP, totalXP, percent }
end;

local GuildStatEventHandler = {
	["PLAYER_ENTERING_WORLD"] = function(arg1, arg2)
		if not GuildFrame and IsInGuild() then
			LoadAddOn("Blizzard_GuildUI")
			GetGuildStatXP()
			GuildRoster()
		end 
	end, 
	["GUILD_ROSTER_UPDATE"] = function(arg1, arg2)
		if arg2 then
			GuildRoster()
		else
			GetGuildStatMembers()
			GuildStatMOTD = GetGuildRosterMOTD()
			if GetMouseFocus() == arg1 then
				arg1:GetScript("OnEnter")(arg1, nil, true)
			end 
		end 
	end,
	["GUILD_XP_UPDATE"] = function(arg1, arg2)
		GetGuildStatXP()
	end,
	["PLAYER_GUILD_UPDATE"] = function(arg1, arg2)
		GuildRoster()
	end,
	["GUILD_MOTD"] = function(arg1, arg2)
		GuildStatMOTD = arg2 
	end,
	["SVUI_FORCE_RUN"] = function() end,
	["SVUI_COLOR_UPDATE"] = function() end
};

local function MenuInvite(self, unit)
	GuildDatatTextRightClickMenu:Hide()
	InviteUnit(unit)
end;

local function MenuRightClick(self, unit)
	GuildDatatTextRightClickMenu:Hide()
	SetItemRef("player:"..unit, ("|Hplayer:%1$s|h[%1$s]|h"):format(unit), "LeftButton")
end;

local function MenuLeftClick()
	if IsInGuild() then
		if not GuildFrame then 
			LoadAddOn("Blizzard_GuildUI")
		end;
		GuildFrame_Toggle()
		GuildFrame_TabClicked(GuildFrameTab2)
	else
		if not LookingForGuildFrame then
			LoadAddOn("Blizzard_LookingForGuildUI")
		end;
		if LookingForGuildFrame then
			LookingForGuildFrame_Toggle()
		end 
	end 
end;

local function Guild_OnEvent(self, event, ...)
	currentObject = self;
	if IsInGuild() and GuildStatEventHandler[event] then
		GuildStatEventHandler[event](self, select(1, ...))
		self.text:SetFormattedText(updatedString, #GuildStatMembers)
	else
		self.text:SetText(updatedString2)
	end 
end;

local function Guild_OnClick(self, button)
	if button == "RightButton" and IsInGuild() then
		MOD.tooltip:Hide()


		local classc, levelc, grouped, info
		local menuCountWhispers = 0
		local menuCountInvites = 0

		MenuMap[2].menuList = {}
		MenuMap[3].menuList = {}

		for i = 1, #GuildStatMembers do
			info = GuildStatMembers[i]
			if info[7] and info[1] ~= SuperVillain.name then 
				local classc, levelc = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS[info[9]], GetQuestDifficultyColor(info[3])
				if UnitInParty(info[1])or UnitInRaid(info[1]) then
					grouped = "|cffaaaaaa*|r"
				elseif not info[11] then 
					menuCountInvites = menuCountInvites + 1;
					grouped = "";
					MenuMap[2].menuList[menuCountInvites] = {
						text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s", levelc.r*255, levelc.g*255, levelc.b*255, info[3], classc.r*255, classc.g*255, classc.b*255, info[1], ""),
						arg1 = info[1], 
						notCheckable = true, 
						func = MenuInvite
					}
				end;
				menuCountWhispers = menuCountWhispers + 1;
				if not grouped then
					grouped = ""
				end;
				MenuMap[3].menuList[menuCountWhispers] = {
					text = format("|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r %s", levelc.r*255, levelc.g*255, levelc.b*255, info[3], classc.r*255, classc.g*255, classc.b*255, info[1], grouped),
					arg1 = info[1], 
					notCheckable = true, 
					func = MenuRightClick
				}
			end 
		end;
		EasyMenu(MenuMap, GuildDatatTextRightClickMenu, "cursor", 0, 0, "MENU", 2)
	else
		MenuLeftClick()
	end 
end;

local function Guild_OnEnter(self, _, ap)
	if not IsInGuild() then
		return 
	end;
	MOD:Tip(self)
	local aq, ar = GetNumGuildMembers()
	if #GuildStatMembers == 0 then GetGuildStatMembers() end;
	SortGuildStatMembers(IsShiftKeyDown())
	local as, at = GetGuildInfo('player')
	local au = GetGuildLevel()
	if as and at and au then
		MOD.tooltip:AddDoubleLine(format("%s [%d]", as, au), format(guildFormattedName, ar, aq), 0.4, 0.78, 1, 0.4, 0.78, 1)
		MOD.tooltip:AddLine(at, 0.4, 0.78, 1)
	end;
	if GuildStatMOTD ~= "" then
		MOD.tooltip:AddLine(' ')
		MOD.tooltip:AddLine(format("%s |cffaaaaaa- |cffffffff%s", GUILD_MOTD, GuildStatMOTD), 0.75, 0.9, 1, 1)
	end;
	local av = SuperVillain:HexColor(0.75,0.9,1)
	if GetGuildLevel() ~= 25 then
		if GuildStatXP[0] then 
			local Z, a0, a1 = unpack(GuildStatXP[0])
			MOD.tooltip:AddLine(' ')
			MOD.tooltip:AddLine(format(guildFormattedXP, TruncateString(Z), TruncateString(a0), a1))
		end 
	end;
	local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
	if standingID ~= 8 then
		barMax = barMax - barMin;
		barValue = barValue - barMin;
		barMin = 0;
		MOD.tooltip:AddLine(format(guildFormattedFaction, COMBAT_FACTION_CHANGE, TruncateString(barValue), TruncateString(barMax), ceil(barValue / barMax * 100)))
	end;
	local zoneColor, classColor, questColor, member, groupFormat;
	local counter = 0;
	MOD.tooltip:AddLine(' ')
	for X = 1, #GuildStatMembers do 
		if((30 - counter) <= 1) then
			if((ar - 30) > 1) then 
				MOD.tooltip:AddLine(format(guildFormattedOnline, ar - 30), 0.75, 0.9, 1)
			end;
			break 
		end;
		member = GuildStatMembers[X]
		if GetRealZoneText() == member[4]then
			zoneColor = {r=0.3,g=1.0,b=0.3} 
		else
			zoneColor = {r=0.65,g=0.65,b=0.65} 
		end;
		classColor, questColor = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS[member[9]], GetQuestDifficultyColor(member[3])
		if UnitInParty(member[1]) or UnitInRaid(member[1]) then
			groupFormat = "|cffaaaaaa*|r"
		else
			groupFormat = ""
		end;
		if IsShiftKeyDown() then
			MOD.tooltip:AddDoubleLine(format("%s |cff999999-|cffffffff %s", member[1], member[2]), member[4], classColor.r, classColor.g, classColor.b, zoneColor.r, zoneColor.g, zoneColor.b)
			if member[5] ~= ""then
				MOD.tooltip:AddLine(format(guildFormattedNote, member[5]), 0.75, 0.9, 1, 1)
			end;
			if member[6] ~= ""then
				MOD.tooltip:AddLine(format(guildFormattedRank, member[6]), 0.3, 1, 0.3, 1)
			end 
		else
			MOD.tooltip:AddDoubleLine(format("|cff%02x%02x%02x%d|r %s%s %s", questColor.r*255, questColor.g*255, questColor.b*255, member[3], member[1], groupFormat, member[8]), member[4], classColor.r, classColor.g, classColor.b, zoneColor.r, zoneColor.g, zoneColor.b)
		end;
		counter = counter + 1 
	end;
	MOD:ShowTip()
	if not ap then
		GuildRoster()
	end 
end;

local GuildColorUpdate = function()
	local hexColor = SuperVillain:HexColor("highlight");
	updatedString = join("", GUILD, ": ", hexColor, "%d|r")
	updatedString2 = join("", hexColor, L['No Guild'])
	if currentObject ~= nil then
		Guild_OnEvent(currentObject, 'SVUI_COLOR_UPDATE')
	end 
end;
SuperVillain.Registry:SetCallback(GuildColorUpdate)

MOD:Extend('Guild', StatEvents, Guild_OnEvent, nil, Guild_OnClick, Guild_OnEnter)