-- ==========================================
-- GERY HUB (AUTO FARM) - MENGGUNAKAN MALAS.LUA
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/cunobot/refs/heads/main/Malas.lua"))()

local Window = Speed_Library:CreateWindow({
    Title = "Gery Hub - Auto Farm",
    SizeUi = UDim2.fromOffset(580, 340)
})

-- ==========================================
-- 1. DATABASE CROPS & RARITY (GAMPANG DIEDIT)
-- ==========================================
local DatabaseMentah = {
    Common = {"Carrot", "Strawberry", "Blueberry"},
    Uncommon = {"Tulip", "Tomato", "Apple"},
    Rare = {"Bamboo", "Corn", "Cactus", "Pineapple", "Horned Melon", "Baby Cactus"},
    Epic = {"Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Mango", "Glow Mushroom"},
    Legendary = {"Dragon Fruit", "Acorn", "Cherry", "Sunflower", "Poison Ivy", "Gold"},
    Mythic = {"Venus Fly Trap", "Pomegranate", "Poison Apple", "Ghost Pepper", "Romanesco", "Rainbow"},
    Super = {"Moon Bloom", "Dragon's Breath"}
}

-- Sistem Auto-Converter (Agar Radar tetap ngebut memproses data)
local CropDatabase = {}
local ListCropsGameBaru = {}

for rarity, listCrops in pairs(DatabaseMentah) do
    for _, cropName in ipairs(listCrops) do
        CropDatabase[cropName] = rarity -- Menyimpan data untuk Radar
        table.insert(ListCropsGameBaru, cropName) -- Menyimpan data untuk UI Dropdown
    end
end
table.sort(ListCropsGameBaru) -- Urutkan nama tanaman sesuai abjad A-Z untuk Dropdown

local ListMutasi = {"Big", "Bigger", "Biggest", "Beast", "Shadow", "Gold", "Golden", "Rainbow", "Corrupted"}

-- Variabel Penyimpan Pilihan UI
local FilterMode = "By Name"
local TargetRarity = {}
local TargetName = {}
local TargetBlacklist = {}
local AutoFarmAktif = false
local AutoHarvestAll = false -- Variabel baru untuk mode sapu bersih

-- ==========================================
-- 2. PEMBUATAN TAB FARMING
-- ==========================================
local TabFarm = Window:AddMainTab("🚜 Farm", true)
local SecFarm = TabFarm:AddSection("Auto Harvest Settings", true)

-- Dropdown 1: Harvest Select By
SecFarm:AddDropdown({ 
    Title = "Harvest Select by", 
    Content = "Choose how crops are harvested", 
    Multi = false, 
    Options = {"By Name", "By Rarity", "Both (Name & Rarity)"}, 
    Default = {"By Name"}, 
    Callback = function(Opt) 
        FilterMode = type(Opt) == "table" and Opt[1] or Opt
    end 
})

-- Dropdown 2: Harvest Rarity
SecFarm:AddDropdown({ 
    Title = "Harvest Rarity", 
    Content = "Collect crops from this rarity", 
    Multi = true, 
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, 
    Default = {}, 
    Callback = function(Opt) TargetRarity = Opt end 
})

-- Dropdown 3: Harvest Name
SecFarm:AddDropdown({ 
    Title = "Harvest Name", 
    Content = "Collect this specific crop", 
    Multi = true, 
    Options = ListCropsGameBaru, 
    Default = {}, 
    Callback = function(Opt) TargetName = Opt end 
})

-- Dropdown 4: Blacklist Mutation
SecFarm:AddDropdown({ 
    Title = "Blacklist Mutation", 
    Content = "Ignore fruits with selected mutation", 
    Multi = true, 
    Options = ListMutasi, 
    Default = {}, 
    Callback = function(Opt) TargetBlacklist = Opt end 
})

-- Tombol Eksekusi
SecFarm:AddLine()

-- Toggle 1: Mematuhi Filter
SecFarm:AddToggle({ 
    Title = "▶️ ENABLE FILTERED HARVEST", 
    Content = "Start farming based on filters above",
    Default = false, 
    Callback = function(Value) 
        AutoFarmAktif = Value
    end 
})

-- Toggle 2: Sapu Bersih (Mengabaikan Filter)
SecFarm:AddToggle({ 
    Title = "▶️ ENABLE AUTO HARVEST ALL", 
    Content = "IGNORE FILTERS! Harvest ALL crops in garden",
    Default = false, 
    Callback = function(Value) 
        AutoHarvestAll = Value
        if Value then
            Speed_Library:SetNotification({Title = "Mode Brutal", Content = "Auto Harvest ALL Menyala!", Time = 2})
        end
    end 
})

-- ==========================================
-- 3. OTAK RADAR (GHOST HARVEST VIA UUID/PLANT ID)
-- ==========================================
local PromptCooldowns = {} 

-- Membajak modul Networking asli bawaan gamenya
local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"))

task.spawn(function()
    while task.wait(0.1) do -- Kecepatan Scan
        if AutoFarmAktif or AutoHarvestAll then 
            local prompts = game:GetService("CollectionService"):GetTagged("HarvestPrompt")
            
            for _, prompt in ipairs(prompts) do
                if not (AutoFarmAktif or AutoHarvestAll) then break end 
                
                -- Lewati prompt jika baru saja dieksekusi (Cooldown 3 detik)
                if PromptCooldowns[prompt] and (os.clock() - PromptCooldowns[prompt] < 3) then
                    continue
                end
                
                if prompt.Enabled and prompt.Parent and prompt.Parent.Parent then
                    local plantModel = prompt.Parent.Parent
                    local namaTanamanDiGame = plantModel.Name
                    
                    local bolehPanen = false
                    
                    -- JIKA TOGGLE "HARVEST ALL" NYALA, LANGSUNG PANEN
                    if AutoHarvestAll then
                        bolehPanen = true
                    
                    -- JIKA "HARVEST ALL" MATI TAPI "FILTERED HARVEST" NYALA, GUNAKAN RADAR FILTER
                    elseif AutoFarmAktif then
                        local isBlacklisted = false
                        local baseName = namaTanamanDiGame
                        
                        -- 1. BEDAH NAMA MUTASI
                        for _, mut in ipairs(ListMutasi) do
                            if string.find(string.lower(namaTanamanDiGame), string.lower(mut)) then
                                baseName = string.gsub(namaTanamanDiGame, mut .. " ", "")
                                baseName = string.gsub(baseName, mut, "")
                                
                                if TargetBlacklist and table.find(TargetBlacklist, mut) then
                                    isBlacklisted = true
                                end
                                break
                            end
                        end
                        
                        baseName = string.match(baseName, "^%s*(.-)%s*$") or baseName
                        
                        -- 2. PENYARINGAN (FILTERING)
                        if not isBlacklisted then
                            local rarityTanaman = CropDatabase[baseName] or "Unknown"
                            
                            local masukRarity = TargetRarity and table.find(TargetRarity, rarityTanaman) ~= nil
                            local masukName   = TargetName and table.find(TargetName, baseName) ~= nil
                            
                            if FilterMode == "By Rarity" and masukRarity then
                                bolehPanen = true
                            elseif FilterMode == "By Name" and masukName then
                                bolehPanen = true
                            elseif FilterMode == "Both (Name & Rarity)" and (masukRarity and masukName) then
                                bolehPanen = true
                            end
                        end
                    end
                    
                    -- 3. EKSEKUSI GHOST HARVEST VIA UUID
                    if bolehPanen then
                        PromptCooldowns[prompt] = os.clock()
                        
                        -- Ambil UUID (PlantId & FruitId) asli dari model tanaman
                        local plantId = plantModel:GetAttribute("PlantId")
                        local fruitId = plantModel:GetAttribute("FruitId") or ""
                        
                        if plantId then
                            task.spawn(function()
                                pcall(function()
                                    -- Tembak sinyal langsung ke jantung server game! (Tanpa klik & tanpa teleport)
                                    Networking.Garden.CollectFruit:Fire(plantId, fruitId)
                                end)
                            end)
                            
                            -- Jeda super cepat (0.05 detik), aman banget karena tidak ada pergerakan karakter
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end
end)

-- Pembersih Memori Anti-Bocor
task.spawn(function()
    while task.wait(10) do
        local waktuSekarang = os.clock()
        for p, waktu in pairs(PromptCooldowns) do
            if waktuSekarang - waktu > 3 then
                PromptCooldowns[p] = nil
            end
        end
    end
end)

-- ==========================================
-- 4. TAB SHOP (AUTO SELL INVENTORY)
-- ==========================================
local TabShop = Window:AddMainTab("🛒 Shop", false)
local SecShop = TabShop:AddSection("Sell", true)

local SellInterval = 60
local AutoSellTimerOn = false
local AutoSellFullOn = false

-- 1. Slider Auto Sell Timer (Sesuai gambar)
SecShop:AddSlider({
    Title = "Sell Timer (s)",
    Content = "How often (in seconds) to sell all fruits automatically.",
    Min = 10,
    Max = 600,
    Increment = 1,
    Default = 60,
    Callback = function(Value)
        SellInterval = Value
    end
})

-- 2. Toggle Auto Sell By Timer
SecShop:AddToggle({
    Title = "Auto Sell by Timer",
    Content = "Sells all fruits on a timed interval.",
    Default = false,
    Callback = function(Value)
        AutoSellTimerOn = Value
    end
})

-- 3. Toggle Auto Sell if Backpack Full
SecShop:AddToggle({
    Title = "Auto Sell if Backpack Full",
    Content = "Automatically sells all fruits when your backpack reaches max capacity.",
    Default = false,
    Callback = function(Value)
        AutoSellFullOn = Value
    end
})

-- ==========================================
-- 5. MESIN GHOST SELL (TANPA TELEPORT)
-- ==========================================
-- Memanggil modul jaringan asli dari game untuk dieksploitasi
local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"))

local function EksekusiGhostSell()
    pcall(function()
        -- Jual paksa semua isi inventory ke server!
        local hasilSell = Networking.NPCS.SellAll:Fire()
    end)
end

-- ⚙️ MESIN 1: BERDASARKAN TIMER (SLIDER)
task.spawn(function()
    local timerHitung = 0
    while task.wait(1) do
        if AutoSellTimerOn then
            timerHitung = timerHitung + 1
            if timerHitung >= SellInterval then
                EksekusiGhostSell()
                timerHitung = 0 -- Reset timer setelah berhasil jual
            end
        else
            timerHitung = 0
        end
    end
end)

-- ⚙️ MESIN 2: BERDASARKAN TAS PENUH (SADAP CCTV DARI DEX EXPLORER)
getgenv().TasPenuh = false

task.spawn(function()
    local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- [UPDATE] Path disesuaikan dengan wujud asli di Dex Explorer
    local FrameFolder = PlayerGui:WaitForChild("TopNotification"):WaitForChild("Frame")
    
    -- Membaca notifikasi game secara diam-diam saat muncul
    FrameFolder.ChildAdded:Connect(function(node)
        task.wait(0.1)
        
        -- Membaca teks asli dari atribut "OG"
        local textOG = node:GetAttribute("OG")
        
        -- [UPDATE] Kata kunci disesuaikan dengan "Your inventory is full"
        if textOG and string.find(string.lower(textOG), "your inventory is full") then
            getgenv().TasPenuh = true
        end
    end)
end)

-- Mesin Eksekutor (Menunggu Sinyal CCTV)
task.spawn(function()
    while task.wait(1) do
        -- Jika CCTV mendeteksi teks tas penuh...
        if getgenv().TasPenuh then
            -- Cek apakah toggle Auto Sell Full di Menu sedang dinyalakan
            if AutoSellFullOn then
                EksekusiGhostSell()
                task.wait(2) -- Jeda aman agar server tidak kaget
            end
            getgenv().TasPenuh = false -- Reset alarm CCTV setelah jualan
        end
    end
end)
