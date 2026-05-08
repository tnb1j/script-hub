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
        game = Window:AddTab({ Title = "Game List", Icon = "usb" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }
else
    Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "info" }),
        Gameworks = Window:AddTab({ Title = "Unknown Game", Icon = "gamepad-2" }),
        Script = Window:AddTab({ Title = "Script", Icon = "scroll" }),
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
    
    Tabs.Script:AddSection("Integrated Administration Frameworks")

    Tabs.Script:AddButton({
        Title = "Execute Infinite Yield",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
        end
    })

    Tabs.Script:AddButton({
        Title = "Execute Fates Admin",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/fatesc/fates-admin/main/main.lua"))()
        end
    })

    Tabs.Script:AddButton({
        Title = "Execute Hydroxide",
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

    Tabs.Script:AddButton({
        Title = "Execute SimpleSpy Engine",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
        end
    })

    Tabs.Script:AddButton({
        Title = "Execute Dark Dex V4",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
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
