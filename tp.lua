-- ==========================================
-- SIMPLE TELEPORT & COPY CFRAME
-- ==========================================
local Speed_Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/cunoby/BangBoy/refs/heads/main/D.lua"))()

local Window = Speed_Library:CreateWindow({
    Title = "Teleport & Copy",
    Description = "Simple Utility",
    TabWidth = 140,
    SizeUi = UDim2.fromOffset(400, 260)
})

local TabTeleport = Window:CreateTab({Name = "Teleport", Icon = "rbxassetid://7734010488"})
local SecTele = TabTeleport:AddSection("Tools Kordinat", false)

local SavedCFrame = nil
local InputKordinat = ""

-- 1. Tombol Ambil Koordinat
SecTele:AddButton({
    Title = "📍 Ambil Kordinat Saat Ini", 
    Content = "Merekam posisi karaktermu sekarang",
    Callback = function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            SavedCFrame = tostring(hrp.CFrame)
            pcall(function()
                Speed_Library:SetNotification({Title = "Terekam!", Content = "Kordinat berhasil diambil.", Time = 2})
            end)
        end
    end
})

-- 2. Tombol Salin (Copy ke Clipboard)
SecTele:AddButton({
    Title = "📋 Salin Kordinat (Copy)", 
    Content = "Salin kordinat agar bisa di-paste ke script lain",
    Callback = function()
        if SavedCFrame then
            if setclipboard then
                setclipboard(SavedCFrame)
                pcall(function()
                    Speed_Library:SetNotification({Title = "Disalin!", Content = "Berhasil disalin ke Clipboard!", Time = 2})
                end)
            else
                print("Executor kamu tidak mendukung fitur Copy/setclipboard!")
            end
        else
            print("Klik 'Ambil Kordinat' terlebih dahulu!")
        end
    end
})

-- 3. Input untuk Paste Koordinat Manual
SecTele:AddInput({
    Title = "Paste Kordinat di Sini", 
    Content = "Tempel kordinat untuk tujuan teleport", 
    Default = "", 
    Callback = function(Text) 
        InputKordinat = Text 
    end 
})

-- 4. Tombol Eksekusi Teleport
SecTele:AddButton({
    Title = "🚀 TELEPORT SEKARANG", 
    Content = "Pindah instan ke kordinat yang di-paste / direkam",
    Callback = function()
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Prioritaskan input teks, kalau kosong gunakan koordinat yang baru saja direkam
            local targetString = (InputKordinat ~= "") and InputKordinat or SavedCFrame
            
            if targetString then
                -- Memecah teks CFrame (X, Y, Z, dll) menjadi angka
                local parameterKordinat = {}
                for angka in string.gmatch(targetString, "[^,]+") do
                    table.insert(parameterKordinat, tonumber(angka))
                end
                
                -- Pastikan minimal ada X, Y, Z sebelum teleport
                if #parameterKordinat >= 3 then
                    hrp.CFrame = CFrame.new(unpack(parameterKordinat))
                else
                    print("Format kordinat tidak valid!")
                end
            end
        end
    end
})
