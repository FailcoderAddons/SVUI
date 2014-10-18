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
local MOD = SV.SVDock
local CHAT = SV.SVChat
local BAG = SV.SVBag

SV.Options.args.SVDock = {
  type = "group", 
  name = MOD.TitleID, 
  args = {}
}

SV.Options.args.SVDock.args["intro"] = {
	order = 1, 
	type = "description", 
	name = "Configure the various frame docks around the screen"
};

SV.Options.args.SVDock.args["common"] = {
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
			get = function(j)return SV.db.SVDock.bottomPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:BottomPanelVisibility()end
		},
		topPanel = {
			order = 2,
			type = 'toggle',
			name = L['Top Panel'],
			desc = L['Display a border across the top of the screen.'],
			get = function(j)return SV.db.SVDock.topPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:TopPanelVisibility()end
		},
		dockStatWidth = {
			order = 3, 
			type = "range", 
			name = L["Bottom Stats Width"], 
			desc = L["PANEL_DESC"],  
			min = 150, 
			max = 1200, 
			step = 1,
			width = "full",
			get = function()return SV.db.SVDock.dockStatWidth end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateSuperDock(true)
			end,
		},
	}
};

SV.Options.args.SVDock.args["leftDockGroup"] = {
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
				get = function(j)return SV.db.SVDock.leftDockBackdrop end,
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
				get = function()return SV.db.SVDock.dockLeftHeight;end, 
				set = function(key,value)
					MOD:ChangeDBVar(value,key[#key]);
					MOD:UpdateSuperDock(true)
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
				get = function()return SV.db.SVDock.dockLeftWidth;end, 
				set = function(key,value)
					MOD:ChangeDBVar(value,key[#key]);
					MOD:UpdateSuperDock(true)
					CHAT:RefreshChatFrames(true)
				end,
			},
		}
	};

local acceptableDocklets = {
	["alDamageMeter"] = L["alDamageMeter"],
	--["Skada"] = L["Skada"],
	["Recount"] = L["Recount"],
	["TinyDPS"] = L["TinyDPS"],
	["Omen"] = L["Omen"]
};

local function GetLiveDockletsA()
	local test = SV.db.SVDock.docklets.DockletExtra;
	local t = {["None"] = L["None"]};
	for n,l in pairs(acceptableDocklets) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			-- if n == "Skada" and _G.Skada then
			-- 	for index,window in pairs(_G.Skada:GetWindows()) do
			-- 	    local key = window.db.name
			-- 	    t["Skada"..key] = (key=="Skada") and "Skada - Main" or "Skada - "..key;
			-- 	end 
			-- end
			if (test ~= n and test ~= l) then
				t[n] = l;
			end
		end
	end
	return t;
end

local function GetLiveDockletsB()
	local test = SV.db.SVDock.docklets.DockletMain;
	local t = {["None"] = L["None"]};
	for n,l in pairs(acceptableDocklets) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			-- if n == "Skada" and _G.Skada then
			-- 	for index,window in pairs(_G.Skada:GetWindows()) do
			-- 	    local key = window.db.name
			-- 	    t["Skada"..key] = (key=="Skada") and "Skada - Main" or "Skada - "..key;
			-- 	end 
			-- end
			if (test ~= n and test ~= l) then
				t[n] = l;
			end
		end
	end
	return t;
end

SV.Options.args.SVDock.args["rightDockGroup"] = {
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
			get = function(j)return SV.db.SVDock.rightDockBackdrop end,
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
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
			get = function()return SV.db.SVDock.dockRightHeight;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateSuperDock(true)
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
			get = function()return SV.db.SVDock.dockRightWidth;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateSuperDock(true)
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
			order = 4, 
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
		},
		docklets = {
			order = 100,
			type = 'group',
			name = 'Addon Docklets',
			guiInline=true,
			args = {
				docked = {
					order=0,
					type='group',
					name='Docklet Settings',
					guiInline=true,
					args = {
						DockletMain = {
							type = "select",
							order = 1,
							name = "Primary Docklet",
							desc = "Select an addon to occupy the primary docklet window",
							values = function()return GetLiveDockletsA()end,
							get = function()return SV.db.SVDock.docklets.DockletMain end,
							set = function(a,value)SV.db.SVDock.docklets.DockletMain = value;SV:ReloadDocklets()end,
						},
						DockletCombatFade = {
							type = "toggle",
							order = 2,
							name = "Out of Combat (Hide)",
							get = function()return SV.db.SVDock.docklets.DockletCombatFade end,
							set = function(a,value)SV.db.SVDock.docklets.DockletCombatFade = value;end
						},
						enableExtra = {
							type = "toggle",
							order = 3,
							name = "Split Docklet",
							desc = "Split the primary docklet window for 2 addons.",
							get = function()return SV.db.SVDock.docklets.enableExtra end,
							set = function(a,value)SV.db.SVDock.docklets.enableExtra = value;SV:ReloadDocklets()end,
						},
						DockletExtra = {
							type = "select",
							order = 4,
							name = "Secondary Docklet",
							desc = "Select another addon",
							disabled = function()return (not SV.db.SVDock.docklets.enableExtra or SV.db.SVDock.docklets.DockletMain == "None") end, 
							values = function()return GetLiveDockletsB()end,
							get = function()return SV.db.SVDock.docklets.DockletExtra end,
							set = function(a,value)SV.db.SVDock.docklets.DockletExtra = value;SV:ReloadDocklets()end,
						}
					}
				}
			}
		}
	}
};