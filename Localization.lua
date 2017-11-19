--[[
AdiBags_Hearths - Adds various hearthing items to AdiBags virtual groups
© 2016 - 2017 Paul "Myrroddin" Vandersypen, All Rights Reserved
]]--

local addonName, addon = ...

local L = setmetatable({}, {
	__index = function(self, key)
		if key then
			rawset(self, key, tostring(key))
		end
		return tostring(key)
	end,
})
addon.L = L

local locale = GetLocale()

-- enUS default
L["Food"] = true
L["Flasks"] = true
L["Potions"] = true
L["Misc"] = true


L["Show food items in this group."] = true
L["Show potions in this group."] = true
L["Show flasks in this group."] = true
L["Show misc raid related items in this group."] = true

-- Replace remaining true values by their key
for k,v in pairs(L) do
	if v == true then
		L[k] = k
	end
end
