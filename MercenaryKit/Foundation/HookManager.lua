--[[
    @computerintrusion  03-26-2026
]]

--[[micro optimization]]
local hookfunction, isfunctionhooked, restorefunction = hookfunction, isfunctionhooked, restorefunction;
local iscclosure, islclosure, newcclosure = iscclosure, islclosure, newcclosure;

--[[check if executor supports required functions]]
--[[this one requires more functions, so we have a better 
	method of checking instead of if else]]
if (type(getgenv) ~= 'function') then
	return warn(`[Mercenary X] missing api function: getgenv - unsupported executor`);
end

local aliases = {
	'hookfunction', 'isfunctionhooked', 'restorefunction', 
	'iscclosure', 'islclosure', 'newcclosure'
};

for index, key in pairs(aliases) do
	local value = rawget(getgenv(), key);
	if (type(value) ~= 'function' or value == nil) then
		return warn(`[Mercenary X] missing executor api function: {key} - unsupported executor`);
	end
end

--[[setup hookManager class]]
local hookManager = {};

hookManager.hookCache = {};

function hookManager:registerHook(hookName, hookData)
	local cache = self.hookCache;
	local hookInfo = cache[hookName];
	if (hookInfo) then
		return hookInfo.originalFunction;
	end

	local originalFunction = nil;

	local function wrappedReplacement(...)
		if (not islclosure(originalFunction) or iscclosure(originalFunction)) then
			return originalFunction(...);
		end

		return hookData.replacement(originalFunction, ...);
	end

	originalFunction = hookfunction(hookData.target, wrappedReplacement);

	cache[hookName] = {
		originalFunction = originalFunction,
		targetFunction = hookData.target,
		replacementFunction = hookData.replacement
	};

	return originalFunction;
end

function hookManager:restoreHook(hookName)
	local hookInfo = self.hookCache[hookName];
	if (not hookInfo or not isfunctionhooked(hookName)) then
		return false;
	end

	restorefunction(hookInfo.targetFunction);
	self.hookCache[hookName] = nil;
	return true;
end

return hookManager;
