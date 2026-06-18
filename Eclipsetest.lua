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
gui.Parent = playerGui

local ANNOUNCE_FILE = "EclipseAnnounce.json"
local announceData = {seen = false}

local announceTexts = {
    EN = {
        title = "Welcome to Eclipse!",
        subtitle = "A New Beginning",
        desc1 = "After thinking a lot about the future of Eclipse, I decided to start a completely new project. Most of this Hub was built by me, with a little help from a friend for some code sharing and testing.",
        desc2 = "Creating everything from scratch has been a huge challenge. Many systems break during development and need to be rebuilt several times, but I'm doing my best to create a better and more stable experience for everyone.",
        subtitle2 = "What happened to the old Eclipse?",
        desc3 = "The old Eclipse was based on a style and structure that no longer matched what I wanted for the project. After a long time working with that model, I decided to leave it behind and build my own unique Hub.",
        desc4 = "This new version gives me more freedom to add features, improve performance, and keep the project growing. I hope you enjoy this new chapter as much as I enjoyed creating it.",
        subtitle3 = "About missing scripts and bugs",
        desc5 = "Some features from previous versions may not be available yet, and you might find occasional bugs while the Hub continues to evolve.",
        desc6 = "I will keep working hard to bring back important systems and improve existing ones. If you notice a missing script or any problem, please let me know through the Discord server.",
        btn_discord = "DISCORD",
        btn_exit = "EXIT"
    },
    PT = {
        title = "Bem-vindo ao Eclipse!",
        subtitle = "Um Novo Começo",
        desc1 = "Depois de pensar muito sobre o futuro do Eclipse, decidi começar um projeto completamente novo. A maior parte deste Hub foi construída por mim, com uma pequena ajuda de um amigo para compartilhamento de código e testes.",
        desc2 = "Criar tudo do zero tem sido um desafio enorme. Muitos sistemas quebram durante o desenvolvimento e precisam ser reconstruídos várias vezes, mas estou fazendo o meu melhor para criar uma experiência melhor e mais estável para todos.",
        subtitle2 = "O que aconteceu com o Eclipse antigo?",
        desc3 = "O Eclipse antigo era baseado em um estilo e estrutura que não combinavam mais com o que eu queria para o projeto. Depois de muito tempo trabalhando com esse modelo, decidi deixá-lo para trás e construir meu próprio Hub único.",
        desc4 = "Esta nova versão me dá mais liberdade para adicionar recursos, melhorar o desempenho e manter o projeto crescendo. Espero que você aproveite este novo capítulo tanto quanto eu gostei de criá-lo.",
        subtitle3 = "Sobre scripts ausentes e bugs",
        desc5 = "Alguns recursos de versões anteriores podem não estar disponíveis ainda, e você pode encontrar bugs ocasionais enquanto o Hub continua evoluindo.",
        desc6 = "Vou continuar trabalhando duro para trazer de volta sistemas importantes e melhorar os existentes. Se você notar um script ausente ou qualquer problema, por favor me avise através do servidor do Discord.",
        btn_discord = "DISCORD",
        btn_exit = "SAIR"
    }
}

local function canUseFile()
    return writefile and readfile and isfile
end

local function loadAnnounce()
    if canUseFile() and isfile(ANNOUNCE_FILE) then
        local success, loaded = pcall(function()
            return HttpService:JSONDecode(readfile(ANNOUNCE_FILE))
        end)
        if success and typeof(loaded) == "table" then
            announceData = loaded
        end
    end
end

local function saveAnnounce()
    if not canUseFile() then return end
    pcall(function()
        writefile(ANNOUNCE_FILE, HttpService:JSONEncode(announceData))
    end)
end

loadAnnounce()

if not announceData.seen then
    local announceFrame = Instance.new("Frame", gui)
    announceFrame.Size = UDim2.new(0, 0, 0, 0)
    announceFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    announceFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    announceFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    announceFrame.BackgroundTransparency = 0.05
    announceFrame.ZIndex = 100
    Instance.new("UICorner", announceFrame).CornerRadius = UDim.new(0, 12)

    local announceStroke = Instance.new("UIStroke", announceFrame)
    announceStroke.Color = Color3.fromRGB(255, 0, 0)
    announceStroke.Thickness = 2
    announceStroke.Transparency = 0

    local announceLangBtn = Instance.new("TextButton", announceFrame)
    announceLangBtn.Size = UDim2.new(0, 32, 0, 28)
    announceLangBtn.Position = UDim2.new(1, -42, 0, 10)
    announceLangBtn.Text = currentLang
    announceLangBtn.BackgroundColor3 = Color3.fromRGB(35, 35)
    announceLangBtn.BackgroundTransparency = 0.3
    announceLangBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    announceLangBtn.TextSize = 15
    announceLangBtn.Font = Enum.Font.GothamBold
    announceLangBtn.ZIndex = 102
    Instance.new("UICorner", announceLangBtn).CornerRadius = UDim.new(0, 6)

    local announceTitle = Instance.new("TextLabel", announceFrame)
    announceTitle.Size = UDim2.new(1, -60, 0, 30)
    announceTitle.Position = UDim2.new(0, 20, 0, 15)
    announceTitle.BackgroundTransparency = 1
    announceTitle.Text = announceTexts[currentLang].title
    announceTitle.Font = Enum.Font.GothamBold
    announceTitle.TextSize = 18
    announceTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    announceTitle.TextXAlignment = Enum.TextXAlignment.Center
    announceTitle.ZIndex = 101

    local scrollFrame = Instance.new("ScrollingFrame", announceFrame)
    scrollFrame.Size = UDim2.new(1, -40, 1, -100)
    scrollFrame.Position = UDim2.new(0, 20, 0, 50)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.ZIndex = 101

    local textLayout = Instance.new("UIListLayout", scrollFrame)
    textLayout.Padding = UDim.new(0, 8)
    textLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local subtitle1 = Instance.new("TextLabel", scrollFrame)
    subtitle1.Size = UDim2.new(1, -10, 0, 20)
    subtitle1.BackgroundTransparency = 1
    subtitle1.Text = announceTexts[currentLang].subtitle
    subtitle1.Font = Enum.Font.GothamBold
    subtitle1.TextSize = 14
    subtitle1.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle1.TextXAlignment = Enum.TextXAlignment.Center
    subtitle1.ZIndex = 101
    subtitle1.LayoutOrder = 1

    local desc1 = Instance.new("TextLabel", scrollFrame)
    desc1.Size = UDim2.new(1, -10, 0, 0)
    desc1.AutomaticSize = Enum.AutomaticSize.Y
    desc1.BackgroundTransparency = 1
    desc1.Text = announceTexts[currentLang].desc1
    desc1.Font = Enum.Font.Gotham
    desc1.TextSize = 13
    desc1.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc1.TextXAlignment = Enum.TextXAlignment.Center
    desc1.TextYAlignment = Enum.TextYAlignment.Top
    desc1.TextWrapped = true
    desc1.ZIndex = 101
    desc1.LayoutOrder = 2

    local desc2 = Instance.new("TextLabel", scrollFrame)
    desc2.Size = UDim2.new(1, -10, 0, 0)
    desc2.AutomaticSize = Enum.AutomaticSize.Y
    desc2.BackgroundTransparency = 1
    desc2.Text = announceTexts[currentLang].desc2
    desc2.Font = Enum.Font.Gotham
    desc2.TextSize = 13
    desc2.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc2.TextXAlignment = Enum.TextXAlignment.Center
    desc2.TextYAlignment = Enum.TextYAlignment.Top
    desc2.TextWrapped = true
    desc2.ZIndex = 101
    desc2.LayoutOrder = 3

    local subtitle2 = Instance.new("TextLabel", scrollFrame)
    subtitle2.Size = UDim2.new(1, -10, 0, 20)
    subtitle2.BackgroundTransparency = 1
    subtitle2.Text = announceTexts[currentLang].subtitle2
    subtitle2.Font = Enum.Font.GothamBold
    subtitle2.TextSize = 14
    subtitle2.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle2.TextXAlignment = Enum.TextXAlignment.Center
    subtitle2.ZIndex = 101
    subtitle2.LayoutOrder = 4

    local desc3 = Instance.new("TextLabel", scrollFrame)
    desc3.Size = UDim2.new(1, -10, 0, 0)
    desc3.AutomaticSize = Enum.AutomaticSize.Y
    desc3.BackgroundTransparency = 1
    desc3.Text = announceTexts[currentLang].desc3
    desc3.Font = Enum.Font.Gotham
    desc3.TextSize = 13
    desc3.TextColor3 = Color3.fromRGB(220, 220)
    desc3.TextXAlignment = Enum.TextXAlignment.Center
    desc3.TextYAlignment = Enum.TextYAlignment.Top
    desc3.TextWrapped = true
    desc3.ZIndex = 101
    desc3.LayoutOrder = 5

    local desc4 = Instance.new("TextLabel", scrollFrame)
    desc4.Size = UDim2.new(1, -10, 0, 0)
    desc4.AutomaticSize = Enum.AutomaticSize.Y
    desc4.BackgroundTransparency = 1
    desc4.Text = announceTexts[currentLang].desc4
    desc4.Font = Enum.Font.Gotham
    desc4.TextSize = 13
    desc4.TextColor3 = Color3.fromRGB(220, 220)
    desc4.TextXAlignment = Enum.TextXAlignment.Center
    desc4.TextYAlignment = Enum.TextYAlignment.Top
    desc4.TextWrapped = true
    desc4.ZIndex = 101
    desc4.LayoutOrder = 6

    local subtitle3 = Instance.new("TextLabel", scrollFrame)
    subtitle3.Size = UDim2.new(1, -10, 0, 20)
    subtitle3.BackgroundTransparency = 1
    subtitle3.Text = announceTexts[currentLang].subtitle3
    subtitle3.Font = Enum.Font.GothamBold
    subtitle3.TextSize = 14
    subtitle3.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle3.TextXAlignment = Enum.TextXAlignment.Center
    subtitle3.ZIndex = 101
    subtitle3.LayoutOrder = 7

    local desc5 = Instance.new("TextLabel", scrollFrame)
    desc5.Size = UDim2.new(1, -10, 0, 0)
    desc5.AutomaticSize = Enum.AutomaticSize.Y
    desc5.BackgroundTransparency = 1
    desc5.Text = announceTexts[currentLang].desc5
    desc5.Font = Enum.Font.Gotham
    desc5.TextSize = 13
    desc5.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc5.TextXAlignment = Enum.TextXAlignment.Center
    desc5.TextYAlignment = Enum.TextYAlignment.Top
    desc5.TextWrapped = true
    desc5.ZIndex = 101
    desc5.LayoutOrder = 8

    local desc6 = Instance.new("TextLabel", scrollFrame)
    desc6.Size = UDim2.new(1, -10, 0, 0)
    desc6.AutomaticSize = Enum.AutomaticSize.Y
    desc6.BackgroundTransparency = 1
    desc6.Text = announceTexts[currentLang].desc6
    desc6.Font = Enum.Font.Gotham
    desc6.TextSize = 13
    desc6.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc6.TextXAlignment = Enum.TextXAlignment.Center
    desc6.TextYAlignment = Enum.TextYAlignment.Top
    desc6.TextWrapped = true
    desc6.ZIndex = 101
    desc6.LayoutOrder = 9

    local btnFrame = Instance.new("Frame", announceFrame)
    btnFrame.Size = UDim2.new(1, -40, 0, 32)
    btnFrame.Position = UDim2.new(0, 20, 1, -42)
    btnFrame.BackgroundTransparency = 1
    btnFrame.ZIndex = 101

    local discordBtn = Instance.new("TextButton", btnFrame)
    discordBtn.Size = UDim2.new(0.48, 0, 1, 0)
    discordBtn.Position = UDim2.new(0, 0, 0, 0)
    discordBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    discordBtn.Text = announceTexts[currentLang].btn_discord
    discordBtn.TextColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 14
    discordBtn.ZIndex = 102
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)

    local exitBtn = Instance.new("TextButton", btnFrame)
    exitBtn.Size = UDim2.new(0.48, 0, 1, 0)
    exitBtn.Position = UDim2.new(0.52, 0, 0, 0)
    exitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    exitBtn.Text = announceTexts[currentLang].btn_exit
    exitBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
    exitBtn.Font = Enum.Font.GothamBold
    exitBtn.TextSize = 14
    exitBtn.ZIndex = 102
    Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(0, 8)

    TweenService:Create(announceFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 450, 0, 350)
    }):Play()

    local function updateAnnounceLang()
        currentLang = currentLang == "EN" and "PT" or "EN"
        announceLangBtn.Text = currentLang
        announceTitle.Text = announceTexts[currentLang].title
        subtitle1.Text = announceTexts[currentLang].subtitle
        desc1.Text = announceTexts[currentLang].desc1
        desc2.Text = announceTexts[currentLang].desc2
        subtitle2.Text = announceTexts[currentLang].subtitle2
        desc3.Text = announceTexts[currentLang].desc3
        desc4.Text = announceTexts[currentLang].desc4
        subtitle3.Text = announceTexts[currentLang].subtitle3
        desc5.Text = announceTexts[currentLang].desc5
        desc6.Text = announceTexts[currentLang].desc6
        discordBtn.Text = announceTexts[currentLang].btn_discord
        exitBtn.Text = announceTexts[currentLang].btn_exit
    end

    announceLangBtn.MouseButton1Click:Connect(updateAnnounceLang)

    discordBtn.MouseButton1Click:Connect(function()
        setclipboard(".ggVe3auRTUA")
        discordBtn.Text = currentLang == "EN" and "COPIED!" or "COPIADO!"
        task.wait(1)
        discordBtn.Text = announceTexts[currentLang].btn_discord
    end)

    exitBtn.MouseButton1Click:Connect(function()
        TweenService:Create(announceFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.3)
        announceFrame:Destroy()
        announceData.seen = true
        saveAnnounce()
    end)
end

local openButton = Instance.new("ImageButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.Image = "rbxassetid://80481300702093"
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openButton.Visible = false
openButton.ZIndex = 20
openButton.Parent = gui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", openButton)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(30, 30, 30)
stroke.Transparency = 0
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

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
frame.Size = UDim2.new(0, 560, 0, 350)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.Parent = gui

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 0, 0)
stroke.Transparency = 0.1

local bg = Instance.new("ImageLabel", frame)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = ""
bg.ImageTransparency = 0.3

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
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 53, 0, 0)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Eclipse V2.4"
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(180, 180, 180)

local searchBox = Instance.new("Frame", topbar)
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(0, 110, 0, 24)
searchBox.Position = UDim2.new(1, -255, 0, 6)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
searchBox.BackgroundTransparency = 0.65
searchBox.BorderSizePixel = 0
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", searchBox).Color = Color3.fromRGB(60, 60, 60)

local searchIcon = Instance.new("ImageLabel", searchBox)
searchIcon.Size = UDim2.new(0, 16, 0, 16)
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
searchInput.TextSize = 13
searchInput.Font = Enum.Font.GothamBold
searchInput.TextXAlignment = Enum.TextXAlignment.Left
searchInput.ClearTextOnFocus = false

local langBtn = Instance.new("TextButton", topbar)
langBtn.Size = UDim2.new(0, 32, 0, 28)
langBtn.Position = UDim2.new(1, -130, 0, 6)
langBtn.Text = "EN"
langBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
langBtn.BackgroundTransparency = 1
langBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
langBtn.TextSize = 15
langBtn.Font = Enum.Font.GothamBold
langBtn.BorderSizePixel = 0
Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", langBtn).Color = Color3.fromRGB(60, 60, 60)

local infoBtn = Instance.new("TextButton", topbar)
infoBtn.Size = UDim2.new(0, 28, 0, 28)
infoBtn.Position = UDim2.new(1, -95, 0, 6)
infoBtn.Text = "ⓘ"
infoBtn.BackgroundTransparency = 1
infoBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
infoBtn.TextSize = 20
infoBtn.Font = Enum.Font.GothamBold

local miniBtn = Instance.new("TextButton", topbar)
miniBtn.Size = UDim2.new(0, 28, 0, 28)
miniBtn.Position = UDim2.new(1, -65, 0, 6)
miniBtn.Text = "–"
miniBtn.BackgroundTransparency = 1
miniBtn.TextColor3 = Color3.fromRGB(200,200,200)
miniBtn.TextSize = 24
miniBtn.Font = Enum.Font.GothamBold

local closeBtn = Instance.new("TextButton", topbar)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -35, 0, 6)
closeBtn.Text = "X"
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
	groupbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	groupbox.BackgroundTransparency = 0.7
	groupbox.Parent = parent
	Instance.new("UICorner", groupbox).CornerRadius = UDim.new(0, 8)
	
	local groupboxStroke = Instance.new("UIStroke", groupbox)
	groupboxStroke.Color = Color3.fromRGB(45, 45, 45) -- CINZA ESCURO
	groupboxStroke.Thickness = 1
	groupboxStroke.Transparency = 0.2 -- MENOS TRANSPARENTE
	
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
discordText.Text = "Discord:.ggVe3auRTUA"
discordText.Font = Enum.Font.GothamBold
discordText.TextSize = 10
discordText.TextColor3 = Color3.fromRGB(255, 255, 255)
discordText.TextXAlignment = Enum.TextXAlignment.Left

local versionText = Instance.new("TextLabel", bottomBar)
versionText.Size = UDim2.new(0.5, -10, 1, 0)
versionText.Position = UDim2.new(0.5, 0, 0, 0)
versionText.BackgroundTransparency = 1
versionText.Text = "FTF Eclipse V2.3 ".. deviceType.. " ┃ Thank you for using FTF Eclipse."
versionText.Font = Enum.Font.GothamBold
versionText.TextSize = 10
versionText.TextColor3 = Color3.fromRGB(255, 255, 255)
versionText.TextXAlignment = Enum.TextXAlignment.Right

-- ========= TOGGLE PÍLULA =========
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
    {Name = "Visual Skins", Icon = "rbxassetid://138986094998542"},
    {Name = "Teleport", Icon = "rbxassetid://84854819063665"},
    {Name = "Sounds", Icon = "rbxassetid://13288142767"},
    {Name = "Setting", Icon = "rbxassetid://125242096497906"},
}

local pages = {}
local tabIndicators = {}
local tabShines = {}

for i, tab in ipairs(tabs) do
	local button = Instance.new("TextButton", sidebar) -- sidebar tem que existir
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
	icon.Size = UDim2.new(0, 16, 0, 16)
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
	label.TextSize = 11
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
	shineLabel.TextSize = 11
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
    local playerHighlight = false
    local computerHighlight = false
    local capsuleHighlight = false
    local exitHighlight = false
    local doorName = false
    local beastIlluminationEnabled = false

    local playerCache = {}
    local playerConnections = {}
    local computerCache = {}
    local capsuleCache = {}
    local exitCache = {}
    local doorCache = {}
    local beastConnections = {}

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
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local box1H, content1H = CreateGroupbox(leftColH, "Objects")

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

    CreateToggle(content1H, "Door", false, function(state)
        doorName = state
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
                while doorName do
                    task.wait(0.5)
                    for i = 1, #doorCache do
                        local door = doorCache[i]
                        if door and door.Parent then
                            local billboardGui = door:FindFirstChild("DoorName")
                            if not billboardGui then
                                billboardGui = Instance.new("BillboardGui")
                                billboardGui.Name = "DoorName"
                                billboardGui.Parent = door
                                billboardGui.Adornee = door
                                billboardGui.Size = UDim2.new(0, 100, 0, 50)
                                billboardGui.StudsOffset = Vector3.new(0, 3, 0)
                                billboardGui.AlwaysOnTop = true
                                local textLabel = Instance.new("TextLabel")
                                textLabel.Parent = billboardGui
                                textLabel.Size = UDim2.new(1, 0, 1, 0)
                                textLabel.BackgroundTransparency = 1
                                textLabel.Font = Enum.Font.GothamBold
                                textLabel.TextSize = 9
                                textLabel.TextStrokeTransparency = 0
                                textLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                                textLabel.Text = ""
                                textLabel.AutoLocalize = false
                            end
                            local textLabel = billboardGui:FindFirstChildOfClass("TextLabel")
                            if textLabel and door:FindFirstChild("DoorTrigger") then
                                local action = door.DoorTrigger:FindFirstChild("ActionSign")
                                if action then
                                    if action.Value == 11 then
                                        textLabel.Text = "OPEN"
                                        textLabel.TextColor3 = Color3.fromRGB(0,255,0)
                                    elseif action.Value == 10 then
                                        textLabel.Text = "CLOSE"
                                        textLabel.TextColor3 = Color3.fromRGB(255,0,0)
                                    end
                                end
                            end
                        end
                    end
                end
                for i = 1, #doorCache do
                    local door = doorCache[i]
                    if door and door:FindFirstChild("DoorName") then door.DoorName:Destroy() end
                end
            end)
        else
            for i = 1, #doorCache do
                local door = doorCache[i]
                if door and door:FindFirstChild("DoorName") then
                    door.DoorName:Destroy()
                end
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
        btn.Size = UDim2.new(0, 85, 0, 28)
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

    local espGroup, espContent = CreateGroupbox(rightColH, "Highlights")

    CreateToggle(espContent, "Highlights", false, function(state)
        playerHighlight = state
        if state then
            playerCache = {}
            playerConnections = {}

            local function addPlayerESP(player)
                if player == game.Players.LocalPlayer then return end
                playerCache[#playerCache + 1] = player
            end

            local function removePlayerESP(player)
                for i = 1, #playerCache do
                    if playerCache[i] == player then
                        table.remove(playerCache, i)
                        break
                    end
                end
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end

            local players = game.Players:GetPlayers()
            for i = 1, #players do
                addPlayerESP(players[i])
            end

            playerConnections[#playerConnections + 1] = game.Players.PlayerAdded:Connect(function(player)
                if playerHighlight then addPlayerESP(player) end
            end)
            playerConnections[#playerConnections + 1] = game.Players.PlayerRemoving:Connect(removePlayerESP)

            task.spawn(function()
                while playerHighlight do
                    task.wait(1)
                    for i = 1, #playerCache do
                        local player = playerCache[i]
                        if player.Character then
                            aplicarHighlight(player.Character, player == getBeast() and "Beast" or "Player")
                        end
                    end
                end
                for i = 1, #playerCache do
                    local player = playerCache[i]
                    if player.Character and player.Character:FindFirstChild("Highlight") then
                        player.Character.Highlight:Destroy()
                    end
                end
                for i = 1, #playerConnections do playerConnections[i]:Disconnect() end
                playerCache, playerConnections = {}, {}
            end)
        else
            for i = 1, #playerConnections do playerConnections[i]:Disconnect() end
            for i = 1, #playerCache do
                local player = playerCache[i]
                if player.Character and player.Character:FindFirstChild("Highlight") then
                    player.Character.Highlight:Destroy()
                end
            end
            playerCache, playerConnections = {}, {}
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

    local columnsP = Instance.new("Frame", settingsPageP)
    columnsP.Size = UDim2.new(1, 0, 0, 0)
    columnsP.AutomaticSize = Enum.AutomaticSize.Y
    columnsP.BackgroundTransparency = 1

    local leftColP = Instance.new("Frame", columnsP)
    leftColP.Size = UDim2.new(0.5, -5, 0, 0)
    leftColP.AutomaticSize = Enum.AutomaticSize.Y
    leftColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColP).Padding = UDim.new(0, 10)

    local rightColP = Instance.new("Frame", columnsP)
    rightColP.Size = UDim2.new(0.5, -5, 0, 0)
    rightColP.Position = UDim2.new(0.5, 5, 0, 0)
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
            btn.Font = Enum.Font.Gotham
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
                opt.BackgroundColor3 = Color3.fromRGB(45,45,45)
                opt.BackgroundTransparency = 0.25
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

    do
        local boxHammer, contentHammer = CreateGroupbox(leftColP, "Hammer")
        boxHammer.BackgroundColor3 = Color3.fromRGB(25,25,25)
        boxHammer.BackgroundTransparency = 1
        boxHammer.BorderSizePixel = 0
        boxHammer.Size = UDim2.new(1,0,0,540)
        boxHammer.ClipsDescendants = false
        Instance.new("UICorner", boxHammer).CornerRadius = UDim.new(0,8)
        contentHammer.ClipsDescendants = false

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(70,70,70)
        stroke.Transparency = 0.8
        stroke.Thickness = 1
        stroke.Parent = boxHammer

        local Refs = {}
        local HammerData = {Enabled = false}

        CreateToggle(contentHammer, "Enable", false, function(state)
            HammerData.Enabled = state
        end)

        task.spawn(function()
            local materials = {"Concrete","Metal","Water","Snow","Granite","Plastic","Neon","Sand","Fabric","Salt","Grass","CorrodedMetal","ForceField","Glass","DiamondPlate"}

            local function makeDropdown(y)
                local holder = Instance.new("TextButton")
                holder.Size = UDim2.new(0.9,0,0,26)
                holder.Position = UDim2.new(0.05,0,0,y)
                holder.BackgroundColor3 = Color3.fromRGB(40,40,40)
                holder.BackgroundTransparency = 1
                holder.Text = ""
                holder.BorderSizePixel = 0
                holder.AutoButtonColor = false
                holder.ZIndex = 5
                holder.Parent = contentHammer
                Instance.new("UICorner", holder).CornerRadius = UDim.new(0,6)

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(60,60,60)
                stroke.Transparency = 1
                stroke.Thickness = 1
                stroke.Parent = holder

                local display = Instance.new("TextLabel")
                display.Size = UDim2.new(1,-25,1,0)
                display.Position = UDim2.new(0,8,0,0)
                display.BackgroundTransparency = 1
                display.Text = materials[1]
                display.TextColor3 = Color3.fromRGB(235,235,235)
                display.Font = Enum.Font.Gotham
                display.TextSize = 11
                display.TextXAlignment = Enum.TextXAlignment.Left
                display.ZIndex = 6
                display.Parent = holder

                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0,20,1,0)
                arrow.Position = UDim2.new(1,-20,0,0)
                arrow.BackgroundTransparency = 1
                arrow.Text = "▼"
                arrow.TextColor3 = Color3.fromRGB(180,180,180)
                arrow.Font = Enum.Font.Gotham
                arrow.TextSize = 10
                arrow.ZIndex = 6
                arrow.Parent = holder

                local currentIndex = 1
                local open = false
                local dropdown

                holder.MouseButton1Click:Connect(function()
                    if open then
                        TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
                        if dropdown then
                            local tween = TweenService:Create(dropdown, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)})
                            tween:Play()
                            tween.Completed:Connect(function()
                                dropdown:Destroy()
                            end)
                        end
                        open = false
                        return
                    end

                    open = true
                    TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 180}):Play()

                    dropdown = Instance.new("ScrollingFrame")
                    dropdown.Size = UDim2.new(1,0,0,0)
                    dropdown.Position = UDim2.new(0,0,1,2)
                    dropdown.BackgroundColor3 = Color3.fromRGB(35,35,35)
                    dropdown.BackgroundTransparency = 0.1
                    dropdown.BorderSizePixel = 0
                    dropdown.ScrollBarThickness = 3
                    dropdown.ZIndex = 20
                    dropdown.ClipsDescendants = true
                    dropdown.Parent = holder
                    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0,6)

                    local list = Instance.new("UIListLayout")
                    list.Parent = dropdown

                    for i = 1, #materials do
                        local option = Instance.new("TextButton")
                        option.Size = UDim2.new(1,0,0,24)
                        option.BackgroundColor3 = Color3.fromRGB(45,45,45)
                        option.BackgroundTransparency = 1
                        option.Text = " "..materials[i]
                        option.TextColor3 = Color3.fromRGB(235,235,235)
                        option.Font = Enum.Font.Gotham
                        option.TextSize = 11
                        option.TextXAlignment = Enum.TextXAlignment.Left
                        option.BorderSizePixel = 0
                        option.ZIndex = 21
                        option.AutoButtonColor = false
                        option.Parent = dropdown

                        option.MouseEnter:Connect(function()
                            TweenService:Create(option, TweenInfo.new(0.1), {BackgroundTransparency = 0.5}):Play()
                        end)
                        option.MouseLeave:Connect(function()
                            TweenService:Create(option, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
                        end)

                        option.MouseButton1Click:Connect(function()
                            currentIndex = i
                            display.Text = materials[i]
                            TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation = 0}):Play()
                            local tween = TweenService:Create(dropdown, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)})
                            tween:Play()
                            tween.Completed:Connect(function()
                                dropdown:Destroy()
                            end)
                            open = false
                        end)
                    end

                    dropdown.CanvasSize = UDim2.new(0,0,0,#materials * 24)
                    TweenService:Create(dropdown, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,120)}):Play()
                end)

                return function()
                    return Enum.Material[materials[currentIndex]]
                end
            end

            Refs.getHammerMaterial = makeDropdown(40)
            Refs.getGemMaterial = makeDropdown(75)
        end)

        task.spawn(function()
            local apply = Instance.new("TextButton")
            apply.Size = UDim2.new(0.9,0,0,32)
            apply.Position = UDim2.new(0.05,0,0,110)
            apply.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            apply.BackgroundTransparency = 0.5
            apply.Text = "Apply"
            apply.TextColor3 = Color3.fromRGB(255,255,255)
            apply.Font = Enum.Font.GothamBold
            apply.TextSize = 12
            apply.BorderSizePixel = 0
            apply.AutoButtonColor = false
            apply.ZIndex = 2
            apply.Parent = contentHammer
            Instance.new("UICorner", apply).CornerRadius = UDim.new(0,6)

            apply.MouseEnter:Connect(function()
                TweenService:Create(apply, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
            end)
            apply.MouseLeave:Connect(function()
                TweenService:Create(apply, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
            end)

            Refs.applyBtn = apply
        end)

        task.spawn(function()
            local function makeInput(name, y, default)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(0.9,0,0,42)
                container.Position = UDim2.new(0.05,0,0,y)
                container.BackgroundTransparency = 1
                container.ZIndex = 2
                container.Parent = contentHammer

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1,0,0,14)
                label.Position = UDim2.new(0,0,0,0)
                label.BackgroundTransparency = 1
                label.Text = name
                label.TextColor3 = Color3.fromRGB(200,200,200)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 11
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 2
                label.Parent = container

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1,0,0,26)
                box.Position = UDim2.new(0,0,0,16)
                box.BackgroundColor3 = Color3.fromRGB(40,40,40)
                box.BackgroundTransparency = 0.3
                box.TextColor3 = Color3.fromRGB(235,235,235)
                box.PlaceholderColor3 = Color3.fromRGB(150,150,150)
                box.Text = default
                box.Font = Enum.Font.Gotham
                box.TextSize = 11
                box.ClearTextOnFocus = false
                box.BorderSizePixel = 0
                box.ZIndex = 2
                box.Parent = container
                Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(60,60,60)
                stroke.Transparency = 0.7
                stroke.Thickness = 1
                stroke.Parent = box

                return box
            end

            Refs.hammerColor = makeInput("Cor da Marreta", 155, "0,0,0")
            Refs.gemColor = makeInput("Cor da Gema", 200, "0,0,0")
            Refs.lightColor = makeInput("Cor da Luz da Gema", 245, "255,255,255")
            Refs.hammerTransparency = makeInput("Transparência da Marreta", 290, "0")
            Refs.gemTransparency = makeInput("Transparência da Gema", 335, "0")
            Refs.hammerTexture = makeInput("Textura da Marreta", 380, "")
            Refs.gemTexture = makeInput("Textura da Gema", 425, "")
        end)

        task.spawn(function()
            task.wait(0.1)
            Refs.applyBtn.MouseButton1Click:Connect(function()
                if not HammerData.Enabled then return end

                task.spawn(function()
                    local player = Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()

                    local function parseColor(txt)
                        local clean = txt:gsub("%s+","")
                        local r,g,b = string.match(clean, "(%d+),(%d+),(%d+)")
                        return Color3.fromRGB(tonumber(r) or 0, tonumber(g) or 0, tonumber(b) or 0)
                    end

                    local th = tonumber(Refs.hammerTransparency.Text) or 0
                    local tg = tonumber(Refs.gemTransparency.Text) or 0
                    local ch = parseColor(Refs.hammerColor.Text)
                    local cg = parseColor(Refs.gemColor.Text)
                    local cl = parseColor(Refs.lightColor.Text)
                    local texH = Refs.hammerTexture.Text
                    local texG = Refs.gemTexture.Text
                    local mh = Refs.getHammerMaterial()
                    local mg = Refs.getGemMaterial()

                    local hammer = character:FindFirstChild("Hammer", true)
                    local gemstone = character:FindFirstChild("Gemstone", true)
                    local packedHammer = character:FindFirstChild("PackedHammer", true)
                    local packedGemstone = character:FindFirstChild("PackedGemstone", true)

                    local hammerTargets = {hammer or packedHammer}
                    local gemTargets = {gemstone or packedGemstone}

                    for _, object in hammerTargets do
                        if not object then continue end
                        for _, d in object:GetDescendants() do
                            if d:IsA("MeshPart") then
                                d.Transparency = th
                                d.TextureID = texH
                                d.Color = ch
                                d.Material = mh
                            end
                        end
                    end

                    for _, object in gemTargets do
                        if not object then continue end
                        for _, d in object:GetDescendants() do
                            if d:IsA("MeshPart") then
                                d.Transparency = tg
                                d.TextureID = texG
                                d.Color = cg
                                d.Material = mg
                            elseif d:IsA("PointLight") then
                                d.Color = cl
                            end
                        end
                    end
                end)
            end)
        end)
    end

    do
        local boxFOV, contentFOV = CreateGroupbox(rightColP, "FOV")
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

        local Camera = workspace.CurrentCamera
        local FOVData = {Enabled = false, Value = 70}

        CreateToggle(contentFOV, "Enable FOV", false, function(state)
            FOVData.Enabled = state
            if state then
                Camera.FieldOfView = FOVData.Value
            else
                Camera.FieldOfView = 70
            end
        end)

        local stretchConn65 = nil
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

        local stretchConn7 = nil
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

        do
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1,0,0,40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = contentFOV

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,0,0,14)
            label.BackgroundTransparency = 1
            label.Text = "FOV: 70"
            label.Font = Enum.Font.GothamBold
            label.TextSize = 11
            label.TextColor3 = Color3.fromRGB(200,200,200)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame

            local sliderBg = Instance.new("TextButton")
            sliderBg.Size = UDim2.new(1,0,0,4)
            sliderBg.Position = UDim2.new(0,0,0,22)
            sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
            sliderBg.BorderSizePixel = 0
            sliderBg.Text = ""
            sliderBg.AutoButtonColor = false
            sliderBg.Parent = sliderFrame
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0,0,1,0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(200,200,200)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

            local sliderBtn = Instance.new("Frame")
            sliderBtn.Size = UDim2.new(0,12,0,12)
            sliderBtn.Position = UDim2.new(0,-6,0.5,-6)
            sliderBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
            sliderBtn.BorderSizePixel = 0
            sliderBtn.ZIndex = 2
            sliderBtn.Parent = sliderBg
            Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1,0)

            local minFOV, maxFOV = 70, 120
            local dragging = false

            local function setFOV(percent)
                percent = math.clamp(percent, 0, 1)
                local value = minFOV + (maxFOV - minFOV) * percent
                FOVData.Value = value
                label.Text = "FOV: " .. math.floor(value)
                
                sliderFill.Size = UDim2.new(percent,0,1,0)
                sliderBtn.Position = UDim2.new(percent,-6,0.5,-6)
                
                if FOVData.Enabled then
                    Camera.FieldOfView = value
                end
            end

            sliderBg.MouseButton1Down:Connect(function()
                dragging = true
                local connection
                connection = UIS.InputChanged:Connect(function(input)
                    if not dragging then
                        connection:Disconnect()
                        return
                    end
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                        setFOV(percent)
                    end
                end)
                local upConnection
                upConnection = UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        connection:Disconnect()
                        upConnection:Disconnect()
                    end
                end)
            end)

            setFOV(0)
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
    leftColP.Size = UDim2.new(0.5, -5, 0, 0)
    leftColP.AutomaticSize = Enum.AutomaticSize.Y
    leftColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColP).Padding = UDim.new(0, 10)

    local rightColP = Instance.new("Frame", columnsP)
    rightColP.Size = UDim2.new(0.5, -5, 0, 0)
    rightColP.Position = UDim2.new(0.5, 5, 0, 0)
    rightColP.AutomaticSize = Enum.AutomaticSize.Y
    rightColP.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColP).Padding = UDim.new(0, 10)

    local box1P, content1P = CreateGroupbox(leftColP, "Objects")
    local box2P, content2P = CreateGroupbox(rightColP, "Players")

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
        local doors = {}
        local running = false

        CreateToggle(content1P, "Door Timer", false, function(v)
            running = v
            if not v then
                for _,d in pairs(doors) do
                    if d.gui then d.gui:Destroy() end
                end
                table.clear(doors)
            end
        end)

        local function getProgress(plr)
            local stats = plr:FindFirstChild("TempPlayerStatsModule")
            local ap = stats and stats:FindFirstChild("ActionProgress")
            return ap and ap.Value or 0
        end

        local function setup(door)
            if doors[door] or door.Name ~= "SingleDoor" then return end
            local part = door:FindFirstChildWhichIsA("BasePart", true)
            if not part then return end

            local gui = Instance.new("BillboardGui")
            gui.Size = UDim2.fromOffset(90, 22)
            gui.AlwaysOnTop = true
            gui.Adornee = part
            gui.Parent = part

            local txt = Instance.new("TextLabel")
            txt.Size = UDim2.new(1,0,0.45,0)
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = Enum.Font.GothamMedium
            txt.TextColor3 = Color3.fromRGB(255,210,140)
            txt.TextStrokeTransparency = 0.6
            txt.Text = "0.0%"
            txt.Parent = gui

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1,0,0.35,0)
            bg.Position = UDim2.new(0,0,0.6,0)
            bg.BackgroundColor3 = Color3.fromRGB(25,15,5)
            bg.BorderSizePixel = 0
            bg.Parent = gui

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0,0,1,0)
            bar.BackgroundColor3 = Color3.fromRGB(170,100,40)
            bar.BorderSizePixel = 0
            bar.Parent = bg

            doors[door] = {gui = gui, bar = bar, txt = txt, progress = 0, part = part, tween = nil}
        end

        task.spawn(function()
            while true do
                if running then
                    for _,v in ipairs(workspace:GetDescendants()) do
                        if v.Name == "SingleDoor" and not doors[v] then
                            setup(v)
                        end
                    end
                end
                task.wait(2)
            end
        end)

        RunService.Heartbeat:Connect(function()
            if not running then return end
            for door, data in pairs(doors) do
                if not door.Parent then
                    if data.gui then data.gui:Destroy() end
                    doors[door] = nil
                else
                    local best = 0
                    for _,plr in ipairs(Players:GetPlayers()) do
                        local char = plr.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - data.part.Position).Magnitude <= 12 then
                            best = math.max(best, getProgress(plr))
                        end
                    end
                    local target = math.clamp(best, 0, 1)
                    if math.abs(target - data.progress) > 0.01 then
                        data.progress = target
                        if data.tween then data.tween:Cancel() end
                        data.tween = TweenService:Create(data.bar, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {Size = UDim2.new(target, 0, 1, 0)})
                        data.tween:Play()
                        data.txt.Text = string.format("%.1f%%", target * 100)
                    end
                end
            end
        end)
    end

    do
        local enabled = false
        local doors = {}
        local folder
        local connAdded

        local function getProgress(plr)
            local stats = plr:FindFirstChild("TempPlayerStatsModule")
            local ap = stats and stats:FindFirstChild("ActionProgress")
            return ap and ap.Value or 0
        end

        local function addDoor(d)
            if doors[d] then return end
            local part = d.PrimaryPart or d:FindFirstChildWhichIsA("BasePart")
            if not part then return end

            local g = Instance.new("BillboardGui")
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
            t.Parent = g

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0.8,0,0,6)
            bg.Position = UDim2.new(0.1,0,0.7,0)
            bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
            bg.Parent = g

            local f = Instance.new("Frame")
            f.Size = UDim2.new(0,0,1,0)
            f.BackgroundColor3 = Color3.fromRGB(255,170,0)
            f.Parent = bg

            doors[d] = {p = part, t = t, f = f}
        end

        CreateToggle(content1P, "ExitDoor Timer", false, function(v)
            enabled = v
            if not v then
                if connAdded then connAdded:Disconnect() connAdded = nil end
                if folder then folder:Destroy() folder = nil end
                table.clear(doors)
                return
            end

            folder = Instance.new("Folder")
            folder.Name = "ExitDoorUI"
            folder.Parent = CoreGui

            for _,o in ipairs(workspace:GetDescendants()) do
                if o:IsA("Model") and o.Name == "ExitDoor" then addDoor(o) end
            end

            connAdded = workspace.DescendantAdded:Connect(function(o)
                if enabled and o:IsA("Model") and o.Name == "ExitDoor" then
                    task.wait(0.2)
                    addDoor(o)
                end
            end)

            task.spawn(function()
                while enabled do
                    task.wait(0.1)
                    for d,data in pairs(doors) do
                        if not d.Parent then
                            doors[d] = nil
                        else
                            local best = 0
                            local using = false
                            for _,plr in ipairs(Players:GetPlayers()) do
                                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                if hrp and (hrp.Position - data.p.Position).Magnitude <= 10 then
                                    local prog = getProgress(plr)
                                    if prog > 0 then
                                        using = true
                                        best = math.max(best, prog)
                                    end
                                end
                            end
                            local prog = using and math.clamp(best,0,1) or 0
                            data.f.Size = UDim2.new(prog,0,1,0)
                            data.t.Text = (prog > 0) and ("OPENING: "..math.floor(prog*100).."%") or "EXIT"
                        end
                    end
                end
            end)
        end)
    end

    do
        local _G_Life = false
        local _G_LifeC = {}
        local LP = Players.LocalPlayer

        local function disconnectAll()
            for _, c in ipairs(_G_LifeC) do pcall(function() c:Disconnect() end) end
            _G_LifeC = {}
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
            table.insert(_G_LifeC, RunService.RenderStepped:Connect(function(dt)
                if not _G_Life or not char.Parent then gui:Destroy() return end
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
            end))
        end

        local function hookPlayer(p)
            table.insert(_G_LifeC, p.CharacterAdded:Connect(function(c)
                task.wait(0.3)
                createTag(c, p)
            end))
            if p.Character then createTag(p.Character, p) end
        end

        CreateToggle(content1P, "Life Timer", false, function(v)
            _G_Life = v
            disconnectAll()
            if not v then return end
            for _, p in ipairs(Players:GetPlayers()) do hookPlayer(p) end
            table.insert(_G_LifeC, Players.PlayerAdded:Connect(hookPlayer))
            task.spawn(function()
                while _G_Life do
                    task.wait(2)
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

        CreateToggle(content2P, "Walkspeed", false, function(Value)
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
                                    label.Text = "Runner is Full"
                                    readyShown = true
                                end
                            elseif value >= 70 then
                                label.TextColor3 = Color3.fromRGB(255, 170, 0)
                                label.Text = "Runner Back In: ".. value.. "%"
                                readyShown = false
                            else
                                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                                label.Text = "Runner Back In: ".. value.. "%"
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

        CreateToggle(content2P, "Spawn Timer", false, function(v)
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
                    TweenService:Create(d, TweenInfo.new(0.8), {
                        Position = d.Position + UDim2.new(0, 0, 0, math.random(35, 60)),
                        TextTransparency = 1
                    }):Play()
                    Debris:AddItem(d, 1)
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
                        TweenService:Create(label, TweenInfo.new(1), {TextTransparency = 0}):Play()
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

    do
        local E = {
            LP = Players.LocalPlayer,
            DURATION = 28,
            active = {},
            enabled = false,
            loopConnection = nil,
            gui = nil,
            list = nil
        }

        local function humanoid(p)
            return p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        end

        local function ragdoll(p)
            local h = humanoid(p)
            if not h then return false end
            return h.PlatformStand or h:GetState() == Enum.HumanoidStateType.Physics
        end

        local function captured(p)
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            return hrp and hrp.Anchored
        end

        local function glowColor()
            local t = tick()
            local pulse = (math.sin(t * 5) + 1) / 2
            local dark = Color3.fromRGB(90, 0, 20)
            local bright = Color3.fromRGB(220, 30, 50)
            return dark:Lerp(bright, pulse)
        end

        local playerGui = E.LP:WaitForChild("PlayerGui")
        E.gui = playerGui:FindFirstChild("RagdollCounterGui")
        if not E.gui then
            E.gui = Instance.new("ScreenGui")
            E.gui.Name = "RagdollCounterGui"
            E.gui.ResetOnSpawn = false
            E.gui.Parent = playerGui
        end

        E.list = Instance.new("Frame", E.gui)
        E.list.Size = UDim2.new(0,240,0,300)
        E.list.Position = UDim2.new(1,-20,1,-20)
        E.list.AnchorPoint = Vector2.new(1,1)
        E.list.BackgroundTransparency = 1

        local layout = Instance.new("UIListLayout", E.list)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

        local function billboard(p)
            local h = p.Character and p.Character:FindFirstChild("Head")
            if not h then return end
            local old = h:FindFirstChild("RC")
            if old then old:Destroy() end
            local bb = Instance.new("BillboardGui")
            bb.Name = "RC"
            bb.Size = UDim2.new(2.5,0,0.7,0)
            bb.StudsOffset = Vector3.new(0,1.9,0)
            bb.AlwaysOnTop = true
            bb.Parent = h
            local t = Instance.new("TextLabel")
            t.Size = UDim2.fromScale(1,1)
            t.BackgroundTransparency = 1
            t.TextScaled = true
            t.Font = Enum.Font.SpecialElite
            t.TextStrokeTransparency = 0.1
            t.TextStrokeColor3 = Color3.fromRGB(0,0,0)
            t.Parent = bb
            return t
        end

        local function start(p)
            if E.active[p] then return end
            E.active[p] = {start = tick(), billboard = billboard(p)}
            local txt = Instance.new("TextLabel", E.list)
            txt.Size = UDim2.new(1,0,0,32)
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = Enum.Font.SpecialElite
            txt.TextXAlignment = Enum.TextXAlignment.Right
            txt.RichText = true
            E.active[p].label = txt
        end

        local function runLoop()
            E.loopConnection = RunService.Heartbeat:Connect(function()
                if not E.enabled then return end
                for _, p in ipairs(Players:GetPlayers()) do
                    if ragdoll(p) and not captured(p) then
                        start(p)
                        local data = E.active[p]
                        if data then
                            local t = math.max(E.DURATION - (tick() - data.start), 0)
                            local c = glowColor()
                            local timeText = string.format("%.2f", t)
                            if data.billboard then
                                data.billboard.Text = timeText
                                data.billboard.TextColor3 = c
                            end
                            if data.label then
                                data.label.Text = '<font color="rgb(255,255,255)">'.. p.Name.. '</font> - <font color="rgb('..math.floor(c.R*255)..','..math.floor(c.G*255)..','..math.floor(c.B*255)..')">'.. timeText.. '</font>'
                            end
                        end
                    else
                        if E.active[p] then
                            if E.active[p].label then E.active[p].label:Destroy() end
                            if p.Character and p.Character:FindFirstChild("Head") then
                                local bb = p.Character.Head:FindFirstChild("RC")
                                if bb then bb:Destroy() end
                            end
                            E.active[p] = nil
                        end
                    end
                end
            end)
        end

        CreateToggle(content2P, "GetUp Timer", false, function(Value)
            E.enabled = Value
            if Value then
                if not E.loopConnection then
                    runLoop()
                end
            else
                if E.loopConnection then
                    E.loopConnection:Disconnect()
                    E.loopConnection = nil
                end
                for p, data in pairs(E.active) do
                    if data.label then data.label:Destroy() end
                    if p.Character and p.Character:FindFirstChild("Head") then
                        local bb = p.Character.Head:FindFirstChild("RC")
                        if bb then bb:Destroy() end
                    end
                end
                table.clear(E.active)
            end
        end)
    end
end

do
    local Players = game:GetService("Players")
    local Lighting = game:GetService("Lighting")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    local Player = Players.LocalPlayer
    local playerGui = Player:WaitForChild("PlayerGui")

    local settingsPageH = pages["Textures"]

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

    -- ========== DOUBLE JUMP EFFECT ==========
    local boxTexture, contentTexture = CreateGroupbox(leftColH, "Double Jump Effect")
    boxTexture.BackgroundColor3 = Color3.fromRGB(30,30,30)
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
    inputBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    inputBox.BackgroundTransparency = 0.65
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
    applyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    applyBtn.BackgroundTransparency = 0.25
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
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.BackgroundTransparency = 0.3
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

    if not getgenv().CrosshairState then
        getgenv().CrosshairState = {
            Size = 30,
            TouchMode = false,
            Crosshair = nil,
            Touches = {}
        }
    end
    local State = getgenv().CrosshairState

    local boxSettings, contentSettings = CreateGroupbox(leftColH, "Crosshair")
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
    textBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    textBox.BackgroundTransparency = 0.65
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
    applyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    applyBtn.BackgroundTransparency = 0.65
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
    touchBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    touchBtn.BackgroundTransparency = 0.65
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
                BackgroundColor3 = Color3.fromRGB(255,255,255),
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
    resetBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    resetBtn.BackgroundTransparency = 0.65
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
            BackgroundColor3 = Color3.fromRGB(255,255,255),
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
    sliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sliderFill.BorderSizePixel = 0
    Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", sliderBack)
    knob.Size = UDim2.new(0,12,0,12)
    knob.Position = UDim2.new((State.Size - 10) / 70, 0, 0.5, 0)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
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
            btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            btn.BackgroundTransparency = 0.3
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

    CreateCrosshairGroup(leftColH, "Custom Cross hair", {
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

    local boxPerf, contentPerf = CreateGroupbox(rightColH, "Performance")
    boxPerf.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxPerf.BackgroundTransparency = 1
    boxPerf.BorderSizePixel = 0
    boxPerf.Size = UDim2.new(1,0,0,130)
    Instance.new("UICorner", boxPerf).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxPerf).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentPerf).Padding = UDim.new(0, 6)

    do
        local saved = {}

        CreateToggle(contentPerf, "FPS Boost", false, function(enabled)
            if enabled then
                saved.Quality = settings().Rendering.QualityLevel
                if Terrain then
                    saved.Water = {
                        WaveSize = Terrain.WaterWaveSize,
                        WaveSpeed = Terrain.WaterWaveSpeed,
                        Reflectance = Terrain.WaterReflectance,
                        Transparency = Terrain.WaterTransparency
                    }
                    Terrain.WaterWaveSize = 0
                    Terrain.WaterWaveSpeed = 0
                    Terrain.WaterReflectance = 0
                    Terrain.WaterTransparency = 1
                end
                saved.Parts = {}
                saved.Decals = {}
                saved.Effects = {}

                for _, v in pairs(game:GetDescendants()) do
                    if v:IsA("BasePart") then
                        saved.Parts[v] = {Material = v.Material, Reflectance = v.Reflectance}
                        v.Material = Enum.Material.Plastic
                        v.Reflectance = 0
                    end
                    if v:IsA("Decal") or v:IsA("Texture") then
                        saved.Decals[v] = v.Transparency
                        v.Transparency = 1
                    end
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        saved.Effects[v] = v.Enabled
                        v.Enabled = false
                    end
                end
                for _, v in pairs(Lighting:GetDescendants()) do
                    if v:IsA("PostEffect") then
                        saved.Effects[v] = v.Enabled
                        v.Enabled = false
                    end
                end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            else
                for v, data in pairs(saved.Parts or {}) do
                    if v and v.Parent then
                        v.Material = data.Material
                        v.Reflectance = data.Reflectance
                    end
                end
                for v, trans in pairs(saved.Decals or {}) do
                    if v and v.Parent then v.Transparency = trans end
                end
                for v, state in pairs(saved.Effects or {}) do
                    if v and v.Parent then v.Enabled = state end
                end
                if Terrain and saved.Water then
                    Terrain.WaterWaveSize = saved.Water.WaveSize
                    Terrain.WaterWaveSpeed = saved.Water.WaveSpeed
                    Terrain.WaterReflectance = saved.Water.Reflectance
                    Terrain.WaterTransparency = saved.Water.Transparency
                end
                settings().Rendering.QualityLevel = saved.Quality or Enum.QualityLevel.Automatic
            end
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

        CreateToggle(contentPerf, "Minecraft", false, function(enabled)
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
                    if obj:IsA("SpecialMesh") then obj.TextureId = "" obj.VertexColor = Vector3.new(0.63,0.63,0.63) end
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

        CreateToggle(contentPerf, "Remove Skin", false, function(enabled)
            if enabled then
                startSkin()
            else
                stopSkin()
            end
        end)
    end
end

do
    local HttpService = game:GetService("HttpService")
    local Lighting = game:GetService("Lighting")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = game:GetService("Players").LocalPlayer

    local settingsPageH = pages["Fog"]
    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

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

    local sliderRefs = {}

    local function resetSlider(name, value, min, max)
        local ref = sliderRefs[name]
        if not ref then return end
        local percent = (value - min) / (max - min)
        ref.label.Text = name.. ": ".. string.format("%.2f", value)
        ref.fill.Size = UDim2.new(percent,0,1,0)
        ref.knob.Position = UDim2.new(percent,-8,0.5,-8)
    end

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

        local percent = (default - min) / (max - min)

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
        clickDetector.Active = true

        sliderRefs[name] = {label = label, fill = sliderFill, knob = sliderBtn}

        local dragging = false
        local function updateSlider(xPos)
            local newPercent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = min + (newPercent * (max - min))
            label.Text = name..": ".. string.format("%.2f", value)
            callback(value)
            TweenService:Create(sliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(newPercent,0,1,0)}):Play()
            TweenService:Create(sliderBtn, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(newPercent,0,0.5,0)}):Play()
        end

        clickDetector.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                updateSlider(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 12, 0, 12)}):Play()
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
        local percent = (value - min) / (max - min)
        ref.label.Text = name.. ": ".. string.format("%.2f", value)
        TweenService:Create(ref.fill, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {Size = UDim2.new(percent,0,1,0)}):Play()
        TweenService:Create(ref.knob, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {Position = UDim2.new(percent,0,0.5,0)}):Play()
    end

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
        TweenService:Create(btnReset, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()

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

        local boxFlash, contentFlash = CreateGroupbox(rightColH, "Flashlight")
    boxFlash.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxFlash.BackgroundTransparency = 1
    boxFlash.BorderSizePixel = 0
    boxFlash.Size = UDim2.new(1,0,0,120)
    boxFlash.ClipsDescendants = false
    Instance.new("UICorner", boxFlash).CornerRadius = UDim.new(0,8)
    contentFlash.ClipsDescendants = false
    Instance.new("UIStroke", boxFlash).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentFlash).Padding = UDim.new(0, 8)

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

    local holderFlash = Instance.new("Frame", contentFlash)
    holderFlash.Size = UDim2.new(1,0,0,28)
    holderFlash.BackgroundTransparency = 1

    local labelFlash = Instance.new("TextLabel", holderFlash)
    labelFlash.Size = UDim2.new(1,-50,1,0)
    labelFlash.BackgroundTransparency = 1
    labelFlash.Text = "Enable"
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

    local holderSlider = Instance.new("Frame", contentFlash)
    holderSlider.Size = UDim2.new(1,0,0,50)
    holderSlider.BackgroundTransparency = 1

    local labelSlider = Instance.new("TextLabel", holderSlider)
    labelSlider.Size = UDim2.new(1,0,0,14)
    labelSlider.BackgroundTransparency = 1
    labelSlider.Text = "Brightness: ".. Brightness2
    labelSlider.Font = Enum.Font.GothamBold
    labelSlider.TextSize = 12
    labelSlider.TextColor3 = Color3.fromRGB(200,200,200)
    labelSlider.TextXAlignment = Enum.TextXAlignment.Left

    local sliderBg = Instance.new("Frame", holderSlider)
    sliderBg.Size = UDim2.new(1,0,0,4)
    sliderBg.Position = UDim2.new(0,0,0,24)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sliderBg.BorderSizePixel = 0
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

    local percent = (Brightness2 - 1) / 9

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
    clickDetector.Active = true

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

    local dragging = false
    local function updateSlider(xPos)
        local newPercent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        Brightness2 = math.floor(1 + (newPercent * 9))
        labelSlider.Text = "Brightness: ".. Brightness2
        if FlashEnabled then UpdateFlashlight(true) end
        TweenService:Create(sliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(newPercent,0,1,0)}):Play()
        TweenService:Create(sliderBtn, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(newPercent,0,0.5,0)}):Play()
    end

    clickDetector.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 14, 0, 14)}):Play()
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 12, 0, 12)}):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if FlashEnabled then UpdateFlashlight(true) end
    end)

    local boxFog, contentFog = CreateGroupbox(rightColH, "Fog")
    boxFog.BackgroundColor3 = Color3.fromRGB(30,30,30)
    boxFog.BackgroundTransparency = 1
    boxFog.BorderSizePixel = 0
    boxFog.Size = UDim2.new(1,0,0,150)
    boxFog.ClipsDescendants = false
    Instance.new("UICorner", boxFog).CornerRadius = UDim.new(0,8)
    contentFog.ClipsDescendants = false
    Instance.new("UIStroke", boxFog).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentFog).Padding = UDim.new(0, 8)

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

        local isAirport = workspace:FindFirstChild("Airport by deadlybones28")
        local isFacility = workspace:FindFirstChild("Facility_0 by MrWindy")

        if FogMode == "Black Fog" then
            Atmosphere.Color = Color3.fromRGB(0,0,0)
            Atmosphere.Haze = 2.46
            Sky.MoonAngularSize = 10
            Sky.StarCount = 0

            if isAirport then
                Atmosphere.Glare = 1.64
                Atmosphere.Decay = Color3.fromRGB(255,255,255)
                Atmosphere.Density = 0.9
            else
                Atmosphere.Glare = 0
                Atmosphere.Decay = Color3.fromRGB(0,0,0)
            end

            if isFacility then
                Atmosphere.Density = 0.85
            elseif not isAirport then
                Atmosphere.Density = 0.76
            end

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

        if FogConnection then
            FogConnection:Disconnect()
            FogConnection = nil
        end

        local lastUpdate = 0
        FogConnection = RunService.RenderStepped:Connect(function()
            if tick() - lastUpdate >= 6 then
                lastUpdate = tick()
                ApplyMode()
            end
        end)
    end

    local function StopFog()
        if FogConnection then
            FogConnection:Disconnect()
            FogConnection = nil
        end

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
    labelToggle.Text = "Enable"
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
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
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
                task.wait(6.5) -- TEMPO DO HACK
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

    -- AUTO REJOIN
    game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if Config.AutoRejoin and child.Name == "ErrorPrompt" then
            task.wait(5)
            TeleportService:Teleport(game.PlaceId, Player)
        end
    end)

    -- TOGGLES
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
    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1
    Instance.new("UIPadding", columnsH).PaddingTop = UDim.new(0, 10)

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Player = game:GetService("Players").LocalPlayer
    local playerGui = Player:WaitForChild("PlayerGui")

    local boxAimbot, contentAimbot = CreateGroupbox(leftColH, "Aimbot")
    boxAimbot.BackgroundColor3 = Color3.fromRGB(35,35,35)
    boxAimbot.BackgroundTransparency = 1
    boxAimbot.BorderSizePixel = 0
    boxAimbot.Size = UDim2.new(1,0,0,145)
    boxAimbot.ClipsDescendants = false
    Instance.new("UICorner", boxAimbot).CornerRadius = UDim.new(0,8)
    contentAimbot.ClipsDescendants = false
    Instance.new("UIStroke", boxAimbot).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentAimbot).Padding = UDim.new(0, 6)

    local AimbotMode = "Press"
    local AimbotActive = false
    local AimbotTarget = nil
    local AimbotConnection = nil
    local KeyConnection = nil
    local PlayerRemovingConnection = nil
    local ButtonConnection = nil
    local ButtonUpConnection = nil
    local AimbotLocked = false

    local function disconnectAll()
        if AimbotConnection then AimbotConnection:Disconnect() AimbotConnection = nil end
        if KeyConnection then KeyConnection:Disconnect() KeyConnection = nil end
        if PlayerRemovingConnection then PlayerRemovingConnection:Disconnect() PlayerRemovingConnection = nil end
        if ButtonConnection then ButtonConnection:Disconnect() ButtonConnection = nil end
        if ButtonUpConnection then ButtonUpConnection:Disconnect() ButtonUpConnection = nil end
    end

    local function stopAimbot()
        if AimbotConnection then
            AimbotConnection:Disconnect()
            AimbotConnection = nil
        end
        AimbotTarget = nil
        local gui = Player.PlayerGui:FindFirstChild("AimbotToggle")
        if gui then
            local toggleBtn = gui:FindFirstChild("Toggle")
            if toggleBtn then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                toggleBtn.Text = "OFF"
            end
        end
    end

    local function startAimbot()
        if AimbotConnection then AimbotConnection:Disconnect() end
        AimbotConnection = RunService.Heartbeat:Connect(function()
            if AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = AimbotTarget.Character.HumanoidRootPart
                local localPart = Player.Character.HumanoidRootPart
                local distance = (targetPart.Position - localPart.Position).Magnitude
                if distance <= 70 then
                    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPart.Position)
                else
                    stopAimbot()
                end
            else
                stopAimbot()
            end
        end)
        local gui = Player.PlayerGui:FindFirstChild("AimbotToggle")
        if gui then
            local toggleBtn = gui:FindFirstChild("Toggle")
            if toggleBtn then
                toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                toggleBtn.Text = "ON"
            end
        end
    end

    local function findClosestPlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        local screenCenter = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2)
        local players = game:GetService("Players"):GetPlayers()
        for i = 1, #players do
            local plr = players[i]
            if plr ~= Player and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(hrp.Position)
                    if onScreen then
                        local distance2D = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        local distance3D = (hrp.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                        if distance2D < shortestDistance and distance3D <= 70 then
                            shortestDistance = distance2D
                            closestPlayer = plr
                        end
                    end
                end
            end
        end
        return closestPlayer
    end

    local holderAimbot = Instance.new("Frame", contentAimbot)
    holderAimbot.Size = UDim2.new(1,0,0,28)
    holderAimbot.BackgroundTransparency = 1

    local labelAimbot = Instance.new("TextLabel", holderAimbot)
    labelAimbot.Size = UDim2.new(1,-50,1,0)
    labelAimbot.BackgroundTransparency = 1
    labelAimbot.Text = "Aimbot"
    labelAimbot.Font = Enum.Font.GothamBold
    labelAimbot.TextSize = 13
    labelAimbot.TextColor3 = Color3.fromRGB(235,235,235)
    labelAimbot.TextXAlignment = Enum.TextXAlignment.Left

    local btnAimbot = Instance.new("TextButton", holderAimbot)
    btnAimbot.Size = UDim2.new(0,44,0,20)
    btnAimbot.Position = UDim2.new(1,-44,0.5,-10)
    btnAimbot.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnAimbot.BackgroundTransparency = 0.65
    btnAimbot.Text = ""
    btnAimbot.BorderSizePixel = 0
    Instance.new("UICorner", btnAimbot).CornerRadius = UDim.new(1,0)

    local circleAimbot = Instance.new("Frame", btnAimbot)
    circleAimbot.Size = UDim2.new(0,16,0,16)
    circleAimbot.Position = UDim2.new(0,2,0.5,-8)
    circleAimbot.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circleAimbot.BorderSizePixel = 0
    Instance.new("UICorner", circleAimbot).CornerRadius = UDim.new(1,0)

    btnAimbot.MouseButton1Click:Connect(function()
        AimbotActive = not AimbotActive
        if AimbotActive then
            TweenService:Create(btnAimbot,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(circleAimbot,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()

            local existingGui = Player.PlayerGui:FindFirstChild("AimbotToggle")
            if existingGui then existingGui:Destroy() end
            disconnectAll()

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "AimbotToggle"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = Player:WaitForChild("PlayerGui")

            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "Toggle"
            ToggleButton.Parent = ScreenGui
            ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ToggleButton.BackgroundTransparency = 0.3
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(0, 10, 0.5, -21)
            ToggleButton.Size = UDim2.new(0, 105, 0, 46)
            ToggleButton.Font = Enum.Font.GothamBold
            ToggleButton.Text = "OFF"
            ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleButton.TextSize = 16
            ToggleButton.Active = true
            ToggleButton.Draggable = not AimbotLocked
            ToggleButton.AutoLocalize = false
            Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 8)

            KeyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    if AimbotTarget then
                        stopAimbot()
                    else
                        local closestPlayer = findClosestPlayer()
                        if closestPlayer then
                            AimbotTarget = closestPlayer
                            startAimbot()
                        end
                    end
                end
            end)

            local holding = false
            ButtonConnection = ToggleButton.MouseButton1Click:Connect(function()
                if AimbotMode ~= "Press" then return end
                if AimbotTarget then
                    stopAimbot()
                else
                    local closestPlayer = findClosestPlayer()
                    if closestPlayer then
                        AimbotTarget = closestPlayer
                        startAimbot()
                    end
                end
            end)

            ToggleButton.MouseButton1Down:Connect(function()
                if AimbotMode ~= "Hold" then return end
                if not holding then
                    holding = true
                    local closestPlayer = findClosestPlayer()
                    if closestPlayer then
                        AimbotTarget = closestPlayer
                        startAimbot()
                    end
                end
            end)

            ButtonUpConnection = ToggleButton.MouseButton1Up:Connect(function()
                if AimbotMode ~= "Hold" then return end
                holding = false
                stopAimbot()
            end)

            PlayerRemovingConnection = game:GetService("Players").PlayerRemoving:Connect(function(plr)
                if plr == AimbotTarget then stopAimbot() end
            end)
        else
            TweenService:Create(btnAimbot,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
            TweenService:Create(circleAimbot,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
            disconnectAll()
            AimbotTarget = nil
            local gui = Player.PlayerGui:FindFirstChild("AimbotToggle")
            if gui then gui:Destroy() end
        end
    end)

    local holderLock = Instance.new("Frame", contentAimbot)
    holderLock.Size = UDim2.new(1,0,0,28)
    holderLock.BackgroundTransparency = 1

    local labelLock = Instance.new("TextLabel", holderLock)
    labelLock.Size = UDim2.new(1,-50,1,0)
    labelLock.BackgroundTransparency = 1
    labelLock.Text = "Lock Aimbot"
    labelLock.Font = Enum.Font.GothamBold
    labelLock.TextSize = 13
    labelLock.TextColor3 = Color3.fromRGB(235,235,235)
    labelLock.TextXAlignment = Enum.TextXAlignment.Left

    local btnLock = Instance.new("TextButton", holderLock)
    btnLock.Size = UDim2.new(0,44,0,20)
    btnLock.Position = UDim2.new(1,-44,0.5,-10)
    btnLock.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnLock.BackgroundTransparency = 0.25
    btnLock.Text = ""
    btnLock.BorderSizePixel = 0
    Instance.new("UICorner", btnLock).CornerRadius = UDim.new(1,0)

    local circleLock = Instance.new("Frame", btnLock)
    circleLock.Size = UDim2.new(0,16,0,16)
    circleLock.Position = UDim2.new(0,2,0.5,-8)
    circleLock.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circleLock.BorderSizePixel = 0
    Instance.new("UICorner", circleLock).CornerRadius = UDim.new(1,0)

    btnLock.MouseButton1Click:Connect(function()
        AimbotLocked = not AimbotLocked
        if AimbotLocked then
            TweenService:Create(btnLock,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
            TweenService:Create(circleLock,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
        else
            TweenService:Create(btnLock,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
            TweenService:Create(circleLock,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
        end
        local gui = Player.PlayerGui:FindFirstChild("AimbotToggle")
        if gui then
            local button = gui:FindFirstChild("Toggle")
            if button then button.Draggable = not AimbotLocked end
        end
    end)

    local buttonHolder = Instance.new("Frame", contentAimbot)
    buttonHolder.Size = UDim2.new(1,0,0,26)
    buttonHolder.BackgroundTransparency = 1

    local btnPress = Instance.new("TextButton", buttonHolder)
    btnPress.Size = UDim2.new(0.5,-3,1,0)
    btnPress.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnPress.BackgroundTransparency = 0.65
    btnPress.Text = "Press"
    btnPress.Font = Enum.Font.GothamBold
    btnPress.TextSize = 12
    btnPress.TextColor3 = Color3.fromRGB(255,255,255)
    btnPress.BorderSizePixel = 0
    Instance.new("UICorner", btnPress).CornerRadius = UDim.new(0,6)

    local btnHold = Instance.new("TextButton", buttonHolder)
    btnHold.Size = UDim2.new(0.5,-3,1,0)
    btnHold.Position = UDim2.new(0.5,3,0,0)
    btnHold.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btnHold.BackgroundTransparency = 0.65
    btnHold.Text = "Hold"
    btnHold.Font = Enum.Font.GothamBold
    btnHold.TextSize = 12
    btnHold.TextColor3 = Color3.fromRGB(255,255,255)
    btnHold.BorderSizePixel = 0
    Instance.new("UICorner", btnHold).CornerRadius = UDim.new(0,6)

    local function updateButtons()
        if AimbotMode == "Press" then
            TweenService:Create(btnPress,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.3}):Play()
            TweenService:Create(btnHold,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.5}):Play()
        else
            TweenService:Create(btnHold,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.3}):Play()
            TweenService:Create(btnPress,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.5}):Play()
        end
    end

    btnPress.MouseButton1Click:Connect(function()
        AimbotMode = "Press"
        updateButtons()
    end)

    btnHold.MouseButton1Click:Connect(function()
        AimbotMode = "Hold"
        updateButtons()
    end)

    updateButtons()

    -- ========== HITBOX EXPANDER ==========
    local boxHitbox, contentHitbox = CreateGroupbox(leftColH, "Hitbox Expander")
    boxHitbox.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxHitbox.BackgroundTransparency = 1
    boxHitbox.BorderSizePixel = 0
    boxHitbox.Size = UDim2.new(1,0,0,130)
    boxHitbox.ClipsDescendants = false
    Instance.new("UICorner", boxHitbox).CornerRadius = UDim.new(0,8)
    contentHitbox.ClipsDescendants = false
    Instance.new("UIStroke", boxHitbox).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentHitbox).Padding = UDim.new(0, 6)

    if not getgenv().HitboxData then
        getgenv().HitboxData = {Enabled = false, Size = 5, Transparency = 0.7}
    end
    local HitboxData = getgenv().HitboxData
    local HitboxConnection = nil
    local OriginalSizes = {}

    local function resetHitbox(plr)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if OriginalSizes[plr] then
                hrp.Size = OriginalSizes[plr]
                hrp.Transparency = 1
                hrp.CanCollide = true
                hrp.Material = Enum.Material.Plastic
            end
        end
    end

    local function applyHitbox()
        if HitboxConnection then HitboxConnection:Disconnect() HitboxConnection = nil end

        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= Player then resetHitbox(plr) end
        end
        OriginalSizes = {}

        if not HitboxData.Enabled then return end

        HitboxConnection = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(game.Players:GetPlayers()) do
                if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                    local hrp = plr.Character.HumanoidRootPart
                    local hum = plr.Character.Humanoid

                    if hum.Health > 0 then
                        if not OriginalSizes[plr] then
                            OriginalSizes[plr] = hrp.Size
                        end

                        hrp.Size = Vector3.new(HitboxData.Size, HitboxData.Size, HitboxData.Size)
                        hrp.Transparency = HitboxData.Transparency
                        hrp.CanCollide = false
                        hrp.Material = Enum.Material.ForceField
                    else
                        resetHitbox(plr)
                    end
                end
            end
        end)
    end

    Player.CharacterAdded:Connect(function()
        task.wait(1)
        applyHitbox()
    end)

    do
        local holder = Instance.new("Frame", contentHitbox)
        holder.Size = UDim2.new(1,0,0,28)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,1,0)
        label.BackgroundTransparency = 1
        label.Text = "Enable Hitbox"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(0,44,0,20)
        btn.Position = UDim2.new(1,-44,0.5,-10)
        btn.BackgroundColor3 = HitboxData.Enabled and Color3.fromRGB(65,65,65) or Color3.fromRGB(45,45,45)
        btn.BackgroundTransparency = HitboxData.Enabled and 0.15 or 1
        btn.Text = ""
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0,16,0,16)
        circle.Position = HitboxData.Enabled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

        btn.MouseButton1Click:Connect(function()
            HitboxData.Enabled = not HitboxData.Enabled
            if HitboxData.Enabled then
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
            else
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
            end
            applyHitbox()
        end)
    end

    do
        local sliderFrame = Instance.new("Frame", contentHitbox)
        sliderFrame.Size = UDim2.new(1,0,0,50)
        sliderFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1,0,0,14)
        label.BackgroundTransparency = 1
        label.Text = "Hitbox: ".. string.format("%.1f", HitboxData.Size)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(200,200,200)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local inputHolder = Instance.new("Frame", sliderFrame)
        inputHolder.Size = UDim2.new(1, 0, 0, 30)
        inputHolder.Position = UDim2.new(0,0,0,20)
        inputHolder.BackgroundTransparency = 1

        local textBox = Instance.new("TextBox", inputHolder)
        textBox.Size = UDim2.new(1, -70, 1, 0)
        textBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
        textBox.BackgroundTransparency = 0.65
        textBox.TextColor3 = Color3.fromRGB(220,220,220)
        textBox.Font = Enum.Font.GothamBold
        textBox.TextSize = 12
        textBox.PlaceholderText = "Ex: 3.5"
        textBox.Text = string.format("%.1f", HitboxData.Size)
        textBox.ClearTextOnFocus = false
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0,6)

        local applyBtn = Instance.new("TextButton", inputHolder)
        applyBtn.Size = UDim2.new(0, 65, 1, 0)
        applyBtn.Position = UDim2.new(1, -65, 0, 0)
        applyBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        applyBtn.BackgroundTransparency = 0.65
        applyBtn.TextColor3 = Color3.fromRGB(220,220,220)
        applyBtn.Font = Enum.Font.GothamBold
        applyBtn.TextSize = 12
        applyBtn.Text = "Apply"
        Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0,6)

        local function applyValue(val)
            local num = tonumber(val)
            if not num then return end
            num = math.clamp(num, 2, 10)
            HitboxData.Size = num
            label.Text = "Hitbox: ".. string.format("%.1f", num)
            textBox.Text = string.format("%.1f", num)
        end

        applyBtn.MouseButton1Click:Connect(function()
            applyValue(textBox.Text)
        end)

        textBox.FocusLost:Connect(function(enter)
            if enter then applyValue(textBox.Text) end
        end)
    end

    local boxSpeed, contentSpeed = CreateGroupbox(rightColH, "WalkSpeed")
    boxSpeed.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxSpeed.BackgroundTransparency = 1
    boxSpeed.BorderSizePixel = 0
    boxSpeed.Size = UDim2.new(1,0,0,95)
    boxSpeed.ClipsDescendants = false
    Instance.new("UICorner", boxSpeed).CornerRadius = UDim.new(0,8)
    contentSpeed.ClipsDescendants = false
    Instance.new("UIStroke", boxSpeed).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentSpeed).Padding = UDim.new(0, 6)

    if not getgenv().SpeedData then
        getgenv().SpeedData = {Enabled = false, Value = 16}
    end
    local SpeedData = getgenv().SpeedData
    local defaultSpeed = 16
    _G.WalkSpeedConnection = nil

    do
        local holder = Instance.new("Frame", contentSpeed)
        holder.Size = UDim2.new(1,0,0,28)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,1,0)
        label.BackgroundTransparency = 1
        label.Text = "Enable"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(0,44,0,20)
        btn.Position = UDim2.new(1,-44,0.5,-10)
        btn.BackgroundColor3 = SpeedData.Enabled and Color3.fromRGB(65,65,65) or Color3.fromRGB(45,45,45)
        btn.BackgroundTransparency = SpeedData.Enabled and 0.15 or 1
        btn.Text = ""
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0,16,0,16)
        circle.Position = SpeedData.Enabled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

        local function setSpeed()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = SpeedData.Enabled and SpeedData.Value or defaultSpeed
            end
        end

        btn.MouseButton1Click:Connect(function()
            SpeedData.Enabled = not SpeedData.Enabled
            if SpeedData.Enabled then
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
                setSpeed()
                if _G.WalkSpeedConnection then _G.WalkSpeedConnection:Disconnect() end
                _G.WalkSpeedConnection = Player.CharacterAdded:Connect(function(char)
                    char:WaitForChild("Humanoid").WalkSpeed = SpeedData.Value
                end)
            else
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
                if _G.WalkSpeedConnection then
                    _G.WalkSpeedConnection:Disconnect()
                    _G.WalkSpeedConnection = nil
                end
                setSpeed()
            end
        end)
    end

    do
        local sliderFrame = Instance.new("Frame", contentSpeed)
        sliderFrame.Size = UDim2.new(1,0,0,50)
        sliderFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1,0,0,14)
        label.BackgroundTransparency = 1
        label.Text = "Speed: ".. SpeedData.Value
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(200,200,200)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1,0,0,4)
        sliderBg.Position = UDim2.new(0,0,0,24)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
        sliderBg.BorderSizePixel = 0
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new((SpeedData.Value - 16) / 34,0,1,0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        sliderFill.BorderSizePixel = 0
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

        local sliderBtn = Instance.new("Frame", sliderBg)
        sliderBtn.Size = UDim2.new(0,12,0,12)
        sliderBtn.Position = UDim2.new((SpeedData.Value - 16) / 34,0,0.5,0)
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
        clickDetector.Active = true

        local dragging = false
        local function updateSlider(xPos)
            local percent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = 16 + 34 * percent
            SpeedData.Value = value
            label.Text = "Speed: ".. math.floor(value)
            TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(percent,0,1,0)}):Play()
            TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(percent,0,0.5,0)}):Play()
            if SpeedData.Enabled then
                local char = Player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = value
                end
            end
        end

        clickDetector.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                TweenService:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                updateSlider(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 12, 0, 12)}):Play()
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)
    end

    local boxJump, contentJump = CreateGroupbox(rightColH, "High Jump")
    boxJump.BackgroundColor3 = Color3.fromRGB(25,25,25)
    boxJump.BackgroundTransparency = 1
    boxJump.BorderSizePixel = 0
    boxJump.Size = UDim2.new(1,0,0,95)
    boxJump.ClipsDescendants = false
    Instance.new("UICorner", boxJump).CornerRadius = UDim.new(0,8)
    contentJump.ClipsDescendants = false
    Instance.new("UIStroke", boxJump).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentJump).Padding = UDim.new(0, 6)

    if not getgenv().JumpData then
        getgenv().JumpData = {Enabled = false, Value = 50}
    end
    local JumpData = getgenv().JumpData
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

        if JumpData.Enabled then
            humanoid.UseJumpPower = true
            humanoid.JumpPower = JumpData.Value
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

    do
        local holder = Instance.new("Frame", contentJump)
        holder.Size = UDim2.new(1,0,0,28)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-50,1,0)
        label.BackgroundTransparency = 1
        label.Text = "Enable High Jump"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local btn = Instance.new("TextButton", holder)
        btn.Size = UDim2.new(0,44,0,20)
        btn.Position = UDim2.new(1,-44,0.5,-10)
        btn.BackgroundColor3 = JumpData.Enabled and Color3.fromRGB(65,65,65) or Color3.fromRGB(45,45,45)
        btn.BackgroundTransparency = JumpData.Enabled and 0.15 or 1
        btn.Text = ""
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)

        local circle = Instance.new("Frame", btn)
        circle.Size = UDim2.new(0,16,0,16)
        circle.Position = JumpData.Enabled and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
        circle.BorderSizePixel = 0
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

        btn.MouseButton1Click:Connect(function()
            JumpData.Enabled = not JumpData.Enabled
            if JumpData.Enabled then
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(65,65,65), BackgroundTransparency = 0.15}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(1,-18,0.5,-8)}):Play()
            else
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(45,45,45), BackgroundTransparency = 0.25}):Play()
                TweenService:Create(circle,TweenInfo.new(0.15),{Position = UDim2.new(0,2,0.5,-8)}):Play()
            end
            applyJump()
        end)
    end

    do
        local sliderFrame = Instance.new("Frame", contentJump)
        sliderFrame.Size = UDim2.new(1,0,0,50)
        sliderFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", sliderFrame)
        label.Size = UDim2.new(1,0,0,14)
        label.BackgroundTransparency = 1
        label.Text = "Jump Power: ".. JumpData.Value
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextColor3 = Color3.fromRGB(200,200,200)
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1,0,0,4)
        sliderBg.Position = UDim2.new(0,0,0,24)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
        sliderBg.BorderSizePixel = 0
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

        local sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new((JumpData.Value - 50) / 150,0,1,0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255,255,255)
        sliderFill.BorderSizePixel = 0
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1,0)

        local sliderBtn = Instance.new("Frame", sliderBg)
        sliderBtn.Size = UDim2.new(0,12,0,12)
        sliderBtn.Position = UDim2.new((JumpData.Value - 50) / 150,0,0.5,0)
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
        clickDetector.Active = true

        local dragging = false
        local function updateSlider(xPos)
            local percent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = 50 + 150 * percent
            JumpData.Value = value
            label.Text = "Jump Power: ".. math.floor(value)
            TweenService:Create(sliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(percent,0,1,0)}):Play()
            TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(percent,0,0.5,0)}):Play()
            if JumpData.Enabled then
                applyJump()
            end
        end

        clickDetector.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                TweenService:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                updateSlider(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(sliderBtn, TweenInfo.new(0.1), {Size = UDim2.new(0, 12, 0, 12)}):Play()
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)
    end
end

do
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    local Player = Players.LocalPlayer
    local settingsPageP = pages["Visual Skins"]
    if not settingsPageP then return end

    settingsPageP:ClearAllChildren()
    settingsPageP.CanvasSize = UDim2.new(0, 0, 0, 0)
    settingsPageP.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsPageP.ScrollBarThickness = 3
    
    local padding = Instance.new("UIPadding", settingsPageP)
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    
    Instance.new("UIListLayout", settingsPageP).Padding = UDim.new(0, 12)

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
    searchHolder.BackgroundColor3 = Color3.fromRGB(30,30,30)
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
    searchBox.ZIndex = 2

    local searchIcon = Instance.new("ImageButton", searchHolder)
    searchIcon.Size = UDim2.new(0, 18, 0, 18)
    searchIcon.Position = UDim2.new(1, -28, 0.5, -9)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://6031154871"
    searchIcon.ImageColor3 = Color3.fromRGB(150,150,150)
    searchIcon.ZIndex = 2

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

    local function searchUser()
        if searchBox.Text == "" then return end
        local success, userId = pcall(function()
            return Players:GetUserIdFromNameAsync(searchBox.Text)
        end)
        if success then TransformarSkin(userId) end
    end

    searchBox.FocusLost:Connect(function(enter)
        if enter then searchUser() end
    end)

    searchIcon.MouseButton1Click:Connect(searchUser)

    local skinGrid = Instance.new("Frame", settingsPageP)
    skinGrid.Size = UDim2.new(1, 0, 0, 0)
    skinGrid.AutomaticSize = Enum.AutomaticSize.Y
    skinGrid.BackgroundTransparency = 1
    skinGrid.LayoutOrder = 3
    
    local gridLayout = Instance.new("UIGridLayout", skinGrid)
    gridLayout.CellSize = UDim2.new(0.25, -4, 0, 50)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder

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
        {name = "Luufyzinho0", id = 3386809191},
        {name = "GabrielMasterPlay2", id = 10745780794},
        {name = "Znerx3ys", id = 708884161},
        {name = "eduttk7", id = 5801621121},
        {name = "TryNotToRage", id = 10279120783},
        {name = "DraxynSoulx", id = 2396362636},
        {name = "Gaie_VR", id = 1244277839},
        {name = "totallyvelez", id = 3597977804},
        {name = "steik00s", id = 4644831551},
        {name = "1Dxqzz", id = 2425366002},
        {name = "shelbws1", id = 9373698388},
        {name = "Guime_blox", id = 2633091297},
        {name = "Mwaiconn", id = 3948962607},
    }

    for i, skin in ipairs(skinList) do
        local card = Instance.new("TextButton", skinGrid)
        card.BackgroundColor3 = Color3.fromRGB(30,30,30)
        card.BackgroundTransparency = 0.3
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
            TransformarSkin(skin.id)
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
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local columnsH = Instance.new("Frame", mainHolder)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

    -- BOX 1: MAP OBJECTS - TRANSPARENTE 1
    local boxMap, contentMap = CreateGroupbox(leftColH, "Map Objects")
    boxMap.BackgroundColor3 = Color3.fromRGB(20,20,20)
    boxMap.BackgroundTransparency = 1 -- AGORA 100% TRANSPARENTE
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
    boxExtra.BackgroundTransparency = 1 -- AGORA 100% TRANSPARENTE
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
    boxPlayers.BackgroundColor3 = Color3.fromRGB(20,20,20)
    boxPlayers.BackgroundTransparency = 1 -- AGORA 100% TRANSPARENTE
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
                plrFrame.BackgroundTransparency = 0.4 -- ESSE MANTEM PRA DESTACAR O CARD
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
    local columnsH = Instance.new("Frame", settingsPageH)
    columnsH.Size = UDim2.new(1, 0, 0, 0)
    columnsH.AutomaticSize = Enum.AutomaticSize.Y
    columnsH.BackgroundTransparency = 1

    local leftColH = Instance.new("Frame", columnsH)
    leftColH.Size = UDim2.new(0.5, -5, 0, 0)
    leftColH.AutomaticSize = Enum.AutomaticSize.Y
    leftColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", leftColH).Padding = UDim.new(0, 10)

    local rightColH = Instance.new("Frame", columnsH)
    rightColH.Size = UDim2.new(0.5, -5, 0, 0)
    rightColH.Position = UDim2.new(0.5, 5, 0, 0)
    rightColH.AutomaticSize = Enum.AutomaticSize.Y
    rightColH.BackgroundTransparency = 1
    Instance.new("UIListLayout", rightColH).Padding = UDim.new(0, 10)

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

    local function CreateVolumeSlider(parent, text, default, callback)
        local holder = Instance.new("Frame", parent)
        holder.Size = UDim2.new(1,0,0,50)
        holder.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,0,0,14)
        label.BackgroundTransparency = 1
        label.Text = text..": ".. default
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

        local percent = default / 10

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
        clickDetector.Active = true

        local dragging = false
        local function updateSlider(xPos)
            local newPercent = math.clamp((xPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            local value = math.floor(newPercent * 10)
            label.Text = text..": ".. value
            if callback then callback(value) end
            TweenService:Create(sliderFill, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(newPercent,0,1,0)}):Play()
            TweenService:Create(sliderBtn, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = UDim2.new(newPercent,0,0.5,0)}):Play()
        end

        clickDetector.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                updateSlider(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenService:Create(sliderBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 12, 0, 12)}):Play()
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input.Position.X)
            end
        end)

        return {SetValue = function(val)
            local p = val / 10
            label.Text = text..": ".. val
            sliderFill.Size = UDim2.new(p,0,1,0)
            sliderBtn.Position = UDim2.new(p,0,0.5,0)
            if callback then callback(val) end
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
    volumeBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
    volumeBox.BackgroundTransparency = 1
    Instance.new("UICorner", volumeBox).CornerRadius = UDim.new(0,8)

    local footstepSlider = CreateVolumeSlider(volumeContent, "FootSteps", 1, function(v) FootstepVolume = v ApplyAllVolumes() end)
    local jumpSlider = CreateVolumeSlider(volumeContent, "Jump", 1, function(v) JumpVolume = v ApplyAllVolumes() end)
    local fallSlider = CreateVolumeSlider(volumeContent, "Fall", 1, function(v) FallVolume = v ApplyAllVolumes() end)

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
    CreateSoundButton(facilityContent, "FootSteps", "Footsteps", "131592620665625")
    CreateSoundButton(facilityContent, "Jump", "Jump", "89459688918065")

    local morcegoCat, morcegoContent = CreateGroupbox(leftColH, "Tio Morcego")
    CreateSoundButton(morcegoContent, "FootSteps", "Footsteps", "97458293386939")
    CreateSoundButton(morcegoContent, "Jump", "Jump", "72503238596964")
    CreateSoundButton(morcegoContent, "Fall", "Fall", "83702883984130")

    local extrasCat, extrasContent = CreateGroupbox(leftColH, "Extras Jumps")
    CreateSoundButton(extrasContent, "Pew Jump", "Jump", "136299701781122")
    CreateSoundButton(extrasContent, "Sharingan Jump", "Jump", "118102230060662")
    CreateSoundButton(extrasContent, "Bubble Jump", "Jump", "129415490412106")
    CreateSoundButton(extrasContent, "RF Jump", "Jump", "80276851298640")

    local normalCat, normalContent = CreateGroupbox(rightColH, "Normal")
    CreateSoundButton(normalContent, "FootSteps", "Footsteps", "79392671800290")
    CreateSoundButton(normalContent, "Jump", "Jump", "80853972291847")
    CreateSoundButton(normalContent, "Fall", "Fall", "88947883822456")

    local noobCat, noobContent = CreateGroupbox(rightColH, "NoobTwoPointOh")
    CreateSoundButton(noobContent, "FootSteps", "Footsteps", "110709356093026")
    CreateSoundButton(noobContent, "Jump", "Jump", "124276657634407")

    local fkpsCat, fkpsContent = CreateGroupbox(rightColH, "FKPS")
    CreateSoundButton(fkpsContent, "FootSteps", "Footsteps", "97733831736820")
    CreateSoundButton(fkpsContent, "Jump", "Jump", "86031664547378")
    CreateSoundButton(fkpsContent, "Fall", "Fall", "78180192109919")

    task.wait(2)
    ApplySound("Footsteps", SelectedSounds.Footsteps)
    ApplySound("Jump", SelectedSounds.Jump)
    ApplySound("Fall", SelectedSounds.Fall)
end)

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

    local mainGui = playerGui:FindFirstChild("EclipseUI")

    local function GetMainFrame()
        return frame
    end

    if not isfolder("FTF_Eclipse") then makefolder("FTF_Eclipse") end

    local function SaveConfig()
        local data = {
            MenuKeybind = getgenv().MenuKeybind or "K",
            BackgroundID = getgenv().CustomBackgroundID or "",
            UIBackground = getgenv().UIBackground or "Style 1"
        }
        writefile("FTF_Eclipse/config.json", HttpService:JSONEncode(data))
    end

    local function LoadConfig()
        if isfile("FTF_Eclipse/config.json") then
            local data = HttpService:JSONDecode(readfile("FTF_Eclipse/config.json"))
            getgenv().MenuKeybind = data.MenuKeybind or "K"
            getgenv().CustomBackgroundID = data.BackgroundID or ""
            getgenv().UIBackground = data.UIBackground or "Style 1"
            return data
        end
        return nil
    end

    LoadConfig()

    local container = Instance.new("Frame", settingsPageH)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    Instance.new("UIPadding", container).PaddingTop = UDim.new(0, 10)
    Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

    local function UpdateBackground(id)
        local mainFrame = GetMainFrame()
        if not mainFrame then return end

        local originalBg = mainFrame:FindFirstChild("bg") or mainFrame:FindFirstChild("Background")
        if originalBg then originalBg:Destroy() end

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

    local boxConfig, contentConfig = CreateGroupbox(container, "Menu Configuration")
    boxConfig.BackgroundTransparency = 1
    boxConfig.BorderSizePixel = 0
    boxConfig.Size = UDim2.new(1,0,0,0)
    boxConfig.AutomaticSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", boxConfig).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", boxConfig).Color = Color3.fromRGB(70,70,70)
    Instance.new("UIListLayout", contentConfig).Padding = UDim.new(0, 8)
    contentConfig.ZIndex = 2

    do
        local holder = Instance.new("Frame", contentConfig)
        holder.Size = UDim2.new(1,0,0,32)
        holder.BackgroundColor3 = Color3.fromRGB(18,18,22)
        holder.BackgroundTransparency = 0.3
        holder.ZIndex = 2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-75,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = "Menu Keybind:"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3

        local keyBtn = Instance.new("TextButton", holder)
        keyBtn.Size = UDim2.new(0,55,0,24)
        keyBtn.Position = UDim2.new(1,-65,0.5,-12)
        keyBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        keyBtn.BackgroundTransparency = 0.3
        keyBtn.Text = getgenv().MenuKeybind or "K"
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.TextSize = 13
        keyBtn.TextColor3 = Color3.fromRGB(235,235,235)
        keyBtn.BorderSizePixel = 0
        keyBtn.ZIndex = 3
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,6)

        local listening = false
        local listenConn = nil

        keyBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            keyBtn.Text = "..."

            if listenConn then listenConn:Disconnect() end

            listenConn = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local keyName = input.KeyCode.Name
                    if keyName ~= "Unknown" then
                        getgenv().MenuKeybind = keyName
                        keyBtn.Text = keyName
                        SaveConfig()
                        listening = false
                        listenConn:Disconnect()
                        listenConn = nil
                    end
                end
            end)
        end)

        if not getgenv().KeybindConnection then
            getgenv().KeybindConnection = UserInputService.InputBegan:Connect(function(input, gpe)
                if gpe or listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode.Name == (getgenv().MenuKeybind or "K") then
                        local gui = playerGui:FindFirstChild("EclipseUI")
                        if gui then
                            gui.Enabled = not gui.Enabled
                        end
                    end
                end
            end)
        end
    end

    do
        local holder = Instance.new("Frame", contentConfig)
        holder.Size = UDim2.new(1,0,0,32)
        holder.BackgroundColor3 = Color3.fromRGB(18,18,22)
        holder.BackgroundTransparency = 0.3
        holder.ZIndex = 2
        holder.ClipsDescendants = false
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,-40,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = "UI Background: ".. (getgenv().UIBackground or "Style 1")
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3

        local arrow = Instance.new("TextLabel", holder)
        arrow.Size = UDim2.new(0,20,1,0)
        arrow.Position = UDim2.new(1,-25,0,0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.TextColor3 = Color3.fromRGB(180,180,180)
        arrow.ZIndex = 3

        local clickArea = Instance.new("TextButton", holder)
        clickArea.Size = UDim2.new(1,0,1,0)
        clickArea.BackgroundTransparency = 1
        clickArea.Text = ""
        clickArea.ZIndex = 4

        local dropdownFrame = Instance.new("ScrollingFrame", contentConfig)
        dropdownFrame.Size = UDim2.new(1,0,0,0)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(15,15,18)
        dropdownFrame.BackgroundTransparency = 0.1
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.Visible = false
        dropdownFrame.ZIndex = 10
        dropdownFrame.ScrollBarThickness = 2
        dropdownFrame.ScrollBarImageColor3 = Color3.fromRGB(255,255,255)
        dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
        dropdownFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Instance.new("UICorner", dropdownFrame).CornerRadius = UDim.new(0,8)
        Instance.new("UIStroke", dropdownFrame).Color = Color3.fromRGB(50,50,55)

        local listLayout = Instance.new("UIListLayout", dropdownFrame)
        listLayout.Padding = UDim.new(0,0)

        local backgrounds = {
            {"Style 1", "94865353552525"},
            {"Style 2", "85784609294289"},
            {"Style 3", "140636010520663"},
            {"Style 4", "124240486073107"},
            {"Style 5", "85635291549219"},
            {"Style 6", "117512819334968"},
            {"Style 7", "111750153717391"},
            {"Style 8", "98791036867631"},
            {"Style 9", "131737959610359"},
            {"Style 10", "81997082602790"},
            {"Style 11", "117151748213203"},
            {"Style 12", "112483283923855"}
        }

        local isOpen = false

        for i, data in ipairs(backgrounds) do
            local option = Instance.new("TextButton", dropdownFrame)
            option.Size = UDim2.new(1,0,0,32)
            option.BackgroundTransparency = 1
            option.Text = data[1]
            option.Font = Enum.Font.Gotham
            option.TextSize = 13
            option.TextColor3 = data[1] == getgenv().UIBackground and Color3.fromRGB(255,255,255) or Color3.fromRGB(140,140,140)
            option.BorderSizePixel = 0
            option.ZIndex = 11

            local line = Instance.new("Frame", option)
            line.Size = UDim2.new(1,0,0,1)
            line.Position = UDim2.new(0,0,1,0)
            line.BackgroundColor3 = Color3.fromRGB(40,40,45)
            line.BorderSizePixel = 0
            line.ZIndex = 11
            if i == #backgrounds then line.Visible = false end

            option.MouseButton1Click:Connect(function()
                label.Text = "UI Background: ".. data[1]
                getgenv().UIBackground = data[1]
                getgenv().CustomBackgroundID = "rbxassetid://".. data[2]
                UpdateBackground(data[2])
                SaveConfig()
                TweenService:Create(dropdownFrame, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)}):Play()
                task.wait(0.15)
                dropdownFrame.Visible = false
                arrow.Text = "▼"
                isOpen = false
            end)
        end

        clickArea.MouseButton1Click:Connect(function()
            isOpen = not isOpen
            if isOpen then
                dropdownFrame.Visible = true
                arrow.Text = "▲"
                TweenService:Create(dropdownFrame, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,160)}):Play()
            else
                TweenService:Create(dropdownFrame, TweenInfo.new(0.15), {Size = UDim2.new(1,0,0,0)}):Play()
                task.wait(0.15)
                dropdownFrame.Visible = false
                arrow.Text = "▼"
            end
        end)

        task.defer(function()
            if getgenv().CustomBackgroundID then
                local id = getgenv().CustomBackgroundID:match("%d+")
                if id then UpdateBackground(id) end
            end
        end)
    end

    do
        local holder = Instance.new("Frame", contentConfig)
        holder.Size = UDim2.new(1,0,0,32)
        holder.BackgroundColor3 = Color3.fromRGB(18,18,22)
        holder.BackgroundTransparency = 0.3
        holder.ZIndex = 2
        Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

        local label = Instance.new("TextLabel", holder)
        label.Size = UDim2.new(1,0,1,0)
        label.Position = UDim2.new(0,15,0,0)
        label.BackgroundTransparency = 1
        label.Text = "Custom Background ID"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(235,235,235)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 3

        local inputBox = Instance.new("TextBox", holder)
        inputBox.Size = UDim2.new(1,0,1,0)
        inputBox.BackgroundTransparency = 1
        inputBox.PlaceholderText = "ID..."
        inputBox.Text = ""
        inputBox.Font = Enum.Font.Gotham
        inputBox.TextSize = 13
        inputBox.TextColor3 = Color3.fromRGB(235,235,235)
        inputBox.PlaceholderColor3 = Color3.fromRGB(100,100,100)
        inputBox.TextXAlignment = Enum.TextXAlignment.Right
        inputBox.ClearTextOnFocus = false
        inputBox.ZIndex = 3
        Instance.new("UIPadding", inputBox).PaddingRight = UDim.new(0,15)

        inputBox.FocusLost:Connect(function(enter)
            if enter then
                local id = inputBox.Text:match("%d+")
                if id then
                    getgenv().CustomBackgroundID = "rbxassetid://".. id
                    UpdateBackground(id)
                    SaveConfig()
                end
            end
        end)
    end
end

-- ========= SISTEMA GLOBAL =========
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
		CoOwner = "Co-owner: @gustavo_bawnana",
		TestersList = "Testers: Kira, Luan, Vitor & Mz",
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
		CoOwner = "Sub-Dono: @gustavo_bawnana",
		TestersList = "Testadores: Kira, Luan, Vitor & Mz",
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

-- ========= SCRIPT INFO =========
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
    E.frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    MakeLabel(g.cc, "Owner: @kayqueneverxita.", false, "Owner")
    MakeLabel(g.cc, "Co-owner: @gustavo_bawnana", false, "CoOwner")
    MakeLabel(g.tc, "Testers: Kira, Luan, Vitor & Mz", false, "TestersList")

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
    E.closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    E.closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    E.closeBtn.BackgroundTransparency = 1
    E.closeBtn.TextTransparency = 1
    E.closeBtn.AutoButtonColor = false
    Instance.new("UICorner", E.closeBtn).CornerRadius = UDim.new(0, 6)
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
    C.frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    C.frame.BackgroundTransparency = 1
    C.frame.Visible = false
    C.frame.ZIndex = 10
    C.frame.Parent = gui
    Instance.new("UICorner", C.frame).CornerRadius = UDim.new(0, 8)

    C.stroke = Instance.new("UIStroke", C.frame)
    C.stroke.Color = Color3.fromRGB(50, 50, 50)
    C.stroke.Thickness = 1
    C.stroke.Transparency = 1

    C.redLine = Instance.new("Frame", C.frame)
    C.redLine.Size = UDim2.new(1, 0, 0, 2)
    C.redLine.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    C.redLine.BackgroundTransparency = 1
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
    UserInputService = game:GetService("UserInputService")
    local isPC = UserInputService.KeyboardEnabled

    if isPC and openButton then
        openButton.Visible = false
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not isPC then return end
        if input.KeyCode == Enum.KeyCode.K then
            frame.Visible = not frame.Visible
            if blur then blur.Size = frame.Visible and 20 or 0 end
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
            if blur then blur.Size = 20 end
        end
    end)
end

UpdateLanguage()
