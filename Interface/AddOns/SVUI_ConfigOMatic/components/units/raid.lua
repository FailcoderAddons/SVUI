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
local SV = _G["SVUI"];
local L = SV.L;
local MOD = SV.SVUnit
if(not MOD) then return end 
local _, ns = ...

SV.Options.args.SVUnit.args["raid"] = {
	name = "Raid", 
	type = "group", 
	order = 12, 
	childGroups = "tab", 
	get = function(l) return SV.db.SVUnit["raid"][l[#l]] end, 
	set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raid"); MOD:SetGroupFrame("raid") end, 
	args = {
		enable = {
			type = "toggle", 
			order = 1, 
			name = L["Enable"], 
		}, 
		configureToggle = {
			order = 2, 
			type = "execute", 
			name = L["Display Frames"], 
			func = function() 
				local setForced = (_G["SVUI_Raid"].forceShow ~= true) or nil; 
				MOD:ViewGroupFrames(_G["SVUI_Raid"], setForced) 
			end, 
		}, 
		resetSettings = {
			type = "execute", 
			order = 3, 
			name = L["Restore Defaults"], 
			func = function(l, m)MOD:ResetUnitOptions("raid") SV.Mentalo:Reset("Raid Frames") end, 
		}, 
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
						showPlayer = 
						{
							order = 1, 
							type = "toggle", 
							name = L["Display Player"], 
							desc = L["When true, always show player in raid frames."],
							get = function(l)return SV.db.SVUnit["raid"].showPlayer end, 
							set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raid"); MOD:SetGroupFrame("raid", true) end, 
						},
						hideonnpc = 
						{
							type = "toggle", 
							order = 2, 
							name = L["Text Toggle On NPC"], 
							desc = L["Power text will be hidden on NPC targets, in addition the name text will be repositioned to the power texts anchor point."], 
							get = function(l)return SV.db.SVUnit["raid"]["power"].hideonnpc end, 
							set = function(l, m) SV.db.SVUnit["raid"]["power"].hideonnpc = m; MOD:SetGroupFrame("raid")end, 
						},
						rangeCheck = {
							order = 3, 
							name = L["Range Check"], 
							desc = L["Check if you are in range to cast spells on this specific unit."], 
							type = "toggle", 
						},
						gps = {
							order = 4, 
							name = "GPS Tracking", 
							desc = "Show an arrow giving the direction and distance to the frames unit.", 
							type = "toggle", 
						}, 
						predict = {
							order = 5, 
							name = L["Heal Prediction"], 
							desc = L["Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals."], 
							type = "toggle", 
						}, 
						threatEnabled = {
							type = "toggle", 
							order = 6, 
							name = L["Show Threat"], 
						}, 
						colorOverride = {
							order = 7, 
							name = L["Class Color Override"], 
							desc = L["Override the default class color setting."], 
							type = "select", 
							values = 
							{
								["USE_DEFAULT"] = L["Use Default"], 
								["FORCE_ON"] = L["Force On"], 
								["FORCE_OFF"] = L["Force Off"], 
							}, 
						}, 
						positionsGroup = {
							order = 100, 
							name = L["Size and Positions"], 
							type = "group", 
							guiInline = true, 
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid");MOD:SetGroupFrame("raid", true)end, 
							args = 
							{ 
								width = 
								{
									order = 1, 
									name = L["Width"], 
									type = "range", 
									min = 10, 
									max = 500, 
									step = 1, 
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid");MOD:SetGroupFrame("raid")end, 
								}, 
								height = 
								{
									order = 2, 
									name = L["Height"], 
									type = "range", 
									min = 10, 
									max = 500, 
									step = 1, 
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid");MOD:SetGroupFrame("raid")end, 
								}, 
								spacer = 
								{
									order = 3, 
									name = "", 
									type = "description", 
									width = "full", 
								}, 
								showBy = 
								{
									order = 4, 
									name = L["Growth Direction"], 
									desc = L["Growth direction from the first unitframe."], 
									type = "select", 
									values = 
									{
										DOWN_RIGHT = format(L["%s and then %s"], L["Down"], L["Right"]), 
										DOWN_LEFT = format(L["%s and then %s"], L["Down"], L["Left"]), 
										UP_RIGHT = format(L["%s and then %s"], L["Up"], L["Right"]), 
										UP_LEFT = format(L["%s and then %s"], L["Up"], L["Left"]), 
										RIGHT_DOWN = format(L["%s and then %s"], L["Right"], L["Down"]), 
										RIGHT_UP = format(L["%s and then %s"], L["Right"], L["Up"]), 
										LEFT_DOWN = format(L["%s and then %s"], L["Left"], L["Down"]), 
										LEFT_UP = format(L["%s and then %s"], L["Left"], L["Up"]), 
									}, 
								},
								gRowCol = 
								{
									order = 5, 
									type = "range", 
									name = L["Groups Per Row / Column"], 
									min = 1, 
									max = 8, 
									step = 1, 
									set = function(l, m)
										MOD:ChangeDBVar(m, l[#l], "raid");
										MOD:SetGroupFrame("raid")
										if(_G["SVUI_Raid"] and _G["SVUI_Raid"].isForced) then	
											MOD:ViewGroupFrames(_G["SVUI_Raid"])
											MOD:ViewGroupFrames(_G["SVUI_Raid"], true)
										end
									end, 
								}, 
								wrapXOffset = 
								{
									order = 6, 
									type = "range", 
									name = L["Horizontal Spacing"], 
									min = 0, 
									max = 50, 
									step = 1, 
								}, 
								wrapYOffset = 
								{
									order = 7, 
									type = "range", 
									name = L["Vertical Spacing"], 
									min = 0, 
									max = 50, 
									step = 1, 
								}, 
							}, 
						},
						sortingGroup = {
							order = 300, 
							type = "group", 
							guiInline = true, 
							name = L["Sorting"], 
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid");MOD:SetGroupFrame("raid", true)end, 
							args = 
							{
								sortMethod = 
								{
									order = 1, 
									name = L["Group By"], 
									desc = L["Set the order that the group will sort."], 
									type = "select", 
									values = 
									{
										["CLASS"] = CLASS, 
										["ROLE"] = ROLE.."(Tanks, Healers, DPS)", 
										["ROLE_TDH"] = ROLE.."(Tanks, DPS, Healers)", 
										["ROLE_HDT"] = ROLE.."(Healers, DPS, Tanks)", 
										["ROLE_HTD"] = ROLE.."(Healers, Tanks, DPS)", 
										["NAME"] = NAME, 
										["MTMA"] = L["Main Tanks  /  Main Assist"], 
										["GROUP"] = GROUP, 
									}, 
								}, 
								sortDir = 
								{
									order = 2, 
									name = L["Sort Direction"], 
									desc = L["Defines the sort order of the selected sort method."], 
									type = "select", 
									values = 
									{
										["ASC"] = L["Ascending"], 
										["DESC"] = L["Descending"], 
									}, 
								}, 
								spacer = 
								{
									order = 3, 
									type = "description", 
									width = "full", 
									name = " ", 
								},  
								invertGroupingOrder = 
								{
									order = 4, 
									name = L["Invert Grouping Order"], 
									desc = L["Enabling this inverts the grouping order when the raid is not full, this will reverse the direction it starts from."], 
									disabled = function()return not SV.db.SVUnit["raid"].customSorting end, 
									type = "toggle", 
								},  
							}, 
						}
					}
				}, 
				misc = ns:SetMiscConfigGroup(true, MOD.SetGroupFrame, "raid"), 
				health = ns:SetHealthConfigGroup(true, MOD.SetGroupFrame, "raid"), 
				power = ns:SetPowerConfigGroup(false, MOD.SetGroupFrame, "raid"), 
				name = ns:SetNameConfigGroup(MOD.SetGroupFrame, "raid"), 
				buffs = ns:SetAuraConfigGroup(true, "buffs", true, MOD.SetGroupFrame, "raid"), 
				debuffs = ns:SetAuraConfigGroup(true, "debuffs", true, MOD.SetGroupFrame, "raid"), 
				auraWatch = {
					order = 600, 
					type = "group", 
					name = L["Aura Watch"], 
					args = {
						enable = {
							type = "toggle", 
							name = L["Enable"], 
							order = 1,
							get = function(l)return SV.db.SVUnit["raid"].auraWatch.enable end, 
							set = function(l, m)MOD:ChangeDBVar(m, "enable", "raid", "auraWatch");MOD:SetGroupFrame("raid")end, 
						}, 
						size = {
							type = "range", 
							name = L["Size"], 
							desc = L["Size of the indicator icon."], 
							order = 2, 
							min = 4, 
							max = 15, 
							step = 1,
							get = function(l)return SV.db.SVUnit["raid"].auraWatch.size end, 
							set = function(l, m)MOD:ChangeDBVar(m, "size", "raid", "auraWatch");MOD:SetGroupFrame("raid")end, 
						}, 
						configureButton = {
							type = "execute", 
							name = L["Configure Auras"], 
							func = function()ns:SetToFilterConfig("BuffWatch")end, 
							order = 3, 
						}, 

					}, 
				}, 
				rdebuffs = {
					order = 800, 
					type = "group", 
					name = L["RaidDebuff Indicator"], 
					get = function(l)return
					SV.db.SVUnit["raid"]["rdebuffs"][l[#l]]end, 
					set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raid", "rdebuffs");MOD:SetGroupFrame("raid")end, 
					args = {
						enable = {
							type = "toggle", 
							name = L["Enable"], 
							order = 1, 
						}, 
						size = {
							type = "range", 
							name = L["Size"], 
							order = 2, 
							min = 8, 
							max = 35, 
							step = 1, 
						}, 
						fontSize = {
							type = "range", 
							name = L["Font Size"], 
							order = 3, 
							min = 7, 
							max = 22, 
							step = 1, 
						}, 
						xOffset = {
							order = 4, 
							type = "range", 
							name = L["xOffset"], 
							min =  - 300, 
							max = 300, 
							step = 1, 
						}, 
						yOffset = {
							order = 5, 
							type = "range", 
							name = L["yOffset"], 
							min =  - 300, 
							max = 300, 
							step = 1, 
						}, 
						configureButton = {
							type = "execute", 
							name = L["Configure Auras"], 
							func = function()ns:SetToFilterConfig("Raid")end, 
							order = 7, 
						}, 
					}, 
				}, 
				icons = ns:SetIconConfigGroup(MOD.SetGroupFrame, "raid"), 
			}, 
		}, 
	}, 
}

SV.Options.args.SVUnit.args.raidpet = {
	order = 13,
	type = 'group',
	name = L['Raid Pets'],
	childGroups = "tab",
	get = function(l)return
	SV.db.SVUnit['raidpet'][l[#l]]end,
	set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet')end,
	args = {
		enable = {
			type = 'toggle',
			order = 1,
			name = L['Enable'],
		},
		configureToggle = {
			order = 2,
			type = 'execute',
			name = L['Display Frames'],
			func = function()MOD:ViewGroupFrames(SVUI_Raidpet, SVUI_Raidpet.forceShow ~= true or nil)end,
		},
		resetSettings = {
			type = 'execute',
			order = 3,
			name = L['Restore Defaults'],
			func = function(l, m)MOD:ResetUnitOptions('raidpet')SV.Mentalo:Reset('Raid Pet Frames')MOD:SetGroupFrame('raidpet', true)end,
		},
		tabGroups= {
			order=3,
			type='group',
			name=L['Unit Options'],
			childGroups="tree",
			args= {
				commonGroup= {
					order=1,
					type='group',
					name=L['General Settings'],
					args= {
						rangeCheck = {
							order = 3,
							name = L["Range Check"],
							desc = L["Check if you are in range to cast spells on this specific unit."],
							type = "toggle",
						},
						predict = {
							order = 4,
							name = L['Heal Prediction'],
							desc = L['Show a incomming heal prediction bar on the unitframe. Also display a slightly different colored bar for incoming overheals.'],
							type = 'toggle',
						},
						threatEnabled = {
							type = 'toggle',
							order = 5,
							name = L['Show Threat'],
						},
						colorOverride = {
							order = 6,
							name = L['Class Color Override'],
							desc = L['Override the default class color setting.'],
							type = 'select',
							values = {
								['USE_DEFAULT'] = L['Use Default'],
								['FORCE_ON'] = L['Force On'],
								['FORCE_OFF'] = L['Force Off'],
							},
						},
						positionsGroup = {
							order = 100,
							name = L['Size and Positions'],
							type = 'group',
							guiInline = true,
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet', true)end,
							args = {
								width = {
									order = 1,
									name = L['Width'],
									type = 'range',
									min = 10,
									max = 500,
									step = 1,
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet')end,
								},
								height = {
									order = 2,
									name = L['Height'],
									type = 'range',
									min = 10,
									max = 500,
									step = 1,
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet')end,
								},
								spacer = {
									order = 3,
									name = '',
									type = 'description',
									width = 'full',
								},
								showBy = {
									order = 4,
									name = L['Growth Direction'],
									desc = L['Growth direction from the first unitframe.'],
									type = 'select',
									values = {
										DOWN_RIGHT = format(L['%s and then %s'], L['Down'], L['Right']),
										DOWN_LEFT = format(L['%s and then %s'], L['Down'], L['Left']),
										UP_RIGHT = format(L['%s and then %s'], L['Up'], L['Right']),
										UP_LEFT = format(L['%s and then %s'], L['Up'], L['Left']),
										RIGHT_DOWN = format(L['%s and then %s'], L['Right'], L['Down']),
										RIGHT_UP = format(L['%s and then %s'], L['Right'], L['Up']),
										LEFT_DOWN = format(L['%s and then %s'], L['Left'], L['Down']),
										LEFT_UP = format(L['%s and then %s'], L['Left'], L['Up']),
									},
								},
								gRowCol = {
									order = 5,
									type = 'range',
									name = L['Groups Per Row/Column'],
									min = 1,
									max = 8,
									step = 1,
									set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet')if
									SVUI_Raidpet.isForced then MOD:ViewGroupFrames(SVUI_Raidpet)MOD:ViewGroupFrames(SVUI_Raidpet, true)end end,
								},
								wrapXOffset = {
									order = 6,
									type = 'range',
									name = L['Horizontal Spacing'],
									min = 0,
									max = 50,
									step = 1,
								},
								wrapYOffset = {
									order = 7,
									type = 'range',
									name = L['Vertical Spacing'],
									min = 0,
									max = 50,
									step = 1,
								},
							},
						},
						visibilityGroup = {
							order = 200,
							name = L['Visibility'],
							type = 'group',
							guiInline = true,
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet', true)end,
							args = {
								visibility = {
									order = 2,
									type = 'input',
									name = L['Visibility'],
									desc = L['The following macro must be true in order for the group to be shown, in addition to any filter that may already be set.'],
									width = 'full',
									desc = L['TEXT_FORMAT_DESC'],
								},
							},
						},
						sortingGroup = {
							order = 300,
							type = 'group',
							guiInline = true,
							name = L['Grouping & Sorting'],
							set = function(l, m)MOD:ChangeDBVar(m, l[#l], "raidpet");MOD:SetGroupFrame('raidpet', true)end,
							args = {
								sortMethod = {
									order = 1,
									name = L['Group By'],
									desc = L['Set the order that the group will sort.'],
									type = 'select',
									values = {
										['NAME'] = L['Owners Name'],
										['PETNAME'] = L['Pet Name'],
										['GROUP'] = GROUP,
									},
								},
								sortDir = {
									order = 2,
									name = L['Sort Direction'],
									desc = L['Defines the sort order of the selected sort method.'],
									type = 'select',
									values = {
										['ASC'] = L['Ascending'],
										['DESC'] = L['Descending'],
									},
								},
								spacer = {
									order = 3,
									type = 'description',
									width = 'full',
									name = ' ',
								},
								invertGroupingOrder = {
									order = 4,
									name = L['Invert Grouping Order'],
									desc = L['Enabling this inverts the grouping order when the raid is not full, this will reverse the direction it starts from.'],
									disabled = function()return not SV.db.SVUnit['raidpet'].customSorting end,
									type = 'toggle',
								},
							},
						}
					}
				},
				misc = ns:SetMiscConfigGroup(true, MOD.SetGroupFrame, 'raidpet'),
				health = ns:SetHealthConfigGroup(true, MOD.SetGroupFrame, 'raidpet'),
				name = ns:SetNameConfigGroup(MOD.SetGroupFrame, 'raidpet'),
				buffs = ns:SetAuraConfigGroup(true, 'buffs', true, MOD.SetGroupFrame, 'raidpet'),
				debuffs = ns:SetAuraConfigGroup(true, 'debuffs', true, MOD.SetGroupFrame, 'raidpet'),
				auraWatch = {
					order = 600,
					type = 'group',
					name = L['Aura Watch'],
					args = {
						enable = {
							type = "toggle", 
							name = L["Enable"], 
							order = 1,
							get = function(l)return SV.db.SVUnit["raidpet"].auraWatch.enable end, 
							set = function(l, m)MOD:ChangeDBVar(m, "enable", "raidpet", "auraWatch");MOD:SetGroupFrame('raidpet')end, 
						}, 
						size = {
							type = "range", 
							name = L["Size"], 
							desc = L["Size of the indicator icon."], 
							order = 2, 
							min = 4, 
							max = 15, 
							step = 1,
							get = function(l)return SV.db.SVUnit["raidpet"].auraWatch.size end, 
							set = function(l, m)MOD:ChangeDBVar(m, "size", "raidpet", "auraWatch");MOD:SetGroupFrame('raidpet')end, 
						}, 
						configureButton = {
							type = 'execute',
							name = L['Configure Auras'],
							func = function()ns:SetToFilterConfig('BuffWatch')end,
							order = 3,
						},
					},
				},
				rdebuffs = {
					order = 700,
					type = 'group',
					name = L['RaidDebuff Indicator'],
					get = function(l)return
					SV.db.SVUnit['raidpet']['rdebuffs'][l[#l]]end,
					set = function(l, m) MOD:ChangeDBVar(m, l[#l], "raidpet", "rdebuffs"); MOD:SetGroupFrame('raidpet')end,
					args = {
						enable = {
							type = 'toggle',
							name = L['Enable'],
							order = 1,
						},
						size = {
							type = 'range',
							name = L['Size'],
							order = 2,
							min = 8,
							max = 35,
							step = 1,
						},
						xOffset = {
							order = 3,
							type = 'range',
							name = L['xOffset'],
							min =  - 300,
							max = 300,
							step = 1,
						},
						yOffset = {
							order = 4,
							type = 'range',
							name = L['yOffset'],
							min =  - 300,
							max = 300,
							step = 1,
						},
						configureButton = {
							type = 'execute',
							name = L['Configure Auras'],
							func = function()ns:SetToFilterConfig('Raid')end,
							order = 5,
						},
					},
				},
				icons = ns:SetIconConfigGroup(MOD.SetGroupFrame, 'raidpet'),
			},
		},
	},
}