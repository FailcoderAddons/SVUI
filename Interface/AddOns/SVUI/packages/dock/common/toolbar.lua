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
local MOD = SuperVillain.Registry:Expose('SVDock');
MOD.BreakingShit = false;
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local tools={};
local ICON_FILE = [[Interface\AddOns\SVUI\assets\artwork\Icons\PROFESSIONS]];
local TOOL_DATA = {
	["Alchemy"] 		= {0,0.25,0,0.25}, 					-- PRO-ALCHEMY
    ["Archaeology"] 	= {0.25,0.5,0,0.25,"Survey"}, 		-- PRO-ARCHAELOGY
    ["Blacksmithing"] 	= {0.5,0.75,0,0.25}, 				-- PRO-BLACKSMITH
    ["Cooking"] 		= {0.75,1,0,0.25,"Cooking Fire"}, 	-- PRO-COOKING
    ["Enchanting"] 		= {0,0.25,0.25,0.5,"Disenchant"}, 	-- PRO-ENCHANTING
    ["Engineering"] 	= {0.25,0.5,0.25,0.5}, 				-- PRO-ENGINEERING
    ["First Aid"] 		= {0.5,0.75,0.25,0.5}, 				-- PRO-FIRSTAID
    ["Herbalism"] 		= {0.75,1,0.25,0.5,"Lifeblood"}, 	-- PRO-HERBALISM
    ["Inscription"] 	= {0,0.25,0.5,0.75,"Milling"}, 		-- PRO-INSCRIPTION
    ["Jewelcrafting"] 	= {0.25,0.5,0.5,0.75,"Prospecting"},-- PRO-JEWELCRAFTING
    ["Leatherworking"] 	= {0.5,0.75,0.5,0.75}, 				-- PRO-LEATHERWORKING
    ["Mining"] 			= {0.75,1,0.5,0.75}, 				-- PRO-MINING
    ["Skinning"] 		= {0,0.25,0.75,1}, 					-- PRO-SKINNING
    ["Tailoring"] 		= {0.25,0.5,0.75,1}, 				-- PRO-TAILORING
    ["Default"] 		= {0.5,0.75,0,0.25}
};
--[[ 
########################################################## 
PRE VARS/FUNCTIONS
##########################################################
]]--
local button_OnEnter=function(b)
	if not b.IsOpen then
		b:SetPanelColor("highlight")
      	b.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
	end
	GameTooltip:SetOwner(b,'ANCHOR_TOPLEFT',0,4)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(b.TText,1,1,1)
	GameTooltip:Show()
end;

local button_OnLeave=function(b)
	if not b.IsOpen then
		b:SetPanelColor("special")
		b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	end
	GameTooltip:Hide()
end;

local button_OnClick=function(b)
	if InCombatLockdown()then return end;
	if b.FrameName and _G[b.FrameName] then
		SuperDockWindowRight.FrameName=b.FrameName
		if not _G[b.FrameName]:IsShown() then
			if not SuperDockWindowRight:IsShown()then
				SuperDockWindowRight:Show()
			end
			MOD:DockletHide()
			_G[b.FrameName]:Show()
			b.IsOpen=true;
			b:SetPanelColor("green")
			b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
		elseif not SuperDockWindowRight:IsShown()then
			SuperDockWindowRight:Show()
			_G[b.FrameName]:Show()
			b.IsOpen=true;
			b:SetPanelColor("green")
			b.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
		end 
	else
		if SuperDockWindowRight:IsShown()then 
			SuperDockWindowRight:Hide()
		else 
			SuperDockWindowRight:Show()
		end
		b.IsOpen=false;
		b:SetPanelColor("special")
		b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
		if MOD.DefaultWindow and _G[MOD.DefaultWindow] and not _G[MOD.DefaultWindow]:IsShown() then
			SuperDockWindowRight.FrameName = MOD.DefaultWindow
			SuperDockWindowRight:Show()
		end
	end;
end;

local macro_OnEnter = function(b)
	b:SetPanelColor("highlight")
    b.icon:SetGradient(unpack(SuperVillain.Media.gradient.bizzaro))
	GameTooltip:SetOwner(b, "ANCHOR_TOPLEFT", 2, 4)
	GameTooltip:ClearLines()
	if not b.TText2 then 
		GameTooltip:AddLine(b.TText, 1, 1, 1)
	else 
		GameTooltip:AddDoubleLine(b.TText, b.TText2, 1, 1, 1)
	end;
	GameTooltip:Show()
end;

local macro_OnLeave=function(b)
	b:SetPanelColor("special")
	b.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	GameTooltip:Hide()
end;

MOD.ToolsList = {};
MOD.ToolsSafty = {};
MOD.MacroCount = 0;
MOD.LastAddedTool = false;
MOD.LastAddedMacro = false;
--[[ 
########################################################## 
CORE FUNCTIONS
##########################################################
]]--
MOD.DefaultWindow = false;
function MOD:RemoveTool(frame)
	if not frame or not frame.listIndex then return end;
	local name = frame:GetName();
	if not MOD.ToolsSafty[name] then return end;
	MOD.ToolsSafty[name] = false;
	local i = frame.listIndex;
	tremove(MOD.ToolsList,i)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	MOD.LastAddedTool = MOD.ToolsList[#MOD.ToolsList];
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:ClearAllPoints()
	SuperDockToolBarRight:Point('RIGHT',RightSuperDockHearthButton,'LEFT',-6,0)
	SuperDockToolBarRight:Size(width,height)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:AddTool(frame)
	local name = frame:GetName();
	if MOD.ToolsSafty[name] then return end;
	MOD.ToolsSafty[name] = true;
	local width;
	local height = SuperDockToolBarRight.currentSize;
	if not MOD.LastAddedTool or MOD.LastAddedTool == frame then
		frame:Point("RIGHT",SuperDockToolBarRight,"RIGHT",-6,0);
	else
		frame:Point("RIGHT",MOD.LastAddedTool,"LEFT",-6,0);
	end
	tinsert(MOD.ToolsList,frame);
    frame.listIndex = #MOD.ToolsList;
	MOD.LastAddedTool = frame;
	width = #MOD.ToolsList * (height + 6)
	SuperDockToolBarRight:ClearAllPoints()
	SuperDockToolBarRight:Point('RIGHT',RightSuperDockHearthButton,'LEFT',-6,0)
	SuperDockToolBarRight:Size(width,height)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:AddMacroTool(frame)
	local width;
	local height = SuperDockToolBarRight.currentSize;
	if not MOD.LastAddedMacro then
		frame:Point("RIGHT",SuperDockMacroBar,"RIGHT",-6,0);
	else
		frame:Point("RIGHT",MOD.LastAddedMacro,"LEFT",-6,0);
	end
	MOD.LastAddedMacro=frame;
	MOD.MacroCount=MOD.MacroCount+1;
	width=MOD.MacroCount*(height+6)
	SuperDockMacroBar:ClearAllPoints()
	SuperDockMacroBar:Size(width,height)
	SuperDockMacroBar:Point('RIGHT',SuperDockToolBarRight,'LEFT',-6,0)
end;

function MOD:CreateBasicToolButton(name,texture,onclick,frameName,isdefault)
	local fName = frameName or name;
	local dockIcon = texture or [[Interface\AddOns\SVUI\assets\artwork\Icons\DOCK-ADDON]];
	local clickFunction = (type(onclick)=="function") and onclick or button_OnClick;
	local size = SuperDockToolBarRight.currentSize;
	local button = _G[fName .. "_ToolBarButton"] or CreateFrame("Button",("%s_ToolBarButton"):format(fName),SuperDockToolBarRight)
	MOD:AddTool(button)
	button:Size(size,size)
	button:SetFramedButtonTemplate()
	button.icon = button:CreateTexture(nil,"OVERLAY")
	button.icon:FillInner(button,2,2)
	button.icon:SetTexture(dockIcon)
	button.TText = "Open " .. name;
	button.FrameName = fName;
	if isdefault == true then
		MOD.DefaultWindow = fName;
	end;
	button.IsOpen = isdefault or false;
	button:SetScript("OnEnter",button_OnEnter)
	button:SetScript("OnLeave",button_OnLeave)
	button:SetScript("OnClick",clickFunction)
	_G[fName].ToggleName = fName.."_ToolBarButton";
	if(isdefault) then
		button:SetPanelColor("green")
		button.icon:SetGradient(unpack(SuperVillain.Media.gradient.green))
	else
		button.icon:SetGradient(unpack(SuperVillain.Media.gradient.light))
	end
end;

function MOD:CreateMacroToolButton(name,texCoords,itemID)
	if name == "Mining" then name = "Smelting" end;
	local data = TOOL_DATA[texCoords] or TOOL_DATA["Default"];
	local size = SuperDockMacroBar.currentSize;
	local button = CreateFrame("Button",("%s_MacroBarButton"):format(itemID),SuperDockMacroBar,"SecureActionButtonTemplate")
	button:Size(size,size)
	MOD:AddMacroTool(button)
	button:SetFramedButtonTemplate()
	button.icon = button:CreateTexture(nil,"OVERLAY")
	button.icon:FillInner(button,2,2)
	button.icon:SetTexture(ICON_FILE)
	button.icon:SetTexCoord(data[1],data[2],data[3],data[4])
	button.icon:SetGradient("VERTICAL", 0.5, 0.53, 0.55, 0.8, 0.8, 1)
	button.skillName = name;
	button.itemId = itemID;
	button.TText = "Open " .. name;
	button:SetAttribute("type","macro")
	if(data[5]) then
		local rightClickSpell = data[5]
		button:SetAttribute("macrotext", "/cast [mod:shift]" .. rightClickSpell .. "; " .. name)
		button.TText2 = "Shift-Click to use " .. rightClickSpell 
	else 
		button:SetAttribute("macrotext","/cast " .. name)
	end;
	button:SetScript("OnEnter",macro_OnEnter)
	button:SetScript("OnLeave",macro_OnLeave)
end;

function MOD:LoadToolBarProfessions()
	if(MOD.ToolBarLoaded) then return end
	local j,k,l,m,n,o=GetProfessions();
	if o~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(o)
		if(t ~= "Herbalism" and t ~= "Skinning") then
			MOD:CreateMacroToolButton(t,t,o)
		end
	end;
	if l~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(l)
		if(t ~= "Herbalism" and t ~= "Skinning") then
			MOD:CreateMacroToolButton(t,t,l)
		end
	end;
	if n~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(n)
		if(t ~= "Herbalism" and t ~= "Skinning") then
			MOD:CreateMacroToolButton(t,t,n)
		end
	end;
	if k~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(k)
		if(t ~= "Herbalism" and t ~= "Skinning") then
			MOD:CreateMacroToolButton(t,t,k)
		end
	end;
	if j~=nil then 
		local t,u,v,w,x,y,z,A,B,C=GetProfessionInfo(j)
		if(t ~= "Herbalism" and t ~= "Skinning") then
			MOD:CreateMacroToolButton(t,t,j)
		end
	end;
	MOD.ToolBarLoaded = true
end