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
local string 	= _G.string;
local table 	 =  _G.table;
local upper = string.upper;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStats');
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args.SVStats = {
	type = "group", 
	name = L["Statistics"], 
	childGroups = "tab", 
	get = function(i)return SuperVillain.db.SVStats[i[#i]]end, 
	set = function(i, h)MOD:ChangeDBVar(h, i[#i]);MOD:Generate()end, 
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["STATS_DESC"]
		}, 
		time24 = {
			order = 2, 
			type = "toggle", 
			name = L["24-Hour Time"], 
			desc = L["Toggle 24-hour mode for the time datatext."]
		}, 
		localtime = {order = 3, type = "toggle", name = L["Local Time"], desc = L["If not set to true then the server time will be displayed instead."]}, 
		battleground = {order = 4, type = "toggle", name = L["Battleground Texts"], desc = L["When inside a battleground display personal scoreboard information on the main datatext bars."]}, 
		topLeftDockPanel = {
			order = 6, 
			name = "Top Left Dock", 
			desc = L["Display statistics along the top of the screen"], 
			type = "toggle"
		}, 
		bottomLeftDockPanel = {
			order = 7, 
			name = "Bottom Left", 
			desc = L["Display statistics along the bottom of the screen"], 
			type = "toggle"
		}, 
		bottomRightDockPanel = {
			order = 8, 
			name = "Bottom Right", 
			desc = L["Display statistics along the bottom of the screen"], 
			type = "toggle"
		}, 
		panels = {
			type = "group", 
			name = L["Panels"], 
			order = 100, 
			args = {}, 
			guiInline = true
		}, 
		fontGroup = {
			order = 120, 
			type = "group", 
			guiInline = true, 
			name = L["Fonts"], 
			set = function(i, h)MOD:ChangeDBVar(h, i[#i]);MOD:Generate()end, 
			args = {
				font = {
					type = "select", 
					dialogControl = "LSM30_Font", 
					order = 4, 
					name = L["Font"], 
					values = AceGUIWidgetLSMlists.font
				}, 
				fontSize = {
					order = 5, 
					name = L["Font Size"], 
					type = "range", 
					min = 6, 
					max = 22, 
					step = 1
				}, 
				fontOutline = {
					order = 6, 
					name = L["Font Outline"], 
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

do
	local statValues = {}

	for name,b in pairs(MOD.Statistics)do 
		statValues[name]=name 
	end;
	statValues[''] = NONE;
	local options = SuperVillain.Options.args.SVStats.args.panels.args;
	local d = 0;
	for e,f in pairs(SuperVillain.db.SVStats.panels)do 
		d = d + 1;
		if not _G[e] then 
			options[e] = nil;
			return 
		end;
		if type(f) == 'table' then 
			options[e] = {
				type = 'group',
				args = {},
				name = L[e] or e,
				guiInline = true,
				order = (d + 10)
			}
			for g,h in pairs(f)do 
				options[e].args[g] = {
					type = 'select',
					name = L[g] or upper(g),
					values = statValues,
					get = function(i)return SuperVillain.db.SVStats.panels[e][i[#i]] end,
					set = function(i,h) MOD:ChangeDBVar(h, i[#i], "panels", e); MOD:Generate() end
				}
			end 
		end 
	end 
end;