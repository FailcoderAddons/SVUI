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
local Ace3Config = LibStub("AceConfig-3.0");
local Ace3ConfigDialog = LibStub("AceConfigDialog-3.0");
Ace3Config:RegisterOptionsTable("SVUI", SuperVillain.Options);
Ace3ConfigDialog:SetDefaultSize("SVUI", 890, 651);
local AceGUI = LibStub("AceGUI-3.0", true);
local posOpts = {TOPLEFT='TOPLEFT',LEFT='LEFT',BOTTOMLEFT='BOTTOMLEFT',RIGHT='RIGHT',TOPRIGHT='TOPRIGHT',BOTTOMRIGHT='BOTTOMRIGHT',CENTER='CENTER',TOP='TOP',BOTTOM='BOTTOM'};
local GEAR = SuperVillain.Registry:Expose('SVGear');
local BAG = SuperVillain.Registry:Expose('SVBag');
local OVR = SuperVillain.Registry:Expose('SVOverride');
local sortingFunction = function(arg1, arg2) return arg1 < arg2 end;

local function CommonFontSizeUpdate()
    local STANDARDFONTSIZE = SuperVillain.db.media.fonts.size;
    local smallfont = STANDARDFONTSIZE - 2;
    local largefont = STANDARDFONTSIZE + 2;
    SuperVillain.db.SVAura.fontSize = STANDARDFONTSIZE;
    SuperVillain.db.SVStats.fontSize = STANDARDFONTSIZE;
    SuperVillain.db.SVUnit.fontSize = STANDARDFONTSIZE;
    SuperVillain.db.SVUnit.auraFontSize = smallfont;

    SuperVillain.db.SVBar.fontSize = smallfont;
    SuperVillain.db.SVPlate.fontSize = smallfont;

    SuperVillain.db.SVLaborer.fontSize = largefont;
    
    SuperVillain.db.SVUnit.player.health.fontSize = largefont;
    SuperVillain.db.SVUnit.player.power.fontSize = largefont;
    SuperVillain.db.SVUnit.player.name.fontSize = largefont;
    SuperVillain.db.SVUnit.player.aurabar.fontSize = STANDARDFONTSIZE;

    SuperVillain.db.SVUnit.target.health.fontSize = largefont;
    SuperVillain.db.SVUnit.target.power.fontSize = largefont;
    SuperVillain.db.SVUnit.target.name.fontSize = largefont;
    SuperVillain.db.SVUnit.target.aurabar.fontSize = STANDARDFONTSIZE;

    SuperVillain.db.SVUnit.focus.health.fontSize = largefont;
    SuperVillain.db.SVUnit.focus.power.fontSize = largefont;
    SuperVillain.db.SVUnit.focus.name.fontSize = largefont;
    SuperVillain.db.SVUnit.focus.aurabar.fontSize = STANDARDFONTSIZE;

    SuperVillain.db.SVUnit.targettarget.health.fontSize = largefont;
    SuperVillain.db.SVUnit.targettarget.power.fontSize = largefont;
    SuperVillain.db.SVUnit.targettarget.name.fontSize = largefont;

    SuperVillain.db.SVUnit.focustarget.health.fontSize = largefont;
    SuperVillain.db.SVUnit.focustarget.power.fontSize = largefont;
    SuperVillain.db.SVUnit.focustarget.name.fontSize = largefont;

    SuperVillain.db.SVUnit.pet.health.fontSize = largefont;
    SuperVillain.db.SVUnit.pet.power.fontSize = largefont;
    SuperVillain.db.SVUnit.pet.name.fontSize = largefont;

    SuperVillain.db.SVUnit.pettarget.health.fontSize = largefont;
    SuperVillain.db.SVUnit.pettarget.power.fontSize = largefont;
    SuperVillain.db.SVUnit.pettarget.name.fontSize = largefont;

    SuperVillain.db.SVUnit.party.health.fontSize = largefont;
    SuperVillain.db.SVUnit.party.power.fontSize = largefont;
    SuperVillain.db.SVUnit.party.name.fontSize = largefont;

    SuperVillain.db.SVUnit.boss.health.fontSize = largefont;
    SuperVillain.db.SVUnit.boss.power.fontSize = largefont;
    SuperVillain.db.SVUnit.boss.name.fontSize = largefont;

    SuperVillain.db.SVUnit.arena.health.fontSize = largefont;
    SuperVillain.db.SVUnit.arena.power.fontSize = largefont;
    SuperVillain.db.SVUnit.arena.name.fontSize = largefont;

    SuperVillain.db.SVUnit.raid10.health.fontSize = largefont;
    SuperVillain.db.SVUnit.raid10.power.fontSize = largefont;
    SuperVillain.db.SVUnit.raid10.name.fontSize = largefont;

    SuperVillain.db.SVUnit.raid25.health.fontSize = largefont;
    SuperVillain.db.SVUnit.raid25.power.fontSize = largefont;
    SuperVillain.db.SVUnit.raid25.name.fontSize = largefont;

    SuperVillain.db.SVUnit.raid40.health.fontSize = largefont;
    SuperVillain.db.SVUnit.raid40.power.fontSize = largefont;
    SuperVillain.db.SVUnit.raid40.name.fontSize = largefont;

    SuperVillain.db.SVUnit.tank.health.fontSize = largefont;
    SuperVillain.db.SVUnit.assist.health.fontSize = largefont;

    SuperVillain:RefreshSystemFonts()
end;
--[[ 
########################################################## 
SET PACKAGE OPTIONS
##########################################################
]]--
SuperVillain.Options.args = {
	SVUI_Header = {
		order = 1, 
		type = "header", 
		name = "You are using |cffff9900Super Villain UI|r - "..L["Version"]..format(": |cff99ff33%s|r", SuperVillain.version), 
		width = "full"
	}
};

SuperVillain.Options.args.primary = {
	type = "group", 
	order = 1, 
	name = L["Main"], 
	get = function(j)return SuperVillain.db.system[j[#j]]end, 
	set = function(j, value)SuperVillain.db.system[j[#j]] = value end, 
	args = {
		introGroup1 = {
			order = 1, 
			name = "", 
			type = "description", 
			width = "full", 
			image = function()return "Interface\\AddOns\\SVUI\\assets\\artwork\\SPLASH", 256, 128 end, 
		}, 
		introGroup2 = {
			order = 2, 
			name = L["Here are a few basic quick-change options to possibly save you some time."], 
			type = "description", 
			width = "full", 
			fontSize = "large", 
		}, 
		quickGroup1 = {
			order = 3, 
			name = "", 
			type = "group", 
			width = "full", 
			guiInline = true, 
			args = {
				Install = {
					order = 3, 
					width = "full", 
					type = "execute", 
					name = L["Install"], 
					desc = L["Run the installation process."], 
					func = function() SuperVillain:Install()SuperVillain:ToggleConfig() end
				},
				ToggleAnchors = {
					order = 4, 
					width = "full", 
					type = "execute", 
					name = L["Move Frames"], 
					desc = L["Unlock various elements of the UI to be repositioned."], 
					func = function() SuperVillain:UseMentalo() end
				},
				ResetAllMovers = {
					order = 5, 
					width = "full", 
					type = "execute", 
					name = L["Reset Anchors"], 
					desc = L["Reset all frames to their original positions."], 
					func = function() SuperVillain:ResetUI() end
				},
				toggleKeybind = {
					order = 6, 
					width = "full", 
					type = "execute", 
					name = L["Keybind Mode"], 
					func = function()
						SuperVillain.Registry:Expose("SVBar"):ToggleKeyBindingMode()
						SuperVillain:ToggleConfig()
						GameTooltip:Hide()
					end, 
					disabled = function() return not SuperVillain.db.SVBar.enable end
				}
			}, 
		}, 
		quickGroup2 = {
			order = 4, 
			name = "", 
			type = "group", 
			width = "full", 
			guiInline = true, 
			args = {}, 
		}, 	
	}
};

SuperVillain.Options.args.common = {
	type = "group", 
	order = 2, 
	name = L["General"], 
	childGroups = "tab", 
	get = function(j)return SuperVillain.db.system[j[#j]]end, 
	set = function(j, value)SuperVillain.db.system[j[#j]] = value end, 
	args = {
		commonGroup = {
			order = 1, 
			type = 'group', 
			name = L['General Options'], 
			childGroups = "tree", 
			args = {
				common = {
					order = 1, 
					type = "group", 
					name = L["Misc"], 
					args = {
						baseGroup = {
							order = 1, 
							type = "group", 
							guiInline = true, 
							name = L["Common Stuff"],
							args = {
								autoScale = {
									order = 1,
									name = L["Auto Scale"],
									desc = L["Automatically scale the User Interface based on your screen resolution"],
									type = "toggle",
									get = function(j)return SuperVillain.db.system.autoScale end,
									set = function(j,value)SuperVillain.db.system.autoScale = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								multiMonitor = {
									order = 2,
									name = L["Multi Monitor"],
									desc = L["Adjust UI dimensions to accomodate for multiple monitor setups"],
									type = "toggle",
									get = function(j)return SuperVillain.db.system.multiMonitor end,
									set = function(j,value)SuperVillain.db.system.multiMonitor = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								hideErrorFrame = {
									order = 3,
									name = L["Hide Error Text"],
									desc = L["Hides the red error text at the top of the screen while in combat."],
									type = "toggle",
									get = function(j)return SuperVillain.db.system.hideErrorFrame end,
									set = function(j,value)SuperVillain.db.system.hideErrorFrame = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								LoginMessage = {
									order = 4,
									type = 'toggle',
									name = L['Login Message'],
									get = function(j)return SuperVillain.db.system.loginmessage end,
									set = function(j,value)SuperVillain.db.system.loginmessage = value end
								},
							}
						},
						lootGroup = {
							order = 2, 
							type = "group", 
							guiInline = true, 
							name = L["Loot Frame / Roll"],
							args = {
								loot = {
									order = 1,
									type = "toggle",
									name = L['Loot Frame'],
									desc = L['Enable/Disable the loot frame.'],
									get = function()return SuperVillain.db.SVOverride.loot end,
									set = function(j,value)SuperVillain.db.SVOverride.loot = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								lootRoll = {
									order = 2,
									type = "toggle",
									name = L['Loot Roll'],
									desc = L['Enable/Disable the loot roll frame.'],
									get = function()return SuperVillain.db.SVOverride.lootRoll end,
									set = function(j,value)SuperVillain.db.SVOverride.lootRoll = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								lootRollWidth = {
									order = 3,
									type = 'range',
									width = "full",
									name = L["Roll Frame Width"],
									min = 100,
									max = 328,
									step = 1,
									get = function()return SuperVillain.db.SVOverride.lootRollWidth end,
									set = function(a,b)OVR:ChangeDBVar(b,a[#a]); end,
								},
								lootRollHeight = {
									order = 4,
									type = 'range',
									width = "full",
									name = L["Roll Frame Height"],
									min = 14,
									max = 58,
									step = 1,
									get = function()return SuperVillain.db.SVOverride.lootRollHeight end,
									set = function(a,b)OVR:ChangeDBVar(b,a[#a]); end,
								},
							}
						},
						scriptGroup = {
							order = 3, 
							type = "group", 
							guiInline = true, 
							name = L["Fun Stuff"],
							args = {
								comix = {
									order = 1,
									type = 'toggle',
									name = L["Enable Comic Popups"],
									get = function(j)return SuperVillain.db.system.comix end,
									set = function(j,value)SuperVillain.db.system.comix = value;SuperVillain:ToggleComix()end
								},
								bubbles = {
									order = 2,
									type = "toggle",
									name = L['Chat Bubbles Style'],
									desc = L['Style the blizzard chat bubbles.'],
									get = function(j)return SuperVillain.db.system.bubbles end,
									set = function(j,value)SuperVillain.db.system.bubbles = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								woot = {
									order = 3,
									type = 'toggle',
									name = L["Say Thanks"],
									desc = L["Thank someone when they cast specific spells on you. Typically resurrections"], 
									get = function(j)return SuperVillain.db.system.woot end,
									set = function(j,value)SuperVillain.db.system.woot = value;SuperVillain:ToggleReactions()end
								},
								pvpinterrupt = {
									order = 4,
									type = 'toggle',
									name = L["Report PVP Actions"],
									desc = L["Announce your interrupts, as well as when you have been sapped!"],
									get = function(j)return SuperVillain.db.system.pvpinterrupt end,
									set = function(j,value)SuperVillain.db.system.pvpinterrupt = value;SuperVillain:ToggleReactions()end
								},
								lookwhaticando = {
									order = 5,
									type = 'toggle',
									name = L["Report Spells"],
									desc = L["Announce various helpful spells cast by players in your party/raid"],
									get = function(j)return SuperVillain.db.system.lookwhaticando end,
									set = function(j,value)SuperVillain.db.system.lookwhaticando = value;SuperVillain:ToggleReactions()end
								},
								sharingiscaring = {
									order = 6,
									type = 'toggle',
									name = L["Report Shareables"],
									desc = L["Announce when someone in your party/raid has laid a feast or repair bot"],
									get = function(j)return SuperVillain.db.system.sharingiscaring end,
									set = function(j,value)SuperVillain.db.system.sharingiscaring = value;SuperVillain:ToggleReactions()end
								},
							}
						},
						otherGroup = {
							order = 4, 
							type = "group", 
							guiInline = true, 
							name = L["Other Stuff"],
							args = {
								threatbar = {
									order = 1, 
									type = "toggle", 
									name = L['Threat Thermometer'], 
									get = function(j)return SuperVillain.db.system.threatbar end, 
									set = function(j, value)SuperVillain.db.system.threatbar = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								totems = {
									order = 2, 
									type = "toggle", 
									name = L["Totems"], 
									get = function(j)
										return SuperVillain.db.system.totems.enable
									end, 
									set = function(j, value)
										SuperVillain.db.system.totems.enable = value;
										SuperVillain:StaticPopup_Show("RL_CLIENT")
									end
								},
								cooldownText = {
									type = "toggle", 
									order = 3, 
									name = L['Cooldown Text'], 
									desc = L["Display cooldown text on anything with the cooldown spiral."], 
									get = function(j)return SuperVillain.db.system.cooldown end, 
									set = function(j,value)SuperVillain.db.system.cooldown = value;SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								size = {
									order = 4, 
									type = 'range',
									width = "full",
									name = L["Totem Button Size"], 
									min = 24, 
									max = 60, 
									step = 1,
									get = function(j)
										return SuperVillain.db.system.totems[j[#j]]
									end, 
									set = function(j, value)
										SuperVillain.db.system.totems[j[#j]] = value
									end
								},
								spacing = {
									order = 5, 
									type = 'range', 
									width = "full",
									name = L['Totem Button Spacing'], 
									min = 1, 
									max = 10, 
									step = 1,
									get = function(j)
										return SuperVillain.db.system.totems[j[#j]]
									end, 
									set = function(j, value)
										SuperVillain.db.system.totems[j[#j]] = value
									end
								},
								sortDirection = {
									order = 6, 
									type = 'select', 
									name = L["Totem Sort Direction"], 
									values = {
										['ASCENDING'] = L['Ascending'], 
										['DESCENDING'] = L['Descending']
									},
									get = function(j)
										return SuperVillain.db.system.totems[j[#j]]
									end, 
									set = function(j, value)
										SuperVillain.db.system.totems[j[#j]] = value
									end
								},
								showBy = {
									order = 7, 
									type = 'select', 
									name = L['Totem Bar Direction'], 
									values = {
										['VERTICAL'] = L['Vertical'], 
										['HORIZONTAL'] = L['Horizontal']
									},
									get = function(j)
										return SuperVillain.db.system.totems[j[#j]]
									end, 
									set = function(j, value)
										SuperVillain.db.system.totems[j[#j]] = value
									end
								}
							}
						}		
					}
				}, 
				media = {
					order = 2,
					type = "group", 
					name = L["Media"], 
					get = function(j)return SuperVillain.db.system[j[#j]]end, 
					set = function(j, value)SuperVillain.db.system[j[#j]] = value end, 
					args = {
						texture = {
							order = 1, 
							type = "group", 
							name = L["Textures"], 
							guiInline = true,
							get = function(key)
								return SuperVillain.db.media.textures[key[#key]]
							end,
							set = function(key, value)
								SuperVillain.db.media.textures[key[#key]] = {"background", value}
								SuperVillain:RefreshEverything(true)
							end,
							args = {
								pattern = {
									type = "select",
									dialogControl = 'LSM30_Background',
									order = 1,
									name = L["Primary Texture"],
									values = AceGUIWidgetLSMlists.background
								},
								comic = {
									type = "select",
									dialogControl = 'LSM30_Background',
									order = 1,
									name = L["Secondary Texture"],
									values = AceGUIWidgetLSMlists.background
								}						
							}
						}, 
						fonts = {
							order = 2, 
							type = "group", 
							name = L["Fonts"], 
							guiInline = true, 
							args = {
								size = {
									order = 1,
									name = L["Font Size"],
									desc = L["Set/Override the global UI font size. |cffFF0000NOTE:|r |cffFF9900This WILL affect configurable fonts.|r"],
									type = "range",
									width = "full",
									min = 6,
									max = 22,
									step = 1,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;CommonFontSizeUpdate()end
								},
								unicodeSize = {
									order = 2,
									name = L["Unicode Font Size"],
									desc = L["Set/Override the global font size used by unstyled text. |cffFF0000(ie, Character stats, tooltips, other smaller texts)|r"],
									type = "range",
									width = "full",
									min = 6,
									max = 22,
									step = 1,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;CommonFontSizeUpdate()end
								},
								fontSpacer1 = {
									order = 3,
									type = "description",
									name = "",
									desc = "",
								},
								fontSpacer2 = {
									order = 4,
									type = "description",
									name = "",
									desc = "",
								},
								default = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 5,
									name = L["Default Font"],
									desc = L["Set/Override the global UI font. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect configurable fonts.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.db.media.fonts[j[#j]]end,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;SuperVillain:RefreshSystemFonts()end
								},
								name = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 6,
									name = L["Unit Name Font"],
									desc = L["Set/Override the global name font. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect styled nameplates or unitframes.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.db.media.fonts[j[#j]]end,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;SuperVillain:RefreshSystemFonts()end
								},
								combat = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 7,
									name = L["CombatText Font"],
									desc = L["Set/Override the font that combat text will use. |cffFF0000NOTE:|r |cffFF9900This requires a game restart or re-log for this change to take effect.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.db.media.fonts[j[#j]]end,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;SuperVillain:RefreshSystemFonts()SuperVillain:StaticPopup_Show("RL_CLIENT")end
								},
								number = {
									type = "select",
									dialogControl = 'LSM30_Font',
									order = 8,
									name = L["Numbers Font"],
									desc = L["Set/Override the global font used for numbers. |cff00FF00NOTE:|r |cff00FF99This WILL NOT affect all numbers.|r"],
									values = AceGUIWidgetLSMlists.font,
									get = function(j)return SuperVillain.db.media.fonts[j[#j]]end,
									set = function(j,value)SuperVillain.db.media.fonts[j[#j]] = value;SuperVillain:RefreshSystemFonts()end
								},					
							}
						}, 
						colors = {
							order = 3, 
							type = "group", 
							name = L["Colors"], 
							guiInline = true,
							args = {
								default = {
									type = "color",
									order = 1,
									name = L["Default Color"],
									desc = L["Main color used by most UI elements. (ex: Backdrop Color)"],
									hasAlpha = true,
									get = function(key)
										local color = SuperVillain.db.media.colors.default
										return color[1],color[2],color[3],color[4] 
									end,
									set = function(key, rValue, gValue, bValue, aValue)
										SuperVillain.db.media.colors.default = {rValue, gValue, bValue, aValue}
										SuperVillain:MediaUpdate()
									end,
								},
								special = {
									type = "color",
									order = 2,
									name = L["Accent Color"],
									desc = L["Color used in various frame accents.  (ex: Dressing Room Backdrop Color)"],
									hasAlpha = true,
									get = function(key)
										local color = SuperVillain.db.media.colors.special
										return color[1],color[2],color[3],color[4] 
									end,
									set = function(key, rValue, gValue, bValue, aValue)
										SuperVillain.db.media.colors.special = {rValue, gValue, bValue, aValue}
										SuperVillain:MediaUpdate()
									end,
								},
								resetbutton = {
									type = "execute",
									order = 3,
									name = L["Restore Defaults"],
									func = function()
										SuperVillain.db.media.colors.default = {0.15, 0.15, 0.15, 1};
										SuperVillain.db.media.colors.special = {0.4, 0.32, 0.2, 1};
										SuperVillain:MediaUpdate()
									end
								}
							}
						}
					}
				}, 
				gear={
					order = 3,
					type = 'group',
					name = L['Gear Managment'],
					get = function(a)return SuperVillain.db.SVGear[a[#a]]end,
					set = function(a,b)SuperVillain.db.SVGear[a[#a]]=b;GEAR:ReLoad()end,
					args={
						intro={
							order = 1,
							type = 'description',
							name = function() 
								if(GetNumEquipmentSets()==0) then 
									return L["EQUIPMENT_DESC"] .. "\n" .. "|cffFF0000Must create an equipment set to use some of these features|r" 
								else 
									return L["EQUIPMENT_DESC"] 
								end 
							end
						},
						specialization={
							order = 2,
							type = "group",
							name = L["Specialization"],
							guiInline = true,
							disabled = function()return GetNumEquipmentSets()==0 end,
							args={
								enable={
									type="toggle",
									order=1,
									name=L["Enable"],
									desc=L['Enable/Disable the specialization switch.'],
									get=function(e)return SuperVillain.db.SVGear.specialization.enable end,
									set=function(e,value) SuperVillain.db.SVGear.specialization.enable = value end
								},
								primary={
									type="select",
									order=2,
									name=L["Primary Talent"],
									desc=L["Choose the equipment set to use for your primary specialization."],
									disabled=function()return not SuperVillain.db.SVGear.specialization.enable end,
									values=function()
										local h={["none"]=L["No Change"]}
										for i=1,GetNumEquipmentSets()do 
											local name=GetEquipmentSetInfo(i)
											if name then h[name]=name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								},
								secondary={
									type="select",
									order=3,
									name=L["Secondary Talent"],
									desc=L["Choose the equipment set to use for your secondary specialization."],
									disabled=function()return not SuperVillain.db.SVGear.specialization.enable end,
									values=function()
										local h={["none"]=L["No Change"]}
										for i=1,GetNumEquipmentSets()do 
											local name,l,l,l,l,l,l,l,l=GetEquipmentSetInfo(i)
											if name then h[name]=name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								}

							}
						},
						battleground = {
							order = 3,
							type = "group",
							name = L["Battleground"],
							guiInline = true,
							disabled = function()return GetNumEquipmentSets() == 0 end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the battleground switch."],
									get = function(e)return SuperVillain.db.SVGear.battleground.enable end,
									set = function(e,value)SuperVillain.db.SVGear.battleground.enable = value end
								},
								equipmentset = {
									type = "select",
									order = 2,
									name = L["Equipment Set"],
									desc = L["Choose the equipment set to use when you enter a battleground or arena."],
									disabled = function()return not SuperVillain.db.SVGear.battleground.enable end,
									values = function()
										local h = {["none"] = L["No Change"]}
										for i = 1,GetNumEquipmentSets()do 
											local name = GetEquipmentSetInfo(i)
											if name then h[name] = name end 
										end;
										tsort(h,sortingFunction)
										return h 
									end
								}
							}
						},
						intro2 = {
							type = "description",
							name = L["DURABILITY_DESC"],
							order = 4
						},
						durability = {
							type = "group",
							name = DURABILITY,
							guiInline = true,
							order = 5,
							get = function(e)return SuperVillain.db.SVGear.durability[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.durability[e[#e]] = value;GEAR:ReLoad()end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the display of durability information on the character screen."]
								},
								onlydamaged = {
									type = "toggle",
									order = 2,
									name = L["Damaged Only"],
									desc = L["Only show durability information for items that are damaged."],
									disabled = function()return not SuperVillain.db.SVGear.durability.enable end
								}
							}
						},
						intro3 = {
							type = "description",
							name = L["ITEMLEVEL_DESC"],
							order = 6
						},
						itemlevel = {
							type = "group",
							name = STAT_AVERAGE_ITEM_LEVEL,
							guiInline = true,
							order = 7,
							get = function(e)return SuperVillain.db.SVGear.itemlevel[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.itemlevel[e[#e]] = value;GEAR:ReLoad()end,
							args = {
								enable = {
									type = "toggle",
									order = 1,
									name = L["Enable"],
									desc = L["Enable/Disable the display of item levels on the character screen."]
								}
							}
						},
						misc = {
							type = "group",
							name = L["Miscellaneous"],
							guiInline = true,
							order = 8,
							get = function(e)return SuperVillain.db.SVGear.misc[e[#e]]end,
							set = function(e,value)SuperVillain.db.SVGear.misc[e[#e]] = value end,
							disabled = function()return not SuperVillain.db.SVBag.enable end,
							args = {
								setoverlay = {
									type = "toggle",
									order = 1,
									name = L["Equipment Set Overlay"],
									desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
									set = function(e,value)
										SuperVillain.db.SVGear.misc[e[#e]] = value;
										BAG:ToggleEquipmentOverlay()
									end
								}
							}
						}
					}
				} 
			}, 
		}, 
	}
};

local q, r, dnt = "", "", "";
local s = "\n";
local p = "\n"..format("|cff4f4f4f%s|r", "---------------------------------------------");
local t = {"Munglunch", "Elv", "Tukz", "Azilroka", "Sortokk", "AlleyKat", "Quokka", "Haleth", "P3lim", "Haste", "Totalpackage", "Kryso", "Thepilli"};
local u = {"Wowinterface Community", "Doonga - (The man who keeps me busy)", "Judicate", "Cazart506", "Movster", "MuffinMonster", "Joelsoul", "Trendkill09", "Luamar", "Zharooz", "Lyn3x5", "Madh4tt3r", "Xarioth", "Sinnisterr", "Melonmaniac", "Hojowameeat", "Xandeca", "Bkan", "Daigan - (My current 2nd in command)", "AtomicKiller", "Meljen", "Moondoggy", "Stormblade", "Schreibstift", "Anj", "Risien"};
local v = {"Movster", "Cazart506", "Other Silent Partners.."};
local credit_header = format("|cffff9900%s|r", "SUPERVILLAIN CREDITS:")..p;
local credit_sub = format("|cffff9900%s|r", "CREATED BY:").."  Munglunch"..p;
local credit_sub2 = format("|cffff9900%s|r", "USING ORIGINAL CODE BY:").."  Elv, Tukz, Azilroka, Sortokk"..p;
local special_thanks = format("|cffff9900%s|r", "A VERY SPECIAL THANKS TO:  ")..format("|cffffff00%s|r", "Movster").."  ..who inspired me to bring this project back to life!"..p;
local coding = format("|cff3399ff%s|r", L['CODE MONKEYS  (aka ORIGINAL AUTHORS):'])..p;
local testing = format("|cffaa33ff%s|r", L['PERFECTIONISTS  (aka TESTERS):'])..p;
local doners = format("|cff99ff33%s|r", L['KINGPINS  (aka INVESTORS):'])..p;

tsort(t, function(o,n) return o < n end)
for _, x in pairs(t) do
	q = q..s..x 
end;
tsort(u, function(o,n) return o < n end)
for _, y in pairs(u) do
	r = r..s..y 
end;
tsort(u, function(o,n) return o < n end)
for _, z in pairs(v) do
	dnt = dnt..s..z 
end;

local creditsString = credit_header..'\n'..credit_sub..'\n'..credit_sub2..'\n'..special_thanks..'\n\n'..coding..q..'\n\n'..testing..r..'\n\n'..doners..dnt..'\n\n';

SuperVillain.Options.args.credits = {
	type = "group", 
	name = L["Credits"], 
	order = -1, 
	args = {
		new = {
			order = 1, 
			type = "description", 
			name = creditsString
		}
	}
}