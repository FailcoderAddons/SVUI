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
local MOD = SuperVillain.Registry:Expose('SVDock')
local CHAT = SuperVillain.Registry:Expose('SVChat')
local BAG = SuperVillain.Registry:Expose("SVBag")

SuperVillain.Options.args.SVDock = {
  type = "group", 
  name = L["Docks"], 
  args = {}
}

SuperVillain.Options.args.SVDock.args["intro"] = {
	order = 1, 
	type = "description", 
	name = "Configure the various frame docks around the screen"
};

SuperVillain.Options.args.SVDock.args["common"] = {
	order = 2,
	type = "group",
	name = "General",
	guiInline = true,
	args = {
		bottomPanel = {
			order = 2,
			type = 'toggle',
			name = L['Bottom Panel'],
			desc = L['Display a border across the bottom of the screen.'],
			get = function(j)return SuperVillain.db.SVDock.bottomPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:BottomPanelVisibility()end
		},
		topPanel = {
			order = 3,
			type = 'toggle',
			name = L['Top Panel'],
			desc = L['Display a border across the top of the screen.'],
			get = function(j)return SuperVillain.db.SVDock.topPanel end,
			set = function(key,value)MOD:ChangeDBVar(value,key[#key]);MOD:TopPanelVisibility()end
		},
	}
};

SuperVillain.Options.args.SVDock.args["leftDockGroup"] = {
		order = 3, 
		type = "group", 
		name = L["Left Dock"], 
		guiInline = true, 
		args = {
			dockLeftHeight = {
				order = 1, 
				type = "range", 
				name = L["Left Dock Height"], 
				desc = L["PANEL_DESC"], 
				min = 150, 
				max = 600, 
				step = 1,
				get = function()return SuperVillain.db.SVDock.dockLeftHeight;end, 
				set = function(key,value)
					MOD:ChangeDBVar(value,key[#key]);
					MOD:UpdateSuperDock(true)
					CHAT:RefreshChatFrames(true)
				end, 
			},
			dockLeftWidth = {
				order = 2, 
				type = "range", 
				name = L["Left Dock Width"], 
				desc = L["PANEL_DESC"],  
				min = 150, 
				max = 700, 
				step = 1,
				get = function()return SuperVillain.db.SVDock.dockLeftWidth;end, 
				set = function(key,value)
					MOD:ChangeDBVar(value,key[#key]);
					MOD:UpdateSuperDock(true)
					CHAT:RefreshChatFrames(true)
				end,
			},
			leftDockBackdrop = {
				order = 3,
				type = 'toggle',
				name = L['Left Dock Backdrop'],
				desc = L['Display a backdrop behind the left-side dock.'],
				get = function(j)return SuperVillain.db.SVDock.leftDockBackdrop end,
				set = function(key,value)
					MOD:ChangeDBVar(value,key[#key]);
					MOD:UpdateDockBackdrops()
				end
			},
		}
	};

local acceptableDocklets = {
	["alDamageMeter"] = L["alDamageMeter"],
	["Skada"] = L["Skada"],
	["Recount"] = L["Recount"],
	["TinyDPS"] = L["TinyDPS"],
	["Omen"] = L["Omen"]
};

local function GetLiveDockletsA()
	local test = SuperVillain.db.SVDock.docklets.DockletExtra;
	local t = {["None"] = L["None"]};
	for n,l in pairs(acceptableDocklets) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			if n=="Skada" and Skada then
				for index,window in pairs(Skada:GetWindows()) do
				    local key = window.db.name
				    t["Skada"..key] = (key=="Skada") and "Skada - Main" or "Skada - "..key;
				end;
			elseif (test ~= n and test ~= l) then
				t[n] = l;
			end
		end
	end
	return t;
end
local function GetLiveDockletsB()
	local test = SuperVillain.db.SVDock.docklets.DockletMain;
	local t = {["None"] = L["None"]};
	for n,l in pairs(acceptableDocklets) do
		if IsAddOnLoaded(n) or IsAddOnLoaded(l) then
			if n=="Skada" and Skada then
				for index,window in pairs(Skada:GetWindows()) do
				    local key = window.db.name
				    t["Skada"..key] = (key=="Skada") and "Skada - Main" or "Skada - "..key;
				end;
			elseif (test ~= n and test ~= l) then
				t[n] = l;
			end
		end
	end
	return t;
end

SuperVillain.Options.args.SVDock.args["rightDockGroup"] = {
	order = 4, 
	type = "group", 
	name = L["Right Dock"], 
	guiInline = true, 
	args = {
		dockRightHeight = {
			order = 1, 
			type = "range", 
			name = L["Right Dock Height"], 
			desc = L["PANEL_DESC"], 
			min = 150, 
			max = 600, 
			step = 1,
			get = function()return SuperVillain.db.SVDock.dockRightHeight;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateSuperDock(true)
				CHAT:RefreshChatFrames(true)
			end, 
		},
		dockRightWidth = {
			order = 2, 
			type = "range", 
			name = L["Right Dock Width"], 
			desc = L["PANEL_DESC"],  
			min = 150, 
			max = 700, 
			step = 1,
			get = function()return SuperVillain.db.SVDock.dockRightWidth;end, 
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateSuperDock(true)
				CHAT:RefreshChatFrames(true)
				BAG:Layout()
				BAG:Layout(true)
			end,
		},
		rightDockBackdrop = {
			order = 3,
			type = 'toggle',
			name = L['Right Dock Backdrop'],
			desc = L['Display a backdrop behind the right-side dock.'],
			get = function(j)return SuperVillain.db.SVDock.rightDockBackdrop end,
			set = function(key,value)
				MOD:ChangeDBVar(value,key[#key]);
				MOD:UpdateDockBackdrops()
			end
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
					get = function()return SuperVillain.db.system.questWatch end,
				 	set = function(j, value) SuperVillain.db.system.questWatch = value; SuperVillain:StaticPopup_Show("RL_CLIENT") end
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
							get = function()return SuperVillain.db.SVDock.docklets.DockletMain end,
							set = function(a,value)SuperVillain.db.SVDock.docklets.DockletMain = value;MOD:ReloadDocklets()end,
						},
						DockletCombatFade = {
							type = "toggle",
							order = 2,
							name = "Out of Combat (Hide)",
							get = function()return SuperVillain.db.SVDock.docklets.DockletCombatFade end,
							set = function(a,value)SuperVillain.db.SVDock.docklets.DockletCombatFade = value;end
						},
						enableExtra = {
							type = "toggle",
							order = 3,
							name = "Split Docklet",
							desc = "Split the primary docklet window for 2 addons.",
							get = function()return SuperVillain.db.SVDock.docklets.enableExtra end,
							set = function(a,value)SuperVillain.db.SVDock.docklets.enableExtra = value;MOD:ReloadDocklets()end,
						},
						DockletExtra = {
							type = "select",
							order = 4,
							name = "Secondary Docklet",
							desc = "Select another addon",
							disabled = function()return (not SuperVillain.db.SVDock.docklets.enableExtra or SuperVillain.db.SVDock.docklets.DockletMain == "None") end, 
							values = function()return GetLiveDockletsB()end,
							get = function()return SuperVillain.db.SVDock.docklets.DockletExtra end,
							set = function(a,value)SuperVillain.db.SVDock.docklets.DockletExtra = value;MOD:ReloadDocklets()end,
						}
					}
				}
			}
		}
	}
};