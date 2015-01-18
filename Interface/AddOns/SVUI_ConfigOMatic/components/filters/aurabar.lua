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
--[[ TABLE METHODS ]]--
local tsort = table.sort;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = _G["SVUI"];
local MOD = SV.SVUnit;
if(not MOD) then return end
local L = SV.L;
local _, ns = ...;
local tempFilterTable = {};
local NONE = _G.NONE;

ns.FilterOptionGroups['AuraBars'] = function(selectedSpell)
	local FILTER = SV.filters.AuraBars;
	local RESULT = {
		type = "group",
		name = 'AuraBars',
		guiInline = true,
		order = 10,
		args = {
			addSpell = {
				order = 1,
				name = L["Add Spell"],
				desc = L["Add a spell to the filter."],
				type = "input",
				guiInline = true,
				get = function(key) return "" end,
				set = function(key, value)
					local spellID = tonumber(value);
					if(not spellID) then 
						SV:AddonMessage(L["Value must be a number"])
					elseif(not GetSpellInfo(spellID)) then 
						SV:AddonMessage(L["Not valid spell id"])
					elseif not FILTER[spellID] then 
						FILTER[spellID] = false 
					end 
					MOD:SetUnitFrame("player")
					MOD:SetUnitFrame("target")
					MOD:SetUnitFrame("focus")
					ns:SetFilterOptions('AuraBars', value)
				end
			},
			removeSpell = {
				order = 2,
				name = L["Remove Spell"],
				desc = L["Remove a spell from the filter."],
				type = "select",
				guiInline = true,
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
						if(type(id) == 'string') then
							local spellID = tonumber(id)
							local auraName = GetSpellInfo(spellID)
							if(auraName) then
								tempFilterTable[id] = auraName
							end
						end
					end
					return tempFilterTable 
				end,
				get = function(key) return "" end,
				set = function(key, value)
					FILTER[value] = nil 
					MOD:SetUnitFrame("player")
					MOD:SetUnitFrame("target")
					MOD:SetUnitFrame("focus")
					ns:SetFilterOptions('AuraBars')
				end
			},
			selectSpell = {
				name = L["Select Spell"],
				type = "select",
				order = 3,
				guiInline = true,
				get = function(key) return selectedSpell end,
				set = function(key, value)
					ns:SetFilterOptions('AuraBars', value)
				end,
				values = function()
					wipe(tempFilterTable)
					tempFilterTable[""] = NONE;
					for stringID,color in pairs(FILTER) do
						local spellID = tonumber(stringID)
						local auraName = GetSpellInfo(spellID)
						tempFilterTable[stringID] = auraName 
					end 
					return tempFilterTable 
				end
			}
		}
	};

	return RESULT;
end;

ns.FilterSpellGroups['AuraBars'] = function(selectedSpell)
	local FILTER = SV.filters.AuraBars;
	local RESULT;

	if(selectedSpell and (FILTER[selectedSpell] ~= nil)) then
		RESULT = {
			type = "group",
			name = selectedSpell,
			order = 15,
			guiInline = true,
			args = {
				color = {
					name = L["Color"],
					type = "color",
					order = 1,
					get = function(key)
						local abColor = FILTER[selectedSpell]
						if type(abColor) == "boolean" then 
							return 0, 0, 0, 1 
						else 
							return abColor[1], abColor[2], abColor[3], abColor[4] 
						end 
					end,
					set = function(key, r, g, b)
						FILTER[selectedSpell] = {r, g, b}
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				},
				removeColor = {
					type = "execute",
					order = 2,
					name = L["Restore Defaults"],
					func = function(key, value)
						FILTER[selectedSpell] = false;
						MOD:SetUnitFrame("player")
						MOD:SetUnitFrame("target")
						MOD:SetUnitFrame("focus")
					end
				}
			}
		};
	end

	return RESULT;
end;