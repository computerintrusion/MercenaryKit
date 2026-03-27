# MercenaryKit

the never complete framework for Mercenary X
it includes my custom implementations and helpers of many features that can assist you to create an entire script hub
designed to be used in an executor environment, not a game, however feel free to take specific modules if you see a use in your game

the idea is that eventually, you will never need any of your own implementations, and can rely on this for everything.
i will update this as frequently as i can, and will focus on creating a fast framework which relies on speed and easy usability

## simple usage example:
  - if this framework gets big or people end up using it or care much about it, i eventually will create a docs for it. until then, i know how to use my own framework so what is the point of creating documentation
```lua
-- init our framework
local mercenaryFramework = loadstring(request({Url = 'https://github.com/computerintrusion/MercenaryKit/releases/download/v1.1.1_RELEASE/MercenaryKit.lua', Method = 'GET'}).Body)();

-- we do this for easier readability
local services = mercenaryFramework.serviceManager;

-- you can also use services:getService('Players');
local localPlayer = services.Players.LocalPlayer;
print(localPlayer.Name);

-- usage for utilities
local hash = mercenaryFramework.utilities.hash;
print(hash.sha3_256(localPlayer.Name));
```

## notes (information for skids or contributers):
  - everything was created and tested on a mac, which means that it MAY not support Windows. if you have any issues while attempting to execute on Windows, please create an issue report regarding the issue (screenshot of issue, etc).
  - i don't really care if you use this in your project, but i do want some credibility 
  - at least don't claim you created the idea, or if you modify the source but use this as a base, at least credit me for originality.
  - fork this if you use it. no promises that i won't private or delete the repository

## building your own version
  - step one: `lua BuildMercenaryKit.lua`, a compiled file gets generated in your directly
  - step two: use the file that was generated as required!
  
