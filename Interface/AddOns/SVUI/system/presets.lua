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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local scc = SVUI_CLASS_COLORS[SuperVillain.class];
local rcc = RAID_CLASS_COLORS[SuperVillain.class];
local r2 = .1 + (rcc.r * .1)
local g2 = .1 + (rcc.g * .1)
local b2 = .1 + (rcc.b * .1)
--[[ 
########################################################## 
LAYOUT PRESETS
##########################################################
]]--
local presets = {
	["media"] = {
		["link"] = "media",
		["default"] = {
			["colors"] = {
				["special"] = {.37, .32, .29, 1},
			},
			["textures"] = {
				["pattern"] = "SVUI Backdrop 1",
				["comic"] = "SVUI Comic 1",
				["unitlarge"] = "SVUI Unit BG 1",
				["unitsmall"] = "SVUI Small BG 1",
			},
			["unitframes"] = {
				["buff_bars"] = {.91, .91, .31, 1},
				["health"] = {.1, .6, .02, 1},
				["casting"] = {.91, .91, .31, 1},
				["spark"] = {1, .72, 0, 1},
			},
		},
		["kaboom"] = {
			["colors"] = {
				["special"] = {.28, .31, .32, 1},
			},
			["textures"] = {
				["pattern"] = "SVUI Backdrop 2",
				["comic"] = "SVUI Comic 2",
				["unitlarge"] = "SVUI Unit BG 2",
				["unitsmall"] = "SVUI Small BG 2",
			},
			["unitframes"] = {
				["buff_bars"] = {.51, .79, 0, 1},
				["health"] = {.16, .86, .22, 1},
				["casting"] = {.91, .91, 0, 1},
				["spark"] = {1, .72, 0, 1},
			},
		},
		["classy"] = {
			["colors"] = {
				["special"] = {r2, g2, b2, 1},
			},
			["textures"] = {
				["pattern"] = "SVUI Backdrop 3",
				["comic"] = "SVUI Comic 3",
				["unitlarge"] = "SVUI Unit BG 3",
				["unitsmall"] = "SVUI Small BG 3",
			},
			["unitframes"] = {
				["buff_bars"] = {scc.r, scc.g, scc.b, 1},
				["health"] = {.16, .86, .22, 1},
				["casting"] = {.91, .91, 0, 1},
				["spark"] = {1, .72, 0, 1},
			},
		},
		["dark"] = {
			["colors"] = {
				["special"] = {.25, .26, .27, 1},
			},
			["textures"] = {
				["pattern"] = "SVUI Backdrop 4",
				["comic"] = "SVUI Comic 4",
				["unitlarge"] = "SVUI Unit BG 4",
				["unitsmall"] = "SVUI Small BG 4",
			},
			["unitframes"] = {
				["buff_bars"] = {.45, .55, .15, 1},
				["health"] = {.06, .06, .06, 1},
				["casting"] = {.8, .8, 0, 1},
				["spark"] = {1, .72, 0, 1},
			},
		},
	},
	["auras"] = {
		["link"] = "SVUnit",
		["default"] = {
			["player"] = {
				["buffs"] = {
					enable = false,
					attachTo = "DEBUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			}
		},
		["icons"] = {
			["player"] = {
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "DISABLED",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = false
				}
			}
		},
		["bars"] = {
			["player"] = {
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["debuffs"] = {
					enable = false,
					attachTo = "FRAME"
				},
				["aurabar"] = {
					enable = true,
					attachTo = "FRAME"
				}
			}
		},
		["theworks"] = {
			["player"] = {
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPLEFT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'RIGHT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			},
			["target"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			},
			["focus"] = {
				["smartAuraDisplay"] = "SHOW_DEBUFFS_ON_FRIENDLIES",
				["buffs"] = {
					enable = true,
					attachTo = "FRAME",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["debuffs"] = {
					enable = true,
					attachTo = "BUFFS",
					anchorPoint = 'TOPRIGHT',
					verticalGrowth = 'UP',
					horizontalGrowth = 'LEFT',
				},
				["aurabar"] = {
					enable = true,
					attachTo = "DEBUFFS"
				}
			}
		},
	},
	["bars"] = {
		["link"] = "SVBar",
		["default"] = {
			["Bar1"] = {
				buttonsize = 40
			},
			["Bar2"] = {
				enable = false
			},
			["Bar3"] = {
				buttons = 6,
				buttonspacin3,
				buttonsPerRow = 6,
				buttonsize = 40
			},
			["Bar5"] = {
				buttons = 6,
				buttonspacin3,
				buttonsPerRow = 6,
				buttonsize = 40
			}
		},
		["onesmall"] = {
			["Bar1"] = {
				buttonsize = 32
			},
			["Bar2"] = {
				enable = false
			},
			["Bar3"] = {
				buttons = 6,
				buttonspacin2,
				buttonsPerRow = 6,
				buttonsize = 32
			},
			["Bar5"] = {
				buttons = 6,
				buttonspacin2,
				buttonsPerRow = 6,
				buttonsize = 32
			}
		},
		["twosmall"] = {
			["Bar1"] = {
				buttonsize = 32
			},
			["Bar2"] = {
				enable = true,
				buttonsize = 32
			},
			["Bar3"] = {
				buttons = 12,
				buttonspacin2,
				buttonsPerRow = 6,
				buttonsize = 32
			},
			["Bar5"] = {
				buttons = 12,
				buttonspacin2,
				buttonsPerRow = 6,
				buttonsize = 32
			}
		},
		["twobig"] = {
			["Bar1"] = {
				buttonsize = 40
			},
			["Bar2"] = {
				enable = true,
				buttonsize = 40
			},
			["Bar3"] = {
				buttons = 12,
				buttonspacin3,
				buttonsPerRow = 6,
				buttonsize = 40
			},
			["Bar5"] = {
				buttons = 12,
				buttonspacin3,
				buttonsPerRow = 6,
				buttonsize = 40
			}
		},
	},
	["units"] = {
		["link"] = "SVUnit",
		["default"] = {
			["player"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["target"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["pet"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["party"] = {
				width = 75,
				height = 60,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["super"] = {
			["player"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["target"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["pet"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				}
			},
			["party"] = {
				width = 75,
				height = 60,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = true,
					style = "3D",
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["simple"] = {
			["player"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 60, 
				}
			},
			["target"] = {
				width = 215,
				height = 60,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 60,
				}
			},
			["pet"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 30,
				},
				name = {
					position = "INNERLEFT"
				},
			},
			["targettarget"] = {
				width = 150,
				height = 30,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 30,
				},
				name = {
					position = "INNERLEFT"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 45,
				}
			},
			["party"] = {
				width = 100,
				height = 35,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = true,
					overlay = false,
					style = "2D",
					width = 35,
				},
				name = {
					position = "INNERRIGHT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
		["compact"] = {
			["player"] = {
				width = 215,
				height = 50,
				portrait = {
					enable = false
				}
			},
			["target"] = {
				width = 215,
				height = 50,
				portrait = {
					enable = false
				}
			},
			["pet"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = false
				},
				name = {
					position = "CENTER"
				},
			},
			["targettarget"] = {
				width = 130,
				height = 30,
				portrait = {
					enable = false
				},
				name = {
					position = "CENTER"
				},
			},
			["boss"] = {
				width = 200,
				height = 45,
				portrait = {
					enable = false
				}
			},
			["party"] = {
				width = 70,
				height = 30,
				gridMode = false,
				wrapXOffset = 9,
				wrapYOffset = 13,
				portrait = {
					enable = false
				},
				name = {
					position = "INNERTOPLEFT"
				},
			},
			["raid10"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid25"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
			["raid40"] = {
				width = 50,
				height = 30,
				gridMode = false,
				wrapXOffset = 6,
				wrapYOffset = 6,
			},
		},
	}	
};

local function CopyLayout(saved, preset)
	if(type(preset) == 'table') then
        for key,val in pairs(preset) do
        	if(not saved[key]) then saved[key] = {} end
    		if(type(val) == "table") then
    			CopyLayout(saved[key], val)
    		elseif(saved[key]) then
            	saved[key] = val
            end
        end
    else
    	saved = preset
    end
end

function SuperVillain:LoadPresetData(category, theme)
	if(presets[category] and presets[category]["link"]) then
		theme = theme or "default"
		local saved = presets[category]["link"]
		local preset =  presets[category][theme]
	    CopyLayout(SuperVillain.db[saved], preset)
	end
end