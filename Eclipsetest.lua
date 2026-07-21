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
blur.Size = 20
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
bg.Image = "rbxassetid://75089517810614"
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
title.Text = "Eclipse V2.6"
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
    Notify("FTF Eclipse V2.6", "Welcome, " .. game.Players.LocalPlayer.Name .. ".", 4)
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
versionText.Text = "FTF Eclipse V2.6 ".. deviceType.. " ┃ Thank you for using FTF Eclipse."
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
	{Name = "Fog", Icon = "rbxassetid://73340401563662"},
	{Name = "Auto Farm", Icon = "rbxassetid://12684119225"},
	{Name = "Advanced", Icon = "rbxassetid://7485051715"},
	{Name = "Sounds", Icon = "rbxassetid://13288142767"},
	{Name = "Music", Icon = "rbxassetid://133565608904662"},
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

task.spawn(function()
	while true do
		for name, data in pairs(tabShines) do
			data.gradient.Offset = Vector2.new(-1.5, 0)
			TweenService:Create(data.gradient, TweenInfo.new(3, Enum.EasingStyle.Linear), {
				Offset = Vector2.new(1.5, 0)
			}):Play()
		end
		task.wait(3)
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

    local estilos = {
    Player = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 255, 0), OutlineColor = Color3.fromRGB(127, 255, 127)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 255, 0), OutlineColor = Color3.fromRGB(0, 255, 0)}
    },
    Beast = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 0, 0), OutlineColor = Color3.fromRGB(255, 127, 127)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 0, 0), OutlineColor = Color3.fromRGB(255, 0, 0)}
    },
    ComputerBlue = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(13, 105, 172), OutlineColor = Color3.fromRGB(20, 165, 255)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 90, 255), OutlineColor = Color3.fromRGB(0, 90, 255)}
    },
    ComputerRed = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(196, 40, 28), OutlineColor = Color3.fromRGB(255, 63, 44)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(215, 0, 0), OutlineColor = Color3.fromRGB(215, 0, 0)}
    },
    ComputerGreen = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(40, 127, 71), OutlineColor = Color3.fromRGB(63, 199, 111)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 215, 0), OutlineColor = Color3.fromRGB(0, 215, 0)}
    },
    Capsule = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(120, 200, 255), OutlineColor = Color3.fromRGB(160, 255, 255)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(95, 205, 255), OutlineColor = Color3.fromRGB(95, 205, 255)}
    },
    Exit = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(252, 255, 100), OutlineColor = Color3.fromRGB(255, 255, 160)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 255, 0), OutlineColor = Color3.fromRGB(255, 255, 0)}
    },
    DoorOpen = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 255, 0), OutlineColor = Color3.fromRGB(0, 0, 0)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(0, 255, 0), OutlineColor = Color3.fromRGB(0, 255, 0)}
    },
    DoorClose = {
        Fill = {FillTransparency = 0.5, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 0, 0), OutlineColor = Color3.fromRGB(0, 0, 0)},
        Outline = {FillTransparency = 1, OutlineTransparency = 0, FillColor = Color3.fromRGB(255, 0, 0), OutlineColor = Color3.fromRGB(255, 0, 0)}
    }
}

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

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -15, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -12, 0, 0)
    rightColH.Position = UDim2.new(0.5, 1, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local box1H, content1H = CreateGroupbox(leftColH, "Objects Features")
    
    local computerHighlight = false
    local computerCache = {}

    CreateToggle(content1H, "Computer", false, function(state)
        computerHighlight = state
        if state and game.ReplicatedStorage:FindFirstChild("CurrentMap") and game.ReplicatedStorage.CurrentMap.Value then
            local map = game.ReplicatedStorage.CurrentMap.Value
            computerCache = {}
            local descendants = map:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj.Name == "ComputerTable" then
                    computerCache[#computerCache + 1] = obj
                end
            end
            task.spawn(function()
                while computerHighlight do
                    task.wait(1)
                    for i = 1, #computerCache do
                        local computer = computerCache[i]
                        if computer and computer:FindFirstChild("Screen") then
                            local c = computer.Screen.Color
                            local r, g, b = c.R, c.G, c.B
                            if r >= g and r >= b then
                                aplicarHighlight(computer, "ComputerRed")
                            elseif g >= r and g >= b then
                                aplicarHighlight(computer, "ComputerGreen")
                            else
                                aplicarHighlight(computer, "ComputerBlue")
                            end
                        end
                    end
                end
                for i = 1, #computerCache do
                    local computer = computerCache[i]
                    if computer and computer:FindFirstChild("Highlight") then computer.Highlight:Destroy() end
                end
            end)
        else
            for i = 1, #computerCache do
                local computer = computerCache[i]
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
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj.Name == "FreezePod" then
                    capsuleCache[#capsuleCache + 1] = obj
                end
            end
            task.spawn(function()
                while capsuleHighlight do
                    task.wait(1)
                    for i = 1, #capsuleCache do
                        local capsule = capsuleCache[i]
                        if capsule then aplicarHighlight(capsule, "Capsule") end
                    end
                end
                for i = 1, #capsuleCache do
                    local capsule = capsuleCache[i]
                    if capsule and capsule:FindFirstChild("Highlight") then capsule.Highlight:Destroy() end
                end
                capsuleCache = {}
            end)
        else
            for i = 1, #capsuleCache do
                local capsule = capsuleCache[i]
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
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local obj = descendants[i]
                if obj.Name == "ExitDoor" then
                    exitCache[#exitCache + 1] = obj
                end
            end
            task.spawn(function()
                while exitHighlight do
                    task.wait(1)
                    for i = 1, #exitCache do
                        local exit = exitCache[i]
                        if exit then aplicarHighlight(exit, "Exit") end
                    end
                end
                for i = 1, #exitCache do
                    local exit = exitCache[i]
                    if exit and exit:FindFirstChild("Highlight") then exit.Highlight:Destroy() end
                end
                exitCache = {}
            end)
        else
            for i = 1, #exitCache do
                local exit = exitCache[i]
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
        local descendants = workspace:GetDescendants()
        for i = 1, #descendants do
            local door = descendants[i]
            if door.Name == "SingleDoor" or door.Name == "DoubleDoor" then
                doorCache[#doorCache + 1] = door
            end
        end
        task.spawn(function()
            while doorHighlight do
                task.wait(0.5)
                for i = 1, #doorCache do
                    local door = doorCache[i]
                    if door and door.Parent then
                        if door:FindFirstChild("DoorTrigger") then
                            local action = door.DoorTrigger:FindFirstChild("ActionSign")
                            if action then
                                if action.Value == 11 then
                                    aplicarHighlight(door, "DoorOpen")
                                elseif action.Value == 10 then
                                    aplicarHighlight(door, "DoorClose")
                                end
                            end
                        end
                    end
                end
            end
            for i = 1, #doorCache do
                local door = doorCache[i]
                local highlight = door and door:FindFirstChildOfClass("Highlight")
                if highlight then highlight:Destroy() end
            end
            doorCache = {}
        end)
    else
        for i = 1, #doorCache do
            local door = doorCache[i]
            local highlight = door and door:FindFirstChildOfClass("Highlight")
            if highlight then highlight:Destroy() end
        end
        doorCache = {}
    end
end)

    local box3H, content3H = CreateGroupbox(leftColH, "Settings Highlights")

    local chipHolder = Instance.new("Frame", content3H)
    chipHolder.Size = UDim2.new(1, 0, 0, 40)
    chipHolder.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", chipHolder)
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 8)

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
            for _, chip in pairs(chips) do
                chip.setSelected(chip.name == HighlightMode)
            end
        end)

        chips[text] = {name = text, setSelected = setSelected}
        setSelected(text == HighlightMode)
    end

    CreateChip("Fill")
    CreateChip("Outline")

    local espGroup, espContent = CreateGroupbox(rightColH, "ESPs Features")
    
local playerHighlight = false
local playerHighlightCache = {}
local playerHighlightConnections = {}
local playerNameCache = {}

CreateToggle(espContent, "Highlights", false, function(state)
    playerHighlight = state
    if state then
        playerHighlightCache = {}
        playerHighlightConnections = {}

        local function addPlayerESP(player)
            if player == game.Players.LocalPlayer then return end
            playerHighlightCache[#playerHighlightCache + 1] = player
        end

        local function removePlayerESP(player)
            for i = 1, #playerHighlightCache do
                if playerHighlightCache[i] == player then
                    table.remove(playerHighlightCache, i)
                    break
                end
            end
            if player.Character then
                if player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
                local billboard = playerNameCache[player.Character]
                if billboard then
                    pcall(function() billboard:Destroy() end)
                    playerNameCache[player.Character] = nil
                end
            end
        end

        local function applyNameESP(player, character, color)
            if not character then return end
            local head = character:FindFirstChild("Head")
            if not head then return end

            local existing = playerNameCache[character]
            if existing then
                pcall(function()
                    existing.TextLabel.TextColor3 = color
                    existing.TextLabel.Text = player.Name
                end)
                return
            end

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
            text.Text = player.Name
            text.TextColor3 = color
            text.Parent = billboard

            billboard.Parent = head
            playerNameCache[character] = billboard
        end

        local players = game.Players:GetPlayers()
        for i = 1, #players do
            addPlayerESP(players[i])
        end

        playerHighlightConnections[#playerHighlightConnections + 1] = game.Players.PlayerAdded:Connect(function(player)
            if playerHighlight then addPlayerESP(player) end
        end)
        playerHighlightConnections[#playerHighlightConnections + 1] = game.Players.PlayerRemoving:Connect(removePlayerESP)

        task.spawn(function()
            while playerHighlight do
                task.wait(1)
                for i = 1, #playerHighlightCache do
                    local player = playerHighlightCache[i]
                    if player.Character then
                        local isBeast = getBeast and player == getBeast()
                        local tipo = isBeast and "Beast" or "Player"

                        aplicarHighlight(player.Character, tipo)

                        local highlight = player.Character:FindFirstChildOfClass("Highlight")
                        if highlight then
                            applyNameESP(player, player.Character, highlight.FillColor)
                        end
                    end
                end
            end

            for i = 1, #playerHighlightCache do
                removePlayerESP(playerHighlightCache[i])
            end
            for i = 1, #playerHighlightConnections do
                playerHighlightConnections[i]:Disconnect()
            end
            playerHighlightCache, playerHighlightConnections, playerNameCache = {}, {}, {}
        end)
    else
        for i = 1, #playerHighlightConnections do
            playerHighlightConnections[i]:Disconnect()
        end
        for i = 1, #playerHighlightCache do
            local player = playerHighlightCache[i]
            if player.Character then
                if player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
                local billboard = playerNameCache[player.Character]
                if billboard then
                    pcall(function() billboard:Destroy() end)
                end
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
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local function isBoxPart(part)
        if not part:IsA("BasePart") then return false end
        if part.Name == "HumanoidRootPart" then return false end
        if part:FindFirstAncestorOfClass("Accessory") then return false end
        local model = part:FindFirstAncestorOfClass("Model")
        if not model then return false end
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if not humanoid then return false end
        if humanoid.RigType ~= Enum.HumanoidRigType.R6 then return false end
        local name = part.Name
        return name == "Head" or name == "Torso" or name == "Left Arm" or name == "Right Arm" or name == "Left Leg" or name == "Right Leg"
    end

    local function clearESP(character)
        local list = playerBoxCache[character]
        if list then
            for i = 1, #list do
                local obj = list[i]
                if obj then pcall(function() obj:Destroy() end) end
            end
            playerBoxCache[character] = nil
        end
    end

    local function applyBoxESP(player, character, color)
        if not character then return end
        local cached = playerBoxCache[character]
        if cached then
            for i = 1, #cached do
                local obj = cached[i]
                pcall(function()
                    if obj:IsA("BoxHandleAdornment") then
                        obj.Color3 = color
                    end
                end)
            end
            return
        end
        playerBoxCache[character] = {}
        local list = playerBoxCache[character]
        local parts = character:GetDescendants()
        for i = 1, #parts do
            local part = parts[i]
            if isBoxPart(part) then
                pcall(function()
                    local box = Instance.new("BoxHandleAdornment")
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Size = part.Size
                    box.Transparency = 0.3
                    box.Color3 = color
                    box.Parent = part
                    list[#list + 1] = box
                end)
            end
        end
    end

    if state then
        local playerList = Players:GetPlayers()
        playerBoxConnections.loop = task.spawn(function()
            while playerBox do
                task.wait(1)
                for i = 1, #playerList do
                    local player = playerList[i]
                    if player ~= LocalPlayer and player.Character then
                        local color
                        if getBeast and player == getBeast() then
                            color = Color3.fromRGB(255, 0, 0)
                        else
                            color = Color3.fromRGB(0, 255, 0)
                        end
                        pcall(function()
                            applyBoxESP(player, player.Character, color)
                        end)
                    end
                end
            end
        end)
        playerBoxConnections.added = Players.PlayerAdded:Connect(function(player)
            playerList[#playerList + 1] = player
        end)
        playerBoxConnections.removing = Players.PlayerRemoving:Connect(function(player)
            if player.Character then
                pcall(function()
                    clearESP(player.Character)
                end)
            end
            for i = 1, #playerList do
                if playerList[i] == player then
                    table.remove(playerList, i)
                    break
                end
            end
        end)
    else
        for character, list in next, playerBoxCache do
            for i = 1, #list do
                local obj = list[i]
                if obj then pcall(function() obj:Destroy() end) end
            end
            playerBoxCache[character] = nil
        end
        if playerBoxConnections.loop then
            task.cancel(playerBoxConnections.loop)
            playerBoxConnections.loop = nil
        end
        if playerBoxConnections.added then
            playerBoxConnections.added:Disconnect()
            playerBoxConnections.added = nil
        end
        if playerBoxConnections.removing then
            playerBoxConnections.removing:Disconnect()
            playerBoxConnections.removing = nil
        end
    end
end)

    local playerSquare = false
    local playerSquareCache = {}
    local playerSquareConnections = {}
        
    CreateToggle(espContent, "Square", false, function(state)
    playerSquare = state
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lplr = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local worldToViewportPoint = camera.WorldToViewportPoint
    local HeadOff = Vector3.new(0,0.5,0)
    local LegOff = Vector3.new(0,3,0)

    local function clearSquare(player)
        if playerSquareCache[player] then
            playerSquareCache[player].Visible = false
            playerSquareCache[player] = nil
        end
    end

    local function createSquare(player)
        if player == lplr then return end
        local square = Drawing.new("Square")
        square.Visible = false
        square.Color = Color3.new(0, 255, 0)
        square.Thickness = 1
        square.Transparency = 1
        square.Filled = false
        playerSquareCache[player] = square
    end

    if state then
        local plrs = Players:GetPlayers()
        for i = 1, #plrs do
            createSquare(plrs[i])
        end

        playerSquareConnections.added = Players.PlayerAdded:Connect(createSquare)
        playerSquareConnections.removing = Players.PlayerRemoving:Connect(function(player)
            clearSquare(player)
        end)

        playerSquareConnections.loop = RunService.RenderStepped:Connect(function()
            local plrs = Players:GetPlayers()
            for i = 1, #plrs do
                local player = plrs[i]
                local square = playerSquareCache[player]
                if square and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local RootPart = player.Character.HumanoidRootPart
                    local RootPosition, RootVisible = worldToViewportPoint(camera, RootPart.Position)
                    local HeadPosition = worldToViewportPoint(camera, RootPart.Position + HeadOff)
                    local LegPosition = worldToViewportPoint(camera, RootPart.Position - LegOff)
                    if RootVisible then
                        local size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                        local position = Vector2.new(RootPosition.X - size.X / 2, RootPosition.Y - size.Y / 2)
                        square.Size = size
                        square.Position = position
                        if getBeast and player == getBeast() then
                            square.Color = Color3.fromRGB(255, 0, 0)
                        else
                            square.Color = Color3.fromRGB(0, 255, 0)
                        end
                        square.Visible = true
                    else
                        square.Visible = false
                    end
                elseif square then
                    square.Visible = false
                end
            end
        end)
    else
        for player, square in next, playerSquareCache do
            if square then square.Visible = false end
            playerSquareCache[player] = nil
        end
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
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lplr = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local worldToViewportPoint = camera.WorldToViewportPoint

    local function clearLine(player)
        if playerLineCache[player] then
            playerLineCache[player].Visible = false
            playerLineCache[player] = nil
        end
    end

    local function createLine(player)
        if player == lplr then return end
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.new(0, 255, 0)
        line.Thickness = 1
        line.Transparency = 1
        playerLineCache[player] = line
    end

    if state then
        local plrs = Players:GetPlayers()
        for i = 1, #plrs do
            createLine(plrs[i])
        end

        playerLineConnections.added = Players.PlayerAdded:Connect(createLine)
        playerLineConnections.removing = Players.PlayerRemoving:Connect(function(player)
            clearLine(player)
        end)

        playerLineConnections.loop = RunService.RenderStepped:Connect(function()
            local plrs = Players:GetPlayers()
            for i = 1, #plrs do
                local player = plrs[i]
                local line = playerLineCache[player]
                if line and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local RootPart = player.Character.HumanoidRootPart
                    local Vector, OnScreen = worldToViewportPoint(camera, RootPart.Position)
                    if OnScreen then
                        line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        line.To = Vector2.new(Vector.X, Vector.Y)
                        if getBeast and player == getBeast() then
                            line.Color = Color3.fromRGB(255, 0, 0)
                        else
                            line.Color = Color3.fromRGB(0, 255, 0)
                        end
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                elseif line then
                    line.Visible = false
                end
            end
        end)
    else
        for player, line in next, playerLineCache do
            if line then line.Visible = false end
            playerLineCache[player] = nil
        end
        if playerLineConnections.loop then playerLineConnections.loop:Disconnect() playerLineConnections.loop = nil end
        if playerLineConnections.added then playerLineConnections.added:Disconnect() playerLineConnections.added = nil end
        if playerLineConnections.removing then playerLineConnections.removing:Disconnect() playerLineConnections.removing = nil end
    end
end)

local function clearGlow(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if head then
            local g = head:FindFirstChild("BeastGlow")
            if g then g:Destroy() end
        end
    end

    local function applyGlow(char)
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end
        local function update()
            local bp = char:FindFirstChild("BeastPowers")
            local glow = head:FindFirstChild("BeastGlow")
            if bp then
                if not glow then
                    glow = Instance.new("PointLight")
                    glow.Name = "BeastGlow"
                    glow.Color = Color3.fromRGB(0, 255, 255)
                    glow.Brightness = 8
                    glow.Range = 25
                    glow.Parent = head
                end
            else
                if glow then glow:Destroy() end
            end
        end
        update()
        table.insert(beastConnections, char.ChildAdded:Connect(update))
        table.insert(beastConnections, char.ChildRemoved:Connect(update))
    end
    
    local beastIlluminationEnabled = false
    local beastConnections = {}

    CreateToggle(espContent, "Beast GlowUp", false, function(enabled)
        beastIlluminationEnabled = enabled
        for i = 1, #beastConnections do beastConnections[i]:Disconnect() end
        beastConnections = {}
        if not enabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then clearGlow(plr.Character) end
            end
            return
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then applyGlow(plr.Character) end
            table.insert(beastConnections, plr.CharacterAdded:Connect(function(char)
                if beastIlluminationEnabled then applyGlow(char) end
            end))
        end
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
    local box2P, content2P = CreateGroupbox(rightColP, "Beast Indicators")

    do
        local enabled = false
        local comps = {}
        local P = game:GetService("Players")
        local RS = game:GetService("ReplicatedStorage")
        local W = workspace

        CreateToggle(content1P, "Computer Progress", false, function(v)
            enabled = v
            if not v then
                for _, d in pairs(comps) do
                    if d.gui then d.gui:Destroy() end
                end
                comps = {}
            end
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
            local bg = Instance.new("Frame", g)
            bg.Position = UDim2.new(0, 0, 0.55, 0)
            bg.Size = UDim2.new(1, 0, 0.35, 0)
            bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            bg.BorderSizePixel = 0
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local bar = Instance.new("Frame", bg)
            bar.Size = UDim2.new(0, 0, 1, 0)
            bar.BorderSizePixel = 0
            bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
            comps[pc] = {gui = g, bar = bar, txt = txt, p = 0, d = false}
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
                        if ap and r and not r.Value then
                            m = math.max(m, ap.Value)
                        end
                    end
                end
            end
            return m
        end

        RunService.Heartbeat:Connect(function()
            if not enabled then return end
            for pc, d in pairs(comps) do
                if not d.d then
                    d.p = math.max(d.p, progress(pc))
                    d.bar.Size = UDim2.new(d.p, 0, 1, 0)
                    if d.p >= 1 then
                        d.d = true
                        d.txt.Text = "COMPLETED"
                        d.txt.TextColor3 = Color3.fromRGB(0, 255, 0)
                        d.bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                    else
                        d.txt.Text = string.format("%.1f%%", d.p * 100)
                    end
                end
            end
        end)

        task.spawn(function()
            while true do
                if enabled then
                    local m = RS:FindFirstChild("CurrentMap")
                    m = m and m.Value
                    local map = m and W:FindFirstChild(tostring(m))
                    if map then
                        for _, o in pairs(map:GetChildren()) do
                            if o.Name == "ComputerTable" and not comps[o] then
                                make(o)
                            end
                        end
                    end
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
        t.Parent = g

        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(0.8,0,0,6)
        bg.Position = UDim2.new(0.1,0,0.7,0)
        bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
        bg.BorderSizePixel = 0
        bg.Parent = g

        local f = Instance.new("Frame")
        f.Size = UDim2.new(0,0,1,0)
        f.BackgroundColor3 = Color3.fromRGB(255,170,0)
        f.BorderSizePixel = 0
        f.Parent = bg

        doors[d] = {p = part, t = t, f = f, gui = g, frozen = false}
    end

    local function removeAll()
        if connAdded then connAdded:Disconnect() connAdded = nil end
        loopThread = nil
        if folder then folder:Destroy() folder = nil end
        table.clear(doors)
    end

    CreateToggle(content1P, "Exit Door Timer", false, function(v)
        enabled = v
        if not v then
            removeAll()
            return
        end

        removeAll()

        folder = Instance.new("Folder")
        folder.Name = "ExitDoorUI"
        folder.Parent = LP:WaitForChild("PlayerGui")

        for _,o in ipairs(workspace:GetDescendants()) do
            if o:IsA("Model") and (o.Name == "ExitDoor" or o.Name == "Exit") then
                addDoor(o)
            end
        end

        connAdded = workspace.DescendantAdded:Connect(function(o)
            if enabled and o:IsA("Model") and (o.Name == "ExitDoor" or o.Name == "Exit") then
                task.wait(0.2)
                addDoor(o)
            end
        end)

        task.spawn(function()
            loopThread = true
            while enabled and loopThread do
                task.wait(0.1)
                for d,data in pairs(doors) do
                    if not d.Parent then
                        if data.gui then data.gui:Destroy() end
                        doors[d] = nil
                    else
                        local best = 0
                        local using = false
                        for _,plr in ipairs(Players:GetPlayers()) do
                            local char = plr.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hrp and (hrp.Position - data.p.Position).Magnitude <= 12 then
                                local prog = getProgress(plr)
                                if prog > 0 then
                                    using = true
                                    best = math.max(best, prog)
                                end
                            end
                        end

                        local prog = using and math.clamp(best,0,1) or 0

                        if prog >= 0.99 and not data.frozen then
                            data.frozen = true
                            data.f.Size = UDim2.new(1,0,1,0)
                            data.f.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                            data.t.Text = "OPEN: 100%"
                            data.t.TextColor3 = Color3.fromRGB(0, 255, 0)
                        elseif prog <= 0.01 and data.frozen then
                            data.frozen = false
                            data.f.BackgroundColor3 = Color3.fromRGB(255,170,0)
                            data.f.Size = UDim2.new(0,0,1,0)
                            data.t.Text = "EXIT"
                            data.t.TextColor3 = Color3.new(1,1,1)
                        elseif not data.frozen then
                            data.f.Size = UDim2.new(prog,0,1,0)
                            data.t.Text = (prog > 0.01) and ("OPENING: "..math.floor(prog*100).."%") or "EXIT"
                            data.t.TextColor3 = (prog > 0) and Color3.fromRGB(255,170,0) or Color3.new(1,1,1)
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
    if getgenv().DoorsList then
        for i = 1, #getgenv().DoorsList do
            local door = getgenv().DoorsList[i]
            if door and door.Parent then
                local b = door:FindFirstChild("BillboardGui")
                if b then b:Destroy() end
            end
        end
    end

    getgenv().DoorsList = {}
    getgenv().DoorProgressData = {}

    local textColor = Color3.fromRGB(133, 88, 0)
    local progressFillColor = Color3.fromRGB(133, 88, 0)
    local backgroundColor = Color3.fromRGB(32, 32, 32)
    local progressTransparency = 0.1
    local backgroundTransparency = 0.4
    local displaySeconds = true
    local displayOpener = true

    CreateToggle(content1P, "Door Timer", false, function(state)
        enabled = state
        if not state then
            if getgenv().DoorTrackerConn then getgenv().DoorTrackerConn:Disconnect() getgenv().DoorTrackerConn = nil end
            for door, _ in pairs(getgenv().DoorProgressData) do
                if door and door.Parent then
                    local b = door:FindFirstChild("BillboardGui")
                    if b then b:Destroy() end
                end
            end
            table.clear(getgenv().DoorsList)
            table.clear(getgenv().DoorProgressData)
        else
            setupDoors()
            startTracker()
        end
    end)

    local function getmap() return map.Value end

    local function getObjectPosition(object)
        if object:IsA("Model") then
            local primary = object.PrimaryPart
            if primary then return primary.Position end
            local cf = object:GetPivot()
            if cf then return cf.Position end
        elseif object:IsA("BasePart") then
            return object.Position
        end
        return Vector3_new(0, 0, 0)
    end

    local function findNearestObject(playerPosition, objectList)
        local nearestObject = nil
        local shortestDistance = math.huge
        for i = 1, #objectList do
            local object = objectList[i]
            if object.Parent then
                local distance = (playerPosition - getObjectPosition(object)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestObject = object
                end
            end
        end
        return nearestObject, shortestDistance
    end

    local function isDoorLocked(door)
        local trigger = door:FindFirstChild("DoorTrigger")
        if trigger then
            local actionSign = trigger:FindFirstChild("ActionSign")
            if actionSign then return actionSign.Value ~= 11 end
        end
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
        ProgressBox.BackgroundTransparency = backgroundTransparency
        ProgressBox.BorderSizePixel = 0
        ProgressBox.Position = UDim2_new(0.5, 0, 0.6, 0)
        ProgressBox.Size = UDim2_new(0.7, 0, 0.08, 0)
        ProgressBox.SizeConstraint = Enum.SizeConstraint.RelativeYY
        ProgressBox.Text = ""
        ProgressBox.Parent = BillboardGui

        local ProgressFill = Instance_new("TextLabel")
        ProgressFill.Name = "ProgressFill"
        ProgressFill.BackgroundColor3 = progressFillColor
        ProgressFill.BackgroundTransparency = progressTransparency
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
        PercentageBox.TextColor3 = textColor
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
        PlayerNameLabel.TextColor3 = textColor
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
        if displaySeconds and timeRemaining and timeRemaining > 0 then
            PercentageBox.Text = percentageText.. " | ".. string_format("%.1fs", timeRemaining)
        else
            PercentageBox.Text = percentageText
        end

        local data = getgenv().DoorProgressData[door]
        if PlayerNameLabel and data then
            PlayerNameLabel.Text = displayOpener and data.playerName ~= "" and data.playerName or ""
        end

        local targetSize = UDim2_new(progress, 0, 1, 0)
        if ProgressFill.Size ~= targetSize then
            TweenService:Create(ProgressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
        end
    end

    local function checkDoorStates()
        for door, data in pairs(getgenv().DoorProgressData) do
            if door and door.Parent then
                local locked = isDoorLocked(door)
                if data.playerName == "" then
                    local newProgress = locked and 0 or 1
                    if data.progress ~= newProgress then
                        data.progress = newProgress
                        data.timeRemaining = nil
                        updateDoorUI(door, newProgress, nil)
                    end
                end
            end
        end
    end

    function setupDoors()
        getgenv().DoorsList = {}
        getgenv().DoorProgressData = {}
        local currentMap = getmap()
        if currentMap then
            for _, v in pairs(currentMap:GetDescendants()) do
                local name = v.Name:lower()
                if (name == "singledoor" or name == "doubledoor") and isValidDoor(v) then
                    table.insert(getgenv().DoorsList, v)
                    getgenv().DoorProgressData[v] = {
                        progress = 0, playerName = "", lastProgress = 0, lastUpdateTime = tick(), timeRemaining = nil, tween = nil
                    }
                    createUIForDoor(v)
                    updateDoorUI(v, 0, nil)
                end
            end
        end
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

                                        if deltaProgress > 0 and timeSinceLastUpdate > 0 then
                                            timeRemaining = (1 - progress) / (deltaProgress / timeSinceLastUpdate)
                                        else
                                            timeRemaining = (1 - progress) * 1.5
                                        end

                                        data.progress = progress
                                        data.playerName = plr.Name
                                        data.timeRemaining = timeRemaining
                                        data.lastProgress = progress
                                        data.lastUpdateTime = currentTime

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
                    if data.playerName ~= "" then
                        data.playerName = ""
                        updateDoorUI(door, data.progress, nil)
                    end
                    if isDoorLocked(door) and data.progress > 0 and data.progress < 1 then
                        data.progress = 0
                        data.timeRemaining = nil
                        updateDoorUI(door, 0, nil)
                    elseif not isDoorLocked(door) then
                        data.progress = 1
                        updateDoorUI(door, 1, nil)
                    end
                end
            end

            checkDoorStates()
        end)

        if getgenv().DoorMapChangedConn then getgenv().DoorMapChangedConn:Disconnect() end
        getgenv().DoorMapChangedConn = map.Changed:Connect(function()
            task.wait(2)
            if enabled then setupDoors() end
        end)
    end
end

do
    local _G_Life = false
    local _G_LifeC = {}
    local LP = Players.LocalPlayer

    local function disconnectAll()
        for _, c in ipairs(_G_LifeC) do pcall(function() c:Disconnect() end) end
        table.clear(_G_LifeC)
    end

    local function clearAllTags()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                if head then
                    local tag = head:FindFirstChild("LifeTag")
                    if tag then tag:Destroy() end
                end
            end
        end
    end

    local function beast(p)
        local s = p:FindFirstChild("TempPlayerStatsModule", true)
        local v = s and s:FindFirstChild("IsBeast")
        return v and v.Value
    end

    local function color(v)
        if v >= 400 then return Color3.fromRGB(80,160,255)
        elseif v >= 200 then return Color3.fromRGB(255,210,80)
        else return Color3.fromRGB(255,80,80) end
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
        text.Parent = gui
        
        local smooth = 500
        local conn = RunService.RenderStepped:Connect(function(dt)
            if not _G_Life or not char.Parent then 
                gui:Destroy() 
                return 
            end
            if beast(player) then
                text.Text = "000s"
                text.TextColor3 = Color3.fromRGB(255,0,0)
                smooth = 500
                return
            end
            local target = math.floor(math.clamp(hp.Value, 0, 100) / 100 * 500)
            smooth += (target - smooth) * math.clamp(dt * 8, 0, 1)
            local v = math.floor(smooth + 0.5)
            text.Text = v.. "s"
            text.TextColor3 = color(v)
        end)
        table.insert(_G_LifeC, conn)
    end

    local function hookPlayer(p)
        table.insert(_G_LifeC, p.CharacterAdded:Connect(function(c)
            task.wait(0.3)
            if _G_Life then createTag(c, p) end
        end))
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
                    if p ~= LP and p.Character then
                        local head = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("HumanoidRootPart")
                        if head and not head:FindFirstChild("LifeTag") then
                            createTag(p.Character, p)
                        end
                    end
                end
            end
        end)
    end)
end

    do
        local walkEnabled = false
        local connections = {}
        local localPlayer = Players.LocalPlayer

        CreateToggle(content1P, "Walkspeed", false, function(Value)
            walkEnabled = Value
            if not Value then
                for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
                table.clear(connections)
                for _, plr in ipairs(Players:GetPlayers()) do
                    local head = plr.Character and plr.Character:FindFirstChild("Head")
                    if head then
                        local tag = head:FindFirstChild("SpeedTag")
                        if tag then tag:Destroy() end
                    end
                end
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
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0.3
                label.TextScaled = true
                label.Font = Enum.Font.GothamBold
                label.Parent = billboard
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    if not walkEnabled or not character.Parent or not humanoid then
                        conn:Disconnect()
                        billboard:Destroy()
                        return
                    end
                    local speed = humanoid.WalkSpeed
                    label.Text = humanoid.MoveDirection.Magnitude > 0 and tostring(math.floor(speed)) or "0"
                end)
                table.insert(connections, conn)
            end
            local function monitorPlayer(plr)
                local c1 = plr.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    createSpeedTag(char)
                end)
                table.insert(connections, c1)
                if plr.Character then createSpeedTag(plr.Character) end
            end
            for _, plr in ipairs(Players:GetPlayers()) do monitorPlayer(plr) end
            local c2 = Players.PlayerAdded:Connect(monitorPlayer)
            table.insert(connections, c2)
            task.spawn(function()
                while walkEnabled do
                    task.wait(2)
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr.Character then createSpeedTag(plr.Character) end
                    end
                end
            end)
        end)
    end

    do
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer

        local E = {
            LP = LP,
            DURATION = 27.7,
            enabled = false,
            playerUI = {},
            nameTags = {},
            countdownTags = {},
            uiOffset = 70,
            connections = {}
        }

        local function GetSmoothColor(timeLeft)
            local percent = math.clamp(timeLeft / E.DURATION, 0, 1)
            local hue = 0.33 * percent
            return Color3.fromHSV(hue, 1, 1)
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

        local function removeNameTag(player)
            if E.nameTags[player] then
                E.nameTags[player]:Destroy()
                E.nameTags[player] = nil
            end
        end

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
            label.TextColor3 = Color3.fromRGB(0, 255, 0)
            label.TextStrokeTransparency = 1
            label.Text = string.format("%.3f", E.DURATION)
            label.Parent = billboardGui
            local stroke = Instance.new("UIStroke", label)
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = 2
            E.countdownTags[player] = billboardGui
            return billboardGui, label
        end

        local function removeCountdownLabel(player)
            if E.countdownTags[player] then
                E.countdownTags[player]:Destroy()
                E.countdownTags[player] = nil
            end
        end

        local function RepositionBottomUIs()
            local index = 0
            for _, data in pairs(E.playerUI) do
                if data.frame and data.frame.Parent then
                    data.frame.Position = UDim2.new(1, -260, 1, -90 - (index * E.uiOffset))
                    index += 1
                end
            end
        end

        local function removeBottomRightUI(player)
            if E.playerUI[player] then
                if E.playerUI[player].connection then E.playerUI[player].connection:Disconnect() end
                E.playerUI[player].screenGui:Destroy()
                E.playerUI[player] = nil
                RepositionBottomUIs()
            end
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
            timerLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
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
                if secondsLeft < 0 or not player.Parent then
                    removeBottomRightUI(player)
                else
                    timerLabel.Text = string.format("%.3f", secondsLeft)
                    timerLabel.TextColor3 = GetSmoothColor(secondsLeft)
                end
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
                if not ragdoll.Value or not player.Parent or not E.enabled then
                    removeCountdownLabel(player)
                    removeNameTag(player)
                    renderSteppedConnection:Disconnect()
                    return
                end
                local secondsLeft = endTime - tick()
                if secondsLeft < 0 then
                    removeCountdownLabel(player)
                    removeNameTag(player)
                    renderSteppedConnection:Disconnect()
                else
                    label.Text = string.format("%.3f", secondsLeft)
                    label.TextColor3 = GetSmoothColor(secondsLeft)
                end
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
                if ragdoll.Value then
                    startRagdollCountdown(player, ragdoll)
                else
                    removeBottomRightUI(player)
                    removeNameTag(player)
                    removeCountdownLabel(player)
                end
            end)
            table.insert(E.connections, conn)
            local charRemoving = player.CharacterRemoving:Connect(function()
                removeNameTag(player)
                removeCountdownLabel(player)
                removeBottomRightUI(player)
            end)
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
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    onRagdollChanged(player)
                else
                    player.CharacterAdded:Connect(function() onRagdollChanged(player) end)
                end
            end
            local added = Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function() onRagdollChanged(player) end)
            end)
            table.insert(E.connections, added)
        end

        CreateToggle(content2P, "GetUp Timer", false, function(Value)
            E.enabled = Value
            if Value then
                Init()
            else
                CleanupAll()
            end
        end)
    end

    do
        local beastEnabled = false
        local loopThread = nil
        local CoreGui = game:GetService("CoreGui")

        CreateToggle(content2P, "Beast Power", false, function(Value)
            beastEnabled = Value
            if not Value then
                if loopThread then task.cancel(loopThread) loopThread = nil end
                local old = CoreGui:FindFirstChild("BeastPowerGui")
                if old then old:Destroy() end
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
            label.BackgroundTransparency = 0.35
            label.TextScaled = true
            label.Font = Enum.Font.GothamBold
            label.Text = ""
            label.Parent = gui
            local function getBeast()
                for _,p in ipairs(Players:GetPlayers()) do
                    local char = p.Character
                    local bp = char and char:FindFirstChild("BeastPowers")
                    if bp then return bp end
                end
                return nil
            end
            loopThread = task.spawn(function()
                local readyShown = false
                while beastEnabled do
                    task.wait(0.2)
                    local bp = getBeast()
                    if not bp then
                        gui.Enabled = false
                        readyShown = false
                    else
                        gui.Enabled = true
                        local percent = bp:FindFirstChild("PowerProgressPercent")
                        if percent then
                            local value = math.floor(percent.Value * 100)
                            if value >= 100 then
                                if not readyShown then
                                    label.TextColor3 = Color3.fromRGB(0, 255, 0)
                                    label.Text = "BeastPower is Full"
                                    readyShown = true
                                end
                            elseif value >= 70 then
                                label.TextColor3 = Color3.fromRGB(255, 170, 0)
                                label.Text = "BeastPower Back In: ".. value.. "%"
                                readyShown = false
                            else
                                label.TextColor3 = Color3.fromRGB(255, 0, 0)
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

        local function disconnectAll()
            for _, c in ipairs(_G_BeastPower2_Connections) do pcall(function() c:Disconnect() end) end
            _G_BeastPower2_Connections = {}
        end

        local function clearAll()
            for _, plr in ipairs(Players:GetPlayers()) do
                local char = plr.Character
                local head = char and char:FindFirstChild("Head")
                if head then
                    local g = head:FindFirstChild("RP")
                    if g then g:Destroy() end
                end
            end
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
            l.TextColor3 = Color3.new(1,1,1)
            l.TextScaled = false
            l.TextSize = 11
            l.Font = Enum.Font.GothamBold
            l.Text = "0%"
            l.Parent = g
        end

        local function rmBBG(head)
            local g = head and head:FindFirstChild("RP")
            if g then g:Destroy() end
        end

                local function setupCharacter(char)
            if not running then return end
            table.insert(_G_BeastPower2_Connections, char.ChildAdded:Connect(function(child)
                if child.Name == "BeastPowers" then
                    local head = char:FindFirstChild("Head")
                    if head then mkBBG(head) end
                end
            end))
            table.insert(_G_BeastPower2_Connections, char.ChildRemoved:Connect(function(child)
                if child.Name == "BeastPowers" then
                    local head = char:FindFirstChild("Head")
                    if head then rmBBG(head) end
                end
            end))
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
                        if value >= 100 then
                            label.Text = "Full"
                            label.TextColor3 = Color3.fromRGB(0, 255, 0)
                        else
                            label.Text = tostring(math.floor(value)).. "%"
                            label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
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
                table.insert(_G_BeastPower2_Connections, plr.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    setupCharacter(char)
                end))
            end
            table.insert(_G_BeastPower2_Connections, Players.PlayerAdded:Connect(function(plr)
                table.insert(_G_BeastPower2_Connections, plr.CharacterAdded:Connect(function(char)
                    task.wait(1)
                    setupCharacter(char)
                end))
            end))
        end)
    end

    do
        local CoreGui = game:GetService("CoreGui")
        local LP = Players.LocalPlayer
        local _G_BTC = nil
        local _G_BCC = nil

        local function disconnectAll()
            if _G_BTC then pcall(function() _G_BTC:Disconnect() end) end
            if _G_BCC then pcall(function() _G_BCC:Disconnect() end) end
        end

        CreateToggle(content2P, "Beast Spawn Timer", false, function(v)
            disconnectAll()
            local old = CoreGui:FindFirstChild("BeastTimerGui")
            if old then old:Destroy() end
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
            label.Visible = false
            label.Parent = gui

            local function drip(text, color)
                for i = 1, math.random(2, 4) do
                    local d = label:Clone()
                    d.Parent = gui
                    d.Text = text
                    d.TextColor3 = color
                    d.Position = label.Position + UDim2.new(0, math.random(-6, 6), 0, 0)
                    game:GetService("TweenService"):Create(d, TweenInfo.new(0.8), {
                        Position = d.Position + UDim2.new(0, 0, 0, math.random(35, 60)),
                        TextTransparency = 1
                    }):Play()
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

                if isBeast() then
                    label.Visible = false
                    active = false
                    return
                end

                if lastPos and not active and (hrp.Position - lastPos).Magnitude > TELEPORT then
                    active = true
                    timeLeft = DURATION
                    label.Visible = true
                end

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
                        task.spawn(function()
                            for i = 1, 25 do
                                drip(label.Text, Color3.fromRGB(180, 0, 0))
                                task.wait(0.1)
                            end
                        end)
                        task.delay(3.5, function()
                            if not active then label.Visible = false end
                        end)
                    else
                        local color = timeLeft <= 5 and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
                        label.TextColor3 = color
                        label.Text = string.format("%.2f", timeLeft)
                        if timeLeft <= 5 and math.random() < 0.6 then
                            drip(label.Text, color)
                        end
                    end
                end
            end)

            _G_BCC = LP.CharacterAdded:Connect(function()
                active = false
                lastPos = nil
                label.Visible = false
            end)
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

        local function saveOriginal()
            local lighting = game:GetService("Lighting")
            originalSettings = {
                GlobalShadows = lighting.GlobalShadows,
                FogEnd = lighting.FogEnd,
                Technology = gethiddenproperty and pcall(gethiddenproperty, lighting, "Technology") and gethiddenproperty(lighting, "Technology") or nil
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
                        CastShadow = v.CastShadow,
                        Color = v.Color
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

        local function applyFPSBoost()
            if not next(originalSettings) then saveOriginal() end
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            if sethiddenproperty then pcall(sethiddenproperty, lighting, "Technology", 2) end
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    if not originalParts[v] then
                        originalParts[v] = {Material = v.Material, Reflectance = v.Reflectance, CastShadow = v.CastShadow, Color = v.Color}
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
            table.insert(connections, workspace.DescendantAdded:Connect(function(v)
                if not fpsEnabled then return end
                task.defer(function()
                    if v:IsA("BasePart") then
                        if not originalParts[v] then
                            originalParts[v] = {Material = v.Material, Reflectance = v.Reflectance, CastShadow = v.CastShadow, Color = v.Color}
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
                end)
            end))
        end

        local function restoreFPS()
            for _, conn in ipairs(connections) do conn:Disconnect() end
            table.clear(connections)
            local lighting = game:GetService("Lighting")
            if originalSettings.GlobalShadows ~= nil then
                lighting.GlobalShadows = originalSettings.GlobalShadows
                lighting.FogEnd = originalSettings.FogEnd
                if originalSettings.Technology and sethiddenproperty then
                    pcall(sethiddenproperty, lighting, "Technology", originalSettings.Technology)
                end
            end
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain and originalSettings.WaterWaveSize then
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
                            obj.Color = data.Color
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
        local CINZA = Color3.fromRGB(160,160,160)
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
            TouchMode = false,
            Crosshair = nil,
            Touches = {}
        }
    end
    local State = getgenv().CrosshairState

    local boxSettings, contentSettings = CreateGroupbox(rightColH, "Crosshair")
    boxSettings.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxSettings.BackgroundTransparency = 1
    boxSettings.Size = UDim2.new(1, 0, 0, 210)
    boxSettings.AutomaticSize = Enum.AutomaticSize.None
    Instance.new("UICorner", boxSettings).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxSettings).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentSettings).Padding = UDim.new(0, 6)

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

    local function CreateCustomCursor(id, size)
        local old = playerGui:FindFirstChild("CustomCursorGui")
        if old then old:Destroy() end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CustomCursorGui"
        screenGui.IgnoreGuiInset = true
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        local cursorImage = Instance.new("ImageLabel")
        cursorImage.Size = UDim2.new(0, size or State.Size, 0, size or State.Size)
        cursorImage.BackgroundTransparency = 1
        cursorImage.Image = "rbxassetid://".. id
        cursorImage.AnchorPoint = Vector2.new(0.5, 0.5)
        cursorImage.Position = UDim2.new(0.5, 0, 0.5, 0)
        cursorImage.Parent = screenGui

        State.Crosshair = cursorImage
        UserInputService.MouseIconEnabled = false
    end

    applyBtn.MouseButton1Click:Connect(function()
        local id = textBox.Text:match("%d+")
        if id then CreateCustomCursor(id) end
    end)

    local touchBtn = Instance.new("TextButton", contentSettings)
    touchBtn.Size = UDim2.new(1, 0, 0, 35)
    touchBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    touchBtn.BackgroundTransparency = 0.35
    touchBtn.TextColor3 = Color3.fromRGB(180,180,180)
    touchBtn.Font = Enum.Font.GothamBold
    touchBtn.TextSize = 13
    touchBtn.Text = "Touch Mode: OFF"
    touchBtn.BorderSizePixel = 0
    Instance.new("UICorner", touchBtn).CornerRadius = UDim.new(0,8)

    local touchStroke = Instance.new("UIStroke", touchBtn)
    touchStroke.Color = Color3.fromRGB(80,80,80)
    touchStroke.Thickness = 1
    touchStroke.Transparency = 0.5

    touchBtn.MouseButton1Click:Connect(function()
        State.TouchMode = not State.TouchMode
        touchBtn.Text = "Touch Mode: ".. (State.TouchMode and "ON" or "OFF")

        if State.TouchMode then
            TweenService:Create(touchBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200,200,200),
                BackgroundTransparency = 0.1,
                TextColor3 = Color3.fromRGB(20,20,20)
            }):Play()
            TweenService:Create(touchStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(200,200,200),
                Transparency = 0.2
            }):Play()

            if State.Crosshair then State.Crosshair.Visible = false end
        else
            TweenService:Create(touchBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(30,30,30),
                BackgroundTransparency = 0.65,
                TextColor3 = Color3.fromRGB(180,180,180)
            }):Play()
            TweenService:Create(touchStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(80,80,80),
                Transparency = 0.5
            }):Play()

            for _, v in pairs(State.Touches) do if v then v:Destroy() end end
            State.Touches = {}
            if State.Crosshair then
                State.Crosshair.Visible = true
                State.Crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
            end
        end
    end)

    touchBtn.MouseEnter:Connect(function()
        if not State.TouchMode then
            TweenService:Create(touchBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.25}):Play()
        end
    end)
    touchBtn.MouseLeave:Connect(function()
        if not State.TouchMode then
            TweenService:Create(touchBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.65}):Play()
        end
    end)

    local resetBtn = Instance.new("TextButton", contentSettings)
    resetBtn.Size = UDim2.new(1, 0, 0, 35)
    resetBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    resetBtn.BackgroundTransparency = 0.35
    resetBtn.TextColor3 = Color3.fromRGB(180,180,180)
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 13
    resetBtn.Text = "Reset to Default"
    resetBtn.BorderSizePixel = 0
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,8)

    local resetStroke = Instance.new("UIStroke", resetBtn)
    resetStroke.Color = Color3.fromRGB(80,80,80)
    resetStroke.Thickness = 1
    resetStroke.Transparency = 0.5

    resetBtn.MouseButton1Click:Connect(function()
        TweenService:Create(resetBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(200,200,200),
            BackgroundTransparency = 0.1,
            TextColor3 = Color3.fromRGB(20,20,20)
        }):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.1), {
            Color = Color3.fromRGB(200,200,200),
            Transparency = 0.2
        }):Play()

        task.wait(0.1)

        TweenService:Create(resetBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(30,30,30),
            BackgroundTransparency = 0.65,
            TextColor3 = Color3.fromRGB(180,180,180)
        }):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(80,80,80),
            Transparency = 0.5
        }):Play()

        for _, v in ipairs(playerGui:GetChildren()) do
            if v:IsA("ScreenGui") and (v.Name:lower():find("crosshair") or v.Name:lower():find("cursor") or v.Name == "CustomCursorGui") then
                v:Destroy()
            end
        end
        UserInputService.MouseIconEnabled = true
        State.Crosshair = nil
        State.Size = 30
        State.TouchMode = false
        touchBtn.Text = "Touch Mode: OFF"
        sizeLabel.Text = "Crosshair Size: 30"
        sliderFill.Size = UDim2.new(0.3, 0, 1, 0)
        knob.Position = UDim2.new(0.3, 0, 0.5, 0)
    end)

    resetBtn.MouseEnter:Connect(function()
        TweenService:Create(resetBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.25}):Play()
    end)
    resetBtn.MouseLeave:Connect(function()
        TweenService:Create(resetBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.65}):Play()
    end)

    local sizeLabel = Instance.new("TextLabel", contentSettings)
    sizeLabel.Size = UDim2.new(1, 0, 0, 20)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Crosshair Size: ".. State.Size
    sizeLabel.Font = Enum.Font.GothamBold
    sizeLabel.TextSize = 14
    sizeLabel.TextColor3 = Color3.fromRGB(220,220,220)
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left

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

        sizeLabel.Text = "Crosshair Size: ".. State.Size
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

    local function CreateCrosshairGroup(parent, title, crosshairs)
        local box, content = CreateGroupbox(parent, title)
        box.BackgroundColor3 = Color3.fromRGB(25,25,25)
        box.BackgroundTransparency = 1
        box.AutomaticSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
        Instance.new("UIStroke", box).Color = Color3.fromRGB(70,70,70)

        local scrollGrid = Instance.new("ScrollingFrame", content)
        scrollGrid.Size = UDim2.new(1, 0, 0, 165)
        scrollGrid.BackgroundTransparency = 1
        scrollGrid.BorderSizePixel = 0
        scrollGrid.ScrollBarThickness = 3
        scrollGrid.ScrollBarImageColor3 = Color3.fromRGB(120,120,120)
        scrollGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
        scrollGrid.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scrollGrid.ClipsDescendants = true

        local gridLayout = Instance.new("UIGridLayout", scrollGrid)
        gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
        gridLayout.CellSize = UDim2.new(0, 50, 0, 50)
        gridLayout.FillDirection = Enum.FillDirection.Horizontal
        gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

        for _, data in ipairs(crosshairs) do
            local btn = Instance.new("ImageButton", scrollGrid)
            btn.Size = UDim2.new(0, 50, 0, 50)
            btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
            btn.BackgroundTransparency = 0.35
            btn.Image = "rbxassetid://".. data[1]
            btn.ScaleType = Enum.ScaleType.Fit
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

            btn.MouseButton1Click:Connect(function()
                CreateCustomCursor(data[1], data[2])
            end)

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.1}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
            end)
        end
    end

    CreateCrosshairGroup(rightColH, "Custom Cross hair", {
        {"72254979333116", 32},
        {"127864951260720", 32},
        {"101384469724691", 32},
        {"124452821551584", 32},
        {"131055002280367", 32},
        {"78294835549441", 32},
        {"117792166125612", 32},
        {"123835544338156", 32},
        {"121119061815558", 32},
        {"120412295822517", 32},
        {"124330770354006", 32},
        {"70916441648356", 32},
        {"87221997499891", 32},
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
        {"85372624608084", 40},
        {"129016541533877", 30},
        {"98285238714079", 40},
        {"103861126846931", 30},
        {"97417889091578", 40},
        {"85605196873114", 30}
    })
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

    local sliderRefs = {}

    local function CreateSlider(parent, name, min, max, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,50)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,0,0,14)
        label.BackgroundTransparency = 1
        label.Text = name..": ".. string.format("%.2f", default)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(200,200,200)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBg = Instance.new("Frame", holder)
        sliderBg.Size = UDim2.new(1,0,0,4)
        sliderBg.Position = UDim2.new(0,0,0,24)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
        sliderBg.BorderSizePixel = 0
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

        local percent = math.clamp((default - min) / (max - min), 0, 1)

        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new(percent,0,1,0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        sliderFill.BorderSizePixel = 0
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

        local sliderBtn = Instance.new("Frame", sliderBg)
        sliderBtn.Size = UDim2.new(0,12,0,12)
        sliderBtn.Position = UDim2.new(percent,0,0.5,0)
        sliderBtn.AnchorPoint = Vector2.new(0.5,0.5)
        sliderBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        sliderBtn.BorderSizePixel = 0
        sliderBtn.ZIndex = 2
        Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0,2)

        local clickDetector = Instance.new("TextButton", sliderBg)
        clickDetector.Size = UDim2.new(1,0,1,0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.ZIndex = 5

        sliderRefs[name] = {label = label, fill = sliderFill, knob = sliderBtn}

        local dragging = false
        local function updateSlider(xPos)
            local newPercent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = min + (newPercent * (max - min))
            label.Text = name..": ".. string.format("%.2f", value)
            callback(value)
            TweenService:Create(sliderFill, TweenInfo.new(0.08), {Size = UDim2.new(newPercent,0,1,0)}):Play()
            TweenService:Create(sliderBtn, TweenInfo.new(0.08), {Position = UDim2.new(newPercent,0,0.5,0)}):Play()
        end

        clickDetector.InputBegan:Connect(function(input)
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

    local function resetSlider(name, value, min, max)
        local ref = sliderRefs[name]
        if not ref then return end
        local percent = math.clamp((value - min) / (max - min), 0, 1)
        ref.label.Text = name.. ": ".. string.format("%.2f", value)
        TweenService:Create(ref.fill, TweenInfo.new(0.12), {Size = UDim2.new(percent,0,1,0)}):Play()
        TweenService:Create(ref.knob, TweenInfo.new(0.12), {Position = UDim2.new(percent,0,0.5,0)}):Play()
    end

    local boxColor, contentColor = CreateGroupbox(leftColH, "Calibration")
    boxColor.BackgroundColor3 = Color3.fromRGB(30,30,30)
    boxColor.BackgroundTransparency = 1
    boxColor.BorderSizePixel = 0
    boxColor.Size = UDim2.new(1,0,0,280)
    boxColor.ClipsDescendants = false
    Instance.new("UICorner", boxColor).CornerRadius = UDim.new(0,8)
    contentColor.ClipsDescendants = false
    Instance.new("UIStroke", boxColor).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentColor).Padding = UDim.new(0, 8)

    local FILE_NAME = "ColorCalibration.json"
    local defaultData = {
        Enabled = false,
        Color = {255, 255, 255},
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
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
                loaded.Enabled = loaded.Enabled or false
                loaded.Color = loaded.Color or table.clone(defaultData.Color)
                if loaded.Brightness == nil then loaded.Brightness = defaultData.Brightness end
                if loaded.Contrast == nil then loaded.Contrast = defaultData.Contrast end
                if loaded.Saturation == nil then loaded.Saturation = defaultData.Saturation end
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
    local filtro

    local function destroyFilter()
        if filtro then filtro:Destroy() filtro = nil end
        local old = Lighting:FindFirstChild("FiltroBranco")
        if old then old:Destroy() end
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

    local function applyFilter()
        if not data.Enabled then destroyFilter() return end
        local filtro = getFilter()
        filtro.TintColor = Color3.fromRGB(data.Color[1], data.Color[2], data.Color[3])
        filtro.Brightness = data.Brightness
        filtro.Contrast = data.Contrast
        filtro.Saturation = data.Saturation
    end

    destroyFilter()

    local holderCal = Instance.new("Frame", contentColor)
    holderCal.Size = UDim2.new(1,0,0,28)
    holderCal.BackgroundTransparency = 1

    local labelCal = Instance.new("TextLabel", holderCal)
    labelCal.Size = UDim2.new(1,-50,1,0)
    labelCal.BackgroundTransparency = 1
    labelCal.Text = "Enable"
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

    local btnReset = Instance.new("TextButton", contentColor)
    btnReset.Size = UDim2.new(1, 0, 0, 30)
    btnReset.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btnReset.BackgroundTransparency = 0.65
    btnReset.Text = "Reset All"
    btnReset.TextColor3 = Color3.fromRGB(235, 235, 235)
    btnReset.Font = Enum.Font.GothamBold
    btnReset.TextSize = 14
    btnReset.BorderSizePixel = 0
    Instance.new("UICorner", btnReset).CornerRadius = UDim.new(0, 6)

    btnReset.MouseButton1Click:Connect(function()
        TweenService:Create(btnReset, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
        task.wait(0.1)
        TweenService:Create(btnReset, TweenInfo.new(0.1), {BackgroundTransparency = 0.65}):Play()

        data.Brightness = defaultData.Brightness
        data.Contrast = defaultData.Contrast
        data.Saturation = defaultData.Saturation

        resetSlider("Brightness", data.Brightness, -1, 1)
        resetSlider("Contrast", data.Contrast, -1, 1)
        resetSlider("Saturation", data.Saturation, -1, 1)

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
    boxFog.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxFog.BackgroundTransparency = 1
    boxFog.BorderSizePixel = 0
    boxFog.Size = UDim2.new(1,0,0,250)
    boxFog.ClipsDescendants = false
    Instance.new("UICorner", boxFog).CornerRadius = UDim.new(0,8)
    contentFog.ClipsDescendants = false
    Instance.new("UIStroke", boxFog).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentFog).Padding = UDim.new(0, 8)

    local FlashEnabled = false
    local Brightness2 = 5

    local function UpdateFlashlight(state)
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if state then
            local old = hrp:FindFirstChild("Light")
            if old then old:Destroy() end
            local light = Instance.new("PointLight")
            light.Name = "Light"
            light.Range = 120
            light.Shadows = false
            light.Brightness = Brightness2
            light.Parent = hrp
        else
            local old = hrp:FindFirstChild("Light")
            if old then old:Destroy() end
        end
    end

    local holderFlash = Instance.new("Frame", contentFog)
    holderFlash.Size = UDim2.new(1,0,0,28)
    holderFlash.BackgroundTransparency = 1
    local labelFlash = Instance.new("TextLabel", holderFlash)
    labelFlash.Size = UDim2.new(1,-50,1,0)
    labelFlash.BackgroundTransparency = 1
    labelFlash.Text = "Flashlight"
    labelFlash.Font = Enum.Font.GothamBold
    labelFlash.TextSize = 13
    labelFlash.TextColor3 = Color3.fromRGB(235,235,235)
    labelFlash.TextXAlignment = Enum.TextXAlignment.Left
    local btnFlash = Instance.new("TextButton", holderFlash)
    btnFlash.Size = UDim2.new(0,44,0,20)
    btnFlash.Position = UDim2.new(1,-44,0.5,-10)
    btnFlash.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnFlash.BackgroundTransparency = 0.25
    btnFlash.Text = ""
    btnFlash.BorderSizePixel = 0
    Instance.new("UICorner", btnFlash).CornerRadius = UDim.new(1,0)
    local circleFlash = Instance.new("Frame", btnFlash)
    circleFlash.Size = UDim2.new(0,16,0,16)
    circleFlash.Position = UDim2.new(0,2,0.5,-8)
    circleFlash.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circleFlash.BorderSizePixel = 0
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

    CreateSlider(contentFog, "Flashlight Intensity", 1, 10, Brightness2, function(Value)
        Brightness2 = Value
        if FlashEnabled then UpdateFlashlight(true) end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if FlashEnabled then UpdateFlashlight(true) end
    end)

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    local Sky = Lighting:FindFirstChildOfClass("Sky")
    local FogMode = "Black Fog"
    local FogConnection = nil
    local FogEnabled = false

    local function RefreshLighting()
        Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        Sky = Lighting:FindFirstChildOfClass("Sky")
    end

    local function ApplyMode()
        RefreshLighting()
        if not FogEnabled or not Atmosphere or not Sky then return end
        if FogMode == "Black Fog" then
            Atmosphere.Color = Color3.fromRGB(0,0,0)
            Atmosphere.Haze = 2.46
            Sky.MoonAngularSize = 10
            Sky.StarCount = 0
            Atmosphere.Glare = 0
            Atmosphere.Decay = Color3.fromRGB(0,0,0)
            Atmosphere.Density = 0.76
        elseif FogMode == "No Fog" then
            Atmosphere.Color = Color3.fromRGB(0,0,0)
            Atmosphere.Glare = 0
            Atmosphere.Haze = 1
            Atmosphere.Decay = Color3.fromRGB(0,0,0)
            Atmosphere.Density = 0
            Sky.MoonAngularSize = 10
            Sky.StarCount = 0
        end
    end

    local function StartFog()
        RefreshLighting()
        if not Atmosphere or not Sky then return end
        ApplyMode()
        if FogConnection then FogConnection:Disconnect() end
        local lastUpdate = 0
        FogConnection = RunService.RenderStepped:Connect(function()
            if tick() - lastUpdate >= 6 then
                lastUpdate = tick()
                ApplyMode()
            end
        end)
    end

    local function StopFog()
        if FogConnection then FogConnection:Disconnect() FogConnection = nil end
        RefreshLighting()
        local settingsFolder = workspace:FindFirstChild("_LightingSettings", true)
        if not settingsFolder then return end
        local originalAtmosphere = settingsFolder:FindFirstChildOfClass("Atmosphere")
        local originalSky = settingsFolder:FindFirstChildOfClass("Sky")
        if Atmosphere and originalAtmosphere then
            Atmosphere.Color = originalAtmosphere.Color
            Atmosphere.Decay = originalAtmosphere.Decay
            Atmosphere.Density = originalAtmosphere.Density
            Atmosphere.Glare = originalAtmosphere.Glare
            Atmosphere.Haze = originalAtmosphere.Haze
        end
        if Sky and originalSky then
            Sky.MoonAngularSize = originalSky.MoonAngularSize
            Sky.StarCount = originalSky.StarCount
        end
    end

    local holderToggle = Instance.new("Frame", contentFog)
    holderToggle.Size = UDim2.new(1,0,0,28)
    holderToggle.BackgroundTransparency = 1
    local labelToggle = Instance.new("TextLabel", holderToggle)
    labelToggle.Size = UDim2.new(1,-50,1,0)
    labelToggle.BackgroundTransparency = 1
    labelToggle.Text = "Enable Fog"
    labelToggle.Font = Enum.Font.GothamBold
    labelToggle.TextSize = 13
    labelToggle.TextColor3 = Color3.fromRGB(235,235,235)
    labelToggle.TextXAlignment = Enum.TextXAlignment.Left
    local btnToggle = Instance.new("TextButton", holderToggle)
    btnToggle.Size = UDim2.new(0,44,0,20)
    btnToggle.Position = UDim2.new(1,-44,0.5,-10)
    btnToggle.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnToggle.BackgroundTransparency = 1
    btnToggle.Text = ""
    btnToggle.BorderSizePixel = 0
    Instance.new("UICorner", btnToggle).CornerRadius = UDim.new(1,0)
    local circleToggle = Instance.new("Frame", btnToggle)
    circleToggle.Size = UDim2.new(0,16,0,16)
    circleToggle.Position = UDim2.new(0,2,0.5,-8)
    circleToggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circleToggle.BorderSizePixel = 0
    Instance.new("UICorner", circleToggle).CornerRadius = UDim.new(1,0)

    local btnBlack = Instance.new("TextButton", contentFog)
    btnBlack.Size = UDim2.new(1, 0, 0, 30)
    btnBlack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btnBlack.BackgroundTransparency = 0.15
    btnBlack.Text = "Black Fog"
    btnBlack.TextColor3 = Color3.fromRGB(20, 20, 20)
    btnBlack.Font = Enum.Font.GothamBold
    btnBlack.TextSize = 14
    btnBlack.BorderSizePixel = 0
    Instance.new("UICorner", btnBlack).CornerRadius = UDim.new(0, 6)

    local btnNoFog = Instance.new("TextButton", contentFog)
    btnNoFog.Size = UDim2.new(1, 0, 0, 30)
    btnNoFog.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btnNoFog.BackgroundTransparency = 0.65
    btnNoFog.Text = "No Fog"
    btnNoFog.TextColor3 = Color3.fromRGB(235, 235, 235)
    btnNoFog.Font = Enum.Font.GothamBold
    btnNoFog.TextSize = 14
    btnNoFog.BorderSizePixel = 0
    Instance.new("UICorner", btnNoFog).CornerRadius = UDim.new(0, 6)

    local function UpdateButtons()
        if FogMode == "Black Fog" then
            TweenService:Create(btnBlack, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(20,20,20)}):Play()
            TweenService:Create(btnNoFog, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30), BackgroundTransparency = 0.65, TextColor3 = Color3.fromRGB(235,235,235)}):Play()
        else
            TweenService:Create(btnNoFog, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(20,20,20)}):Play()
            TweenService:Create(btnBlack, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30), BackgroundTransparency = 0.65, TextColor3 = Color3.fromRGB(235,235,235)}):Play()
        end
    end

    btnToggle.MouseButton1Click:Connect(function()
        FogEnabled = not FogEnabled
        if FogEnabled then
            TweenService:Create(btnToggle,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(circleToggle,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
            StartFog()
        else
            TweenService:Create(btnToggle,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
            TweenService:Create(circleToggle,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
            StopFog()
        end
    end)

    btnBlack.MouseButton1Click:Connect(function()
        FogMode = "Black Fog"
        UpdateButtons()
        if FogEnabled then ApplyMode() end
    end)

    btnNoFog.MouseButton1Click:Connect(function()
        FogMode = "No Fog"
        UpdateButtons()
        if FogEnabled then ApplyMode() end
    end)
end
    
do
    local settingsPageH = pages["Auto Farm"]

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    Instance.new("UIPadding", columnsH).PaddingTop = UDim.new(0, 10)

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -15, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -15, 0, 0)
    rightColH.Position = UDim2.new(0.5, 1, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local TeleportService = game:GetService("TeleportService")
    local VirtualUser = game:GetService("VirtualUser")
    local Player = Players.LocalPlayer

    if not getgenv().NexFarm then
        getgenv().NexFarm = {
            AutoHackPC = false,
            AutoWinTP = false,
            AutoWinFly = false,
            AutoBeast = false,
            AutoSave = false,
            AutoSaveSilent = false,
            AntiAFK = false,
            AutoRejoin = false,
            FlySpeed = 22,
            TPDelay = 0.5,
            Threads = {}
        }
    end
    local Config = getgenv().NexFarm

    local function getBeast()
        for _,v in pairs(Players:GetPlayers()) do
            local stats = v:FindFirstChild("TempPlayerStatsModule")
            if stats and stats:FindFirstChild("IsBeast") and stats.IsBeast.Value then
                return v
            end
        end
    end

    local function getPCs()
        local pcs = {}
        for _,v in pairs(workspace:GetDescendants()) do
            if v.Name == "ComputerTable" and v:FindFirstChild("Screen") and v:FindFirstChild("Computer") then
                if v.Screen.BrickColor ~= BrickColor.new("Lime green") then
                    table.insert(pcs, v)
                end
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

    local function fireHack(pc)
        if pc and pc:FindFirstChild("Computer") and pc.Computer:FindFirstChild("Hack") then
            local cd = pc.Computer.Hack:FindFirstChild("ClickDetector")
            if cd and fireclickdetector then
                fireclickdetector(cd)
                return true
            end
        end
        return false
    end

    local function getCaptured()
        local captured = {}
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Captive") and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hum = plr.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    table.insert(captured, plr)
                end
            end
        end
        return captured
    end

    local function AutoHackPC()
        while Config.AutoHackPC and task.wait(0.1) do
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
            if getBeast() == Player then task.wait(2) continue end

            local pcs = getPCs()
            if #pcs > 0 then
                local pc = pcs[1]
                local hrp = Player.Character.HumanoidRootPart
                local offset = pc.Screen.CFrame * CFrame.new(-3.5, 0, 0)
                hrp.CFrame = CFrame.new(offset.Position, pc.Screen.Position)
                task.wait(Config.TPDelay)

                for i = 1, 3 do
                    if fireHack(pc) then break end
                    task.wait(0.1)
                end
                task.wait(6.5)
            else
                task.wait(1)
            end
        end
    end

    local function AutoWinTP()
        while Config.AutoWinTP and task.wait(0.1) do
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
            if getBeast() == Player then task.wait(2) continue end

            local hrp = Player.Character.HumanoidRootPart
            local pcs = getPCs()

            if #pcs > 0 then
                local pc = pcs[1]
                local offset = pc.Screen.CFrame * CFrame.new(-3.5, 0, 0)
                hrp.CFrame = CFrame.new(offset.Position, pc.Screen.Position)
                task.wait(Config.TPDelay)

                for i = 1, 3 do
                    if fireHack(pc) then break end
                    task.wait(0.1)
                end
                task.wait(6.5)
            else
                local doors = getDoors()
                if #doors > 0 then
                    hrp.CFrame = doors[1].Door.CFrame + Vector3.new(0, 3, 0)
                end
                task.wait(0.5)
            end
        end
    end

    local function AutoWinFly()
        if Config.Threads.Fly then Config.Threads.Fly:Disconnect() end
        Config.Threads.Fly = RunService.Heartbeat:Connect(function()
            if not Config.AutoWinFly then
                Config.Threads.Fly:Disconnect()
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    Player.Character.HumanoidRootPart.Velocity = Vector3.zero
                end
                return
            end
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
            if getBeast() == Player then return end

            local hrp = Player.Character.HumanoidRootPart
            local pcs = getPCs()

            if #pcs > 0 then
                local pc = pcs[1]
                local target = (pc.Screen.CFrame * CFrame.new(-3.5, 0, 0)).Position
                local dist = (hrp.Position - target).Magnitude
                if dist > 5 then
                    local dir = (target - hrp.Position).Unit
                    hrp.Velocity = dir * Config.FlySpeed
                else
                    hrp.Velocity = Vector3.zero
                    hrp.CFrame = CFrame.new(target, pc.Screen.Position)
                    fireHack(pc)
                    task.wait(6)
                end
            else
                local doors = getDoors()
                if #doors > 0 then
                    local target = doors[1].Door.Position
                    local dir = (target - hrp.Position).Unit
                    hrp.Velocity = dir * Config.FlySpeed
                end
            end
        end)
    end

    local function AutoBeast()
        while Config.AutoBeast and task.wait() do
            if getBeast() ~= Player then task.wait(1) continue end
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") or not Player.Character:FindFirstChild("Humanoid") then task.wait(0.5) continue end

            local hrp = Player.Character.HumanoidRootPart
            local hum = Player.Character.Humanoid
            local tool = Player.Character:FindFirstChildOfClass("Tool")

            if not tool and Player.Backpack:FindFirstChild("Hammer") then
                hum:EquipTool(Player.Backpack.Hammer)
                task.wait()
                tool = Player.Character:FindFirstChildOfClass("Tool")
            end

            local vivos = {}
            for _,plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                    local targetHum = plr.Character.Humanoid
                    if targetHum.Health > 0 and not plr.Character:FindFirstChild("Captive") then
                        table.insert(vivos, plr)
                    end
                end
            end

            if #vivos == 0 then task.wait(0.5) continue end

            for _,plr in pairs(vivos) do
                if not Config.AutoBeast then break end
                if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Captive") then continue end

                local targetHRP = plr.Character.HumanoidRootPart

                for i = 1, 3 do
                    if not plr.Character or plr.Character:FindFirstChild("Captive") then break end
                    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
                    if tool then tool:Activate() end
                    task.wait(0.03)
                end

                local startTime = tick()
                while tick() - startTime < 0.5 and plr.Character and not plr.Character:FindFirstChild("Captive") and Config.AutoBeast do
                    if targetHRP then
                        hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
                        if tool then tool:Activate() end
                    end
                    task.wait()
                end
            end
        end
    end

    local function AutoSave()
        while Config.AutoSave and task.wait(0.1) do
            if getBeast() == Player then task.wait(2) continue end
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end

            local hrp = Player.Character.HumanoidRootPart
            local caps = getCaptured()

            if #caps > 0 then
                for _,plr in pairs(caps) do
                    if not Config.AutoSave then break end
                    if plr.Character and plr.Character:FindFirstChild("Captive") and plr.Character:FindFirstChild("HumanoidRootPart") then           
                        hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                        task.wait(Config.TPDelay)

                        local captive = plr.Character.Captive
                        firetouchinterest(hrp, captive, 0)
                        task.wait(0.1)
                        firetouchinterest(hrp, captive, 1)
                        task.wait(0.3)
                    end
                end
            else
                task.wait(1)
            end
        end
    end

    local function AutoSaveSilent()
        while Config.AutoSaveSilent and task.wait(0.05) do
            if getBeast() == Player then task.wait(2) continue end
            if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end

            local hrp = Player.Character.HumanoidRootPart
            for _,plr in pairs(getCaptured()) do
                if not Config.AutoSaveSilent then break end
                if plr.Character and plr.Character:FindFirstChild("Captive") then
                    local captive = plr.Character.Captive
                    firetouchinterest(hrp, captive, 0)
                    task.wait()
                    firetouchinterest(hrp, captive, 1)
                    task.wait(0.1)
                end
            end
            task.wait(0.2)
        end
    end

    Player.Idled:Connect(function()
        if Config.AntiAFK then
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end)

    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if Config.AutoRejoin and child.Name == "ErrorPrompt" then
            task.wait(5)
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end)

    local boxMain, contentMain = CreateGroupbox(leftColH, "Main Farming")
    boxMain.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxMain.BackgroundTransparency = 1
    boxMain.BorderSizePixel = 0
    boxMain.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxMain).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxMain).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentMain).Padding = UDim.new(0, 8)

    CreateToggle(contentMain, "Auto Hack PC", Config.AutoHackPC, function(v)
        Config.AutoHackPC = v
        if v then task.spawn(AutoHackPC) end
    end)

    CreateToggle(contentMain, "Auto Win Survivor (TP)", Config.AutoWinTP, function(v)
        Config.AutoWinTP = v
        if v then task.spawn(AutoWinTP) end
    end)

    CreateToggle(contentMain, "Auto Win Survivor (Fly)", Config.AutoWinFly, function(v)
        Config.AutoWinFly = v
        if v then AutoWinFly() end
    end)

    CreateToggle(contentMain, "Auto Win Beast", Config.AutoBeast, function(v)
        Config.AutoBeast = v
        if v then task.spawn(AutoBeast) end
    end)

    CreateToggle(contentMain, "Auto Save (TP)", Config.AutoSave, function(v)
        Config.AutoSave = v
        if v then task.spawn(AutoSave) end
    end)

    CreateToggle(contentMain, "Auto Save (Silent)", Config.AutoSaveSilent, function(v)
        Config.AutoSaveSilent = v
        if v then task.spawn(AutoSaveSilent) end
    end)

    local boxSet, contentSet = CreateGroupbox(rightColH, "Farm Settings")
    boxSet.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxSet.BackgroundTransparency = 1
    boxSet.BorderSizePixel = 0
    boxSet.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxSet).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxSet).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentSet).Padding = UDim.new(0, 8)

    CreateToggle(contentSet, "Anti AFK", Config.AntiAFK, function(v)
        Config.AntiAFK = v
    end)

    CreateToggle(contentSet, "Auto Rejoin", Config.AutoRejoin, function(v)
        Config.AutoRejoin = v
    end)
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

    local boxMovement, contentMovement = CreateGroupbox(leftColH, "Movement")
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
        if not hum or not hrp then
            isFlicking = false
            return
        end
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

    CreateToggle(contentMovement, "WalkSpeed", false, function(state)
        speedEnabled = state
        if state then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = speedValue
            end
            if _G.WalkSpeedConnection then _G.WalkSpeedConnection:Disconnect() end
            _G.WalkSpeedConnection = Player.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid").WalkSpeed = speedValue
            end)
        else
            if _G.WalkSpeedConnection then
                _G.WalkSpeedConnection:Disconnect()
                _G.WalkSpeedConnection = nil
            end
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = defaultSpeed
            end
        end
    end)

    CreateSlider(contentMovement, "Speed", 16, 50, 16, function(value)
        speedValue = value
        if speedEnabled then
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = value
            end
        end
    end)

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
            if defaultUseJumpPower then
                humanoid.JumpPower = defaultJumpPower
            else
                humanoid.JumpHeight = defaultJumpHeight
            end
        end
    end

    Player.CharacterAdded:Connect(function()
        task.wait(0.5)
        applyJump()
    end)

    CreateToggle(contentMovement, "High Jump", false, function(state)
        jumpEnabled = state
        applyJump()
    end)

    CreateSlider(contentMovement, "Jump Power", 50, 200, 50, function(value)
        jumpValue = value
        if jumpEnabled then
            applyJump()
        end
    end)

    local crawlBoostEnabled = false
    local crawlBoostSpeed = 22
    local crawlConnection = nil

    CreateToggle(contentMovement, "Crawl Boost", false, function(state)
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
            if crawlConnection then
                crawlConnection:Disconnect()
                crawlConnection = nil
            end
            local char = Player.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                if speedEnabled then
                    humanoid.WalkSpeed = speedValue
                else
                    humanoid.WalkSpeed = defaultSpeed
                end
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
            if systemEnabled then
                systemEnabled = false
                fullStop()
            end
            return
        end
        if not systemEnabled then
            if loadBeastAssets() then
                systemEnabled = true
            else
                return
            end
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
            if classicCamConnection then
                task.cancel(classicCamConnection)
                classicCamConnection = nil
            end
        end
    end)

    CreateToggle(contentRight, "Noclip", false, function(state)
        noclipEnabled = state
    end)

    CreateToggle(contentRight, "Auto Hit Beast", false, function(state)
        autoHitBeast = state
    end)
    CreateSlider(contentRight, "Auto Hit Range", 5, 10, 10, function(value)
        autoHitRange = value
    end)
    CreateSlider(contentRight, "Auto Hit Delay", 0.5, 1.5, 1.0, function(value)
        autoHitDelay = value
    end)

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
            if beastCrawlConnection then
                beastCrawlConnection:Disconnect()
                beastCrawlConnection = nil
            end
        end
    end)

    CreateToggle(contentRight, "Auto Tie", false, function(state)
        autoTie = state
    end)
    CreateToggle(contentRight, "Auto Tie V2", false, function(state)
        autoPegarCorda = state
    end)
    CreateSlider(contentRight, "Auto Tie Range", 5, 50, 15, function(value)
        tieRange = value
    end)

    CreateToggle(contentRight, "Hit Aura", false, function(state)
        hitAura = state
        getgenv().HitAuraAtivo = state
    end)
    CreateSlider(contentRight, "Hit Aura Range", 5, 100, 50, function(value)
        hitRange = value
    end)

    CreateToggle(contentRight, "Enable Hitbox", false, function(state)
        hitbox = state
    end)
    CreateToggle(contentRight, "Hide Hitbox", false, function(state)
        hideHitbox = state
    end)
    CreateSlider(contentRight, "Hitbox X", 2, 10, 5, function(value)
        hitboxX = value
    end)
    CreateSlider(contentRight, "Hitbox Y", 2, 10, 5, function(value)
        hitboxY = value
    end)
    CreateSlider(contentRight, "Hitbox Z", 2, 10, 5, function(value)
        hitboxZ = value
    end)

    RunService.Stepped:Connect(function()
        if noclipEnabled then
            local char = Player.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
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
end

task.spawn(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    local FootstepVolume = 1
    local JumpVolume = 1
    local FallVolume = 1

    local DefaultSounds = {
        Footsteps = "79392671800290",
        Jump = "80853972291847",
        Fall = "88947883822456"
    }

    local SelectedSounds = {
        Footsteps = "79392671800290",
        Jump = "80853972291847",
        Fall = "88947883822456"
    }

    local settingsPageH = pages["Sounds"]

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

    local function GetType(name)
        name = name:lower()
        if name:find("run") or name:find("walk") or name:find("step") or name:find("foot") then
            return "Footsteps"
        end
        if name:find("jump") then
            return "Jump"
        end
        if name:find("fall") or name:find("freefall") then
            return "Fall"
        end
        return nil
    end

    local function ApplySound(soundType, soundId)
        SelectedSounds[soundType] = soundId
        for _, plr in pairs(Players:GetPlayers()) do
            local character = plr.Character
            if character then
                for _, obj in pairs(character:GetDescendants()) do
                    if obj:IsA("Sound") then
                        local t = GetType(obj.Name)
                        if t == soundType then
                            obj.SoundId = "rbxassetid://".. soundId
                            if t == "Footsteps" then obj.Volume = FootstepVolume
                            elseif t == "Jump" then obj.Volume = JumpVolume
                            elseif t == "Fall" then obj.Volume = FallVolume end
                        end
                    end
                end
            end
        end
    end

    local function ApplyAllVolumes()
        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr.Character
            if char then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Sound") then
                        local t = GetType(obj.Name)
                        if t == "Footsteps" then obj.Volume = FootstepVolume
                        elseif t == "Jump" then obj.Volume = JumpVolume
                        elseif t == "Fall" then obj.Volume = FallVolume end
                    end
                end
            end
        end
    end

    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(2)
            ApplySound("Footsteps", SelectedSounds.Footsteps)
            ApplySound("Jump", SelectedSounds.Jump)
            ApplySound("Fall", SelectedSounds.Fall)
        end)
    end)

    task.spawn(function()
        while task.wait(1) do
            ApplyAllVolumes()
        end
    end)

    local function CreateVolumeSlider(parent, text, min, max, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,40)
        holder.BackgroundColor3 = Color3.fromRGB(18,18,22)
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
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.1
                }):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), {
                    Color = Color3.fromRGB(255, 255, 255)
                }):Play()
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    BackgroundTransparency = 0.5
                }):Play()
                TweenService:Create(stroke, TweenInfo.new(0.15), {
                    Color = Color3.fromRGB(90, 90, 90)
                }):Play()
                label.TextColor3 = Color3.fromRGB(220, 220, 220)
            end
        end

        btn.MouseButton1Click:Connect(function()
            ApplySound(soundType, soundId)
            for _, button in ipairs(ActiveButtons[soundType]) do
                button.UpdateVisual()
            end
        end)

        UpdateVisual()
        table.insert(ActiveButtons[soundType], {UpdateVisual = UpdateVisual})
        return btn
    end

    local function CreateResetButton(parent, text, callback)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        btn.BackgroundTransparency = 0.5
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.TextColor3 = Color3.fromRGB(220,220,220)
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(90,90,90)
        stroke.Thickness = 1

        btn.MouseButton1Down:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(255,255,255),
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(255,255,255)
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.12, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(0,0,0)
            }):Play()
        end)

        btn.MouseButton1Up:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(45,45,45),
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(90,90,90)
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(220,220,220)
            }):Play()
            if callback then callback() end
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(45,45,45),
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(stroke, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                Color = Color3.fromRGB(90,90,90)
            }):Play()
            TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(220,220,220)
            }):Play()
        end)

        return btn
    end

    local volumeBox, volumeContent = CreateGroupbox(leftColH, "Volume")
    volumeBox.LayoutOrder = 1

    local footstepSlider = CreateVolumeSlider(volumeContent, "FootSteps", 0, 10, 1, function(v) FootstepVolume = v ApplyAllVolumes() end)
    local jumpSlider = CreateVolumeSlider(volumeContent, "Jump", 0, 10, 1, function(v) JumpVolume = v ApplyAllVolumes() end)
    local fallSlider = CreateVolumeSlider(volumeContent, "Fall", 0, 10, 1, function(v) FallVolume = v ApplyAllVolumes() end)

    CreateResetButton(volumeContent, "Reset Volumes", function()
        FootstepVolume = 1
        JumpVolume = 1
        FallVolume = 1
        footstepSlider.SetValue(1)
        jumpSlider.SetValue(1)
        fallSlider.SetValue(1)
        ApplyAllVolumes()
    end)

    CreateResetButton(volumeContent, "Reset Sounds", function()
        ApplySound("Footsteps", DefaultSounds.Footsteps)
        ApplySound("Jump", DefaultSounds.Jump)
        ApplySound("Fall", DefaultSounds.Fall)
        for _, soundType in pairs({"Footsteps", "Jump", "Fall"}) do
            for _, button in ipairs(ActiveButtons[soundType]) do
                button.UpdateVisual()
            end
        end
    end)

    local facilityCat, facilityContent = CreateGroupbox(leftColH, "Facility Gamer")
    facilityCat.LayoutOrder = 2
    CreateSoundButton(facilityContent, "FootSteps", "Footsteps", "131592620665625")
    CreateSoundButton(facilityContent, "Jump", "Jump", "89459688918065")

    local morcegoCat, morcegoContent = CreateGroupbox(leftColH, "Tio Morcego")
    morcegoCat.LayoutOrder = 3
    CreateSoundButton(morcegoContent, "FootSteps", "Footsteps", "97458293386939")
    CreateSoundButton(morcegoContent, "Jump", "Jump", "72503238596964")
    CreateSoundButton(morcegoContent, "Fall", "Fall", "83702883984130")

    local extrasCat, extrasContent = CreateGroupbox(leftColH, "Extras Jumps")
    extrasCat.LayoutOrder = 4
    CreateSoundButton(extrasContent, "Pew Jump", "Jump", "136299701781122")
    CreateSoundButton(extrasContent, "Sharingan Jump", "Jump", "118102230060662")
    CreateSoundButton(extrasContent, "Bubble Jump", "Jump", "129415490412106")
    CreateSoundButton(extrasContent, "RF Jump", "Jump", "80276851298640")

    local normalCat, normalContent = CreateGroupbox(rightColH, "Normal")
    normalCat.LayoutOrder = 1
    CreateSoundButton(normalContent, "FootSteps", "Footsteps", "79392671800290")
    CreateSoundButton(normalContent, "Jump", "Jump", "80853972291847")
    CreateSoundButton(normalContent, "Fall", "Fall", "88947883822456")

    local noobCat, noobContent = CreateGroupbox(rightColH, "NoobTwoPointOh")
    noobCat.LayoutOrder = 2
    CreateSoundButton(noobContent, "FootSteps", "Footsteps", "110709356093026")
    CreateSoundButton(noobContent, "Jump", "Jump", "124276657634407")

    local fkpsCat, fkpsContent = CreateGroupbox(rightColH, "FKPS")
    fkpsCat.LayoutOrder = 3
    CreateSoundButton(fkpsContent, "FootSteps", "Footsteps", "97733831736820")
    CreateSoundButton(fkpsContent, "Jump", "Jump", "86031664547378")
    CreateSoundButton(fkpsContent, "Fall", "Fall", "78180192109919")

    task.wait(1)
    ApplySound("Footsteps", SelectedSounds.Footsteps)
    ApplySound("Jump", SelectedSounds.Jump)
    ApplySound("Fall", SelectedSounds.Fall)
end)

do
    local settingsPageH = pages["Music"]
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

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

    local mainCol = Instance.new("Frame", columnsH)
    mainCol.Name = "MainColumn"
    mainCol.Size = UDim2.new(1, 0, 1, 0)
    mainCol.BackgroundTransparency = 1

    local listLayout = Instance.new("UIListLayout", mainCol)
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local box, content = CreateGroupbox(mainCol, "Music Player")
    box.LayoutOrder = 1

    local sound = Instance.new("Sound", workspace)
    sound.Looped = true
    sound.Volume = 0.5
    local playing = false

    do
        local holder = Instance.new("Frame", content)
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
            sound.Volume = scale
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
                    if isDragging and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
                        updateVolume(input2.Position.X)
                    end
                end)

                endConnection = UserInputService.InputEnded:Connect(function(input2)
                    if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                        stopDragging()
                    end
                end)
            end
        end)

        settingsPageH.AncestryChanged:Connect(function()
            if not settingsPageH:IsDescendantOf(game) then
                stopDragging()
            end
        end)
    end

    do
        local holder = Instance.new("Frame", content)
        holder.Size = UDim2.new(1,0,0,32)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 2

        local layout = Instance.new("UIListLayout", holder)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, 8)

        local idBox = Instance.new("TextBox", holder)
        idBox.Size = UDim2.new(0.33, -5, 1, 0)
        idBox.PlaceholderText = "Insert ID..."
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
        dropdown.Text = "Select Song"
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

        local dropdownList = Instance.new("ScrollingFrame", content)
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

        local listLayout = Instance.new("UIListLayout", dropdownList)
        listLayout.Padding = UDim.new(0,0)

        local isOpen = false
        local songs = {
            {"six seven","139780631670217"}, 
            {"low cortisol","110919391228823"},
            {"His Love","140684861805080"},
            {"7 years of trying","909647887628820"},
            {"7 years","115598617339786"},
            {"Never Alone","86404842974521"},
            {"its you","139010646759693"},
            {"Ariana Grande","111795743730164"},
            {"King Nasir Phonk","76650356472656"},
            {"METAMORPHOSIS","15689451063"},
            {"Sin Teen","121242950842428"},
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

            option.MouseEnter:Connect(function()
                TweenService:Create(option, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)
            option.MouseLeave:Connect(function()
                TweenService:Create(option, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(180,180,185)}):Play()
            end)

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
            if playing then
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
            if not playing then
                if idBox.Text ~= "" then
                    sound.SoundId = "rbxassetid://".. idBox.Text
                    sound:Play()
                    playing = true
                    UpdatePlayVisual()
                end
            else
                sound:Stop()
                playing = false
                UpdatePlayVisual()
            end
        end)
    end
end

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
            -- EFEITO FLASH BRANCO
            TweenService:Create(btn, TweenInfo.new(0.08), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            task.delay(0.08, function()
                TweenService:Create(btn, TweenInfo.new(0.12), {TextColor3 = originalColor}):Play()
            end)

            -- executa a função
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
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local Player = game:GetService("Players").LocalPlayer
    local playerGui = Player:WaitForChild("PlayerGui")

    for _,v in pairs(settingsPageH:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end

    local function GetMainFrame()
        return frame or playerGui:WaitForChild("EclipseUI", 5):FindFirstChild("Main", true)
    end

    local isPC = UserInputService.KeyboardEnabled -- detecta se é PC

    if not isfolder("FTF_Eclipse") then makefolder("FTF_Eclipse") end

    local backgrounds = {
        {"Style 1", "94148533276635"},
        {"Style 2", "97984932480755"},
        {"Style 3", "86192845180549"},
        {"Style 4", "85784609294289"},
        {"Style 5", "140636010520663"},
        {"Style 6", "124240486073107"},
        {"Style 7", "85635291549219"},
        {"Style 8", "117512819334968"},
        {"Style 9", "111750153717391"},
        {"Style 10", "98791036867631"},
        {"Style 11", "131737959610359"},
        {"Style 12", "81997082602790"},
        {"Style 13", "117151748213203"},
        {"Style 14", "112483283923855"},
        {"Style 15", "109490272700736"},
        {"Style 16", "125661929366351"},
        {"Style 17", "74184537251110"},
        {"Style 18", "124786302962772"},
        {"Style 19", "125474858681812"},
        {"Style 20", "99142368271124"},
        {"Style 21", "94865353552525"},
        {"Style 22", "120484401704545"},
    }

    getgenv().BackgroundLocked = getgenv().BackgroundLocked or false

    local function SaveConfig()
        local data = {
            MenuKeybind = getgenv().MenuKeybind or "K",
            BackgroundID = getgenv().CustomBackgroundID or "",
            UIBackground = getgenv().UIBackground or "Style 1",
            Font = getgenv().UIFont or "Gotham",
            BackgroundLocked = getgenv().BackgroundLocked
        }
        writefile("FTF_Eclipse/config.json", HttpService:JSONEncode(data))
    end

    local function LoadConfig()
        if isfile("FTF_Eclipse/config.json") then
            local data = HttpService:JSONDecode(readfile("FTF_Eclipse/config.json"))
            getgenv().MenuKeybind = data.MenuKeybind or "K"
            getgenv().CustomBackgroundID = data.BackgroundID or ""
            getgenv().UIBackground = data.UIBackground or "Style 1"
            getgenv().UIFont = data.Font or "Gotham"
            getgenv().BackgroundLocked = data.BackgroundLocked or false
            return data
        else
            getgenv().MenuKeybind = "K"
            getgenv().UIBackground = "Style 1"
            getgenv().UIFont = "Gotham"
            getgenv().CustomBackgroundID = ""
            getgenv().BackgroundLocked = false
            SaveConfig()
            return nil
        end
    end

    LoadConfig()

    local container = Instance.new("Frame", settingsPageH)
    container.Size = UDim2.new(1, -20, 1, 0)
    container.Position = UDim2.new(0, 10, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 10)
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

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
            bg.BackgroundTransparency = 1
            bg.Image = "rbxassetid://".. id
            bg.ImageTransparency = 0.15
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 0
        end
    end

    local function ToggleMenu()
        local gui = playerGui:FindFirstChild("EclipseUI")
        if gui then
            gui.Enabled = not gui.Enabled
            if isPC and openButton then openButton.Visible = false end
        end
    end

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
    end
    ApplyFont(CurrentFont)

    local boxSettings, contentSettings = CreateGroupbox(container, "Settings")
    boxSettings.BackgroundTransparency = 1
    boxSettings.BorderSizePixel = 0
    boxSettings.Size = UDim2.new(1,0,1,0)
    boxSettings.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxSettings).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxSettings).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentSettings).Padding = UDim.new(0, 10)

    -- KEYBIND SETTINGS
    do
        local holder = Instance.new("Frame", contentSettings)
        holder.Size = UDim2.new(1,0,0,35)
        holder.BackgroundColor3 = Color3.fromRGB(0,0,0)
        holder.BackgroundTransparency = 0.3
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,6)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-75,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = "Menu Keybind:"
        label.Font = CurrentFont
        label.TextSize = 14
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local keyBtn = Instance.new("TextButton", holder)
        keyBtn.Size = UDim2.new(0,55,0,24)
        keyBtn.Position = UDim2.new(1,-65,0.5,-12)
        keyBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
        keyBtn.BackgroundTransparency = 0.2
        keyBtn.Text = getgenv().MenuKeybind or "K"
        keyBtn.Font = CurrentFont
        keyBtn.TextSize = 13
        keyBtn.TextColor3 = Color3.fromRGB(255,255,255)
        keyBtn.BorderSizePixel = 0
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,5)

        local listening = false
        keyBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            keyBtn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    getgenv().MenuKeybind = input.KeyCode.Name
                    keyBtn.Text = input.KeyCode.Name
                    SaveConfig()
                    listening = false
                    conn:Disconnect()
                end
            end)
        end)

        if getgenv().KeybindConnection then getgenv().KeybindConnection:Disconnect() end
        getgenv().KeybindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode.Name == (getgenv().MenuKeybind or "K") then
                ToggleMenu()
            end
        end)
    end

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
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
        dropdownFrame.BackgroundTransparency = 0.05
        dropdownFrame.ClipsDescendants = true
        Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,6)
        Instance.new("UIStroke", dropdownFrame).Color = Color3.fromRGB(45,45,50)
        Instance.new("UIListLayout", dropdownFrame).Padding = UDim.new(0,0)

        local isOpen = false
        local dropdownHeight = #list * 34

        for i, data in ipairs(list) do
            local option = Instance.new("TextButton", dropdownFrame)
            option.Size = UDim2.new(1,0,0,34)
            option.BackgroundTransparency = 1
            option.Text = type(data) == "table" and data[1] or data
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

            option.MouseEnter:Connect(function()
                TweenService:Create(option, TweenInfo.new(0.12), {BackgroundTransparency = 0.85}):Play()
                TweenService:Create(option, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)
            option.MouseLeave:Connect(function()
                TweenService:Create(option, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
                TweenService:Create(option, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(170,170,170)}):Play()
            end)

            option.MouseButton1Click:Connect(function()
                local value = type(data) == "table" and data[1] or data
                label.Text = labelText..": "..value
                callback(data)
                TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,-8,0,0)}):Play()
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
                task.wait(0.25)
                isOpen = false
            end)
        end

        clickArea.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 180}):Play()
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,-8,0,dropdownHeight)}):Play()
            else
                TweenService:Create(arrow, TweenInfo.new(0.25), {Rotation = 0}):Play()
                TweenService:Create(dropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1,-8,0,0)}):Play()
            end
        end)
    end

    CreateDropdown(contentSettings, "UI Background", backgrounds, getgenv().UIBackground, function(data)
        getgenv().UIBackground = data[1]
        getgenv().CustomBackgroundID = "rbxassetid://".. data[2]
        getgenv().BackgroundLocked = true
        UpdateBackground(data[2], true)
        SaveConfig()
    end)

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
                    getgenv().CustomBackgroundID = "rbxassetid://".. id
                    getgenv().BackgroundLocked = true
                    UpdateBackground(id, true)
                    SaveConfig()
                end
            end
        end)
    end

    local fonts = {}
    for _, font in pairs(Enum.Font:GetEnumItems()) do
        table.insert(fonts, font.Name)
    end
    table.sort(fonts)

    CreateDropdown(contentSettings, "UI Font", fonts, getgenv().UIFont, function(fontName)
        getgenv().UIFont = fontName
        ApplyFont(Enum.Font[fontName])
        SaveConfig()
    end)

    task.spawn(function()
        task.wait(0.5)
        if getgenv().BackgroundLocked and getgenv().CustomBackgroundID ~= "" then
            local id = getgenv().CustomBackgroundID:match("%d+")
            if id then UpdateBackground(id, true) end
        else
            UpdateBackground(backgrounds[1][2], false)
        end
    end)

    if isPC and openButton then
        openButton.Visible = false
    end
end

local currentLanguage = "EN"
local Translation = {
	EN = {
		Search = "Search...",
		Info = "INFO",
		Exit = "Exit Eclipse",
		ExitText = "Are you sure you want to close the script? You will\nneed to re-execute to open it again.",
		Cancel = "Cancel",
		YesExit = "Yes, Exit",
		Close = "Close",
		Minimize = "Minimize",
		Credits = "CREDITS",
		Testers = "TESTERS",
		PlayerInfo = "PLAYER INFO",
		ServerInfo = "SERVER INFO",
		Thanks = "Thank you for using Eclipse.",
		Owner = "Owner: @kayqueneverxita.",
		CoOwner = "Co-owner: @gustavo_bawnana & @x67j",
		TestersList = "Testers: Luan, Vitor & Mz",
		FPS = "FPS",
		Ping = "Ping",
		Executor = "Executor",
		Region = "Region: BR",
		Players = "Players",
		MaxPlayers = "Max Players"
	},
	PT = {
		Search = "Pesquisar...",
		Info = "INFORMAÇÕES",
		Exit = "Sair do Eclipse",
		ExitText = "Tem certeza que quer fechar o script? Você\nprecisará executar novamente para abrir.",
		Cancel = "Cancelar",
		YesExit = "Sim, Sair",
		Close = "Fechar",
		Minimize = "Minimizar",
		Credits = "CRÉDITOS",
		Testers = "TESTADORES",
		PlayerInfo = "INFO DO PLAYER",
		ServerInfo = "INFO DO SERVIDOR",
		Thanks = "Obrigado por usar Eclipse.",
		Owner = "Dono: @kayqueneverxita.",
		CoOwner = "Sub-Dono: @gustavo_bawnana & @x67j",
		TestersList = "Testadores: Luan, Vitor & Mz",
		FPS = "FPS",
		Ping = "Ping",
		Executor = "Executor",
		Region = "Região: BR",
		Players = "Jogadores",
		MaxPlayers = "Máx Jogadores"
	}
}

local TranslatableElements = {}
local AllSearchable = {}

local function AddTranslatable(element, key)
	TranslatableElements[element] = key
end

local function AddToSearch(element, name)
	if element then
		AllSearchable[element] = name:lower()
	end
end

local function UpdateLanguage()
	langBtn.Text = currentLanguage
	searchInput.PlaceholderText = Translation[currentLanguage].Search
	
	for element, key in pairs(TranslatableElements) do
		if element and element.Parent then
			element.Text = Translation[currentLanguage][key] or key
		end
	end
end

langBtn.MouseButton1Click:Connect(function()
	currentLanguage = currentLanguage == "EN" and "PT" or "EN"
	UpdateLanguage()
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
			local visible = string.find(name, text, 1, true) ~= nil
			element.Visible = visible
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
        for _,v in pairs(E.conns) do
            if typeof(v) == "RBXScriptConnection" then v:Disconnect()
            elseif typeof(v) == "thread" then task.cancel(v) end
        end
    end

    E.frame = Instance.new("Frame")
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
    MakeLabel(g.cc, "Owner: @Kayque", false, "Owner")
    MakeLabel(g.cc, "Co-owner: @gustavo_bawnana & @x67j", false, "CoOwner")
    MakeLabel(g.cc, "Administrator: Teste", false, "Administrator: @skztv157")
    MakeLabel(g.tc, "Testers: Luan, Vitor & Mz", false, "TestersList")

    E.fps = MakeLabel(g.pc, "FPS: 60", true)
    E.ping = MakeLabel(g.pc, "Ping: 0 ms", true)
    MakeLabel(g.pc, "Executor: ".. (identifyexecutor and identifyexecutor() or "Unknown"), true)

    MakeLabel(g.sc, "Region: BR", true, "Region")
    MakeLabel(g.sc, "Players: ".. #Players:GetPlayers(), true)
    MakeLabel(g.sc, "Max Players: ".. Players.MaxPlayers, true)

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
    AddTranslatable(E.thanks, "Thanks")

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
        E.lastTime = tick()
        E.conns.hb = RunService.Heartbeat:Connect(function()
            local now = tick()
            local fps = 1 / (now - E.lastTime)
            E.lastTime = now
            if E.frame.Visible then
                E.fps.Text = "FPS: ".. math.floor(fps)
            end
        end)

        E.conns.ping = task.spawn(function()
            while E.frame.Visible do
                pcall(function()
                    local v = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                    E.ping.Text = "Ping: ".. math.floor(v).. " ms"
                end)
                task.wait(0.5)
            end
        end)
    end

    function E.Stop()
        if E.conns.hb then E.conns.hb:Disconnect() E.conns.hb = nil end
        if E.conns.ping then task.cancel(E.conns.ping) E.conns.ping = nil end
    end

    function E.Open()
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

    C.frame = Instance.new("Frame")
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

    C.title = Instance.new("TextLabel", C.frame)
    C.title.Size = UDim2.new(1, 0, 0, 50)
    C.title.Position = UDim2.new(0, 0, 0, 10)
    C.title.BackgroundTransparency = 1
    C.title.Text = "Exit Eclipse"
    C.title.Font = Enum.Font.GothamBold
    C.title.TextSize = 18
    C.title.TextColor3 = Color3.fromRGB(255, 255, 255)
    C.title.TextTransparency = 1
    C.title.ZIndex = 11
    AddTranslatable(C.title, "Exit")

    C.text = Instance.new("TextLabel", C.frame)
    C.text.Size = UDim2.new(1, -40, 0, 50)
    C.text.Position = UDim2.new(0, 20, 0, 50)
    C.text.BackgroundTransparency = 1
    C.text.Text = "Are you sure you want to close the script? You will\nneed to re-execute to open it again."
    C.text.TextWrapped = true
    C.text.Font = Enum.Font.Gotham
    C.text.TextSize = 13
    C.text.TextColor3 = Color3.fromRGB(180, 180, 180)
    C.text.TextTransparency = 1
    C.text.ZIndex = 11
    AddTranslatable(C.text, "ExitText")

    C.cancelBtn = Instance.new("TextButton", C.frame)
    C.cancelBtn.Size = UDim2.new(0, 120, 0, 35)
    C.cancelBtn.Position = UDim2.new(0, 35, 1, -50)
    C.cancelBtn.Text = "Cancel"
    C.cancelBtn.Font = Enum.Font.GothamBold
    C.cancelBtn.TextSize = 14
    C.cancelBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    C.cancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    C.cancelBtn.BackgroundTransparency = 1
    C.cancelBtn.TextTransparency = 1
    C.cancelBtn.ZIndex = 11
    Instance.new("UICorner", C.cancelBtn).CornerRadius = UDim.new(0, 6)
    AddTranslatable(C.cancelBtn, "Cancel")

    C.exitBtn = Instance.new("TextButton", C.frame)
    C.exitBtn.Size = UDim2.new(0, 120, 0, 35)
    C.exitBtn.Position = UDim2.new(1, -155, 1, -50)
    C.exitBtn.Text = "Yes, Exit"
    C.exitBtn.Font = Enum.Font.GothamBold
    C.exitBtn.TextSize = 14
    C.exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    C.exitBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    C.exitBtn.BackgroundTransparency = 1
    C.exitBtn.TextTransparency = 1
    C.exitBtn.ZIndex = 11
    Instance.new("UICorner", C.exitBtn).CornerRadius = UDim.new(0, 6)
    AddTranslatable(C.exitBtn, "YesExit")

    local exitGradient = Instance.new("UIGradient", C.exitBtn)
    exitGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 30, 30))
    }
    exitGradient.Rotation = 90

    function C.Open()
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
    miniBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        if not isPC and openButton then openButton.Visible = true end
        if blur then blur.Size = 0 end
    end)

    openButton.MouseButton1Click:Connect(function()
        frame.Visible = true
        openButton.Visible = false
        if blur then blur.Size = 20 end
    end)
end

UpdateLanguage()
