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
--GLOBAL NAMESPACE
local _G = _G;
--LUA
local unpack        = _G.unpack;
local select        = _G.select;
local assert        = _G.assert;

local AddonName, AddonObject = ...

assert(_G.LibSuperVillain, AddonName .. " requires LibSuperVillain")

local PLUGIN = _G.LibSuperVillain:NewPlugin(AddonName, AddonObject)

local Schema = PLUGIN.Schema;
local SV = _G["SVUI"];
local L = SV.L
--[[ 
########################################################## 
CONFIG DATA
##########################################################
]]--
SV.configs[Schema] = {
    ["enable"] = true,
    ["size"] = 75, 
    ["fontSize"] = 12,
    ["groups"] = true,
    ["proximity"] = false, 
}
--[[ 
########################################################## 
CONFIG OPTIONS
##########################################################
]]--
SV.Options.args.plugins.args.pluginOptions.args[Schema].args["groups"] = {
    order = 3,
    name = L["GPS"],
    desc = L["Use group frame GPS elements"],
    type = "toggle",
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key]); PLUGIN:UpdateLogWindow() end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["proximity"] = {
    order = 4,
    name = L["GPS Proximity"],
    desc = L["Only point to closest low health unit"],
    type = "toggle",
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key]); PLUGIN:UpdateLogWindow() end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["fontSize"] = {
    order = 5,
    name = L["Font Size"],
    desc = L["Set the font size of the range text"],
    type = "range",
    min = 6,
    max = 22,
    step = 1,
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) PLUGIN:ChangeDBVar(value, key[#key]); PLUGIN:UpdateLogWindow() end
}