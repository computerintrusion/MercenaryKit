--[[
    @computerintrusion  03-26-2026
]]

--[[micro optimization]]
local cloneref, gethui = cloneref, gethui;
local taskspawn, taskwait = task.spawn, task.wait;
local warn = warn;

--[[check if executor supports required functions]]
if (type(cloneref) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'cloneref' - unsupported executor`);
elseif (type(gethui) ~= 'function') then
    return warn(`[MercenaryKit] missing critical alias 'gethui' - unsupported executor`);
end

--[[setup local player]]
local players = cloneref(game:GetService("Players"))
local localPlayer = players.LocalPlayer;
if (not localPlayer) then
	players:GetPropertyChangedSignal('LocalPlayer'):Wait();
	localPlayer = players.LocalPlayer;
end

--[[setup class kickManager]]
local kickManager = {};

kickManager.__index = kickManager;

kickManager.isKicked = false;
kickManager.baseTitle = "MercenaryKit::KickManager";
kickManager.baseMessage = "You have been disconnected by MercenaryKit::KickManager";

--[[
    ErrorPrompt [Frame] | Visible: true | Size: {0, 400}, {0, 250} | Position: {0.5, 0}, {0.5, 0}
    PromptLayout [UIListLayout]
    PromptScale [UIScale]
    TitleFrame [Frame] | Visible: true | Size: {1, 0}, {0, 50} | Position: {0, 0}, {0, 0}
        TitleFramePadding [UIPadding]
        ErrorTitle [TextLabel] | Text: Disconnected | Visible: true | Size: {1, 0}, {0, 28} | Position: {0, 0}, {0, 0}
    SplitLine [Frame] | Visible: true | Size: {1, -40}, {0, 1} | Position: {0, 0}, {0, 0}
    MessageArea [Frame] | Visible: true | Size: {1, 0}, {1, -51} | Position: {0, 0}, {0, 0}
        MessageAreaPadding [UIPadding]
        ErrorFrame [Frame] | Visible: true | Size: {1, 0}, {1, 0} | Position: {0, 0}, {0, 0}
        ErrorFrameLayout [UIListLayout]
        ErrorMessage [TextLabel] | Text: You have been kicked by this experience or its moderators. (Error Code: 267) | Visible: true | Size: {1, 0}, {1, -56} | Position: {0, 0}, {0, 0}
        ButtonArea [Frame] | Visible: true | Size: {1, 0}, {0, 36} | Position: {0, 0}, {0, 0}
            ButtonLayout [UIGridLayout]
            LeaveButton [ImageButton] | Visible: true | Size: {1, 0}, {1, 0} | Position: {0, 0}, {0, 0}
            ButtonText [TextLabel] | Text: Leave | Visible: true | Size: {1, 0}, {1, 0} | Position: {0, 0}, {0, 0}
            ShimmerFrame [ImageLabel] | Visible: false | Size: {1, 0}, {1, 0} | Position: {0, 0}, {0, 0}
                Shimmer [ImageLabel] | Visible: true | Size: {1, 0}, {2, 0} | Position: {-1, 0}, {0, 0}
                ShimmerOverlay [ImageLabel] | Visible: true | Size: {1, 0}, {1, 0} | Position: {0, 0}, {0, 0}
]]

function kickManager:overridePrompt()
    local coreGui = (type(gethui) == 'function' and gethui());
    if (not coreGui) then 
        return;
    end

    local robloxPromptGui = coreGui:FindFirstChild("RobloxPromptGui");
    if (not robloxPromptGui) then 
        return;
    end

    local promptOverlay = robloxPromptGui:FindFirstChild("promptOverlay");
    if (not promptOverlay) then 
        return;
    end

    local errorPrompt = promptOverlay:FindFirstChild("ErrorPrompt");
    if (not errorPrompt) then 
        return;
    end

    local titleFrame = errorPrompt:FindFirstChild("TitleFrame");
    local errorTitle = titleFrame and titleFrame:FindFirstChild("ErrorTitle");
    if (errorTitle) then
        errorTitle.Text = self.baseTitle
    end

    local messageArea = errorPrompt:FindFirstChild("MessageArea");
    local errorFrame = messageArea and messageArea:FindFirstChild("ErrorFrame");
    local errorMessage = errorFrame and errorFrame:FindFirstChild("ErrorMessage");

    if (errorMessage) then
        errorMessage.Text = self.baseMessage;
    end
end

function kickManager:kick(message)
    if (self.isKicked) then
        return warn("[MercenaryKit::KickManager] already kicked");
    end

    self.isKicked = true;

    if (message) then
        self.baseMessage = message;
    end

    taskspawn(function()
        pcall(localPlayer:Kick());

        while self.isKicked do
            self:overridePrompt();
            taskwait(0.5);
        end
    end)
end

return kickManager;
