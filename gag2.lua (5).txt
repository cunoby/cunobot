-- ==========================================
-- 👑 GERY HUB (GOD MODE EDITION) 
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/cunobot/refs/heads/main/Malas1.lua"))()

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
-- 🎯 FITUR BARU: AUTO SNIPE WILD PET + SERVER HOP
-- ==========================================
local SecSnipePet = TabShop:AddSection("Auto Snipe Wild Pet", false)

-- 1. Menyadap Daftar Nama Pet Asli dari Dalam Game
local ListSemuaPet = {"Dog", "Cat", "Bunny"} -- Data cadangan
pcall(function()
    local petMods = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("PetModules"))
    if petMods and type(petMods) == "table" then
        ListSemuaPet = {}
        for petName, _ in pairs(petMods) do
            table.insert(ListSemuaPet, petName)
        end
        table.sort(ListSemuaPet) -- Urutkan sesuai abjad A-Z
    end
end)

-- 2. Variabel Kontrol
local TargetSnipePets = {}
local HopDelay = 5
local AutoSnipePetOn = false
local AutoHopPetOn = false

-- 3. Membuat UI
SecSnipePet:AddDropdown({
    Title = "🎯 Select Target Pets",
    Content = "Pilih pet langka yang ingin diburu (Bisa lebih dari 1)",
    Multi = true,
    Options = ListSemuaPet,
    Default = {},
    Callback = function(Opt)
        TargetSnipePets = type(Opt) == "table" and Opt or {Opt}
    end
})

SecSnipePet:AddInput({
    Title = "⏳ Server Hop Delay (Detik)",
    Content = "Waktu tunggu sebelum pindah server jika pet target tidak ada",
    Default = "5",
    Callback = function(Value)
        -- Mengubah teks menjadi angka, default 5 detik jika ngawur
        HopDelay = tonumber(Value) or 5 
    end
})

SecSnipePet:AddToggle({
    Title = "▶️ ENABLE AUTO BUY PET",
    Content = "Otomatis TP dan beli pet target jika ada di server ini",
    Default = false,
    Callback = function(Value)
        AutoSnipePetOn = Value
    end
})

SecSnipePet:AddToggle({
    Title = "🔄 ENABLE AUTO HOP SERVER",
    Content = "Otomatis lompat server terus-menerus sampai pet target ditemukan",
    Default = false,
    Callback = function(Value)
        AutoHopPetOn = Value
    end
})

-- 4. Fungsi Server Hop (Mencari Server Sepi/Lain)
local function EksekusiServerHop()
    Speed_Library:SetNotification({Title = "🔄 Server Hop", Content = "Mencari server baru dalam " .. HopDelay .. " detik...", Time = HopDelay})
    task.wait(HopDelay)
    
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    
    -- Mengambil data server list dari API Roblox
    local serversApi = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return game:HttpGet(serversApi)
    end)
    
    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data.data then
            for _, server in ipairs(data.data) do
                -- Mencari server yang belum penuh dan BUKAN server tempat kita berada sekarang
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    -- 🔧 FIX: Menggunakan LocalPlayer
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer) 
                    task.wait(5) -- Jeda teleport
                    break
                end
            end
        end
    end
end

-- 5. Mesin Pemburu (Auto Snipe + Teleport Aman & Balik Semula)
task.spawn(function()
    while task.wait(1) do
        if AutoSnipePetOn and Networking then
            local map = workspace:FindFirstChild("Map")
            local wildPetRef = map and map:FindFirstChild("WildPetRef")
            local petTargetDitemukan = false
            
            if wildPetRef and #TargetSnipePets > 0 then
                for _, petPart in ipairs(wildPetRef:GetChildren()) do
                    if petPart:IsA("BasePart") then
                        -- Cek apakah pet masih tersedia
                        local ownerId = petPart:GetAttribute("OwnerUserId")
                        if (type(ownerId) ~= "number" or ownerId == 0) then
                            
                            local petName = petPart:GetAttribute("PetName")
                            -- Jika nama pet cocok dengan incaranmu
                            if petName and table.find(TargetSnipePets, petName) then
                                petTargetDitemukan = true
                                
                                local char = LocalPlayer.Character 
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                
                                if hrp then
                                    -- 📍 1. SIMPAN POSISI AWALMU SAAT INI
                                    local posisiAwal = hrp.CFrame
                                    
                                    -- ✨ 2. TELEPORT KE PET
                                    hrp.CFrame = petPart.CFrame * CFrame.new(0, 3, 0)
                                    task.wait(0.3) -- Jeda agar server mengenali posisimu
                                    
                                    -- 💸 3. EKSEKUSI PEMBELIAN
                                    pcall(function()
                                        Networking.Pets.WildPetTame:Fire(petPart)
                                        Speed_Library:SetNotification({Title = "🎯 AUTO SNIPE", Content = "Berhasil membeli " .. petName .. "!", Time = 2})
                                    end)
                                    
                                    task.wait(0.5) -- Tunggu sebentar agar transaksi masuk
                                    
                                    -- 🔙 4. KEMBALI KE TEMPAT SEMULA
                                    hrp.CFrame = posisiAwal
                                    task.wait(1) -- Jeda aman sebelum script mencari pet lain
                                end
                            end
                        end
                    end
                end
            end
            
            -- C. Logika Lompat Server
            -- Jika Auto Hop menyala, kita punya target, TAPI targetnya ga ketemu di server ini
            if AutoHopPetOn and not petTargetDitemukan and #TargetSnipePets > 0 then
                EksekusiServerHop()
            end
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


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

local TabShop = Window:AddMainTab("🛒 Live Shop", false)
local SecShop = TabShop:AddSection("Panel Kontrol", false)

-- 1. Memanggil UI Kustom yang baru kita buat
local LiveShopPanel = SecShop:AddPopUpLive({
    Title = "🖥️ Buka Live Shop",
    Content = "Munculkan panel toko mengambang di layar",
    PanelTitle = "LIVE SHOP SYNC"
})

-- 2. Mesin Scanner
task.spawn(function()
    local StockFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop"):WaitForChild("Items")

    while task.wait(1) do 
        -- Hemat memori: Loop hanya mengeksekusi data jika panel sedang terbuka!
        if LiveShopPanel:IsVisible() then 
            
            local textTimer = "⏳ Menunggu Restock..."
            local seedShopUI = Player.PlayerGui:FindFirstChild("SeedShop")
            if seedShopUI then
                for _, objek in ipairs(seedShopUI:GetDescendants()) do
                    if objek:IsA("TextLabel") and string.find(string.lower(objek.Text), "restock in") then
                        textTimer = "⏳ " .. objek.Text
                        break
                    end
                end
            end

            local success, SeedData = pcall(function()
                return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SeedData"))
            end)

            if success and type(SeedData) == "table" then
                local ActiveShopItems = {}
                for _, seedInfo in ipairs(SeedData) do
                    if seedInfo.RestockShop and seedInfo.SeedName then
                        table.insert(ActiveShopItems, seedInfo)
                    end
                end
                
                table.sort(ActiveShopItems, function(a, b)
                    local orderA = a.SeedShopDisplayOrder or 9999
                    local orderB = b.SeedShopDisplayOrder or 9999
                    if orderA == orderB then return a.SeedName < b.SeedName end
                    return orderA < orderB
                end)
                
                local contentText = textTimer .. "\n\n"
                local currentRarity = ""
                local lines = 3 
                
                if #ActiveShopItems > 0 then
                    for _, seedInfo in ipairs(ActiveShopItems) do
                        if seedInfo.Rarity ~= currentRarity then
                            currentRarity = seedInfo.Rarity or "Unknown"
                            contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"
                            lines = lines + 1
                        end
                        
                        local namaBibit = seedInfo.SeedName
                        local jumlahStok = "0"
                        local stockItem = StockFolder:FindFirstChild(namaBibit)
                        if stockItem then
                            if stockItem:IsA("IntValue") or stockItem:IsA("NumberValue") then jumlahStok = tostring(stockItem.Value)
                            elseif stockItem:IsA("StringValue") then jumlahStok = stockItem.Value end
                        end
                        
                        contentText = contentText .. " • " .. namaBibit .. " (x" .. jumlahStok .. ")\n"
                        lines = lines + 1
                    end
                else
                    contentText = contentText .. "Toko sedang kosong!\n"
                end
                
                -- Lempar data teks ke dalam Malas.lua untuk dirender!
                LiveShopPanel:Set(contentText, lines)
            end
        end
    end
end)

-- ==========================================
-- 🛠️ FITUR BARU: POP-UP LIVE GEAR SHOP
-- ==========================================

-- 1. Memanggil UI Kustom untuk Gear Shop
local LiveGearPanel = SecShop:AddPopUpLive({
    Title = "🖥️ Buka Live Gear Shop",
    Content = "Munculkan panel toko alat (Gear) mengambang",
    PanelTitle = "LIVE GEAR SYNC",
    Icon = "rbxassetid://136890595976124" 
})

-- 2. Mesin Scanner Khusus Gear Shop
task.spawn(function()
    local GearStockFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("GearShop"):WaitForChild("Items")

    -- Hierarki Rarity bawaan game (Dari baris 20 di script-mu)
    local RarityOrder = {
        ["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3,
        ["Epic"] = 4, ["Legendary"] = 5, ["Mythic"] = 6, ["Super"] = 7
    }

    while task.wait(1) do 
        if LiveGearPanel:IsVisible() then 
            
            -- A. Cari Timer Restock Gear
            local textTimer = "⏳ Menunggu Restock..."
            local gearShopUI = Player.PlayerGui:FindFirstChild("GearShop")
            if gearShopUI then
                for _, objek in ipairs(gearShopUI:GetDescendants()) do
                    if objek:IsA("TextLabel") and string.find(string.lower(objek.Text), "restock in") then
                        textTimer = "⏳ " .. objek.Text
                        break
                    end
                end
            end

            -- B. Baca Modul GearShopData
            local success, GearDataMod = pcall(function()
                return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GearShopData"))
            end)

            if success and type(GearDataMod) == "table" and type(GearDataMod.Data) == "table" then
                local ActiveGearItems = {}
                
                -- C. Menyaring barang (Hanya yang tidak pakai Robux & Bisa masuk toko)
                for _, gearInfo in ipairs(GearDataMod.Data) do
                    if not gearInfo.RobuxOnly and (gearInfo.RestockChance or gearInfo.EquippableGear) and gearInfo.ItemName then
                        
                        -- Cek apakah barangnya SEDANG dijual hari ini (Ada di Stock Folder atau dia Barang Permanen)
                        local isCurrentlyInShop = gearInfo.EquippableGear or GearStockFolder:FindFirstChild(gearInfo.ItemName)
                        
                        if isCurrentlyInShop then
                            table.insert(ActiveGearItems, gearInfo)
                        end
                    end
                end
                
                -- D. Mengurutkan sesuai logika asli game (Dari baris 33 di script-mu)
                table.sort(ActiveGearItems, function(a, b)
                    local orderA = RarityOrder[a.Rarity] or 0
                    local orderB = RarityOrder[b.Rarity] or 0
                    
                    if orderA == orderB then
                        local prioA = a.SortPriority or 0
                        local prioB = b.SortPriority or 0
                        if prioA == prioB then
                            if a.EquippableGear and not b.EquippableGear then return false
                            elseif b.EquippableGear and not a.EquippableGear then return true
                            elseif a.EquippableGear and b.EquippableGear then return (a.Cost or 0) < (b.Cost or 0)
                            else return (a.RestockChance or 0) > (b.RestockChance or 0) end
                        else return prioA < prioB end
                    else return orderA < orderB end
                end)
                
                -- E. Merangkai Teks ke Panel
                local contentText = textTimer .. "\n\n"
                local currentRarity = ""
                local lines = 3 
                
                if #ActiveGearItems > 0 then
                    for _, gearInfo in ipairs(ActiveGearItems) do
                        if gearInfo.Rarity ~= currentRarity then
                            currentRarity = gearInfo.Rarity or "Unknown"
                            contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"
                            lines = lines + 1
                        end
                        
                        local namaGear = gearInfo.ItemName
                        
                        -- Fix nama Crowbar sesuai script asli
                        local displayName = (namaGear == "Crowbar") and "Door Crowbar" or namaGear
                        
                        -- Cek Stok
                        local jumlahStok = "∞" -- Default untuk item permanen (EquippableGear)
                        local stockItem = GearStockFolder:FindFirstChild(namaGear)
                        
                        if stockItem then
                            if stockItem:IsA("IntValue") or stockItem:IsA("NumberValue") then jumlahStok = tostring(stockItem.Value)
                            elseif stockItem:IsA("StringValue") then jumlahStok = stockItem.Value end
                        else
                            -- Jika bukan item permanen dan tak ada di folder, anggap stok habis
                            if not gearInfo.EquippableGear then jumlahStok = "0" end
                        end
                        
                        contentText = contentText .. " • " .. displayName .. " (x" .. jumlahStok .. ")\n"
                        lines = lines + 1
                    end
                else
                    contentText = contentText .. "Toko sedang kosong!\n"
                end
                
                -- F. Eksekusi Render UI
                LiveGearPanel:Set(contentText, lines)
            end
        end
    end
end)

-- ==========================================
-- 📦 FITUR BARU: POP-UP LIVE CRATE SHOP
-- ==========================================

-- 1. Memanggil UI Kustom untuk Crate Shop
local LiveCratePanel = SecShop:AddPopUpLive({
    Title = "🖥️ Buka Live Crate Shop",
    Content = "Munculkan panel toko peti (Crate) mengambang",
    PanelTitle = "LIVE CRATE SYNC",
    Icon = "rbxassetid://136890595976124" 
})

-- 2. Mesin Scanner Khusus Crate Shop
task.spawn(function()
    local CrateStockFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("CrateShop"):WaitForChild("Items")

    local RarityOrder = {
        ["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3,
        ["Epic"] = 4, ["Legendary"] = 5, ["Mythic"] = 6, ["Super"] = 7
    }

    while task.wait(1) do 
        if LiveCratePanel:IsVisible() then 
            
            -- A. Cari Timer Restock Crate
            local textTimer = "⏳ Menunggu Restock..."
            local crateShopUI = Player.PlayerGui:FindFirstChild("CrateShop")
            if crateShopUI then
                for _, objek in ipairs(crateShopUI:GetDescendants()) do
                    if objek:IsA("TextLabel") and string.find(string.lower(objek.Text), "restock in") then
                        textTimer = "⏳ " .. objek.Text
                        break
                    end
                end
            end

            -- B. Baca Modul CrateData
            local success, CrateDataMod = pcall(function()
                return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("CrateData"))
            end)

            -- C. Game ini memanggil data peti pakai fungsi .GetAllCrates()
            if success and type(CrateDataMod) == "table" and type(CrateDataMod.GetAllCrates) == "function" then
                local ActiveCrateItems = {}
                local allCrates = CrateDataMod.GetAllCrates()
                
                -- Menyaring barang yang boleh masuk rotasi (Ada RestockChance)
                for _, crateInfo in pairs(allCrates) do
                    if crateInfo.RestockChance and crateInfo.Name then
                        
                        -- Cek apakah barangnya SEDANG dijual hari ini di server
                        if CrateStockFolder:FindFirstChild(crateInfo.Name) then
                            table.insert(ActiveCrateItems, crateInfo)
                        end
                    end
                end
                
                -- D. Mengurutkan sesuai logika asli game (Rarity -> RestockChance)
                table.sort(ActiveCrateItems, function(a, b)
                    local orderA = RarityOrder[a.Rarity] or 0
                    local orderB = RarityOrder[b.Rarity] or 0
                    
                    if orderA == orderB then
                        return (a.RestockChance or 0) > (b.RestockChance or 0)
                    else 
                        return orderA < orderB 
                    end
                end)
                
                -- E. Merangkai Teks ke Panel
                local contentText = textTimer .. "\n\n"
                local currentRarity = ""
                local lines = 3 
                
                if #ActiveCrateItems > 0 then
                    for _, crateInfo in ipairs(ActiveCrateItems) do
                        if crateInfo.Rarity ~= currentRarity then
                            currentRarity = crateInfo.Rarity or "Unknown"
                            contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"
                            lines = lines + 1
                        end
                        
                        local namaCrate = crateInfo.Name
                        local jumlahStok = "0"
                        
                        -- Cek Stok
                        local stockItem = CrateStockFolder:FindFirstChild(namaCrate)
                        if stockItem then
                            if stockItem:IsA("IntValue") or stockItem:IsA("NumberValue") then jumlahStok = tostring(stockItem.Value)
                            elseif stockItem:IsA("StringValue") then jumlahStok = stockItem.Value end
                        end
                        
                        contentText = contentText .. " • " .. namaCrate .. " (x" .. jumlahStok .. ")\n"
                        lines = lines + 1
                    end
                else
                    contentText = contentText .. "Toko sedang kosong!\n"
                end
                
                -- F. Eksekusi Render UI
                LiveCratePanel:Set(contentText, lines)
            end
        end
    end
end)

-- ==========================================
-- 🐾 FITUR BARU: POP-UP LIVE PET RADAR
-- ==========================================

-- Kita masukkan ke dalam TabShop yang sudah ada
local SecPetRadar = TabShop:AddSection("Pet Radar System", false)

-- 1. Memanggil UI Kustom untuk Pet Radar
local LivePetPanel = SecPetRadar:AddPopUpLive({
    Title = "🖥️ Buka Live Pet Radar",
    Content = "Munculkan panel radar pemantau pet liar di map",
    PanelTitle = "LIVE PET RADAR",
    Icon = "rbxassetid://136890595976124" 
})

-- Fungsi pembantu format angka koin (1000 -> 1,000)
local function formatKoin(angka)
    local str = tostring(math.floor(math.abs(angka)))
    return string.reverse((string.reverse(str):gsub("%d%d%d", "%1,"))):gsub("^,", "")
end

-- 2. Mesin Scanner Khusus Pet Radar
task.spawn(function()
    local RarityOrder = {
        ["Common"] = 1, ["Uncommon"] = 2, ["Rare"] = 3,
        ["Epic"] = 4, ["Legendary"] = 5, ["Mythic"] = 6, ["Super"] = 7
    }

    while task.wait(1) do 
        if LivePetPanel:IsVisible() then 
            local map = workspace:FindFirstChild("Map")
            local wildPetRef = map and map:FindFirstChild("WildPetRef")
            
            local ActivePets = {}
            
            if wildPetRef then
                for _, petPart in ipairs(wildPetRef:GetChildren()) do
                    if petPart:IsA("BasePart") then
                        -- Cek apakah sudah dibeli orang (Jika OwnerUserId bukan 0, berarti sudah laku)
                        local ownerId = petPart:GetAttribute("OwnerUserId")
                        if type(ownerId) == "number" and ownerId ~= 0 then
                            continue 
                        end
                        
                        local petName = petPart:GetAttribute("PetName")
                        local rarity = petPart:GetAttribute("Rarity") or "Common"
                        local price = petPart:GetAttribute("Price") or 0
                        local spawnedAt = petPart:GetAttribute("SpawnedAt") or os.time()
                        local lifetime = petPart:GetAttribute("Lifetime") or 0
                        
                        -- Kalkulasi sisa waktu sebelum pet kabur
                        local sisaWaktu = (spawnedAt + lifetime) - os.time()
                        
                        if petName and sisaWaktu > 0 then
                            table.insert(ActivePets, {
                                Name = petName,
                                Rarity = rarity,
                                Price = price,
                                TimeLeft = sisaWaktu
                            })
                        end
                    end
                end
            end
            
            -- Mengurutkan berdasarkan Kelangkaan (Super/Mythic Paling Atas!)
            table.sort(ActivePets, function(a, b)
                local orderA = RarityOrder[a.Rarity] or 0
                local orderB = RarityOrder[b.Rarity] or 0
                
                if orderA == orderB then
                    -- Jika rarity sama, urutkan dari waktu yang mau habis duluan
                    return a.TimeLeft < b.TimeLeft 
                else 
                    return orderA > orderB -- Urutan dibalik agar yang langka di atas
                end
            end)
            
            -- Merangkai Teks ke Panel
            local contentText = "🐶 Pet Liar di Map: " .. #ActivePets .. "\n\n"
            local currentRarity = ""
            local lines = 3 
            
            if #ActivePets > 0 then
                for _, petInfo in ipairs(ActivePets) do
                    if petInfo.Rarity ~= currentRarity then
                        currentRarity = petInfo.Rarity
                        contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"
                        lines = lines + 1
                    end
                    
                    -- Format timer ala game aslinya (misal: 2m 15s)
                    local timeStr = ""
                    local m = math.floor(petInfo.TimeLeft / 60)
                    local s = petInfo.TimeLeft % 60
                    if m > 0 then
                        timeStr = string.format("%dm %ds", m, s)
                    else
                        timeStr = string.format("%ds", s)
                    end
                    
                    contentText = contentText .. " • " .. petInfo.Name .. " | ¢" .. formatKoin(petInfo.Price) .. " (" .. timeStr .. ")\n"
                    lines = lines + 1
                end
            else
                contentText = contentText .. "Map sedang sepi (Tidak ada pet).\n"
            end
            
            -- Eksekusi Render UI
            LivePetPanel:Set(contentText, lines)
        end
    end
end)

-- ==========================================
-- 🔮 FITUR BARU: LIVE MOON PREDICTOR (MEMORI BYPASS 100% AKURAT)
-- ==========================================
local SecMoonPredictor = TabMisc:AddSection("Moon Predictor", false)

local LiveMoonPanel = SecMoonPredictor:AddPopUpLive({
    Title = "🖥️ Buka Live Moon Predictor",
    Content = "Jadwal presisi menggunakan memori asli game",
    PanelTitle = "🌙 WEATHER PREDICTION",
    Icon = "rbxassetid://91446334780160" 
})

task.spawn(function()
    local CYCLE_DURATION = 600
    local DAY_DUR = 450
    local SUNSET_DUR = 30
    local NIGHT_ORDER = 3

    -- MENGAMBIL TABEL ASLI DARI MEMORI GAME (Inilah rahasia Wish Hub!)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TimeCycleMod = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("TimeCycleData"))
    
    local rawNightWeathers = nil
    if TimeCycleMod and TimeCycleMod.Data and TimeCycleMod.Data.Night then
        rawNightWeathers = TimeCycleMod.Data.Night.Weathers
    end

    local function formatTime(seconds)
        if not seconds then return "0h 0m 0s" end
        local h = math.floor(seconds / 3600)
        local m = math.floor((seconds % 3600) / 60)
        local s = seconds % 60
        return string.format("%dh %dm %ds", h, m, s)
    end

    while task.wait(1) do 
        if LiveMoonPanel:IsVisible() and rawNightWeathers then 
            local currentTime = os.time()
            local currentCycle = math.floor(currentTime / CYCLE_DURATION)
            local timeInCycle = currentTime % CYCLE_DURATION
            
            local nextPhaseName = ""
            local nextPhaseTime = 0
            
            if timeInCycle < DAY_DUR then
                nextPhaseName = "Sunset"
                nextPhaseTime = DAY_DUR - timeInCycle
            elseif timeInCycle < (DAY_DUR + SUNSET_DUR) then
                nextPhaseName = "Night"
                nextPhaseTime = (DAY_DUR + SUNSET_DUR) - timeInCycle
            else
                nextPhaseName = "Day"
                nextPhaseTime = CYCLE_DURATION - timeInCycle
            end
            
            local predictions = {
                ["Goldmoon"] = nil,
                ["Rainbow Moon"] = nil,
                ["Bloodmoon"] = nil
            }
            
            local found = 0
            local cycleOffset = 0
            
            -- Mesin Peramal (Bypass Memory)
            while found < 3 and cycleOffset < 1000 do
                local simCycle = currentCycle + cycleOffset
                local seed = simCycle * 1000 + NIGHT_ORDER
                local rng = Random.new(seed)
                
                -- Kalkulasi total chance persis seperti script game
                local totalChance = 0
                for _, data in pairs(rawNightWeathers) do
                    totalChance = totalChance + data.Chance
                end
                
                local roll = rng:NextNumber() * totalChance
                local currentSum = 0
                local selectedMoon = "Unknown"
                
                -- Loop pairs asli menggunakan tabel game!
                for name, data in pairs(rawNightWeathers) do
                    currentSum = currentSum + data.Chance
                    if roll <= currentSum then
                        selectedMoon = name
                        break
                    end
                end
                
                local nightStartTime = simCycle * CYCLE_DURATION + (DAY_DUR + SUNSET_DUR)
                local timeLeft = nightStartTime - currentTime
                
                if timeLeft > 0 and predictions[selectedMoon] == nil and selectedMoon ~= "Moon" then
                    predictions[selectedMoon] = timeLeft
                    found = found + 1
                end
                
                cycleOffset = cycleOffset + 1
            end
            
            local contentText = ""
            contentText = contentText .. "Next: " .. nextPhaseName .. " in " .. formatTime(nextPhaseTime) .. "\n"
            contentText = contentText .. "Next Bloodmoon: " .. formatTime(predictions["Bloodmoon"]) .. "\n"
            contentText = contentText .. "Next Goldmoon: " .. formatTime(predictions["Goldmoon"]) .. "\n"
            contentText = contentText .. "Next Rainbow Moon: " .. formatTime(predictions["Rainbow Moon"]) .. "\n"
            
            LiveMoonPanel:Set(contentText, 4)
        end
    end
end)

-- ==========================================
-- 🎯 GERY HUB: AUTO-SEED SNIPER (ULTRA-FAST)
-- ==========================================
local SecSniper = TabMisc:AddSection("Seed Sniper (Ultra Fast)", false)

local AutoTP = false
local AutoClaim = false

SecSniper:AddToggle({Title = "🚀 Auto-TP Rainbow/Gold Seed", Default = false, Callback = function(v) AutoTP = v end})
SecSniper:AddToggle({Title = "💎 Auto-Claim Instant", Default = false, Callback = function(v) AutoClaim = v end})

-- Fungsi Inti: Menyadap event kemunculan bibit dari Server
local function StartSeedSniper()
    local ServerLocations = game:GetService("Workspace").Map.SeedPackSpawnServerLocations
    
    -- Listener Super Cepat
    ServerLocations.ChildAdded:Connect(function(child)
        -- Tunggu sampai atribut Seed muncul (hanya perlu beberapa milidetik)
        task.spawn(function()
            local startTime = os.clock()
            repeat task.wait() until child:GetAttribute("SeedPack") ~= nil or child:GetAttribute("RainbowSeed") or child:GetAttribute("GoldSeed")
            
            local isRainbow = child:GetAttribute("RainbowSeed") == true
            local isGold = child:GetAttribute("GoldSeed") == true
            
            if (isRainbow or isGold) and AutoTP then
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    -- TP langsung ke posisi bibit
                    hrp.CFrame = child.CFrame + Vector3.new(0, 3, 0)
                    
                    -- Auto Claim (Langsung menyentuh/mengirim request claim)
                    if AutoClaim then
                        -- Menggunakan Networking asli game untuk claim instant
                        local Networking = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                        -- Kita kirim sinyal claim ke server sebelum pemain lain sempat bergerak
                        task.spawn(function()
                            -- Sesuaikan dengan nama fungsi claim di Networking (biasanya 'ClaimSeed' atau 'Pickup')
                            Networking.SeedPack.Claim:FireServer(child) 
                        end)
                    end
                end
            end
        end)
    end)
end

-- Jalankan listener
StartSeedSniper()
