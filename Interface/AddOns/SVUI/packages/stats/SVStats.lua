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
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local type      = _G.type;
local string    = _G.string;
local math      = _G.math;
--[[ STRING METHODS ]]--
local join = string.join;
--[[ MATH METHODS ]]--
local min = math.min;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = {};
MOD.Anchors = {};
MOD.Statistics = {};
MOD.PlotPoints = {'middle','left','right'};
MOD.tooltip = CreateFrame("GameTooltip", "StatisticTooltip", UIParent, "GameTooltipTemplate")
--[[ 
########################################################## 
LOCALIZED GLOBALS
##########################################################
]]--
local SVUI_CLASS_COLORS = _G.SVUI_CLASS_COLORS
local RAID_CLASS_COLORS = _G.RAID_CLASS_COLORS
--[[ 
########################################################## 
LOCAL VARIABLES
##########################################################
]]--
--local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
local hexString = "|cffFFFFFF";
local myName = UnitName("player");
local myClass = select(2,UnitClass("player"));
local classColor = RAID_CLASS_COLORS[myClass];
local BGStatString = '';
local StatMenuFrame = CreateFrame("Frame", "SVUI_StatMenu", UIParent);
local ListNeedsUpdate = true
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function GrabPlot(parent,slot,max)
  if max==1 then 
    return'CENTER',parent,'CENTER'
  else 
    if slot==1 then 
      return'CENTER',parent,'CENTER'
    elseif slot==2 then 
      return'RIGHT',parent.holders['middle'],'LEFT',-4,0 
    elseif slot==3 then 
      return'LEFT',parent.holders['middle'],'RIGHT',4,0 
    end 
  end 
end;

local UpdateAnchor = function()
  for _,anchor in pairs(MOD.Anchors)do 
    local w=anchor:GetWidth() / anchor.numPoints - 4;
    local h=anchor:GetHeight() - 4;
    for i=1,anchor.numPoints do 
      local this=MOD.PlotPoints[i]
      anchor.holders[this]:Width(w)
      anchor.holders[this]:Height(h)
      anchor.holders[this]:Point(GrabPlot(anchor,i,numPoints))
    end 
  end 
end;

local _hook_TooltipOnShow = function(self)
  self:SetBackdrop({
    bgFile = [[Interface\AddOns\SVUI\assets\artwork\Template\DEFAULT]], 
    edgeFile = [[Interface\BUTTONS\WHITE8X8]], 
    tile = false, 
    edgeSize = 1
  })
  self:SetBackdropColor(0, 0, 0, 0.8)
  self:SetBackdropBorderColor(0, 0, 0)
end;

local function TruncateString(value)
    if value >= 1e9 then 
        return ("%.1fb"):format(value/1e9):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e6 then 
        return ("%.1fm"):format(value/1e6):gsub("%.?0+([kmb])$","%1")
    elseif value >= 1e3 or value <= -1e3 then 
        return ("%.1fk"):format(value/1e3):gsub("%.?0+([kmb])$","%1")
    else 
        return value 
    end 
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:Tip(f)
  local p = f:GetParent()
  MOD.tooltip:Hide()
  MOD.tooltip:SetOwner(p,p.anchor,p.xOff,p.yOff)
  MOD.tooltip:ClearLines()
  GameTooltip:Hide()
end;

function MOD:ShowTip(noSpace)
  if(not noSpace) then
    MOD.tooltip:AddLine(" ")
  end
  MOD.tooltip:AddDoubleLine("[Alt + Click]","Swap Stats",0,1,0, 0.5,1,0.5)
  MOD.tooltip:Show()
end;

function MOD:NewAnchor(parent, maxCount, tipAnchor, x, y)
  ListNeedsUpdate = true
  MOD.Anchors[parent:GetName()] = parent;
  parent.holders = {};
  parent.numPoints = maxCount;
  parent.xOff = x;
  parent.yOff = y;
  parent.anchor = tipAnchor;
  for i = 1, maxCount do 
    local this = MOD.PlotPoints[i]
    if not parent.holders[this] then
      parent.holders[this] = CreateFrame("Button", "DataText"..i, parent)
      parent.holders[this]:RegisterForClicks("AnyUp")
      parent.holders[this].barframe = CreateFrame("Frame", nil, parent.holders[this])
      parent.holders[this].barframe:Point("TOPLEFT", parent.holders[this], "TOPLEFT", 24, 2)
      parent.holders[this].barframe:Point("BOTTOMRIGHT", parent.holders[this], "BOTTOMRIGHT", 3, -2)
      parent.holders[this].barframe:SetFrameLevel(parent.holders[this]:GetFrameLevel()-1)
      parent.holders[this].barframe:SetBackdrop({
        bgFile = [[Interface\BUTTONS\WHITE8X8]], 
        edgeFile = [[Interface\AddOns\SVUI\assets\artwork\Template\GLOW]], 
        tile = false, 
        tileSize = 0, 
        edgeSize = 2, 
        insets = {left = 0, right = 0, top = 0, bottom = 0}
      })
      parent.holders[this].barframe:SetBackdropColor(0, 0, 0, 0.5)
      parent.holders[this].barframe:SetBackdropBorderColor(0, 0, 0, 0.8)
      parent.holders[this].barframe.icon = CreateFrame("Frame", nil, parent.holders[this].barframe)
      parent.holders[this].barframe.icon:Point("TOPLEFT", parent.holders[this], "TOPLEFT", 0, 6)
      parent.holders[this].barframe.icon:Point("BOTTOMRIGHT", parent.holders[this], "BOTTOMLEFT", 26, -6)
      parent.holders[this].barframe.icon.texture = parent.holders[this].barframe.icon:CreateTexture(nil, "OVERLAY")
      parent.holders[this].barframe.icon.texture:FillInner(parent.holders[this].barframe.icon, 2, 2)
      parent.holders[this].barframe.icon.texture:SetTexture("Interface\\Addons\\SVUI\\assets\\artwork\\Icons\\PLACEHOLDER")
      parent.holders[this].barframe.bar = CreateFrame("StatusBar", nil, parent.holders[this].barframe)
      parent.holders[this].barframe.bar:FillInner(parent.holders[this].barframe, 2, 2)
      parent.holders[this].barframe.bar:SetStatusBarTexture(SuperVillain.Media.bar.default)
      parent.holders[this].barframe.bg = parent.holders[this].barframe:CreateTexture(nil, "BORDER")
      parent.holders[this].barframe.bg:FillInner(parent.holders[this].barframe, 2, 2)
      parent.holders[this].barframe.bg:SetTexture([[Interface\BUTTONS\WHITE8X8]])
      parent.holders[this].barframe.bg:SetGradient(unpack(SuperVillain.Media.gradient.dark))
      parent.holders[this].barframe.bar.extra = CreateFrame("StatusBar", nil, parent.holders[this].barframe.bar)
      parent.holders[this].barframe.bar.extra:SetAllPoints()
      parent.holders[this].barframe.bar.extra:SetStatusBarTexture(SuperVillain.Media.bar.default)
      parent.holders[this].barframe.bar.extra:Hide()
      parent.holders[this].barframe:Hide()
      parent.holders[this].textframe = CreateFrame("Frame", nil, parent.holders[this])
      parent.holders[this].textframe:SetAllPoints(parent.holders[this])
      parent.holders[this].textframe:SetFrameStrata("HIGH")
      parent.holders[this].text = parent.holders[this].textframe:CreateFontString(nil, "OVERLAY", nil, 7)
      parent.holders[this].text:SetAllPoints()
      parent.holders[this].text:SetFontTemplate(SuperVillain.Shared:Fetch("font", MOD.db.font), MOD.db.fontSize, MOD.db.fontOutline)
      parent.holders[this].text:SetJustifyH("CENTER")
      parent.holders[this].text:SetJustifyV("middle")
    end;
    parent.holders[this].MenuList = {};
    parent.holders[this]:Point(GrabPlot(parent, i, maxCount))
  end;
  parent:SetScript("OnSizeChanged", UpdateAnchor)
  UpdateAnchor(parent)
end;

function MOD:Extend(newStat,eventList,onEvents,update,click,focus,blur)
  if not newStat then return end;
  MOD.Statistics[newStat]={}
  if type(eventList)=='table'then 
    MOD.Statistics[newStat]['events']=eventList;
    MOD.Statistics[newStat]['event_handler']=onEvents 
  end;
  if update and type(update)=='function'then 
    MOD.Statistics[newStat]['update_handler']=update 
  end;
  if click and type(click)=='function'then 
    MOD.Statistics[newStat]['click_handler']=click 
  end;
  if focus and type(focus)=='function'then 
    MOD.Statistics[newStat]['focus_handler']=focus 
  end;
  if blur and type(blur)=='function'then 
    MOD.Statistics[newStat]['blur_handler']=blur 
  end 
end;

do
  local dataLayout, dataStrings = {}, {"None",KILLING_BLOWS,HONORABLE_KILLS,DEATHS,HONOR,"None","None","None","None",DAMAGE,SHOW_COMBAT_HEALING};
  dataLayout["TopLeftDataPanel"] = {true,true,true};
  dataLayout["TopLeftDataPanel"]['left'] = 10;
  dataLayout["TopLeftDataPanel"]['middle'] = 5;
  dataLayout["TopLeftDataPanel"]['right'] = 2;
  dataLayout["TopRightDataPanel"] = {true,true,true};
  dataLayout["TopRightDataPanel"]['left'] = 4;
  dataLayout["TopRightDataPanel"]['middle'] = 3;
  dataLayout["TopRightDataPanel"]['right'] = 11;
  local Stat_OnLeave = function()
    MOD.tooltip:Hide()
  end

  local DD_OnClick = function(self)
      self.func()
      self:GetParent():Hide()
  end

  local DD_OnEnter = function(self)
      self.hoverTex:Show()
  end

  local DD_OnLeave = function(self)
      self.hoverTex:Hide()
  end

  local function _locate(parent)
      local centerX,centerY = parent:GetCenter()
      local screenWidth = GetScreenWidth()
      local screenHeight = GetScreenHeight()
      local result;
      if not centerX or not centerY then 
          return "CENTER"
      end;
      local heightTop = screenHeight * 0.75;
      local heightBottom = screenHeight * 0.25;
      local widthLeft = screenWidth * 0.25;
      local widthRight = screenWidth * 0.75;
      if(((centerX > widthLeft) and (centerX < widthRight)) and (centerY > heightTop)) then 
          result="TOP"
      elseif((centerX < widthLeft) and (centerY > heightTop)) then 
          result="TOPLEFT"
      elseif((centerX > widthRight) and (centerY > heightTop)) then 
          result="TOPRIGHT"
      elseif(((centerX > widthLeft) and (centerX < widthRight)) and centerY < heightBottom) then 
          result="BOTTOM"
      elseif((centerX < widthLeft) and (centerY < heightBottom)) then 
          result="BOTTOMLEFT"
      elseif((centerX > widthRight) and (centerY < heightBottom)) then 
          result="BOTTOMRIGHT"
      elseif((centerX < widthLeft) and (centerY > heightBottom) and (centerY < heightTop)) then 
          result="LEFT"
      elseif((centerX > widthRight) and (centerY < heightTop) and (centerY > heightBottom)) then 
          result="RIGHT"
      else 
          result="CENTER"
      end;
      return result 
  end

  function MOD:SetStatMenu(self, list)
      if not StatMenuFrame.buttons then
          StatMenuFrame.buttons = {}
          StatMenuFrame:SetFrameStrata("DIALOG")
          StatMenuFrame:SetClampedToScreen(true)
          tinsert(UISpecialFrames, StatMenuFrame:GetName())
          StatMenuFrame:Hide()
      end
      local maxPerColumn = 25
      local cols = 1
      for i=1, #StatMenuFrame.buttons do
          StatMenuFrame.buttons[i]:Hide()
      end
      for i=1, #list do 
          if not StatMenuFrame.buttons[i] then
              StatMenuFrame.buttons[i] = CreateFrame("Button", nil, StatMenuFrame)
              StatMenuFrame.buttons[i].hoverTex = StatMenuFrame.buttons[i]:CreateTexture(nil, 'OVERLAY')
              StatMenuFrame.buttons[i].hoverTex:SetAllPoints()
              StatMenuFrame.buttons[i].hoverTex:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]])
              StatMenuFrame.buttons[i].hoverTex:SetBlendMode("ADD")
              StatMenuFrame.buttons[i].hoverTex:Hide()
              StatMenuFrame.buttons[i].text = StatMenuFrame.buttons[i]:CreateFontString(nil, 'BORDER')
              StatMenuFrame.buttons[i].text:SetAllPoints()
              StatMenuFrame.buttons[i].text:SetFont(SuperVillain.Media.font.roboto,12,"OUTLINE")
              StatMenuFrame.buttons[i].text:SetJustifyH("LEFT")
              StatMenuFrame.buttons[i]:SetScript("OnEnter", DD_OnEnter)
              StatMenuFrame.buttons[i]:SetScript("OnLeave", DD_OnLeave)           
          end
          StatMenuFrame.buttons[i]:Show()
          StatMenuFrame.buttons[i]:SetHeight(16)
          StatMenuFrame.buttons[i]:SetWidth(135)
          StatMenuFrame.buttons[i].text:SetText(list[i].text)
          StatMenuFrame.buttons[i].func = list[i].func
          StatMenuFrame.buttons[i]:SetScript("OnClick", DD_OnClick)
          if i == 1 then
              StatMenuFrame.buttons[i]:SetPoint("TOPLEFT", StatMenuFrame, "TOPLEFT", 10, -10)
          elseif((i -1) % maxPerColumn == 0) then
              StatMenuFrame.buttons[i]:SetPoint("TOPLEFT", StatMenuFrame.buttons[i - maxPerColumn], "TOPRIGHT", 10, 0)
              cols = cols + 1
          else
              StatMenuFrame.buttons[i]:SetPoint("TOPLEFT", StatMenuFrame.buttons[i - 1], "BOTTOMLEFT")
          end
      end
      local maxHeight = (min(maxPerColumn, #list) * 16) + 20
      local maxWidth = (135 * cols) + (10 * cols)
      StatMenuFrame:SetSize(maxWidth, maxHeight)    
      StatMenuFrame:ClearAllPoints()
      local point = _locate(self:GetParent()) 
      if strfind(point, "BOTTOM") then
          StatMenuFrame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 10, 10)
      else
          StatMenuFrame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 10, -10)
      end
      ToggleFrame(StatMenuFrame)
  end

  local Parent_OnClick = function(self, button)
    if IsAltKeyDown() then
      MOD:SetStatMenu(self, self.MenuList);
    elseif(self.onClick) then
      if(StatMenuFrame:IsShown()) then
        ToggleFrame(StatMenuFrame)
      else
        self.onClick(self, button);
      end
    end
  end

  local function _load(parent, config)
    if config["events"]then 
      for _, event in pairs(config["events"])do 
        parent:RegisterEvent(event)
      end 
    end;
    if config["event_handler"]then 
      parent:SetScript("OnEvent", config["event_handler"])
      config["event_handler"](parent, "SVUI_FORCE_RUN")
    end;
    if config["update_handler"]then 
      parent:SetScript("OnUpdate", config["update_handler"])
      config["update_handler"](parent, 20000)
    end;
    if config["click_handler"]then
      parent.onClick = config["click_handler"]
    end
    parent:SetScript("OnClick", Parent_OnClick)
    if config["focus_handler"]then 
      parent:SetScript("OnEnter", config["focus_handler"])
    end;
    if config["blur_handler"]then 
      parent:SetScript("OnLeave", config["blur_handler"])
    else 
      parent:SetScript("OnLeave", Stat_OnLeave)
    end 
  end

  local BGStatPrev;
  local BG_OnUpdate = function(self)
    BGStatPrev = self;
    local truncated, tmp, bgName;
    local parentName = BGStatPrev:GetParent():GetName();
    local lookup = BGStatPrev.pointIndex
    local pointIndex = dataLayout[parentName][lookup]
    local scoreType = dataStrings[pointIndex]
    for index = 1, GetNumBattlefieldScores() do 
      bgName = GetBattlefieldScore(index)
      if(bgName == myName) then
        tmp = select(pointIndex, GetBattlefieldScore(index))
        truncated = TruncateString(tmp)
        BGStatPrev.text:SetFormattedText(BGStatString, scoreType, truncated)
        break 
      end 
    end 
  end

  local BG_OnEnter = function(self)
    MOD:Tip(self)
    local bgName;
    local mapToken = GetCurrentMapAreaID()
    local r, g, b;
    if(classColor) then
      r, g, b = classColor.r, classColor.g, classColor.b
    else
      r, g, b = 1, 1, 1
    end
    for i = 1, GetNumBattlefieldScores() do 
      bgName = GetBattlefieldScore(i)
      if(bgName and bgName == myName) then 
        MOD.tooltip:AddDoubleLine(L["Stats For:"], bgName, 1, 1, 1, r, g, b)
        MOD.tooltip:AddLine(" ")
        if(mapToken == 443 or mapToken == 626) then 
          MOD.tooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Flags Returned"], GetBattlefieldStatData(i, 2), 1, 1, 1)
        elseif(mapToken == 482) then 
          MOD.tooltip:AddDoubleLine(L["Flags Captured"], GetBattlefieldStatData(i, 1), 1, 1, 1)
        elseif(mapToken == 401) then 
          MOD.tooltip:AddDoubleLine(L["Graveyards Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Graveyards Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Towers Assaulted"], GetBattlefieldStatData(i, 3), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Towers Defended"], GetBattlefieldStatData(i, 4), 1, 1, 1)
        elseif(mapToken == 512) then 
          MOD.tooltip:AddDoubleLine(L["Demolishers Destroyed"], GetBattlefieldStatData(i, 1), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Gates Destroyed"], GetBattlefieldStatData(i, 2), 1, 1, 1)
        elseif(mapToken == 540 or mapToken == 736 or mapToken == 461) then 
          MOD.tooltip:AddDoubleLine(L["Bases Assaulted"], GetBattlefieldStatData(i, 1), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Bases Defended"], GetBattlefieldStatData(i, 2), 1, 1, 1)
        elseif(mapToken == 856) then 
          MOD.tooltip:AddDoubleLine(L["Orb Possessions"], GetBattlefieldStatData(i, 1), 1, 1, 1)
          MOD.tooltip:AddDoubleLine(L["Victory Points"], GetBattlefieldStatData(i, 2), 1, 1, 1)
        elseif(mapToken == 860) then 
          MOD.tooltip:AddDoubleLine(L["Carts Controlled"], GetBattlefieldStatData(i, 1), 1, 1, 1)
        end;
        break 
      end 
    end;
    MOD:ShowTip()
  end

  local ForceHideBGStats;
  local BG_OnClick = function()
    ForceHideBGStats = true;
    MOD:Generate()
    SuperVillain:AddonMessage(L["Battleground statistics temporarily hidden, to show type \"/sv bg\" or \"/sv pvp\""])
  end

  local function SetMenuLists()
    for place,parent in pairs(MOD.Anchors)do
      for h = 1, parent.numPoints do 
        local this = MOD.PlotPoints[h]
        tinsert(parent.holders[this].MenuList,{text = NONE, func = function() MOD:ChangeDBVar(NONE, this, "panels", place); MOD:Generate() end});
        for name,config in pairs(MOD.Statistics)do
          tinsert(parent.holders[this].MenuList,{text = name, func = function() MOD:ChangeDBVar(name, this, "panels", place); MOD:Generate() end});
        end 
      end
      ListNeedsUpdate = false;
    end
  end;

  function MOD:Generate()
    if(ListNeedsUpdate) then
      SetMenuLists()
    end
    local instance, groupType = IsInInstance()
    for place, parent in pairs(MOD.Anchors)do
      for h = 1, parent.numPoints do 
        local this = MOD.PlotPoints[h]
        parent.holders[this]:UnregisterAllEvents()
        parent.holders[this]:SetScript("OnUpdate", nil)
        parent.holders[this]:SetScript("OnEnter", nil)
        parent.holders[this]:SetScript("OnLeave", nil)
        parent.holders[this]:SetScript("OnClick", nil)
        parent.holders[this].text:SetFontTemplate(SuperVillain.Shared:Fetch("font", MOD.db.font), MOD.db.fontSize, MOD.db.fontOutline)
        parent.holders[this].text:SetText(nil)
        if parent.holders[this].barframe then 
          parent.holders[this].barframe:Hide()
        end;
        parent.holders[this].pointIndex = this;
        if place == "TopLeftDataPanel" and instance and groupType == "pvp" and not ForceHideBGStats and SuperVillain.db.SVStats.battleground then 
          parent.holders[this]:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
          parent.holders[this]:SetScript("OnEvent", BG_OnUpdate)
          parent.holders[this]:SetScript("OnEnter", BG_OnEnter)
          parent.holders[this]:SetScript("OnLeave", Stat_OnLeave)
          parent.holders[this]:SetScript("OnClick", BG_OnClick)
          BG_OnUpdate(parent.holders[this])
        else 
          for name, config in pairs(MOD.Statistics)do
            for k, l in pairs(SuperVillain.db.SVStats.panels)do 
              if l and type(l) == "table"then 
                if k == place and SuperVillain.db.SVStats.panels[k][this] and SuperVillain.db.SVStats.panels[k][this] == name then 
                  _load(parent.holders[this], config)
                end 
              elseif l and type(l) == "string"and l == name then 
                if SuperVillain.db.SVStats.panels[k] == name and k == place then 
                  _load(parent.holders[this], config)
                end 
              end 
            end
          end 
        end 
      end
    end;
    if ForceHideBGStats then ForceHideBGStats = nil end
  end

  local BGStatColorUpdate = function()
    BGStatString = join("","%s: ", hexString, "%s|r")
    if BGStatPrev ~= nil then 
      BG_OnUpdate(BGStatPrev)
    end 
  end;
  SuperVillain.Registry:SetCallback(BGStatColorUpdate);
end;
--[[ 
########################################################## 
BUILD FUNCTION / UPDATE
##########################################################
]]--
function MOD:ReLoad()
  self:Generate()
end;

function MOD:Load()
  hexString = SuperVillain:HexColor("highlight") or "|cffFFFFFF"
  SVUI_Global["Accountant"] = SVUI_Global["Accountant"] or {};
  SVUI_Global["Accountant"][SuperVillain.realm] = SVUI_Global["Accountant"][SuperVillain.realm] or {};
  SVUI_Global["Accountant"][SuperVillain.realm]["gold"] = SVUI_Global["Accountant"][SuperVillain.realm]["gold"] or {};
  SVUI_Global["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] = SVUI_Global["Accountant"][SuperVillain.realm]["gold"][SuperVillain.name] or 0;
  SVUI_Global["Accountant"][SuperVillain.realm]["tokens"] = SVUI_Global["Accountant"][SuperVillain.realm]["tokens"] or {};
  SVUI_Global["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name] = SVUI_Global["Accountant"][SuperVillain.realm]["tokens"][SuperVillain.name] or 738;

  SuperVillain.Registry:RunTemp("SVStats")

  StatMenuFrame:SetParent(SuperVillain.UIParent);
  StatMenuFrame:SetPanelTemplate("Transparent");
  StatMenuFrame:Hide()
	MOD.tooltip:SetParent(SuperVillain.UIParent)
  MOD.tooltip:SetFrameStrata("DIALOG")
	MOD.tooltip:HookScript("OnShow", _hook_TooltipOnShow)

	self:Generate()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "Generate")
end

SuperVillain.Registry:NewPackage(MOD, "SVStats");

--[[
MAPID REFERENCE

WSG=443
TP=626
AV=401
SOTA=512
IOC=540
EOTS=482
TBFG=736
AB=461
TOK=856
SSM=860
]]--