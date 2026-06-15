-- ==========================================
-- 🧪 TESTER: SEAMLESS HOP + SKIP LOADING + AUTO RE-EXECUTE
-- ==========================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- 🧳 1. SIAPKAN BARANG SELUNDUPAN (QUEUE ON TELEPORT)
-- Mendukung berbagai macam eksekutor (Delta, Fluxus, Codex, dll)
local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport)

if queue_on_teleport then
    -- Ini adalah kode yang akan DIBAWA TERBANG dan dieksekusi di server baru
    local ScriptPenyelundup = [[
        -- A. Hancurkan Loading Screen Game Instan
        task.spawn(function()
            local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            local function NukeUI()
                for _, gui in ipairs(PlayerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        for _, desc in ipairs(gui:GetDescendants()) do
                            if desc:IsA("TextLabel") and (string.find(string.lower(desc.Text), "loading") or string.find(string.lower(desc.Text), "harvest")) then
                                gui.Enabled = false
                                gui:Destroy()
                                break
                            end
                        end
                    end
                end
            end
            NukeUI()
            PlayerGui.ChildAdded:Connect(function()
                task.wait(0.1)
                NukeUI()
            end)
        end)

        -- B. Notifikasi Bukti Berhasil Re-Execute
        task.wait(2)
        game.StarterGui:SetCore("SendNotification", {
            Title = "🤖 Sistem Aktif!",
            Text = "Script WisHub berhasil diselundupkan ke server baru!",
            Duration = 5
        })

        -- C. AREA EKSEKUSI HUB UTAMA (Nanti hapus tanda -- nya)
        -- loadstring(game:HttpGet("https://raw.githubusercontent.com/AkunKamu/RepoKamu/main/WisHub.lua"))()
    ]]
    
    -- Masukkan ke dalam koper karakter!
    queue_on_teleport(ScriptPenyelundup)
    print("✅ Script re-execute sudah masuk ke antrean teleport!")
else
    print("⚠️ Eksekutormu tidak mendukung queue_on_teleport!")
end


-- 🚀 2. TOMBOL HOP DI LAYAR
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local testButton = Instance.new("TextButton", screenGui)
testButton.Size = UDim2.new(0, 320, 0, 50)
testButton.Position = UDim2.new(0.5, -160, 0.9, 0)
testButton.Text = "🚀 HOP + RE-EXECUTE SEKARANG"
testButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
testButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 16

testButton.MouseButton1Click:Connect(function()
    testButton.Text = "🔍 Mencari Korban Baru..."
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    
    task.spawn(function()
        local success, result = pcall(function()
            local api_url = "https://games.roblox.com/v1/games/" .. tostring(PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            return game:HttpGet(api_url)
        end)
        
        if success and result then
            local data = HttpService:JSONDecode(result)
            local targetServer = nil
            
            for _, server in ipairs(data.data) do
                if type(server) == "table" and server.playing < server.maxPlayers and server.id ~= JobId then
                    targetServer = server.id
                    break
                end
            end
            
            if targetServer then
                testButton.Text = "⚡ MENGHILANG..."
                
                -- Layar tembus pandang (Seamless)
                local invisibleGui = Instance.new("ScreenGui")
                invisibleGui.IgnoreGuiInset = true
                TeleportService:SetTeleportGui(invisibleGui)
                
                -- LAKUKAN LOMPATAN
                TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
            else
                testButton.Text = "❌ Gagal Dapat Server"
                task.wait(2)
                testButton.Text = "🚀 HOP + RE-EXECUTE SEKARANG"
            end
        end
    end)
end)
