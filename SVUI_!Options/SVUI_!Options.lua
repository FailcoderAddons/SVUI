--[[
##########################################################
S V U I   By: Munglunch
##########################################################
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;
local type          = _G.type;
local error         = _G.error;
local pcall         = _G.pcall;
local print         = _G.print;
local ipairs        = _G.ipairs;
local pairs         = _G.pairs;
local next          = _G.next;
local rawset        = _G.rawset;
local rawget        = _G.rawget;
local tostring      = _G.tostring;
local tonumber      = _G.tonumber;
local getmetatable  = _G.getmetatable;
local setmetatable  = _G.setmetatable;
local tinsert 	 =  _G.tinsert;
local table 	 =  _G.table;
local wipe       =  _G.wipe;
--[[ TABLE METHODS ]]--
local tsort = table.sort;
local IsAddOnLoaded         = _G.IsAddOnLoaded;
--[[
##########################################################
GET ADDON DATA
##########################################################
]]--
local SV = _G['SVUI']
local L = SV.L;
local _, SVUIOptions = ...;
local SVUILib = Librarian("Registry");
local AceGUI = LibStub("AceGUI-3.0", true);
local AceConfig = LibStub("AceConfig-3.0");
local AceConfigDialog = LibStub("AceConfigDialog-1.0");
local AceGUIWidgetLSMlists = AceGUIWidgetLSMlists;
local GameTooltip = GameTooltip;
local GetNumEquipmentSets = GetNumEquipmentSets;
local GetEquipmentSetInfo = GetEquipmentSetInfo;
local sortingFunction = function(arg1, arg2) return arg1 < arg2 end
local GUIWidth = SV.LowRez and 890 or 1090;
local playerRealm = GetRealmName()
local playerName = UnitName("player")
local profileKey = ("%s - %s"):format(playerName, playerRealm)
local DockableAddons = {
	["alDamageMeter"] = L["alDamageMeter"],
	["Skada"] = L["Skada"],
	["Recount"] = L["Recount"],
	["TinyDPS"] = L["TinyDPS"],
	["Omen"] = L["Omen"],
	--["Details"] = L["Details"]
};

local NONE = _G.NONE;
local GetSpellInfo = _G.GetSpellInfo;
local collectgarbage = _G.collectgarbage;

local allFilterTable, userFilterTable, tempFilterTable = {},{},{};
local CURRENT_FILTER_TYPE = NONE;

AceConfig:RegisterOptionsTable(SV.NameID, SV.Options);
AceConfigDialog:SetDefaultSize(SV.NameID, GUIWidth, 651);

SVUIOptions.FilterOptionGroups = {};
SVUIOptions.FilterOptionSpells = {};

local function GetLiveDockletsA()
	local test = SV.private.Docks.Embed2;
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if(n:find("Skada") and _G.Skada) then
			for index,window in pairs(_G.Skada:GetWindows()) do
			    local name = window.db.name
			    local key = "SkadaBarWindow"..name
			    if(not test or test ~= key) then
			    	t["SkadaBarWindow"..name] = (key == "Skada") and "Skada - Main" or "Skada - "..name;
			    end
			end
		elseif((not test) or (not test:find(n))) then
			if IsAddOnLoaded(n) or IsAddOnLoaded(l) then t[n] = l end
		end
	end
	return t;
end

local function GetLiveDockletsB()
	local test = SV.private.Docks.Embed1;
	local t = {["None"] = L["None"]};
	for n,l in pairs(DockableAddons) do
		if(n:find("Skada") and _G.Skada) then
			for index,window in pairs(_G.Skada:GetWindows()) do
			    local name = window.db.name
			    local key = "SkadaBarWindow"..name
			    if(not test or test ~= key) then
			    	t["SkadaBarWindow"..name] = (key == "Skada") and "Skada - Main" or "Skada - "..name;
			    end
			end
		elseif((not test) or (not test:find(n))) then
			if IsAddOnLoaded(n) or IsAddOnLoaded(l) then t[n] = l end
		end
	end
	return t;
end
--[[
##########################################################
INIT OPTIONS
##########################################################
]]--
local function RefreshProfileOptions()
	local hasProfile = true;
	local currentProfile = SVUILib:CurrentProfile()
	if(not currentProfile) then
		hasProfile = false
		currentProfile = profileKey
	end
	SV.Options.args.profiles.desc = " |cff66FF33" .. L["current"] .. currentProfile .. "|r";
	local optionGroup = SV.Options.args.profiles.args

	optionGroup.spacer1 = {
		order = 1,
		type = "description",
		name = "|cff66FF33" .. L["current"] .. currentProfile .. "|r",
		width = "full",
	}
	optionGroup.spacer2 = {
		order = 2,
		type = "description",
		name = "",
		width = "full",
	}
	optionGroup.dualSpec = {
		order = 3,
		type = "toggle",
		name = "Dual-Spec Switching",
		get = function() return SVUILib:CheckDualProfile() end,
		set = function(key, value) SVUILib:ToggleDualProfile(value) end,
		width = 'full'
	}
	optionGroup.importdesc = {
		order = 4,
		type = "description",
		name = function()
			if(SVUILib:CheckDualProfile()) then
				return "\n" .. L["Can not Save, Copy or Change while dual spec swapping is enabled"]
			else
				return "\n" .. L["import_desc"]
			end
		end,
		width = "full"
	}
	optionGroup.spacer3 = {
		order = 5,
		type = "description",
		name = "",
		width = "full",
	}
	optionGroup.export = {
		name = L["export"],
		desc = L["export_sub"],
		type = "input",
		order = 6,
		get = false,
		set = function(key, value) SVUILib:CloneDatabase(value) SV:SavedPopup() RefreshProfileOptions() end,
		disabled = function()
			local t = SVUILib:CheckProfiles()
			return ((not t) or SVUILib:CheckDualProfile())
		end,
	}
	optionGroup.copy = {
		name = L["Copy"],
		desc = L["Copy from another profile. Further changes from other characters using this profile will not affect this one."],
		type = "select",
		order = 7,
		get = function() return currentProfile end,
		set = function(key, value) SV:CopyProfile(value) SV:SavedPopup() RefreshProfileOptions() end,
		disabled = function()
			local t = SVUILib:CheckProfiles()
			return ((not t) or SVUILib:CheckDualProfile())
		end,
		values = SVUILib:GetProfiles(),
	}
	optionGroup.import = {
		name = L["Share"],
		desc = L["Share an already existing profile. Changes made by any characters using this profile will be shared."],
		type = "select",
		order = 8,
		get = function() return currentProfile end,
		set = function(key, value) SV:LinkProfile(value) SV:SavedPopup() RefreshProfileOptions() end,
		disabled = function()
			local t = SVUILib:CheckProfiles()
			return ((not t) or SVUILib:CheckDualProfile())
		end,
		values = SVUILib:GetProfiles(),
		width = 'fill',
	}
	optionGroup.spacer4 = {
		order = 9,
		type = "description",
		name = "",
		width = "full",
	}
	optionGroup.spacer5 = {
		order = 10,
		type = "description",
		name = L["delete_desc"],
		width = "full",
	}
	optionGroup.delete = {
		order = 11,
		type = "select",
		name = L["delete"],
		desc = L["delete_sub"],
		get = function() return " SELECT ONE" end,
		set = function(key, value) SVUILib:Remove(value) end,
		values = SVUILib:GetProfiles(),
		disabled = function() local t = SVUILib:CheckProfiles() return (not t) end,
		confirm = true,
		confirmText = L["delete_confirm"],
	}
	optionGroup.spacer6 = {
		order = 12,
		type = "description",
		name = "",
		width = "full",
	}
	optionGroup.spacer7 = {
		order = 13,
		type = "description",
		name = L["reset_desc"],
		width = "full",
	}
	optionGroup.reset = {
		order = 14,
		type = "execute",
		name = function() return L["reset"] .. " " .. " |cffFFFF00" .. currentProfile .. "|r" end,
		desc = L["reset_sub"],
		func = function() SV:StaticPopup_Show("RESET_PROFILE_PROMPT") end,
		width = 'full'
	}
end

function SVUIOptions:SetToFontConfig(font)
	font = font or "Default";
	AceConfigDialog:SelectGroup(SV.NameID, "Fonts", "fontGroup", font);
end

local function GetUserFilterList()
	wipe(userFilterTable);
	userFilterTable[""] = NONE;
	for filter in pairs(SV.db.Filters.Custom) do
		userFilterTable[filter] = filter
	end
	return userFilterTable
end

local function GetAllFilterList()
	wipe(allFilterTable);
	allFilterTable[""] = NONE;
	for filter in pairs(SV.db.Filters) do
		if(filter == 'Raid') then
			allFilterTable[filter] = "Consolidated"
		elseif(filter ~= 'Custom') then
			allFilterTable[filter] = filter
		end
	end
	for filter in pairs(SV.db.Filters.Custom) do
		allFilterTable[filter] = filter
	end
	return allFilterTable
end

function SVUIOptions:SetFilterOptions(filterType, selectedSpell)
	local FILTER
	CURRENT_FILTER_TYPE = filterType
	if(SV.db.Filters.Custom[filterType]) then
		FILTER = SV.db.Filters.Custom[filterType]
	else
		FILTER = SV.db.Filters[filterType]
	end
	if((not filterType) or (filterType == "") or (not FILTER)) then
		SV.Options.args.Filters.args.filterGroup = nil;
		SV.Options.args.Filters.args.spellGroup = nil;
		return
	end
	if(not self.FilterOptionGroups[filterType]) then
		self.FilterOptionGroups[filterType] = self.FilterOptionGroups['_NEW'](filterType);
	end
	SV.Options.args.Filters.args.filterGroup = self.FilterOptionGroups[filterType](selectedSpell)
	if(not self.FilterOptionSpells[filterType]) then
		self.FilterOptionSpells[filterType] = self.FilterOptionSpells['_NEW'](filterType);
	end
	SV.Options.args.Filters.args.spellGroup = self.FilterOptionSpells[filterType](selectedSpell);
	SV.Events:Trigger("AURA_FILTER_OPTIONS_CHANGED");
	collectgarbage("collect")
end


function SVUIOptions:SetToFilterConfig(newFilter)
	local filter = newFilter or "BuffWatch";
	self:SetFilterOptions(filter);
	_G.LibStub("AceConfigDialog-1.0"):SelectGroup(SV.NameID, "Filters");
end

local generalFonts = {
	["default"] = {
		order = 1,
		name = "Default",
		desc = "Standard font for the majority of uses."
	},
	["dialog"] = {
		order = 2,
		name = "Dialog",
		desc = "Font used in places that story text appears. (ie.. quest text)"
	},
	["combat"] = {
		order = 3,
		name = "Combat",
		desc = "Scrolling combat text font."
	},
	["alert"] = {
		order = 4,
		name = "Alerts",
		desc = "Font used for on-screen message alerts."
	},
	["zone"] = {
		order = 5,
		name = "Zone Text",
		desc = "Font used for zone names. Shown when changing zones."
	},
	["title"] = {
		order = 6,
		name = "Titles",
		desc = "Font used to display various titles."
	},
	["header"] = {
		order = 7,
		name = "Frame Headers",
		desc = "Font used to large names at the top of some frames."
	},
	["caps"] = {
		order = 8,
		name = "Caps",
		desc = "Font typically used for things like tabs and fitted headers."
	},
};
local numberFonts = {
	["number"] = {
		order = 1,
		name = "Numbers (Regular)",
		desc = "Font used to display most numeric values."
	},
	["number_big"] = {
		order = 2,
		name = "Numbers (Large)",
		desc = "Font used to display larger numeric values."
	},
	["aura"]   = {
		order = 3,
		name = "Auras",
		desc = "Aura counts and timers use this font."
	},
};
local lootFonts = {
	["lootdialog"] = {
		order = 1,
		name = "Loot Frame Dialog",
		desc = "Default font used in the loot frame"
	},
    ["lootnumber"] = {
		order = 2,
		name = "Loot Frame Numbers",
		desc = "Font used in the loot frame to display numeric values."
	},
	["rolldialog"] = {
		order = 3,
		name = "Roll Frame Dialog",
		desc = "Default font used in the loot-roll frame"
	},
    ["rollnumber"] = {
		order = 4,
		name = "Roll Frame Numbers",
		desc = "Font used in the loot-roll frame to display numeric values."
	},
};
local miscFonts = {
	["data"] = {
		order = 1,
		name = "Docked Stats",
		desc = "Font used by the bottom and top data docks."
	},
	["narrator"] = {
		order = 2,
		name = "Narratives",
		desc = "Font used for things like the 'Meanwhile' tag."
	},
	["pixel"] = {
		order = 3,
		name = "Pixel",
		desc = "Tiniest fonts."
	},
};

SV.Options.args.primary = {
	type = "group",
	order = 1,
	name = L["Main"],
	get = function(j) return SV.db[j[#j]] end,
	set = function(j, value) SV.db[j[#j]] = value end,
	args = {
		introGroup1 = {
			order = 1,
			name = "",
			type = "description",
			width = "full",
			image = function() return SV.SplashImage, 256, 128 end,
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
					order = 1,
					width = "full",
					type = "execute",
					name = L["Install"],
					desc = L["Run the installation process."],
					func = function() SV.Setup:Install() SV:ToggleConfig() end
				},
				Themes = {
					order = 2,
					width = "full",
					type = "execute",
					name = L["Themes"],
					desc = L["Select an available theme."],
					func = function() SV.Setup:SelectTheme() SV:ToggleConfig() end
				},
				Backdrops = {
					order = 3,
					width = "full",
					type = "execute",
					name = L["Backdrops"],
					desc = L["Change all backdrop art randomly."],
					func = function() SV.Setup:RandomBackdrops() end
				},
				ToggleAnchors = {
					order = 4,
					width = "full",
					type = "execute",
					name = L["Move Frames"],
					desc = L["Unlock various elements of the UI to be repositioned."],
					func = function() SV:MoveAnchors() end
				},
				ResetMoveables = {
					order = 5,
					width = "full",
					type = "execute",
					name = L["Reset SVUI Anchors"],
					desc = L["Reset all movable frames to their original positions."],
					func = function() SV:StaticPopup_Show("RESETLAYOUT_CHECK") end
				},
				ResetDraggables = {
					order = 6,
					width = "full",
					type = "execute",
					name = L["Reset Blizzard Anchors"],
					desc = L["Reset all draggable Blizzard frames to their original positions."],
					func = function() SV:StaticPopup_Show("RESETBLIZZARD_CHECK") end
				},
			},
		},
	}
}

SV.Options.args.Core = {
	type = "group",
	order = 2,
	name = L['General Options'],
	childGroups = "tab",
	get = function(key) return SV.db[key[#key]] end,
	set = function(key, value) SV.db[key[#key]] = value end,
	args = {}
}

SV.Options.args.Core.args.mostCommon = {
	type = "group",
	order = 1,
	name = "Most Common",
	guiInline = true,
	args = {
		LoginMessage = {
			order = 1,
			type = 'toggle',
			name = L['Login Messages'],
			get = function(j)return SV.db.general.loginmessage end,
			set = function(j,value)SV.db.general.loginmessage = value end
		},
		LoginCredits = {
			order = 2,
			type = 'toggle',
			name = L['Login Credits'],
			get = function(j)return SV.db.general.logincredits end,
			set = function(j,value)SV.db.general.logincredits = value end
		},
		useDraggable = {
			order = 3,
			type = "toggle",
			name = L["Enable Draggable"],
			desc = L["Allow many default Blizzard frames to be draggable"],
			get = function(j)return SV.db.general.useDraggable end,
			set = function(j,value)SV.db.general.useDraggable = value; SV:StaticPopup_Show("RL_CLIENT") end
		},
		saveDraggable = {
			order = 4,
			type = "toggle",
			name = L["Save Draggable"],
			desc = L["Save the positions of draggable frames when they are moved. NOTE: THIS WILL OVERRIDE BLIZZARD FRAME SNAPPING!"],
			get = function(j)return SV.db.general.saveDraggable end,
			set = function(j,value)SV.db.general.saveDraggable = value; SV:StaticPopup_Show("RL_CLIENT") end
		},
		cooldownText = {
			order = 5,
			type = "toggle",
			name = L['Cooldown Text'],
			desc = L["Display cooldown text on anything with the cooldown spiral."],
			get = function(j)return SV.db.general.cooldown end,
			set = function(j,value)SV.db.general.cooldown = value; SV:StaticPopup_Show("RL_CLIENT")end
		},
		texture = {
			order = 6,
			type = "group",
			name = L["Textures"],
			guiInline = true,
			get = function(key)
				return SV.media.shared.background[key[#key]].file
			end,
			set = function(key, value)
				SV.media.shared.background[key[#key]].file = value
				SV:RefreshEverything(true)
			end,
			args = {
				pattern = {
					type = "select",
					dialogControl = 'LSM30_Background',
					order = 1,
					name = L["Primary Texture"],
					values = AceGUIWidgetLSMlists.background
				},
				premium = {
					type = "select",
					dialogControl = 'LSM30_Background',
					order = 1,
					name = L["Secondary Texture"],
					values = AceGUIWidgetLSMlists.background
				}
			}
		},
		colors = {
			order = 7,
			type = "group",
			name = L["Colors"],
			guiInline = true,
			args = {
				customClassColor = {
					type = "toggle",
					order = 1,
					name = L["Use Custom Class Colors"],
					desc = L["Use the enhanced class colors provided by SVUI"],
					get = function(key) return SV.db.general.customClassColor end,
					set = function(key, value) SV.db.general.customClassColor = value; SV:StaticPopup_Show("RL_CLIENT") end,
				},
				default = {
					type = "color",
					order = 2,
					name = L["Default Color"],
					desc = L["Main color used by most UI elements. (ex: Backdrop Color)"],
					hasAlpha = true,
					get = function(key)
						local color = SV.media.color.default
						return color[1],color[2],color[3],color[4]
					end,
					set = function(key, rValue, gValue, bValue, aValue)
						SV.media.color.default = {rValue, gValue, bValue, aValue}
						SV:UpdateSharedMedia()
					end,
				},
				special = {
					type = "color",
					order = 3,
					name = L["Accent Color"],
					desc = L["Color used in various frame accents.  (ex: Dressing Room Backdrop Color)"],
					hasAlpha = true,
					get = function(key)
						local color = SV.media.color.special
						return color[1],color[2],color[3],color[4]
					end,
					set = function(key, rValue, gValue, bValue, aValue)
						SV.media.color.special = {rValue, gValue, bValue, aValue}
						SV.media.color.specialdark = {(rValue * 0.75), (gValue * 0.75), (bValue * 0.75), aValue}
						SV:UpdateSharedMedia()
					end,
				},
				resetbutton = {
					type = "execute",
					order = 4,
					name = L["Restore Defaults"],
					func = function()
						SV.media.color.default = {0.15, 0.15, 0.15, 1};
						SV.media.color.special = {0.4, 0.32, 0.2, 1};
						SV:UpdateSharedMedia()
					end
				}
			}
		},
		loot = {
			order = 8,
			type = "toggle",
			name = L['Loot Frame'],
			desc = L['Enable/Disable the loot frame.'],
			get = function()return SV.db.general.loot end,
			set = function(j,value)SV.db.general.loot = value;SV:StaticPopup_Show("RL_CLIENT")end
		},
		lootRoll = {
			order = 9,
			type = "toggle",
			name = L['Loot Roll'],
			desc = L['Enable/Disable the loot roll frame.'],
			get = function()return SV.db.general.lootRoll end,
			set = function(j,value)SV.db.general.lootRoll = value;SV:StaticPopup_Show("RL_CLIENT")end
		},
		lootRollWidth = {
			order = 10,
			type = 'range',
			width = "full",
			name = L["Roll Frame Width"],
			min = 100,
			max = 328,
			step = 1,
			get = function()return SV.db.general.lootRollWidth end,
			set = function(a,b) SV.db.general.lootRollWidth = b; end,
		},
		lootRollHeight = {
			order = 11,
			type = 'range',
			width = "full",
			name = L["Roll Frame Height"],
			min = 14,
			max = 58,
			step = 1,
			get = function()return SV.db.general.lootRollHeight end,
			set = function(a,b) SV.db.general.lootRollHeight = b; end,
		},
	}
};

SV.Options.args.Core.args.Extras = {
	type = "group",
	order = 2,
	name = "Extras",
	guiInline = true,
	get = function(a)return SV.db["Extras"][a[#a]]end,
	set = function(a,b)SV:ChangeDBVar(b,a[#a]); end,
	args = {
		common = {
			order = 1,
			type = "group",
			name = L["General"],
			guiInline = true,
			args = {
				threatbar = {
					order = 1,
					type = 'toggle',
					name = L["Threat Thermometer"],
					desc = L["Enable/disable the custom SVUI threat meter"],
					get = function(j)return SV.db["Extras"].threatbar end,
					set = function(j,value)SV.db["Extras"].threatbar = value; SV:StaticPopup_Show("RL_CLIENT") end
				},
				woot = {
					order = 2,
					type = 'toggle',
					name = L["Say Thanks"],
					desc = L["Thank someone when they cast specific spells on you. Typically resurrections"],
					get = function(j)return SV.db["Extras"].woot end,
					set = function(j,value)SV.db["Extras"].woot = value;SV:ToggleReactions()end
				},
				pvpinterrupt = {
					order = 3,
					type = 'toggle',
					name = L["Report PVP Actions"],
					desc = L["Announce your interrupts, as well as when you have been sapped!"],
					get = function(j)return SV.db["Extras"].pvpinterrupt end,
					set = function(j,value)SV.db["Extras"].pvpinterrupt = value;SV:ToggleReactions()end
				},
				lookwhaticando = {
					order = 4,
					type = 'toggle',
					name = L["Report Spells"],
					desc = L["Announce various helpful spells cast by players in your party/raid"],
					get = function(j)return SV.db["Extras"].lookwhaticando end,
					set = function(j,value)SV.db["Extras"].lookwhaticando = value;SV:ToggleReactions()end
				},
				sharingiscaring = {
					order = 5,
					type = 'toggle',
					name = L["Report Shareables"],
					desc = L["Announce when someone in your party/raid has laid a feast or repair bot"],
					get = function(j)return SV.db["Extras"].sharingiscaring end,
					set = function(j,value)SV.db["Extras"].sharingiscaring = value;SV:ToggleReactions()end
				},
				reactionChat = {
					order = 6,
					type = 'toggle',
					name = L["Report in Chat"],
					desc = L["Announcements will be sent to group chat channels"],
					get = function(j)return SV.db["Extras"].reactionChat end,
					set = function(j,value)SV.db["Extras"].reactionChat = value;SV:ToggleReactions()end
				},
				reactionEmote = {
					order = 7,
					type = 'toggle',
					name = L["Auto Emotes"],
					desc = L["Some announcements are accompanied by player emotes."],
					get = function(j)return SV.db["Extras"].reactionEmote end,
					set = function(j,value)SV.db["Extras"].reactionEmote = value;SV:ToggleReactions()end
				},
			}
		},
		automations = {
			order = 2,
			type = "group",
			name = L["Automations"],
			guiInline = true,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["Adjust the behavior of the many automations."]
				},
				automationGroup1 = {
					order = 2,
					type = "group",
					guiInline = true,
					name = L["Task Minions"],
					desc = L['Minions that can make certain tasks easier by handling them automatically.'],
					args = {
						mailOpener = {
							order = 1,
							type = 'toggle',
							name = L["Enable Mail Helper"],
							get = function(j) return SV.db["Extras"].mailOpener end,
							set = function(j,value) SV.db["Extras"].mailOpener = value; SV:ToggleMailMinions() end
						},
						autoAcceptInvite = {
							order = 2,
							name = L['Accept Invites'],
							desc = L['Automatically accept invites from guild/friends.'],
							type = 'toggle',
							get = function(j) return SV.db["Extras"].autoAcceptInvite end,
							set = function(j,value) SV.db["Extras"].autoAcceptInvite = value end
						},
						vendorGrays = {
							order = 3,
							name = L['Vendor Grays'],
							desc = L['Automatically vendor gray items when visiting a vendor.'],
							type = 'toggle',
							get = function(j) return SV.db["Extras"].vendorGrays end,
							set = function(j,value) SV.db["Extras"].vendorGrays = value end
						},
						pvpautorelease = {
							order = 4,
							type = "toggle",
							name = L['PvP Autorelease'],
							desc = L['Automatically release body when killed inside a battleground.'],
							get = function(j) return SV.db["Extras"].pvpautorelease end,
							set = function(j,value) SV.db["Extras"].pvpautorelease = value; SV:StaticPopup_Show("RL_CLIENT") end
						},
						autorepchange = {
							order = 5,
							type = "toggle",
							name = L['Track Reputation'],
							desc = L['Automatically change your watched faction on the reputation bar to the faction you got reputation points for.'],
							get = function(j)return SV.db["Extras"].autorepchange end,
							set = function(j,value)SV.db["Extras"].autorepchange = value end
						},
						skipcinematics = {
							order = 6,
							type = "toggle",
							name = L['Skip Cinematics'],
							desc = L['Automatically skip any cinematic sequences.'],
							get = function(j)return SV.db["Extras"].skipcinematics end,
							set = function(j,value) SV.db["Extras"].skipcinematics = value; SV:StaticPopup_Show("RL_CLIENT") end
						},
						autoRepair = {
							order = 7,
							name = L['Auto Repair'],
							desc = L['Automatically repair using the following method when visiting a merchant.'],
							type = 'select',
							values = {
								['NONE'] = NONE,
								['GUILD'] = GUILD,
								['PLAYER'] = PLAYER
							},
							get = function(j)return SV.db["Extras"].autoRepair end,
							set = function(j,value)SV.db["Extras"].autoRepair = value end
						},
					}
				},
				automationGroup2 = {
					order = 3,
					type = "group",
					guiInline = true,
					name = L["Looting Minions"],
					desc = L['Minions that can make looting easier by rolling automatically.'],
					get = function(key) return SV.db.Extras[key[#key]] end,
					set = function(key,value) SV.db.Extras[key[#key]] = value; SV.Events:Trigger("LOOTING_UPVALUES_UPDATED"); end,
					disabled = function() return not SV.db.general.lootRoll end,
					args = {
						autoRoll = {
							order = 1,
							name = L['Auto Greed'],
							desc = L['Automatically select greed on loot rolls.'],
							type = 'toggle',
						},
						autoRollDisenchant = {
							order = 2,
							name = L['Auto Disenchant'],
							desc = L['"Auto Greed" will select disenchant (when available).'],
							type = 'toggle',
						},
						autoRollMaxLevel = {
							order = 3,
							name = L['Only Max Level'],
							desc = L['When set, "Auto Greed" will only operate if you are at max player level.'],
							type = 'toggle',
						},
						autoRollSoulbound = {
							order = 4,
							name = L['Allow Soulbound'],
							desc = L['When set, "Auto Greed" will include items that are BoP.'],
							type = 'toggle',
						},
						autoRollQuality = {
							order = 5,
							name = L['Max Quality'],
							desc = L['Set the highest item quality that "Auto Greed" will activate on.'],
							type = 'select',
							values = {
								['2'] = ITEM_QUALITY2_DESC,
								['3'] = ITEM_QUALITY3_DESC,
								['4'] = ITEM_QUALITY4_DESC
							},
						},
					}
				},
				automationGroup3 = {
					order = 4,
					type = "group",
					guiInline = true,
					name = L["Quest Minions"],
					desc = L['Minions that can make questing easier by automatically accepting/completing quests.'],
					args = {
						autoquestaccept = {
							order = 1,
							type = "toggle",
							name = L['Accept Quests'],
							desc = L['Automatically accepts quests as they are presented to you.'],
							get = function(j)return SV.db["Extras"].autoquestaccept end,
							set = function(j,value) SV.db["Extras"].autoquestaccept = value end
						},
						autoquestcomplete = {
							order = 2,
							type = "toggle",
							name = L['Complete Quests'],
							desc = L['Automatically complete quests when possible.'],
							get = function(j)return SV.db["Extras"].autoquestcomplete end,
							set = function(j,value)SV.db["Extras"].autoquestcomplete = value end
						},
						autoquestreward = {
							order = 3,
							type = "toggle",
							name = L['Select Quest Reward'],
							desc = L['Automatically select the quest reward with the highest vendor sell value.'],
							get = function(j)return SV.db["Extras"].autoquestreward end,
							set = function(j,value)SV.db["Extras"].autoquestreward = value end
						},
						autodailyquests = {
							order = 4,
							type = "toggle",
							name = L['Only Automate Dailies'],
							desc = L['Force the auto accept functions to only respond to daily quests. NOTE: This does not apply to daily heroics for some reason.'],
							get = function(j)return SV.db["Extras"].autodailyquests end,
							set = function(j,value)SV.db["Extras"].autodailyquests = value end
						},
						autopvpquests = {
							order = 5,
							type = "toggle",
							name = L['Accept PVP Quests'],
							get = function(j)return SV.db["Extras"].autopvpquests end,
							set = function(j,value)SV.db["Extras"].autopvpquests = value end
						},
					}
				},
			}
		},
		FunStuff = {
			type = "group",
			order = 12,
			name = L["Fun Stuff"],
			guiInline = true,
			args = {
				drunk = {
					order = 1,
					type = 'toggle',
					name = L["Drunk Mode"],
					get = function(j)return SV.db.FunStuff.drunk end,
					set = function(j,value) SV.db.FunStuff.drunk = value; SV.Drunk:Toggle() end,
				},
				comix = {
					order = 2,
					type = 'select',
					name = L["Comic Popups"],
					desc = '"All Popups" will include non-comic styles (ie.. TOASTY!)',
					get = function(j)return SV.db.FunStuff.comix end,
					set = function(j,value) SV.db.FunStuff.comix = value; SV.Comix:Toggle() end,
					values = {
						['NONE'] = NONE,
						['1'] = 'All Popups',
						['2'] = 'Comic Style Only',
					}
				},
				afk = {
					order = 3,
					type = 'select',
					name = L["AFK Screen"],
					get = function(j)return SV.db.FunStuff.afk end,
					set = function(j,value) SV.db.FunStuff.afk = value; SV.AFK:Toggle() end,
					values = {
						['NONE'] = NONE,
						['1'] = 'Fully Enabled',
						['2'] = 'Enabled (No Spinning)',
					}
				},
				gamemenu = {
					order = 4,
					type = 'select',
					name = L["Game Menu"],
					get = function(j)return SV.db.FunStuff.gamemenu end,
					set = function(j,value) SV.db.FunStuff.gamemenu = value; SV:StaticPopup_Show("RL_CLIENT") end,
					values = {
						['NONE'] = NONE,
						['1'] = 'You + Henchman',
						['2'] = 'You x2',
					}
				},
			}
		},
	}
};

local function GetGearSetList()
	local t = {["none"] = L["No Change"]}
	for i = 1, GetNumEquipmentSets() do
		local name = GetEquipmentSetInfo(i)
		if name then
			t[name] = name
		end
	end
	tsort(t, sortingFunction)
	return t
end

SV.Options.args.Core.args.Gear = {
	order = 3,
	type = 'group',
	name = "Gear",
	guiInline = true,
	get = function(key) return SV.db.Gear[key[#key]]end,
	set = function(key, value) SV.db.Gear[key[#key]] = value; SV:UpdateGearInfo() end,
	args = {
		intro = {
			order = 1,
			type = 'description',
			name = function()
				if(GetNumEquipmentSets()==0) then
					return ("%s\n|cffFF0000Must create an equipment set to use some of these features|r"):format(L["EQUIPMENT_DESC"])
				else
					return L["EQUIPMENT_DESC"]
				end
			end
		},
		specialization = {
			order = 2,
			type = "group",
			name = L["Specialization"],
			guiInline = true,
			disabled = function() return GetNumEquipmentSets() == 0 end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					name = L["Enable"],
					desc = L["Enable/Disable auto swapping gear sets when switching specializations."],
					get = function(key) return SV.db.Gear.specialization.enable end,
					set = function(key, value) SV.db.Gear.specialization.enable = value; SV:UpdateGearInfo() end
				},
				primary = {
					type = "select",
					order = 2,
					name = L["Primary Gear Set"],
					desc = L["Choose the equipment set to use for your primary specialization."],
					disabled = function() return not SV.db.Gear.specialization.enable end,
					values = GetGearSetList(),
					get = function(e) return SV.db.Gear.specialization.primary end,
					set = function(e,value) SV.db.Gear.specialization.primary = value; SV:UpdateGearInfo() end
				},
				secondary = {
					type = "select",
					order = 3,
					name = L["Secondary Gear Set"],
					desc = L["Choose the equipment set to use for your secondary specialization."],
					disabled = function() return not SV.db.Gear.specialization.enable end,
					values = GetGearSetList(),
					get = function(e) return SV.db.Gear.specialization.secondary end,
					set = function(e,value) SV.db.Gear.specialization.secondary = value; SV:UpdateGearInfo() end
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
					desc = L["Enable/Disable auto swapping gear sets in battlegrounds."],
					get = function(e) return SV.db.Gear.battleground.enable end,
					set = function(e,value) SV.db.Gear.battleground.enable = value; SV:UpdateGearInfo() end
				},
				equipmentset = {
					type = "select",
					order = 2,
					name = L["Battleground Gear Set"],
					desc = L["Choose the equipment set to use when you enter a battleground or arena."],
					disabled = function() return not SV.db.Gear.battleground.enable end,
					values = GetGearSetList(),
					get = function(e) return SV.db.Gear.battleground.equipmentset end,
					set = function(e,value) SV.db.Gear.battleground.equipmentset = value; SV:UpdateGearInfo() end
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
			get = function(e)return SV.db.Gear.durability[e[#e]]end,
			set = function(e,value)SV.db.Gear.durability[e[#e]] = value; SV:UpdateGearInfo() end,
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
					disabled = function()return not SV.db.Gear.durability.enable end
				}
			}
		},
		intro3 = {
			type = "description",
			name = L["ITEMLEVEL_DESC"],
			order = 6
		},
		itemlevels = {
			type = "group",
			name = STAT_AVERAGE_ITEM_LEVEL,
			guiInline = true,
			order = 7,
			args = {
				characterItemLevel = {
					type = "toggle",
					order = 1,
					name = L["Character Screen iLevels"],
					desc = L["Enable/Disable the display of item levels on the character screen."],
					get = function(e)return SV.db.Gear.labels.characterItemLevel end,
					set = function(e,value)SV.db.Gear.labels.characterItemLevel = value; SV:UpdateGearInfo() end,
				},
				inventoryItemLevel = {
					type = "toggle",
					order = 2,
					name = L["Inventory iLevels"],
					desc = L["Enable/Disable the display of item levels in your bags (or bank)."],
					get = function(e)return SV.db.Gear.labels.inventoryItemLevel end,
					set = function(e,value)SV.db.Gear.labels.inventoryItemLevel = value; SV:UpdateGearInfo() end,
				}
			}
		},
		setNames = {
			type = "group",
			name = L["Set Labels"],
			guiInline = true,
			order = 8,
			args = {
				inventoryGearSet = {
					type = "toggle",
					order = 1,
					name = L["Equipment Set Overlay"],
					desc = L["Show the associated equipment sets for the items in your bags (or bank)."],
					get = function(e)return SV.db.Gear.labels.inventoryGearSet end,
					set = function(e,value)SV.db.Gear.labels.inventoryGearSet = value; SV:UpdateGearInfo() end,
				}
			}
		}
	}
};

SV.Options.args.Core.args.errors = {
	order = 4,
	type = "group",
	name = L["Error Handling"],
	guiInline = true,
	args = {
		filterErrors = {
			order = 1,
			name = L["Filter Errors"],
			desc = L["Choose specific errors from the list below to hide/ignore"],
			type = "toggle",
			get = function(key)return SV.db.general.filterErrors end,
			set = function(key,value)SV.db.general.filterErrors = value; SV:UpdateErrorFilters() end
		},
		hideErrorFrame = {
			order = 2,
			name = L["Combat Hide All"],
			desc = L["Hides all errors regardless of filtering while in combat."],
			type = "toggle",
			disabled = function() return not SV.db.general.filterErrors end,
			get = function(key) return SV.db.general.hideErrorFrame end,
			set = function(key,value)SV.db.general.hideErrorFrame = value; SV:UpdateErrorFilters() end
		},
		filterGroup = {
			order = 3,
			type = "group",
			guiInline = true,
			name = L["Filters"],
			disabled = function() return not SV.db.general.filterErrors end,
			args = {}
		},
	}
};

SV.Options.args.Screen = {
	type = 'group',
	name = 'Screen',
	order = 3,
	get = function(a)return SV.db.screen[a[#a]] end,
	set = function(a,b) SV.db.screen[a[#a]] = b; end,
	args = {
		commonGroup = {
			order = 1,
			type = 'group',
			name = L['Basic Options'],
			guiInline = true,
			args = {
				autoScale = {
					order = 1,
					name = L["Auto Scale"],
					desc = L["Automatically scale the User Interface based on your screen resolution"],
					type = "toggle",
					get = function(j)return SV.db.screen.autoScale end,
					set = function(j,value)
						SV.db.screen.autoScale = value;
						if(value) then
							SV.db.screen.scaleAdjust = 0.64;
						end
						SV:StaticPopup_Show("RL_CLIENT")
					end
				},
				multiMonitor = {
					order = 2,
					name = L["Multi Monitor"],
					desc = L["Adjust UI dimensions to accomodate for multiple monitor setups"],
					type = "toggle",
					get = function(j)return SV.db.screen.multiMonitor end,
					set = function(j,value) SV.db.screen.multiMonitor = value; SV:StaticPopup_Show("RL_CLIENT") end
				},
			}
		},
		advancedGroup = {
			order = 2,
			type = 'group',
			name = L['Advanced Options'],
			guiInline = true,
			args = {
				advanced = {
					order = 1,
					name = L["Enable"],
					desc = L["These settings are for advanced users only!"],
					type = "toggle",
					get = function(j)return SV.db.screen.advanced end,
					set = function(j,value) SV.db.screen.advanced = value; SV:StaticPopup_Show("RL_CLIENT"); end
				},
				forcedWidth = {
					order = 2,
					name = L["Forced Width"],
					desc = function() return L["Setting your resolution height here will bypass all evaluated measurements. Current: "] .. SV.db.screen.forcedWidth; end,
					type = "input",
					disabled = function() return not SV.db.screen.advanced end,
					get = function(key) return SV.db.screen.forcedWidth end,
					set = function(key, value)
						local w = tonumber(value);
						if(not w) then
							SV:AddonMessage(L["Value must be a number"])
						elseif(w < 800) then
							SV:AddonMessage(L["Less than 800 is not allowed"])
						else
							SV.db.screen.forcedWidth = w;
							SV:StaticPopup_Show("RL_CLIENT");
						end
					end
				},
				forcedHeight = {
					order = 3,
					name = L["Forced Height"],
					desc = function() return L["Setting your resolution height here will bypass all evaluated measurements. Current: "] .. SV.db.screen.forcedHeight; end,
					type = "input",
					disabled = function() return not SV.db.screen.advanced end,
					get = function(key) return SV.db.screen.forcedHeight end,
					set = function(key, value)
						local h = tonumber(value);
						if(not h) then
							SV:AddonMessage(L["Value must be a number"])
						elseif(h < 600) then
							SV:AddonMessage(L["Less than 600 is not allowed"])
						else
							SV.db.screen.forcedHeight = h;
							SV:StaticPopup_Show("RL_CLIENT");
						end
					end
				},
				scaleAdjust = {
					order = 4,
					name = L["Base Scale"],
					desc = L["You can use this to adjust the base value applied to scale calculations."],
					type = "range",
					width = 'full',
					min = 0.25,
					max = 1,
					step = 0.01,
					disabled = function() return not SV.db.screen.advanced end,
					get = function(j)return SV.db.screen.scaleAdjust end,
					set = function(j,value)
						SV.db.screen.scaleAdjust = value;
						if(value ~= 0.64) then
							SV.db.screen.autoScale = false;
						end
						SV:StaticPopup_Show("RL_CLIENT")
					end
				},
			}
		},
	}
}
SV.Options.args.Fonts = {
	order = 4,
	type = "group",
	name = L['Fonts'],
	childGroups = "tab",
	args = {
		fontGroup = {
			order = 1,
			type = 'group',
			name = L['Font Options'],
			childGroups = "tree",
			args = {}
		}
	}
}
SV.Options.args.Dock = {
	type = "group",
	order = 5,
	name = SV.Dock.TitleID,
	args = {
  	intro = {
			order = 1,
			type = "description",
			name = "Configure the various frame docks around the screen"
		},
		generalGroup = {
			order = 2,
			type = "group",
			name = "General",
			guiInline = true,
			get = function(key)return SV.db.Dock[key[#key]];end,
			set = function(key,value)
				SV.Dock:ChangeDBVar(value,key[#key]);
				SV.Dock:Refresh()
			end,
			args = {
				bottomPanel = {
					order = 1,
					type = 'toggle',
					name = L['Bottom Panel'],
					desc = L['Display a border across the bottom of the screen.'],
					get = function(j) return SV.db.Dock.bottomPanel end,
					set = function(key,value) SV.Dock:ChangeDBVar(value,key[#key]); end
				},
				topPanel = {
					order = 2,
					type = 'toggle',
					name = L['Top Panel'],
					desc = L['Display a border across the top of the screen.'],
					get = function(j) return SV.db.Dock.topPanel end,
					set = function(key,value) SV.Dock:ChangeDBVar(value,key[#key]); end
				},
				buttonSize = {
					order = 3,
					type = "range",
					name = L["Dock Button Size"],
					desc = L["PANEL_DESC"],
					min = 20,
					max = 80,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.buttonSize;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
					end,
				},
			},
		},
		dataGroup = {
			order = 2,
			type = "group",
			name = "Reports (Data Texts)",
			guiInline = true,
			get = function(key)return SV.db.Reports[key[#key]];end,
			set = function(key,value)
				SV.Reports:ChangeDBVar(value,key[#key]);
			end,
			args = {
				time24 = {
					order = 1,
					type = "toggle",
					name = L["24-Hour Time"],
					desc = L["Toggle 24-hour mode for the time datatext."],
				},
				localtime = {
					order = 2,
					type = "toggle",
					name = L["Local Time"],
					desc = L["If not set to true then the server time will be displayed instead."]
				},
				battleground = {
					order = 3,
					type = "toggle",
					name = L["Battleground Texts"],
					desc = L["When inside a battleground display personal scoreboard information on the main datatext bars."]
				},
				backdrop = {
					order = 4,
					name = "Data Backgrounds",
					desc = L["Display background textures on docked data texts"],
					type = "toggle",
					set = function(key, value) SV.Reports:ChangeDBVar(value, key[#key]); SV.Reports:UpdateAllReports() end,
				},
				shortGold = {
					order = 5,
					type = "toggle",
					name = L["Shortened Gold Text"],
				},
				spacer1 = {
					order = 6,
					name = "",
					type = "description",
					width = "full",
				},
				dockCenterWidth = {
					order = 7,
					type = 'range',
					name = L['Stat Panel Width'],
					desc = L["PANEL_DESC"],
					min = 400,
					max = 1800,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.dockCenterWidth; end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
					end,
				},
				spacer2 = {
					order = 8,
					name = "",
					type = "description",
					width = "full",
				},
				buttonSize = {
					order = 9,
					type = "range",
					name = L["Dock Button Size"],
					desc = L["PANEL_DESC"],
					min = 20,
					max = 80,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.buttonSize;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
					end,
				},
			}
		},
		leftDockGroup = {
			order = 3,
			type = "group",
			name = L["Left Dock"],
			guiInline = true,
			args = {
				leftDockBackdrop = {
					order = 1,
					type = 'toggle',
					name = L['Left Dock Backdrop'],
					desc = L['Display a backdrop behind the left-side dock.'],
					get = function(j)return SV.db.Dock.leftDockBackdrop end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:UpdateDockBackdrops()
					end
				},
				dockLeftHeight = {
					order = 2,
					type = "range",
					name = L["Left Dock Height"],
					desc = L["PANEL_DESC"],
					min = 150,
					max = 600,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.dockLeftHeight;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
						if(SV.Chat) then
							SV.Chat:UpdateLocals()
							SV.Chat:RefreshChatFrames(true)
						end
					end,
				},
				dockLeftWidth = {
					order = 3,
					type = "range",
					name = L["Left Dock Width"],
					desc = L["PANEL_DESC"],
					min = 150,
					max = 700,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.dockLeftWidth;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
						if(SV.Chat) then
							SV.Chat:UpdateLocals()
							SV.Chat:RefreshChatFrames(true)
						end
					end,
				},
			}
		},
		rightDockGroup = {
			order = 4,
			type = "group",
			name = L["Right Dock"],
			guiInline = true,
			args = {
				rightDockBackdrop = {
					order = 1,
					type = 'toggle',
					name = L['Right Dock Backdrop'],
					desc = L['Display a backdrop behind the right-side dock.'],
					get = function(j)return SV.db.Dock.rightDockBackdrop end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value, key[#key]);
						SV.Dock:UpdateDockBackdrops()
					end
				},
				dockRightHeight = {
					order = 2,
					type = "range",
					name = L["Right Dock Height"],
					desc = L["PANEL_DESC"],
					min = 150,
					max = 600,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.dockRightHeight;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
						if(SV.Chat) then
							SV.Chat:UpdateLocals()
							SV.Chat:RefreshChatFrames(true)
						end
					end,
				},
				dockRightWidth = {
					order = 3,
					type = "range",
					name = L["Right Dock Width"],
					desc = L["PANEL_DESC"],
					min = 150,
					max = 700,
					step = 1,
					width = "full",
					get = function()return SV.db.Dock.dockRightWidth;end,
					set = function(key,value)
						SV.Dock:ChangeDBVar(value,key[#key]);
						SV.Dock:Refresh()
						if(SV.Chat) then
							SV.Chat:UpdateLocals()
							SV.Chat:RefreshChatFrames(true)
						end
						if(SV.Inventory) then
							SV.Inventory.BagFrame:UpdateLayout()
							if(SV.Inventory.BankFrame) then
								SV.Inventory.BankFrame:UpdateLayout()
							end
						end
					end,
				},
			}
		},
		toolsGroup = {
			order = 5,
			type = "group",
			name = L["Dock Tools"],
			guiInline = true,
			get = function(key) return SV.db.Dock.dockTools[key[#key]] end,
			set = function(key,value) SV.Dock:ChangeDBVar(value, key[#key], "dockTools"); SV:StaticPopup_Show("RL_CLIENT"); end,
			args = {
				garrison = {
					order = 1,
					type = 'toggle',
					name = L['Garrison Utility'],
					desc = L['Left click for landing, right click to use Garrison hearth.'],
				},
				leader = {
					order = 2,
					type = 'toggle',
					name = L['Raid Leader'],
					desc = L['Quick launch menu of raid leader tools.'],
				},
				primary = {
					order = 3,
					type = 'toggle',
					name = L['Primary Profession'],
					desc = L['Quick launch of your primary profession window'],
				},
				secondary = {
					order = 4,
					type = 'toggle',
					name = L['Secondary Profession'],
					desc = L['Quick launch of your secondary profession window'],
				},
				firstAid = {
					order = 5,
					type = 'toggle',
					name = L['First Aid'],
					desc = L['Quick launch of your first aid window'],
				},
				cooking = {
					order = 6,
					type = 'toggle',
					name = L['Cooking'],
					desc = L['Quick launch of your cooking window'],
				},
				archaeology = {
					order = 7,
					type = 'toggle',
					name = L['Archaeology'],
					desc = L['Quick launch of your archaeology window'],
				},
				hearth = {
					order = 8,
					type = 'toggle',
					name = L['Hearth Tool'],
					desc = L['Left click to use your hearthstone, right click for various class-based options.'],
				},
				specswap = {
					order = 9,
					type = 'toggle',
					name = L['Spec Swap'],
					desc = L['Click to simply swap specs (out of combat).'],
				},
				breakstuff = {
					order = 10,
					type = 'toggle',
					name = L['Break Stuff'],
					desc = L['This tool, when available and enabled, will allow you to single click items in your bags for certain abilities. [Milling, Prospecting, Disenchanting, Lockpicking or use a Skeleton Key]'],
				},
				power = {
					order = 11,
					type = 'toggle',
					name = L['Power Button'],
					desc = L['This tool gives you one-click access to logging out, reloading the UI and exiting the game]'],
				},
			}
		},
		reportGroup1 = {
			order = 6,
			type = "group",
			name = L["Bottom Stats: Left"],
			guiInline = true,
			args = {}
		},
		reportGroup2 = {
			order = 7,
			type = "group",
			name = L["Bottom Stats: Right"],
			guiInline = true,
			args = {}
		},
		reportGroup3 = {
			order = 8,
			type = "group",
			name = L["Top Stats: Left"],
			guiInline = true,
			args = {}
		},
		reportGroup4 = {
			order = 9,
			type = "group",
			name = L["Top Stats: Right"],
			guiInline = true,
			args = {}
		},
		AddonDocklets = {
			order = 10,
			type = "group",
			name = L["Docked Addons"],
			guiInline = true,
			args = {
				DockletMain = {
					type = "select",
					order = 1,
					name = "Primary Docklet",
					desc = "Select an addon to occupy the primary docklet window",
					values = function() return GetLiveDockletsA() end,
					get = function() return SV.private.Docks.Embed1 end,
					set = function(a,value) SV.private.Docks.Embed1 = value; if(SV.Skins) then SV.Skins:RegisterAddonDocklets() end end,
				},
				DockletSplit = {
					type = "select",
					order = 2,
					name = "Secondary Docklet",
					desc = "Select another addon",
					--disabled = function() return (SV.private.Docks.Embed1 == "None") end,
					values = function() return GetLiveDockletsB() end,
					get = function() return SV.private.Docks.Embed2 end,
					set = function(a,value) SV.private.Docks.Embed2 = value; if(SV.Skins) then SV.Skins:RegisterAddonDocklets() end end,
				}
			}
		},
	}
}
SV.Options.args.Filters = {
	type = "group",
	name = L["Aura Filters"],
	order = 9996,
	args = {}
}

local listIndex = 1;
local filterGroup = SV.Options.args.Core.args.errors.args.filterGroup.args;
for errorName, state in pairs(SV.db.general.errorFilters) do
	filterGroup[errorName] = {
		order = listIndex,
		type = 'toggle',
		name = errorName,
		width = 'full',
		get = function(key) return SV.db.general.errorFilters[errorName]; end,
		set = function(key,value) SV.db.general.errorFilters[errorName] = value; SV:UpdateErrorFilters() end
	}
	listIndex = listIndex + 1
end

local statValues = {[""] = "None"};
for name, _ in pairs(SV.Reports.Plugins) do
	statValues[name] = name;
end

for panelIndex, panelPositions in pairs(SV.db.REPORT_SLOTS) do
	local panelName = 'reportGroup' .. panelIndex;
	local optionTable = SV.Options.args.Dock.args;
	if(optionTable[panelName] and type(panelPositions) == "table") then
		for i = 1, #panelPositions do
			local slotName = 'Slot' .. i;
			optionTable[panelName].args[slotName] = {
				order = i,
				type = 'select',
				name = 'Slot '..i,
				values = statValues,
				get = function(key) return SV.db.REPORT_SLOTS[panelIndex][i] end,
				set = function(key, value) SV.db.REPORT_SLOTS[panelIndex][i] = value; SV.Reports:UpdateAllReports() end
			}
		end
	end
end

SV:GenerateFontOptionGroup("General", 1, "The most commonly used fonts. Changing these will require reloading the UI.", generalFonts)
SV:GenerateFontOptionGroup("Numeric", 2, "These fonts are used for many number values.", numberFonts)
SV:GenerateFontOptionGroup("Loot", 3, "Fonts used in loot frames.", lootFonts)
SV:GenerateFontOptionGroup("Misc", 4, "Fonts used in various places including the docks.", miscFonts)

SVUILib:LoadModuleOptions()
RefreshProfileOptions()

SVUIOptions.FilterOptionGroups['_NEW'] = function(filterType)
	return function()
		local RESULT, FILTER
		if(SV.db.Filters.Custom[filterType]) then
			FILTER = SV.db.Filters.Custom[filterType]
		else
			FILTER = SV.db.Filters[filterType]
		end
		if(FILTER) then
			RESULT = {
				type = "group",
				name = filterType,
				guiInline = true,
				order = 4,
				args = {
					addSpell = {
						order = 1,
						name = L["Add Spell"] ..  " by ID",
						desc = L["Add a spell to the filter by ID (number). You can use wowhead.com to find the ID of your desired spell"],
						type = "input",
						get = function(key) return "" end,
						set = function(key, value)
							local spellID = tonumber(value);
							if(not spellID) then
								SV:AddonMessage(L["Value must be a number"])
							elseif(not GetSpellInfo(spellID)) then
								SV:AddonMessage(L["Not valid spell id"])
							elseif(not FILTER[value]) then
								FILTER[value] = {['enable'] = true, ['id'] = spellID, ['priority'] = 0}
								SVUIOptions:SetFilterOptions(filterType)
								SV.Events:Trigger("AURA_FILTER_OPTIONS_CHANGED");
							end
						end
					},
					removeSpell = {
						order = 2,
						name = L["Remove Spell"],
						desc = L["Remove a spell from the filter."],
						type = "select",
						disabled = function()
							local EMPTY = true;
							for g in pairs(FILTER) do
								EMPTY = false;
							end
							return EMPTY
						end,
						values = function()
							wipe(tempFilterTable)
							for id, filterData in pairs(FILTER) do
								if(type(id) == 'string' and filterData.id) then
									local auraName = GetSpellInfo(filterData.id)
									if(auraName) then
										tempFilterTable[id] = auraName
									end
								end
							end
							return tempFilterTable
						end,
						get = function(key) return "" end,
						set = function(key, value)
							if(FILTER[value]) then
								if(FILTER[value].isDefault) then
									FILTER[value].enable = false;
									SV:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
								else
									FILTER[value] = nil
								end
							end
							SVUIOptions:SetFilterOptions(filterType)
							SV.Events:Trigger("AURA_FILTER_OPTIONS_CHANGED");
						end
					},
				}
			};
		end;
		return RESULT;
	end;
end;

SVUIOptions.FilterOptionSpells['_NEW'] = function(filterType)
	return function()
		local RESULT, FILTER
		if(SV.db.Filters.Custom[filterType]) then
			FILTER = SV.db.Filters.Custom[filterType]
		else
			FILTER = SV.db.Filters[filterType]
		end
		if(FILTER) then
			RESULT = {
				type = "group",
				name = filterType .. " - " .. L["Spells"],
				order = 5,
				guiInline = true,
				args = {}
			};
			for id, filterData in pairs(FILTER) do
				local auraName = GetSpellInfo(filterData.id)
				if(auraName) then
					RESULT.args[auraName] = {
						name = auraName,
						type = "toggle",
						get = function()
							return FILTER[id].enable
						end,
						set = function(key, value)
							FILTER[id].enable = value;
							SV.Events:Trigger("AURA_FILTER_OPTIONS_CHANGED");
							SVUIOptions:SetFilterOptions(filterType)
						end
					};
				end
			end
		end
		return RESULT;
	end;
end;

SV.Options.args.Filters.args.createFilter = {
	order = 1,
	name = L["Create Filter"],
	desc = L["Create a custom filter."],
	type = "input",
	get = function(key) return "" end,
	set = function(key, value)
		if(not value or (value and value == '')) then
			SV:AddonMessage(L["Not a usable filter name"])
		elseif(SV.db.Filters.Custom[value]) then
			SV:AddonMessage(L["Filter already exists"])
		else
			SV.db.Filters.Custom[value] = {};
			SVUIOptions:SetFilterOptions(value);
		end
	end
};

SV.Options.args.Filters.args.deleteFilter = {
	type = "select",
	order = 2,
	name = L["Delete Filter"],
	desc = L["Delete a custom filter."],
	get = function(key) return "" end,
	set = function(key, value)
		SV.db.Filters.Custom[value] = nil;
		SV.Options.args.Filters.args.filterGroup = nil
	end,
	values = GetUserFilterList()
};

SV.Options.args.Filters.args.selectFilter = {
	order = 3,
	type = "select",
	name = L["Select Filter"],
	get = function(key) return CURRENT_FILTER_TYPE end,
	set = function(key, value) SVUIOptions:SetFilterOptions(value) end,
	values = GetAllFilterList()
};

SV.OptionsLoaded = true;
