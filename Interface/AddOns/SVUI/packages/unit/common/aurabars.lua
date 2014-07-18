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
--]]
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVUnit')
if(not MOD) then return end;
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
--[[ 
########################################################## 
LOCAL VARIABLES 
##########################################################
]]--
local tsort,floor,sub = table.sort, math.floor, string.sub;
local CustomBarFilter;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
local AuraRemover_OnClick = function(self)
	if not IsShiftKeyDown() then return end 
	local name = self:GetParent().aura.name
	if name then 
		SuperVillain:AddonMessage(format(L["The spell '%s' has been added to the Blocked unitframe aura filter."], name))
		SuperVillain.Filters["Blocked"][name] = {["enable"] = true, ["priority"] = 0}
		MOD:RefreshUnitFrames()
	end 
end

local function PostCreateAuraBars(self)
	self.iconHolder:RegisterForClicks("RightButtonUp")
	self.iconHolder:SetScript("OnClick", AuraRemover_OnClick)
end 

local function ColorizeAuraBars(self)
	local bars = self.bars;
	for i = 1, #bars do 
		local auraBar = bars[i]
		if not auraBar:IsVisible()then break end 
		local color
		local spellName = auraBar.statusBar.aura.name;
		local spellID = auraBar.statusBar.aura.spellID;
		if(SuperVillain.Filters["Shield"][spellName]) then 
			color = oUF_SuperVillain.colors.shield_bars
		elseif(SuperVillain.db.media.unitframes.spellcolor[spellName]) then
			color = SuperVillain.db.media.unitframes.spellcolor[spellName]
		end 
		if color then 
			auraBar.statusBar:SetStatusBarColor(unpack(color))
			auraBar:SetBackdropColor(color[1] * 0.25, color[2] * 0.25, color[3] * 0.25, 0.25)
		else
			local r, g, b = auraBar.statusBar:GetStatusBarColor()
			auraBar:SetBackdropColor(r * 0.25, g * 0.25, b * 0.25, 0.25)
		end 
	end 
end 

do
	local function _test(setting, helpful)
		local friend, enemy = false, false
		if type(setting) == "boolean" then 
			friend = setting;
		  	enemy = setting
		elseif setting and type(setting) ~= "string" then 
			friend = setting.friendly;
		  	enemy = setting.enemy
		end 
		if (friend and helpful) or (enemy and not helpful) then 
		  return true;
		end
	  	return false 
	end 

	CustomBarFilter = function(self, unit, name, _, _, _, debuffType, duration, _, caster, isStealable, shouldConsolidate, spellID)
		local key = self.___key
		local db = MOD.db[key]
		if((not db) or (db and not db.aurabar) or (spellID == 65148)) then 
			return false;
		end
		local barDB = db.aurabar
		local filtered = (caster == "player" or caster == "vehicle") and true or false;
		local allowed = true;
		local pass = false;
		local friendly = UnitIsFriend("player", unit) == 1 and true or false;

		if _test(barDB.filterPlayer, friendly) then
			allowed = filtered;
			pass = true 
		end 
		if _test(barDB.filterDispellable, friendly) then 
			if (debuffType and not SuperVillain.Dispellable[debuffType]) or debuffType == nil then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(barDB.filterRaid, friendly) then 
			if shouldConsolidate == 1 then filtered = false end 
			pass = true 
		end 
		if _test(barDB.filterInfinite, friendly) then 
			if duration == 0 or not duration then 
				filtered = false 
			end 
			pass = true 
		end 
		if _test(barDB.filterBlocked, friendly) then
			local blackList = SuperVillain.Filters["Blocked"][name]
			if blackList and blackList.enable then filtered = false end 
			pass = true 
		end 
		if _test(barDB.filterAllowed, friendly) then 
			local whiteList = SuperVillain.Filters["Allowed"][name]
			if whiteList and whiteList.enable then 
				filtered = true 
			elseif not pass then 
				filtered = false 
			end 
			pass = true 
		end
		local active = barDB.useFilter
		if active and active ~= "" and SuperVillain.Filters[active] then
			local spellsDB = SuperVillain.Filters[active];
			if active ~= "Blocked" then 
				if spellsDB[name] and spellsDB[name].enable and allowed then 
					filtered = true 
				elseif not pass then 
					filtered = false
				end 
			elseif spellsDB[name] and spellsDB[name].enable then 
				filtered = false 
			end 
		end 
		return filtered 
	end
end
--[[ 
########################################################## 
UTILITY
##########################################################
]]--
function MOD:CreateAuraBarHeader(frame, unitName)
	local auraBarParent = CreateFrame("Frame", nil, frame)
	auraBarParent.parent = frame;
	auraBarParent.PostCreateBar = PostCreateAuraBars;
	auraBarParent.gap = 2;
	auraBarParent.spacing = 1;
	auraBarParent.spark = true;
	auraBarParent.filter = CustomBarFilter;
	auraBarParent.PostUpdate = ColorizeAuraBars;
	auraBarParent.barTexture = SuperVillain.Shared:Fetch("statusbar", MOD.db.auraBarStatusbar)
	auraBarParent.timeFont = SuperVillain.Shared:Fetch("font", "Roboto")
	auraBarParent.textFont = SuperVillain.Shared:Fetch("font", MOD.db.auraFont)
	auraBarParent.textSize = MOD.db.auraFontSize
	auraBarParent.textOutline = MOD.db.auraFontOutline
	return auraBarParent 
end  