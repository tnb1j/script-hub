if getgenv().Window then
    pcall(function()
        getgenv().Window:Destroy()
    end)
    getgenv().Window = nil
end

local Fluent = getgenv()._FluentLib
if not Fluent then
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    end)
    if ok and lib then
        Fluent = lib
        getgenv()._FluentLib = Fluent
    else
        Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/main.lua"))()
        getgenv()._FluentLib = Fluent
    end
end
getgenv().Fluent = Fluent

local HttpService = game:GetService("HttpService")
local PlaceId = game.PlaceId
local Request = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)

local REPO_OWNER = "tnb1j"
local REPO_NAME = "script-hub"
local REPO_BRANCH = "main"
local RAW_REF_PATH = "refs/heads/" .. REPO_BRANCH
local RAW_BASE_URL = ("https://raw.githubusercontent.com/%s/%s/%s"):format(REPO_OWNER, REPO_NAME, RAW_REF_PATH)
local DIRECTORY_URL = ("https://api.github.com/repos/%s/%s/contents/main/script?ref=%s"):format(REPO_OWNER, REPO_NAME, REPO_BRANCH)
local UNIVERSAL_SCRIPT_URL = RAW_BASE_URL .. "/main/NoGame.lua"

-- Static game catalog ensuring full functionality even when GitHub API rate-limits (HTTP 403)
local STATIC_GAME_REGISTRY = {
    [101949297449238] = { name = "Build An Island", file = "Build-An-Island-101949297449238-🟢.txt", status = "🟢" },
    [6447798030]        = { name = "Funky Friday", file = "Funky-Friday-6447798030-🟢.txt", status = "🟢" },
    [189707]            = { name = "Natural Disaster Survival", file = "Natural-Disaster-Survival-189707-🟢.txt", status = "🟢" },
    [18901165922]       = { name = "PETS GO", file = "PETS-GO-18901165922-🟠.txt", status = "🟠" },
    [98228431199658]  = { name = "Raft Survival", file = "Raft-Survival-98228431199658-🟢.txt", status = "🟢" },
    [4972273297]        = { name = "Regretevator", file = "Regretevator-4972273297-🟢.txt", status = "🟢" },
    [11379739543]       = { name = "Timebomb Duels", file = "Timebomb-Duels-11379739543-🟢.txt", status = "🟢" }
}
getgenv()._GokuGameRegistry = STATIC_GAME_REGISTRY

local function notify(content, duration)
    pcall(function()
        Fluent:Notify({
            Title = "gokuthug1's Script Hub",
            Content = content,
            Duration = duration or 6
        })
    end)
end

local function looksLikeHtml(body)
    if type(body) ~= "string" then
        return false
    end
    local preview = body:sub(1, 200):lower()
    return preview:find("<!doctype", 1, true)
        or preview:find("<html", 1, true)
        or preview:find("<head", 1, true)
end

local function httpGet(url)
    if Request then
        local ok, response = pcall(function()
            return Request({
                Url = url,
                Method = "GET",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["User-Agent"] = "Roblox/ScriptHub"
                }
            })
        end)

        if ok and type(response) == "table" then
            local statusCode = response.StatusCode or response.Status
            local body = response.Body or response.body or response.ResponseBody

            if (statusCode == 200 or response.Success == true) and type(body) == "string" and body ~= "" then
                return true, body
            end
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

local function normalizeRepoRawUrl(url)
    if type(url) ~= "string" or url == "" then
        return url
    end

    local rawPrefix = ("https://raw.githubusercontent.com/%s/%s/"):format(REPO_OWNER, REPO_NAME)
    local branchPrefix = rawPrefix .. REPO_BRANCH .. "/"
    local refsPrefix = rawPrefix .. RAW_REF_PATH .. "/"

    if url:sub(1, #refsPrefix) == refsPrefix then
        return url
    end

    if url:sub(1, #branchPrefix) == branchPrefix then
        return refsPrefix .. url:sub(#branchPrefix + 1)
    end

    return url
end

local function loadRemoteScript(url, label)
    url = normalizeRepoRawUrl(url)
    local ok, bodyOrError = httpGet(url)
    if not ok then
        warn(string.format("[gokuthug1's Hub] Failed to fetch %s from %s: %s", label, url, bodyOrError))
        return false
    end

    if looksLikeHtml(bodyOrError) then
        warn(string.format("[gokuthug1's Hub] Refused to execute HTML response for %s from %s", label, url))
        return false
    end

    local chunk, loadErr = loadstring(bodyOrError)
    if not chunk then
        warn(string.format("[gokuthug1's Hub] Failed to compile %s from %s: %s", label, url, tostring(loadErr)))
        return false
    end

    local ran, runtimeErr = pcall(chunk)
    if not ran then
        warn(string.format("[gokuthug1's Hub] Failed to execute %s from %s: %s", label, url, tostring(runtimeErr)))
        return false
    end

    return true
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

local targetGameFile = nil
local targetGameName = nil

-- Attempt GitHub directory listing with seamless static fallback
local success, responseBody = httpGet(DIRECTORY_URL)
if success and not looksLikeHtml(responseBody) then
    local decoded, data = pcall(function()
        return HttpService:JSONDecode(responseBody)
    end)

    if decoded and type(data) == "table" and not data.message then
        for _, file in ipairs(data) do
            if type(file) == "table" and file.name and file.download_url then
                local mapName, mapId, status = parseScriptFileName(file.name)
                if mapName and mapId then
                    STATIC_GAME_REGISTRY[mapId] = {
                        name = mapName,
                        file = file.name,
                        status = status or "🟢",
                        download_url = file.download_url
                    }
                    if PlaceId == mapId then
                        targetGameFile = file.download_url
                        targetGameName = mapName
                    end
                end
            end
        end
    end
end

-- Fallback to static registry if API was rate-limited or target not found via API
if not targetGameFile and STATIC_GAME_REGISTRY[PlaceId] then
    local entry = STATIC_GAME_REGISTRY[PlaceId]
    targetGameFile = RAW_BASE_URL .. "/main/script/" .. entry.file
    targetGameName = entry.name
end

-- Launch the targeted profile or universal fallback
if targetGameFile and targetGameName then
    print("[gokuthug1's Hub] Loading game profile: " .. targetGameName)
    notify("Executing dynamic profile for: " .. targetGameName, 5)

    if loadRemoteScript(targetGameFile, targetGameName) then
        if not loadRemoteScript(UNIVERSAL_SCRIPT_URL, "hub shell") then
            warn("[gokuthug1's Hub] Game profile loaded, but hub shell failed to start.")
            notify("Game profile loaded, but hub UI failed to start.")
        end
    else
        warn("[gokuthug1's Hub] Failed to load targeted profile, falling back to universal.")
        notify("Game profile fetch failed. Running universal profile.")
        loadRemoteScript(UNIVERSAL_SCRIPT_URL, "universal profile")
    end
else
    notify("Universal profile applied successfully.", 5)
    loadRemoteScript(UNIVERSAL_SCRIPT_URL, "universal profile")
end
