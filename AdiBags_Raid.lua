--[[
AdiBags_Hearths - Adds various hearthing items to AdiBags virtual groups
© 2016 - 2017 Paul "Myrroddin" Vandersypen, All Rights Reserved
]]--

local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = addon.L
local MatchIDs
local Tooltip
local Result = {}

local function AddToSet(Set, List)
	for _, v in ipairs(List) do
		Set[v] = true
	end
end

-- the list of items, toys, cloaks, etc
local food = {
	133566,
	133576,
	133570,
	133565,
	133557,
	133574,
	133567,
	133571,
	133569,
	133568,
}

local potions = {
	142117,
	116268,
	127843,
	127844,
	127846,
	127834
	
}

local flasks = {
	127847, -- Intellect
	127849, -- Strength
	127848, -- Agility
	127850, -- Stamina
}

local misc = {
	146406, -- Vanuts Rune
	141446, -- Tome of the Tranquil MInd
	140587, -- Augment Rune
	144341, -- Reaves
	49040,  -- Jeeves
    127770, -- Brazier
	132515, -- Failure Detection Pylon
	132514, -- Auto-hammer
	
}


local function MatchIDs_Init(self)
	wipe(Result)
	AddToSet(Result, food)
	
	if self.db.profile.movePotions then
		AddToSet(Result, potions)
	end
	
	if self.db.profile.moveFlasks then
		AddToSet(Result, flasks)
	end
	
	if self.db.profile.moveMisc then
		AddToSet(Result, misc)
	end
	
	return Result
 end
 
local function Tooltip_Init()
	local tip, leftside = CreateFrame("GameTooltip"), {}
	for i = 1, 3 do
		local Left, Right = tip:CreateFontString(), tip:CreateFontString()
		Left:SetFontObject(GameFontNormal)
		Right:SetFontObject(GameFontNormal)
		tip:AddFontStrings(Left, Right)
		leftside[i] = Left
	end
	tip.leftside = leftside
	return tip
end
 
local setFilter = AdiBags:RegisterFilter("Raid Items", 92, "ABEvent-1.0")
setFilter.uiName = "Raid"
setFilter.uiDesc = L["Items useful in raids."]

function setFilter:OnInitialize()
	self.db = AdiBags.db:RegisterNamespace("Raid Items", {
		profile = {
			moveFood = true, 
			movePotions = true,
			moveFlasks = true,
			moveMisc = true
		}
	})
end

function setFilter:Update()
	MatchIDs = nil
	self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
	AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
	AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
	MatchIDs = MatchIDs or MatchIDs_Init(self)
	if MatchIDs[slotData.itemId] then
		return "Raid"
	end
	
	Tooltip = Tooltip or Tooltip_Init()
	Tooltip:SetOwner(UIParent,"ANCHOR_NONE")
	Tooltip:ClearLines()
	
	if slotData.bag == BANK_CONTAINER then
		Tooltip:SetInventoryItem("player", BankButtonIDToInvSlotID(slotData.slot, nil))
	else
		Tooltip:SetBagItem(slotData.bag, slotData.slot)
	end
	
	Tooltip:Hide()
end

function setFilter:GetOptions()
	return {
		moveFood = {
			name  = L["Food"],
			desc  = L["Show food items in this group."],
			type  = "toggle",
			order = 10
		},
		movePotions = {
			name  = L["Potions"],
			desc  = L["Show potions in this group."],
			type  = "toggle",
			order = 20
		},
		moveFlasks = {
			name = L["Flasks"],
			desc = L["Show flasks in this group."],
			type = "toggle",
			order = 30
		},
		moveMisc = {
			name  = L["Misc"],
			desc = L["Show misc raid related items in this group."],
			type  = "toggle",
			order = 40
		},
	},
	AdiBags:GetOptionHandler(self, false, function()
		return self:Update()
	end)
end
