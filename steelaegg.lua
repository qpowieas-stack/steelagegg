-- Roblox Delta Script: Steal The Egg (Classic UI)
-- Created for Executor: Delta

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FreezeBtn = Instance.new("TextButton")
local SpeedBtn = Instance.new("TextButton")
local JumpBtn = Instance.new("TextButton")
local EspBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- إعداد الواجهة الرئيسية
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "StealEggClassicUI"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 260)
MainFrame.Active = true
MainFrame.Draggable = true -- إمكانية سحب القائمة

-- عنوان القائمة (تصميم كلاسيكي)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "🥚 Steal The Egg - Classic"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- زر الإخفاء (-) في الزاوية علوياً
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Position = UDim2.new(0.92, 0, 0.05, 0)
ToggleBtn.Size = UDim2.new(0, 35, 0, 35)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 24
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

-- وظيفة زر الإخفاء (-)
local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    if menuVisible then
        ToggleBtn.Text = "-"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        ToggleBtn.Text = "+"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    end
end)

-- وظيفة إنشاء الأزرار داخل القائمة
local function createButton(name, text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Position = pos
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    return btn
end

-- الأزرار
local freezeToggle = false
FreezeBtn = createButton("FreezeBtn", "تجميد الحيوانات: OFF", UDim2.new(0.075, 0, 0.2, 0), Color3.fromRGB(150, 50, 50))

local speedToggle = false
SpeedBtn = createButton("SpeedBtn", "سرعة خارقة (Speed): OFF", UDim2.new(0.075, 0, 0.38, 0), Color3.fromRGB(60, 60, 60))

local jumpToggle = false
JumpBtn = createButton("JumpBtn", "قفز عالي (High Jump): OFF", UDim2.new(0.075, 0, 0.56, 0), Color3.fromRGB(60, 60, 60))

local espToggle = false
EspBtn = createButton("EspBtn", "كشف مكان البيض (ESP): OFF", UDim2.new(0.075, 0, 0.74, 0), Color3.fromRGB(60, 60, 60))

-----------------------------------------------------
-- البرمجة والوظائف (Logic)
-----------------------------------------------------

-- 1. منع الحيوانات من الملاحقة (تجميد/تعطيل الذكاء الاصطناعي للحيوانات)
FreezeBtn.MouseButton1Click:Connect(function()
    freezeToggle = not freezeToggle
    if freezeToggle then
        FreezeBtn.Text = "تجميد الحيوانات: ON"
        FreezeBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    else
        FreezeBtn.Text = "تجميد الحيوانات: OFF"
        FreezeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    end
end)

-- حلقة تكرار لتجميد حركة الأعداء والحيوانات حولك
task.spawn(function()
    while task.wait(0.5) do
        if freezeToggle then
            for _, obj in pairs(workspace:GetDescendants()) do
                -- البحث عن الكائنات التي تحوي Humanoid وليست اللاعب نفسه
                if obj:IsA("Humanoid") and not obj.Parent:FindFirstChild("HumanoidRootPart") == game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if obj.Parent.Name ~= game.Players.LocalPlayer.Name then
                        obj.WalkSpeed = 0
                        if obj.Parent:FindFirstChild("HumanoidRootPart") then
                            obj.Parent.HumanoidRootPart.Anchored = true
                        end
                    end
                end
            end
        else
            -- إرجاع الحركة للحيوانات عند إيقاف الزر
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Humanoid") and obj.Parent.Name ~= game.Players.LocalPlayer.Name then
                    obj.WalkSpeed = 16
                    if obj.Parent:FindFirstChild("HumanoidRootPart") then
                        obj.Parent.HumanoidRootPart.Anchored = false
                    end
                end
            end
        end
    end
end)

-- 2. زيادة السرعة (Speed)
SpeedBtn.MouseButton1Click:Connect(function()
    speedToggle = not speedToggle
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if speedToggle then
            char.Humanoid.WalkSpeed = 50
            SpeedBtn.Text = "سرعة خارقة: ON"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            char.Humanoid.WalkSpeed = 16
            SpeedBtn.Text = "سرعة خارقة: OFF"
            SpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)

-- 3. القفز العالي (Jump Power)
JumpBtn.MouseButton1Click:Connect(function()
    jumpToggle = not jumpToggle
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if jumpToggle then
            char.Humanoid.JumpPower = 120
            JumpBtn.Text = "قفز عالي: ON"
            JumpBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        else
            char.Humanoid.JumpPower = 50
            JumpBtn.Text = "قفز عالي: OFF"
            JumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
    end
end)

-- 4. كشف مكان البيض والحيوانات عبر الجدران (ESP)
EspBtn.MouseButton1Click:Connect(function()
    espToggle = not espToggle
    if espToggle then
        EspBtn.Text = "كشف البيض (ESP): ON"
        EspBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and (string.find(string.lower(v.Name), "egg") or string.find(string.lower(v.Name), "pet")) then
                if not v:FindFirstChild("Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Parent = v
                    hl.FillColor = Color3.fromRGB(255, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    else
        EspBtn.Text = "كشف البيض (ESP): OFF"
        EspBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:FindFirstChild("Highlight") then
                v.Highlight:Destroy()
            end
        end
    end
end)
