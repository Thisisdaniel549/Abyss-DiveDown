--// Made by abyss with help from vmpf, but i did use ai for helper functions that i will continue using such as esp.draw_highlight for object esp, get_root just faster for 
--// getting rootpart, esp.draw_text for labeling the items or players.
--// Hopefull your able to learn off this the code is an mess somewhat so im sorry for that.

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicated_storage = game:GetService("ReplicatedStorage")
local run_service = game:GetService("RunService")

local camera = workspace.CurrentCamera
local local_player = players.LocalPlayer
local character = local_player.Character or local_player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Shops = game:GetService("Workspace").Game.Map.MapMiddle.Shops

local FinShop_game = Shops.FinShop
local OxygenShop = Shops.OxygenShop
local TreatShop = Shops.Treatshop
local WeightShop = Shops.WeightShop


local fishes = workspace:WaitForChild("Game"):WaitForChild("Fishes")

--// little helper functions @ yes i did use chatgpt to help me make them
local function get_root()
    local character = local_player.Character or local_player.CharacterAdded:Wait()
    return character:WaitForChild("HumanoidRootPart")
end

local esp = {}
esp.objects = {}
esp.enabled = false

function esp.draw_highlight(target, color)
    if not target or esp.objects[target] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = color or Color3.fromRGB(255, 103, 103)
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.FillTransparency = 0.5
    highlight.Parent = target

    esp.objects[target] = highlight
end

function esp.draw_text(target, customText)
    if not target or esp.objects[target .. "_text"] then return end
    
    local adorneePart = target:FindFirstChildWhichIsA("BasePart")
    if not adorneePart then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPText"
    billboard.Adornee = adorneePart
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 103, 103)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Text = customText ~= "" and customText or target.Name
    label.Parent = billboard

    esp.objects[target .. "_text"] = billboard
end

function esp.remove(target)
    if esp.objects[target] then
        esp.objects[target]:Destroy()
        esp.objects[target] = nil
    end
    
    if esp.objects[target .. "_text"] then
        esp.objects[target .. "_text"]:Destroy()
        esp.objects[target .. "_text"] = nil
    end
end

function esp.clear_all()
    for target, object in pairs(esp.objects) do
        if object then
            object:Destroy()
        end
    end
    esp.objects = {}
end

--// handle new fish spawning
fishes.ChildAdded:Connect(function(child)
    if esp.enabled then
        task.wait()
        esp.draw_highlight(child, Color3.fromRGB(255, 103, 103))
    end
end)

local rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = rayfield:CreateWindow({
   Name = "Abyss - Dive Down",
   Icon = 0,
   LoadingTitle = "Made with love",
   LoadingSubtitle = "by Abyss",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Abyss"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Tab = Window:CreateTab("Misc", 4483362458)
local Section = Tab:CreateSection("LocalPlayer Modifications")

Tab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 500},
   Increment = 1,
   Suffix = "Amount",
   CurrentValue = 16,
   Flag = "Walkspeed",
   Callback = function(value)
       humanoid.WalkSpeed = value
   end,
})

Tab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 500},
    Increment = 1,
    Suffix = "Amount",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        humanoid.JumpPower = value
    end, 
})


Tab:CreateButton({
    Name = "Teleport To Finshop Games",
    Callback = function(Value)
    local root = get_root()
    root.CFrame = FinShop_game:GetPivot() + Vector3.new(0, 1, 0)
    end,
})

Tab:CreateButton({
    Name = "Teleport To Oxygen Shop",
    Callback = function(Value)
    local root = get_root()
    root.CFrame = OxygenShop:GetPivot() + Vector3.new(0, 1, 0)
    end,
})

Tab:CreateButton({
    Name = "Teleport To Treat Shop",
    Callback = function(Value)
    local root = get_root()
    root.CFrame = TreatShop:GetPivot() + Vector3.new(0, 1, 0)
    end,
})

Tab:CreateButton({
    Name = "Teleport To Weight Shop",
    Callback = function(Value)
    local root = get_root()
    root.CFrame = WeightShop:GetPivot() + Vector3.new(0, 1, 0)
    end,
})

local Visuals = Window:CreateTab("Visuals", 4483362458)

Visuals:CreateToggle({
    Name = "Fish ESP",
    CurrentValue = false,
    Flag = "Fishtoggle",
    Callback = function(value)
        esp.enabled = value

        if value then
            for _, fish in pairs(fishes:GetChildren()) do
                esp.draw_highlight(fish, Color3.fromRGB(255, 103, 103))
            end
        else
            esp.clear_all()
        end
    end,
})

rayfield:LoadConfiguration()
