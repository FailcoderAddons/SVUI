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

local rez = GetCVar("gxResolution");
local defaultDockWidth = tonumber(rez:match("(%d+)x%d+")) * 0.5;
local defaultCenterWidth = min(defaultDockWidth, 800);

local function safename(id)
    local n = GetSpellInfo(id)  
    if not n then
        if type(id) == "string" then
            n = id
        else
            --SV:Debugger('|cffFF9900SVUI:|r Spell not found: (#ID) '..id)
            n = "Voodoo Doll";
        end
    end
    return n
end

local NAMEFONT = "SVUI Name Font";
if(GetLocale() ~= "enUS") then
	NAMEFONT = "Roboto"
end

SV.defaults = {};

SV.defaults["LAYOUT"] = {
    mediastyle = "default",
    barstyle = "default",
    unitstyle = "default",
    groupstyle = "default", 
    aurastyle = "default"
}

SV.defaults["general"] = {
    ["cooldown"] = true, 
    ["autoScale"] = true,
    ["multiMonitor"] = false,
    ["saveDraggable"] = false,
    ["taintLog"] = false, 
    ["stickyFrames"] = true, 
    ["loginmessage"] = true, 
    ["threatbar"] = false, 
    ["bubbles"] = true, 
    ["comix"] = true,
    ["bigComix"] = false,
    ["questWatch"] = true,
    ["questHeaders"] = true,
    ["woot"] = true, 
    ["gamemenu"] = true, 
    ["afk"] = true, 
    ["afkNoMove"] = false,
    ["pvpinterrupt"] = true, 
    ["lookwhaticando"] = false,
    ["reactionChat"] = false,
    ["reactionEmote"] = false,
    ["sharingiscaring"] = false, 
    ["arenadrink"] = true, 
    ["stupidhat"] = true,
    ["graphSize"] = 64,
    ["scaleAdjust"] = 0.64,
}

SV.defaults["totems"] = {
    ["enable"] = true, 
    ["showBy"] = "VERTICAL", 
    ["sortDirection"] = "ASCENDING", 
    ["size"] = 40, 
    ["spacing"] = 4
}

SV.defaults["media"] = {
    ["fonts"] = {
        ["default"] = "SVUI System Font", 
        ["name"] = NAMEFONT, 
        ["number"] = "SVUI Number Font", 
        ["combat"] = "SVUI Number Font", 
        ["giant"] = "SVUI System Font", 
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
        ["specialdark"]  = {0.37, 0.32, 0.29, 1}, 
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
            --[safename(84963)] = {0.98, 0.57, 0.11}, --Inquisition
            [safename(86659)] = {0.98, 0.57, 0.11}, --Guardian of Ancient Kings
        }
    }
}

SV.defaults["SVBar"] = {
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
		    ["WARRIOR"] 	 = "[bonusbar:1] 7; [bonusbar:2] 8;", 
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

SV.defaults["SVAura"] = {
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

SV.defaults["SVBag"] = {
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

SV.defaults["SVChat"] = {
	["enable"] = true, 
	["docked"] = "BottomLeft",
	["tabHeight"] = 20, 
	["tabWidth"] = 75, 
	["tabStyled"] = true, 
	["font"] = "Roboto", 
	["fontOutline"] = "OUTLINE", 
	["tabFont"] = "SVUI Action Font", 
	["tabFontSize"] = 11, 
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

SV.defaults["Dock"] = {
	["enable"] = true, 
	["dockLeftWidth"] = 412, 
	["dockLeftHeight"] = 224, 
	["dockRightWidth"] = 412, 
	["dockRightHeight"] = 224,
	["dockCenterWidth"] = defaultCenterWidth,
	["buttonSize"] = 30, 
	["buttonSpacing"] = 4, 
	["leftDockBackdrop"] = true, 
	["rightDockBackdrop"] = true, 
	["topPanel"] = true, 
	["bottomPanel"] = true, 
};

SV.defaults["SVGear"] = {
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

SV.defaults["SVHenchmen"] = {
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

SV.defaults["SVMap"] = {
	["incompatible"] = {
		["SexyMap"] = true,
		["SquareMap"] = true,
		["PocketPlot"] = true,
	},
	["enable"] = true,
	["customIcons"] = true,
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

SV.defaults["SVOverride"] = {
	["enable"] = true, 
	["loot"] = true, 
	["lootRoll"] = true, 
	["lootRollWidth"] = 328, 
	["lootRollHeight"] = 28,
    ["filterErrors"] = true,
    ["hideErrorFrame"] = true, 
	["errorFilters"] = {
		[INTERRUPTED] = false,
		[ERR_ABILITY_COOLDOWN] = true,
		[ERR_ATTACK_CHANNEL] = false,
		[ERR_ATTACK_CHARMED] = false,
		[ERR_ATTACK_CONFUSED] = false,
		[ERR_ATTACK_DEAD] = false,
		[ERR_ATTACK_FLEEING] = false,
		[ERR_ATTACK_MOUNTED] = true,
		[ERR_ATTACK_PACIFIED] = false,
		[ERR_ATTACK_STUNNED] = false,
		[ERR_ATTACK_NO_ACTIONS] = false,
		[ERR_AUTOFOLLOW_TOO_FAR] = false,
		[ERR_BADATTACKFACING] = false,
		[ERR_BADATTACKPOS] = false,
		[ERR_CLIENT_LOCKED_OUT] = false,
		[ERR_GENERIC_NO_TARGET] = true,
		[ERR_GENERIC_NO_VALID_TARGETS] = true,
		[ERR_GENERIC_STUNNED] = false,
		[ERR_INVALID_ATTACK_TARGET] = true,
		[ERR_ITEM_COOLDOWN] = true,
		[ERR_NOEMOTEWHILERUNNING] = false,
		[ERR_NOT_IN_COMBAT] = false,
		[ERR_NOT_WHILE_DISARMED] = false,
		[ERR_NOT_WHILE_FALLING] = false,
		[ERR_NOT_WHILE_MOUNTED] = false,
		[ERR_NO_ATTACK_TARGET] = true,
		[ERR_OUT_OF_ENERGY] = true,
		[ERR_OUT_OF_FOCUS] = true,
		[ERR_OUT_OF_MANA] = true,
		[ERR_OUT_OF_RAGE] = true,
		[ERR_OUT_OF_RANGE] = true,
		[ERR_OUT_OF_RUNES] = true,
		[ERR_OUT_OF_RUNIC_POWER] = true,
		[ERR_SPELL_COOLDOWN] = true,
		[ERR_SPELL_OUT_OF_RANGE] = false,
		[ERR_TOO_FAR_TO_INTERACT] = false,
		[ERR_USE_BAD_ANGLE] = false,
		[ERR_USE_CANT_IMMUNE] = false,
		[ERR_USE_TOO_FAR] = false,
		[SPELL_FAILED_BAD_IMPLICIT_TARGETS] = true,
		[SPELL_FAILED_BAD_TARGETS] = true,
		[SPELL_FAILED_CASTER_AURASTATE] = true,
		[SPELL_FAILED_NO_COMBO_POINTS] = true,
		[SPELL_FAILED_SPELL_IN_PROGRESS] = true,
		[SPELL_FAILED_TARGET_AURASTATE] = true,
		[SPELL_FAILED_TOO_CLOSE] = false,
		[SPELL_FAILED_UNIT_NOT_INFRONT] = false,
	}
};

SV.defaults["SVPlate"] = {
	["enable"] = true, 
	["filter"] = {}, 
	["font"] = NAMEFONT, 
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
		["height"] = 10, 
		["text"] = {
			["enable"] = false, 
			["format"] = "CURRENT", 
			["xOffset"] = 0, 
			["yOffset"] = 0, 
			["attachTo"] = "CENTER", 
		}, 
	}, 
	["castBar"] = {
		["height"] = 8, 
		["color"] = {1, 0.81, 0}, 
		["noInterrupt"] = {1, 0.25, 0.25}, 
		["text"] = {
			["enable"] = false, 
			["xOffset"] = 2, 
			["yOffset"] = 0, 
		}, 
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

SV.defaults["SVQuest"] = {
    ["enable"] = true, 
    ["rowHeight"] = 20,
}

SV.defaults["SVStats"] = {
	["enable"] = true, 
	["font"] = "SVUI Number Font", 
	["fontSize"] = 11, 
	["fontOutline"] = "OUTLINE",
	["showBackground"] = false,
	["shortGold"] = true,
	["docks"] = {
		["SVUI_DockBottomCenterLeft"] = {
			["left"] = "Experience Bar", 
			["middle"] = "Time", 
			["right"] = "System",  
		}, 
		["SVUI_DockBottomCenterRight"] = {
			["left"] = "Gold", 
			["middle"] = "Durability", 	
			["right"] = "Reputation Bar", 
		}, 
		["SVUI_DockTopCenterLeft"] = {
			["left"] = "None", 
			["middle"] = "None", 
			["right"] = "None",
		},
		["SVUI_DockTopCenterRight"] = {
			["left"] = "None", 
			["middle"] = "None", 
			["right"] = "None", 
		}, 
	}, 
	["localtime"] = true, 
	["time24"] = false, 
	["battleground"] = true, 
};

SV.defaults["SVTip"] = {
	["enable"] = true, 
	["comicStyle"] = true,
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

SV.defaults["SVTools"] = {
	["enable"] = true, 
	["garrison"] = true, 
	["professions"] = true, 
	["breakStuff"] = true,
};

SV.defaults["SVUnit"] = {
	["enable"] = true,
	["comicStyle"] = true,
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
	["OORAlpha"] = 0.4,
	["groupOORAlpha"] = 0.2, 
	["combatFadeRoles"] = true, 
	["combatFadeNames"] = true, 
	["debuffHighlighting"] = true, 
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
		["wrapXOffset"] = 6, 
		["wrapYOffset"] = 6,
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
			["enable"] = true, 
			["perrow"] = 8, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT",
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterAll"] = false, 
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
			["attachTo"] = "BUFFS", 
			["anchorPoint"] = "TOPLEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "RIGHT",
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterAll"] = false, 
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
			["font"] = NAMEFONT, 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
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
			["filterAll"] = 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			},
			["filterAll"] = 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = true, 
				enemy = true, 
			}, 
			["filterAll"] = 
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
			["classIcon"] = 
			{
				["enable"] = false, 
				["size"] = 26, 
				["attachTo"] = "INNERBOTTOMLEFT", 
				["xOffset"] = 0, 
				["yOffset"] = 0, 
			},
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
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
			["filterAll"] = 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			},
			["filterAll"] = 
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
		["castbar"] = 
		{
			["enable"] = true, 
			["width"] = 170, 
			["height"] = 10,
			["icon"] = false,
			["matchFrameWidth"] = true,
			["format"] = "REMAINING", 
			["spark"] = true, 
			["useCustomColor"] = false, 
			["castingColor"] = {0.8, 0.8, 0}, 
			["sparkColor"] = {1, 0.72, 0}, 
		}, 
		["buffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT",
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
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
			["filterAll"] = 
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
			["yOffset"] = 4, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT",
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			},
			["filterAll"] = 
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
			["xOffset"] = -4, 
			["yOffset"] = 0, 
			["sizeOverride"] = 0, 
		}, 
		["aurabar"] = 
		{
			["enable"] = false, 
			["anchorPoint"] = "ABOVE", 
			["attachTo"] = "FRAME",
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			},
			["filterAll"] = 
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
		["enable"] = true, 
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
			["enable"] = true, 
			["perrow"] = 7, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "TOPRIGHT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT",
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
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
			["filterAll"] = 
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
			["yOffset"] = 4, 
			["sizeOverride"] = 0, 
		}, 
		["debuffs"] = 
		{
			["enable"] = true, 
			["perrow"] = 5, 
			["numrows"] = 1, 
			["attachTo"] = "FRAME", 
			["anchorPoint"] = "LEFT", 
			["verticalGrowth"] = "UP", 
			["horizontalGrowth"] = "LEFT",
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			},
			["filterAll"] = 
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
			["xOffset"] = -4, 
			["yOffset"] = 0, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true,
			["filterAll"] = true, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false,
			["filterAll"] = false, 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
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
			["filterAll"] = 
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
			["filterWhiteList"] = 
			{
				friendly = false, 
				enemy = false, 
			},
			["filterPlayer"] = 
			{
				friendly = false, 
				enemy = true, 
			}, 
			["filterAll"] = 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterRaid"] = false, 
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterRaid"] = false, 
			["filterAll"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "Shield", 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterRaid"] = false, 
			["filterAll"] = false, 
			["filterInfinite"] = false, 
			["filterDispellable"] = false, 
			["useFilter"] = "CC",
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
		["visibility"] = "[group:raid][nogroup] hide;show", 
		["showBy"] = "UP_RIGHT", 
		["wrapXOffset"] = 9, 
		["wrapYOffset"] = 13,
		["allowedGroup"] = {
			[1] = true, 
		},
		["gRowCol"] = 1,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC",
		["invertGroupingOrder"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterAll"] = false, 
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
	["raid"] = {
		["enable"] = true,
		["gridAllowed"] = true,
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[group:raid] show;hide",
		["showBy"] = "RIGHT_DOWN", 
		["wrapXOffset"] = 8, 
		["wrapYOffset"] = 8,
		["showGroupNumber"] = false,
		["allowedGroup"] = {
			[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true,
		},
		["gRowCol"] = 1,
		["sortMethod"] = "GROUP", 
		["sortDir"] = "ASC", 
		["showPlayer"] = true, 
		["predict"] = false, 
		["colorOverride"] = "USE_DEFAULT", 
		["width"] = 50, 
		["height"] = 30,
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true, 
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterAll"] = false, 
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
		["gridAllowed"] = true, 
		["rangeCheck"] = true, 
		["threatEnabled"] = true, 
		["visibility"] = "[group:raid] show;hide", 
		["showBy"] = "DOWN_RIGHT", 
		["wrapXOffset"] = 3, 
		["wrapYOffset"] = 3,
		["allowedGroup"] = {
			[1] = true, [2] = true,
		},
		["gRowCol"] = 1,
		["sortMethod"] = "PETNAME", 
		["sortDir"] = "ASC",  
		["invertGroupingOrder"] = false, 
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
			["position"] = "INNERBOTTOMRIGHT", 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = true, 
			["filterRaid"] = true,
			["filterAll"] = false, 
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
			["filterWhiteList"] = false,
			["filterPlayer"] = false, 
			["filterAll"] = false, 
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
		["visibility"] = "[group:raid] show;hide",
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
		["visibility"] = "[group:raid] show;hide",
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
}