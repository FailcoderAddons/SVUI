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
local AddonName, AddonObject = ...

assert(LibSuperVillain, AddonName .. " requires LibSuperVillain")

local PLUGIN = LibSuperVillain:NewPlugin(AddonName, AddonObject)

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
    ["saveChats"] = true,
    ["service"] = true,
  	["autoAnswer"] = false, 
  	["prefix"] = true
}
--[[ 
########################################################## 
CONFIG OPTIONS
##########################################################
]]--
SV.Options.args.plugins.args.pluginOptions.args[Schema].args["saveChats"] = {
    order = 2, 
    name = "Save Chat History", 
    type = "toggle", 
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) SV.db[Schema][key[#key]] = value end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["service"] = {
    order = 3, 
    name = "Answering Service", 
    type = "toggle", 
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) SV.db[Schema][key[#key]] = value end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["autoAnswer"] = {
    order = 4, 
    name = "Auto Answer", 
    type = "toggle", 
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) SV.db[Schema][key[#key]] = value end
}

SV.Options.args.plugins.args.pluginOptions.args[Schema].args["prefix"] = {
    order = 5, 
    name = "Prefix Messages", 
    type = "toggle", 
    get = function(key) return SV.db[Schema][key[#key]] end,
    set = function(key,value) SV.db[Schema][key[#key]] = value end
}