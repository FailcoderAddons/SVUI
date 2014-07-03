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
SuperVillain.Options.args.SVUnit.args.target={
	name=L['Target Frame'],
	type='group',
	order=6,
	childGroups="tab",
	get=function(l)return SuperVillain.db.SVUnit['target'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "target");MOD:SetBasicFrame('target')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('target')SuperVillain:ResetMovables('Target Frame')end},
		tabGroups={
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args={
				commonGroup = {
					order = 1,
					type = 'group',
					name = L['General Settings'],
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
									func = function()local U = SVUI_Target;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("target")end
								},
								smartAuraDisplay = {
									type = "select",
									name = L["Smart Auras"],
									desc = L["When set the Buffs and Debuffs will toggle being displayed depending on if the unit is friendly or an enemy. This will not effect the aurabars package."],
									order = 2,
									values = {
										["DISABLED"] = L["Disabled"],
										["SHOW_DEBUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Debuffs"],
										["SHOW_BUFFS_ON_FRIENDLIES"] = L["Friendlies: Show Buffs"]
									}
								},
								predict = {
									order = 3,
									name = L["Heal Prediction"],
									desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."],
									type = "toggle"
								},
								hideonnpc = {
									type = "toggle",
									order = 4,
									name = L["Text Toggle On NPC"],
									desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
									get = function(l)return SuperVillain.db.SVUnit["target"]["power"].hideonnpc end,
									set = function(l, m)SuperVillain.db.SVUnit["target"]["power"].hideonnpc = m;MOD:SetBasicFrame("target")end
								},
								threatEnabled = {
									type = "toggle",
									order = 5,
									name = L["Show Threat"]
								},
								middleClickFocus = {
									order = 6,
									name = L["Middle Click - Set Focus"],
									desc = L["Middle clicking the unit frame will cause your focus to match the unit."],
									type = "toggle",
									disabled = function()return IsAddOnLoaded("Clique")end
								},

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
									set = function(l, m)
										if SuperVillain.db.SVUnit["target"].castbar.width == SuperVillain.db.SVUnit["target"][l[#l]] then 
											SuperVillain.db.SVUnit["target"].castbar.width = m 
										end;
										MOD:ChangeDBVar(m, l[#l], "target");
										MOD:SetBasicFrame("target")
									end
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
						}
					}
				},
				combobar = {
					order = 800,
					type = "group",
					name = L["Combobar"],
					get = function(l)return SuperVillain.db.SVUnit["target"]["combobar"][l[#l]]end,
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "target", "combobar");MOD:SetBasicFrame("target")end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = L["Enable"]
						},
						smallIcons = {
							type = "toggle",
							name = L["Small Points"],
							order = 2
						},
						height = {
							type = "range",
							order = 3,
							name = L["Height"],
							min = 15,
							max = 45,
							step = 1
						},
						autoHide = {
							type = "toggle",
							name = L["Auto-Hide"],
							order = 4
						}
					}
				},
				misc = ns:SetMiscConfigGroup(false, MOD.SetBasicFrame, "target"),
				health = ns:SetHealthConfigGroup(false, MOD.SetBasicFrame, "target"), 
				power = ns:SetPowerConfigGroup(true, MOD.SetBasicFrame, "target"), 
				name = ns:SetNameConfigGroup(MOD.SetBasicFrame, "target"), 
				portrait = ns:SetPortraitConfigGroup(MOD.SetBasicFrame, "target"), 
				buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "target"), 
				debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "target"), 
				castbar = ns:SetCastbarConfigGroup(MOD.SetBasicFrame, "target"), 
				aurabar = ns:SetAurabarConfigGroup(false, MOD.SetBasicFrame, "target"), 
				icons = ns:SetIconConfigGroup(MOD.SetBasicFrame, "target")
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SuperVillain.Options.args.SVUnit.args.targettarget={
	name=L['TargetTarget Frame'],
	type='group',
	order=7,
	childGroups="tab",
	get=function(l)return SuperVillain.db.SVUnit['targettarget'][l[#l]]end,
	set=function(l,m)MOD:ChangeDBVar(m, l[#l], "targettarget");MOD:SetBasicFrame('targettarget')end,
	args={
		enable={type='toggle',order=1,name=L['Enable']},
		resetSettings={type='execute',order=2,name=L['Restore Defaults'],func=function(l,m)MOD:ResetUnitOptions('targettarget')SuperVillain:ResetMovables('TargetTarget Frame')end},
		tabGroups={
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args={
				commonGroup = {
					order = 1,
					type = 'group',
					name = L['General Settings'],
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
									func = function()local U = SVUI_TargetTarget;if U.forceShowAuras then U.forceShowAuras = nil else U.forceShowAuras = true end;MOD:SetBasicFrame("targettarget")end
								},
								spacer1 = {
									order = 2,
									type = "description", 
									name = "",
								},
								rangeCheck = {
									order = 3,
									name = L["Range Check"],
									desc = L["Check if you are in range to cast spells on this specific unit."],
									type = "toggle"
								},
								hideonnpc = {
									type = "toggle",
									order = 4,
									name = L["Text Toggle On NPC"],
									desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."],
									get = function(l)return SuperVillain.db.SVUnit["target"]["power"].hideonnpc end,
									set = function(l, m)SuperVillain.db.SVUnit["target"]["power"].hideonnpc = m;MOD:SetBasicFrame("target")end
								},
								threatEnabled = {
									type = "toggle",
									order = 5,
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
						}
					}
				},
				misc = ns:SetMiscConfigGroup(false, MOD.SetBasicFrame, "targettarget"),
				health = ns:SetHealthConfigGroup(false, MOD.SetBasicFrame, "targettarget"), 
				power = ns:SetPowerConfigGroup(nil, MOD.SetBasicFrame, "targettarget"), 
				name = ns:SetNameConfigGroup(MOD.SetBasicFrame, "targettarget"), 
				portrait = ns:SetPortraitConfigGroup(MOD.SetBasicFrame, "targettarget"), 
				buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetBasicFrame, "targettarget"), 
				debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetBasicFrame, "targettarget"), 
				icons = ns:SetIconConfigGroup(MOD.SetBasicFrame, "targettarget")
			}
		}
	}
}