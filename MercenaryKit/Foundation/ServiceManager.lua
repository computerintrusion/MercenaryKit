--[[
    @computerintrusion  03-26-2026
]]

--[[micro optimization]]
local cloneref, clonefunction = cloneref, clonefunction;

local game, getService = game, (type(clonefunction) == 'function' and clonefunction(game.GetService));

--[[check if executor supports required functions]]
if (type(cloneref) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'cloneref' - unsupported executor`);
elseif (type(clonefunction) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'clonefunction' - unsupported executor`);
end

-- [[setup serviceManager class]]
local serviceManager = {};

serviceManager.__index = serviceManager;
serviceManager.cachedServices = {};

--[[manual service loading]]
function serviceManager:getService(name)
    local cached = self.cachedServices[name];
    if (cached) ~= nil then
        return cached;
    end

    local service = cloneref(getService(game, name));
    self.cachedServices[name] = service;

    return service;
end

--[[lazy service loading]]
setmetatable(serviceManager, {
	__index = function(self, key)
		return self:getService(key);
	end
})

return serviceManager;
