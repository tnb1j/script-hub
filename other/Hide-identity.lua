local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

getgenv()._RealPlaceId = getgenv()._RealPlaceId or game.PlaceId

getgenv().IdentityConfig = getgenv().IdentityConfig or {
    FakeName = "???",
    FakeUserId = 1,
    FakeHWID = "???",
    FakePremium = true,
    FakeJobId = "???",
    FakePlaceId = 106656461757128,
    FakeGameName = "???",
}

getgenv().IdentityHider = getgenv().IdentityHider or {}
local savedData = getgenv().IdentityHider

if not savedData.originalName then
    savedData.originalName = Players.LocalPlayer.Name
    savedData.originalDisplayName = Players.LocalPlayer.DisplayName
    savedData.originalUserId = Players.LocalPlayer.UserId
    savedData.appliedChanges = {}
end

savedData.changedLocations = savedData.changedLocations or {}

local hookInstalled = false
local oldIndex = nil
local oldNamecall = nil

pcall(function()
    if hookmetamethod and newcclosure then
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(obj, key)
            if obj == game and key == "JobId" then
                return getgenv().IdentityConfig.FakeJobId
            end
            if obj == game and key == "PlaceId" then
                return getgenv().IdentityConfig.FakePlaceId
            end
            if obj == game and key == "Name" then
                return getgenv().IdentityConfig.FakeGameName
            end
            if obj == Players.LocalPlayer then
                if key == "MembershipType" then
                    return getgenv().IdentityConfig.FakePremium and Enum.MembershipType.Premium or Enum.MembershipType.None
                end
                if key == "Name" or key == "DisplayName" then
                    return getgenv().IdentityConfig.FakeName
                end
                if key == "UserId" then
                    return getgenv().IdentityConfig.FakeUserId
                end
            end
            return oldIndex(obj, key)
        end))

        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "GetClientId" and tostring(self) == "RbxAnalyticsService" then
                return getgenv().IdentityConfig.FakeHWID
            end
            return oldNamecall(self, ...)
        end))
        hookInstalled = true
    else
        local mt = getrawmetatable(game)
        setreadonly(mt, false)

        oldIndex = mt.__index
        mt.__index = function(obj, key)
            if obj == game and key == "JobId" then
                return getgenv().IdentityConfig.FakeJobId
            end
            if obj == game and key == "PlaceId" then
                return getgenv().IdentityConfig.FakePlaceId
            end
            if obj == game and key == "Name" then
                return getgenv().IdentityConfig.FakeGameName
            end
            if obj == Players.LocalPlayer then
                if key == "MembershipType" then
                    return getgenv().IdentityConfig.FakePremium and Enum.MembershipType.Premium or Enum.MembershipType.None
                end
                if key == "Name" or key == "DisplayName" then
                    return getgenv().IdentityConfig.FakeName
                end
                if key == "UserId" then
                    return getgenv().IdentityConfig.FakeUserId
                end
            end
            return oldIndex(obj, key)
        end

        oldNamecall = mt.__namecall
        mt.__namecall = function(self, ...)
            local method = getnamecallmethod()
            if method == "GetClientId" and tostring(self) == "RbxAnalyticsService" then
                return getgenv().IdentityConfig.FakeHWID
            end
            return oldNamecall(self, ...)
        end

        setreadonly(mt, true)
        hookInstalled = true
    end
end)

local function isLocationChanged(object, property)
    local ok, fullName = pcall(function() return object:GetFullName() .. "." .. property end)
    return ok and savedData.changedLocations[fullName] == true
end

local function markLocationChanged(object, property)
    local ok, fullName = pcall(function() return object:GetFullName() .. "." .. property end)
    if ok then
        savedData.changedLocations[fullName] = true
    end
end

local function applyPlayerChanges()
    local localPlayer = Players.LocalPlayer
    if not localPlayer then return end

    pcall(function()
        if localPlayer.Name == savedData.originalName and not isLocationChanged(localPlayer, "Name") then
            localPlayer.Name = getgenv().IdentityConfig.FakeName
            markLocationChanged(localPlayer, "Name")
        end
    end)

    pcall(function()
        if localPlayer.DisplayName == savedData.originalDisplayName and not isLocationChanged(localPlayer, "DisplayName") then
            localPlayer.DisplayName = getgenv().IdentityConfig.FakeName
            markLocationChanged(localPlayer, "DisplayName")
        end
    end)

    pcall(function()
        if localPlayer.UserId == savedData.originalUserId and not isLocationChanged(localPlayer, "UserId") then
            localPlayer.UserId = getgenv().IdentityConfig.FakeUserId
            markLocationChanged(localPlayer, "UserId")
        end
    end)
end

local function updateWorkspaceNames(object)
    if not object then return end
    local ok, children = pcall(function() return object:GetChildren() end)
    if not ok or not children then return end

    for _, child in pairs(children) do
        pcall(function()
            if child.Name == savedData.originalName and not isLocationChanged(child, "Name") then
                child.Name = getgenv().IdentityConfig.FakeName
                markLocationChanged(child, "Name")
            end

            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                if child.Text == savedData.originalName and not isLocationChanged(child, "Text") then
                    child.Text = getgenv().IdentityConfig.FakeName
                    markLocationChanged(child, "Text")
                elseif child.Text == savedData.originalDisplayName and not isLocationChanged(child, "Text") then
                    child.Text = getgenv().IdentityConfig.FakeName
                    markLocationChanged(child, "Text")
                end
            end
        end)
        updateWorkspaceNames(child)
    end
end

local function updatePlayerGui()
    local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        updateWorkspaceNames(playerGui)
    end
end

local function updateCoreGui()
    local success, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)

    if success and coreGui then
        for _, gui in pairs(coreGui:GetChildren()) do
            updateWorkspaceNames(gui)
        end
    end
end

local function applyAllChanges()
    applyPlayerChanges()
    updateWorkspaceNames(workspace)
    updatePlayerGui()
    updateCoreGui()
end

local function setupMonitoring()
    workspace.ChildAdded:Connect(function(child)
        task.wait(0.1)
        updateWorkspaceNames(child)
    end)

    local playerGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        playerGui.ChildAdded:Connect(function(child)
            task.wait(0.1)
            updateWorkspaceNames(child)
        end)
    end

    pcall(function()
        local coreGui = game:GetService("CoreGui")
        coreGui.ChildAdded:Connect(function(child)
            task.wait(0.1)
            updateWorkspaceNames(child)
        end)
    end)

    Players.LocalPlayer.Changed:Connect(function(property)
        if property == "Name" or property == "DisplayName" or property == "UserId" then
            task.wait(0.1)
            applyPlayerChanges()
        end
    end)
end

local function startContinuousLoop()
    task.spawn(function()
        while getgenv().IdentityHiderActive ~= false do
            task.wait(2)
            applyPlayerChanges()
            pcall(function() updateWorkspaceNames(workspace) end)
            pcall(function() updatePlayerGui() end)
            pcall(function() updateCoreGui() end)
        end
    end)
end

getgenv().IdentityHiderActive = true
applyAllChanges()
setupMonitoring()
startContinuousLoop()

getgenv().restoreIdentity = function()
    getgenv().IdentityHiderActive = false
    local localPlayer = Players.LocalPlayer
    if localPlayer then
        pcall(function() localPlayer.Name = savedData.originalName end)
        pcall(function() localPlayer.DisplayName = savedData.originalDisplayName end)
        pcall(function() localPlayer.UserId = savedData.originalUserId end)
    end
end
