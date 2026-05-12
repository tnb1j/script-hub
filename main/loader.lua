if getgenv()._FluentLib then
    pcall(function()
        getgenv()._FluentLib:Destroy()
    end)
    getgenv()._FluentLib = nil
    getgenv().Window = nil
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
getgenv()._FluentLib = Fluent
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

local function notify(content)
    pcall(function()
        Fluent:Notify({
            Title = "gokuthug1's Script Hub",
            Content = content,
            Duration = 8
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

local success, responseBody = httpGet(DIRECTORY_URL)
if success then
    local decoded, data = pcall(function()
        return HttpService:JSONDecode(responseBody)
    end)

    if decoded and type(data) == "table" then
        local found = false

        for _, file in pairs(data) do
            if type(file) == "table" and file.name and file.download_url then
                local mapName, mapId = parseScriptFileName(file.name)

                if mapName and mapId and PlaceId == mapId then
                    print("[gokuthug1's Hub] Loading game config: " .. mapName)
                    notify("Executing dynamic profile for: " .. mapName)

                    if loadRemoteScript(file.download_url, mapName) then
                        found = true
                        break
                    end
                end
            end
        end

        if not found then
            notify("Universal profile applied successfully.")
            loadRemoteScript(UNIVERSAL_SCRIPT_URL, "universal profile")
        end
    else
        warn("[gokuthug1's Hub] Failed to decode game directory payload.")
        loadRemoteScript(UNIVERSAL_SCRIPT_URL, "universal profile")
    end
else
    warn("[gokuthug1's Hub] Error fetching directory mapping: " .. tostring(responseBody))
    loadRemoteScript(UNIVERSAL_SCRIPT_URL, "universal profile")
end
