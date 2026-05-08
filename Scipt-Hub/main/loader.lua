local function encodeURL(url)
    -- We no longer need to encode '|', just the emojis
    url = string.gsub(url, "🟢", "%%F0%%9F%%9F%%A2")
    url = string.gsub(url, "🟠", "%%F0%%9F%%9F%%A0") 
    url = string.gsub(url, "🔴", "%%F0%%9F%%94%%B4")
    return url
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local api_url = "https://api.github.com/repos/tnb1j/script-hub/contents/Script?ref=main"
local PlaceId = game.PlaceId

local success, response = pcall(function()
    return request({
        Url = api_url,
        Method = "GET",
        Headers = { ["Content-Type"] = "application/json" }
    })
end)

if success and response.StatusCode == 200 then
    local http = game:GetService("HttpService")
    local data = http:JSONDecode(response.Body)
    local found = false

    for _, file in pairs(data) do
        local fullName = file.name
        
        -- Pattern matches: GameName - PlaceId - Emoji .lua
        -- Works perfectly even if GameName has dashes in it (e.g., Timebomb-Duels)
        local mapName, mapIdStr, status = fullName:match("^(.-)%-(%d+)%-(.+)%.lua$")
        
        if mapName and mapIdStr then
            local mapId = tonumber(mapIdStr)
            local download_url = file.download_url

            if download_url and PlaceId == mapId then
                print("[gokuthug1's Hub] Loading game config: " .. mapName)

                Fluent:Notify({
                    Title = "gokuthug1's Script Hub",
                    Content = "Executing dynamic profile for: " .. mapName,
                    Duration = 8
                })

                local encoded_url = encodeURL(download_url)
                loadstring(game:HttpGet(encoded_url))()
                found = true
                break
            end
        end
    end
    
    if not found then
        Fluent:Notify({
            Title = "gokuthug1's Script Hub",
            Content = "Universal profile applied successfully.",
            Duration = 8
        })
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tnb1j/script-hub/main/NoGame.lua"))()
    end
else
    print("[gokuthug1's Hub] Error fetching directory mapping.")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/tnb1j/script-hub/main/NoGame.lua"))()
end
