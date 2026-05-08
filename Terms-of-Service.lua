local BOOTSTRAP_URL = "https://raw.githubusercontent.com/tnb1j/script-hub/main/main/loader.lua"

local function looksLikeHtml(body)
    if type(body) ~= "string" then
        return false
    end

    local preview = body:sub(1, 200):lower()
    return preview:find("<!doctype", 1, true)
        or preview:find("<html", 1, true)
        or preview:find("<head", 1, true)
end

local function safeBootstrap(url, label)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or type(body) ~= "string" or body == "" then
        warn(string.format("[gokuthug1's Hub] Failed to fetch %s from %s: %s", label, url, tostring(body)))
        return
    end

    if looksLikeHtml(body) then
        warn(string.format("[gokuthug1's Hub] Refused to execute HTML response for %s from %s", label, url))
        return
    end

    local chunk, loadErr = loadstring(body)
    if not chunk then
        warn(string.format("[gokuthug1's Hub] Failed to compile %s from %s: %s", label, url, tostring(loadErr)))
        return
    end

    local ran, runtimeErr = pcall(chunk)
    if not ran then
        warn(string.format("[gokuthug1's Hub] Failed to execute %s from %s: %s", label, url, tostring(runtimeErr)))
    end
end

safeBootstrap(BOOTSTRAP_URL, "main loader")

return {
    Configuration = {
        {
            title = "Warning",
            description = "We are not responsible or legally liable if system bans are sustained inside any production experience while executing this code suite."
        },
        {
            title = "Legal Notice",
            description = "Execution of this software engine layout is undertaken entirely at your own discretion. The developers hold zero absolute liability."
        },
        {
            title = "Open Source Framework",
            description = "This collection represents a fully open-source collaborative assembly structure:",
            link = "https://github.com/tnb1j/script-hub"
        },
        {
            title = "تحذير هام",
            description = "نحن غير مسؤولين عن أي حظر قد يحدث نتيجة استخدام هذا السكربت في أي ماب."
        },
        {
            title = "إخلاء مسؤولية",
            description = "استخدام هذا السكربت يكون على مسؤوليتك الشخصية بالكامل. المطور لا يتحمل أي عواقب ناتجة عن الاستخدام."
        },
        {
            title = "مشروع مفتوح المصدر",
            description = "هذا السكربت مفتوح المصدر بالكامل ومتاح للجميع:",
            link = "https://github.com/tnb1j/script-hub"
        }
    }
}
