local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local NotificationGui = CoreGui:FindFirstChild("gokuthug1NotificationSystem")
if not NotificationGui then
    NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = "gokuthug1NotificationSystem"
    NotificationGui.ResetOnSpawn = false
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotificationGui.Parent = CoreGui
end

local Container = NotificationGui:FindFirstChild("Container")
if not Container then
    Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.BackgroundTransparency = 1
    Container.AnchorPoint = Vector2.new(1, 0)
    Container.Position = UDim2.new(1, -16, 0, 16)
    Container.Size = UDim2.new(0, 320, 1, -32)
    Container.Parent = NotificationGui

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = Container
end

local function createNotification(data)
    local duration = tonumber(data and data.Duration) or 5

    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    frame.BackgroundTransparency = 0.08
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 300, 0, 78)
    frame.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 150)
    stroke.Transparency = 0.25
    stroke.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 12)
    padding.PaddingRight = UDim.new(0, 12)
    padding.Parent = frame

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Font = Enum.Font.GothamBold
    title.Text = tostring(data and data.Title or "Notification")
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local content = Instance.new("TextLabel")
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 0, 0, 24)
    content.Size = UDim2.new(1, 0, 1, -24)
    content.Font = Enum.Font.Gotham
    content.Text = tostring(data and data.Content or "")
    content.TextColor3 = Color3.fromRGB(220, 220, 220)
    content.TextSize = 13
    content.TextWrapped = true
    content.TextXAlignment = Enum.TextXAlignment.Left
    content.TextYAlignment = Enum.TextYAlignment.Top
    content.Parent = frame

    frame.Position = UDim2.new(1, 24, 0, 0)
    TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    task.delay(duration, function()
        if not frame.Parent then
            return
        end

        local tween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 24, 0, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        frame:Destroy()
    end)
end

getgenv().Notify = function(data)
    local ok, err = pcall(createNotification, data)
    if not ok then
        warn("[gokuthug1's Hub] Notify failed: " .. tostring(err))
    end
end

return getgenv().Notify
