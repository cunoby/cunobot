-- ==========================================
-- 🧪 STANDALONE DUPE TESTER (SAFE & LAG-FREE)
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/cunobot/refs/heads/main/Malas.lua"))()

local Window = Speed_Library:CreateWindow({
    Title = "🧪 Tester Ilmu Hitam V5",
    SizeUi = UDim2.fromOffset(500, 250)
})

local TabDupe = Window:AddMainTab("🧪 Eksperimen", false)
local SecDupe = TabDupe:AddSection("Safe Dupe System (No Lag)", false)

-- Variabel Sistem
local FreezeVisualOn = false
local SafeDupeOn = false

-- 1. PELACAK NETWORKING ASLI
local Networking = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("Networking"))

if not Networking then
    Speed_Library:SetNotification({Title = "Error", Content = "Networking gagal dilacak!", Time = 3})
end

-- ==========================================
-- 2. SISTEM HOOKING (ANTI-HAPUS)
-- ==========================================
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if FreezeVisualOn and not checkcaller() and method == "Destroy" then
        if typeof(self) == "Instance" and self.Parent and self.Parent.Name == "Fruits" then
            return nil -- Buah menjadi abadi
        end
    end
    
    return oldNamecall(self, ...)
end)

-- ==========================================
-- 3. GUI ELEMENTS
-- ==========================================
SecDupe:AddToggle({ 
    Title = "1. Freeze Visual (WAJIB NYALA)", 
    Content = "Mencegat perintah hapus agar buah utuh di layar",
    Default = false, 
    Callback = function(Value) 
        FreezeVisualOn = Value
    end 
})

SecDupe:AddToggle({ 
    Title = "2. 🔄 ENABLE SAFE AUTO DUPE", 
    Content = "Memanen buah abadi secara otomatis tanpa bikin lag",
    Default = false, 
    Callback = function(Value) 
        SafeDupeOn = Value
        if Value then
            Speed_Library:SetNotification({Title = "Safe Dupe", Content = "Memanen santai dimulai!", Time = 2})
        end
    end 
})

-- ==========================================
-- 4. MESIN EKSEKUTOR (VISUAL SPAM BRUTAL MODE)
-- ==========================================
task.spawn(function()
    local Player = game.Players.LocalPlayer

    while task.wait() do -- Putaran utama (tanpa delay buatan)
        if SafeDupeOn then
            local plotId = Player:GetAttribute("PlotId")
            
            if plotId then
                local myPlot = workspace:WaitForChild("Gardens"):FindFirstChild("Plot" .. tostring(plotId))
                
                if myPlot then
                    local plantsFolder = myPlot:FindFirstChild("Plants")
                    
                    if plantsFolder then
                        -- Sapu bersih semua tanaman
                        for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                            local fruitsFolder = plantModel:FindFirstChild("Fruits")
                            
                            if fruitsFolder then
                                -- Serang semua buah sekaligus
                                for _, fruitObj in ipairs(fruitsFolder:GetChildren()) do
                                    local plantId = plantModel:GetAttribute("PlantId") or plantModel.Name
                                    local fruitId = plantModel:GetAttribute("FruitId") or fruitObj.Name
                                    
                                    if plantId and fruitId then
                                        -- 💡 TRIK SPAM UI: Panen dan Jual dieksekusi bersamaan per buah!
                                        task.spawn(function()
                                            -- 1. Sedot buah ke tas
                                            Networking.Garden.CollectFruit:Fire(plantId, fruitId)
                                            -- 2. Langsung paksa jual detik itu juga (memaksa UI memunculkan teks baru untuk buah ini)
                                            Networking.NPCS.SellAll:Fire()
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)
