--[[

    @computerintrusion  03-26-2026

    TODO: compiling or merging files

    currently, instead of creating one big file, we 'import' our dependencies via github link. 
    this is slow and far from optimal, i want to implement a way to compile the files into
    one large file, so we can locally use it instead

]]

--[[micro optimization]]
local getgenv = getgenv;
local pcall, warn = pcall, warn;

--[[check if executor supports required functions]]
--[[TODO: either make this a table with a loop,
    or make your own 'check' function to verify these]]
if (type(getgenv) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'getgenv' - unsupported executor`);
end

local request = request or http_request;
local loadstring = loadstring;
if (type(request) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'request' - unsupported executor`);
elseif (type(loadstring) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'loadstring' - unsupported executor`);
end

local executor = (type(identifyexecutor) == 'function' and identifyexecutor) or 'unknown executor'; 

--[[create the import function]]
getgenv().frameworkImport = function(file, ...)
	local gitPath = `https://github.com/computerintrusion/MercenaryKit/raw/main/MercenaryKit/{file}`;
    local success, response = pcall(request, { Url = gitPath, Method = 'GET' });
    if (not success) then
		return warn(`frameworkImport failed (1) - request error\nurl: {gitPath}`);
	elseif (type(response.Body) ~= 'string' or response.StatusCode ~= 200) then
        return warn(`frameworkImport failed (2) - bad response\nurl: {gitPath}`);
    end

    local loader = loadstring(response.Body);
    if (not loader) then
        return warn(`frameworkImport failed (3) - syntax error\n\nurl: {gitPath}`);
    end

    return loader(...);
end

--[[setup foundation class]]
local foundation = {};

foundation.serviceManager   = frameworkImport('Foundation/ServiceManager.lua');
foundation.hookManager      = frameworkImport('Foundation/HookManager.lua');
foundation.kickManager      = frameworkImport('Foundation/KickManager.lua');

--[[setup simple foundation helper functions]]
--[[no reason to have a separate file for this]]
function foundation:protectedMessagebox(body, title, id)
    local success, output = pcall(messagebox, body, title, id);

    if (success) then
        return output;
    end

    return self.kickManager:kick(`messagebox failed - {tostring(body)} | err: {tostring(output)}`);
end

function foundation:protectedLoad(url, ...)
    if (type(url) ~= 'string') then
        return self:protectedMessagebox(`protectedLoad syntax error (1) - expected string type for url, got {type(url)}`, `[{executor}]`, 48);
    end

    local success, response = pcall(request, { Url = url, Method = 'GET' });
    if (not success) then
        return self:protectedMessagebox(`protectedLoad failed (1) - request error\n\nurl: {url}`, `[{executor}]`, 48);
    elseif (type(response.Body) ~= 'string' or response.StatusCode ~= 200) then
        return self:protectedMessagebox(`protectedLoad failed (2) - bad response\n\nurl: {url}`, `[{executor}]`, 48);
    end

    local loader = loadstring(response.Body);
    if (not loader) then
        return self:protectedMessagebox(`protectedLoad failed (3) - syntax error\n\nurl: {url}`, `[{executor}]`, 48);
    end

    return loader(...);
end

return foundation;
