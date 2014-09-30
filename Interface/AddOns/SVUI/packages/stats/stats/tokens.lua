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

STATS:Extend EXAMPLE USAGE: MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)

########################################################## 
LOCALIZED LUA FUNCTIONS
##########################################################
]]--
--[[ GLOBALS ]]--
local _G = _G;
local unpack 	= _G.unpack;
local select 	= _G.select;
local tinsert 	= _G.tinsert;
local table     = _G.table;
local twipe     = table.wipe; 
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SV = select(2, ...)
local L = SV.L;
local MOD = SV.SVStats;
--[[ 
########################################################## 
GOLD STATS
##########################################################
]]--
local playerName = UnitName("player");
local playerRealm = GetRealmName();

local TokenEvents = {'PLAYER_ENTERING_WORLD','PLAYER_MONEY','CURRENCY_DISPLAY_UPDATE'};
local TokenMenuList = {};
local TokenParent;

local function TokenInquiry(id, weekly, capped)
  local name, amount, tex, week, weekmax, maxed, discovered = GetCurrencyInfo(id)
  local r, g, b = 1, 1, 1
  for i = 1, GetNumWatchedTokens() do
    local _, _, _, itemID = GetBackpackCurrencyInfo(i)
    if id == itemID then r, g, b = 0.23, 0.88, 0.27 end
  end
  local texStr = ("\124T%s:12\124t %s"):format(tex, name)
  local altStr = ""
  if weekly then
    if discovered then
      if id == 390 then
        altStr = ("Current: %d | Weekly: %d / %d"):format(amount, week, weekmax)
      else
        altStr = ("Current: %d / %d | Weekly: %d / %d"):format(amount, maxed, week, weekmax)
      end
      MOD.tooltip:AddDoubleLine(texStr, altStr, r, g, b, r, g, b)
    end
  elseif capped then
    if id == 392 or id == 395 then maxed = 4000 end
    if id == 396 then maxed = 3000 end
    if discovered then
      altStr = ("%d / %d"):format(amount, maxed)
      MOD.tooltip:AddDoubleLine(texStr, altStr, r, g, b, r, g, b)
    end
  else
    if discovered then
      MOD.tooltip:AddDoubleLine(texStr, amount, r, g, b, r, g, b)
    end
  end
end

local function TokensEventHandler(self, event,...)
    if not IsLoggedIn() or not self then return end 
    local id = MOD.Accountant[playerRealm]["tokens"][playerName];
    local _, current, tex = GetCurrencyInfo(id)
    local currentText = ("\124T%s:12\124t %s"):format(tex, current);
    self.text:SetText(currentText)
end 

local function AddToTokenMenu(id)
	local name, _, tex, _, _, _, _ = GetCurrencyInfo(id)
	local itemName = "\124T"..tex..":12\124t "..name;
	local fn = function() 
		MOD.Accountant[playerRealm]["tokens"][playerName] = id;
		TokensEventHandler(TokenParent)
	end  
	tinsert(TokenMenuList, {text = itemName, func = fn});
end

function MOD:CacheTokenData()
    twipe(TokenMenuList)
    local prof1, prof2, archaeology, _, cooking = GetProfessions()
    if archaeology then
        AddToTokenMenu(398)
        AddToTokenMenu(384)
        AddToTokenMenu(393)
        AddToTokenMenu(677)
        AddToTokenMenu(400)
        AddToTokenMenu(394)
        AddToTokenMenu(397)
        AddToTokenMenu(676)
        AddToTokenMenu(401)
        AddToTokenMenu(385)
        AddToTokenMenu(399)
    end
    if cooking then
        AddToTokenMenu(81)
        AddToTokenMenu(402)
    end
    if(prof1 == 9 or prof2 == 9) then
        AddToTokenMenu(61)
        AddToTokenMenu(361)
        AddToTokenMenu(698)
    end
    AddToTokenMenu(697, false, true)
    AddToTokenMenu(738)
    AddToTokenMenu(615)
    AddToTokenMenu(614)
    AddToTokenMenu(395, false, true)
    AddToTokenMenu(396, false, true)
    AddToTokenMenu(390, true)
    AddToTokenMenu(392, false, true)
    AddToTokenMenu(391)
    AddToTokenMenu(241)
    AddToTokenMenu(416)
    AddToTokenMenu(515)
    AddToTokenMenu(776)
    AddToTokenMenu(777)
    AddToTokenMenu(789)
end

local function Tokens_OnEnter(self)
	MOD:Tip(self)
	MOD.tooltip:AddLine(playerName .. "\'s Tokens")

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("Common")
	TokenInquiry(241)
	TokenInquiry(416)
	TokenInquiry(515)
	TokenInquiry(776)
	TokenInquiry(777)
	TokenInquiry(789)

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("Raiding and Dungeons")
	TokenInquiry(697, false, true)
	TokenInquiry(738)
	TokenInquiry(615)
	TokenInquiry(614)
	TokenInquiry(395, false, true)
	TokenInquiry(396, false, true)

	MOD.tooltip:AddLine(" ")
	MOD.tooltip:AddLine("PvP")
	TokenInquiry(390, true)
	TokenInquiry(392, false, true)
	TokenInquiry(391)

	local prof1, prof2, archaeology, _, cooking = GetProfessions()
	if(archaeology or cooking or prof1 == 9 or prof2 == 9) then
		MOD.tooltip:AddLine(" ")
		MOD.tooltip:AddLine("Professions")
	end
	if cooking then
		TokenInquiry(81)
		TokenInquiry(402)
	end
	if(prof1 == 9 or prof2 == 9) then
		TokenInquiry(61)
		TokenInquiry(361)
		TokenInquiry(698)
	end
	if archaeology then
		TokenInquiry(398)
		TokenInquiry(384)
		TokenInquiry(393)
		TokenInquiry(677)
		TokenInquiry(400)
		TokenInquiry(394)
		TokenInquiry(397)
		TokenInquiry(676)
		TokenInquiry(401)
		TokenInquiry(385)
		TokenInquiry(399)
	end
	MOD.tooltip:AddLine(" ")
  	MOD.tooltip:AddDoubleLine("[Shift + Click]", "Change Watched Token", 0,1,0, 0.5,1,0.5)
	MOD:ShowTip(true)
end 

local function Tokens_OnClick(self, button)
	TokenParent = self;
  MOD:CacheTokenData()
	MOD:SetStatMenu(self, TokenMenuList) 
end 

MOD:Extend('Tokens', TokenEvents, TokensEventHandler, nil,  Tokens_OnClick,  Tokens_OnEnter)