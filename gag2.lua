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
local TabFarm = Window:AddMainTab("🚜 Farm", false)
local SecFarm = TabFarm:AddSection("Auto Harvest Settings", false)

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
-- 6. MENU AUTO PLANT (BRUTAL SPEED)
-- ==========================================
local SecPlant = TabFarm:AddSection("Auto Plant Settings", false)

local SelectedSeeds = {}
local PlantMode = "Random"
local AutoPlantOn = false

-- 1. Seeds to Plant (Dropdown Multi-Select)
SecPlant:AddDropdown({ 
    Title = "Seeds to Plant", 
    Content = "Select which seeds to plant", 
    Multi = true, 
    Options = ListCropsGameBaru, 
    Default = {}, 
    Callback = function(Opt) 
        SelectedSeeds = Opt 
    end 
})

-- 2. Plant Mode
SecPlant:AddDropdown({ 
    Title = "Plant Mode", 
    Content = "Random: plants at a random available spot", 
    Multi = false, 
    Options = {"Random", "Sequential", "Closest"}, 
    Default = {"Random"}, 
    Callback = function(Opt) 
        PlantMode = type(Opt) == "table" and Opt[1] or Opt
    end 
})

-- 3. Toggle Auto Plant
SecPlant:AddToggle({ 
    Title = "▶️ ENABLE AUTO PLANT", 
    Content = "Automatically plants the selected seeds at 0.1s delay.",
    Default = false, 
    Callback = function(Value) 
        AutoPlantOn = Value
        if AutoPlantOn then
            Speed_Library:SetNotification({Title = "Sistem Tanam", Content = "Auto Plant Brutal Mode Aktif!", Time = 2})
        end
    end 
})

-- ==========================================
-- 7. MESIN AUTO PLANT (SMART EQUIP & LOOP 0.1S)
-- ==========================================
local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"))

task.spawn(function()
    while task.wait(0.05) do -- Scan kebun berjalan sangat cepat
        if AutoPlantOn and #SelectedSeeds > 0 then
            
            local player = game.Players.LocalPlayer
            local char = player.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local backpack = player:FindFirstChild("Backpack")
            local plotId = player:GetAttribute("PlotId")
            
            if plotId and char and humanoid and backpack then
                local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. plotId)
                
                if myPlot then
                    local targetSeedName = SelectedSeeds[math.random(#SelectedSeeds)]
                    local seedTool = nil
                    
                    -- Radar Pencari Bibit
                    local function cariBibit(wadah)
                        for _, item in ipairs(wadah:GetChildren()) do
                            if item:IsA("Tool") then
                                local attrSeed = item:GetAttribute("SeedTool")
                                local attrCategory = item:GetAttribute("MainCategory")
                                
                                if (attrSeed and attrSeed == targetSeedName) or (item.Name == targetSeedName and attrCategory == "Seed") then
                                    return item
                                end
                            end
                        end
                        return nil
                    end
                    
                    local toolDiTangan = cariBibit(char)
                    seedTool = toolDiTangan or cariBibit(backpack)
                    
                    if seedTool then
                        -- Sistem Smart Equip (Hanya ganti tool jika jenis bibit berbeda)
                        if not toolDiTangan then
                            humanoid:UnequipTools() 
                            task.wait(0.02)
                            
                            humanoid:EquipTool(seedTool)
                            if seedTool.Parent ~= char then
                                seedTool.Parent = char 
                            end
                            
                            local timeout = 0
                            while seedTool.Parent ~= char and timeout < 10 do
                                task.wait(0.02)
                                timeout = timeout + 1
                            end
                        end
                        
                        local seedAttr = seedTool:GetAttribute("SeedTool")
                        
                        -- Eksekusi Tanam
                        if seedTool.Parent == char and seedAttr then
                            local plantAreas = {}
                            for _, desc in ipairs(myPlot:GetDescendants()) do
                                if game:GetService("CollectionService"):HasTag(desc, "PlantArea") then
                                    table.insert(plantAreas, desc)
                                end
                            end
                            
                            if #plantAreas > 0 then
                                local targetArea = plantAreas[math.random(#plantAreas)]
                                local randomX = targetArea.Position.X + math.random(-2, 2)
                                local randomZ = targetArea.Position.Z + math.random(-2, 2)
                                local plantPos = Vector3.new(randomX, targetArea.Position.Y, randomZ)
                                
                                pcall(function()
                                    Networking.Plant.PlantSeed:Fire(plantPos, seedAttr, seedTool)
                                end)
                                
                                -- ⏱️ Kunci kecepatan tanam di pas 0.1 detik per tanaman!
                                task.wait(0.1)
                            end
                        end
                    else
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end)
-- ==========================================
-- 4. TAB SHOP (AUTO SELL INVENTORY)
-- ==========================================
local TabShop = Window:AddMainTab("🛒 Shop", false)
local SecShop = TabShop:AddSection("Sell", false)

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


-- ==========================================
-- 8. MENU AUTO BUY SEEDS (FIX MULTI-SELECT BUG)
-- ==========================================

local SecBuy = TabShop:AddSection("Shop", false)

local SelectMode = "By Rarity"
local SelectedRarities = {"Common"} -- Diubah ke format array murni
local SelectedSeeds = {"Carrot"}
local AutoBuyOn = false

local DropdownSeedName

-- 1. Seed Select by
SecBuy:AddDropdown({ 
    Title = "Seed Select by", 
    Content = "Choose which seeds to buy", 
    Multi = false, 
    Options = {"By Rarity", "By Name"},
    Default = {"By Rarity"}, 
    Callback = function(Opt) 
        SelectMode = type(Opt) == "table" and Opt[1] or Opt
    end 
})

-- 2. Seed Rarity
SecBuy:AddDropdown({ 
    Title = "Seed Rarity", 
    Content = "Buy seeds from these rarities", 
    Multi = true, 
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"},
    Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedRarities = type(Opt) == "table" and Opt or {Opt}
        
        -- Membangun ulang daftar bibit sesuai rarity
        local combinedList = {}
        for key, value in pairs(SelectedRarities) do
            -- 🛠️ Deteksi pintar untuk mengatasi perbedaan output UI
            local rarityName = type(key) == "number" and value or key
            local isChecked = type(key) == "number" and true or value
            
            if isChecked and DatabaseMentah[rarityName] then
                for _, seed in ipairs(DatabaseMentah[rarityName]) do
                    table.insert(combinedList, seed)
                end
            end
        end
        
        -- Update dropdown bawah
        if #combinedList > 0 then
            pcall(function() DropdownSeedName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownSeedName:SetOptions(combinedList) end)
            SelectedSeeds = {combinedList[1]}
        end
    end 
})

-- 3. Seed Name
DropdownSeedName = SecBuy:AddDropdown({ 
    Title = "Seed Name", 
    Content = "Buy these seed names", 
    Multi = true, 
    Options = DatabaseMentah["Common"], 
    Default = {"Carrot"}, 
    Callback = function(Opt) 
        SelectedSeeds = type(Opt) == "table" and Opt or {Opt}
    end 
})

-- 4. Toggle Auto Buy
SecBuy:AddToggle({ 
    Title = "Auto Buy Seed", 
    Content = "Keeps buying matching seeds",
    Default = false, 
    Callback = function(Value) 
        AutoBuyOn = Value
    end 
})

-- ==========================================
-- 9. MESIN AUTO BUY (FIX PEMBACA ARRAY)
-- ==========================================
task.spawn(function()
    local Networking = nil
    
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("ModuleScript") and obj.Name == "Networking" then
            local success, modul = pcall(require, obj)
            if success and type(modul) == "table" and modul.SeedShop then
                Networking = modul
                break
            end
        end
    end

    if not Networking then return end
    
    while task.wait(0.2) do 
        if AutoBuyOn then
            pcall(function()
                local poolSeeds = {}
                
                if SelectMode == "By Rarity" then
                    for key, value in pairs(SelectedRarities) do
                        local rarityName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and DatabaseMentah[rarityName] then
                            for _, seed in ipairs(DatabaseMentah[rarityName]) do
                                table.insert(poolSeeds, seed)
                            end
                        end
                    end
                else
                    for key, value in pairs(SelectedSeeds) do
                        local seedName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and seedName ~= "" then
                            table.insert(poolSeeds, seedName)
                        end
                    end
                end
                
                -- Eksekusi pembelian secara acak dari keranjang
                if #poolSeeds > 0 then
                    local seedToBuy = poolSeeds[math.random(#poolSeeds)]
                    if seedToBuy then
                        Networking.SeedShop.PurchaseSeed:Fire(seedToBuy)
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 10. MENU AUTO BUY GEAR (MULTI-SELECT & BY RARITY)
-- ==========================================
-- 🛠️ Database alat (Gear) resmi dikelompokkan sesuai Rarity
local DatabaseGearMentah = {
    Common = {"Common Watering Can", "Common Sprinkler", "Sign"},
    Uncommon = {"Uncommon Sprinkler"},
    Rare = {"Lantern", "Rare Sprinkler", "Trowel", "Speed Mushroom", "Jump Mushroom"},
    Epic = {"Gnome", "Shrink Mushroom", "Supersize Mushroom", "Basic Pot", "Flashbang"},
    Legendary = {"Legendary Sprinkler", "Wheelbarrow", "Teleporter", "Invisibility Mushroom"},
    Super = {"Super Sprinkler", "Super Watering Can"}
}

local SecGear = TabShop:AddSection("Auto Buy Gear", false)

local SelectModeGear = "By Rarity"
local SelectedGearRarities = {"Common"}
local SelectedGears = {"Common Watering Can"}
local AutoBuyGearOn = false

local DropdownGearName -- Deklarasi awal

-- 1. Gear Select by
SecGear:AddDropdown({ 
    Title = "Gear Select by", 
    Content = "Choose which gear should be bought", 
    Multi = false, 
    Options = {"By Rarity", "By Name"},
    Default = {"By Rarity"}, 
    Callback = function(Opt) 
        SelectModeGear = type(Opt) == "table" and Opt[1] or Opt
    end 
})

-- 2. Gear Rarity (Multi-Select)
SecGear:AddDropdown({ 
    Title = "Gear Rarity", 
    Content = "Buy gear from this rarity", 
    Multi = true, 
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Super"},
    Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedGearRarities = type(Opt) == "table" and Opt or {Opt}
        
        -- Membangun ulang daftar Gear sesuai rarity yang dicentang
        local combinedList = {}
        for key, value in pairs(SelectedGearRarities) do
            local rarityName = type(key) == "number" and value or key
            local isChecked = type(key) == "number" and true or value
            
            if isChecked and DatabaseGearMentah[rarityName] then
                for _, gear in ipairs(DatabaseGearMentah[rarityName]) do
                    table.insert(combinedList, gear)
                end
            end
        end
        
        -- Update dropdown nama Gear secara otomatis
        if #combinedList > 0 then
            pcall(function() DropdownGearName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownGearName:SetOptions(combinedList) end)
            SelectedGears = {combinedList[1]}
        end
    end 
})

-- 3. Gear Name (Multi-Select)
DropdownGearName = SecGear:AddDropdown({ 
    Title = "Gear Name", 
    Content = "Buy these gear names", 
    Multi = true, 
    Options = DatabaseGearMentah["Common"], 
    Default = {"Common Watering Can"}, 
    Callback = function(Opt) 
        SelectedGears = type(Opt) == "table" and Opt or {Opt}
    end 
})

-- 4. Toggle Auto Buy Gear
SecGear:AddToggle({ 
    Title = "Auto Buy Gear", 
    Content = "Keeps buying matching gear when affordable",
    Default = false, 
    Callback = function(Value) 
        AutoBuyGearOn = Value
    end 
})

-- ==========================================
-- 11. MESIN AUTO BUY GEAR (DUAL MODE FIX)
-- ==========================================
task.spawn(function()
    local Networking = nil
    
    -- Pelacak Dinamis Modul Networking
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("ModuleScript") and obj.Name == "Networking" then
            local success, modul = pcall(require, obj)
            if success and type(modul) == "table" and modul.GearShop then
                Networking = modul
                break
            end
        end
    end

    if not Networking then return end
    
    while task.wait(0.5) do -- Delay aman 0.5 detik
        if AutoBuyGearOn then
            pcall(function()
                local poolGears = {}
                
                if SelectModeGear == "By Rarity" then
                    -- Ambil semua gear dari kategori rarity yang dicentang
                    for key, value in pairs(SelectedGearRarities) do
                        local rarityName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and DatabaseGearMentah[rarityName] then
                            for _, gear in ipairs(DatabaseGearMentah[rarityName]) do
                                table.insert(poolGears, gear)
                            end
                        end
                    end
                else
                    -- Ambil semua nama gear yang dicentang
                    for key, value in pairs(SelectedGears) do
                        local gearName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and gearName ~= "" then
                            table.insert(poolGears, gearName)
                        end
                    end
                end
                
                -- Eksekusi pembelian secara acak dari keranjang belanja
                if #poolGears > 0 then
                    local gearToBuy = poolGears[math.random(#poolGears)]
                    if gearToBuy then
                        Networking.GearShop.PurchaseGear:Fire(gearToBuy)
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 12. MENU AUTO BUY PROPS (MULTI-SELECT & BY RARITY)
-- ==========================================
-- 🛠️ Database Prop Sementara (HARAP GANTI DENGAN NAMA PROP ASLI DI GAME)
local DatabasePropMentah = {
    Common = {"Ladder Crate"},
    Uncommon = {"Bench Crate", "Light Crate"},
    Rare = {"Sign Crate", "Arch Crate", "Roleplay Crate"},
    Epic = {"Bridge Crate", "Spring Crate", "Seesaw Crate", "Conveyor Crate"},
    Legendary = {"Owner Door Crate", "Bear Trap Crate", "Fence Crate"},
    Mythic = {"Teleporter Pad Crate"}
}

local SecProp = TabShop:AddSection("Auto Buy Props", false)

local SelectModeProp = "By Rarity"
local SelectedPropRarities = {"Common"}
local SelectedProps = {"Ladder Crate"}
local AutoBuyPropOn = false

local DropdownPropName -- Deklarasi awal

-- 1. Prop Select by
SecProp:AddDropdown({ 
    Title = "Prop Select by", 
    Content = "Choose which props should be bought", 
    Multi = false, 
    Options = {"By Rarity", "By Name"},
    Default = {"By Rarity"}, 
    Callback = function(Opt) 
        SelectModeProp = type(Opt) == "table" and Opt[1] or Opt
    end 
})

-- 2. Prop Rarity (Multi-Select)
SecProp:AddDropdown({ 
    Title = "Prop Rarity", 
    Content = "Buy props from this rarity", 
    Multi = true, 
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"},
    Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedPropRarities = type(Opt) == "table" and Opt or {Opt}
        
        -- Membangun ulang daftar Prop sesuai rarity yang dicentang
        local combinedList = {}
        for key, value in pairs(SelectedPropRarities) do
            local rarityName = type(key) == "number" and value or key
            local isChecked = type(key) == "number" and true or value
            
            if isChecked and DatabasePropMentah[rarityName] then
                for _, prop in ipairs(DatabasePropMentah[rarityName]) do
                    table.insert(combinedList, prop)
                end
            end
        end
        
        -- Update dropdown nama Prop secara otomatis
        if #combinedList > 0 then
            pcall(function() DropdownPropName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownPropName:SetOptions(combinedList) end)
            SelectedProps = {combinedList[1]}
        end
    end 
})

-- 3. Prop Name (Multi-Select)
DropdownPropName = SecProp:AddDropdown({ 
    Title = "Prop Name", 
    Content = "Buy these prop names", 
    Multi = true, 
    Options = DatabasePropMentah["Common"], 
    Default = {"Ladder Crate"}, 
    Callback = function(Opt) 
        SelectedProps = type(Opt) == "table" and Opt or {Opt}
    end 
})

-- 4. Toggle Auto Buy Prop
SecProp:AddToggle({ 
    Title = "Auto Buy Prop", 
    Content = "Keeps buying matching props when affordable",
    Default = false, 
    Callback = function(Value) 
        AutoBuyPropOn = Value
    end 
})

-- ==========================================
-- 13. MESIN AUTO BUY PROPS (FIX JALUR KE CRATESHOP)
-- ==========================================
task.spawn(function()
    local Networking = nil
    
    -- Pelacak Dinamis Modul Networking
    for _, obj in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if obj:IsA("ModuleScript") and obj.Name == "Networking" then
            local success, modul = pcall(require, obj)
            -- FIX: Mencari modul CrateShop, bukan PropShop!
            if success and type(modul) == "table" and modul.CrateShop then
                Networking = modul
                break
            end
        end
    end

    if not Networking then return end
    
    while task.wait(0.5) do
        if AutoBuyPropOn then
            pcall(function()
                local poolProps = {}
                
                if SelectModeProp == "By Rarity" then
                    for key, value in pairs(SelectedPropRarities) do
                        local rarityName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and DatabasePropMentah[rarityName] then
                            for _, prop in ipairs(DatabasePropMentah[rarityName]) do
                                table.insert(poolProps, prop)
                            end
                        end
                    end
                else
                    for key, value in pairs(SelectedProps) do
                        local propName = type(key) == "number" and value or key
                        local isChecked = type(key) == "number" and true or value
                        
                        if isChecked and propName ~= "" then
                            table.insert(poolProps, propName)
                        end
                    end
                end
                
                -- Eksekusi pembelian secara acak dari keranjang belanja
                if #poolProps > 0 then
                    local propToBuy = poolProps[math.random(#poolProps)]
                    if propToBuy then
                        -- FIX: Jalur yang benar adalah CrateShop.PurchaseCrate
                        Networking.CrateShop.PurchaseCrate:Fire(propToBuy)
                    end
                end
            end)
        end
    end
end)

-- ==========================================
-- 14. SISTEM ANTI-AFK (FIXED)
-- ==========================================
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local AntiAFKOn = true
LocalPlayer.Idled:Connect(function()
    if AntiAFKOn then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[Gery Hub] Anti-AFK mencegah kick!")
    end
end)
