local AllowedPlaces = {
    [893973440] = true,
    [74436060734791] = true,
    [100448435050950] = true,
}

if not AllowedPlaces[game.PlaceId] then
    game.Players.LocalPlayer:Kick("This experience is not supported, please execute FTF Eclipse in Flee the Facility only. NexVoid On Top!")
    return
end

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function GetDeviceType()
    if UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled then
        return "Mobile"
    elseif UIS.KeyboardEnabled and UIS.MouseEnabled and UIS.TouchEnabled then
        return "Tablet"
    elseif UIS.KeyboardEnabled and UIS.MouseEnabled then
        return "PC"
    else
        return "Unknown"
    end
end

local deviceType = GetDeviceType()
local currentLang = "EN"

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local gui = Instance.new("ScreenGui")
gui.Name = "EclipseUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 9999
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local openButton = Instance.new("ImageButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0, 15, 0, 60)
openButton.Image = "rbxassetid://75089517810614"
openButton.BackgroundTransparency = 1
openButton.Visible = false
openButton.ZIndex = 23
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 6)

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "rbxassetid://109947390024918"
bg.ImageTransparency = 0
bg.BackgroundTransparency = 1
bg.ZIndex = 22
bg.Parent = openButton
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)

local border = Instance.new("Frame")
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundColor3 = Color3.fromRGB(255,255,255)
border.ZIndex = 21
border.Parent = openButton
Instance.new("UICorner", border).CornerRadius = UDim.new(0, 8)

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
}
gradient.Rotation = 135
gradient.Parent = border

openButton.MouseEnter:Connect(function() openButton.ImageTransparency = 0.2 end)
openButton.MouseLeave:Connect(function() openButton.ImageTransparency = 0 end)

local draggingBtn, dragStartBtn, startPosBtn, dragInputBtn = false
openButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingBtn = true
		dragStartBtn = input.Position
		startPosBtn = openButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then draggingBtn = false end
		end)
	end
end)
openButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputBtn = input
	end
end)
UIS.InputChanged:Connect(function(input)
	if draggingBtn and input == dragInputBtn then
		local delta = input.Position - dragStartBtn
		openButton.Position = UDim2.new(startPosBtn.X.Scale, startPosBtn.X.Offset + delta.X, startPosBtn.Y.Scale, startPosBtn.Y.Offset + delta.Y)
	end
end)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 525, 0, 372)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.ZIndex = 10
frame.Parent = gui

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Transparency = 0.1
stroke.ZIndex = 11

local bg = Instance.new("ImageLabel", frame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = ""
bg.ImageTransparency = 0.3
bg.ZIndex = 9

local topbar = Instance.new("Frame", frame)
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundTransparency = 1

local draggingFrame, dragInputFrame, dragStartFrame, startPosFrame = false
local function UpdateFrameInput(input)
	local delta = input.Position - dragStartFrame
	frame.Position = UDim2.new(startPosFrame.X.Scale, startPosFrame.X.Offset + delta.X, startPosFrame.Y.Scale, startPosFrame.Y.Offset + delta.Y)
end

topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingFrame = true
		dragStartFrame = input.Position
		startPosFrame = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingFrame = false
			end
		end)
	end
end)

topbar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInputFrame = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInputFrame and draggingFrame then
		UpdateFrameInput(input)
	end
end)

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "FTF"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 46, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Eclipse V2.9"
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(140, 140, 140)

local searchBox = Instance.new("Frame", topbar)
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(0, 90, 0, 23)
searchBox.Position = UDim2.new(1, -245, 0, 8)
searchBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
searchBox.BackgroundTransparency = 0.65
searchBox.BorderSizePixel = 0
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", searchBox).Color = Color3.fromRGB(60, 60, 60)

local searchIcon = Instance.new("ImageLabel", searchBox)
searchIcon.Size = UDim2.new(0, 14, 0, 14)
searchIcon.Position = UDim2.new(0, 6, 0.5, -8)
searchIcon.BackgroundTransparency = 1
searchIcon.Image = "rbxassetid://73518047113283"
searchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

local searchInput = Instance.new("TextBox", searchBox)
searchInput.Name = "SearchInput"
searchInput.Size = UDim2.new(1, -30, 1, 0)
searchInput.Position = UDim2.new(0, 28, 0, 0)
searchInput.BackgroundTransparency = 1
searchInput.PlaceholderText = "Search..."
searchInput.Text = ""
searchInput.TextColor3 = Color3.fromRGB(220, 220, 220)
searchInput.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
searchInput.TextSize = 11
searchInput.Font = Enum.Font.GothamBold
searchInput.TextXAlignment = Enum.TextXAlignment.Left
searchInput.ClearTextOnFocus = false

local langBtn = Instance.new("TextButton", topbar)
langBtn.Size = UDim2.new(0, 32, 0, 28)
langBtn.Position = UDim2.new(1, -145, 0, 6)
langBtn.Text = "EN"
langBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
langBtn.BackgroundTransparency = 1
langBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
langBtn.TextSize = 15
langBtn.Font = Enum.Font.GothamBold
langBtn.BorderSizePixel = 0
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langBtn).Color = Color3.fromRGB(60, 60, 60)

local infoBtn = Instance.new("ImageButton", topbar)
infoBtn.Size = UDim2.new(0, 15, 0, 15)
infoBtn.Position = UDim2.new(1, -100, 0, 13)
infoBtn.BackgroundTransparency = 1
infoBtn.Image = "rbxassetid://5832745500"
infoBtn.ImageColor3 = Color3.fromRGB(200, 200, 200)

local miniBtn = Instance.new("TextButton", topbar)
miniBtn.Size = UDim2.new(0, 28, 0, 28)
miniBtn.Position = UDim2.new(1, -70, 0, 6)
miniBtn.Text = "–"
miniBtn.BackgroundTransparency = 1
miniBtn.TextColor3 = Color3.fromRGB(200,200,200)
miniBtn.TextSize = 24
miniBtn.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton", topbar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -35, 0, 6)
closeBtn.Text = "x"
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(200,200,200)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold

local line = Instance.new("Frame", topbar)
line.Size = UDim2.new(1, 0, 0, 1)
line.Position = UDim2.new(0, 0, 1, 0)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.85
line.BorderSizePixel = 0

local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, 0, 1, -56)
container.Position = UDim2.new(0, 0, 0, 40)
container.BackgroundTransparency = 1

local sidebar = Instance.new("Frame", container)
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", sidebar).Padding = UDim.new(0, 4)
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 5)

local content = Instance.new("Frame", container)
content.Size = UDim2.new(1, -130, 1, 0)
content.Position = UDim2.new(0, 130, 0, 0)
content.BackgroundTransparency = 1
content.ClipsDescendants = true

local function CreateGroupbox(parent, title)
	local groupbox = Instance.new("Frame")
	groupbox.Size = UDim2.new(1, 0, 0, 0)
	groupbox.AutomaticSize = Enum.AutomaticSize.Y
	groupbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	groupbox.BackgroundTransparency = 0.6
	groupbox.Parent = parent
	Instance.new("UICorner", groupbox).CornerRadius = UDim.new(0, 8)
	
	local groupboxStroke = Instance.new("UIStroke", groupbox)
	groupboxStroke.Color = Color3.fromRGB(0, 0, 0)
	groupboxStroke.Thickness = 1
	groupboxStroke.Transparency = 0.2
	
	local header = Instance.new("Frame", groupbox)
	header.Size = UDim2.new(1, 0, 0, 35)
	header.BackgroundTransparency = 1
	
	local titleLabel = Instance.new("TextLabel", header)
	titleLabel.Size = UDim2.new(1, -30, 1, 0)
	titleLabel.Position = UDim2.new(0, 22, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	local divider = Instance.new("Frame", groupbox)
	divider.Size = UDim2.new(1, -24, 0, 1)
	divider.Position = UDim2.new(0, 12, 0, 35)
	divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	divider.BackgroundTransparency = 0.3
	divider.BorderSizePixel = 0
	
	local contentFrame = Instance.new("Frame", groupbox)
	contentFrame.Size = UDim2.new(1, -24, 0, 0)
	contentFrame.Position = UDim2.new(0, 12, 0, 45)
	contentFrame.BackgroundTransparency = 1
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y
	Instance.new("UIListLayout", contentFrame).Padding = UDim.new(0, 8)
	Instance.new("UIPadding", contentFrame).PaddingBottom = UDim.new(0, 12)
	
	return groupbox, contentFrame
end

function Notify(title, text, duration)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local gui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("EclipseUI") 
    
    if not gui then
        local screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
        screen.Name = "NotifyGui"
        gui = screen
    end

    duration = duration or 3

    local notify = Instance.new("Frame", gui)
    notify.Size = UDim2.new(0, 260, 0, 70)
    notify.AnchorPoint = Vector2.new(1, 1)
    notify.Position = UDim2.new(1, 300, 1, -25)
    notify.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notify.BorderSizePixel = 0
    notify.ZIndex = 1000

    Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notify)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1

    local icon = Instance.new("ImageLabel", notify)
    icon.Size = UDim2.new(0, 42, 0, 42)
    icon.Position = UDim2.new(0, 12, 0.5, -21)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://75089517810614"

    local titleLabel = Instance.new("TextLabel", notify)
    titleLabel.Size = UDim2.new(1, -65, 0, 22)
    titleLabel.Position = UDim2.new(0, 60, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local textLabel = Instance.new("TextLabel", notify)
    textLabel.Size = UDim2.new(1, -65, 0, 18)
    textLabel.Position = UDim2.new(0, 60, 0, 34)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text
    textLabel.TextSize = 13
    textLabel.TextColor3 = Color3.fromRGB(180,180,180)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    local barBg = Instance.new("Frame", notify)
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.Position = UDim2.new(0, 0, 1, -3)
    barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    barBg.BorderSizePixel = 0

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bar.BorderSizePixel = 0

    TweenService:Create(notify, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -25)}):Play()
    TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,1,0)}):Play()

    task.delay(duration, function()
        TweenService:Create(notify, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -25)}):Play()
        task.wait(0.35)
        notify:Destroy()
    end)
end

task.spawn(function()
    task.wait(2)
    Notify("FTF Eclipse V2.9", "Welcome, " .. game.Players.LocalPlayer.Name .. ".", 4)
end)

local CROSSHAIR_SIZE = 26

local CrosshairLayer = Instance.new("Frame")
CrosshairLayer.Name = "CrosshairLayer"
CrosshairLayer.Size = UDim2.fromScale(1, 1)
CrosshairLayer.Position = UDim2.fromScale(0, 0)
CrosshairLayer.BackgroundTransparency = 1
CrosshairLayer.ClipsDescendants = true
CrosshairLayer.Active = false
CrosshairLayer.ZIndex = 100
CrosshairLayer.Parent = frame

local Crosshair = Instance.new("ImageLabel")
Crosshair.Name = "Crosshair_ID001"
Crosshair.Size = UDim2.fromOffset(
    CROSSHAIR_SIZE,
    CROSSHAIR_SIZE
)
Crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
Crosshair.BackgroundTransparency = 1
Crosshair.Image = "rbxassetid://13210153721"
Crosshair.ScaleType = Enum.ScaleType.Fit
Crosshair.Visible = false
Crosshair.Active = false
Crosshair.ZIndex = 101
Crosshair.Parent = CrosshairLayer

local activeTouch = nil
local mouseHeld = false

local function UpdateCrosshair(position)
    local origin = frame.AbsolutePosition
    local size = frame.AbsoluteSize

    local x = position.X - origin.X
    local y = position.Y - origin.Y

    if x >= 0 and x <= size.X
    and y >= 0 and y <= size.Y then

        Crosshair.Position = UDim2.fromOffset(x, y)
        Crosshair.Visible = true
    else
        Crosshair.Visible = false
    end
end

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        activeTouch = input
        UpdateCrosshair(input.Position)

    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseHeld = true
        UpdateCrosshair(input.Position)
    end
end)

UIS.TouchMoved:Connect(function(input)
    if input == activeTouch then
        UpdateCrosshair(input.Position)
    end
end)

UIS.InputChanged:Connect(function(input)
    if mouseHeld
    and input.UserInputType == Enum.UserInputType.MouseMovement then
        UpdateCrosshair(input.Position)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input == activeTouch then
        activeTouch = nil
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        mouseHeld = false
    end
end)

local bottomBar = Instance.new("Frame", frame)
bottomBar.Name = "BottomBar"
bottomBar.Size = UDim2.new(1, 0, 0, 16)
bottomBar.Position = UDim2.new(0, 0, 1, -16)
bottomBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bottomBar.BackgroundTransparency = 1
bottomBar.BorderSizePixel = 0

local bottomStroke = Instance.new("UIStroke", bottomBar)
bottomStroke.Color = Color3.fromRGB(50, 50, 50)
bottomStroke.Thickness = 1
bottomStroke.Transparency = 0.5

local discordText = Instance.new("TextLabel", bottomBar)
discordText.Size = UDim2.new(0.5, 0, 1, 0)
discordText.Position = UDim2.new(0, 10, 0, 0)
discordText.BackgroundTransparency = 1
discordText.Text = "Discord:.gg/tDaAubSS3V"
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 10
discordText.TextColor3 = Color3.fromRGB(255, 255, 255)
discordText.TextXAlignment = Enum.TextXAlignment.Left

local versionText = Instance.new("TextLabel", bottomBar)
versionText.Size = UDim2.new(0.5, -10, 1, 0)
versionText.Position = UDim2.new(0.5, 0, 0, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "FTF Eclipse V2.9 ".. deviceType.. " ┃ Thank you for using FTF Eclipse."
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 10
versionText.TextColor3 = Color3.fromRGB(255, 255, 255)
versionText.TextXAlignment = Enum.TextXAlignment.Right

local function CreateToggle(parent, text, default, callback)
	local toggleFrame = Instance.new("Frame", parent)
	toggleFrame.Size = UDim2.new(1, 0, 0, 22)
	toggleFrame.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel", toggleFrame)
	label.Size = UDim2.new(1, -50, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(180, 180, 180)
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local toggle = Instance.new("TextButton", toggleFrame)
	toggle.Size = UDim2.new(0, 38, 0, 17)
	toggle.Position = UDim2.new(1, -40, 0.5, -9)
	toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	toggle.BackgroundTransparency = default and 0 or 1
	toggle.Text = ""
	toggle.AutoButtonColor = false
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
	
	local stroke = Instance.new("UIStroke", toggle)
	stroke.Color = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
	stroke.Thickness = 1.5
	
	local circle = Instance.new("Frame", toggle)
	circle.Size = UDim2.new(0, 14, 0, 14)
	circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	circle.BackgroundColor3 = default and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
	circle.BorderSizePixel = 0
	Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
	
	local enabled = default
	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		
		TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
			BackgroundColor3 = enabled and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
		}):Play()
		
		TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
			BackgroundTransparency = enabled and 0 or 1,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
		
		TweenService:Create(stroke, TweenInfo.new(0.15), {
			Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
		}):Play()
		
		if callback then callback(enabled) end
	end)
	
	return toggleFrame
end

local tabs = {
	{Name = "Highlights", Icon = "rbxassetid://98889659045683"},
	{Name = "Visual", Icon = "rbxassetid://78134819718605"},
	{Name = "Progress", Icon = "rbxassetid://117215481109731"},
	{Name = "Textures", Icon = "rbxassetid://12623720992"},
	{Name = "Fog", Icon = "rbxassetid://88527860157418"},
	{Name = "Auto Farm", Icon = "rbxassetid://9768843948"},
	{Name = "Advanced", Icon = "rbxassetid://101596398409097"},
	{Name = "Sounds", Icon = "rbxassetid://93160522453913"},
    {Name = "Visual Skins", Icon = "rbxassetid://138986094998542"},
    {Name = "Teleport", Icon = "rbxassetid://84854819063665"},    
    {Name = "Setting", Icon = "rbxassetid://11956055886"},
}

local pages = {}
local tabIndicators = {}
local tabShines = {}

for i, tab in ipairs(tabs) do
	local button = Instance.new("TextButton", sidebar)
	button.Size = UDim2.new(1, 0, 0, 22)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.AutoButtonColor = false
	button.ClipsDescendants = true

	local indicator = Instance.new("Frame", button)
	indicator.Size = UDim2.new(0, 3, 0.7, 0)
	indicator.Position = UDim2.new(0, 0, 0.5, 0)
	indicator.AnchorPoint = Vector2.new(0, 0.5)
	indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	indicator.BorderSizePixel = 0
	indicator.Visible = i == 1
	tabIndicators[tab.Name] = indicator

	local icon = Instance.new("ImageLabel", button)
	icon.Size = UDim2.new(0, 15, 0, 15)
	icon.Position = UDim2.new(0, 8, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.BackgroundTransparency = 1
	icon.Image = tab.Icon
	icon.ImageColor3 = i == 1 and Color3.fromRGB(220,220,220) or Color3.fromRGB(150,150,150)
	icon.ZIndex = 2

	local label = Instance.new("TextLabel", button)
	label.Name = "BaseLabel"
	label.Size = UDim2.new(1, -35, 1, 0)
	label.Position = UDim2.new(0, 32, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = tab.Name
	label.Font = Enum.Font.GothamBold
	label.TextSize = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = i == 1 and Color3.fromRGB(220,220,220) or Color3.fromRGB(150,150,150)
	label.ZIndex = 1
	
	local shineLabel = Instance.new("TextLabel", button)
	shineLabel.Name = "ShineLabel"
	shineLabel.Size = UDim2.new(1, -35, 1, 0)
	shineLabel.Position = UDim2.new(0, 32, 0, 0)
	shineLabel.BackgroundTransparency = 1
	shineLabel.Text = tab.Name
	shineLabel.Font = Enum.Font.GothamBold
	shineLabel.TextSize = 10
	shineLabel.TextXAlignment = Enum.TextXAlignment.Left
	shineLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	shineLabel.ZIndex = 2
	shineLabel.Visible = true
	
	local shineGradient = Instance.new("UIGradient", shineLabel)
	shineGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.3, 1),
		NumberSequenceKeypoint.new(0.45, 0.2),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(0.55, 0.2),
		NumberSequenceKeypoint.new(0.7, 1),
		NumberSequenceKeypoint.new(1, 1)
	}
	shineGradient.Offset = Vector2.new(-1.5, 0)
	
	tabShines[tab.Name] = {base = label, shine = shineLabel, gradient = shineGradient, icon = icon}

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = i == 1
	page.ScrollBarThickness = 4
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.ClipsDescendants = true
	Instance.new("UIListLayout", page).Padding = UDim.new(0, 10)
	Instance.new("UIPadding", page).PaddingTop = UDim.new(0, 10)
	Instance.new("UIPadding", page).PaddingLeft = UDim.new(0, 10)
	Instance.new("UIPadding", page).PaddingRight = UDim.new(0, 10)
	pages[tab.Name] = page

	button.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		page.Visible = true
		
		for name, ind in pairs(tabIndicators) do
			ind.Visible = false
			tabShines[name].base.TextColor3 = Color3.fromRGB(150,150,150)
			tabShines[name].icon.ImageColor3 = Color3.fromRGB(150,150,150)
		end
		indicator.Visible = true
		label.TextColor3 = Color3.fromRGB(220,220,220)
		icon.ImageColor3 = Color3.fromRGB(220,220,220)
	end)
	
	button.MouseEnter:Connect(function()
		if not indicator.Visible then
			TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(180,180,180)}):Play()
			TweenService:Create(icon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(180,180,180)}):Play()
		end
	end)
	
	button.MouseLeave:Connect(function()
		if not indicator.Visible then
			TweenService:Create(label, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150,150,150)}):Play()
			TweenService:Create(icon, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(150,150,150)}):Play()
		end
	end)
end

local ShineTweenInfo = TweenInfo.new(
    2.5,
    Enum.EasingStyle.Linear,
    Enum.EasingDirection.InOut
)

task.spawn(function()
    while task.wait(2.5) do
        for _, data in pairs(tabShines) do
            if data.gradient and data.gradient.Parent then
                data.gradient.Offset = Vector2.new(-1.5, 0)

                TweenService:Create(
                    data.gradient,
                    ShineTweenInfo,
                    {
                        Offset = Vector2.new(1.5, 0)
                    }
                ):Play()
            end
        end
    end
end)

do
    local function getBeast()
        local players = game.Players:GetPlayers()
        for i = 1, #players do
            local player = players[i]
            local character = player.Character
            if character and character:FindFirstChild("Hammer") then
                return player
            end
        end
    end

    local HighlightMode = "Fill"
    local SAVE_FILE = "EclipseColors.json"

    local function ColorToTable(c)
        return {r = math.floor(c.R * 255 + 0.5), g = math.floor(c.G * 255 + 0.5), b = math.floor(c.B * 255 + 0.5)}
    end
    local function TableToColor(t, fallback)
        if type(t) == "table" and t.r and t.g and t.b then
            return Color3.fromRGB(t.r, t.g, t.b)
        end
        return fallback
    end

    local SavedColors = {}
    pcall(function()
        if isfile and isfile(SAVE_FILE) then
            SavedColors = HttpService:JSONDecode(readfile(SAVE_FILE))
        elseif getgenv and getgenv().EclipseSavedColors then
            SavedColors = getgenv().EclipseSavedColors
        end
    end)
    if type(SavedColors) ~= "table" then SavedColors = {} end
    if type(SavedColors.Transp) ~= "table" then SavedColors.Transp = {} end

    local function GetSaved(name, fallback) return TableToColor(SavedColors[name], fallback) end

    local DEFAULTS = {
        SurvivorFill = Color3.fromRGB(0, 255, 0),
        SurvivorOutline = Color3.fromRGB(127, 255, 127),
        BeastFill = Color3.fromRGB(255, 0, 0),
        BeastOutline = Color3.fromRGB(255, 127, 127),
        ComputerFill = Color3.fromRGB(13, 105, 172),
        ComputerOutline = Color3.fromRGB(20, 165, 255),
        FreezepodFill = Color3.fromRGB(120, 200, 255),
        FreezepodOutline = Color3.fromRGB(160, 255, 255),
        DoorFill = Color3.fromRGB(0, 255, 0),
        DoorFillClose = Color3.fromRGB(255, 0, 0),
        DoorOutline = Color3.fromRGB(0, 0, 0),
        CharmsSurvivor = Color3.fromRGB(0, 255, 0),
        CharmsBeast = Color3.fromRGB(255, 0, 0),
    }
    local DEFAULT_TRANSP = {
        BeastFill = 0.5, SurvivorFill = 0.5, ComputerFill = 0.5, FreezepodFill = 0.5, DoorFill = 0.5,
        BeastOutline = 0, SurvivorOutline = 0, ComputerOutline = 0, FreezepodOutline = 0, DoorOutline = 0,
        CharmsSurvivor = 0.3, CharmsBeast = 0.3,
    }
    local function GetSavedTransp(name)
        local v = SavedColors.Transp[name]
        if type(v) == "number" then return math.clamp(v, 0, 1) end
        return DEFAULT_TRANSP[name] or 0.5
    end
    local HighlightTransp = {}
    for k, v in pairs(DEFAULT_TRANSP) do HighlightTransp[k] = GetSavedTransp(k) end

    local ESPColors = {
        CharmsSurvivor = GetSaved("CharmsSurvivor", DEFAULTS.CharmsSurvivor),
        CharmsBeast = GetSaved("CharmsBeast", DEFAULTS.CharmsBeast),
        SquareSurvivor = Color3.fromRGB(0, 255, 0),
        SquareBeast = Color3.fromRGB(255, 0, 0),
        LineSurvivor = Color3.fromRGB(0, 255, 0),
        LineBeast = Color3.fromRGB(255, 0, 0),
    }

    local estilos = {
        Player = {
            Fill = {FillTransparency = HighlightTransp.SurvivorFill, OutlineTransparency = HighlightTransp.SurvivorOutline, FillColor = GetSaved("SurvivorFill", DEFAULTS.SurvivorFill), OutlineColor = GetSaved("SurvivorOutline", DEFAULTS.SurvivorOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.SurvivorOutline, FillColor = GetSaved("SurvivorFill", DEFAULTS.SurvivorFill), OutlineColor = GetSaved("SurvivorOutline", DEFAULTS.SurvivorOutline)}
        },
        Beast = {
            Fill = {FillTransparency = HighlightTransp.BeastFill, OutlineTransparency = HighlightTransp.BeastOutline, FillColor = GetSaved("BeastFill", DEFAULTS.BeastFill), OutlineColor = GetSaved("BeastOutline", DEFAULTS.BeastOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.BeastOutline, FillColor = GetSaved("BeastFill", DEFAULTS.BeastFill), OutlineColor = GetSaved("BeastOutline", DEFAULTS.BeastOutline)}
        },
        ComputerBlue = {
            Fill = {FillTransparency = HighlightTransp.ComputerFill, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)}
        },
        ComputerRed = {
            Fill = {FillTransparency = HighlightTransp.ComputerFill, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)}
        },
        ComputerGreen = {
            Fill = {FillTransparency = HighlightTransp.ComputerFill, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.ComputerOutline, FillColor = GetSaved("ComputerFill", DEFAULTS.ComputerFill), OutlineColor = GetSaved("ComputerOutline", DEFAULTS.ComputerOutline)}
        },
        Capsule = {
            Fill = {FillTransparency = HighlightTransp.FreezepodFill, OutlineTransparency = HighlightTransp.FreezepodOutline, FillColor = GetSaved("FreezepodFill", DEFAULTS.FreezepodFill), OutlineColor = GetSaved("FreezepodOutline", DEFAULTS.FreezepodOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.FreezepodOutline, FillColor = GetSaved("FreezepodFill", DEFAULTS.FreezepodFill), OutlineColor = GetSaved("FreezepodOutline", DEFAULTS.FreezepodOutline)}
        },
        Exit = {
            Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(252, 255, 100), OutlineColor = Color3.fromRGB(255, 255, 160)},
            Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 255, 0), OutlineColor = Color3.fromRGB(255, 255, 0)}
        },
        DoorOpen = {
            Fill = {FillTransparency = HighlightTransp.DoorFill, OutlineTransparency = HighlightTransp.DoorOutline, FillColor = GetSaved("DoorFill", DEFAULTS.DoorFill), OutlineColor = GetSaved("DoorOutline", DEFAULTS.DoorOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.DoorOutline, FillColor = GetSaved("DoorFill", DEFAULTS.DoorFill), OutlineColor = GetSaved("DoorOutline", DEFAULTS.DoorOutline)}
        },
        DoorClose = {
            Fill = {FillTransparency = HighlightTransp.DoorFill, OutlineTransparency = HighlightTransp.DoorOutline, FillColor = GetSaved("DoorFill", DEFAULTS.DoorFillClose), OutlineColor = GetSaved("DoorOutline", DEFAULTS.DoorOutline)},
            Outline = {FillTransparency = 1, OutlineTransparency = HighlightTransp.DoorOutline, FillColor = GetSaved("DoorFill", DEFAULTS.DoorFillClose), OutlineColor = GetSaved("DoorOutline", DEFAULTS.DoorOutline)}
        }
    }

    local savePending = false
    local function SaveColors()
        if savePending then return end
        savePending = true
        task.delay(0.4, function()
            savePending = false
            local data = {
                SurvivorFill = ColorToTable(estilos.Player.Fill.FillColor),
                SurvivorOutline = ColorToTable(estilos.Player.Fill.OutlineColor),
                BeastFill = ColorToTable(estilos.Beast.Fill.FillColor),
                BeastOutline = ColorToTable(estilos.Beast.Fill.OutlineColor),
                ComputerFill = ColorToTable(estilos.ComputerBlue.Fill.FillColor),
                ComputerOutline = ColorToTable(estilos.ComputerBlue.Fill.OutlineColor),
                FreezepodFill = ColorToTable(estilos.Capsule.Fill.FillColor),
                FreezepodOutline = ColorToTable(estilos.Capsule.Fill.OutlineColor),
                DoorFill = ColorToTable(estilos.DoorOpen.Fill.FillColor),
                DoorOutline = ColorToTable(estilos.DoorOpen.Fill.OutlineColor),
                CharmsSurvivor = ColorToTable(ESPColors.CharmsSurvivor),
                CharmsBeast = ColorToTable(ESPColors.CharmsBeast),
                Transp = HighlightTransp,
            }
            SavedColors = data
            pcall(function()
                if getgenv then getgenv().EclipseSavedColors = data end
                if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(data)) end
            end)
        end)
    end

    local function ApplyTransp(key, val)
        HighlightTransp[key] = val
        if key == "BeastFill" then estilos.Beast.Fill.FillTransparency = val
        elseif key == "SurvivorFill" then estilos.Player.Fill.FillTransparency = val
        elseif key == "ComputerFill" then estilos.ComputerBlue.Fill.FillTransparency = val estilos.ComputerRed.Fill.FillTransparency = val estilos.ComputerGreen.Fill.FillTransparency = val
        elseif key == "FreezepodFill" then estilos.Capsule.Fill.FillTransparency = val
        elseif key == "DoorFill" then estilos.DoorOpen.Fill.FillTransparency = val estilos.DoorClose.Fill.FillTransparency = val
        elseif key == "BeastOutline" then estilos.Beast.Fill.OutlineTransparency = val estilos.Beast.Outline.OutlineTransparency = val
        elseif key == "SurvivorOutline" then estilos.Player.Fill.OutlineTransparency = val estilos.Player.Outline.OutlineTransparency = val
        elseif key == "ComputerOutline" then estilos.ComputerBlue.Fill.OutlineTransparency = val estilos.ComputerBlue.Outline.OutlineTransparency = val estilos.ComputerRed.Fill.OutlineTransparency = val estilos.ComputerRed.Outline.OutlineTransparency = val estilos.ComputerGreen.Fill.OutlineTransparency = val estilos.ComputerGreen.Outline.OutlineTransparency = val
        elseif key == "FreezepodOutline" then estilos.Capsule.Fill.OutlineTransparency = val estilos.Capsule.Outline.OutlineTransparency = val
        elseif key == "DoorOutline" then estilos.DoorOpen.Fill.OutlineTransparency = val estilos.DoorOpen.Outline.OutlineTransparency = val estilos.DoorClose.Fill.OutlineTransparency = val estilos.DoorClose.Outline.OutlineTransparency = val
        elseif key == "CharmsSurvivor" or key == "CharmsBeast" then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("BoxHandleAdornment") then
                    local beastBox = (d.Color3 == ESPColors.CharmsBeast)
                    if (key == "CharmsBeast" and beastBox) or (key == "CharmsSurvivor" and not beastBox) then
                        d.Transparency = val
                    end
                end
            end
        end
    end

    local function aplicarHighlight(obj, tipo)
        if not obj then return end
        local highlight = obj:FindFirstChild("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight", obj)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
        local estilo = estilos[tipo][HighlightMode]
        highlight.FillTransparency = estilo.FillTransparency
        highlight.OutlineTransparency = estilo.OutlineTransparency
        highlight.FillColor = estilo.FillColor
        highlight.OutlineColor = estilo.OutlineColor
    end

    local settingsPageH = pages["Highlights"]
    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    local columnsLayoutH = Instance.new("UIListLayout", columnsH)
    columnsLayoutH.FillDirection = Enum.FillDirection.Horizontal
    columnsLayoutH.Padding = UDim.new(0, 10)
    columnsLayoutH.SortOrder = Enum.SortOrder.LayoutOrder
    columnsLayoutH.HorizontalFlex = Enum.UIFlexAlignment.Fill
    columnsLayoutH.VerticalAlignment = Enum.VerticalAlignment.Top

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    leftColH.LayoutOrder = 1
    local leftLayoutH = Instance.new("UIListLayout", leftColH)
    leftLayoutH.FillDirection = Enum.FillDirection.Vertical
    leftLayoutH.Padding = UDim.new(0, 10)
    leftLayoutH.SortOrder = Enum.SortOrder.LayoutOrder

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    rightColH.LayoutOrder = 2
    local rightLayoutH = Instance.new("UIListLayout", rightColH)
    rightLayoutH.FillDirection = Enum.FillDirection.Vertical
    rightLayoutH.Padding = UDim.new(0, 10)
    rightLayoutH.SortOrder = Enum.SortOrder.LayoutOrder

    local box1H, content1H = CreateGroupbox(leftColH, "Objects Features")
    box1H.LayoutOrder = 1
    local computerHighlight = false
    local computerCache = {}
    CreateToggle(content1H, "Computer", false, function(state)
        computerHighlight = state
        if state and game.ReplicatedStorage:FindFirstChild("CurrentMap") and game.ReplicatedStorage.CurrentMap.Value then
            local map = game.ReplicatedStorage.CurrentMap.Value
            computerCache = {}
            for _, obj in ipairs(map:GetDescendants()) do
                if obj.Name == "ComputerTable" then table.insert(computerCache, obj) end
            end
            task.spawn(function()
                while computerHighlight do
                    task.wait(1)
                    for _, computer in ipairs(computerCache) do
                        if computer and computer:FindFirstChild("Screen") then
                            local c = computer.Screen.Color
                            if c.R >= c.G and c.R >= c.B then aplicarHighlight(computer, "ComputerRed")
                            elseif c.G >= c.R and c.G >= c.B then aplicarHighlight(computer, "ComputerGreen")
                            else aplicarHighlight(computer, "ComputerBlue") end
                        end
                    end
                end
                for _, computer in ipairs(computerCache) do
                    if computer and computer:FindFirstChild("Highlight") then computer.Highlight:Destroy() end
                end
            end)
        else
            for _, computer in ipairs(computerCache) do
                if computer and computer:FindFirstChild("Highlight") then computer.Highlight:Destroy() end
            end
            computerCache = {}
        end
    end)
    local capsuleHighlight = false
    local capsuleCache = {}
    CreateToggle(content1H, "Capsule", false, function(state)
        capsuleHighlight = state
        if state then
            capsuleCache = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "FreezePod" then table.insert(capsuleCache, obj) end
            end
            task.spawn(function()
                while capsuleHighlight do
                    task.wait(1)
                    for _, capsule in ipairs(capsuleCache) do
                        if capsule then aplicarHighlight(capsule, "Capsule") end
                    end
                end
                for _, capsule in ipairs(capsuleCache) do
                    if capsule and capsule:FindFirstChild("Highlight") then capsule.Highlight:Destroy() end
                end
                capsuleCache = {}
            end)
        else
            for _, capsule in ipairs(capsuleCache) do
                if capsule and capsule:FindFirstChild("Highlight") then capsule.Highlight:Destroy() end
            end
            capsuleCache = {}
        end
    end)
    local exitHighlight = false
    local exitCache = {}
    CreateToggle(content1H, "Exit", false, function(state)
        exitHighlight = state
        if state then
            exitCache = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name == "ExitDoor" then table.insert(exitCache, obj) end
            end
            task.spawn(function()
                while exitHighlight do
                    task.wait(1)
                    for _, exit in ipairs(exitCache) do
                        if exit then aplicarHighlight(exit, "Exit") end
                    end
                end
                for _, exit in ipairs(exitCache) do
                    if exit and exit:FindFirstChild("Highlight") then exit.Highlight:Destroy() end
                end
                exitCache = {}
            end)
        else
            for _, exit in ipairs(exitCache) do
                if exit and exit:FindFirstChild("Highlight") then exit.Highlight:Destroy() end
            end
            exitCache = {}
        end
    end)
    local doorHighlight = false
    local doorCache = {}
    CreateToggle(content1H, "Door", false, function(state)
        doorHighlight = state
        if state then
            doorCache = {}
            for _, door in ipairs(workspace:GetDescendants()) do
                if door.Name == "SingleDoor" or door.Name == "DoubleDoor" then table.insert(doorCache, door) end
            end
            task.spawn(function()
                while doorHighlight do
                    task.wait(0.5)
                    for _, door in ipairs(doorCache) do
                        if door and door.Parent and door:FindFirstChild("DoorTrigger") then
                            local action = door.DoorTrigger:FindFirstChild("ActionSign")
                            if action then
                                if action.Value == 11 then aplicarHighlight(door, "DoorOpen")
                                elseif action.Value == 10 then aplicarHighlight(door, "DoorClose") end
                            end
                        end
                    end
                end
                for _, door in ipairs(doorCache) do
                    local hl = door and door:FindFirstChildOfClass("Highlight")
                    if hl then hl:Destroy() end
                end
                doorCache = {}
            end)
        else
            for _, door in ipairs(doorCache) do
                local hl = door and door:FindFirstChildOfClass("Highlight")
                if hl then hl:Destroy() end
            end
            doorCache = {}
        end
    end)

    local box3H, content3H = CreateGroupbox(leftColH, "Settings Highlights")
    box3H.LayoutOrder = 2
    local chipHolder = Instance.new("Frame", content3H)
    chipHolder.Size = UDim2.new(1, 0, 0, 40)
    chipHolder.BackgroundTransparency = 1
    local layout = Instance.new("UIListLayout", chipHolder)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local chips = {}
    local function CreateChip(text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = chipHolder
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(90, 90, 90)
        stroke.Thickness = 1.2
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        local function setSelected(state)
            if state then
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(255, 255, 255), Thickness = 2}):Play()
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(90, 90, 90), Thickness = 1.2}):Play()
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        btn.MouseButton1Click:Connect(function()
            HighlightMode = text
            for _, chip in pairs(chips) do chip.setSelected(chip.name == HighlightMode) end
        end)
        chips[text] = {name = text, setSelected = setSelected}
        setSelected(text == HighlightMode)
    end
    CreateChip("Fill")
    CreateChip("Outline")

    local pickerSetters = {}
    local transpSetters = {}

    local function CreateResetButton(parent, text, order, onClick)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.LayoutOrder = order
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(180, 180, 180)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = parent
        btn.MouseEnter:Connect(function() btn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
        btn.MouseLeave:Connect(function() btn.TextColor3 = Color3.fromRGB(180, 180, 180) end)
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    local function CreateColorPicker(parent, name, defaultColor, onChange, order, transpKey)
        local parentLayout = parent:FindFirstChildOfClass("UIListLayout")
        if parentLayout then parentLayout.SortOrder = Enum.SortOrder.LayoutOrder end
        local h, s, v = defaultColor:ToHSV()
        local transpVal = transpKey and HighlightTransp[transpKey] or 0.5

        local holder = Instance.new("Frame")
        holder.Name = name .. "_Holder"
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.ClipsDescendants = false
        holder.LayoutOrder = order or 0
        holder.Active = true
        holder.Parent = parent
        local holderLayout = Instance.new("UIListLayout", holder)
        holderLayout.FillDirection = Enum.FillDirection.Vertical
        holderLayout.Padding = UDim.new(0, 6)
        holderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local row = Instance.new("Frame")
        row.Name = name
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(1, 0, 0, 28)
        row.LayoutOrder = 1
        row.Parent = holder
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = name
        label.Parent = row
        local preview = Instance.new("TextButton")
        preview.BackgroundColor3 = defaultColor
        preview.Size = UDim2.new(0, 26, 0, 22)
        preview.Position = UDim2.new(1, -26, 0, 3)
        preview.Text = ""
        preview.AutoButtonColor = false
        preview.Active = true
        preview.ZIndex = 5
        preview.Parent = row
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
        Instance.new("UIStroke", preview).Color = Color3.fromRGB(70, 70, 70)

        local picker = Instance.new("Frame")
        picker.Name = "Picker"
        picker.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        picker.Size = UDim2.new(1, 0, 0, 148)
        picker.Visible = false
        picker.LayoutOrder = 2
        picker.ZIndex = 5
        picker.Active = true
        picker.Parent = holder
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", picker).Color = Color3.fromRGB(70, 70, 70)

        local svBox = Instance.new("ImageButton")
        svBox.Name = "SVBox"
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svBox.Position = UDim2.new(0, 10, 0, 10)
        svBox.Size = UDim2.new(1, -42, 1, -58)
        svBox.AutoButtonColor = false
        svBox.Active = true
        svBox.ZIndex = 6
        svBox.Image = ""
        svBox.Parent = picker
        Instance.new("UICorner", svBox).CornerRadius = UDim.new(0, 6)
        local whiteOverlay = Instance.new("Frame")
        whiteOverlay.Name = "WhiteGradient"
        whiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
        whiteOverlay.BorderSizePixel = 0
        whiteOverlay.Size = UDim2.new(1, 0, 1, 0)
        whiteOverlay.ZIndex = 7
        whiteOverlay.Active = false
        whiteOverlay.Parent = svBox
        Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 6)
        local satGrad = Instance.new("UIGradient")
        satGrad.Rotation = 0
        satGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
        satGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        satGrad.Parent = whiteOverlay
        local valFrame = Instance.new("Frame")
        valFrame.Name = "BlackGradient"
        valFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        valFrame.BorderSizePixel = 0
        valFrame.Size = UDim2.new(1, 0, 1, 0)
        valFrame.ZIndex = 8
        valFrame.Active = false
        valFrame.Parent = svBox
        Instance.new("UICorner", valFrame).CornerRadius = UDim.new(0, 6)
        local valGrad = Instance.new("UIGradient")
        valGrad.Rotation = 90
        valGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
        valGrad.Parent = valFrame
        local svCursor = Instance.new("Frame")
        svCursor.Name = "SVCursor"
        svCursor.Size = UDim2.new(0, 14, 0, 14)
        svCursor.BackgroundTransparency = 1
        svCursor.ZIndex = 10
        svCursor.Active = false
        svCursor.Parent = svBox
        local svInner = Instance.new("Frame")
        svInner.Size = UDim2.new(1, -4, 1, -4)
        svInner.Position = UDim2.new(0, 2, 0, 2)
        svInner.BackgroundTransparency = 1
        svInner.ZIndex = 10
        svInner.Active = false
        svInner.Parent = svCursor
        Instance.new("UICorner", svInner).CornerRadius = UDim.new(1, 0)
        local svStroke = Instance.new("UIStroke", svInner)
        svStroke.Color = Color3.fromRGB(255, 255, 255)
        svStroke.Thickness = 2
        local hueBar = Instance.new("ImageButton")
        hueBar.Name = "HueBar"
        hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueBar.Position = UDim2.new(1, -22, 0, 10)
        hueBar.Size = UDim2.new(0, 12, 1, -58)
        hueBar.AutoButtonColor = false
        hueBar.Active = true
        hueBar.ZIndex = 6
        hueBar.Image = ""
        hueBar.Parent = picker
        Instance.new("UICorner", hueBar).CornerRadius = UDim.new(1, 0)
        local hueGrad = Instance.new("UIGradient")
        hueGrad.Rotation = 90
        hueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
        })
        hueGrad.Parent = hueBar
        local hueCursor = Instance.new("Frame")
        hueCursor.Name = "HueCursor"
        hueCursor.Size = UDim2.new(1, 6, 0, 6)
        hueCursor.Position = UDim2.new(0, -3, 0, 0)
        hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueCursor.BorderSizePixel = 0
        hueCursor.ZIndex = 10
        hueCursor.Active = false
        hueCursor.Parent = hueBar
        Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", hueCursor).Color = Color3.fromRGB(0, 0, 0)

        local transpLabel = Instance.new("TextLabel")
        transpLabel.Name = "TransparencyLabel"
        transpLabel.BackgroundTransparency = 1
        transpLabel.Position = UDim2.new(0, 10, 0, 118)
        transpLabel.Size = UDim2.new(1, -60, 0, 14)
        transpLabel.Font = Enum.Font.Gotham
        transpLabel.TextSize = 12
        transpLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        transpLabel.TextXAlignment = Enum.TextXAlignment.Left
        transpLabel.Text = "Transparency"
        transpLabel.Parent = picker
        local transpValLabel = Instance.new("TextLabel")
        transpValLabel.Name = "TransparencyValue"
        transpValLabel.BackgroundTransparency = 1
        transpValLabel.Position = UDim2.new(1, -50, 0, 118)
        transpValLabel.Size = UDim2.new(0, 40, 0, 14)
        transpValLabel.Font = Enum.Font.Gotham
        transpValLabel.TextSize = 12
        transpValLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        transpValLabel.TextXAlignment = Enum.TextXAlignment.Right
        transpValLabel.Text = string.format("%.2f", transpVal)
        transpValLabel.Parent = picker
        local transpTrack = Instance.new("TextButton")
        transpTrack.Name = "TranspTrack"
        transpTrack.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        transpTrack.Position = UDim2.new(0, 10, 0, 134)
        transpTrack.Size = UDim2.new(1, -20, 0, 6)
        transpTrack.Text = ""
        transpTrack.AutoButtonColor = false
        transpTrack.Active = true
        transpTrack.ZIndex = 6
        transpTrack.Parent = picker
        Instance.new("UICorner", transpTrack).CornerRadius = UDim.new(1, 0)
        local transpFill = Instance.new("Frame")
        transpFill.Name = "TranspFill"
        transpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        transpFill.BorderSizePixel = 0
        transpFill.Size = UDim2.new(transpVal, 0, 1, 0)
        transpFill.ZIndex = 7
        transpFill.Parent = transpTrack
        Instance.new("UICorner", transpFill).CornerRadius = UDim.new(1, 0)

        local function setTransp(val, fire)
            val = math.clamp(val, 0, 1)
            transpVal = val
            transpFill.Size = UDim2.new(val, 0, 1, 0)
            transpValLabel.Text = string.format("%.2f", val)
            if transpKey then
                HighlightTransp[transpKey] = val
                if fire ~= false then ApplyTransp(transpKey, val) end
            end
            if fire ~= false then SaveColors() end
        end
        if transpKey then transpSetters[transpKey] = function(v) setTransp(v, false) ApplyTransp(transpKey, v) end end

        local draggingTransp = false
        local dragInputTransp = nil
        local function updateTransp(input)
            local pos = transpTrack.AbsolutePosition
            local size = transpTrack.AbsoluteSize
            if size.X <= 0 then return end
            setTransp(math.clamp((input.Position.X - pos.X) / size.X, 0, 1))
        end
        transpTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingTransp = true
                dragInputTransp = input
                updateTransp(input)
            end
        end)
        transpTrack.InputEnded:Connect(function(input)
            if input == dragInputTransp then
                draggingTransp = false
                dragInputTransp = nil
            end
        end)

        local function updateVisual()
            h = h % 1
            s = math.clamp(s, 0, 1)
            v = math.clamp(v, 0, 1)
            local color = Color3.fromHSV(h, s, v)
            preview.BackgroundColor3 = color
            svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
            svCursor.Position = UDim2.new(s, -7, 1 - v, -7)
            hueCursor.Position = UDim2.new(0, -3, h, -3)
            if onChange then onChange(color) end
            SaveColors()
        end
        local function setColor(newColor)
            h, s, v = newColor:ToHSV()
            updateVisual()
        end
        pickerSetters[name] = setColor
        local draggingSV = false
        local draggingHue = false
        local dragInput = nil
        local function updateSV(input)
            local pos = svBox.AbsolutePosition
            local size = svBox.AbsoluteSize
            if size.X <= 0 or size.Y <= 0 then return end
            s = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
            v = 1 - math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
            updateVisual()
        end
        local function updateHue(input)
            local pos = hueBar.AbsolutePosition
            local size = hueBar.AbsoluteSize
            if size.Y <= 0 then return end
            h = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
            updateVisual()
        end
        svBox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true dragInput = input updateSV(input) end
        end)
        hueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true dragInput = input updateHue(input) end
        end)
        UIS.InputChanged:Connect(function(input)
            if draggingTransp and input == dragInputTransp then
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then updateTransp(input) end
                return
            end
            if not draggingSV and not draggingHue then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if draggingSV then updateSV(input) elseif draggingHue then updateHue(input) end
            elseif input.UserInputType == Enum.UserInputType.Touch and input == dragInput then
                if draggingSV then updateSV(input) elseif draggingHue then updateHue(input) end
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input == dragInputTransp then
                draggingTransp = false
                dragInputTransp = nil
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or (input.UserInputType == Enum.UserInputType.Touch and input == dragInput) then
                draggingSV = false
                draggingHue = false
                dragInput = nil
            end
        end)
        preview.MouseButton1Click:Connect(function()
            picker.Visible = not picker.Visible
            task.wait()
            holder.Size = UDim2.new(1, 0, 0, 0)
        end)
        updateVisual()
        return setColor
    end

    local boxOutlineH, contentOutlineH = CreateGroupbox(leftColH, "Outline Customization")
    boxOutlineH.LayoutOrder = 3
    CreateColorPicker(contentOutlineH, "Beast Outline", estilos.Beast.Fill.OutlineColor, function(c)
        estilos.Beast.Fill.OutlineColor = c
        estilos.Beast.Outline.OutlineColor = c
    end, 1, "BeastOutline")
    CreateColorPicker(contentOutlineH, "Survivor Outline", estilos.Player.Fill.OutlineColor, function(c)
        estilos.Player.Fill.OutlineColor = c
        estilos.Player.Outline.OutlineColor = c
    end, 2, "SurvivorOutline")
    CreateColorPicker(contentOutlineH, "Computer Outline", estilos.ComputerBlue.Fill.OutlineColor, function(c)
        estilos.ComputerBlue.Fill.OutlineColor = c
        estilos.ComputerRed.Fill.OutlineColor = c
        estilos.ComputerGreen.Fill.OutlineColor = c
        estilos.ComputerBlue.Outline.OutlineColor = c
        estilos.ComputerRed.Outline.OutlineColor = c
        estilos.ComputerGreen.Outline.OutlineColor = c
    end, 3, "ComputerOutline")
    CreateColorPicker(contentOutlineH, "Freezepod Outline", estilos.Capsule.Fill.OutlineColor, function(c)
        estilos.Capsule.Fill.OutlineColor = c
        estilos.Capsule.Outline.OutlineColor = c
    end, 4, "FreezepodOutline")
    CreateColorPicker(contentOutlineH, "Door Outline", estilos.DoorOpen.Fill.OutlineColor, function(c)
        estilos.DoorOpen.Fill.OutlineColor = c
        estilos.DoorOpen.Outline.OutlineColor = c
        estilos.DoorClose.Fill.OutlineColor = c
        estilos.DoorClose.Outline.OutlineColor = c
    end, 5, "DoorOutline")
    CreateResetButton(contentOutlineH, "Reset All Outline", 99, function()
        if pickerSetters["Beast Outline"] then pickerSetters["Beast Outline"](DEFAULTS.BeastOutline) end
        if pickerSetters["Survivor Outline"] then pickerSetters["Survivor Outline"](DEFAULTS.SurvivorOutline) end
        if pickerSetters["Computer Outline"] then pickerSetters["Computer Outline"](DEFAULTS.ComputerOutline) end
        if pickerSetters["Freezepod Outline"] then pickerSetters["Freezepod Outline"](DEFAULTS.FreezepodOutline) end
        if pickerSetters["Door Outline"] then pickerSetters["Door Outline"](DEFAULTS.DoorOutline) end
        if transpSetters["BeastOutline"] then transpSetters["BeastOutline"](DEFAULT_TRANSP.BeastOutline) end
        if transpSetters["SurvivorOutline"] then transpSetters["SurvivorOutline"](DEFAULT_TRANSP.SurvivorOutline) end
        if transpSetters["ComputerOutline"] then transpSetters["ComputerOutline"](DEFAULT_TRANSP.ComputerOutline) end
        if transpSetters["FreezepodOutline"] then transpSetters["FreezepodOutline"](DEFAULT_TRANSP.FreezepodOutline) end
        if transpSetters["DoorOutline"] then transpSetters["DoorOutline"](DEFAULT_TRANSP.DoorOutline) end
        SaveColors()
    end)

    local espGroup, espContent = CreateGroupbox(rightColH, "ESPs Features")
    espGroup.LayoutOrder = 1
    local playerHighlight = false
    local playerHighlightCache = {}
    local playerHighlightConnections = {}
    local playerNameCache = {}
    CreateToggle(espContent, "Highlights", false, function(state)
        playerHighlight = state
        if state then
            playerHighlightCache = {}
            playerHighlightConnections = {}
            local function addPlayerESP(plr)
                if plr == game.Players.LocalPlayer then return end
                table.insert(playerHighlightCache, plr)
            end
            local function removePlayerESP(plr)
                for i, v in ipairs(playerHighlightCache) do if v == plr then table.remove(playerHighlightCache, i) break end end
                if plr.Character then
                    if plr.Character:FindFirstChild("Highlight") then plr.Character.Highlight:Destroy() end
                    local bb = playerNameCache[plr.Character]
                    if bb then pcall(function() bb:Destroy() end) playerNameCache[plr.Character] = nil end
                end
            end
            local function applyNameESP(plr, character, color)
                if not character then return end
                local head = character:FindFirstChild("Head")
                if not head then return end
                local existing = playerNameCache[character]
                if existing then pcall(function() existing.TextLabel.TextColor3 = color existing.TextLabel.Text = plr.Name end) return end
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "NameESP"
                billboard.Adornee = head
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 100, 0, 25)
                billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextSize = 12
                text.Font = Enum.Font.SourceSansBold
                text.Text = plr.Name
                text.TextColor3 = color
                text.Parent = billboard
                billboard.Parent = head
                playerNameCache[character] = billboard
            end
            for _, plr in ipairs(game.Players:GetPlayers()) do addPlayerESP(plr) end
            table.insert(playerHighlightConnections, game.Players.PlayerAdded:Connect(function(plr) if playerHighlight then addPlayerESP(plr) end end))
            table.insert(playerHighlightConnections, game.Players.PlayerRemoving:Connect(removePlayerESP))
            task.spawn(function()
                while playerHighlight do
                    task.wait(1)
                    for _, plr in ipairs(playerHighlightCache) do
                        if plr.Character then
                            local tipo = (getBeast and plr == getBeast()) and "Beast" or "Player"
                            aplicarHighlight(plr.Character, tipo)
                            local hl = plr.Character:FindFirstChildOfClass("Highlight")
                            if hl then applyNameESP(plr, plr.Character, hl.FillColor) end
                        end
                    end
                end
                for _, plr in ipairs(playerHighlightCache) do removePlayerESP(plr) end
                for _, c in ipairs(playerHighlightConnections) do c:Disconnect() end
                playerHighlightCache, playerHighlightConnections, playerNameCache = {}, {}, {}
            end)
        else
            for _, c in ipairs(playerHighlightConnections) do c:Disconnect() end
            for _, plr in ipairs(playerHighlightCache) do
                if plr.Character then
                    if plr.Character:FindFirstChild("Highlight") then plr.Character.Highlight:Destroy() end
                    local bb = playerNameCache[plr.Character]
                    if bb then pcall(function() bb:Destroy() end) end
                end
            end
            playerHighlightCache, playerHighlightConnections, playerNameCache = {}, {}, {}
        end
    end)

    local playerBox = false
    local playerBoxCache = {}
    local playerBoxConnections = {}
    CreateToggle(espContent, "Charms", false, function(state)
        playerBox = state
        local LocalPlayer = Players.LocalPlayer
        local function isBoxPart(part)
            if not part:IsA("BasePart") then return false end
            if part.Name == "HumanoidRootPart" then return false end
            if part:FindFirstAncestorOfClass("Accessory") then return false end
            local model = part:FindFirstAncestorOfClass("Model")
            if not model then return false end
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then return false end
            return part.Name == "Head" or part.Name == "Torso" or part.Name == "Left Arm" or part.Name == "Right Arm" or part.Name == "Left Leg" or part.Name == "Right Leg"
        end
        local function clearESP(character)
            local list = playerBoxCache[character]
            if list then for _, obj in ipairs(list) do pcall(function() obj:Destroy() end) end playerBoxCache[character] = nil end
        end
        local function applyBoxESP(plr, character, color)
            if not character then return end
            local isBeast = getBeast and plr == getBeast()
            local transp = isBeast and HighlightTransp.CharmsBeast or HighlightTransp.CharmsSurvivor
            local cached = playerBoxCache[character]
            if cached then for _, obj in ipairs(cached) do pcall(function() if obj:IsA("BoxHandleAdornment") then obj.Color3 = color obj.Transparency = transp end end) end return end
            playerBoxCache[character] = {}
            local list = playerBoxCache[character]
            for _, part in ipairs(character:GetDescendants()) do
                if isBoxPart(part) then
                    pcall(function()
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = part box.AlwaysOnTop = true box.ZIndex = 10 box.Size = part.Size box.Transparency = transp box.Color3 = color box.Parent = part
                        table.insert(list, box)
                    end)
                end
            end
        end
        if state then
            local playerList = Players:GetPlayers()
            playerBoxConnections.loop = task.spawn(function()
                while playerBox do
                    task.wait(1)
                    for _, plr in ipairs(playerList) do
                        if plr ~= LocalPlayer and plr.Character then
                            local color = (getBeast and plr == getBeast()) and ESPColors.CharmsBeast or ESPColors.CharmsSurvivor
                            pcall(function() applyBoxESP(plr, plr.Character, color) end)
                        end
                    end
                end
            end)
            playerBoxConnections.added = Players.PlayerAdded:Connect(function(plr) table.insert(playerList, plr) end)
            playerBoxConnections.removing = Players.PlayerRemoving:Connect(function(plr)
                if plr.Character then pcall(function() clearESP(plr.Character) end) end
                for i, v in ipairs(playerList) do if v == plr then table.remove(playerList, i) break end end
            end)
        else
            for char, list in pairs(playerBoxCache) do for _, obj in ipairs(list) do pcall(function() obj:Destroy() end) end playerBoxCache[char] = nil end
            if playerBoxConnections.loop then task.cancel(playerBoxConnections.loop) playerBoxConnections.loop = nil end
            if playerBoxConnections.added then playerBoxConnections.added:Disconnect() playerBoxConnections.added = nil end
            if playerBoxConnections.removing then playerBoxConnections.removing:Disconnect() playerBoxConnections.removing = nil end
        end
    end)

    local playerSquare = false
    local playerSquareCache = {}
    local playerSquareConnections = {}
    CreateToggle(espContent, "Square", false, function(state)
        playerSquare = state
        local lplr = Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local function clearSquare(plr)
            if playerSquareCache[plr] then
                pcall(function() playerSquareCache[plr]:Remove() end)
                playerSquareCache[plr] = nil
            end
        end
        local function createSquare(plr)
            if plr == lplr then return end
            if playerSquareCache[plr] then pcall(function() playerSquareCache[plr]:Remove() end) end
            local sq = Drawing.new("Square") sq.Visible = false sq.Color = Color3.new(0, 255, 0) sq.Thickness = 1 sq.Transparency = 1 sq.Filled = false
            playerSquareCache[plr] = sq
        end
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do createSquare(plr) end
            playerSquareConnections.added = Players.PlayerAdded:Connect(createSquare)
            playerSquareConnections.removing = Players.PlayerRemoving:Connect(function(plr) clearSquare(plr) end)
            local acc = 0
            playerSquareConnections.loop = RunService.RenderStepped:Connect(function(dt)
                acc += dt
                if acc < 0.05 then return end
                acc = 0
                local beast = getBeast()
                for _, plr in ipairs(Players:GetPlayers()) do
                    local sq = playerSquareCache[plr]
                    if sq and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                        local rp = plr.Character.HumanoidRootPart
                        local RootPos, RootVis = camera:WorldToViewportPoint(rp.Position)
                        local HeadPos = camera:WorldToViewportPoint(rp.Position + Vector3.new(0, 0.5, 0))
                        local LegPos = camera:WorldToViewportPoint(rp.Position - Vector3.new(0, 3, 0))
                        if RootVis then
                            local size = Vector2.new(1000 / RootPos.Z, HeadPos.Y - LegPos.Y)
                            sq.Size = size
                            sq.Position = Vector2.new(RootPos.X - size.X / 2, RootPos.Y - size.Y / 2)
                            sq.Color = (beast and plr == beast) and ESPColors.SquareBeast or ESPColors.SquareSurvivor
                            sq.Visible = true
                        else sq.Visible = false end
                    elseif sq then sq.Visible = false end
                end
            end)
        else
            for plr, sq in pairs(playerSquareCache) do pcall(function() sq:Remove() end) playerSquareCache[plr] = nil end
            if playerSquareConnections.loop then playerSquareConnections.loop:Disconnect() playerSquareConnections.loop = nil end
            if playerSquareConnections.added then playerSquareConnections.added:Disconnect() playerSquareConnections.added = nil end
            if playerSquareConnections.removing then playerSquareConnections.removing:Disconnect() playerSquareConnections.removing = nil end
        end
    end)

    local playerLine = false
    local playerLineCache = {}
    local playerLineConnections = {}
    CreateToggle(espContent, "Trace Line", false, function(state)
        playerLine = state
        local lplr = Players.LocalPlayer
        local camera = workspace.CurrentCamera
        local function clearLine(plr)
            if playerLineCache[plr] then
                pcall(function() playerLineCache[plr]:Remove() end)
                playerLineCache[plr] = nil
            end
        end
        local function createLine(plr)
            if plr == lplr then return end
            if playerLineCache[plr] then pcall(function() playerLineCache[plr]:Remove() end) end
            local ln = Drawing.new("Line") ln.Visible = false ln.Color = Color3.new(0, 255, 0) ln.Thickness = 1 ln.Transparency = 1
            playerLineCache[plr] = ln
        end
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do createLine(plr) end
            playerLineConnections.added = Players.PlayerAdded:Connect(createLine)
            playerLineConnections.removing = Players.PlayerRemoving:Connect(function(plr) clearLine(plr) end)
            local acc = 0
            playerLineConnections.loop = RunService.RenderStepped:Connect(function(dt)
                acc += dt
                if acc < 0.05 then return end
                acc = 0
                local beast = getBeast()
                for _, plr in ipairs(Players:GetPlayers()) do
                    local ln = playerLineCache[plr]
                    if ln and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                        local vec, onScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                        if onScreen then
                            ln.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                            ln.To = Vector2.new(vec.X, vec.Y)
                            ln.Color = (beast and plr == beast) and ESPColors.LineBeast or ESPColors.LineSurvivor
                            ln.Visible = true
                        else ln.Visible = false end
                    elseif ln then ln.Visible = false end
                end
            end)
        else
            for plr, ln in pairs(playerLineCache) do pcall(function() ln:Remove() end) playerLineCache[plr] = nil end
            if playerLineConnections.loop then playerLineConnections.loop:Disconnect() playerLineConnections.loop = nil end
            if playerLineConnections.added then playerLineConnections.added:Disconnect() playerLineConnections.added = nil end
            if playerLineConnections.removing then playerLineConnections.removing:Disconnect() playerLineConnections.removing = nil end
        end
    end)

    local beastConnections = {}
    local beastIlluminationEnabled = false
    local function clearGlow(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if head then local g = head:FindFirstChild("BeastGlow") if g then g:Destroy() end end
    end
    local function applyGlow(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local function update()
            local bp = char:FindFirstChild("BeastPowers")
            local glow = head:FindFirstChild("BeastGlow")
            if bp then
                if not glow then glow = Instance.new("PointLight") glow.Name = "BeastGlow" glow.Color = Color3.fromRGB(0, 255, 255) glow.Brightness = 8 glow.Range = 25 glow.Parent = head end
            else if glow then glow:Destroy() end end
        end
        update()
        table.insert(beastConnections, char.ChildAdded:Connect(update))
        table.insert(beastConnections, char.ChildRemoved:Connect(update))
    end
    CreateToggle(espContent, "Beast GlowUp", false, function(enabled)
        beastIlluminationEnabled = enabled
        for _, c in ipairs(beastConnections) do c:Disconnect() end
        beastConnections = {}
        if not enabled then for _, plr in ipairs(Players:GetPlayers()) do if plr.Character then clearGlow(plr.Character) end end return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then applyGlow(plr.Character) end
            table.insert(beastConnections, plr.CharacterAdded:Connect(function(char) if beastIlluminationEnabled then applyGlow(char) end end))
        end
    end)

    local boxFillH, contentFillH = CreateGroupbox(rightColH, "Color Customization")
    boxFillH.LayoutOrder = 2
    CreateColorPicker(contentFillH, "Beast Fill Color", estilos.Beast.Fill.FillColor, function(c)
        estilos.Beast.Fill.FillColor = c
        estilos.Beast.Outline.FillColor = c
    end, 1, "BeastFill")
    CreateColorPicker(contentFillH, "Survivor Fill Color", estilos.Player.Fill.FillColor, function(c)
        estilos.Player.Fill.FillColor = c
        estilos.Player.Outline.FillColor = c
    end, 2, "SurvivorFill")
    CreateColorPicker(contentFillH, "Freezepod Fill Color", estilos.Capsule.Fill.FillColor, function(c)
        estilos.Capsule.Fill.FillColor = c
        estilos.Capsule.Outline.FillColor = c
    end, 3, "FreezepodFill")
    CreateColorPicker(contentFillH, "Computer Fill Color", estilos.ComputerBlue.Fill.FillColor, function(c)
        estilos.ComputerBlue.Fill.FillColor = c
        estilos.ComputerRed.Fill.FillColor = c
        estilos.ComputerGreen.Fill.FillColor = c
    end, 4, "ComputerFill")
    CreateColorPicker(contentFillH, "Door Fill Color", estilos.DoorOpen.Fill.FillColor, function(c)
        estilos.DoorOpen.Fill.FillColor = c
        estilos.DoorClose.Fill.FillColor = c
    end, 5, "DoorFill")
    CreateColorPicker(contentFillH, "Charms Survivor", ESPColors.CharmsSurvivor, function(c) ESPColors.CharmsSurvivor = c end, 6, "CharmsSurvivor")
    CreateColorPicker(contentFillH, "Charms Beast", ESPColors.CharmsBeast, function(c) ESPColors.CharmsBeast = c end, 7, "CharmsBeast")
    CreateResetButton(contentFillH, "Reset All Fill", 99, function()
        if pickerSetters["Beast Fill Color"] then pickerSetters["Beast Fill Color"](DEFAULTS.BeastFill) end
        if pickerSetters["Survivor Fill Color"] then pickerSetters["Survivor Fill Color"](DEFAULTS.SurvivorFill) end
        if pickerSetters["Freezepod Fill Color"] then pickerSetters["Freezepod Fill Color"](DEFAULTS.FreezepodFill) end
        if pickerSetters["Computer Fill Color"] then pickerSetters["Computer Fill Color"](DEFAULTS.ComputerFill) end
        if pickerSetters["Door Fill Color"] then pickerSetters["Door Fill Color"](DEFAULTS.DoorFill) end
        if pickerSetters["Charms Survivor"] then pickerSetters["Charms Survivor"](DEFAULTS.CharmsSurvivor) end
        if pickerSetters["Charms Beast"] then pickerSetters["Charms Beast"](DEFAULTS.CharmsBeast) end
        if transpSetters["BeastFill"] then transpSetters["BeastFill"](DEFAULT_TRANSP.BeastFill) end
        if transpSetters["SurvivorFill"] then transpSetters["SurvivorFill"](DEFAULT_TRANSP.SurvivorFill) end
        if transpSetters["FreezepodFill"] then transpSetters["FreezepodFill"](DEFAULT_TRANSP.FreezepodFill) end
        if transpSetters["ComputerFill"] then transpSetters["ComputerFill"](DEFAULT_TRANSP.ComputerFill) end
        if transpSetters["DoorFill"] then transpSetters["DoorFill"](DEFAULT_TRANSP.DoorFill) end
        if transpSetters["CharmsSurvivor"] then transpSetters["CharmsSurvivor"](DEFAULT_TRANSP.CharmsSurvivor) end
        if transpSetters["CharmsBeast"] then transpSetters["CharmsBeast"](DEFAULT_TRANSP.CharmsBeast) end
        estilos.DoorClose.Fill.FillColor = DEFAULTS.DoorFillClose
        estilos.DoorClose.Outline.FillColor = DEFAULTS.DoorFillClose
        SaveColors()
    end)
end

do
    local settingsPageP = pages["Visual"]
    local TweenService = game:GetService("TweenService")
    local UIS = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera

    local columnsP = Instance.new("Frame", settingsPageP)
    columnsP.Size = UDim2.new(1, 0, 0, 0)
    columnsP.AutomaticSize = Enum.AutomaticSize.Y
    columnsP.BackgroundTransparency = 1

    local leftColP = Instance.new("Frame", columnsP)
    leftColP.Size = UDim2.new(0.5, -15, 0, 0)
    leftColP.AutomaticSize = Enum.AutomaticSize.Y
    leftColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColP).Padding = UDim.new(0, 10)

    local rightColP = Instance.new("Frame", columnsP)
    rightColP.Size = UDim2.new(0.5, -12, 0, 0)
    rightColP.Position = UDim2.new(0.5, 1, 0, 0)
    rightColP.AutomaticSize = Enum.AutomaticSize.Y
    rightColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColP).Padding = UDim.new(0, 10)

    local function MakeDivider(parent)
        local line = Instance.new("Frame", parent)
        line.Size = UDim2.new(1, 0, 0, 1)
        line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
    end

    do
        local p = Players.LocalPlayer
        local data = {
            on = false,
            name = "MaybeKayque",
            level = 100,
            icon = "",
            n = nil, l = nil, i = nil,
            orig = {}
        }

        local icons = {
            VIP = "rbxassetid://1188562340",
            QA = "rbxassetid://18940008283",
            CON = "rbxassetid://18940005647",
            Casey = "rbxassetid://131476591459702",
            DEV = "rbxassetid://18940006678",
            MrWindy = "rbxassetid://18937953345",
            MOD = "rbxassetid://105155010224102"
        }

        local function setup()
            local success, frame = pcall(function()
                return p.PlayerGui:WaitForChild("ScreenGui").PlayerNamesFrame:WaitForChild(p.Name.. "PlayerFrame")
            end)
            if not success or not frame then return end

            data.n = frame.NameLabel
            data.l = frame.LevelLabel
            for _, v in ipairs(frame:GetDescendants()) do
                if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                    data.i = v
                    data.i.BackgroundTransparency = 1
                    break
                end
            end

            data.orig.n = data.n.Text
            data.orig.l = data.l.Text
            data.orig.i = data.i and data.i.Image
        end

        local function apply()
            if not data.n then setup() end
            if not data.n then return end

            if data.on then
                data.n.Text = data.name
                data.l.Text = tostring(data.level)
                if data.i and data.icon ~= "" then
                    data.i.Image = data.icon
                    data.i.BackgroundTransparency = 1
                end
            else
                data.n.Text = data.orig.n
                data.l.Text = data.orig.l
                if data.i and data.orig.i then data.i.Image = data.orig.i end
            end
        end

        RunService.RenderStepped:Connect(function()
            if data.on and data.n then
                data.n.Text = data.name
                data.l.Text = tostring(data.level)
                if data.i and data.icon ~= "" then
                    data.i.Image = data.icon
                    data.i.BackgroundTransparency = 1
                end
            end
        end)

        task.spawn(setup)

        local boxNick, contentNick = CreateGroupbox(leftColP, "Player Spoof")
        boxNick.BackgroundColor3 = Color3.fromRGB(45,45,45)
        boxNick.BackgroundTransparency = 1
        boxNick.ClipsDescendants = false
        local corner = boxNick:FindFirstChildOfClass("UICorner")
        if corner then corner.CornerRadius = UDim.new(0,12) end
        local stroke = boxNick:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", boxNick)
        stroke.Color = Color3.fromRGB(80,80,80)
        stroke.Transparency = 0.55
        stroke.Thickness = 1

        CreateToggle(contentNick, "Hide Username", false, function(state)
            data.on = state
            apply()
        end)

        MakeDivider(contentNick)

        local function CreateInput(text, default, callback)
            local holder = Instance.new("Frame", contentNick)
            holder.Size = UDim2.new(1, 0, 0, 48)
            holder.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextColor3 = Color3.fromRGB(220,220,220)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local box = Instance.new("TextBox", holder)
            box.Size = UDim2.new(1, 0, 0, 26)
            box.Position = UDim2.new(0, 0, 0, 20)
            box.BackgroundColor3 = Color3.fromRGB(55,55,55)
            box.BackgroundTransparency = 0.65
            box.TextColor3 = Color3.fromRGB(220,220,220)
            box.Font = Enum.Font.Gotham
            box.TextSize = 13
            box.Text = default
            box.TextXAlignment = Enum.TextXAlignment.Center
            box.ClearTextOnFocus = false
            Instance.new("UICorner", box).CornerRadius = UDim.new(0,12)
            local boxStroke = Instance.new("UIStroke", box)
            boxStroke.Color = Color3.fromRGB(120,120,120)
            boxStroke.Transparency = 0.7
            boxStroke.Thickness = 1

            box.FocusLost:Connect(function(enter)
                if enter then callback(box.Text) end
            end)
        end

        CreateInput("Username", "MaybeKayque", function(v)
            data.name = v
            if data.on then apply() end
        end)

        MakeDivider(contentNick)

        CreateInput("Level", "100", function(v)
            data.level = tonumber(v) or 100
            if data.on then apply() end
        end)

        MakeDivider(contentNick)

        do
            local holder = Instance.new("Frame", contentNick)
            holder.Size = UDim2.new(1, 0, 0, 48)
            holder.BackgroundTransparency = 1
            holder.ClipsDescendants = false
            holder.ZIndex = 5

            local label = Instance.new("TextLabel", holder)
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Text = "Icon"
            label.Font = Enum.Font.GothamBold
            label.TextSize = 13
            label.TextColor3 = Color3.fromRGB(220,220,220)
            label.TextXAlignment = Enum.TextXAlignment.Left

            local btn = Instance.new("TextButton", holder)
            btn.Size = UDim2.new(1, 0, 0, 26)
            btn.Position = UDim2.new(0, 0, 0, 20)
            btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
            btn.BackgroundTransparency = 0.65
            btn.TextColor3 = Color3.fromRGB(220,220,220)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 13
            btn.Text = " None"
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.ZIndex = 5
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
            Instance.new("UIStroke", btn).Color = Color3.fromRGB(80,80,80)

            local arrow = Instance.new("TextLabel", btn)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.Font = Enum.Font.GothamBold
            arrow.TextSize = 12
            arrow.TextColor3 = Color3.fromRGB(180,180,180)

            local frame = Instance.new("ScrollingFrame", boxNick)
            frame.Size = UDim2.new(1, -20, 0, 0)
            frame.Position = UDim2.new(0, 10, 0, holder.AbsolutePosition.Y - boxNick.AbsolutePosition.Y + 48)
            frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
            frame.BorderSizePixel = 0
            frame.ScrollBarThickness = 4
            frame.Visible = false
            frame.ZIndex = 20
            frame.ClipsDescendants = true
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)
            Instance.new("UIStroke", frame).Color = Color3.fromRGB(80,80,80)

            local list = Instance.new("UIListLayout", frame)
            list.Padding = UDim.new(0, 2)

            local iconList = {"None","VIP","QA","CON","Casey","DEV","MrWindy","MOD"}
            local open = false

            for _, iconName in ipairs(iconList) do
                local opt = Instance.new("TextButton", frame)
                opt.Size = UDim2.new(1, -8, 0, 26)
                opt.BackgroundColor3 = Color3.fromRGB(6,6,6)
                opt.BackgroundTransparency = 0.65
                opt.TextColor3 = Color3.fromRGB(220,220,220)
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 13
                opt.Text = " ".. iconName
                opt.TextXAlignment = Enum.TextXAlignment.Left
                opt.ZIndex = 21
                Instance.new("UICorner", opt).CornerRadius = UDim.new(0,6)

                opt.MouseButton1Click:Connect(function()
                    btn.Text = " ".. iconName
                    data.icon = (iconName == "None" and "" or icons[iconName])
                    if data.on then apply() end
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(0.2)
                    frame.Visible = false
                    open = false
                end)
            end

            btn.MouseButton1Click:Connect(function()
                open = not open
                if open then
                    frame.Visible = true
                    frame.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 4)
                    frame.Position = UDim2.new(0, 10, 0, holder.AbsolutePosition.Y - boxNick.AbsolutePosition.Y + 48)
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -20, 0, 120)}):Play()
                else
                    TweenService:Create(arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, -20, 0, 0)}):Play()
                    task.wait(0.2)
                    frame.Visible = false
                end
            end)
        end
    end

local icons = {
    ["Default"] = "",
    Casey = "rbxassetid://131476591459702",
    VIP = "rbxassetid://1188562340",
    QA = "rbxassetid://18940008283",
    CON = "rbxassetid://18940005647",
    DEV = "rbxassetid://18940006678",
    MrWindy = "rbxassetid://18937953345",
    MOD = "rbxassetid://105155010224102"
}

do
    local boxTarget, contentTarget = CreateGroupbox(leftColP, "Target Nick")
    boxTarget.BackgroundTransparency = 1

    local scroll = Instance.new("ScrollingFrame", contentTarget)
    scroll.Size = UDim2.new(1, 0, 0, 320)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ClipsDescendants = true
    Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 8)

    local targetData = {}
    local playerCards = {}

    local function EnsureIconFrame(parent)
        local iconFrame = parent:FindFirstChild("IconFrame")
        if not iconFrame then
            iconFrame = Instance.new("Frame", parent)
            iconFrame.Name = "IconFrame"
            iconFrame.Size = UDim2.new(0, 20, 0, 20)
            iconFrame.Position = UDim2.new(0, 0, 0.5, -10)
            iconFrame.BackgroundTransparency = 1
            iconFrame.LayoutOrder = -1
            iconFrame.ZIndex = 5
        end
        return iconFrame
    end

    local function SetIcon(parent, iconId)
        local iconFrame = EnsureIconFrame(parent)
        iconFrame:ClearAllChildren()
        if iconId and iconId ~= "" then
            local iconImg = Instance.new("ImageLabel", iconFrame)
            iconImg.Size = UDim2.new(1, 0, 1, 0)
            iconImg.Image = iconId
            iconImg.BackgroundTransparency = 1
            iconImg.ZIndex = 6
        end
    end

    local function ResetPlayerVisuals(plr, origName, origLevel)
        local plrGui = Players.LocalPlayer:FindFirstChild("PlayerGui")
        if not plrGui then return end
        local screenGui = plrGui:FindFirstChild("ScreenGui")
        if not screenGui then return end

        local topBar = screenGui:FindFirstChild("PlayerNamesFrame")
        if topBar then
            for _, frame in ipairs(topBar:GetChildren()) do
                if frame.Name == plr.Name.. "PlayerFrame" then
                    if frame:FindFirstChild("NameLabel") then frame.NameLabel.Text = origName end
                    if frame:FindFirstChild("LevelLabel") then frame.LevelLabel.Text = tostring(origLevel) end
                    if frame:FindFirstChild("IconFrame") then frame.IconFrame:Destroy() end
                end
            end
        end

        local lb = screenGui:FindFirstChild("LeaderboardFrame")
        if lb then
            for _, entry in ipairs(lb:GetChildren()) do
                if entry:IsA("Frame") and entry:FindFirstChild("NameLabel") then
                    if entry.NameLabel.Text:find(plr.Name) or entry.NameLabel.Text:find(origName) then
                        entry.NameLabel.Text = origName
                        if entry:FindFirstChild("LevelLabel") then entry.LevelLabel.Text = tostring(origLevel) end
                        if entry:FindFirstChild("IconFrame") then entry.IconFrame:Destroy() end
                    end
                end
            end
        end
    end

    local function ForceUpdate()
        local plrGui = Players.LocalPlayer:WaitForChild("PlayerGui")
        local screenGui = plrGui:FindFirstChild("ScreenGui")
        if not screenGui then return end

        local topBar = screenGui:FindFirstChild("PlayerNamesFrame")
        local lb = screenGui:FindFirstChild("LeaderboardFrame")

        for userId, data in pairs(targetData) do
            local plr = Players:GetPlayerByUserId(userId)
            if not plr then continue end
            if not data.on then continue end

            local displayName = data.name ~= "" and data.name or data.origName
            local displayLevel = data.level ~= "" and data.level or data.origLevel
            local iconToUse = data.icon ~= "Nenhum" and icons[data.icon] or nil

            if topBar then
                for _, frame in ipairs(topBar:GetChildren()) do
                    if frame.Name == plr.Name.. "PlayerFrame" then
                        if frame:FindFirstChild("NameLabel") then frame.NameLabel.Text = displayName end
                        if frame:FindFirstChild("LevelLabel") then frame.LevelLabel.Text = tostring(displayLevel) end
                        SetIcon(frame, iconToUse)
                    end
                end
            end

            if lb then
                for _, entry in ipairs(lb:GetChildren()) do
                    if entry:IsA("Frame") and entry:FindFirstChild("NameLabel") then
                        local entryName = entry.NameLabel.Text:match("^(%S+)")
                        if entryName == plr.Name or entryName == data.origName then
                            entry.NameLabel.Text = displayName
                            if entry:FindFirstChild("LevelLabel") then entry.LevelLabel.Text = tostring(displayLevel) end
                            SetIcon(entry, iconToUse)
                        end
                    end
                end
            end
        end
    end
    RunService.RenderStepped:Connect(ForceUpdate)

    local function DestroyPlayerCard(userId)
        if playerCards[userId] then
            playerCards[userId]:Destroy()
            playerCards[userId] = nil
        end
        targetData[userId] = nil
    end

    local function CreatePlayerCard(targetPlayer)
        if targetData[targetPlayer.UserId] then return end

        local card = Instance.new("Frame", scroll)
        card.Name = targetPlayer.Name
        card.Size = UDim2.new(1, -4, 0, 155)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ClipsDescendants = true
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)
        Instance.new("UIStroke", card).Color = Color3.fromRGB(80,80,80)

        playerCards[targetPlayer.UserId] = card
        targetData[targetPlayer.UserId] = {on = false, name = "", level = "", icon = "Default", origName = targetPlayer.Name, origLevel = "1"}

        local header = Instance.new("Frame", card)
        header.Size = UDim2.new(1, -10, 0, 26)
        header.Position = UDim2.new(0, 10, 0, 8)
        header.BackgroundTransparency = 1

        local avatar = Instance.new("ImageLabel", header)
        avatar.Size = UDim2.new(0, 26, 0, 26)
        avatar.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(0,6)

        local nameLabel = Instance.new("TextLabel", header)
        nameLabel.Size = UDim2.new(1, -80, 1, 0)
        nameLabel.Position = UDim2.new(0, 32, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = targetPlayer.Name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextColor3 = Color3.fromRGB(220,220,220)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd

        CreateToggle(header, "", false, function(state)
            local data = targetData[targetPlayer.UserId]
            if not data then return end
            data.on = state
            pcall(function()
                if state then
                    ReplicatedStorage.SetPlayerNickname:FireServer(targetPlayer.UserId, data.name, data.level)
                else
                    ReplicatedStorage.SetPlayerNickname:FireServer(targetPlayer.UserId, data.origName, data.origLevel)
                    ResetPlayerVisuals(targetPlayer, data.origName, data.origLevel)
                end
            end)
        end)

        local nickLabel = Instance.new("TextLabel", card)
        nickLabel.Size = UDim2.new(1, -20, 0, 14)
        nickLabel.Position = UDim2.new(0, 10, 0, 36)
        nickLabel.BackgroundTransparency = 1
        nickLabel.Text = "Nick"
        nickLabel.TextColor3 = Color3.fromRGB(180,180,180)
        nickLabel.Font = Enum.Font.Gotham
        nickLabel.TextSize = 11
        nickLabel.TextXAlignment = Enum.TextXAlignment.Left

        local nickBox = Instance.new("TextBox", card)
        nickBox.Size = UDim2.new(1, -20, 0, 24)
        nickBox.Position = UDim2.new(0, 10, 0, 50)
        nickBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
        nickBox.BackgroundTransparency = 0.3
        nickBox.PlaceholderText = "Nick"
        nickBox.Text = ""
        nickBox.TextColor3 = Color3.fromRGB(220,220,220)
        nickBox.Font = Enum.Font.GothamBold
        nickBox.TextSize = 13
        nickBox.TextXAlignment = Enum.TextXAlignment.Center
        nickBox.ClearTextOnFocus = false
        Instance.new("UICorner", nickBox).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", nickBox).Color = Color3.fromRGB(60,60,60)

        nickBox.FocusLost:Connect(function(enter)
            if enter then
                local data = targetData[targetPlayer.UserId]
                if data then
                    data.name = nickBox.Text
                    if data.on then
                        ReplicatedStorage.SetPlayerNickname:FireServer(targetPlayer.UserId, nickBox.Text, data.level)
                    end
                end
            end
        end)

        local levelLabel = Instance.new("TextLabel", card)
        levelLabel.Size = UDim2.new(1, -20, 0, 14)
        levelLabel.Position = UDim2.new(0, 10, 0, 76)
        levelLabel.BackgroundTransparency = 1
        levelLabel.Text = "Level"
        levelLabel.TextColor3 = Color3.fromRGB(180,180,180)
        levelLabel.Font = Enum.Font.Gotham
        levelLabel.TextSize = 11
        levelLabel.TextXAlignment = Enum.TextXAlignment.Left

        local levelBox = Instance.new("TextBox", card)
        levelBox.Size = UDim2.new(1, -20, 0, 24)
        levelBox.Position = UDim2.new(0, 10, 0, 90)
        levelBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
        levelBox.BackgroundTransparency = 0.3
        levelBox.PlaceholderText = "Level"
        levelBox.Text = ""
        levelBox.TextColor3 = Color3.fromRGB(220,220,220)
        levelBox.Font = Enum.Font.GothamBold
        levelBox.TextSize = 13
        levelBox.TextXAlignment = Enum.TextXAlignment.Center
        levelBox.ClearTextOnFocus = false
        Instance.new("UICorner", levelBox).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", levelBox).Color = Color3.fromRGB(60,60,60)

        levelBox.FocusLost:Connect(function(enter)
            if enter then
                local data = targetData[targetPlayer.UserId]
                if data then
                    data.level = levelBox.Text
                    if data.on then
                        ReplicatedStorage.SetPlayerNickname:FireServer(targetPlayer.UserId, data.name, levelBox.Text)
                    end
                end
            end
        end)

        local iconLabel = Instance.new("TextLabel", card)
        iconLabel.Size = UDim2.new(1, -20, 0, 14)
        iconLabel.Position = UDim2.new(0, 10, 0, 116)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = "Icon"
        iconLabel.TextColor3 = Color3.fromRGB(180,180,180)
        iconLabel.Font = Enum.Font.Gotham
        iconLabel.TextSize = 11
        iconLabel.TextXAlignment = Enum.TextXAlignment.Left

        local iconDropdown = Instance.new("TextButton", card)
        iconDropdown.Size = UDim2.new(1, -20, 0, 24)
        iconDropdown.Position = UDim2.new(0, 10, 0, 130)
        iconDropdown.BackgroundColor3 = Color3.fromRGB(40,40,40)
        iconDropdown.BackgroundTransparency = 0.3
        iconDropdown.Text = "Icon: Default"
        iconDropdown.TextColor3 = Color3.fromRGB(220,220,220)
        iconDropdown.Font = Enum.Font.GothamBold
        iconDropdown.TextSize = 12
        iconDropdown.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", iconDropdown).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", iconDropdown).Color = Color3.fromRGB(60,60,60)

        local iconListFrame = Instance.new("ScrollingFrame", card)
        iconListFrame.Size = UDim2.new(1, -20, 0, 0)
        iconListFrame.Position = UDim2.new(0, 10, 0, 156)
        iconListFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        iconListFrame.BackgroundTransparency = 0.1
        iconListFrame.ClipsDescendants = true
        iconListFrame.ScrollBarThickness = 2
        iconListFrame.CanvasSize = UDim2.new(0, 0, 0, 192)
        iconListFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        Instance.new("UICorner", iconListFrame).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", iconListFrame).Color = Color3.fromRGB(60,60,60)
        Instance.new("UIListLayout", iconListFrame).Padding = UDim.new(0, 0)

        local iconOrder = {"Nenhum", "Casey", "VIP", "QA", "CON", "DEV", "MrWindy", "MOD"}
        local dropdownOpen = false
        for _, iconName in ipairs(iconOrder) do
            local btn = Instance.new("TextButton", iconListFrame)
            btn.Size = UDim2.new(1, 0, 0, 24)
            btn.BackgroundTransparency = 1
            btn.Text = iconName
            btn.TextColor3 = Color3.fromRGB(150,150,150)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Center

            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
                btn.BackgroundTransparency = 0.5
                btn.TextColor3 = Color3.fromRGB(220,220,220)
            end)
            btn.MouseLeave:Connect(function()
                btn.BackgroundTransparency = 1
                btn.TextColor3 = Color3.fromRGB(150,150,150)
            end)

            btn.MouseButton1Click:Connect(function()
                local data = targetData[targetPlayer.UserId]
                if data then
                    data.icon = iconName
                    iconDropdown.Text = "Icon: "..iconName
                end
                card:TweenSize(UDim2.new(1, -4, 0, 155), "Out", "Quad", 0.15, true)
                iconListFrame:TweenSize(UDim2.new(1, -20, 0, 0), "Out", "Quad", 0.15, true)
                dropdownOpen = false
            end)
        end

        iconDropdown.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            if dropdownOpen then
                card:TweenSize(UDim2.new(1, -4, 0, 300), "Out", "Quad", 0.15, true)
                iconListFrame:TweenSize(UDim2.new(1, -20, 0, 120), "Out", "Quad", 0.15, true)
            else
                card:TweenSize(UDim2.new(1, -4, 0, 155), "Out", "Quad", 0.15, true)
                iconListFrame:TweenSize(UDim2.new(1, -20, 0, 0), "Out", "Quad", 0.15, true)
            end
        end)
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Players.LocalPlayer then CreatePlayerCard(plr) end
    end

    Players.PlayerAdded:Connect(CreatePlayerCard)
    Players.PlayerRemoving:Connect(function(plr)
        DestroyPlayerCard(plr.UserId)
    end)
end

    do
        local boxFOV, contentFOV = CreateGroupbox(rightColP, "Câmera")
        boxFOV.BackgroundColor3 = Color3.fromRGB(25,25,25)
        boxFOV.BackgroundTransparency = 1
        boxFOV.BorderSizePixel = 0
        boxFOV.Size = UDim2.new(1,0,0,190)
        boxFOV.ClipsDescendants = false
        Instance.new("UICorner", boxFOV).CornerRadius = UDim.new(0,8)
        contentFOV.ClipsDescendants = false

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(70,70,70)
        stroke.Transparency = 0.8
        stroke.Thickness = 1
        stroke.Parent = boxFOV

        local FOVData = {Enabled = false, Value = 70}
        local stretchConn65, stretchConn7 = nil, nil

        CreateToggle(contentFOV, "Enable FOV", false, function(state)
            FOVData.Enabled = state
            if state then
                Camera.FieldOfView = FOVData.Value
            else
                Camera.FieldOfView = 70
            end
        end)

        local sliderFrame = Instance.new("Frame", contentFOV)
        sliderFrame.Size = UDim2.new(1,0,0,40)
        sliderFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1,-50,0,20)
        label.Position = UDim2.new(0,10,0,5)
        label.BackgroundTransparency = 1
        label.Text = "Field Of View"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local valueLabel = Instance.new("TextLabel", sliderFrame)
        valueLabel.Size = UDim2.new(0,40,0,20)
        valueLabel.Position = UDim2.new(1,-45,0,5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = "70"
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = Color3.fromRGB(235,235,235)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right

        local bar = Instance.new("TextButton", sliderFrame)
        bar.Size = UDim2.new(1,-20,0,5)
        bar.Position = UDim2.new(0,10,0,28)
        bar.BackgroundColor3 = Color3.fromRGB(50,50,55)
        bar.BorderSizePixel = 0
        bar.Text = ""
        bar.AutoButtonColor = false
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new(0,0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        fill.BorderSizePixel = 0
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

        local minFOV, maxFOV = 70, 120
        local dragging = false
        local function update(inputX)
            local scale = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(minFOV + (maxFOV - minFOV) * scale + 0.5)
            TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
            valueLabel.Text = tostring(value)
            FOVData.Value = value
            if FOVData.Enabled then Camera.FieldOfView = value end
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input.Position.X)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        CreateToggle(contentFOV, "Stretch 0.65", false, function(state)
            if state then
                getgenv().Resolution = {[".gg/scripters"] = 0.65}
                if not stretchConn65 then
                    stretchConn65 = RunService.RenderStepped:Connect(function()
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.65, 0, 0, 0, 1)
                    end)
                end
            else
                if stretchConn65 then
                    stretchConn65:Disconnect()
                    stretchConn65 = nil
                end
            end
        end)

        CreateToggle(contentFOV, "Stretch 0.7", false, function(state)
            if state then
                getgenv().Resolution = {[".gg/scripters"] = 0.7}
                if not stretchConn7 then
                    stretchConn7 = RunService.RenderStepped:Connect(function()
                        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
                    end)
                end
            else
                if stretchConn7 then
                    stretchConn7:Disconnect()
                    stretchConn7 = nil
                end
            end
        end)
    end

do
    local boxFOV, contentFOV = CreateGroupbox(rightColP, "Sensitivity")
    boxFOV.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxFOV.BackgroundTransparency = 1
    boxFOV.BorderSizePixel = 0
    boxFOV.Size = UDim2.new(1,0,0,270)
    boxFOV.ClipsDescendants = false
    Instance.new("UICorner", boxFOV).CornerRadius = UDim.new(0,8)
    contentFOV.ClipsDescendants = false

    local layout = contentFOV:FindFirstChildOfClass("UIListLayout")
    if layout then
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 8)
    end

    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local HttpService = game:GetService("HttpService")

    local function SaveSensitivity()
        pcall(function()
            local data = {}
            if isfile("FTF_Eclipse/config.json") then
                local ok, decoded = pcall(function()
                    return HttpService:JSONDecode(readfile("FTF_Eclipse/config.json"))
                end)
                if ok and decoded then data = decoded end
            end
            data.SensitivityX = _G.CameraSensitivityX
            data.SensitivityY = _G.CameraSensitivityY
            writefile("FTF_Eclipse/config.json", HttpService:JSONEncode(data))
        end)
    end

    local function LoadSensitivity()
        if isfile("FTF_Eclipse/config.json") then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(readfile("FTF_Eclipse/config.json"))
            end)
            if ok and data then
                if data.SensitivityX then _G.CameraSensitivityX = data.SensitivityX end
                if data.SensitivityY then _G.CameraSensitivityY = data.SensitivityY end
            end
        end
        _G.CameraSensitivityX = _G.CameraSensitivityX or 1
        _G.CameraSensitivityY = _G.CameraSensitivityY or 1
    end

    LoadSensitivity()

    local CameraInput
    pcall(function()
        CameraInput = require(player.PlayerScripts.PlayerModule.CameraModule.CameraInput)
    end)

    if CameraInput then
        if _G.OriginalGetRotation then
            CameraInput.getRotation = _G.OriginalGetRotation
        end

        _G.OriginalGetRotation = CameraInput.getRotation

        CameraInput.getRotation = function(...)
            local rot = _G.OriginalGetRotation(...)
            return Vector2.new(rot.X * _G.CameraSensitivityX, rot.Y * _G.CameraSensitivityY)
        end

        local order = 0
        local function NextOrder()
            order += 1
            return order
        end

        local function CreateSliderRow(title, initial, onChange)
            local row = Instance.new("Frame", contentFOV)
            row.LayoutOrder = NextOrder()
            row.Size = UDim2.new(1, 0, 0, 32)
            row.BackgroundTransparency = 1
            row.ZIndex = 5

            local nameLabel = Instance.new("TextLabel", row)
            nameLabel.Size = UDim2.new(1, -40, 0, 16)
            nameLabel.Position = UDim2.new(0, 0, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = title
            nameLabel.Font = CurrentFont or Enum.Font.GothamBold
            nameLabel.TextSize = 12
            nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.ZIndex = 6

            local valueLabel = Instance.new("TextLabel", row)
            valueLabel.Size = UDim2.new(0, 40, 0, 16)
            valueLabel.Position = UDim2.new(1, -40, 0, 0)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = string.format("%.1f", initial)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextSize = 12
            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = 6

            local track = Instance.new("Frame", row)
            track.Size = UDim2.new(1, 0, 0, 4)
            track.Position = UDim2.new(0, 0, 0, 22)
            track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            track.BorderSizePixel = 0
            track.ZIndex = 6
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

            local fill = Instance.new("Frame", track)
            fill.Size = UDim2.new(0, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            fill.BorderSizePixel = 0
            fill.ZIndex = 7
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

            local current = initial
            local dragging = false

            local function UpdateVisual(v)
                local percent = (v - 0.1) / (5 - 0.1)
                fill.Size = UDim2.new(percent, 0, 1, 0)
            end

            local function Set(v)
                current = math.clamp(v, 0.1, 5)
                valueLabel.Text = string.format("%.1f", current)
                UpdateVisual(current)
                onChange(current)
                SaveSensitivity()
            end

            local function UpdateFromInput(input)
                local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
                local v = 0.1 + math.clamp(rel, 0, 1) * (5 - 0.1)
                Set(math.floor(v * 10 + 0.5) / 10)
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateFromInput(input)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateFromInput(input)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UpdateVisual(current)
            return Set
        end

        local function CreateResetBtn(text)
            local btn = Instance.new("TextButton", contentFOV)
            btn.LayoutOrder = NextOrder()
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.BackgroundTransparency = 1
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.AutoButtonColor = false
            btn.ZIndex = 5
            return btn
        end

        local setX = CreateSliderRow("Sensitivity X", _G.CameraSensitivityX, function(v)
            _G.CameraSensitivityX = v
        end)

        local spacer = Instance.new("Frame", contentFOV)
        spacer.LayoutOrder = NextOrder()
        spacer.Size = UDim2.new(1, 0, 0, 2)
        spacer.BackgroundTransparency = 1

        local setY = CreateSliderRow("Sensitivity Y", _G.CameraSensitivityY, function(v)
            _G.CameraSensitivityY = v
        end)

        local spacer2 = Instance.new("Frame", contentFOV)
        spacer2.LayoutOrder = NextOrder()
        spacer2.Size = UDim2.new(1, 0, 0, 6)
        spacer2.BackgroundTransparency = 1

        local resetX = CreateResetBtn("Resetar X")
        resetX.MouseButton1Click:Connect(function() setX(1) end)

        local resetY = CreateResetBtn("Resetar Y")
        resetY.MouseButton1Click:Connect(function() setY(1) end)
    end
end
end

do
    local settingsPageP = pages["Progress"]
    local columnsP = Instance.new("Frame", settingsPageP)
    columnsP.Size = UDim2.new(1, 0, 0, 0)
    columnsP.AutomaticSize = Enum.AutomaticSize.Y
    columnsP.BackgroundTransparency = 1

    local leftColP = Instance.new("Frame", columnsP)
    leftColP.Size = UDim2.new(0.5, -15, 0, 0)
    leftColP.AutomaticSize = Enum.AutomaticSize.Y
    leftColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColP).Padding = UDim.new(0, 10)

    local rightColP = Instance.new("Frame", columnsP)
    rightColP.Size = UDim2.new(0.5, -12, 0, 0)
    rightColP.Position = UDim2.new(0.5, 1, 0, 0)
    rightColP.AutomaticSize = Enum.AutomaticSize.Y
    rightColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColP).Padding = UDim.new(0, 10)

    local box1P, content1P = CreateGroupbox(leftColP, "Action Timers")
    local boxTimerColors, contentTimerColors = CreateGroupbox(leftColP, "Timer Colors")
    boxTimerColors.LayoutOrder = 2
    local box2P, content2P = CreateGroupbox(rightColP, "Beast Indicators")
    local boxIndicatorColors, contentIndicatorColors = CreateGroupbox(rightColP, "Indicators Colors")
    boxIndicatorColors.LayoutOrder = 2
    for _, c in ipairs({contentTimerColors, contentIndicatorColors}) do
        local l = c:FindFirstChildOfClass("UIListLayout")
        if l then l.SortOrder = Enum.SortOrder.LayoutOrder end
    end

    local Http = game:GetService("HttpService")
    local SAVE_FILE = "TimerColors.json"
    local DEFAULT_COLORS = {
        ComputerColor = Color3.fromRGB(255, 255, 255),
        ExitColor = Color3.fromRGB(255, 170, 0),
        DoorColor = Color3.fromRGB(133, 88, 0),
        LifeColor = Color3.fromRGB(80, 160, 255),
        WalkspeedColor = Color3.fromRGB(255, 255, 255),
        GetUpColor = Color3.fromRGB(0, 255, 0),
        BeastPowerColor = Color3.fromRGB(255, 170, 0),
        BeastPowerV2Color = Color3.fromRGB(255, 255, 255),
        BeastSpawnColor = Color3.fromRGB(255, 255, 255),
    }
    local DEFAULT_TRANSP = { TimerTransparency = 0, IndicatorTransparency = 0 }
    local ComputerColor, ExitColor, DoorColor, LifeColor, WalkspeedColor
    local GetUpColor, BeastPowerColor, BeastPowerV2Color, BeastSpawnColor
    local TimerTransparency, IndicatorTransparency
    local function colorToTable(c)
        if not c then return {255, 255, 255} end
        return {math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)}
    end
    local function tableToColor(t) if type(t) ~= "table" or not t[1] then return nil end return Color3.fromRGB(t[1], t[2], t[3]) end
    local function LoadColors()
        local data = nil
        pcall(function()
            if readfile and isfile and isfile(SAVE_FILE) then data = readfile(SAVE_FILE) end
        end)
        if data and data ~= "" then
            local ok2, decoded = pcall(function() return Http:JSONDecode(data) end)
            if ok2 and type(decoded) == "table" and next(decoded) then return decoded end
        end
        if getgenv().TimerColorsSaved and next(getgenv().TimerColorsSaved) then
            return getgenv().TimerColorsSaved
        end
        return {}
    end
    local Loaded = LoadColors()
    local function GetSaved(name, def)
        local c = Loaded[name] and tableToColor(Loaded[name])
        return c or def
    end
    local function GetSavedNum(name, def)
        local v = Loaded[name]
        if type(v) == "number" then return math.clamp(v, 0, 1) end
        return def
    end
    local function SaveColors()
        local toSave = {
            ComputerColor = colorToTable(ComputerColor),
            ExitColor = colorToTable(ExitColor),
            DoorColor = colorToTable(DoorColor),
            LifeColor = colorToTable(LifeColor),
            WalkspeedColor = colorToTable(WalkspeedColor),
            GetUpColor = colorToTable(GetUpColor),
            BeastPowerColor = colorToTable(BeastPowerColor),
            BeastPowerV2Color = colorToTable(BeastPowerV2Color),
            BeastSpawnColor = colorToTable(BeastSpawnColor),
            TimerTransparency = TimerTransparency or 0,
            IndicatorTransparency = IndicatorTransparency or 0,
        }
        getgenv().TimerColorsSaved = toSave
        local ok, encoded = pcall(function() return Http:JSONEncode(toSave) end)
        if ok and encoded then
            pcall(function() if writefile then writefile(SAVE_FILE, encoded) end end)
        end
    end

    local UIS_P = game:GetService("UserInputService")
    ComputerColor = GetSaved("ComputerColor", DEFAULT_COLORS.ComputerColor)
    ExitColor = GetSaved("ExitColor", DEFAULT_COLORS.ExitColor)
    DoorColor = GetSaved("DoorColor", DEFAULT_COLORS.DoorColor)
    LifeColor = GetSaved("LifeColor", DEFAULT_COLORS.LifeColor)
    WalkspeedColor = GetSaved("WalkspeedColor", DEFAULT_COLORS.WalkspeedColor)
    GetUpColor = GetSaved("GetUpColor", DEFAULT_COLORS.GetUpColor)
    BeastPowerColor = GetSaved("BeastPowerColor", DEFAULT_COLORS.BeastPowerColor)
    BeastPowerV2Color = GetSaved("BeastPowerV2Color", DEFAULT_COLORS.BeastPowerV2Color)
    BeastSpawnColor = GetSaved("BeastSpawnColor", DEFAULT_COLORS.BeastSpawnColor)
    TimerTransparency = GetSavedNum("TimerTransparency", 0)
    IndicatorTransparency = GetSavedNum("IndicatorTransparency", 0)
    local OnComputerColorChanged = nil
    local OnExitColorChanged = nil
    local OnDoorColorChanged = nil
    local OnLifeColorChanged = nil
    local OnWalkspeedColorChanged = nil
    local OnGetUpColorChanged = nil
    local OnBeastPowerColorChanged = nil
    local OnBeastPowerV2ColorChanged = nil
    local OnBeastSpawnColorChanged = nil
    local OnTimerTransparencyChanged = nil
    local OnIndicatorTransparencyChanged = nil
    local PickSetters = {}
    local PickPreviews = {}
    local SliderSetters = {}

    local PickSetters = {}
    local PickPreviews = {}
    local SliderSetters = {}
    local TranspUIs = {}

    local function CreatePickColor(parent, name, defaultColor, onChange, saveKey, order, defaultTransp, onTranspChange, transpKey)
        local h, s, v = defaultColor:ToHSV()
        local transp = defaultTransp or 0

        local holder = Instance.new("Frame")
        holder.Name = name .. "_Holder"
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.AutomaticSize = Enum.AutomaticSize.Y
        holder.ClipsDescendants = false
        holder.ZIndex = 5
        holder.LayoutOrder = order or 1
        holder.Parent = parent

        local holderLayout = Instance.new("UIListLayout", holder)
        holderLayout.FillDirection = Enum.FillDirection.Vertical
        holderLayout.Padding = UDim.new(0, 6)
        holderLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local row = Instance.new("Frame")
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(1, 0, 0, 24)
        row.LayoutOrder = 1
        row.Parent = holder

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(210, 210, 210)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = name
        label.Parent = row

        local preview = Instance.new("TextButton")
        preview.BackgroundColor3 = defaultColor
        preview.Size = UDim2.new(0, 26, 0, 22)
        preview.Position = UDim2.new(1, -26, 0, 3)
        preview.Text = ""
        preview.AutoButtonColor = false
        preview.ZIndex = 5
        preview.Parent = row
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 6)
        local ps = Instance.new("UIStroke", preview)
        ps.Color = Color3.fromRGB(70, 70, 70)
        ps.Thickness = 1
        if saveKey then PickPreviews[saveKey] = preview end

        local picker = Instance.new("Frame")
        picker.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        picker.BackgroundTransparency = 0.1
        picker.Size = UDim2.new(1, 0, 0, 165)
        picker.Visible = false
        picker.LayoutOrder = 2
        picker.ZIndex = 5
        picker.Parent = holder
        Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 10)
        local pks = Instance.new("UIStroke", picker)
        pks.Color = Color3.fromRGB(60, 60, 60)
        pks.Thickness = 1

        local svBox = Instance.new("ImageButton")
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svBox.Position = UDim2.new(0, 10, 0, 10)
        svBox.Size = UDim2.new(1, -42, 0, 110)
        svBox.AutoButtonColor = false
        svBox.Parent = picker
        Instance.new("UICorner", svBox).CornerRadius = UDim.new(0, 6)

        local whiteOverlay = Instance.new("Frame")
        whiteOverlay.Name = "WhiteGradient"
        whiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
        whiteOverlay.BorderSizePixel = 0
        whiteOverlay.Size = UDim2.new(1, 0, 1, 0)
        whiteOverlay.ZIndex = 7
        whiteOverlay.Active = false
        whiteOverlay.Parent = svBox
        Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 6)
        local satGrad = Instance.new("UIGradient")
        satGrad.Rotation = 0
        satGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
        satGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
        satGrad.Parent = whiteOverlay
        local valFrame = Instance.new("Frame")
        valFrame.Name = "BlackGradient"
        valFrame.BackgroundColor3 = Color3.new(0, 0, 0)
        valFrame.BorderSizePixel = 0
        valFrame.Size = UDim2.new(1, 0, 1, 0)
        valFrame.ZIndex = 8
        valFrame.Active = false
        valFrame.Parent = svBox
        Instance.new("UICorner", valFrame).CornerRadius = UDim.new(0, 6)
        local valGrad = Instance.new("UIGradient")
        valGrad.Rotation = 90
        valGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
        valGrad.Parent = valFrame

        local svCursor = Instance.new("Frame")
        svCursor.Size = UDim2.new(0, 14, 0, 14)
        svCursor.BackgroundTransparency = 1
        svCursor.Parent = svBox
        local svInner = Instance.new("Frame")
        svInner.Size = UDim2.new(1, -4, 1, -4)
        svInner.Position = UDim2.new(0, 2, 0, 2)
        svInner.BackgroundTransparency = 1
        svInner.Parent = svCursor
        Instance.new("UICorner", svInner).CornerRadius = UDim.new(1, 0)
        local svStroke = Instance.new("UIStroke", svInner)
        svStroke.Color = Color3.fromRGB(255, 255, 255)
        svStroke.Thickness = 2

        local hueBar = Instance.new("ImageButton")
        hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueBar.Position = UDim2.new(1, -22, 0, 10)
        hueBar.Size = UDim2.new(0, 12, 1, -58)
        hueBar.AutoButtonColor = false
        hueBar.Parent = picker
        Instance.new("UICorner", hueBar).CornerRadius = UDim.new(1, 0)
        local hueGrad = Instance.new("UIGradient")
        hueGrad.Rotation = 90
        hueGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
            ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
            ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
            ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
            ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
        })
        hueGrad.Parent = hueBar

        local hueCursor = Instance.new("Frame")
        hueCursor.Name = "HueCursor"
        hueCursor.AnchorPoint = Vector2.new(0, 0.5)
        hueCursor.Size = UDim2.new(1, 6, 0, 6)
        hueCursor.Position = UDim2.new(0, -3, 0, 0)
        hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hueCursor.BorderSizePixel = 0
        hueCursor.ZIndex = 10
        hueCursor.Active = false
        hueCursor.Parent = hueBar
        Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(0, 2)
        Instance.new("UIStroke", hueCursor).Color = Color3.fromRGB(0, 0, 0)

        local transpLabel = Instance.new("TextLabel")
        transpLabel.BackgroundTransparency = 1
        transpLabel.Position = UDim2.new(0, 10, 0, 128)
        transpLabel.Size = UDim2.new(1, -70, 0, 14)
        transpLabel.Font = Enum.Font.Gotham
        transpLabel.TextSize = 12
        transpLabel.TextColor3 = Color3.fromRGB(190, 190, 190)
        transpLabel.TextXAlignment = Enum.TextXAlignment.Left
        transpLabel.Text = "Transparency"
        transpLabel.Parent = picker

        local transpVal = Instance.new("TextLabel")
        transpVal.BackgroundTransparency = 1
        transpVal.Position = UDim2.new(1, -52, 0, 128)
        transpVal.Size = UDim2.new(0, 42, 0, 14)
        transpVal.Font = Enum.Font.Gotham
        transpVal.TextSize = 12
        transpVal.TextColor3 = Color3.fromRGB(190, 190, 190)
        transpVal.TextXAlignment = Enum.TextXAlignment.Right
        transpVal.Text = string.format("%.2f", transp)
        transpVal.Parent = picker

        local transpTrack = Instance.new("TextButton")
        transpTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        transpTrack.Position = UDim2.new(0, 10, 0, 147)
        transpTrack.Size = UDim2.new(1, -20, 0, 4)
        transpTrack.Text = ""
        transpTrack.AutoButtonColor = false
        transpTrack.Parent = picker
        Instance.new("UICorner", transpTrack).CornerRadius = UDim.new(1, 0)

        local transpFill = Instance.new("Frame")
        transpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        transpFill.Size = UDim2.new(transp, 0, 1, 0)
        transpFill.BorderSizePixel = 0
        transpFill.Parent = transpTrack
        Instance.new("UICorner", transpFill).CornerRadius = UDim.new(1, 0)

local UserInputService = game:GetService("UserInputService")

local transpTrack = Instance.new("TextButton")
transpTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
transpTrack.Position = UDim2.new(0, 10, 0, 147)
transpTrack.Size = UDim2.new(1, -20, 0, 4)
transpTrack.Text = ""
transpTrack.AutoButtonColor = false
transpTrack.Parent = picker
Instance.new("UICorner", transpTrack).CornerRadius = UDim.new(1, 0)

local transpFill = Instance.new("Frame")
transpFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
transpFill.Size = UDim2.new(transp, 0, 1, 0)
transpFill.BorderSizePixel = 0
transpFill.Parent = transpTrack
Instance.new("UICorner", transpFill).CornerRadius = UDim.new(1, 0)

if transpKey then
    TranspUIs[transpKey] = TranspUIs[transpKey] or {}
    table.insert(TranspUIs[transpKey], {fill = transpFill, val = transpVal})
end

local function updateVisual(fire, skipSave)
    local color = Color3.fromHSV(h, s, v)
    preview.BackgroundColor3 = color
    svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    svCursor.Position = UDim2.new(s, -7, 1 - v, -7)
    hueCursor.Position = UDim2.new(0, -4, math.clamp(h, 0.03, 0.97), 0)
    if fire ~= false and onChange then onChange(color, skipSave) end
end

local function setTranspVisual(val)
    for _, ui in ipairs(TranspUIs[transpKey] or {}) do
        ui.fill.Size = UDim2.new(val, 0, 1, 0)
        ui.val.Text = string.format("%.2f", val)
    end
end

local function setTransp(val, fire)
    transp = math.clamp(val, 0, 1)
    setTranspVisual(transp)
    if fire ~= false and onTranspChange then onTranspChange(transp) end
end

if saveKey then
    PickSetters[saveKey] = function(c)
        h, s, v = c:ToHSV()
        preview.BackgroundColor3 = c
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svCursor.Position = UDim2.new(s, -7, 1 - v, -7)
        hueCursor.Position = UDim2.new(0, -4, math.clamp(h, 0.03, 0.97), 0)
        if onChange then onChange(c, true) end
    end
end
if transpKey then
    SliderSetters[transpKey] = function(val)
        setTranspVisual(val)
        if onTranspChange then onTranspChange(val, true) end
    end
end

local draggingSV = false
local draggingHue = false
local draggingTransp = false
local dragInputTransp = nil

local function updateSV(input)
    local pos = svBox.AbsolutePosition
    local size = svBox.AbsoluteSize
    s = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
    v = 1 - math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
    updateVisual()
    SaveColors()
end
local function updateHue(input)
    local pos = hueBar.AbsolutePosition
    local size = hueBar.AbsoluteSize
    h = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
    updateVisual()
    SaveColors()
end
local function updateTransp(input)
    local pos = transpTrack.AbsolutePosition
    local size = transpTrack.AbsoluteSize
    if size.X <= 0 then return end
    local val = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
    setTransp(val)
    SaveColors()
end

svBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true updateSV(input) end
end)
hueBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true updateHue(input) end
end)
transpTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingTransp = true dragInputTransp = input updateTransp(input) end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if draggingSV then updateSV(input) end
        if draggingHue then updateHue(input) end
        if draggingTransp and input == dragInputTransp then updateTransp(input) end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSV = false draggingHue = false
        if input == dragInputTransp then draggingTransp = false dragInputTransp = nil end
    end
end)

preview.MouseButton1Click:Connect(function()
    picker.Visible = not picker.Visible
end)
updateVisual(false)
setTransp(transp, false)
end

local function CreateTransparencySlider(parent, name, defaultValue, onChange, saveKey, order)
    if saveKey then
        SliderSetters[saveKey] = function(v)
            if onChange then onChange(v, true) end
        end
    end
    return nil
end

local function CreateResetButton(parent, text, keys, transpKeys)
    local btn = Instance.new("TextButton")
    btn.Name = text
    btn.Size = UDim2.new(1, 0, 0, 20)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.LayoutOrder = 99
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        for _, k in ipairs(keys) do
            local def = DEFAULT_COLORS[k]
            if PickSetters[k] then PickSetters[k](def) end
            if PickPreviews[k] then PickPreviews[k].BackgroundColor3 = def end
        end
        for _, k in ipairs(transpKeys or {}) do
            local def = DEFAULT_TRANSP[k] or 0
            if SliderSetters[k] then SliderSetters[k](def) end
        end
        task.wait()
        SaveColors()
        for _, k in ipairs(keys) do
            if PickPreviews[k] then PickPreviews[k].BackgroundColor3 = DEFAULT_COLORS[k] end
        end
    end)
    btn.MouseEnter:Connect(function() btn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    btn.MouseLeave:Connect(function() btn.TextColor3 = Color3.fromRGB(170, 170, 170) end)
    return btn
end

    CreatePickColor(contentTimerColors, "Computer Color", ComputerColor, function(c, skip) ComputerColor = c if OnComputerColorChanged then OnComputerColorChanged(c) end if not skip then SaveColors() end end, "ComputerColor", 1)
    CreatePickColor(contentTimerColors, "Exit Door Color", ExitColor, function(c, skip) ExitColor = c if OnExitColorChanged then OnExitColorChanged(c) end if not skip then SaveColors() end end, "ExitColor", 2)
    CreatePickColor(contentTimerColors, "Door Timer Color", DoorColor, function(c, skip) DoorColor = c if OnDoorColorChanged then OnDoorColorChanged(c) end if not skip then SaveColors() end end, "DoorColor", 3)
    CreatePickColor(contentTimerColors, "Life Timer Color", LifeColor, function(c, skip) LifeColor = c if OnLifeColorChanged then OnLifeColorChanged(c) end if not skip then SaveColors() end end, "LifeColor", 4)
    CreatePickColor(contentTimerColors, "Walkspeed Color", WalkspeedColor, function(c, skip) WalkspeedColor = c if OnWalkspeedColorChanged then OnWalkspeedColorChanged(c) end if not skip then SaveColors() end end, "WalkspeedColor", 5)
    CreateTransparencySlider(contentTimerColors, "Transparency", TimerTransparency, function(v, skip) TimerTransparency = v if OnTimerTransparencyChanged then OnTimerTransparencyChanged(v) end if not skip then SaveColors() end end, "TimerTransparency", 6)
    CreateResetButton(contentTimerColors, "Reset Timer Colors", {"ComputerColor", "ExitColor", "DoorColor", "LifeColor", "WalkspeedColor"}, {"TimerTransparency"})

    CreatePickColor(contentIndicatorColors, "GetUp Color", GetUpColor, function(c, skip) GetUpColor = c if OnGetUpColorChanged then OnGetUpColorChanged(c) end if not skip then SaveColors() end end, "GetUpColor", 1)
    CreatePickColor(contentIndicatorColors, "Beast Power Color", BeastPowerColor, function(c, skip) BeastPowerColor = c if OnBeastPowerColorChanged then OnBeastPowerColorChanged(c) end if not skip then SaveColors() end end, "BeastPowerColor", 2)
    CreatePickColor(contentIndicatorColors, "Beast Power V2 Color", BeastPowerV2Color, function(c, skip) BeastPowerV2Color = c if OnBeastPowerV2ColorChanged then OnBeastPowerV2ColorChanged(c) end if not skip then SaveColors() end end, "BeastPowerV2Color", 3)
    CreatePickColor(contentIndicatorColors, "Beast Spawn Color", BeastSpawnColor, function(c, skip) BeastSpawnColor = c if OnBeastSpawnColorChanged then OnBeastSpawnColorChanged(c) end if not skip then SaveColors() end end, "BeastSpawnColor", 4)
    CreateTransparencySlider(contentIndicatorColors, "Transparency", IndicatorTransparency, function(v, skip) IndicatorTransparency = v if OnIndicatorTransparencyChanged then OnIndicatorTransparencyChanged(v) end if not skip then SaveColors() end end, "IndicatorTransparency", 5)
    CreateResetButton(contentIndicatorColors, "Reset Indicators Colors", {"GetUpColor", "BeastPowerColor", "BeastPowerV2Color", "BeastSpawnColor"}, {"IndicatorTransparency"})

    do
        local enabled = false
        local comps = {}
        local P = game:GetService("Players")
        local RS = game:GetService("ReplicatedStorage")
        local W = workspace
        CreateToggle(content1P, "Computer Progress", false, function(v)
            enabled = v
            if not v then for _, d in pairs(comps) do if d.gui then d.gui:Destroy() end end comps = {} end
        end)
        local function make(pc)
            if comps[pc] then return end
            local g = Instance.new("BillboardGui")
            g.Name = "ComputerProgressGui"
            g.Size = UDim2.new(0, 120, 0, 18)
            g.StudsOffset = Vector3.new(0, 3.5, 0)
            g.AlwaysOnTop = true
            g.Parent = pc
            local txt = Instance.new("TextLabel", g)
            txt.Size = UDim2.new(1, 0, 0.5, 0)
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = Enum.Font.GothamBold
            txt.TextColor3 = Color3.new(1, 1, 1)
            txt.TextStrokeTransparency = 0.4
            txt.Text = "0%"
            txt.TextTransparency = TimerTransparency
            local bg = Instance.new("Frame", g)
            bg.Position = UDim2.new(0, 0, 0.55, 0)
            bg.Size = UDim2.new(1, 0, 0.35, 0)
            bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            bg.BorderSizePixel = 0
            bg.BackgroundTransparency = TimerTransparency
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local bar = Instance.new("Frame", bg)
            bar.Size = UDim2.new(0, 0, 1, 0)
            bar.BorderSizePixel = 0
            bar.BackgroundColor3 = ComputerColor
            bar.BackgroundTransparency = TimerTransparency
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            comps[pc] = {gui = g, bar = bar, txt = txt, bg = bg, p = 0, d = false}
        end
        local function progress(pc)
            local m = 0
            for _, p in pairs(pc:GetChildren()) do
                if p:IsA("BasePart") and p.Name:find("ComputerTrigger") then
                    for _, t in pairs(p:GetTouchingParts()) do
                        local pl = P:GetPlayerFromCharacter(t.Parent)
                        local s = pl and pl:FindFirstChild("TempPlayerStatsModule")
                        local ap = s and s:FindFirstChild("ActionProgress")
                        local r = s and s:FindFirstChild("Ragdoll")
                        if ap and r and not r.Value then m = math.max(m, ap.Value) end
                    end
                end
            end
            return m
        end
        OnComputerColorChanged = function(c) for _, d in pairs(comps) do if d.bar and not d.d then d.bar.BackgroundColor3 = c end end end
        local _oldTimerTransp = OnTimerTransparencyChanged
        OnTimerTransparencyChanged = function(t)
            if _oldTimerTransp then _oldTimerTransp(t) end
            for _, d in pairs(comps) do
                if d.bar then d.bar.BackgroundTransparency = t end
                if d.bg then d.bg.BackgroundTransparency = t end
                if d.txt then d.txt.TextTransparency = t end
            end
        end
        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            for pc, d in pairs(comps) do
                if not d.d then
                    d.p = math.max(d.p, progress(pc))
                    d.bar.Size = UDim2.new(d.p, 0, 1, 0)
                    if d.p >= 1 then d.d = true d.txt.Text = "COMPLETED" d.txt.TextColor3 = Color3.fromRGB(0, 255, 0) d.bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    else d.txt.Text = string.format("%.1f%%", d.p * 100) end
                end
            end
        end)
        task.spawn(function()
            while true do
                if enabled then
                    local m = RS:FindFirstChild("CurrentMap") m = m and m.Value
                    local map = m and W:FindFirstChild(tostring(m))
                    if map then for _, o in pairs(map:GetChildren()) do if o.Name == "ComputerTable" and not comps[o] then make(o) end end end
                end
                task.wait(1)
            end
        end)
    end

do
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer
    local enabled = false
    local doors = {}
    local folder
    local connAdded
    local loopThread
    local function getProgress(plr)
        local stats = plr:FindFirstChild("TempPlayerStatsModule")
        if not stats then return 0 end
        local ap = stats:FindFirstChild("ActionProgress") or stats:FindFirstChild("DoorProgress")
        return ap and ap.Value or 0
    end
    local function addDoor(d)
        if doors[d] then return end
        local part = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        local g = Instance.new("BillboardGui")
        g.Name = "ExitDoorTimer"
        g.Size = UDim2.new(0,140,0,40)
        g.StudsOffset = Vector3.new(0,5,0)
        g.AlwaysOnTop = true
        g.Adornee = part
        g.Parent = folder
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1,0,0.6,0)
        t.BackgroundTransparency = 1
        t.Text = "EXIT"
        t.TextScaled = true
        t.Font = Enum.Font.GothamBold
        t.TextColor3 = Color3.new(1,1,1)
        t.TextStrokeTransparency = 0
        t.TextStrokeColor3 = Color3.new(0,0,0)
        t.TextTransparency = TimerTransparency
        t.Parent = g
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0.8,0,0,6)
        bg.Position = UDim2.new(0.1,0,0.7,0)
        bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        bg.BorderSizePixel = 0
        bg.BackgroundTransparency = TimerTransparency
        bg.Parent = g
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0,0,1,0)
        f.BackgroundColor3 = ExitColor
        f.BorderSizePixel = 0
        f.BackgroundTransparency = TimerTransparency
        f.Parent = bg
        doors[d] = {p = part, t = t, f = f, bg = bg, gui = g, frozen = false}
    end
    local function removeAll()
        if connAdded then connAdded:Disconnect() connAdded = nil end
        loopThread = nil
        if folder then folder:Destroy() folder = nil end
        table.clear(doors)
    end
    OnExitColorChanged = function(c) for _, data in pairs(doors) do if data.f and not data.frozen then data.f.BackgroundColor3 = c end if data.t and data.t.Text ~= "EXIT" and not data.frozen then data.t.TextColor3 = c end end end
    local _prevExitTransp = OnTimerTransparencyChanged
    local _oldExitHandler = OnTimerTransparencyChanged
    local prevTimerTranspHandler = OnTimerTransparencyChanged
    OnTimerTransparencyChanged = function(t)
        if prevTimerTranspHandler then prevTimerTranspHandler(t) end
        for _, data in pairs(doors) do
            if data.f then data.f.BackgroundTransparency = t end
            if data.bg then data.bg.BackgroundTransparency = t end
            if data.t then data.t.TextTransparency = t end
        end
    end
    CreateToggle(content1P, "Exit Door Timer", false, function(v)
        enabled = v
        if not v then removeAll() return end
        removeAll()
        folder = Instance.new("Folder")
        folder.Name = "ExitDoorUI"
        folder.Parent = LP:WaitForChild("PlayerGui")
        for _,o in ipairs(workspace:GetDescendants()) do if o:IsA("Model") and (o.Name == "ExitDoor" or o.Name == "Exit") then addDoor(o) end end
        connAdded = workspace.DescendantAdded:Connect(function(o)
            if enabled and o:IsA("Model") and (o.Name == "ExitDoor" or o.Name == "Exit") then task.wait(0.2) addDoor(o) end
        end)
        task.spawn(function()
            loopThread = true
            while enabled and loopThread do
                task.wait(0.1)
                for d,data in pairs(doors) do
                    if not d.Parent then if data.gui then data.gui:Destroy() end doors[d] = nil
                    else
                        local best = 0
                        local using = false
                        for _,plr in ipairs(Players:GetPlayers()) do
                            local char = plr.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - data.p.Position).Magnitude <= 12 then
                                local prog = getProgress(plr)
                                if prog > 0 then using = true best = math.max(best, prog) end
                            end
                        end
                        local prog = using and math.clamp(best,0,1) or 0
                        if prog >= 0.99 and not data.frozen then
                            data.frozen = true data.f.Size = UDim2.new(1,0,1,0) data.f.BackgroundColor3 = Color3.fromRGB(0, 255, 0) data.t.Text = "OPEN: 100%" data.t.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif prog <= 0.01 and data.frozen then
                            data.frozen = false data.f.BackgroundColor3 = ExitColor data.f.Size = UDim2.new(0,0,1,0) data.t.Text = "EXIT" data.t.TextColor3 = Color3.new(1,1,1)
                        elseif not data.frozen then
                            data.f.Size = UDim2.new(prog,0,1,0) data.t.Text = (prog > 0.01) and ("OPENING: "..math.floor(prog*100).."%") or "EXIT" data.t.TextColor3 = (prog > 0) and ExitColor or Color3.new(1,1,1)
                        end
                    end
                end
            end
        end)
    end)
end

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    local map = ReplicatedStorage:WaitForChild("CurrentMap")
    local tick = tick
    local string_format = string.format
    local math_clamp = math.clamp
    local Instance_new = Instance.new
    local Vector3_new = Vector3.new
    local UDim2_new = UDim2.new
    local localPlayer = Players.LocalPlayer
    local enabled = false
    local lastUpdate = 0
    if getgenv().DoorTrackerConn then getgenv().DoorTrackerConn:Disconnect() getgenv().DoorTrackerConn = nil end
    if getgenv().DoorMapChangedConn then getgenv().DoorMapChangedConn:Disconnect() getgenv().DoorMapChangedConn = nil end
    if getgenv().DoorsList then for i = 1, #getgenv().DoorsList do local door = getgenv().DoorsList[i] if door and door.Parent then local b = door:FindFirstChild("BillboardGui") if b then b:Destroy() end end end end
    getgenv().DoorsList = {}
    getgenv().DoorProgressData = {}
    local backgroundColor = Color3.fromRGB(32, 32, 32)
    local progressTransparency = 0.1
    local backgroundTransparency = 0.4
    local displaySeconds = true
    local displayOpener = true
    OnDoorColorChanged = function(c)
        for door, _ in pairs(getgenv().DoorProgressData) do
            if door and door.Parent then
                local gui = door:FindFirstChild("BillboardGui")
                if gui then
                    local fill = gui:FindFirstChild("ProgressBox") and gui.ProgressBox:FindFirstChild("ProgressFill")
                    if fill then fill.BackgroundColor3 = c end
                    local pct = gui:FindFirstChild("PercentageBox")
                    if pct then pct.TextColor3 = c end
                    local nameL = gui:FindFirstChild("PlayerNameLabel")
                    if nameL then nameL.TextColor3 = c end
                end
            end
        end
    end
    local prevDoorTransp = OnTimerTransparencyChanged
    OnTimerTransparencyChanged = function(t)
        if prevDoorTransp then prevDoorTransp(t) end
        for door, _ in pairs(getgenv().DoorProgressData) do
            if door and door.Parent then
                local gui = door:FindFirstChild("BillboardGui")
                if gui then
                    local box = gui:FindFirstChild("ProgressBox")
                    if box then box.BackgroundTransparency = math.clamp(0.4 + t * 0.6, 0, 1) end
                    local fill = box and box:FindFirstChild("ProgressFill")
                    if fill then fill.BackgroundTransparency = math.clamp(0.1 + t * 0.8, 0, 1) end
                    local pct = gui:FindFirstChild("PercentageBox")
                    if pct then pct.TextTransparency = t end
                    local nameL = gui:FindFirstChild("PlayerNameLabel")
                    if nameL then nameL.TextTransparency = t end
                end
            end
        end
    end
    CreateToggle(content1P, "Door Timer", false, function(state)
        enabled = state
        if not state then
            if getgenv().DoorTrackerConn then getgenv().DoorTrackerConn:Disconnect() getgenv().DoorTrackerConn = nil end
            for door, _ in pairs(getgenv().DoorProgressData) do if door and door.Parent then local b = door:FindFirstChild("BillboardGui") if b then b:Destroy() end end end
            table.clear(getgenv().DoorsList)
            table.clear(getgenv().DoorProgressData)
        else setupDoors() startTracker() end
    end)
    local function getmap() return map.Value end
    local function getObjectPosition(object)
        if object:IsA("Model") then local primary = object.PrimaryPart if primary then return primary.Position end local cf = object:GetPivot() if cf then return cf.Position end
        elseif object:IsA("BasePart") then return object.Position end
        return Vector3_new(0, 0, 0)
    end
    local function findNearestObject(playerPosition, objectList)
        local nearestObject = nil
        local shortestDistance = math.huge
        for i = 1, #objectList do local object = objectList[i] if object.Parent then local distance = (playerPosition - getObjectPosition(object)).Magnitude if distance < shortestDistance then shortestDistance = distance nearestObject = object end end end
        return nearestObject, shortestDistance
    end
    local function isDoorLocked(door)
        local trigger = door:FindFirstChild("DoorTrigger")
        if trigger then local actionSign = trigger:FindFirstChild("ActionSign") if actionSign then return actionSign.Value ~= 11 end end
        return true
    end
    local function isValidDoor(obj)
        if obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then return false end
        if not (obj:IsA("Model") or obj:IsA("BasePart")) then return false end
        return true
    end
    local function createUIForDoor(door)
        if door:FindFirstChild("BillboardGui") then door.BillboardGui:Destroy() end
        local BillboardGui = Instance_new("BillboardGui")
        BillboardGui.Name = "BillboardGui"
        BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        BillboardGui.Active = true
        BillboardGui.AlwaysOnTop = true
        BillboardGui.LightInfluence = 1
        BillboardGui.Size = UDim2_new(10, 0, 10, 0)
        BillboardGui.StudsOffset = Vector3_new(0, 0, 0)
        BillboardGui.Enabled = true
        BillboardGui.Parent = door
        local ProgressBox = Instance_new("TextLabel")
        ProgressBox.Name = "ProgressBox"
        ProgressBox.AnchorPoint = Vector2.new(0.5, 0)
        ProgressBox.BackgroundColor3 = backgroundColor
        ProgressBox.BackgroundTransparency = math.clamp(0.4 + TimerTransparency * 0.6, 0, 1)
        ProgressBox.BorderSizePixel = 0
        ProgressBox.Position = UDim2_new(0.5, 0, 0.6, 0)
        ProgressBox.Size = UDim2_new(0.7, 0, 0.08, 0)
        ProgressBox.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ProgressBox.Text = ""
        ProgressBox.Parent = BillboardGui
        local ProgressFill = Instance_new("TextLabel")
        ProgressFill.Name = "ProgressFill"
        ProgressFill.BackgroundColor3 = DoorColor
        ProgressFill.BackgroundTransparency = math.clamp(0.1 + TimerTransparency * 0.8, 0, 1)
        ProgressFill.BorderSizePixel = 0
        ProgressFill.Size = UDim2_new(0, 0, 1, 0)
        ProgressFill.ZIndex = 2
        ProgressFill.Text = ""
        ProgressFill.Parent = ProgressBox
        local PercentageBox = Instance_new("TextLabel")
        PercentageBox.Name = "PercentageBox"
        PercentageBox.AnchorPoint = Vector2.new(0.5, 0)
        PercentageBox.BackgroundTransparency = 1
        PercentageBox.Position = UDim2_new(0.5, 0, 0.45, 0)
        PercentageBox.Size = UDim2_new(0.7, 0, 0.1, 0)
        PercentageBox.SizeConstraint = Enum.SizeConstraint.RelativeYY
        PercentageBox.Text = "0.0%"
        PercentageBox.TextColor3 = DoorColor
        PercentageBox.TextTransparency = TimerTransparency
        PercentageBox.TextScaled = true
        PercentageBox.Parent = BillboardGui
        local PlayerNameLabel = Instance_new("TextLabel")
        PlayerNameLabel.Name = "PlayerNameLabel"
        PlayerNameLabel.AnchorPoint = Vector2.new(0.5, 0)
        PlayerNameLabel.BackgroundTransparency = 1
        PlayerNameLabel.Position = UDim2_new(0.5, 0, 0.3, 0)
        PlayerNameLabel.Size = UDim2_new(0.7, 0, 0.12, 0)
        PlayerNameLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
        PlayerNameLabel.Text = ""
        PlayerNameLabel.TextColor3 = DoorColor
        PlayerNameLabel.TextTransparency = TimerTransparency
        PlayerNameLabel.TextScaled = true
        PlayerNameLabel.TextStrokeTransparency = 0.5
        PlayerNameLabel.Parent = BillboardGui
    end
    local function updateDoorUI(door, progress, timeRemaining)
        local gui = door:FindFirstChild("BillboardGui")
        if not gui then return end
        local ProgressBox = gui:FindFirstChild("ProgressBox")
        local ProgressFill = ProgressBox and ProgressBox:FindFirstChild("ProgressFill")
        local PercentageBox = gui:FindFirstChild("PercentageBox")
        local PlayerNameLabel = gui:FindFirstChild("PlayerNameLabel")
        if not ProgressBox or not ProgressFill or not PercentageBox then return end
        progress = math_clamp(progress or 0, 0, 1)
        local percentageText = string_format("%.1f%%", progress * 100)
        if displaySeconds and timeRemaining and timeRemaining > 0 then PercentageBox.Text = percentageText.. " | ".. string_format("%.1fs", timeRemaining) else PercentageBox.Text = percentageText end
        local data = getgenv().DoorProgressData[door]
        if PlayerNameLabel and data then PlayerNameLabel.Text = displayOpener and data.playerName ~= "" and data.playerName or "" end
        local targetSize = UDim2_new(progress, 0, 1, 0)
        if ProgressFill.Size ~= targetSize then TweenService:Create(ProgressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play() end
    end
    local function checkDoorStates()
        for door, data in pairs(getgenv().DoorProgressData) do
            if door and door.Parent then
                local locked = isDoorLocked(door)
                if data.playerName == "" then
                    local newProgress = locked and 0 or 1
                    if data.progress ~= newProgress then data.progress = newProgress data.timeRemaining = nil updateDoorUI(door, newProgress, nil) end
                end
            end
        end
    end
    function setupDoors()
        getgenv().DoorsList = {}
        getgenv().DoorProgressData = {}
        local currentMap = getmap()
        if currentMap then for _, v in pairs(currentMap:GetDescendants()) do local name = v.Name:lower() if (name == "singledoor" or name == "doubledoor") and isValidDoor(v) then table.insert(getgenv().DoorsList, v) getgenv().DoorProgressData[v] = {progress = 0, playerName = "", lastProgress = 0, lastUpdateTime = tick(), timeRemaining = nil, tween = nil} createUIForDoor(v) updateDoorUI(v, 0, nil) end end end
    end
    function startTracker()
        if getgenv().DoorTrackerConn then return end
        getgenv().DoorTrackerConn = RunService.Heartbeat:Connect(function()
            if not enabled then return end
            if tick() - lastUpdate < 0.1 then return end
            lastUpdate = tick()
            local activeDoors = {}
            local players = Players:GetPlayers()
            for i = 1, #players do
                local plr = players[i]
                local character = plr.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local stats = plr:FindFirstChild("TempPlayerStatsModule")
                    if stats then
                        local progressVal = stats:FindFirstChild("ActionProgress")
                        local ragdollVal = stats:FindFirstChild("Ragdoll")
                        local progress = progressVal and progressVal.Value or 0
                        if progress > 0 and not (ragdollVal and ragdollVal.Value) then
                            local playerPosition = character.HumanoidRootPart.Position
                            local nearestDoor, doorDistance = findNearestObject(playerPosition, getgenv().DoorsList)
                            if nearestDoor and doorDistance < 8 then
                                local data = getgenv().DoorProgressData[nearestDoor]
                                if data then
                                    if progress > 0 and (data.progress < 1 or data.progress > 0) then
                                        local currentTime = tick()
                                        local deltaProgress = progress - data.lastProgress
                                        local timeSinceLastUpdate = currentTime - data.lastUpdateTime
                                        local timeRemaining = nil
                                        if deltaProgress > 0 and timeSinceLastUpdate > 0 then timeRemaining = (1 - progress) / (deltaProgress / timeSinceLastUpdate) else timeRemaining = (1 - progress) * 1.5 end
                                        data.progress = progress data.playerName = plr.Name data.timeRemaining = timeRemaining data.lastProgress = progress data.lastUpdateTime = currentTime
                                        updateDoorUI(nearestDoor, progress, timeRemaining)
                                        activeDoors[nearestDoor] = true
                                    end
                                end
                            end
                        end
                    end
                end
            end
            for door, data in pairs(getgenv().DoorProgressData) do
                if not activeDoors[door] then
                    if data.playerName ~= "" then data.playerName = "" updateDoorUI(door, data.progress, nil) end
                    if isDoorLocked(door) and data.progress > 0 and data.progress < 1 then data.progress = 0 data.timeRemaining = nil updateDoorUI(door, 0, nil)
                    elseif not isDoorLocked(door) then data.progress = 1 updateDoorUI(door, 1, nil) end
                end
            end
            checkDoorStates()
        end)
        if getgenv().DoorMapChangedConn then getgenv().DoorMapChangedConn:Disconnect() end
        getgenv().DoorMapChangedConn = map.Changed:Connect(function() task.wait(2) if enabled then setupDoors() end end)
    end
end

do
    local _G_Life = false
    local _G_LifeC = {}
    local LP = Players.LocalPlayer
    local function disconnectAll() for _, c in ipairs(_G_LifeC) do pcall(function() c:Disconnect() end) end table.clear(_G_LifeC) end
    local function clearAllTags()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") if head then local tag = head:FindFirstChild("LifeTag") if tag then tag:Destroy() end end end
        end
    end
    local function beast(p) local s = p:FindFirstChild("TempPlayerStatsModule", true) local v = s and s:FindFirstChild("IsBeast") return v and v.Value end
    local function color(v)
        if v >= 400 then return LifeColor
        elseif v >= 200 then return LifeColor:Lerp(Color3.fromRGB(255,210,80), 0.5)
        else return Color3.fromRGB(255,80,80) end
    end
    OnLifeColorChanged = function(c)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") if head then local tag = head:FindFirstChild("LifeTag") if tag then local t = tag:FindFirstChildOfClass("TextLabel") if t and t.Text ~= "000s" then t.TextColor3 = c end end end end
        end
    end
    local prevLifeTransp = OnTimerTransparencyChanged
    OnTimerTransparencyChanged = function(t)
        if prevLifeTransp then prevLifeTransp(t) end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") if head then local tag = head:FindFirstChild("LifeTag") if tag then local txt = tag:FindFirstChildOfClass("TextLabel") if txt then txt.TextTransparency = t end end end end
        end
    end
    local function createTag(char, player)
        if not _G_Life or player == LP then return end
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not head or head:FindFirstChild("LifeTag") then return end
        local stats = player:FindFirstChild("TempPlayerStatsModule", true)
        local hp = stats and stats:FindFirstChild("Health")
        if not hp then return end
        local gui = Instance.new("BillboardGui")
        gui.Name = "LifeTag"
        gui.Size = UDim2.new(0, 60, 0, 20)
        gui.StudsOffset = Vector3.new(0, 3, 0)
        gui.AlwaysOnTop = true
        gui.Parent = head
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextScaled = true
        text.Font = Enum.Font.Arcade
        text.TextStrokeTransparency = 0.4
        text.TextTransparency = TimerTransparency
        text.Parent = gui
        local smooth = 500
        local conn = RunService.RenderStepped:Connect(function(dt)
            if not _G_Life or not char.Parent then gui:Destroy() return end
            if beast(player) then text.Text = "000s" text.TextColor3 = Color3.fromRGB(255,0,0) smooth = 500 return end
            local target = math.floor(math.clamp(hp.Value, 0, 100) / 100 * 500)
            smooth += (target - smooth) * math.clamp(dt * 8, 0, 1)
            local v = math.floor(smooth + 0.5)
            text.Text = v.. "s"
            text.TextColor3 = color(v)
        end)
        table.insert(_G_LifeC, conn)
    end
    local function hookPlayer(p)
        table.insert(_G_LifeC, p.CharacterAdded:Connect(function(c) task.wait(0.3) if _G_Life then createTag(c, p) end end))
        if p.Character and _G_Life then createTag(p.Character, p) end
    end
    CreateToggle(content1P, "Life Timer", false, function(v)
        _G_Life = v
        disconnectAll()
        clearAllTags()
        if not v then return end
        for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
        table.insert(_G_LifeC, Players.PlayerAdded:Connect(hookPlayer))
        task.spawn(function()
            while _G_Life do
                task.wait(2)
                if not _G_Life then break end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Character then local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart") if head and not head:FindFirstChild("LifeTag") then createTag(p.Character, p) end end
                end
            end
        end)
    end)
end

    do
        local walkEnabled = false
        local connections = {}
        local localPlayer = Players.LocalPlayer
        OnWalkspeedColorChanged = function(c)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then local head = plr.Character:FindFirstChild("Head") if head then local tag = head:FindFirstChild("SpeedTag") if tag then local l = tag:FindFirstChildOfClass("TextLabel") if l then l.TextColor3 = c end end end end
            end
        end
        local prevWalkTransp = OnTimerTransparencyChanged
        OnTimerTransparencyChanged = function(t)
            if prevWalkTransp then prevWalkTransp(t) end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then local head = plr.Character:FindFirstChild("Head") if head then local tag = head:FindFirstChild("SpeedTag") if tag then local l = tag:FindFirstChildOfClass("TextLabel") if l then l.TextTransparency = t end end end end
            end
        end
        CreateToggle(content1P, "Walkspeed", false, function(Value)
            walkEnabled = Value
            if not Value then
                for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
                table.clear(connections)
                for _, plr in ipairs(Players:GetPlayers()) do local head = plr.Character and plr.Character:FindFirstChild("Head") if head then local tag = head:FindFirstChild("SpeedTag") if tag then tag:Destroy() end end end
                return
            end
            table.clear(connections)
            local function createSpeedTag(character)
                if not walkEnabled then return end
                local player = Players:GetPlayerFromCharacter(character)
                if player == localPlayer then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local head = character:FindFirstChild("Head")
                if not humanoid or not head or head:FindFirstChild("SpeedTag") then return end
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "SpeedTag"
                billboard.Size = UDim2.new(0, 50, 0, 25)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = head
                billboard.Parent = head
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = WalkspeedColor
                label.TextTransparency = TimerTransparency
                label.TextStrokeTransparency = 0.3
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.Parent = billboard
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not walkEnabled or not character.Parent or not humanoid then conn:Disconnect() billboard:Destroy() return end
                    local speed = humanoid.WalkSpeed
                    label.Text = humanoid.MoveDirection.Magnitude > 0 and tostring(math.floor(speed)) or "0"
                end)
                table.insert(connections, conn)
            end
            local function monitorPlayer(plr)
                local c1 = plr.CharacterAdded:Connect(function(char) task.wait(0.5) createSpeedTag(char) end)
                table.insert(connections, c1)
                if plr.Character then createSpeedTag(plr.Character) end
            end
            for _, plr in ipairs(Players:GetPlayers()) do monitorPlayer(plr) end
            local c2 = Players.PlayerAdded:Connect(monitorPlayer)
            table.insert(connections, c2)
            task.spawn(function()
                while walkEnabled do
                    task.wait(2)
                    for _, plr in ipairs(Players:GetPlayers()) do if plr.Character then createSpeedTag(plr.Character) end end
                end
            end)
        end)
    end

    do
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer
        local E = { LP = LP, DURATION = 27.7, enabled = false, playerUI = {}, nameTags = {}, countdownTags = {}, uiOffset = 70, connections = {} }
        local function GetSmoothColor(timeLeft)
            local percent = math.clamp(timeLeft / E.DURATION, 0, 1)
            return GetUpColor:Lerp(Color3.fromRGB(255, 0, 0), 1 - percent)
        end
        OnGetUpColorChanged = function(c)
            for _, data in pairs(E.playerUI) do if data.timerLabel then data.timerLabel.TextColor3 = c end end
            for _, gui in pairs(E.countdownTags) do local l = gui:FindFirstChild("CountdownLabel") if l then l.TextColor3 = c end end
        end
        OnIndicatorTransparencyChanged = function(t)
            for _, data in pairs(E.playerUI) do if data.timerLabel then data.timerLabel.TextTransparency = t end end
            for _, gui in pairs(E.countdownTags) do local l = gui:FindFirstChild("CountdownLabel") if l then l.TextTransparency = t end end
        end
        local function createNameTag(player, head)
            if E.nameTags[player] then E.nameTags[player]:Destroy() end
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "SurvivorNameTag"
            billboardGui.AlwaysOnTop = true
            billboardGui.Size = UDim2.new(4, 0, 1, 0)
            billboardGui.StudsOffset = Vector3.new(0, 4.5, 0)
            billboardGui.Parent = head
            local label = Instance.new("TextLabel")
            label.Name = "NameLabel"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextStrokeTransparency = 1
            label.Text = player.Name
            label.Parent = billboardGui
            local stroke = Instance.new("UIStroke", label)
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 2
            E.nameTags[player] = billboardGui
            return billboardGui
        end
        local function removeNameTag(player) if E.nameTags[player] then E.nameTags[player]:Destroy() E.nameTags[player] = nil end end
        local function createCountdownLabel(player, head)
            if E.countdownTags[player] then E.countdownTags[player]:Destroy() end
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "RagdollCountdown"
            billboardGui.AlwaysOnTop = true
            billboardGui.Size = UDim2.new(3, 0, 1, 0)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.Parent = head
            local label = Instance.new("TextLabel")
            label.Name = "CountdownLabel"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.TextColor3 = GetUpColor
            label.TextTransparency = IndicatorTransparency
            label.TextStrokeTransparency = 1
            label.Text = string.format("%.3f", E.DURATION)
            label.Parent = billboardGui
            local stroke = Instance.new("UIStroke", label)
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 2
            E.countdownTags[player] = billboardGui
            return billboardGui, label
        end
        local function removeCountdownLabel(player) if E.countdownTags[player] then E.countdownTags[player]:Destroy() E.countdownTags[player] = nil end end
        local function RepositionBottomUIs()
            local index = 0
            for _, data in pairs(E.playerUI) do if data.frame and data.frame.Parent then data.frame.Position = UDim2.new(1, -260, 1, -90 - (index * E.uiOffset)) index += 1 end end
        end
        local function removeBottomRightUI(player)
            if E.playerUI[player] then if E.playerUI[player].connection then E.playerUI[player].connection:Disconnect() end E.playerUI[player].screenGui:Destroy() E.playerUI[player] = nil RepositionBottomUIs() end
        end
        local function updateBottomRightUI(player, endTime)
            if player == E.LP then return end
            if E.playerUI[player] then return end
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "RagdollUI_".. player.Name
            screenGui.ResetOnSpawn = false
            screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            screenGui.Parent = E.LP:WaitForChild("PlayerGui")
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 240, 0, 70)
            frame.BackgroundTransparency = 1
            frame.Parent = screenGui
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextSize = 24
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.TextStrokeTransparency = 1
            nameLabel.TextXAlignment = Enum.TextXAlignment.Right
            nameLabel.Text = player.Name
            nameLabel.Parent = frame
            local nameStroke = Instance.new("UIStroke", nameLabel)
            nameStroke.Color = Color3.fromRGB(0, 0, 0)
            nameStroke.Thickness = 2
            local timerLabel = Instance.new("TextLabel")
            timerLabel.Size = UDim2.new(1, 0, 0.6, 0)
            timerLabel.Position = UDim2.new(0, 0, 0.4, 0)
            timerLabel.BackgroundTransparency = 1
            timerLabel.TextSize = 36
            timerLabel.Font = Enum.Font.GothamBold
            timerLabel.TextColor3 = GetUpColor
            timerLabel.TextTransparency = IndicatorTransparency
            timerLabel.TextStrokeTransparency = 1
            timerLabel.TextXAlignment = Enum.TextXAlignment.Right
            timerLabel.Text = string.format("%.3f", E.DURATION)
            timerLabel.Parent = frame
            local timerStroke = Instance.new("UIStroke", timerLabel)
            timerStroke.Color = Color3.fromRGB(0, 0, 0)
            timerStroke.Thickness = 2.5
            local count = 0
            for _ in pairs(E.playerUI) do count += 1 end
            frame.Position = UDim2.new(1, -260, 1, -90 - (count * E.uiOffset))
            local renderSteppedConnection
            renderSteppedConnection = RunService.RenderStepped:Connect(function()
                if not E.enabled then removeBottomRightUI(player) return end
                local secondsLeft = endTime - tick()
                if secondsLeft < 0 or not player.Parent then removeBottomRightUI(player)
                else timerLabel.Text = string.format("%.3f", secondsLeft) timerLabel.TextColor3 = GetSmoothColor(secondsLeft) end
            end)
            E.playerUI[player] = {screenGui = screenGui, frame = frame, timerLabel = timerLabel, connection = renderSteppedConnection}
        end
        local function startRagdollCountdown(player, ragdoll)
            local character = player.Character or player.CharacterAdded:Wait()
            local head = character:FindFirstChild("Head")
            if not head then return end
            removeCountdownLabel(player)
            local _, label = createCountdownLabel(player, head)
            createNameTag(player, head)
            local endTime = tick() + E.DURATION
            local renderSteppedConnection
            renderSteppedConnection = RunService.RenderStepped:Connect(function()
                if not ragdoll.Value or not player.Parent or not E.enabled then removeCountdownLabel(player) removeNameTag(player) renderSteppedConnection:Disconnect() return end
                local secondsLeft = endTime - tick()
                if secondsLeft < 0 then removeCountdownLabel(player) removeNameTag(player) renderSteppedConnection:Disconnect()
                else label.Text = string.format("%.3f", secondsLeft) label.TextColor3 = GetSmoothColor(secondsLeft) end
            end)
            if E.LP ~= player then updateBottomRightUI(player, endTime) end
        end
        local function onRagdollChanged(player)
            local tempStats = player:WaitForChild("TempPlayerStatsModule")
            local ragdoll = tempStats:WaitForChild("Ragdoll")
            local conn = ragdoll.Changed:Connect(function()
                if not E.enabled then return end
                local character = player.Character or player.CharacterAdded:Wait()
                local head = character:FindFirstChild("Head")
                if not head then return end
                if ragdoll.Value then startRagdollCountdown(player, ragdoll)
                else removeBottomRightUI(player) removeNameTag(player) removeCountdownLabel(player) end
            end)
            table.insert(E.connections, conn)
            local charRemoving = player.CharacterRemoving:Connect(function() removeNameTag(player) removeCountdownLabel(player) removeBottomRightUI(player) end)
            table.insert(E.connections, charRemoving)
        end
        local function CleanupAll()
            for _, conn in ipairs(E.connections) do pcall(function() conn:Disconnect() end) end
            table.clear(E.connections)
            for player, _ in pairs(E.playerUI) do removeBottomRightUI(player) end
            for player, _ in pairs(E.nameTags) do removeNameTag(player) end
            for player, _ in pairs(E.countdownTags) do removeCountdownLabel(player) end
        end
        local function Init()
            for _, player in ipairs(Players:GetPlayers()) do if player.Character then onRagdollChanged(player) else player.CharacterAdded:Connect(function() onRagdollChanged(player) end) end end
            local added = Players.PlayerAdded:Connect(function(player) player.CharacterAdded:Connect(function() onRagdollChanged(player) end) end)
            table.insert(E.connections, added)
        end
        CreateToggle(content2P, "GetUp Timer", false, function(Value) E.enabled = Value if Value then Init() else CleanupAll() end end)
    end

    do
        local beastEnabled = false
        local loopThread = nil
        local CoreGui = game:GetService("CoreGui")
        local currentLabel = nil
        OnBeastPowerColorChanged = function(c) if currentLabel then currentLabel.TextColor3 = c end end
        local prevBeastTransp = OnIndicatorTransparencyChanged
        OnIndicatorTransparencyChanged = function(t)
            if prevBeastTransp then prevBeastTransp(t) end
            if currentLabel then currentLabel.TextTransparency = t currentLabel.BackgroundTransparency = math.clamp(0.35 + t * 0.5, 0, 1) end
        end
        CreateToggle(content2P, "Beast Power", false, function(Value)
            beastEnabled = Value
            if not Value then
                if loopThread then task.cancel(loopThread) loopThread = nil end
                local old = CoreGui:FindFirstChild("BeastPowerGui")
                if old then old:Destroy() end
                currentLabel = nil
                return
            end
            local old = CoreGui:FindFirstChild("BeastPowerGui")
            if old then old:Destroy() end
            local gui = Instance.new("ScreenGui")
            gui.Name = "BeastPowerGui"
            gui.ResetOnSpawn = false
            gui.Parent = CoreGui
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0, 200, 0, 20)
            label.Position = UDim2.new(0.5, -100, 0.83, 0)
            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.BackgroundTransparency = math.clamp(0.35 + IndicatorTransparency * 0.5, 0, 1)
            label.TextTransparency = IndicatorTransparency
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Text = ""
            label.TextColor3 = BeastPowerColor
            label.Parent = gui
            currentLabel = label
            local function getBeast()
                for _,p in ipairs(Players:GetPlayers()) do local char = p.Character local bp = char and char:FindFirstChild("BeastPowers") if bp then return bp end end
                return nil
            end
            loopThread = task.spawn(function()
                local readyShown = false
                while beastEnabled do
                    task.wait(0.2)
                    local bp = getBeast()
                    if not bp then gui.Enabled = false readyShown = false
                    else
                        gui.Enabled = true
                        local percent = bp:FindFirstChild("PowerProgressPercent")
                        if percent then
                            local value = math.floor(percent.Value * 100)
                            if value >= 100 then
                                if not readyShown then label.TextColor3 = Color3.fromRGB(0, 255, 0) label.Text = "BeastPower is Full" readyShown = true end
                            else
                                label.TextColor3 = BeastPowerColor
                                label.Text = "BeastPower Back In: ".. value.. "%"
                                readyShown = false
                            end
                        end
                    end
                end
            end)
        end)
    end

    do
        local _G_BeastPower2_Session = 0
        local _G_BeastPower2_Connections = {}
        local running = false
        local function disconnectAll() for _, c in ipairs(_G_BeastPower2_Connections) do pcall(function() c:Disconnect() end) end _G_BeastPower2_Connections = {} end
        local function clearAll()
            for _, plr in ipairs(Players:GetPlayers()) do local char = plr.Character local head = char and char:FindFirstChild("Head") if head then local g = head:FindFirstChild("RP") if g then g:Destroy() end end end
        end
        local function mkBBG(head)
            if head:FindFirstChild("RP") then return end
            local g = Instance.new("BillboardGui")
            g.Name = "RP"
            g.Size = UDim2.new(0, 80, 0, 20)
            g.StudsOffset = Vector3.new(0, 3, 0)
            g.AlwaysOnTop = true
            g.Parent = head
            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.TextColor3 = BeastPowerV2Color
            l.TextTransparency = IndicatorTransparency
            l.TextScaled = false
            l.TextSize = 11
            l.Font = Enum.Font.GothamBold
            l.Text = "0%"
            l.Parent = g
        end
        local function rmBBG(head) local g = head and head:FindFirstChild("RP") if g then g:Destroy() end end
        OnBeastPowerV2ColorChanged = function(c)
            for _, plr in ipairs(Players:GetPlayers()) do local char = plr.Character local head = char and char:FindFirstChild("Head") if head then local g = head:FindFirstChild("RP") if g then local l = g:FindFirstChildOfClass("TextLabel") if l and l.Text ~= "Full" then l.TextColor3 = c end end end end
        end
        local prevV2Transp = OnIndicatorTransparencyChanged
        OnIndicatorTransparencyChanged = function(t)
            if prevV2Transp then prevV2Transp(t) end
            for _, plr in ipairs(Players:GetPlayers()) do local char = plr.Character local head = char and char:FindFirstChild("Head") if head then local g = head:FindFirstChild("RP") if g then local l = g:FindFirstChildOfClass("TextLabel") if l then l.TextTransparency = t end end end end
        end
        local function setupCharacter(char)
            if not running then return end
            table.insert(_G_BeastPower2_Connections, char.ChildAdded:Connect(function(child) if child.Name == "BeastPowers" then local head = char:FindFirstChild("Head") if head then mkBBG(head) end end end))
            table.insert(_G_BeastPower2_Connections, char.ChildRemoved:Connect(function(child) if child.Name == "BeastPowers" then local head = char:FindFirstChild("Head") if head then rmBBG(head) end end end))
            table.insert(_G_BeastPower2_Connections, RunService.Heartbeat:Connect(function()
                if not running then return end
                local head = char:FindFirstChild("Head")
                local bp = char:FindFirstChild("BeastPowers")
                if not head then return end
                if not bp then rmBBG(head) return end
                local g = head:FindFirstChild("RP") or mkBBG(head)
                local v = bp:FindFirstChild("PowerProgressPercent")
                if g then
                    local label = g:FindFirstChildOfClass("TextLabel")
                    if label and v then
                        local value = math.clamp(v.Value * 100, 0, 100)
                        if value >= 100 then label.Text = "Full" label.TextColor3 = Color3.fromRGB(0, 255, 0)
                        else label.Text = tostring(math.floor(value)).. "%" label.TextColor3 = BeastPowerV2Color end
                    end
                end
            end))
        end
        CreateToggle(content2P, "Beast Power V2", false, function(Value)
            _G_BeastPower2_Session += 1
            disconnectAll()
            clearAll()
            running = Value
            if not Value then return end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then setupCharacter(plr.Character) end
                table.insert(_G_BeastPower2_Connections, plr.CharacterAdded:Connect(function(char) task.wait(1) setupCharacter(char) end))
            end
            table.insert(_G_BeastPower2_Connections, Players.PlayerAdded:Connect(function(plr) table.insert(_G_BeastPower2_Connections, plr.CharacterAdded:Connect(function(char) task.wait(1) setupCharacter(char) end)) end))
        end)
    end

    do
        local CoreGui = game:GetService("CoreGui")
        local LP = Players.LocalPlayer
        local _G_BTC = nil
        local _G_BCC = nil
        local currentSpawnLabel = nil
        OnBeastSpawnColorChanged = function(c) if currentSpawnLabel then currentSpawnLabel.TextColor3 = c end end
        local prevSpawnTransp = OnIndicatorTransparencyChanged
        OnIndicatorTransparencyChanged = function(t)
            if prevSpawnTransp then prevSpawnTransp(t) end
            if currentSpawnLabel then currentSpawnLabel.TextTransparency = t end
        end
        local function disconnectAll() if _G_BTC then pcall(function() _G_BTC:Disconnect() end) end if _G_BCC then pcall(function() _G_BCC:Disconnect() end) end end
        CreateToggle(content2P, "Beast Spawn Timer", false, function(v)
            disconnectAll()
            local old = CoreGui:FindFirstChild("BeastTimerGui")
            if old then old:Destroy() end
            currentSpawnLabel = nil
            if not v then return end
            local gui = Instance.new("ScreenGui")
            gui.Name = "BeastTimerGui"
            gui.DisplayOrder = 999
            gui.Parent = CoreGui
            local label = Instance.new("TextLabel")
            label.AnchorPoint = Vector2.new(0.5, 0.5)
            label.Position = UDim2.new(0.5, 0, 0.5, 0)
            label.Size = UDim2.new(0, 320, 0, 70)
            label.BackgroundTransparency = 1
            label.TextSize = 34
            label.Font = Enum.Font.SpecialElite
            label.TextStrokeTransparency = 0.2
            label.TextStrokeColor3 = Color3.fromRGB(120, 0, 0)
            label.Text = ""
            label.TextColor3 = BeastSpawnColor
            label.TextTransparency = IndicatorTransparency
            label.Visible = false
            label.Parent = gui
            currentSpawnLabel = label
            local function drip(text, color)
                for i = 1, math.random(2, 4) do
                    local d = label:Clone()
                    d.Parent = gui
                    d.Text = text
                    d.TextColor3 = color
                    d.Position = label.Position + UDim2.new(0, math.random(-6, 6), 0, 0)
                    game:GetService("TweenService"):Create(d, TweenInfo.new(0.8), { Position = d.Position + UDim2.new(0, 0, 0, math.random(35, 60)), TextTransparency = 1 }):Play()
                    game:GetService("Debris"):AddItem(d, 1)
                end
            end
            local lastPos = nil
            local active = false
            local timeLeft = 0
            local TELEPORT = 20
            local DURATION = 16
            local function isBeast()
                local stats = LP:FindFirstChild("TempPlayerStatsModule")
                if not stats then return false end
                local ok, mod = pcall(require, stats)
                return ok and mod and mod.IsBeast
            end
            _G_BTC = RunService.Heartbeat:Connect(function(dt)
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if isBeast() then label.Visible = false active = false return end
                if lastPos and not active and (hrp.Position - lastPos).Magnitude > TELEPORT then active = true timeLeft = DURATION label.Visible = true end
                lastPos = hrp.Position
                if active then
                    timeLeft -= dt
                    if timeLeft <= 0 then
                        active = false
                        label.Text = "The Beast is here..."
                        label.TextSize = 28
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.Visible = true
                        game:GetService("TweenService"):Create(label, TweenInfo.new(1), {TextTransparency = 0}):Play()
                        task.spawn(function() for i = 1, 25 do drip(label.Text, Color3.fromRGB(180, 0, 0)) task.wait(0.1) end end)
                        task.delay(3.5, function() if not active then label.Visible = false end end)
                    else
                        local color = timeLeft <= 5 and Color3.fromRGB(255, 60, 60) or BeastSpawnColor
                        label.TextColor3 = color
                        label.Text = string.format("%.2f", timeLeft)
                        if timeLeft <= 5 and math.random() < 0.6 then drip(label.Text, color) end
                    end
                end
            end)
            _G_BCC = LP.CharacterAdded:Connect(function() active = false lastPos = nil label.Visible = false end)
        end)
    end
end

do
    local settingsPageH = pages["Textures"]
    local L = game:GetService("Lighting")
    local R = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Name = "Columns"
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    Instance.new("UIPadding", columnsH).PaddingTop = UDim.new(0, 10)

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Name = "LeftCol"
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Name = "RightCol"
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local function CreateGroupbox(parent, title)
        local groupbox = Instance.new("Frame")
        groupbox.Size = UDim2.new(1, 0, 0, 0)
        groupbox.AutomaticSize = Enum.AutomaticSize.Y
        groupbox.BackgroundColor3 = Color3.fromRGB(0, 0, 00)
        groupbox.BackgroundTransparency = 0.7
        groupbox.Parent = parent
        Instance.new("UICorner", groupbox).CornerRadius = UDim.new(0, 8)

        local groupboxStroke = Instance.new("UIStroke", groupbox)
        groupboxStroke.Color = Color3.fromRGB(0, 0, 0)
        groupboxStroke.Thickness = 1
        groupboxStroke.Transparency = 0.2

        local header = Instance.new("Frame", groupbox)
        header.Size = UDim2.new(1, 0, 0, 35)
        header.BackgroundTransparency = 1

        local titleLabel = Instance.new("TextLabel", header)
        titleLabel.Size = UDim2.new(1, -30, 1, 0)
        titleLabel.Position = UDim2.new(0, 22, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 13
        titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local divider = Instance.new("Frame", groupbox)
        divider.Size = UDim2.new(1, -24, 0, 1)
        divider.Position = UDim2.new(0, 12, 0, 35)
        divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        divider.BackgroundTransparency = 0.3
        divider.BorderSizePixel = 0

        local contentFrame = Instance.new("Frame", groupbox)
        contentFrame.Size = UDim2.new(1, -24, 0, 0)
        contentFrame.Position = UDim2.new(0, 12, 0, 45)
        contentFrame.BackgroundTransparency = 1
        contentFrame.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UIListLayout", contentFrame).Padding = UDim.new(0, 8)
        Instance.new("UIPadding", contentFrame).PaddingBottom = UDim.new(0, 12)

        return groupbox, contentFrame
    end

    local function CreateToggle(parent, text, default, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(1, 0, 0, 22)
        toggleFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", toggleFrame)
        toggle.Size = UDim2.new(0, 40, 0, 18)
        toggle.Position = UDim2.new(1, -40, 0.5, -9)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggle.BackgroundTransparency = default and 0 or 1
        toggle.Text = ""
        toggle.AutoButtonColor = false
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke", toggle)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5
        stroke.Transparency = 0

        local circle = Instance.new("Frame", toggle)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = default and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = enabled and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = enabled and 0 or 1
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {
                Color = Color3.fromRGB(255, 255, 255)
            }):Play()
            if callback then callback(enabled) end
        end)
        return toggleFrame
    end

    do
        local boxTextures, contentTextures = CreateGroupbox(leftColH, "Map Textures")
        boxTextures.BackgroundTransparency = 1
        boxTextures.BorderSizePixel = 0
        boxTextures.Size = UDim2.new(1,0,0)
        boxTextures.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", boxTextures).CornerRadius = UDim.new(0,8)
        Instance.new("UIStroke", boxTextures).Color = Color3.fromRGB(70,70,70)
        Instance.new("UIListLayout", contentTextures).Padding = UDim.new(0, 8)

        do
            local originalParts = {}
            local function salvarOriginal()
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not originalParts[part] then
                        originalParts[part] = {Material = part.Material, Color = part.Color}
                    end
                end
            end
            local function aplicarTijolos()
                salvarOriginal()
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Material = Enum.Material.Brick
                        part.Color = Color3.fromRGB(255,255,255)
                    end
                end
            end
            local function restaurarTijolos()
                for part, data in pairs(originalParts) do
                    if part and part.Parent then
                        part.Material = data.Material
                        part.Color = data.Color
                    end
                end
                table.clear(originalParts)
            end
            CreateToggle(contentTextures, "White Bricks", false, function(enabled)
                if enabled then aplicarTijolos() else restaurarTijolos() end
            end)
        end

        do
            local originalPartsSnow = {}
            local IgnoreNames = {ComputerTable = true, ExitDoor = true}
            local function salvarOriginalSnow()
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Anchored and not IgnoreNames[part.Name] and not originalPartsSnow[part] then
                        originalPartsSnow[part] = {Material = part.Material, Color = part.Color}
                    end
                end
            end
            local function aplicarSnow()
                salvarOriginalSnow()
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and part.Anchored and not IgnoreNames[part.Name] then
                        part.Material = Enum.Material.Snow
                        part.Color = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
            local function restaurarSnow()
                for part, data in pairs(originalPartsSnow) do
                    if part and part.Parent then
                        part.Material = data.Material
                        part.Color = data.Color
                    end
                end
                table.clear(originalPartsSnow)
            end
            CreateToggle(contentTextures, "Snow Map", false, function(enabled)
                if enabled then aplicarSnow() else restaurarSnow() end
            end)
        end

        do
            local originalPartsRemove = {}
            local removedInstances = {}
            local function salvarOriginalRemove()
                for _, part in ipairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and not originalPartsRemove[part] then
                        originalPartsRemove[part] = {Material = part.Material, Reflectance = part.Reflectance}
                    end
                end
            end
            local function aplicarRemoveTexture()
                salvarOriginalRemove()
                for _, item in pairs(workspace:GetDescendants()) do
                    if item:IsA("Texture") or item:IsA("Decal") then
                        pcall(function()
                            item:SetAttribute("OriginalParent", item.Parent)
                            item.Parent = nil
                            table.insert(removedInstances, item)
                        end)
                    elseif item:IsA("BasePart") then
                        pcall(function()
                            item.Reflectance = 0
                            item.Material = Enum.Material.SmoothPlastic
                        end)
                    end
                end
            end
            local function restaurarRemoveTexture()
                for part, data in pairs(originalPartsRemove) do
                    if part and part.Parent then
                        part.Material = data.Material
                        part.Reflectance = data.Reflectance
                    end
                end
                for _, instance in pairs(removedInstances) do
                    pcall(function()
                        instance.Parent = instance:GetAttribute("OriginalParent")
                    end)
                end
                table.clear(originalPartsRemove)
                table.clear(removedInstances)
            end
            CreateToggle(contentTextures, "Remove Textures", false, function(enabled)
                if enabled then aplicarRemoveTexture() else restaurarRemoveTexture() end
            end)
        end

        do
            local faces = {"Front", "Back", "Bottom", "Top", "Right", "Left"}
            local materials = {
                Wood = "3258599312", WoodPlanks = "8676581022",
                Brick = "8558400252", Cobblestone = "5003953441",
                Concrete = "7341687607", DiamondPlate = "6849247561",
                Fabric = "118776397", Granite = "4722586771",
                Grass = "4722588177", Ice = "3823766459",
                Marble = "62967586", Metal = "62967586",
                Sand = "152572215"
            }
            local tamanhoDoBloco = 4
            local originalData = {}
            local minecraftConnection
            local function processPart(part)
                if part:IsA("BasePart") then
                    local textureId = materials[part.Material.Name]
                    if textureId then
                        if not originalData[part] then
                            originalData[part] = {Material = part.Material}
                        end
                        for _, face in ipairs(faces) do
                            local newTexture = Instance.new("Texture")
                            newTexture.Name = "MinecraftTexture"
                            newTexture.Texture = "rbxassetid://".. textureId
                            newTexture.Face = Enum.NormalId[face]
                            newTexture.StudsPerTileU = tamanhoDoBloco
                            newTexture.StudsPerTileV = tamanhoDoBloco
                            newTexture.Color3 = part.Color
                            newTexture.Transparency = part.Transparency
                            newTexture.Parent = part
                        end
                        part.Material = Enum.Material.SmoothPlastic
                    end
                end
            end
            local function restoreParts()
                for part, data in pairs(originalData) do
                    if part and part.Parent then
                        part.Material = data.Material
                        for _, obj in ipairs(part:GetChildren()) do
                            if obj:IsA("Texture") and obj.Name == "MinecraftTexture" then
                                obj:Destroy()
                            end
                        end
                    end
                end
                originalData = {}
            end
            CreateToggle(contentTextures, "Minecraft Texture", false, function(enabled)
                if enabled then
                    for _, obj in ipairs(workspace:GetDescendants()) do processPart(obj) end
                    minecraftConnection = workspace.DescendantAdded:Connect(function(newObj)
                        task.defer(function() processPart(newObj) end)
                    end)
                else
                    if minecraftConnection then minecraftConnection:Disconnect() minecraftConnection = nil end
                    restoreParts()
                end
            end)
        end
    end

    local boxTexture, contentTexture = CreateGroupbox(leftColH, "Double Jump Effect")
    boxTexture.BackgroundColor3 = Color3.fromRGB(0,0,0)
    boxTexture.BackgroundTransparency = 1
    boxTexture.BorderSizePixel = 0
    boxTexture.Size = UDim2.new(1,0,0,300)
    Instance.new("UICorner", boxTexture).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxTexture).Color = Color3.fromRGB(70,70,70)

    local currentTexture, connection

    local function save(v)
        if not v:GetAttribute("OldTexture") then
            v:SetAttribute("OldTexture", v.Texture)
        end
    end

    local function applyAll()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                save(v)
                if currentTexture then v.Texture = currentTexture end
            end
        end
    end

    local function start()
        if connection then connection:Disconnect() end
        connection = workspace.DescendantAdded:Connect(function(v)
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                save(v)
                if currentTexture then v.Texture = currentTexture end
            end
        end)
    end

    local function restoreAll()
        if connection then connection:Disconnect() connection = nil end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                local old = v:GetAttribute("OldTexture")
                if old then v.Texture = old end
            end
        end
        currentTexture = nil
    end

    local inputHolder = Instance.new("Frame", contentTexture)
    inputHolder.Size = UDim2.new(1,0,0,28)
    inputHolder.BackgroundTransparency = 1

    local inputBox = Instance.new("TextBox", inputHolder)
    inputBox.Size = UDim2.new(1,-70,1,0)
    inputBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
    inputBox.BackgroundTransparency = 0.35
    inputBox.PlaceholderText = "Enter Texture ID..."
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 12
    inputBox.TextColor3 = Color3.fromRGB(235,235,235)
    inputBox.BorderSizePixel = 0
    inputBox.ClearTextOnFocus = false
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,6)

    local applyBtn = Instance.new("TextButton", inputHolder)
    applyBtn.Size = UDim2.new(0,65,1,0)
    applyBtn.Position = UDim2.new(1,-65,0,0)
    applyBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    applyBtn.BackgroundTransparency = 0
    applyBtn.Text = "Apply"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 12
    applyBtn.TextColor3 = Color3.fromRGB(235,235,235)
    applyBtn.BorderSizePixel = 0
    Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,6)

    applyBtn.MouseButton1Click:Connect(function()
        local id = inputBox.Text
        if id ~= "" then
            if not string.find(id, "rbxassetid://") then
                id = "rbxassetid://"..id
            end
            currentTexture = id
            applyAll()
            start()
        end
    end)

    local scrollFrame = Instance.new("ScrollingFrame", contentTexture)
    scrollFrame.Size = UDim2.new(1,0,1,-34)
    scrollFrame.Position = UDim2.new(0,0,0,34)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.BorderSizePixel = 0

    local gridLayout = Instance.new("UIGridLayout", scrollFrame)
    gridLayout.CellSize = UDim2.new(0,50,0,50)
    gridLayout.CellPadding = UDim2.new(0,6,0,6)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function createTextureButton(name, id, image)
        local btn = Instance.new("ImageButton", scrollFrame)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency = 0.35
        btn.BorderSizePixel = 0
        btn.Image = image or ""
        btn.LayoutOrder = name == "Default" and 0 or 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        if name == "Default" then
            local textLabel = Instance.new("TextLabel", btn)
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Default"
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 11
            textLabel.TextColor3 = Color3.fromRGB(235,235,235)
        end

        btn.MouseButton1Click:Connect(function()
            if name == "Default" then
                restoreAll()
            else
                currentTexture = id
                applyAll()
                start()
            end
            for _,v in pairs(scrollFrame:GetChildren()) do
                if v:IsA("ImageButton") then
                    TweenService:Create(v,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
                end
            end
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65)}):Play()
        end)
    end

    local textures = {
        {"Default", nil, ""},
        {"FacilityGamer Cat", "rbxassetid://98980064486234", "rbxassetid://98980064486234"},
        {"Nezuko", "rbxassetid://98285238714079", "rbxassetid://98285238714079"},
        {"Tanjiro", "rbxassetid://85372624608084", "rbxassetid://85372624608084"},
        {"Inosuke", "rbxassetid://97417889091578", "rbxassetid://97417889091578"},
        {"Earrings", "rbxassetid://129016541533877", "rbxassetid://129016541533877"},
        {"Bamboo", "rbxassetid://103861126846931", "rbxassetid://103861126846931"},
        {"Gengar", "rbxassetid://124320703202272", "rbxassetid://124320703202272"},
        {"Green Flame", "rbxassetid://125577376734114", "rbxassetid://125577376734114"},
        {"Hello Kitty", "rbxassetid://133484432928988", "rbxassetid://133484432928988"},
        {"Heart Minecraft", "rbxassetid://88121396536824", "rbxassetid://88121396536824"},
        {"Skeleton Army", "rbxassetid://88014445293756", "rbxassetid://88014445293756"},
        {"Pokemon", "rbxassetid://127357504054794", "rbxassetid://127357504054794"},
        {"Pikachu", "rbxassetid://112770541700961", "rbxassetid://112770541700961"},
        {"Pikachu Exe", "rbxassetid://85484998460643", "rbxassetid://85484998460643"},
        {"Sharingan", "rbxassetid://119906553877197", "rbxassetid://119906553877197"},
        {"Fire Skull", "rbxassetid://88821202537004", "rbxassetid://88821202537004"},
        {"Banana", "rbxassetid://78357281892162", "rbxassetid://78357281892162"},
        {"Beam", "rbxassetid://120302408630480", "rbxassetid://120302408630480"},
        {"Dragao", "rbxassetid://95322519251239", "rbxassetid://95322519251239"},
        {"Gengar2", "rbxassetid://85800788294484", "rbxassetid://85800788294484"},
        {"Little", "rbxassetid://91770326809398", "rbxassetid://91770326809398"},
        {"Melody", "rbxassetid://86299667519942", "rbxassetid://86299667519942"},
        {"Gray", "rbxassetid://76905368249152", "rbxassetid://76905368249152"},
        {"Sheep", "rbxassetid://75625272935607", "rbxassetid://75625272935607"}
    }

    for _, data in ipairs(textures) do
        createTextureButton(data[1], data[2], data[3])
    end

    local boxJump, contentJump = CreateGroupbox(leftColH, "Button Jump")
    boxJump.BackgroundTransparency = 1
    boxJump.BorderSizePixel = 0
    boxJump.Size = UDim2.new(1,0,0,0)
    boxJump.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxJump).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxJump).Color = Color3.fromRGB(70,70,70)

    getgenv().FTF_JumpSkinID = getgenv().FTF_JumpSkinID or nil
    local jumpConns = {}
    local originalJumpData = nil
    local forceApplyJump = false

    local function GetJumpButton()
        local touchGui = playerGui:FindFirstChild("TouchGui")
        if not touchGui then return nil end
        local touchControlFrame = touchGui:FindFirstChild("TouchControlFrame", true)
        if not touchControlFrame then return nil end
        return touchControlFrame:FindFirstChild("JumpButton")
    end

    local function saveOriginalJump()
        local btn = GetJumpButton()
        if btn and not originalJumpData then
            originalJumpData = {
                Image = btn.Image,
                ImageRectOffset = btn.ImageRectOffset,
                ImageRectSize = btn.ImageRectSize,
                Size = btn.Size,
                ImageTransparency = btn.ImageTransparency
            }
        end
    end

    local function forceApplyJumpSkin()
        local btn = GetJumpButton()
        if btn and getgenv().FTF_JumpSkinID and forceApplyJump then
            btn.Image = getgenv().FTF_JumpSkinID
            btn.ImageRectOffset = Vector2.new(0, 0)
            btn.ImageRectSize = Vector2.new(0, 0)
            btn.Size = UDim2.new(0, 80, 0, 80)
            btn.ImageTransparency = 0
        end
    end

    local function startJumpProtection()
        for _, conn in pairs(jumpConns) do if conn then conn:Disconnect() end end
        jumpConns = {}
        local btn = GetJumpButton()
        if not btn then return end
        saveOriginalJump()
        forceApplyJump = true
        table.insert(jumpConns, R.RenderStepped:Connect(forceApplyJumpSkin))
        table.insert(jumpConns, btn:GetPropertyChangedSignal("Image"):Connect(function()
            if forceApplyJump and getgenv().FTF_JumpSkinID and btn.Image ~= getgenv().FTF_JumpSkinID then
                btn.Image = getgenv().FTF_JumpSkinID
                btn.ImageRectOffset = Vector2.new(0, 0)
                btn.ImageRectSize = Vector2.new(0, 0)
                btn.Size = UDim2.new(0, 80, 0, 80)
            end
        end))
        table.insert(jumpConns, btn.Activated:Connect(function() task.wait() forceApplyJumpSkin() end))
        table.insert(jumpConns, btn.MouseButton1Click:Connect(function() task.wait() forceApplyJumpSkin() end))
        forceApplyJumpSkin()
    end

    local function stopJumpProtection()
        forceApplyJump = false
        for _, conn in pairs(jumpConns) do if conn then conn:Disconnect() end end
        jumpConns = {}
        local btn = GetJumpButton()
        if btn and originalJumpData then
            btn.Image = originalJumpData.Image
            btn.ImageRectOffset = originalJumpData.ImageRectOffset
            btn.ImageRectSize = originalJumpData.ImageRectSize
            btn.Size = originalJumpData.Size
            btn.ImageTransparency = originalJumpData.ImageTransparency
        end
        getgenv().FTF_JumpSkinID = nil
    end

    local BUTTON_LIST = {
        {"Default", nil, ""},
        {"Nezuko", "rbxassetid://98285238714079", "rbxassetid://98285238714079"},
        {"Tanjiro", "rbxassetid://85372624608084", "rbxassetid://85372624608084"},
        {"Inosuke", "rbxassetid://97417889091578", "rbxassetid://97417889091578"},
        {"Gengar", "rbxassetid://124320703202272", "rbxassetid://124320703202272"},
        {"Green Flame", "rbxassetid://125577376734114", "rbxassetid://125577376734114"},
        {"Hello Kitty", "rbxassetid://133484432928988", "rbxassetid://133484432928988"},
        {"Heart Minecraft", "rbxassetid://88121396536824", "rbxassetid://88121396536824"},
        {"Skeleton Army", "rbxassetid://88014445293756", "rbxassetid://88014445293756"},
        {"Pokemon", "rbxassetid://127357504054794", "rbxassetid://127357504054794"},
        {"Pikachu", "rbxassetid://112770541700961", "rbxassetid://112770541700961"},
        {"Pikachu Exe", "rbxassetid://85484998460643", "rbxassetid://85484998460643"},
        {"Sharingan", "rbxassetid://119906553877197", "rbxassetid://119906553877197"},
        {"Fire Skull", "rbxassetid://88821202537004", "rbxassetid://88821202537004"},
        {"Banana", "rbxassetid://78357281892162", "rbxassetid://78357281892162"},
        {"Beam", "rbxassetid://120302408630480", "rbxassetid://120302408630480"},
        {"Dragao", "rbxassetid://95322519251239", "rbxassetid://95322519251239"},
        {"Gengar2", "rbxassetid://85800788294484", "rbxassetid://85800788294484"},
        {"Little", "rbxassetid://91770326809398", "rbxassetid://91770326809398"},
        {"Melody", "rbxassetid://86299667519942", "rbxassetid://86299667519942"},
        {"Gray", "rbxassetid://76905368249152", "rbxassetid://76905368249152"},
        {"Sheep", "rbxassetid://75625272935607", "rbxassetid://75625272935607"}
    }

    local scrollJump = Instance.new("ScrollingFrame", contentJump)
    scrollJump.Size = UDim2.new(1, 0, 0, 200)
    scrollJump.BackgroundTransparency = 1
    scrollJump.ScrollBarThickness = 4
    scrollJump.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollJump.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollJump.BorderSizePixel = 0

    local gridJump = Instance.new("UIGridLayout", scrollJump)
    gridJump.CellSize = UDim2.new(0, 50, 0, 50)
    gridJump.CellPadding = UDim2.new(0, 6, 0, 6)
    gridJump.SortOrder = Enum.SortOrder.LayoutOrder
    gridJump.HorizontalAlignment = Enum.HorizontalAlignment.Center

    for _, data in ipairs(BUTTON_LIST) do
        local btn = Instance.new("ImageButton", scrollJump)
        btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        btn.BackgroundTransparency = 0.35
        btn.BorderSizePixel = 0
        btn.Image = data[3] ~= "" and data[3] or ""
        btn.LayoutOrder = data[1] == "Default" and 0 or 1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

        if data[1] == "Default" then
            local textLabel = Instance.new("TextLabel", btn)
            textLabel.Size = UDim2.new(1,0,1,0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "Default"
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextSize = 11
            textLabel.TextColor3 = Color3.fromRGB(235,235,235)
        end

        btn.MouseButton1Click:Connect(function()
            if data[1] == "Default" then
                stopJumpProtection()
            else
                getgenv().FTF_JumpSkinID = data[2]
                startJumpProtection()
            end
            for _,v in pairs(scrollJump:GetChildren()) do
                if v:IsA("ImageButton") then
                    TweenService:Create(v,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
                end
            end
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65)}):Play()
        end)
    end

    local boxFPS, contentFPS = CreateGroupbox(rightColH, "FPS Setting")
    boxFPS.BackgroundTransparency = 1
    boxFPS.BorderSizePixel = 0
    boxFPS.Size = UDim2.new(1,0,0,0)
    boxFPS.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxFPS).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxFPS).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentFPS).Padding = UDim.new(0, 8)

    do
        local fpsEnabled = false
        local originalSettings = {}
        local originalParts = {}
        local connections = {}

        local function disconnectAll()
            for _, conn in ipairs(connections) do
                pcall(function() conn:Disconnect() end)
            end
            table.clear(connections)
        end

        local function saveOriginal()
            local lighting = game:GetService("Lighting")

            local tech = nil
            if gethiddenproperty then
                local ok, val = pcall(gethiddenproperty, lighting, "Technology")
                if ok then tech = val end
            end

            originalSettings = {
                GlobalShadows = lighting.GlobalShadows,
                FogEnd = lighting.FogEnd,
                Technology = tech
            }

            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                originalSettings.WaterWaveSize = terrain.WaterWaveSize
                originalSettings.WaterWaveSpeed = terrain.WaterWaveSpeed
                originalSettings.WaterReflectance = terrain.WaterReflectance
                originalSettings.WaterTransparency = terrain.WaterTransparency
            end

            table.clear(originalParts)
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not originalParts[v] then
                    originalParts[v] = {
                        Material = v.Material,
                        Reflectance = v.Reflectance,
                        CastShadow = v.CastShadow
                    }
                elseif (v:IsA("Decal") or v:IsA("Texture")) and not originalParts[v] then
                    originalParts[v] = {Transparency = v.Transparency}
                elseif (v:IsA("ParticleEmitter") or v:IsA("Trail")) and not originalParts[v] then
                    originalParts[v] = {Lifetime = v.Lifetime}
                elseif (v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles")) and not originalParts[v] then
                    originalParts[v] = {Enabled = v.Enabled}
                end
            end
        end

        local function applyToInstance(v)
            if v:IsA("BasePart") then
                if not originalParts[v] then
                    originalParts[v] = {
                        Material = v.Material,
                        Reflectance = v.Reflectance,
                        CastShadow = v.CastShadow
                    }
                end
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                if not originalParts[v] then originalParts[v] = {Transparency = v.Transparency} end
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                if not originalParts[v] then originalParts[v] = {Lifetime = v.Lifetime} end
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                if not originalParts[v] then originalParts[v] = {Enabled = v.Enabled} end
                v.Enabled = false
            end
        end

        local function applyFPSBoost()
            disconnectAll()

            if not next(originalSettings) then saveOriginal() end

            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9

            if sethiddenproperty then
                pcall(sethiddenproperty, lighting, "Technology", Enum.Technology.Legacy)
            end

            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end

            for _, v in ipairs(workspace:GetDescendants()) do
                applyToInstance(v)
            end

            table.insert(connections, workspace.DescendantAdded:Connect(function(v)
                if not fpsEnabled then return end
                task.defer(function()
                    if v.Parent then
                        pcall(applyToInstance, v)
                    end
                end)
            end))
        end

        local function restoreFPS()
            disconnectAll()

            local lighting = game:GetService("Lighting")
            if originalSettings.GlobalShadows ~= nil then
                lighting.GlobalShadows = originalSettings.GlobalShadows
                lighting.FogEnd = originalSettings.FogEnd
                if originalSettings.Technology ~= nil and sethiddenproperty then
                    pcall(sethiddenproperty, lighting, "Technology", originalSettings.Technology)
                end
            end

            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain and originalSettings.WaterWaveSize ~= nil then
                terrain.WaterWaveSize = originalSettings.WaterWaveSize
                terrain.WaterWaveSpeed = originalSettings.WaterWaveSpeed
                terrain.WaterReflectance = originalSettings.WaterReflectance
                terrain.WaterTransparency = originalSettings.WaterTransparency
            end

            for obj, data in pairs(originalParts) do
                if obj and obj.Parent then
                    pcall(function()
                        if obj:IsA("BasePart") then
                            obj.Material = data.Material
                            obj.Reflectance = data.Reflectance
                            obj.CastShadow = data.CastShadow
                        elseif obj:IsA("Decal") or obj:IsA("Texture") then
                            obj.Transparency = data.Transparency
                        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                            obj.Lifetime = data.Lifetime
                        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                            obj.Enabled = data.Enabled
                        end
                    end)
                end
            end
            table.clear(originalParts)
            table.clear(originalSettings)
        end

        CreateToggle(contentFPS, "FPS Boost", false, function(enabled)
            fpsEnabled = enabled
            if enabled then applyFPSBoost() else restoreFPS() end
        end)
    end

    do
        local CINZA = Color3.fromRGB(105,105,105)
        local skinOriginal = {}
        local skinConnections = {}

        local function estaEmPastaIgnorada(obj)
            local current = obj
            while current do
                if current.Name == "PackedHammer" or current.Name == "PackedGemstone" or current.Name == "Hammer" or current.Name == "Gemstone" then return true end
                current = current.Parent
            end
            return false
        end

        local function salvarSkin(character)
            if skinOriginal[character] then return end
            local data = {}
            for _, obj in ipairs(character:GetDescendants()) do
                if obj:IsA("BasePart") then data[obj] = {Color = obj.Color, Material = obj.Material, Reflectance = obj.Reflectance}
                elseif obj:IsA("Decal") or obj:IsA("Texture") then data[obj] = {Texture = obj.Texture}
                elseif obj:IsA("MeshPart") then data[obj] = {TextureID = obj.TextureID, Color = obj.Color, Material = obj.Material}
                elseif obj:IsA("SpecialMesh") then data[obj] = {TextureId = obj.TextureId, VertexColor = obj.VertexColor}
                elseif obj:IsA("Shirt") then data[obj] = {ShirtTemplate = obj.ShirtTemplate}
                elseif obj:IsA("Pants") then data[obj] = {PantsTemplate = obj.PantsTemplate}
                elseif obj:IsA("ShirtGraphic") then data[obj] = {Graphic = obj.Graphic} end
            end
            skinOriginal[character] = data
        end

        local function aplicarSkin(character)
            salvarSkin(character)
            local data = skinOriginal[character]
            if not data then return end
            for obj, _ in pairs(data) do
                if obj and obj.Parent and not estaEmPastaIgnorada(obj) then
                    if obj:IsA("BasePart") then obj.Color = CINZA obj.Material = Enum.Material.SmoothPlastic obj.Reflectance = 0 end
                    if obj:IsA("Decal") or obj:IsA("Texture") then obj.Texture = "" end
                    if obj:IsA("MeshPart") then obj.TextureID = "" obj.Color = CINZA obj.Material = Enum.Material.SmoothPlastic end
                    if obj:IsA("SpecialMesh") then obj.TextureId = "" obj.VertexColor = Vector3.new(0.63,0.63) end
                    if obj:IsA("Shirt") then obj.ShirtTemplate = "" end
                    if obj:IsA("Pants") then obj.PantsTemplate = "" end
                    if obj:IsA("ShirtGraphic") then obj.Graphic = "" end
                end
            end
        end

        local function restaurarSkin(character)
            local data = skinOriginal[character]
            if not data then return end
            for obj, props in pairs(data) do
                if obj and obj.Parent then
                    if obj:IsA("BasePart") then obj.Color = props.Color obj.Material = props.Material obj.Reflectance = props.Reflectance end
                    if obj:IsA("Decal") or obj:IsA("Texture") then obj.Texture = props.Texture or "" end
                    if obj:IsA("MeshPart") then obj.TextureID = props.TextureID or "" obj.Color = props.Color obj.Material = props.Material end
                    if obj:IsA("SpecialMesh") then obj.TextureId = props.TextureId or "" obj.VertexColor = props.VertexColor end
                    if obj:IsA("Shirt") then obj.ShirtTemplate = props.ShirtTemplate or "" end
                    if obj:IsA("Pants") then obj.PantsTemplate = props.PantsTemplate or "" end
                    if obj:IsA("ShirtGraphic") then obj.Graphic = props.Graphic or "" end
                end
            end
        end

        local function onCharacterSkin(char) aplicarSkin(char) end

        local function startSkin()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then onCharacterSkin(plr.Character) end
                table.insert(skinConnections, plr.CharacterAdded:Connect(onCharacterSkin))
            end
            table.insert(skinConnections, Players.PlayerAdded:Connect(function(plr) plr.CharacterAdded:Connect(onCharacterSkin) end))
        end

        local function stopSkin()
            for char, _ in pairs(skinOriginal) do restaurarSkin(char) end
            table.clear(skinOriginal)
            for _, c in ipairs(skinConnections) do c:Disconnect() end
            table.clear(skinConnections)
        end

        CreateToggle(contentFPS, "Gray Character", false, function(enabled)
            if enabled then
                startSkin()
            else
                stopSkin()
            end
        end)
    end

if not getgenv().CrosshairState then
    getgenv().CrosshairState = {
        Size = 30,
        Crosshair = nil
    }
end
local State = getgenv().CrosshairState
local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local boxSettings, contentSettings = CreateGroupbox(rightColH, "Crosshair")
boxSettings.BackgroundColor3 = Color3.fromRGB(0,0,0)
boxSettings.BackgroundTransparency = 1
boxSettings.Size = UDim2.new(1, 0, 0, 280)
boxSettings.AutomaticSize = Enum.AutomaticSize.None
Instance.new("UICorner", boxSettings).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", boxSettings).Color = Color3.fromRGB(70,70,70)

local list = Instance.new("UIListLayout", contentSettings)
list.Padding = UDim.new(0, 8)

local function CreateCustomCursor(id, size)
    local old = playerGui:FindFirstChild("CustomCursorGui")
    if old then old:Destroy() end

    if id == "0" then
        UserInputService.MouseIconEnabled = true
        State.Crosshair = nil
        return
    end

    UserInputService.MouseIconEnabled = false
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomCursorGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local cursorImage = Instance.new("ImageLabel")
    cursorImage.Size = UDim2.new(0, size or State.Size, 0, size or State.Size)
    cursorImage.BackgroundTransparency = 1
    cursorImage.Image = "rbxassetid://".. id
    cursorImage.AnchorPoint = Vector2.new(0.5, 0.5)
    cursorImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    cursorImage.ZIndex = 999
    cursorImage.Parent = screenGui

    State.Crosshair = cursorImage
end

local inputHolder = Instance.new("Frame", contentSettings)
inputHolder.Size = UDim2.new(1, 0, 0, 30)
inputHolder.BackgroundTransparency = 1

local textBox = Instance.new("TextBox", inputHolder)
textBox.Size = UDim2.new(1, -70, 1, 0)
textBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
textBox.BackgroundTransparency = 0.35
textBox.TextColor3 = Color3.fromRGB(220,220,220)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 12
textBox.PlaceholderText = "Enter Texture ID..."
textBox.Text = ""
textBox.ClearTextOnFocus = false
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0,6)

local applyBtn = Instance.new("TextButton", inputHolder)
applyBtn.Size = UDim2.new(0, 65, 1, 0)
applyBtn.Position = UDim2.new(1, -65, 0, 0)
applyBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
applyBtn.BackgroundTransparency = 0
applyBtn.TextColor3 = Color3.fromRGB(220,220,220)
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 12
applyBtn.Text = "Apply"
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,6)

applyBtn.MouseButton1Click:Connect(function()
    local id = textBox.Text:match("%d+")
    if id then CreateCustomCursor(id) end
end)

local sliderBack = Instance.new("Frame", contentSettings)
sliderBack.Size = UDim2.new(1, 0, 0, 4)
sliderBack.BackgroundColor3 = Color3.fromRGB(50,50,50)
sliderBack.BorderSizePixel = 0
Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1,0)

local sliderFill = Instance.new("Frame", sliderBack)
sliderFill.Size = UDim2.new((State.Size - 10) / 70, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
sliderFill.BorderSizePixel = 0
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

local knob = Instance.new("Frame", sliderBack)
knob.Size = UDim2.new(0,12,0,12)
knob.Position = UDim2.new((State.Size - 10) / 70, 0, 0.5, 0)
knob.AnchorPoint = Vector2.new(0.5,0.5)
knob.BackgroundColor3 = Color3.fromRGB(200,200,200)
knob.BorderSizePixel = 0
Instance.new("UICorner", knob).CornerRadius = UDim.new(0,2)

local knobBtn = Instance.new("TextButton", knob)
knobBtn.Size = UDim2.new(1, 0, 1, 0)
knobBtn.BackgroundTransparency = 1
knobBtn.Text = ""
knobBtn.ZIndex = 2

local dragging = false
local function UpdateSlider(input)
    local percent = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
    State.Size = math.floor(10 + percent * 70)

    TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        Size = UDim2.new(percent, 0, 1, 0)
    }):Play()
    TweenService:Create(knob, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        Position = UDim2.new(percent, 0, 0.5, 0)
    }):Play()

    if State.Crosshair then
        State.Crosshair.Size = UDim2.new(0, State.Size, 0, State.Size)
    end
end

knobBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 14, 0, 14)}):Play()
    end
end)
sliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        UpdateSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        TweenService:Create(knob, TweenInfo.new(0.1), {Size = UDim2.new(0, 12, 0, 12)}):Play()
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

local spacer = Instance.new("Frame", contentSettings)
spacer.Size = UDim2.new(1, 0, 0, 1)
spacer.BackgroundTransparency = 1

local scrollGrid = Instance.new("ScrollingFrame", contentSettings)
scrollGrid.Size = UDim2.new(1, 0, 0, 165)
scrollGrid.BackgroundTransparency = 1
scrollGrid.BorderSizePixel = 0
scrollGrid.ScrollBarThickness = 3
scrollGrid.ScrollBarImageColor3 = Color3.fromRGB(120,120,120)
scrollGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollGrid.ClipsDescendants = true

local gridLayout = Instance.new("UIGridLayout", scrollGrid)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.CellSize = UDim2.new(0, 50, 0, 50)
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

local crosshairs = {
    {"0", 30},
    {"82286577776735", 32},
    {"109488705276896", 32},
    {"72254979333116", 32},
    {"127864951260720", 32},
    {"101384469724691", 32},
    {"124452821551584", 32},
    {"131055002280367", 32},
    {"78294835549441", 32},
    {"123505599804904", 32},
    {"89904973294948", 32},
    {"92210699714458", 32},
    {"117792166125612", 32},
    {"126904800610954", 32},
    {"98387861703675", 32},
    {"123835544338156", 32},
    {"121119061815558", 32},
    {"120412295822517", 32},
    {"124330770354006", 32},
    {"110144177338957", 32},
    {"70916441648356", 32},
    {"87221997499891", 32},
    {"72665358303361", 32},
    {"107141720811781", 20},
    {"123251498254248", 20},
    {"98472165787527", 20},
    {"124717991062973", 20},
    {"79131555594807", 20},
    {"128172876968221", 20},
    {"108999407533236", 20},
    {"133609476736972", 20},
    {"73733909030062", 20},
    {"94442637068173", 20},
    {"83854134929412", 20},
    {"85372624608084", 40},
    {"129016541533877", 30},
    {"98285238714079", 40},
    {"103861126846931", 30},
    {"97417889091578", 40},
    {"85605196873114", 30}
}

for _, data in ipairs(crosshairs) do
    local btn = Instance.new("ImageButton", scrollGrid)
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = 0.65
    btn.Image = data[1] == "0" and "" or "rbxassetid://".. data[1]
    btn.ScaleType = Enum.ScaleType.Fit
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    if data[1] == "0" then
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.Text = "Default"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextColor3 = Color3.fromRGB(200,200,200)
    end

    btn.MouseButton1Click:Connect(function()
        CreateCustomCursor(data[1], data[2])
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.35}):Play()
    end)
end
end

do
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local settingsPageH = pages["Fog"]
    settingsPageH:ClearAllChildren()

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -13, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -15, 0, 0)
    rightColH.Position = UDim2.new(0.5, 1, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local sliderRefs = {}

local function CreateSlider(parent, name, min, max, default, callback)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,0,0,52)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1,0,0,20)
    label.BackgroundTransparency = 1
    label.Text = name..": ".. string.format("%.2f", default)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", holder)
    sliderBg.Size = UDim2.new(1,0,0,8)
    sliderBg.Position = UDim2.new(0,0,0,26)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50,50,50)
    sliderBg.BorderSizePixel = 0
    sliderBg.ZIndex = 1
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

    local percent = math.clamp((default - min) / (max - min), 0, 1)

    local sliderFill = Instance.new("Frame", sliderBg)
    sliderFill.Size = UDim2.new(percent,0,1,0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sliderFill.BorderSizePixel = 0
    sliderFill.ZIndex = 2
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

    local gradient = Instance.new("UIGradient", sliderFill)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    gradient.Rotation = 90

    sliderRefs[name] = {label = label, fill = sliderFill, min = min, max = max}

    local dragging = false
    local function updateSlider(xPos)
        local newPercent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local value = min + (newPercent * (max - min))
        label.Text = name..": ".. string.format("%.2f", value)
        callback(value)
        TweenService:Create(sliderFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(newPercent,0,1,0)}):Play()
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)
end

local function resetSlider(name, value)
    local ref = sliderRefs[name]
    if not ref then return end
    local percent = math.clamp((value - ref.min) / (ref.max - ref.min), 0, 1)
    ref.label.Text = name.. ": ".. string.format("%.2f", value)

    TweenService:Create(ref.fill, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(220,220,220)}):Play()
    task.wait(0.08)
    TweenService:Create(ref.fill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(percent,0,1,0), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
end

local boxColor, contentColor = CreateGroupbox(leftColH, "Calibration")
boxColor.BackgroundColor3 = Color3.fromRGB(30,30,30)
boxColor.BackgroundTransparency = 1
boxColor.BorderSizePixel = 0
boxColor.Size = UDim2.new(1,0,0,340)
boxColor.ClipsDescendants = false
Instance.new("UICorner", boxColor).CornerRadius = UDim.new(0,8)
contentColor.ClipsDescendants = false
Instance.new("UIStroke", boxColor).Color = Color3.fromRGB(0,0,0)
Instance.new("UIListLayout", contentColor).Padding = UDim.new(0, 8)

local FILE_NAME = "ColorCalibration.json"
local defaultData = {
    Enabled = false,
    Color = {255, 255, 255},
    Brightness = 0,
    Contrast = 0,
    Saturation = 0,
    Exposure = 0,
    Temperature = 0,
    Blur = 0
}

local function canUseFile()
    return writefile and readfile and isfile
end

local function loadData()
    if canUseFile() and isfile(FILE_NAME) then
        local success, loaded = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end)
        if success and typeof(loaded) == "table" then
            for k,v in pairs(defaultData) do
                if loaded[k] == nil then loaded[k] = v end
            end
            return loaded
        end
    end
    return table.clone(defaultData)
end

local lastSavedJSON = ""
local function saveData(data)
    if not canUseFile() then return end
    local success, newJSON = pcall(function() return HttpService:JSONEncode(data) end)
    if not success or newJSON == lastSavedJSON then return end
    lastSavedJSON = newJSON
    pcall(function() writefile(FILE_NAME, newJSON) end)
end

local data = loadData()
lastSavedJSON = HttpService:JSONEncode(data)
local filtro, blurEffect

local function destroyFilter()
    if filtro then filtro:Destroy() filtro = nil end
    if blurEffect then blurEffect:Destroy() blurEffect = nil end
    local old = Lighting:FindFirstChild("FiltroBranco")
    if old then old:Destroy() end
    local oldBlur = Lighting:FindFirstChild("BlurCalibration")
    if oldBlur then oldBlur:Destroy() end
end

local function getFilter()
    if not filtro or not filtro.Parent then
        filtro = Lighting:FindFirstChild("FiltroBranco")
        if not filtro then
            filtro = Instance.new("ColorCorrectionEffect")
            filtro.Name = "FiltroBranco"
            filtro.Parent = Lighting
        end
    end
    return filtro
end

local function getBlur()
    if not blurEffect or not blurEffect.Parent then
        blurEffect = Lighting:FindFirstChild("BlurCalibration")
        if not blurEffect then
            blurEffect = Instance.new("BlurEffect")
            blurEffect.Name = "BlurCalibration"
            blurEffect.Parent = Lighting
        end
    end
    return blurEffect
end

local function applyFilter()
    if not data.Enabled then destroyFilter() return end
    local filtro = getFilter()
    local r, g, b = data.Color[1], data.Color[2], data.Color[3]

    local temp = data.Temperature
    if temp > 0 then
        r = math.clamp(r + temp * 30, 0, 255)
        b = math.clamp(b - temp * 20, 0, 255)
    elseif temp < 0 then
        b = math.clamp(b - temp * 30, 0, 255)
        r = math.clamp(r + temp * 20, 0, 255)
    end

    filtro.TintColor = Color3.fromRGB(r, g, b)
    filtro.Brightness = data.Brightness + data.Exposure
    filtro.Contrast = data.Contrast
    filtro.Saturation = data.Saturation

    local blur = getBlur()
    blur.Size = math.clamp(data.Blur, 0, 24)
end

destroyFilter()

local holderCal = Instance.new("Frame", contentColor)
holderCal.Size = UDim2.new(1,0,0,28)
holderCal.BackgroundTransparency = 1

local labelCal = Instance.new("TextLabel", holderCal)
labelCal.Size = UDim2.new(1,-50,1,0)
labelCal.BackgroundTransparency = 1
labelCal.Text = "Enable Calibration"
labelCal.Font = Enum.Font.GothamBold
labelCal.TextSize = 13
labelCal.TextColor3 = Color3.fromRGB(235,235,235)
labelCal.TextXAlignment = Enum.TextXAlignment.Left

local btnCal = Instance.new("TextButton", holderCal)
btnCal.Size = UDim2.new(0,44,0,20)
btnCal.Position = UDim2.new(1,-44,0.5,-10)
btnCal.BackgroundColor3 = Color3.fromRGB(45,45,45)
btnCal.BackgroundTransparency = 1
btnCal.Text = ""
btnCal.BorderSizePixel = 0
Instance.new("UICorner", btnCal).CornerRadius = UDim.new(1,0)

local circleCal = Instance.new("Frame", btnCal)
circleCal.Size = UDim2.new(0,16,0,16)
circleCal.Position = UDim2.new(0,2,0.5,-8)
circleCal.BackgroundColor3 = Color3.fromRGB(255,255,255)
circleCal.BorderSizePixel = 0
Instance.new("UICorner", circleCal).CornerRadius = UDim.new(1,0)

if data.Enabled then
    btnCal.BackgroundColor3 = Color3.fromRGB(65,65,65)
    btnCal.BackgroundTransparency = 0.15
    circleCal.Position = UDim2.new(1,-18,0.5,-8)
end

btnCal.MouseButton1Click:Connect(function()
    data.Enabled = not data.Enabled
    if data.Enabled then
        TweenService:Create(btnCal,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
        TweenService:Create(circleCal,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
        applyFilter()
    else
        TweenService:Create(btnCal,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
        TweenService:Create(circleCal,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
        destroyFilter()
    end
    saveData(data)
end)

CreateSlider(contentColor, "Brightness", -1, 1, data.Brightness, function(Value)
    data.Brightness = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

CreateSlider(contentColor, "Contrast", -1, 1, data.Contrast, function(Value)
    data.Contrast = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

CreateSlider(contentColor, "Saturation", -1, 1, data.Saturation, function(Value)
    data.Saturation = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

CreateSlider(contentColor, "Exposure", -1, 1, data.Exposure, function(Value)
    data.Exposure = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

CreateSlider(contentColor, "Temperature", -1, 1, data.Temperature, function(Value)
    data.Temperature = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

CreateSlider(contentColor, "Blur", 0, 24, data.Blur, function(Value)
    data.Blur = Value
    if data.Enabled then applyFilter() end
    saveData(data)
end)

local resetText = Instance.new("TextLabel", contentColor)
resetText.Size = UDim2.new(1, 0, 0, 28)
resetText.BackgroundTransparency = 1
resetText.Text = "Reset All"
resetText.TextColor3 = Color3.fromRGB(255, 255, 255)
resetText.Font = Enum.Font.GothamBold
resetText.TextSize = 13
resetText.TextXAlignment = Enum.TextXAlignment.Center

local resetBtn = Instance.new("TextButton", resetText)
resetBtn.Size = UDim2.new(1, 0, 1, 0)
resetBtn.BackgroundTransparency = 1
resetBtn.Text = ""

resetBtn.MouseEnter:Connect(function()
    TweenService:Create(resetText, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
end)
resetBtn.MouseLeave:Connect(function()
    TweenService:Create(resetText, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
end)

resetBtn.MouseButton1Click:Connect(function()
    TweenService:Create(resetText, TweenInfo.new(0.08), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    task.wait(0.08)
    TweenService:Create(resetText, TweenInfo.new(0.08), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()

    data.Brightness = defaultData.Brightness
    data.Contrast = defaultData.Contrast
    data.Saturation = defaultData.Saturation
    data.Exposure = defaultData.Exposure
    data.Temperature = defaultData.Temperature
    data.Blur = defaultData.Blur

    resetSlider("Brightness", data.Brightness)
    task.wait(0.025)
    resetSlider("Contrast", data.Contrast)
    task.wait(0.025)
    resetSlider("Saturation", data.Saturation)
    task.wait(0.025)
    resetSlider("Exposure", data.Exposure)
    task.wait(0.025)
    resetSlider("Temperature", data.Temperature)
    task.wait(0.025)
    resetSlider("Blur", data.Blur)

    if data.Enabled then applyFilter() end
    saveData(data)
end)

if data.Enabled then applyFilter() end

do
    local boxShader, contentShader = CreateGroupbox(rightColH, "Shaders")
    boxShader.BackgroundColor3 = Color3.fromRGB(0,0,0)
    boxShader.BackgroundTransparency = 1
    boxShader.BorderSizePixel = 0
    boxShader.Size = UDim2.new(1,0,0,0)
    boxShader.AutomaticSize = Enum.AutomaticSize.Y
    boxShader.ClipsDescendants = false
    Instance.new("UICorner", boxShader).CornerRadius = UDim.new(0,8)
    contentShader.ClipsDescendants = false
    contentShader.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UIStroke", boxShader).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentShader).Padding = UDim.new(0, 6)
    Instance.new("UIPadding", contentShader).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", contentShader).PaddingRight = UDim.new(0, 10)

    local L = game:GetService("Lighting")
    local R = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")

    getgenv().FTF_Shaders = getgenv().FTF_Shaders or {
        Enabled = false,
        Current = "midday"
    }

    local shaderlight = {
        ["yfbghj"] = L.Ambient, ["tgvbyd"] = L.ClockTime, ["ghuybhuyhj"] = L.GeographicLatitude,
        ["khnbfth"] = L.Brightness, ["hgyghkg"] = L.ColorShift_Bottom, ["yfbhjku"] = L.ColorShift_Top,
        ["ygyyfgvhbjytrt"] = L.EnvironmentDiffuseScale, ["sdfcddc"] = L.EnvironmentSpecularScale,
        ["hgnujuu7thgr"] = L.GlobalShadows, ["hyhnngtf"] = L.OutdoorAmbient, ["hdfr7thgr"] = L.ExposureCompensation,
        ["fhnchvhfjsd"] = 0, ["ugtbbjhygt"] = 0, ["tfbghuugbnjhg"] = 0, ["fvrtccvghghj"] = Color3.fromRGB(255, 255, 255),
        ["jnfdhbnfcvh"] = 0.4, ["fvtyghj"] = 24, ["ygbhnj"] = 0.95, ["njnfg"] = 0, ["jdfkd"] = 0.1,
        ["fvgsdfg"] = 50, ["sdkvkflv"] = 10, ["hbjhd"] = 0.75, ["gyhgtg"] = 0, ["ygbhggv"] = 0,
        ["jghbjhgyfd"] = Color3.fromRGB(255, 255, 255), ["shdbsnjfc"] = 0, ["skdjfkdm"] = 0,
        ["sjdjncdjf"] = Color3.fromRGB(199, 199, 199), ["efjdjfk"] = Color3.fromRGB(106, 112, 125),
        ["sejfd"] = 0, ["jddfjsd"] = 0,
    }

    local backup = {
        ["ClockTime"] = L.ClockTime, ["Ambient"] = L.Ambient, ["Brightness"] = L.Brightness,
        ["ColorShift_Bottom"] = L.ColorShift_Bottom, ["ColorShift_Top"] = L.ColorShift_Top,
        ["EnvDiffuse"] = L.EnvironmentDiffuseScale, ["EnvSpecular"] = L.EnvironmentSpecularScale,
        ["Shadows"] = L.GlobalShadows, ["Outdoor"] = L.OutdoorAmbient, ["Exposure"] = L.ExposureCompensation,
        ["Lat"] = L.GeographicLatitude
    }

    local shaderWL = { ["dof"] = false, ["cor"] = true, ["sray"] = false, ["bl"] = true, ["blr"] = false, }

    local presets = {
        ["morning"] = { ["yfbghj"] = Color3.fromRGB(138, 138, 138), ["tgvbyd"] = 6.5, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 2, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(0, 0, 0), ["ygyyfgvhbjytrt"] = 0.25, ["sdfcddc"] = 0.25, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(138, 138, 138), ["hdfr7thgr"] = 0.2, ["fhnchvhfjsd"] = 0.02, ["ugtbbjhygt"] = 0.1, ["tfbghuugbnjhg"] = -0.2, ["fvrtccvghghj"] = Color3.fromRGB(255, 255, 255), ["jnfdhbnfcvh"] = 0.8, ["fvtyghj"] = 24, ["ygbhnj"] = 0.8, ["njnfg"] = 0, ["jdfkd"] = 0.1, ["fvgsdfg"] = 50, ["sdkvkflv"] = 15, ["hbjhd"] = 0.75, ["gyhgtg"] = 0.4, ["ygbhggv"] = 0.3, ["jghbjhgyfd"] = Color3.fromRGB(255, 248, 231), ["shdbsnjfc"] = 0.31, ["skdjfkdm"] = 0.25, ["sjdjncdjf"] = Color3.fromRGB(199, 199, 199), ["efjdjfk"] = Color3.fromRGB(106, 112, 125), ["sejfd"] = 0.1, ["jddfjsd"] = 0, },
        ["midday"] = { ["yfbghj"] = Color3.fromRGB(138, 138, 138), ["tgvbyd"] = 14, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 2, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(0, 0, 0), ["ygyyfgvhbjytrt"] = 0.25, ["sdfcddc"] = 0.25, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(138, 138, 138), ["hdfr7thgr"] = 0, ["fhnchvhfjsd"] = 0, ["ugtbbjhygt"] = 0.1, ["tfbghuugbnjhg"] = 0, ["fvrtccvghghj"] = Color3.fromRGB(255, 255, 255), ["jnfdhbnfcvh"] = 1, ["fvtyghj"] = 24, ["ygbhnj"] = 0.95, ["njnfg"] = 0, ["jdfkd"] = 0.1, ["fvgsdfg"] = 50, ["sdkvkflv"] = 10, ["hbjhd"] = 0.75, ["gyhgtg"] = 0.5, ["ygbhggv"] = 0.4, ["jghbjhgyfd"] = Color3.fromRGB(255, 255, 255), ["shdbsnjfc"] = 0.364, ["skdjfkdm"] = 0.25, ["sjdjncdjf"] = Color3.fromRGB(199, 199, 199), ["efjdjfk"] = Color3.fromRGB(106, 112, 125), ["sejfd"] = 0, ["jddfjsd"] = 0, },
        ["afternoon"] = { ["yfbghj"] = Color3.fromRGB(138, 138, 138), ["tgvbyd"] = 15.5, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 2, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(0, 0, 0), ["ygyyfgvhbjytrt"] = 0.25, ["sdfcddc"] = 0.25, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(138, 138, 138), ["hdfr7thgr"] = 0.1, ["fhnchvhfjsd"] = 0.01, ["ugtbbjhygt"] = 0.15, ["tfbghuugbnjhg"] = -0.1, ["fvrtccvghghj"] = Color3.fromRGB(255, 252, 245), ["jnfdhbnfcvh"] = 0.9, ["fvtyghj"] = 24, ["ygbhnj"] = 0.85, ["njnfg"] = 0, ["jdfkd"] = 0.15, ["fvgsdfg"] = 50, ["sdkvkflv"] = 12, ["hbjhd"] = 0.75, ["gyhgtg"] = 0.45, ["ygbhggv"] = 0.35, ["jghbjhgyfd"] = Color3.fromRGB(255, 248, 231), ["shdbsnjfc"] = 0.32, ["skdjfkdm"] = 0.25, ["sjdjncdjf"] = Color3.fromRGB(199, 199, 199), ["efjdjfk"] = Color3.fromRGB(106, 112, 125), ["sejfd"] = 0.05, ["jddfjsd"] = 0, },
        ["evening"] = { ["yfbghj"] = Color3.fromRGB(150, 112, 90), ["tgvbyd"] = 17.5, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 2, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(255, 176, 131), ["ygyyfgvhbjytrt"] = 0.25, ["sdfcddc"] = 0.25, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(150, 112, 90), ["hdfr7thgr"] = 0.25, ["fhnchvhfjsd"] = 0.05, ["ugtbbjhygt"] = 0.2, ["tfbghuugbnjhg"] = -0.3, ["fvrtccvghghj"] = Color3.fromRGB(255, 231, 207), ["jnfdhbnfcvh"] = 1.2, ["fvtyghj"] = 32, ["ygbhnj"] = 0.7, ["njnfg"] = 0, ["jdfkd"] = 0.2, ["fvgsdfg"] = 50, ["sdkvkflv"] = 15, ["hbjhd"] = 0.8, ["gyhgtg"] = 0.6, ["ygbhggv"] = 0.4, ["jghbjhgyfd"] = Color3.fromRGB(255, 207, 165), ["shdbsnjfc"] = 0.42, ["skdjfkdm"] = 0.3, ["sjdjncdjf"] = Color3.fromRGB(225, 180, 150), ["efjdjfk"] = Color3.fromRGB(255, 176, 131), ["sejfd"] = 0.3, ["jddfjsd"] = 0.1, },
        ["night"] = { ["yfbghj"] = Color3.fromRGB(85, 85, 127), ["tgvbyd"] = 0, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 1, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(0, 0, 0), ["ygyyfgvhbjytrt"] = 0.15, ["sdfcddc"] = 0.15, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(85, 85, 127), ["hdfr7thgr"] = -0.2, ["fhnchvhfjsd"] = -0.1, ["ugtbbjhygt"] = 0.05, ["tfbghuugbnjhg"] = -0.5, ["fvrtccvghghj"] = Color3.fromRGB(200, 210, 255), ["jnfdhbnfcvh"] = 0.4, ["fvtyghj"] = 24, ["ygbhnj"] = 1, ["njnfg"] = 0, ["jdfkd"] = 0.1, ["fvgsdfg"] = 50, ["sdkvkflv"] = 10, ["hbjhd"] = 0.75, ["gyhgtg"] = 0.3, ["ygbhggv"] = 0.2, ["jghbjhgyfd"] = Color3.fromRGB(170, 180, 210), ["shdbsnjfc"] = 0.25, ["skdjfkdm"] = 0.2, ["sjdjncdjf"] = Color3.fromRGB(140, 150, 180), ["efjdjfk"] = Color3.fromRGB(85, 85, 127), ["sejfd"] = 0, ["jddfjsd"] = 0.2, },
        ["midnight"] = { ["yfbghj"] = Color3.fromRGB(60, 60, 90), ["tgvbyd"] = 0, ["ghuybhuyhj"] = 41.7, ["khnbfth"] = 0.5, ["hgyghkg"] = Color3.fromRGB(0, 0, 0), ["yfbhjku"] = Color3.fromRGB(0, 0, 0), ["ygyyfgvhbjytrt"] = 0.1, ["sdfcddc"] = 0.1, ["hgnujuu7thgr"] = true, ["hyhnngtf"] = Color3.fromRGB(60, 60, 90), ["hdfr7thgr"] = -0.3, ["fhnchvhfjsd"] = -0.15, ["ugtbbjhygt"] = 0, ["tfbghuugbnjhg"] = -0.6, ["fvrtccvghghj"] = Color3.fromRGB(180, 190, 230), ["jnfdhbnfcvh"] = 0.3, ["fvtyghj"] = 24, ["ygbhnj"] = 1, ["njnfg"] = 0, ["jdfkd"] = 0.05, ["fvgsdfg"] = 50, ["sdkvkflv"] = 8, ["hbjhd"] = 0.7, ["gyhgtg"] = 0.2, ["ygbhggv"] = 0.15, ["jghbjhgyfd"] = Color3.fromRGB(150, 160, 190), ["shdbsnjfc"] = 0.2, ["skdjfkdm"] = 0.15, ["sjdjncdjf"] = Color3.fromRGB(120, 130, 160), ["efjdjfk"] = Color3.fromRGB(60, 60, 90), ["sejfd"] = 0, ["jddfjsd"] = 0.3, }
    }

    local active = false
    local loop
    local dropdownBtn
    local dropdownHolder

    function update()
        if not active then return end
        L.Ambient = shaderlight["yfbghj"]
        L.ClockTime = shaderlight["tgvbyd"]
        L.GeographicLatitude = shaderlight["ghuybhuyhj"]
        L.Brightness = shaderlight["khnbfth"]
        L.ColorShift_Bottom = shaderlight["hgyghkg"]
        L.ColorShift_Top = shaderlight["yfbhjku"]
        L.EnvironmentDiffuseScale = shaderlight["ygyyfgvhbjytrt"]
        L.EnvironmentSpecularScale = shaderlight["sdfcddc"]
        L.GlobalShadows = shaderlight["hgnujuu7thgr"]
        L.OutdoorAmbient = shaderlight["hyhnngtf"]
        L.ExposureCompensation = shaderlight["hdfr7thgr"]
        L.FogEnd = 999

        local cc = L:FindFirstChildOfClass("ColorCorrectionEffect") or Instance.new("ColorCorrectionEffect", L)
        local bl = L:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", L)
        local br = L:FindFirstChildOfClass("BlurEffect") or Instance.new("BlurEffect", L)
        local df = L:FindFirstChildOfClass("DepthOfFieldEffect") or Instance.new("DepthOfFieldEffect", L)
        local cl = L:FindFirstChildOfClass("Clouds") or Instance.new("Clouds", L)
        local at = L:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", L)

        cc.Brightness = shaderlight["fhnchvhfjsd"]
        cc.Contrast = shaderlight["ugtbbjhygt"]
        cc.Saturation = shaderlight["tfbghuugbnjhg"]
        cc.TintColor = shaderlight["fvrtccvghghj"]
        cc.Enabled = shaderWL["cor"]

        bl.Intensity = shaderlight["jnfdhbnfcvh"]
        bl.Size = shaderlight["fvtyghj"]
        bl.Threshold = shaderlight["ygbhnj"]
        bl.Enabled = shaderWL["bl"]

        br.Size = shaderlight["njnfg"]
        br.Enabled = shaderWL["blr"]

        df.FarIntensity = shaderlight["jdfkd"]
        df.FocusDistance = shaderlight["fvgsdfg"]
        df.InFocusRadius = shaderlight["sdkvkflv"]
        df.NearIntensity = shaderlight["hbjhd"]
        df.Enabled = shaderWL["dof"]

        cl.Cover = shaderlight["gyhgtg"]
        cl.Density = shaderlight["ygbhggv"]
        cl.Color = shaderlight["jghbjhgyfd"]

        at.Density = shaderlight["shdbsnjfc"]
        at.Offset = shaderlight["skdjfkdm"]
        at.Color = shaderlight["sjdjncdjf"]
        at.Decay = shaderlight["efjdjfk"]
        at.Glare = shaderlight["sejfd"]
        at.Haze = shaderlight["jddfjsd"]
    end

    local function destroyShaders()
        if loop then loop:Disconnect() loop = nil end
        active = false
        L.ClockTime = backup.ClockTime
        L.Ambient = backup.Ambient
        L.Brightness = backup.Brightness
        L.ColorShift_Bottom = backup.ColorShift_Bottom
        L.ColorShift_Top = backup.ColorShift_Top
        L.EnvironmentDiffuseScale = backup.EnvDiffuse
        L.EnvironmentSpecularScale = backup.EnvSpecular
        L.GlobalShadows = backup.Shadows
        L.OutdoorAmbient = backup.Outdoor
        L.ExposureCompensation = backup.Exposure
        L.GeographicLatitude = backup.Lat
    end

    local function CreateToggle(parent, text, default, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(1, 0, 0, 22)
        toggleFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", toggleFrame)
        toggle.Size = UDim2.new(0, 38, 0, 17)
        toggle.Position = UDim2.new(1, -40, 0.5, -9)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggle.BackgroundTransparency = default and 0 or 1
        toggle.Text = ""
        toggle.AutoButtonColor = false
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke", toggle)
        stroke.Color = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        stroke.Thickness = 1.5

        local circle = Instance.new("Frame", toggle)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = default and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = enabled and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
            }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.15), {
                BackgroundTransparency = enabled and 0 or 1
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {
                Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
            }):Play()
            if callback then callback(enabled) end
        end)
        return toggleFrame
    end

    local function CreateDropdown(parent, label, list, default, callback)
        dropdownHolder = Instance.new("Frame", parent)
        dropdownHolder.Size = UDim2.new(1,0,0,26)
        dropdownHolder.BackgroundTransparency = 1
        dropdownHolder.ZIndex = 10

        dropdownBtn = Instance.new("TextButton", dropdownHolder)
        dropdownBtn.Size = UDim2.new(1,0,0,26)
        dropdownBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dropdownBtn.BackgroundTransparency = 1
        dropdownBtn.Text = label.. ": ".. default:sub(1,1):upper()..default:sub(2)
        dropdownBtn.Font = Enum.Font.GothamBold
        dropdownBtn.TextSize = 13
        dropdownBtn.TextColor3 = Color3.fromRGB(180,180,180)
        dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
        dropdownBtn.ZIndex = 11
        Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,4)
        Instance.new("UIStroke", dropdownBtn).Color = Color3.fromRGB(40,40,40)

        local arrow = Instance.new("TextLabel", dropdownBtn)
        arrow.Size = UDim2.new(0,20,1,0)
        arrow.Position = UDim2.new(1,-25,0,0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 10
        arrow.TextColor3 = Color3.fromRGB(150,150,150)
        arrow.ZIndex = 12

        local scrollFrame = Instance.new("Frame", dropdownHolder)
        scrollFrame.Size = UDim2.new(1,0,0,0)
        scrollFrame.Position = UDim2.new(0,0,0,28)
        scrollFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        scrollFrame.BackgroundTransparency = 0.2
        scrollFrame.BorderSizePixel = 0
        scrollFrame.ZIndex = 50
        scrollFrame.ClipsDescendants = true
        Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0,4)
        Instance.new("UIStroke", scrollFrame).Color = Color3.fromRGB(40,40,40)

        local layout = Instance.new("UIListLayout", scrollFrame)

        local open = false
        local itemHeight = 24

        local function closeDropdown()
            open = false
            arrow.Text = "▼"
            TweenService:Create(scrollFrame, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)}):Play()
            TweenService:Create(dropdownHolder, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,26)}):Play()
            dropdownBtn.Text = label.. ": ".. getgenv().FTF_Shaders.Current:sub(1,1):upper()..getgenv().FTF_Shaders.Current:sub(2)
        end

        for i, v in ipairs(list) do
            local item = Instance.new("TextButton", scrollFrame)
            item.Size = UDim2.new(1,0,0,itemHeight)
            item.Text = v:sub(1,1):upper()..v:sub(2)
            item.BackgroundTransparency = 1
            item.TextColor3 = Color3.fromRGB(255,255,255)
            item.Font = Enum.Font.Gotham
            item.TextSize = 13
            item.BorderSizePixel = 0
            item.ZIndex = 51
            item.TextXAlignment = Enum.TextXAlignment.Center

            if i < #list then
                local line = Instance.new("Frame", item)
                line.Size = UDim2.new(1,-20,0,1)
                line.Position = UDim2.new(0,10,1,-1)
                line.BackgroundColor3 = Color3.fromRGB(35,35,35)
                line.BorderSizePixel = 0
                line.ZIndex = 52
            end

            item.MouseButton1Click:Connect(function()
                getgenv().FTF_Shaders.Current = v
                callback(v)
                closeDropdown()
            end)
        end

        dropdownBtn.MouseButton1Click:Connect(function()
            open = not open
            arrow.Text = open and "▲" or "▼"
            local dropdownHeight = #list * itemHeight
            if open then
                TweenService:Create(scrollFrame, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,dropdownHeight)}):Play()
                TweenService:Create(dropdownHolder, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,28 + dropdownHeight)}):Play()
            else
                closeDropdown()
            end
        end)
        return dropdownHolder
    end

    CreateToggle(contentShader, "Enable Shaders", getgenv().FTF_Shaders.Enabled, function(state)
        getgenv().FTF_Shaders.Enabled = state
        if state then
            active = true
            loop = R.Heartbeat:Connect(update)
        else
            destroyShaders()
        end
    end)

    local presetList = {"morning", "midday", "afternoon", "evening", "night", "midnight"}
    CreateDropdown(contentShader, "Preset", presetList, getgenv().FTF_Shaders.Current, function(value)
        for k, v in pairs(presets[value]) do
            shaderlight[k] = v
        end
    end)

    local holderReset = Instance.new("Frame", contentShader)
    holderReset.Size = UDim2.new(1,0,0,26)
    holderReset.BackgroundTransparency = 1

    local btnReset = Instance.new("TextButton", holderReset)
    btnReset.Size = UDim2.new(1,0,0,26)
    btnReset.BackgroundTransparency = 1
    btnReset.Text = "Reset Shaders"
    btnReset.TextColor3 = Color3.fromRGB(235, 235, 235)
    btnReset.Font = Enum.Font.GothamBold
    btnReset.TextSize = 12
    btnReset.BorderSizePixel = 0
    btnReset.TextXAlignment = Enum.TextXAlignment.Left

    btnReset.MouseButton1Click:Connect(function()
        TweenService:Create(btnReset, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 80, 80)}):Play()
        task.wait(0.15)
        TweenService:Create(btnReset, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(235, 235, 235)}):Play()

        getgenv().FTF_Shaders.Current = "midday"
        getgenv().FTF_Shaders.Enabled = false

        dropdownBtn.Text = "Preset: Midday"
        for k, v in pairs(presets["midday"]) do
            shaderlight[k] = v
        end
        destroyShaders()
    end)
end

local boxFog, contentFog = CreateGroupbox(rightColH, "Fog Settings")
    boxFog.BackgroundColor3 = Color3.fromRGB(0,0,0)
    boxFog.BackgroundTransparency = 1
    boxFog.BorderSizePixel = 0
    boxFog.Size = UDim2.new(1,0,0,0)
    boxFog.AutomaticSize = Enum.AutomaticSize.Y
    boxFog.ClipsDescendants = false
    Instance.new("UICorner", boxFog).CornerRadius = UDim.new(0,8)
    contentFog.ClipsDescendants = false
    contentFog.AutomaticSize = Enum.AutomaticSize.Y
    contentFog.ZIndex = 5
    Instance.new("UIStroke", boxFog).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIPadding", contentFog).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", contentFog).PaddingRight = UDim.new(0, 10)
    for _, o in pairs(contentFog:GetDescendants()) do
        if o:IsA("UIListLayout") then o.SortOrder = Enum.SortOrder.LayoutOrder o.Padding = UDim.new(0, 8) end
    end
    local contentLayoutFog = contentFog:FindFirstChildOfClass("UIListLayout")
    if contentLayoutFog then contentLayoutFog.Padding = UDim.new(0, 8) contentLayoutFog.SortOrder = Enum.SortOrder.LayoutOrder end

    local UIS = game:GetService("UserInputService")
    local FlashEnabled = false
    local Brightness2 = 5

    local function UpdateFlashlight(state)
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local light = hrp:FindFirstChild("Light")
        if state then
            if not light then
                light = Instance.new("PointLight")
                light.Name = "Light"
                light.Range = 120
                light.Shadows = false
                light.Parent = hrp
            end
            light.Brightness = Brightness2
        else
            if light then light:Destroy() end
        end
    end

    local Lighting = game:GetService("Lighting")
    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    local Sky = Lighting:FindFirstChildOfClass("Sky")
    local FogMode = "Default"
    local FogConnection = nil
    local FogEnabled = false
    local Active = nil
    local FogColor = Color3.fromRGB(0, 0, 0)

    local OriginalFog = {
        Color = Atmosphere and Atmosphere.Color or Color3.fromRGB(192,192,192),
        Haze = Atmosphere and Atmosphere.Haze or 0,
        Glare = Atmosphere and Atmosphere.Glare or 0,
        Decay = Atmosphere and Atmosphere.Decay or Color3.fromRGB(0,0,0),
        Density = Atmosphere and Atmosphere.Density or 0,
        MoonSize = Sky and Sky.MoonAngularSize or 10,
        Stars = Sky and Sky.StarCount or 1000
    }

    local function RefreshLighting()
        Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        Sky = Lighting:FindFirstChildOfClass("Sky")
    end

    local presets = {
        ["Default"] = function()
            if not Atmosphere or not Sky then return end
            pcall(function()
                Atmosphere.Color = OriginalFog.Color
                Atmosphere.Haze = OriginalFog.Haze
                Atmosphere.Glare = OriginalFog.Glare
                Atmosphere.Decay = OriginalFog.Decay
                Atmosphere.Density = OriginalFog.Density
                Sky.MoonAngularSize = OriginalFog.MoonSize
                Sky.StarCount = OriginalFog.Stars
            end)
        end,
        ["Black Fog"] = function()
            if not Atmosphere or not Sky then return end
            pcall(function()
                Atmosphere.Color = Color3.fromRGB(0,0,0) Atmosphere.Haze = 2.46 Atmosphere.Density = 0.76 Atmosphere.Glare = 0 Atmosphere.Decay = Color3.fromRGB(0,0,0) Sky.MoonAngularSize = 10 Sky.StarCount = 0
            end)
        end,
        ["Gray Fog"] = function()
            if not Atmosphere or not Sky then return end
            pcall(function()
                Atmosphere.Color = Color3.fromRGB(128,128,128) Atmosphere.Haze = 2 Atmosphere.Density = 0.55 Atmosphere.Glare = 0 Atmosphere.Decay = Color3.fromRGB(100,100,100) Sky.MoonAngularSize = 10 Sky.StarCount = 0
            end)
        end,
        ["No Fog"] = function()
            if not Atmosphere or not Sky then return end
            pcall(function()
                Atmosphere.Color = Color3.fromRGB(0,0,0)
                Atmosphere.Glare = 0
                Atmosphere.Haze = 0
                Atmosphere.Decay = Color3.fromRGB(0,0,0)
                Atmosphere.Density = 0
                Sky.MoonAngularSize = 10
                Sky.StarCount = 0
            end)
        end,
        ["Custom"] = function()
            if not Atmosphere or not Sky then return end
            pcall(function()
                local r, g, b = FogColor.R, FogColor.G, FogColor.B
                Atmosphere.Color = FogColor
                Atmosphere.Haze = 1.7
                Atmosphere.Density = 0.6
                Atmosphere.Glare = 0
                Atmosphere.Decay = Color3.new(r * 0.4, g * 0.4, b * 0.4)
                Sky.MoonAngularSize = 10
                Sky.StarCount = 0
            end)
        end,
    }

    local function ApplyMode()
        RefreshLighting()
        if not Atmosphere or not Sky or not FogEnabled then return end
        if presets[FogMode] then presets[FogMode]() end
    end

    local function StartFog()
        FogEnabled = true
        RefreshLighting()
        if not Atmosphere or not Sky then return end
        ApplyMode()
        if FogConnection then FogConnection:Disconnect() FogConnection = nil end
        local lastUpdate = 0
        FogConnection = RunService.RenderStepped:Connect(function()
            if not FogEnabled then return end
            if tick() - lastUpdate >= 6 then
                lastUpdate = tick()
                ApplyMode()
            end
        end)
    end

    local function StopFog()
        FogEnabled = false
        if FogConnection then FogConnection:Disconnect() FogConnection = nil end
        FogMode = "Default"
        RefreshLighting()
        if Atmosphere and Sky then presets["Default"]() end
    end

    local function ToggleVisual(btn, circle, on)
        if on then
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
        else
            TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
            TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
        end
    end

    local function CreateToggle(text, order)
        local holder = Instance.new("Frame", contentFog)
        holder.Size = UDim2.new(1,0,0,28)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 5
        holder.LayoutOrder = order or 0
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,1,0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 5
        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(0,44,0,20)
        btn.Position = UDim2.new(1,-44,0.5,-10)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0,16,0,16)
        circle.Position = UDim2.new(0,2,0.5,-8)
        circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
        circle.BorderSizePixel = 0
        circle.ZIndex = 6
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
        return btn, circle
    end

    local btnBlack, circleBlack = CreateToggle("Black Fog", 1)
    local btnGray, circleGray = CreateToggle("Gray Fog", 2)
    local btnNoFog, circleNoFog = CreateToggle("No Fog", 3)
    local btnToggle, circleToggle = CreateToggle("Enable Fog Mode", 4)

    local function TurnOffAll()
        Active = nil
        ToggleVisual(btnBlack, circleBlack, false)
        ToggleVisual(btnGray, circleGray, false)
        ToggleVisual(btnNoFog, circleNoFog, false)
        ToggleVisual(btnToggle, circleToggle, false)
        StopFog()
    end

    btnBlack.MouseButton1Click:Connect(function()
        if Active == "Black" then TurnOffAll()
        else
            Active = "Black"
            ToggleVisual(btnBlack, circleBlack, true)
            ToggleVisual(btnGray, circleGray, false)
            ToggleVisual(btnNoFog, circleNoFog, false)
            ToggleVisual(btnToggle, circleToggle, false)
            FogMode = "Black Fog" StartFog()
        end
    end)
    btnGray.MouseButton1Click:Connect(function()
        if Active == "Gray" then TurnOffAll()
        else
            Active = "Gray"
            ToggleVisual(btnBlack, circleBlack, false)
            ToggleVisual(btnGray, circleGray, true)
            ToggleVisual(btnNoFog, circleNoFog, false)
            ToggleVisual(btnToggle, circleToggle, false)
            FogMode = "Gray Fog" StartFog()
        end
    end)
    btnNoFog.MouseButton1Click:Connect(function()
        if Active == "NoFog" then TurnOffAll()
        else
            Active = "NoFog"
            ToggleVisual(btnBlack, circleBlack, false)
            ToggleVisual(btnGray, circleGray, false)
            ToggleVisual(btnNoFog, circleNoFog, true)
            ToggleVisual(btnToggle, circleToggle, false)
            FogMode = "No Fog" StartFog()
        end
    end)
    btnToggle.MouseButton1Click:Connect(function()
        if Active == "Enable" then TurnOffAll()
        else
            Active = "Enable"
            ToggleVisual(btnBlack, circleBlack, false)
            ToggleVisual(btnGray, circleGray, false)
            ToggleVisual(btnNoFog, circleNoFog, false)
            ToggleVisual(btnToggle, circleToggle, true)
            FogMode = "Custom" StartFog()
        end
    end)

local UIS = game:GetService("UserInputService")

local function CreateFogColorPicker(parent, name, defaultColor, onChange, order)
    local h, s, v = defaultColor:ToHSV()
    local holder = Instance.new("Frame")
    holder.Name = name .. "_Holder"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.ClipsDescendants = false
    holder.LayoutOrder = order or 0
    holder.ZIndex = 5
    holder.Parent = parent
    local holderLayout = Instance.new("UIListLayout", holder)
    holderLayout.FillDirection = Enum.FillDirection.Vertical
    holderLayout.Padding = UDim.new(0, 6)
    holderLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local row = Instance.new("Frame")
    row.Name = name
    row.BackgroundTransparency = 1
    row.Size = UDim2.new(1, 0, 0, 28)
    row.LayoutOrder = 1
    row.Parent = holder

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = name
    label.Parent = row

    local preview = Instance.new("TextButton")
    preview.BackgroundColor3 = defaultColor
    preview.Size = UDim2.new(0, 26, 0, 22)
    preview.Position = UDim2.new(1, -26, 0, 3)
    preview.Text = ""
    preview.AutoButtonColor = false
    preview.ZIndex = 5
    preview.Parent = row
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", preview).Color = Color3.fromRGB(70, 70, 70)

    local picker = Instance.new("Frame")
    picker.Name = "Picker"
    picker.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    picker.Size = UDim2.new(1, 0, 0, 130)
    picker.Visible = false
    picker.LayoutOrder = 2
    picker.ZIndex = 5
    picker.Parent = holder
    Instance.new("UICorner", picker).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", picker).Color = Color3.fromRGB(70, 70, 70)

    local svBox = Instance.new("ImageButton")
    svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
    svBox.Position = UDim2.new(0, 10, 0, 10)
    svBox.Size = UDim2.new(1, -42, 0, 110)
    svBox.AutoButtonColor = false
    svBox.Parent = picker
    Instance.new("UICorner", svBox).CornerRadius = UDim.new(0, 6)

    local whiteOverlay = Instance.new("Frame")
    whiteOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
    whiteOverlay.BorderSizePixel = 0
    whiteOverlay.Size = UDim2.new(1, 0, 1, 0)
    whiteOverlay.ZIndex = 7
    whiteOverlay.Active = false
    whiteOverlay.Parent = svBox
    Instance.new("UICorner", whiteOverlay).CornerRadius = UDim.new(0, 6)
    local satGrad = Instance.new("UIGradient")
    satGrad.Rotation = 0
    satGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
    satGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
    satGrad.Parent = whiteOverlay

    local valFrame = Instance.new("Frame")
    valFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    valFrame.BorderSizePixel = 0
    valFrame.Size = UDim2.new(1, 0, 1, 0)
    valFrame.ZIndex = 8
    valFrame.Active = false
    valFrame.Parent = svBox
    Instance.new("UICorner", valFrame).CornerRadius = UDim.new(0, 6)
    local valGrad = Instance.new("UIGradient")
    valGrad.Rotation = 90
    valGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
    valGrad.Parent = valFrame

    local svCursor = Instance.new("Frame")
    svCursor.Size = UDim2.new(0, 14, 0, 14)
    svCursor.BackgroundTransparency = 1
    svCursor.ZIndex = 9
    svCursor.Parent = svBox
    local svInner = Instance.new("Frame")
    svInner.Size = UDim2.new(1, -4, 1, -4)
    svInner.Position = UDim2.new(0, 2, 0, 2)
    svInner.BackgroundTransparency = 1
    svInner.Parent = svCursor
    Instance.new("UICorner", svInner).CornerRadius = UDim.new(1, 0)
    local svStroke = Instance.new("UIStroke", svInner)
    svStroke.Color = Color3.fromRGB(255, 255, 255)
    svStroke.Thickness = 2

    local hueBar = Instance.new("ImageButton")
    hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueBar.Position = UDim2.new(1, -22, 0, 10)
    hueBar.Size = UDim2.new(0, 12, 0, 110)
    hueBar.AutoButtonColor = false
    hueBar.Parent = picker
    Instance.new("UICorner", hueBar).CornerRadius = UDim.new(1, 0)
    local hueGrad = Instance.new("UIGradient")
    hueGrad.Rotation = 90
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.16, Color3.fromHSV(0.16, 1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.66, Color3.fromHSV(0.66, 1, 1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
    })
    hueGrad.Parent = hueBar

    local hueCursor = Instance.new("Frame")
    hueCursor.AnchorPoint = Vector2.new(0, 0.5)
    hueCursor.Size = UDim2.new(1, 6, 0, 6)
    hueCursor.Position = UDim2.new(0, -3, 0, 0)
    hueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hueCursor.BorderSizePixel = 0
    hueCursor.ZIndex = 10
    hueCursor.Active = false
    hueCursor.Parent = hueBar
    Instance.new("UICorner", hueCursor).CornerRadius = UDim.new(0, 2)
    Instance.new("UIStroke", hueCursor).Color = Color3.fromRGB(0, 0, 0)

    local function updateVisual()
        local color = Color3.fromHSV(h, s, v)
        preview.BackgroundColor3 = color
        svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        svCursor.Position = UDim2.new(s, -7, 1 - v, -7)
        hueCursor.Position = UDim2.new(0, -4, math.clamp(h, 0.03, 0.97), 0)
        if onChange then onChange(color) end
    end

    local draggingSV = false
    local draggingHue = false

    local function updateSV(input)
        local pos = svBox.AbsolutePosition
        local size = svBox.AbsoluteSize
        s = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
        v = 1 - math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
        updateVisual()
    end
    local function updateHue(input)
        local pos = hueBar.AbsolutePosition
        local size = hueBar.AbsoluteSize
        h = math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
        updateVisual()
    end

    svBox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = true updateSV(input) end
    end)
    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingHue = true updateHue(input) end
    end)
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if draggingSV then updateSV(input) end
            if draggingHue then updateHue(input) end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then draggingSV = false draggingHue = false end
    end)
    preview.MouseButton1Click:Connect(function()
        picker.Visible = not picker.Visible
    end)
    updateVisual()
end

CreateFogColorPicker(contentFog, "Fog Color", FogColor, function(c)
    FogColor = c
    if FogEnabled and FogMode == "Custom" then ApplyMode() end
end, 5)

    local holderFlash = Instance.new("Frame", contentFog)
    holderFlash.Size = UDim2.new(1,0,0,28)
    holderFlash.BackgroundTransparency = 1
    holderFlash.ZIndex = 5
    holderFlash.LayoutOrder = 6
    local labelFlash = Instance.new("TextLabel", holderFlash)
    labelFlash.Size = UDim2.new(1,-50,1,0)
    labelFlash.BackgroundTransparency = 1
    labelFlash.Text = "Flashlight"
    labelFlash.Font = Enum.Font.GothamBold
    labelFlash.TextSize = 13
    labelFlash.TextColor3 = Color3.fromRGB(235,235,235)
    labelFlash.TextXAlignment = Enum.TextXAlignment.Left
    labelFlash.ZIndex = 5
    local btnFlash = Instance.new("TextButton", holderFlash)
    btnFlash.Size = UDim2.new(0,44,0,20)
    btnFlash.Position = UDim2.new(1,-44,0.5,-10)
    btnFlash.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnFlash.BackgroundTransparency = 0.25
    btnFlash.Text = ""
    btnFlash.BorderSizePixel = 0
    btnFlash.ZIndex = 5
    Instance.new("UICorner", btnFlash).CornerRadius = UDim.new(1,0)
    local circleFlash = Instance.new("Frame", btnFlash)
    circleFlash.Size = UDim2.new(0,16,0,16)
    circleFlash.Position = UDim2.new(0,2,0.5,-8)
    circleFlash.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circleFlash.BorderSizePixel = 0
    circleFlash.ZIndex = 6
    Instance.new("UICorner", circleFlash).CornerRadius = UDim.new(1,0)
    btnFlash.MouseButton1Click:Connect(function()
        FlashEnabled = not FlashEnabled
        if FlashEnabled then
            TweenService:Create(btnFlash,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(circleFlash,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
        else
            TweenService:Create(btnFlash,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
            TweenService:Create(circleFlash,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
        end
        UpdateFlashlight(FlashEnabled)
    end)

    do
        local holder = Instance.new("Frame", contentFog)
        holder.Name = "FlashlightIntensityHolder"
        holder.Size = UDim2.new(1, 0, 0, 40)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 5
        holder.LayoutOrder = 7
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1, -50, 0, 20)
        label.Position = UDim2.new(0, 0, 0, 5)
        label.BackgroundTransparency = 1
        label.Text = "Flashlight Intensity"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235, 235, 235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 5
        local valueLabel = Instance.new("TextLabel", holder)
        valueLabel.Size = UDim2.new(0, 40, 0, 20)
        valueLabel.Position = UDim2.new(1, -40, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = string.format("%.2f", Brightness2)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.ZIndex = 5
        local bar = Instance.new("TextButton", holder)
        bar.Size = UDim2.new(1, 0, 0, 5)
        bar.Position = UDim2.new(0, 0, 0, 28)
        bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        bar.BorderSizePixel = 0
        bar.Text = ""
        bar.AutoButtonColor = false
        bar.ZIndex = 5
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)
        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((Brightness2 - 1) / (10 - 1), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 6
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 3)
        local dragging = false
        local function update(inputX)
            local scale = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = 1 + (10 - 1) * scale
            value = math.floor(value * 100 + 0.5) / 100
            TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
            valueLabel.Text = string.format("%.2f", value)
            Brightness2 = value
            if FlashEnabled then UpdateFlashlight(true) end
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true update(input.Position.X) end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if FlashEnabled then UpdateFlashlight(true) end
    end)
end

do
    local settingsPageH = pages["Auto Farm"]

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    if getgenv().NexFarm then
        getgenv().NexFarm.AutoHackPC = false
        getgenv().NexFarm.AutoWinTP = false
        getgenv().NexFarm.AutoWinFly = false
        getgenv().NexFarm.AutoBeast = false
        getgenv().NexFarm.AutoSave = false
        getgenv().NexFarm.AutoSaveSilent = false
        getgenv().NexFarm.AntiAFK = false
        getgenv().NexFarm.AutoRejoin = false
        if getgenv().NexFarm.Threads and getgenv().NexFarm.Threads.Fly then
            pcall(function() getgenv().NexFarm.Threads.Fly:Disconnect() end)
            getgenv().NexFarm.Threads.Fly = nil
        end
    end

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    Instance.new("UIPadding", columnsH).PaddingTop = UDim.new(0, 10)
    Instance.new("UIPadding", columnsH).PaddingLeft = UDim.new(0, 10)
    Instance.new("UIPadding", columnsH).PaddingRight = UDim.new(0, 10)

    local boxMain, contentMain = CreateGroupbox(columnsH, "Auto Farm")
    boxMain.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxMain.BackgroundTransparency = 1
    boxMain.BorderSizePixel = 0
    boxMain.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxMain).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxMain).Color = Color3.fromRGB(70,70,70)

    local title = Instance.new("TextLabel", contentMain)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "EM MANUTENÇÃO"
    title.Font = CurrentFont or Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local line = Instance.new("Frame", contentMain)
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, 0)
    line.BackgroundColor3 = Color3.fromRGB(70,70,70)
    line.BorderSizePixel = 0

    local desc = Instance.new("TextLabel", contentMain)
    desc.Size = UDim2.new(1, 0, 0, 70)
    desc.BackgroundTransparency = 1
    desc.Text = "O Auto Farm está em manutenção no momento.\nEstamos corrigindo e melhorando as funções.\n\nVolte em breve!"
    desc.Font = CurrentFont or Enum.Font.Gotham
    desc.TextSize = 14
    desc.TextColor3 = Color3.fromRGB(200, 200, 200)
    desc.TextWrapped = true
    desc.TextYAlignment = Enum.TextYAlignment.Top

    local badge = Instance.new("TextLabel", contentMain)
    badge.Size = UDim2.new(1, 0, 0, 28)
    badge.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    badge.Text = "Aguarda uma nova atualização."
    badge.Font = CurrentFont or Enum.Font.GothamBold
    badge.TextSize = 12
    badge.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke", badge)
    st.Color = Color3.fromRGB(70, 70, 70)
    st.Thickness = 1
end

do
    local settingsPageH = pages["Advanced"]
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Player = LocalPlayer
    local Workspace = game:GetService("Workspace")

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") or v:IsA("UIListLayout") or v:IsA("UIPadding") then
            v:Destroy()
        end
    end

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Name = "ColumnsContainer"
    columnsH.Size = UDim2.new(1, 0, 1, 0)
    columnsH.BackgroundTransparency = 1

    local padding = Instance.new("UIPadding", columnsH)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Name = "LeftColumn"
    leftColH.Size = UDim2.new(0.5, -10, 1, 0)
    leftColH.BackgroundTransparency = 1

    local leftList = Instance.new("UIListLayout", leftColH)
    leftList.Padding = UDim.new(0, 10)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Name = "RightColumn"
    rightColH.Size = UDim2.new(0.5, -10, 1, 0)
    rightColH.Position = UDim2.new(0.5, 10, 0, 0)
    rightColH.BackgroundTransparency = 1

    local rightList = Instance.new("UIListLayout", rightColH)
    rightList.Padding = UDim.new(0, 10)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder

    local boxLeft, contentLeft = CreateGroupbox(leftColH, "Survivor")
    boxLeft.LayoutOrder = 1

    local boxMovement, contentMovement = CreateGroupbox(leftColH, "Character")
    boxMovement.LayoutOrder = 2

    local boxRight, contentRight = CreateGroupbox(rightColH, "Beast")
    boxRight.LayoutOrder = 1

    local function CreateSlider(parent, text, min, max, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,40)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,0,20)
        label.Position = UDim2.new(0,15,0,5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2

        local valueLabel = Instance.new("TextLabel", holder)
        valueLabel.Size = UDim2.new(0,40,0,20)
        valueLabel.Position = UDim2.new(1,-45,0,5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = Color3.fromRGB(235,235,235)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.ZIndex = 2

        local bar = Instance.new("TextButton", holder)
        bar.Size = UDim2.new(1,-30,0,5)
        bar.Position = UDim2.new(0,15,0,28)
        bar.BackgroundColor3 = Color3.fromRGB(50,50,55)
        bar.BorderSizePixel = 0
        bar.Text = ""
        bar.AutoButtonColor = false
        bar.ZIndex = 2
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)

        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 3
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)

        local dragging = false
        local function update(inputX)
            local scale = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * scale + 0.5)
            TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
            valueLabel.Text = tostring(value)
            callback(value)
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local fatigueEnabled = false
    local fatigueDelay = 1.0
    local fatigueDuration = 2.0
    local fatigueSpeed = 3.4
    local fatigueConnection = nil
    local fatigueState = "idle"
    local fatigueTimer = 0
    local lastSpeedCheck = 0

    local function StartFatigueMonitoring()
        if fatigueConnection then fatigueConnection:Disconnect() end
        fatigueConnection = RunService.Heartbeat:Connect(function(dt)
            if not fatigueEnabled then 
                fatigueState = "idle" 
                fatigueTimer = 0 
                return 
            end
            
            local MyChar = LocalPlayer.Character
            if not MyChar then fatigueState = "idle" fatigueTimer = 0 return end
            local Humanoid = MyChar:FindFirstChild("Humanoid")
            local Beast = MyChar:FindFirstChild("BeastPowers")
            if not Humanoid or not Beast then fatigueState = "idle" fatigueTimer = 0 return end
            
            local currentSpeed = Humanoid.WalkSpeed
            fatigueTimer = fatigueTimer + dt

            if currentSpeed >= 16 and fatigueState == "idle" then
                fatigueState = "delay"
                fatigueTimer = 0
            end

            if fatigueState == "delay" then
                Humanoid.WalkSpeed = 20
                if fatigueTimer >= fatigueDelay then
                    fatigueState = "fatigued"
                    fatigueTimer = 0
                end

            elseif fatigueState == "fatigued" then
                Humanoid.WalkSpeed = fatigueSpeed
                if fatigueTimer >= fatigueDuration then
                    fatigueState = "idle"
                    fatigueTimer = 0
                end
            end

            if currentSpeed < 16 and fatigueState ~= "idle" then
                fatigueState = "idle"
                fatigueTimer = 0
            end
            if Humanoid.Health <= 0 then
                fatigueState = "idle"
                fatigueTimer = 0
            end
        end)
    end

    local function StopFatigueMonitoring()
        if fatigueConnection then fatigueConnection:Disconnect() fatigueConnection = nil end
        fatigueState = "idle" 
        fatigueTimer = 0
        local char = Player.Character
        if char and char:FindFirstChild("Humanoid") then 
            char.Humanoid.WalkSpeed = speedEnabled and speedValue or defaultSpeed 
        end
    end

    local beastUntie = false
    CreateToggle(contentLeft, "Beast Untie Player", false, function(state)
        beastUntie = state
        if state then
            local function ObterEventoMarreta()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Hammer") then
                        return player.Character:FindFirstChild("HammerEvent", true)
                    end
                end
                return nil
            end
            task.spawn(function()
                while beastUntie do
                    local eventoMarreta = ObterEventoMarreta()
                    if eventoMarreta and eventoMarreta:IsA("RemoteEvent") then
                        pcall(function() eventoMarreta:FireServer("HammerClick", true) end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    local antiRagdoll = false
    CreateToggle(contentLeft, "Anti Ragdoll", false, function(state)
        antiRagdoll = state
        getgenv().AntiRagdollLigado = state
        if state then
            task.spawn(function()
                while getgenv().AntiRagdollLigado do
                    task.wait(0.1)
                    pcall(function()
                        local Character = LocalPlayer.Character
                        if not Character then return end
                        local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                        if not Humanoid then return end
                        local Stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
                        if Stats then
                            local Ragdoll = Stats:FindFirstChild("Ragdoll")
                            if Ragdoll and Ragdoll:IsA("BoolValue") and Ragdoll.Value then
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                                Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                                Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            end
                        end
                    end)
                end
                pcall(function()
                    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                    if Humanoid then
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                        Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
                    end
                end)
            end)
        end
    end)

    local slowBeast = false
    CreateToggle(contentLeft, "Slow Beast", false, function(state)
        slowBeast = state
        getgenv().SlowBeastLigado = state
        if state then
            local function ObterEventoMarretaao()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if player.Character:FindFirstChild("BeastPowers") then
                            return player.Character:FindFirstChild("PowersEvent", true)
                        end
                    end
                end
                return nil
            end
            task.spawn(function()
                while getgenv().SlowBeastLigado do
                    local eventoPoderes = ObterEventoMarretaao()
                    if eventoPoderes and eventoPoderes:IsA("RemoteEvent") then
                        pcall(function() eventoPoderes:FireServer("Jumped") end)
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    local smartSlowBeast = false
    CreateToggle(contentLeft, "Slow Beast Runner", false, function(state)
        smartSlowBeast = state
        getgenv().SmartSlowBeastLigado = state
        if state then
            local energiaAnterior = 100
            local function ObterDadosDaFera()
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local beastPowers = player.Character:FindFirstChild("BeastPowers")
                        if beastPowers then
                            local powersEvent = player.Character:FindFirstChild("PowersEvent", true)
                            local staminaValue = beastPowers:FindFirstChildOfClass("NumberValue")
                            if powersEvent and staminaValue then
                                return powersEvent, staminaValue
                            end
                        end
                    end
                end
                return nil, nil
            end
            task.spawn(function()
                while getgenv().SmartSlowBeastLigado do
                    local eventoPoderes, valorStamina = ObterDadosDaFera()
                    if eventoPoderes and valorStamina then
                        local energiaAtual = valorStamina.Value
                        if energiaAtual < energiaAnterior then
                            pcall(function() eventoPoderes:FireServer("Jumped") end)
                        end
                        energiaAnterior = energiaAtual
                    else
                        energiaAnterior = 100
                    end
                    task.wait(0.1)
                end
            end)
        end
    end)

    local forceBeastInput = false
    CreateToggle(contentLeft, "Beast Ability", false, function(state)
        forceBeastInput = state
        if state then
            task.spawn(function()
                while forceBeastInput do
                    for _, plr in pairs(Players:GetPlayers()) do
                        local char = plr.Character
                        if char and char:FindFirstChild("BeastPowers") then
                            local event = char:FindFirstChild("PowersEvent", true)
                            if event then
                                pcall(function() event:FireServer("Input") end)
                                break
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local lastPower = nil
local powerConnection = nil

function Notify(title, text, duration)
    local gui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("EclipseUI") 
    
    if not gui then
        local screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
        screen.Name = "EclipseBeast"
        gui = screen
    end

    duration = duration or 3

    local notify = Instance.new("Frame", gui)
    notify.Size = UDim2.new(0, 260, 0, 70)
    notify.AnchorPoint = Vector2.new(1, 1)
    notify.Position = UDim2.new(1, 300, 1, -25)
    notify.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notify.BorderSizePixel = 0
    notify.ZIndex = 1000

    Instance.new("UICorner", notify).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", notify)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1

    local icon = Instance.new("ImageLabel", notify)
    icon.Size = UDim2.new(0, 42, 0, 42)
    icon.Position = UDim2.new(0, 12, 0.5, -21)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://123245923618767"

    local titleLabel = Instance.new("TextLabel", notify)
    titleLabel.Size = UDim2.new(1, -65, 0, 22)
    titleLabel.Position = UDim2.new(0, 60, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextSize = 15
    titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local textLabel = Instance.new("TextLabel", notify)
    textLabel.Size = UDim2.new(1, -65, 0, 18)
    textLabel.Position = UDim2.new(0, 60, 0, 34)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Text = text
    textLabel.TextSize = 13
    textLabel.TextColor3 = Color3.fromRGB(180,180,180)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    local barBg = Instance.new("Frame", notify)
    barBg.Size = UDim2.new(1, 0, 0, 3)
    barBg.Position = UDim2.new(0, 0, 1, -3)
    barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    barBg.BorderSizePixel = 0

    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bar.BorderSizePixel = 0

    TweenService:Create(notify, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -25)}):Play()
    TweenService:Create(bar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0,0,1,0)}):Play()

    task.delay(duration, function()
        TweenService:Create(notify, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, -25)}):Play()
        task.wait(0.35)
        notify:Destroy()
    end)
end

CreateToggle(contentLeft, "Beast Power Notify", false, function(state)
    local CurrentPower = ReplicatedStorage:WaitForChild("CurrentPower")

    if state then
        if CurrentPower.Value and CurrentPower.Value ~= "" then
            task.wait(0.2)
            Notify("Current Beast", "Beast Power: "..tostring(CurrentPower.Value), 4)
            lastPower = CurrentPower.Value
        end

        powerConnection = CurrentPower.Changed:Connect(function(newVal)
            if not newVal or newVal == "" then return end
            if lastPower ~= newVal then
                Notify("Current Beast", "Beast Power: "..tostring(newVal), 4)
                lastPower = newVal
            end
        end)
    else
        if powerConnection then 
            powerConnection:Disconnect() 
            powerConnection = nil 
        end
        lastPower = nil
    end
end)

    local touchFlingEnabled = false
    CreateToggle(contentLeft, "Touch Fling", false, function(state)
        touchFlingEnabled = state
        _G.TouchFlingEnabled = state
        if state then
            task.spawn(function()
                local movel = 0.05
                while _G.TouchFlingEnabled do
                    RunService.Heartbeat:Wait()
                    local Character = Player.Character
                    local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
                    if RootPart then
                        local oldVel = RootPart.Velocity
                        RootPart.Velocity = (oldVel * 9e8) + Vector3.new(0, 9e8, 0)
                        RunService.RenderStepped:Wait()
                        if RootPart then RootPart.Velocity = oldVel end
                        RunService.Stepped:Wait()
                        if RootPart then
                            RootPart.Velocity = oldVel + Vector3.new(0, movel, 0)
                            movel = movel * -1
                        end
                    end
                end
            end)
        end
    end)

    local wallHopEnabled = false
    local isFlicking = false
    local lastFlickTime = 0
    local lastHitInstance = nil
    local Camera = workspace.CurrentCamera

    local function performVideoFlick()
        if isFlicking then return end
        isFlicking = true
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then isFlicking = false return end
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
        local startCFrame = Camera.CFrame
        Camera.CFrame = startCFrame * CFrame.Angles(0, math.rad(180), 0)
        task.wait(0.01)
        Camera.CFrame = startCFrame
        isFlicking = false
    end

    RunService.Heartbeat:Connect(function()
        if not wallHopEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {char}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(hrp.Position, Camera.CFrame.LookVector * 3, raycastParams)
        if result and result.Instance.CanCollide then
            if lastHitInstance and lastHitInstance ~= result.Instance then
                if tick() - lastFlickTime > 0.05 then
                    lastFlickTime = tick()
                    performVideoFlick()
                end
            end
            lastHitInstance = result.Instance
        else
            lastHitInstance = nil
        end
    end)

    CreateToggle(contentLeft, "Macro WallHop", false, function(state)
        wallHopEnabled = state
    end)

    local speedEnabled = false
    local speedValue = 16
    local defaultSpeed = 16
    _G.WalkSpeedConnection = nil

    CreateToggle(contentMovement, "Enable WalkSpeed", false, function(state)
        speedEnabled = state
        if state then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = speedValue end
            if _G.WalkSpeedConnection then _G.WalkSpeedConnection:Disconnect() end
            _G.WalkSpeedConnection = Player.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid").WalkSpeed = speedValue
            end)
        else
            if _G.WalkSpeedConnection then _G.WalkSpeedConnection:Disconnect() _G.WalkSpeedConnection = nil end
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = defaultSpeed end
        end
    end)

    CreateSlider(contentMovement, "Walkspeed", 16, 50, 16, function(value)
        speedValue = value
        if speedEnabled then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = value end
        end
    end)

    CreateToggle(contentMovement, "Enable Fatigue", false, function(state)
        fatigueEnabled = state
        if state then StartFatigueMonitoring() else StopFatigueMonitoring() end
    end)
    CreateSlider(contentMovement, "Fatigue Delay", 0.1, 5, 1.0, function(value) fatigueDelay = value end)
    CreateSlider(contentMovement, "Fatigue Duration", 0.1, 5, 2.0, function(value) fatigueDuration = value end)
    CreateSlider(contentMovement, "Fatigue Speed", 1, 10, 3.4, function(value) fatigueBoostSpeed = value end)

    local jumpEnabled = false
    local jumpValue = 50
    local defaultJumpPower = nil
    local defaultUseJumpPower = nil
    local defaultJumpHeight = nil

    local function applyJump()
        local character = Player.Character
        if not character then return end
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        if defaultJumpPower == nil then
            defaultJumpPower = humanoid.JumpPower
            defaultUseJumpPower = humanoid.UseJumpPower
            defaultJumpHeight = humanoid.JumpHeight
        end
        if jumpEnabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = jumpValue
        else
            humanoid.UseJumpPower = defaultUseJumpPower
            if defaultUseJumpPower then humanoid.JumpPower = defaultJumpPower else humanoid.JumpHeight = defaultJumpHeight end
        end
    end

    Player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyJump()
    end)

    CreateToggle(contentMovement, "Enable High Jump", false, function(state)
        jumpEnabled = state
        applyJump()
    end)

    CreateSlider(contentMovement, "Jump Power", 50, 200, 50, function(value)
        jumpValue = value
        if jumpEnabled then applyJump() end
    end)

local crawlBoostEnabled = false
    local crawlBoostSpeed = 22
    local crawlConnection = nil

    CreateToggle(contentMovement, "Enable Crawl", false, function(state)
        crawlBoostEnabled = state
        if state then
            if crawlConnection then crawlConnection:Disconnect() end
            crawlConnection = RunService.RenderStepped:Connect(function()
                local char = Player.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid and crawlBoostEnabled then
                    local floorMaterial = humanoid.FloorMaterial
                    if floorMaterial ~= Enum.Material.Air then
                        if humanoid.WalkSpeed > 1 and humanoid.WalkSpeed < 11 then
                            humanoid.WalkSpeed = crawlBoostSpeed
                        end
                    end
                end
            end)
        else
            if crawlConnection then crawlConnection:Disconnect() crawlConnection = nil end
            local char = Player.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if speedEnabled then humanoid.WalkSpeed = speedValue else humanoid.WalkSpeed = defaultSpeed end
            end
        end
    end)

    CreateSlider(contentMovement, "Crawl Speed", 16, 50, 22, function(value)
        crawlBoostSpeed = value
    end)

    local classicCamEnabled = false
    local classicCamConnection = nil
    local noclipEnabled = false
    local autoCrawlBeast = false
    local beastCrawlConnection = nil
    local CRAWL_BOOST_SPEED = 22
    local autoTie = false
    local tieRange = 15
    local autoPegarCorda = false
    local hitAura = false
    local hitRange = 50
    local hitbox = false
    local hideHitbox = false
    local hitboxX, hitboxY, hitboxZ = 5, 5, 5

    local autoHitBeast = false
    local autoHitRange = 10
    local autoHitDelay = 1.0
    local systemEnabled = false
    local hitCooldown = {}
    local jumpedUsed = {}
    local Hammer, SoundHitPlayer, SoundHitWall
    local normalAnim, hitAnim, animator, wallActive, hitAnimPlaying
    local Char = Player.Character
    local HRP = Char and Char:FindFirstChild("HumanoidRootPart")
    local Hum = Char and Char:FindFirstChildOfClass("Humanoid")

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

    Player.CharacterAdded:Connect(function(c)
        Char = c
        HRP = c:WaitForChild("HumanoidRootPart")
        Hum = c:WaitForChild("Humanoid")
        animator = Hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", Hum)
        rayParams.FilterDescendantsInstances = {Char}
        table.clear(hitCooldown)
    end)

    if Char then
        animator = Hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", Hum)
        rayParams.FilterDescendantsInstances = {Char}
    end

    local function isBeast()
        return Char and Char:FindFirstChild("Hammer") and Char:FindFirstChild("BeastPowers")
    end
    local function fullStop()
        if SoundHitWall and SoundHitWall.IsPlaying then SoundHitWall:Stop() end
        if normalAnim and normalAnim.IsPlaying then normalAnim:Stop() end
        wallActive = false
        hitAnimPlaying = false
        table.clear(hitCooldown)
        table.clear(jumpedUsed)
    end
    local function loadBeastAssets()
        if not Char then return false end
        Hammer = Char:FindFirstChild("Hammer")
        if not Hammer then return false end
        local Handle = Hammer:FindFirstChild("Handle")
        if not Handle then return false end
        SoundHitPlayer = Handle:FindFirstChild("SoundHitPlayer")
        SoundHitWall = Handle:FindFirstChild("SoundHitWall")
        if SoundHitWall then SoundHitWall.Looped = true end
        local baseAnim = Hammer:FindFirstChildWhichIsA("Animation")
        if baseAnim then
            local anim = Instance.new("Animation")
            anim.AnimationId = baseAnim.AnimationId
            normalAnim = animator:LoadAnimation(anim)
            normalAnim.Looped = true
        end
        hitAnim = Hammer:FindFirstChild("HitPlayerAnimation")
        return true
    end
    local function playHitAnim()
        if hitAnimPlaying or not hitAnim then return end
        hitAnimPlaying = true
        if normalAnim and normalAnim.IsPlaying then normalAnim:Stop() end
        local track = animator:LoadAnimation(hitAnim)
        track:Play()
        track.Stopped:Once(function()
            hitAnimPlaying = false
            if normalAnim then normalAnim:Play() end
        end)
    end
    local function checkWall()
        if not HRP or not HRP.Parent then return end
        local result = Workspace:Raycast(HRP.Position, HRP.CFrame.LookVector * 2.5, rayParams)
        if result then
            if not wallActive then
                wallActive = true
                if normalAnim and not hitAnimPlaying then normalAnim:Play() end
                if SoundHitWall and not SoundHitWall.IsPlaying then SoundHitWall:Play() end
            end
        else
            if wallActive then
                wallActive = false
                if SoundHitWall and SoundHitWall.IsPlaying then SoundHitWall:Stop() end
            end
        end
    end
    local function isRagdoll(plr)
        local c = plr.Character
        if not c then return false end
        local h = c:FindFirstChildOfClass("Humanoid")
        return h and h.PlatformStand
    end
    local function getTargetsInRange()
        local targets = {}
        if not HRP then return targets end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health > 0 then
                    local dist = (HRP.Position - root.Position).Magnitude
                    if dist <= autoHitRange then
                        table.insert(targets, {player = plr, root = root})
                    end
                end
            end
        end
        return targets
    end

    RunService.Heartbeat:Connect(function()
        if not autoHitBeast or not isBeast() then
            if systemEnabled then systemEnabled = false fullStop() end
            return
        end
        if not systemEnabled then
            if loadBeastAssets() then systemEnabled = true else return end
        end
        if not HRP or not HRP.Parent then return end
        checkWall()
        local targets = getTargetsInRange()
        for _, data in ipairs(targets) do
            local plr = data.player
            local root = data.root
            if isRagdoll(plr) then
                if not jumpedUsed[plr] then
                    jumpedUsed[plr] = true
                    if Char:FindFirstChild("BeastPowers") and Char.BeastPowers:FindFirstChild("PowersEvent") then
                        Char.BeastPowers.PowersEvent:FireServer("Jumped")
                    end
                end
            else
                jumpedUsed[plr] = nil
                if not hitCooldown[plr] then
                    hitCooldown[plr] = true
                    if Hammer and Hammer:FindFirstChild("HammerEvent") then
                        Hammer.HammerEvent:FireServer("HammerHit", root)
                    end
                    if SoundHitPlayer then SoundHitPlayer:Play() end
                    playHitAnim()
                    task.delay(autoHitDelay, function() hitCooldown[plr] = nil end)
                end
            end
        end
    end)

    CreateToggle(contentRight, "Camera Mode", false, function(state)
        classicCamEnabled = state
        _G.CamDModeEnabled = state
        if state then
            if classicCamConnection then classicCamConnection:Disconnect() end
            classicCamConnection = task.spawn(function()
                while _G.CamDModeEnabled do
                    task.wait(0.2)
                    if Player.CameraMode ~= Enum.CameraMode.Classic then
                        Player.CameraMode = Enum.CameraMode.Classic
                    end
                end
            end)
        else
            if classicCamConnection then task.cancel(classicCamConnection) classicCamConnection = nil end
        end
    end)

    CreateToggle(contentRight, "Noclip", false, function(state) noclipEnabled = state end)
    CreateToggle(contentRight, "Auto Hit Beast", false, function(state) autoHitBeast = state end)
    CreateSlider(contentRight, "Auto Hit Range", 5, 10, 10, function(value) autoHitRange = value end)
    CreateSlider(contentRight, "Auto Hit Delay", 0.5, 1.5, 1.0, function(value) autoHitDelay = value end)

    CreateToggle(contentRight, "Crawl Beast", false, function(state)
        autoCrawlBeast = state
        if state then
            if beastCrawlConnection then beastCrawlConnection:Disconnect() end
            beastCrawlConnection = RunService.RenderStepped:Connect(function()
                local char = Player.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid and autoCrawlBeast and char:FindFirstChild("BeastPowers") then
                    if humanoid.WalkSpeed > 1 and humanoid.WalkSpeed < 11 then
                        humanoid.WalkSpeed = CRAWL_BOOST_SPEED
                    end
                end
            end)
        else
            if beastCrawlConnection then beastCrawlConnection:Disconnect() beastCrawlConnection = nil end
        end
    end)

    CreateToggle(contentRight, "Auto Tie aura", false, function(state) autoTie = state end)
    CreateToggle(contentRight, "Auto Tie After Hit", false, function(state) autoPegarCorda = state end)
    CreateSlider(contentRight, "Auto Tie Range", 5, 50, 15, function(value) tieRange = value end)

    CreateToggle(contentRight, "Hit Aura", false, function(state) hitAura = state getgenv().HitAuraAtivo = state end)
    CreateSlider(contentRight, "Hit Aura Range", 5, 100, 50, function(value) hitRange = value end)

    CreateToggle(contentRight, "Enable Hitbox", false, function(state) hitbox = state end)
    CreateToggle(contentRight, "Hide Hitbox", false, function(state) hideHitbox = state end)
    CreateSlider(contentRight, "Hitbox X", 2, 10, 5, function(value) hitboxX = value end)
    CreateSlider(contentRight, "Hitbox Y", 2, 10, 5, function(value) hitboxY = value end)
    CreateSlider(contentRight, "Hitbox Z", 2, 10, 5, function(value) hitboxZ = value end)

    RunService.Stepped:Connect(function()
        if noclipEnabled then
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.25)
            if autoTie then
                pcall(function()
                    local MeuPersonagem = LocalPlayer.Character
                    if not MeuPersonagem then return end
                    local MeuEventoMarreta = MeuPersonagem:FindFirstChild("HammerEvent", true)
                    local MinhaRaiz = MeuPersonagem:FindFirstChild("HumanoidRootPart")
                    if not MeuEventoMarreta or not MinhaRaiz then return end
                    for _, alvo in pairs(Players:GetPlayers()) do
                        if alvo ~= LocalPlayer and alvo.Character then
                            local Stats = alvo:FindFirstChild("TempPlayerStatsModule")
                            if Stats then
                                local alvoCaido = Stats:FindFirstChild("Ragdoll")
                                local alvoCapturado = Stats:FindFirstChild("Captured")
                                if alvoCaido and alvoCapturado and alvoCaido.Value == true and alvoCapturado.Value == false then
                                    local RaizAlvo = alvo.Character:FindFirstChild("HumanoidRootPart")
                                    if RaizAlvo and (RaizAlvo.Position - MinhaRaiz.Position).Magnitude <= tieRange then
                                        MeuEventoMarreta:FireServer("HammerTieUp", RaizAlvo, RaizAlvo.Position)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    task.spawn(function()
        local JaAmarrados = {}
        while true do
            task.wait(0.2)
            if autoPegarCorda then
                pcall(function()
                    local MeuPersonagem = LocalPlayer.Character
                    if not MeuPersonagem then return end
                    local MeuEventoMarreta = MeuPersonagem:FindFirstChild("HammerEvent", true)
                    local MinhaRaiz = MeuPersonagem:FindFirstChild("HumanoidRootPart")
                    if not MeuEventoMarreta or not MinhaRaiz then return end
                    for _, alvo in pairs(Players:GetPlayers()) do
                        if alvo ~= LocalPlayer and alvo.Character then
                            local Stats = alvo:FindFirstChild("TempPlayerStatsModule")
                            if Stats then
                                local alvoCaido = Stats:FindFirstChild("Ragdoll")
                                local alvoCapturado = Stats:FindFirstChild("Captured")
                                if alvoCaido and alvoCapturado then
                                    if alvoCaido.Value == true and alvoCapturado.Value == false and not JaAmarrados[alvo.Name] then
                                        local RaizAlvo = alvo.Character:FindFirstChild("HumanoidRootPart")
                                        if RaizAlvo and (RaizAlvo.Position - MinhaRaiz.Position).Magnitude <= tieRange then
                                            MeuEventoMarreta:FireServer("HammerTieUp", RaizAlvo, RaizAlvo.Position)
                                            JaAmarrados[alvo.Name] = true
                                        end
                                    elseif alvoCaido.Value == false then
                                        JaAmarrados[alvo.Name] = false
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    local function getRoot(character)
        if not character then return nil end
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end

    task.spawn(function()
        while true do
            task.wait(0.15)
            if getgenv().HitAuraAtivo then
                pcall(function()
                    local meChar = LocalPlayer.Character
                    local meRoot = getRoot(meChar)
                    if not meChar or not meRoot then return end
                    local HammerEvent = meChar:FindFirstChild("HammerEvent", true)
                    if not HammerEvent then return end
                    for _, alvo in pairs(Players:GetPlayers()) do
                        if alvo ~= LocalPlayer then
                            local stats = alvo:FindFirstChild("TempPlayerStatsModule")
                            if stats then
                                local isRagdoll = stats:FindFirstChild("Ragdoll")
                                local isCaptured = stats:FindFirstChild("Captured")
                                if isRagdoll and isCaptured and not isRagdoll.Value and not isCaptured.Value then
                                    local alvoChar = alvo.Character
                                    local alvoRoot = getRoot(alvoChar)
                                    if alvoRoot and (alvoRoot.Position - meRoot.Position).Magnitude <= hitRange then
                                        HammerEvent:FireServer("HammerHit", alvoRoot)
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    local hitboxParts = {}
    RunService.Heartbeat:Connect(function()
        if hitbox then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        if not hitboxParts[player] then
                            local box = Instance.new("Part")
                            box.Name = "HitboxVisual"
                            box.Anchored = true
                            box.CanCollide = false
                            box.CanQuery = false
                            box.CanTouch = false
                            box.Material = Enum.Material.Neon
                            box.Color = Color3.fromRGB(120, 120, 120)
                            box.Transparency = hideHitbox and 1 or 0.6
                            box.Parent = workspace
                            hitboxParts[player] = box
                        end
                        local box = hitboxParts[player]
                        box.Size = Vector3.new(hitboxX, hitboxY, hitboxZ)
                        box.CFrame = root.CFrame
                        box.Transparency = hideHitbox and 1 or 0.6
                    end
                end
            end
        else
            for player, box in pairs(hitboxParts) do
                if box then box:Destroy() end
                hitboxParts[player] = nil
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if hitboxParts[player] then
            hitboxParts[player]:Destroy()
            hitboxParts[player] = nil
        end
    end)

local HttpService = game:GetService("HttpService")
local SAVE_FILE = "Eclipse_JumpButtons_Save.json"

local SaveData = {
    JumpEnabled = false, JumpX = 0, JumpY = 0, JumpScale = 1,
    ThumbstickEnabled = false, ThumbstickX = 0, ThumbstickY = 0,
    EEnabled = false, EX = 0, EY = 0, ESize = 30,
    CEnabled = false, CX = 0, CY = 0, CSize = 30,
}

local function LoadSave()
    local ok, data = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
        return nil
    end)
    if ok and data and typeof(data) == "table" then
        for k, v in pairs(data) do SaveData[k] = v end
    end
    if getgenv and getgenv().Eclipse_JumpSave then
        for k, v in pairs(getgenv().Eclipse_JumpSave) do SaveData[k] = v end
    end
end

local function DoSave()
    if getgenv then getgenv().Eclipse_JumpSave = SaveData end
    pcall(function()
        if writefile then writefile(SAVE_FILE, HttpService:JSONEncode(SaveData)) end
    end)
end

LoadSave()

local boxJump, contentJump = CreateGroupbox(leftColH, "Jump & Classic")
boxJump.LayoutOrder = 3

local player = game.Players.LocalPlayer

local originals = {}
local function GetOriginal(btn)
    if not btn then return nil, nil end
    local o = originals[btn]
    if o then return o.Pos, o.Size end
    originals[btn] = {Pos = btn.Position, Size = btn.Size}
    return btn.Position, btn.Size
end

local function GetTouchFrame()
    local touchGui = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("TouchGui")
    if not touchGui then return nil end
    return touchGui:FindFirstChild("TouchControlFrame")
end
local function GetJumpButton()
    local tf = GetTouchFrame()
    return tf and tf:FindFirstChild("JumpButton")
end
local function GetThumbstick()
    local tf = GetTouchFrame()
    return tf and (tf:FindFirstChild("ThumbstickFrame") or tf:FindFirstChild("DynamicThumbstickFrame"))
end

local JumpEnabled = SaveData.JumpEnabled
local JumpX = SaveData.JumpX
local JumpY = SaveData.JumpY
local JumpScale = SaveData.JumpScale
local JumpSliders = {}

local ThumbstickEnabled = SaveData.ThumbstickEnabled
local ThumbstickX = SaveData.ThumbstickX
local ThumbstickY = SaveData.ThumbstickY
local ThumbstickSliders = {}

local function ApplyThumbstick()
    local thumbstick = GetThumbstick()
    if not thumbstick then return end
    local origPos = GetOriginal(thumbstick)
    if not origPos then return end
    pcall(function()
        if ThumbstickEnabled then
            local offsetX = origPos.X.Offset + (ThumbstickX * 5)
            local offsetY = origPos.Y.Offset + (ThumbstickY * 5)
            thumbstick.Position = UDim2.new(origPos.X.Scale, offsetX, origPos.Y.Scale, offsetY)
        else
            thumbstick.Position = origPos
        end
    end)
end

local function ApplyJump()
    local jumpButton = GetJumpButton()
    if not jumpButton then return end
    local origPos, origSize = GetOriginal(jumpButton)
    if not origPos or not origSize then return end
    pcall(function()
        if JumpEnabled then
            local offsetX = origPos.X.Offset + (JumpX * 5)
            local offsetY = origPos.Y.Offset + (JumpY * 5)
            jumpButton.Position = UDim2.new(origPos.X.Scale, offsetX, origPos.Y.Scale, offsetY)
            jumpButton.Size = UDim2.new(0, origSize.X.Offset * JumpScale, 0, origSize.Y.Offset * JumpScale)
        else
            jumpButton.Position = origPos
            jumpButton.Size = origSize
        end
    end)
end

CreateToggle(contentJump, "Enable Classic Thumbstick", ThumbstickEnabled, function(state)
    ThumbstickEnabled = state
    SaveData.ThumbstickEnabled = state
    DoSave()
    ApplyThumbstick()
    for _, slider in pairs(ThumbstickSliders) do slider.Visible = state end
end)

ThumbstickSliders.X = CreateSlider(contentJump, "Thumbstick X", -100, 100, ThumbstickX, function(value)
    ThumbstickX = value
    SaveData.ThumbstickX = value
    DoSave()
    if ThumbstickEnabled then ApplyThumbstick() end
end)

ThumbstickSliders.Y = CreateSlider(contentJump, "Thumbstick Y", -100, 100, ThumbstickY, function(value)
    ThumbstickY = value
    SaveData.ThumbstickY = value
    DoSave()
    if ThumbstickEnabled then ApplyThumbstick() end
end)

CreateToggle(contentJump, "Enable Jump Button", JumpEnabled, function(state)
    JumpEnabled = state
    SaveData.JumpEnabled = state
    DoSave()
    ApplyJump()
    for _, slider in pairs(JumpSliders) do slider.Visible = state end
end)

JumpSliders.X = CreateSlider(contentJump, "Jump X", -100, 100, JumpX, function(value)
    JumpX = value
    SaveData.JumpX = value
    DoSave()
    if JumpEnabled then ApplyJump() end
end)

JumpSliders.Y = CreateSlider(contentJump, "Jump Y", -100, 100, JumpY, function(value)
    JumpY = value
    SaveData.JumpY = value
    DoSave()
    if JumpEnabled then ApplyJump() end
end)

JumpSliders.Scale = CreateSlider(contentJump, "Jump Scale", 0.5, 2, JumpScale, function(value)
    JumpScale = value
    SaveData.JumpScale = value
    DoSave()
    if JumpEnabled then ApplyJump() end
end)

for _, slider in pairs(ThumbstickSliders) do slider.Visible = ThumbstickEnabled end
for _, slider in pairs(JumpSliders) do slider.Visible = JumpEnabled end

local boxButtons, contentButtons = CreateGroupbox(rightColH, "Button E & Button C")
boxButtons.LayoutOrder = 4

local EEnabled = SaveData.EEnabled
local EX = SaveData.EX
local EY = SaveData.EY
local ESize = SaveData.ESize
local ESliders = {}

local CEnabled = SaveData.CEnabled
local CX = SaveData.CX
local CY = SaveData.CY
local CSize = SaveData.CSize
local CSliders = {}

local function GetButtonByText(Text)
    local Found
    pcall(function()
        local Frame = player.PlayerGui:FindFirstChild("ContextActionGui") and player.PlayerGui.ContextActionGui:FindFirstChild("ContextButtonFrame")
        if not Frame then return end
        for _, Object in Frame:GetDescendants() do
            if Object:IsA("TextLabel") and Object.Name == "ActionTitle" and Object.Text == Text then
                local Parent = Object.Parent
                while Parent and Parent ~= Frame do
                    if Parent.Name == "ContextActionButton" then Found = Parent break end
                    Parent = Parent.Parent
                end
            end
        end
    end)
    return Found
end

local function ApplyEButton()
    local Button = GetButtonByText("E")
    if not Button then return end
    local origPos, origSize = GetOriginal(Button)
    if not origPos or not origSize then return end
    pcall(function()
        if EEnabled then
            local offsetX = origPos.X.Offset + (EX * 5)
            local offsetY = origPos.Y.Offset + (EY * 5)
            Button.Position = UDim2.new(origPos.X.Scale, offsetX, origPos.Y.Scale, offsetY)
            Button.Size = UDim2.fromOffset(ESize, ESize)
        else
            Button.Position = origPos
            Button.Size = origSize
        end
    end)
end

local function ApplyCButton()
    local Button = GetButtonByText("C")
    if not Button then return end
    local origPos, origSize = GetOriginal(Button)
    if not origPos or not origSize then return end
    pcall(function()
        if CEnabled then
            local offsetX = origPos.X.Offset + (CX * 5)
            local offsetY = origPos.Y.Offset + (CY * 5)
            Button.Position = UDim2.new(origPos.X.Scale, offsetX, origPos.Y.Scale, offsetY)
            Button.Size = UDim2.fromOffset(CSize, CSize)
        else
            Button.Position = origPos
            Button.Size = origSize
        end
    end)
end

CreateToggle(contentButtons, "Enable E Button", EEnabled, function(state)
    EEnabled = state
    SaveData.EEnabled = state
    DoSave()
    ApplyEButton()
    for _, slider in pairs(ESliders) do slider.Visible = state end
end)

ESliders.X = CreateSlider(contentButtons, "E X", -100, 100, EX, function(value)
    EX = value SaveData.EX = value DoSave()
    if EEnabled then ApplyEButton() end
end)
ESliders.Y = CreateSlider(contentButtons, "E Y", -100, 100, EY, function(value)
    EY = value SaveData.EY = value DoSave()
    if EEnabled then ApplyEButton() end
end)
ESliders.Size = CreateSlider(contentButtons, "E Size", 20, 80, ESize, function(value)
    ESize = value SaveData.ESize = value DoSave()
    if EEnabled then ApplyEButton() end
end)

CreateToggle(contentButtons, "Enable C Button", CEnabled, function(state)
    CEnabled = state
    SaveData.CEnabled = state
    DoSave()
    ApplyCButton()
    for _, slider in pairs(CSliders) do slider.Visible = state end
end)

CSliders.X = CreateSlider(contentButtons, "C X", -100, 100, CX, function(value)
    CX = value SaveData.CX = value DoSave()
    if CEnabled then ApplyCButton() end
end)
CSliders.Y = CreateSlider(contentButtons, "C Y", -100, 100, CY, function(value)
    CY = value SaveData.CY = value DoSave()
    if CEnabled then ApplyCButton() end
end)
CSliders.Size = CreateSlider(contentButtons, "C Size", 20, 80, CSize, function(value)
    CSize = value SaveData.CSize = value DoSave()
    if CEnabled then ApplyCButton() end
end)

for _, slider in pairs(ESliders) do slider.Visible = EEnabled end
for _, slider in pairs(CSliders) do slider.Visible = CEnabled end

local function ApplyAll()
    ApplyJump()
    ApplyThumbstick()
    ApplyEButton()
    ApplyCButton()
end

task.spawn(function()
    task.wait(2)
    ApplyAll()
    while true do
        task.wait(0.5)
        ApplyAll()
    end
end)

pcall(function()
    player.PlayerGui.ChildAdded:Connect(function(child)
        if child.Name == "TouchGui" or child.Name == "ContextActionGui" then
            task.wait(0.5)
            ApplyAll()
            task.wait(0.5)
            ApplyAll()
        end
    end)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        ApplyAll()
        task.wait(1)
        ApplyAll()
    end)
end)
end

task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer

    local FootstepVolume = 15
    local JumpVolume = 10
    local FallVolume = 10
    local MuteFootsteps = false
    local MuteJump = false
    local MuteFall = false
    local MuteHit = false
    local FootstepMinDist = 0
    local FootstepMaxDist = 150
    local FootstepRollOff = 1

    local DefaultSounds = { Footsteps = "79392671800290", Jump = "80853972291847", Fall = "88947883822456" }
    local SelectedSounds = { Footsteps = "79392671800290", Jump = "80853972291847", Fall = "88947883822456" }

    local settingsPageH = pages["Sounds"]
    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    pcall(function()
        settingsPageH.AutomaticCanvasSize = Enum.AutomaticSize.Y
        settingsPageH.CanvasSize = UDim2.new(0, 0, 0, 0)
        settingsPageH.ScrollBarThickness = 3
    end)

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Name = "ColumnsContainer"
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    local padding = Instance.new("UIPadding", columnsH)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Name = "LeftColumn"
    leftColH.Size = UDim2.new(0.5, -10, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    local leftList = Instance.new("UIListLayout", leftColH)
    leftList.Padding = UDim.new(0, 10)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Name = "RightColumn"
    rightColH.Size = UDim2.new(0.5, -10, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.Position = UDim2.new(0.5, 10, 0, 0)
    rightColH.BackgroundTransparency = 1
    local rightList = Instance.new("UIListLayout", rightColH)
    rightList.Padding = UDim.new(0, 10)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder

    local function GetType(name)
        name = name:lower()
        if name:find("run") or name:find("walk") or name:find("step") or name:find("foot") or name:find("running") then return "Footsteps" end
        if name:find("jump") then return "Jump" end
        if name:find("fall") or name:find("freefall") or name:find("land") then return "Fall" end
        return nil
    end

    local function ApplySoundIdGlobally(soundType, soundId)
        local newId = "rbxassetid://".. soundId
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj:IsA("Sound") then
                        local t = GetType(obj.Name)
                        if t == soundType and obj.SoundId ~= newId then obj.SoundId = newId end
                    end
                end
            end
        end
    end

    local function UpdateAllSounds()
        pcall(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    local isMe = (plr == player)
                    for _, obj in pairs(plr.Character:GetDescendants()) do
                        if obj:IsA("Sound") then
                            local t = GetType(obj.Name)
                            if t == "Footsteps" then
                                obj.Volume = (MuteFootsteps and isMe) and 0 or (FootstepVolume / 10)
                                pcall(function()
                                    obj.RollOffMinDistance = FootstepMinDist
                                    obj.RollOffMaxDistance = FootstepMaxDist
                                    obj.RollOffMode = Enum.RollOffMode.InverseTapered
                                end)
                            elseif t == "Jump" then
                                if isMe then obj.Volume = MuteJump and 0 or (JumpVolume / 10) end
                            elseif t == "Fall" then
                                if isMe then obj.Volume = MuteFall and 0 or (FallVolume / 10) end
                            end
                        end
                    end
                end
            end
        end)
    end

    local updateDebounce = false
    local function DebouncedUpdate()
        if updateDebounce then return end
        updateDebounce = true
        task.delay(0.2, function()
            updateDebounce = false
            UpdateAllSounds()
        end)
    end

    local function WatchCharacter(char)
        if not char then return end
        char.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                task.wait()
                DebouncedUpdate()
                local t = GetType(desc.Name)
                if t and SelectedSounds[t] then
                    local newId = "rbxassetid://".. SelectedSounds[t]
                    if desc.SoundId ~= newId then desc.SoundId = newId end
                end
            end
        end)
    end

    local watchedChars = {}
    local function WatchCharacterSafe(char)
        if not char or watchedChars[char] then return end
        watchedChars[char] = true
        WatchCharacter(char)
        char.AncestryChanged:Connect(function()
            if not char:IsDescendantOf(workspace) then
                watchedChars[char] = nil
            end
        end)
    end

    local function OnCharAdded(char)
        task.wait(1)
        ApplySoundIdGlobally("Footsteps", SelectedSounds.Footsteps)
        ApplySoundIdGlobally("Jump", SelectedSounds.Jump)
        ApplySoundIdGlobally("Fall", SelectedSounds.Fall)
        UpdateAllSounds()
        WatchCharacterSafe(char)
    end

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(OnCharAdded)
    end)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then WatchCharacterSafe(plr.Character) end
        plr.CharacterAdded:Connect(OnCharAdded)
    end

    local function MuteHitSounds(obj)
        if not MuteHit then return end
        if obj:IsA("Sound") then
            local name = obj.Name:lower()
            if name:find("hit") or name:find("punch") or name:find("slash") or name:find("wall") then obj.Volume = 0 end
        end
    end
    workspace.DescendantAdded:Connect(MuteHitSounds)
    ReplicatedStorage.DescendantAdded:Connect(MuteHitSounds)
    if player.Character then UpdateAllSounds() WatchCharacterSafe(player.Character) end

    local function CreateVolumeSlider(parent, text, min, max, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,40)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,0,20)
        label.Position = UDim2.new(0,15,0,5)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2
        local valueLabel = Instance.new("TextLabel", holder)
        valueLabel.Size = UDim2.new(0,40,0,20)
        valueLabel.Position = UDim2.new(1,-45,0,5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextColor3 = Color3.fromRGB(235,235,235)
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.ZIndex = 2
        local bar = Instance.new("TextButton", holder)
        bar.Size = UDim2.new(1,-30,0,5)
        bar.Position = UDim2.new(0,15,0,28)
        bar.BackgroundColor3 = Color3.fromRGB(50,50,55)
        bar.BorderSizePixel = 0
        bar.Text = ""
        bar.AutoButtonColor = false
        bar.ZIndex = 2
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,3)
        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 3
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0,3)
        local dragging = false
        local function update(inputX)
            local scale = math.clamp((inputX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value
            if max <= 5 then
                value = math.floor((min + (max - min) * scale) * 100 + 0.5) / 100
            else
                value = math.floor((min + (max - min) * scale) + 0.5)
            end
            TweenService:Create(fill, TweenInfo.new(0.08), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
            valueLabel.Text = tostring(value)
            callback(value)
        end
        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true update(input.Position.X) end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        return {SetValue = function(val)
            local scale = math.clamp((val - min) / (max - min), 0, 1)
            valueLabel.Text = tostring(val)
            fill.Size = UDim2.new(scale, 0, 1, 0)
            callback(val)
        end}
    end

    local ActiveButtons = {Footsteps = {}, Jump = {}, Fall = {}}
    local function CreateSoundButton(parent, text, soundType, soundId)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.5
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(90, 90, 90)
        stroke.Thickness = 1
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 220)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        local function UpdateVisual()
            local isActive = SelectedSounds[soundType] == soundId
            if isActive then
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.1 }):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(255, 255, 255) }):Play()
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 30), BackgroundTransparency = 0.5 }):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(90, 90, 90) }):Play()
                label.TextColor3 = Color3.fromRGB(220, 220, 220)
            end
        end
        btn.MouseButton1Click:Connect(function()
            SelectedSounds[soundType] = soundId
            ApplySoundIdGlobally(soundType, soundId)
            UpdateAllSounds()
            for _, button in ipairs(ActiveButtons[soundType]) do button.UpdateVisual() end
        end)
        UpdateVisual()
        table.insert(ActiveButtons[soundType], {UpdateVisual = UpdateVisual})
        return btn
    end

    local function CreateResetButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(180,180,180)
        btn.AutoButtonColor = false
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255,80,80)}):Play()
            task.wait(0.15)
            TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(180,180,180)}):Play()
            if callback then callback() end
        end)
        return btn
    end

    local function CreateToggle(parent, text, default, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(1, 0, 0, 22)
        toggleFrame.BackgroundTransparency = 1
        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextXAlignment = Enum.TextXAlignment.Left
        local toggle = Instance.new("TextButton", toggleFrame)
        toggle.Size = UDim2.new(0, 38, 0, 17)
        toggle.Position = UDim2.new(1, -40, 0.5, -9)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggle.BackgroundTransparency = default and 0 or 1
        toggle.Text = ""
        toggle.AutoButtonColor = false
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", toggle)
        stroke.Color = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        stroke.Thickness = 1.5
        local circle = Instance.new("Frame", toggle)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = default and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = enabled and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220) }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { BackgroundTransparency = enabled and 0 or 1, BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), { Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100) }):Play()
            if callback then callback(enabled) end
        end)
        return toggleFrame
    end

    local volumeBox, volumeContent = CreateGroupbox(leftColH, "Volume")
    volumeBox.LayoutOrder = 1
    local footstepSlider = CreateVolumeSlider(volumeContent, "FootSteps", 0, 100, 15, function(v) FootstepVolume = v UpdateAllSounds() end)
    local jumpSlider = CreateVolumeSlider(volumeContent, "Jump", 0, 100, 10, function(v) JumpVolume = v UpdateAllSounds() end)
    local fallSlider = CreateVolumeSlider(volumeContent, "Fall", 0, 100, 10, function(v) FallVolume = v UpdateAllSounds() end)
    CreateResetButton(volumeContent, "Reset Volumes", function()
        FootstepVolume = 15 JumpVolume = 10 FallVolume = 10
        footstepSlider.SetValue(15) jumpSlider.SetValue(10) fallSlider.SetValue(10) UpdateAllSounds()
    end)
    CreateResetButton(volumeContent, "Reset Sounds", function()
        SelectedSounds = {Footsteps = DefaultSounds.Footsteps, Jump = DefaultSounds.Jump, Fall = DefaultSounds.Fall}
        ApplySoundIdGlobally("Footsteps", DefaultSounds.Footsteps)
        ApplySoundIdGlobally("Jump", DefaultSounds.Jump)
        ApplySoundIdGlobally("Fall", DefaultSounds.Fall)
        UpdateAllSounds()
        for _, soundType in pairs({"Footsteps", "Jump", "Fall"}) do
            for _, button in ipairs(ActiveButtons[soundType]) do button.UpdateVisual() end
        end
    end)

    local muteBox, muteContent = CreateGroupbox(leftColH, "Mute System")
    muteBox.LayoutOrder = 2
    CreateToggle(muteContent, "Mute Your Footsteps", false, function(s) MuteFootsteps = s UpdateAllSounds() end)
    CreateToggle(muteContent, "Mute Your Jump", false, function(s) MuteJump = s UpdateAllSounds() end)
    CreateToggle(muteContent, "Mute Your Fall", false, function(s) MuteFall = s UpdateAllSounds() end)
    CreateToggle(muteContent, "Mute Hit Sound", false, function(s) MuteHit = s end)

    local facilityCat, facilityContent = CreateGroupbox(leftColH, "Facility Gamer")
    facilityCat.LayoutOrder = 3
    CreateSoundButton(facilityContent, "FootSteps", "Footsteps", "131592620665625")
    CreateSoundButton(facilityContent, "Jump", "Jump", "89459688918065")

    local morcegoCat, morcegoContent = CreateGroupbox(leftColH, "Tio Morcego")
    morcegoCat.LayoutOrder = 4
    CreateSoundButton(morcegoContent, "FootSteps", "Footsteps", "97458293386939")
    CreateSoundButton(morcegoContent, "Jump", "Jump", "72503238596964")
    CreateSoundButton(morcegoContent, "Fall", "Fall", "83702883984130")

    local extrasCat, extrasContent = CreateGroupbox(leftColH, "Extras Jumps")
    extrasCat.LayoutOrder = 5
    CreateSoundButton(extrasContent, "Pew Jump", "Jump", "136299701781122")
    CreateSoundButton(extrasContent, "Sharingan Jump", "Jump", "118102230060662")
    CreateSoundButton(extrasContent, "Bubble Jump", "Jump", "129415490412106")
    CreateSoundButton(extrasContent, "RF Jump", "Jump", "80276851298640")

    local distBox, distContent = CreateGroupbox(rightColH, "Distância de Passos")
    distBox.LayoutOrder = 1
    local minDistSlider = CreateVolumeSlider(distContent, "Min Distância", 0, 20, 0, function(v) FootstepMinDist = v UpdateAllSounds() end)
    local maxDistSlider = CreateVolumeSlider(distContent, "Max Distância", 10, 500, 150, function(v) FootstepMaxDist = v UpdateAllSounds() end)
    local rollOffSlider = CreateVolumeSlider(distContent, "RollOff", 0, 5, 1, function(v) FootstepRollOff = v UpdateAllSounds() end)
    CreateResetButton(distContent, "Reset Distância", function()
        FootstepMinDist = 0 FootstepMaxDist = 150 FootstepRollOff = 1
        minDistSlider.SetValue(0) maxDistSlider.SetValue(150) rollOffSlider.SetValue(1) UpdateAllSounds()
    end)

    local musicBox, musicContent = CreateGroupbox(rightColH, "Music Player")
    musicBox.LayoutOrder = 2
    local musicSound = Instance.new("Sound", workspace)
    musicSound.Name = "MusicPlayerSound"
    musicSound.Looped = true
    musicSound.Volume = 0.5
    local musicPlaying = false

    do
        local holder = Instance.new("Frame", musicContent)
        holder.Size = UDim2.new(1,0,0,45)
        holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
        holder.BackgroundTransparency = 0.5
        holder.ZIndex = 2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-80,0,20)
        label.Position = UDim2.new(0,15,0,5)
        label.BackgroundTransparency = 1
        label.Text = "Music Volume"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 2
        local volPercent = Instance.new("TextLabel", holder)
        volPercent.Size = UDim2.new(0,40,0,20)
        volPercent.Position = UDim2.new(1,-45,0,5)
        volPercent.BackgroundTransparency = 1
        volPercent.Text = "50%"
        volPercent.Font = Enum.Font.GothamBold
        volPercent.TextSize = 13
        volPercent.TextColor3 = Color3.fromRGB(235,235,235)
        volPercent.TextXAlignment = Enum.TextXAlignment.Right
        volPercent.ZIndex = 2
        local volBar = Instance.new("Frame", holder)
        volBar.Size = UDim2.new(1,-30,0,6)
        volBar.Position = UDim2.new(0,15,0,28)
        volBar.BackgroundColor3 = Color3.fromRGB(0,0,0)
        volBar.BorderSizePixel = 0
        volBar.ZIndex = 2
        Instance.new("UICorner", volBar).CornerRadius = UDim.new(0,3)
        local volFill = Instance.new("Frame", volBar)
        volFill.Size = UDim2.new(0.5, 0, 1, 0)
        volFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        volFill.BorderSizePixel = 0
        volFill.ZIndex = 3
        Instance.new("UICorner", volFill).CornerRadius = UDim.new(0,3)
        local function updateVolume(inputPosX)
            local relativeX = math.clamp(inputPosX - volBar.AbsolutePosition.X, 0, volBar.AbsoluteSize.X)
            local scale = relativeX / volBar.AbsoluteSize.X
            TweenService:Create(volFill, TweenInfo.new(0.08), {Size = UDim2.new(scale, 0, 1, 0)}):Play()
            musicSound.Volume = scale
            volPercent.Text = math.floor(scale * 100).. "%"
        end
        local isDragging = false
        local moveConnection, endConnection
        local function stopDragging()
            isDragging = false
            if moveConnection then moveConnection:Disconnect() moveConnection = nil end
            if endConnection then endConnection:Disconnect() endConnection = nil end
        end
        volBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                updateVolume(input.Position.X)
                moveConnection = UserInputService.InputChanged:Connect(function(input2)
                    if isDragging and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then updateVolume(input2.Position.X) end
                end)
                endConnection = UserInputService.InputEnded:Connect(function(input2)
                    if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then stopDragging() end
                end)
            end
        end)
    end

    do
        local holder = Instance.new("Frame", musicContent)
        holder.Size = UDim2.new(1,0,0,32)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 2
        local layout = Instance.new("UIListLayout", holder)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)
        local idBox = Instance.new("TextBox", holder)
        idBox.Size = UDim2.new(0.33, -5, 1, 0)
        idBox.PlaceholderText = "ID..."
        idBox.Text = ""
        idBox.Font = Enum.Font.GothamBold
        idBox.TextSize = 12
        idBox.TextColor3 = Color3.fromRGB(255,255,255)
        idBox.PlaceholderColor3 = Color3.fromRGB(120,120,125)
        idBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
        idBox.BackgroundTransparency = 0.5
        idBox.BorderSizePixel = 0
        idBox.ZIndex = 2
        idBox.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", idBox).CornerRadius = UDim.new(0,6)
        local strokeId = Instance.new("UIStroke", idBox)
        strokeId.Color = Color3.fromRGB(80,80,85)
        strokeId.Thickness = 1
        local dropdown = Instance.new("TextButton", holder)
        dropdown.Size = UDim2.new(0.33, -5, 1, 0)
        dropdown.Text = "Select"
        dropdown.Font = Enum.Font.GothamBold
        dropdown.TextSize = 12
        dropdown.TextColor3 = Color3.fromRGB(220,220,220)
        dropdown.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dropdown.BackgroundTransparency = 0.5
        dropdown.BorderSizePixel = 0
        dropdown.AutoButtonColor = false
        dropdown.ZIndex = 2
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,6)
        local strokeDrop = Instance.new("UIStroke", dropdown)
        strokeDrop.Color = Color3.fromRGB(80,80,85)
        strokeDrop.Thickness = 1
        local dropdownList = Instance.new("ScrollingFrame", musicContent)
        dropdownList.Size = UDim2.new(1, 0, 0, 0)
        dropdownList.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dropdownList.BorderSizePixel = 0
        dropdownList.Visible = false
        dropdownList.ZIndex = 10
        dropdownList.ScrollBarThickness = 3
        dropdownList.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
        dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0,6)
        local strokeList = Instance.new("UIStroke", dropdownList)
        strokeList.Color = Color3.fromRGB(70,70,75)
        local listLayout2 = Instance.new("UIListLayout", dropdownList)
        listLayout2.Padding = UDim.new(0,0)
        local isOpen = false
        local songs = {
            {"six seven","139780631670217"}, {"low cortisol","110919391228823"}, {"His Love","140684861805080"},
            {"7 years of trying","909647887628820"}, {"7 years","115598617339786"}, {"Never Alone","86404842974521"},
            {"its you","139010646759693"}, {"Ariana Grande","111795743730164"}, {"Montagem benção","140245756477343"},
            {"King Nasir Phonk","76650356472656"}, {"METAMORPHOSIS","15689451063"}, {"Sin Teen","121242950842428"},
        }
        for i, song in ipairs(songs) do
            local option = Instance.new("TextButton", dropdownList)
            option.Size = UDim2.new(1,0,0,30)
            option.BackgroundTransparency = 1
            option.Text = song[1]
            option.Font = Enum.Font.GothamBold
            option.TextSize = 12
            option.TextColor3 = Color3.fromRGB(180,180,185)
            option.BorderSizePixel = 0
            option.ZIndex = 11
            local line = Instance.new("Frame", option)
            line.Size = UDim2.new(1,-20,0,1)
            line.Position = UDim2.new(0,10,1,-1)
            line.BackgroundColor3 = Color3.fromRGB(45,45,50)
            line.BorderSizePixel = 0
            line.ZIndex = 11
            if i == #songs then line.Visible = false end
            option.MouseEnter:Connect(function() TweenService:Create(option, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255,255,255)}):Play() end)
            option.MouseLeave:Connect(function() TweenService:Create(option, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(180,180,185)}):Play() end)
            option.MouseButton1Click:Connect(function()
                dropdown.Text = song[1]
                idBox.Text = song[2]
                TweenService:Create(dropdownList, TweenInfo.new(0.12), {Size = UDim2.new(1,0,0,0)}):Play()
                task.wait(0.12)
                dropdownList.Visible = false
                isOpen = false
            end)
        end
        dropdown.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                dropdownList.Visible = true
                TweenService:Create(dropdownList, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,150)}):Play()
            else
                TweenService:Create(dropdownList, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)}):Play()
                task.wait(0.15)
                dropdownList.Visible = false
            end
        end)
        local playBtn = Instance.new("TextButton", holder)
        playBtn.Size = UDim2.new(0.34, -5, 1, 0)
        playBtn.Text = ""
        playBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        playBtn.BackgroundTransparency = 0.5
        playBtn.BorderSizePixel = 0
        playBtn.AutoButtonColor = false
        playBtn.ZIndex = 2
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0,6)
        local strokePlay = Instance.new("UIStroke", playBtn)
        strokePlay.Color = Color3.fromRGB(80,80,85)
        strokePlay.Thickness = 1
        local playText = Instance.new("TextLabel", playBtn)
        playText.Size = UDim2.new(1,0,1,0)
        playText.Text = "Play"
        playText.Font = Enum.Font.GothamBold
        playText.TextSize = 13
        playText.TextColor3 = Color3.fromRGB(220,220,220)
        playText.BackgroundTransparency = 1
        playText.ZIndex = 3
        local function UpdatePlayVisual()
            if musicPlaying then
                TweenService:Create(playBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.1}):Play()
                TweenService:Create(strokePlay, TweenInfo.new(0.15), {Color = Color3.fromRGB(255,255,255)}):Play()
                playText.TextColor3 = Color3.fromRGB(0,0,0)
                playText.Text = "Stop"
            else
                TweenService:Create(playBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30), BackgroundTransparency = 0.5}):Play()
                TweenService:Create(strokePlay, TweenInfo.new(0.15), {Color = Color3.fromRGB(80,80,85)}):Play()
                playText.TextColor3 = Color3.fromRGB(220,220,220)
                playText.Text = "Play"
            end
        end
        playBtn.MouseButton1Click:Connect(function()
            if not musicPlaying then
                if idBox.Text ~= "" then
                    musicSound.SoundId = "rbxassetid://".. idBox.Text
                    musicSound:Play()
                    musicPlaying = true
                    UpdatePlayVisual()
                end
            else
                musicSound:Stop()
                musicPlaying = false
                UpdatePlayVisual()
            end
        end)
    end

    local noobCat, noobContent = CreateGroupbox(rightColH, "NoobTwoPointOh")
    noobCat.LayoutOrder = 3
    CreateSoundButton(noobContent, "FootSteps", "Footsteps", "110709356093026")
    CreateSoundButton(noobContent, "Jump", "Jump", "124276657634407")

    local fkpsCat, fkpsContent = CreateGroupbox(rightColH, "FKPS")
    fkpsCat.LayoutOrder = 4
    CreateSoundButton(fkpsContent, "FootSteps", "Footsteps", "97733831736820")
    CreateSoundButton(fkpsContent, "Jump", "Jump", "86031664547378")
    CreateSoundButton(fkpsContent, "Fall", "Fall", "78180192109919")

    task.wait(1)
    ApplySoundIdGlobally("Footsteps", SelectedSounds.Footsteps)
    ApplySoundIdGlobally("Jump", SelectedSounds.Jump)
    ApplySoundIdGlobally("Fall", SelectedSounds.Fall)
    UpdateAllSounds()
end)

do
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")

    local Player = Players.LocalPlayer
    local settingsPageP = pages["Visual Skins"]
    if not settingsPageP then return end

    settingsPageP:ClearAllChildren()
    settingsPageP.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsPageP.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsPageP.ScrollBarThickness = 3
    
    local listLayout = Instance.new("UIListLayout", settingsPageP)
    listLayout.Padding = UDim.new(0, 12)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local padding = Instance.new("UIPadding", settingsPageP)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)

    local gui = settingsPageP:FindFirstAncestorOfClass("ScreenGui")

    local titleHolder = Instance.new("Frame", settingsPageP)
    titleHolder.Size = UDim2.new(1, 0, 0, 20)
    titleHolder.BackgroundTransparency = 1
    titleHolder.LayoutOrder = 1

    local title = Instance.new("TextLabel", titleHolder)
    title.Size = UDim2.new(0, 100, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Skin Changer"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(220,220,220)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local line = Instance.new("Frame", titleHolder)
    line.Size = UDim2.new(1, -110, 0, 1)
    line.Position = UDim2.new(0, 110, 0.5, 0)
    line.BackgroundColor3 = Color3.fromRGB(60,60,60)
    line.BorderSizePixel = 0

    local searchHolder = Instance.new("Frame", settingsPageP)
    searchHolder.Size = UDim2.new(1, 0, 0, 36)
    searchHolder.BackgroundColor3 = Color3.fromRGB(6,6,6)
    searchHolder.BackgroundTransparency = 0.65
    searchHolder.BorderSizePixel = 0
    searchHolder.LayoutOrder = 2
    Instance.new("UICorner", searchHolder).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", searchHolder).Color = Color3.fromRGB(50,50,50)

    local searchBox = Instance.new("TextBox", searchHolder)
    searchBox.Size = UDim2.new(1, -40, 1, 0)
    searchBox.Position = UDim2.new(0, 12, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.TextColor3 = Color3.fromRGB(220,220,220)
    searchBox.Font = Enum.Font.GothamBold
    searchBox.TextSize = 13
    searchBox.Text = ""
    searchBox.PlaceholderText = "Username..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120,120,120)
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false

    local searchIcon = Instance.new("ImageButton", searchHolder)
    searchIcon.Size = UDim2.new(0, 18, 0, 18)
    searchIcon.Position = UDim2.new(1, -28, 0.5, -9)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://6031154871"
    searchIcon.ImageColor3 = Color3.fromRGB(150,150,150)

    local skinGrid = Instance.new("Frame", settingsPageP)
    skinGrid.Size = UDim2.new(1, 0, 0, 500)
    skinGrid.BackgroundTransparency = 1
    skinGrid.LayoutOrder = 3
    skinGrid.ClipsDescendants = false
    
    local gridLayout = Instance.new("UIGridLayout", skinGrid)
    gridLayout.CellSize = UDim2.new(0.25, -4, 0, 50)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    gridLayout.FillDirectionMaxCells = 4

    if getgenv().SkinFixLoop then 
        getgenv().SkinFixLoop:Disconnect() 
        getgenv().SkinFixLoop = nil 
    end
    getgenv().CurrentSkinUserId = 0
    getgenv().IsApplyingSkin = false

    local function SmartWeld(char, accessory)
        local handle = accessory:FindFirstChild("Handle")
        if not handle then return end
        handle.Anchored = false
        handle.CanCollide = false
        handle.Massless = true
        accessory.Parent = char
        
        local accAtt = handle:FindFirstChildWhichIsA("Attachment")
        if not accAtt then
            local weld = Instance.new("Weld")
            weld.Part0 = char:FindFirstChild("Head") or char:FindFirstChild("Torso")
            weld.Part1 = handle
            weld.C0 = CFrame.new(0, 0.5, 0)
            weld.Parent = handle
            return
        end

        local targetPart = char:FindFirstChild("Head")
        local charAtt = targetPart and targetPart:FindFirstChild(accAtt.Name)
        if not charAtt then
            targetPart = char:FindFirstChild("Torso")
            charAtt = targetPart and targetPart:FindFirstChild(accAtt.Name)
        end

        local weld = Instance.new("Weld")
        weld.Part1 = handle
        weld.Part0 = targetPart or char:FindFirstChild("Head")
        weld.C0 = charAtt and charAtt.CFrame or CFrame.new(0, 0.5, 0)
        weld.C1 = accAtt.CFrame
        weld.Parent = handle
    end

    local function StartFixLoop(char, colorTable, originalHeadTextureId)
        if getgenv().SkinFixLoop then getgenv().SkinFixLoop:Disconnect() end
        local lastCheck = 0
        getgenv().SkinFixLoop = RunService.Heartbeat:Connect(function()
            if tick() - lastCheck < 0.5 then return end
            lastCheck = tick()
            
            if not char or not char.Parent then
                if getgenv().SkinFixLoop then getgenv().SkinFixLoop:Disconnect() end
                return
            end
            
            for partName, color in pairs(colorTable) do
                local part = char:FindFirstChild(partName)
                if part and part:IsA("BasePart") and part.Color ~= color then
                    part.Color = color
                    part.Material = Enum.Material.SmoothPlastic
                    if partName == "Head" then
                        local mesh = part:FindFirstChildOfClass("SpecialMesh")
                        if mesh then
                            if originalHeadTextureId ~= "" then
                                if mesh.TextureId ~= originalHeadTextureId then 
                                    mesh.TextureId = originalHeadTextureId 
                                end
                            elseif mesh.TextureId ~= "" then 
                                mesh.TextureId = "" 
                            end
                        end
                    end
                end
            end
        end)
    end

    local function TransformarSkin(userId)
        if getgenv().IsApplyingSkin or getgenv().CurrentSkinUserId == userId then return end
        getgenv().IsApplyingSkin = true
        
        local char = Player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then 
            getgenv().IsApplyingSkin = false
            return 
        end

        local success, desc = pcall(function() 
            return Players:GetHumanoidDescriptionFromUserId(userId) 
        end)
        if not success or not desc then 
            getgenv().IsApplyingSkin = false
            return 
        end

        if getgenv().SkinFixLoop then 
            getgenv().SkinFixLoop:Disconnect() 
            getgenv().SkinFixLoop = nil 
        end
        getgenv().CurrentSkinUserId = userId

        local dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R6)
        dummy.Name = "AssetSource"
        dummy.Parent = nil
        task.wait(0.3)

        local realColors = { 
            ["Head"] = desc.HeadColor, 
            ["Torso"] = desc.TorsoColor,
            ["Left Arm"] = desc.LeftArmColor,
            ["Right Arm"] = desc.RightArmColor,
            ["Left Leg"] = desc.LeftLegColor,
            ["Right Leg"] = desc.RightLegColor 
        }
        
        local targetHeadTexture = ""
        local dummyMesh = dummy.Head:FindFirstChildOfClass("SpecialMesh")
        if dummyMesh then targetHeadTexture = dummyMesh.TextureId end

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("CharacterMesh") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("face") then 
            char.Head.face:Destroy() 
        end

        local myMesh = char.Head:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", char.Head)
        if dummyMesh then
            myMesh.MeshType = dummyMesh.MeshType
            myMesh.MeshId = dummyMesh.MeshId
            myMesh.Scale = dummyMesh.Scale
            myMesh.TextureId = targetHeadTexture
        else
            myMesh.MeshType = Enum.MeshType.Head
            myMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
            myMesh.TextureId = ""
        end
        myMesh.VertexColor = Vector3.new(1,1,1)

        for _, item in pairs(dummy:GetChildren()) do 
            if item:IsA("CharacterMesh") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic") then 
                item:Clone().Parent = char 
            end 
        end
        
        local faceDecal = Instance.new("Decal")
        faceDecal.Name = "face"
        local dummyFace = dummy.Head:FindFirstChild("face")
        faceDecal.Texture = dummyFace and dummyFace.Texture or (desc.Face > 0 and "rbxassetid://"..desc.Face or "rbxasset://textures/face.png")
        faceDecal.Parent = char.Head

        local newBC = Instance.new("BodyColors")
        newBC.HeadColor3 = desc.HeadColor
        newBC.TorsoColor3 = desc.TorsoColor
        newBC.LeftArmColor3 = desc.LeftArmColor
        newBC.RightArmColor3 = desc.RightArmColor
        newBC.LeftLegColor3 = desc.LeftLegColor
        newBC.RightLegColor3 = desc.RightLegColor
        newBC.Parent = char

        StartFixLoop(char, realColors, targetHeadTexture)

        for _, item in pairs(dummy:GetChildren()) do
            if item:IsA("Accessory") then
                SmartWeld(char, item:Clone())
            end
        end
        
        dummy:Destroy()
        task.wait(0.2)
        getgenv().IsApplyingSkin = false
    end

    local function ShowSkinPopup(userId, username)
        local oldBlur = Lighting:FindFirstChild("SkinPopupBlur")
        if oldBlur then oldBlur:Destroy() end
        if gui:FindFirstChild("SkinPopupOverlay") then
            gui:FindFirstChild("SkinPopupOverlay"):Destroy()
        end

        local blur = Instance.new("BlurEffect")
        blur.Name = "SkinPopupBlur"
        blur.Size = 12
        blur.Parent = Lighting

        local overlay = Instance.new("Frame", gui)
        overlay.Name = "SkinPopupOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 1
        overlay.ZIndex = 1000
        overlay.Active = true

        local popupFrame = Instance.new("Frame", overlay)
        popupFrame.Size = UDim2.new(0, 320, 0, 170)
        popupFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        popupFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        popupFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
        popupFrame.BackgroundTransparency = 0.05
        popupFrame.ZIndex = 1001
        Instance.new("UICorner", popupFrame).CornerRadius = UDim.new(0, 8)

        local popupStroke = Instance.new("UIStroke", popupFrame)
        popupStroke.Color = Color3.fromRGB(80, 80, 80)
        popupStroke.Thickness = 1

        local popupTitle = Instance.new("TextLabel", popupFrame)
        popupTitle.Size = UDim2.new(1, 0, 0, 40)
        popupTitle.Position = UDim2.new(0, 0, 0, 0)
        popupTitle.BackgroundTransparency = 1
        popupTitle.Text = "SKIN FOUND"
        popupTitle.Font = Enum.Font.GothamBold
        popupTitle.TextSize = 15
        popupTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        popupTitle.ZIndex = 1002

        local avatarImg = Instance.new("ImageLabel", popupFrame)
        avatarImg.Size = UDim2.new(0, 60, 0, 60)
        avatarImg.Position = UDim2.new(0, 25, 0, 50)
        avatarImg.BackgroundTransparency = 1
        avatarImg.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=150&height=150&format=png"
        avatarImg.ZIndex = 1002
        Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 6)

        local nameLabel = Instance.new("TextLabel", popupFrame)
        nameLabel.Size = UDim2.new(1, -100, 0, 20)
        nameLabel.Position = UDim2.new(0, 95, 0, 70)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = username
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.ZIndex = 1002

        local applyBtn = Instance.new("TextButton", popupFrame)
        applyBtn.Size = UDim2.new(0, 120, 0, 32)
        applyBtn.Position = UDim2.new(0, 25, 1, -50)
        applyBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        applyBtn.Text = "Apply Skin"
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.TextSize = 13
        applyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        applyBtn.ZIndex = 1003
        applyBtn.AutoButtonColor = false
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 6)

        local cancelBtn = Instance.new("TextButton", popupFrame)
        cancelBtn.Size = UDim2.new(0, 120, 0, 32)
        cancelBtn.Position = UDim2.new(1, -145, 1, -50)
        cancelBtn.BackgroundTransparency = 1
        cancelBtn.Text = "Cancel"
        cancelBtn.Font = Enum.Font.GothamBold
        cancelBtn.TextSize = 13
        cancelBtn.TextColor3 = Color3.fromRGB(255, 59, 59)
        cancelBtn.ZIndex = 1003
        cancelBtn.AutoButtonColor = false

        applyBtn.MouseButton1Click:Connect(function()
            blur:Destroy()
            overlay:Destroy()
            TransformarSkin(userId)
        end)

        cancelBtn.MouseButton1Click:Connect(function()
            blur:Destroy()
            overlay:Destroy()
        end)

        applyBtn.MouseEnter:Connect(function()
            TweenService:Create(applyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        applyBtn.MouseLeave:Connect(function()
            TweenService:Create(applyBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(235, 235, 235)}):Play()
        end)

        cancelBtn.MouseEnter:Connect(function()
            TweenService:Create(cancelBtn, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)
        cancelBtn.MouseLeave:Connect(function()
            TweenService:Create(cancelBtn, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end)
    end

    local function searchUser()
        if searchBox.Text == "" then return end
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(searchBox.Text)
        end)
        if success then 
            ShowSkinPopup(userId, searchBox.Text)
        end
    end

    searchBox.FocusLost:Connect(function(enter)
        if enter then searchUser() end
    end)

    searchIcon.MouseButton1Click:Connect(searchUser)

    local skinList = {
        {name = "Foxygaimar", id = 534577197},
        {name = "Meshew", id = 471532382},
        {name = "nathanserafas12", id = 1154255704},
        {name = "Baydiina", id = 2468610502},
        {name = "1Pexssz", id = 3255132752},
        {name = "LastWeekM", id = 10499617173},
        {name = "Vaultzinx", id = 9927926742},
        {name = "fleepkkj", id = 7469923945},
        {name = "Markzinh0", id = 5390545482},
        {name = "Luan21leo", id = 2200270213},
        {name = "Sleep01101011", id = 9629354365},
        {name = "aniiltw", id = 2029152623},
        {name = "dimeyuri", id = 1023942107},
        {name = "Surimiva", id = 10380062125},
        {name = "Krizzenxdev1ce", id = 10726477156},
        {name = "y_avriix", id = 10288333128},
        {name = "nyviima", id = 9264913030},
        {name = "Luufyzinho0", id = 3386809191},
        {name = "Frecxy_Angels", id = 3923504748},
        {name = "GabrielMasterPlay2", id = 10745780794},
        {name = "Znerx3ys", id = 708884161},
        {name = "eduttk7", id = 5801621121},
        {name = "TryNotToRage", id = 10279120783},
        {name = "DraxynSoulx", id = 2396362636},
        {name = "Gaie_VR", id = 1244277839},
        {name = "totallyvelez", id = 3597977804},
        {name = "steik00s", id = 4644831551},
        {name = "1Dxqzz", id = 2425366002},
        {name = "Guime_blox", id = 2633091297},
        {name = "Mwaiconn", id = 3948962607},
    }

    for i, skin in ipairs(skinList) do
        local card = Instance.new("TextButton", skinGrid)
        card.BackgroundColor3 = Color3.fromRGB(6,6,6)
        card.BackgroundTransparency = 0.6
        card.BorderSizePixel = 0
        card.Text = ""
        card.AutoButtonColor = false
        card.LayoutOrder = i
        card.ClipsDescendants = true
        card.ZIndex = 2
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,6)

        local thumb = Instance.new("ImageLabel", card)
        thumb.Size = UDim2.new(0, 32, 0, 32)
        thumb.Position = UDim2.new(0, 8, 0.5, -16)
        thumb.BackgroundTransparency = 1
        thumb.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..skin.id.."&width=150&height=150&format=png"
        thumb.ZIndex = 1
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0,4)

        local nameLabel = Instance.new("TextLabel", card)
        nameLabel.Size = UDim2.new(1, -48, 1, 0)
        nameLabel.Position = UDim2.new(0, 45, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = skin.name
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.TextColor3 = Color3.fromRGB(220,220,220)
        nameLabel.TextWrapped = true
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.ZIndex = 1

        card.MouseButton1Click:Connect(function()
            if getgenv().IsApplyingSkin then return end
            TweenService:Create(card, TweenInfo.new(0.05), {BackgroundTransparency = 0.1}):Play()
            task.wait(0.05)
            TweenService:Create(card, TweenInfo.new(0.05), {BackgroundTransparency = 0.3}):Play()
            ShowSkinPopup(skin.id, skin.name)
        end)

        card.MouseEnter:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
        end)
        card.MouseLeave:Connect(function()
            TweenService:Create(card, TweenInfo.new(0.15), {BackgroundTransparency = 0.3}):Play()
        end)
    end
end

do
    local settingsPageH = pages["Teleport"]
    local TweenService = game:GetService("TweenService")

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local mainHolder = Instance.new("Frame", settingsPageH)
    mainHolder.Size = UDim2.new(1, 0, 0, 0)
    mainHolder.AutomaticSize = Enum.AutomaticSize.Y
    mainHolder.BackgroundTransparency = 1
    Instance.new("UIListLayout", mainHolder).Padding = UDim.new(0, 10)
    Instance.new("UIPadding", mainHolder).PaddingTop = UDim.new(0, 10)

    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TeleportService = game:GetService("TeleportService")

    local function getBeast()
        for _,v in pairs(Players:GetPlayers()) do
            local stats = v:FindFirstChild("TempPlayerStatsModule")
            if stats and stats:FindFirstChild("IsBeast") and stats.IsBeast.Value then
                return v
            end
        end
    end

    local function teleportTo(cf)
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = cf + Vector3.new(0, 3, 0)
        end
    end

    local function getPCs()
        local pcs = {}
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "ComputerTable" and v:FindFirstChild("Screen") then
                table.insert(pcs, v)
            end
        end
        return pcs
    end

    local function getDoors()
        local doors = {}
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "ExitDoor" and v:FindFirstChild("Door") then
                table.insert(doors, v)
            end
        end
        return doors
    end

    local function getFreezepods()
        local pods = {}
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "FreezePod" then
                table.insert(pods, v)
            end
        end
        return pods
    end

    local function getMapPoints(name)
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():find(name:lower()) and v:IsA("BasePart") then
                return v
            end
        end
    end

    local function CreateButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0

        local originalColor = btn.TextColor3

        btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.08), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            task.delay(0.08, function()
                TweenService:Create(btn, TweenInfo.new(0.12), {TextColor3 = originalColor}):Play()
            end)

            callback()
        end)
        return btn
    end

    local columnsH = Instance.new("Frame", mainHolder)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -13, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -15, 0, 0)
    rightColH.Position = UDim2.new(0.5, 1, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local boxMap, contentMap = CreateGroupbox(leftColH, "Map Objects")
    boxMap.BackgroundColor3 = Color3.fromRGB(20,20,20)
    boxMap.BackgroundTransparency = 1
    boxMap.BorderSizePixel = 0
    boxMap.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxMap).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxMap).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentMap).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", contentMap).PaddingLeft = UDim.new(0, 10)

    CreateButton(contentMap, "TP Computer", function()
        local pcs = getPCs()
        if #pcs > 0 then
            teleportTo(pcs[1].Screen.CFrame * CFrame.new(-3.5, 0, 0))
        end
    end)

    CreateButton(contentMap, "TP Exitdoor", function()
        local doors = getDoors()
        if #doors > 0 then
            teleportTo(doors[1].Door.CFrame)
        end
    end)

    CreateButton(contentMap, "TP Freezepods", function()
        local pods = getFreezepods()
        if #pods > 0 then
            teleportTo(pods[1].CFrame)
        end
    end)

    CreateButton(contentMap, "TP Crystal Cove", function()
        local point = getMapPoints("Crystal") or getMapPoints("Cove")
        if point then teleportTo(point.CFrame) end
    end)

    CreateButton(contentMap, "TP Beast Cave", function()
        local point = getMapPoints("Cave") or getMapPoints("Beast")
        if point then teleportTo(point.CFrame) end
    end)

    CreateButton(contentMap, "TP Map", function()
        teleportTo(CFrame.new(0, 10, 0))
    end)

    local boxExtra, contentExtra = CreateGroupbox(rightColH, "Extras")
    boxExtra.BackgroundColor3 = Color3.fromRGB(20,20,20)
    boxExtra.BackgroundTransparency = 1
    boxExtra.BorderSizePixel = 0
    boxExtra.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxExtra).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxExtra).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentExtra).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", contentExtra).PaddingLeft = UDim.new(0, 10)

    CreateButton(contentExtra, "Teleport to Beast", function()
        local beast = getBeast()
        if beast and beast.Character and beast.Character:FindFirstChild("HumanoidRootPart") then
            teleportTo(beast.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
        end
    end)

    CreateButton(contentExtra, "Reset Character", function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.Health = 0
        end
    end)

    CreateButton(contentExtra, "Server Rejoin", function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)

    CreateButton(contentExtra, "Random Servers", function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        if servers.data and #servers.data > 0 then
            local randomServer = servers.data[math.random(1, #servers.data)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer.id, Player)
        end
    end)

    local boxPlayers, contentPlayers = CreateGroupbox(mainHolder, "Players Teleport")
    boxPlayers.Size = UDim2.new(1, -10, 0, 0)
    boxPlayers.BackgroundColor3 = Color3.fromRGB(0,0,0)
    boxPlayers.BackgroundTransparency = 1
    boxPlayers.BorderSizePixel = 0
    boxPlayers.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxPlayers).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxPlayers).Color = Color3.fromRGB(70,70,70)

    local refreshBtn = Instance.new("TextButton", boxPlayers)
    refreshBtn.Size = UDim2.new(0, 80, 0, 25)
    refreshBtn.Position = UDim2.new(1, -85, 0, 5)
    refreshBtn.BackgroundTransparency = 1
    refreshBtn.Text = "Refresh"
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 13
    refreshBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    refreshBtn.BorderSizePixel = 0

    local scrollPlayers = Instance.new("ScrollingFrame", contentPlayers)
    scrollPlayers.Size = UDim2.new(1, 0, 0, 220)
    scrollPlayers.BackgroundTransparency = 1
    scrollPlayers.ScrollBarThickness = 4
    scrollPlayers.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollPlayers.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UIListLayout", scrollPlayers).Padding = UDim.new(0, 8)
    Instance.new("UIPadding", scrollPlayers).PaddingTop = UDim.new(0, 5)

    local function refreshPlayerList()
        for _,v in pairs(scrollPlayers:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end

        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                local plrFrame = Instance.new("Frame", scrollPlayers)
                plrFrame.Size = UDim2.new(1, -5, 0, 45)
                plrFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                plrFrame.BackgroundTransparency = 0.4
                plrFrame.BorderSizePixel = 0
                Instance.new("UICorner", plrFrame).CornerRadius = UDim.new(0, 6)

                local thumb = Instance.new("ImageLabel", plrFrame)
                thumb.Size = UDim2.new(0, 35, 0, 35)
                thumb.Position = UDim2.new(0, 8, 0.5, -17.5)
                thumb.BackgroundTransparency = 1
                thumb.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 6)

                local name = Instance.new("TextLabel", plrFrame)
                name.Size = UDim2.new(1, -130, 1, 0)
                name.Position = UDim2.new(0, 50, 0, 0)
                name.BackgroundTransparency = 1
                name.Text = plr.DisplayName.. "\n@".. plr.Name
                name.Font = Enum.Font.GothamBold
                name.TextSize = 13
                name.TextColor3 = Color3.fromRGB(255, 255, 255)
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.TextYAlignment = Enum.TextYAlignment.Center

                local tpBtn = Instance.new("TextButton", plrFrame)
                tpBtn.Size = UDim2.new(0, 75, 0, 30)
                tpBtn.Position = UDim2.new(1, -80, 0.5, -15)
                tpBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
                tpBtn.Text = "Teleport"
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 13
                tpBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                tpBtn.BorderSizePixel = 0
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

                tpBtn.MouseButton1Click:Connect(function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        teleportTo(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
                    end
                end)
            end
        end
    end

    refreshBtn.MouseButton1Click:Connect(refreshPlayerList)
    refreshPlayerList()
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)
end

do
    local settingsPageH = pages["Setting"]
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")
    local Stats = game:GetService("Stats")
    local RunService = game:GetService("RunService")
    local Player = game:GetService("Players").LocalPlayer
    local playerGui = Player:WaitForChild("PlayerGui")

    pcall(function() setfpscap(0) end)

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local function GetMainFrame()
        if frame then return frame end
        local ui = playerGui:FindFirstChild("EclipseUI")
        if not ui then
            ui = playerGui:WaitForChild("EclipseUI", 5)
        end
        if not ui then return nil end
        return ui:FindFirstChild("Main", true)
    end

    if not isfolder("FTF_Eclipse") then makefolder("FTF_Eclipse") end

    local backgrounds = {
        {"Style 1", "92787928900360"},
        {"Style 2", "109143338870022"},
        {"Style 3", "78186972924904"},
        {"Style 4", "105066440016571"},
        {"Style 5", "110215769551010"},
        {"Style 6", "115541469321190"},
        {"Style 7", "97984932480755"},
        {"Style 8", "86192845180549"},
        {"Style 9", "85784609294289"},
        {"Style 10", "140636010520663"},
        {"Style 11", "124240486073107"},
        {"Style 12", "85635291549219"},
        {"Style 13", "117512819334968"},
        {"Style 14", "111750153717391"},
        {"Style 15", "98791036867631"},
        {"Style 16", "131737959610359"},
        {"Style 17", "81997082602790"},
        {"Style 18", "117151748213203"},
        {"Style 19", "112483283923855"},
        {"Style 20", "109490272700736"},
        {"Style 21", "125661929366351"},
        {"Style 22", "74184537251110"},
        {"Style 23", "124786302962772"},
        {"Style 24", "125474858681812"},
        {"Style 25", "99142368271124"},
        {"Style 26", "94865353552525"},
        {"Style 27", "120484401704545"},
    }

    getgenv().BackgroundLocked = getgenv().BackgroundLocked or false
    getgenv().ShowFPS = getgenv().ShowFPS or false
    getgenv().ShowPing = getgenv().ShowPing or false
    getgenv().ShowCPU = getgenv().ShowCPU or false

    local function SaveConfig()
        local data = {
            BackgroundID = getgenv().CustomBackgroundID or "",
            UIBackground = getgenv().UIBackground or "Style 1",
            Font = getgenv().UIFont or "Gotham",
            BackgroundLocked = getgenv().BackgroundLocked,
            ShowFPS = getgenv().ShowFPS, ShowPing = getgenv().ShowPing, ShowCPU = getgenv().ShowCPU
        }
        pcall(function()
            writefile("FTF_Eclipse/config.json", HttpService:JSONEncode(data))
        end)
    end

    local function LoadConfig()
        if isfile("FTF_Eclipse/config.json") then
            local success, data = pcall(function()
                return HttpService:JSONDecode(readfile("FTF_Eclipse/config.json"))
            end)
            if success and data then
                getgenv().CustomBackgroundID = data.BackgroundID or ""
                getgenv().UIBackground = data.UIBackground or "Style 1"
                getgenv().UIFont = data.Font or "Gotham"
                getgenv().BackgroundLocked = data.BackgroundLocked or false
                getgenv().ShowFPS = data.ShowFPS or false
                getgenv().ShowPing = data.ShowPing or false
                getgenv().ShowCPU = data.ShowCPU or false
                return data
            end
        end
        getgenv().UIBackground = "Style 1"
        getgenv().UIFont = "Gotham"
        getgenv().CustomBackgroundID = backgrounds[1][2]
        getgenv().BackgroundLocked = false
        SaveConfig()
        return nil
    end

    local function UpdateBackground(id, force)
        if getgenv().BackgroundLocked and not force then return end
        local mainFrame = GetMainFrame()
        if not mainFrame then return end
        local oldBg = mainFrame:FindFirstChild("CustomBg")
        if oldBg then oldBg:Destroy() end
        if id and id ~= "" then
            local bg = Instance.new("ImageLabel", mainFrame)
            bg.Name = "CustomBg"
            bg.Size = UDim2.new(1,0,1,0)
            bg.Position = UDim2.new(0,0,0,0)
            bg.BackgroundTransparency = 1
            bg.Image = "rbxassetid://".. tostring(id)
            bg.ImageTransparency = 0.15
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 0
        end
    end

    LoadConfig()

    task.spawn(function()
        for i = 1, 20 do
            local mainFrame = GetMainFrame()
            if mainFrame then break end
            task.wait(0.25)
        end
        local id = getgenv().CustomBackgroundID
        if not id or id == "" then
            for _, b in ipairs(backgrounds) do
                if b[1] == getgenv().UIBackground then
                    id = b[2]
                    break
                end
            end
            if not id or id == "" then id = backgrounds[1][2] end
            getgenv().CustomBackgroundID = id
        end
        UpdateBackground(id, true)
    end)

    local container = Instance.new("Frame", settingsPageH)
    container.Size = UDim2.new(1, -20, 1, 0)
    container.Position = UDim2.new(0, 10, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 10)
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local CurrentFont = Enum.Font[getgenv().UIFont] or Enum.Font.Gotham
    local function ApplyFont(font)
        CurrentFont = font
        local mainFrame = GetMainFrame()
        if mainFrame then
            for _, obj in ipairs(mainFrame:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    obj.Font = font
                end
            end
        end
        if fpsLabel then fpsLabel.Font = font end
    end
    ApplyFont(CurrentFont)

    local function CreateGroupbox(parent, title)
        local box = Instance.new("Frame", parent)
        box.Size = UDim2.new(1,0,0,0)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 0
        box.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
        Instance.new("UIStroke", box).Color = Color3.fromRGB(70,70,70)

        local titleLabel = Instance.new("TextLabel", box)
        titleLabel.Size = UDim2.new(1,-20,0,20)
        titleLabel.Position = UDim2.new(0,10,0,0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.Font = CurrentFont
        titleLabel.TextSize = 14
        titleLabel.TextColor3 = Color3.fromRGB(235,235,235)
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        local content = Instance.new("Frame", box)
        content.Size = UDim2.new(1,0,0,0)
        content.Position = UDim2.new(0,0,0,22)
        content.BackgroundTransparency = 1
        content.AutomaticSize = Enum.AutomaticSize.Y

        local cl = Instance.new("UIListLayout", content)
        cl.Padding = UDim.new(0, 6)
        cl.SortOrder = Enum.SortOrder.LayoutOrder

        return box, content
    end

    local boxSettings, contentSettings = CreateGroupbox(container, "Appearance")

    local function CreateDropdown(parent, labelText, list, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,35)
        holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
        holder.BackgroundTransparency = 0.3
        holder.ClipsDescendants = false
        holder.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,6)
        Instance.new("UIListLayout", holder).Padding = UDim.new(0,0)

        local top = Instance.new("Frame", holder)
        top.Size = UDim2.new(1,0,0,35)
        top.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", top)
        label.Size = UDim2.new(1,-40,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = labelText..": "..default
        label.Font = CurrentFont
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local arrow = Instance.new("TextLabel", top)
        arrow.Size = UDim2.new(0,20,1,0)
        arrow.Position = UDim2.new(1,-25,0,0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "v"
        arrow.Font = CurrentFont
        arrow.TextSize = 12
        arrow.TextColor3 = Color3.fromRGB(180,180,180)

        local clickArea = Instance.new("TextButton", top)
        clickArea.Size = UDim2.new(1,0,1,0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""

        local dropdownFrame = Instance.new("Frame", holder)
        dropdownFrame.Size = UDim2.new(1,-8,0,0)
        dropdownFrame.Position = UDim2.new(0,4,0,0)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        dropdownFrame.BackgroundTransparency = 0.05
        dropdownFrame.ClipsDescendants = true
        Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", dropdownFrame).Color = Color3.fromRGB(45,45,50)
        Instance.new("UIListLayout", dropdownFrame).Padding = UDim.new(0,0)

        local isOpen = false
        local dropdownHeight = #list * 34

        for i, data in ipairs(list) do
            local valueName = type(data) == "table" and data[1] or data
            local option = Instance.new("TextButton", dropdownFrame)
            option.Size = UDim2.new(1,0,0,34)
            option.BackgroundTransparency = 1
            option.Text = valueName
            option.Font = CurrentFont
            option.TextSize = 14
            option.TextColor3 = option.Text == default and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,170,170)
            option.BorderSizePixel = 0
            option.AutoButtonColor = false

            if i < #list then
                local line = Instance.new("Frame", option)
                line.Size = UDim2.new(1,-20,0,1)
                line.Position = UDim2.new(0,10,1,0)
                line.BackgroundColor3 = Color3.fromRGB(35,35,40)
                line.BorderSizePixel = 0
                line.ZIndex = 2
            end

            option.MouseButton1Click:Connect(function()
                local value = type(data) == "table" and data[1] or data
                local id = type(data) == "table" and data[2] or ""
                label.Text = labelText..": "..value
                for _, opt in pairs(dropdownFrame:GetChildren()) do
                    if opt:IsA("TextButton") then opt.TextColor3 = Color3.fromRGB(170,170,170) end
                end
                option.TextColor3 = Color3.fromRGB(255,255,255)

                getgenv().UIBackground = value
                getgenv().CustomBackgroundID = id
                getgenv().BackgroundLocked = true
                UpdateBackground(id, true)
                SaveConfig()

                TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1,-8,0,0)}):Play()
                arrow.Text = "v"
                task.wait(0.25)
                isOpen = false
            end)
        end

        clickArea.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                arrow.Text = "^"
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(1,-8,0,dropdownHeight)}):Play()
            else
                arrow.Text = "v"
                TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1,-8,0,0)}):Play()
            end
        end)
    end

    CreateDropdown(contentSettings, "UI Background", backgrounds, getgenv().UIBackground, function(data) end)

    do
        local holder = Instance.new("Frame", contentSettings)
        holder.Size = UDim2.new(1,0,0,35)
        holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
        holder.BackgroundTransparency = 0.3
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,6)
        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,0,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = "Custom Background ID"
        label.Font = CurrentFont
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.TextXAlignment = Enum.TextXAlignment.Left
        local inputBox = Instance.new("TextBox", holder)
        inputBox.Size = UDim2.new(0,80,0,24)
        inputBox.Position = UDim2.new(1,-90,0.5,-12)
        inputBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
        inputBox.BackgroundTransparency = 0.2
        inputBox.PlaceholderText = "ID..."
        inputBox.Font = CurrentFont
        inputBox.TextSize = 13
        inputBox.TextColor3 = Color3.fromRGB(235,235,235)
        inputBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
        inputBox.TextXAlignment = Enum.TextXAlignment.Center
        inputBox.BorderSizePixel = 0
        Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0,5)
        inputBox.FocusLost:Connect(function(enter)
            if enter then
                local id = inputBox.Text:match("%d+")
                if id then
                    getgenv().CustomBackgroundID = id
                    getgenv().UIBackground = "Custom"
                    getgenv().BackgroundLocked = true
                    UpdateBackground(id, true)
                    SaveConfig()
                end
            end
        end)
    end

    local fonts = {}
    for _, font in pairs(Enum.Font:GetEnumItems()) do table.insert(fonts, font.Name) end
    table.sort(fonts)
    CreateDropdown(contentSettings, "UI Font", fonts, getgenv().UIFont, function(fontName)
        getgenv().UIFont = fontName
        ApplyFont(Enum.Font[fontName])
        SaveConfig()
    end)

do
    local holder = Instance.new("Frame", contentSettings)
    holder.Size = UDim2.new(1, 0, 0, 68)
    holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    holder.BackgroundTransparency = 0.3
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 15, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = "Shine Color"
    label.Font = CurrentFont
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local preview = Instance.new("Frame", holder)
    preview.Size = UDim2.new(0, 24, 0, 24)
    preview.Position = UDim2.new(1, -34, 0, 6)
    preview.BackgroundColor3 = getgenv().ShineColor or Color3.fromRGB(255, 255, 255)
    preview.BorderSizePixel = 0
    Instance.new("UICorner", preview).CornerRadius = UDim.new(1, 0)
    Instance.new("UIStroke", preview).Color = Color3.fromRGB(60, 60, 60)

    local colors = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 170, 255),
        Color3.fromRGB(0, 255, 120),
        Color3.fromRGB(255, 200, 0),
        Color3.fromRGB(170, 0, 255),
        Color3.fromRGB(255, 80, 200),
        Color3.fromRGB(255, 120, 0),
    }

    local function ApplyShineColor(color)
        getgenv().ShineColor = color
        preview.BackgroundColor3 = color
        pcall(SaveConfig)
        for _, data in pairs(tabShines) do
            if data.gradient and data.gradient.Parent then
                data.gradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.5, color),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                })
                data.gradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
            end
        end
    end

    if getgenv().ShineColor then
        task.delay(0.5, function() ApplyShineColor(getgenv().ShineColor) end)
    end

    local x = 15
    for _, col in ipairs(colors) do
        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(0, 22, 0, 22)
        btn.Position = UDim2.new(0, x, 0, 34)
        btn.BackgroundColor3 = col
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        Instance.new("UIStroke", btn).Color = Color3.fromRGB(50, 50, 50)
        btn.Activated:Connect(function()
            ApplyShineColor(col)
            Notify("Theme System", "Shine color applied!", 3)
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(0, 18, 0, 18)}):Play()
            task.delay(0.1, function()
                TweenService:Create(btn, TweenInfo.new(0.15), {Size = UDim2.new(0, 22, 0, 22)}):Play()
            end)
        end)
        x += 28
    end

    local hexBox = Instance.new("TextBox", holder)
    hexBox.Size = UDim2.new(0, 70, 0, 22)
    hexBox.Position = UDim2.new(1, -80, 0, 34)
    hexBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hexBox.PlaceholderText = "HEX"
    hexBox.Text = ""
    hexBox.Font = CurrentFont
    hexBox.TextSize = 12
    hexBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    hexBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    hexBox.TextXAlignment = Enum.TextXAlignment.Center
    hexBox.BorderSizePixel = 0
    Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 6)
    hexBox.FocusLost:Connect(function(enter)
        if not enter then return end
        local hex = hexBox.Text:gsub("#", ""):gsub("%s+", "")
        if #hex == 6 then
            local ok, col = pcall(function() return Color3.fromHex(hex) end)
            if ok and col then
                ApplyShineColor(col)
                Notify("FTF Eclipse V2.9", "Shine color aplicado!", 3)
            end
        end
    end)
end

    local boxStats, contentStats = CreateGroupbox(container, "Configuration")

    local function CreateToggle(parent, text, default, callback)
        local toggleFrame = Instance.new("Frame", parent)
        toggleFrame.Size = UDim2.new(1, 0, 0, 22)
        toggleFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", toggleFrame)
        label.Size = UDim2.new(1, -50, 1, 0)
        label.Position = UDim2.new(0, 18, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = CurrentFont
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(180, 180, 180)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggle = Instance.new("TextButton", toggleFrame)
        toggle.Size = UDim2.new(0, 38, 0, 17)
        toggle.Position = UDim2.new(1, -40, 0.5, -9)
        toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggle.BackgroundTransparency = default and 0 or 1
        toggle.Text = ""
        toggle.AutoButtonColor = false
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke", toggle)
        stroke.Color = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
        stroke.Thickness = 1.5

        local circle = Instance.new("Frame", toggle)
        circle.Size = UDim2.new(0, 14, 0, 14)
        circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        circle.BackgroundColor3 = default and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local enabled = default
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            TweenService:Create(circle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = enabled and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(220, 220, 220)
            }):Play()
            TweenService:Create(toggle, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = enabled and 0 or 1,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15), {
                Color = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
            }):Play()
            if callback then callback(enabled) end
            SaveConfig()
        end)
        return toggleFrame
    end

CreateToggle(contentStats, "Touch Screen Interface", true, function(enabled)
    CrosshairLayer.Visible = enabled
end)

    local fpsGui, fpsLabel
    local fpsConnection

    local function CreateFPSCounter()
        if fpsGui then fpsGui:Destroy() end
        fpsGui = Instance.new("ScreenGui")
        fpsGui.Name = "FPSCounter"
        fpsGui.ResetOnSpawn = false
        fpsGui.Parent = playerGui

        local frame = Instance.new("Frame", fpsGui)
        frame.Size = UDim2.new(0, 180, 0, 25)
        frame.Position = UDim2.new(0, 10, 0, 1)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        fpsLabel = Instance.new("TextLabel", frame)
        fpsLabel.Size = UDim2.new(1, 0, 1, 0)
        fpsLabel.BackgroundTransparency = 1
        fpsLabel.Text = "FPS: 0 (Optimized)"
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        fpsLabel.Font = CurrentFont
        fpsLabel.TextSize = 14
        fpsLabel.TextXAlignment = Enum.TextXAlignment.Center

        local lastTick = tick()
        local frameCount = 0

        fpsConnection = RunService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            if tick() - lastTick >= 0.25 then
                local currentFps = math.floor(frameCount / (tick() - lastTick) + 0.5)
                frameCount = 0
                lastTick = tick()

                local status = "(Optimized)"
                local color = Color3.fromRGB(0, 255, 0)

                if currentFps < 30 then
                    status = "(Laggy)"
                    color = Color3.fromRGB(255, 0, 0)
                elseif currentFps < 60 then
                    status = "(Normal)"
                    color = Color3.fromRGB(255, 255, 0)
                elseif currentFps >= 120 then
                    status = "(Ultra)"
                    color = Color3.fromRGB(0, 255, 255)
                end

                fpsLabel.Text = "FPS: ".. currentFps.." ".. status
                fpsLabel.TextColor3 = color
            end
        end)
    end

    CreateToggle(contentStats, "Show FPS", getgenv().ShowFPS, function(state)
        getgenv().ShowFPS = state
        if state then
            CreateFPSCounter()
        else
            if fpsConnection then fpsConnection:Disconnect() end
            if fpsGui then fpsGui:Destroy() end
        end
    end)

    local pingLabel, cpuLabel
    CreateToggle(contentStats, "Show Ping", getgenv().ShowPing, function(state)
        getgenv().ShowPing = state
        if state and not pingLabel then
            local screenGui = Instance.new("ScreenGui", playerGui)
            screenGui.Name = "PINGCounter"
            local frame = Instance.new("Frame", screenGui)
            frame.Size = UDim2.new(0, 120, 0, 25) frame.Position = UDim2.new(0, 10, 0, 30)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) frame.BackgroundTransparency = 0.3
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            pingLabel = Instance.new("TextLabel", frame)
            pingLabel.Size = UDim2.new(1, 0, 1, 0) pingLabel.BackgroundTransparency = 1
            pingLabel.Font = CurrentFont pingLabel.TextSize = 14 pingLabel.TextXAlignment = Enum.TextXAlignment.Center
            task.spawn(function()
                while getgenv().ShowPing do
                    local ping = 0
                    pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
                    pingLabel.Text = "PING: ".. ping.."ms"
                    pingLabel.TextColor3 = ping > 150 and Color3.fromRGB(255,0,0) or ping > 80 and Color3.fromRGB(255,165,0) or Color3.fromRGB(0,255,0)
                    task.wait(0.5)
                end
            end)
        elseif not state and pingLabel then pingLabel.Parent:Destroy() pingLabel = nil end
    end)

    CreateToggle(contentStats, "Show CPU", getgenv().ShowCPU, function(state)
        getgenv().ShowCPU = state
        if state and not cpuLabel then
            local screenGui = Instance.new("ScreenGui", playerGui)
            screenGui.Name = "CPUCounter"
            local frame = Instance.new("Frame", screenGui)
            frame.Size = UDim2.new(0, 120, 0, 25) frame.Position = UDim2.new(0, 10, 0, 60)
            frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) frame.BackgroundTransparency = 0.3
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            cpuLabel = Instance.new("TextLabel", frame)
            cpuLabel.Size = UDim2.new(1, 0, 1, 0) cpuLabel.BackgroundTransparency = 1
            cpuLabel.Font = CurrentFont cpuLabel.TextSize = 14 cpuLabel.TextXAlignment = Enum.TextXAlignment.Center
            task.spawn(function()
                while getgenv().ShowCPU do
                    local physics = Stats.PerformanceStats:GetValue("PhysicsStepMs")
                    local render = Stats.PerformanceStats:GetValue("RenderMs")
                    local total = physics + render
                    cpuLabel.Text = string.format("CPU: %.1fms", total)
                    cpuLabel.TextColor3 = total > 16 and Color3.fromRGB(255,0,0) or total > 8 and Color3.fromRGB(255,255,0) or Color3.fromRGB(0,200,255)
                    task.wait(0.25)
                end
            end)
        elseif not state and cpuLabel then cpuLabel.Parent:Destroy() cpuLabel = nil end
    end)

    task.spawn(function()
        task.wait(0.5)
        UpdateBackground(getgenv().CustomBackgroundID, true)
    end)

    local MEU_CODIGO = [[
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    ]]

    local function CreateAnimatedButton(parent, text)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 38)
        btn.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ClipsDescendants = true
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(70, 70, 70)
        stroke.Thickness = 1

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.Font = CurrentFont or Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.ZIndex = 6

        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -6, 0, 34), BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(label, TweenInfo.new(0.1), {TextSize = 13}):Play()
        end)
        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            TweenService:Create(label, TweenInfo.new(0.25), {TextSize = 14}):Play()
        end)

        btn.MouseButton1Click:Connect(function()
            local ripple = Instance.new("Frame", btn)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            ripple.Size = UDim2.new(0, 10, 0, 10)
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.5
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 7
            Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
            TweenService:Create(ripple, TweenInfo.new(0.5), {Size = UDim2.new(1.5, 0, 1.5, 0), BackgroundTransparency = 1}):Play()
            game:GetService("Debris"):AddItem(ripple, 0.5)

            local oldText = label.Text
            label.Text = "Carregando..."
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 80)}):Play()
            task.wait(0.25)
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            label.Text = "Carregado ✓"
            task.wait(0.8)
            label.Text = oldText

            local ok, err = pcall(function()
                loadstring(MEU_CODIGO)()
            end)
            if not ok then
                label.Text = "Erro!"
                warn("Erro:", err)
                task.wait(1)
                label.Text = oldText
            end
        end)
        return btn
    end

    CreateAnimatedButton(contentStats, "Inifine Yield")
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local currentLanguage = "EN"

local Translation = {
	EN = {
		Search = "Search...",
		Highlights = "Highlights", Visual = "Visual", Progress = "Progress",
		Textures = "Textures", Fog = "Fog", AutoFarm = "Auto Farm",
		Advanced = "Advanced", Sounds = "Sounds", VisualSkins = "Visual Skins",
		Teleport = "Teleport", Setting = "Setting", Settings = "Settings",
		ObjectsFeatures = "Objects Features",
		ESPsFeatures = "ESPs Features",
		SettingsHighlights = "Settings Highlights",
		ColorCustomization = "Color Customization",
		OutlineCustomization = "Outline Customization",
		Computer = "Computer", Capsule = "Capsule", Exit = "Exit", Door = "Door",
		Fill = "Fill", Outline = "Outline",
		Charms = "Charms", Square = "Square", TraceLine = "Trace Line", BeastGlowUp = "Beast GlowUp",
		BeastFillColor = "Beast Fill Color", SurvivorFillColor = "Survivor Fill Color",
		ComputerFillColor = "Computer Fill Color", DoorFillColor = "Door Fill Color",
		FreezepodFillColor = "Freezepod Fill Color",
		BeastOutline = "Beast Outline", SurvivorOutline = "Survivor Outline",
		ComputerOutline = "Computer Outline", FreezepodOutline = "Freezepod Outline",
		DoorOutline = "Door Outline", CharmsSurvivor = "Charms Survivor", CharmsBeast = "Charms Beast",
		ResetAllOutline = "Reset All Outline", ResetAllFill = "Reset All Fill",
		Survivor = "Survivor", Beast = "Beast",
		BeastUntiePlayer = "Beast Untie Player", AntiRagdoll = "Anti Ragdoll",
		SlowBeast = "Slow Beast", SlowBeastRunner = "Slow Beast Runner",
		BeastAbility = "Beast Ability", BeastPowerNotify = "Beast Power Notify",
		TouchFling = "Touch Fling", MacroWallHop = "Macro WallHop",
		CameraMode = "Camera Mode", Noclip = "Noclip", AutoHitBeast = "Auto Hit Beast",
		AutoHitRange = "Auto Hit Range", AutoHitDelay = "Auto Hit Delay",
		CrawlBeast = "Crawl Beast", AutoTieAura = "Auto Tie aura", AutoTieAfterHit = "Auto Tie After Hit",
		Transparency = "Transparency",
		PlayerSpoof = "Player Spoof", HideUsername = "Hide Username",
		Username = "Username", Level = "Level", Icon = "Icon", None = "None",
		IconDefault = "Icon: Default", TargetNick = "Target Nick", Nick = "Nick",
		Camera = "Camera", EnableFOV = "Enable FOV", FieldOfView = "Field Of View",
		Stretch065 = "Stretch 0.65", Stretch07 = "Stretch 0.7",
		Sensitivity = "Sensitivity", SensitivityX = "Sensitivity X", SensitivityY = "Sensitivity Y",
		ResetX = "Reset X", ResetY = "Reset Y",
		ActionTimers = "Action Timers", ComputerProgress = "Computer Progress",
		ExitDoorTimer = "Exit Door Timer", DoorTimer = "Door Timer",
		LifeTimer = "Life Timer", Walkspeed = "Walkspeed",
		TimerColors = "Timer Colors", ComputerColor = "Computer Color",
		ExitDoorColor = "Exit Door Color", DoorTimerColor = "Door Timer Color",
		LifeTimerColor = "Life Timer Color", WalkspeedColor = "Walkspeed Color",
		ResetTimerColors = "Reset Timer Colors",
		BeastIndicators = "Beast Indicators", GetUpTimer = "GetUp Timer",
		BeastPower = "Beast Power", BeastPowerV2 = "Beast Power V2",
		BeastSpawnTimer = "Beast Spawn Timer", IndicatorsColors = "Indicators Colors",
		GetUpColor = "GetUp Color", BeastPowerColor = "Beast Power Color",
		BeastPowerV2Color = "Beast Power V2 Color", BeastSpawnColor = "Beast Spawn Color",
		ResetIndicatorsColors = "Reset Indicators Colors",
		MapTextures = "Map Textures", WhiteBricks = "White Bricks",
		SnowMap = "Snow Map", RemoveTextures = "Remove Textures",
		MinecraftTexture = "Minecraft Texture", DoubleJumpEffect = "Double Jump Effect",
		EnterTextureID = "Enter Texture ID...", Apply = "Apply",
		FPSSetting = "FPS Setting", FPSBoost = "FPS Boost",
		GrayCharacter = "Gray Character", Crosshair = "Crosshair",
		ButtonJump = "Button Jump", Default = "Padrão",
		Calibration = "Calibration", EnableCalibration = "Enable Calibration",
		Brightness = "Brightness", Contrast = "Contrast", Saturation = "Saturation",
		Exposure = "Exposure", Temperature = "Temperature", Blur = "Blur",
		ResetAll = "Reset All", Shaders = "Shaders", EnableShaders = "Enable Shaders",
		Preset = "Preset", ResetShaders = "Reset Shaders",
		Morning = "Morning", Midday = "Midday", Afternoon = "Afternoon",
		Evening = "Evening", Night = "Night", Midnight = "Midnight",
		FogSettings = "Fog Settings", BlackFog = "Black Fog", GrayFog = "Gray Fog", NoFog = "No Fog",
		EnableFogMode = "Enable Fog Mode", FogColor = "Fog Color",
		Flashlight = "Flashlight", FlashlightIntensity = "Flashlight Intensity",
		Character = "Character", EnableWalkSpeed = "Enable WalkSpeed",
		EnableFatigue = "Enable Fatigue", FatigueDelay = "Fatigue Delay",
		FatigueDuration = "Fatigue Duration", FatigueSpeed = "Fatigue Speed",
		EnableHighJump = "Enable High Jump", JumpPower = "Jump Power",
		EnableCrawl = "Enable Crawl", CrawlSpeed = "Crawl Speed",
		JumpClassic = "Jump & Classic", EnableClassicThumbstick = "Enable Classic Thumbstick",
		ThumbstickX = "Thumbstick X", ThumbstickY = "Thumbstick Y",
		EnableJumpButton = "Enable Jump Button",
		JumpX = "Jump X", JumpY = "Jump Y", JumpScale = "Jump Scale",
		AutoTieRange = "Auto Tie Range",
		HitAura = "Hit Aura", HitAuraRange = "Hit Aura Range",
		EnableHitbox = "Enable Hitbox", HideHitbox = "Hide Hitbox",
		HitboxX = "Hitbox X", HitboxY = "Hitbox Y", HitboxZ = "Hitbox Z",
		ButtonEButtonC = "Button E & Button C",
		EnableEButton = "Enable E Button",
		EX = "E X", EY = "E Y", ESize = "E Size",
		EnableCButton = "Enable C Button",
		CX = "C X", CY = "C Y", CSize = "C Size",
		Volume = "Volume", FootSteps = "FootSteps",
		Jump = "Jump", Fall = "Fall",
		ResetVolumes = "Reset Volumes", ResetSounds = "Reset Sounds",
		MuteSystem = "Mute System",
		MuteYourFootsteps = "Mute Your Footsteps",
		MuteYourJump = "Mute Your Jump",
		MuteYourFall = "Mute Your Fall",
		MuteHitSound = "Mute Hit Sound",
		StepDistance = "Step Distance",
		MinDistance = "Min Distance", MaxDistance = "Max Distance",
		RollOff = "RollOff", ResetDistance = "Reset Distance",
		MusicPlayer = "Music Player", MusicVolume = "Music Volume",
		Select = "Select", Play = "Play",
		SkinChanger = "Skin Changer",
		UsernamePlaceholder = "Username...",
		MapObjects = "Map Objects",
		TPComputer = "TP Computer",
		TPExitdoor = "TP Exitdoor",
		TPFreezepods = "TP Freezepods",
		TPCrystalCove = "TP Crystal Cove",
		TPBeastCave = "TP Beast Cave",
		TPMap = "TP Map",
		Extras = "Extras",
		TeleportToBeast = "Teleport to Beast",
		ResetCharacter = "Reset Character",
		ServerRejoin = "Server Rejoin",
		RandomServers = "Random Servers",
		PlayersTeleport = "Players Teleport",
		Update = "Atualizar",
		Appearance = "Appearance",
		UIBackground = "UI Background",
		CustomBackgroundID = "Custom Background ID",
		UIFont = "UI Font",
		ShineColor = "Shine Color",
		TouchScreenInterface = "Touch Screen Interface",
		ShowFPS = "Show FPS",
		Configuration = "Configuration",
		ShowPing = "Show Ping",
		ShowCPU = "Show CPU",
		TextBoxLabel = "TextBox",
		ThanksFooter = "FTF Eclipse V2.9 Mobile | Thank you for using FTF Eclipse.",
	},
	PT = {
		Search = "Pesquisar...",
		Highlights = "Destaques", Visual = "Visual", Progress = "Progresso",
		Textures = "Texturas", Fog = "Nevoeiro", AutoFarm = "Farm Automático",
		Advanced = "Avançado", Sounds = "Sons", VisualSkins = "Skins Visuais",
		Teleport = "Teleporte", Setting = "Configuração", Settings = "Configurações",
		ObjectsFeatures = "Recursos dos Objetos",
		ESPsFeatures = "Recursos de ESP",
		SettingsHighlights = "Configurações de Destaques",
		ColorCustomization = "Personalização de Cor",
		OutlineCustomization = "Personalização do Contorno",
		Computer = "Computador", Capsule = "Cápsula", Exit = "Saída", Door = "Porta",
		Fill = "Preencher", Outline = "Contorno",
		Charms = "Amuletos", Square = "Quadrado", TraceLine = "Linha", BeastGlowUp = "Brilho Fera",
		BeastFillColor = "Preencher Fera",
		SurvivorFillColor = "Preencher Sobreviv.",
		ComputerFillColor = "Preencher Computador",
		DoorFillColor = "Preencher Porta",
		FreezepodFillColor = "Preencher Freezepod",
		BeastOutline = "Contorno Fera",
		SurvivorOutline = "Contorno Sobreviv.",
		ComputerOutline = "Contorno Computador",
		FreezepodOutline = "Contorno Freezepod",
		DoorOutline = "Contorno Porta",
		CharmsSurvivor = "Amuletos Sobreviv.",
		CharmsBeast = "Amuletos Fera",
		ResetAllOutline = "Resetar Contorno",
		ResetAllFill = "Resetar Preencher",
		Survivor = "Sobrevivente", Beast = "Fera",
		BeastUntiePlayer = "Desamarrar Jogador",
		AntiRagdoll = "Anti Ragdoll",
		SlowBeast = "Lentidão Fera",
		SlowBeastRunner = "Lentidão Corredor",
		BeastAbility = "Habilidade Fera",
		BeastPowerNotify = "Aviso Poder Fera",
		TouchFling = "Toque Arremesso",
		MacroWallHop = "Macro WallHop",
		CameraMode = "Modo Câmera",
		Noclip = "Atravessar",
		AutoHitBeast = "Auto Hit Fera",
		AutoHitRange = "Alcance Hit",
		AutoHitDelay = "Delay Hit",
		CrawlBeast = "Rastejar Fera",
		AutoTieAura = "Auto Amarrar Aura",
		AutoTieAfterHit = "Amarrar Após Hit",
		Transparency = "Transparência",
		PlayerSpoof = "Falsificar Jogador", HideUsername = "Ocultar Nome",
		Username = "Nome de Usuário", Level = "Nível", Icon = "Ícone", None = "Nenhum",
		IconDefault = "Ícone: Padrão", TargetNick = "Apelido Alvo", Nick = "Apelido",
		Camera = "Câmera", EnableFOV = "Ativar FOV", FieldOfView = "Campo de Visão",
		Stretch065 = "Alongar 0.65", Stretch07 = "Alongar 0.7",
		Sensitivity = "Sensibilidade", SensitivityX = "Sensibilidade X", SensitivityY = "Sensibilidade Y",
		ResetX = "Resetar X", ResetY = "Resetar Y",
		ActionTimers = "Temporizadores de Ação",
		ComputerProgress = "Progresso Computador",
		ExitDoorTimer = "Timer Porta Saída",
		DoorTimer = "Timer Porta",
		LifeTimer = "Timer de Vida",
		Walkspeed = "Velocidade",
		TimerColors = "Cores do Timer",
		ComputerColor = "Cor Computador",
		ExitDoorColor = "Cor Porta Saída",
		DoorTimerColor = "Cor Timer Porta",
		LifeTimerColor = "Cor Timer Vida",
		WalkspeedColor = "Cor Velocidade",
		ResetTimerColors = "Resetar Cores Timer",
		BeastIndicators = "Indicadores da Fera",
		GetUpTimer = "Timer Levantar",
		BeastPower = "Poder da Fera",
		BeastPowerV2 = "Poder da Fera V2",
		BeastSpawnTimer = "Timer Spawn Fera",
		IndicatorsColors = "Cores Indicadores",
		GetUpColor = "Cor Levantar",
		BeastPowerColor = "Cor Poder Fera",
		BeastPowerV2Color = "Cor Poder Fera V2",
		BeastSpawnColor = "Cor Spawn Fera",
		ResetIndicatorsColors = "Resetar Cores Indicadores",
		MapTextures = "Texturas do Mapa",
		WhiteBricks = "Tijolos Brancos",
		SnowMap = "Mapa de Neve",
		RemoveTextures = "Remover Texturas",
		MinecraftTexture = "Textura Minecraft",
		DoubleJumpEffect = "Efeito Pulo Duplo",
		EnterTextureID = "Digite o ID da Textura...",
		Apply = "Aplicar",
		FPSSetting = "Config. de FPS",
		FPSBoost = "Boost de FPS",
		GrayCharacter = "Personagem Cinza",
		Crosshair = "Mira",
		ButtonJump = "Botão de Pulo",
		Default = "Padrão",
		Calibration = "Calibração",
		EnableCalibration = "Ativar Calibração",
		Brightness = "Brilho",
		Contrast = "Contraste",
		Saturation = "Saturação",
		Exposure = "Exposição",
		Temperature = "Temperatura",
		Blur = "Desfoque",
		ResetAll = "Resetar Tudo",
		Shaders = "Shaders",
		EnableShaders = "Ativar Shaders",
		Preset = "Predefinição",
		ResetShaders = "Resetar Shaders",
		Morning = "Manhã", Midday = "Meio-dia", Afternoon = "Tarde",
		Evening = "Entardecer", Night = "Noite", Midnight = "Meia-noite",
		FogSettings = "Config. de Névoa",
		BlackFog = "Névoa Preta", GrayFog = "Névoa Cinza", NoFog = "Sem Névoa",
		EnableFogMode = "Ativar Modo Névoa",
		FogColor = "Cor da Névoa",
		Flashlight = "Lanterna",
		FlashlightIntensity = "Intensidade Lanterna",
		Character = "Personagem",
		EnableWalkSpeed = "Ativar Velocidade",
		EnableFatigue = "Ativar Cansaço",
		FatigueDelay = "Delay do Cansaço",
		FatigueDuration = "Duração do Cansaço",
		FatigueSpeed = "Velocidade Cansaço",
		EnableHighJump = "Ativar Pulo Alto",
		JumpPower = "Força do Pulo",
		EnableCrawl = "Ativar Rastejar",
		CrawlSpeed = "Velocidade Rastejar",
		JumpClassic = "Pulo & Clássico",
		EnableClassicThumbstick = "Ativar Thumbstick Clássico",
		ThumbstickX = "Thumbstick X", ThumbstickY = "Thumbstick Y",
		EnableJumpButton = "Ativar Botão Pulo",
		JumpX = "Pulo X", JumpY = "Pulo Y", JumpScale = "Escala do Pulo",
		AutoTieRange = "Alcance Auto Amarrar",
		HitAura = "Aura de Hit", HitAuraRange = "Alcance Aura Hit",
		EnableHitbox = "Ativar Hitbox", HideHitbox = "Ocultar Hitbox",
		HitboxX = "Hitbox X", HitboxY = "Hitbox Y", HitboxZ = "Hitbox Z",
		ButtonEButtonC = "Botão E & Botão C",
		EnableEButton = "Ativar Botão E",
		EX = "E X", EY = "E Y", ESize = "Tamanho E",
		EnableCButton = "Ativar Botão C",
		CX = "C X", CY = "C Y", CSize = "Tamanho C",
		Volume = "Volume", FootSteps = "Passos",
		Jump = "Pulo", Fall = "Queda",
		ResetVolumes = "Resetar Volumes", ResetSounds = "Resetar Sons",
		MuteSystem = "Silenciar Sistema",
		MuteYourFootsteps = "Silenciar Seus Passos",
		MuteYourJump = "Silenciar Seu Pulo",
		MuteYourFall = "Silenciar Sua Queda",
		MuteHitSound = "Silenciar Som de Hit",
		StepDistance = "Distância de Passos",
		MinDistance = "Min Distância", MaxDistance = "Max Distância",
		RollOff = "RollOff", ResetDistance = "Reset Distância",
		MusicPlayer = "Tocador de Música", MusicVolume = "Volume da Música",
		Select = "Selecionar", Play = "Tocar",
		SkinChanger = "Trocador de Skin",
		UsernamePlaceholder = "Nome de usuário...",
		MapObjects = "Objetos do Mapa",
		TPComputer = "TP Computador",
		TPExitdoor = "TP Porta Saída",
		TPFreezepods = "TP Freezepods",
		TPCrystalCove = "TP Crystal Cove",
		TPBeastCave = "TP Caverna da Fera",
		TPMap = "TP Mapa",
		Extras = "Extras",
		TeleportToBeast = "Teleportar p/ Fera",
		ResetCharacter = "Resetar Personagem",
		ServerRejoin = "Reentrar no Servidor",
		RandomServers = "Servidores Aleatórios",
		PlayersTeleport = "Teleporte de Jogadores",
		Update = "Atualizar",
		Appearance = "Aparência",
		UIBackground = "Fundo da UI",
		CustomBackgroundID = "ID de Fundo Personalizado",
		UIFont = "Fonte da UI",
		ShineColor = "Cor do Brilho",
		TouchScreenInterface = "Interface Tela Touch",
		ShowFPS = "Mostrar FPS",
		Configuration = "Configuração",
		ShowPing = "Mostrar Ping",
		ShowCPU = "Mostrar CPU",
		TextBoxLabel = "Caixa de Texto",
		ThanksFooter = "FTF Eclipse V2.9 Mobile | Obrigado por usar FTF Eclipse.",
	}
}

local TextToKey = {
	["Search..."] = "Search", ["Pesquisar..."] = "Search",
	["Highlights"] = "Highlights", ["Visual"] = "Visual", ["Progress"] = "Progress",
	["Textures"] = "Textures", ["Fog"] = "Fog",
	["Farm Automático"] = "AutoFarm", ["Auto Farm"] = "AutoFarm",
	["Advanced"] = "Advanced", ["Sounds"] = "Sounds", ["Visual Skins"] = "VisualSkins",
	["Teleport"] = "Teleport", ["Teleporte"] = "Teleport",
	["Setting"] = "Setting", ["Settings"] = "Settings",
	["Objects Features"] = "ObjectsFeatures", ["Recursos dos Objetos"] = "ObjectsFeatures", ["Objetos"] = "ObjectsFeatures",
	["ESPs Features"] = "ESPsFeatures", ["Recursos de ESP"] = "ESPsFeatures", ["ESPs"] = "ESPsFeatures",
	["Settings Highlights"] = "SettingsHighlights", ["Configurações de Destaques"] = "SettingsHighlights", ["Config. Destaques"] = "SettingsHighlights",
	["Color Customization"] = "ColorCustomization", ["Personalização de Cor"] = "ColorCustomization", ["Cores"] = "ColorCustomization",
	["Outline Customization"] = "OutlineCustomization", ["Personalização do Contorno"] = "OutlineCustomization", ["Contorno"] = "OutlineCustomization",
	["Computer"] = "Computer", ["Capsule"] = "Capsule",
	["Exit"] = "Exit", ["Door"] = "Door",
	["Fill"] = "Fill", ["Preenchimento"] = "Fill", ["Preencher"] = "Fill",
	["Outline"] = "Outline",
	["Charms"] = "Charms", ["Square"] = "Square",
	["Trace Line"] = "TraceLine", ["Beast GlowUp"] = "BeastGlowUp",
	["Beast Fill Color"] = "BeastFillColor", ["Cor de Preencher da Fera"] = "BeastFillColor",
	["Survivor Fill Color"] = "SurvivorFillColor", ["Cor de Preencher do Sobrevivente"] = "SurvivorFillColor",
	["Computer Fill Color"] = "ComputerFillColor", ["Cor de Preencher do Computador"] = "ComputerFillColor",
	["Door Fill Color"] = "DoorFillColor", ["Cor de Preencher da Porta"] = "DoorFillColor",
	["Freezepod Fill Color"] = "FreezepodFillColor", ["Cor de Preencher do Freezepod"] = "FreezepodFillColor",
	["Beast Outline"] = "BeastOutline", ["Contorno da Fera"] = "BeastOutline",
	["Survivor Outline"] = "SurvivorOutline", ["Contorno do Sobrevivente"] = "SurvivorOutline",
	["Computer Outline"] = "ComputerOutline", ["Contorno do Computador"] = "ComputerOutline",
	["Freezepod Outline"] = "FreezepodOutline", ["Contorno do Freezepod"] = "FreezepodOutline",
	["Door Outline"] = "DoorOutline", ["Contorno da Porta"] = "DoorOutline",
	["Charms Survivor"] = "CharmsSurvivor", ["Amuletos do Sobrevivente"] = "CharmsSurvivor",
	["Charms Beast"] = "CharmsBeast", ["Amuletos da Fera"] = "CharmsBeast",
	["Reset All Outline"] = "ResetAllOutline", ["Reset All Fill"] = "ResetAllFill",
	["Survivor"] = "Survivor", ["Sobrevivente"] = "Survivor",
	["Beast"] = "Beast", ["Fera"] = "Beast",
	["Beast Untie Player"] = "BeastUntiePlayer",
	["Anti Ragdoll"] = "AntiRagdoll",
	["Slow Beast"] = "SlowBeast", ["Slow Beast Runner"] = "SlowBeastRunner",
	["Beast Ability"] = "BeastAbility", ["Beast Power Notify"] = "BeastPowerNotify",
	["Touch Fling"] = "TouchFling", ["Macro WallHop"] = "MacroWallHop",
	["Camera Mode"] = "CameraMode", ["Noclip"] = "Noclip",
	["Auto Hit Beast"] = "AutoHitBeast", ["Auto Hit Range"] = "AutoHitRange",
	["Auto Hit Delay"] = "AutoHitDelay", ["Crawl Beast"] = "CrawlBeast",
	["Auto Tie aura"] = "AutoTieAura", ["Auto Tie After Hit"] = "AutoTieAfterHit",
	["Transparency"] = "Transparency", ["Transparência"] = "Transparency",
	["Player Spoof"] = "PlayerSpoof", ["Falsificar Jogador"] = "PlayerSpoof",
	["Hide Username"] = "HideUsername", ["Ocultar Nome"] = "HideUsername",
	["Username"] = "Username", ["Nome de Usuário"] = "Username",
	["Level"] = "Level", ["Nível"] = "Level",
	["Icon"] = "Icon", ["Ícone"] = "Icon",
	["None"] = "None", ["Nenhum"] = "None",
	["Icon: Default"] = "IconDefault", ["Ícone: Padrão"] = "IconDefault",
	["Target Nick"] = "TargetNick", ["Apelido Alvo"] = "TargetNick",
	["Nick"] = "Nick", ["Apelido"] = "Nick",
	["Camera"] = "Camera", ["Câmera"] = "Camera",
	["Enable FOV"] = "EnableFOV", ["Ativar FOV"] = "EnableFOV",
	["Field Of View"] = "FieldOfView", ["Campo de Visão"] = "FieldOfView",
	["Stretch 0.65"] = "Stretch065", ["Alongar 0.65"] = "Stretch065",
	["Stretch 0.7"] = "Stretch07", ["Alongar 0.7"] = "Stretch07",
	["Sensitivity"] = "Sensitivity", ["Sensibilidade"] = "Sensitivity",
	["Sensitivity X"] = "SensitivityX", ["Sensibilidade X"] = "SensitivityX",
	["Sensitivity Y"] = "SensitivityY", ["Sensibilidade Y"] = "SensitivityY",
	["Reset X"] = "ResetX", ["Resetar X"] = "ResetX",
	["Reset Y"] = "ResetY", ["Resetar Y"] = "ResetY",
	["Action Timers"] = "ActionTimers", ["Temporizadores de Ação"] = "ActionTimers",
	["Computer Progress"] = "ComputerProgress", ["Progresso Computador"] = "ComputerProgress",
	["Exit Door Timer"] = "ExitDoorTimer", ["Timer Porta Saída"] = "ExitDoorTimer",
	["Door Timer"] = "DoorTimer", ["Timer Porta"] = "DoorTimer",
	["Life Timer"] = "LifeTimer", ["Timer de Vida"] = "LifeTimer",
	["Walkspeed"] = "Walkspeed", ["Velocidade"] = "Walkspeed",
	["Timer Colors"] = "TimerColors", ["Cores do Timer"] = "TimerColors",
	["Computer Color"] = "ComputerColor", ["Cor Computador"] = "ComputerColor",
	["Exit Door Color"] = "ExitDoorColor", ["Cor Porta Saída"] = "ExitDoorColor",
	["Door Timer Color"] = "DoorTimerColor", ["Cor Timer Porta"] = "DoorTimerColor",
	["Life Timer Color"] = "LifeTimerColor", ["Cor Timer Vida"] = "LifeTimerColor",
	["Walkspeed Color"] = "WalkspeedColor", ["Cor Velocidade"] = "WalkspeedColor",
	["Reset Timer Colors"] = "ResetTimerColors", ["Resetar Cores Timer"] = "ResetTimerColors",
	["Beast Indicators"] = "BeastIndicators", ["Indicadores da Fera"] = "BeastIndicators",
	["GetUp Timer"] = "GetUpTimer", ["Timer Levantar"] = "GetUpTimer",
	["Beast Power"] = "BeastPower", ["Poder da Fera"] = "BeastPower",
	["Beast Power V2"] = "BeastPowerV2", ["Poder da Fera V2"] = "BeastPowerV2",
	["Beast Spawn Timer"] = "BeastSpawnTimer", ["Timer Spawn Fera"] = "BeastSpawnTimer",
	["Indicators Colors"] = "IndicatorsColors", ["Cores Indicadores"] = "IndicatorsColors",
	["GetUp Color"] = "GetUpColor", ["Cor Levantar"] = "GetUpColor",
	["Beast Power Color"] = "BeastPowerColor", ["Cor Poder Fera"] = "BeastPowerColor",
	["Beast Power V2 Color"] = "BeastPowerV2Color", ["Cor Poder Fera V2"] = "BeastPowerV2Color",
	["Beast Spawn Color"] = "BeastSpawnColor", ["Cor Spawn Fera"] = "BeastSpawnColor",
	["Reset Indicators Colors"] = "ResetIndicatorsColors", ["Resetar Cores Indicadores"] = "ResetIndicatorsColors",
	["Map Textures"] = "MapTextures", ["Texturas do Mapa"] = "MapTextures",
	["White Bricks"] = "WhiteBricks", ["Tijolos Brancos"] = "WhiteBricks",
	["Snow Map"] = "SnowMap", ["Mapa de Neve"] = "SnowMap",
	["Remove Textures"] = "RemoveTextures", ["Remover Texturas"] = "RemoveTextures",
	["Minecraft Texture"] = "MinecraftTexture", ["Textura Minecraft"] = "MinecraftTexture",
	["Double Jump Effect"] = "DoubleJumpEffect", ["Efeito Pulo Duplo"] = "DoubleJumpEffect",
	["Enter Texture ID..."] = "EnterTextureID", ["Digite o ID da Textura..."] = "EnterTextureID",
	["Apply"] = "Apply", ["Aplicar"] = "Apply",
	["FPS Setting"] = "FPSSetting", ["Config. de FPS"] = "FPSSetting",
	["FPS Boost"] = "FPSBoost", ["Boost de FPS"] = "FPSBoost",
	["Gray Character"] = "GrayCharacter", ["Personagem Cinza"] = "GrayCharacter",
	["Crosshair"] = "Crosshair", ["Mira"] = "Crosshair",
	["Button Jump"] = "ButtonJump", ["Botão de Pulo"] = "ButtonJump",
	["Padrão"] = "Default",
	["Calibration"] = "Calibration", ["Calibração"] = "Calibration",
	["Enable Calibration"] = "EnableCalibration", ["Ativar Calibração"] = "EnableCalibration",
	["Brightness"] = "Brightness", ["Brilho"] = "Brightness",
	["Contrast"] = "Contrast", ["Contraste"] = "Contrast",
	["Saturation"] = "Saturation", ["Saturação"] = "Saturation",
	["Exposure"] = "Exposure", ["Exposição"] = "Exposure",
	["Temperature"] = "Temperature", ["Temperatura"] = "Temperature",
	["Blur"] = "Blur", ["Desfoque"] = "Blur",
	["Reset All"] = "ResetAll", ["Resetar Tudo"] = "ResetAll",
	["Shaders"] = "Shaders",
	["Enable Shaders"] = "EnableShaders", ["Ativar Shaders"] = "EnableShaders",
	["Preset"] = "Preset", ["Predefinição"] = "Preset",
	["Reset Shaders"] = "ResetShaders", ["Resetar Shaders"] = "ResetShaders",
	["Morning"] = "Morning", ["Manhã"] = "Morning",
	["Midday"] = "Midday", ["Meio-dia"] = "Midday",
	["Afternoon"] = "Afternoon", ["Tarde"] = "Afternoon",
	["Evening"] = "Evening", ["Entardecer"] = "Evening",
	["Night"] = "Night", ["Noite"] = "Night",
	["Midnight"] = "Midnight", ["Meia-noite"] = "Midnight",
	["Fog Settings"] = "FogSettings", ["Config. de Névoa"] = "FogSettings",
	["Black Fog"] = "BlackFog", ["Névoa Preta"] = "BlackFog",
	["Gray Fog"] = "GrayFog", ["Névoa Cinza"] = "GrayFog",
	["No Fog"] = "NoFog", ["Sem Névoa"] = "NoFog",
	["Enable Fog Mode"] = "EnableFogMode", ["Ativar Modo Névoa"] = "EnableFogMode",
	["Fog Color"] = "FogColor", ["Cor da Névoa"] = "FogColor",
	["Flashlight"] = "Flashlight", ["Lanterna"] = "Flashlight",
	["Flashlight Intensity"] = "FlashlightIntensity", ["Intensidade Lanterna"] = "FlashlightIntensity",
	["Character"] = "Character", ["Personagem"] = "Character",
	["Enable WalkSpeed"] = "EnableWalkSpeed", ["Ativar Velocidade"] = "EnableWalkSpeed",
	["Enable Fatigue"] = "EnableFatigue", ["Ativar Cansaço"] = "EnableFatigue",
	["Fatigue Delay"] = "FatigueDelay", ["Delay do Cansaço"] = "FatigueDelay",
	["Fatigue Duration"] = "FatigueDuration", ["Duração do Cansaço"] = "FatigueDuration",
	["Fatigue Speed"] = "FatigueSpeed", ["Velocidade Cansaço"] = "FatigueSpeed",
	["Enable High Jump"] = "EnableHighJump", ["Ativar Pulo Alto"] = "EnableHighJump",
	["Jump Power"] = "JumpPower", ["Força do Pulo"] = "JumpPower",
	["Enable Crawl"] = "EnableCrawl", ["Ativar Rastejar"] = "EnableCrawl",
	["Crawl Speed"] = "CrawlSpeed", ["Velocidade Rastejar"] = "CrawlSpeed",
	["Jump & Classic"] = "JumpClassic", ["Pulo & Clássico"] = "JumpClassic",
	["Enable Classic Thumbstick"] = "EnableClassicThumbstick", ["Ativar Thumbstick Clássico"] = "EnableClassicThumbstick",
	["Enable Classic Thumb..."] = "EnableClassicThumbstick",
	["Thumbstick X"] = "ThumbstickX", ["Thumbstick Y"] = "ThumbstickY",
	["Enable Jump Button"] = "EnableJumpButton", ["Ativar Botão Pulo"] = "EnableJumpButton",
	["Jump X"] = "JumpX", ["Pulo X"] = "JumpX",
	["Jump Y"] = "JumpY", ["Pulo Y"] = "JumpY",
	["Jump Scale"] = "JumpScale", ["Escala do Pulo"] = "JumpScale",
	["Auto Tie Range"] = "AutoTieRange", ["Alcance Auto Amarrar"] = "AutoTieRange",
	["Hit Aura"] = "HitAura", ["Aura de Hit"] = "HitAura",
	["Hit Aura Range"] = "HitAuraRange", ["Alcance Aura Hit"] = "HitAuraRange",
	["Enable Hitbox"] = "EnableHitbox", ["Ativar Hitbox"] = "EnableHitbox",
	["Hide Hitbox"] = "HideHitbox", ["Ocultar Hitbox"] = "HideHitbox",
	["Hitbox X"] = "HitboxX", ["Hitbox Y"] = "HitboxY", ["Hitbox Z"] = "HitboxZ",
	["Button E & Button C"] = "ButtonEButtonC", ["Botão E & Botão C"] = "ButtonEButtonC",
	["Enable E Button"] = "EnableEButton", ["Ativar Botão E"] = "EnableEButton",
	["E X"] = "EX", ["E Y"] = "EY", ["E Size"] = "ESize",
	["Tamanho E"] = "ESize",
	["Enable C Button"] = "EnableCButton", ["Ativar Botão C"] = "EnableCButton",
	["C X"] = "CX", ["C Y"] = "CY", ["C Size"] = "CSize",
	["Tamanho C"] = "CSize",
	["Volume"] = "Volume",
	["FootSteps"] = "FootSteps", ["Passos"] = "FootSteps",
	["Jump"] = "Jump", ["Pulo"] = "Jump",
	["Fall"] = "Fall", ["Queda"] = "Fall",
	["Reset Volumes"] = "ResetVolumes", ["Resetar Volumes"] = "ResetVolumes",
	["Reset Sounds"] = "ResetSounds", ["Resetar Sons"] = "ResetSounds",
	["Mute System"] = "MuteSystem", ["Silenciar Sistema"] = "MuteSystem",
	["Mute Your Footsteps"] = "MuteYourFootsteps", ["Silenciar Seus Passos"] = "MuteYourFootsteps",
	["Mute Your Jump"] = "MuteYourJump", ["Silenciar Seu Pulo"] = "MuteYourJump",
	["Mute Your Fall"] = "MuteYourFall", ["Silenciar Sua Queda"] = "MuteYourFall",
	["Mute Hit Sound"] = "MuteHitSound", ["Silenciar Som de Hit"] = "MuteHitSound",
	["Step Distance"] = "StepDistance", ["Distância de Passos"] = "StepDistance",
	["Min Distance"] = "MinDistance", ["Min Distância"] = "MinDistance",
	["Max Distance"] = "MaxDistance", ["Max Distância"] = "MaxDistance",
	["RollOff"] = "RollOff",
	["Reset Distance"] = "ResetDistance", ["Reset Distância"] = "ResetDistance",
	["Music Player"] = "MusicPlayer", ["Tocador de Música"] = "MusicPlayer",
	["Music Volume"] = "MusicVolume", ["Volume da Música"] = "MusicVolume",
	["Select"] = "Select", ["Selecionar"] = "Select",
	["Play"] = "Play", ["Tocar"] = "Play",
	["Skin Changer"] = "SkinChanger", ["Trocador de Skin"] = "SkinChanger",
	["Username..."] = "UsernamePlaceholder", ["Nome de usuário..."] = "UsernamePlaceholder",
	["Map Objects"] = "MapObjects", ["Objetos do Mapa"] = "MapObjects",
	["TP Computer"] = "TPComputer", ["TP Computador"] = "TPComputer",
	["TP Exitdoor"] = "TPExitdoor", ["TP Porta Saída"] = "TPExitdoor",
	["TP Freezepods"] = "TPFreezepods",
	["TP Crystal Cove"] = "TPCrystalCove",
	["TP Beast Cave"] = "TPBeastCave", ["TP Caverna da Fera"] = "TPBeastCave",
	["TP Map"] = "TPMap", ["TP Mapa"] = "TPMap",
	["Extras"] = "Extras",
	["Teleport to Beast"] = "TeleportToBeast", ["Teleportar p/ Fera"] = "TeleportToBeast",
	["Reset Character"] = "ResetCharacter", ["Resetar Personagem"] = "ResetCharacter",
	["Server Rejoin"] = "ServerRejoin", ["Reentrar no Servidor"] = "ServerRejoin",
	["Random Servers"] = "RandomServers", ["Servidores Aleatórios"] = "RandomServers",
	["Players Teleport"] = "PlayersTeleport", ["Teleporte de Jogadores"] = "PlayersTeleport",
	["Atualizar"] = "Update",
	["Appearance"] = "Appearance", ["Aparência"] = "Appearance",
	["UI Background: Style 3"] = "UIBackground", ["Fundo da UI: Estilo 3"] = "UIBackground",
	["UI Background"] = "UIBackground", ["Fundo da UI"] = "UIBackground",
	["Custom Background ID"] = "CustomBackgroundID", ["ID de Fundo Personalizado"] = "CustomBackgroundID",
	["UI Font: Arial"] = "UIFont", ["Fonte da UI: Arial"] = "UIFont",
	["UI Font"] = "UIFont", ["Fonte da UI"] = "UIFont",
	["Shine Color"] = "ShineColor", ["Cor do Brilho"] = "ShineColor",
	["Touch Screen Interface"] = "TouchScreenInterface", ["Interface Tela Touch"] = "TouchScreenInterface",
	["Show FPS"] = "ShowFPS", ["Mostrar FPS"] = "ShowFPS",
	["Configuration"] = "Configuration", ["Configuração"] = "Configuration",
	["Show Ping"] = "ShowPing", ["Mostrar Ping"] = "ShowPing",
	["Show CPU"] = "ShowCPU", ["Mostrar CPU"] = "ShowCPU",
	["TextBox"] = "TextBoxLabel", ["Caixa de Texto"] = "TextBoxLabel",
	["FTF Eclipse V2.9 Mobile | Thank you for using FTF Eclipse."] = "ThanksFooter",
	["FTF Eclipse V2.9 Mobile | Obrigado por usar FTF Eclipse."] = "ThanksFooter",
}

local Translatable = {}
local TranslatableElements = {}
local AllSearchable = {}

local function AddTranslatable(el, key)
	if el and key then TranslatableElements[el] = key end
end
local function AddToSearch(el, name)
	if el and name then AllSearchable[el] = name:lower() end
end

local function T(key)
	return Translation[currentLanguage][key] or key
end
_G.T = T

local PlayerNames = {}
for _, p in ipairs(Players:GetPlayers()) do
	PlayerNames[p.Name] = true
	PlayerNames[p.DisplayName] = true
end
Players.PlayerAdded:Connect(function(p)
	PlayerNames[p.Name] = true
	PlayerNames[p.DisplayName] = true
end)

local function DeveIgnorar(el, text)
	if not el or not text or text == "" then return true end
	if text == "Exit Eclipse" or text == "Sair do Eclipse" then return true end
	if text:find("Are you sure you want to close") then return true end
	if text:find("Tem certeza que quer fechar") then return true end
	if text == "Cancel" or text == "Cancelar" then return true end
	if text == "Yes, Exit" or text == "Sim, Sair" then return true end
	if text == "Close" or text == "Fechar" then return true end
	if text == "INFO" or text == "INFORMAÇÕES" then return true end
	if text == "Thank you for using Eclipse." or text == "Obrigado por usar Eclipse." then return true end
	if text:sub(1, 1) == "@" then return true end
	if PlayerNames[text] then return true end
	if text:find("^FPS:") or text:find("^Ping:") then return true end
	if text:find("^Players:") or text:find("^Max Players:") then return true end
	if text:find("^Executor:") or text:find("^Region:") or text:find("^Região:") then return true end
	return false
end

local function IsInExitOrInfo(el)
	local cur = el
	while cur do
		if cur:GetAttribute("NoTranslate") then return true end
		local n = cur.Name:lower()
		if n:find("exit") or n:find("info") then
			if n:find("exitpopup") or n:find("exitframe") or n:find("infoframe") or n:find("infopanel") or n == "info" or n == "exit" then
				return true
			end
		end
		cur = cur.Parent
		if not cur or cur:IsA("PlayerGui") then break end
	end
	return false
end

local function TryTranslate(el)
	if not el or not el.Parent then return end
	if IsInExitOrInfo(el) then return end
	if el:GetAttribute("NoTranslate") then return end
	if el:IsA("TextBox") then
		local ph = el.PlaceholderText
		if ph and ph ~= "" and not DeveIgnorar(el, ph) then
			local k = TextToKey[ph]
			if k then
				Translatable[el] = k
				el.PlaceholderText = Translation[currentLanguage][k]
			end
		end
		return
	end
	local clean = el.Text:gsub("^%s+", ""):gsub("%s+$", "")
	if DeveIgnorar(el, clean) then return end
	if Translatable[el] then
		local suffix = el:GetAttribute("TransSuffix")
		if suffix then
			el.Text = Translation[currentLanguage][Translatable[el]] .. ": " .. suffix
		else
			el.Text = Translation[currentLanguage][Translatable[el]]
		end
		return
	end
	local prefix, rest = clean:match("^(.-):%s*(.+)$")
	if prefix and TextToKey[prefix] then
		if TextToKey[clean] then
			local k2 = TextToKey[clean]
			Translatable[el] = k2
			el:SetAttribute("TransSuffix", nil)
			el.Text = Translation[currentLanguage][k2]
			return
		end
		if DeveIgnorar(el, rest) then return end
		local key = TextToKey[prefix]
		Translatable[el] = key
		el:SetAttribute("TransSuffix", rest)
		el.Text = Translation[currentLanguage][key] .. ": " .. rest
		return
	end
	local key = TextToKey[clean]
	if key then
		Translatable[el] = key
		el.Text = Translation[currentLanguage][key]
	end
end

local function TranslateAllOnce(gui)
	if not gui then return end
	for _, el in ipairs(gui:GetDescendants()) do
		if el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox") then
			TryTranslate(el)
		end
	end
end

local function UpdateLanguage()
	for el, key in pairs(Translatable) do
		if el and el.Parent then
			if el:IsA("TextBox") then
				el.PlaceholderText = Translation[currentLanguage][key] or el.PlaceholderText
			else
				local suffix = el:GetAttribute("TransSuffix")
				if suffix then
					el.Text = Translation[currentLanguage][key] .. ": " .. suffix
				else
					el.Text = Translation[currentLanguage][key] or key
				end
			end
		end
	end
	for el, key in pairs(TranslatableElements) do
		if el and el.Parent then
			el.Text = Translation[currentLanguage][key] or key
		end
	end
	if langBtn and langBtn.Parent then langBtn.Text = currentLanguage end
	if searchInput and searchInput.Parent then
		searchInput.PlaceholderText = Translation[currentLanguage].Search
	end
end
_G.UpdateLanguage = UpdateLanguage

if langBtn and not langBtn:GetAttribute("IsLangBtn") then
	langBtn:SetAttribute("IsLangBtn", true)
	langBtn.MouseButton1Click:Connect(function()
		currentLanguage = (currentLanguage == "EN") and "PT" or "EN"
		UpdateLanguage()
	end)
end

task.spawn(function()
	local gui2 = PlayerGui:WaitForChild("EclipseUI", 15)
	if not gui2 then return end
	task.wait(0.2)
	TranslateAllOnce(gui2)
	UpdateLanguage()
	gui2.DescendantAdded:Connect(function(el)
		if el:IsA("TextLabel") or el:IsA("TextButton") or el:IsA("TextBox") then
			task.wait(0.05)
			TryTranslate(el)
		end
	end)
end)

local function FilterSearch(text)
	text = text:lower()
	if text == "" then
		for element, _ in pairs(AllSearchable) do
			if element and element.Parent then element.Visible = true end
		end
		return
	end
	for element, name in pairs(AllSearchable) do
		if element and element.Parent then
			element.Visible = string.find(name, text, 1, true) ~= nil
		end
	end
end

searchInput:GetPropertyChangedSignal("Text"):Connect(function()
	FilterSearch(searchInput.Text)
end)

local function CreateGroupbox(parent, titleKey)
	local groupbox = Instance.new("Frame")
	groupbox.Size = UDim2.new(1, 0, 0, 0)
	groupbox.AutomaticSize = Enum.AutomaticSize.Y
	groupbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	groupbox.BackgroundTransparency = 0.7
	groupbox.Parent = parent
	Instance.new("UICorner", groupbox).CornerRadius = UDim.new(0, 8)
	local groupboxStroke = Instance.new("UIStroke", groupbox)
	groupboxStroke.Color = Color3.fromRGB(80, 80, 80)
	groupboxStroke.Thickness = 1
	groupboxStroke.Transparency = 0.4
	local header = Instance.new("Frame", groupbox)
	header.Size = UDim2.new(1, 0, 0, 35)
	header.BackgroundTransparency = 1
	local titleLabel = Instance.new("TextLabel", header)
	titleLabel.Size = UDim2.new(1, -30, 1, 0)
	titleLabel.Position = UDim2.new(0, 22, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = Translation[currentLanguage][titleKey] or titleKey
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	AddTranslatable(titleLabel, titleKey)
	local divider = Instance.new("Frame", groupbox)
	divider.Size = UDim2.new(1, -24, 0, 1)
	divider.Position = UDim2.new(0, 12, 0, 35)
	divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	divider.BackgroundTransparency = 0.3
	divider.BorderSizePixel = 0
	local contentFrame = Instance.new("Frame", groupbox)
	contentFrame.Size = UDim2.new(1, -24, 0, 0)
	contentFrame.Position = UDim2.new(0, 12, 0, 45)
	contentFrame.BackgroundTransparency = 1
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y
	Instance.new("UIListLayout", contentFrame).Padding = UDim.new(0, 8)
	Instance.new("UIPadding", contentFrame).PaddingBottom = UDim.new(0, 12)
	AddToSearch(groupbox, titleKey:lower())
	return groupbox, contentFrame
end

do
	Players = game:GetService("Players")
	RunService = game:GetService("RunService")
	TweenService = game:GetService("TweenService")
	Stats = game:GetService("Stats")
	getgenv().EclipseInfo = getgenv().EclipseInfo or {}
	E = getgenv().EclipseInfo
	if E.frame then E.frame:Destroy() end
	if E.conns then
		for _, v in pairs(E.conns) do
			if typeof(v) == "RBXScriptConnection" then v:Disconnect()
			elseif typeof(v) == "thread" then task.cancel(v) end
		end
	end
	E.frame = Instance.new("Frame")
	E.frame.Name = "InfoFrame"
	E.frame.Size = UDim2.new(0, 300, 0, 340)
	E.frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	E.frame.AnchorPoint = Vector2.new(0.5, 0.5)
	E.frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	E.frame.BackgroundTransparency = 1
	E.frame.Visible = false
	E.frame.ZIndex = 15
	E.frame.Parent = frame
	Instance.new("UICorner", E.frame).CornerRadius = UDim.new(0, 8)
	E.stroke = Instance.new("UIStroke", E.frame)
	E.stroke.Color = Color3.fromRGB(50, 50, 50)
	E.stroke.Thickness = 1
	E.stroke.Transparency = 1
	E.title = Instance.new("TextLabel", E.frame)
	E.title.Size = UDim2.new(1, 0, 0, 35)
	E.title.BackgroundTransparency = 1
	E.title.Text = "INFO"
	E.title.Font = Enum.Font.GothamBold
	E.title.TextSize = 14
	E.title.TextColor3 = Color3.fromRGB(255, 255, 255)
	E.title.TextTransparency = 1
	AddTranslatable(E.title, "Info")
	E.scroll = Instance.new("ScrollingFrame", E.frame)
	E.scroll.Size = UDim2.new(1, -20, 1, -95)
	E.scroll.Position = UDim2.new(0, 10, 0, 40)
	E.scroll.BackgroundTransparency = 1
	E.scroll.ScrollBarThickness = 4
	E.scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	E.scroll.ScrollBarImageTransparency = 1
	Instance.new("UIListLayout", E.scroll).Padding = UDim.new(0, 8)
	function MakeLabel(p, t, b, key)
		local l = Instance.new("TextLabel", p)
		l.Size = UDim2.new(1, 0, 0, 18)
		l.BackgroundTransparency = 1
		l.Text = t
		l.Font = b and Enum.Font.GothamBold or Enum.Font.Gotham
		l.TextSize = 12
		l.TextColor3 = Color3.fromRGB(180, 180, 180)
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextTransparency = 1
		if key then AddTranslatable(l, key) end
		return l
	end
	local g = {}
	g.cb, g.cc = CreateGroupbox(E.scroll, "Credits")
	g.tb, g.tc = CreateGroupbox(E.scroll, "Testers")
	g.pb, g.pc = CreateGroupbox(E.scroll, "PlayerInfo")
	g.sb, g.sc = CreateGroupbox(E.scroll, "ServerInfo")
	MakeLabel(g.cc, "Eclipse the Creator", true)
	MakeLabel(g.cc, "Owner: @kayquet", false)
	MakeLabel(g.cc, "Co-owner: @gustavo_bawnana & @x67j", false)
	MakeLabel(g.cc, "Administrator: @skztv157", false)
	MakeLabel(g.tc, "Testers: Luan, Vitor & Mz", false)
	E.fps = MakeLabel(g.pc, "FPS: 60", true)
	E.ping = MakeLabel(g.pc, "Ping: 0 ms", true)
	MakeLabel(g.pc, "Executor: " .. (identifyexecutor and identifyexecutor() or "Unknown"), true)
	MakeLabel(g.sc, "Region: BR", true, "Region")
	MakeLabel(g.sc, "Players: " .. #Players:GetPlayers(), true)
	MakeLabel(g.sc, "Max Players: " .. Players.MaxPlayers, true)
	E.thanks = Instance.new("TextLabel", E.frame)
	E.thanks.Size = UDim2.new(1, -40, 0, 40)
	E.thanks.Position = UDim2.new(0, 20, 1, -75)
	E.thanks.BackgroundTransparency = 1
	E.thanks.Text = "Thank you for using Eclipse."
	E.thanks.Font = Enum.Font.Gotham
	E.thanks.TextSize = 11
	E.thanks.TextColor3 = Color3.fromRGB(150, 150, 150)
	E.thanks.TextTransparency = 1
	E.thanks.TextWrapped = true
	AddTranslatable(E.thanks, "Thank you for using Eclipse")
	E.closeBtn = Instance.new("TextButton", E.frame)
	E.closeBtn.Size = UDim2.new(0, 100, 0, 30)
	E.closeBtn.Position = UDim2.new(0.5, -50, 1, -40)
	E.closeBtn.Text = "Close"
	E.closeBtn.Font = Enum.Font.GothamBold
	E.closeBtn.TextSize = 13
	E.closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	E.closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	E.closeBtn.BackgroundTransparency = 1
	E.closeBtn.TextTransparency = 1
	E.closeBtn.AutoButtonColor = false
	Instance.new("UICorner", E.closeBtn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", E.closeBtn)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	AddTranslatable(E.closeBtn, "Close")
	E.conns = {}
	function E.Start()
		if E.conns.hb then return end
		E.lastTime = tick()
		E.conns.hb = RunService.Heartbeat:Connect(function()
			local now = tick()
			local dt = now - E.lastTime
			E.lastTime = now
			if dt > 0 and E.frame.Visible then
				E.fps.Text = "FPS: " .. math.floor(1 / dt)
			end
		end)
		if not E.conns.ping then
			E.conns.ping = task.spawn(function()
				while E.frame and E.frame.Visible do
					pcall(function()
						local v = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
						E.ping.Text = "Ping: " .. math.floor(v) .. " ms"
					end)
					task.wait(0.5)
				end
				E.conns.ping = nil
			end)
		end
	end
	function E.Stop()
		if E.conns.hb then E.conns.hb:Disconnect() E.conns.hb = nil end
		if E.conns.ping then task.cancel(E.conns.ping) E.conns.ping = nil end
	end
	function E.Open()
		E.Stop()
		E.frame.Visible = true
		E.Start()
		local t = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(E.frame, t, {BackgroundTransparency = 0.1}):Play()
		TweenService:Create(E.stroke, t, {Transparency = 0.2}):Play()
		TweenService:Create(E.title, t, {TextTransparency = 0}):Play()
		TweenService:Create(E.scroll, t, {ScrollBarImageTransparency = 0}):Play()
		TweenService:Create(E.closeBtn, t, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
		TweenService:Create(E.thanks, t, {TextTransparency = 0}):Play()
		for _, o in pairs(E.scroll:GetDescendants()) do
			if o:IsA("TextLabel") then
				TweenService:Create(o, t, {TextTransparency = 0}):Play()
			end
		end
	end
	function E.Close()
		E.Stop()
		local t = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		TweenService:Create(E.frame, t, {BackgroundTransparency = 1}):Play()
		TweenService:Create(E.stroke, t, {Transparency = 1}):Play()
		TweenService:Create(E.title, t, {TextTransparency = 1}):Play()
		TweenService:Create(E.scroll, t, {ScrollBarImageTransparency = 1}):Play()
		TweenService:Create(E.closeBtn, t, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		TweenService:Create(E.thanks, t, {TextTransparency = 1}):Play()
		for _, o in pairs(E.scroll:GetDescendants()) do
			if o:IsA("TextLabel") then
				TweenService:Create(o, t, {TextTransparency = 1}):Play()
			end
		end
		task.wait(0.25)
		E.frame.Visible = false
	end
	infoBtn.MouseButton1Click:Connect(E.Open)
	E.closeBtn.MouseButton1Click:Connect(E.Close)
	E.closeBtn.MouseEnter:Connect(function()
		TweenService:Create(E.closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
	end)
	E.closeBtn.MouseLeave:Connect(function()
		TweenService:Create(E.closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
	end)
end

do
	TweenService = game:GetService("TweenService")
	getgenv().EclipseExit = getgenv().EclipseExit or {}
	local C = getgenv().EclipseExit
	if C.frame then C.frame:Destroy() end

	local function GetExitTexts()
		if currentLanguage == "PT" then
			return "Sair do Eclipse", "Tem certeza que quer fechar o script? Você vai\nprecisar executar de novo para abrir novamente.", "Cancelar", "Sim, Sair"
		else
			return "Exit Eclipse", "Are you sure you want to close the script? You will\nneed to re-execute to open it again.", "Cancel", "Yes, Exit"
		end
	end

	C.frame = Instance.new("Frame")
	C.frame.Name = "ExitFrame"
	C.frame:SetAttribute("NoTranslate", true)
	C.frame.Size = UDim2.new(0, 340, 0, 170)
	C.frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	C.frame.AnchorPoint = Vector2.new(0.5, 0.5)
	C.frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	C.frame.BackgroundTransparency = 0
	C.frame.Visible = false
	C.frame.ZIndex = 10
	C.frame.Parent = gui
	Instance.new("UICorner", C.frame).CornerRadius = UDim.new(0, 8)
	C.stroke = Instance.new("UIStroke", C.frame)
	C.stroke.Color = Color3.fromRGB(0, 0, 0)
	C.stroke.Thickness = 0
	C.stroke.Transparency = 1
	C.redLine = Instance.new("Frame", C.frame)
	C.redLine.Size = UDim2.new(1, 0, 0, 2)
	C.redLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	C.redLine.BackgroundTransparency = 0
	C.redLine.BorderSizePixel = 0
	C.redLine.ZIndex = 11
	Instance.new("UICorner", C.redLine).CornerRadius = UDim.new(0, 8)

	local t1, t2, t3, t4 = GetExitTexts()

	C.title = Instance.new("TextLabel", C.frame)
	C.title.Size = UDim2.new(1, 0, 0, 50)
	C.title.Position = UDim2.new(0, 0, 0, 10)
	C.title.BackgroundTransparency = 1
	C.title.Text = t1
	C.title.Font = Enum.Font.GothamBold
	C.title.TextSize = 18
	C.title.TextColor3 = Color3.fromRGB(255, 255, 255)
	C.title.TextTransparency = 1
	C.title.ZIndex = 11

	C.text = Instance.new("TextLabel", C.frame)
	C.text.Size = UDim2.new(1, -40, 0, 50)
	C.text.Position = UDim2.new(0, 20, 0, 50)
	C.text.BackgroundTransparency = 1
	C.text.Text = t2
	C.text.TextWrapped = true
	C.text.Font = Enum.Font.Gotham
	C.text.TextSize = 13
	C.text.TextColor3 = Color3.fromRGB(180, 180, 180)
	C.text.TextTransparency = 1
	C.text.ZIndex = 11

	C.cancelBtn = Instance.new("TextButton", C.frame)
	C.cancelBtn.Size = UDim2.new(0, 120, 0, 35)
	C.cancelBtn.Position = UDim2.new(0, 35, 1, -50)
	C.cancelBtn.Text = t3
	C.cancelBtn.Font = Enum.Font.GothamBold
	C.cancelBtn.TextSize = 14
	C.cancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	C.cancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	C.cancelBtn.BackgroundTransparency = 1
	C.cancelBtn.TextTransparency = 1
	C.cancelBtn.ZIndex = 11
	Instance.new("UICorner", C.cancelBtn).CornerRadius = UDim.new(0, 6)

	C.exitBtn = Instance.new("TextButton", C.frame)
	C.exitBtn.Size = UDim2.new(0, 120, 0, 35)
	C.exitBtn.Position = UDim2.new(1, -155, 1, -50)
	C.exitBtn.Text = t4
	C.exitBtn.Font = Enum.Font.GothamBold
	C.exitBtn.TextSize = 14
	C.exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	C.exitBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
	C.exitBtn.BackgroundTransparency = 1
	C.exitBtn.TextTransparency = 1
	C.exitBtn.ZIndex = 11
	Instance.new("UICorner", C.exitBtn).CornerRadius = UDim.new(0, 6)

	local exitGradient = Instance.new("UIGradient", C.exitBtn)
	exitGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 30))
	}
	exitGradient.Rotation = 90

	function C.Open()
		local a, b, c, d = GetExitTexts()
		C.title.Text = a
		C.text.Text = b
		C.cancelBtn.Text = c
		C.exitBtn.Text = d
		C.frame.Visible = true
		C.frame.Size = UDim2.new(0, 280, 0, 130)
		local t = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		TweenService:Create(C.frame, t, {Size = UDim2.new(0, 340, 0, 170), BackgroundTransparency = 0.1}):Play()
		TweenService:Create(C.stroke, t, {Transparency = 0.2}):Play()
		TweenService:Create(C.redLine, t, {BackgroundTransparency = 0}):Play()
		TweenService:Create(C.title, t, {TextTransparency = 0}):Play()
		TweenService:Create(C.text, t, {TextTransparency = 0}):Play()
		TweenService:Create(C.cancelBtn, t, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
		TweenService:Create(C.exitBtn, t, {BackgroundTransparency = 0, TextTransparency = 0}):Play()
	end
	function C.Close()
		local t = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		TweenService:Create(C.frame, t, {Size = UDim2.new(0, 280, 0, 130), BackgroundTransparency = 1}):Play()
		TweenService:Create(C.stroke, t, {Transparency = 1}):Play()
		TweenService:Create(C.redLine, t, {BackgroundTransparency = 1}):Play()
		TweenService:Create(C.title, t, {TextTransparency = 1}):Play()
		TweenService:Create(C.text, t, {TextTransparency = 1}):Play()
		TweenService:Create(C.cancelBtn, t, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		TweenService:Create(C.exitBtn, t, {BackgroundTransparency = 1, TextTransparency = 1}):Play()
		task.wait(0.25)
		C.frame.Visible = false
	end
	closeBtn.MouseButton1Click:Connect(C.Open)
	C.cancelBtn.MouseButton1Click:Connect(C.Close)
	C.exitBtn.MouseButton1Click:Connect(function()
		C.Close()
		if getgenv().EclipseInfo and getgenv().EclipseInfo.Stop then
			getgenv().EclipseInfo.Stop()
		end
		task.wait(0.25)
		if blur then blur:Destroy() end
		if gui then gui:Destroy() end
	end)
	C.cancelBtn.MouseEnter:Connect(function()
		TweenService:Create(C.cancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
	end)
	C.cancelBtn.MouseLeave:Connect(function()
		TweenService:Create(C.cancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
	end)
	C.exitBtn.MouseEnter:Connect(function()
		TweenService:Create(C.exitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
	end)
	C.exitBtn.MouseLeave:Connect(function()
		TweenService:Create(C.exitBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 40, 40)}):Play()
	end)
end

do
	UserInputService = game:GetService("UserInputService")
	local isPC = UserInputService.KeyboardEnabled
	if isPC and openButton then openButton.Visible = false end
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp or not isPC then return end
		if input.KeyCode == Enum.KeyCode.K then
			frame.Visible = not frame.Visible
			if blur then blur.Size = 0 end
			if isPC and openButton then openButton.Visible = false end
		end
	end)
	miniBtn.MouseButton1Click:Connect(function()
		frame.Visible = false
		if not isPC and openButton then openButton.Visible = true end
		if blur then blur.Size = 0 end
	end)
	openButton.MouseButton1Click:Connect(function()
		if not isPC then
			frame.Visible = true
			openButton.Visible = false
			if blur then blur.Size = 0 end
		end
	end)
end

UpdateLanguage()
