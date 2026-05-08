local SETTINGS_URL = "https://raw.githubusercontent.com/tnb1j/script-hub/refs/heads/main/main/Settings.lua"

local function looksLikeHtml(body)
    if type(body) ~= "string" then
        return false
    end

    local preview = body:sub(1, 200):lower()
    return preview:find("<!doctype", 1, true)
        or preview:find("<html", 1, true)
        or preview:find("<head", 1, true)
end

local ok, body = pcall(function()
    return game:HttpGet(SETTINGS_URL)
end)

if not ok or type(body) ~= "string" or body == "" or looksLikeHtml(body) then
    warn("[gokuthug1's Hub] Failed to fetch canonical Settings library.")
    return nil
end

local chunk, loadErr = loadstring(body)
if not chunk then
    warn("[gokuthug1's Hub] Failed to compile canonical Settings library: " .. tostring(loadErr))
    return nil
end

local ran, result = pcall(chunk)
if not ran then
    warn("[gokuthug1's Hub] Failed to execute canonical Settings library: " .. tostring(result))
    return nil
end

return result
