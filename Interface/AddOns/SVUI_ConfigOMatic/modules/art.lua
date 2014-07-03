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
SuperVillain.Options.args.SVStyle={
	type = "group", 
	name = L["UI Styling"], 
	childGroups = "tree", 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["ART_DESC"]
		},
		blizzardEnable = {
			order = 2, 
			type = "toggle", 
			name = "Standard UI Styling", 
			get = function(a)return SuperVillain.db.SVStyle.blizzard.enable end, 
			set = function(a,b)SuperVillain.db.SVStyle.blizzard.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		addonEnable = {
			order = 3, 
			type = "toggle", 
			name = "Addon Styling", 
			get = function(a)return SuperVillain.db.SVStyle.addons.enable end, 
			set = function(a,b)SuperVillain.db.SVStyle.addons.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		blizzard = {
			order = 300, 
			type = "group", 
			name = "Individual Mods", 
			get = function(a)return SuperVillain.db.SVStyle.blizzard[a[#a]]end, 
			set = function(a,b)SuperVillain.db.SVStyle.blizzard[a[#a]] = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end, 
			disabled = function()return not SuperVillain.db.SVStyle.blizzard.enable end, 
			guiInline = true, 
			args = {
				bmah = {
					type = "toggle", 
					name = L["Black Market AH"], 
					desc = L["TOGGLEART_DESC"]
				},
					transmogrify = {
					type = "toggle", 
					name = L["Transmogrify Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					encounterjournal = {
					type = "toggle", 
					name = L["Encounter Journal"], 
					desc = L["TOGGLEART_DESC"]
				},
					reforge = {
					type = "toggle", 
					name = L["Reforge Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					calendar = {
					type = "toggle", 
					name = L["Calendar Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					achievement = {
					type = "toggle", 
					name = L["Achievement Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					lfguild = {
					type = "toggle", 
					name = L["LF Guild Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					inspect = {
					type = "toggle", 
					name = L["Inspect Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					binding = {
					type = "toggle", 
					name = L["KeyBinding Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					gbank = {
					type = "toggle", 
					name = L["Guild Bank"], 
					desc = L["TOGGLEART_DESC"]
				},
					archaeology = {
					type = "toggle", 
					name = L["Archaeology Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					guildcontrol = {
					type = "toggle", 
					name = L["Guild Control Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					guild = {
					type = "toggle", 
					name = L["Guild Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					tradeskill = {
					type = "toggle", 
					name = L["TradeSkill Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					raid = {
					type = "toggle", 
					name = L["Raid Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					talent = {
					type = "toggle", 
					name = L["Talent Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					auctionhouse = {
					type = "toggle", 
					name = L["Auction Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					timemanager = {
					type = "toggle", 
					name = L["Time Manager"], 
					desc = L["TOGGLEART_DESC"]
				},
					barber = {
					type = "toggle", 
					name = L["Barbershop Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					macro = {
					type = "toggle", 
					name = L["Macro Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					debug = {
					type = "toggle", 
					name = L["Debug Tools"], 
					desc = L["TOGGLEART_DESC"]
				},
					trainer = {
					type = "toggle", 
					name = L["Trainer Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					socket = {
					type = "toggle", 
					name = L["Socket Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					alertframes = {
					type = "toggle", 
					name = L["Alert Frames"], 
					desc = L["TOGGLEART_DESC"]
				},
					loot = {
					type = "toggle", 
					name = L["Loot Frames"], 
					desc = L["TOGGLEART_DESC"]
				},
					bgscore = {
					type = "toggle", 
					name = L["BG Score"], 
					desc = L["TOGGLEART_DESC"]
				},
					merchant = {
					type = "toggle", 
					name = L["Merchant Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					mail = {
					type = "toggle", 
					name = L["Mail Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					help = {
					type = "toggle", 
					name = L["Help Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					trade = {
					type = "toggle", 
					name = L["Trade Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					gossip = {
					type = "toggle", 
					name = L["Gossip Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					greeting = {
					type = "toggle", 
					name = L["Greeting Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					worldmap = {
					type = "toggle", 
					name = L["World Map"], 
					desc = L["TOGGLEART_DESC"]
				},
					taxi = {
					type = "toggle", 
					name = L["Taxi Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					lfg = {
					type = "toggle", 
					name = L["LFG Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					mounts = {
					type = "toggle", 
					name = L["Mounts & Pets"], 
					desc = L["TOGGLEART_DESC"]
				},
					quest = {
					type = "toggle", 
					name = L["Quest Frames"], 
					desc = L["TOGGLEART_DESC"]
				},
					petition = {
					type = "toggle", 
					name = L["Petition Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					dressingroom = {
					type = "toggle", 
					name = L["Dressing Room"], 
					desc = L["TOGGLEART_DESC"]
				},
					pvp = {
					type = "toggle", 
					name = L["PvP Frames"], 
					desc = L["TOGGLEART_DESC"]
				},
					nonraid = {
					type = "toggle", 
					name = L["Non-Raid Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					friends = {
					type = "toggle", 
					name = L["Friends"], 
					desc = L["TOGGLEART_DESC"]
				},
					spellbook = {
					type = "toggle", 
					name = L["Spellbook"], 
					desc = L["TOGGLEART_DESC"]
				},
					character = {
					type = "toggle", 
					name = L["Character Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					misc = {
					type = "toggle", 
					name = L["Misc Frames"], 
					desc = L["TOGGLEART_DESC"]
				},
					tabard = {
					type = "toggle", 
					name = L["Tabard Frame"], 
					desc = L["TOGGLEART_DESC"]
				},
					guildregistrar = {
					type = "toggle", 
					name = L["Guild Registrar"], 
					desc = L["TOGGLEART_DESC"]
				},
					bags = {
					type = "toggle", 
					name = L["Bags"], 
					desc = L["TOGGLEART_DESC"]
				},
					stable = {
					type = "toggle", 
					name = L["Stable"], 
					desc = L["TOGGLEART_DESC"]
				},
					bgmap = {
					type = "toggle", 
					name = L["BG Map"], 
					desc = L["TOGGLEART_DESC"]
				},
					petbattleui = {
					type = "toggle", 
					name = L["Pet Battle"], 
					desc = L["TOGGLEART_DESC"]
				},
					losscontrol = {
					type = "toggle", 
					name = L["Loss Control"], 
					desc = L["TOGGLEART_DESC"]
				},
					voidstorage = {
					type = "toggle", 
					name = L["Void Storage"], 
					desc = L["TOGGLEART_DESC"]
				},
					itemUpgrade = {
					type = "toggle", 
					name = L["Item Upgrade"], 
					desc = L["TOGGLEART_DESC"]
				}
			}
		}
	}
}