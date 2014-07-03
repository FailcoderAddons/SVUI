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
local unpack  = _G.unpack;
local select  = _G.select;
local pairs   = _G.pairs;
local type    = _G.type;
local tinsert   = _G.tinsert;
local string  = _G.string;
local math    = _G.math;
local table   = _G.table;
--[[ STRING METHODS ]]--
local format,find = string.format, string.find;
--[[ MATH METHODS ]]--
local floor = math.floor;
--[[ TABLE METHODS ]]--
local tremove, twipe = table.remove, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local SuperVillain, L = unpack(select(2, ...));
local MOD = SuperVillain.Registry:Expose('SVDock');
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local ToggleButton = CreateFrame("Button","ToolBarDockletButton",UIParent);
local DOCK_HEIGHT,DOCK_WIDTH;
local SuperDockletMain = CreateFrame('Frame', 'SuperDockletMain', UIParent);
local SuperDockletExtra = CreateFrame('Frame', 'SuperDockletExtra', UIParent);
SuperDockletMain.FrameName = "None";
SuperDockletExtra.FrameName = "None";
local ICONFILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-BAG-MICRO]];
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
MOD.DockletList={};
MOD.MainToolTip = "";
MOD.ExtraToolTip = "";
MOD.CurrentlyDocked = {};

local resizeHook = function()
  MOD:ReloadDocklets()
end;

local rightDockSizeHook = function(self,width,height)
  SuperDockWindowRight:Width(width)
  SuperDockWindowRight:Height(height)
  SuperDockWindowRight:SetPoint("BOTTOMLEFT", SuperDockAlertRight, "TOPLEFT", 0, 0)
end

local DockletFrame_OnShow = function(self)
  local frameName = self.FrameName;
  if (frameName and _G[frameName]) then 
    _G[frameName]:Show()
  end
end;

local Addon_OnEnter=function(b)
  if not b.IsOpen then
    b:SetPanelColor("highlight")
    b.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
  end
  GameTooltip:SetOwner(b,'ANCHOR_TOPLEFT',0,4)
  GameTooltip:ClearLines()
  GameTooltip:AddLine(b.TText,1,1,1)
  GameTooltip:Show()
end;

local Addon_OnLeave=function(b)
  if not b.IsOpen then
    b:SetPanelColor("special")
    b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  end
  GameTooltip:Hide()
end;

local Addon_OnClick=function(b)
  if SuperDockletMain.FrameName and _G[SuperDockletMain.FrameName] then
    if not _G[SuperDockletMain.FrameName]:IsShown() then
      MOD:DockletHide()
      if not InCombatLockdown() and not SuperDockletMain:IsShown()then
        SuperDockletMain:Show()
      end
      _G[SuperDockletMain.FrameName]:Show()
      b.IsOpen=true;
      b:SetPanelColor("green")
      b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
    elseif not SuperDockletMain:IsShown()then
      if not InCombatLockdown() then SuperDockletMain:Show() end
      _G[SuperDockletMain.FrameName]:Show()
      b.IsOpen=true;
      b:SetPanelColor("green")
      b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
    end 
  else
    SuperDockletMain.FrameName="None"
    if InCombatLockdown()then return end;
    if SuperDockletMain:IsShown()then 
      SuperDockletMain:Hide()
    else 
      SuperDockletMain:Show()
    end
    b:SetPanelColor("special")
    b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  end;
  if SuperVillain.db.SVDock.docklets.enableExtra and SuperDockletExtra.FrameName and _G[SuperDockletExtra.FrameName] then
    if not _G[SuperDockletExtra.FrameName]:IsShown() then
      if not InCombatLockdown() and not SuperDockletExtra:IsShown()then
        SuperDockletExtra:Show()
        SuperDockletMain:Show()
      end
      _G[SuperDockletExtra.FrameName]:Show()
      b.IsOpen=true;
      b:SetPanelColor("green")
      b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
    elseif not SuperDockletExtra:IsShown() then
      if not InCombatLockdown() then 
        SuperDockletExtra:Show()
        SuperDockletMain:Show()
      end
      _G[SuperDockletExtra.FrameName]:Show()
      b.IsOpen=true;
      b:SetPanelColor("green")
      b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
    else
      if not InCombatLockdown() then 
        SuperDockletExtra:Hide() 
        SuperDockletMain:Hide()
      end
      b:SetPanelColor("special")
      b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
    end
  else
    SuperDockletExtra.FrameName="None"
  end
end;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
function MOD:DockletShow()
  if(_G[SuperDockWindowRight.FrameName]) then
    if(InCombatLockdown() and (_G[SuperDockWindowRight.FrameName].IsProtected and _G[SuperDockWindowRight.FrameName]:IsProtected())) then return end 
    _G[SuperDockWindowRight.FrameName]:Show()
  end 
  if _G[SuperDockWindowRight.SecondName] then
    if(InCombatLockdown() and (_G[SuperDockWindowRight.SecondName].IsProtected and _G[SuperDockWindowRight.SecondName]:IsProtected())) then return end
    _G[SuperDockWindowRight.SecondName]:Show()
  end 
end;

function MOD:DockletHide()
  --if InCombatLockdown()then SuperVillain:AddonMessage("Cant close any windows in combat. Try again after combat ends...")return end;
  for i=1, #MOD.DockletList do
    local f = MOD.DockletList[i]
    if(not InCombatLockdown() or (InCombatLockdown() and (f.IsProtected and not f:IsProtected()))) then
      f.IsOpen = false;
      local b = _G[f.ToggleName]
      b:SetPanelColor("special")
      b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
      if f.Hide then
        f:Hide()
      end
    end
  end
  -- SuperDockWindowRight:Show()
end;

function MOD:DockWindowResize()
  if InCombatLockdown()then return end;
  local width=RightSuperDock:GetWidth();
  local height=RightSuperDock:GetHeight() - 22
  SuperDockWindowRight:Size(width,height)
  SuperDockWindowRight:SetPoint("BOTTOMLEFT", SuperDockAlertRight, "TOPLEFT", 0, 0)
end;

function MOD:RegisterDocklet(name,tooltip,texture,onclick,isdefault)
  local frame=_G[name];
  if frame and (frame.IsObjectType and frame:IsObjectType('Frame')) and (frame.IsProtected and not frame:IsProtected()) then 
    frame:ClearAllPoints()
    frame:SetParent(SuperDockWindowRight)
    frame:FillInner(SuperDockWindowRight,4,4)
    frame.FrameName=name;
    tinsert(MOD.DockletList,frame);
    frame.listIndex=#MOD.DockletList;
    MOD:CreateBasicToolButton(tooltip,texture,onclick,name,isdefault)
  end
end;

function MOD:UnregisterDocklet(name)
  local frame=_G[name];
  if not frame or not frame.listIndex then return end;
  local i=frame.listIndex;
  tremove(MOD.DockletList,i)
end;

function MOD:CreateDockWindow()
  DOCK_HEIGHT,DOCK_WIDTH = SuperVillain.db.SVDock.dockRightHeight, SuperVillain.db.SVDock.dockRightWidth;
  MOD:DockWindowResize()
  SuperDockWindowRight:SetScript('OnShow',MOD.DockletShow)
  SuperDockWindowRight:SetScript('OnHide',MOD.DockletHide)
  if not InCombatLockdown()then 
    MOD:DockletHide()
  end;
  hooksecurefunc(RightSuperDock,'SetSize', rightDockSizeHook)
end;

function MOD:IsDockletReady(arg)
  local addon = arg;
  if arg == "DockletMain" or arg == "DockletExtra" then
    addon = SuperVillain.db.SVDock.docklets[arg]
  end
  if find(addon, "Skada") then addon = "Skada" end;
  if addon == nil or addon == 'None' or not IsAddOnLoaded(addon) then 
    return false 
  end;
  return true
end;

function MOD:ResizeDocklets()
  if InCombatLockdown()then return end;
  local width = SuperVillain.db.SVDock.dockRightWidth or 350;
  local height = (SuperVillain.db.SVDock.dockRightHeight or 180) - 22
  if MOD:IsDockletReady('DockletMain') then
    if MOD:IsDockletReady("DockletExtra") and SuperVillain.db.SVDock.docklets.enableExtra then
      width = width * 0.5;
    end
    SuperDockletMain:ClearAllPoints()
    SuperDockletMain:Size(width,height)
    SuperDockletMain:Point('BOTTOMLEFT',RightSuperDock,'BOTTOMLEFT',1,1)
    SuperDockletExtra:ClearAllPoints()
    SuperDockletExtra:Size(width,height)
    SuperDockletExtra:Point('BOTTOMLEFT',SuperDockletMain,'BOTTOMRIGHT',0,0)
  end
end;

function MOD:UnsetDockletButton()
  MOD:RemoveTool(ToggleButton)
  ToggleButton.TText="";
  ToggleButton.IsOpen=false;
  ToggleButton.IsRegistered=false;
  ToggleButton:Hide()
end;

function MOD:RegisterMainDocklet(name)
  local frame = _G[name];
  if (frame and (frame.IsObjectType and frame:IsObjectType('Frame')) and (frame.IsProtected and not frame:IsProtected())) then 
    SuperDockletMain.FrameName=name;
    SuperVillain.db.SVDock.docklets.MainWindow = name;
    frame:ClearAllPoints()
    frame:SetParent(SuperDockletMain)
    frame:SetAllPoints(SuperDockletMain)
    frame.ToggleName="ToolBarDockletButton";
    tinsert(MOD.DockletList,frame);
    frame.listIndex=#MOD.DockletList;
    MOD:AddTool(ToggleButton)
    ToggleButton.TText="Open "..MOD.MainToolTip;
    ToggleButton.IsRegistered = true;
    MOD.CurrentlyDocked[name] = true;
    if not ToggleButton:IsShown() then ToggleButton:Show()end;
    if not InCombatLockdown() and frame:IsShown() then frame:Hide() end;
  end
end;

function MOD:RegisterExtraDocklet(name)
  local frame = _G[name];
  if (frame and (frame.IsObjectType and frame:IsObjectType('Frame')) and (frame.IsProtected and not frame:IsProtected())) then  
    SuperDockletExtra.FrameName=name;
    SuperVillain.db.SVDock.docklets.ExtraWindow=name;
    frame:ClearAllPoints()
    frame:SetParent(SuperDockletExtra)
    frame:SetAllPoints(SuperDockletExtra)
    frame.ToggleName="ToolBarDockletButton";
    tinsert(MOD.DockletList,frame);
    frame.listIndex=#MOD.DockletList;
    ToggleButton.TText = MOD.MainToolTip.." and "..MOD.ExtraToolTip;
    MOD.CurrentlyDocked[name] = true;
    if not InCombatLockdown() and frame:IsShown() then frame:Hide() end;
  end
end;

function MOD:UnregisterDocklets()
  local frame,i;
  twipe(MOD.CurrentlyDocked);
  if MOD:IsDockletReady('DockletMain') then
      frame=SuperVillain.db.SVDock.docklets.MainWindow
      if frame~=nil and frame~="None" and _G[frame] then
        MOD:UnregisterDocklet(frame)
        SuperVillain.db.SVDock.docklets.MainWindow="None"
      end
  elseif ToggleButton.IsRegistered then
    MOD:UnsetDockletButton()
  end
  if MOD:IsDockletReady('DockletExtra') then
    frame=SuperVillain.db.SVDock.docklets.ExtraWindow
    if frame~=nil and frame~="None" and _G[frame] then
      MOD:UnregisterDocklet(frame)
      SuperVillain.db.SVDock.docklets.ExtraWindow="None"
    end
  end
  SuperDockletMain.FrameName="None"
  SuperDockletExtra.FrameName="None"
end;

function MOD:ReloadDocklets(alert)
  MOD:UnregisterDocklets()
  MOD:ResizeDocklets()
  MOD.MainToolTip = "";
  MOD.ExtraToolTip = "";
end;

function MOD:DockletEnterCombat(D)
  MOD.CombatLocked = true;
  if SuperVillain.db.SVDock.docklets.DockletCombatFade then 
    SuperDockletMain:Show()
    SuperDockletExtra:Show()
  end 
end;

local timeOutFunc = function()
  if not MOD.CombatLocked then 
    SuperDockletMain:Hide()
    SuperDockletExtra:Hide()
  end 
end;

function MOD:DockletExitCombat(D)
  MOD.CombatLocked = false;
  if SuperVillain.db.SVDock.docklets.DockletCombatFade then 
    SuperVillain:ExecuteTimer(timeOutFunc, 10)
  end
end;

function MOD:CreateDockletButton()
  SuperDockletMain:SetFrameLevel(SuperDockWindowRight:GetFrameLevel() + 50)
  SuperDockletExtra:SetFrameLevel(SuperDockWindowRight:GetFrameLevel() + 50)
  local size = SuperDockToolBarRight.currentSize;
  ToggleButton:SetParent(SuperDockToolBarRight)
  ToggleButton:Size(size,size)
  ToggleButton:SetFramedButtonTemplate()
  ToggleButton.icon=ToggleButton:CreateTexture(nil,"OVERLAY")
  ToggleButton.icon:FillInner()
  ToggleButton.icon:SetTexture([[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]])
  ToggleButton.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
  ToggleButton.TText="";
  ToggleButton.IsOpen=false;
  ToggleButton.IsRegistered=false;
  ToggleButton:SetScript("OnEnter",Addon_OnEnter)
  ToggleButton:SetScript("OnLeave",Addon_OnLeave)
  ToggleButton:SetScript("OnClick",Addon_OnClick)
  ToggleButton:Hide()
end;

function MOD:DockletInit()
  MOD:CreateDockletButton()
  MOD:ReloadDocklets(true)
  SuperDockletMain:SetScript('OnShow', DockletFrame_OnShow)
  SuperDockletExtra:SetScript('OnShow', DockletFrame_OnShow)
  hooksecurefunc(MOD,'DockWindowResize', resizeHook)
end;