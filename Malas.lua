local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

local Custom = {} do
  Custom.ColorRGB = Color3.fromRGB(250, 7, 7)

  function Custom:Create(Name, Properties, Parent)
    local _instance = Instance.new(Name)
    for i, v in pairs(Properties) do
      _instance[i] = v
    end
    if Parent then
      _instance.Parent = Parent
    end
    return _instance
  end

  function Custom:EnabledAFK()
    Player.Idled:Connect(function()
      VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
  end
end

Custom:EnabledAFK()

function CircleClick(Button, X, Y)
	task.spawn(function()
		Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel")
		Circle.Image = "rbxassetid://106471194043211"
		Circle.ImageColor3 = Color3.fromRGB(80, 80, 80)
		Circle.ImageTransparency = 0.899
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1
		Circle.ZIndex = 10
		Circle.Parent = Button
		
		local NewX = X - Button.AbsolutePosition.X
		local NewY = Y - Button.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)

		local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 1.5
		local Time = 0.5
		local Tween = TweenService:Create(Circle, TweenInfo.new(Time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, Size, 0, Size),
			Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2)
		})
		Tween:Play()
		Tween.Completed:Connect(function()
			for i = 1, 10 do
				Circle.ImageTransparency = Circle.ImageTransparency + 0.01
				task.wait(Time / 10)
			end
			Circle:Destroy()
		end)
	end)
end

local Speed_Library = {}
Speed_Library.Unloaded = false

-- ========================================================
-- FITUR NOTIFIKASI
-- ========================================================
function Speed_Library:SetNotification(Config)
  local Title = Config.Title or Config[1] or ""
  local Description = Config.Description or Config[2] or ""
  local Content = Config.Content or Config[3] or ""
  local Time = Config.Time or Config[5] or 0.5
  local Delay = Config.Delay or Config[6] or 5

  local NotificationGui = Custom:Create("ScreenGui", {ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, RunService:IsStudio() and Player.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

  local NotificationLayout = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(1, 1), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 1,
    BorderSizePixel = 0, Position = UDim2.new(1, -30, 1, -30), Size = UDim2.new(0, 320, 1, 0), Parent = NotificationGui
  })

  local Count = 0
  NotificationLayout.ChildRemoved:Connect(function()
    Count = 0
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    for _, v in ipairs(NotificationLayout:GetChildren()) do
      local NewPOS = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))
      TweenService:Create(v, tweenInfo, {Position = NewPOS}):Play()
      Count = Count + 1
    end
  end)

  local _Count = 0
  for _, v in ipairs(NotificationLayout:GetChildren()) do
    _Count = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
  end

  local NotificationFrame = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 150),
    BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -(_Count)), Parent = NotificationLayout
  })

  local NotificationFrameReal = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(15, 15, 15), BorderSizePixel = 0, Position = UDim2.new(0, 400, 0, 0), Size = UDim2.new(1, 0, 1, 0), Parent = NotificationFrame
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 8)}, NotificationFrameReal)
  Custom:Create("UIStroke", {Color = Color3.fromRGB(50, 50, 50), Thickness = 1.6}, NotificationFrameReal)

  local Top = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36), Parent = NotificationFrameReal})
  
  local TextLabel = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), Parent = Top})
  local TextLabel1 = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Description, TextColor3 = Custom.ColorRGB, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, TextLabel.TextBounds.X + 15, 0, 0), Parent = Top})

  local CloseBtn = Custom:Create("TextButton", {Font = Enum.Font.SourceSans, Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18, AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -5, 0.5, 0), Size = UDim2.new(0, 25, 0, 25), Parent = Top})

  local TextLabel2 = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, Text = Content, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 27), Size = UDim2.new(1, -20, 0, 13), Parent = NotificationFrameReal})
  TextLabel2.Size = UDim2.new(1, -20, 0, 13 + (13 * (TextLabel2.TextBounds.X // TextLabel2.AbsoluteSize.X)))
  TextLabel2.TextWrapped = true

  if TextLabel2.AbsoluteSize.Y < 27 then NotificationFrame.Size = UDim2.new(1, 0, 0, 65) else NotificationFrame.Size = UDim2.new(1, 0, 0, TextLabel2.AbsoluteSize.Y + 40) end

  local Waitted = false
  local function CloseNotif()
    if Waitted then return false end
    Waitted = true
    TweenService:Create(NotificationFrameReal, TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 400, 0, 0)}):Play()
    task.wait(tonumber(Time) / 1.2)
    NotificationFrame:Destroy()
    Waitted = false
  end

  CloseBtn.Activated:Connect(CloseNotif)
  TweenService:Create(NotificationFrameReal, TweenInfo.new(tonumber(Time), Enum.EasingStyle.Back, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 0, 0)}):Play()
  
  task.spawn(function() task.wait(tonumber(Delay)) CloseNotif() end)
end

-- ========================================================
-- CORE ENGINE UI (SPLIT LAYOUT + MINIMIZE FEATURE)
-- ========================================================
function Speed_Library:CreateWindow(Config)
  local Title = Config.Title or Config[1] or ""
  local SizeUi = Config.SizeUi or Config[4] or UDim2.fromOffset(550, 315)
  local CountDropdown = 0

  local SpeedHubXGui = Custom:Create("ScreenGui", {
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  }, RunService:IsStudio() and Player.PlayerGui or (gethui() or cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")))

  -- [FITUR MINIMIZE] Tombol Ikon Mengambang
  local OpenButton = Custom:Create("ImageButton", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0,
    Position = UDim2.new(0.1, 0, 0.1, 0), Size = UDim2.new(0, 59, 0, 49),
    Image = "rbxassetid://136890595976124", Visible = false, Active = true, Draggable = true, Parent = SpeedHubXGui
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 9)}, OpenButton)
  Custom:Create("UIStroke", {Color = Custom.ColorRGB, Thickness = 1.6}, OpenButton)

  -- Frame Utama
  local Main = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.fromRGB(15, 15, 15), BackgroundTransparency = 0.1,
    BorderSizePixel = 0, Position = UDim2.new(0.5, 0, 0.5, 0), Size = SizeUi, Active = true, Draggable = true, Name = "Main"
  }, SpeedHubXGui)

  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 8)}, Main)
  Custom:Create("UIStroke", {Color = Color3.fromRGB(50, 50, 50), Thickness = 1.6}, Main)

  local Top = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 38)}, Main)
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 8)}, Top)

  local TextTitle = Custom:Create("TextLabel", {
    Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Custom.ColorRGB, TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 15, 0, 0), Parent = Top
  })

  -- Tombol Close & Minimize
  local Close = Custom:Create("TextButton", {
    Font = Enum.Font.GothamBold, Text = "X", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 15, AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1, Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.new(0, 25, 0, 25), Parent = Top
  })
  local Min = Custom:Create("TextButton", {
    Font = Enum.Font.GothamBold, Text = "-", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 18, AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0.5, 0), Size = UDim2.new(0, 25, 0, 25), Parent = Top
  })

  -- Logika Close & Minimize
  Close.Activated:Connect(function() SpeedHubXGui:Destroy() end)
  
  Min.Activated:Connect(function()
    Main.Visible = false
    OpenButton.Visible = true
  end)

  OpenButton.MouseButton1Click:Connect(function() 
    Main.Visible = true 
    OpenButton.Visible = false 
end)

OpenButton.TouchTap:Connect(function() 
    Main.Visible = true 
    OpenButton.Visible = false 
end)


  -- ========================================================
  -- KARTU PROFIL PEMAIN & SYSTEM MONITOR
  -- ========================================================
  local PlayerCard = Custom:Create("Frame", {
    BackgroundColor3 = Color3.fromRGB(22, 22, 22), BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 0, 45), Size = UDim2.new(0, 150, 1, -55), Parent = Main
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 6)}, PlayerCard)
  Custom:Create("UIStroke", {Color = Color3.fromRGB(40, 40, 40), Thickness = 1}, PlayerCard)

  local AvatarFrame = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(30, 30, 30), Position = UDim2.new(0.5, -35, 0, 15), Size = UDim2.new(0, 70, 0, 70), Parent = PlayerCard})
  Custom:Create("UICorner", {CornerRadius = UDim.new(1, 0)}, AvatarFrame)
  Custom:Create("UIStroke", {Color = Custom.ColorRGB, Thickness = 2}, AvatarFrame)

  local AvatarImg = Custom:Create("ImageLabel", {
      BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0),
      Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150), Parent = AvatarFrame
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(1, 0)}, AvatarImg)

  local DisplayName = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 95), Size = UDim2.new(1, -10, 0, 20), Font = Enum.Font.GothamBold, Text = Player.DisplayName, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 14, TextTruncate = Enum.TextTruncate.AtEnd, Parent = PlayerCard})
  local Username = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0, 110), Size = UDim2.new(1, -10, 0, 15), Font = Enum.Font.GothamMedium, Text = "@" .. Player.Name, TextColor3 = Color3.fromRGB(150, 150, 150), TextSize = 11, TextTruncate = Enum.TextTruncate.AtEnd, Parent = PlayerCard})

  Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Position = UDim2.new(0, 15, 0, 135), Size = UDim2.new(1, -30, 0, 1), Parent = PlayerCard})

  local DateDisplay = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 145), Size = UDim2.new(1, 0, 0, 15), Font = Enum.Font.GothamSemibold, Text = "Loading...", TextColor3 = Color3.fromRGB(200, 200, 200), TextSize = 11, TextXAlignment = Enum.TextXAlignment.Center, Parent = PlayerCard})
  local TimeDisplay = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 160), Size = UDim2.new(1, 0, 0, 20), Font = Enum.Font.GothamBold, Text = "00:00:00", TextColor3 = Custom.ColorRGB, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Center, Parent = PlayerCard})

  Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Position = UDim2.new(0, 15, 0, 185), Size = UDim2.new(1, -30, 0, 1), Parent = PlayerCard})

  local FPSDisplay = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 195), Size = UDim2.new(1, -30, 0, 15), Font = Enum.Font.GothamBold, Text = "🖥️ FPS: 0", TextColor3 = Color3.fromRGB(255, 200, 100), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = PlayerCard})
  local PingDisplay = Custom:Create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 215), Size = UDim2.new(1, -30, 0, 15), Font = Enum.Font.GothamBold, Text = "📶 Ping: 0 ms", TextColor3 = Color3.fromRGB(150, 255, 150), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = PlayerCard})

  -- Update Real-Time Loop
  local Hari = {"Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"}
  local Bulan = {"Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"}
  
  local LastTick = tick()
  local FrameCount = 0
  RunService.RenderStepped:Connect(function()
      FrameCount = FrameCount + 1
      local CurrentTick = tick()
      if CurrentTick - LastTick >= 1 then
          if FPSDisplay.Parent then FPSDisplay.Text = "🖥️ FPS: " .. FrameCount end
          FrameCount = 0
          LastTick = CurrentTick
      end
  end)

  task.spawn(function()
      while task.wait(1) do
          if not TimeDisplay.Parent then break end
          local waktu = os.date("*t")
          DateDisplay.Text = Hari[waktu.wday] .. ", " .. waktu.day .. " " .. Bulan[waktu.month]
          TimeDisplay.Text = string.format("%02d:%02d:%02d WIB", waktu.hour, waktu.min, waktu.sec)

          local ping = 0
          pcall(function() ping = math.round(Player:GetNetworkPing() * 1000) end)
          if ping == 0 then pcall(function() local stats = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString() ping = math.round(tonumber(string.match(stats, "%d+")) or 0) end) end
          
          PingDisplay.Text = "📶 Ping: " .. ping .. " ms"
          if ping < 100 then PingDisplay.TextColor3 = Color3.fromRGB(150, 255, 150) elseif ping < 250 then PingDisplay.TextColor3 = Color3.fromRGB(255, 255, 100) else PingDisplay.TextColor3 = Color3.fromRGB(255, 100, 100) end
      end
  end)

  -- ========================================================
  -- MENU ACCORDION DI SEBELAH KANAN
  -- ========================================================
  local MasterScroll = Custom:Create("ScrollingFrame", {
    ScrollBarImageColor3 = Custom.ColorRGB, ScrollBarThickness = 2, Active = true, BackgroundTransparency = 1, BorderSizePixel = 0,
    Position = UDim2.new(0, 170, 0, 45), Size = UDim2.new(1, -180, 1, -55), AutomaticCanvasSize = Enum.AutomaticSize.Y, Name = "MasterScroll", Parent = Main
  })

  Custom:Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, MasterScroll)
  Custom:Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 10), PaddingRight = UDim.new(0, 5)}, MasterScroll)

  local MoreBlur = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, Size = UDim2.new(1, 0, 1, 0), Visible = false, ZIndex = 50, Parent = Main
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 8)}, MoreBlur)

  local ConnectButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = MoreBlur})
  
  local DropdownSelect = Custom:Create("Frame", {
    AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Position = UDim2.new(1, 172, 0.5, 0), Size = UDim2.new(0, 160, 1, -16), ClipsDescendants = true, Parent = MoreBlur
  })
  Custom:Create("UICorner", {CornerRadius = UDim.new(0, 3)}, DropdownSelect)
  Custom:Create("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 2.5, Transparency = 0.8}, DropdownSelect)

  local DropdownSelectReal = Custom:Create("Frame", {
      AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ClipsDescendants = true, 
      Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, -10, 1, -10), Parent = DropdownSelect
  })
  local DropdownFolder = Custom:Create("Frame", {Name = "DropdownFolder", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = DropdownSelectReal})
  local DropPageLayout = Custom:Create("UIPageLayout", {
      Padding = UDim.new(0, 30), EasingDirection = Enum.EasingDirection.InOut, EasingStyle = Enum.EasingStyle.Quad, 
      TweenTime = 0.01, SortOrder = Enum.SortOrder.LayoutOrder, Archivable = false, Parent = DropdownFolder
  })

  ConnectButton.Activated:Connect(function()
    if MoreBlur.Visible then
      TweenService:Create(MoreBlur, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
      TweenService:Create(DropdownSelect, TweenInfo.new(0.2), {Position = UDim2.new(1, 172, 0.5, 0)}):Play()
      task.wait(0.2)
      MoreBlur.Visible = false
    end
  end)

  local WindowAPI = {}

  function WindowAPI:AddMainTab(MainName, IsMainOpen)
      local MainTabContainer = Custom:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = MasterScroll})
      Custom:Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, MainTabContainer)

      local MainHeader = Custom:Create("TextButton", {
          BackgroundColor3 = Color3.fromRGB(22, 22, 22), Size = UDim2.new(1, 0, 0, 42), Text = "   " .. MainName, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.GothamBold, TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left, Parent = MainTabContainer
      })
      Custom:Create("UICorner", {CornerRadius = UDim.new(0, 6)}, MainHeader)
      local ChooseFrame = Custom:Create("Frame", {BackgroundColor3 = Custom.ColorRGB, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.5, -8), Size = UDim2.new(0, 2, 0, 16), Parent = MainHeader})
      Custom:Create("UICorner", {}, ChooseFrame)
      Custom:Create("UIStroke", {Color = Custom.ColorRGB, Thickness = 1.6}, ChooseFrame)

      local FeatureFrameTab = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 20, 0, 20), Parent = MainHeader})
      local ArrowImgTab = Custom:Create("ImageLabel", {Image = "rbxassetid://125609963478878", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Rotation = IsMainOpen and 0 or -90, Size = UDim2.new(1, 6, 1, 6), Parent = FeatureFrameTab})

      local MainContent = Custom:Create("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Visible = IsMainOpen, Parent = MainTabContainer})
      Custom:Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, MainContent)

      MainHeader.Activated:Connect(function()
          CircleClick(MainHeader, Player:GetMouse().X, Player:GetMouse().Y)
          MainContent.Visible = not MainContent.Visible
          TweenService:Create(ArrowImgTab, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = MainContent.Visible and 0 or -90}):Play()
      end)

      local MainTabAPI = {}
      local CountSection = 0

      function MainTabAPI:AddSection(Title, OpenSection)
          local Title = Title or ""
          local OpenSection = OpenSection or false
      
          local Section = Custom:Create("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.999, BorderSizePixel = 0, ClipsDescendants = true,
            LayoutOrder = CountSection, Size = UDim2.new(1, 0, 0, 30), Name = "Section", Parent = MainContent
          })
      
          local SectionReal = Custom:Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935,
            BorderSizePixel = 0, LayoutOrder = 1, Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(1, 1, 0, 30), Name = "SectionReal", Parent = Section
          })
          Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, SectionReal)
      
          local SectionButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = SectionReal})
      
          local FeatureFrame = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -5, 0.5, 0), Size = UDim2.new(0, 20, 0, 20), Parent = SectionReal})
          local FeatureImg = Custom:Create("ImageLabel", {Image = "rbxassetid://125609963478878", AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Rotation = -90, Size = UDim2.new(1, 6, 1, 6), Parent = FeatureFrame})
      
          Custom:Create("TextLabel", {
            Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(230, 230, 230), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0.5, 0), Size = UDim2.new(1, -50, 0, 13), Parent = SectionReal
          })
      
          local SectionDecideFrame = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 33), Size = UDim2.new(0, 0, 0, 2), Parent = Section})
          Custom:Create("UICorner", {}, SectionDecideFrame)
          Custom:Create("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)), ColorSequenceKeypoint.new(0.5, Custom.ColorRGB), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))}}, SectionDecideFrame)
      
          local SectionAdd = Custom:Create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, ClipsDescendants = true,
            LayoutOrder = 1, Position = UDim2.new(0.5, 0, 0, 38), Size = UDim2.new(1, 0, 0, 100), Name = "SectionAdd", Parent = Section
          })
          Custom:Create("UICorner", {CornerRadius = UDim.new(0, 2)}, SectionAdd)
          Custom:Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, SectionAdd)
        
          local function UpdateSizeSection()
            if OpenSection then
              local SectionSizeYWitdh = 38
              for _, v in pairs(SectionAdd:GetChildren()) do
                if v.Name ~= "UIListLayout" and v.Name ~= "UICorner" then
                  SectionSizeYWitdh = SectionSizeYWitdh + v.Size.Y.Offset + 3
                end
              end
              TweenService:Create(FeatureFrame, TweenInfo.new(0.1), {Rotation = 90}):Play()
              TweenService:Create(Section, TweenInfo.new(0.1), {Size = UDim2.new(1, 1, 0, SectionSizeYWitdh)}):Play()
              TweenService:Create(SectionAdd, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, SectionSizeYWitdh - 38)}):Play()
              TweenService:Create(SectionDecideFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 2)}):Play()
            end
          end
        
          SectionButton.Activated:Connect(function()
            CircleClick(SectionButton, Player:GetMouse().X, Player:GetMouse().Y)
            if OpenSection then
              TweenService:Create(FeatureFrame, TweenInfo.new(0.1), {Rotation = 0}):Play()
              TweenService:Create(Section, TweenInfo.new(0.1), {Size = UDim2.new(1, 1, 0, 30)}):Play()
              TweenService:Create(SectionDecideFrame, TweenInfo.new(0.1), {Size = UDim2.new(0, 0, 0, 2)}):Play()
              OpenSection = false
            else
              OpenSection = true
              UpdateSizeSection()
            end
          end)
        
          SectionAdd.ChildAdded:Connect(UpdateSizeSection)
          SectionAdd.ChildRemoved:Connect(UpdateSizeSection)
    
          local Item, ItemCount = {}, 0
          
          function Item:AddParagraph(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local SettingFuncs = {}
    
            local Paragraph = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, BorderSizePixel = 0, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Name = "Paragraph", Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Paragraph)
    
            local ParagraphTitle = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(231, 231, 231), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -16, 0, 13), Name = "ParagraphTitle", Parent = Paragraph})
            local ParagraphContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Name = "ParagraphContent", Parent = Paragraph})
    
            local function UpdateParagraphSize()
              ParagraphContent.TextWrapped = false
              local absX = ParagraphContent.AbsoluteSize.X
              local lineCount = math.ceil(ParagraphContent.TextBounds.X / (absX == 0 and 1 or absX))
              ParagraphContent.Size = UDim2.new(1, -16, 0, 12 + (12 * lineCount))
              Paragraph.Size = UDim2.new(1, 0, 0, ParagraphContent.AbsoluteSize.Y + 33)
              ParagraphContent.TextWrapped = true
              UpdateSizeSection()
            end
            UpdateParagraphSize()
            ParagraphContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateParagraphSize)
    
            function SettingFuncs:Set(Config)
              ParagraphTitle.Text = Config.Title or Config[1] or ""
              ParagraphContent.Text = Config.Content or Config[2] or ""
              UpdateParagraphSize()
            end
            return SettingFuncs
          end
    
          function Item:AddSeperator(Config)
            local Title = Config[1] or Config.Title or ""
            local Sep_Funcs = {}
            local Seperator = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(70, 70, 70), BackgroundTransparency = 0.1, BorderSizePixel = 1, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 30), Parent = SectionAdd})
            local SeperatorTitle = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(231, 231, 231), TextStrokeTransparency = 0.8, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -16, 1, 0), Parent = Seperator})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 6)}, Seperator)
            Custom:Create("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 120, 120)), ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 120))}, Rotation = 90}, Seperator)
            function Sep_Funcs:Set(Config) SeperatorTitle.Text = Config.Title or Config[1] or "" end
            ItemCount += 1
            return Sep_Funcs
          end
    
          function Item:AddLine()
            local Line = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(90, 90, 90), BackgroundTransparency = 0.2, BorderSizePixel = 0, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 7), Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 3)}, Line)
            Custom:Create("UIGradient", {Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)), ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))}, Rotation = 0}, Line)
            ItemCount += 1
          end
    
          function Item:AddButton(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local Icon = Config[3] or Config.Icon or "rbxassetid://7734010488"
            local Callback = Config[4] or Config.Callback or function() end
            local Funcs_Button = {}
    
            local Button = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, BorderSizePixel = 0, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Button)
    
            Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(231, 231, 231), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -100, 0, 13), Parent = Button})
            local ButtonContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -100, 0, 12), Parent = Button})
    
            local function UpdateButtonSize()
              local absX = ButtonContent.AbsoluteSize.X
              local _Height = 12 + (12 * (ButtonContent.TextBounds.X // (absX == 0 and 1 or absX)))
              ButtonContent.Size = UDim2.new(1, -100, 0, _Height)
              Button.Size = UDim2.new(1, 0, 0, ButtonContent.AbsoluteSize.Y + 33)
            end
            ButtonContent.TextWrapped = true
            UpdateButtonSize()
            ButtonContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() ButtonContent.TextWrapped = false UpdateButtonSize() ButtonContent.TextWrapped = true UpdateSizeSection() end)
    
            local ButtonButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Button})
            local FeatureFrame1 = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 25, 0, 25), Parent = Button})
            Custom:Create("ImageLabel", {Image = Icon, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(1, 0, 1, 0), Parent = FeatureFrame1})
    
            ButtonButton.Activated:Connect(function() CircleClick(ButtonButton, Player:GetMouse().X, Player:GetMouse().Y) Callback() end)
            ItemCount += 1
            return Funcs_Button
          end
    
          function Item:AddToggle(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local Default = Config[3] or Config.Default or false
            local Callback = Config[4] or Config.Callback or function() end
            local Funcs_Toggle = {Value = Default}
    
            local Toggle = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Toggle)
    
            local ToggleTitle = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextSize = 13, TextColor3 = Color3.fromRGB(231, 231, 231), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -100, 0, 13), Parent = Toggle})
            local ToggleContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), TextTransparency = 0.6, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -100, 0, 12), Parent = Toggle})
            
            local function UpdateToggleSize()
              ToggleContent.TextWrapped = false
              local absX = ToggleContent.AbsoluteSize.X
              local Ratio = ToggleContent.TextBounds.X / (absX == 0 and 1 or absX)
              ToggleContent.Size = UDim2.new(1, -100, 0, 12 + (12 * math.ceil(Ratio)))
              Toggle.Size = UDim2.new(1, 0, 0, ToggleContent.AbsoluteSize.Y + 33)
              ToggleContent.TextWrapped = true
            end
            UpdateToggleSize()
            ToggleContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() UpdateToggleSize() UpdateSizeSection() end)
    
            local ToggleButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Toggle})
            local FeatureFrame2 = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.92, Position = UDim2.new(1, -15, 0.5, 0), Size = UDim2.new(0, 30, 0, 15), Parent = Toggle})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, FeatureFrame2)
            local UIStroke8 = Custom:Create("UIStroke", {Color = Color3.fromRGB(255, 255, 255), Thickness = 2, Transparency = 0.9}, FeatureFrame2)
            local ToggleCircle = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(230, 230, 230), Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(0, 0, 0, 0), Parent = FeatureFrame2})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 15)}, ToggleCircle)
    
            local function ToggleAnimation(isOn)          
              local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
              TweenService:Create(ToggleTitle, tweenInfo, {TextColor3 = isOn and Custom.ColorRGB or Color3.fromRGB(230, 230, 230)}):Play()
              TweenService:Create(ToggleCircle, tweenInfo, {Position = isOn and UDim2.new(0, 15, 0, 0) or UDim2.new(0, 0, 0, 0)}):Play()
              TweenService:Create(UIStroke8, tweenInfo, {Color = isOn and Custom.ColorRGB or Color3.fromRGB(255, 255, 255), Transparency = isOn and 0 or 0.9}):Play()
              TweenService:Create(FeatureFrame2, tweenInfo, {BackgroundColor3 = isOn and Custom.ColorRGB or Color3.fromRGB(255, 255, 255), BackgroundTransparency = isOn and 0 or 0.92}):Play()
            end
          
            ToggleButton.Activated:Connect(function() CircleClick(ToggleButton, Player:GetMouse().X, Player:GetMouse().Y) Funcs_Toggle.Value = not Funcs_Toggle.Value Funcs_Toggle:Set(Funcs_Toggle.Value) end)
            function Funcs_Toggle:Set(Value) Callback(Value) ToggleAnimation(Value) end
            Funcs_Toggle:Set(Funcs_Toggle.Value)
            ItemCount += 1
            return Funcs_Toggle
          end
    
          function Item:AddSlider(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local Increment = Config[3] or Config.Increment or 1
            local Min = Config[4] or Config.Min or 0
            local Max = Config[5] or Config.Max or 100
            local Default = Config[6] or Config.Default or 50
            local Callback = Config[7] or Config.Callback or function() end
            local Funcs_Slider = {Value = Default}
            
            local Slider = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Slider)
    
            Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(230, 230, 230), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -180, 0, 13), Parent = Slider})
            local SliderContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -180, 0, 12), Parent = Slider})
    
            local function UpdateSliderSize()
              SliderContent.TextWrapped = false
              local absX = SliderContent.AbsoluteSize.X
              SliderContent.Size = UDim2.new(1, -180, 0, 12 + (12 * math.floor(SliderContent.TextBounds.X / (absX == 0 and 1 or absX))))
              Slider.Size = UDim2.new(1, 0, 0, SliderContent.AbsoluteSize.Y + 33)
              SliderContent.TextWrapped = true
            end
            SliderContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() UpdateSliderSize() UpdateSizeSection() end)
            UpdateSliderSize()
    
            local SliderInput = Custom:Create("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Custom.ColorRGB, Position = UDim2.new(1, -155, 0.5, 0), Size = UDim2.new(0, 28, 0, 20), Parent = Slider})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 2)}, SliderInput)
            local TextBox = Custom:Create("TextBox", {Font = Enum.Font.GothamBold, Text = tostring(Default), TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 13, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = SliderInput})
            local SliderFrame = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.8, Position = UDim2.new(1, -20, 0.5, 0), Size = UDim2.new(0, 100, 0, 3), Parent = Slider})
            Custom:Create("UICorner", {}, SliderFrame)
            local SliderDraggable = Custom:Create("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Custom.ColorRGB, Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(0.899, 0, 0, 1), Parent = SliderFrame})
            Custom:Create("UICorner", {}, SliderDraggable)
            local SliderCircle = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Custom.ColorRGB, Position = UDim2.new(1, 4, 0.5, 0), Size = UDim2.new(0, 8, 0, 8), Parent = SliderDraggable})
            Custom:Create("UICorner", {}, SliderCircle)
            Custom:Create("UIStroke", {Color = Custom.ColorRGB}, SliderCircle)
    
            local Dragging = false
            local function Round(Number, Factor) local Result = math.floor(Number / Factor + (math.sign(Number) * 0.5)) * Factor if Result < 0 then Result = Result + Factor end return Result end
            
            function Funcs_Slider:Set(Value)
              Value = math.clamp(Round(Value, Increment), Min, Max)
              Funcs_Slider.Value = Value
              TextBox.Text = tostring(Value)
              TweenService:Create(SliderDraggable, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.fromScale((Value - Min) / (Max - Min), 1) }):Play()
            end
            
            SliderFrame.InputBegan:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = true end end)
            SliderFrame.InputEnded:Connect(function(Input) if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then Dragging = false Callback(Funcs_Slider.Value) end end)
            local _LastX = nil
            UserInputService.InputChanged:Connect(function(Input)
              if Dragging then
                local CurrPosX = Input.Position.X
                if CurrPosX ~= _LastX then
                  _LastX = CurrPosX
                  local SizeScale = math.clamp((CurrPosX - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1)
                  Funcs_Slider:Set(Min + ((Max - Min) * SizeScale))
                end
              end
            end)
            TextBox:GetPropertyChangedSignal("Text"):Connect(function() local Valid = TextBox.Text:gsub("[^%d]", "") if Valid ~= "" then TextBox.Text = tostring(math.min(tonumber(Valid), Max)) else TextBox.Text = "0" end end)
            TextBox.FocusLost:Connect(function() if TextBox.Text ~= "" then Funcs_Slider:Set(tonumber(TextBox.Text)) Callback(Funcs_Slider.Value) else Funcs_Slider:Set(0) Callback(Funcs_Slider.Value) end end)
            
            Funcs_Slider:Set(tonumber(Default))
            Callback(Funcs_Slider.Value)
            ItemCount += 1
            return Funcs_Slider
          end
    
          function Item:AddInput(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local Default = Config[3] or Config.Default or ""
            local Callback = Config[4] or Config.Callback or function() end
            local Funcs_Input = {Value = Default}
    
            local Input = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Parent = SectionAdd})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Input)
    
            Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(230, 230, 230), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -180, 0, 13), Parent = Input})
            local InputContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -180, 0, 12), Parent = Input})
    
            local function UpdateInputSize()
              local absX = InputContent.AbsoluteSize.X
              local Ratio = InputContent.TextBounds.X / (absX == 0 and 1 or absX)
              InputContent.Size = UDim2.new(1, -180, 0, 12 + (12 * math.floor(Ratio)))
              Input.Size = UDim2.new(1, 0, 0, InputContent.AbsoluteSize.Y + 33)
            end
            UpdateInputSize()
            InputContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() InputContent.TextWrapped = false UpdateInputSize() InputContent.TextWrapped = true UpdateSizeSection() end)
    
            local InputFrame = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.95, ClipsDescendants = true, Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.new(0, 148, 0, 30), Parent = Input})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, InputFrame)
            local InputTextBox = Custom:Create("TextBox", {Font = Enum.Font.GothamBold, PlaceholderColor3 = Color3.fromRGB(120, 120, 120), PlaceholderText = "Write your input there", Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.new(1, -10, 1, -8), Parent = InputFrame})
    
            function Funcs_Input:Set(Value) InputTextBox.Text = Value Funcs_Input.Value = Value Callback(Value) end
            InputTextBox.FocusLost:Connect(function() Funcs_Input:Set(InputTextBox.Text) end)
            Funcs_Input:Set(Default)
            ItemCount += 1
            return Funcs_Input
          end
    
          function Item:AddDropdown(Config)
            local Title = Config[1] or Config.Title or ""
            local Content = Config[2] or Config.Content or ""
            local Multi = Config[3] or Config.Multi or false
            local Options = Config[4] or Config.Options or {}
            local Default = Config[5] or Config.Default or {}
            local Callback = Config[6] or Config.Callback or function() end
            local Funcs_Dropdown = {Value = Default, Options = Options}
    
            local CurrentLayout = CountDropdown
            CountDropdown += 1
    
            local Dropdown = Custom:Create("Frame", {BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.935, LayoutOrder = ItemCount, Size = UDim2.new(1, 0, 0, 35), Parent = SectionAdd})
            local DropdownButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Dropdown})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, Dropdown)
    
            Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Title, TextColor3 = Color3.fromRGB(230, 230, 230), TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(1, -180, 0, 13), Parent = Dropdown})
            local DropdownContent = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = Content, TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -180, 0, 12), Parent = Dropdown})
            
            local function UpdateDropSize()
              local absX = DropdownContent.AbsoluteSize.X
              DropdownContent.Size = UDim2.new(1, -180, 0, 12 + (12 * (DropdownContent.TextBounds.X // (absX == 0 and 1 or absX))))
              Dropdown.Size = UDim2.new(1, 0, 0, DropdownContent.AbsoluteSize.Y + 33)
            end
            UpdateDropSize()
            DropdownContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() DropdownContent.TextWrapped = false UpdateDropSize() DropdownContent.TextWrapped = true UpdateSizeSection() end)
    
            local SelectOptionsFrame = Custom:Create("Frame", {AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.95, Position = UDim2.new(1, -7, 0.5, 0), Size = UDim2.new(0, 148, 0, 30), LayoutOrder = CurrentLayout, Parent = Dropdown})
            Custom:Create("UICorner", {CornerRadius = UDim.new(0, 4)}, SelectOptionsFrame)
            local OptionSelecting = Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, TextTransparency = 0.6, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, AnchorPoint = Vector2.new(0, 0.5), BackgroundTransparency = 1, Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.new(1, -30, 1, -8), Parent = SelectOptionsFrame})
            Custom:Create("ImageLabel", {Image = "rbxassetid://90200523188815", ImageColor3 = Color3.fromRGB(231, 231, 231), AnchorPoint = Vector2.new(1, 0.5), BackgroundTransparency = 1, Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 25, 0, 25), Parent = SelectOptionsFrame})
    
            local ScrollSelect = Custom:Create("ScrollingFrame", {ScrollBarThickness = 0, Active = true, LayoutOrder = CurrentLayout, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = DropdownFolder})
            Custom:Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}, ScrollSelect)
            local SearchBar = Custom:Create("TextBox", {Font = Enum.Font.GothamBold, PlaceholderText = "Search", PlaceholderColor3 = Color3.fromRGB(120, 120, 120), Text = "", TextColor3 = Color3.fromRGB(255, 255, 255), TextSize = 12, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.9, BorderColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 1, Size = UDim2.new(1, 0, 0, 20), Name = "SearchBar", Parent = ScrollSelect})
    
            DropdownButton.Activated:Connect(function()
              if not MoreBlur.Visible then
                MoreBlur.Visible = true
                DropPageLayout:JumpToIndex(CurrentLayout)
                TweenService:Create(MoreBlur, TweenInfo.new(0.1), {BackgroundTransparency = 0.7}):Play()
                TweenService:Create(DropdownSelect, TweenInfo.new(0.1), {Position = UDim2.new(1, -11, 0.5, 0)}):Play()
              end
            end)
    
            SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
              local SearchText = string.lower(SearchBar.Text)
              for _, v in pairs(ScrollSelect:GetChildren()) do
                if v:IsA("Frame") and v.Name == "Option" then
                  local OptionText = v:FindFirstChild("OptionText")
                  if OptionText then v.Visible = string.find(string.lower(OptionText.Text), SearchText) ~= nil end
                end
              end
            end)
    
            local DropCount = 0
            function Funcs_Dropdown:Clear() 
              for _, DropFrame in pairs(ScrollSelect:GetChildren()) do 
                if DropFrame:IsA("Frame") and DropFrame.Name == "Option" then 
                  Funcs_Dropdown.Value = {} 
                  Funcs_Dropdown.Options = {} 
                  OptionSelecting.Text = "Select Options" 
                  DropFrame:Destroy() 
                end 
              end 
            end
            
            function Funcs_Dropdown:Set(Value)
              Funcs_Dropdown.Value = Value or Funcs_Dropdown.Value
              for _, Drop in pairs(ScrollSelect:GetChildren()) do
                if Drop:IsA("Frame") and Drop.Name == "Option" then
                  local isTextFound = false
                  if type(Funcs_Dropdown.Value) == "table" then
                    isTextFound = table.find(Funcs_Dropdown.Value, Drop.OptionText.Text) ~= nil
                  else
                    isTextFound = (Funcs_Dropdown.Value == Drop.OptionText.Text)
                  end
                  
                  local twInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                  TweenService:Create(Drop.ChooseFrame, twInfo, {Size = isTextFound and UDim2.new(0, 1, 0, 12) or UDim2.new(0, 0, 0, 0)}):Play()
                  TweenService:Create(Drop.ChooseFrame.UIStroke, twInfo, {Transparency = isTextFound and 0 or 0.999}):Play()
                  TweenService:Create(Drop, twInfo, {BackgroundTransparency = isTextFound and 0.935 or 0.999}):Play()
                end
              end
              
              local DropdownValueTable = type(Funcs_Dropdown.Value) == "table" and table.concat(Funcs_Dropdown.Value, ", ") or tostring(Funcs_Dropdown.Value)
              OptionSelecting.Text = (DropdownValueTable ~= "" and DropdownValueTable ~= "nil") and DropdownValueTable or "Select Options"
              Callback(Funcs_Dropdown.Value)
            end
    
            function Funcs_Dropdown:AddOption(OptionName)
              OptionName = OptionName or "Option"
              local Option = Custom:Create("Frame", {BackgroundTransparency = 1, LayoutOrder = DropCount, Size = UDim2.new(1, 0, 0, 30), Name = "Option", Parent = ScrollSelect})
              Custom:Create("UICorner", {CornerRadius = UDim.new(0, 3)}, Option)
              local OptionButton = Custom:Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = Option})
              Custom:Create("TextLabel", {Font = Enum.Font.GothamBold, Text = OptionName, TextSize = 13, TextColor3 = Color3.fromRGB(230, 230, 230), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 8), Size = UDim2.new(1, -100, 0, 13), Name = "OptionText", Parent = Option})
              
              local ChooseFrame = Custom:Create("Frame", {AnchorPoint = Vector2.new(0, 0.5), BackgroundColor3 = Custom.ColorRGB, Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.new(0, 0, 0, 0), Name = "ChooseFrame", Parent = Option})
              Custom:Create("UIStroke", {Color = Custom.ColorRGB, Thickness = 1.6, Transparency = 0.999}, ChooseFrame)
              Custom:Create("UICorner", {}, ChooseFrame)
      
              OptionButton.Activated:Connect(function()
                CircleClick(OptionButton, Player:GetMouse().X, Player:GetMouse().Y)
                local isOptionSelected = Option.BackgroundTransparency > 0.95
                if Multi then
                  local tbl = type(Funcs_Dropdown.Value) == "table" and Funcs_Dropdown.Value or {}
                  if isOptionSelected then
                    if not table.find(tbl, OptionName) then table.insert(tbl, OptionName) end
                  else
                    for i, value in ipairs(tbl) do if value == OptionName then table.remove(tbl, i) break end end
                  end
                  Funcs_Dropdown.Value = tbl
                else Funcs_Dropdown.Value = {OptionName} end
                Funcs_Dropdown:Set(Funcs_Dropdown.Value)
              end)
            
              local OffsetY = 0
              for _, child in ipairs(ScrollSelect:GetChildren()) do if child.Name ~= "UIListLayout" and child.Name ~= "SearchBar" then OffsetY = OffsetY + 5 + child.Size.Y.Offset end end
              ScrollSelect.CanvasSize = UDim2.new(0, 0, 0, OffsetY)
              DropCount += 1
            end
    
            function Funcs_Dropdown:Refresh(RefreshList, Selecting)
              RefreshList = RefreshList or {}
              Selecting = Selecting or {}
              Funcs_Dropdown:Clear()
              for _, Drop in ipairs(RefreshList) do Funcs_Dropdown:AddOption(Drop) end
              Funcs_Dropdown.Options = RefreshList
              Funcs_Dropdown:Set(Selecting)
            end
          
            Funcs_Dropdown:Refresh(Funcs_Dropdown.Options, Funcs_Dropdown.Value)
            ItemCount += 1
            return Funcs_Dropdown
          end
    
          return Item
      end
      return MainTabAPI
  end
  return WindowAPI
end
