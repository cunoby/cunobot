local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)

-- Masukkan URL Webhook Discord kamu di sini
local WEBHOOK_URL = "https://discord.com/api/webhooks/1499378663102218311/qNd0YN-h31ykmktLA10atQm9KCCHCjDXAR31pUSDpaZaAfxZ_WCgPg8i_4FuTIyvcvRu"

local httpRequest = request or http_request or (syn and syn.request) or (http and http.request)
if not httpRequest then
    warn("Executor tidak mendukung HTTP Request!")
    return
end

-- ==========================================
-- 1. DAFTAR SEED (18 Item Unik)
-- ==========================================
local SEED_LIST = {
    { name = "Spooky Seed Pack",     tier = "Exclusive", priority = 1 },
    { name = "Vortex Seed Pack",     tier = "Void",      priority = 2 },
    { name = "Celestial Seed Pack",  tier = "Secret",    priority = 3 },
    { name = "Void Seed Pack",       tier = "Secret",    priority = 4 },
    { name = "Graveyard Seed Pack",  tier = "Mythic",    priority = 5 },
    { name = "Mutant Seed Pack",     tier = "Mythic",    priority = 6 },
    { name = "Cosmic Seed Pack",     tier = "Mythic",    priority = 7 },
    { name = "Phoenix Seed Pack",    tier = "Mythic",    priority = 8, aliases = { "phonixseedpack" } },
    { name = "Dragon Seed Pack",     tier = "Legendary", priority = 9 },
    { name = "Golden Sun Seed Pack", tier = "Legendary", priority = 10 },
    { name = "Aurora Seed Pack",     tier = "Epic",      priority = 11 },
    { name = "Ember Seed Pack",      tier = "Epic",      priority = 12 },
    { name = "Moonlight Seed Pack",  tier = "Rare",      priority = 13 },
    { name = "Crystal Seed Pack",    tier = "Rare",      priority = 14 },
    { name = "Bloom Seed Pack",      tier = "Uncommon",  priority = 15 },
    { name = "Sunny Seed Pack",      tier = "Uncommon",  priority = 16 },
    { name = "Garden Seed Pack",     tier = "Common",    priority = 17 },
    { name = "Basic Seed Pack",      tier = "Common",    priority = 18 }
}

-- ==========================================
-- 2. DAFTAR EGG (14 Item Unik)
-- ==========================================
local EGG_LIST = {
    { name = "Sealed Eye Egg", tier = "Secret",    priority = 1 },
    { name = "Abyss Egg",      tier = "Secret",    priority = 2, aliases = { "abyasegg" } },
    { name = "Solar Egg",      tier = "Mythic",    priority = 3 },
    { name = "Inferno Egg",    tier = "Mythic",    priority = 4 },
    { name = "Royal Egg",      tier = "Legendary", priority = 5 },
    { name = "Sunny Wing Egg", tier = "Legendary", priority = 6 },
    { name = "Geode Egg",      tier = "Epic",      priority = 7 },
    { name = "Mushroom Egg",   tier = "Epic",      priority = 8, aliases = { "mussromegg" } },
    { name = "Frozen Egg",     tier = "Rare",      priority = 9 },
    { name = "Tide Egg",       tier = "Rare",      priority = 10 },
    { name = "Daisy Egg",      tier = "Uncommon",  priority = 11 },
    { name = "Bug Egg",        tier = "Uncommon",  priority = 12 },
    { name = "Sprout Egg",     tier = "Common",    priority = 13 },
    { name = "Stone Egg",      tier = "Common",    priority = 14 }
}

local function normalizeStock(rawTable)
    local clean = {}
    for name, qty in pairs(rawTable) do
        clean[string.lower(name:gsub("%s+", ""))] = qty
    end
    return clean
end

local function sendWebhook(title, description, fields, color)
    local payload = {
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
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
-- LISTENER: SEED SHOP
-- ==========================================
local seedRemote = Remotes:WaitForChild("SeedShop", 5)
if seedRemote then
    seedRemote.OnClientEvent:Connect(function(action, stockTable, nextTime, restockType)
        if action == "Stock" and type(stockTable) == "table" then
            local stockLookup = normalizeStock(stockTable)
            local fields = {}
            local readyCount = 0

            for _, item in ipairs(SEED_LIST) do
                local cleanKey = string.lower(item.name:gsub("%s+", ""))
                local amount = stockLookup[cleanKey] or 0

                if amount == 0 and item.aliases then
                    for _, aliasKey in ipairs(item.aliases) do
                        if stockLookup[aliasKey] and stockLookup[aliasKey] > 0 then
                            amount = stockLookup[aliasKey]
                            break
                        end
                    end
                end

                if amount > 0 then
                    readyCount = readyCount + 1
                end

                local statusTxt = amount > 0 and string.format("Stok: **x%d**", amount) or "❌ **SOLD OUT**"
                table.insert(fields, {
                    ["name"] = string.format("[%s] %s", item.tier, item.name),
                    ["value"] = statusTxt,
                    ["inline"] = true
                })
            end

            local sisaDetik = nextTime and math.max(0, math.floor(tonumber(nextTime) - workspace:GetServerTimeNow())) or 0
            local countdownTxt = string.format("%d menit %d detik", math.floor(sisaDetik / 60), sisaDetik % 60)
            local statusLabel = restockType == "Refill" and "Refilled" or "Restocked"

            sendWebhook(
                "🌱 Seed Shop " .. statusLabel,
                string.format("Ready: **%d/%d Item** | Restock lagi dalam: **%s**", readyCount, #SEED_LIST, countdownTxt),
                fields,
                3066993
            )
        end
    end)
    seedRemote:FireServer("Get")
end

-- ==========================================
-- LISTENER: EGG SHOP
-- ==========================================
local eggRemote = Remotes:WaitForChild("EggShop", 5)
if eggRemote then
    eggRemote.OnClientEvent:Connect(function(action, stockTable, nextTime)
        if action == "Stock" and type(stockTable) == "table" then
            local stockLookup = normalizeStock(stockTable)
            local fields = {}
            local readyCount = 0

            for _, item in ipairs(EGG_LIST) do
                local cleanKey = string.lower(item.name:gsub("%s+", ""))
                local amount = stockLookup[cleanKey] or 0

                if amount == 0 and item.aliases then
                    for _, aliasKey in ipairs(item.aliases) do
                        if stockLookup[aliasKey] and stockLookup[aliasKey] > 0 then
                            amount = stockLookup[aliasKey]
                            break
                        end
                    end
                end

                if amount > 0 then
                    readyCount = readyCount + 1
                end

                local statusTxt = amount > 0 and string.format("Stok: **x%d**", amount) or "❌ **SOLD OUT**"
                table.insert(fields, {
                    ["name"] = string.format("[%s] %s", item.tier, item.name),
                    ["value"] = statusTxt,
                    ["inline"] = true
                })
            end

            local sisaDetik = nextTime and math.max(0, math.floor(tonumber(nextTime) - workspace:GetServerTimeNow())) or 0
            local countdownTxt = string.format("%d menit %d detik", math.floor(sisaDetik / 60), sisaDetik % 60)

            sendWebhook(
                "🥚 Egg Shop Restocked",
                string.format("Ready: **%d/%d Telur** | Restock lagi dalam: **%s**", readyCount, #EGG_LIST, countdownTxt),
                fields,
                15844367
            )
        end
    end)
    eggRemote:FireServer("Get")
end
