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
local MOD = SuperVillain.Registry:Expose('SVAura');
local MAP = SuperVillain.Registry:Expose("SVMap");
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
local auraOptionsTemplate = {
	scaleGroup = {
		order = 1, 
		guiInline = true, 
		type = "group", 
		name = L["Scale Options"], 
		args = {
			size = {
				type = "range", 
				name = L["Size"], 
				desc = L["Set the size of the individual auras."], 
				min = 16, 
				max = 60, 
				step = 2, 
				order = 1
			},
			wrapXOffset = {
				order = 2, 
				type = "range", 
				name = L["Horizontal Spacing"], 
				min = 0, 
				max = 50, 
				step = 1
			},
			wrapYOffset = {
				order = 3, 
				type = "range", 
				name = L["Vertical Spacing"], 
				min = 0, 
				max = 50, 
				step = 1
			},
		}
	},
	layoutGroup = {
		order = 2, 
		guiInline = true, 
		type = "group", 
		name = L["Directional Options"], 
		args = {
			showBy = {
				type = "select", 
				order = 1, 
				name = L["Growth Direction"], 
				desc = L["The direction the auras will grow and then the direction they will grow after they reach the wrap after limit."], 
				values = {
					DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]), 
					DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]), 
					UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]), 
					UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]), 
					RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]), 
					RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]), 
					LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]), 
					LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"])
				}
			},
			wrapAfter = {
				type = "range", 
				order = 2, 
				name = L["Wrap After"], 
				desc = L["Begin a new row or column after this many auras."], 
				min = 1, 
				max = 32, 
				step = 1
			},
			maxWraps = {
				name = L["Max Wraps"], 
				order = 3, 
				desc = L["Limit the number of rows or columns."], 
				type = "range", 
				min = 1, 
				max = 32, 
				step = 1
			},
		}
	},
	sortGroup = {
		order = 1, 
		guiInline = true, 
		type = "group", 
		name = L["Sorting Options"], 
		args = {
			sortMethod = {
				order = 1, 
				name = L["Sort Method"], 
				desc = L["Defines how the group is sorted."], 
				type = "select", 
				values = {
					["INDEX"] = L["Index"], 
					["TIME"] = L["Time"], 
					["NAME"] = L["Name"]
				}
			},
			sortDir = {
				order = 2, 
				name = L["Sort Direction"], 
				desc = L["Defines the sort order of the selected sort method."], 
				type = "select", 
				values = {
					["+"] = L["Ascending"], 
					["-"] = L["Descending"]
				}
			},
			isolate = {
				order = 3, 
				name = L["Seperate"], 
				desc = L["Indicate whether buffs you cast yourself should be separated before or after."], 
				type = "select", 
				values = {
					[-1] = L["Other's First"], 
					[0] = L["No Sorting"], 
					[1] = L["Your Auras First"]
				}
			}
		}
	},
}
	
SuperVillain.Options.args.SVAura = {
	type = "group", 
	name = BUFFOPTIONS_LABEL, 
	childGroups = "tab", 
	get = function(a)return SuperVillain.db.SVAura[a[#a]]end,
	set = function(a,b)
		MOD:ChangeDBVar(b,a[#a]);
		MOD:UpdateHeader(SVUI_PlayerBuffs)
		MOD:UpdateHeader(SVUI_PlayerDebuffs)
	end,
	args = {
		intro = {
			order = 1, 
			type = "description", 
			name = L["AURAS_DESC"]
		},
		enable = {
			order = 2, 
			type = "toggle", 
			name = L["Enable"],
			get = function(a)return SuperVillain.db.SVAura.enable end,
			set = function(a,b)SuperVillain.db.SVAura.enable = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		disableBlizzard = {
			order = 3, 
			type = "toggle", 
			name = L["Disabled Blizzard"],
			get = function(a)return SuperVillain.db.SVAura.disableBlizzard end,
			set = function(a,b)SuperVillain.db.SVAura.disableBlizzard = b;SuperVillain:StaticPopup_Show("RL_CLIENT")end
		},
		auraGroups = {
			order = 4, 
			type = "group", 
			name = L["Options"], 
			childGroups = "tree", 
			args = {
				common = {
					order = 10, 
					type = "group", 
					name = L["General"], 
					args = {
						fadeBy = {
							type = "range", 
							name = L["Fade Threshold"], 
							desc = L["Threshold before text changes red, goes into decimal form, and the icon will fade. Set to -1 to disable."], 
							min = -1, 
							max = 30, 
							step = 1, 
							order = 1
						},
						font = {
							type = "select", 
							dialogControl = "LSM30_Font", 
							order = 2, 
							name = L["Font"], 
							values = AceGUIWidgetLSMlists.font
						},
						fontSize = {
							order = 3, 
							name = L["Font Size"], 
							type = "range", 
							min = 6, 
							max = 22, 
							step = 1
						},
						fontOutline = {
							order = 4, 
							name = L["Font Outline"], 
							desc = L["Set the font outline."], 
							type = "select", 
							values = {
								["NONE"] = L["None"], 
								["OUTLINE"] = "OUTLINE", 
								["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE", 
								["THICKOUTLINE"] = "THICKOUTLINE"
							}
						},
						timeOffsetH = {
							order = 5, 
							name = L["Time xOffset"], 
							type = "range", 
							min = -60, 
							max = 60, 
							step = 1
						},
						timeOffsetV = {
							order = 6, 
							name = L["Time yOffset"], 
							type = "range", 
							min = -60, 
							max = 60, 
							step = 1
						},
						countOffsetH = {
							order = 7, 
							name = L["Count xOffset"], 
							type = "range", 
							min = -60, 
							max = 60, 
							step = 1
						},
						countOffsetV = {
							order = 8, 
							name = L["Count yOffset"], 
							type = "range", 
							min = -60, 
							max = 60, 
							step = 1
						}
					}
				},
				hyperBuffs = {
					order = 20, 
					type = "group", 
					name = L["Hyper Buffs"], 
					get = function(b)return SuperVillain.db.SVAura.hyperBuffs[b[#b]]end,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"hyperBuffs");MOD:ToggleConsolidatedBuffs();MAP:UpdateThisPackage();MOD:UpdateHeader(SVUI_PlayerBuffs)end,
					args = {
						enable = {
							order = 1, 
							type = "toggle", 
							name = L["Enable"], 
							desc = L["Display the consolidated buffs bar."],
							disabled = function()return not SuperVillain.db.SVMap.enable end,
						},
						filter = {
							order = 2, 
							name = L["Filter Hyper"], 
							desc = L["Only show consolidated icons on the consolidated bar that your class/spec is interested in. This is useful for raid leading."], 
							type = "toggle",
							disabled = function()return not SuperVillain.db.SVAura.hyperBuffs.enable end,
						}
					}
				},
				buffs = {
					order = 30, 
					type = "group", 
					name = L["Buffs"], 
					get = function(b)return SuperVillain.db.SVAura.buffs[b[#b]]end,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"buffs");MOD:UpdateHeader(SVUI_PlayerBuffs)end,
					args = auraOptionsTemplate
				},
				debuffs = {
					order = 40, 
					type = "group", 
					name = L["Debuffs"], 
					get = function(b)return SuperVillain.db.SVAura.debuffs[b[#b]]end,
					set = function(a,b)MOD:ChangeDBVar(b,a[#a],"debuffs");MOD:UpdateHeader(SVUI_PlayerDebuffs)end,
					args = auraOptionsTemplate
				}
			}
		},
	}
}
	