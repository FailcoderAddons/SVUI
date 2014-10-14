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
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)

local playerClass = select(2, UnitClass("player"));

local filterClass = playerClass or "NONE"

local function safename(id)
    local n = GetSpellInfo(id)  
    if not n then
        if type(id) == "string" then
            n = id
        else
            SV:Debugger('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
            n = "Voodoo Doll";
        end
    end
    return n
end

--[[ SYSTEM DATA ]]--

SV.configs = {}

SV.configs["general"] = {
    ["cooldown"] = true, 
    ["autoScale"] = true,
    ["multiMonitor"] = false,
    ["taintLog"] = false, 
    ["stickyFrames"] = true, 
    ["loginmessage"] = true, 
    ["hideErrorFrame"] = true, 
    ["threatbar"] = false, 
    ["bubbles"] = true, 
    ["comix"] = true,
    ["bigComix"] = true,
    ["questWatch"] = true, 
    ["woot"] = true, 
    ["pvpinterrupt"] = true, 
    ["lookwhaticando"] = false,
    ["reactionChat"] = false,
    ["reactionEmote"] = false,
    ["sharingiscaring"] = false, 
    ["arenadrink"] = true, 
    ["stupidhat"] = true, 
}

SV.configs["LAYOUT"] = {
    mediastyle = "default",
    barstyle = "default",
    unitstyle = "default",
    groupstyle = "default", 
    aurastyle = "default"
}

SV.configs["totems"] = {
    ["enable"] = true, 
    ["showBy"] = "VERTICAL", 
    ["sortDirection"] = "ASCENDING", 
    ["size"] = 40, 
    ["spacing"] = 4
}

SV.configs["media"] = {
    ["fonts"] = {
        ["default"] = "SVUI System Font", 
        ["name"] = "SVUI Name Font", 
        ["number"] = "SVUI Number Font", 
        ["combat"] = "SVUI Combat Font", 
        ["giant"] = "SVUI Action Font", 
        ["size"] = 10, 
        ["unicodeSize"] = 12, 
    }, 
    ["textures"] = { 
        ["pattern"]      = "SVUI Backdrop 1", 
        ["comic"]        = "SVUI Comic 1", 
        ["unitlarge"]    = "SVUI Unit BG 3", 
        ["unitsmall"]    = "SVUI Small BG 3"
    }, 
    ["colors"] = {
        ["default"]      = {0.2, 0.2, 0.2, 1}, 
        ["special"]      = {0.37, 0.32, 0.29, 1}, 
    }, 
    ["unitframes"] = {
        ["health"]       = {0.3, 0.5, 0.3}, 
        ["power"]        = {
            ["MANA"]         = {0.41, 0.85, 1}, 
            ["RAGE"]         = {1, 0.31, 0.31}, 
            ["FOCUS"]        = {1, 0.63, 0.27}, 
            ["ENERGY"]       = {0.85, 0.83, 0.25}, 
            ["RUNES"]        = {0.55, 0.57, 0.61}, 
            ["RUNIC_POWER"] = {0, 0.82, 1}, 
            ["FUEL"]         = {0, 0.75, 0.75}
        }, 
        ["reaction"]     = {
            [1] = {0.92, 0.15, 0.15}, 
            [2] = {0.92, 0.15, 0.15}, 
            [3] = {0.92, 0.15, 0.15}, 
            [4] = {0.85, 0.85, 0.13}, 
            [5] = {0.19, 0.85, 0.13}, 
            [6] = {0.19, 0.85, 0.13}, 
            [7] = {0.19, 0.85, 0.13}, 
            [8] = {0.19, 0.85, 0.13}, 
        },
        ["tapped"]           = {0.55, 0.57, 0.61}, 
        ["disconnected"]     = {0.84, 0.75, 0.65}, 
        ["casting"]          = {0.8, 0.8, 0}, 
        ["spark"]            = {1, 0.72, 0}, 
        ["interrupt"]        = {0.78, 0.25, 0.25}, 
        ["shield_bars"]      = {0.56, 0.4, 0.62}, 
        ["buff_bars"]        = {0.31, 0.31, 0.31}, 
        ["debuff_bars"]      = {0.8, 0.1, 0.1}, 
        ["predict"]          = {
            ["personal"]         = {0, 1, 0.5, 0.25}, 
            ["others"]           = {0, 1, 0, 0.25}, 
            ["absorbs"]          = {1, 1, 0, 0.25}
        }, 
        ["spellcolor"] = {
            [safename(2825)] = {0.98, 0.57, 0.11},  --Bloodlust
            [safename(32182)] = {0.98, 0.57, 0.11}, --Heroism
            [safename(80353)] = {0.98, 0.57, 0.11}, --Time Warp
            [safename(90355)] = {0.98, 0.57, 0.11}, --Ancient Hysteria
            [safename(84963)] = {0.98, 0.57, 0.11}, --Inquisition
            [safename(86659)] = {0.98, 0.57, 0.11}, --Guardian of Ancient Kings
        }
    }
}

SV.configs["SVBar"] = {
	["enable"] = true, 
	["font"] = "Roboto", 
	["fontSize"] = 11,  
	["fontOutline"] = "OUTLINE",
	["countFont"] = "SVUI Number Font", 
	["countFontSize"] = 11,  
	["countFontOutline"] = "OUTLINE",
	["cooldownSize"] = 18, 
	["rightClickSelf"] = false, 
	["macrotext"] = false, 
	["hotkeytext"] = false, 
	["hotkeyAbbrev"] = true, 
	["showGrid"] = true, 
	["unc"] = {0.8, 0.1, 0.1, 0.7}, 
	["unpc"] = {0.5, 0.5, 1, 0.7}, 
	["keyDown"] = false, 
	["unlock"] = "SHIFT", 
	["Micro"] = {
		["enable"] = true, 
		["mouseover"] = true, 
		["alpha"] = 1, 
		["buttonsize"] = 30, 
		["buttonspacing"] = 4, 
		["yOffset"] = 4
	}, 
	["Bar1"] = {
		["enable"] = true, 
		["buttons"] = 12, 
		["mouseover"] = false, 
		["buttonsPerRow"] = 12, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = true, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "[form:2] 10;", 
		    ["PRIEST"]  	 = "[bonusbar:1] 7;", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "[stance:1] 7; [stance:2] 7; [stance:3] 7; [bonusbar:1] 7; [form:3] 7;", 
		    ["DRUID"]   	 = "[bonusbar:1, nostealth] 7; [bonusbar:1, stealth] 8; [bonusbar:2] 8; [bonusbar:3] 9; [bonusbar:4] 10;", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "[bonusbar:1] 7; [bonusbar:2] 8; [bonusbar:3] 9;", 
		}, 
		["alpha"] = 1
	}, 
	["Bar2"] = {
		["enable"] = false, 
		["mouseover"] = false, 
		["buttons"] = 12, 
		["buttonsPerRow"] = 12, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = false, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "", 
		    ["PRIEST"]  	 = "", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "", 
		    ["DRUID"]   	 = "", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "", 
		}, 
		["alpha"] = 1
	}, 
	["Bar3"] = {
		["enable"] = true, 
		["mouseover"] = false, 
		["buttons"] = 6, 
		["buttonsPerRow"] = 6, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = false, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "", 
		    ["PRIEST"]  	 = "", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "", 
		    ["DRUID"]   	 = "", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "", 
		}, 
		["alpha"] = 1
	}, 
	["Bar4"] = {
		["enable"] = true, 
		["mouseover"] = true, 
		["buttons"] = 12, 
		["buttonsPerRow"] = 1, 
		["point"] = "TOPRIGHT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = false, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "", 
		    ["PRIEST"]  	 = "", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "", 
		    ["DRUID"]   	 = "", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "", 
		}, 
		["alpha"] = 1
	}, 
	["Bar5"] = {
		["enable"] = true, 
		["mouseover"] = false, 
		["buttons"] = 6, 
		["buttonsPerRow"] = 6, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = false, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "", 
		    ["PRIEST"]  	 = "", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "", 
		    ["DRUID"]   	 = "", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "", 
		}, 
		["alpha"] = 1
	}, 
	["Bar6"] = {
		["enable"] = false, 
		["mouseover"] = false, 
		["buttons"] = 12, 
		["buttonsPerRow"] = 12, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 32, 
		["buttonspacing"] = 2, 
		["useCustomPaging"] = false, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[vehicleui] hide; [overridebar] hide; [petbattle] hide; show", 
		["customPaging"] = {
		    ["HUNTER"]  	 = "", 
		    ["WARLOCK"] 	 = "", 
		    ["PRIEST"]  	 = "", 
		    ["PALADIN"] 	 = "", 
		    ["MAGE"]    	 = "", 
		    ["ROGUE"]   	 = "", 
		    ["DRUID"]   	 = "", 
		    ["SHAMAN"]  	 = "", 
		    ["WARRIOR"] 	 = "", 
		    ["DEATHKNIGHT"]  = "", 
		    ["MONK"]    	 = "", 
		}, 
		["alpha"] = 1
	}, 
	["Pet"] = {
		["enable"] = true, 
		["mouseover"] = false, 
		["buttons"] = NUM_PET_ACTION_SLOTS, 
		["buttonsPerRow"] = NUM_PET_ACTION_SLOTS, 
		["point"] = "TOPLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 24, 
		["buttonspacing"] = 3, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[petbattle] hide; [pet, novehicleui, nooverridebar, nopossessbar] show; hide", 
		["alpha"] = 1
	}, 
	["Stance"] = {
		["enable"] = true, 
		["style"] = "darkenInactive", 
		["mouseover"] = false, 
		["buttons"] = NUM_STANCE_SLOTS, 
		["buttonsPerRow"] = NUM_STANCE_SLOTS, 
		["point"] = "BOTTOMLEFT", 
		["backdrop"] = false, 
		["buttonsize"] = 24, 
		["buttonspacing"] = 5, 
		["useCustomVisibility"] = false, 
		["customVisibility"] = "[petbattle] hide; show",  
		["alpha"] = 1
	}
};

SV.configs["SVAura"] = {
	["enable"] = true, 
	["disableBlizzard"] = true, 
	["font"] = "SVUI Number Font", 
	["fontSize"] = 12, 
	["fontOutline"] = "THINOUTLINE", 
	["countOffsetV"] = 0, 
	["countOffsetH"] = 0, 
	["timeOffsetV"] = -4, 
	["timeOffsetH"] = 0, 
	["hyperBuffs"] = {
		["enable"] = true, 
		["filter"] = true, 
	}, 
	["fadeBy"] = 5, 
	["buffs"] = {
		["showBy"] = "LEFT_DOWN", 
		["wrapAfter"] = 12, 
		["maxWraps"] = 3, 
		["wrapXOffset"] = 6, 
		["wrapYOffset"] = 16, 
		["sortMethod"] = "TIME", 
		["sortDir"] = "-", 
		["isolate"] = 1, 
		["size"] = 32, 
	}, 
	["debuffs"] = {
		["showBy"] = "LEFT_DOWN", 
		["wrapAfter"] = 12, 
		["maxWraps"] = 1, 
		["wrapXOffset"] = 6, 
		["wrapYOffset"] = 16, 
		["sortMethod"] = "TIME", 
		["sortDir"] = "-", 
		["isolate"] = 1, 
		["size"] = 32, 
	},
};

SV.configs["SVBag"] = {
	["incompatible"] = {
		["AdiBags"] = true,
		["ArkInventory"] = true,
		["Bagnon"] = true,
	},
	["enable"] = true, 
	["sortInverted"] = false, 
	["bags"] = {
		["xOffset"] = -40, 
		["yOffset"] = 40,
		["point"] = "BOTTOMRIGHT",
	},
	["bank"] = {
		["xOffset"] = 40, 
		["yOffset"] = 40,
		["point"] = "BOTTOMLEFT",
	},
	["bagSize"] = 34, 
	["bankSize"] = 34, 
	["alignToChat"] = false, 
	["bagWidth"] = 525, 
	["bankWidth"] = 525, 
	["currencyFormat"] = "ICON", 
	["ignoreItems"] = "", 
	["bagTools"] = true, 
	["bagBar"] = {
		["enable"] = false, 
		["showBy"] = "VERTICAL", 
		["sortDirection"] = "ASCENDING", 
		["size"] = 30, 
		["spacing"] = 4, 
		["showBackdrop"] = false, 
		["mouseover"] = false, 
	},
};

SV.configs["SVChat"] = {
	["enable"] = true, 
	["tabHeight"] = 20, 
	["tabWidth"] = 75, 
	["tabStyled"] = true, 
	["font"] = "Roboto", 
	["fontOutline"] = "OUTLINE", 
	["tabFont"] = "SVUI Alert Font", 
	["tabFontSize"] = 10, 
	["tabFontOutline"] = "OUTLINE", 
	["url"] = true, 
	["shortChannels"] = true, 
	["hyperlinkHover"] = true, 
	["throttleInterval"] = 45, 
	["fade"] = false, 
	["sticky"] = true, 
	["smileys"] = true, 
	["secretWordTone"] = "None", 
	["psst"] = "Whisper Alert", 
	["noWipe"] = false, 
	["timeStampFormat"] = "NONE", 
	["secretWords"] = "%MYNAME%, SVUI", 
	["basicTools"] = true,
};

SV.configs["SVDock"] = {
	["enable"] = true, 
	["dockLeftWidth"] = 412, 
	["dockLeftHeight"] = 224, 
	["dockRightWidth"] = 412, 
	["dockRightHeight"] = 224, 
	["dockStatWidth"] = defaultStatBarWidth,
	["buttonSize"] = 30, 
	["buttonSpacing"] = 4, 
	["leftDockBackdrop"] = true, 
	["rightDockBackdrop"] = true, 
	["topPanel"] = true, 
	["bottomPanel"] = true, 
	["docklets"] = {
		["DockletMain"] = "None", 
		["MainWindow"] = "None", 
		["DockletExtra"] = "None", 
		["ExtraWindow"] = "None", 
		["enableExtra"] = false, 
		["DockletCombatFade"] = true
	},
};

SV.configs["SVGear"] = {
	["enable"] = true, 
	["specialization"] = {
		["enable"] = false, 
	}, 
	["battleground"] = {
		["enable"] = false, 
	}, 
	["primary"] = "none", 
	["secondary"] = "none", 
	["equipmentset"] = "none", 
	["durability"] = {
		["enable"] = true, 
		["onlydamaged"] = true, 
	}, 
	["itemlevel"] = {
		["enable"] = true, 
	}, 
	["misc"] = {
		setoverlay = true, 
	}
};

SV.configs["SVHenchmen"] = {
	["enable"] = true,
	["autoRoll"] = false, 
	["vendorGrays"] = true, 
	["autoAcceptInvite"] = false, 
	["autorepchange"] = false, 
	["pvpautorelease"] = false, 
	["autoquestcomplete"] = false, 
	["autoquestreward"] = false, 
	["autoquestaccept"] = false, 
	["autodailyquests"] = false, 
	["autopvpquests"] = false, 
	["skipcinematics"] = false, 
	["mailOpener"] = true,
	["autoRepair"] = "PLAYER",
};

SV.configs["SVMap"] = {
	["incompatible"] = {
		["SexyMap"] = true,
		["SquareMap"] = true,
		["PocketPlot"] = true,
	},
	["enable"] = true, 
	["mapAlpha"] = 1, 
	["tinyWorldMap"] = true, 
	["size"] = 240, 
	["customshape"] = true, 
	["locationText"] = "CUSTOM", 
	["playercoords"] = "CUSTOM", 
	["bordersize"] = 6, 
	["bordercolor"] = "light", 
	["minimapbar"] = {
		["enable"] = true, 
		["styleType"] = "HORIZONTAL", 
		["layoutDirection"] = "NORMAL", 
		["buttonSize"] = 28, 
		["mouseover"] = false, 
	},
};

SV.configs["SVOverride"] = {
	["enable"] = true, 
	["loot"] = true, 
	["lootRoll"] = true, 
	["lootRollWidth"] = 328, 
	["lootRollHeight"] = 28,
};

SV.configs["SVPlate"] = {
	["enable"] = true, 
	["filter"] = {}, 
	["font"] = "SVUI Name Font", 
	["fontSize"] = 10, 
	["fontOutline"] = "OUTLINE", 
	["comboPoints"] = true, 
	["nonTargetAlpha"] = 0.6, 
	["combatHide"] = false, 
	["colorNameByValue"] = true, 
	["showthreat"] = true, 
	["targetcount"] = true, 
	["pointer"] = {
		["enable"] = true, 
		["colorMatchHealthBar"] = true, 
		["color"] = {0.9, 1, 0.9}, 
	}, 
	["healthBar"] = {
		["lowThreshold"] = 0.4, 
		["width"] = 108, 
		["height"] = 9, 
		["text"] = {
			["enable"] = false, 
			["format"] = "CURRENT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["attachTo"] = "CENTER", 
		}, 
	}, 
	["castBar"] = {
		["height"] = 6, 
		["color"] = {1, 0.81, 0}, 
		["noInterrupt"] = {0.78, 0.25, 0.25}, 
	}, 
	["raidHealIcon"] = {
		["xOffset"] =  -4, 
		["yOffset"] = 6, 
		["size"] = 36, 
		["attachTo"] = "LEFT", 
	}, 
	["threat"] = {
		["enable"] = false, 
		["goodScale"] = 1, 
		["badScale"] = 1, 
		["goodColor"] = {0.29, 0.68, 0.3}, 
		["badColor"] = {0.78, 0.25, 0.25}, 
		["goodTransitionColor"] = {0.85, 0.77, 0.36}, 
		["badTransitionColor"] = {0.94, 0.6, 0.06}, 
	}, 
	["auras"] = {
		["font"] = "SVUI Number Font", 
		["fontSize"] = 7, 
		["fontOutline"] = "OUTLINE", 
		["numAuras"] = 5, 
		["additionalFilter"] = "CC"
	}, 
	["reactions"] = {
		["tapped"] = {0.6, 0.6, 0.6}, 
		["friendlyNPC"] = { 0.31, 0.45, 0.63}, 
		["friendlyPlayer"] = {0.29, 0.68, 0.3}, 
		["neutral"] = {0.85, 0.77, 0.36}, 
		["enemy"] = {0.78, 0.25, 0.25}, 
	}, 
};

SV.configs["SVStats"] = {
	["enable"] = true, 
	["font"] = "SVUI Number Font", 
	["fontSize"] = 12, 
	["fontOutline"] = "OUTLINE",
	["showBackground"] = true,
	["shortGold"] = true,
	["panels"] = {
		["BottomRightDataPanel"] = {
			["right"] = "Bags", 
			["left"] = "Friends", 
			["middle"] = "Guild", 
		}, 
		["BottomLeftDataPanel"] = {
			["left"] = "Time", 
			["middle"] = "System", 	
			["right"] = "Gold", 
		}, 
		["TopLeftDataPanel"] = {
			["left"] = "Durability Bar", 
			["middle"] = "Reputation Bar", 
			["right"] = "Experience Bar", 
		},
		["TopRightDataPanel"] = {
			["left"] = "None", 
			["middle"] = "None", 
			["right"] = "None", 
		}, 
	}, 
	["localtime"] = true, 
	["time24"] = false, 
	["battleground"] = true, 
	["topLeftDockPanel"] = true, 
	["bottomLeftDockPanel"] = true, 
	["bottomRightDockPanel"] = true, 
	["panelTransparency"] = false,
};

SV.configs["SVTip"] = {
	["enable"] = true, 
	["cursorAnchor"] = false, 
	["targetInfo"] = true, 
	["playerTitles"] = true, 
	["guildRanks"] = true, 
	["inspectInfo"] = false, 
	["itemCount"] = true, 
	["spellID"] = false, 
	["progressInfo"] = true, 
	["visibility"] = {
		["unitFrames"] = "NONE", 
		["combat"] = false, 
	}, 
	["healthBar"] = {
		["text"] = true, 
		["height"] = 10, 
		["font"] = "Roboto", 
		["fontSize"] = 10, 
	}, 
};

SV.configs["SVUnit"] = {
	["enable"] = true, 
	["disableBlizzard"] = true, 

	["smoothbars"] = false, 
	["statusbar"] = "SVUI BasicBar", 
	["auraBarStatusbar"] = "SVUI BasicBar", 

	["font"] = "SVUI Number Font", 
	["fontSize"] = 12, 
	["fontOutline"] = "OUTLINE", 

	["auraFont"] = "SVUI Alert Font", 
	["auraFontSize"] = 12, 
	["auraFontOutline"] = "OUTLINE", 

	["OORAlpha"] = 0.65,
	["groupOORAlpha"] = 0.45, 
	["combatFadeRoles"] = true, 
	["combatFadeNames"] = true, 
	["debuffHighlighting"] = true, 
	["smartRaidFilter"] = true, 
	["fastClickTarget"] = false, 
	["healglow"] = true, 
	["glowtime"] = 0.8, 
	["glowcolor"] = {1, 1, 0}, 
	["autoRoleSet"] = false, 
	["healthclass"] = true, 
	["forceHealthColor"] = false, 
	["overlayAnimation"] = true, 
	["powerclass"] = false, 
	["colorhealthbyvalue"] = true, 
	["customhealthbackdrop"] = true, 
	["classbackdrop"] = false, 
	["auraBarByType"] = true, 
	["auraBarShield"] = true, 
	["castClassColor"] = false, 
	["xrayFocus"] = true,
	["grid"] = {
		["enable"] = false,
		["size"] = 28,
		["shownames"] = false,
		["font"] = "Roboto",
		["fontsize"] = 16,
	}, 
	["player"] = {
		["enable"] = true, 
		["width"] = 215, 
		["height"] = 60, 
		["lowmana"] = 30, 
		["combatfade"] = false, 
		["predict"] = false, 
		["threatEnabled"] = true, 
		["playerExpBar"] = false, 
		["playerRepBar"] = false, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "current", 
			["name_colored"] = true, 
			["name_length"] = 21, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:current]", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 11, 
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "", 
			["height"] = 10, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0,
			["detachedWidth"] = 250, 
			["attachTextToPower"] = false, 
			["druidMana"] = true,
			["fontSize"] = 11,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 13, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["pvp"] = 
		{
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
			["position"] = "BOTTOM", 
			["tags"] = "||cFFB04F4F[pvptimer][mouseover]||r", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 50, 
			["overlay"] = true, 
			["camDistanceScale"] = 1.4, 
			["rotation"] = 0, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "DEBUFFS", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = true, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "DEBUFFS", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = true, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 215, 
			["height"] = 20, 
			["matchFrameWidth"] = true, 
			["icon"] = true, 
			["latency"] = false, 
			["format"] = "REMAINING", 
			["ticks"] = false, 
			["spark"] = true, 
			["displayTarget"] = false, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["classbar"] = 
		{
			["enable"] = true, 
			["slideLeft"] = true, 
			["inset"] = "inset", 
			["height"] = 25, 
			["detachFromFrame"] = false,
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 25, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["combatIcon"] = {
				["enable"] = true, 
				["size"] = 26, 
				["attachTo"] = "INNERTOPRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["restIcon"] = {
				["enable"] = true, 
				["size"] = 25, 
				["attachTo"] = "INNERTOPRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
		["stagger"] = 
		{
			["enable"] = true, 
		}, 
	}, 
	["target"] = {
		["enable"] = true, 
		["width"] = 215, 
		["height"] = 60, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["predict"] = false, 
		["smartAuraDisplay"] = "DISABLED", 
		["middleClickFocus"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "current", 
			["name_colored"] = true, 
			["name_length"] = 18, 
			["smartlevel"] = true, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:current]", 
			["position"] = "INNERLEFT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = true, 
			["fontSize"] = 11,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "[power:color][power:current]", 
			["height"] = 10, 
			["position"] = "INNERRIGHT", 
			["hideonnpc"] = true, 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["attachTextToPower"] = false,
			["fontSize"] = 11,
		}, 
		["name"] = 
		{
			["position"] = "INNERRIGHT", 
			["tags"] = "[name:color][name:18][smartlevel]", 
			["xOffset"] = -2, 
			["yOffset"] = 36, 
			["font"] = "SVUI Name Font", 
			["fontSize"] = 15, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 50, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1.4, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "DEBUFFS", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 215, 
			["height"] = 20, 
			["matchFrameWidth"] = true, 
			["icon"] = true, 
			["format"] = "REMAINING", 
			["spark"] = true, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["combobar"] = 
		{
			["enable"] = true, 
			["height"] = 30, 
			["smallIcons"] = false, 
			["hudStyle"] = false, 
			["hudScale"] = 64, 
			["autoHide"] = true, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 30, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}
		}, 
	}, 
	["targettarget"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 150, 
		["height"] = 30, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 10, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 9,
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["tags"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0,
			["fontSize"] = 9,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "[name:color][name:10]", 
			["xOffset"] = 0, 
			["yOffset"] = 1, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] =  -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] =  0, 
			["yOffset"] =  8, 
			["sizeOverride"] = 0, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["focus"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["width"] = 170, 
		["height"] = 30, 
		["predict"] = false, 
		["smartAuraDisplay"] = "DISABLED", 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 15, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "[name:color][name:15]", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMRIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 170, 
			["height"] = 18, 
			["icon"] = true, 
			["matchFrameWidth"] = true,
			["format"] = "REMAINING", 
			["spark"] = true, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "FRAME", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["useFilter"] = "", 
			["friendlyAuraType"] = "HELPFUL", 
			["enemyAuraType"] = "HARMFUL", 
			["height"] = 18, 
			["sort"] = "TIME_REMAINING", 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["focustarget"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 150, 
		["height"] = 26, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 15, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "INNERRIGHT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["tags"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["xOffset"] = 0, 
			["yOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "[name:color][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["pet"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["width"] = 150, 
		["height"] = 30, 
		["predict"] = false, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 10, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "INNERRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["tags"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "[name:color][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = true, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = -3, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 3, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 130, 
			["height"] = 8, 
			["icon"] = false, 
			["matchFrameWidth"] = true,
			["format"] = "REMAINING", 
			["spark"] = false, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
	}, 
	["pettarget"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = false, 
		["width"] = 130, 
		["height"] = 26, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 15, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "INNERRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["tags"] = "", 
			["height"] = 7, 
			["position"] = "INNERLEFT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "CENTER", 
			["tags"] = "[name:color][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 14, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMLEFT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = true, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = -8, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "BOTTOMRIGHT", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterBlocked"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "", 
			["xOffset"] = 0, 
			["yOffset"] = 8, 
			["sizeOverride"] = 0, 
		}, 
	}, 
	["boss"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["showBy"] = "UP", 
		["width"] = 200, 
		["height"] = 45, 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "current", 
			["name_colored"] = true, 
			["name_length"] = 15, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:current]", 
			["position"] = "INNERTOPRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = true,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "[power:color][power:current]", 
			["height"] = 7, 
			["position"] = "INNERBOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 7, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 35, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["tags"] = "[name:color][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 2, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = false, 
			["filterRaid"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  -8, 
			["yOffset"] =  0, 
			["sizeOverride"] = 40, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] =  -8, 
			["yOffset"] =  0, 
			["sizeOverride"] = 40, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 200, 
			["height"] = 18, 
			["icon"] = true, 
			["matchFrameWidth"] = true,
			["format"] = "REMAINING", 
			["spark"] = true, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 22, 
				["attachTo"] = "CENTER", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["arena"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["showBy"] = "UP", 
		["width"] = 215, 
		["height"] = 45,  
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "current", 
			["name_colored"] = true, 
			["name_length"] = 15, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:current]", 
			["position"] = "INNERTOPRIGHT", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = true,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "[power:color][power:current]", 
			["height"] = 7, 
			["position"] = "INNERBOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 7, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["tags"] = "[name:color][name:15]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Number Font", 
			["fontSize"] = 12, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterRaid"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "Shield", 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["xOffset"] = -8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 40, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT", 
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterBlocked"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterAllowed"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["filterInfinite"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["useFilter"] = "CC", 
			["filterDispellable"] = 
			{
				friendly = false, 
				enemy = false, 
			}, 
			["xOffset"] = -8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 40, 
		}, 
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 215, 
			["height"] = 18, 
			["icon"] = true, 
			["matchFrameWidth"] = true,
			["format"] = "REMAINING", 
			["spark"] = true, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["pvp"] = 
		{
			["enable"] = true,
			["trinketPosition"] = "LEFT",
			["trinketSize"] = 45,
			["trinketX"] = -2, 
			["trinketY"] = 0,
			["specPosition"] = "RIGHT",
			["specSize"] = 45,
			["specX"] = 2, 
			["specY"] = 0,
		}, 
	}, 
	["party"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, exists][nogroup] hide;show", 
		["showBy"] = "UP_RIGHT", 
		["wrapXOffset"] = 9, 
		["wrapYOffset"] = 13, 
		["groupCount"] = 1, 
		["gRowCol"] = 1,
		["customSorting"] = false,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC",
		["invertGroupingOrder"] = false, 
		["startFromCenter"] = false, 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 70, 
		["height"] = 70,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 10, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "", 
			["frequentUpdates"] = false, 
			["height"] = 7, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["tags"] = "[name:color][name:10]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Narrator Font", 
			["fontSize"] = 13, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 2, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHTTOP", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 2, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHTTOP", 
			["verticalGrowth"] = "DOWN", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
			["fontSize"] = 11, 
		}, 
		["petsGroup"] = 
		{
			["enable"] = false, 
			["width"] = 30, 
			["height"] = 30,
			["gridAllowed"] = true,
			["anchorPoint"] = "BOTTOMLEFT", 
			["xOffset"] =  - 1, 
			["yOffset"] = 0, 
			["name_length"] = 3, 
			["tags"] = "[name:3]", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["width"] = 30, 
			["height"] = 30,
			["gridAllowed"] = true,
			["anchorPoint"] = "TOPLEFT", 
			["xOffset"] =  - 1, 
			["yOffset"] = 0, 
			["name_length"] = 3, 
			["tags"] = "[name:3]", 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 25, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = -4, 
			}, 
		}, 
		["portrait"] = 
		{
			["enable"] = true, 
			["width"] = 45, 
			["overlay"] = true, 
			["rotation"] = 0, 
			["camDistanceScale"] = 1, 
			["style"] = "3D", 
		}, 
	}, 
	["raid10"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, noexists][@raid11, exists][nogroup] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["groupCount"] = 2, 
		["gRowCol"] = 1,
		["customSorting"] = false,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 75, 
		["height"] = 34,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 4, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "", 
			["frequentUpdates"] = false, 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["tags"] = "[name:color][name:4]", 
			["yOffset"] = 0, 
			["xOffset"] = 8, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = -8, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = -4, 
			}, 
		}, 
	}, 
	["raid25"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, noexists][@raid11, noexists][@raid26, exists][nogroup] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["groupCount"] = 5, 
		["gRowCol"] = 1,
		["customSorting"] = false,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 50, 
		["height"] = 30,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 4, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = true, 
			["tags"] = "", 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["tags"] = "[name:color][name:4]", 
			["yOffset"] = 0, 
			["xOffset"] = 8, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = -8, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = -4, 
			}, 
		}, 
	}, 
	["raid40"] = {
		["enable"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[@raid6, noexists][@raid11, noexists][@raid26, noexists][nogroup] hide;show", 
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8, 
		["groupCount"] = 8, 
		["gRowCol"] = 1,
		["customSorting"] = false,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 50, 
		["height"] = 30,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "none", 
			["name_colored"] = true, 
			["name_length"] = 4, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{ 
			["tags"] = "", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["power"] = 
		{
			["enable"] = false, 
			["tags"] = "", 
			["frequentUpdates"] = false, 
			["height"] = 4, 
			["position"] = "BOTTOMRIGHT", 
			["hideonnpc"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["tags"] = "[name:color][name:4]", 
			["yOffset"] = 0, 
			["xOffset"] = 8, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 22, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 15, 
				["attachTo"] = "INNERBOTTOMRIGHT", 
				["xOffset"] = -8, 
				["yOffset"] = 0, 
			}, 
			["roleIcon"] = 
			{
				["enable"] = true, 
				["size"] = 12, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = 0, 
			}, 
			["raidRoleIcons"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "TOPLEFT", 
				["xOffset"] = 8, 
				["yOffset"] = -4, 
			}, 
		},
	}, 
	["raidpet"] = {
		["enable"] = false, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[group:raid] show; hide", 
		["showBy"] = "DOWN_RIGHT", 
		["wrapXOffset"] = 3, 
		["wrapYOffset"] = 3, 
		["groupCount"] = 2, 
		["gRowCol"] = 1,
		["customSorting"] = true,
		["sortMethod"] = "PETNAME", 
		["sortDir"] = "ASC",  
		["invertGroupingOrder"] = false, 
		["startFromCenter"] = false, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 80, 
		["height"] = 30,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "deficit", 
			["name_colored"] = true, 
			["name_length"] = 4, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:deficit]", 
			["position"] = "BOTTOM", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERTOPLEFT", 
			["tags"] = "[name:color][name:4]", 
			["yOffset"] = 4, 
			["xOffset"] = -4, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["buffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = true, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = false, 
			["perrow"] = 3, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "RIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT", 
			["filterPlayer"] = false, 
			["filterBlocked"] = true, 
			["filterAllowed"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "", 
			["xOffset"] = 8, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["auraWatch"] = 
		{
			["enable"] = true, 
			["size"] = 8, 
		}, 
		["rdebuffs"] = 
		{
			["enable"] = true, 
			["size"] = 26, 
			["xOffset"] = 0, 
			["yOffset"] = 2, 
		}, 
		["icons"] = 
		{
			["raidicon"] = 
			{
				["enable"] = true, 
				["size"] = 18, 
				["attachTo"] = "INNERTOPLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			}, 
		}, 
	}, 
	["tank"] = {
		["enable"] = true, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["width"] = 120, 
		["height"] = 28,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "deficit", 
			["name_colored"] = true, 
			["name_length"] = 8, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:deficit]", 
			["position"] = "INNERRIGHT", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["tags"] = "[name:color][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "RIGHT", 
			["xOffset"] = 1, 
			["yOffset"] = 0, 
			["width"] = 120, 
			["height"] = 28, 
		}, 
	}, 
	["assist"] = {
		["enable"] = true, 
		["threatEnabled"] = true, 
		["rangeCheck"] = true, 
		["width"] = 120, 
		["height"] = 28,
		["gridAllowed"] = true,
		["formatting"] = {
			["power_colored"] = true, 
			["power_type"] = "none", 
			["power_class"] = false, 
			["power_alt"] = false, 
			["health_colored"] = true, 
			["health_type"] = "deficit", 
			["name_colored"] = true, 
			["name_length"] = 8, 
			["smartlevel"] = false, 
			["absorbs"] = false, 
			["threat"] = false, 
			["incoming"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
		}, 
		["misc"] = {
			["tags"] = ""
		}, 
		["health"] = 
		{
			["tags"] = "[health:color][health:deficit]", 
			["position"] = "INNERRIGHT", 
			["orientation"] = "HORIZONTAL", 
			["frequentUpdates"] = false, 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["reversed"] = false,
			["fontSize"] = 10,
		}, 
		["name"] = 
		{
			["position"] = "INNERLEFT", 
			["tags"] = "[name:color][name:8]", 
			["yOffset"] = 0, 
			["xOffset"] = 0, 
			["font"] = "SVUI Default Font", 
			["fontSize"] = 10, 
			["fontOutline"] = "OUTLINE", 
		}, 
		["targetsGroup"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "RIGHT", 
			["xOffset"] = 1, 
			["yOffset"] = 0, 
			["width"] = 120, 
			["height"] = 28, 
		}, 
	}
}

--[[ CACHE DATA ]]--

local BUFFWATCH_BY_CLASS = {
    PRIEST = {
        {-- Weakened Soul
            ["enabled"] = true, 
            ["id"] = 6788, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Prayer of Mending
            ["enabled"] = true, 
            ["id"] = 41635, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Renew
            ["enabled"] = true, 
            ["id"] = 139, 
            ["point"] = "BOTTOMLEFT", 
            ["color"] = {["r"] = 0.4, ["g"] = 0.7, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Power Word: Shield
            ["enabled"] = true, 
            ["id"] = 17, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Power Word: Shield Power Insight
            ["enabled"] = true, 
            ["id"] = 123258, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.81, ["g"] = 0.85, ["b"] = 0.1}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Power Infusion
            ["enabled"] = true, 
            ["id"] = 10060, 
            ["point"] = "RIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Guardian Spirit
            ["enabled"] = true, 
            ["id"] = 47788, 
            ["point"] = "LEFT", 
            ["color"] = {["r"] = 0.86, ["g"] = 0.44, ["b"] = 0}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Pain Suppression
            ["enabled"] = true, 
            ["id"] = 33206, 
            ["point"] = "LEFT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    DRUID = {
        {-- Rejuvenation
            ["enabled"] = true, 
            ["id"] = 774, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Regrowth
            ["enabled"] = true, 
            ["id"] = 8936, 
            ["point"] = "BOTTOMLEFT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Lifebloom
            ["enabled"] = true, 
            ["id"] = 33763, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Wild Growth
            ["enabled"] = true, 
            ["id"] = 48438, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    PALADIN = {
        {-- Beacon of Light
            ["enabled"] = true, 
            ["id"] = 53563, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Hand of Protection
            ["enabled"] = true, 
            ["id"] = 1022, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Hand of Freedom
            ["enabled"] = true, 
            ["id"] = 1044, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.45, ["b"] = 0}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Hand of Salvation
            ["enabled"] = true, 
            ["id"] = 1038, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Hand of Sacrifice
            ["enabled"] = true, 
            ["id"] = 6940, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.1, ["b"] = 0.1}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Hand of Purity
            ["enabled"] = true, 
            ["id"] = 114039, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.64, ["g"] = 0.41, ["b"] = 0.72}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Sacred Shield
            ["enabled"] = true, 
            ["id"] = 20925, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.93, ["g"] = 0.75, ["b"] = 0},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Eternal Flame
            ["enabled"] = true, 
            ["id"] = 114163, 
            ["point"] = "BOTTOMLEFT", 
            ["color"] = {["r"] = 0.87, ["g"] = 0.7, ["b"] = 0.03}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    SHAMAN = {
        {-- Riptide
            ["enabled"] = true, 
            ["id"] = 61295, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.7, ["g"] = 0.3, ["b"] = 0.7}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Earth Shield
            ["enabled"] = true, 
            ["id"] = 974, 
            ["point"] = "BOTTOMLEFT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.7, ["b"] = 0.2}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Earthliving
            ["enabled"] = true, 
            ["id"] = 51945, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0.4}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    MONK = {
        {--Renewing Mist
            ["enabled"] = true, 
            ["id"] = 119611, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.8, ["g"] = 0.4, ["b"] = 0.8}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Life Cocoon
            ["enabled"] = true, 
            ["id"] = 116849, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Enveloping Mist
            ["enabled"] = true, 
            ["id"] = 132120, 
            ["point"] = "BOTTOMLEFT", 
            ["color"] = {["r"] = 0.4, ["g"] = 0.8, ["b"] = 0.2}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Zen Sphere
            ["enabled"] = true, 
            ["id"] = 124081, 
            ["point"] = "BOTTOMRIGHT", 
            ["color"] = {["r"] = 0.7, ["g"] = 0.4, ["b"] = 0}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    ROGUE = {
        {-- Tricks of the Trade
            ["enabled"] = true, 
            ["id"] = 57934, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    MAGE = {
        {-- Ice Ward
            ["enabled"] = true, 
            ["id"] = 111264, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1}, 
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    WARRIOR = {
        {-- Vigilance
            ["enabled"] = true, 
            ["id"] = 114030, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.2, ["b"] = 1},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Intervene
            ["enabled"] = true, 
            ["id"] = 3411, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Safe Guard
            ["enabled"] = true, 
            ["id"] = 114029, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    },
    DEATHKNIGHT = {
        {-- Unholy Frenzy
            ["enabled"] = true, 
            ["id"] = 49016, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
            ["anyUnit"] = false, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },  
    },
    HUNTER = {},
    WARLOCK = {},
    NONE = {}
}

local FilterIDs = {
    ["Blocked"] = [[36900,36901,36893,114216,97821,36032,132365,8733,57724,25771,57723,36032,58539,26013,6788,71041,41425,55711,8326,23445,24755,25163,80354,95809,95223,124275,124274,124273,117870,123981,15007,113942,89140]],
    ["Allowed"] = [[31821,2825,32182,80353,90355,47788,33206,116849,22812,1490,116202,123059,136431,137332,137375,144351,142863,142864,142865,143198]],
    ["Strict"] = [[123059,136431,137332,137375,144351,142863,142864,142865,143198]],
    ["CC"] = [[47476,91800,91807,91797,108194,115001,33786,2637,339,78675,22570,5211,9005,102359,99,127797,45334,102795,114238,113004,3355,1513,19503,34490,24394,64803,19386,117405,128405,50519,91644,90337,54706,4167,90327,56626,50245,50541,96201,96201,31661,118,55021,122,82691,118271,44572,33395,102051,20066,10326,853,105593,31935,105421,605,64044,8122,9484,15487,114404,88625,113792,87194,2094,1776,6770,1833,51722,1330,408,88611,115197,113953,51514,64695,63685,76780,118905,118345,710,6789,118699,5484,6358,30283,24259,115782,115268,118093,89766,137143,20511,7922,676,105771,107566,132168,107570,118895,18498,116706,117368,115078,122242,119392,119381,120086,116709,123407,140023,25046,20549,107079]],
    ["Shield"] = [[17,47515,45243,45438,115610,48797,48792,49039,87256,55233,50461,33206,47788,62618,47585,104773,110913,108359,22812,102342,106922,61336,19263,53480,1966,31224,74001,5277,45182,98007,30823,108271,1022,6940,114039,31821,498,642,86659,31850,118038,55694,97463,12975,114029,871,114030,120954,131523,122783,122278,115213,116849,20594]],
    ["Player"] = [[17,47515,45243,45438,45438,115610,110909,12051,12472,80353,12042,32612,110960,108839,111264,108843,48797,48792,49039,87256,49222,55233,50461,49016,51271,96268,33206,47788,62618,47585,6346,10060,114239,119032,27827,104773,110913,108359,113860,113861,113858,88448,22812,102342,106922,61336,117679,102543,102558,102560,16689,132158,106898,1850,106951,29166,52610,69369,112071,124974,19263,53480,51755,54216,34471,3045,3584,131894,90355,90361,31224,74001,5277,45182,51713,114018,2983,121471,11327,108212,57933,79140,13750,98007,30823,108271,16188,2825,79206,16191,8178,58875,108281,108271,16166,114896,1044,1022,1038,6940,114039,31821,498,642,86659,20925,31850,31884,53563,31842,54428,105809,85499,118038,55694,97463,12975,114029,871,114030,18499,1719,23920,114028,46924,3411,107574,120954,131523,122783,122278,115213,116849,125174,116841,20594,59545,20572,26297,68992]],
    ["Raid"] = [[116281,116784,116417,116942,116161,117708,118303,118048,118135,117878,117949,116835,116778,116525,122761,122760,122740,123812,123180,123474,122835,123081,122125,121885,121949,117436,118091,117519,122752,123011,116161,123121,119985,119086,119775,122151,138349,137371,136767,137641,137359,137972,136903,136753,137633,137731,133767,133768,136050,138569,134691,137440,137408,137360,135000,143436,143579,147383,146124,144851,144358,144774,147207,144215,143990,144330,143494,142990,143919,143766,143773,146589,143777,143385,143974,145183]]
}

local FilterOverrides = {
    ["45438"] = 5, ["48797"] = 5, ["87256"] = 4, 
    ["33206"] = 3, ["47585"] = 5, ["22812"] = 2, 
    ["102342"] = 2, ["19263"] = 5, ["5277"] = 5, 
    ["1022"] = 5, ["31821"] = 3, ["498"] = 2, 
    ["642"] = 5, ["86659"] = 4, ["31850"] = 4, 
    ["118038"] = 5, ["114029"] = 2, ["871"] = 3, 
    ["120954"] = 2, ["131523"] = 5
}

SV.configs["filter"] = {
    ["CC"] = {},
    ["Shield"] = {},
    ["Player"] = {},
    ["Blocked"] = {},
    ["Allowed"] = {},
    ["Strict"] = {},
    ["Raid"] = {},
    ["BuffWatch"] = BUFFWATCH_BY_CLASS[filterClass],
    ["PetBuffWatch"] = {
        {-- Frenzy
            ["enabled"] = true, 
            ["id"] = 19615, 
            ["point"] = "TOPLEFT", 
            ["color"] = {["r"] = 0.89, ["g"] = 0.09, ["b"] = 0.05},
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
        {-- Mend Pet
            ["enabled"] = true, 
            ["id"] = 136, 
            ["point"] = "TOPRIGHT", 
            ["color"] = {["r"] = 0.2, ["g"] = 0.8, ["b"] = 0.2}, 
            ["anyUnit"] = true, 
            ["onlyShowMissing"] = false, 
            ['style'] = 'coloredIcon', 
            ['displayText'] = false, 
            ['textColor'] = {["r"] = 1, ["g"] = 1, ["b"] = 1}, 
            ['textThreshold'] = -1, 
            ['xOffset'] = 0, 
            ['yOffset'] = 0
        },
    }
}

for k, x in pairs(FilterIDs) do
    local src = {};
    for id in x:gmatch("([^,]+)") do
        if(id) then
            local saved
            local n = safename(id);
            local p = FilterOverrides[tostring(id)] or 0;
            if k == "Strict" then
                saved = {['enable'] = true, ['spellID'] = id, ['priority'] = p}
            else
                saved = {['enable'] = true, ['priority'] = p}
            end
            src[n] = saved
        end 
    end
    SV.configs["filter"][k] = src
end