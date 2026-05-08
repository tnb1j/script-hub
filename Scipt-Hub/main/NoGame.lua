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

    -- Dynamically requests content lists from your new repository matching structural parameters
    local api_url = "https://api.github.com/repos/tnb1j/script-hub/contents/Script?ref=main"
    local map_success, map_response = pcall(function()
        return request({ Url = api_url, Method = "GET", Headers = { ["Content-Type"] = "application/json" } })
    end)
    
    if map_success and map_response.StatusCode == 200 then
        local http = game:GetService("HttpService")
        local data = http:JSONDecode(map_response.Body)
    
        for _, file in pairs(data) do
            local fullName = file.name
            local mapName, mapId, status = fullName:match("^(.-)|(%d+)|(.+)$")
            
            if mapName and mapId and status then
                mapId = tonumber(mapId)
                Tabs.game:AddButton({
                    Title = mapName .. " [" .. status:gsub("%.lua","") .. "]",
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