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
local unpack 	= _G.unpack;
local select 	= _G.select;
local pairs 	= _G.pairs;
local string 	= _G.string;
--[[ STRING METHODS ]]--
local format = string.format;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(SVUI);
local MOD = SuperVillain.Registry:Expose('SVStyle');
--[[ 
########################################################## 
WEAKAURAS
##########################################################
]]--
local function StyleWeakAuras()
	local function Style_WeakAuras(frame)
		if not frame.Panel then
			MOD:ApplyFrameStyle(frame,"Transparent")
			frame.icon.OldAlpha = frame.icon.SetAlpha
			frame.icon.SetAlpha = function(self, ...)
				frame.icon.OldAlpha(self, ...)
				frame.Panel:SetAlpha(...)
			end
		end
		SuperVillain:AddCD(frame.cooldown)
		frame.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		frame.icon.SetTexCoord = function() end
	end
	local function Create_WeakAuras(parent, data)
		local region = WeakAuras.regionTypes.icon.OldCreate(parent, data)
		Style_WeakAuras(region)
		return region
	end
	local function Modify_WeakAuras(parent, region, data)
		WeakAuras.regionTypes.icon.OldModify(parent, region, data)
		Style_WeakAuras(region)
	end
	WeakAuras.regionTypes.icon.OldCreate = WeakAuras.regionTypes.icon.create
	WeakAuras.regionTypes.icon.create = Create_WeakAuras
	WeakAuras.regionTypes.icon.OldModify = WeakAuras.regionTypes.icon.modify
	WeakAuras.regionTypes.icon.modify = Modify_WeakAuras
	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' then
			Style_WeakAuras(WeakAuras.regions[weakAura].region)
		end
	end
end
MOD:SaveAddonStyle("WeakAuras", StyleWeakAuras)