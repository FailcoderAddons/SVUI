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
local SV = SVUI;
local L = LibStub("LibSuperVillain-1.0"):Lang();
local MOD = SV.SVUnit
if(not MOD) then return end 
local _, ns = ...
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.boss = {
	name = L["Boss Frames"], 
	type = "group", 
	order = 1000, 
	childGroups = "tab", 
	get = function(l)return SV.db.SVUnit["boss"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "boss");MOD:SetEnemyFrames("boss", MAX_BOSS_FRAMES)end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]},
		displayFrames = {type = "execute", order = 2, name = L["Display Frames"], desc = L["Force the frames to show, they will act as if they are the player frame."], func = function()MOD:SwapElement("boss", 4)end}, 
		resetSettings = {type = "execute", order = 3, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("boss")SV:ResetMovables("Boss Frames")end}, 
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
								showBy = {order = 1, name = L["Growth Direction"], type = "select", values = {["UP"] = L["Up"], ["DOWN"] = L["Down"]}},
								spacer1 = {
									order = 2,
									type = "description", 
									name = "",
								},
								rangeCheck = {order = 3, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
								hideonnpc = {type = "toggle", order = 4, name = L["Text Toggle On NPC"], desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], get = function(l)return SV.db.SVUnit["boss"]["power"].hideonnpc end, set = function(l, m)SV.db.SVUnit["boss"]["power"].hideonnpc = m;MOD:SetEnemyFrames("boss")end}, 
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
				misc = ns:SetMiscConfigGroup(false, MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES),
				health = ns:SetHealthConfigGroup(false, MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				power = ns:SetPowerConfigGroup(false, MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				name = ns:SetNameConfigGroup(MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				portrait = ns:SetPortraitConfigGroup(MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				buffs = ns:SetAuraConfigGroup(true, "buffs", false, MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				debuffs = ns:SetAuraConfigGroup(true, "debuffs", false, MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				castbar = ns:SetCastbarConfigGroup(MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES), 
				icons = ns:SetIconConfigGroup(MOD.SetEnemyFrames, "boss", MAX_BOSS_FRAMES)
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.arena = {
	name = L["Arena Frames"], 
	type = "group", 
	order = 1100, 
	childGroups = "tab", 
	get = function(l)return SV.db.SVUnit["arena"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "arena");MOD:SetEnemyFrames("arena", 5)end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		displayFrames = {type = "execute", order = 2, name = L["Display Frames"], desc = L["Force the frames to show, they will act as if they are the player frame."], func = function()MOD:SwapElement("arena", 5)end},
		resetSettings = {type = "execute", order = 3, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("arena")SV:ResetMovables("Arena Frames")end}, 
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
								showBy = {order = 1, name = L["Growth Direction"], type = "select", values = {["UP"] = L["Up"], ["DOWN"] = L["Down"]}},
								spacer1 = {
									order = 2,
									type = "description", 
									name = "",
								},
								predict = {order = 3, name = L["Heal Prediction"], desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], type = "toggle"}, 
								rangeCheck = {order = 4, name = L["Range Check"], desc = L["Check if you are in range to cast spells on this specific unit."], type = "toggle"}, 
								hideonnpc = {type = "toggle", order = 5, name = L["Text Toggle On NPC"], desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], get = function(l)return SV.db.SVUnit["arena"]["power"].hideonnpc end, set = function(l, m)SV.db.SVUnit["arena"]["power"].hideonnpc = m;MOD:SetEnemyFrames("arena")end}, 
								threatEnabled = {type = "toggle", order = 6, name = L["Show Threat"]}
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
						pvp = {
							order = 3,
							guiInline = true, 
							type = "group", 
							name = L["PVP Indicators"],  
							args = {
								enable = {
									type = "toggle", 
									order = 1, 
									name = L["Enable"],
									get = function(l)return SV.db.SVUnit.arena.pvp.enable end, 
									set = function(l, m)MOD:ChangeDBVar(m, "enable", "arena", "pvp");MOD:SetEnemyFrames("arena", 5)end,
								},
								trinketGroup = {
									order = 2,
									guiInline = true, 
									type = "group", 
									name = L["Trinkets"],
									get = function(l)return SV.db.SVUnit.arena.pvp[l[#l]]end, 
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "arena", "pvp");MOD:SetEnemyFrames("arena", 5)end,
									disabled = function() return not SV.db.SVUnit.arena.pvp.enable end,
									args = {
										trinketPosition = {
											type = "select", 
											order = 1, 
											name = L["Position"], 
											values = {
												["LEFT"] = L["Left"], 
												["RIGHT"] = L["Right"]
											}
										},
										trinketSize = {
											order = 2, 
											type = "range", 
											name = L["Size"], 
											min = 10, 
											max = 60, 
											step = 1
										},
										trinketX = {
											order = 3, 
											type = "range", 
											name = L["xOffset"], 
											min = -60, 
											max = 60, 
											step = 1
										},
										trinketY = {
											order = 4, 
											type = "range", 
											name = L["yOffset"], 
											min = -60, 
											max = 60, 
											step = 1
										}
									}
								},
								specGroup = {
									order = 3,
									guiInline = true, 
									type = "group", 
									name = L["Enemy Specs"],
									get = function(l)return SV.db.SVUnit.arena.pvp[l[#l]]end, 
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "arena", "pvp");MOD:SetEnemyFrames("arena", 5)end,
									disabled = function() return not SV.db.SVUnit.arena.pvp.enable end,
									args = {
										specPosition = {
											type = "select", 
											order = 1, 
											name = L["Position"], 
											values = {
												["LEFT"] = L["Left"], 
												["RIGHT"] = L["Right"]
											}
										},
										specSize = {
											order = 2, 
											type = "range", 
											name = L["Size"], 
											min = 10, 
											max = 60, 
											step = 1
										},
										specX = {
											order = 3, 
											type = "range", 
											name = L["xOffset"], 
											min = -60, 
											max = 60, 
											step = 1
										},
										specY = {
											order = 4, 
											type = "range", 
											name = L["yOffset"], 
											min = -60, 
											max = 60, 
											step = 1
										}
									}
								}
							}
						},
					}
				},
				misc = ns:SetMiscConfigGroup(false, MOD.SetEnemyFrames, "arena", 5),
				health = ns:SetHealthConfigGroup(false, MOD.SetEnemyFrames, "arena", 5), 
				power = ns:SetPowerConfigGroup(false, MOD.SetEnemyFrames, "arena", 5), 
				name = ns:SetNameConfigGroup(MOD.SetEnemyFrames, "arena", 5), 
				buffs = ns:SetAuraConfigGroup(false, "buffs", false, MOD.SetEnemyFrames, "arena", 5), 
				debuffs = ns:SetAuraConfigGroup(false, "debuffs", false, MOD.SetEnemyFrames, "arena", 5), 
				castbar = ns:SetCastbarConfigGroup(MOD.SetEnemyFrames, "arena", 5)
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.tank = {
	name = L["Tank Frames"], 
	type = "group", 
	order = 1200, 
	childGroups = "tab", 
	get = function(l)return SV.db.SVUnit["tank"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "tank");MOD:SetGroupFrame("tank")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("tank")end}, 
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
						width = {order = 2, name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 3, name = L["Height"], type = "range", min = 10, max = 250, step = 1}
					}
				}, 
				targetsGroup = {
					order = 2, 
					type = "group", 
					name = L["Tank Target"], 
					guiInline = true, 
					get = function(l)return SV.db.SVUnit["tank"]["targetsGroup"][l[#l]]end, 
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "tank", "targetsGroup");MOD:SetGroupFrame("tank")end, 
					args = {
						enable = {type = "toggle", name = L["Enable"], order = 1}, 
						width = {order = 2, name = L["Width"], type = "range", min = 10, max = 500, step = 1}, 
						height = {order = 3, name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
						anchorPoint = {type = "select", order = 5, name = L["Anchor Point"], desc = L["What point to anchor to the frame you set to attach to."], values = {TOPLEFT = "TOPLEFT", LEFT = "LEFT", BOTTOMLEFT = "BOTTOMLEFT", RIGHT = "RIGHT", TOPRIGHT = "TOPRIGHT", BOTTOMRIGHT = "BOTTOMRIGHT", CENTER = "CENTER", TOP = "TOP", BOTTOM = "BOTTOM"}}, 
						xOffset = {order = 6, type = "range", name = L["xOffset"], desc = L["An X offset (in pixels) to be used when anchoring new frames."], min = -500, max = 500, step = 1}, 
						yOffset = {order = 7, type = "range", name = L["yOffset"], desc = L["An Y offset (in pixels) to be used when anchoring new frames."], min = -500, max = 500, step = 1}
					}
				}
			}
		}
	}
}
--[[
##################################################################################################
##################################################################################################
##################################################################################################
]]
SV.Options.args.SVUnit.args.assist = {
	name = L["Assist Frames"], 
	type = "group", 
	order = 1300, 
	childGroups = "tab", 
	get = function(l)return SV.db.SVUnit["assist"][l[#l]]end, 
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "assist");MOD:SetGroupFrame("assist")end, 
	args = {
		enable = {type = "toggle", order = 1, name = L["Enable"]}, 
		resetSettings = {type = "execute", order = 2, name = L["Restore Defaults"], func = function(l, m)MOD:ResetUnitOptions("assist")end}, 
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
						width = {order = 2, name = L["Width"], type = "range", min = 50, max = 500, step = 1}, 
						height = {order = 3, name = L["Height"], type = "range", min = 10, max = 250, step = 1}
					}
				}, 
				targetsGroup = {
					order = 4, 
					type = "group", 
					name = L["Assist Target"], 
					guiInline = true, 
					get = function(l)return SV.db.SVUnit["assist"]["targetsGroup"][l[#l]]end, 
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "assist", "targetsGroup");MOD:SetGroupFrame("assist")end, 
					args = {
						enable = {type = "toggle", name = L["Enable"], order = 1}, 
						width = {order = 2, name = L["Width"], type = "range", min = 10, max = 500, step = 1}, 
						height = {order = 3, name = L["Height"], type = "range", min = 10, max = 250, step = 1}, 
						anchorPoint = {type = "select", order = 5, name = L["Anchor Point"], desc = L["What point to anchor to the frame you set to attach to."], values = {TOPLEFT = "TOPLEFT", LEFT = "LEFT", BOTTOMLEFT = "BOTTOMLEFT", RIGHT = "RIGHT", TOPRIGHT = "TOPRIGHT", BOTTOMRIGHT = "BOTTOMRIGHT", CENTER = "CENTER", TOP = "TOP", BOTTOM = "BOTTOM"}}, 
						xOffset = {order = 6, type = "range", name = L["xOffset"], desc = L["An X offset (in pixels) to be used when anchoring new frames."], min = -500, max = 500, step = 1}, 
						yOffset = {order = 7, type = "range", name = L["yOffset"], desc = L["An Y offset (in pixels) to be used when anchoring new frames."], min = -500, max = 500, step = 1}
					}
				}
			}
		}
	}
}