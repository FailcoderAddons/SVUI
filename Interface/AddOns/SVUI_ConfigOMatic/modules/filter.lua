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
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local selectedSpell,filterType,filters;
local tinsert = table.insert;
local function generateFilterOptions()
	if filterType == 'AuraBar Colors' then 

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if not SuperVillain.db.media.unitframes.spellcolor[arg] then 
							SuperVillain.db.media.unitframes.spellcolor[arg] = false 
						end;
						generateFilterOptions()
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				},
				removeSpell = {
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					guiInline = true,
					get = function(e)return""end,
					set = function(e, arg)
						if SuperVillain.db.media.unitframes.spellcolor[arg]then 
							SuperVillain.db.media.unitframes.spellcolor[arg] = false;
							SuperVillain:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
						else 
							SuperVillain.db.media.unitframes.spellcolor[arg] = nil 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				},
				selectSpell = {
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e)return selectedSpell end,
					set = function(e, arg)
						selectedSpell = arg;
						generateFilterOptions()
					end,
					values = function()
						local filters = {}
						filters[""] = NONE;
						for g in pairs(SuperVillain.db.media.unitframes.spellcolor)do 
							filters[g] = g 
						end;
						return filters 
					end
				}
			}
		}

		if not selectedSpell or SuperVillain.db.media.unitframes.spellcolor[selectedSpell] == nil then 
			SuperVillain.Options.args.filters.args.spellGroup = nil; 
			return 
		end;

		SuperVillain.Options.args.filters.args.spellGroup = {
			type = "group",
			name = selectedSpell,
			order = 15,
			guiInline = true,
			args = {
				color = {
					name = L["Color"],
					type = "color",
					order = 1,
					get = function(e)
						local abColor = SuperVillain.db.media.unitframes.spellcolor[selectedSpell]
						if type(abColor) == "boolean"then 
							return 0, 0, 0, 1 
						else 
							return abColor[1], abColor[2], abColor[3], abColor[4] 
						end 
					end,
					set = function(e, r, g, b)
						if type(SuperVillain.db.media.unitframes.spellcolor[selectedSpell]) ~= "table"then 
							SuperVillain.db.media.unitframes.spellcolor[selectedSpell] = {}
						end;
						local abColor = {r, g, b}
						SuperVillain.db.media.unitframes.spellcolor[selectedSpell] = abColor
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				},
				removeColor = {
					type = "execute",
					order = 2,
					name = L["Restore Defaults"],
					func = function(e, arg)
						SuperVillain.db.media.unitframes.spellcolor[selectedSpell] = false;
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				}
			}
		}

	elseif filterType == 'Buff Indicator (Pet)' then

		local watchedBuffs={}

		if not SuperVillain.Filters["PetBuffWatch"] then 
			SuperVillain.Filters["PetBuffWatch"] = {}
		end;
		for o,f in pairs(SuperVillain.Filters["PetBuffWatch"])do 
			tinsert(watchedBuffs,f)
		end;

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "tab", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(arg)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(arg)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SuperVillain.Filters["PetBuffWatch"], {["enable"] = true, ["id"] = tonumber(arg), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = true})
							generateFilterOptions()
							MOD:SetUnitFrame("pet")
							selectedSpell = nil 
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SuperVillain.Filters["PetBuffWatch"])do 
								if r["id"] == tonumber(f)then 
									p = r;
									if SuperVillain.Filters["PetBuffWatch"][q]then 
										SuperVillain.Filters["PetBuffWatch"][q].enable = false;
									else 
										SuperVillain.Filters["PetBuffWatch"][q] = nil 
									end 
								end 
							end;
							if p == nil then 
								SuperVillain:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						MOD:SetUnitFrame("pet")
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local v = {}
						watchedBuffs = {}
						for o, f in pairs(SuperVillain.Filters["PetBuffWatch"])do 
							tinsert(watchedBuffs, f)
						end;
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								v[l.id] = name 
							end 
						end;
						return v 
					end, 
					get = function(e)return selectedSpell end, 
					set = function(e, arg)selectedSpell = arg; generateFilterOptions()end
				}
			}
		}

		local registeredSpell;

		for t,l in pairs(SuperVillain.Filters["PetBuffWatch"])do 
			if l.id == selectedSpell then 
				registeredSpell = t 
			end 
		end;

		if selectedSpell and registeredSpell then 
			local currentSpell = GetSpellInfo(selectedSpell)
			SuperVillain.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]] end, 
				set = function(e, arg)
					SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]] = arg;
					MOD:SetUnitFrame("pet")
				end, 
				order = -10, 
				args = {
					enable = {
						name = L["Enable"], 
						order = 0, 
						type = "toggle"
					}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {
						name = L["Style"], 
						order = 3, 
						type = "select", 
						values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], [""] = NONE}
					}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							MOD:SetUnitFrame("pet")
						end
					}, 
					displayText = {
						name = L["Display Text"],
						type = "toggle",
						order = 5
					},
					textColor = {
						name = L["Text Color"],
						type = "color",
						order = 6,
						get = function(e)
							local abColor = SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,abColor.g,abColor.b,abColor.a 
							else 
								return 1,1,1,1 
							end 
						end,
						set = function(e,i,j,k)
							local abColor = SuperVillain.Filters["PetBuffWatch"][registeredSpell][e[#e]]
							abColor.r,abColor.g,abColor.b = i,j,k;
							MOD:SetUnitFrame("pet")
						end
					},
					textThreshold = {
						name = L["Text Threshold"],
						desc = L["At what point should the text be displayed. Set to -1 to disable."],
						type = "range",
						order = 6,
						min = -1,
						max = 60,
						step = 1
					},
					anyUnit = {
						name = L["Show Aura From Other Players"],
						order = 7,
						type = "toggle"
					},
					onlyShowMissing = {
						name = L["Show When Not Active"],
						order = 8,
						type = "toggle",
						disabled = function()return SuperVillain.Filters["PetBuffWatch"][registeredSpell].style == "text"end
					}
				}
			}
		end;

		watchedBuffs = nil;

	elseif filterType == 'Buff Indicator' then

		local watchedBuffs={}

		if not SuperVillain.Filters["BuffWatch"] then 
			SuperVillain.Filters["BuffWatch"] = {}
		end;
		for o,f in pairs(SuperVillain.Filters["BuffWatch"]) do 
			tinsert(watchedBuffs,f)
		end;

		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group", 
			name = filterType, 
			guiInline = true, 
			order = -10, 
			childGroups = "tab", 
			args = {
				addSpellID = {
					order = 1, 
					name = L["Add SpellID"], 
					desc = L["Add a spell to the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							tinsert(SuperVillain.Filters["BuffWatch"], {["enable"] = true, ["id"] = tonumber(f), ["point"] = "TOPRIGHT", ["color"] = {["r"] = 1, ["g"] = 0, ["b"] = 0}, ["anyUnit"] = false})
							generateFilterOptions()
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end;
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
							selectedSpell = nil 
						end 
					end
				}, 
				removeSpellID = {
					order = 2, 
					name = L["Remove SpellID"], 
					desc = L["Remove a spell from the filter."], 
					type = "input", 
					get = function(e)return""end, 
					set = function(e, arg)
						if not tonumber(f)then 
							SuperVillain:AddonMessage(L["Value must be a number"])
						elseif not GetSpellInfo(f)then 
							SuperVillain:AddonMessage(L["Not valid spell id"])
						else 
							local p;
							for q, r in pairs(SuperVillain.Filters["BuffWatch"])do 
								if r["id"] == tonumber(f)then 
									p = r;
									if SuperVillain.Filters["BuffWatch"][q]then 
										SuperVillain.Filters["BuffWatch"][q].enable = false;
									else 
										SuperVillain.Filters["BuffWatch"][q] = nil 
									end 
								end 
							end;
							if p == nil then 
								SuperVillain:AddonMessage(L["Spell not found in list."])
							else 
								generateFilterOptions()
							end 
						end;
						selectedSpell = nil;
						generateFilterOptions()
						for t = 10, 40, 15 do 
							MOD:UpdateGroupAuraWatch("raid"..t)
						end;
						MOD:UpdateGroupAuraWatch("party")
						MOD:UpdateGroupAuraWatch("raidpet", true)
					end
				}, 
				selectSpell = {
					name = L["Select Spell"], 
					type = "select", 
					order = 3, 
					values = function()
						local v = {}
						watchedBuffs = {}
						for o, f in pairs(SuperVillain.Filters["BuffWatch"])do 
							tinsert(watchedBuffs, f)
						end;
						for o, l in pairs(watchedBuffs)do 
							if l.id then 
								local name = GetSpellInfo(l.id)
								v[l.id] = name 
							end 
						end;
						return v 
					end, 
					get = function(e)return selectedSpell end, 
					set = function(e, arg)selectedSpell = arg;generateFilterOptions()end
				}
			}
		}
		local registeredSpell;
		for t,l in pairs(SuperVillain.Filters["BuffWatch"])do if l.id==selectedSpell then registeredSpell=t end end;
		if selectedSpell and registeredSpell then 
			local currentSpell=GetSpellInfo(selectedSpell)
			SuperVillain.Options.args.filters.args.filterGroup.args[currentSpell] = {
				name = currentSpell.." ("..selectedSpell..")", 
				type = "group", 
				get = function(e)return SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]]end, 
				set = function(e, arg)
					SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]] = arg;
					for t = 10, 40, 15 do 
						MOD:UpdateGroupAuraWatch("raid"..t)
					end;
					MOD:UpdateGroupAuraWatch("party")
					MOD:UpdateGroupAuraWatch("raidpet", true)
				end, 
				order = -10, 
				args = {
					enable = {name = L["Enable"], order = 0, type = "toggle"}, 
					point = {
						name = L["Anchor Point"], 
						order = 1, 
						type = "select", 
						values = {
							["TOPLEFT"] = "TOPLEFT", 
							["TOPRIGHT"] = "TOPRIGHT", 
							["BOTTOMLEFT"] = "BOTTOMLEFT", 
							["BOTTOMRIGHT"] = "BOTTOMRIGHT", 
							["LEFT"] = "LEFT", 
							["RIGHT"] = "RIGHT", 
							["TOP"] = "TOP", 
							["BOTTOM"] = "BOTTOM"
						}
					}, 
					xOffset = {order = 2, type = "range", name = L["xOffset"], min = -75, max = 75, step = 1}, 
					yOffset = {order = 2, type = "range", name = L["yOffset"], min = -75, max = 75, step = 1}, 
					style = {name = L["Style"], order = 3, type = "select", values = {["coloredIcon"] = L["Colored Icon"], ["texturedIcon"] = L["Textured Icon"], [""] = NONE}}, 
					color = {
						name = L["Color"], 
						type = "color", 
						order = 4, 
						get = function(e)
							local abColor = SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]]
							return abColor.r,  abColor.g,  abColor.b,  abColor.a 
						end, 
						set = function(e, i, j, k)
							local abColor = SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end;
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
						end
					}, 
					displayText = {
						name = L["Display Text"], 
						type = "toggle", 
						order = 5
					}, 
					textColor = {
						name = L["Text Color"], 
						type = "color", 
						order = 6, 
						get = function(e)
							local abColor = SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]]
							if abColor then 
								return abColor.r,  abColor.g,  abColor.b,  abColor.a 
							else 
								return 1, 1, 1, 1 
							end 
						end, 
						set = function(e, i, j, k)
							SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]] = SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]] or {}
							local abColor = SuperVillain.Filters["BuffWatch"][registeredSpell][e[#e]]
							abColor.r,  abColor.g,  abColor.b = i, j, k;
							for t = 10, 40, 15 do 
								MOD:UpdateGroupAuraWatch("raid"..t)
							end;
							MOD:UpdateGroupAuraWatch("party")
							MOD:UpdateGroupAuraWatch("raidpet", true)
						end
					}, 
					textThreshold = {
						name = L["Text Threshold"], 
						desc = L["At what point should the text be displayed. Set to -1 to disable."], 
						type = "range", 
						order = 6, 
						min = -1, 
						max = 60, 
						step = 1
					}, 
					anyUnit = {
						name = L["Show Aura From Other Players"], 
						order = 7, 
						type = "toggle"
					}, 
					onlyShowMissing = {
						name = L["Show When Not Active"], 
						order = 8, 
						type = "toggle", 
						disabled = function()return SuperVillain.Filters["BuffWatch"][registeredSpell].style == "text" end
					}
				}
			}
		end;
		watchedBuffs=nil 
	else 
		if not filterType or not SuperVillain.Filters[filterType]then 
			SuperVillain.Options.args.filters.args.filterGroup = nil;
			SuperVillain.Options.args.filters.args.spellGroup = nil;
			return 
		end;
		SuperVillain.Options.args.filters.args.filterGroup = {
			type = "group",
			name = filterType,
			guiInline = true,
			order = 10,
			args = {
				addSpell = {
					order = 1,
					name = L["Add Spell"],
					desc = L["Add a spell to the filter."],
					type = "input",
					get = function(e)return""end,
					set = function(e, arg)
						if not SuperVillain.Filters[filterType][arg]then 
							SuperVillain.Filters[filterType][arg] = {
								["enable"] = true,
								["priority"] = 0
							}
						end;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				},
				removeSpell = {	
					order = 2,
					name = L["Remove Spell"],
					desc = L["Remove a spell from the filter."],
					type = "input",
					get = function(e)return""end,
					set = function(e, arg)
						if SuperVillain.Filters[filterType] then 
							if SuperVillain.Filters[filterType][arg] then 
								SuperVillain.Filters[filterType][arg].enable = false;
								SuperVillain:AddonMessage(L["You may not remove a spell from a default filter that is not customly added. Setting spell to false instead."])
							else 
								SuperVillain.Filters[filterType][arg] = nil 
							end 
						else 
							SuperVillain.Filters[filterType][arg] = nil 
						end;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				},
				selectSpell = {	
					name = L["Select Spell"],
					type = "select",
					order = 3,
					guiInline = true,
					get = function(e)return selectedSpell end,
					set = function(e, arg)
						selectedSpell = arg;
						generateFilterOptions()
					end,
					values = function()
						local filters = {}
						local list = SuperVillain.Filters[filterType]
						filters[""] = NONE;
						for g in pairs(list)do
							filters[g] = g 
						end;
						return filters 
					end
				}
			}
		}

		if not selectedSpell or not SuperVillain.Filters[filterType][selectedSpell] then 
			SuperVillain.Options.args.filters.args.spellGroup = nil;
			return 
		end;

		SuperVillain.Options.args.filters.args.spellGroup = {
			type = "group", 
			name = selectedSpell, 
			order = 15, 
			guiInline = true, 
			args = {
				enable = {
					name = L["Enable"], 
					type = "toggle", 
					get = function()
						if selectedFolder or not selectedSpell then 
							return false 
						else 
							return SuperVillain.Filters[filterType][selectedSpell].enable 
						end 
					end, 
					set = function(e, arg)
						SuperVillain.Filters[filterType][selectedSpell].enable = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end
				}, 
				priority = {
					name = L["Priority"], 
					type = "range", 
					get = function()
						if selectedFolder or not selectedSpell then 
							return 0 
						else 
							return SuperVillain.Filters[filterType][selectedSpell].priority 
						end 
					end, 
					set = function(e, arg)
						SuperVillain.Filters[filterType][selectedSpell].priority = arg;
						generateFilterOptions()
						MOD:RefreshUnitFrames()
					end, 
					min = 0, 
					max = 99, 
					step = 1, 
					desc = L["Set the priority order of the spell, please note that prioritys are only used for the raid debuff package, not the standard buff/debuff package. If you want to disable set to zero."]
				}
			}
		}
	end;
	MOD:RefreshUnitFrames()
	collectgarbage("collect")
end;
SuperVillain.Options.args.filters = {
	type = "group",
	name = L["Filters"],
	order = -10,
	args = {	
		createFilter = {	
			order = 1,
			name = L["Create Filter"],
			desc = L["Create a filter, once created a filter can be set inside the buffs/debuffs section of each unit."],
			type = "input",
			get = function(e)return""end,
			set = function(e, arg)
				SuperVillain.Filters[arg] = {}
				SuperVillain.Filters[arg]["spells"] = {}
			end
		},
		deleteFilter = {
			type = "select",
			order = 2,
			name = L["Delete Filter"],
			desc = L["Delete a created filter, you cannot delete pre-existing filters, only custom ones."],
			get = function(e)return""end,
			set = function(e, arg)
				if SuperVillain.Filters[arg] then 
					SuperVillain:AddonMessage(L["You can't remove a pre-existing filter."])
				else 
					SuperVillain.Filters[arg] = nil;
					filterType = nil;
					selectedSpell = nil;
					SuperVillain.Options.args.filters.args.filterGroup = nil 
				end 
			end,
			values = function()
				filters = {}
				filters[""] = NONE;
				for g in pairs(SuperVillain.Filters) do
					filters[g] = g
				end;
				return filters 
			end
		},
		selectFilter = {
			order = 3,
			type = "select",
			name = L["Select Filter"],
			get = function(e)return filterType end,
			set = function(e, arg)
				if arg == "" then 
					filterType = nil;
					selectedSpell = nil 
				else 
					filterType = arg 
				end; 
				generateFilterOptions() 
			end,
			values = function()
				filters = {}
				filters[""] = NONE;
				for g in pairs(SuperVillain.Filters) do 
					filters[g] = g
				end;
				filters["Buff Indicator"] = "Buff Indicator"
				filters["Buff Indicator (Pet)"] = "Buff Indicator (Pet)"
				filters["AuraBar Colors"] = "AuraBar Colors"
				return filters 
			end
		}
	}
}

local aceConfig = LibStub("AceConfigDialog-3.0")

function SuperVillain:SetToFilterConfig(newFilter)
	filterType = newFilter or "Buff Indicator"
	generateFilterOptions()
	aceConfig:SelectGroup("SVUI", "filters")
end