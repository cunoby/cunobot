-- ==========================================
-- 👑 GERY HUB (GOD MODE EDITION) 
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/cunobot/refs/heads/main/Malas.lua"))()

local Window = Speed_Library:CreateWindow({
    Title = "Gery Hub - God Mode",
    SizeUi = UDim2.fromOffset(580, 340)
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. DATABASE & CACHE
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

local DatabaseGearMentah = {
    Common = {"Common Watering Can", "Common Sprinkler", "Sign"},
    Uncommon = {"Uncommon Sprinkler"},
    Rare = {"Lantern", "Rare Sprinkler", "Trowel", "Speed Mushroom", "Jump Mushroom"},
    Epic = {"Gnome", "Shrink Mushroom", "Supersize Mushroom", "Basic Pot", "Flashbang"},
    Legendary = {"Legendary Sprinkler", "Wheelbarrow", "Teleporter", "Invisibility Mushroom"},
    Super = {"Super Sprinkler", "Super Watering Can"}
}

local DatabasePropMentah = {
    Common = {"Ladder Crate"},
    Uncommon = {"Bench Crate", "Light Crate"},
    Rare = {"Sign Crate", "Arch Crate", "Roleplay Crate"},
    Epic = {"Bridge Crate", "Spring Crate", "Seesaw Crate", "Conveyor Crate"},
    Legendary = {"Owner Door Crate", "Bear Trap Crate", "Fence Crate"},
    Mythic = {"Teleporter Pad Crate"}
}

local ListMutasi = {"Big", "Bigger", "Biggest", "Beast", "Shadow", "Gold", "Golden", "Rainbow", "Corrupted"}

local CropDatabase = {}
local ListCropsGameBaru = {}

for rarity, listCrops in pairs(DatabaseMentah) do
    for _, cropName in ipairs(listCrops) do
        CropDatabase[cropName] = rarity
        table.insert(ListCropsGameBaru, cropName)
    end
end
table.sort(ListCropsGameBaru)

-- ==========================================
-- 2. SETUP MODUL JARINGAN SERVER (GLOBAL)
-- ==========================================
local Networking = nil
local GardenSyncController = nil
local FruitsDB = nil
local BaseWeightCache = {}

-- Bypass Networking Game
for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("ModuleScript") and obj.Name == "Networking" then
        pcall(function() Networking = require(obj) end)
        break
    end
end

-- Bypass Pengendali Berat & Overtime
for _, obj in ipairs(LocalPlayer.PlayerScripts:GetDescendants()) do
    if obj:IsA("ModuleScript") and obj.Name == "GardenSyncController" then
        pcall(function() GardenSyncController = require(obj) end)
    end
end
if not GardenSyncController then
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("ModuleScript") and obj.Name == "GardenSyncController" then
            pcall(function() GardenSyncController = require(obj) end)
        end
    end
end

local PlantDB = ReplicatedStorage:FindFirstChild("PlantGenerationModules") 
FruitsDB = PlantDB and PlantDB:FindFirstChild("Fruits")


-- ==========================================
-- 3. TAB 1: 🚜 FARMING
-- ==========================================
local TabFarm = Window:AddMainTab("🚜 Farm", false)

-- [ A. AUTO HARVEST GOD MODE (FIXED: MULTI & SINGLE HARVEST) ]
local SecFarm = TabFarm:AddSection("Auto Harvest Settings", false)
local FilterMode = "By Name"
local TargetRarity, TargetName, TargetBlacklist = {}, {}, {}
local AutoFarmAktif, AutoHarvestAll = false, false

SecFarm:AddDropdown({ Title = "Harvest Select by", Options = {"By Name", "By Rarity", "Both (Name & Rarity)"}, Default = {"By Name"}, Callback = function(Opt) FilterMode = type(Opt) == "table" and Opt[1] or Opt end })
SecFarm:AddDropdown({ Title = "Harvest Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Callback = function(Opt) TargetRarity = Opt end })
SecFarm:AddDropdown({ Title = "Harvest Name", Multi = true, Options = ListCropsGameBaru, Callback = function(Opt) TargetName = Opt end })
SecFarm:AddDropdown({ Title = "Blacklist Mutation", Multi = true, Options = ListMutasi, Callback = function(Opt) TargetBlacklist = Opt end })
SecFarm:AddLine()
SecFarm:AddToggle({ Title = "▶️ ENABLE FILTERED HARVEST", Default = false, Callback = function(Value) AutoFarmAktif = Value end })
SecFarm:AddToggle({ 
    Title = "▶️ ENABLE AUTO HARVEST ALL", 
    Default = false, 
    Callback = function(Value) 
        AutoHarvestAll = Value
        if Value then Speed_Library:SetNotification({Title = "God Mode", Content = "Auto Harvest ALL Menyala!", Time = 2}) end
    end 
})

task.spawn(function()
    while task.wait(0.5) do
        if (AutoFarmAktif or AutoHarvestAll) and Networking then 
            local myPlotId = LocalPlayer:GetAttribute("PlotId")
            if not myPlotId then continue end
            
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(myPlotId))
            local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
            
            if plantsFolder then
                for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                    local plantId = plantModel:GetAttribute("PlantId")
                    if not plantId then continue end

                    -- FUNGSI KECIL UNTUK CEK DAN PANEN
                    local function CekDanPanen(objTarget, fId)
                        local age = objTarget:GetAttribute("Age")
                        local maxAge = objTarget:GetAttribute("MaxAge")
                        
                        -- Cek apakah umurnya sudah mencapai maxAge (Matang)
                        if age and maxAge and age >= maxAge then
                            local namaTanaman = objTarget:GetAttribute("CorePartName") or plantModel.Name
                            local bolehPanen = false
                            
                            if AutoHarvestAll then
                                bolehPanen = true
                            elseif AutoFarmAktif then
                                local isBlacklisted = false
                                local mutation = objTarget:GetAttribute("Mutation")
                                if mutation and TargetBlacklist and table.find(TargetBlacklist, mutation) then isBlacklisted = true end
                                
                                if not isBlacklisted then
                                    local rarity = CropDatabase[namaTanaman] or "Unknown"
                                    local masukRarity = TargetRarity and table.find(TargetRarity, rarity)
                                    local masukName = TargetName and table.find(TargetName, namaTanaman)
                                    
                                    if FilterMode == "By Rarity" and masukRarity then bolehPanen = true
                                    elseif FilterMode == "By Name" and masukName then bolehPanen = true
                                    elseif FilterMode == "Both (Name & Rarity)" and (masukRarity and masukName) then bolehPanen = true end
                                end
                            end
                            
                            if bolehPanen then
                                pcall(function() Networking.Garden.CollectFruit:Fire(plantId, fId) end)
                                task.wait(0.05) -- Jeda aman agar tidak nge-lag
                            end
                        end
                    end

                    -- 1. CEK TIPE CABUT (Single-Harvest seperti Carrot/Tulip)
                    -- Biasanya buah tipe ini tidak punya fruitId, jadi kita kirim teks kosong ""
                    CekDanPanen(plantModel, "")

                    -- 2. CEK TIPE POHON (Multi-Harvest seperti Apple/Tomato)
                    local fruitsFolder = plantModel:FindFirstChild("Fruits")
                    if fruitsFolder then
                        for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                            local fruitId = fruit:GetAttribute("FruitId") or fruit.Name
                            CekDanPanen(fruit, fruitId)
                        end
                    end
                    
                end
            end
        end
    end
end)

-- ==========================================
-- [ B. AUTO PLANT (DUAL MODE) ]
-- ==========================================
local SecPlant = TabFarm:AddSection("Auto Plant Settings", false)
local SelectedSeeds, PlantMode, AutoPlantOn = {}, "Random Area", false

-- 1. Pilih Bibit
SecPlant:AddDropdown({ 
    Title = "Seeds to Plant", 
    Multi = true, 
    Options = ListCropsGameBaru, 
    Callback = function(Opt) SelectedSeeds = Opt end 
})

-- 2. Pilih Mode Penanaman (🌟 FITUR BARU)
SecPlant:AddDropdown({ 
    Title = "Plant Position Mode", 
    Content = "Pilih lokasi di mana bibit akan ditanam",
    Multi = false, 
    Options = {"Random Area", "At Character Position"}, 
    Default = {"Random Area"}, 
    Callback = function(Opt) PlantMode = type(Opt) == "table" and Opt[1] or Opt end 
})

-- 3. Eksekutor
SecPlant:AddToggle({ 
    Title = "▶️ ENABLE AUTO PLANT", 
    Default = false, 
    Callback = function(Value) 
        AutoPlantOn = Value
        if Value then Speed_Library:SetNotification({Title = "Sistem Tanam", Content = "Auto Plant ("..PlantMode..") Aktif!", Time = 2}) end
    end 
})

task.spawn(function()
    while task.wait(0.05) do
        if AutoPlantOn and #SelectedSeeds > 0 and Networking then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local plotId = LocalPlayer:GetAttribute("PlotId")
            
            if plotId and char and humanoid and backpack then
                local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                if myPlot then
                    local targetSeedName = SelectedSeeds[math.random(#SelectedSeeds)]
                    
                    local function cariBibit(wadah)
                        for _, item in ipairs(wadah:GetChildren()) do
                            if item:IsA("Tool") and (item:GetAttribute("SeedTool") == targetSeedName or (item.Name == targetSeedName and item:GetAttribute("MainCategory") == "Seed")) then
                                return item
                            end
                        end
                        return nil
                    end
                    
                    local toolDiTangan = cariBibit(char)
                    local seedTool = toolDiTangan or cariBibit(backpack)
                    
                    if seedTool then
                        -- Sistem Smart Equip
                        if not toolDiTangan then
                            humanoid:UnequipTools() 
                            task.wait(0.02)
                            humanoid:EquipTool(seedTool)
                            local timeout = 0
                            while seedTool.Parent ~= char and timeout < 10 do task.wait(0.02); timeout = timeout + 1 end
                        end
                        
                        local seedAttr = seedTool:GetAttribute("SeedTool")
                        if seedTool.Parent == char and seedAttr then
                            
                            local plantPos = nil
                            
                            -- 🌟 LOGIKA DUAL MODE
                            if PlantMode == "Random Area" then
                                -- MODE 1: Cari tanah acak di kebun
                                local plantAreas = {}
                                for _, desc in ipairs(myPlot:GetDescendants()) do
                                    if game:GetService("CollectionService"):HasTag(desc, "PlantArea") then 
                                        table.insert(plantAreas, desc) 
                                    end
                                end
                                
                                if #plantAreas > 0 then
                                    local targetArea = plantAreas[math.random(#plantAreas)]
                                    -- Ambil posisi acak di atas petak tanah target
                                    plantPos = Vector3.new(targetArea.Position.X + math.random(-2, 2), targetArea.Position.Y, targetArea.Position.Z + math.random(-2, 2))
                                end
                                
                            else
                                -- MODE 2: Tanam tepat di posisi kaki karakter saat ini
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    -- Kurangi koordinat Y sedikit agar menyentuh tanah secara natural
                                    plantPos = hrp.Position - Vector3.new(0, 3, 0)
                                end
                            end
                            
                            -- Eksekusi Tembakan ke Server
                            if plantPos then
                                pcall(function() Networking.Plant.PlantSeed:Fire(plantPos, seedAttr, seedTool) end)
                                task.wait(0.1) -- Jeda aman kecepatan tanam
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- [ C. AUTO SHOVEL FRUIT V6 (PERFECT NATIVE MATH) ]
local SecShovelFruit = TabFarm:AddSection("Auto Shovel Fruit", false)
local ShovelSelectBy = "By Rarity"
local TargetShovelRarity, TargetShovelName = {"Common"}, {"Carrot"}
local ShovelMinKG, AutoShovelFruitOn = 1, false
local DropdownShovelName

SecShovelFruit:AddDropdown({ Title = "Shovel Select by", Options = {"By Rarity", "By Name", "Both (Name & Rarity)"}, Default = {"By Rarity"}, Callback = function(Opt) ShovelSelectBy = type(Opt) == "table" and Opt[1] or Opt end })
SecShovelFruit:AddDropdown({ Title = "Shovel Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Default = {"Common"}, 
    Callback = function(Opt) 
        TargetShovelRarity = type(Opt) == "table" and Opt or {Opt}
        local combinedList = {}
        for key, value in pairs(TargetShovelRarity) do
            local rarityName = type(key) == "number" and value or key
            if (type(key) == "number" and true or value) and DatabaseMentah[rarityName] then
                for _, seed in ipairs(DatabaseMentah[rarityName]) do table.insert(combinedList, seed) end
            end
        end
        if #combinedList > 0 then
            pcall(function() DropdownShovelName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownShovelName:SetOptions(combinedList) end)
            TargetShovelName = {combinedList[1]}
        end
    end 
})
DropdownShovelName = SecShovelFruit:AddDropdown({ Title = "Shovel Name", Multi = true, Options = DatabaseMentah["Common"], Default = {"Carrot"}, Callback = function(Opt) TargetShovelName = type(Opt) == "table" and Opt or {Opt} end })
SecShovelFruit:AddInput({ Title = "Minimum KG", Default = "1", Numeric = true, Callback = function(Value) ShovelMinKG = tonumber(Value) or 1 end })
SecShovelFruit:AddToggle({ Title = "Auto Shovel Fruit", Default = false, Callback = function(Value) AutoShovelFruitOn = Value end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoShovelFruitOn and Networking then
            local char = LocalPlayer.Character
            if not char then continue end
            
            local shovelTool = char:FindFirstChild("Shovel")
            if not shovelTool then
                local backpackShovel = LocalPlayer.Backpack:FindFirstChild("Shovel")
                if backpackShovel and char:FindFirstChild("Humanoid") then
                    char.Humanoid:EquipTool(backpackShovel)
                    shovelTool = backpackShovel
                    task.wait(0.5) 
                elseif Networking.GearShop and Networking.GearShop.EquipGear then
                    Networking.GearShop.EquipGear:Fire("Shovel")
                    task.wait(0.5)
                    shovelTool = char:FindFirstChild("Shovel")
                end
            end
            
            if shovelTool then
                local shovelAttribute = shovelTool:GetAttribute("Shovel")
                if not shovelAttribute then continue end

                local targetFruits = {}
                if ShovelSelectBy == "By Rarity" then
                    for key, value in pairs(TargetShovelRarity) do
                        local rarityName = type(key) == "number" and value or key
                        if (type(key) == "number" and true or value) and DatabaseMentah[rarityName] then
                            for _, name in ipairs(DatabaseMentah[rarityName]) do targetFruits[name] = true end
                        end
                    end
                else
                    for key, value in pairs(TargetShovelName) do
                        local fruitName = type(key) == "number" and value or key
                        if type(key) == "number" and true or value then targetFruits[fruitName] = true end
                    end
                end
                
                local gardensFolder = workspace:FindFirstChild("Gardens")
                if not gardensFolder then continue end
                
                for _, object in ipairs(gardensFolder:GetDescendants()) do
                    local userId = tonumber(object:GetAttribute("UserId"))
                    local plantId = object:GetAttribute("PlantId")
                    local fruitId = object:GetAttribute("FruitId") or ""
                    local fruitName = object:GetAttribute("CorePartName")
                    local sizeMulti = object:GetAttribute("SizeMulti") or 1
                    
                    if userId == LocalPlayer.UserId and plantId and fruitName and targetFruits[fruitName] then
                        local distance = (object:GetPivot().Position - char:GetPivot().Position).Magnitude
                        
                        if distance <= 12 then
                            local baseWeight = BaseWeightCache[fruitName]
                            if not baseWeight and FruitsDB then
                                local fruitMod = FruitsDB:FindFirstChild(fruitName)
                                if fruitMod then
                                    local success, data = pcall(require, fruitMod)
                                    if success and data and data.GrowData and data.GrowData.BaseWeight then
                                        baseWeight = data.GrowData.BaseWeight
                                        BaseWeightCache[fruitName] = baseWeight
                                    end
                                end
                            end
                            
                            local overtimeGrowth = 1
                            if GardenSyncController then
                                pcall(function()
                                    local plantData = GardenSyncController:GetPlant(userId, plantId)
                                    if plantData and plantData.Fruits and plantData.Fruits[fruitId] then
                                        overtimeGrowth = plantData.Fruits[fruitId].OvertimeGrowth or 1
                                    end
                                end)
                            end
                            
                            if baseWeight then
                                local totalWeight = baseWeight * sizeMulti * overtimeGrowth
                                local formattedWeight = tonumber(string.format("%.2f", totalWeight))
                                
                                if formattedWeight and formattedWeight < ShovelMinKG then
                                    shovelTool:Activate()
                                    pcall(function() Networking.Shovel.SwingShovel:Fire(shovelTool) end)
                                    pcall(function() Networking.Shovel.UseShovel:Fire(plantId, fruitId, shovelAttribute, shovelTool) end)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)


-- ==========================================
-- [ A. AUTO SELL INVENTORY (ULTIMATE CORE READER) ]
-- ==========================================

local TabShop = Window:AddMainTab("🛒 Shop", false) 
local SecShop = TabShop:AddSection("Sell", false)
local SellInterval, AutoSellTimerOn, AutoSellFullOn = 60, false, false

SecShop:AddSlider({ Title = "Sell Timer (s)", Min = 10, Max = 600, Increment = 1, Default = 60, Callback = function(Value) SellInterval = Value end })
SecShop:AddToggle({ Title = "Auto Sell by Timer", Default = false, Callback = function(Value) AutoSellTimerOn = Value end })
SecShop:AddToggle({ Title = "Auto Sell if Backpack Full", Default = false, Callback = function(Value) AutoSellFullOn = Value end })

local function EksekusiGhostSell()
    if Networking then 
        pcall(function() 
            Networking.NPCS.SellAll:Fire() 
            Speed_Library:SetNotification({Title = "🛒 Shop System", Content = "Isi tas berhasil dijual otomatis!", Time = 2})
        end) 
    end
end

-- MESIN 1: JUAL BERDASARKAN WAKTU (TIMER)
task.spawn(function()
    local timerHitung = 0
    while task.wait(1) do
        if AutoSellTimerOn then
            timerHitung = timerHitung + 1
            if timerHitung >= SellInterval then 
                EksekusiGhostSell() 
                timerHitung = 0 
            end
        else 
            timerHitung = 0 
        end
    end
end)

-- MESIN 2: JUAL SAAT TAS PENUH (BYPASS CORE ATTRIBUTE)
task.spawn(function()
    while task.wait(0.5) do
        if AutoSellFullOn then
            pcall(function()
                -- Membaca langsung kapasitas tas dari jantung server game!
                local isiTas = LocalPlayer:GetAttribute("FruitCount") or 0
                local maxTas = LocalPlayer:GetAttribute("MaxFruitCapacity") or 100
                
                -- Jika buah di tas sudah mencapai atau melebihi batas maksimal...
                if isiTas >= maxTas and maxTas > 0 then
                    EksekusiGhostSell()
                    task.wait(3) -- Jeda aman agar server sempat mereset angka tasmu
                end
            end)
        end
    end
end)


-- ==========================================
-- [ B. AUTO LOCK (PELINDUNG BUAH LANGKA & BERAT) ]
-- ==========================================
local SecProtect = TabShop:AddSection("Fruit Protection", false)

-- Variabel bawaan disetel kosong / aman
local LockRarities = {} 
local LockMutations = {} 
local LockMinKG = 999999 
local AutoLockOn = false

SecProtect:AddDropdown({ 
    Title = "Lock by Rarity", 
    Content = "Otomatis kunci (Favorite) buah dari Rarity ini",
    Multi = true, 
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, 
    Default = {}, -- Dibuat kosong dari awal
    Callback = function(Opt) LockRarities = type(Opt) == "table" and Opt or {Opt} end 
})

SecProtect:AddDropdown({ 
    Title = "Lock by Mutation", 
    Content = "Otomatis kunci buah yang punya mutasi ini",
    Multi = true, 
    Options = ListMutasi, 
    Default = {}, -- Dibuat kosong dari awal
    Callback = function(Opt) LockMutations = type(Opt) == "table" and Opt or {Opt} end 
})

SecProtect:AddInput({
    Title = "Lock Minimum KG",
    Content = "Kunci buah apa saja jika beratnya >= angka ini (Kosongkan jika tidak mau dipakai)",
    Default = "", -- Teks inputan dibiarkan kosong
    Numeric = true,
    Callback = function(Value)
        -- Jika input dihapus/kosong, set ke angka mustahil agar tidak mengunci buah biasa
        LockMinKG = tonumber(Value) or 999999
    end
})

SecProtect:AddToggle({ 
    Title = "🛡️ ENABLE AUTO LOCK FRUITS", 
    Content = "Lindungi buah langka & berat agar tidak ikut terjual saat Auto Sell",
    Default = false, 
    Callback = function(Value) AutoLockOn = Value end 
})

task.spawn(function()
    while task.wait(0.5) do
        if AutoLockOn and Networking then
            pcall(function()
                local function PeriksaDanKunci(wadah)
                    if not wadah then return end
                    
                    for _, item in ipairs(wadah:GetChildren()) do
                        if item:IsA("Tool") and item:GetAttribute("Fruit") then
                            local isFav = item:GetAttribute("IsFavorite")
                            
                            if not isFav then
                                local fruitId = item:GetAttribute("Id")
                                local fruitName = item:GetAttribute("Fruit")
                                local mutation = item:GetAttribute("Mutation")
                                local weight = item:GetAttribute("Weight") or 0 
                                local harusDikunci = false
                                
                                -- 1. Cek Mutasi
                                if mutation and table.find(LockMutations, mutation) then
                                    harusDikunci = true
                                end
                                
                                -- 2. Cek Rarity 
                                if not harusDikunci and fruitName then
                                    local rarity = CropDatabase[fruitName]
                                    if rarity and table.find(LockRarities, rarity) then
                                        harusDikunci = true
                                    end
                                end
                                
                                -- 3. Cek Berat (KG)
                                if not harusDikunci and weight >= LockMinKG then
                                    harusDikunci = true
                                end
                                
                                -- 4. Eksekusi Kunci
                                if harusDikunci and fruitId then
                                    item:SetAttribute("IsFavorite", true)
                                    Networking.Backpack.SetFruitFavorite:Fire(fruitId, true)
                                    
                                    local namaLengkap = (mutation and (mutation .. " ") or "") .. fruitName
                                    local formatBerat = string.format("%.2f", weight)
                                    Speed_Library:SetNotification({Title = "🛡️ Item Secured", Content = namaLengkap .. " (" .. formatBerat .. "kg) dikunci!", Time = 3})
                                end
                            end
                        end
                    end
                end
                
                PeriksaDanKunci(LocalPlayer:FindFirstChild("Backpack"))
                PeriksaDanKunci(LocalPlayer.Character)
            end)
        end
    end
end)


-- [ B. AUTO BUY SEEDS ]
local SecBuy = TabShop:AddSection("Auto Buy Seeds", false)
local SelectModeBuy, SelectedBuyRarities, SelectedBuySeeds, AutoBuyOn = "By Rarity", {"Common"}, {"Carrot"}, false
local DropdownBuySeedName

SecBuy:AddDropdown({ Title = "Seed Select by", Options = {"By Rarity", "By Name"}, Default = {"By Rarity"}, Callback = function(Opt) SelectModeBuy = type(Opt) == "table" and Opt[1] or Opt end })
SecBuy:AddDropdown({ Title = "Seed Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedBuyRarities = type(Opt) == "table" and Opt or {Opt}
        local combinedList = {}
        for key, value in pairs(SelectedBuyRarities) do
            local rName = type(key) == "number" and value or key
            if (type(key) == "number" and true or value) and DatabaseMentah[rName] then
                for _, s in ipairs(DatabaseMentah[rName]) do table.insert(combinedList, s) end
            end
        end
        if #combinedList > 0 then
            pcall(function() DropdownBuySeedName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownBuySeedName:SetOptions(combinedList) end)
            SelectedBuySeeds = {combinedList[1]}
        end
    end 
})
DropdownBuySeedName = SecBuy:AddDropdown({ Title = "Seed Name", Multi = true, Options = DatabaseMentah["Common"], Default = {"Carrot"}, Callback = function(Opt) SelectedBuySeeds = type(Opt) == "table" and Opt or {Opt} end })
SecBuy:AddToggle({ Title = "Auto Buy Seed", Default = false, Callback = function(Value) AutoBuyOn = Value end })

task.spawn(function()
    while task.wait(0.2) do 
        if AutoBuyOn and Networking then
            pcall(function()
                local pool = {}
                if SelectModeBuy == "By Rarity" then
                    for k, v in pairs(SelectedBuyRarities) do
                        local r = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and DatabaseMentah[r] then
                            for _, s in ipairs(DatabaseMentah[r]) do table.insert(pool, s) end
                        end
                    end
                else
                    for k, v in pairs(SelectedBuySeeds) do
                        local s = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and s ~= "" then table.insert(pool, s) end
                    end
                end
                if #pool > 0 then Networking.SeedShop.PurchaseSeed:Fire(pool[math.random(#pool)]) end
            end)
        end
    end
end)

-- [ C. AUTO BUY GEAR & PROPS ] (RESTORED FULL VERSION)
local SecGear = TabShop:AddSection("Auto Buy Gear", false)
local SelectModeGear, SelectedGearRarities, SelectedGears, AutoBuyGearOn = "By Rarity", {"Common"}, {"Common Watering Can"}, false
local DropdownGearName

SecGear:AddDropdown({ Title = "Gear Select by", Options = {"By Rarity", "By Name"}, Default = {"By Rarity"}, Callback = function(Opt) SelectModeGear = type(Opt) == "table" and Opt[1] or Opt end })
SecGear:AddDropdown({ Title = "Gear Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Super"}, Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedGearRarities = type(Opt) == "table" and Opt or {Opt}
        local combinedList = {}
        for key, value in pairs(SelectedGearRarities) do
            local rName = type(key) == "number" and value or key
            if (type(key) == "number" and true or value) and DatabaseGearMentah[rName] then
                for _, g in ipairs(DatabaseGearMentah[rName]) do table.insert(combinedList, g) end
            end
        end
        if #combinedList > 0 then
            pcall(function() DropdownGearName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownGearName:SetOptions(combinedList) end)
            SelectedGears = {combinedList[1]}
        end
    end 
})
DropdownGearName = SecGear:AddDropdown({ Title = "Gear Name", Multi = true, Options = DatabaseGearMentah["Common"], Default = {"Common Watering Can"}, Callback = function(Opt) SelectedGears = type(Opt) == "table" and Opt or {Opt} end })
SecGear:AddToggle({ Title = "Auto Buy Gear", Default = false, Callback = function(Value) AutoBuyGearOn = Value end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoBuyGearOn and Networking then
            pcall(function()
                local pool = {}
                if SelectModeGear == "By Rarity" then
                    for k, v in pairs(SelectedGearRarities) do
                        local r = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and DatabaseGearMentah[r] then
                            for _, g in ipairs(DatabaseGearMentah[r]) do table.insert(pool, g) end
                        end
                    end
                else
                    for k, v in pairs(SelectedGears) do
                        local g = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and g ~= "" then table.insert(pool, g) end
                    end
                end
                if #pool > 0 then Networking.GearShop.PurchaseGear:Fire(pool[math.random(#pool)]) end
            end)
        end
    end
end)

local SecProp = TabShop:AddSection("Auto Buy Props", false)
local SelectModeProp, SelectedPropRarities, SelectedProps, AutoBuyPropOn = "By Rarity", {"Common"}, {"Ladder Crate"}, false
local DropdownPropName

SecProp:AddDropdown({ Title = "Prop Select by", Options = {"By Rarity", "By Name"}, Default = {"By Rarity"}, Callback = function(Opt) SelectModeProp = type(Opt) == "table" and Opt[1] or Opt end })
SecProp:AddDropdown({ Title = "Prop Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"}, Default = {"Common"}, 
    Callback = function(Opt) 
        SelectedPropRarities = type(Opt) == "table" and Opt or {Opt}
        local combinedList = {}
        for key, value in pairs(SelectedPropRarities) do
            local rName = type(key) == "number" and value or key
            if (type(key) == "number" and true or value) and DatabasePropMentah[rName] then
                for _, p in ipairs(DatabasePropMentah[rName]) do table.insert(combinedList, p) end
            end
        end
        if #combinedList > 0 then
            pcall(function() DropdownPropName:Refresh(combinedList, {combinedList[1]}) end)
            pcall(function() DropdownPropName:SetOptions(combinedList) end)
            SelectedProps = {combinedList[1]}
        end
    end 
})
DropdownPropName = SecProp:AddDropdown({ Title = "Prop Name", Multi = true, Options = DatabasePropMentah["Common"], Default = {"Ladder Crate"}, Callback = function(Opt) SelectedProps = type(Opt) == "table" and Opt or {Opt} end })
SecProp:AddToggle({ Title = "Auto Buy Prop", Default = false, Callback = function(Value) AutoBuyPropOn = Value end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoBuyPropOn and Networking then
            pcall(function()
                local pool = {}
                if SelectModeProp == "By Rarity" then
                    for k, v in pairs(SelectedPropRarities) do
                        local r = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and DatabasePropMentah[r] then
                            for _, p in ipairs(DatabasePropMentah[r]) do table.insert(pool, p) end
                        end
                    end
                else
                    for k, v in pairs(SelectedProps) do
                        local p = type(k) == "number" and v or k
                        if (type(k) == "number" and true or v) and p ~= "" then table.insert(pool, p) end
                    end
                end
                if #pool > 0 then Networking.CrateShop.PurchaseCrate:Fire(pool[math.random(#pool)]) end
            end)
        end
    end
end)


-- ==========================================
-- 5. TAB 3: ⚙️ MISC (ESP & ANTI-AFK)
-- ==========================================
local TabMisc = Window:AddMainTab("⚙️ Misc", false)

-- [ A. FRUIT WEIGHT ESP V3 ]
local SecESP = TabMisc:AddSection("Visual Features", false)
local FruitESPOn = false

SecESP:AddToggle({ 
    Title = "👁️ Fruit Weight ESP", 
    Content = "Menampilkan berat dan nama buah secara akurat dari jarak jauh.",
    Default = false, 
    Callback = function(Value) 
        FruitESPOn = Value
        if not Value then
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BillboardGui") and obj.Name == "MyWeightESP" then obj:Destroy() end
                end
            end)
        end
    end 
})

task.spawn(function()
    while task.wait(0.5) do
        if FruitESPOn then
            pcall(function()
                local gardensFolder = workspace:FindFirstChild("Gardens")
                if not gardensFolder then return end

                for _, object in ipairs(gardensFolder:GetDescendants()) do
                    local userId = tonumber(object:GetAttribute("UserId"))
                    local plantId = object:GetAttribute("PlantId")
                    local fruitId = object:GetAttribute("FruitId")
                    local fruitName = object:GetAttribute("CorePartName")
                    local sizeMulti = object:GetAttribute("SizeMulti") or 1
                    
                    if userId and plantId and fruitId and fruitName then
                        local baseWeight = BaseWeightCache[fruitName]
                        if not baseWeight and FruitsDB then
                            local fruitMod = FruitsDB:FindFirstChild(fruitName)
                            if fruitMod then
                                local success, data = pcall(require, fruitMod)
                                if success and data and data.GrowData and data.GrowData.BaseWeight then
                                    baseWeight = data.GrowData.BaseWeight
                                    BaseWeightCache[fruitName] = baseWeight
                                end
                            end
                        end
                        
                        local overtimeGrowth = 1
                        if GardenSyncController then
                            pcall(function()
                                local plantData = GardenSyncController:GetPlant(userId, plantId)
                                if plantData and plantData.Fruits and plantData.Fruits[fruitId] then
                                    overtimeGrowth = plantData.Fruits[fruitId].OvertimeGrowth or 1
                                end
                            end)
                        end
                        
                        if baseWeight then
                            local totalWeight = baseWeight * sizeMulti * overtimeGrowth
                            local formattedWeight = string.format("%.2f", totalWeight)
                            local weightText = fruitName .. "\n🎯 " .. formattedWeight .. " kg"

                            local existingGui = object:FindFirstChild("MyWeightESP")
                            if not existingGui then
                                local billboard = Instance.new("BillboardGui")
                                billboard.Name = "MyWeightESP"
                                billboard.Adornee = object
                                billboard.Size = UDim2.new(0, 150, 0, 60) 
                                billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                                billboard.AlwaysOnTop = true

                                local textLabel = Instance.new("TextLabel")
                                textLabel.Name = "WeightText"
                                textLabel.Parent = billboard
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.TextColor3 = Color3.new(1, 0.8, 0) 
                                textLabel.TextStrokeTransparency = 0 
                                textLabel.TextSize = 16
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextWrapped = true
                                
                                billboard.Parent = object
                                existingGui = billboard
                            end
                            existingGui.WeightText.Text = weightText
                        end
                    end
                end
            end)
        end
    end
end)

-- [ B. ANTI-AFK BYPASS ]
local SecSecurity = TabMisc:AddSection("Security", false)
SecSecurity:AddLine()

task.spawn(function()
    -- Matikan kick bawaan Roblox
    pcall(function()
        for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
            if connection.Disable then connection:Disable() elseif connection.Disconnect then connection:Disconnect() end
        end
    end)

    -- Bypass anti-AFK internal game
    while task.wait(5) do
        pcall(function() LocalPlayer:SetAttribute("AntiAfkIdleOverride", 999999999) end)
    end
end)

Speed_Library:SetNotification({Title = "Gery Hub", Content = "God Mode Loaded Successfully!", Time = 3})
