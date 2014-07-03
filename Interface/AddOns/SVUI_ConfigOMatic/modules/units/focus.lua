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
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.focus = {
	name = L["Focus Frame"], 
	type = "group", 
	order = 9, 
	childGroups = "tab", 
	get = function(l)return SuperVillain.db.SVUnit["focus"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focus");MOD:SetBasicFrame("focus")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focus");SuperVillain:ResetMovables("Focus Frame")end}, 
		tabGroups = {
			order = 3, 
			type = "group", 
			name = L["Unit Options"], 
			childGroups = "tree", 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					name = L["General Settings"], 
					args = {
						baseGroup = {
							order = 1, 
							type = "group", 
							guiInline = true, 
							name = L["Base Settings"],
							args = {
								showAuras = {
									order = 1, 
									type = "execute",
									name = L["Show Auras"], 
									func = function()local U = SVUI_Focus;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("focus")end
								},
								smartAuraDisplay = {
									type = "select", 
									name = L["Smart Auras"], 
									desc = L["When set the Buffs and Debuffs will toggle being displayed depending on if the unit is friendly or an enemy. This will not effect the aurabars package."], 
									order = 2, 
									values = {["DISABLED"] = L["Disabled"], ["SHOW_DEBUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Debuffs"], ["SHOW_BUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Buffs"]}
								},
								rangeCheck = {
									order = 3, 
									name = L["Range Check"], 
									desc = L["Check if you are in range to cast spells on this specific unit."], 
									type = "toggle"
								}, 
								predict = {
									order = 4, 
									name = L["Heal Prediction"], 
									desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
									type = "toggle"
								}, 
								hideonnpc = {
									type = "toggle", 
									order = 5, 
									name = L["Text Toggle On NPC"], 
									desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
									get = function(l)return SuperVillain.db.SVUnit["focus"]["power"].hideonnpc end, 
									set = function(l, m)SuperVillain.db.SVUnit["focus"]["power"].hideonnpc = m;MOD:SetBasicFrame("focus")end
								},  
								threatEnabled = {
									type = "toggle", 
									order = 6, 
									name = L["Show Threat"]
								}
							}
						},
						sizeGroup = {
							order = 2, 
							guiInline = true, 
							type = "group", 
							name = L["Size Settings"], 
							args = {
								width = {
									order = 1,
									name = L["Width"],
									type = "range",
									width = "full",
									min = 50,
									max = 500,
									step = 1,
								},
								height = {
									order = 2,
									name = L["Height"],
									type = "range",
									width = "full",
									min = 10,
									max = 250,
									step = 1
								},
							}
						},
					}
				}, 
				misc = ns:SetMiscConfigGroup(false, MOD.SetBasicFrame, "focus"),
				health = ns:SetHealthConfigGroup(false, MOD.SetBasicFrame, "focus"), 
				power = ns:SetPowerConfigGroup(nil, MOD.SetBasicFrame, "focus"), 
				name = ns:SetNameConfigGroup(MOD.SetBasicFrame, "focus"), 
				buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "focus"), 
				debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "focus"), 
				castbar = ns:SetCastbarConfigGroup(MOD.SetBasicFrame, "focus"), 
				aurabar = ns:SetAurabarConfigGroup(false, MOD.SetBasicFrame, "focus"), 
				icons = ns:SetIconConfigGroup(MOD.SetBasicFrame, "focus")
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.focustarget = {
	name = L["FocusTarget Frame"], 
	type = "group", 
	order = 10, 
	childGroups = "tab", 
	get = function(l)return SuperVillain.db.SVUnit["focustarget"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "focustarget");MOD:SetBasicFrame("focustarget")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("focustarget")SuperVillain:ResetMovables("FocusTarget Frame")end}, 
		tabGroups = {
			order = 3, 
			type = "group", 
			name = L["Unit Options"], 
			childGroups = "tree", 
			args = {
				commonGroup = {
					order = 1, 
					type = "group", 
					name = L["General Settings"], 
					args = {
						baseGroup = {
							order = 1, 
							type = "group", 
							guiInline = true, 
							name = L["Base Settings"],
							args = {
								showAuras = {order = 1, type = "execute", name = L["Show Auras"], func = function()local U = SVUI_FocusTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("focustarget")end}, 
								spacer1 = {
									order = 2,
									type = "description", 
									name = "",
								},
								rangeCheck = {order = 3, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
								hideonnpc = {type = "toggle", order = 4, name = L["Text Toggle On NPC"], desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], get = function(l)return SuperVillain.db.SVUnit["focustarget"]["power"].hideonnpc end, set = function(l, m)SuperVillain.db.SVUnit["focustarget"]["power"].hideonnpc = m;MOD:SetBasicFrame("focustarget")end}, 
								threatEnabled = {type = "toggle", order = 5, name = L["Show Threat"]}
							}
						},
						sizeGroup = {
							order = 2, 
							guiInline = true, 
							type = "group", 
							name = L["Size Settings"], 
							args = {
								width = {order = 1, width = "full", name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
								height = {order = 2, width = "full", name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
							}
						},
					}
				},
				misc = ns:SetMiscConfigGroup(false, MOD.SetBasicFrame, "focustarget"),
				health = ns:SetHealthConfigGroup(false, MOD.SetBasicFrame, "focustarget"), 
				power = ns:SetPowerConfigGroup(false, MOD.SetBasicFrame, "focustarget"), 
				name = ns:SetNameConfigGroup(MOD.SetBasicFrame, "focustarget"), 
				buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "focustarget"), 
				debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "focustarget"), 
				icons = ns:SetIconConfigGroup(MOD.SetBasicFrame, "focustarget")
			}
		}
	}
}