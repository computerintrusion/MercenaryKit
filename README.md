# MercenaryKit

the never complete framework for Mercenary X
it includes my custom implementations and helpers of many features that can assist you to create an entire script hub
designed to be used in an executor environment, not a game, however feel free to take specific modules if you see a use in your game

the idea is that eventually, you will never need any of your own implementations, and can rely on this for everything.
i will update this as frequently as i can, and will focus on creating a fast framework which relies on speed and easy usability


notes (information for skids or contributers):
  - i don't really care if you use this in your project, but i do want some credibility 
  - at least don't claim you created the idea, or if you modify the source but use this as a base, at least credit me for originality.
  - fork this if you use it. no promises that i won't private or delete the repository


**TODO (number one priority currently)**:
  - implement a 'compile' method, so instead of using 'Foundation/Foundation.lua', which imports files from the github itself, it compiles the entire project into one usable file which i can add to Releases.  i have found a way of doing this, just need to implement it properly, until then i won't be using it.
  - not only will this make it faster, but also more easily manageable in the end.

simple usage example:
  - if this framework gets big, i eventually will create a docs for it. for now, here is a simple example.
```lua
local mercenaryFramework = loadstring(request({Url = 'https://github.com/computerintrusion/MercenaryKit/raw/refs/heads/main/MercenaryKit/Foundation/Foundation.lua', Method = 'GET'}).Body)();

local services = mercenaryFramework.serviceManager; -- we do this for easier readability
local localPlayer = services.Players.LocalPlayer; -- you can also use services.getService("Players");
print(localPlayer.Name);
```
