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
local MOD = SuperVillain.Registry:Expose('SVUnit');
local _, ns = ...
local oUF_SuperVillain = ns.oUF
--[[ MUNGLUNCH's FASTER ASSERT FUNCTION ]]--
local assert = enforce;
assert(oUF_SuperVillain, "SVUI was unable to locate oUF.");
local LSM = LibStub("LibSharedMedia-3.0");
--[[ 
########################################################## 
LOCAL VARIABLES 
##########################################################
]]--
local tsort,floor,sub,huge = table.sort,math.floor,string.sub,math.huge;
--[[ 
########################################################## 
BUILD FUNCTION
##########################################################
]]--
function MOD:CreateAuraBars()
	local parent = self:GetParent().parent
	local db = parent.db.aurabar
	local auraBar = self.statusBar;
	self:SetFixedPanelTemplate('Transparent',true)
	auraBar:FillInner(self)
	MOD:WatchUnitMedia("aurabarfonts", auraBar)
	auraBar.spelltime:SetFontTemplate(LSM:Fetch("font", MOD.db.auraFont), MOD.db.auraFontSize, MOD.db.auraFontOutline, "RIGHT", nil, true)
	auraBar.spelltime:SetShadowOffset(1, -1)
  	auraBar.spelltime:SetShadowColor(0, 0, 0)
	auraBar.spellname:SetFontTemplate(LSM:Fetch("font", MOD.db.auraFont), MOD.db.auraFontSize, MOD.db.auraFontOutline, "LEFT", nil, true)
	auraBar.spellname:SetShadowOffset(1, -1)
  	auraBar.spellname:SetShadowColor(0, 0, 0)
	auraBar.spellname:ClearAllPoints()
	auraBar.spellname:SetPoint('LEFT',auraBar,'LEFT',4,0)
	auraBar.spellname:SetPoint('RIGHT',auraBar.spelltime,'LEFT',-4,0)
	auraBar.iconHolder:SetFixedPanelTemplate('Transparent',true)
	auraBar.icon:FillInner(auraBar.iconHolder)
	auraBar.icon:SetDrawLayer('OVERLAY')
	auraBar.bg = auraBar:CreateTexture(nil,'BORDER')
	auraBar.bg:Hide()
	auraBar.iconHolder:RegisterForClicks('RightButtonUp')
	auraBar.iconHolder:SetScript('OnClick',function(self)
		if not IsShiftKeyDown()then return end;
		local n = self:GetParent().aura.name;
		local id = self:GetParent().aura.spellID;
		if id then 
			SuperVillain:AddonMessage(format(L['The spell "%s" has been added to the Blocked unitframe aura filter.'],n))
			SuperVillain.Filters:Change('Blocked', id, {['enable'] = true, ['priority'] = 0})
			MOD:RefreshUnitFrames()
		end 
	end)
end;

function MOD:ColorizeAuraBars()
	local bars = self.bars;
	for i=1,#bars do 
		local auraBar = bars[i]
		if not auraBar:IsVisible()then break end;
		local color
		local spellName = auraBar.statusBar.aura.name;
		local spellID = auraBar.statusBar.aura.spellID;
		if(SuperVillain.Filters["Shield"][spellName]) then 
			color = oUF_SuperVillain.colors.shield_bars
		elseif(SuperVillain.db.media.unitframes.spellcolor[spellName]) then
			color = SuperVillain.db.media.unitframes.spellcolor[spellName]
		end;
		if color then 
			auraBar.statusBar:SetStatusBarColor(unpack(color))
			auraBar.statusBar.bg:SetTexture(color[1]*0.25,color[2]*0.25,color[3]*0.25)
		else
			local r,g,b = auraBar.statusBar:GetStatusBarColor()
			auraBar.statusBar.bg:SetTexture(r*0.25,g*0.25,b*0.25)
		end 
	end 
end;

local function CheckAuraFilter(setting,helpful)
	local friend, enemy = false, false
	if type(setting)=='boolean' then 
		friend = setting;
	  	enemy = setting
	elseif setting and type(setting)~='string' then 
		friend = setting.friendly;
	  	enemy = setting.enemy
	end;
	if (friend and helpful) or (enemy and not helpful) then 
	  return true;
	end
  	return false 
end;

function MOD:AuraBarFilter(unit,name,_,_,_,debuffType,duration,_,unitCaster,isStealable,shouldConsolidate,spellID)
	if not MOD.db then return end;
	if(spellID == 65148) then 
		return false;
	end
	local db = self.db.aurabar;
	local filtered = (unitCaster=='player' or unitCaster=='vehicle') and true or false;
	local allowed = true;
	local pass = false;
	local friendly = UnitIsFriend('player',unit) == 1 and true or false;

	if CheckAuraFilter(db.filterPlayer,friendly) then
		allowed=filtered;
		pass=true 
	end;
	if CheckAuraFilter(db.filterDispellable,friendly)then 
		if (self.type=='buffs' and not isStealable) or (self.type=='debuffs' and debuffType and not SuperVillain:DispellAvailable(debuffType)) or debuffType==nil then 
			filtered=false 
		end;
		pass=true 
	end;
	if CheckAuraFilter(db.filterRaid,friendly)then 
		if shouldConsolidate==1 then filtered=false end;
		pass=true 
	end;
	if CheckAuraFilter(db.filterInfinite,friendly)then 
		if duration==0 or not duration then 
			filtered=false 
		end;
		pass=true 
	end;
	if CheckAuraFilter(db.filterBlocked,friendly)then
		local blackList = SuperVillain.Filters['Blocked'][name]
		if blackList and blackList.enable then filtered=false end;
		pass=true 
	end;
	if CheckAuraFilter(db.filterAllowed,friendly)then 
		local whiteList = SuperVillain.Filters['Allowed'][name]
		if whiteList and whiteList.enable then 
			filtered=true 
		elseif not pass then 
			filtered=false 
		end;
		pass=true 
	end;
	if db.useFilter and SuperVillain.Filters[db.useFilter]then
		local spellsDB = SuperVillain.Filters[db.useFilter];
		if db.useFilter ~= 'Blocked' then 
			if spellsDB[name] and spellsDB[name].enable and allowed then 
				filtered=true 
			elseif not pass then 
				filtered=false
			end 
		elseif spellsDB[name] and spellsDB[name].enable then 
			filtered=false 
		end 
	end;
	return filtered 
end;
--[[ 
########################################################## 
UTILITY
##########################################################
]]--
function MOD:CreateAuraBarHeader(frame,unitName)
	local abHeader = CreateFrame('Frame',nil,frame)
	abHeader.parent = frame;
	abHeader.PostCreateBar = self.CreateAuraBars;
	abHeader.gap = -1;
	abHeader.spacing = -1;
	abHeader.spark = true;
	abHeader.filter = self.AuraBarFilter;
	abHeader.PostUpdate = self.ColorizeAuraBars;
	local bartex = self.db.auraBarStatusbar
	abHeader.auraBarTexture = LSM:Fetch("statusbar", bartex);
	self:WatchUnitMedia("aurabars", abHeader)
	return abHeader 
end;

function MOD:SortAuraBars(parent,sorting)
	if not parent then return end;
	if sorting=='TIME_REMAINING' then 
		parent.sort=true;
	elseif sorting=='TIME_REMAINING_REVERSE' then 
		parent.sort=function(a,b)local compA,compB=a.noTime and huge or a.expirationTime, b.noTime and huge or b.expirationTime; return compA < compB end; 
	elseif sorting=='TIME_DURATION' then 
		parent.sort=function(a,b)local compA,compB=a.noTime and huge or a.duration, b.noTime and huge or b.duration; return compA > compB end;
	elseif sorting=='TIME_DURATION_REVERSE' then 
		parent.sort=function(a,b)local compA,compB=a.noTime and huge or a.duration, b.noTime and huge or b.duration; return compA < compB end; 
	elseif sorting=='NAME' then 
		parent.sort=function(a,b)return a.name > b.name end;
	else 
		parent.sort=nil;
	end;
end;