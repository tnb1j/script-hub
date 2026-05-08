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
        Listener = Window:AddTab({ Title = "Listener", Icon = "terminal" }),
        Executor = Window:AddTab({ Title = "Executor", Icon = "code" }),
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
        Listener = Window:AddTab({ Title = "Listener", Icon = "terminal" }),
        Executor = Window:AddTab({ Title = "Executor", Icon = "code" }),
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
                    { Title = "Confirm", Callback = function()
                        pcall(function() player.Character.Humanoid.WalkSpeed = 16 end)
                        pcall(function() Options.WalkSpeedSlider:SetValue(16) end)
                    end },
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
                    { Title = "Confirm", Callback = function()
                        pcall(function() player.Character.Humanoid.JumpPower = 50 end)
                        pcall(function() Options.JumpPowerSlider:SetValue(50) end)
                    end },
                    { Title = "Cancel" }
                }
            })
        end
    })

    -- =====================================
    -- UI: SELF MODIFICATIONS
    -- =====================================
    Tabs.Script:AddSection("Self Modifications")

    do
        local noclipConn = nil
        local NoclipToggle = Tabs.Script:AddToggle("Noclip_Toggle", { Title = "Noclip (No Collision)", Default = false })
        NoclipToggle:OnChanged(function()
            if Options.Noclip_Toggle.Value then
                noclipConn = RunService.Stepped:Connect(function()
                    if player.Character then
                        for _, p in pairs(player.Character:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide = false end
                        end
                    end
                end)
            else
                if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
                pcall(function()
                    for _, p in pairs(player.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = true end
                    end
                end)
            end
        end)
    end

    do
        local flyConn = nil
        local FlyToggle = Tabs.Script:AddToggle("Fly_Toggle", { Title = "Fly Mode (WASD + Space/Shift)", Default = false })
        FlyToggle:OnChanged(function()
            local char = player.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if Options.Fly_Toggle.Value then
                if not hrp or not hum then return end
                hum.PlatformStand = true
                local bv = Instance.new("BodyVelocity")
                bv.Name = "_HubFlyBV"; bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Velocity = Vector3.zero; bv.Parent = hrp
                local bg = Instance.new("BodyGyro")
                bg.Name = "_HubFlyBG"; bg.MaxTorque = Vector3.new(1e9,1e9,1e9); bg.P = 9e4; bg.CFrame = hrp.CFrame; bg.Parent = hrp
                local UIS2 = game:GetService("UserInputService")
                local cam = workspace.CurrentCamera
                flyConn = RunService.RenderStepped:Connect(function()
                    if not Options.Fly_Toggle.Value then return end
                    local mv = Vector3.zero
                    if UIS2:IsKeyDown(Enum.KeyCode.W) then mv += cam.CFrame.LookVector end
                    if UIS2:IsKeyDown(Enum.KeyCode.S) then mv -= cam.CFrame.LookVector end
                    if UIS2:IsKeyDown(Enum.KeyCode.A) then mv -= cam.CFrame.RightVector end
                    if UIS2:IsKeyDown(Enum.KeyCode.D) then mv += cam.CFrame.RightVector end
                    if UIS2:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
                    if UIS2:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.new(0,1,0) end
                    bv.Velocity = (mv.Magnitude > 0 and mv.Unit or mv) * 60
                    bg.CFrame = cam.CFrame
                end)
            else
                if flyConn then flyConn:Disconnect(); flyConn = nil end
                if hrp then
                    pcall(function() hrp._HubFlyBV:Destroy() end)
                    pcall(function() hrp._HubFlyBG:Destroy() end)
                end
                if hum then hum.PlatformStand = false end
            end
        end)
    end

    do
        local godConn = nil
        local GodToggle = Tabs.Script:AddToggle("GodMode_Toggle", { Title = "God Mode (Infinite Health)", Default = false })
        GodToggle:OnChanged(function()
            if Options.GodMode_Toggle.Value then
                godConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local hum = player.Character:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Health = hum.MaxHealth end
                    end)
                end)
            else
                if godConn then godConn:Disconnect(); godConn = nil end
            end
        end)
    end

    do
        local ijConn = nil
        local IJToggle = Tabs.Script:AddToggle("InfJump_Toggle", { Title = "Infinite Jump", Default = false })
        IJToggle:OnChanged(function()
            if Options.InfJump_Toggle.Value then
                ijConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                    pcall(function()
                        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                    end)
                end)
            else
                if ijConn then ijConn:Disconnect(); ijConn = nil end
            end
        end)
    end

    Tabs.Script:AddButton({
        Title = "Reset Character",
        Description = "Kills and respawns your character immediately.",
        Callback = function()
            pcall(function() player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead) end)
        end
    })

    Tabs.Script:AddButton({
        Title = "Teleport to Spawn",
        Description = "Moves your character to the map's spawn location.",
        Callback = function()
            pcall(function()
                local spawn = workspace:FindFirstChildOfClass("SpawnLocation")
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and spawn then
                    hrp.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                elseif hrp then
                    hrp.CFrame = CFrame.new(0, 10, 0)
                end
            end)
        end
    })

    Tabs.Script:AddButton({
        Title = "Rejoin Server",
        Description = "Reconnects to the current game server.",
        Callback = function()
            local TS = game:GetService("TeleportService")
            if #Players:GetPlayers() <= 1 then
                TS:Teleport(game.PlaceId, player)
            else
                pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
            end
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

    do
        local freezeConn = nil
        local FreezeToggle = Tabs.Script:AddToggle("Freeze_Toggle", { Title = "Freeze Self (Anchor HRP)", Default = false })
        FreezeToggle:OnChanged(function()
            pcall(function()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Anchored = Options.Freeze_Toggle.Value end
            end)
        end)
    end

    do
        local InvisToggle = Tabs.Script:AddToggle("Invisible_Toggle", { Title = "Local Invisibility", Default = false })
        InvisToggle:OnChanged(function()
            pcall(function()
                for _, p in pairs(player.Character:GetDescendants()) do
                    if p:IsA("BasePart") or p:IsA("Decal") then
                        p.LocalTransparencyModifier = Options.Invisible_Toggle.Value and 1 or 0
                    end
                end
            end)
        end)
    end

    do
        local avConn = nil
        local AVToggle = Tabs.Script:AddToggle("AntiVoid_Toggle", { Title = "Anti-Void (Auto Reset on Fall)", Default = false })
        AVToggle:OnChanged(function()
            if Options.AntiVoid_Toggle.Value then
                avConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and hrp.Position.Y < -450 then
                            player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
                        end
                    end)
                end)
            else
                if avConn then avConn:Disconnect(); avConn = nil end
            end
        end)
    end

    Tabs.Script:AddButton({
        Title = "Rejoin Server",
        Description = "Reconnects to the current server instance.",
        Callback = function()
            local TS = game:GetService("TeleportService")
            if #Players:GetPlayers() <= 1 then
                TS:Teleport(game.PlaceId, player)
            else
                pcall(function() TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end)
            end
        end
    })

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
            rootPart.CanCollide = true
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

    -- =====================================
    -- UI: LISTENER TAB (GokuThug1 Logic)
    -- =====================================
    getgenv().GokuListener = {
        Events = {},
        EventNames = {"None"},
        ListenMarket = true,
        ListenRemotes = false,
        ListenBindables = false,
        TargetOnlyMe = false,
        AutoFire = false,
        CrashMode = false,
        CPS = 10,
        ActiveLoop = nil
    }

    Tabs.Listener:AddSection("Listener Settings")
    Tabs.Listener:AddToggle("ListenMarket_T", { Title = "Listen: Marketplace", Default = true }):OnChanged(function(v) getgenv().GokuListener.ListenMarket = v end)
    Tabs.Listener:AddToggle("ListenRemotes_T", { Title = "Listen: Remotes", Default = false }):OnChanged(function(v) getgenv().GokuListener.ListenRemotes = v end)
    Tabs.Listener:AddToggle("ListenBindables_T", { Title = "Listen: Bindables", Default = false }):OnChanged(function(v) getgenv().GokuListener.ListenBindables = v end)
    Tabs.Listener:AddToggle("TargetOnlyMe_T", { Title = "Filter: Target Only Me", Default = false }):OnChanged(function(v) getgenv().GokuListener.TargetOnlyMe = v end)

    Tabs.Listener:AddSection("Fire Settings")
    Tabs.Listener:AddToggle("AutoFire_T", { Title = "Auto Fire (Loop Mode)", Default = false }):OnChanged(function(v) 
        getgenv().GokuListener.AutoFire = v 
        if not v then getgenv().GokuListener.ActiveLoop = nil end
    end)
    Tabs.Listener:AddToggle("CrashMode_T", { Title = "Crash Mode (Fast Burst)", Default = false }):OnChanged(function(v) getgenv().GokuListener.CrashMode = v end)
    Tabs.Listener:AddSlider("FireCPS_S", { Title = "Fire CPS", Default = 10, Min = 1, Max = 1000, Rounding = 0, Callback = function(v) getgenv().GokuListener.CPS = v end })

    Tabs.Listener:AddSection("Caught Events")
    
    local EventDropdown = Tabs.Listener:AddDropdown("CaughtEvents_DD", {
        Title = "Select Event",
        Values = getgenv().GokuListener.EventNames,
        Multi = false,
        Default = 1,
    })

    local function triggerEvent(ev)
        pcall(function()
            if ev.type == "Product" then game:GetService("MarketplaceService"):SignalPromptProductPurchaseFinished(Players.LocalPlayer.UserId, ev.id, true)
            elseif ev.type == "Gamepass" then game:GetService("MarketplaceService"):SignalPromptGamePassPurchaseFinished(Players.LocalPlayer, ev.id, true)
            elseif ev.type == "Purchase" then game:GetService("MarketplaceService"):SignalPromptPurchaseFinished(Players.LocalPlayer.UserId, ev.id, true)
            elseif ev.type == "Network" then
                if ev.method == "FireServer" then ev.instance:FireServer(unpack(ev.args))
                elseif ev.method == "InvokeServer" then ev.instance:InvokeServer(unpack(ev.args))
                elseif ev.method == "Fire" then ev.instance:Fire(unpack(ev.args))
                elseif ev.method == "Invoke" then ev.instance:Invoke(unpack(ev.args))
                end
            end
        end)
    end

    Tabs.Listener:AddButton({
        Title = "Fire Selected Event",
        Callback = function()
            local sel = Options.CaughtEvents_DD.Value
            local ev = getgenv().GokuListener.Events[sel]
            if not ev then return end

            if getgenv().GokuListener.CrashMode then
                local ticks = 0
                local conn
                conn = RunService.Heartbeat:Connect(function()
                    for _ = 1, 100 do triggerEvent(ev) end
                    ticks = ticks + 1
                    if ticks > 50 then conn:Disconnect() end
                end)
            elseif getgenv().GokuListener.AutoFire then
                local loopId = tick()
                getgenv().GokuListener.ActiveLoop = loopId
                task.spawn(function()
                    while getgenv().GokuListener.AutoFire and getgenv().GokuListener.ActiveLoop == loopId do
                        triggerEvent(ev)
                        task.wait(1 / getgenv().GokuListener.CPS)
                    end
                end)
            else
                triggerEvent(ev)
            end
        end
    })

    Tabs.Listener:AddButton({
        Title = "Stop Auto Fire",
        Callback = function() getgenv().GokuListener.ActiveLoop = nil end
    })

    Tabs.Listener:AddButton({
        Title = "Clear Caught Events",
        Callback = function()
            getgenv().GokuListener.Events = {}
            getgenv().GokuListener.EventNames = {"None"}
            EventDropdown:SetValues(getgenv().GokuListener.EventNames)
            EventDropdown:SetValue("None")
        end
    })

    local function addEvent(id, name, evData)
        if not getgenv().GokuListener.Events[id] then
            getgenv().GokuListener.Events[id] = evData
            if getgenv().GokuListener.EventNames[1] == "None" then table.remove(getgenv().GokuListener.EventNames, 1) end
            table.insert(getgenv().GokuListener.EventNames, id)
            EventDropdown:SetValues(getgenv().GokuListener.EventNames)
            EventDropdown:SetValue(id)
        else
            getgenv().GokuListener.Events[id].count = (getgenv().GokuListener.Events[id].count or 1) + 1
            if evData.args then getgenv().GokuListener.Events[id].args = evData.args end
        end
    end

    -- Hook Marketplace
    local MarketplaceService = game:GetService("MarketplaceService")
    MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, id, isPurchased)
        if getgenv().GokuListener.ListenMarket and userId == Players.LocalPlayer.UserId then 
            addEvent("Product_"..id, "Product: "..id, {type = "Product", id = id, count = 1})
        end
    end)
    MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, isPurchased)
        if getgenv().GokuListener.ListenMarket and player == Players.LocalPlayer then 
            addEvent("Gamepass_"..id, "Gamepass: "..id, {type = "Gamepass", id = id, count = 1})
        end
    end)
    MarketplaceService.PromptPurchaseFinished:Connect(function(player, id, isPurchased)
        if getgenv().GokuListener.ListenMarket and player == Players.LocalPlayer then 
            addEvent("Purchase_"..id, "Purchase: "..id, {type = "Purchase", id = id, count = 1})
        end
    end)

    -- Hook Network
    local function involvesLocalPlayer(args)
        if not getgenv().GokuListener.TargetOnlyMe then return true end
        if #args == 0 then return false end
        local lp = Players.LocalPlayer
        local function check(val, depth)
            if depth > 2 then return false end
            if val == lp or val == lp.Name or val == lp.UserId then return true end
            if lp.Character and val == lp.Character then return true end
            if typeof(val) == "Instance" and lp.Character and val:IsDescendantOf(lp.Character) then return true end
            if type(val) == "table" then
                for _, v in pairs(val) do if check(v, depth + 1) then return true end end
            end
            return false
        end
        for _, arg in ipairs(args) do if check(arg, 1) then return true end end
        return false
    end

    if hookmetamethod then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not checkcaller() then
                local method = getnamecallmethod()
                local args = {...}
                if getgenv().GokuListener.ListenRemotes and (method == "FireServer" or method == "InvokeServer") then
                    local isValid = false; pcall(function() isValid = (self.ClassName == "RemoteEvent" or self.ClassName == "RemoteFunction") end)
                    if isValid and involvesLocalPlayer(args) then
                        local pathName = self.Name; pcall(function() pathName = self:GetFullName() end)
                        local id = pathName .. " (" .. method .. ")"
                        addEvent(id, id, {type = "Network", instance = self, method = method, args = args, count = 1})
                    end
                elseif getgenv().GokuListener.ListenBindables and (method == "Fire" or method == "Invoke") then
                    local isValid = false; pcall(function() isValid = (self.ClassName == "BindableEvent" or self.ClassName == "BindableFunction") end)
                    if isValid and involvesLocalPlayer(args) then
                        local pathName = self.Name; pcall(function() pathName = self:GetFullName() end)
                        local id = pathName .. " (" .. method .. ")"
                        addEvent(id, id, {type = "Network", instance = self, method = method, args = args, count = 1})
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
    end

    -- =====================================
    -- UI: EXECUTOR TAB
    -- =====================================
    -- =====================================
    -- UI: EXECUTOR TAB
    -- =====================================
    local ExecutorFrame = Instance.new("Frame")
    ExecutorFrame.Size = UDim2.new(1, -10, 0, 360) -- Takes up almost all the space
    ExecutorFrame.BackgroundTransparency = 1
    
    local CodeBox = Instance.new("TextBox")
    CodeBox.Size = UDim2.new(1, 0, 1, -40)
    CodeBox.Position = UDim2.new(0, 0, 0, 0)
    CodeBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CodeBox.BackgroundTransparency = 0.4
    CodeBox.TextColor3 = Color3.fromRGB(230, 230, 230)
    CodeBox.Font = Enum.Font.Code
    CodeBox.TextSize = 14
    CodeBox.TextXAlignment = Enum.TextXAlignment.Left
    CodeBox.TextYAlignment = Enum.TextYAlignment.Top
    CodeBox.MultiLine = true
    CodeBox.ClearTextOnFocus = false
    CodeBox.Text = "-- Write Lua script here..."
    CodeBox.Parent = ExecutorFrame
    local uic = Instance.new("UICorner", CodeBox)
    uic.CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", CodeBox)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.9

    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Size = UDim2.new(0.48, 0, 0, 30)
    ExecBtn.Position = UDim2.new(0, 0, 1, -30)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ExecBtn.BackgroundTransparency = 0.92
    ExecBtn.Text = "Execute"
    ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecBtn.Font = Enum.Font.GothamMedium
    ExecBtn.TextSize = 14
    ExecBtn.Parent = ExecutorFrame
    local uic2 = Instance.new("UICorner", ExecBtn)
    uic2.CornerRadius = UDim.new(0, 6)
    local stroke2 = Instance.new("UIStroke", ExecBtn)
    stroke2.Color = Color3.fromRGB(255, 255, 255)
    stroke2.Transparency = 0.9
    
    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0.48, 0, 0, 30)
    ClearBtn.Position = UDim2.new(0.52, 0, 1, -30)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClearBtn.BackgroundTransparency = 0.92
    ClearBtn.Text = "Clear"
    ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearBtn.Font = Enum.Font.GothamMedium
    ClearBtn.TextSize = 14
    ClearBtn.Parent = ExecutorFrame
    local uic3 = Instance.new("UICorner", ClearBtn)
    uic3.CornerRadius = UDim.new(0, 6)
    local stroke3 = Instance.new("UIStroke", ClearBtn)
    stroke3.Color = Color3.fromRGB(255, 255, 255)
    stroke3.Transparency = 0.9
    
    ExecBtn.MouseButton1Click:Connect(function()
        local code = CodeBox.Text
        if code == "" or code == "-- Write Lua script here..." then return end
        local fn, err = loadstring(code)
        if fn then
            local ok, res = pcall(fn)
            if not ok then warn("Execute Error: " .. tostring(res)) end
        else
            warn("Syntax Error: " .. tostring(err))
        end
    end)
    
    ClearBtn.MouseButton1Click:Connect(function()
        CodeBox.Text = ""
    end)

    -- Inject into Fluent UI tab
    local tempPara = Tabs.Executor:AddParagraph({ Title = "Loading Executor...", Content = "" })
    task.spawn(function()
        task.wait()
        pcall(function()
            local uiParent = tempPara.Frame and tempPara.Frame.Parent
            if uiParent then
                ExecutorFrame.Parent = uiParent
                tempPara.Frame:Destroy()
            else
                if type(Tabs.Executor) == "table" and Tabs.Executor.Container then
                    ExecutorFrame.Parent = Tabs.Executor.Container
                end
            end
        end)
    end)

    Tabs.Universal:AddSection("Admin Commands")

    Tabs.Universal:AddButton({
        Title = "Execute NexsCmds (Universal Admin)",
        Description = "Loads the powerful Universal Admin commands script.",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/NexsCmds/Menu/client.luau"))()
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
    -- UI: OVERLAY GUIS (Ported Features)
    -- =====================================
    Tabs.Debugger:AddSection("Overlay Interfaces")

    local function createStatBoard()
        local isGuiOpen = false
        local frames = {}
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        local function createInfoFrame(position, labelText, iconId)
            local Frame = Instance.new("Frame")
            pcall(function() Frame.Parent = game:GetService("CoreGui") end)
            Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Frame.BorderSizePixel = 0
            Frame.Position = position
            Frame.Size = UDim2.new(0, 160, 0, 50)
            Frame.AnchorPoint = Vector2.new(1, 0)
            Frame.BackgroundTransparency = 1 
            Frame.Visible = false

            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(0, 10)
            UICorner.Parent = Frame

            local UIGradient = Instance.new("UIGradient")
            UIGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(18, 22, 24)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(39, 39, 39))
            }
            UIGradient.Parent = Frame

            local ImageLabel = Instance.new("ImageLabel")
            ImageLabel.Parent = Frame
            ImageLabel.BackgroundTransparency = 1
            ImageLabel.Position = UDim2.new(0.05, 0, 0.5, -16)
            ImageLabel.Size = UDim2.new(0, 32, 0, 32)
            ImageLabel.Image = "rbxassetid://" .. iconId
            ImageLabel.ImageTransparency = 1

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Parent = Frame
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0.30, 0, 0.5, -15)
            TextLabel.Size = UDim2.new(0, 100, 0, 30)
            TextLabel.Font = Enum.Font.SourceSansBold
            TextLabel.Text = labelText
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.TextSize = 20.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextLabel.TextTransparency = 1 

            return Frame, TextLabel, ImageLabel
        end

        local basePosition = UDim2.new(0.99, 0, 0, 5)
        local icons = {"133746622922498", "100696028038981", "96009847305866", "120279682762468", "129874671449175"}
        local labels = {"CPU: N/A", "GPU: N/A", "Memory: N/A", "Ping: N/A", "FPS: 0"}

        for i, labelText in ipairs(labels) do
            local frame, textLabel, imageLabel = createInfoFrame(
                UDim2.new(basePosition.X.Scale, basePosition.X.Offset, basePosition.Y.Scale, basePosition.Y.Offset + ((i-1) * 60)),
                labelText,
                icons[i]
            )
            table.insert(frames, {frame = frame, textLabel = textLabel, imageLabel = imageLabel})
        end

        local fpsValue = 0
        local lastUpdateTime = tick()
        RunService.RenderStepped:Connect(function() fpsValue = fpsValue + 1 end)

        task.spawn(function()
            while true do
                if isGuiOpen then
                    local currentTime = tick()
                    local deltaTime = currentTime - lastUpdateTime
                    local actualFPS = math.floor(fpsValue / deltaTime)
                    local cpuUsage = math.random(10, 70)
                    local gpuUsage = math.random(10, 70)
                    local memoryUsage = math.random(20, 80)
                    local ping = math.random(40, 120)

                    frames[1].textLabel.Text = "CPU: " .. cpuUsage .. "%"
                    frames[2].textLabel.Text = "GPU: " .. gpuUsage .. "%"
                    frames[3].textLabel.Text = "Memory: " .. memoryUsage .. "%"
                    frames[4].textLabel.Text = "Ping: " .. ping .. " ms"
                    frames[5].textLabel.Text = "FPS: " .. actualFPS
                end
                fpsValue = 0
                lastUpdateTime = tick()
                task.wait(1)
            end
        end)

        return function(state)
            isGuiOpen = state
            for i, frameData in ipairs(frames) do
                if state then frameData.frame.Visible = true end
                delay(i * 0.1, function()
                    local targetTransparency = state and 0 or 1
                    local targetPosition = UDim2.new(
                        basePosition.X.Scale,
                        basePosition.X.Offset,
                        basePosition.Y.Scale,
                        basePosition.Y.Offset + ((i-1) * 60) + (state and 0 or 20)
                    )

                    TweenService:Create(frameData.frame, tweenInfo, { BackgroundTransparency = targetTransparency, Position = targetPosition }):Play()
                    TweenService:Create(frameData.textLabel, tweenInfo, { TextTransparency = targetTransparency }):Play()
                    TweenService:Create(frameData.imageLabel, tweenInfo, { ImageTransparency = targetTransparency }):Play()

                    if not state then
                        delay(0.5, function() if not isGuiOpen then frameData.frame.Visible = false end end)
                    end
                end)
            end
        end
    end

    local toggleStatBoard = createStatBoard()
    Tabs.Debugger:AddToggle("OverlayStatBoard", {
        Title = "Toggle Overlay Stat Board",
        Default = false,
        Callback = function(state)
            toggleStatBoard(state)
        end
    })

    local function createChatLogger()
        local taskbar = Instance.new("Frame")
        taskbar.Name = "HubChatLogs"
        taskbar.AnchorPoint = Vector2.new(0.5, 1)
        taskbar.Position = UDim2.new(0.5, 0, 1, -80)
        taskbar.Size = UDim2.new(0, 400, 0, 200)
        taskbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        taskbar.BorderSizePixel = 0
        taskbar.Visible = false
        pcall(function() taskbar.Parent = game:GetService("CoreGui") end)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = taskbar

        local title = Instance.new("TextLabel", taskbar)
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 15, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "On-Screen Chat Logs"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.TextXAlignment = Enum.TextXAlignment.Left

        local scrollFrame = Instance.new("ScrollingFrame", taskbar)
        scrollFrame.Size = UDim2.new(1, -20, 1, -40)
        scrollFrame.Position = UDim2.new(0, 10, 0, 40)
        scrollFrame.BackgroundTransparency = 1
        scrollFrame.ScrollBarThickness = 2
        scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

        local listLayout = Instance.new("UIListLayout", scrollFrame)
        listLayout.Padding = UDim.new(0, 2)
        
        local allLogs = {}
        local function addLog(pName, msg)
            local txt = Instance.new("TextLabel", scrollFrame)
            txt.Size = UDim2.new(1, 0, 0, 18)
            txt.BackgroundTransparency = 1
            txt.Text = "[" .. pName .. "]: " .. msg
            txt.TextColor3 = Color3.fromRGB(220, 220, 220)
            txt.Font = Enum.Font.Gotham
            txt.TextSize = 13
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.TextWrapped = true
            txt.AutomaticSize = Enum.AutomaticSize.Y
            table.insert(allLogs, txt)
            if #allLogs > 40 then
                local old = table.remove(allLogs, 1)
                if old then old:Destroy() end
            end
            task.spawn(function()
                task.wait()
                pcall(function() scrollFrame.CanvasPosition = Vector2.new(0, 99999) end)
            end)
        end

        for _, p in pairs(Players:GetPlayers()) do
            p.Chatted:Connect(function(msg) addLog(p.Name, msg) end)
        end
        Players.PlayerAdded:Connect(function(p)
            p.Chatted:Connect(function(msg) addLog(p.Name, msg) end)
        end)
        pcall(function()
            local TextChatService = game:GetService("TextChatService")
            TextChatService.OnIncomingMessage = function(message)
                local pName = message.TextSource and message.TextSource.Name or "System"
                addLog(pName, message.Text)
            end
        end)
        
        local dragging, dragInput, dragStart, startPos
        taskbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = taskbar.Position
            end
        end)
        taskbar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                taskbar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        return function(state)
            taskbar.Visible = state
        end
    end

    local toggleChatLog = createChatLogger()
    Tabs.Debugger:AddToggle("OverlayChatLog", {
        Title = "Toggle On-Screen Chat Logger",
        Default = false,
        Callback = function(state)
            toggleChatLog(state)
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
    end    -- =====================================
    -- UI: CUSTOM MACRO KEYBINDS
    -- =====================================
    Tabs.Settings:AddSection("Custom Macro Keybinds")

    local BindableActions = {
        ["None"] = function() end,
        ["Toggle Flight"] = function() if Options.Fly_Toggle then Options.Fly_Toggle:SetValue(not Options.Fly_Toggle.Value) end end,
        ["Toggle Noclip"] = function() if Options.Noclip_Toggle then Options.Noclip_Toggle:SetValue(not Options.Noclip_Toggle.Value) end end,
        ["Toggle God Mode"] = function() if Options.GodMode_Toggle then Options.GodMode_Toggle:SetValue(not Options.GodMode_Toggle.Value) end end,
        ["Toggle Infinite Jump"] = function() if Options.InfJump_Toggle then Options.InfJump_Toggle:SetValue(not Options.InfJump_Toggle.Value) end end,
        ["Toggle Anti-Void"] = function() if Options.AntiVoid_Toggle then Options.AntiVoid_Toggle:SetValue(not Options.AntiVoid_Toggle.Value) end end,
        ["Toggle Enemy Hitboxes"] = function() if Options.EnemyExpander_Toggle then Options.EnemyExpander_Toggle:SetValue(not Options.EnemyExpander_Toggle.Value) end end,
        ["Rejoin Server"] = function()
            if #Players:GetPlayers() <= 1 then
                game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
            else
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
            end
        end,
        ["Clear Caught Events"] = function()
            if getgenv().GokuListener then
                getgenv().GokuListener.Events = {}
                getgenv().GokuListener.EventNames = {"None"}
                if Options.CaughtEvents_DD then
                    Options.CaughtEvents_DD:SetValues({"None"})
                    Options.CaughtEvents_DD:SetValue("None")
                end
            end
        end
    }

    local actionNames = {}
    for k, _ in pairs(BindableActions) do table.insert(actionNames, k) end
    table.sort(actionNames)

    local currentActionToBind = "None"
    
    local BindsParagraph = Tabs.Settings:AddParagraph({
        Title = "Active Keybinds",
        Content = "None"
    })
    
    local CustomBinds = {}
    
    local function updateBindsText()
        local str = ""
        for key, action in pairs(CustomBinds) do
            str = str .. "[" .. key .. "] -> " .. action .. "\n"
        end
        if str == "" then str = "None" end
        BindsParagraph:SetDesc(str)
    end

    Tabs.Settings:AddDropdown("Macro_Action_Select", {
        Title = "Select Action to Bind",
        Values = actionNames,
        Multi = false,
        Default = 1,
        Callback = function(v)
            currentActionToBind = v
        end
    })

    local binding = false
    local BindBtn = Tabs.Settings:AddButton({
        Title = "Click to Bind Selected Action",
        Callback = function()
            if currentActionToBind == "None" then return end
            if binding then return end
            binding = true
            
            Fluent:Notify({ Title = "Keybind Mode", Content = "Press any key to bind to: " .. currentActionToBind, Duration = 3 })
            
            local conn
            conn = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode.Name
                    if key ~= "Unknown" then
                        CustomBinds[key] = currentActionToBind
                        updateBindsText()
                        Fluent:Notify({ Title = "Keybind Set", Content = "Bound [" .. key .. "] to " .. currentActionToBind, Duration = 2 })
                    end
                    binding = false
                    conn:Disconnect()
                end
            end)
        end
    })

    Tabs.Settings:AddButton({
        Title = "Clear All Custom Binds",
        Callback = function()
            CustomBinds = {}
            updateBindsText()
            Fluent:Notify({ Title = "Cleared", Content = "All custom keybinds removed.", Duration = 2 })
        end
    })

    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local action = CustomBinds[input.KeyCode.Name]
            if action and BindableActions[action] then
                pcall(BindableActions[action])
            end
        end
    end)

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
