-- ==========================================
-- CUSTOM PREMIUM UI LIBRARY (LOADER)
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/BangBoy/refs/heads/main/D.lua"))()

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser       = game:GetService("VirtualUser")
local LocalPlayer       = Players.LocalPlayer
local PlayerGui         = LocalPlayer.PlayerGui
local PetsService       = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetsService")
local ActivePetsService = require(ReplicatedStorage.Modules.PetServices.ActivePetsService)
local PetUtilities      = require(ReplicatedStorage.Modules.PetServices.PetUtilities)
local PetMutationRegistry = require(ReplicatedStorage.Data.PetRegistry.PetMutationRegistry)

-- ==========================================
-- STATE & VARIABEL MESIN
-- ==========================================
local FavPet = {}
local NonFav = {}
local PetTeamElephant = {}
local PetTeamLeveling = {}
local PetTeamAge100 = {}
local PetBahan = {}
local ElephantMinAge = 50
local ElephantResetAge = 1
local LevelingMinAge = 1
local LevelingMaxAge = 50
local Age100MinAge   = 55
local Age100MaxAge   = 100
local BahanBatchSize = 2

-- ==========================================
-- STATE & VARIABEL MESIN (PABRIK 2: PUSH 50)
-- ==========================================
local PetTeamPush50 = {}
local PetBahanPush50 = {}
local Push50BatchSize = 2
local Push50TargetAge = 50
local AutoPush50On = false

local AutoElephantOn = false
local WaktuTerakhirGerak = 0
local FaseFarming = "TANAM"  
local BahanDiKebun = {} 
local GajahMentokNotif = false
local CycleCount = 0
local WaktuStartBot = tick()
local WaktuStartCycle = tick()
local WebhookURL = ""
local AntiAFKOn = true
local IsRefreshingUI = false -- SAKLAR PENGUNCI MEMORI UI
local IsBooting = true -- SAKLAR PENGAMAN BOOTING


-- ==========================================
-- FITUR AUTO-SAVE (DATABASE LOKAL)
-- ==========================================
local HttpService = game:GetService("HttpService")
local SaveFileName = "FSMBot_Gery_Save.json"
local SavedData = { 
    Gajah = {}, Leveling = {}, Age100 = {}, Bahan = {}, PickPlace = {},
    PushTeam = {}, PushBahan = {}, 
    AutoStartFSM = false, AutoStartPush = false, AutoStartPickPlace = false, AutoStartRejoin = false,
    Input = {
        ElMin = 50, LevMin = 0, LevMax = 50, AgeMin = 55, AgeMax = 100,
        BahanBatch = 2, PushTarget = 50, PushBatch = 2, DelayPick = 0.5, DelayPlace = 0.5,
        RejoinTime = 60 -- Default 60 menit
    }
}

pcall(function()
    if isfile and readfile and isfile(SaveFileName) then
        local raw = readfile(SaveFileName)
        local data = HttpService:JSONDecode(raw)
        if data then
            SavedData.Gajah = data.Gajah or {}
            SavedData.Leveling = data.Leveling or {}
            SavedData.Age100 = data.Age100 or {}
            SavedData.Bahan = data.Bahan or {}
            SavedData.PickPlace = data.PickPlace or {}
            SavedData.PushTeam = data.PushTeam or {}
            SavedData.PushBahan = data.PushBahan or {}
            SavedData.AutoStartFSM = data.AutoStartFSM or false 
            SavedData.AutoStartPush = data.AutoStartPush or false 
            SavedData.AutoStartPickPlace = data.AutoStartPickPlace or false 
            SavedData.AutoStartRejoin = data.AutoStartRejoin or false 
            if data.Input then
                for k, v in pairs(data.Input) do SavedData.Input[k] = v end
            end
        end
    end
end)

local function SaveSettings()
    pcall(function()
        if writefile then writefile(SaveFileName, HttpService:JSONEncode(SavedData)) end
    end)
end

-- ==========================================
-- UPDATE VARIABEL MESIN MENGGUNAKAN DATA SAVE
-- ==========================================
local ElephantMinAge = SavedData.Input.ElMin
local LevelingMinAge = SavedData.Input.LevMin
local LevelingMaxAge = SavedData.Input.LevMax
local Age100MinAge   = SavedData.Input.AgeMin
local Age100MaxAge   = SavedData.Input.AgeMax
local BahanBatchSize = SavedData.Input.BahanBatch
local Push50TargetAge = SavedData.Input.PushTarget
local Push50BatchSize = SavedData.Input.PushBatch
local DelayToPick = SavedData.Input.DelayPick
local DelayToPlace = SavedData.Input.DelayPlace
local AutoRejoinMenit = SavedData.Input.RejoinTime
local AutoRejoinOn = false

local function SaveSettings()
    pcall(function()
        if writefile then
            writefile(SaveFileName, HttpService:JSONEncode(SavedData))
        end
    end)
end

-- ==========================================
-- VARIABEL & SISTEM SADAP SERVER (SKILL CANCEL)
-- ==========================================
local PetKebun = {}
local PickPlacePets = {}
local DelayToPick = 0.5
local DelayToPlace = 0.5
local AutoPickPlaceOn = false

local PetCooldownsUpdated = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetCooldownsUpdated")
local CooldownDatabase = {}

PetCooldownsUpdated.OnClientEvent:Connect(function(uuid, cdData)
    CooldownDatabase[uuid] = cdData
end)

task.spawn(function()
    while task.wait(1) do
        for uuid, slots in pairs(CooldownDatabase) do
            if slots then
                for _, slotData in ipairs(slots) do
                    if slotData and slotData.Time then
                        slotData.Time = math.max(0, slotData.Time - 1)
                    end
                end
            end
        end
    end
end)

local function IsPetSkillReady(uuid)
    local slots = CooldownDatabase[uuid]
    if slots then
        if slots[1] and slots[1].Time <= 0 then return true end
        if slots[2] and slots[2].Time <= 0 then return true end
    end
    return false 
end

-- ==========================================
-- 1. FUNGSI KEBUN & PET
-- ==========================================
local function GetMyFarmCenter()
    local farmFolder = workspace:FindFirstChild("Farm") or workspace:FindFirstChild("Farms")
    if not farmFolder then return nil end
    for _, kebun in ipairs(farmFolder:GetChildren()) do
        local ownerVal = kebun:FindFirstChild("Important") and kebun.Important:FindFirstChild("Data") and kebun.Important.Data:FindFirstChild("Owner")
        if ownerVal and tostring(ownerVal.Value) == LocalPlayer.Name then
            local center = kebun:FindFirstChild("Spawn_Point") or kebun:FindFirstChild("Center_Point")
            if center then return center:IsA("BasePart") and center.CFrame or CFrame.new(center.Value) end
        end
    end
    return nil
end

local function PlacePet(petId)
    WaktuTerakhirGerak = tick()
    local koordinatKebun = GetMyFarmCenter()
    if not koordinatKebun then return false end
    local sukses, _ = pcall(function() PetsService:FireServer("EquipPet", petId, koordinatKebun) end)
    return sukses
end

local function PickupPet(petId)
    WaktuTerakhirGerak = tick()
    local sukses, _ = pcall(function() PetsService:FireServer("UnequipPet", petId) end)
    return sukses
end

local function TarikSemuaPetDiAwal()
    print("[Sistem] Memulai pembersihan kebun otomatis...")
    pcall(function()
        local scrollingFrame = PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
        if scrollingFrame then
            for _, item in ipairs(scrollingFrame:GetChildren()) do
                if string.find(item.Name, "-") then PickupPet(item.Name) task.wait(0.1) end
            end
        end
    end)
end

local function AmbilUmurDiKebun(petId)
    local umur = 0
    pcall(function()
        local data = ActivePetsService:GetPetData(LocalPlayer.Name, petId)
        if data and data.PetData then umur = data.PetData.Level end
    end)
    return umur
end

local function RegisterPet(uuid, isFav)
    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
    if not data then return end
    
    local petType = data.PetType or "Unknown"
    local nama = petType
    
    pcall(function()
        local mutType = data.PetData and data.PetData.MutationType
        if mutType then
            local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
            if mutString and mutString ~= "Normal" then
                nama = mutString .. " " .. petType
            end
        end
    end)
    
    local umur = data.PetData and data.PetData.Level or 1
    local uuidBersih = string.gsub(uuid, "[^%w]", "") 
    local uuidPendek = string.sub(uuidBersih, 1, 4)
    local teksDropdown = nama .. " [#" .. string.upper(uuidPendek) .. "]"
    local dataPet = { Id = uuid, Nama = nama, Umur = umur, Teks = teksDropdown }
    
    local targetTable = isFav and FavPet or NonFav
    for _, p in ipairs(targetTable) do if p.Id == uuid then return end end
    
    table.insert(targetTable, dataPet)
end

local function ScanTas()
    table.clear(FavPet) 
    table.clear(NonFav)
    
    local tas = LocalPlayer:FindFirstChild("Backpack")
    if tas then
        for _, item in ipairs(tas:GetChildren()) do
            if item:GetAttribute("ItemType") == "Pet" then
                local uuid = item:GetAttribute("PET_UUID")
                if uuid and uuid ~= "" then
                    local isFav = item:GetAttribute("d") == true
                    RegisterPet(uuid, isFav)
                end
            end
        end
    end
    
    pcall(function()
        local physFolder = workspace:FindFirstChild("PetsPhysical")
        if physFolder then
            for _, item in ipairs(physFolder:GetChildren()) do
                local owner = item:GetAttribute("OWNER")
                local uuid = item:GetAttribute("UUID")
                if owner == LocalPlayer.Name and uuid then
                    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                    if data and data.PetData then
                        local isFav = data.PetData.IsFavorite == true
                        RegisterPet(uuid, isFav)
                    end
                end
            end
        end
    end)
end

local function ScanKebun()
    table.clear(PetKebun)
    
    -- Filter Anti-Duplikat
    local function IsDuplikat(uuid)
        for _, p in ipairs(PetKebun) do
            if p.Id == uuid then return true end
        end
        return false
    end

    pcall(function()
        local physFolder = workspace:FindFirstChild("PetsPhysical")
        if physFolder then
            for _, item in ipairs(physFolder:GetChildren()) do
                local owner = item:GetAttribute("OWNER")
                local uuid = item:GetAttribute("UUID")
                
                -- Cek: Kalau milik kita & belum masuk daftar, baru diproses
                if owner == LocalPlayer.Name and uuid and not IsDuplikat(uuid) then
                    local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                    if data and data.PetType then 
                        local petType = data.PetType
                        local namaPet = petType
                        
                        local mutType = data.PetData and data.PetData.MutationType
                        if mutType then
                            local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                            if mutString and mutString ~= "Normal" then
                                namaPet = mutString .. " " .. petType
                            end
                        end
                        
                        local uuidBersih = string.gsub(uuid, "[^%w]", "") 
                        local uuidPendek = string.sub(uuidBersih, 1, 4) 
                        local teksDropdown = namaPet .. " [#" .. string.upper(uuidPendek) .. "]"
                        
                        table.insert(PetKebun, { Id = uuid, Nama = namaPet, Teks = teksDropdown })
                    end
                end
            end
        end
        
        if #PetKebun == 0 then
            local scrollingFrame = PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
            if scrollingFrame then
                for _, item in ipairs(scrollingFrame:GetChildren()) do
                    if string.find(item.Name, "-") then
                        local uuid = item.Name
                        -- Cek duplikat juga untuk UI Scan
                        if not IsDuplikat(uuid) then
                            local data = ActivePetsService:GetPetData(LocalPlayer.Name, uuid)
                            if data and data.PetType then 
                                local petType = data.PetType
                                local namaPet = petType
                                
                                local mutType = data.PetData and data.PetData.MutationType
                                if mutType then
                                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                                    if mutString and mutString ~= "Normal" then
                                        namaPet = mutString .. " " .. petType
                                    end
                                end
                                
                                local uuidBersih = string.gsub(uuid, "[^%w]", "") 
                                local uuidPendek = string.sub(uuidBersih, 1, 4) 
                                local teksDropdown = namaPet .. " [#" .. string.upper(uuidPendek) .. "]"
                                table.insert(PetKebun, { Id = uuid, Nama = namaPet, Teks = teksDropdown })
                            end
                        end
                    end
                end
            end
        end
    end)
end


local function InfoBahan()
    local daftarNama = {}
    for _, id in ipairs(BahanDiKebun) do
        local namaPet = "Unknown"
        pcall(function()
            local data = ActivePetsService:GetPetData(LocalPlayer.Name, id)
            if data and data.PetType then 
                namaPet = data.PetType
                local mutType = data.PetData and data.PetData.MutationType
                if mutType then
                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                    if mutString and mutString ~= "Normal" then
                        namaPet = mutString .. " " .. namaPet
                    end
                end
            end
        end)
        table.insert(daftarNama, namaPet)
    end
    return #daftarNama == 0 and "Bahan" or table.concat(daftarNama, " & ")
end

local function GetDetailBahan()
    if #BahanDiKebun == 0 then
        return "> **[Bahan Kosong]**\n> **Name :** -\n> **Age :** 0\n> **Kg :** 0"
    end

    local teksDetail = ""
    for i, id in ipairs(BahanDiKebun) do
        local namaPet = "Unknown"
        local umurPet = 0
        local beratPet = 0
        
        pcall(function()
            local data = ActivePetsService:GetPetData(LocalPlayer.Name, id)
            if data and data.PetData then
                namaPet = data.PetType or "Unknown"
                local mutType = data.PetData and data.PetData.MutationType
                if mutType then
                    local mutString = PetMutationRegistry.EnumToPetMutation and PetMutationRegistry.EnumToPetMutation[mutType]
                    if mutString and mutString ~= "Normal" then
                        namaPet = mutString .. " " .. namaPet
                    end
                end
                
                umurPet = data.PetData.Level
                local baseWeight = data.PetData.BaseWeight
                beratPet = PetUtilities:CalculateWeight(baseWeight, umurPet, data.PetType)
            end
        end)
        
        local beratFormat = string.format("%.2f", beratPet)
        
        teksDetail = teksDetail .. "> **[Bahan " .. i .. "]**\n"
        teksDetail = teksDetail .. "> **Name :** " .. namaPet .. "\n"
        teksDetail = teksDetail .. "> **Age :** " .. umurPet .. "\n"
        teksDetail = teksDetail .. "> **Kg :** " .. beratFormat
        
        if i < #BahanDiKebun then
            teksDetail = teksDetail .. "\n> \n"
        end
    end
    return teksDetail
end

local function GetSisaBahan()
    local sisa = 0
    for _, petBahan in ipairs(PetBahan) do
        local inKebun = false
        for _, id in ipairs(BahanDiKebun) do
            if id == petBahan.Id then
                inKebun = true
                if AmbilUmurDiKebun(id) < Age100MaxAge then
                    sisa = sisa + 1
                end
                break
            end
        end
        if not inKebun then
            for _, p in ipairs(NonFav) do
                if p.Id == petBahan.Id then
                    if p.Umur < Age100MaxAge then
                        sisa = sisa + 1
                    end
                    break
                end
            end
        end
    end
    return sisa
end

-- ==========================================
-- 2. SISTEM WEBHOOK DISCORD
-- ==========================================
local function FormatWaktu(detik)
    local h = math.floor(detik / 3600)
    local m = math.floor((detik % 3600) / 60)
    local s = math.floor(detik % 60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function GetPing()
    local ping = "N/A"
    pcall(function() ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
    return ping .. " ms"
end

local function GetTeamNames(teamTable)
    local names = {}
    for _, pet in ipairs(teamTable) do table.insert(names, pet.Nama) end
    if #names == 0 then return "Kosong" end
    return table.concat(names, ", ")
end

local function KirimWebhook(teksFase, embedData)
    if WebhookURL == "" or string.find(WebhookURL, "MASUKKAN") then return end
    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
        if req then
            req({
                Url = WebhookURL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode({ ["content"] = "", ["embeds"] = { embedData } })
            })
        end
    end)
end

local function LogPesan(teksFase)
    print(teksFase)
    
    -- 1. Tangkap durasi fase yang baru saja selesai
    local waktuFaseBerjalan = tick() - WaktuStartCycle 
    
    -- 2. Langsung RESET timer ke 0 untuk mulai menghitung fase selanjutnya!
    WaktuStartCycle = tick() 
    
    task.spawn(function()
        local dataEmbed = {
            ["title"] = teksFase,
            ["fields"] = {
                -- Cycle Time diubah menjadi Phase Time dan menggunakan waktu yang ditangkap di atas
                { ["name"] = "Information Pet", ["value"] = GetDetailBahan() .. "\n> ────────────────\n> **Cycle Count :** " .. CycleCount .. "\n> **Duration :** " .. FormatWaktu(tick() - WaktuStartBot) .. "\n> **Phase Time :** " .. FormatWaktu(waktuFaseBerjalan), ["inline"] = false },
                { ["name"] = "Game Info", ["value"] = "> **Game Ping :** " .. GetPing() .. "\n> **Total Pets :** " .. (#FavPet + #NonFav) .. "\n> **Sisa Bahan :** " .. GetSisaBahan() .. " Pet", ["inline"] = false },
                { ["name"] = "Teams Inventory", ["value"] = "> **Team Elephant :** " .. GetTeamNames(PetTeamElephant) .. "\n> **Team Leveling :** " .. GetTeamNames(PetTeamLeveling) .. "\n> **Team Age100 :** " .. GetTeamNames(PetTeamAge100), ["inline"] = false }
            },
            ["footer"] = { ["text"] = "FSM Bot by Gery • " .. os.date("%d/%m/%y, %H:%M") }
        }
        KirimWebhook(teksFase, dataEmbed)
    end)
end

-- ==========================================
-- 3. PEMBUATAN CUSTOM UI
-- ==========================================
local Window = Speed_Library:CreateWindow({
    Title = "FSM Bot Auto-Farming",
    Description = "Ultimate Edition by Gery",
    TabWidth = 140,
    SizeUi = UDim2.fromOffset(580, 340)
})

local function AmbilDaftarNama(tabelPet)
    local daftar = {}
    for _, pet in ipairs(tabelPet) do table.insert(daftar, pet.Teks) end
    return #daftar > 0 and daftar or {"Kosong"}
end

local function UpdateMultiSelectState(tabelSumber, daftarPilihanUI, tabelStateTarget)
    if IsRefreshingUI then return end -- KUNCI: Jangan hapus data saat UI sedang refresh otomatis
    table.clear(tabelStateTarget) 
    for _, namaDipilih in ipairs(daftarPilihanUI) do
        for _, pet in ipairs(tabelSumber) do
            if pet.Teks == namaDipilih then table.insert(tabelStateTarget, pet) end
        end
    end
end

local TabLeveling = Window:CreateTab({Name = "Auto Leveling", Icon = "rbxassetid://7734010488"})
local TabMisc     = Window:CreateTab({Name = "MISC",          Icon = "rbxassetid://7734010488"})
local TabSetting  = Window:CreateTab({Name = "Settings",      Icon = "rbxassetid://7734010488"})

-- SECTION 1: GAJAH
local SecGajah = TabLeveling:AddSection("Team Gajah Settings", false)

SecGajah:AddButton({
    Title = "🔄 Refresh Data Tas", 
    Content = "Klik ini jika daftar dropdown Kosong",
    Callback = function()
        WaktuTerakhirGerak = 0 
        UpdateSemuaDropdown(true) 
        Speed_Library:SetNotification({Title = "Refresh Sukses", Description = "Berhasil", Content = "Daftar tas diperbarui!", Time = 2})
    end
})

local DropGajah = SecGajah:AddDropdown({
    Title = "Pilih Team Gajah", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Gajah,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamElephant) 
        if not IsRefreshingUI then SavedData.Gajah = Options SaveSettings() end
    end
})
SecGajah:AddInput({
    Title = "Min Age (Blessing)", Content = "Umur minimal gajah ditarik", Default = tostring(SavedData.Input.ElMin),
    Callback = function(Text) ElephantMinAge = tonumber(Text) or 50; SavedData.Input.ElMin = ElephantMinAge; SaveSettings() end
})

-- SECTION 2: LEVELING
local SecLeveling = TabLeveling:AddSection("Team Leveling Settings", false)
local DropLeveling = SecLeveling:AddDropdown({
    Title = "Pilih Team Leveling", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Leveling,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamLeveling) 
        if not IsRefreshingUI then SavedData.Leveling = Options SaveSettings() end
    end
})
SecLeveling:AddInput({
    Title = "Minimum Age", Content = "Batas bawah", Default = tostring(SavedData.Input.LevMin),
    Callback = function(Text) LevelingMinAge = tonumber(Text) or 0; SavedData.Input.LevMin = LevelingMinAge; SaveSettings() end
})
SecLeveling:AddInput({
    Title = "Maximum Age", Content = "Batas atas", Default = tostring(SavedData.Input.LevMax),
    Callback = function(Text) LevelingMaxAge = tonumber(Text) or 50; SavedData.Input.LevMax = LevelingMaxAge; SaveSettings() end
})

-- SECTION 3: AGE 100
local SecAge100 = TabLeveling:AddSection("Team Age 100 Settings", false)
local DropAge100 = SecAge100:AddDropdown({
    Title = "Pilih Team Age 100", Content = "Pilih 1 atau lebih", Multi = true, Options = {"Kosong"}, Default = SavedData.Age100,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamAge100) 
        if not IsRefreshingUI then SavedData.Age100 = Options SaveSettings() end
    end
})
SecAge100:AddInput({
    Title = "Minimum Age", Content = "Bypass Gajah", Default = tostring(SavedData.Input.AgeMin),
    Callback = function(Text) Age100MinAge = tonumber(Text) or 55; SavedData.Input.AgeMin = Age100MinAge; SaveSettings() end
})
SecAge100:AddInput({
    Title = "Maximum Age", Content = "Target panen", Default = tostring(SavedData.Input.AgeMax),
    Callback = function(Text) Age100MaxAge = tonumber(Text) or 100; SavedData.Input.AgeMax = Age100MaxAge; SaveSettings() end
})

-- SECTION 4: BAHAN
local ToggleMesin
local SecBahan = TabLeveling:AddSection("Konfigurasi Bahan", false)
local DropBahan = SecBahan:AddDropdown({
    Title = "Pilih Pet Bahan", Content = "Pilih dari Non-Fav", Multi = true, Options = {"Kosong"}, Default = SavedData.Bahan,
    Callback = function(Options) 
        UpdateMultiSelectState(NonFav, Options, PetBahan) 
        if not IsRefreshingUI then SavedData.Bahan = Options SaveSettings() end
    end
})
SecBahan:AddInput({
    Title = "Batch Size", Content = "Jumlah tanam per putaran", Default = tostring(SavedData.Input.BahanBatch),
    Callback = function(Text) BahanBatchSize = tonumber(Text) or 2; SavedData.Input.BahanBatch = BahanBatchSize; SaveSettings() end
})
ToggleMesin = SecBahan:AddToggle({
    Title = "▶️ MULAI MESIN OTOMATIS", Content = "Pastikan semua setting benar", 
    Default = SavedData.AutoStartFSM, -- <== LANGSUNG BACA DARI MEMORI
    Callback = function(Value)
        if IsBooting then return end -- Tahan eksekusi kalau game belum siap!
        AutoElephantOn = Value
        SavedData.AutoStartFSM = Value
        SaveSettings()
        
        if AutoElephantOn then
            FaseFarming = "TANAM" WaktuStartCycle = tick()
            Speed_Library:SetNotification({Title = "Sistem Menyala", Description = "Mesin Berjalan", Content = "Otomasi FSM telah diaktifkan!", Time = 3})
        else
            Speed_Library:SetNotification({Title = "Sistem Mati", Description = "Mesin Dimatikan", Content = "Menarik semua pet dari kebun...", Time = 3})
            task.spawn(TarikSemuaPetDiAwal) 
        end
    end
})

-- ==============================================
-- PABRIK 2: TAB PUSH AGE 50
-- ==============================================
local TabPush50 = Window:CreateTab({Name = "Push Age 50", Icon = "rbxassetid://7734010488"})
local SecPushSet = TabPush50:AddSection("Push 50 Settings", false)

local DropPushLeveling = SecPushSet:AddDropdown({
    Title = "Pilih Team Leveling", Content = "Pet untuk bantu naikin EXP", Multi = true, Options = {"Kosong"}, Default = SavedData.PushTeam,
    Callback = function(Options) 
        UpdateMultiSelectState(FavPet, Options, PetTeamPush50) 
        if not IsRefreshingUI then SavedData.PushTeam = Options SaveSettings() end
    end
})
local DropPushBahan = SecPushSet:AddDropdown({
    Title = "Pilih Pet Bahan", Content = "Pet yang akan dipanen", Multi = true, Options = {"Kosong"}, Default = SavedData.PushBahan,
    Callback = function(Options) 
        UpdateMultiSelectState(NonFav, Options, PetBahanPush50) 
        if not IsRefreshingUI then SavedData.PushBahan = Options SaveSettings() end
    end
})
SecPushSet:AddInput({ Title = "Target Age", Content = "Umur panen bahan", Default = tostring(SavedData.Input.PushTarget), Callback = function(Text) Push50TargetAge = tonumber(Text) or 50; SavedData.Input.PushTarget = Push50TargetAge; SaveSettings() end })
SecPushSet:AddInput({ Title = "Batch Size", Content = "Jumlah tanam per putaran", Default = tostring(SavedData.Input.PushBatch), Callback = function(Text) Push50BatchSize = tonumber(Text) or 2; SavedData.Input.PushBatch = Push50BatchSize; SaveSettings() end })

local ToggleMesinPush
ToggleMesinPush = SecPushSet:AddToggle({
    Title = "▶️ MULAI PABRIK PUSH 50", Content = "Leveling murni tanpa Gajah", 
    Default = SavedData.AutoStartPush, -- <== LANGSUNG BACA DARI MEMORI
    Callback = function(Value)
        if IsBooting then return end -- Tahan eksekusi
        AutoPush50On = Value
        SavedData.AutoStartPush = Value
        SaveSettings()
        
        if AutoPush50On then
            if ToggleMesin then ToggleMesin:Set(false) end 
            FaseFarming = "TANAM_PUSH" WaktuStartCycle = tick()
            Speed_Library:SetNotification({Title = "Pabrik 2 Menyala", Description = "Push 50 Aktif", Content = "Mesin berjalan!", Time = 3})
        else
            if not AutoElephantOn then task.spawn(TarikSemuaPetDiAwal) end
        end
    end
})

-- SECTION 5: TAB MISC (SADAP SERVER SKILL CANCEL)
local SecPickPlace = TabMisc:AddSection("Pickup And Place", false)
local DropPickPlace 
SecPickPlace:AddButton({
    Title = "🔍 Scan Pet di Kebun", Content = "Tembus pandang tanpa buka UI game!",
    Callback = function()
        ScanKebun()
        if DropPickPlace then DropPickPlace:Refresh(AmbilDaftarNama(PetKebun), DropPickPlace.Value) end
        Speed_Library:SetNotification({Title = "Scan Selesai", Description = "Berhasil", Content = "Daftar pet diperbarui!", Time = 2})
    end
})
DropPickPlace = SecPickPlace:AddDropdown({ 
    Title = "Pilih Pet", Content = "Pilih dari hasil scan kebun", Multi = true, Options = {"Kosong"}, Default = SavedData.PickPlace, 
    Callback = function(Options) 
        UpdateMultiSelectState(PetKebun, Options, PickPlacePets) 
        if not IsRefreshingUI then SavedData.PickPlace = Options SaveSettings() end
    end 
})
SecPickPlace:AddInput({ Title = "Delay To Pick", Content = "Jeda narik (0.5)", Default = tostring(SavedData.Input.DelayPick), Callback = function(Text) DelayToPick = tonumber(Text) or 0.5; SavedData.Input.DelayPick = DelayToPick; SaveSettings() end })
SecPickPlace:AddInput({ Title = "Delay To Place", Content = "Jeda nanam (0.5)", Default = tostring(SavedData.Input.DelayPlace), Callback = function(Text) DelayToPlace = tonumber(Text) or 0.5; SavedData.Input.DelayPlace = DelayToPlace; SaveSettings() end })
local TogglePickPlace -- Deklarasi nama tombol agar bisa dipanggil otomatis
local TogglePickPlace
TogglePickPlace = SecPickPlace:AddToggle({ 
    Title = "▶️ MULAI SADAP SKILL", Content = "Bisa jalan bareng FSM atau mandiri!", 
    Default = SavedData.AutoStartPickPlace, -- <== LANGSUNG BACA DARI MEMORI
    Callback = function(Value) 
        if IsBooting then return end -- Tahan eksekusi
        AutoPickPlaceOn = Value 
        SavedData.AutoStartPickPlace = Value
        SaveSettings()
    end 
})

-- SECTION 5.5: AUTO REJOIN (TAB MISC)
local SecRejoin = TabMisc:AddSection("Auto Rejoin Settings", false)
SecRejoin:AddInput({ 
    Title = "Rejoin Timer (Menit)", 
    Content = "Berapa menit sekali untuk rejoin?", 
    Default = tostring(SavedData.Input.RejoinTime), 
    Callback = function(Text) 
        AutoRejoinMenit = tonumber(Text) or 60
        SavedData.Input.RejoinTime = AutoRejoinMenit
        SaveSettings() 
    end 
})

local ToggleRejoin
ToggleRejoin = SecRejoin:AddToggle({
    Title = "▶️ AUTO REJOIN SERVER", 
    Content = "Otomatis reconnect setelah waktu habis", 
    Default = SavedData.AutoStartRejoin, 
    Callback = function(Value)
        if IsBooting then return end
        AutoRejoinOn = Value
        SavedData.AutoStartRejoin = Value
        SaveSettings()
    end
})

-- SECTION 6: SETTINGS & SECFITUR
local SecSet = TabSetting:AddSection("Webhook & Update", false)
SecSet:AddInput({
    Title = "URL Webhook", Content = "Paste link Discord", Default = "",
    Callback = function(Text) WebhookURL = Text end
})
SecSet:AddButton({
    Title = "Test Webhook", Content = "Kirim pesan test",
    Callback = function()
        if WebhookURL == "" then
            Speed_Library:SetNotification({Title = "Gagal", Description = "Error", Content = "Link Webhook kosong!", Time = 3})
        else
            KirimWebhook("✅ **TEST BERHASIL!** Custom UI Gery sudah terhubung!", {["title"] = "Test", ["description"] = "Aman!"})
        end
    end
})

-- ==========================================
-- 4. SENSOR UI ANTI-LAG & CCTV
-- ==========================================
local function UpdateSemuaDropdown(paksaRefresh)
    if not paksaRefresh and (tick() - WaktuTerakhirGerak < 3) then return end 
    
    IsRefreshingUI = true -- KUNCI AKTIF
    ScanTas()
    ScanKebun() -- Sinkronisasi Pick & Place
    
    if DropGajah then DropGajah:Refresh(AmbilDaftarNama(FavPet), DropGajah.Value) end
    if DropLeveling then DropLeveling:Refresh(AmbilDaftarNama(FavPet), DropLeveling.Value) end
    if DropAge100 then DropAge100:Refresh(AmbilDaftarNama(FavPet), DropAge100.Value) end
    if DropBahan then DropBahan:Refresh(AmbilDaftarNama(NonFav), DropBahan.Value) end
    
    if DropPushLeveling then DropPushLeveling:Refresh(AmbilDaftarNama(FavPet), DropPushLeveling.Value) end
    if DropPushBahan then DropPushBahan:Refresh(AmbilDaftarNama(NonFav), DropPushBahan.Value) end
    if DropPickPlace then DropPickPlace:Refresh(AmbilDaftarNama(PetKebun), DropPickPlace.Value) end
    IsRefreshingUI = false -- KUNCI MATI
    
    -- SINKRONISASI PAKSA TABEL MEMORI SETELAH UI REFRESH
    if DropGajah then UpdateMultiSelectState(FavPet, DropGajah.Value, PetTeamElephant) end
    if DropLeveling then UpdateMultiSelectState(FavPet, DropLeveling.Value, PetTeamLeveling) end
    if DropAge100 then UpdateMultiSelectState(FavPet, DropAge100.Value, PetTeamAge100) end
    if DropBahan then UpdateMultiSelectState(NonFav, DropBahan.Value, PetBahan) end
    if DropPushLeveling then UpdateMultiSelectState(FavPet, DropPushLeveling.Value, PetTeamPush50) end
    if DropPushBahan then UpdateMultiSelectState(NonFav, DropPushBahan.Value, PetBahanPush50) end
    if DropPickPlace then UpdateMultiSelectState(PetKebun, DropPickPlace.Value, PickPlacePets) end
end

local tas = LocalPlayer:WaitForChild("Backpack")
local function PantauBintangPet(item)
    if item:GetAttribute("ItemType") == "Pet" then
        item:GetAttributeChangedSignal("d"):Connect(function() task.wait(0.1) UpdateSemuaDropdown() end)
    end
end
for _, item in ipairs(tas:GetChildren()) do PantauBintangPet(item) end
tas.ChildAdded:Connect(function(item) if item:GetAttribute("ItemType") == "Pet" then PantauBintangPet(item) task.wait(0.1) UpdateSemuaDropdown() end end)
tas.ChildRemoved:Connect(function(item) if item:GetAttribute("ItemType") == "Pet" then UpdateSemuaDropdown() end end)

local function SetupCCTVNotif()
    local FrameFolder = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Top_Notification"):WaitForChild("Frame")
    local function CekNotifikasi(uiNode)
        if string.find(uiNode.Name, "Notification") then
            local function BacaAtribut()
                local textOG = uiNode:GetAttribute("OG")
                if textOG and textOG ~= "" then
                    local teksKecil = string.lower(textOG)
                    if string.find(teksKecil, "elephant trumpeted") and string.find(teksKecil, "weight cap") then
                        LogPesan("🚨 [Sistem] Alarm CCTV: Gajah mentok terdeteksi!") GajahMentokNotif = true 
                    end
                end
            end
            BacaAtribut() uiNode:GetAttributeChangedSignal("OG"):Connect(BacaAtribut)
        end
    end
    FrameFolder.ChildAdded:Connect(function(node) task.wait(0.1) CekNotifikasi(node) end)
end
task.spawn(SetupCCTVNotif)


-- ==========================================
-- 4.5 MESIN PARALEL: AUTO PICK & PLACE
-- ==========================================
task.spawn(function()
    while true do -- Loop murni kecepatan maksimal
        if AutoPickPlaceOn and #PickPlacePets > 0 then
            
            local function IsPetActiveInFSM(petId)
                if AutoElephantOn then
                    if FaseFarming == "LEVELING" or FaseFarming == "PUSH_LEVELING" then
                        for _, p in ipairs(PetTeamLeveling) do if p.Id == petId then return true end end
                    elseif FaseFarming == "BLESSING" then
                        for _, p in ipairs(PetTeamElephant) do if p.Id == petId then return true end end
                    elseif FaseFarming == "MENUJU_100" then
                        for _, p in ipairs(PetTeamAge100) do if p.Id == petId then return true end end
                    end
                    local isFSMTarget = false
                    for _, p in ipairs(PetTeamLeveling) do if p.Id == petId then isFSMTarget = true end end
                    for _, p in ipairs(PetTeamElephant) do if p.Id == petId then isFSMTarget = true end end
                    for _, p in ipairs(PetTeamAge100) do if p.Id == petId then isFSMTarget = true end end
                    if not isFSMTarget then return true end 
                    
                elseif AutoPush50On then
                    if FaseFarming == "LEVELING_PUSH" then
                        for _, p in ipairs(PetTeamPush50) do if p.Id == petId then return true end end
                    end
                    local isPushTarget = false
                    for _, p in ipairs(PetTeamPush50) do if p.Id == petId then isPushTarget = true end end
                    if not isPushTarget then return true end 
                end
                return false
            end
            
            local petsReady = {}
            for _, pet in ipairs(PickPlacePets) do
                if not AutoPickPlaceOn then break end
                if IsPetSkillReady(pet.Id) and IsPetActiveInFSM(pet.Id) then table.insert(petsReady, pet.Id) end
            end
            
            if #petsReady > 0 then
                for _, uuid in ipairs(petsReady) do PetsService:FireServer("UnequipPet", uuid) end
                task.wait(DelayToPick) 
                
                local koordinat = GetMyFarmCenter()
                if koordinat then for _, uuid in ipairs(petsReady) do PetsService:FireServer("EquipPet", uuid, koordinat) end end
                task.wait(DelayToPlace) 
                
                for _, uuid in ipairs(petsReady) do CooldownDatabase[uuid] = nil end
            end
        end
        task.wait() -- Penahan wajib agar game tidak crash/freeze
    end
end)



-- ==========================================
-- 5. MESIN FSM OTOMATISASI UTAMA
-- ==========================================
task.spawn(function()
    while task.wait(0.5) do 
        if AutoElephantOn then
            if FaseFarming == "TANAM" then
                table.clear(BahanDiKebun) ScanTas() 
                local targetDitanam = {}
                for _, petBahan in ipairs(PetBahan) do 
                    local petSegar = nil
                    for _, p in ipairs(NonFav) do if p.Id == petBahan.Id then petSegar = p break end end
                    if petSegar and petSegar.Umur < Age100MaxAge then
                        table.insert(targetDitanam, petSegar)
                        if #targetDitanam >= BahanBatchSize then break end
                    end
                end
                
                local bahanDitanam = 0
                for _, pet in ipairs(targetDitanam) do PlacePet(pet.Id) table.insert(BahanDiKebun, pet.Id) bahanDitanam = bahanDitanam + 1 task.wait(0.5) end
                
                if bahanDitanam == 0 then
                    LogPesan("[Sistem] Selesai!") 
                    AutoElephantOn = false 
                    ToggleMesin:Set(false)
                    continue
                end
                
                for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.5) end
                FaseFarming = "LEVELING" LogPesan("[Fase] Masuk Fase LEVELING...")

            elseif FaseFarming == "LEVELING" then
                local semuaSiapBlessing = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < ElephantMinAge then semuaSiapBlessing = false break end end
                
                if semuaSiapBlessing then
                    LogPesan("[Fase] " .. InfoBahan() .. " -> Gajah") GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamLeveling) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamElephant) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "BLESSING"
                end

            elseif FaseFarming == "BLESSING" then
                local semuaSuksesReset = true
                local semuaDiatasMinAge = true
                
                for _, id in ipairs(BahanDiKebun) do
                    local umurSekarang = AmbilUmurDiKebun(id)
                    if umurSekarang > 0 then 
                        if umurSekarang > (ElephantResetAge + 5) then semuaSuksesReset = false end 
                        if umurSekarang < ElephantMinAge then semuaDiatasMinAge = false end
                    else 
                        semuaSuksesReset = false 
                        semuaDiatasMinAge = false
                    end
                end

                -- Prioritas 1: Jika SEMUA pet berhasil reset ke umur 1
                if semuaSuksesReset then
                    LogPesan("✅ [Fase] Reset Sukses " .. InfoBahan())
                    GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "LEVELING" 

                -- Prioritas 2: CCTV Mentok, TAPI ada pet yang baru aja reset (Umur < 50)
                elseif GajahMentokNotif and not semuaDiatasMinAge then
                    LogPesan("🔄 [Sinkronisasi] Ada pet yang baru reset. Kembali Leveling!")
                    GajahMentokNotif = false
                    for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "LEVELING"

                -- Prioritas 3: CCTV Mentok, DAN SEMUA pet udah mentok (Umur >= 50)
                elseif GajahMentokNotif and semuaDiatasMinAge then
                    GajahMentokNotif = false 
                    local butuhPush = false
                    for _, id in ipairs(BahanDiKebun) do
                        if AmbilUmurDiKebun(id) < Age100MinAge then
                            butuhPush = true
                            break
                        end
                    end
                    
                    if butuhPush then
                        LogPesan("⚠️ [Fase] Push Leveling " .. InfoBahan())
                        for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                        for _, petTeam in ipairs(PetTeamLeveling) do PlacePet(petTeam.Id) task.wait(0.4) end
                        FaseFarming = "PUSH_LEVELING"
                    else
                        LogPesan("⏩ [Fase] Langsung Age 100 " .. InfoBahan())
                        for _, petTeam in ipairs(PetTeamElephant) do PickupPet(petTeam.Id) task.wait(0.4) end
                        for _, petTeam in ipairs(PetTeamAge100) do PlacePet(petTeam.Id) task.wait(0.4) end
                        FaseFarming = "MENUJU_100"
                    end
                end

            elseif FaseFarming == "PUSH_LEVELING" then
                local semuaSiapAge100 = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Age100MinAge then semuaSiapAge100 = false break end end
                
                if semuaSiapAge100 then
                    LogPesan("[Fase] Push Selesai, masuk Age 100")
                    for _, petTeam in ipairs(PetTeamLeveling) do PickupPet(petTeam.Id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamAge100) do PlacePet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "MENUJU_100"
                end

            elseif FaseFarming == "MENUJU_100" then
                local semuaSudahMax = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Age100MaxAge then semuaSudahMax = false break end end
                
                if semuaSudahMax then
                    LogPesan("🎉 [PANEN] " .. InfoBahan() .. " max!") CycleCount = CycleCount + 1 WaktuStartCycle = tick()
                    for _, id in ipairs(BahanDiKebun) do PickupPet(id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamAge100) do PickupPet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "TANAM" 
                end
            end

        -- ========================================================
        -- PABRIK 2 : MESIN PUSH MURNI (TAB PUSH 50)
        -- ========================================================
        elseif AutoPush50On then
            if FaseFarming == "TANAM_PUSH" then
                table.clear(BahanDiKebun) ScanTas() 
                local targetDitanam = {}
                for _, petBahan in ipairs(PetBahanPush50) do 
                    local petSegar = nil
                    for _, p in ipairs(NonFav) do if p.Id == petBahan.Id then petSegar = p break end end
                    if petSegar and petSegar.Umur < Push50TargetAge then
                        table.insert(targetDitanam, petSegar)
                        if #targetDitanam >= Push50BatchSize then break end
                    end
                end
                
                local bahanDitanam = 0
                for _, pet in ipairs(targetDitanam) do PlacePet(pet.Id) table.insert(BahanDiKebun, pet.Id) bahanDitanam = bahanDitanam + 1 task.wait(0.5) end
                
                if bahanDitanam == 0 then
                    LogPesan("[Sistem] Selesai!") 
                    AutoPush50On = false 
                    if ToggleMesinPush then ToggleMesinPush:Set(false) end
                    continue
                end
                
                for _, petTeam in ipairs(PetTeamPush50) do PlacePet(petTeam.Id) task.wait(0.5) end
                FaseFarming = "LEVELING_PUSH" LogPesan("[Push 50] Menuju Umur " .. Push50TargetAge .. "...")

            elseif FaseFarming == "LEVELING_PUSH" then
                local semuaSudahMax = true
                for _, id in ipairs(BahanDiKebun) do if AmbilUmurDiKebun(id) < Push50TargetAge then semuaSudahMax = false break end end
                
                if semuaSudahMax then
                    LogPesan("🎉 [PANEN PUSH 50] " .. InfoBahan() .. " max!") CycleCount = CycleCount + 1 WaktuStartCycle = tick()
                    for _, id in ipairs(BahanDiKebun) do PickupPet(id) task.wait(0.4) end
                    for _, petTeam in ipairs(PetTeamPush50) do PickupPet(petTeam.Id) task.wait(0.4) end
                    FaseFarming = "TANAM_PUSH" 
                end
            end

        end
    end
end)


-- ==========================================
-- 6. SISTEM ANTI-AFK
-- ==========================================
LocalPlayer.Idled:Connect(function()
    if AntiAFKOn then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("🛡️ [Sistem] Anti-AFK Berjalan! Mereset timer idle Roblox...")
    end
end)

-- ==========================================
-- 6.5 SISTEM AUTO REJOIN
-- ==========================================
task.spawn(function()
    while task.wait(5) do -- Cek timer setiap 5 detik
        if AutoRejoinOn and AutoRejoinMenit > 0 then
            local waktuJalan = tick() - WaktuStartBot -- Dihitung sejak script jalan
            local targetDetik = AutoRejoinMenit * 60
            
            if waktuJalan >= targetDetik then
                LogPesan("🔄 [Sistem] Waktu Rejoin (" .. AutoRejoinMenit .. " Menit) telah tiba! Mencoba Reconnect...")
                task.wait(2)
                
                local TeleportService = game:GetService("TeleportService")
                pcall(function()
                    if #Players:GetPlayers() <= 1 then
                        LocalPlayer:Kick("\n[FSM Bot] Rejoining Server...")
                        task.wait()
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                    end
                end)
                task.wait(15) -- Rem tangan agar tidak spam saat proses DC
            end
        end
    end
end)

-- ==========================================
-- 7. BOOTING & INISIALISASI AWAL (Smart Wait)
-- ==========================================
task.spawn(function()
    TarikSemuaPetDiAwal() 
    
    local timerTunggu = 0
    while timerTunggu < 15 do
        task.wait(1)
        timerTunggu = timerTunggu + 1
        ScanTas()
        if #FavPet > 0 or #NonFav > 0 then break end
    end
    
    WaktuTerakhirGerak = 0 
    UpdateSemuaDropdown(true) 
    
    -- ==========================================
    -- BUKA KUNCI! GAME SUDAH SIAP 100%
    -- ==========================================
    IsBooting = false 
    Speed_Library:SetNotification({Title = "Berhasil", Description = "Injected", Content = "FSM Bot Ultimate siap!", Time = 5})
    
    -- NYALAKAN MESIN DARI BELAKANG LAYAR SESUAI MEMORI
    if SavedData.AutoStartFSM then
        print("[Sistem] Mengaktifkan kembali Mesin Utama secara otomatis!")
        AutoElephantOn = true
        FaseFarming = "TANAM" 
        WaktuStartCycle = tick()
    elseif SavedData.AutoStartPush then
        print("[Sistem] Mengaktifkan kembali Mesin Push 50 secara otomatis!")
        AutoPush50On = true
        FaseFarming = "TANAM_PUSH" 
        WaktuStartCycle = tick()
    end
    
    if SavedData.AutoStartPickPlace then
        print("[Sistem] Mengaktifkan kembali Pick & Place secara otomatis!")
        AutoPickPlaceOn = true
    end

    if SavedData.AutoStartRejoin then
        print("[Sistem] Mengaktifkan kembali Auto Rejoin secara otomatis!")
        AutoRejoinOn = true
    end

end)
