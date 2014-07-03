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
local unpack 	 =  _G.unpack;
local pairs 	 =  _G.pairs;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVChat');
local DOCK = SuperVillain.Registry:Expose('SVDock');
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args.SVChat={
	type = "group", 
	name = L["Chat"], 
	get = function(a)return SuperVillain.db.SVChat[a[#a]]end, 
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]); end, 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["CHAT_DESC"]
		},
		enable = {
			order = 2, 
			type = "toggle", 
			name = L["Enable"], 
			get = function(a)return SuperVillain.db.SVChat.enable end, 
			set = function(a,b)SuperVillain.db.SVChat.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		common = {
			order = 3, 
			type = "group", 
			name = L["General"], 
			guiInline = true, 
			args = {
				sticky = {
					order = 1, 
					type = "toggle", 
					name = L["Sticky Chat"], 
					desc = L["When opening the Chat Editbox to type a message having this option set means it will retain the last channel you spoke in. If this option is turned off opening the Chat Editbox should always default to the SAY channel."]
				},
				saveChats = {
					order = 2, 
					type = "toggle", 
					name = L["Save Chats"], 
					desc = L["Retain chat messages even after logging out."]
				},
				url = {
					order = 3, 
					type = "toggle", 
					name = L["URL Links"], 
					desc = L["Attempt to create URL links inside the chat."],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a]); MOD:UpdateUpvalues(); end
				},
				hyperlinkHover = {
					order = 4, 
					type = "toggle", 
					name = L["Hyperlink Hover"], 
					desc = L["Display the hyperlink tooltip while hovering over a hyperlink."], 
					set = function(a,b)MOD:ChangeDBVar(b,a[#a]); MOD:ToggleHyperlinks(b); end
				},
				smileys = {
					order = 5, 
					type = "toggle", 
					name = L["Emotion Icons"], 
					desc = L["Display emotion icons in chat."]
				},
				tabStyled = {
					order = 6, 
					type = "toggle", 
					name = L["Custom Tab Style"],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a]);SuperVillain:StaticPopup_Show("RL_CLIENT") end, 
				},
				timeStampFormat = {
					order = 7, 
					type = "select", 
					name = TIMESTAMPS_LABEL, 
					desc = OPTION_TOOLTIP_TIMESTAMPS, 
					values = {
						["NONE"] = NONE, 
						["%I:%M "] = "03:27", 
						["%I:%M:%S "] = "03:27:32", 
						["%I:%M %p "] = "03:27 PM", 
						["%I:%M:%S %p "] = "03:27:32 PM", 
						["%H:%M "] = "15:27", 
						["%H:%M:%S "] = "15:27:32"
					}
				},
				psst = {
					order = 9, 
					type = "select", 
					dialogControl = "LSM30_Sound", 
					name = L["Whisper Alert"], 
					disabled = function()return not SuperVillain.db.SVChat.psst end, 
					values = AceGUIWidgetLSMlists.sound,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a]); MOD:UpdateUpvalues(); end
				},
				spacer2 = {
					order = 10, 
					type = "description", 
					name = ""
				},
				throttleInterval = {
					order = 11, 
					type = "range", 
					name = L["Spam Interval"], 
					desc = L["Prevent the same messages from displaying in chat more than once within this set amount of seconds, set to zero to disable."], 
					min = 0, 
					max = 120, 
					step = 1,
					width = "full",
					set = function(a,b)MOD:ChangeDBVar(b,a[#a]); MOD:UpdateUpvalues(b); end
				},
			}
		},
		fontGroup = {
			order = 4, 
			type = "group", 
			guiInline = true, 
			name = L["Fonts"], 
			set = function(a,b)MOD:ChangeDBVar(b,a[#a]);MOD:RefreshChatFrames()end, 
			args = {
				font = {
					type = "select", 
					dialogControl = "LSM30_Font", 
					order = 1, 
					name = L["Font"], 
					values = AceGUIWidgetLSMlists.font
				},
				fontOutline = {
					order = 2, 
					name = L["Font Outline"], 
					desc = L["Set the font outline."], 
					type = "select", 
					values = {
						["NONE"] = L["None"], 
						["OUTLINE"] = "OUTLINE", 
						["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
						["THINOUTLINE"] = "THINOUTLINE",
						["THICKOUTLINE"] = "THICKOUTLINE"
					}
				},
				fontSpacer = {
					type = "description", 
					order = 3, 
					name = "", 
				},
				tabFont = {
					type = "select", 
					dialogControl = "LSM30_Font", 
					order = 4, 
					name = L["Tab Font"], 
					values = AceGUIWidgetLSMlists.font
				},
				tabFontSize = {
					order = 5, 
					name = L["Tab Font Size"], 
					type = "range", 
					min = 6, 
					max = 22, 
					step = 1
				},
				tabFontOutline = {
					order = 6, 
					name = L["Tab Font Outline"], 
					desc = L["Set the font outline."], 
					type = "select", 
					values = {
						["NONE"] = L["None"], 
						["OUTLINE"] = "OUTLINE", 
						["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", 
						["THICKOUTLINE"] = "THICKOUTLINE"
					}
				}
			}
		}
	}
}