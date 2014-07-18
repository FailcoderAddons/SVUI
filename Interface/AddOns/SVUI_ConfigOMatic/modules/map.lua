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
local MOD = SuperVillain.Registry:Expose('SVMap')
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local textSelect = {
	['HIDE'] = L['Hide This'], 
	['CUSTOM'] = L['Use Custom Style'], 
	['SIMPLE'] = L['Use Simple Style']
};
local colorSelect = {
	['light'] = L['Light'], 
	['dark'] = L['Dark'], 
	['class'] = L['Class']
};
--[[ 
########################################################## 
OPTIONS TABLE
##########################################################
]]--
SuperVillain.Options.args.SVMap = {
	type = 'group',
	childGroups = "tree", 
	name = L['Minimap'],
	get = function(a)return SuperVillain.db.SVMap[a[#a]]end,
	set = function(a,b)MOD:ChangeDBVar(b,a[#a]);MOD:ReLoad()end,
	args={
		intro={
			order = 1,
			type = 'description',
			name = L["Options for the Minimap"]
		},
		enable={
			type = "toggle",
			order = 2,
			name = L['Enable'],
			desc = L['Enable/Disable the Custom Minimap.'],
			get = function(a)return SuperVillain.db.SVMap.enable end,
			set = function(a,b)SuperVillain.db.SVMap.enable=b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		common = {
			order = 3,
			type = "group", 
			name = MINIMAP_LABEL,
			desc = L['General display settings'],
			guiInline = true,
			disabled = function()return not SuperVillain.db.SVMap.enable end,
			args = {
				size = {
					order = 1,
					type = "range",
					name = L["Size"],
					desc = L['Adjust the size of the minimap.'],
					min = 120,
					max = 240,
					width = "full",
					step = 1
				},
				bordersize = {
					order = 2,
					type = "range",
					name = "Border Size",
					desc = "Adjust the size of the minimap's outer border",
					min = 0,
					max = 20,
					step = 1,
					width = "full"
				},
				bordercolor = {
					order = 3,
					type = 'select',
					name = "Border Color",
					desc = "Adjust the color of the minimap's outer border",
					values = colorSelect,
				},
				customshape = {
					order = 4,
					type = "toggle",
					name = "Custom Shape",
					desc = "Toggle the use of either rectangular or square minimap.",
				}
			}
		},
		spacer1 = {
			order = 4,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {} 
		},
		common2 = {
			order = 5,
			type = "group", 
			name = "Labels and Info",
			desc = L['Configure various minimap texts'],
			guiInline = true,
			disabled = function()return not SuperVillain.db.SVMap.enable end,
			args = {
				locationText = {
					order = 1,
					type = "select",
					name = L["Location Text"],
					values = textSelect,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:UpdateMinimapTexts()end
				},
				playercoords = {
					order = 2,
					type = "select",
					name = L["Player Coords"],
					values = textSelect,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:SetMiniMapCoords()end
				}
			}
		},
		spacer2 = {
			order = 6,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {}
		},
		mmButtons = {
			order = 7,
			type = "group",
			name = "Minimap Buttons",
			get = function(j)return SuperVillain.db.SVMap.minimapbar[j[#j]]end,
			guiInline = true,
			disabled = function()return not SuperVillain.db.SVMap.enable end,
			args = {
				enable = {
					order = 1,
					type = 'toggle',
					name = L['Buttons Styled'],
					desc = L['Style the minimap buttons.'],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")SuperVillain:StaticPopup_Show("RL_CLIENT")end,
				},
				mouseover = {
					order = 2, 
					name = L["Mouse Over"], 
					desc = L["Hidden unless you mouse over the frame."], 
					type = "toggle",
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
				},
				styleType = {
					order = 3,
					type = 'select',
					name = L['Button Bar Layout'],
					desc = L['Change settings for how the minimap buttons are styled.'],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
					disabled = function()return not SuperVillain.db.SVMap.minimapbar.enable end,
					values = {
						['NOANCHOR'] = L['No Anchor Bar'],
						['HORIZONTAL'] = L['Horizontal Anchor Bar'],
						['VERTICAL'] = L['Vertical Anchor Bar']
					}
				},
				buttonSize = {
					order = 4,
					type = 'range',
					name = L['Buttons Size'],
					desc = L['The size of the minimap buttons.'],
					min = 16,
					max = 40,
					step = 1,
					width = "full",
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"minimapbar")MOD:UpdateMinimapButtonSettings()end,
					disabled = function()return not SuperVillain.db.SVMap.minimapbar.enable or SuperVillain.db.SVMap.minimapbar.styleType == 'NOANCHOR'end
				},
			}
		},
		spacer3 = {
			order = 8,
			type = "group", 
			name = "",
			guiInline = true, 
			args = {}
		},
		worldMap = {
			order = 9,
			type = "group",
			name = "WorldMap",
			guiInline = true, 
			args = {
				tinyWorldMap = {
					order = 1,
					type = "toggle",
					name = L["Tiny Map"],
					desc = L["Don't scale the large world map to block out sides of the screen."],
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:UpdateWorldMapConfig()end
				},
				mapAlpha = {
					order = 2,
					name = L['Map Alpha While Moving'],
					desc = L['Controls what the transparency of the worldmap will be set to when you are moving.'],
					type = 'range',
					isPercent = true,
					min = 0,
					max = 1,
					step = 0.01,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a])MOD:UpdateWorldMapConfig()end
				},
			}
		},  
	}
}