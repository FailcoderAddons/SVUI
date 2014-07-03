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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local parsefloat, random = math.parsefloat, math.random;  -- Uncommon
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe, tsort, tconcat = table.remove, table.copy, table.wipe, table.sort, table.concat;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
local DOCK = SuperVillain.Registry:Expose('SVDock');
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local SetAllChatHooks, SetParseHandlers;
local internalTest = false
local locale = GetLocale()
local NewHook = hooksecurefunc;
--[[ 
########################################################## 
LOCALIZED DB UPVALUES
##########################################################
]]--
local CHAT_WIDTH = 350;
local CHAT_HEIGHT = 180;
local CHAT_THROTTLE = 45;
local CHAT_ALLOW_URL = true;
local CHAT_HOVER_URL = true;
local CHAT_STICKY = true;
local CHAT_FONT = [[Interface\AddOns\SVUI\assets\fonts\Roboto.ttf]];
local CHAT_FONTSIZE = 12;
local CHAT_FONTOUTLINE = "OUTLINE";
local TAB_WIDTH = 75;
local TAB_HEIGHT = 20;
local TAB_SKINS = true;
local TAB_FONT = [[Interface\AddOns\SVUI\assets\fonts\Alert.ttf]];
local TAB_FONTSIZE = 10;
local TAB_FONTOUTLINE = "OUTLINE";
local CHAT_FADING = false;
local CHAT_PSST = [[Interface\AddOns\SVUI\assets\sounds\whisper.mp3]];
local TIME_STAMP_MASK = "NONE";
local ICONARTFILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-CHAT]]
local THROTTLE_CACHE = {};
--[[ 
########################################################## 
INIT SETTINGS
##########################################################
]]--
CHAT_GUILD_GET = "|Hchannel:GUILD|hG|h %s ";
CHAT_OFFICER_GET = "|Hchannel:OFFICER|hO|h %s ";
CHAT_RAID_GET = "|Hchannel:RAID|hR|h %s ";
CHAT_RAID_WARNING_GET = "RW %s ";
CHAT_RAID_LEADER_GET = "|Hchannel:RAID|hRL|h %s ";
CHAT_PARTY_GET = "|Hchannel:PARTY|hP|h %s ";
CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|hPL|h %s ";
CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|hPG|h %s ";
CHAT_INSTANCE_CHAT_GET = "|Hchannel:Battleground|hI.|h %s: ";
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: ";
CHAT_WHISPER_INFORM_GET = "to %s ";
CHAT_WHISPER_GET = "from %s ";
CHAT_BN_WHISPER_INFORM_GET = "to %s ";
CHAT_BN_WHISPER_GET = "from %s ";
CHAT_SAY_GET = "%s ";
CHAT_YELL_GET = "%s ";
CHAT_FLAG_AFK = "[AFK] ";
CHAT_FLAG_DND = "[DND] ";
CHAT_FLAG_GM = "[GM] ";
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
do
	local EmoteCount = 39;
	local EmotePatterns = {
		{
			"%:%-%@","%:%@","%:%-%)","%:%)","%:D","%:%-D","%;%-D","%;D","%=D",
			"xD","XD","%:%-%(","%:%(","%:o","%:%-o","%:%-O","%:O","%:%-0",
			"%:P","%:%-P","%:p","%:%-p","%=P","%=p","%;%-p","%;p","%;P","%;%-P",
			"%;%-%)","%;%)","%:S","%:%-S","%:%,%(","%:%,%-%(","%:%'%(",
			"%:%'%-%(","%:%F","<3","</3"
		},
		{
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\angry.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\angry.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\happy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\happy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\grin.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\sad.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\sad.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\surprise.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\tongue.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\winky.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\winky.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\hmm.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\hmm.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\weepy.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\middle_finger.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\heart.blp]],
			[[Interface\AddOns\SVUI\assets\artwork\Chat\Emoticons\broken_heart.blp]]
		}
	}

	local function GetEmoticon(pattern)
		for i=1, EmoteCount do
			local emote,icon = EmotePatterns[1][i], EmotePatterns[2][i];
			pattern = gsub(pattern, emote, "|T" .. icon .. ":16|t");
		end
		return pattern;
	end

	local function SetEmoticon(text)
		if not text then return end;
		if (not MOD.db.smileys or text:find(" / run") or text:find(" / dump") or text:find(" / script")) then 
			return text 
		end;
		local result = "";
		local maxLen = len(text);
		local count = 1;
		local temp, pattern;
		while count  <= maxLen do 
			temp = maxLen;
			local section = find(text, "|H", count, true)
			if section ~= nil then temp = section end;
			pattern = sub(text, count, temp);
			result = result .. GetEmoticon(pattern)
			count = temp  +  1;
			if section ~= nil then 
				temp = find(text, "|h]|r", count, -1) or find(text, "|h", count, -1)
				temp = temp or maxLen;
				if count < temp then 
					result = result..sub(text, count, temp)
					count = temp  +  1;
				end 
			end 
		end;
		return result 
	end

	local SVUI_ParseMessage = function(self, event, text, ...)
		if ((event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER") and CHAT_PSST) then 
			if text:sub(1, 3) == "OQ, " then 
				return false, text, ...
			end;
			PlaySoundFile(CHAT_PSST, "Master")
		end;
		if(not CHAT_ALLOW_URL) then
			text = SetEmoticon(text)
			return false, text, ...
		end;
		local result, ct = gsub(text, "(%a+)://(%S+)%s?", "%1://%2")
		if ct > 0 then 
			return false, SetEmoticon(result), ...
		end;
		result, ct = gsub(text, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", "www.%1.%2")
		if ct > 0 then 
			return false, SetEmoticon(result), ...
		end;
		result, ct = gsub(text, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4")
		if ct > 0 then 
			return false, SetEmoticon(result), ...
		end;
		text = SetEmoticon(text)
		return false, text, ...
	end

	local function _concatTimeStamp(msg)
		if (TIME_STAMP_MASK and TIME_STAMP_MASK ~= 'NONE' ) then
			local timeStamp = BetterDate(TIME_STAMP_MASK, time());
			timeStamp = timeStamp:gsub(' ', '')
			timeStamp = timeStamp:gsub('AM', ' AM')
			timeStamp = timeStamp:gsub('PM', ' PM')
			msg = '|cffB3B3B3['..timeStamp..'] |r'..msg
		end
		return msg
	end

	local function _parse(arg1,arg2,arg3)
		internalTest = true;
		local result = " "..string.link("["..arg2.."]", "url", arg2, "0099FF").." ";
		return result
	end

	local AddModifiedMessage = function(self, text, ...)
		internalTest = false;
		if find(text,"%pTInterface%p+") or find(text,"%pTINTERFACE%p+") then 
			internalTest = true 
		end;
		if not internalTest then text = gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)(%s?)", _parse) end;
		if not internalTest then text = gsub(text, "(%s?)(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)(%s?)", _parse) end;
		if not internalTest then text = gsub(text, "(%s?)([%w_-]+%.?[%w_-]+%.[%w_-]+:%d%d%d?%d?%d?)(%s?)", _parse) end;
		if not internalTest then text = gsub(text, "(%s?)(%a+://[%w_/%.%?%%=~&-'%-]+)(%s?)", _parse) end;
		if not internalTest then text = gsub(text, "(%s?)(www%.[%w_/%.%?%%=~&-'%-]+)(%s?)", _parse) end;
		if not internalTest then text = gsub(text, "(%s?)([_%w-%.~-]+@[_%w-]+%.[_%w-%.]+)(%s?)", _parse) end;
		self.TempAddMessage(self, _concatTimeStamp(text), ...)
	end

	local ChatEventFilter = function(self, event, message, author, ...)
		local filter = nil
		if locale == 'enUS' or locale == 'enGB' then
			if strfind(message, '[\227-\237]') then
				filter = true
			end
		end
		if filter then
			return true;
		end
		local blockFlag = false
		local msg = author:upper() .. message;
		if(author ~= UnitName("player") and msg ~= nil and (event == "CHAT_MSG_YELL" or event == "CHAT_MSG_CHANNEL")) then
			if THROTTLE_CACHE[msg] and CHAT_THROTTLE ~= 0 then
				if difftime(time(), THROTTLE_CACHE[msg]) <= CHAT_THROTTLE then
					blockFlag = true
				end
			end
			if blockFlag then
				return true;
			else
				if CHAT_THROTTLE ~= 0 then
					THROTTLE_CACHE[msg] = time()
				end
			end
		end
		return SVUI_ParseMessage(self, event, message, author, ...)
	end

	function SetParseHandlers()
		for _,chatName in pairs(CHAT_FRAMES)do 
			local chat = _G[chatName]
			if chat:GetID() ~= 2 then
				chat.TempAddMessage = chat.AddMessage;
				chat.AddMessage = AddModifiedMessage
			end
		end;
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", ChatEventFilter)
		ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", ChatEventFilter);
	end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
do
	local TabsList = {};
	local TabSafety = {};
	local refreshLocked = false;

	local SVUI_OnHyperlinkShow = function(self, link, ...)
		if(link:sub(1, 3) == "url") then
			local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
			local currentLink = (link):sub(5)
			if (not ChatFrameEditBox:IsShown()) then
				ChatEdit_ActivateChat(ChatFrameEditBox)
			end
			ChatFrameEditBox:Insert(currentLink)
			ChatFrameEditBox:HighlightText()
			return;
		end
		local test, text = link:match("(%a+):(.+)");
		if(test == "url") then 
			local editBox = LAST_ACTIVE_CHAT_EDIT_BOX or _G[self:GetName()..'EditBox']
			if editBox then 
				editBox:SetText(text)
				editBox:SetFocus()
				editBox:HighlightText()
			end 
		else 
			ChatFrame_OnHyperlinkShow(self, link, ...)
		end
	end

	local _hook_TabTextColor = function(self, r, g, b, a)
		local r2, g2, b2 = 1, 1, 1;
		if r ~= r2 or g ~= g2 or b ~= b2 then 
			self:SetTextColor(r2, g2, b2)
			self:SetShadowColor(0, 0, 0)
			self:SetShadowOffset(2, -2)
		end 
	end

	local Tab_OnEnter = function(self)
		local chatFrame = _G["ChatFrame"..self:GetID()];
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
		GameTooltip:ClearLines();
		GameTooltip:AddLine(self.TText,1,1,1);
	    if ( chatFrame.isTemporary and chatFrame.chatType == "BN_CONVERSATION" ) then
	        BNConversation_DisplayConversationTooltip(tonumber(chatFrame.chatTarget));
	    else
	        GameTooltip_AddNewbieTip(self, CHAT_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_CHATOPTIONS, 1);
	    end
		if not self.IsOpen then
			self:SetPanelColor("highlight")
		end
		GameTooltip:Show()
	end;

	local Tab_OnLeave = function(self)
		if not self.IsOpen then
			self:SetPanelColor("default")
		end
		GameTooltip:Hide()
	end;

	local Tab_OnClick = function(self,button)
		FCF_Tab_OnClick(self,button);
		local chatFrame = _G["ChatFrame"..self:GetID()]; 
		if ( chatFrame.isDocked and FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) ~= chatFrame ) then
	        self.IsOpen = true
	        self:SetPanelColor("highlight")
	    else
	        self.IsOpen = false
	        self:SetPanelColor("default")
	    end
	end;

	local EditBox_OnEditFocusGained = function(self)
		self:Show()
		if not LeftSuperDock:IsShown()then 
			LeftSuperDock.editboxforced = true;
			LeftSuperDockToggleButton:GetScript("OnEnter")(LeftSuperDockToggleButton)
		end
		DOCK:DockAlertLeftOpen(self)
	end

	local EditBox_OnEditFocusLost = function(self)
		if LeftSuperDock.editboxforced then 
			LeftSuperDock.editboxforced = nil;
			if LeftSuperDock:IsShown()then 
				LeftSuperDockToggleButton:GetScript("OnLeave")(LeftSuperDockToggleButton)
			end 
		end;
		self:Hide()
		DOCK:DockAlertLeftClose()
	end

	local EditBox_OnTextChanged = function(self)
		local text = self:GetText()
		if InCombatLockdown()then 
			local max = 5;
			if len(text) > max then 
				local testText = true;
				for i = 1, max, 1 do 
					if sub(text, 0 - i, 0 - i)  ~= sub(text, -1 - i, -1 - i) then 
						testText = false;
						break 
					end 
				end;
				if testText then 
					self:Hide()
					return 
				end 
			end 
		end;
		if text:len() < 5 then 
			if text:sub(1, 4) == "/tt " then 
				local name, realm = UnitName("target")
				if name then 
					name = gsub(name, " ", "")
				end;
				if name and not UnitIsSameServer("player", "target") then 
					name = name.."-"..gsub(realm, " ", "")
				end;
				ChatFrame_SendTell(name or L["Invalid Target"], ChatFrame1)
			end;
			if text:sub(1, 4) == "/gr " then 
				self:SetText(MOD:GetGroupDistribution()..text:sub(5))
				ChatEdit_ParseText(self, 0)
			end 
		end;
		local result, ct = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)|k", "%2 %3")
		if ct > 0 then 
			result = result:gsub("|", "")
			self:SetText(result)
		end 
	end

	local function _repositionDockedTabs()
		local lastTab = TabsList[1];
		if(lastTab) then
			lastTab:ClearAllPoints()
			lastTab:Point("LEFT",SuperDockChatTabBar,"LEFT",3,0);
		end
		for chatID,frame in pairs(TabsList) do
			if(frame and chatID ~= 1 and frame.isDocked) then
				frame:ClearAllPoints()
				if(not lastTab) then
					frame:Point("LEFT",SuperDockChatTabBar,"LEFT",3,0);
				else
					frame:Point("LEFT",lastTab,"RIGHT",6,0);
				end
				lastTab = frame
			end
		end
	end;

	local function _removeTab(frame,chat)
		if(not frame or not frame.chatID) then return end;
		local name = frame:GetName();
		if(not TabSafety[name]) then return end;
		TabSafety[name] = false;
		local chatID = frame.chatID;
		if(TabsList[chatID]) then
			TabsList[chatID] = nil;
		end
		frame:SetParent(chat)
		if(chatID ~= 1) then
			frame:ClearAllPoints()
			frame:Point("TOPLEFT",chat,"BOTTOMLEFT",0,0)
		end
		_repositionDockedTabs()
	end

	local function _addTab(frame,chatID)
		local name = frame:GetName();
		if(TabSafety[name]) then return end;
		TabSafety[name] = true;
		TabsList[chatID] = frame
	    frame.chatID = chatID;
	    frame:SetParent(SuperDockChatTabBar)
	    _repositionDockedTabs()
	end

	local function _customTab(tab, chatID, enabled)
		if(tab.IsStyled) then return end;
		local tabName = tab:GetName();
		local tabSize = SuperDockChatTabBar.currentSize;
		local tabText = tab.text:GetText() or "Chat "..chatID;

		local holder = CreateFrame("Frame",("SVUI_ChatTab%s"):format(chatID),SuperDockChatTabBar)
		holder:SetWidth(tabSize * 1.75)
		holder:SetHeight(tabSize)
		tab.chatID = chatID;
		tab:SetParent(holder)
		tab:ClearAllPoints()
		tab:SetAllPoints(holder)
		tab:SetFramedButtonTemplate()
		tab.icon = tab:CreateTexture(nil,"BACKGROUND",nil,3)
		tab.icon:Size(tabSize * 1.25,tabSize)
		tab.icon:Point("CENTER",tab,"CENTER",0,0)
		tab.icon:SetTexture(ICONARTFILE)
		if(tab.conversationIcon) then
			tab.icon:SetGradient("VERTICAL", 0.1, 0.53, 0.65, 0.3, 0.7, 1)
		else
			tab.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		end
		tab.icon:SetAlpha(0.5)
		tab.TText = tabText;
		
		--tab.SetWidth = function()end;
		tab.SetHeight = function()end;
		tab.SetSize = function()end;
		tab.SetParent = function()end;
		tab.ClearAllPoints = function()end;
		tab.SetAllPoints = function()end;
		tab.SetPoint = function()end;

		tab:SetScript("OnEnter", Tab_OnEnter);
		tab:SetScript("OnLeave", Tab_OnLeave);
		tab:SetScript("OnClick", Tab_OnClick);
		tab.IsStyled = true;
		tab.Holder = holder
	end

	local function _modifyChat(chat)
		if(not chat) then return; end
		local chatName = chat:GetName()
		local chatID = chat:GetID();
		local tabName = chatName.."Tab";
		local tabText = _G[chatName.."TabText"]
		local _, fontSize = FCF_GetChatWindowInfo(chatID);
		CHAT_FONTSIZE = fontSize
		chat:SetFont(CHAT_FONT, CHAT_FONTSIZE, CHAT_FONTOUTLINE)
		tabText:SetFont(TAB_FONT, TAB_FONTSIZE, TAB_FONTOUTLINE)
		if(CHAT_FONTOUTLINE ~= 'NONE' )then
			chat:SetShadowColor(0, 0, 0, 0)
			chat:SetShadowOffset(0, 0)
		else
			chat:SetShadowColor(0, 0, 0, 1)
			chat:SetShadowOffset(1, -1)
		end
		if(not chat.InitConfig) then
			local tab = _G[tabName]
			local editBoxName = chatName.."EditBox";
			local editBox = _G[editBoxName]
			-------------------------------------------
			chat:SetFrameLevel(4)
			chat:SetClampRectInsets(0, 0, 0, 0)
			chat:SetClampedToScreen(false)
			chat:Formula409(true)
			_G[chatName.."ButtonFrame"]:MUNG()
			-------------------------------------------
			_G[tabName .."Left"]:SetTexture(nil)
			_G[tabName .."Middle"]:SetTexture(nil)
			_G[tabName .."Right"]:SetTexture(nil)
			_G[tabName .."SelectedLeft"]:SetTexture(nil)
			_G[tabName .."SelectedMiddle"]:SetTexture(nil)
			_G[tabName .."SelectedRight"]:SetTexture(nil)
			_G[tabName .."HighlightLeft"]:SetTexture(nil)
			_G[tabName .."HighlightMiddle"]:SetTexture(nil)
			_G[tabName .."HighlightRight"]:SetTexture(nil)

			tab.text = _G[chatName.."TabText"]
			tab.text:SetTextColor(1, 1, 1)
			tab.text:SetShadowColor(0, 0, 0)
			tab.text:SetShadowOffset(2, -2)
			tab.text:FillInner(tab)
			tab.text:SetJustifyH("CENTER")
			tab.text:SetJustifyV("MIDDLE")
			NewHook(tab.text, "SetTextColor", _hook_TabTextColor)
			if tab.conversationIcon then 
				tab.conversationIcon:ClearAllPoints()
				tab.conversationIcon:Point("RIGHT", tab.text, "LEFT", -1, 0)
			end;
			if(TAB_SKINS and not tab.IsStyled) then
				local arg3 = (chat.inUse or chat.isDocked or chat.isTemporary)
				_customTab(tab, chatID, arg3)
			else
				tab:SetHeight(TAB_HEIGHT)
				tab:SetWidth(TAB_WIDTH)
				tab.SetWidth = function()return end;
			end
			-------------------------------------------
			local ebPoint1, ebPoint2, ebPoint3 = select(6, editBox:GetRegions())
			ebPoint1:MUNG()
			ebPoint2:MUNG()
			ebPoint3:MUNG()
			_G[editBoxName.."FocusLeft"]:MUNG()
			_G[editBoxName.."FocusMid"]:MUNG()
			_G[editBoxName.."FocusRight"]:MUNG()
			editBox:SetFixedPanelTemplate("Button", true)
			editBox:SetAltArrowKeyMode(false)
			editBox:SetAllPoints(SuperDockAlertLeft)
			editBox:HookScript("OnEditFocusGained", EditBox_OnEditFocusGained)
			editBox:HookScript("OnEditFocusLost", EditBox_OnEditFocusLost)
			editBox:HookScript("OnTextChanged", EditBox_OnTextChanged)
			-------------------------------------------
			chat:SetTimeVisible(100)	
			chat:SetFading(CHAT_FADING)
			chat:SetScript("OnHyperlinkClick", SVUI_OnHyperlinkShow)
			chat.InitConfig = true
		end
	end;

	local function _modifyTab(tab, floating)	
		if(not floating) then
			_G[tab:GetName().."Text"]:Show()
			if tab.owner and tab.owner.button and GetMouseFocus() ~= tab.owner.button then
				tab.owner.button:SetAlpha(1)
			end
			if tab.conversationIcon then
				tab.conversationIcon:Show()
			end
		elseif GetMouseFocus() ~= tab then
			_G[tab:GetName().."Text"]:Hide()
			if tab.owner and tab.owner.button and GetMouseFocus() ~= tab.owner.button then
				tab.owner.button:SetAlpha(1)
			end
			if tab.conversationIcon then 
				tab.conversationIcon:Hide()
			end
		end
	end

	function MOD:UpdateUpvalues(throttle)
		CHAT_WIDTH = (SuperVillain.db.SVDock.dockLeftWidth or 350) - 10;
		CHAT_HEIGHT = (SuperVillain.db.SVDock.dockLeftHeight or 180) - 15;
		CHAT_THROTTLE = MOD.db.throttleInterval;
		CHAT_ALLOW_URL = MOD.db.url;
		CHAT_HOVER_URL = MOD.db.hyperlinkHover;
		CHAT_STICKY = MOD.db.sticky;
		CHAT_FONT = LSM:Fetch("font", MOD.db.font);
		CHAT_FONTSIZE = SuperVillain.db.media.fonts.size or 12;
		CHAT_FONTOUTLINE = MOD.db.fontOutline;
		TAB_WIDTH = MOD.db.tabWidth;
		TAB_HEIGHT = MOD.db.tabHeight;
		TAB_SKINS = MOD.db.tabStyled;
		TAB_FONT = LSM:Fetch("font", MOD.db.tabFont);
		TAB_FONTSIZE = MOD.db.tabFontSize;
		TAB_FONTOUTLINE = MOD.db.tabFontOutline;
		CHAT_FADING = MOD.db.fade;
		CHAT_PSST = LSM:Fetch("sound", MOD.db.psst);
		TIME_STAMP_MASK = MOD.db.timeStampFormat;
		if(throttle and throttle == 0) then
			twipe(THROTTLE_CACHE)
		end
	end

	function MOD:RefreshChatFrames(forced)
		if (not SuperVillain.db.SVChat.enable) then return; end
		if ((not forced) and refreshLocked and (IsMouseButtonDown("LeftButton") or InCombatLockdown())) then return; end

		MOD:UpdateUpvalues()

		for i,name in pairs(CHAT_FRAMES)do 
			local chat = _G[name]
			local id = chat:GetID() 
			local tab = _G[name.."Tab"]
			local tabText = _G[name.."TabText"]
			_modifyChat(chat, tabText)
			tab.owner = chat;
			if not chat.isDocked and chat:IsShown() then 
				chat:SetParent(UIParent)
				if(not TAB_SKINS) then
					tab.isDocked = chat.isDocked;
					tab:SetParent(chat)
					_modifyTab(tab, true)
				else
					tab.owner = chat;
					tab.isDocked = false;
					if(tab.Holder) then
						tab.Holder.isDocked = false;
						_removeTab(tab.Holder,chat)
					end
				end
			else 
				if id == 1 then
					chat:ClearAllPoints()
					chat:Width(CHAT_WIDTH - 12)
					chat:Height(CHAT_HEIGHT)
					chat:Point("BOTTOMRIGHT",SuperDockWindowLeft,"BOTTOMRIGHT",-6,10)
					FCF_SavePositionAndDimensions(chat)
				end;
				chat:SetParent(SuperDockWindowLeft)
				if(not TAB_SKINS) then
					tab.owner = chat;
					tab.isDocked = chat.isDocked;
					tab:SetParent(SuperDockChatTabBar)
					_modifyTab(tab, false)
				else
					tab.owner = chat;
					tab.isDocked = true;
					local arg3 = (chat.inUse or chat.isDocked or chat.isTemporary)
					if(tab.Holder and arg3) then
						tab.Holder.isDocked = true;
						_addTab(tab.Holder,id)
					end
				end
				if chat:IsMovable()then 
					chat:SetUserPlaced(true)
				end 
			end 
		end;
		refreshLocked = true 
	end
end;

function MOD:PET_BATTLE_CLOSE()
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame and _G[frameName.."Tab"]:GetText():match(PET_BATTLE_COMBAT_LOG) then
			FCF_Close(frame)
		end
	end
end

do
	local _linkTokens = {
		['item'] = true,
		['spell'] = true,
		['unit'] = true,
		['quest'] = true,
		['enchant'] = true,
		['achievement'] = true,
		['instancelock'] = true,
		['talent'] = true,
		['glyph'] = true,
	}

	local _hook_FCFOnMouseScroll = function(self, delta)
		if(IsShiftKeyDown()) then
			if(delta > 0) then
				self:ScrollToTop()
			else
				self:ScrollToBottom()
			end
		end
	end

	local _hook_ChatEditOnEnterKey = function(self, input)
		local ctype = self:GetAttribute("chatType");
		local attr = (not CHAT_STICKY) and "SAY" or ctype;
		local chat = self:GetParent();
		if not chat.isTemporary and ChatTypeInfo[ctype].sticky == 1 then
			self:SetAttribute("chatType", attr);
		end
	end

	local _hook_ChatFontUpdate = function(self, chat, size)
		if ( not chat ) then
			chat = FCF_GetCurrentChatFrame();
		end
		if ( not size ) then
			size = self.value or CHAT_FONTSIZE;
		end
		chat:SetFont(CHAT_FONT, size, CHAT_FONTOUTLINE)
		if(CHAT_FONTOUTLINE ~= 'NONE' )then
			chat:SetShadowColor(0, 0, 0, 0)
			chat:SetShadowOffset(0, 0)
		else
			chat:SetShadowColor(0, 0, 0, 1)
			chat:SetShadowOffset(1, -1)
		end
	end

	local _hook_GDMFrameSetPoint = function(self)
		self:SetAllPoints(SuperDockChatTabBar)
	end

	local _hook_GDMScrollSetPoint = function(self, point, anchor, attachTo, x, y)
		if anchor == GeneralDockManagerOverflowButton and x == 0 and y == 0 then
			self:SetPoint(point, anchor, attachTo, -2, -6)
		end
	end

	local _hook_OnHyperlinkEnter = function(self, refString)
		if(not CHAT_HOVER_URL or InCombatLockdown()) then return; end
		local token = refString:match("^([^:]+)")
		if _linkTokens[token] then
			ShowUIPanel(GameTooltip)
			GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(refString)
			ActiveHyperLink = self;
			GameTooltip:Show()
		end
	end

	local _hook_OnHyperlinkLeave = function(self, refString)
		if(not CHAT_HOVER_URL) then return; end
		local token = refString:match("^([^:]+)")
		if _linkTokens[token] then
			HideUIPanel(GameTooltip)
			ActiveHyperLink = nil;
		end
	end

	local _hook_OnMessageScrollChanged = function(self)
		if(not CHAT_HOVER_URL) then return; end
		if(ActiveHyperLink == self) then
			HideUIPanel(GameTooltip)
			ActiveHyperLink = false;
		end
	end

	local _hook_TabOnEnter = function(self)
		--_G[self:GetName().."Text"]:Show()
		if self.conversationIcon then
			self.conversationIcon:Show()
		end
	end

	local _hook_TabOnLeave = function(self)
		--_G[self:GetName().."Text"]:Hide()
		if self.conversationIcon then
			self.conversationIcon:Hide()
		end
	end

	local _hook_OnUpdateHeader = function(editBox)
		local attrib = editBox:GetAttribute("chatType")
		if attrib == "CHANNEL" then 
			local channel = GetChannelName(editBox:GetAttribute("channelTarget"))
			if channel == 0 then 
				editBox:SetBackdropBorderColor(0,0,0)
			else 
				editBox:SetBackdropBorderColor(ChatTypeInfo[attrib..channel].r, ChatTypeInfo[attrib..channel].g, ChatTypeInfo[attrib..channel].b)
			end 
		elseif attrib then 
			editBox:SetBackdropBorderColor(ChatTypeInfo[attrib].r, ChatTypeInfo[attrib].g, ChatTypeInfo[attrib].b)
		end 
	end

	function SetAllChatHooks()
		NewHook('FCF_OpenNewWindow', MOD.RefreshChatFrames)
		NewHook('FCF_UnDockFrame', MOD.RefreshChatFrames)
		NewHook('FCF_DockFrame', MOD.RefreshChatFrames)
		NewHook('FCF_OpenTemporaryWindow', MOD.RefreshChatFrames)
		NewHook('ChatEdit_OnEnterPressed', _hook_ChatEditOnEnterKey)
		NewHook('FCF_SetChatWindowFontSize', _hook_ChatFontUpdate)
		NewHook('FloatingChatFrame_OnMouseScroll', _hook_FCFOnMouseScroll)
		NewHook(GeneralDockManager, 'SetPoint', _hook_GDMFrameSetPoint)
		NewHook(GeneralDockManagerScrollFrame, 'SetPoint', _hook_GDMScrollSetPoint)
		for _, name in pairs(CHAT_FRAMES) do
			local chat = _G[name]
			local tab = _G[name .. "Tab"]
			if(not chat.hookedHyperLinks) then
				chat:HookScript('OnHyperlinkEnter', _hook_OnHyperlinkEnter)
				chat:HookScript('OnHyperlinkLeave', _hook_OnHyperlinkLeave)
				chat:HookScript('OnMessageScrollChanged', _hook_OnMessageScrollChanged)
				tab:HookScript('OnEnter', _hook_TabOnEnter)
				tab:HookScript('OnLeave', _hook_TabOnLeave)
				chat.hookedHyperLinks = true
			end
		end
		NewHook("ChatEdit_UpdateHeader", _hook_OnUpdateHeader)
	end
end;

function MOD:UpdateThisPackage()
	self:RefreshChatFrames(true) 
end;

function MOD:ConstructThisPackage()
	if(not SuperVillain.db.SVChat.enable) then return end;
	self:RegisterEvent('UPDATE_CHAT_WINDOWS', 'RefreshChatFrames')
	self:RegisterEvent('UPDATE_FLOATING_CHAT_WINDOWS', 'RefreshChatFrames')
	self:RegisterEvent('PET_BATTLE_CLOSE')
	SetParseHandlers();
	self:RefreshChatFrames(true)
	_G.GeneralDockManagerOverflowButton:ClearAllPoints()
	_G.GeneralDockManagerOverflowButton:SetPoint('BOTTOMRIGHT', SuperDockChatTabBar, 'BOTTOMRIGHT', -2, 2)
	_G.GeneralDockManagerOverflowButtonList:SetFixedPanelTemplate('Transparent')
	_G.GeneralDockManager:SetAllPoints(SuperDockChatTabBar)
	SetAllChatHooks()
	FriendsMicroButton:MUNG()
	ChatFrameMenuButton:MUNG()
	_G.InterfaceOptionsSocialPanelTimestampsButton:SetAlpha(0)
	_G.InterfaceOptionsSocialPanelTimestampsButton:SetScale(0.000001)
	_G.InterfaceOptionsSocialPanelTimestamps:SetAlpha(0)
	_G.InterfaceOptionsSocialPanelTimestamps:SetScale(0.000001)
	_G.InterfaceOptionsSocialPanelChatStyle:EnableMouse(false)
	_G.InterfaceOptionsSocialPanelChatStyleButton:Hide()
	_G.InterfaceOptionsSocialPanelChatStyle:SetAlpha(0)
end;
SuperVillain.Registry:NewPackage(MOD, "SVChat")