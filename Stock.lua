-- 1

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

-- URL Webhook Discord
local WEBHOOK_URL = "https://discord.com/api/webhooks/1499378663102218311/qNd0YN-h31ykmktLA10atQm9KCCHCjDXAR31pUSDpaZaAfxZ_WCgPg8i_4FuTIyvcvRu"

local httpRequest = request or http_request or (syn and syn.request) or (http and http.request)
if not httpRequest then
    warn("[-] Executor tidak mendukung HTTP Request!")
    return
end

-- ==========================================
-- ROLE TAG MAPPER (Sesuai Server Kamu)
-- ==========================================
local ROLE_TAGS = {
    -- Seed Roles
    ["Exclusive Seed"] = "<@&1563698278099591229>",
    ["Secret Seed"]    = "<@&1563698057411960832>",
    ["Void Seed"]      = "<@&1563698146339590264>",

    -- Egg Roles
    ["Mythic Egg"]     = "<@&1563697647745892352>",
    ["Secret Egg"]     = "<@&1563697917704020088>"
}

-- ==========================================
-- 1. DATABASE LENGKAP SEED (18 ITEM)
-- ==========================================
local SEED_LIST = {
    { name = "Spooky Seed Pack",     tier = "Exclusive", role = "Exclusive Seed", group = "Secret & Special" },
    { name = "Vortex Seed Pack",     tier = "Void",      role = "Void Seed",      group = "Secret & Special" },
    { name = "Celestial Seed Pack",  tier = "Secret",    role = "Secret Seed",    group = "Secret & Special" },
    { name = "Void Seed Pack",       tier = "Secret",    role = "Secret Seed",    group = "Secret & Special" },
    { name = "Graveyard Seed Pack",  tier = "Mythic",    role = nil,              group = "Mythic" },
    { name = "Mutant Seed Pack",     tier = "Mythic",    role = nil,              group = "Mythic" },
    { name = "Cosmic Seed Pack",     tier = "Mythic",    role = nil,              group = "Mythic" },
    { name = "Phoenix Seed Pack",    tier = "Mythic",    role = nil,              group = "Mythic", aliases = { "phonixseedpack" } },
    { name = "Dragon Seed Pack",     tier = "Legendary", role = nil,              group = "Legendary & Epic" },
    { name = "Golden Sun Seed Pack", tier = "Legendary", role = nil,              group = "Legendary & Epic" },
    { name = "Aurora Seed Pack",     tier = "Epic",      role = nil,              group = "Legendary & Epic" },
    { name = "Ember Seed Pack",      tier = "Epic",      role = nil,              group = "Legendary & Epic" },
    { name = "Moonlight Seed Pack",  tier = "Rare",      role = nil,              group = "Rare & Normal" },
    { name = "Crystal Seed Pack",    tier = "Rare",      role = nil,              group = "Rare & Normal" },
    { name = "Bloom Seed Pack",      tier = "Uncommon",  role = nil,              group = "Rare & Normal" },
    { name = "Sunny Seed Pack",      tier = "Uncommon",  role = nil,              group = "Rare & Normal" },
    { name = "Garden Seed Pack",     tier = "Common",    role = nil,              group = "Rare & Normal" },
    { name = "Basic Seed Pack",      tier = "Common",    role = nil,              group = "Rare & Normal" }
}

-- ==========================================
-- 2. DATABASE LENGKAP EGG (14 ITEM)
-- ==========================================
local EGG_LIST = {
    { name = "Sealed Eye Egg", tier = "Secret",    role = "Secret Egg", group = "Secret" },
    { name = "Abyss Egg",      tier = "Secret",    role = "Secret Egg", group = "Secret", aliases = { "abyasegg" } },
    { name = "Solar Egg",      tier = "Mythic",    role = "Mythic Egg", group = "Mythic" },
    { name = "Inferno Egg",    tier = "Mythic",    role = "Mythic Egg", group = "Mythic" },
    { name = "Royal Egg",      tier = "Legendary", role = nil,          group = "Legendary & Epic" },
    { name = "Sun Wing Egg",   tier = "Legendary", role = nil,          group = "Legendary & Epic", aliases = { "sunnywingegg" } },
    { name = "Geode Egg",      tier = "Epic",      role = nil,          group = "Legendary & Epic" },
    { name = "Mushroom Egg",   tier = "Epic",      role = nil,          group = "Legendary & Epic", aliases = { "mussromegg" } },
    { name = "Frozen Egg",     tier = "Rare",      role = nil,          group = "Rare & Normal" },
    { name = "Tide Egg",       tier = "Rare",      role = nil,          group = "Rare & Normal" },
    { name = "Daisy Egg",      tier = "Uncommon",  role = nil,          group = "Rare & Normal" },
    { name = "Bug Egg",        tier = "Uncommon",  role = nil,          group = "Rare & Normal" },
    { name = "Sprout Egg",     tier = "Common",    role = nil,          group = "Rare & Normal" },
    { name = "Stone Egg",      tier = "Common",    role = nil,          group = "Rare & Normal" }
}

local function normalizeStock(rawTable)
    local clean = {}
    for name, qty in pairs(rawTable) do
        clean[string.lower(name:gsub("%s+", ""))] = qty
    end
    return clean
end

-- ==========================================
-- 3. FUNGSI PENGIRIMAN WEBHOOK EMBED
-- ==========================================
local function sendSummaryWebhook(shopName, itemList, stockLookup, nextTime, defaultColor)
    local readyCount = 0
    local totalItems = #itemList
    local activeAlerts = {}
    local groupedData = {}
    local groupOrder = {}

    for _, item in ipairs(itemList) do
        local cleanKey = string.lower(item.name:gsub("%s+", ""))
        local amount = stockLookup[cleanKey] or 0

        if amount == 0 and item.aliases then
            for _, alias in ipairs(item.aliases) do
                if stockLookup[alias] and stockLookup[alias] > 0 then
                    amount = stockLookup[alias]
                    break
                end
            end
        end

        local line = ""
        if amount > 0 then
            readyCount = readyCount + 1
            line = string.format("🟢 **%s** — `x%d`", item.name, amount)

            if item.role and ROLE_TAGS[item.role] then
                table.insert(activeAlerts, string.format("%s **%s** (x%d)", ROLE_TAGS[item.role], item.name, amount))
            elseif item.tier == "Mythic" or item.tier == "Secret" then
                table.insert(activeAlerts, string.format("**[%s] %s** (x%d)", item.tier, item.name, amount))
            end
        else
            line = string.format("🔴 **%s** — *Sold Out*", item.name)
        end

        if not groupedData[item.group] then
            groupedData[item.group] = {}
            table.insert(groupOrder, item.group)
        end
        table.insert(groupedData[item.group], line)
    end

    local sisaDetik = nextTime and math.max(0, math.floor(tonumber(nextTime) - workspace:GetServerTimeNow())) or 0
    local countdownTxt = string.format("%d menit %d detik", math.floor(sisaDetik / 60), sisaDetik % 60)

    local placeId = tostring(game.PlaceId)
    local jobId = tostring(game.JobId)
    local joinLink = string.format("https://www.roblox.com/games/start?placeId=%s&gameInstanceId=%s", placeId, jobId)

    local fields = {}
    for _, grp in ipairs(groupOrder) do
        table.insert(fields, {
            ["name"] = string.format("📁 %s", grp),
            ["value"] = table.concat(groupedData[grp], "\n"),
            ["inline"] = false
        })
    end

    local alertContent = nil
    if #activeAlerts > 0 then
        alertContent = "🚨 " .. table.concat(activeAlerts, " | ")
    end

    local payload = {
        ["content"] = alertContent,
        ["allowed_mentions"] = {
            ["parse"] = { "roles", "users" }
        },
        ["embeds"] = {{
            ["title"] = string.format("%s Stock Report", shopName),
            ["description"] = string.format(
                "📦 **Total Tersedia:** `%d/%d Item`\n⏳ **Restock Berikutnya:** `%s`\n\n🔗 **[KLIK DI SINI UNTUK JOIN SERVER](%s)**\n📋 **JobId:** `%s`",
                readyCount, totalItems, countdownTxt, joinLink, jobId
            ),
            ["color"] = #activeAlerts > 0 and 15158332 or defaultColor,
            ["fields"] = fields,
            ["footer"] = { ["text"] = "Waktu Server: " .. os.date("%X") },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    httpRequest({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(payload)
    })
end

-- ==========================================
-- 4. LISTENER REMOTE IN-GAME
-- ==========================================
local seedRemote = Remotes:WaitForChild("SeedShop", 5)
if seedRemote then
    seedRemote.OnClientEvent:Connect(function(action, stockTable, nextTime)
        if action == "Stock" and type(stockTable) == "table" then
            local clean = normalizeStock(stockTable)
            sendSummaryWebhook("🌱 Seed Shop", SEED_LIST, clean, nextTime, 3066993)
        end
    end)
    seedRemote:FireServer("Get")
end

local eggRemote = Remotes:WaitForChild("EggShop", 5)
if eggRemote then
    eggRemote.OnClientEvent:Connect(function(action, stockTable, nextTime)
        if action == "Stock" and type(stockTable) == "table" then
            local clean = normalizeStock(stockTable)
            sendSummaryWebhook("🥚 Egg Shop", EGG_LIST, clean, nextTime, 15844367)
        end
    end)
    eggRemote:FireServer("Get")
end

print("[+] Script Monitoring Stock Berjalan!")
