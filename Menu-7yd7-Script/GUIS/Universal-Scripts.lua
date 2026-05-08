-- Services
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TextChatService = game:GetService("TextChatService")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TextService = game:GetService("TextService")

local function makeUICorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

local taskbar = Instance.new("Frame")
taskbar.Name = "Universal Scripts"
taskbar.Visible = false
taskbar.AnchorPoint = Vector2.new(0.5, 1)
taskbar.Position = UDim2.new(0.5, 0, 1, -80)
taskbar.Size = UDim2.new(0, 400, 0, 200)
taskbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
taskbar.BorderSizePixel = 0
taskbar.Parent = game.CoreGui["Menu-7yd7"]
makeUICorner(taskbar, 10)

local title = Instance.new("TextLabel")
title.Parent = taskbar
title.Size = UDim2.new(1, -120, 0, 30)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Universal Scripts"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local searchFrame = Instance.new("Frame")
searchFrame.Parent = taskbar
searchFrame.Size = UDim2.new(0, 120, 0, 24)
searchFrame.Position = UDim2.new(1, -135, 0, 3)
searchFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
makeUICorner(searchFrame, 4)

local searchIcon = Instance.new("ImageLabel")
searchIcon.Parent = searchFrame
searchIcon.Size = UDim2.new(0, 16, 0, 16)
searchIcon.Position = UDim2.new(0, 6, 0.5, -8)
searchIcon.BackgroundTransparency = 1
searchIcon.Image = "rbxassetid://104986431790017" 
searchIcon.ImageColor3 = Color3.fromRGB(180, 180, 180)

local searchBox = Instance.new("TextBox")
searchBox.Parent = searchFrame
searchBox.Size = UDim2.new(1, -30, 1, 0)
searchBox.Position = UDim2.new(0, 26, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "Search..."
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
searchBox.Font = Enum.Font.Gotham
searchBox.TextStrokeColor3 = Color3.fromRGB(49, 49, 49)
searchBox.TextSize = 12
searchBox.TextWrapped = true
searchBox.TextXAlignment = Enum.TextXAlignment.Left

local underline = Instance.new("Frame")
underline.Parent = taskbar
underline.Size = UDim2.new(1, -20, 0, 2)
underline.Position = UDim2.new(0, 10, 0, 30)
underline.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Parent = taskbar
scrollFrame.Size = UDim2.new(1, -20, 1, -40)
scrollFrame.Position = UDim2.new(0, 10, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 2
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75)

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function addButton(data)
	local buttonFrame = Instance.new("Frame")
	buttonFrame.Size = UDim2.new(1, -10, 0, 45)
	buttonFrame.BackgroundColor3 = data.color
	buttonFrame.BorderSizePixel = 0
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.Parent = scrollFrame
	makeUICorner(buttonFrame, 6)

	local scriptName = Instance.new("TextLabel")
	scriptName.Parent = buttonFrame
	scriptName.Size = UDim2.new(1, -100, 0, 20)
	scriptName.Position = UDim2.new(0, 15, 0, 5)
	scriptName.BackgroundTransparency = 1
	scriptName.Text = data.name or "Script Name"
	scriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
	scriptName.Font = Enum.Font.GothamBold
	scriptName.TextSize = 14
	scriptName.TextTransparency = 1
	scriptName.TextXAlignment = Enum.TextXAlignment.Left

	local scriptAuthor = Instance.new("TextLabel")
	scriptAuthor.Parent = buttonFrame
	scriptAuthor.Size = UDim2.new(1, -100, 0, 20)
	scriptAuthor.Position = UDim2.new(0, 15, 0, 25)
	scriptAuthor.BackgroundTransparency = 1
	scriptAuthor.TextTransparency = 1
	scriptAuthor.Text = data.author or "Author Name"
	scriptAuthor.TextColor3 = Color3.fromRGB(180, 180, 180)
	scriptAuthor.Font = Enum.Font.Gotham
	scriptAuthor.TextSize = 12
	scriptAuthor.TextXAlignment = Enum.TextXAlignment.Left

	local executeButton = Instance.new("TextButton")
	executeButton.Parent = buttonFrame
	executeButton.Size = UDim2.new(0, 65, 0, 25)
	executeButton.Position = UDim2.new(1, -75, 0.5, -12)
	executeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	executeButton.Text = "Execute"
	executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	executeButton.Font = Enum.Font.GothamBold
	executeButton.BackgroundTransparency = 1
	executeButton.TextTransparency = 1
	executeButton.TextSize = 12
	executeButton.BorderSizePixel = 0
	makeUICorner(executeButton, 4)

	executeButton.MouseButton1Click:Connect(function()
		if data.action then
			data.action()
		end
	end)

	return buttonFrame, scriptName.Text, scriptAuthor.Text
end

local buttons = {}
searchBox.Changed:Connect(function(prop)
	if prop == "Text" then
		local searchText = searchBox.Text:lower()
		for _, buttonData in ipairs(buttons) do
			local button = buttonData[1]
			local scriptName = buttonData[2]:lower()
			local authorName = buttonData[3]:lower()

			if searchText == "" then
				button.Visible = true
			else
				button.Visible = scriptName:find(searchText) or authorName:find(searchText)
			end
		end
	end
end)


local tweenInfo = TweenInfo.new(
	0.3,
	Enum.EasingStyle.Sine, 
	Enum.EasingDirection.InOut
)

taskbar.BackgroundTransparency = 1
title.TextTransparency = 1
underline.BackgroundTransparency = 1
scrollFrame.ScrollBarImageTransparency = 1

searchIcon.ImageTransparency = 1
searchBox.TextStrokeTransparency = 1
searchBox.TextTransparency = 1
searchBox.Interactable = false
searchFrame.BackgroundTransparency = 1

local isVisible = false


local function makeDraggable(frame)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or 
			input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or 
			input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end



local function toggleGUI()
    isVisible = not isVisible
    local targetTransparency = isVisible and 0 or 1
    local shadowTargetTransparency = isVisible and 0.6 or 1
    
    if isVisible then
        taskbar.Visible = true
        for _, child in ipairs(taskbar:GetDescendants()) do
            if child:IsA("GuiObject") then
                child.Visible = true
            end
        end
    end
    
    local tweens = {
        TweenService:Create(taskbar, tweenInfo, {
            BackgroundTransparency = targetTransparency,
            Position = isVisible and
                UDim2.new(0.5, 0, 1, -80) or
                UDim2.new(0.5, 0, 1, 20)
        }),
        TweenService:Create(title, tweenInfo, {
            TextTransparency = targetTransparency
        }),
        TweenService:Create(underline, tweenInfo, {
            BackgroundTransparency = targetTransparency
        }),
        TweenService:Create(scrollFrame, tweenInfo, {
            ScrollBarImageTransparency = targetTransparency
        }),
        TweenService:Create(searchIcon, tweenInfo, {
            ImageTransparency = targetTransparency
        }),
        TweenService:Create(searchBox, tweenInfo, {
            TextStrokeTransparency = targetTransparency,
            TextTransparency = targetTransparency,
            Interactable = isVisible
        }),
        TweenService:Create(searchFrame, tweenInfo, {
            BackgroundTransparency = targetTransparency,
        })
    }
    
    for _, tween in ipairs(tweens) do
        tween:Play()
    end
    
    local mainTween = tweens[1]
    
    task.spawn(function()
        for i, button in ipairs(scrollFrame:GetChildren()) do
            if button:IsA("Frame") then
                local delay = isVisible and (i * 0.05) or (0.05 * (#scrollFrame:GetChildren() - i))
                task.wait(delay)
                
                local buttonTween = TweenService:Create(button, tweenInfo, {
                    BackgroundTransparency = targetTransparency,
                    Position = UDim2.new(
                        0,
                        isVisible and 0 or (button.Position.X.Offset + 50),
                        0,
                        button.Position.Y.Offset
                    )
                })
                buttonTween:Play()
                
                for _, child in ipairs(button:GetChildren()) do
                    if child:IsA("TextLabel") then
                        TweenService:Create(child, tweenInfo, {
                            TextTransparency = targetTransparency,
                            Position = UDim2.new(
                                0,
                                isVisible and 15 or 30,
                                child.Position.Y.Scale,
                                child.Position.Y.Offset
                            )
                        }):Play()
                    elseif child:IsA("TextButton") then
                        TweenService:Create(child, tweenInfo, {
                            BackgroundTransparency = targetTransparency,
                            TextTransparency = targetTransparency
                        }):Play()
                    end
                end
            end
        end
    end)
    
    if not isVisible then
        mainTween.Completed:Connect(function()
            taskbar.Visible = false
            for _, child in ipairs(taskbar:GetDescendants()) do
                if child:IsA("GuiObject") then
                    child.Visible = false
                end
            end
        end)
    end
end

makeDraggable(taskbar)

for i = 1,2 do
    getgenv().UniversalScripts = toggleGUI
end


function createScriptButton(data)
	if type(data) ~= "table" then
		warn("Invalid data passed to createScriptButton")
		return nil
	end

	local button, name, author = addButton(data)
	if button then
		table.insert(buttons, {button, name, author})
		return button, name, author
	else
		warn("Failed to create button for script")
		return nil
	end
end

for i = 1,2 do
    getgenv().createScriptButton = createScriptButton
end
