local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/cunobot/refs/heads/main/ikan.lua"))()

Speed_Library.SetNotification = function(self, args)
    if type(args) == "table" then
        local judul = args.Title or "Info"
        local isi = args.Content or args.Description or ""
    end
end

local Window = Speed_Library:CreateWindow({
    Title = "Gery Hub - God Mode",
    SizeUi = UDim2.fromOffset(580, 340)
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

_G.TriggerFullInstantHop = function()
    pcall(function()
        local blankGui = Instance.new("ScreenGui")
        blankGui.Enabled = true
        game:GetService("TeleportService"):SetTeleportGui(blankGui)
    end)
    local queue = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)
    if queue then
        queue([[
            if _G.BypassExecuted then return end
            _G.BypassExecuted = true
            pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)
            pcall(function() if game:GetService("CoreGui"):FindFirstChild("RobloxLoadingGui") then game:GetService("CoreGui").RobloxLoadingGui:Destroy() end end)
            local lp = game:GetService("Players").LocalPlayer
            local rf = game:GetService("ReplicatedFirst")
            local workspace = game:GetService("Workspace")
            local active = true
            task.delay(5, function() active = false end)
            local old
            old = hookmetamethod(game, "__newindex", function(self, prop, val)
                if not active then return old(self, prop, val) end
                if self:IsA("ScreenGui") and prop == "Enabled" and val == false then
                    if self.Name ~= "LoadingScreenMenu" and self.Name ~= "Dex" then return end
                end
                if self:IsA("Camera") then
                    if prop == "CameraType" and val == Enum.CameraType.Scriptable then return end
                    if prop == "FieldOfView" and val == 45 then return end
                end
                if self:IsA("BasePart") and prop == "Anchored" and val == true then
                    if self.Name == "HumanoidRootPart" or self.Parent:FindFirstChild("Humanoid") then return end
                end
                return old(self, prop, val)
            end)
            local function ExecuteNativeCleanup()
                if getgc then
                    for _, v in pairs(getgc()) do
                        if type(v) == "function" then
                            pcall(function()
                                local name = debug.info(v, "n")
                                if name == "showGuis" or name == "endTransparentBGfx" then v() end
                            end)
                        end
                    end
                end
                pcall(function()
                    if rf:FindFirstChild("LoadingScreenController") then
                        rf.LoadingScreenController.Disabled = true
                        rf.LoadingScreenController:Destroy()
                    end
                    if workspace:FindFirstChild("LoadingScreenMenu") then workspace.LoadingScreenMenu:Destroy() end
                end)
                pcall(function()
                    local g = workspace:FindFirstChild("Gardens")
                    if g then
                        for _, p in pairs(g:GetChildren()) do
                            if p:FindFirstChild("LoadingCam") then p.LoadingCam:Destroy() end
                            if p:FindFirstChild("LoadingScreenCam") then p.LoadingScreenCam:Destroy() end
                        end
                    end
                end)
                pcall(function()
                    local char = lp.Character
                    if char then
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if root then root.Anchored = false end
                        for _, part in pairs(char:GetChildren()) do
                            if part:IsA("BasePart") then part.Anchored = false end
                        end
                    end
                end)
                lp:SetAttribute("LoadingScreenActive", false)
                lp:SetAttribute("LoadingScreenDone", true)
                game:GetService("ProximityPromptService").Enabled = true
            end
            task.spawn(function()
                ExecuteNativeCleanup()
                for i = 1, 30 do ExecuteNativeCleanup() task.wait(0.05) end
            end)
            workspace.ChildAdded:Connect(function(child)
                if child.Name == "LoadingScreenMenu" or child.Name == "Gardens" then ExecuteNativeCleanup() end
            end)
            pcall(function()
                if game.Lighting:FindFirstChild("Blur") then game.Lighting.Blur.Enabled = false end
                if game.Lighting:FindFirstChild("DepthOfField") then game.Lighting.DepthOfField.Enabled = false end
            end)
        ]])
    end
end

if not _G.BypassExecuted then
    _G.BypassExecuted = true
    local lp = LocalPlayer
    local rf = game:GetService("ReplicatedFirst")
    local active = true
    task.delay(5, function() active = false end)
    local old
    old = hookmetamethod(game, "__newindex", function(self, prop, val)
        if not active then return old(self, prop, val) end
        if self:IsA("ScreenGui") and prop == "Enabled" and val == false then
            if self.Name ~= "LoadingScreenMenu" and self.Name ~= "Dex" then return end
        end
        if self:IsA("Camera") then
            if prop == "CameraType" and val == Enum.CameraType.Scriptable then return end
            if prop == "FieldOfView" and val == 45 then return end
        end
        if self:IsA("BasePart") and prop == "Anchored" and val == true then
            if self.Name == "HumanoidRootPart" or self.Parent:FindFirstChild("Humanoid") then return end
        end
        return old(self, prop, val)
    end)
    local function ExecuteNativeCleanup()
        if getgc then
            for _, v in pairs(getgc()) do
                if type(v) == "function" then
                    pcall(function()
                        local name = debug.info(v, "n")
                        if name == "showGuis" or name == "endTransparentBGfx" then v() end
                    end)
                end
            end
        end
        pcall(function()
            if rf:FindFirstChild("LoadingScreenController") then
                rf.LoadingScreenController.Disabled = true
                rf.LoadingScreenController:Destroy()
            end
            if workspace:FindFirstChild("LoadingScreenMenu") then workspace.LoadingScreenMenu:Destroy() end
        end)
        pcall(function()
            local g = workspace:FindFirstChild("Gardens")
            if g then
                for _, p in pairs(g:GetChildren()) do
                    if p:FindFirstChild("LoadingCam") then p.LoadingCam:Destroy() end
                    if p:FindFirstChild("LoadingScreenCam") then p.LoadingScreenCam:Destroy() end
                end
            end
        end)
        pcall(function()
            local char = lp.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then root.Anchored = false end
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.Anchored = false end
                end
            end
        end)
        lp:SetAttribute("LoadingScreenActive", false)
        lp:SetAttribute("LoadingScreenDone", true)
        game:GetService("ProximityPromptService").Enabled = true
    end
    task.spawn(function()
        ExecuteNativeCleanup()
        for i = 1, 30 do ExecuteNativeCleanup() task.wait(0.05) end
    end)
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "LoadingScreenMenu" or child.Name == "Gardens" then ExecuteNativeCleanup() end
    end)
    pcall(function()
        if game.Lighting:FindFirstChild("Blur") then game.Lighting.Blur.Enabled = false end
        if game.Lighting:FindFirstChild("DepthOfField") then game.Lighting.DepthOfField.Enabled = false end
    end)
end

local ConfigFile = "GeryHub_FullConfig.json"

_G.Config = {
    FilterMode = "By Name", TargetRarity = {}, TargetName = {}, TargetBlacklist = {}, AutoFarmAktif = false, AutoHarvestAll = false,
    SelectedSeeds = {}, PlantMode = "Random Area", AutoPlantOn = false,
    ShovelSelectBy = "By Rarity", TargetShovelRarity = {"Common"}, TargetShovelName = {"Carrot"}, ShovelMinKG = 1, AutoShovelFruitOn = false,
    TargetShovelPlantsList = {}, AutoShovelPlantOn = false,
    TargetTrowelPlants = {}, AutoTrowelOn = false,
    TargetWater = {}, WaterDelay = 1.2, AutoWaterOn = false,
    TargetSprinklerPlant = {}, SelectedSprinklerType = "", SprinklerDelay = 1.2, AutoSprinklerOn = false,
    SellInterval = 60, AutoSellTimerOn = false, AutoSellFullOn = false,
    SelectModeBuy = "By Rarity", SelectedBuyRarities = {"Common"}, SelectedBuySeeds = {"Carrot"}, AutoBuyOn = false,
    SelectModeGear = "By Rarity", SelectedGearRarities = {"Common"}, SelectedGears = {"Common Watering Can"}, AutoBuyGearOn = false,
    SelectModeProp = "By Rarity", SelectedPropRarities = {"Common"}, SelectedProps = {"Ladder Crate"}, AutoBuyPropOn = false,
    TargetSnipePets = {}, HopDelay = 5, AutoSnipePetOn = false, AutoHopPetOn = false,
    FruitESPOn = false, AutoTP = false, AutoClaim = false, PotatoMode = false
}

if isfile and isfile(ConfigFile) then
    pcall(function()
        local data = HttpService:JSONDecode(readfile(ConfigFile))
        for k, v in pairs(data) do _G.Config[k] = v end
    end)
end

_G.SaveConfig = function()
    if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(_G.Config)) end) end
end

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

local Networking = nil
local GardenSyncController = nil
local FruitsDB = nil
local BaseWeightCache = {}

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
    if obj:IsA("ModuleScript") and obj.Name == "Networking" then pcall(function() Networking = require(obj) end) break end
end

for _, obj in ipairs(LocalPlayer.PlayerScripts:GetDescendants()) do
    if obj:IsA("ModuleScript") and obj.Name == "GardenSyncController" then pcall(function() GardenSyncController = require(obj) end) end
end
if not GardenSyncController then
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("ModuleScript") and obj.Name == "GardenSyncController" then pcall(function() GardenSyncController = require(obj) end) end
    end
end

local PlantDB = ReplicatedStorage:FindFirstChild("PlantGenerationModules") 
FruitsDB = PlantDB and PlantDB:FindFirstChild("Fruits")

local TabFarm = Window:AddMainTab("🚜 Farm", false)
local SecFarm = TabFarm:AddSection("Auto Harvest Settings", false)
local FilterMode, TargetRarity, TargetName, TargetBlacklist = _G.Config.FilterMode, _G.Config.TargetRarity, _G.Config.TargetName, _G.Config.TargetBlacklist
local AutoFarmAktif, AutoHarvestAll = _G.Config.AutoFarmAktif, _G.Config.AutoHarvestAll

SecFarm:AddDropdown({ Title = "Harvest Select by", Options = {"By Name", "By Rarity", "Both (Name & Rarity)"}, Default = {FilterMode}, Callback = function(Opt) FilterMode = type(Opt) == "table" and Opt[1] or Opt; _G.Config.FilterMode = FilterMode; _G.SaveConfig() end })
SecFarm:AddDropdown({ Title = "Harvest Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Default = TargetRarity, Callback = function(Opt) TargetRarity = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetRarity = TargetRarity; _G.SaveConfig() end })
SecFarm:AddDropdown({ Title = "Harvest Name", Multi = true, Options = ListCropsGameBaru, Default = TargetName, Callback = function(Opt) TargetName = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetName = TargetName; _G.SaveConfig() end })
SecFarm:AddDropdown({ Title = "Blacklist Mutation", Multi = true, Options = ListMutasi, Default = TargetBlacklist, Callback = function(Opt) TargetBlacklist = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetBlacklist = TargetBlacklist; _G.SaveConfig() end })
SecFarm:AddLine()
SecFarm:AddToggle({ Title = "▶️ ENABLE FILTERED HARVEST", Default = AutoFarmAktif, Callback = function(Value) AutoFarmAktif = Value; _G.Config.AutoFarmAktif = Value; _G.SaveConfig() end })
SecFarm:AddToggle({ Title = "▶️ ENABLE AUTO HARVEST ALL", Default = AutoHarvestAll, Callback = function(Value) AutoHarvestAll = Value; _G.Config.AutoHarvestAll = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.1) do
        if (AutoFarmAktif or AutoHarvestAll) and Networking and Networking.Garden and Networking.Garden.CollectFruit then 
            local myPlotId = LocalPlayer:GetAttribute("PlotId")
            if not myPlotId then continue end
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(myPlotId))
            local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
            
            if plantsFolder then
                for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                    local plantId = plantModel:GetAttribute("PlantId")
                    local fruitsFolder = plantModel:FindFirstChild("Fruits")
                    
                    if plantId and fruitsFolder then
                        -- PENETRASI JALUR V5: Mengais langsung isi folder Fruits bawaan game
                        for _, fruitObj in ipairs(fruitsFolder:GetChildren()) do
                            local fruitId = fruitObj:GetAttribute("FruitId") or fruitObj.Name
                            local age = fruitObj:GetAttribute("Age") or plantModel:GetAttribute("Age")
                            local maxAge = fruitObj:GetAttribute("MaxAge") or plantModel:GetAttribute("MaxAge")
                            
                            -- Pastikan kondisi buah beneran sudah matang
                            if age and maxAge and age >= maxAge then
                                local namaTanaman = fruitObj:GetAttribute("CorePartName") or plantModel.Name
                                local bolehPanen = false
                                
                                -- Cek filter kecocokan UI Menu Gery Hub
                                if AutoHarvestAll then
                                    bolehPanen = true
                                elseif AutoFarmAktif then
                                    local isBlacklisted = false
                                    local mutation = fruitObj:GetAttribute("Mutation")
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
                                
                                -- Eksekusi panen kilat jika lolos filter
                                if bolehPanen then
                                    pcall(function() 
                                        Networking.Garden.CollectFruit:Fire(plantId, tostring(fruitId)) 
                                    end)
                                    task.wait(0.02) -- Jeda biner presisi hasil uji coba sukses
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local SecPlant = TabFarm:AddSection("Auto Plant Settings", false)
local SelectedSeeds, PlantMode, AutoPlantOn = _G.Config.SelectedSeeds, _G.Config.PlantMode, _G.Config.AutoPlantOn

SecPlant:AddDropdown({ Title = "Seeds to Plant", Multi = true, Options = ListCropsGameBaru, Default = SelectedSeeds, Callback = function(Opt) SelectedSeeds = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedSeeds = SelectedSeeds; _G.SaveConfig() end })
SecPlant:AddDropdown({ Title = "Plant Position Mode", Multi = false, Options = {"Random Area", "At Character Position"}, Default = {PlantMode}, Callback = function(Opt) PlantMode = type(Opt) == "table" and Opt[1] or Opt; _G.Config.PlantMode = PlantMode; _G.SaveConfig() end })
SecPlant:AddToggle({ Title = "▶️ ENABLE AUTO PLANT", Default = AutoPlantOn, Callback = function(Value) AutoPlantOn = Value; _G.Config.AutoPlantOn = Value; _G.SaveConfig() end })

task.spawn(function()
    local AreaTanamCached = {}
    local LastPlotId = nil

    while task.wait(0.1) do -- Interval check detak jantung tas
        if AutoPlantOn and #SelectedSeeds > 0 and Networking then
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            local plotId = LocalPlayer:GetAttribute("PlotId")
            
            if plotId and char and humanoid and backpack then
                -- 📡 1. REFRESH CACHE ZONA TANAH (Anti-Lag System, Scan Cuma Sekali)
                if LastPlotId ~= plotId or #AreaTanamCached == 0 then
                    LastPlotId = plotId
                    table.clear(AreaTanamCached)
                    local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                    if myPlot then
                        for _, desc in ipairs(myPlot:GetDescendants()) do
                            if CollectionService:HasTag(desc, "PlantArea") then 
                                table.insert(AreaTanamCached, desc) 
                            end
                        end
                    end
                end

                if #AreaTanamCached > 0 then
                    -- 🎒 2. SERGAP & KUMPULKAN SEMUA BIBIT COCOK DI TAS + TANGAN SECARA INSTAN
                    local DaftarBibitTersedia = {}
                    
                    -- Ambil dari tas
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and table.find(SelectedSeeds, item:GetAttribute("SeedTool") or item.Name) then
                            table.insert(DaftarBibitTersedia, item)
                        end
                    end
                    -- Ambil dari tangan
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") and table.find(SelectedSeeds, item:GetAttribute("SeedTool") or item.Name) then
                            table.insert(DaftarBibitTersedia, item)
                        end
                    end

                    -- 🔥 3. EKSEKUSI BRUTAL BURST PLANTING (Tanam Semua dalam Sekejap!)
                    if #DaftarBibitTersedia > 0 then
                        for _, seedTool in ipairs(DaftarBibitTersedia) do
                            if not AutoPlantOn then break end
                            
                            local seedAttr = seedTool:GetAttribute("SeedTool") or seedTool.Name
                            local plantPos = nil
                            
                            if PlantMode == "Random Area" then
                                local targetArea = AreaTanamCached[math.random(#AreaTanamCached)]
                                if targetArea then
                                    plantPos = Vector3.new(targetArea.Position.X + math.random(-2, 2), targetArea.Position.Y, targetArea.Position.Z + math.random(-2, 2))
                                end
                            else
                                local hrp = char:FindFirstChild("HumanoidRootPart")
                                if hrp then plantPos = hrp.Position - Vector3.new(0, 3, 0) end
                            end

                            if plantPos and seedAttr then
                                -- Pegang paksa kilat biar server gak nolak paket
                                if seedTool.Parent ~= char then
                                    pcall(function() humanoid:EquipTool(seedTool) end)
                                end
                                
                                -- Tembak paket biner tanam pintas
                                pcall(function() 
                                    Networking.Plant.PlantSeed:Fire(plantPos, seedAttr, seedTool) 
                                end)
                                
                                -- Jeda micro-detik ultra tipis biar aman dari deteksi oversize server
                                task.wait(0.01)
                            end
                        end
                    end
                end
            end
        end
    end
end)

local SecShovelFruit = TabFarm:AddSection("Auto Shovel Fruit", false)
local ShovelSelectBy, TargetShovelRarity, TargetShovelName = _G.Config.ShovelSelectBy, _G.Config.TargetShovelRarity, _G.Config.TargetShovelName
local ShovelMinKG, AutoShovelFruitOn = _G.Config.ShovelMinKG, _G.Config.AutoShovelFruitOn
local DropdownShovelName

SecShovelFruit:AddDropdown({ Title = "Shovel Select by", Options = {"By Rarity", "By Name", "Both (Name & Rarity)"}, Default = {ShovelSelectBy}, Callback = function(Opt) ShovelSelectBy = type(Opt) == "table" and Opt[1] or Opt; _G.Config.ShovelSelectBy = ShovelSelectBy; _G.SaveConfig() end })
SecShovelFruit:AddDropdown({ Title = "Shovel Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Default = TargetShovelRarity, 
    Callback = function(Opt) 
        TargetShovelRarity = type(Opt) == "table" and Opt or {Opt}
        _G.Config.TargetShovelRarity = TargetShovelRarity; _G.SaveConfig()
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
            _G.Config.TargetShovelName = TargetShovelName; _G.SaveConfig()
        end
    end 
})
DropdownShovelName = SecShovelFruit:AddDropdown({ Title = "Shovel Name", Multi = true, Options = DatabaseMentah["Common"], Default = TargetShovelName, Callback = function(Opt) TargetShovelName = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetShovelName = TargetShovelName; _G.SaveConfig() end })
SecShovelFruit:AddInput({ Title = "Minimum KG", Default = tostring(ShovelMinKG), Numeric = true, Callback = function(Value) ShovelMinKG = tonumber(Value) or 1; _G.Config.ShovelMinKG = ShovelMinKG; _G.SaveConfig() end })
SecShovelFruit:AddToggle({ Title = "Auto Shovel Fruit", Default = AutoShovelFruitOn, Callback = function(Value) AutoShovelFruitOn = Value; _G.Config.AutoShovelFruitOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoShovelFruitOn and Networking then
            local char = LocalPlayer.Character
            if not char then continue end
            local shovelTool = char:FindFirstChild("Shovel")
            if not shovelTool then
                local backpackShovel = LocalPlayer.Backpack:FindFirstChild("Shovel")
                if backpackShovel and char:FindFirstChild("Humanoid") then
                    char.Humanoid:EquipTool(backpackShovel); shovelTool = backpackShovel; task.wait(0.5) 
                elseif Networking.GearShop and Networking.GearShop.EquipGear then
                    Networking.GearShop.EquipGear:Fire("Shovel"); task.wait(0.5); shovelTool = char:FindFirstChild("Shovel")
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
                                    if success and data and data.GrowData and data.GrowData.BaseWeight then baseWeight = data.GrowData.BaseWeight; BaseWeightCache[fruitName] = baseWeight end
                                end
                            end
                            local overtimeGrowth = 1
                            if GardenSyncController then
                                pcall(function()
                                    local plantData = GardenSyncController:GetPlant(userId, plantId)
                                    if plantData and plantData.Fruits and plantData.Fruits[fruitId] then overtimeGrowth = plantData.Fruits[fruitId].OvertimeGrowth or 1 end
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

local SecShovelPlant = TabFarm:AddSection("Auto Shovel Plant", false)
local TargetShovelPlantsList, AutoShovelPlantOn = _G.Config.TargetShovelPlantsList, _G.Config.AutoShovelPlantOn
local DropdownShovelPlant

DropdownShovelPlant = SecShovelPlant:AddDropdown({ Title = "Select Plants to Destroy", Multi = true, Options = {"Scan Garden First!"}, Default = TargetShovelPlantsList, Callback = function(Opt) TargetShovelPlantsList = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetShovelPlantsList = TargetShovelPlantsList; _G.SaveConfig() end })

SecShovelPlant:AddButton({
    Title = "🔍 SCAN GARDEN FOR SHOVEL",
    Callback = function()
        local ditemukan = {}
        local plotId = LocalPlayer:GetAttribute("PlotId")
        if plotId then
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
            local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
            if plantsFolder then
                for _, p in ipairs(plantsFolder:GetChildren()) do
                    local name = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                    for _, mut in ipairs(ListMutasi) do name = string.gsub(name, mut .. " ", ""); name = string.gsub(name, mut, "") end
                    name = string.match(name, "^%s*(.-)%s*$") or name
                    if not table.find(ditemukan, name) and name ~= "" then table.insert(ditemukan, name) end
                end
                if #ditemukan > 0 then
                    table.sort(ditemukan)
                    pcall(function() DropdownShovelPlant:Refresh(ditemukan, {ditemukan[1]}) end)
                    TargetShovelPlantsList = {ditemukan[1]}; _G.Config.TargetShovelPlantsList = TargetShovelPlantsList; _G.SaveConfig()
                end
            end
        end
    end
})

SecShovelPlant:AddToggle({ Title = "▶️ ENABLE AUTO SHOVEL PLANT", Default = AutoShovelPlantOn, Callback = function(Value) AutoShovelPlantOn = Value; _G.Config.AutoShovelPlantOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoShovelPlantOn and Networking and #TargetShovelPlantsList > 0 then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                local shovelTool = char:FindFirstChild("Shovel")
                if not shovelTool then
                    local backpackShovel = LocalPlayer.Backpack:FindFirstChild("Shovel")
                    if backpackShovel and char:FindFirstChild("Humanoid") then
                        char.Humanoid:EquipTool(backpackShovel); shovelTool = backpackShovel; task.wait(0.5)
                    elseif Networking.GearShop and Networking.GearShop.EquipGear then
                        Networking.GearShop.EquipGear:Fire("Shovel"); task.wait(0.5); shovelTool = char:FindFirstChild("Shovel")
                    end
                end
                if shovelTool then
                    local shovelAttribute = shovelTool:GetAttribute("Shovel")
                    if not shovelAttribute then return end
                    local plotId = LocalPlayer:GetAttribute("PlotId")
                    if not plotId then return end
                    local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                    local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                            if not AutoShovelPlantOn then break end
                            local plantId = plantModel:GetAttribute("PlantId")
                            local fruitName = plantModel:GetAttribute("SeedName") or plantModel:GetAttribute("CorePartName") or plantModel.Name
                            for _, mut in ipairs(ListMutasi) do fruitName = string.gsub(fruitName, mut .. " ", ""); fruitName = string.gsub(fruitName, mut, "") end
                            fruitName = string.match(fruitName, "^%s*(.-)%s*$") or fruitName
                            if plantId and table.find(TargetShovelPlantsList, fruitName) then
                                local distance = (plantModel:GetPivot().Position - char:GetPivot().Position).Magnitude
                                if distance <= 15 then
                                    shovelTool:Activate()
                                    pcall(function() Networking.Shovel.SwingShovel:Fire(shovelTool) end)
                                    pcall(function() Networking.Shovel.UseShovel:Fire(plantId, "", shovelAttribute, shovelTool) end)
                                    task.wait(0.3)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local TabTool = Window:AddMainTab("🛠️ Tools", false)
local SecTrowel = TabTool:AddSection("Auto Trowel (Smart Magnet)", false)
local TargetTrowelPlants, AutoTrowelOn = _G.Config.TargetTrowelPlants, _G.Config.AutoTrowelOn
local DropdownTrowel

DropdownTrowel = SecTrowel:AddDropdown({ Title = "Select Plants to Pull", Multi = true, Options = {"Scan Garden First!"}, Default = TargetTrowelPlants, Callback = function(Opt) TargetTrowelPlants = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetTrowelPlants = TargetTrowelPlants; _G.SaveConfig() end })

SecTrowel:AddButton({
    Title = "🔍 SCAN GARDEN FOR TROWEL",
    Callback = function()
        local ditemukan = {}
        local plotId = LocalPlayer:GetAttribute("PlotId")
        if plotId then
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
            local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
            if plantsFolder then
                for _, p in ipairs(plantsFolder:GetChildren()) do
                    local name = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                    for _, mut in ipairs(ListMutasi) do name = string.gsub(name, mut .. " ", ""); name = string.gsub(name, mut, "") end
                    name = string.match(name, "^%s*(.-)%s*$") or name
                    if not table.find(ditemukan, name) and name ~= "" then table.insert(ditemukan, name) end
                end
                if #ditemukan > 0 then
                    table.sort(ditemukan)
                    pcall(function() DropdownTrowel:Refresh(ditemukan, {ditemukan[1]}) end)
                    TargetTrowelPlants = {ditemukan[1]}; _G.Config.TargetTrowelPlants = TargetTrowelPlants; _G.SaveConfig()
                end
            end
        end
    end
})

SecTrowel:AddToggle({ Title = "▶️ ENABLE MAGNET AURA", Default = AutoTrowelOn, Callback = function(Value) AutoTrowelOn = Value; _G.Config.AutoTrowelOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoTrowelOn and Networking and #TargetTrowelPlants > 0 then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local trowelTool = char:FindFirstChild("Trowel")
                if not trowelTool then
                    local backpackTrowel = LocalPlayer.Backpack:FindFirstChild("Trowel")
                    if backpackTrowel and char:FindFirstChild("Humanoid") then
                        char.Humanoid:EquipTool(backpackTrowel); trowelTool = backpackTrowel; task.wait(0.5)
                    elseif Networking.GearShop and Networking.GearShop.EquipGear then
                        Networking.GearShop.EquipGear:Fire("Trowel"); task.wait(0.5); trowelTool = char:FindFirstChild("Trowel")
                    end
                end
                if trowelTool then
                    local plotId = LocalPlayer:GetAttribute("PlotId")
                    if not plotId then return end
                    local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                    local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        local targetPos = hrp.Position - Vector3.new(0, 3, 0)
                        for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                            if not AutoTrowelOn then break end
                            local plantId = plantModel:GetAttribute("PlantId")
                            local fruitName = plantModel:GetAttribute("SeedName") or plantModel:GetAttribute("CorePartName") or plantModel.Name
                            for _, mut in ipairs(ListMutasi) do fruitName = string.gsub(fruitName, mut .. " ", ""); fruitName = string.gsub(fruitName, mut, "") end
                            fruitName = string.match(fruitName, "^%s*(.-)%s*$") or fruitName
                            if plantId and table.find(TargetTrowelPlants, fruitName) then
                                local currentPos = plantModel:GetPivot().Position
                                if (currentPos - targetPos).Magnitude > 3 then
                                    trowelTool:Activate()
                                    Networking.Trowel.MovePlant:Fire(plantId, targetPos, 0)
                                    task.wait(0.1) 
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local SecWater = TabTool:AddSection("Auto Watering Can", false)
local TargetWater, WaterDelay, AutoWaterOn = _G.Config.TargetWater, _G.Config.WaterDelay, _G.Config.AutoWaterOn
local DropWater

DropWater = SecWater:AddDropdown({ Title = "Select Plants to Water", Multi = true, Options = {"Scan First!"}, Default = TargetWater, Callback = function(Opt) TargetWater = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetWater = TargetWater; _G.SaveConfig() end })
SecWater:AddInput({ Title = "Water Delay (detik)", Default = tostring(WaterDelay), Callback = function(Value) WaterDelay = tonumber(Value) or 1.2; _G.Config.WaterDelay = WaterDelay; _G.SaveConfig() end })

SecWater:AddButton({
    Title = "🔍 SCAN GARDEN FOR WATERING",
    Callback = function()
        local d = {}
        local plotId = LocalPlayer:GetAttribute("PlotId")
        if plotId then
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
            local plants = myPlot and myPlot:FindFirstChild("Plants")
            if plants then
                for _, p in ipairs(plants:GetChildren()) do
                    local n = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                    for _, mut in ipairs(ListMutasi) do n = string.gsub(n, mut .. " ", ""); n = string.gsub(n, mut, "") end
                    n = string.match(n, "^%s*(.-)%s*$") or n
                    if not table.find(d, n) and n ~= "" then table.insert(d, n) end
                end
                if #d > 0 then
                    table.sort(d)
                    pcall(function() DropWater:Refresh(d, {d[1]}) end)
                    TargetWater = {d[1]}; _G.Config.TargetWater = TargetWater; _G.SaveConfig()
                end
            end
        end
    end
})

SecWater:AddToggle({ Title = "▶️ ENABLE AUTO WATERING", Default = AutoWaterOn, Callback = function(Value) AutoWaterOn = Value; _G.Config.AutoWaterOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoWaterOn and Networking and #TargetWater > 0 then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local water = char:FindFirstChildOfClass("Tool")
                if not (water and string.find(water.Name, "Watering Can")) then
                    if LocalPlayer.Backpack then
                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and string.find(tool.Name, "Watering Can") then
                                if char:FindFirstChild("Humanoid") then char.Humanoid:EquipTool(tool); water = tool; task.wait(0.5) end
                                break
                            end
                        end
                    end
                end
                if water then
                    local namaAlatPenyiram = water:GetAttribute("WateringCan")
                    if not namaAlatPenyiram then return end
                    local plotId = LocalPlayer:GetAttribute("PlotId")
                    local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                    local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
                    if plantsFolder then
                        for _, p in ipairs(plantsFolder:GetChildren()) do
                            if not AutoWaterOn then break end
                            local fName = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                            for _, mut in ipairs(ListMutasi) do fName = string.gsub(fName, mut .. " ", ""); fName = string.gsub(fName, mut, "") end
                            fName = string.match(fName, "^%s*(.-)%s*$") or fName
                            if table.find(TargetWater, fName) then
                                local targetPos = p:GetPivot().Position
                                if (targetPos - hrp.Position).Magnitude <= 40 then
                                    local rayParams = RaycastParams.new(); rayParams.FilterType = Enum.RaycastFilterType.Include; rayParams.FilterDescendantsInstances = CollectionService:GetTagged("PlantArea")
                                    local rayHit = workspace:Raycast(targetPos + Vector3.new(0, 5, 0), Vector3.new(0, -15, 0), rayParams)
                                    if rayHit then
                                        pcall(function() Networking.WateringCan.UseWateringCan:Fire(rayHit.Position - Vector3.new(0, 0.3, 0), namaAlatPenyiram, water) end)
                                        task.wait(WaterDelay) 
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local SecSprinkler = TabTool:AddSection("Auto Sprinkler", false)
local TargetSprinklerPlant, SelectedSprinklerType, SprinklerDelay, AutoSprinklerOn = _G.Config.TargetSprinklerPlant, _G.Config.SelectedSprinklerType, _G.Config.SprinklerDelay, _G.Config.AutoSprinklerOn
local DropSprinklerPlant, DropSprinklerType

DropSprinklerPlant = SecSprinkler:AddDropdown({ Title = "Select Plant Target", Multi = true, Options = {"Scan Garden First!"}, Default = TargetSprinklerPlant, Callback = function(Opt) TargetSprinklerPlant = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetSprinklerPlant = TargetSprinklerPlant; _G.SaveConfig() end })
DropSprinklerType = SecSprinkler:AddDropdown({ Title = "Select Sprinkler Type", Multi = false, Options = {"Scan Backpack First!"}, Default = {SelectedSprinklerType}, Callback = function(Opt) SelectedSprinklerType = type(Opt) == "table" and Opt[1] or Opt; _G.Config.SelectedSprinklerType = SelectedSprinklerType; _G.SaveConfig() end })

SecSprinkler:AddButton({
    Title = "🔍 SCAN GARDEN FOR PLANTS",
    Callback = function()
        local d = {}
        local plotId = LocalPlayer:GetAttribute("PlotId")
        if plotId then
            local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
            local plants = myPlot and myPlot:FindFirstChild("Plants")
            if plants then
                for _, p in ipairs(plants:GetChildren()) do
                    local n = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                    for _, mut in ipairs(ListMutasi) do n = string.gsub(n, mut .. " ", ""); n = string.gsub(n, mut, "") end
                    n = string.match(n, "^%s*(.-)%s*$") or n
                    if not table.find(d, n) and n ~= "" then table.insert(d, n) end
                end
                if #d > 0 then
                    table.sort(d)
                    pcall(function() DropSprinklerPlant:Refresh(d, {d[1]}) end)
                    TargetSprinklerPlant = {d[1]}; _G.Config.TargetSprinklerPlant = TargetSprinklerPlant; _G.SaveConfig()
                end
            end
        end
    end
})

SecSprinkler:AddButton({
    Title = "🎒 SCAN BACKPACK FOR SPRINKLERS",
    Callback = function()
        local d = {}
        local function scanW(w) if not w then return end; for _, i in ipairs(w:GetChildren()) do if i:IsA("Tool") and i:GetAttribute("Sprinkler") then local sN = i:GetAttribute("Sprinkler"); if not table.find(d, sN) then table.insert(d, sN) end end end end
        scanW(LocalPlayer.Backpack); scanW(LocalPlayer.Character)
        if #d > 0 then table.sort(d); pcall(function() DropSprinklerType:Refresh(d, {d[1]}) end); SelectedSprinklerType = d[1]; _G.Config.SelectedSprinklerType = SelectedSprinklerType; _G.SaveConfig() end
    end
})

SecSprinkler:AddInput({ Title = "Placement Delay (detik)", Default = tostring(SprinklerDelay), Callback = function(Value) SprinklerDelay = tonumber(Value) or 1.2; _G.Config.SprinklerDelay = SprinklerDelay; _G.SaveConfig() end })
SecSprinkler:AddToggle({ Title = "▶️ ENABLE AUTO SPRINKLER", Default = AutoSprinklerOn, Callback = function(Value) AutoSprinklerOn = Value; _G.Config.AutoSprinklerOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoSprinklerOn and Networking and #TargetSprinklerPlant > 0 and SelectedSprinklerType ~= "" then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                local plotId = LocalPlayer:GetAttribute("PlotId")
                if not hrp or not humanoid or not plotId then return end
                local function cariS(w) if not w then return nil end; for _, t in ipairs(w:GetChildren()) do if t:IsA("Tool") and t:GetAttribute("Sprinkler") == SelectedSprinklerType then return t end end end
                local sprinklerTool = cariS(char) or cariS(LocalPlayer.Backpack)
                if sprinklerTool then
                    if sprinklerTool.Parent ~= char then
                        humanoid:UnequipTools(); task.wait(0.05); humanoid:EquipTool(sprinklerTool)
                        local tOut = 0; while sprinklerTool.Parent ~= char and tOut < 15 do task.wait(0.1); tOut = tOut + 1 end
                    end
                    if sprinklerTool.Parent == char then
                        local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                        local plantsFolder = myPlot and myPlot:FindFirstChild("Plants")
                        if plantsFolder then
                            for _, p in ipairs(plantsFolder:GetChildren()) do
                                if not AutoSprinklerOn or sprinklerTool.Parent ~= char then break end
                                local fName = p:GetAttribute("SeedName") or p:GetAttribute("CorePartName") or p.Name
                                for _, mut in ipairs(ListMutasi) do fName = string.gsub(fName, mut .. " ", ""); fName = string.gsub(fName, mut, "") end
                                fName = string.match(fName, "^%s*(.-)%s*$") or fName
                                if table.find(TargetSprinklerPlant, fName) then
                                    local targetPos = p:GetPivot().Position
                                    if (targetPos - hrp.Position).Magnitude <= 40 then
                                        local rayParams = RaycastParams.new(); rayParams.FilterType = Enum.RaycastFilterType.Include; rayParams.FilterDescendantsInstances = CollectionService:GetTagged("PlantArea")
                                        local rayHit = workspace:Raycast(targetPos + Vector3.new(0, 5, 0), Vector3.new(0, -15, 0), rayParams)
                                        if rayHit then
                                            pcall(function() Networking.Place.PlaceSprinkler:Fire(rayHit.Position, SelectedSprinklerType, sprinklerTool, plotId) end)
                                            task.wait(SprinklerDelay)
                                            break 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

local TabBackpack = Window:AddMainTab("🎒 Backpack", false) 
local SecBackpack = TabBackpack:AddSection("Sell", false)
local SellInterval, AutoSellTimerOn, AutoSellFullOn = _G.Config.SellInterval, _G.Config.AutoSellTimerOn, _G.Config.AutoSellFullOn

SecBackpack:AddSlider({ Title = "Sell Timer (s)", Min = 10, Max = 600, Increment = 1, Default = SellInterval, Callback = function(Value) SellInterval = Value; _G.Config.SellInterval = Value; _G.SaveConfig() end })
SecBackpack:AddToggle({ Title = "Auto Sell by Timer", Default = AutoSellTimerOn, Callback = function(Value) AutoSellTimerOn = Value; _G.Config.AutoSellTimerOn = Value; _G.SaveConfig() end })
SecBackpack:AddToggle({ Title = "Auto Sell if Backpack Full", Default = AutoSellFullOn, Callback = function(Value) AutoSellFullOn = Value; _G.Config.AutoSellFullOn = Value; _G.SaveConfig() end })

local function EksekusiGhostSell()
    if Networking then pcall(function() Networking.NPCS.SellAll:Fire() end) end
end

task.spawn(function()
    local timerHitung = 0
    while task.wait(1) do
        if AutoSellTimerOn then timerHitung = timerHitung + 1; if timerHitung >= SellInterval then EksekusiGhostSell(); timerHitung = 0 end else timerHitung = 0 end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if AutoSellFullOn then
            pcall(function()
                local isiTas = LocalPlayer:GetAttribute("FruitCount") or 0
                local maxTas = LocalPlayer:GetAttribute("MaxFruitCapacity") or 100
                if isiTas >= maxTas and maxTas > 0 then EksekusiGhostSell(); task.wait(3) end
            end)
        end
    end
end)

-- ========================================================
-- 🛒 REPLACEMENT FOR TAB SHOP (FIXED OPTION GENERATOR)
-- ========================================================
local TabShop = Window:AddMainTab("🛒 Shop", false) 

-- Generator otomatis daftar lengkap item game untuk keperluan mode "By Name"
local ListGearsFull = {}
for _, list in pairs(DatabaseGearMentah) do
    for _, name in ipairs(list) do table.insert(ListGearsFull, name) end
end
table.sort(ListGearsFull)

local ListPropsFull = {}
for _, list in pairs(DatabasePropMentah) do
    for _, name in ipairs(list) do table.insert(ListPropsFull, name) end
end
table.sort(ListPropsFull)

-----------------------------------------------------------
-- 🌱 1. SECTION: AUTO BUY SEEDS
-----------------------------------------------------------
local SecBuy = TabShop:AddSection("Auto Buy Seeds", false)
local SelectModeBuy, SelectedBuyRarities, SelectedBuySeeds, AutoBuyOn = _G.Config.SelectModeBuy, _G.Config.SelectedBuyRarities, _G.Config.SelectedBuySeeds, _G.Config.AutoBuyOn
local DropdownBuySeedName

local function AmbilSeedBerdasarkanRarity()
    local cL = {}
    for k, v in pairs(SelectedBuyRarities) do 
        local rN = type(k) == "number" and v or k
        if (type(k) == "number" and true or v) and DatabaseMentah[rN] then 
            for _, s in ipairs(DatabaseMentah[rN]) do table.insert(cL, s) end 
        end 
    end
    return cL
end

SecBuy:AddDropdown({ Title = "Seed Select by", Options = {"By Rarity", "By Name"}, Default = {SelectModeBuy}, Callback = function(Opt) 
    SelectModeBuy = type(Opt) == "table" and Opt[1] or Opt; _G.Config.SelectModeBuy = SelectModeBuy; _G.SaveConfig() 
    if SelectModeBuy == "By Name" then 
        pcall(function() DropdownBuySeedName:Refresh(ListCropsGameBaru, SelectedBuySeeds) end)
        pcall(function() DropdownBuySeedName:SetOptions(ListCropsGameBaru) end)
    else 
        local cL = AmbilSeedBerdasarkanRarity(); 
        if #cL > 0 then 
            pcall(function() DropdownBuySeedName:Refresh(cL, {cL[1]}) end) 
            pcall(function() DropdownBuySeedName:SetOptions(cL) end) 
        end 
    end end 
})
SecBuy:AddDropdown({ Title = "Seed Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"}, Default = SelectedBuyRarities, Callback = function(Opt) 
    SelectedBuyRarities = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedBuyRarities = SelectedBuyRarities; _G.SaveConfig()
    if SelectModeBuy == "By Rarity" then 
        local cL = AmbilSeedBerdasarkanRarity()
        if #cL > 0 then 
            pcall(function() DropdownBuySeedName:Refresh(cL, {cL[1]}) end)
            pcall(function() DropdownBuySeedName:SetOptions(cL) end)
            SelectedBuySeeds = {cL[1]}; _G.Config.SelectedBuySeeds = SelectedBuySeeds; _G.SaveConfig() 
        end 
    end end 
})
local OpsiAwalSeed = (SelectModeBuy == "By Name") and ListCropsGameBaru or AmbilSeedBerdasarkanRarity()
DropdownBuySeedName = SecBuy:AddDropdown({ Title = "Seed Name", Multi = true, Options = #OpsiAwalSeed > 0 and OpsiAwalSeed or DatabaseMentah["Common"], Default = SelectedBuySeeds, Callback = function(Opt) SelectedBuySeeds = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedBuySeeds = SelectedBuySeeds; _G.SaveConfig() end })
SecBuy:AddToggle({ Title = "Auto Buy Seed", Default = AutoBuyOn, Callback = function(Value) AutoBuyOn = Value; _G.Config.AutoBuyOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.2) do 
        if AutoBuyOn and Networking then
            pcall(function()
                local pool = {}
                if SelectModeBuy == "By Rarity" then
                    for k, v in pairs(SelectedBuyRarities) do local r = type(k) == "number" and v or k; if (type(k) == "number" and true or v) and DatabaseMentah[r] then for _, s in ipairs(DatabaseMentah[r]) do table.insert(pool, s) end end end
                else
                    for k, v in pairs(SelectedBuySeeds) do local s = type(k) == "number" and v or k; if (type(k) == "number" and true or v) and s ~= "" then table.insert(pool, s) end end
                end
                if #pool > 0 then Networking.SeedShop.PurchaseSeed:Fire(pool[math.random(#pool)]) end
            end)
        end
    end
end)

-----------------------------------------------------------
-- 🛠️ 2. SECTION: AUTO BUY GEAR
-----------------------------------------------------------
local SecGear = TabShop:AddSection("Auto Buy Gear", false)
local SelectModeGear, SelectedGearRarities, SelectedGears, AutoBuyGearOn = _G.Config.SelectModeGear, _G.Config.SelectedGearRarities, _G.Config.SelectedGears, _G.Config.AutoBuyGearOn
local DropdownGearName

local function AmbilGearBerdasarkanRarity()
    local cL = {}
    for k, v in pairs(SelectedGearRarities) do 
        local rN = type(k) == "number" and v or k
        if (type(k) == "number" and true or v) and DatabaseGearMentah[rN] then 
            for _, g in ipairs(DatabaseGearMentah[rN]) do table.insert(cL, g) end 
        end 
    end
    return cL
end

SecGear:AddDropdown({ Title = "Gear Select by", Options = {"By Rarity", "By Name"}, Default = {SelectModeGear}, Callback = function(Opt) 
    SelectModeGear = type(Opt) == "table" and Opt[1] or Opt; _G.Config.SelectModeGear = SelectModeGear; _G.SaveConfig()
    if SelectModeGear == "By Name" then 
        pcall(function() DropdownGearName:Refresh(ListGearsFull, SelectedGears) end)
        pcall(function() DropdownGearName:SetOptions(ListGearsFull) end)
    else 
        local cL = AmbilGearBerdasarkanRarity(); 
        if #cL > 0 then 
            pcall(function() DropdownGearName:Refresh(cL, {cL[1]}) end) 
            pcall(function() DropdownGearName:SetOptions(cL) end) 
        end 
    end end 
})
SecGear:AddDropdown({ Title = "Gear Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Super"}, Default = SelectedGearRarities, Callback = function(Opt) 
    SelectedGearRarities = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedGearRarities = SelectedGearRarities; _G.SaveConfig()
    if SelectModeGear == "By Rarity" then 
        local cL = AmbilGearBerdasarkanRarity()
        if #cL > 0 then 
            pcall(function() DropdownGearName:Refresh(cL, {cL[1]}) end)
            pcall(function() DropdownGearName:SetOptions(cL) end)
            SelectedGears = {cL[1]}; _G.Config.SelectedGears = SelectedGears; _G.SaveConfig() 
        end
    end end 
})
local OpsiAwalGear = (SelectModeGear == "By Name") and ListGearsFull or AmbilGearBerdasarkanRarity()
DropdownGearName = SecGear:AddDropdown({ Title = "Gear Name", Multi = true, Options = #OpsiAwalGear > 0 and OpsiAwalGear or DatabaseGearMentah["Common"], Default = SelectedGears, Callback = function(Opt) SelectedGears = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedGears = SelectedGears; _G.SaveConfig() end })
SecGear:AddToggle({ Title = "Auto Buy Gear", Default = AutoBuyGearOn, Callback = function(Value) AutoBuyGearOn = Value; _G.Config.AutoBuyGearOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(0.5) do
        if AutoBuyGearOn and Networking then
            pcall(function()
                local pool = {}
                if SelectModeGear == "By Rarity" then
                    for k, v in pairs(SelectedGearRarities) do local r = type(k) == "number" and v or k; if (type(k) == "number" and true or v) and DatabaseGearMentah[r] then for _, g in ipairs(DatabaseGearMentah[r]) do table.insert(pool, g) end end end
                else
                    for k, v in pairs(SelectedGears) do local g = type(k) == "number" and v or k; if (type(k) == "number" and true or v) and g ~= "" then table.insert(pool, g) end end
                end
                if #pool > 0 then Networking.GearShop.PurchaseGear:Fire(pool[math.random(#pool)]) end
            end)
        end
    end
end)

-----------------------------------------------------------
-- 📦 3. SECTION: AUTO BUY PROPS
-----------------------------------------------------------
local SecProp = TabShop:AddSection("Auto Buy Props", false)
local SelectModeProp, SelectedPropRarities, SelectedProps, AutoBuyPropOn = _G.Config.SelectModeProp, _G.Config.SelectedPropRarities, _G.Config.SelectedProps, _G.Config.AutoBuyPropOn
local DropdownPropName

local function AmbilPropBerdasarkanRarity()
    local cL = {}
    for k, v in pairs(SelectedPropRarities) do 
        local rN = type(k) == "number" and v or k
        if (type(k) == "number" and true or v) and DatabasePropMentah[rN] then 
            for _, p in ipairs(DatabasePropMentah[rN]) do table.insert(cL, p) end 
        end 
    end
    return cL
end

SecProp:AddDropdown({ Title = "Prop Select by", Options = {"By Rarity", "By Name"}, Default = {SelectModeProp}, Callback = function(Opt) 
    SelectModeProp = type(Opt) == "table" and Opt[1] or Opt; _G.Config.SelectModeProp = SelectModeProp; _G.SaveConfig()
    if SelectModeProp == "By Name" then 
        pcall(function() DropdownPropName:Refresh(ListPropsFull, SelectedProps) end)
        pcall(function() DropdownPropName:SetOptions(ListPropsFull) end)
    else 
        local cL = AmbilPropBerdasarkanRarity(); 
        if #cL > 0 then 
            pcall(function() DropdownPropName:Refresh(cL, {cL[1]}) end) 
            pcall(function() DropdownPropName:SetOptions(cL) end) 
        end 
    end end 
})
SecProp:AddDropdown({ Title = "Prop Rarity", Multi = true, Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic"}, Default = SelectedPropRarities, Callback = function(Opt) 
    SelectedPropRarities = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedPropRarities = SelectedPropRarities; _G.SaveConfig()
    if SelectModeProp == "By Rarity" then 
        local cL = AmbilPropBerdasarkanRarity()
        if #cL > 0 then 
            pcall(function() DropdownPropName:Refresh(cL, {cL[1]}) end)
            pcall(function() DropdownPropName:SetOptions(cL) end)
            SelectedProps = {cL[1]}; _G.Config.SelectedProps = SelectedProps; _G.SaveConfig() 
        end
    end end 
})
local OpsiAwalProp = (SelectModeProp == "By Name") and ListPropsFull or AmbilPropBerdasarkanRarity()
DropdownPropName = SecProp:AddDropdown({ Title = "Prop Name", Multi = true, Options = #OpsiAwalProp > 0 and OpsiAwalProp or DatabasePropMentah["Common"], Default = SelectedProps, Callback = function(Opt) SelectedProps = type(Opt) == "table" and Opt or {Opt}; _G.Config.SelectedProps = SelectedProps; _G.SaveConfig() end })
SecProp:AddToggle({ Title = "Auto Buy Prop", Default = AutoBuyPropOn, Callback = function(Value) AutoBuyPropOn = Value; _G.Config.AutoBuyPropOn = Value; _G.SaveConfig() end })

local SecSnipePet = TabShop:AddSection("Auto Buy Wild Pet", false)
local ListSemuaPet = {"Dog", "Cat", "Bunny"} 
pcall(function() local petMods = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("PetModules")); if petMods and type(petMods) == "table" then ListSemuaPet = {}; for petName, _ in pairs(petMods) do table.insert(ListSemuaPet, petName) end; table.sort(ListSemuaPet) end end)

local TargetSnipePets, HopDelay, AutoSnipePetOn, AutoHopPetOn = _G.Config.TargetSnipePets, _G.Config.HopDelay, _G.Config.AutoSnipePetOn, _G.Config.AutoHopPetOn

local function EksekusiServerHop()
    Speed_Library:SetNotification({Title = "🔄 Server Hop", Content = "Mencari server baru dalam " .. HopDelay .. " detik...", Time = HopDelay}); task.wait(HopDelay)
    local HttpService, TeleportService, placeId = game:GetService("HttpService"), game:GetService("TeleportService"), game.PlaceId
    local success, result = pcall(function() return game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100") end)
    if success and result then
        local data = HttpService:JSONDecode(result)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then 
                    pcall(function() if _G.TriggerFullInstantHop then _G.TriggerFullInstantHop() end end)
                    TeleportService:TeleportToPlaceInstance(placeId, server.id, LocalPlayer)
                    task.wait(5)
                    break 
                end
            end
        end
    end
end

SecSnipePet:AddDropdown({ Title = "🎯 Select Target Pets", Multi = true, Options = ListSemuaPet, Default = TargetSnipePets, Callback = function(Opt) TargetSnipePets = type(Opt) == "table" and Opt or {Opt}; _G.Config.TargetSnipePets = TargetSnipePets; _G.SaveConfig() end })
SecSnipePet:AddInput({ Title = "⏳ Server Hop Delay (Detik)", Default = tostring(HopDelay), Callback = function(Value) HopDelay = tonumber(Value) or 5; _G.Config.HopDelay = HopDelay; _G.SaveConfig() end })
SecSnipePet:AddToggle({ Title = "▶️ ENABLE AUTO BUY PET", Default = AutoSnipePetOn, Callback = function(Value) AutoSnipePetOn = Value; _G.Config.AutoSnipePetOn = Value; _G.SaveConfig() end })
SecSnipePet:AddToggle({ Title = "🔄 ENABLE AUTO HOP SERVER", Default = AutoHopPetOn, Callback = function(Value) AutoHopPetOn = Value; _G.Config.AutoHopPetOn = Value; _G.SaveConfig() end })

task.spawn(function()
    while task.wait(1) do
        if AutoSnipePetOn and Networking then
            local map = workspace:FindFirstChild("Map"); local wildPetRef = map and map:FindFirstChild("WildPetRef"); local petTargetDitemukan = false
            if wildPetRef and #TargetSnipePets > 0 then
                for _, petPart in ipairs(wildPetRef:GetChildren()) do
                    if petPart:IsA("BasePart") then
                        local ownerId = petPart:GetAttribute("OwnerUserId")
                        if (type(ownerId) ~= "number" or ownerId == 0) then
                            local petName = petPart:GetAttribute("PetName")
                            if petName and table.find(TargetSnipePets, petName) then
                                petTargetDitemukan = true
                                local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local posisiAwal = hrp.CFrame
                                    hrp.CFrame = petPart.CFrame * CFrame.new(0, 3, 0); task.wait(0.3)
                                    pcall(function() Networking.Pets.WildPetTame:Fire(petPart) end)
                                    task.wait(0.5); hrp.CFrame = posisiAwal; task.wait(1)
                                end
                            end
                        end
                    end
                end
            end
            if AutoHopPetOn and not petTargetDitemukan and #TargetSnipePets > 0 then EksekusiServerHop() end
        end
    end
end)

local TabMisc = Window:AddMainTab("⚙️ Misc", false)
local SecBypass = TabMisc:AddSection("Instant Loading Bypass", false)
    SecBypass:AddParagraph({Title = "Status: Permanently Active (0 Delay)", Content = ""})

local SecESP = TabMisc:AddSection("Visual Features", false)
local FruitESPOn = _G.Config.FruitESPOn

SecESP:AddToggle({ Title = "👁️ Fruit Weight ESP", Default = FruitESPOn, Callback = function(Value) FruitESPOn = Value; _G.Config.FruitESPOn = Value; _G.SaveConfig(); if not Value then pcall(function() for _, obj in ipairs(workspace:GetDescendants()) do if obj:IsA("BillboardGui") and obj.Name == "MyWeightESP" then obj:Destroy() end end end) end end })

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
                        if not baseWeight and FruitsDB then local fruitMod = FruitsDB:FindFirstChild(fruitName); if fruitMod then local success, data = pcall(require, fruitMod); if success and data and data.GrowData and data.GrowData.BaseWeight then baseWeight = data.GrowData.BaseWeight; BaseWeightCache[fruitName] = baseWeight end end end
                        local overtimeGrowth = 1
                        if GardenSyncController then pcall(function() local plantData = GardenSyncController:GetPlant(userId, plantId); if plantData and plantData.Fruits and plantData.Fruits[fruitId] then overtimeGrowth = plantData.Fruits[fruitId].OvertimeGrowth or 1 end end) end
                        if baseWeight then
                            local totalWeight = baseWeight * sizeMulti * overtimeGrowth
                            local formattedWeight = string.format("%.2f", totalWeight)
                            local weightText = fruitName .. "\n🎯 " .. formattedWeight .. " kg"
                            local existingGui = object:FindFirstChild("MyWeightESP")
                            if not existingGui then
                                local billboard = Instance.new("BillboardGui"); billboard.Name = "MyWeightESP"; billboard.Adornee = object; billboard.Size = UDim2.new(0, 150, 0, 60); billboard.StudsOffset = Vector3.new(0, 3.5, 0); billboard.AlwaysOnTop = true
                                local textLabel = Instance.new("TextLabel"); textLabel.Name = "WeightText"; textLabel.Parent = billboard; textLabel.Size = UDim2.new(1, 0, 1, 0); textLabel.BackgroundTransparency = 1; textLabel.TextColor3 = Color3.new(1, 0.8, 0); textLabel.TextStrokeTransparency = 0; textLabel.TextSize = 16; textLabel.Font = Enum.Font.GothamBold; textLabel.TextWrapped = true; billboard.Parent = object
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

local SecSniper = TabMisc:AddSection("Seed Sniper (Ultra Fast)", false)
local AutoTP, AutoClaim, PotatoMode = _G.Config.AutoTP, _G.Config.AutoClaim, _G.Config.PotatoMode

SecSniper:AddToggle({ Title = "🚀 Auto-TP Rainbow/Gold Seed", Default = AutoTP, Callback = function(v) AutoTP = v; _G.Config.AutoTP = v; _G.SaveConfig() end})
SecSniper:AddToggle({Title = "💎 Auto-Claim Instant", Default = AutoClaim, Callback = function(v) AutoClaim = v; _G.Config.AutoClaim = v; _G.SaveConfig() end})

local function StartSeedSniper()
    local ServerLocations = game:GetService("Workspace").Map.SeedPackSpawnServerLocations
    ServerLocations.ChildAdded:Connect(function(child)
        task.spawn(function()
            -- Tunggu sampai atribut bawaan benih muncul sempurna di workspace
            repeat task.wait() until child:GetAttribute("SeedPack") ~= nil or child:GetAttribute("RainbowSeed") or child:GetAttribute("GoldSeed")
            
            local isRainbow = child:GetAttribute("RainbowSeed") == true
            local isGold = child:GetAttribute("GoldSeed") == true
            
            if (isRainbow or isGold) and AutoTP then
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    -- 🎯 AMBIL TITIK TENTAH OBJEK (Anti-Meleset)
                    -- Jika box berbentuk model kompleks, kita ambil Center Pivot-nya
                    local targetCFrame = child:IsA("Model") and child:GetPivot() or (child:IsA("BasePart") and child.CFrame)
                    
                    if targetCFrame then
                        -- 🛑 RESET FISIKA BADAN (Pencegah Karakter Meluncur/Nge-slide)
                        pcall(function()
                            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        end)
                        
                        -- Teleport pas di atas objek benih emas (Offset Y diturunkan ke 1.5 biar nempel)
                        hrp.CFrame = targetCFrame * CFrame.new(0, 1.5, 0)
                        
                        -- ⏳ JEDA KRUSIAL REPLIKASI SERVER (Sweet Spot untuk Emulator MuMu)
                        -- Memberi waktu 0.15 detik agar server sadar koordinat lu udah pindah tepat di atas benih
                        task.wait(0.15) 
                        
                        if AutoClaim then
                            pcall(function()
                                local Net = require(game:GetService("ReplicatedStorage").SharedModules.Networking)
                                if Net and Net.SeedPack and Net.SeedPack.Claim then
                                    -- Tembak paket klaim instan langsung lewat Remote asli game
                                    if type(Net.SeedPack.Claim) == "table" and Net.SeedPack.Claim.Fire then
                                        Net.SeedPack.Claim:Fire(child)
                                    elseif typeof(Net.SeedPack.Claim) == "Instance" and Net.SeedPack.Claim:IsA("RemoteEvent") then
                                        Net.SeedPack.Claim:FireServer(child)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end)
    end)
end

task.spawn(function()
    pcall(function() for _, connection in pairs(getconnections(LocalPlayer.Idled)) do if connection.Disable then connection:Disable() elseif connection.Disconnect then connection:Disconnect() end end end)
    while task.wait(5) do pcall(function() LocalPlayer:SetAttribute("AntiAfkIdleOverride", 999999999) end) end
end)

local SecPotato = TabMisc:AddSection("Potato Mode (Optimasi)", false)

local function EksekusiPotatoMode()
    task.spawn(function()
        local Workspace = game:GetService("Workspace")
        local Lighting = game:GetService("Lighting")
        local Terrain = Workspace:WaitForChild("Terrain")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("Atmosphere") or effect:IsA("Sky") then
                pcall(function() effect.Enabled = false end)
            end
        end
        pcall(function()
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false 
        end)
        local function OptimasiObjek(obj)
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
                obj.Reflectance = 0
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1 
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false 
            end
        end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            task.spawn(function() pcall(function() OptimasiObjek(obj) end) end)
        end
        Workspace.DescendantAdded:Connect(function(obj)
            pcall(function() OptimasiObjek(obj) end)
        end)
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    end)
end

SecPotato:AddToggle({
    Title = "🥔 Potato Mode", 
    Default = PotatoMode, 
    Callback = function(v) 
        PotatoMode = v
        _G.Config.PotatoMode = v
        _G.SaveConfig() 
        if v then EksekusiPotatoMode() end
    end
})

if PotatoMode then EksekusiPotatoMode() end

local SecHardcore = TabMisc:AddSection("Hardcore AFK Saver", false)

local function formatAngka(angka)
    local str = tostring(math.floor(math.abs(angka or 0)))
    return string.reverse((string.reverse(str):gsub("%d%d%d", "%1,"))):gsub("^,", "")
end

SecHardcore:AddButton({
    Title = "📺 Aktifkan Layar Hitam (Live Dashboard)",
    Callback = function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "TrueAFKMode"
        gui.IgnoreGuiInset = true
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(0, 0, 0)
        frame.Parent = gui
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0.3, 0)
        title.Position = UDim2.new(0, 0, 0.1, 0)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(0, 255, 0)
        title.Font = Enum.Font.Code
        title.TextSize = 25
        title.Text = "🥶 TRUE AFK MODE AKTIF 🥶"
        title.Parent = frame
        local statsText = Instance.new("TextLabel")
        statsText.Size = UDim2.new(1, 0, 0.4, 0)
        statsText.Position = UDim2.new(0, 0, 0.4, 0)
        statsText.BackgroundTransparency = 1
        statsText.TextColor3 = Color3.fromRGB(0, 255, 255)
        statsText.Font = Enum.Font.Code
        statsText.TextSize = 20
        statsText.Text = "Memuat data..."
        statsText.Parent = frame
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 200, 0, 50)
        closeBtn.Position = UDim2.new(0.5, -100, 0.8, 0)
        closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 16
        closeBtn.Text = "TUTUP AFK MODE"
        closeBtn.Parent = frame
        pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not gui.Parent then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
        pcall(function() setfpscap(5) end)
        pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(false) end)
        local startTime = os.time()
        _G.AFKStatsLoop = task.spawn(function()
            while task.wait(1) do
                if not gui or not gui.Parent then break end
                local elapsed = os.time() - startTime
                local h = math.floor(elapsed / 3600)
                local m = math.floor((elapsed % 3600) / 60)
                local s = elapsed % 60
                local timeStr = string.format("%02d Jam, %02d Menit, %02d Detik", h, m, s)
                local lp = game:GetService("Players").LocalPlayer
                local isiTas = lp:GetAttribute("FruitCount") or 0
                local maxTas = lp:GetAttribute("MaxFruitCapacity") or 0
                local coins = 0
                pcall(function()
                    local ls = lp:FindFirstChild("leaderstats")
                    if ls and ls:FindFirstChild("Sheckles") then coins = ls.Sheckles.Value end
                end)
                statsText.Text = "⏳ Durasi AFK: " .. timeStr .. "\n\n" .. "💰 Total Koin: ¢" .. formatAngka(coins) .. "\n\n" .. "🎒 Isi Tas: " .. formatAngka(isiTas) .. " / " .. formatAngka(maxTas)
            end
        end)
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            pcall(function() setfpscap(60) end)
            pcall(function() game:GetService("RunService"):Set3dRenderingEnabled(true) end)
            if _G.AFKStatsLoop then task.cancel(_G.AFKStatsLoop) end
        end)
    end
})

local RejoinTimer = 4
SecHardcore:AddInput({
    Title = "Auto Rejoin Tiap (Jam)",
    Default = "4",
    Callback = function(Value) RejoinTimer = tonumber(Value) or 4 end
})

SecHardcore:AddToggle({
    Title = "🔄 Aktifkan Auto Rejoin (Pencegah Lag)",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.AutoRejoinLoop = task.spawn(function()
                task.wait(RejoinTimer * 3600) 
                local ts = game:GetService("TeleportService")
                local p = game:GetService("Players").LocalPlayer
                pcall(function() if _G.TriggerFullInstantHop then _G.TriggerFullInstantHop() end end)
                ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
            end)
        else
            if _G.AutoRejoinLoop then task.cancel(_G.AutoRejoinLoop) end
        end
    end
})

local AutoReconnectOn = _G.Config.AutoReconnectOn

SecHardcore:AddToggle({
    Title = "⚡ Enable Auto Reconnect",
    Default = AutoReconnectOn,
    Callback = function(Value)
        AutoReconnectOn = Value
        _G.Config.AutoReconnectOn = Value
        _G.SaveConfig() 
    end
})

task.spawn(function()
    local GuiService = game:GetService("GuiService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    GuiService.ErrorMessageChanged:Connect(function()
        if AutoReconnectOn then
            pcall(function() if _G.TriggerFullInstantHop then _G.TriggerFullInstantHop() end end)
            pcall(function() TeleportService:Teleport(game.PlaceId, Players.LocalPlayer) end)
            task.wait(0.5)
            pcall(function()
                local CoreGui = game:GetService("CoreGui")
                local prompt = CoreGui:FindFirstChild("RobloxPromptGui")
                if prompt then
                    local confirmBtn = prompt.promptOverlay:FindFirstChild("ErrorPrompt") and prompt.promptOverlay.ErrorPrompt.MessageArea.ErrorFrame.ButtonArea:FindFirstChild("LeaveButton")
                    if confirmBtn then
                        local VirtualInputManager = game:GetService("VirtualInputManager")
                        VirtualInputManager:SendMouseButtonEvent(confirmBtn.AbsolutePosition.X + (confirmBtn.AbsoluteSize.X / 2), confirmBtn.AbsolutePosition.Y + (confirmBtn.AbsoluteSize.Y / 2), 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(confirmBtn.AbsolutePosition.X + (confirmBtn.AbsoluteSize.X / 2), confirmBtn.AbsolutePosition.Y + (confirmBtn.AbsoluteSize.Y / 2), 0, false, game, 1)
                    end
                end
            end)
        end
    end)
end)

local SecAntiFling = TabMisc:AddSection("Anti-Fling & Protection", false)
local AntiFlingOn = _G.Config.AntiFlingOn or false

SecAntiFling:AddToggle({
    Title = "🛡️ Enable Anti-Fling",
    Default = AntiFlingOn,
    Callback = function(Value) AntiFlingOn = Value; _G.Config.AntiFlingOn = Value; _G.SaveConfig() end
})

task.spawn(function()
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    RunService.Stepped:Connect(function()
        if AntiFlingOn then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end
        end
    end)
end)

local TabLive = Window:AddMainTab("Live Panel", false)
local SecLive = TabLive:AddSection("Panel Kontrol", false)

local LiveShopPanel = SecLive:AddPopUpLive({Title = "🖥️ Buka Live Shop", Content = "Munculkan panel toko mengambang di layar", PanelTitle = "LIVE SHOP SYNC"})
task.spawn(function()
    -- Ambil folder data Stock asli milik game
    local SeedShopFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("SeedShop")
    local StockFolder = SeedShopFolder:WaitForChild("Items")
    local UnixNextRestock = SeedShopFolder:WaitForChild("UnixNextRestock") -- Objek waktu restock dari decompile pasar

    while task.wait(1) do 
        if LiveShopPanel:IsVisible() then 
            
            -- 🕒 INTERPRETASI MATEMATIKA UNIX TIMESTAMP (PRESISI & ANTI-LAG)
            local textTimer = "⏳ Menunggu Restock..."
            if UnixNextRestock then
                local targetTime = UnixNextRestock.Value or 0 -- Waktu restock server (Detik)
                local currentTime = os.time()                 -- Waktu saat ini (Detik)
                local diff = targetTime - currentTime         -- Mencari selisih detiknya
                
                if diff > 0 then
                    local m = math.floor(diff / 60)
                    local s = diff % 60
                    textTimer = string.format("⏳ Restock in %02dm %02ds", m, s)
                else
                    textTimer = "⏳ Restocking..."
                end
            end

            local success, SeedData = pcall(function() return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("SeedData")) end)
            if success and type(SeedData) == "table" then
                local ActiveShopItems = {}
                for _, s in ipairs(SeedData) do if s.RestockShop and s.SeedName then table.insert(ActiveShopItems, s) end end
                table.sort(ActiveShopItems, function(a, b) local oA, oB = a.SeedShopDisplayOrder or 9999, b.SeedShopDisplayOrder or 9999; if oA == oB then return a.SeedName < b.SeedName end; return oA < oB end)
                local contentText, currentRarity, lines = textTimer .. "\n\n", "", 3 
                if #ActiveShopItems > 0 then
                    for _, s in ipairs(ActiveShopItems) do
                        if s.Rarity ~= currentRarity then currentRarity = s.Rarity or "Unknown"; contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"; lines = lines + 1 end
                        local stok = "0"; local stI = StockFolder:FindFirstChild(s.SeedName); if stI then if stI:IsA("IntValue") or stI:IsA("NumberValue") or stI:IsA("StringValue") then stok = tostring(stI.Value) end end
                        contentText = contentText .. " • " .. s.SeedName .. " (x" .. stok .. ")\n"; lines = lines + 1
                    end
                else contentText = contentText .. "Toko sedang kosong!\n" end
                LiveShopPanel:Set(contentText, lines)
            end
        end
    end
end)

local LiveGearPanel = SecLive:AddPopUpLive({Title = "🖥️ Buka Live Gear Shop", Content = "Munculkan panel toko alat (Gear) mengambang", PanelTitle = "LIVE GEAR SYNC", Icon = "rbxassetid://136890595976124"})
task.spawn(function()
    local GearStockFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("GearShop"):WaitForChild("Items")
    local RarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mythic"]=6, ["Super"]=7}
    while task.wait(1) do 
        if LiveGearPanel:IsVisible() then 
            local textTimer = "⏳ Menunggu Restock..."
            local gearShopUI = LocalPlayer.PlayerGui:FindFirstChild("GearShop")
            if gearShopUI then for _, o in ipairs(gearShopUI:GetDescendants()) do if o:IsA("TextLabel") and string.find(string.lower(o.Text), "restock in") then textTimer = "⏳ " .. o.Text; break end end end
            local success, GearDataMod = pcall(function() return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("GearShopData")) end)
            if success and type(GearDataMod) == "table" and type(GearDataMod.Data) == "table" then
                local ActiveGearItems = {}
                for _, g in ipairs(GearDataMod.Data) do if not g.RobuxOnly and (g.RestockChance or g.EquippableGear) and g.ItemName then local isI = g.EquippableGear or GearStockFolder:FindFirstChild(g.ItemName); if isI then table.insert(ActiveGearItems, g) end end end
                table.sort(ActiveGearItems, function(a, b) local oA, oB = RarityOrder[a.Rarity] or 0, RarityOrder[b.Rarity] or 0; return oA < oB end)
                local contentText, currentRarity, lines = textTimer .. "\n\n", "", 3 
                if #ActiveGearItems > 0 then
                    for _, g in ipairs(ActiveGearItems) do
                        if g.Rarity ~= currentRarity then currentRarity = g.Rarity or "Unknown"; contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"; lines = lines + 1 end
                        local nG = g.ItemName; local dN = (nG == "Crowbar") and "Door Crowbar" or nG
                        local stok = "∞"; local stI = GearStockFolder:FindFirstChild(nG)
                        if stI then if stI:IsA("IntValue") or stI:IsA("NumberValue") or stI:IsA("StringValue") then stok = tostring(stI.Value) end else if not g.EquippableGear then stok = "0" end end
                        contentText = contentText .. " • " .. dN .. " (x" .. stok .. ")\n"; lines = lines + 1
                    end
                else contentText = contentText .. "Toko sedang kosong!\n" end
                LiveGearPanel:Set(contentText, lines)
            end
        end
    end
end)

local LiveCratePanel = SecLive:AddPopUpLive({Title = "🖥️ Buka Live Crate Shop", Content = "Munculkan panel toko peti (Crate) mengambang", PanelTitle = "LIVE CRATE SYNC", Icon = "rbxassetid://136890595976124"})
task.spawn(function()
    local CrateStockFolder = ReplicatedStorage:WaitForChild("StockValues"):WaitForChild("CrateShop"):WaitForChild("Items")
    local RarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mythic"]=6, ["Super"]=7}
    while task.wait(1) do 
        if LiveCratePanel:IsVisible() then 
            local textTimer = "⏳ Menunggu Restock..."
            local crateShopUI = LocalPlayer.PlayerGui:FindFirstChild("CrateShop")
            if crateShopUI then for _, o in ipairs(crateShopUI:GetDescendants()) do if o:IsA("TextLabel") and string.find(string.lower(o.Text), "restock in") then textTimer = "⏳ " .. o.Text; break end end end
            local success, CrateDataMod = pcall(function() return require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("CrateData")) end)
            if success and type(CrateDataMod) == "table" and type(CrateDataMod.GetAllCrates) == "function" then
                local ActiveCrateItems = {}
                local allCrates = CrateDataMod.GetAllCrates()
                for _, c in pairs(allCrates) do if c.RestockChance and c.Name and CrateStockFolder:FindFirstChild(c.Name) then table.insert(ActiveCrateItems, c) end end
                local contentText, currentRarity, lines = textTimer .. "\n\n", "", 3 
                if #ActiveCrateItems > 0 then
                    for _, c in ipairs(ActiveCrateItems) do
                        if c.Rarity ~= currentRarity then currentRarity = c.Rarity or "Unknown"; contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"; lines = lines + 1 end
                        local stok = "0"; local stI = CrateStockFolder:FindFirstChild(c.Name); if stI then if stI:IsA("IntValue") or stI:IsA("NumberValue") or stI:IsA("StringValue") then stok = tostring(stI.Value) end end
                        contentText = contentText .. " • " .. c.Name .. " (x" .. stok .. ")\n"; lines = lines + 1
                    end
                else contentText = contentText .. "Toko sedang kosong!\n" end
                LiveCratePanel:Set(contentText, lines)
            end
        end
    end
end)

local LivePetPanel = SecLive:AddPopUpLive({Title = "🖥️ Buka Live Pet Radar", Content = "Munculkan panel radar pemantau pet liar di map", PanelTitle = "LIVE PET RADAR", Icon = "rbxassetid://136890595976124"})
task.spawn(function()
    local RarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mythic"]=6, ["Super"]=7}
    while task.wait(1) do 
        if LivePetPanel:IsVisible() then 
            local map = workspace:FindFirstChild("Map"); local wildPetRef = map and map:FindFirstChild("WildPetRef"); local ActivePets = {}
            if wildPetRef then
                for _, p in ipairs(wildPetRef:GetChildren()) do
                    if p:IsA("BasePart") then
                        local oId = p:GetAttribute("OwnerUserId"); if type(oId) == "number" and oId ~= 0 then continue end
                        local pN, r, pr = p:GetAttribute("PetName"), p:GetAttribute("Rarity") or "Common", p:GetAttribute("Price") or 0
                        local sW = (p:GetAttribute("SpawnedAt") or os.time()) + (p:GetAttribute("Lifetime") or 0) - os.time()
                        if pN and sW > 0 then table.insert(ActivePets, {Name = pN, Rarity = r, Price = pr, TimeLeft = sW}) end
                    end
                end
            end
            local contentText, currentRarity, lines = "🐶 Pet Liar di Map: " .. #ActivePets .. "\n\n", "", 3 
            if #ActivePets > 0 then
                for _, p in ipairs(ActivePets) do
                    if p.Rarity ~= currentRarity then currentRarity = p.Rarity; contentText = contentText .. "🌟 [" .. string.upper(currentRarity) .. "]\n"; lines = lines + 1 end
                    local m, s = math.floor(p.TimeLeft / 60), p.TimeLeft % 60; local tS = string.format("%ds", s)
                    contentText = contentText .. " • " .. p.Name .. " (" .. tS .. ")\n"; lines = lines + 1
                end
            else contentText = contentText .. "Map sedang sepi\n" end
            LivePetPanel:Set(contentText, lines)
        end
    end
end)

local LiveMoonPanel = SecLive:AddPopUpLive({Title = "🖥️ Buka Live Moon Predictor", Content = "Jadwal presisi menggunakan memori asli game", PanelTitle = "🌙 WEATHER PREDICTION", Icon = "rbxassetid://91446334780160"})
task.spawn(function()
    local CYCLE_DURATION, DAY_DUR, SUNSET_DUR, NIGHT_ORDER = 600, 450, 30, 3
    local TimeCycleMod = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("TimeCycleData"))
    local rawNightWeathers = (TimeCycleMod and TimeCycleMod.Data and TimeCycleMod.Data.Night) and TimeCycleMod.Data.Night.Weathers or nil
    while task.wait(1) do 
        if LiveMoonPanel:IsVisible() and rawNightWeathers then 
            local currentTime = os.time(); local currentCycle = math.floor(currentTime / CYCLE_DURATION); local timeInCycle = currentTime % CYCLE_DURATION
            local nextPhaseName, nextPhaseTime = "", 0
            if timeInCycle < DAY_DUR then nextPhaseName = "Sunset"; nextPhaseTime = DAY_DUR - timeInCycle elseif timeInCycle < (DAY_DUR + SUNSET_DUR) then nextPhaseName = "Night"; nextPhaseTime = (DAY_DUR + SUNSET_DUR) - timeInCycle else nextPhaseName = "Day"; nextPhaseTime = CYCLE_DURATION - timeInCycle end
            local predictions, found, cycleOffset = {["Goldmoon"] = nil, ["Rainbow Moon"] = nil, ["Bloodmoon"] = nil}, 0, 0
            while found < 3 and cycleOffset < 1000 do
                local simCycle = currentCycle + cycleOffset; local rng = Random.new(simCycle * 1000 + NIGHT_ORDER); local totalChance = 0
                for _, data in pairs(rawNightWeathers) do totalChance = totalChance + data.Chance end
                local roll, currentSum, selectedMoon = rng:NextNumber() * totalChance, 0, "Unknown"
                for name, data in pairs(rawNightWeathers) do currentSum = currentSum + data.Chance; if roll <= currentSum then selectedMoon = name; break end end
                local timeLeft = (simCycle * CYCLE_DURATION + (DAY_DUR + SUNSET_DUR)) - currentTime
                if timeLeft > 0 and predictions[selectedMoon] == nil and selectedMoon ~= "Moon" then predictions[selectedMoon] = timeLeft; found = found + 1 end
                cycleOffset = cycleOffset + 1
            end
            local contentText = "Next: " .. nextPhaseName .. "\nNext Bloodmoon: " .. tostring(predictions["Bloodmoon"]) .. "\nNext Goldmoon: " .. tostring(predictions["Goldmoon"]) .. "\nNext Rainbow Moon: " .. tostring(predictions["Rainbow Moon"]) .. "\n"
            LiveMoonPanel:Set(contentText, 4)
        end
    end
end)

local TabGlobal = Window:AddMainTab("🌐 Global Pet", false)
local SecGlobal = TabGlobal:AddSection("Cross-Server Radar", false)
local FirebaseURL = "https://pet-finder-d1145-default-rtdb.asia-southeast1.firebasedatabase.app/LivePets" 
local RarityOrder = {["Common"]=1, ["Uncommon"]=2, ["Rare"]=3, ["Epic"]=4, ["Legendary"]=5, ["Mythic"]=6, ["Super"]=7}
local TargetScoutRarities = _G.Config.TargetScoutRarities or {"Legendary", "Mythic", "Super"}

SecGlobal:AddDropdown({
    Title = "🎯 Filter Scout Rarity",
    Multi = true,
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Super"},
    Default = TargetScoutRarities,
    Callback = function(Opt)
        TargetScoutRarities = type(Opt) == "table" and Opt or {Opt}
        _G.Config.TargetScoutRarities = TargetScoutRarities
        if _G.SaveConfig then _G.SaveConfig() end
    end
})

task.spawn(function()
    local req = (syn and syn.request) or http_request or request
    while task.wait(5) do
        if req then
            local map = workspace:FindFirstChild("Map")
            local wildPetRef = map and map:FindFirstChild("WildPetRef")
            local foundPets = {}
            if wildPetRef and #TargetScoutRarities > 0 then
                for _, p in ipairs(wildPetRef:GetChildren()) do
                    if p:IsA("BasePart") then
                        local oId = p:GetAttribute("OwnerUserId")
                        if type(oId) ~= "number" or oId == 0 then
                            local r = p:GetAttribute("Rarity") or "Common"
                            if table.find(TargetScoutRarities, r) then
                                local pN = p:GetAttribute("PetName") or "Unknown"
                                local pr = p:GetAttribute("Price") or 0
                                local sW = (p:GetAttribute("SpawnedAt") or os.time()) + (p:GetAttribute("Lifetime") or 0) - os.time()
                                if sW > 0 then table.insert(foundPets, {PetName = pN, Rarity = r, Price = pr, ExpireAt = os.time() + sW}) end
                            end
                        end
                    end
                end
            end
            local serverUrl = FirebaseURL .. "/" .. game.JobId .. ".json"
            if #foundPets > 0 then
                local data = {Pets = foundPets, Time = os.time(), PlaceId = game.PlaceId, Players = tostring(#game:GetService("Players"):GetPlayers()) .. "/" .. tostring(game:GetService("Players").MaxPlayers)}
                pcall(function() req({Url = serverUrl, Method = "PUT", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end)
            else
                pcall(function() req({Url = serverUrl, Method = "PUT", Headers = {["Content-Type"] = "application/json"}, Body = "null"}) end)
            end
        end
    end
end)

SecGlobal:AddLine()
local GlobalPetPanel = SecGlobal:AddPopUpLive({ Title = "🖥️ Buka Premium Pet Finder", ShowButton = "True", PanelTitle = "PREMIUM PET FINDER", Icon = "rbxassetid://136890595976124" })

task.spawn(function()
    while task.wait(3) do
        if GlobalPetPanel:IsVisible() then
            local success, result = pcall(function() return game:HttpGet(FirebaseURL .. ".json") end)
            if success and result then
                if result == "null" then
                    GlobalPetPanel:Set("Database kosong")
                else
                    local dbData = HttpService:JSONDecode(result)
                    local groupedPets = {}
                    if type(dbData) == "table" then
                        for jobId, srvData in pairs(dbData) do
                            if type(srvData) == "table" and srvData.Time and srvData.Pets then
                                local dataAge = os.time() - srvData.Time
                                if dataAge < 300 then
                                    for _, pet in ipairs(srvData.Pets) do
                                        local remaining = (pet.ExpireAt or 0) - os.time()
                                        if remaining > 0 then 
                                            if not groupedPets[pet.PetName] then
                                                local priceStr = tostring(pet.Price)
                                                groupedPets[pet.PetName] = {PetName = pet.PetName, Rarity = pet.Rarity, Price = priceStr, SortValue = RarityOrder[pet.Rarity] or 0, Servers = {}}
                                            end
                                            local mins = math.floor(remaining / 60)
                                            local secs = math.floor(remaining % 60)
                                            local timerStr = string.format("%dm %ds", mins, secs)
                                            table.insert(groupedPets[pet.PetName].Servers, { JobId = jobId, PlaceId = srvData.PlaceId or game.PlaceId, Players = srvData.Players or "0/8", Age = "🕒 " .. timerStr })
                                        end
                                    end
                                end
                            end
                        end
                        local finalArray = {}
                        for _, pData in pairs(groupedPets) do table.insert(finalArray, pData) end
                        GlobalPetPanel:Set(finalArray)
                    end
                end
            end
        end
    end
end)

Speed_Library:SetNotification({Title = "Gery Hub", Content = "Full Instant Hop Connected!", Time = 3})
