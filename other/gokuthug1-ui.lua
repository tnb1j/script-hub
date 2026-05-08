-- gokuthug1's Hub — Standalone Exploit UI
-- Theme: Dark bg + Orange accent + BuilderSans

local Players        = game:GetService("Players")
local UIS            = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local HttpService    = game:GetService("HttpService")
local LogService     = game:GetService("LogService")
local CoreGui        = game:GetService("CoreGui")
local TeleportService= game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")

local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
local cam = workspace.CurrentCamera

-- cleanup old instance
pcall(function() CoreGui:FindFirstChild("GokuHub"):Destroy() end)

local T = {
    bg          = Color3.fromRGB(15,15,20),
    sidebar     = Color3.fromRGB(20,20,28),
    surface     = Color3.fromRGB(28,28,38),
    surfaceHigh = Color3.fromRGB(40,40,55),
    accent      = Color3.fromRGB(230,126,34),
    accentDim   = Color3.fromRGB(160,88,24),
    text        = Color3.fromRGB(240,240,245),
    textDim     = Color3.fromRGB(140,140,155),
    border      = Color3.fromRGB(50,50,65),
    red         = Color3.fromRGB(220,60,60),
    green       = Color3.fromRGB(60,200,100),
    font        = Enum.Font.BuilderSans,
}
local tw = function(obj,props,t,s)
    TweenService:Create(obj,TweenInfo.new(t or 0.18,Enum.EasingStyle[s or "Quad"]),props):Play()
end

-- ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "GokuHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = (syn and syn.protect_gui and syn.protect_gui(sg)) and CoreGui or (gethui and gethui() or CoreGui)

-- Main frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0,720,0,460)
main.Position = UDim2.new(0.5,-360,0.5,-230)
main.BackgroundColor3 = T.bg
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = sg
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)
local ms = Instance.new("UIStroke",main); ms.Color=T.border; ms.Thickness=1

-- Titlebar
local titlebar = Instance.new("Frame")
titlebar.Size = UDim2.new(1,0,0,36)
titlebar.BackgroundColor3 = T.sidebar
titlebar.BorderSizePixel = 0
titlebar.Parent = main
local tl = Instance.new("TextLabel",titlebar)
tl.Size = UDim2.new(1,-80,1,0); tl.Position = UDim2.new(0,12,0,0)
tl.BackgroundTransparency=1; tl.Font=T.font
tl.TextColor3=T.accent; tl.TextSize=15; tl.TextXAlignment=Enum.TextXAlignment.Left
tl.Text="⬡  gokuthug1's Hub"

-- Close / Minimize buttons
local function mkBtn(parent,xoff,txt,col)
    local b = Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,28,0,22); b.Position=UDim2.new(1,xoff,0.5,-11)
    b.BackgroundColor3=col; b.Text=txt; b.Font=T.font; b.TextSize=13
    b.TextColor3=T.text; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
    return b
end
local closeBtn = mkBtn(titlebar,-34,"✕",T.red)
local minBtn   = mkBtn(titlebar,-68,"—",T.accentDim)
local minimised = false
minBtn.MouseButton1Click:Connect(function()
    minimised = not minimised
    tw(main,{Size=minimised and UDim2.new(0,720,0,36) or UDim2.new(0,720,0,460)})
end)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Drag
do
    local dragging,dragStart,startPos
    titlebar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true; dragStart=i.Position; startPos=main.Position
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-dragStart
            main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
end

-- Resize handle
local rh = Instance.new("TextButton",main)
rh.Size=UDim2.new(0,14,0,14); rh.Position=UDim2.new(1,-14,1,-14)
rh.BackgroundColor3=T.border; rh.Text=""; rh.BorderSizePixel=0
Instance.new("UICorner",rh).CornerRadius=UDim.new(0,3)
do
    local resizing,rs,ss
    rh.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            resizing=true; rs=i.Position; ss=main.AbsoluteSize
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if resizing and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-rs
            main.Size=UDim2.new(0,math.max(500,ss.X+d.X),0,math.max(300,ss.Y+d.Y))
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=false end
    end)
end

-- Sidebar
local sidebar = Instance.new("Frame",main)
sidebar.Size=UDim2.new(0,130,1,-36); sidebar.Position=UDim2.new(0,0,0,36)
sidebar.BackgroundColor3=T.sidebar; sidebar.BorderSizePixel=0
local sidDiv=Instance.new("Frame",sidebar)
sidDiv.Size=UDim2.new(0,1,1,0); sidDiv.Position=UDim2.new(1,-1,0,0)
sidDiv.BackgroundColor3=T.border; sidDiv.BorderSizePixel=0

-- Content area
local content = Instance.new("Frame",main)
content.Size=UDim2.new(1,-131,1,-36); content.Position=UDim2.new(0,131,0,36)
content.BackgroundTransparency=1; content.ClipsDescendants=true

-- Tab system
local tabs={} ; local tabBtns={}; local activeTab=nil

local function mkTabBtn(name,icon,idx)
    local btn=Instance.new("TextButton",sidebar)
    btn.Size=UDim2.new(1,-10,0,36); btn.Position=UDim2.new(0,5,0,8+(idx-1)*42)
    btn.BackgroundColor3=T.surface; btn.BorderSizePixel=0
    btn.Font=T.font; btn.TextSize=13; btn.TextColor3=T.textDim
    btn.Text=icon.."  "..name; btn.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
    Instance.new("UIPadding",btn).PaddingLeft=UDim.new(0,10)

    local page=Instance.new("ScrollingFrame",content)
    page.Size=UDim2.new(1,0,1,0); page.BackgroundTransparency=1
    page.BorderSizePixel=0; page.Visible=false
    page.ScrollBarThickness=3; page.ScrollBarImageColor3=T.accent
    page.CanvasSize=UDim2.new(0,0,0,0); page.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local layout=Instance.new("UIListLayout",page)
    layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding",page).PaddingTop=UDim.new(0,10)

    tabs[name]=page; tabBtns[name]=btn

    btn.MouseButton1Click:Connect(function()
        if activeTab then
            tabs[activeTab].Visible=false
            tw(tabBtns[activeTab],{BackgroundColor3=T.surface,TextColor3=T.textDim})
        end
        activeTab=name; page.Visible=true
        tw(btn,{BackgroundColor3=T.accentDim,TextColor3=T.accent})
    end)
    return page
end

local homeTab     = mkTabBtn("Home",    "🏠", 1)
local playerTab   = mkTabBtn("Players", "👤", 2)
local listenerTab = mkTabBtn("Listener","📡", 3)
local consoleTab  = mkTabBtn("Console", "📋", 4)
local settingsTab = mkTabBtn("Settings","⚙",  5)

-- ── Helpers ──────────────────────────────────────────────────────────────────
local function pad(parent,v) local p=Instance.new("UIPadding",parent); p.PaddingLeft=UDim.new(0,v); p.PaddingRight=UDim.new(0,v) end

local function mkCard(parent,h)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,-20,0,h or 54)
    f.BackgroundColor3=T.surface; f.BorderSizePixel=0
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    pad(f,2)
    return f
end

local function mkLabel(parent,txt,size,col,xa)
    local l=Instance.new("TextLabel",parent); l.Size=UDim2.new(1,0,0,size+4)
    l.BackgroundTransparency=1; l.Font=T.font; l.TextSize=size
    l.TextColor3=col or T.text; l.Text=txt
    l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.TextTruncate=Enum.TextTruncate.AtEnd
    return l
end

local function createInput(parent,placeholder,default,xoff,yoff,w)
    local frame=Instance.new("Frame",parent)
    frame.Size=UDim2.new(0,w or 160,0,28); frame.Position=UDim2.new(0,xoff or 0,0,yoff or 0)
    frame.BackgroundColor3=T.surfaceHigh; frame.BorderSizePixel=0
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,6)
    local input=Instance.new("TextBox",frame)
    input.Size=UDim2.new(1,-8,1,0); input.Position=UDim2.new(0,4,0,0)
    input.BackgroundTransparency=1; input.Font=T.font; input.TextSize=13
    input.TextColor3=T.text; input.PlaceholderColor3=T.textDim
    input.PlaceholderText=placeholder or ""; input.Text=default or ""
    input.ClearTextOnFocus=false
    return frame, input  -- returns BOTH frame and TextBox
end

local function mkToggle(parent,label,callback)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,-16,0,30)
    row.BackgroundTransparency=1; row.BorderSizePixel=0
    local lbl=mkLabel(row,label,13,T.text); lbl.Size=UDim2.new(1,-50,1,0)
    local state=false
    local btn=Instance.new("TextButton",row)
    btn.Size=UDim2.new(0,42,0,22); btn.Position=UDim2.new(1,-42,0.5,-11)
    btn.BackgroundColor3=T.surfaceHigh; btn.Text="OFF"; btn.Font=T.font
    btn.TextSize=11; btn.TextColor3=T.textDim; btn.BorderSizePixel=0
    Instance.new("UICorner",btn).CornerRadius=UDim.new(0,11)
    btn.MouseButton1Click:Connect(function()
        state=not state
        tw(btn,{BackgroundColor3=state and T.accent or T.surfaceHigh,TextColor3=state and T.bg or T.textDim})
        btn.Text=state and "ON" or "OFF"
        callback(state)
    end)
    return row, btn, function() return state end
end

local function mkButton(parent,txt,w,h,col)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,w or 120,0,h or 30)
    b.BackgroundColor3=col or T.accent; b.BorderSizePixel=0
    b.Font=T.font; b.TextSize=13; b.TextColor3=T.bg; b.Text=txt
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseEnter:Connect(function() tw(b,{BackgroundColor3=T.accentDim}) end)
    b.MouseLeave:Connect(function() tw(b,{BackgroundColor3=col or T.accent}) end)
    return b
end

-- Notification
local function notify(msg,good)
    local nf=Instance.new("Frame",sg)
    nf.Size=UDim2.new(0,260,0,44); nf.Position=UDim2.new(1,-270,1,-54)
    nf.BackgroundColor3=good and T.green or T.red; nf.BorderSizePixel=0
    Instance.new("UICorner",nf).CornerRadius=UDim.new(0,8)
    local nl=Instance.new("TextLabel",nf); nl.Size=UDim2.new(1,-10,1,0)
    nl.Position=UDim2.new(0,10,0,0); nl.BackgroundTransparency=1
    nl.Font=T.font; nl.TextSize=13; nl.TextColor3=Color3.new(1,1,1); nl.Text=msg
    nl.TextXAlignment=Enum.TextXAlignment.Left
    nf.BackgroundTransparency=1; tw(nf,{BackgroundTransparency=0})
    task.delay(3,function() tw(nf,{BackgroundTransparency=1}) task.wait(0.2) nf:Destroy() end)
end

-- ── HOME TAB ─────────────────────────────────────────────────────────────────
do
    local function actionCard(parent,title,desc,btnTxt,cb,lo)
        local c=mkCard(parent,64); c.LayoutOrder=lo or 0
        local l=Instance.new("UIListLayout",c); l.FillDirection=Enum.FillDirection.Horizontal
        l.VerticalAlignment=Enum.VerticalAlignment.Center; l.Padding=UDim.new(0,8)
        local info=Instance.new("Frame",c); info.Size=UDim2.new(1,-110,1,0)
        info.BackgroundTransparency=1
        local il=Instance.new("UIListLayout",info); il.Padding=UDim.new(0,2)
        mkLabel(info,title,14,T.text); mkLabel(info,desc,11,T.textDim)
        local btn=mkButton(c,btnTxt,100,30); btn.Parent=c
        btn.MouseButton1Click:Connect(cb)
    end

    local function sectionLabel(parent,txt,lo)
        local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,-20,0,24)
        f.BackgroundTransparency=1; f.LayoutOrder=lo
        local s=Instance.new("UIStroke"); s.Parent=Instance.new("Frame",f)
        mkLabel(f,txt,12,T.accent)
    end

    mkLabel(homeTab,"  gokuthug1's Hub",20,T.accent).LayoutOrder=0

    actionCard(homeTab,"Server Rejoin","Teleport to a fresh server of this place","Rejoin",function()
        local ok,err=pcall(function()
            TeleportService:Teleport(game.PlaceId,lp)
        end)
        if not ok then notify("Rejoin failed: "..(err or "?"), false) end
    end,1)

    actionCard(homeTab,"Fly Mode","Toggle free-flight for your character","Toggle Fly",function()
        local char=lp.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        if hrp:FindFirstChild("FlyBody") then
            hrp.FlyBody:Destroy(); hrp.FlyGyro:Destroy()
            notify("Fly OFF",false); return
        end
        local bg=Instance.new("BodyGyro",hrp); bg.Name="FlyGyro"
        bg.MaxTorque=Vector3.new(9e9,9e9,9e9); bg.D=100
        local bv=Instance.new("BodyVelocity",hrp); bv.Name="FlyBody"
        bv.MaxForce=Vector3.new(9e9,9e9,9e9); bv.Velocity=Vector3.zero
        notify("Fly ON",true)
        RunService:BindToRenderStep("FlyStep",300,function()
            if not hrp or not hrp:FindFirstChild("FlyBody") then
                RunService:UnbindFromRenderStep("FlyStep"); return
            end
            local speed=50
            local v=Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then v=v+cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then v=v-cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then v=v-cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then v=v+cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then v=v+Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then v=v-Vector3.new(0,1,0) end
            hrp.FlyBody.Velocity=v*speed
            bg.CFrame=cam.CFrame
        end)
    end,2)

    -- Remote hook toggle
    local remoteLog={}; local remoteConn
    actionCard(homeTab,"Remote Spy","Log all RemoteEvent fires","Toggle",function()
        if remoteConn then remoteConn:Disconnect(); remoteConn=nil; notify("Remote Spy OFF",false); return end
        local hookFn = hookmetamethod or nil
        if hookFn then
            remoteConn=hookFn(game,"__namecall",function(self,...)
                local m=getnamecallmethod()
                if m=="FireServer" or m=="InvokeServer" then
                    table.insert(remoteLog,1,os.date("[%H:%M:%S] ")..tostring(self).." → "..m)
                end
                return hookFn(self,...)
            end)
            notify("Remote Spy ON",true)
        else
            notify("hookmetamethod unavailable",false)
        end
    end,3)

    -- Marketplace block
    actionCard(homeTab,"Block Purchases","Block all MarketplaceService prompts","Toggle",function()
        local mt=getrawmetatable and getrawmetatable(MarketplaceService)
        if mt then
            local old=mt.__index
            mt.__index=function(s,k,...)
                if k=="PromptProductPurchase" or k=="PromptPurchase" or k=="PromptGamePassPurchase" then
                    return function() notify("Purchase blocked",false) end
                end
                return old(s,k,...)
            end
            notify("Purchase prompts blocked",true)
        else
            notify("getrawmetatable unavailable",false)
        end
    end,4)
end

-- ── PLAYERS TAB ───────────────────────────────────────────────────────────────
do
    -- Per-player connection storage
    local playerConns = {}   -- [player.UserId] = { conns=[], expanded=Frame }

    local function clearConns(uid)
        if playerConns[uid] then
            for _,c in ipairs(playerConns[uid].conns or {}) do pcall(function() c:Disconnect() end) end
            playerConns[uid].conns = {}
        end
    end

    local function createPlayerCard(player)
        local uid = player.UserId
        playerConns[uid] = { conns={} }

        -- Outer wrapper (collapsed height = 68, expanded = ~580)
        local wrapper = Instance.new("Frame", playerTab)
        wrapper.Size = UDim2.new(1,-20,0,68)
        wrapper.BackgroundColor3 = T.surface
        wrapper.BorderSizePixel = 0
        wrapper.ClipsDescendants = true
        Instance.new("UICorner",wrapper).CornerRadius = UDim.new(0,8)

        -- Header row
        local header = Instance.new("Frame",wrapper)
        header.Size = UDim2.new(1,0,0,68)
        header.BackgroundTransparency = 1

        local avatar = Instance.new("Frame",header)
        avatar.Size = UDim2.new(0,44,0,44)
        avatar.Position = UDim2.new(0,10,0,12)
        avatar.BackgroundColor3 = T.surfaceHigh
        avatar.BorderSizePixel = 0
        Instance.new("UICorner",avatar).CornerRadius = UDim.new(0,22)
        local avLbl = Instance.new("TextLabel",avatar)
        avLbl.Size = UDim2.new(1,0,1,0); avLbl.BackgroundTransparency=1
        avLbl.Font=T.font; avLbl.TextSize=18; avLbl.TextColor3=T.accent
        avLbl.Text = string.sub(player.Name,1,1):upper()
        avLbl.TextXAlignment = Enum.TextXAlignment.Center

        local nameLabel = Instance.new("TextLabel",header)
        nameLabel.Size = UDim2.new(1,-130,0,20)
        nameLabel.Position = UDim2.new(0,64,0,12)
        nameLabel.BackgroundTransparency=1; nameLabel.Font=T.font
        nameLabel.TextSize=14; nameLabel.TextColor3=T.text
        nameLabel.Text = player.Name
        nameLabel.TextXAlignment=Enum.TextXAlignment.Left

        local idLabel = Instance.new("TextLabel",header)
        idLabel.Size = UDim2.new(1,-130,0,16)
        idLabel.Position = UDim2.new(0,64,0,33)
        idLabel.BackgroundTransparency=1; nameLabel.Font=T.font
        idLabel.TextSize=11; idLabel.TextColor3=T.textDim
        idLabel.Text = "ID: "..uid..(player==lp and "  (you)" or "")
        idLabel.TextXAlignment=Enum.TextXAlignment.Left

        local expandBtn = mkButton(header,"▼  Expand",90,26,T.accentDim)
        expandBtn.Position = UDim2.new(1,-100,0,21)

        -- ── Expanded panel ─────────────────────────────────────────────────
        local expanded = Instance.new("Frame",wrapper)
        expanded.Size = UDim2.new(1,-16,0,500)
        expanded.Position = UDim2.new(0,8,0,72)
        expanded.BackgroundTransparency = 1
        playerConns[uid].expanded = expanded

        local expLayout = Instance.new("UIListLayout",expanded)
        expLayout.Padding = UDim.new(0,6)
        expLayout.SortOrder = Enum.SortOrder.LayoutOrder

        -- Helper: row with label + input + reset button
        local function statRow(labelTxt, defaultVal, lo, applyFn)
            local row = Instance.new("Frame",expanded)
            row.Size = UDim2.new(1,0,0,30)
            row.BackgroundTransparency=1; row.LayoutOrder=lo

            local lbl = Instance.new("TextLabel",row)
            lbl.Size=UDim2.new(0,90,1,0); lbl.BackgroundTransparency=1
            lbl.Font=T.font; lbl.TextSize=12; lbl.TextColor3=T.textDim
            lbl.Text=labelTxt; lbl.TextXAlignment=Enum.TextXAlignment.Left

            local _f, inputBox = createInput(row, tostring(defaultVal), tostring(defaultVal), 94, 1, 100)
            _f.Parent = row

            local applyBtn = mkButton(row,"Set",38,26,T.accent)
            applyBtn.Position = UDim2.new(0,200,0,2)
            applyBtn.Parent = row

            local resetBtn = mkButton(row,"↺",30,26,T.accentDim)
            resetBtn.Position = UDim2.new(0,242,0,2)
            resetBtn.Parent = row

            applyBtn.MouseButton1Click:Connect(function()
                local v = tonumber(inputBox.Text)
                if v then applyFn(v); notify(labelTxt.." → "..v, true) end
            end)
            resetBtn.MouseButton1Click:Connect(function()
                local def = defaultVal
                applyFn(def)
                inputBox.Text = tostring(def)   -- UI sync!
                notify(labelTxt.." reset → "..def, true)
            end)

            return inputBox
        end

        local function getHum()
            local char = player.Character
            return char and char:FindFirstChildOfClass("Humanoid")
        end
        local function getHRP()
            local char = player.Character
            return char and char:FindFirstChild("HumanoidRootPart")
        end

        statRow("WalkSpeed", 16, 1, function(v)
            local h = getHum(); if h then h.WalkSpeed = v end
        end)
        statRow("JumpPower", 50, 2, function(v)
            local h = getHum(); if h then h.JumpPower = v end
        end)

        -- Separator
        local sep=Instance.new("Frame",expanded); sep.Size=UDim2.new(1,0,0,1)
        sep.BackgroundColor3=T.border; sep.BorderSizePixel=0; sep.LayoutOrder=3

        -- ── 6 toggles ──────────────────────────────────────────────────────
        -- 1) Infinite Jump
        do
            local row,_btn,_ = mkToggle(expanded,"Infinite Jump",function(on)
                clearConns(uid)   -- clear old infinite jump conn
                if on then
                    local c = UIS.JumpRequest:Connect(function()
                        local h=getHum()
                        if h and h:GetState()~=Enum.HumanoidStateType.Dead then h:ChangeState(Enum.HumanoidStateType.Jumping) end
                    end)
                    table.insert(playerConns[uid].conns, c)
                end
            end)
            row.LayoutOrder=4; row.Parent=expanded
        end

        -- 2) Noclip
        do
            local noclipConn
            local row,_btn,_ = mkToggle(expanded,"Noclip",function(on)
                if noclipConn then noclipConn:Disconnect(); noclipConn=nil end
                if on then
                    noclipConn = RunService.Stepped:Connect(function()
                        local char=player.Character; if not char then return end
                        for _,p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.CanCollide=false end
                        end
                    end)
                    table.insert(playerConns[uid].conns, noclipConn)
                end
            end)
            row.LayoutOrder=5; row.Parent=expanded
        end

        -- 3) God Mode
        do
            local godConn
            local row,_btn,_ = mkToggle(expanded,"God Mode",function(on)
                if godConn then godConn:Disconnect(); godConn=nil end
                if on then
                    godConn = RunService.Heartbeat:Connect(function()
                        local h=getHum()
                        if h then h.Health=h.MaxHealth end
                    end)
                    table.insert(playerConns[uid].conns, godConn)
                end
            end)
            row.LayoutOrder=6; row.Parent=expanded
        end

        -- 4) Freeze
        do
            local row,_btn,_ = mkToggle(expanded,"Freeze",function(on)
                local hrp=getHRP()
                if hrp then hrp.Anchored=on end
            end)
            row.LayoutOrder=7; row.Parent=expanded
        end

        -- 5) Local Invisibility
        do
            local row,_btn,_ = mkToggle(expanded,"Local Invisibility",function(on)
                local char=player.Character; if not char then return end
                for _,p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.LocalTransparencyModifier = on and 1 or 0
                    end
                end
            end)
            row.LayoutOrder=8; row.Parent=expanded
        end

        -- 6) Anti-Void
        do
            local avConn
            local row,_btn,_ = mkToggle(expanded,"Anti-Void",function(on)
                if avConn then avConn:Disconnect(); avConn=nil end
                if on then
                    avConn = RunService.Heartbeat:Connect(function()
                        local hrp=getHRP()
                        if hrp and hrp.Position.Y < -450 then
                            local h=getHum()
                            if h then h.Health=0 end
                        end
                    end)
                    table.insert(playerConns[uid].conns, avConn)
                end
            end)
            row.LayoutOrder=9; row.Parent=expanded
        end

        -- Expand / Collapse
        local isExpanded = false
        expandBtn.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            local targetH = isExpanded and (68+12+500) or 68
            expandBtn.Text = isExpanded and "▲  Collapse" or "▼  Expand"
            tw(wrapper,{Size=UDim2.new(1,-20,0,targetH)})
        end)

        return wrapper
    end

    -- Populate existing players
    for _,p in ipairs(Players:GetPlayers()) do
        createPlayerCard(p)
    end
    Players.PlayerAdded:Connect(function(p)
        createPlayerCard(p)
    end)
    Players.PlayerRemoving:Connect(function(p)
        clearConns(p.UserId)
    end)
end

-- ── LISTENER TAB ─────────────────────────────────────────────────────────────
do
    local logs = {}
    local logFrame = Instance.new("Frame",listenerTab)
    logFrame.Size = UDim2.new(1,-20,0,300); logFrame.LayoutOrder=0
    logFrame.BackgroundColor3=T.surface; logFrame.BorderSizePixel=0
    Instance.new("UICorner",logFrame).CornerRadius=UDim.new(0,8)

    local scroll = Instance.new("ScrollingFrame",logFrame)
    scroll.Size=UDim2.new(1,-4,1,-4); scroll.Position=UDim2.new(0,2,0,2)
    scroll.BackgroundTransparency=1; scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=3; scroll.ScrollBarImageColor3=T.accent
    scroll.CanvasSize=UDim2.new(0,0,0,0); scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y

    local ll=Instance.new("UIListLayout",scroll); ll.Padding=UDim.new(0,2)

    local function addLog(msg,col)
        if #logs>200 then table.remove(logs,1); scroll:FindFirstChildOfClass("TextLabel"):Destroy() end
        table.insert(logs,msg)
        local l=Instance.new("TextLabel",scroll)
        l.Size=UDim2.new(1,-6,0,16); l.BackgroundTransparency=1
        l.Font=Enum.Font.Code; l.TextSize=11; l.TextColor3=col or T.textDim
        l.Text=msg; l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextTruncate=Enum.TextTruncate.AtEnd
        scroll.CanvasPosition=Vector2.new(0,scroll.AbsoluteCanvasSize.Y)
    end

    -- Hook LogService
    LogService.MessageOut:Connect(function(msg,mtype)
        local col = (mtype==Enum.MessageType.MessageError) and T.red
            or (mtype==Enum.MessageType.MessageWarning) and Color3.fromRGB(230,180,0)
            or T.textDim
        addLog(os.date("[%H:%M:%S] ")..msg, col)
    end)

    -- Control row
    local ctrlRow = Instance.new("Frame",listenerTab)
    ctrlRow.Size=UDim2.new(1,-20,0,34); ctrlRow.LayoutOrder=1
    ctrlRow.BackgroundTransparency=1
    local ll2=Instance.new("UIListLayout",ctrlRow); ll2.FillDirection=Enum.FillDirection.Horizontal
    ll2.Padding=UDim.new(0,8); ll2.VerticalAlignment=Enum.VerticalAlignment.Center

    local clrBtn=mkButton(ctrlRow,"Clear",80,28,T.red)
    clrBtn.Parent=ctrlRow
    clrBtn.MouseButton1Click:Connect(function()
        for _,c in ipairs(scroll:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
        logs={}
    end)

    addLog("Listener ready — logs will appear here.",T.accent)
end

-- ── CONSOLE TAB ──────────────────────────────────────────────────────────────
do
    local outputFrame=Instance.new("Frame",consoleTab)
    outputFrame.Size=UDim2.new(1,-20,0,260); outputFrame.LayoutOrder=0
    outputFrame.BackgroundColor3=T.surface; outputFrame.BorderSizePixel=0
    Instance.new("UICorner",outputFrame).CornerRadius=UDim.new(0,8)

    local outScroll=Instance.new("ScrollingFrame",outputFrame)
    outScroll.Size=UDim2.new(1,-4,1,-4); outScroll.Position=UDim2.new(0,2,0,2)
    outScroll.BackgroundTransparency=1; outScroll.BorderSizePixel=0
    outScroll.ScrollBarThickness=3; outScroll.ScrollBarImageColor3=T.accent
    outScroll.CanvasSize=UDim2.new(0,0,0,0); outScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local ol=Instance.new("UIListLayout",outScroll); ol.Padding=UDim.new(0,2)

    local function printOut(msg,col)
        local l=Instance.new("TextLabel",outScroll)
        l.Size=UDim2.new(1,-6,0,16); l.BackgroundTransparency=1
        l.Font=Enum.Font.Code; l.TextSize=11; l.TextColor3=col or T.text
        l.Text=msg; l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextTruncate=Enum.TextTruncate.AtEnd
        outScroll.CanvasPosition=Vector2.new(0,outScroll.AbsoluteCanvasSize.Y)
    end

    printOut("> Console ready. Type Lua below and press Enter.",T.accent)

    -- Input row
    local inputRow=Instance.new("Frame",consoleTab)
    inputRow.Size=UDim2.new(1,-20,0,34); inputRow.LayoutOrder=1
    inputRow.BackgroundColor3=T.surface; inputRow.BorderSizePixel=0
    Instance.new("UICorner",inputRow).CornerRadius=UDim.new(0,8)

    local _if, codeInput=createInput(inputRow,"Enter Lua...", "", 6, 3, 0)
    _if.Size=UDim2.new(1,-80,0,28); _if.Position=UDim2.new(0,6,0,3)

    local runBtn=mkButton(inputRow,"▶ Run",68,28,T.accent)
    runBtn.Position=UDim2.new(1,-74,0,3)

    local function execCode()
        local code=codeInput.Text; if code=="" then return end
        printOut("> "..code, T.accent)
        local fn,err=loadstring(code)
        if not fn then printOut("  Error: "..(err or "?"),T.red); return end
        local ok,res=pcall(fn)
        if not ok then printOut("  Error: "..(res or "?"),T.red)
        elseif res~=nil then printOut("  = "..tostring(res),T.green) end
        codeInput.Text=""
    end

    runBtn.MouseButton1Click:Connect(execCode)
    codeInput.FocusLost:Connect(function(enter) if enter then execCode() end end)
end

-- ── SETTINGS TAB ─────────────────────────────────────────────────────────────
do
    mkLabel(settingsTab,"  Settings",18,T.accent).LayoutOrder=0

    -- FPS display toggle
    local fpsConn
    local fpsLabel=Instance.new("TextLabel",sg)
    fpsLabel.Size=UDim2.new(0,120,0,20); fpsLabel.Position=UDim2.new(0,4,0,4)
    fpsLabel.BackgroundTransparency=1; fpsLabel.Font=T.font; fpsLabel.TextSize=12
    fpsLabel.TextColor3=T.accent; fpsLabel.Text=""; fpsLabel.TextXAlignment=Enum.TextXAlignment.Left
    fpsLabel.Visible=false

    local fpsCard=mkCard(settingsTab,50); fpsCard.LayoutOrder=1
    local fpsRow,_,_=mkToggle(fpsCard,"FPS Counter",function(on)
        fpsLabel.Visible=on
        if fpsConn then fpsConn:Disconnect(); fpsConn=nil end
        if on then
            local t,f=0,0
            fpsConn=RunService.Heartbeat:Connect(function(dt)
                t=t+dt; f=f+1
                if t>=0.5 then fpsLabel.Text="FPS: "..math.round(f/t); t=0; f=0 end
            end)
        end
    end)
    fpsRow.Parent=fpsCard

    -- Keybind hint
    local hintCard=mkCard(settingsTab,50); hintCard.LayoutOrder=2
    mkLabel(hintCard,"Fly: W/A/S/D + Space/Shift  |  Drag: hold title  |  Resize: drag ↘",11,T.textDim).Parent=hintCard

    -- Theme note
    local themeCard=mkCard(settingsTab,50); themeCard.LayoutOrder=3
    mkLabel(themeCard,"Theme: Dark (15,15,20) + Orange accent (230,126,34) + BuilderSans",11,T.textDim).Parent=themeCard

    -- Version
    local verCard=mkCard(settingsTab,40); verCard.LayoutOrder=4
    mkLabel(verCard,"gokuthug1's Hub  v2.0  —  standalone exploit UI",12,T.textDim).Parent=verCard
end

-- ── Init: open Home tab ───────────────────────────────────────────────────────
tabBtns["Home"]:GetPropertyChangedSignal("Text"):Wait()   -- ensure parented
tabBtns["Home"].MouseButton1Click:Fire()
task.defer(function() tabBtns["Home"].MouseButton1Click:Fire() end)
