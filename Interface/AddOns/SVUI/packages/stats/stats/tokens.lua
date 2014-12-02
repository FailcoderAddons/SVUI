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
    if(not IsLoggedIn() or (not self)) then return end
    local id = self.TokenKey or 738;
    local _, current, tex = GetCurrencyInfo(id)
    local currentText = ("\124T%s:12\124t %s"):format(tex, current);
    self.text:SetText(currentText)
end 

local function AddToTokenMenu(parent, id)
	local name, _, tex, _, _, _, _ = GetCurrencyInfo(id)
	local itemName = "\124T"..tex..":12\124t "..name;
	local fn = function() 
		MOD.Accountant[playerRealm]["tokens"][playerName][parent.SlotKey] = id;
    parent.TokenKey = id
		TokensEventHandler(parent)
	end  
	tinsert(parent.TokenList, {text = itemName, func = fn});
end

local function CacheTokenData(self)
    twipe(self.TokenList)
    local prof1, prof2, archaeology, _, cooking = GetProfessions()
    if archaeology then
        AddToTokenMenu(self, 398)
        AddToTokenMenu(self, 384)
        AddToTokenMenu(self, 393)
        AddToTokenMenu(self, 677)
        AddToTokenMenu(self, 400)
        AddToTokenMenu(self, 394)
        AddToTokenMenu(self, 397)
        AddToTokenMenu(self, 676)
        AddToTokenMenu(self, 401)
        AddToTokenMenu(self, 385)
        AddToTokenMenu(self, 399)
        AddToTokenMenu(self, 821)
        AddToTokenMenu(self, 829)
        AddToTokenMenu(self, 944)
    end
    if cooking then
        AddToTokenMenu(self, 81)
        AddToTokenMenu(self, 402)
    end
    if(prof1 == 9 or prof2 == 9) then
        AddToTokenMenu(self, 61)
        AddToTokenMenu(self, 361)
        AddToTokenMenu(self, 698)

        AddToTokenMenu(self, 910)
        AddToTokenMenu(self, 999)
        AddToTokenMenu(self, 1020)
        AddToTokenMenu(self, 1008)
        AddToTokenMenu(self, 1017)
    end
    AddToTokenMenu(self, 697, false, true)
    AddToTokenMenu(self, 738)
    AddToTokenMenu(self, 615)
    AddToTokenMenu(self, 614)
    AddToTokenMenu(self, 395, false, true)
    AddToTokenMenu(self, 396, false, true)
    AddToTokenMenu(self, 390, true)
    AddToTokenMenu(self, 392, false, true)
    AddToTokenMenu(self, 391)
    AddToTokenMenu(self, 241)
    AddToTokenMenu(self, 416)
    AddToTokenMenu(self, 515)
    AddToTokenMenu(self, 776)
    AddToTokenMenu(self, 777)
    AddToTokenMenu(self, 789)
    AddToTokenMenu(self, 823)
    AddToTokenMenu(self, 824)
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
  MOD.tooltip:AddLine("Garrison")
  TokenInquiry(823)
  TokenInquiry(824)
  TokenInquiry(910)
  TokenInquiry(999)
  TokenInquiry(1020)
  TokenInquiry(1008)
  TokenInquiry(1017)

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
    TokenInquiry(821)
    TokenInquiry(829)
    TokenInquiry(944)
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
  CacheTokenData(self);
	SV.Dropdown:Open(self, self.TokenList) 
end

local function Tokens_OnInit(self)
  local key = self.SlotKey
  MOD.Accountant[playerRealm]["tokens"][playerName][key] = MOD.Accountant[playerRealm]["tokens"][playerName][key] or 738;
  self.TokenKey = MOD.Accountant[playerRealm]["tokens"][playerName][key]
  CacheTokenData(self);
end

MOD:Extend('Tokens', TokenEvents, TokensEventHandler, nil,  Tokens_OnClick,  Tokens_OnEnter, nil, Tokens_OnInit)