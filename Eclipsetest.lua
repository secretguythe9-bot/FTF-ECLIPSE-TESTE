local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local gui = player:WaitForChild("PlayerGui"):FindFirstChild("EclipseAnnounceGui")
if gui then gui:Destroy() end
gui = Instance.new("ScreenGui")
gui.Name = "EclipseAnnounceGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local announceTexts = {
    EN = {
        title = "Thank You!",
        desc1 = "Thank you for taking the time to test FTF Eclipse.",
        desc2 = "Your support, feedback, and bug reports help improve the project with every update. Every issue you find and every suggestion you share makes a real difference.",
        desc3 = "We truly appreciate your help and hope you enjoy using FTF Eclipse.",
        desc4 = "Thank you for being part of the journey.",
        btn_exit = "CLOSE"
    },
    PT = {
        title = "Obrigado!",
        desc1 = "Obrigado por dedicar seu tempo testando o FTF Eclipse.",
        desc2 = "Seu apoio, feedback e relatórios de bugs ajudam a melhorar o projeto a cada atualização. Cada problema que você encontra e cada sugestão que compartilha faz uma diferença real.",
        desc3 = "Nós realmente agradecemos sua ajuda e esperamos que você curta usar o FTF Eclipse.",
        desc4 = "Obrigado por fazer parte da jornada.",
        btn_exit = "FECHAR"
    }
}

local currentLang = "EN"

local announceFrame = Instance.new("Frame", gui)
announceFrame.Size = UDim2.new(0, 0, 0, 0)
announceFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
announceFrame.AnchorPoint = Vector2.new(0.5, 0.5)
announceFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
announceFrame.BackgroundTransparency = 0.05
announceFrame.ZIndex = 100
Instance.new("UICorner", announceFrame).CornerRadius = UDim.new(0, 10)

local announceStroke = Instance.new("UIStroke", announceFrame)
announceStroke.Color = Color3.fromRGB(255, 255, 255)
announceStroke.Thickness = 1.5
announceStroke.Transparency = 0.4

local announceLangBtn = Instance.new("TextButton", announceFrame)
announceLangBtn.Size = UDim2.new(0, 28, 0, 24)
announceLangBtn.Position = UDim2.new(1, -34, 0, 8)
announceLangBtn.Text = currentLang
announceLangBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
announceLangBtn.BackgroundTransparency = 0.3
announceLangBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
announceLangBtn.TextSize = 13
announceLangBtn.Font = Enum.Font.GothamBold
announceLangBtn.ZIndex = 102
Instance.new("UICorner", announceLangBtn).CornerRadius = UDim.new(0, 5)

local announceTitle = Instance.new("TextLabel", announceFrame)
announceTitle.Size = UDim2.new(1, -50, 0, 24)
announceTitle.Position = UDim2.new(0, 15, 0, 10)
announceTitle.BackgroundTransparency = 1
announceTitle.Text = announceTexts[currentLang].title
announceTitle.Font = Enum.Font.GothamBold
announceTitle.TextSize = 16
announceTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
announceTitle.TextXAlignment = Enum.TextXAlignment.Center
announceTitle.ZIndex = 101

local scrollFrame = Instance.new("ScrollingFrame", announceFrame)
scrollFrame.Size = UDim2.new(1, -24, 1, -78)
scrollFrame.Position = UDim2.new(0, 12, 0, 38)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ZIndex = 101

local textLayout = Instance.new("UIListLayout", scrollFrame)
textLayout.Padding = UDim.new(0, 6)
textLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createText(text, order)
    local label = Instance.new("TextLabel", scrollFrame)
    label.Size = UDim2.new(1, -6, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = true
    label.ZIndex = 101
    label.LayoutOrder = order
end

local function loadTexts()
    for _, child in pairs(scrollFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    createText(announceTexts[currentLang].desc1, 1)
    createText(announceTexts[currentLang].desc2, 2)
    createText(announceTexts[currentLang].desc3, 3)
    createText(announceTexts[currentLang].desc4, 4)
end

loadTexts()

local exitBtn = Instance.new("TextButton", announceFrame)
exitBtn.Size = UDim2.new(1, -24, 0, 28)
exitBtn.Position = UDim2.new(0, 12, 1, -36)
exitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
exitBtn.Text = announceTexts[currentLang].btn_exit
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.Font = Enum.Font.GothamBold
exitBtn.TextSize = 13
exitBtn.ZIndex = 102
Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(0, 6)

TweenService:Create(announceFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 220)
}):Play()

announceLangBtn.MouseButton1Click:Connect(function()
    currentLang = currentLang == "EN" and "PT" or "EN"
    announceLangBtn.Text = currentLang
    announceTitle.Text = announceTexts[currentLang].title
    exitBtn.Text = announceTexts[currentLang].btn_exit
    loadTexts()
end)

exitBtn.MouseButton1Click:Connect(function()
    TweenService:Create(announceFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.25)
    gui:Destroy()
end)
