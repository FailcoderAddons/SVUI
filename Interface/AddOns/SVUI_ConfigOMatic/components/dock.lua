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
local MOD = SV.Dock
local CHAT = SV.SVChat
local BAG = SV.SVBag

SV.Options.args.Dock = {
  type = "group", 
  name = MOD.TitleID, 
  args = {}
}

SV.Options.args.Dock.args["intro"] = {
	order = 1, 
	type = "description", 
	name = "Configure the various frame docks around the screen"
};

SV.Options.args.Dock.args["common"] = {
	order = 2,
	type = "group",
	name = "General",
	guiInline = true,
	args = {
		bottomPanel = {
			order = 1,
			type = 'toggle',
			name = L['Bottom Panel'],
			desc = L['Display a border across the bottom of the screen.'],
			get = function(j)return SV.db.Dock.bottomPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:BottomBorderVisibility()end
		},
		topPanel = {
			order = 2,
			type = 'toggle',
			name = L['Top Panel'],
			desc = L['Display a border across the top of the screen.'],
			get = function(j)return SV.db.Dock.topPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:TopBorderVisibility()end
		},
		dockCenterWidth = {
			order = 3,
			type = 'range',
			name = L['Stat Panel Width'],
			desc = L["PANEL_DESC"], 
			min = 400, 
			max = 1800, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.dockCenterWidth; end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
			end, 
		},
		buttonSize = {
			order = 4, 
			type = "range", 
			name = L["Dock Button Size"], 
			desc = L["PANEL_DESC"], 
			min = 20, 
			max = 80, 
			step = 1,
			width = "full",
			get = function()return SV.db.Dock.buttonSize;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
			end, 
		},
	}
};

SV.Options.args.Dock.args["leftDockGroup"] = {
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
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateDockBackdrops()
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
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
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
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
			end,
		},
	}
};

SV.Options.args.Dock.args["rightDockGroup"] = {
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
				MOD:ChangeDBVar(value, key[#key]);
				MOD:UpdateDockBackdrops()
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
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
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
				MOD:ChangeDBVar(value,key[#key]);
				MOD:Refresh()
				CHAT:UpdateLocals()
				CHAT:RefreshChatFrames(true)
				BAG.BagFrame:UpdateLayout()
				BAG.BankFrame:UpdateLayout()
			end,
		},
		quest = {
			order = 4, 
			type = "group", 
			name = L['Quest Watch Docklet'], 
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()return SV.db.general.questWatch end,
				 	set = function(j, value) SV.db.general.questWatch = value; SV:StaticPopup_Show("RL_CLIENT") end
				}
			}
		},
		questHeaders = {
			order = 5, 
			type = "group", 
			name = L['Quest Header Styled'], 
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function()return SV.db.general.questHeaders end,
				 	set = function(j, value) SV.db.general.questHeaders = value; SV:StaticPopup_Show("RL_CLIENT") end,
				 	disabled = function()return (not SV.db.general.questWatch) end, 
				}
			}
		}
	}
};

if(MOD.CustomOptions) then
	SV.Options.args.Dock.args.custom = {
		order = 5,
		type = 'group',
		name = 'Custom Docks',
		guiInline = true,
		args = MOD.CustomOptions
	}
end