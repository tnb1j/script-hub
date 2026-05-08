local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local GamePlaceId = game.PlaceId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(GamePlaceId).Name
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerName = player.Name
local GameJobId = game.JobId
local AccountAge = player.AccountAge
local hasPremium = player.MembershipType == Enum.MembershipType.Premium
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Request = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)

local REPO_OWNER = "tnb1j"
local REPO_NAME = "script-hub"
local REPO_BRANCH = "main"
local SCRIPT_DIRECTORY_URL = ("https://api.github.com/repos/%s/%s/contents/main/script?ref=%s"):format(REPO_OWNER, REPO_NAME, REPO_BRANCH)

local function httpGet(url)
    if Request then
        local ok, response = pcall(function()
            return Request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Roblox"
                }
            })
        end)

        if ok and type(response) == "table" then
            local statusCode = response.StatusCode or response.Status
            local body = response.Body or response.body or response.ResponseBody

            if (statusCode == 200 or response.Success == true) and type(body) == "string" and body ~= "" then
                return true, body
            end

            return false, tostring(statusCode or response.StatusMessage or "request failed")
        end
    end

    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(body) == "string" and body ~= "" then
        return true, body
    end

    return false, tostring(body)
end

local function parseScriptFileName(fullName)
    local mapName, mapIdStr, status, extension = fullName:match("^(.-)%-(%d+)%-(.+)%.([^.]+)$")
    if not mapName or not mapIdStr or not status or not extension then
        return nil
    end

    extension = extension:lower()
    if extension ~= "lua" and extension ~= "txt" then
        return nil
    end

    return mapName, tonumber(mapIdStr), status
end

local Window = Fluent:CreateWindow({
    Title = "gokuthug1's Script Hub | " .. GameName .. " | " .. playerName,
    SubTitle = "v1.0.0 Execution",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

local Tabs
if getgenv().GameName then
    Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "info" }),
        Update = Window:AddTab({ Title = "Update", Icon = "upload" }),
        Gameworks = Window:AddTab({ Title = getgenv().GameName, Icon = "gamepad-2" }),
        Script = Window:AddTab({ Title = "Script", Icon = "scroll" }),
        Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
        Debugger = Window:AddTab({ Title = "Debugger", Icon = "bug" }),
        game = Window:AddTab({ Title = "Game List", Icon = "usb" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }
else
    Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "info" }),
        Gameworks = Window:AddTab({ Title = "Unknown Game", Icon = "gamepad-2" }),
        Script = Window:AddTab({ Title = "Script", Icon = "scroll" }),
        Universal = Window:AddTab({ Title = "Universal", Icon = "globe" }),
        Debugger = Window:AddTab({ Title = "Debugger", Icon = "bug" }),
        game = Window:AddTab({ Title = "Game List", Icon = "usb" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }
end

local Options = Fluent.Options
getgenv().Tabs = Tabs
getgenv().Options = Options
getgenv().Window = Window

do
    local time = os.time()
    local date = os.date("*t", time)
    local hour = date.hour % 12
    if hour == 0 then hour = 12 end
    local min = string.format("%02d", date.min)
    local sec = string.format("%02d", date.sec)
    local ampm = date.hour >= 12 and "PM" or "AM"

    -- =====================================
    -- UI: MAIN TAB INFORMATION
    -- =====================================
    Tabs.Main:AddSection("Session Diagnostics")
    Tabs.Main:AddParagraph({ Title = "Welcome, " .. playerName .. "!" })
    Tabs.Main:AddParagraph({ Title = "Active Instance Name: " .. GameName })
    Tabs.Main:AddParagraph({ Title = "Universe Place ID: " .. GamePlaceId })
    Tabs.Main:AddParagraph({ Title = "Active Server JobID: " .. GameJobId })
    Tabs.Main:AddParagraph({ Title = "Account Maturity (Days): " .. AccountAge })
    Tabs.Main:AddParagraph({ Title = "Premium Membership Status: " .. (hasPremium and "Active Status" or "Inactive") })
    Tabs.Main:AddParagraph({ Title = "System Initialization Clock: " .. date.day .. "/" .. date.month .. "/" .. date.year .. " " .. hour .. ":" .. min .. ":" .. sec .. " " .. ampm })
    Tabs.Main:AddParagraph({ Title = "Source Provider: https://github.com/tnb1j/script-hub" })

    -- =====================================
    -- UI: UPDATE BANNER MANAGEMENT
    -- =====================================
    if getgenv().update then
        local isLoaded1 = false
        pcall(function()
            Tabs.Update:AddParagraph({
                Title = "Target Profile Changelog: " .. tostring(getgenv().GameName),
                Content = getgenv().update()
            })
            isLoaded1 = true 
        end)
    else
        if Tabs and Tabs.Update then
            Tabs.Update:AddParagraph({
                Title = "Dynamic Interface Warning",
                Content = "No specialized patchnotes submitted for this environment package profile yet."
            })
        end
    end

    -- =====================================
    -- UI: ENVIRONMENT CONTEXT DEPLOYER
    -- =====================================
    if getgenv().ScriptGe then
        local isLoaded = false
        pcall(function()
            getgenv().ScriptGe()
            isLoaded = true 
        end)
    else
        if Tabs and Tabs.Gameworks then
            Tabs.Gameworks:AddParagraph({
                Title = "Universal Mode Deployed",
                Content = "Notice: This instance configuration profile hasn't been compiled into our custom repository definitions database yet. Default toolsets are available via the generic Script tools interface."
            })
        end
    end

    -- =====================================
    -- UI: GLOBAL UTILITIES TAB
    -- =====================================
    Tabs.Script:AddSection("Local Environment Exploits")

    Tabs.Script:AddSlider("WalkSpeedSlider", {
        Title = "Speed Adjustment (WalkSpeed)",
        Description = "Modifies physical internal workspace speed values.",
        Default = 16, Min = 0, Max = 500, Rounding = 1,
        Callback = function(Value)
            pcall(function() player.Character.Humanoid.WalkSpeed = Value end)
        end
    })

    Tabs.Script:AddButton({
        Title = "Reset Character WalkSpeed",
        Description = "Restores standard engine speed boundaries (16).",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Reversion",
                Content = "Are you sure you want to revert modifications back to structural baseline properties?",
                Buttons = {
                    { Title = "Confirm", Callback = function() pcall(function() player.Character.Humanoid.WalkSpeed = 16 end) end },
                    { Title = "Cancel" }
                }
            })
        end
    })

    Tabs.Script:AddSlider("JumpPowerSlider", {
        Title = "Velocity Alteration (JumpPower)",
        Description = "Modifies jump engine workspace upward force values.",
        Default = 50, Min = 0, Max = 500, Rounding = 1,
        Callback = function(Value)
            pcall(function() player.Character.Humanoid.JumpPower = Value end)
        end
    })

    Tabs.Script:AddButton({
        Title = "Reset Character JumpPower",
        Description = "Restores standard engine jump boundaries (50).",
        Callback = function()
            Window:Dialog({
                Title = "Confirm Reversion",
                Content = "Are you sure you want to revert physics modifications back to standard engine metrics?",
                Buttons = {
                    { Title = "Confirm", Callback = function() pcall(function() player.Character.Humanoid.JumpPower = 50 end) end },
                    { Title = "Cancel" }
                }
            })
        end
    })
    
    local Toggle = Tabs.Script:AddToggle("AntiAFK_Hook", {Title = "State Lock (Anti-AFK)", Default = false})
    Toggle:OnChanged(function()
        getgenv().AntiAFKEnabled = Options.AntiAFK_Hook.Value
        if getgenv().AntiAFKEnabled then
            local VirtualUser = game:GetService("VirtualUser")
            if getgenv().AFKConnection then getgenv().AFKConnection:Disconnect() end
            getgenv().AFKConnection = player.Idled:Connect(function()
                if getgenv().AntiAFKEnabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        else
            if getgenv().AFKConnection then getgenv().AFKConnection:Disconnect() end
        end
    end)

    Tabs.Script:AddSection("Universal Hitbox Expander")
    Tabs.Script:AddParagraph({
        Title = "Hitbox Configuration",
        Content = "Modify enemy and local hitboxes seamlessly.\nSizes are capped only by the engine-safe range up to 2048."
    })

    getgenv().HitboxSettings = getgenv().HitboxSettings or {
        EnemyExpander = false,
        TeamCheck = true,
        EnemySize = 15,
        EnemyTransparency = 0.5,
        SelfExpander = false,
        SelfSize = 2,
        SelfTransparency = 1
    }

    local function getRootPart(character)
        if not character then
            return nil
        end

        return character:FindFirstChild("HumanoidRootPart")
    end

    local function safeHitboxSize(value)
        return math.clamp(tonumber(value) or 2, 0.05, 2048)
    end

    local function resetCharacterHitbox(character)
        local rootPart = getRootPart(character)
        if not rootPart then
            return
        end

        pcall(function()
            rootPart.Size = Vector3.new(2, 2, 1)
            rootPart.Transparency = 1
            rootPart.CanCollide = false
        end)
    end

    local function resetEnemyHitboxes()
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                resetCharacterHitbox(otherPlayer.Character)
            end
        end
    end

    local function resetAllHitboxes()
        resetEnemyHitboxes()
        resetCharacterHitbox(player.Character)
    end

    if getgenv().HitboxConnection then
        getgenv().HitboxConnection:Disconnect()
        getgenv().HitboxConnection = nil
    end
    resetAllHitboxes()

    local EnemyToggle = Tabs.Script:AddToggle("EnemyExpander_Toggle", {
        Title = "Expand Enemy Hitboxes",
        Default = getgenv().HitboxSettings.EnemyExpander
    })

    EnemyToggle:OnChanged(function()
        getgenv().HitboxSettings.EnemyExpander = Options.EnemyExpander_Toggle.Value

        if not getgenv().HitboxSettings.EnemyExpander then
            resetEnemyHitboxes()
        end
    end)

    local TeamCheckToggle = Tabs.Script:AddToggle("TeamCheck_Toggle", {
        Title = "Team Check",
        Default = getgenv().HitboxSettings.TeamCheck
    })

    TeamCheckToggle:OnChanged(function()
        getgenv().HitboxSettings.TeamCheck = Options.TeamCheck_Toggle.Value

        if getgenv().HitboxSettings.TeamCheck then
            resetEnemyHitboxes()
        end
    end)

    Tabs.Script:AddSlider("EnemySize_Slider", {
        Title = "Enemy Hitbox Size",
        Description = "Sets how large enemy hitboxes become. 0 uses the minimum safe size; 2048 is the maximum.",
        Default = getgenv().HitboxSettings.EnemySize,
        Min = 0,
        Max = 2048,
        Rounding = 1,
        Callback = function(Value)
            getgenv().HitboxSettings.EnemySize = safeHitboxSize(Value)
        end
    })

    Tabs.Script:AddSlider("EnemyTrans_Slider", {
        Title = "Enemy Transparency (%)",
        Description = "0% is fully visible, 100% is invisible.",
        Default = math.round((getgenv().HitboxSettings.EnemyTransparency or 0.5) * 100),
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().HitboxSettings.EnemyTransparency = math.clamp(Value / 100, 0, 1)
        end
    })

    Tabs.Script:AddSection("Your Hitbox (Self)")

    local SelfToggle = Tabs.Script:AddToggle("SelfExpander_Toggle", {
        Title = "Modify Own Hitbox",
        Default = getgenv().HitboxSettings.SelfExpander
    })

    SelfToggle:OnChanged(function()
        getgenv().HitboxSettings.SelfExpander = Options.SelfExpander_Toggle.Value

        if not getgenv().HitboxSettings.SelfExpander then
            resetCharacterHitbox(player.Character)
        end
    end)

    Tabs.Script:AddSlider("SelfSize_Slider", {
        Title = "Own Hitbox Size",
        Description = "Shrink yourself close to zero or expand up to the maximum safe size.",
        Default = getgenv().HitboxSettings.SelfSize,
        Min = 0,
        Max = 2048,
        Rounding = 1,
        Callback = function(Value)
            getgenv().HitboxSettings.SelfSize = safeHitboxSize(Value)
        end
    })

    Tabs.Script:AddSlider("SelfTrans_Slider", {
        Title = "Own Transparency (%)",
        Description = "0% is fully visible, 100% is invisible.",
        Default = math.round((getgenv().HitboxSettings.SelfTransparency or 1) * 100),
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(Value)
            getgenv().HitboxSettings.SelfTransparency = math.clamp(Value / 100, 0, 1)
        end
    })

    Tabs.Script:AddButton({
        Title = "Reset All Hitboxes",
        Description = "Restore local and enemy root parts to their default values.",
        Callback = function()
            resetAllHitboxes()
        end
    })

    getgenv().HitboxConnection = RunService.Stepped:Connect(function()
        local settings = getgenv().HitboxSettings

        if settings.EnemyExpander then
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local rootPart = getRootPart(otherPlayer.Character)
                    if rootPart then
                        local isTeammate = settings.TeamCheck
                            and player.Team ~= nil
                            and otherPlayer.Team ~= nil
                            and otherPlayer.Team == player.Team

                        if isTeammate then
                            resetCharacterHitbox(otherPlayer.Character)
                        else
                            pcall(function()
                                local size = safeHitboxSize(settings.EnemySize)
                                rootPart.Size = Vector3.new(size, size, size)
                                rootPart.Transparency = math.clamp(settings.EnemyTransparency or 0.5, 0, 1)
                                rootPart.CanCollide = false
                            end)
                        end
                    end
                end
            end
        end

        if settings.SelfExpander and player.Character then
            local rootPart = getRootPart(player.Character)
            if rootPart then
                pcall(function()
                    local size = safeHitboxSize(settings.SelfSize)
                    rootPart.Size = Vector3.new(size, size, size)
                    rootPart.Transparency = math.clamp(settings.SelfTransparency or 1, 0, 1)
                    rootPart.CanCollide = false
                end)
            end
        end
    end)
    
    -- =====================================
    -- UI: UNIVERSAL TAB
    -- =====================================
    Tabs.Universal:AddSection("Integrated Administration Frameworks")

    Tabs.Universal:AddButton({
        Title = "Execute Infinite Yield",
        Description = "Full-featured admin command framework.",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute Fates Admin",
        Description = "Lightweight admin command script.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))()
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute Hydroxide",
        Description = "Roblox remote spy and debugger.",
        Callback = function()
            local owner = "Upbolt"
            local branch = "revision"
            local function webImport(file)
                return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
            end
            webImport("init")
            webImport("ui/main")
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute SimpleSpy Engine",
        Description = "Remote event spy tool.",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute Dark Dex V4",
        Description = "Roblox explorer and debugger.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
        end
    })
    Tabs.Universal:AddSection("Client Utilities")

    Tabs.Universal:AddButton({
        Title = "Execute Hide Identity",
        Description = "Masks your name, UserID, HWID, JobID and PlaceID client-side.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tnb1j/script-hub/refs/heads/main/other/Hide-identity.lua"))()
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute Private Server",
        Description = "Generates and teleports you to a private server in the current game.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tnb1j/script-hub/refs/heads/main/other/Privateserver.lua"))()
        end
    })

    Tabs.Universal:AddSection("Combat Utilities")

    Tabs.Universal:AddButton({
        Title = "Execute AimBot + ESP (Latest)",
        Description = "Universal aimbot and ESP with FOV, silent aim, hitbox expander, and triggerbot.",
        Callback = function()
            loadstring(game:HttpGet("https://pastebin.com/raw/bJ5AuiX5"))()
        end
    })

    Tabs.Universal:AddButton({
        Title = "Execute GokuDex",
        Description = "Custom Roblox explorer and instance viewer.",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/gokuthug1/GokuDex/raw/refs/heads/main/GokuDex.lua"))()
        end
    })

    -- =====================================
    -- UI: DEBUGGER TAB
    -- =====================================
    Tabs.Debugger:AddSection("Environment Info")

    Tabs.Debugger:AddButton({
        Title = "Dump Player Info",
        Description = "Prints full local player data to the developer console.",
        Callback = function()
            local lp = Players.LocalPlayer
            print("===== PLAYER DUMP =====")
            print("Name:        " .. tostring(lp.Name))
            print("DisplayName: " .. tostring(lp.DisplayName))
            print("UserId:      " .. tostring(lp.UserId))
            print("AccountAge:  " .. tostring(lp.AccountAge) .. " days")
            print("Premium:     " .. tostring(lp.MembershipType == Enum.MembershipType.Premium))
            print("Team:        " .. tostring(lp.Team))
            print("Character:   " .. tostring(lp.Character))
            if lp.Character then
                local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    print("Health:      " .. tostring(hum.Health) .. " / " .. tostring(hum.MaxHealth))
                    print("WalkSpeed:   " .. tostring(hum.WalkSpeed))
                    print("JumpPower:   " .. tostring(hum.JumpPower))
                end
                local root = lp.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    print("Position:    " .. tostring(root.Position))
                end
            end
            print("=======================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "Dump Game Info",
        Description = "Prints place ID, job ID, server info, and loaded services.",
        Callback = function()
            print("===== GAME DUMP =====")
            print("PlaceId:     " .. tostring(game.PlaceId))
            print("JobId:       " .. tostring(game.JobId))
            print("PlaceVersion:" .. tostring(game.PlaceVersion))
            pcall(function()
                local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
                print("Game Name:   " .. tostring(info.Name))
                print("Creator:     " .. tostring(info.Creator and info.Creator.Name))
            end)
            print("Players:     " .. tostring(#Players:GetPlayers()))
            print("Server Time: " .. tostring(workspace.DistributedGameTime) .. "s")
            print("====================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "Dump Executor Info",
        Description = "Prints detected executor capabilities and environment.",
        Callback = function()
            print("===== EXECUTOR DUMP =====")
            print("request:         " .. tostring(request ~= nil))
            print("http_request:    " .. tostring(http_request ~= nil))
            print("syn.request:     " .. tostring(syn ~= nil and syn.request ~= nil))
            print("getrawmetatable: " .. tostring(getrawmetatable ~= nil))
            print("setreadonly:     " .. tostring(setreadonly ~= nil))
            print("getnamecallmethod:" .. tostring(getnamecallmethod ~= nil))
            print("hookfunction:    " .. tostring(hookfunction ~= nil))
            print("decompile:       " .. tostring(decompile ~= nil))
            print("getgc:           " .. tostring(getgc ~= nil))
            print("getscripts:      " .. tostring(getscripts ~= nil))
            print("getsenv:         " .. tostring(getsenv ~= nil))
            print("==========================")
        end
    })

    Tabs.Debugger:AddSection("Remote Inspector")

    Tabs.Debugger:AddButton({
        Title = "List All RemoteEvents",
        Description = "Scans the entire game tree and prints every RemoteEvent found.",
        Callback = function()
            print("===== REMOTE EVENTS =====")
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") then
                    count = count + 1
                    print("[" .. count .. "] " .. obj:GetFullName())
                end
            end
            print("Total: " .. count .. " RemoteEvents")
            print("=========================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "List All RemoteFunctions",
        Description = "Scans the entire game tree and prints every RemoteFunction found.",
        Callback = function()
            print("===== REMOTE FUNCTIONS =====")
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("RemoteFunction") then
                    count = count + 1
                    print("[" .. count .. "] " .. obj:GetFullName())
                end
            end
            print("Total: " .. count .. " RemoteFunctions")
            print("===========================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "List All BindableEvents",
        Description = "Scans the entire game tree and prints every BindableEvent found.",
        Callback = function()
            print("===== BINDABLE EVENTS =====")
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("BindableEvent") then
                    count = count + 1
                    print("[" .. count .. "] " .. obj:GetFullName())
                end
            end
            print("Total: " .. count .. " BindableEvents")
            print("==========================")
        end
    })

    do
        local remoteLogEnabled = false
        local remoteLogConnection = nil

        local RemoteLogToggle = Tabs.Debugger:AddToggle("RemoteLog_Toggle", {
            Title = "Toggle Remote Logger",
            Default = false
        })

        RemoteLogToggle:OnChanged(function()
            remoteLogEnabled = Options.RemoteLog_Toggle.Value
            if remoteLogEnabled then
                pcall(function()
                    local mt = getrawmetatable(game)
                    setreadonly(mt, false)
                    local oldNamecall = mt.__namecall
                    getgenv()._remoteLogOldNamecall = oldNamecall
                    mt.__namecall = function(self, ...)
                        local method = getnamecallmethod()
                        if remoteLogEnabled and (method == "FireServer" or method == "InvokeServer" or method == "FireAllClients") then
                            print("[REMOTE] " .. method .. " -> " .. tostring(self:GetFullName()))
                        end
                        return oldNamecall(self, ...)
                    end
                    setreadonly(mt, true)
                end)
                print("[Debugger] Remote Logger ON")
            else
                pcall(function()
                    local mt = getrawmetatable(game)
                    setreadonly(mt, false)
                    mt.__namecall = getgenv()._remoteLogOldNamecall
                    setreadonly(mt, true)
                end)
                print("[Debugger] Remote Logger OFF")
            end
        end)
    end

    Tabs.Debugger:AddSection("Script Inspector")

    Tabs.Debugger:AddButton({
        Title = "List All LocalScripts",
        Description = "Scans and prints every LocalScript in the game.",
        Callback = function()
            print("===== LOCAL SCRIPTS =====")
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("LocalScript") then
                    count = count + 1
                    print("[" .. count .. "] " .. obj:GetFullName() .. (obj.Disabled and " [DISABLED]" or ""))
                end
            end
            print("Total: " .. count .. " LocalScripts")
            print("=========================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "List All ModuleScripts",
        Description = "Scans and prints every ModuleScript in the game.",
        Callback = function()
            print("===== MODULE SCRIPTS =====")
            local count = 0
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ModuleScript") then
                    count = count + 1
                    print("[" .. count .. "] " .. obj:GetFullName())
                end
            end
            print("Total: " .. count .. " ModuleScripts")
            print("==========================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "Dump Running Scripts",
        Description = "Lists all scripts currently executing (requires getscripts).",
        Callback = function()
            print("===== RUNNING SCRIPTS =====")
            if getscripts then
                local scripts = getscripts()
                for i, s in ipairs(scripts) do
                    print("[" .. i .. "] " .. tostring(s.Name) .. " | " .. tostring(s:GetFullName()))
                end
                print("Total: " .. #scripts)
            else
                print("getscripts() not available in this executor.")
            end
            print("===========================")
        end
    })

    Tabs.Debugger:AddSection("Performance")

    Tabs.Debugger:AddButton({
        Title = "Print Memory Usage",
        Description = "Shows current Lua memory usage and Roblox stats.",
        Callback = function()
            print("===== MEMORY STATS =====")
            print("Lua memory:  " .. string.format("%.2f MB", collectgarbage("count") / 1024))
            pcall(function()
                local stats = game:GetService("Stats")
                print("DataReceive: " .. string.format("%.2f KB/s", stats.DataReceiveKbps))
                print("DataSend:    " .. string.format("%.2f KB/s", stats.DataSendKbps))
                print("Physics:     " .. string.format("%.2f ms", stats.PhysicsReceiveKbps))
            end)
            print("========================")
        end
    })

    Tabs.Debugger:AddButton({
        Title = "Print Current FPS",
        Description = "Samples FPS over 1 second and prints the result.",
        Callback = function()
            task.spawn(function()
                local frames = 0
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    frames = frames + 1
                end)
                task.wait(1)
                conn:Disconnect()
                print("[FPS] Measured: " .. frames .. " fps")
            end)
        end
    })

    do
        local fpsMonitorConn = nil
        local FPSToggle = Tabs.Debugger:AddToggle("FPSMonitor_Toggle", {
            Title = "Toggle FPS Monitor",
            Default = false
        })
        FPSToggle:OnChanged(function()
            if Options.FPSMonitor_Toggle.Value then
                local frameCount = 0
                local lastPrint = tick()
                fpsMonitorConn = RunService.RenderStepped:Connect(function()
                    frameCount = frameCount + 1
                    if tick() - lastPrint >= 5 then
                        print("[FPS Monitor] " .. math.floor(frameCount / (tick() - lastPrint)) .. " fps")
                        frameCount = 0
                        lastPrint = tick()
                    end
                end)
                print("[Debugger] FPS Monitor ON (prints every 5s)")
            else
                if fpsMonitorConn then
                    fpsMonitorConn:Disconnect()
                    fpsMonitorConn = nil
                end
                print("[Debugger] FPS Monitor OFF")
            end
        end)
    end

    Tabs.Debugger:AddButton({
        Title = "Dump Character Stats",
        Description = "Prints full character CFrame, velocity, and part count.",
        Callback = function()
            local char = Players.LocalPlayer.Character
            if not char then print("[Debugger] No character loaded.") return end
            print("===== CHARACTER STATS =====")
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                print("CFrame:   " .. tostring(root.CFrame))
                print("Position: " .. tostring(root.Position))
                print("Velocity: " .. tostring(root.AssemblyLinearVelocity))
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                print("Health:   " .. hum.Health .. " / " .. hum.MaxHealth)
                print("State:    " .. tostring(hum:GetState()))
                print("MoveDir:  " .. tostring(hum.MoveDirection))
            end
            print("Parts:    " .. #char:GetChildren() .. " children")
            print("===========================")
        end
    })

    -- =====================================
    -- UI: REMOTE DIRECTORY NETWORK EXPLORER
    -- =====================================
    Tabs.game:AddSection("Supported Architecture Ecosystem")
    Tabs.game:AddParagraph({
        Title = "Status Level Legend Indices",
        Content = "🟢 Fully Functional: Complete architectural profile script adaptation.\n🟠 Partially Functional: Legacy build layout; features could run inconsistently.\n🔴 Non-Functional: Patched structural security layout limits exploitation."
    })

    -- Dynamically requests content lists from your new repository
    local map_success, map_response = httpGet(SCRIPT_DIRECTORY_URL)
    
    if map_success then
        local decoded, data = pcall(function()
            return HttpService:JSONDecode(map_response)
        end)

        if decoded and type(data) == "table" then
    
            for _, file in pairs(data) do
                if type(file) == "table" and file.name then
            
            -- Reads the new hyphen structure: Timebomb-Duels-11379739543-🟢.lua
                    local mapName, mapId, status = parseScriptFileName(file.name)
            
                    if mapName and mapId and status then
                Tabs.game:AddButton({
                    Title = mapName .. " [" .. status .. "]",
                    Description = "Target Universe Routing Sequence ID: " .. tostring(mapId),
                    Callback = function()
                        Window:Dialog({
                            Title = "Initialize Crossroads Cross-Teleportation",
                            Content = "Initiating global teleport protocol query straight toward: " .. mapName,
                            Buttons = {
                                { Title = "Confirm", Callback = function() game:GetService("TeleportService"):Teleport(mapId, player) end },
                                { Title = "Cancel" }
                            }
                        })
                    end
                })
                    end
                end
            end
        else
            warn("[gokuthug1's Hub] Failed to decode game directory payload.")
        end
    else
        warn("[gokuthug1's Hub] Failed to fetch game directory payload: " .. tostring(map_response))
    end

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("gokuthug1Hub")
    SaveManager:SetFolder("gokuthug1Hub/configs")
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
    Window:SelectTab(1)
    SaveManager:LoadAutoloadConfig()
end
