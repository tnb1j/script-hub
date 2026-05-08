loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/Off-site/Notify.lua"))()
local baseUrl = "https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/GUIS/"

local scripts = {
    {name = "List.lua", critical = true},
    {name = "Universal-Scripts.lua", critical = false},
    {name = "Off-site/Confirmation.lua", critical = false},
    {name = "Home.lua", critical = false}, 
    {name = "ChatLog.lua", critical = false},
    {name = "Stat-Board.lua", critical = false}
}

getgenv().ScriptFlags = getgenv().ScriptFlags or {}


getgenv().Notify({
  Title = 'Menu | 7yd7',
  Content = '🚀 Start loading scripts in order', 
  Duration = 5
})

local function loadScriptWithTimeout(scriptName, index, timeout)
    local fullUrl = baseUrl .. scriptName
    local flagName = "Script_" .. index
    local startTime = tick()

    task.spawn(function()
        local success, response = pcall(function()
            return game:HttpGet(fullUrl)
        end)

        if success and response then
            local loadSuccess = pcall(function()
                loadstring(response)()
            end)
            getgenv().ScriptFlags[flagName] = loadSuccess
            if not loadSuccess then
            
                getgenv().Notify({
                  Title = 'Menu | 7yd7',
                  Content = "Download failed: " .. scriptName, 
                  Duration = 5
                })

            end
        else
            getgenv().ScriptFlags[flagName] = false

                getgenv().Notify({
                  Title = 'Menu | 7yd7',
                  Content = "Download failed: " .. scriptName, 
                  Duration = 5
                })

        end
    end)

    while getgenv().ScriptFlags[flagName] == nil do
        if tick() - startTime > timeout then
            getgenv().ScriptFlags[flagName] = false
            break
        end
        wait(0.05)
    end

    return getgenv().ScriptFlags[flagName]
end

task.spawn(function()
    local successful = 0
    local total = #scripts
    local criticalFailed = false

    for i, scriptInfo in ipairs(scripts) do
        local scriptName = scriptInfo.name
        local isCritical = scriptInfo.critical
        local timeout = isCritical and 30 or 15

        local result = loadScriptWithTimeout(scriptName, i, timeout)

        if result then
            successful = successful + 1
        elseif isCritical then
            criticalFailed = true
            break
        end

        wait(0.1)
    end

    if criticalFailed then
        return
    end

    if getgenv().ScriptFlags["Script_1"] then
        local externalSuccess = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Menu-7yd7/refs/heads/Script/Create/buttons.lua"))()
        end)

        if externalSuccess then
               getgenv().Notify({
                  Title = 'Menu | 7yd7',
                  Content = '🎉 Everything worked!', 
                  Duration = 5
                })
        end
    end
end)

local requiredFunctions = {
    "createButton",
    "createScriptButton",
    "updateAllowedButtonData",
    "updateConfig",
    "createConfirmation",
    "Notify"
}

local timeout = 10
local startTime = tick()
local function allFunctionsReady()
    for _, funcName in ipairs(requiredFunctions) do
        if getgenv()[funcName] == nil then
            return false
        end
    end
    return true
end

repeat
    wait(0.1)
until allFunctionsReady() or (tick() - startTime > timeout)
