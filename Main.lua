--[[
	User Interface Library
	Made by Late
]]

--// Connections
local GetService = game.GetService
local Connect = game.Loaded.Connect
local Wait = game.Loaded.Wait
local Clone = game.Clone 
local Destroy = game.Destroy 

if (not game:IsLoaded()) then
	local Loaded = game.Loaded
	Loaded.Wait(Loaded);
end

--// Important 
local Blur = require(loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Assets/Blur.lua"))());
local Setup = {
	Keybind = Enum.KeyCode.LeftControl,
	Transparency = 0.2,
	ThemeMode = "Dark",
	Size = nil,
}

--[[
	Primary = Color3.fromRGB(232, 232, 232),
	Secondary = Color3.fromRGB(255, 255, 255),
	Icon = Color3.fromRGB(100, 100, 100),
	Title = Color3.fromRGB(0, 0, 0),
	Description = Color3.fromRGB(100, 100, 100),
]]

local Theme = {
	--// Frames:
	Primary = Color3.fromRGB(30, 30, 30),
	Secondary = Color3.fromRGB(35, 35, 35),
	Component = Color3.fromRGB(40, 40, 40),
	Interactables = Color3.fromRGB(45, 45, 45),
	
	--// Text:
	Tab = Color3.fromRGB(200, 200, 200),
	Title = Color3.fromRGB(240,240,240),
	Description = Color3.fromRGB(200,200,200),
	
	--// Outlines:
	Shadow = Color3.fromRGB(0, 0, 0),
	Outline = Color3.fromRGB(40, 40, 40),
	
	--// Image:
	Icon = Color3.fromRGB(220, 220, 220),
}

--// Services & Functions
local LocalPlayer = GetService(game, "Players").LocalPlayer;
local Services = {
	Insert = GetService(game, "InsertService");
	Tween = GetService(game, "TweenService");
	Run = GetService(game, "RunService");
	Input = GetService(game, "UserInputService");
}

local Player = {
	Mouse = LocalPlayer:GetMouse();
	GUI = LocalPlayer.PlayerGui;
}

local Tween = function(Object : Instance, Speed : number, Properties : {},  Info : { EasingStyle: Enum?, EasingDirection: Enum? })
	local Style, Direction
	
	if Info then
		Style, Direction = Info["EasingStyle"], Info["EasingDirection"]
	else
		Style, Direction = Enum.EasingStyle.Sine, Enum.EasingDirection.Out
	end
	
	return Services.Tween:Create(Object, TweenInfo.new(Speed, Style, Direction), Properties):Play()
end

local SetProperty = function(Object: Instance, Properties: {})
	for Index, Property in next, Properties do
		Object[Index] = (Property);
	end
	
	return Object
end

local Multiply = function(Value, Amount)
	local New = {
		Value.X.Scale * Amount;
		Value.X.Offset * Amount;
		Value.Y.Scale * Amount;
		Value.Y.Offset * Amount;
	}

	return UDim2.new(unpack(New))
end

local Color = function(Color, Factor, Mode)
	Mode = Mode or Setup.ThemeMode

	if Mode == "Light" then
		return Color3.fromRGB((Color.R * 255) - Factor, (Color.G * 255) - Factor, (Color.B * 255) - Factor)
	else
		return Color3.fromRGB((Color.R * 255) + Factor, (Color.G * 255) + Factor, (Color.B * 255) + Factor)
	end
end

--// Setup [UI]
if (identifyexecutor) then
	Screen = (Services.Insert:LoadLocalAsset(18490507748));
else
	Screen = (script.Parent);
end

xpcall(function()
	Screen.Parent = game.CoreGui
end, function() 
	Screen.Parent = Player.GUI
end)

--// Tables for Data
local Animations = {}
local Blurs = {}
local Components = (Screen:FindFirstChild("Components"));
local Library = {};
local StoredInfo = {
	["Sections"] = {};
	["Tabs"] = {}
};

--// Animations [Window]
function Animations:Open(Window: CanvasGroup, Transparency: number)
	local Original = Setup.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChild("UIStroke")
	
	
	SetProperty(Shadow, { Transparency = 1 })
	SetProperty(Window, {
		Size = Multiplied,
		GroupTransparency = 1,
		Visible = true,
	})
	
	Tween(Shadow, .25, { Transparency = 0.5 })
	Tween(Window, .25, {
		Size = Original,
		GroupTransparency = Transparency or 0,
	})
end

function Animations:Close(Window: CanvasGroup)
	local Original = Window.Size
	local Multiplied = Multiply(Original, 1.1)
	local Shadow = Window:FindFirstChild("UIStroke")

	SetProperty(Window, {
		Size = Original,
	})

	Tween(Shadow, .25, { Transparency = 1 })
	Tween(Window, .25, {
		Size = Multiplied,
		GroupTransparency = 1,
	})
	
	task.wait(.25)
	Window.Size = Original
end


function Animations:Component(Component: any, Custom: boolean)	
	Connect(Component.InputBegan, function() 
		if Custom then
			Tween(Component, .25, { Transparency = .85 });
		else
			Tween(Component, .25, { BackgroundColor3 = Color(Theme.Component, 5, Setup.ThemeMode) });
		end
	end)
	
	Connect(Component.InputEnded, function() 
		if Custom then
			Tween(Component, .25, { Transparency = 1 });
		else
			Tween(Component, .25, { BackgroundColor3 = Theme.Component });
		end
	end)
end

--// Library [Window]

function Library:CreateWindow(Settings: { Title: string, Size: UDim2, Transparency: number, Blurring: boolean, Theme: string })
	local Window = Clone(Screen:WaitForChild("Main"));
	local Sidebar = Window:FindFirstChild("Sidebar");
	local Holder = Window:FindFirstChild("Main");
	local Tab = Sidebar:FindFirstChild("Tab");
	
	local Options = {};
	local Examples = {};
	local Opened = true;
	local Maximized = false
	
	for Index, Example in next, Window:GetDescendants() do
		if Example.Name:find("Example") and not Examples[Example.Name] then
			Examples[Example.Name] = Example
		end
	end
	
	--// UI Blur & More
	Setup.Transparency = Settings.Transparency or 0
	Setup.Size = Settings.Size
	
	if Settings.Blurring then
		Blurs[Settings.Title] = Blur.new(Window, 5)
	end
	
	--// Animate
	local Close = function()
		if Opened then
			if Settings.Blurring then
				Blurs[Settings.Title].root.Parent = nil
			end
			
			Opened = false
			Animations:Close(Window)
			Window.Visible = false
		else
			Animations:Open(Window, Setup.Transparency)
			Opened = true
			task.wait(.1)
			if Settings.Blurring then
				Blurs[Settings.Title].root.Parent = workspace.CurrentCamera
			end
		end
	end
	
	for Index, Button in next, Sidebar.Top.Buttons:GetChildren() do
		if Button:IsA("TextButton") then
			local Name = Button.Name
			Animations:Component(Button, true)
			
			Connect(Button.MouseButton1Click, function() 
				if Name == "Close" then
					Close()
				elseif Name == "Maximize" then
					if Maximized then
						Maximized = false
						Tween(Window, .15, { Size = Settings.Size});
					else
						Maximized = true
						Tween(Window, .15, { Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0.5, 0.5 )});
					end
				elseif Name == "Minimize" then
					Opened = false
					Window.Visible = false
					Blurs[Settings.Title].root.Parent = nil
				end
			end)
		end
	end
	
	Services.Input.InputBegan:Connect(function(Input) 
		if Input.KeyCode == Setup.Keybind then
			Close()
		end
	end)
	
	--// Tab Functions
	
	function Options:SetTab(Name: string)
		for Index, Button in next, Tab:GetChildren() do
			if Button:IsA("TextButton") then
				local Opened, SameName = Button.Value, (Button.Name == Name);
				local Padding = Button:FindFirstChildOfClass("UIPadding");
				
				if SameName and not Opened.Value then
					Tween(Padding, .25, { PaddingLeft = UDim.new(0, 25) });
					Tween(Button, .25, { BackgroundTransparency = 0.9, Size = UDim2.new(1, -15, 0, 30) });
					SetProperty(Opened, { Value = true });
				elseif not SameName and Opened.Value then
					Tween(Padding, .25, { PaddingLeft = UDim.new(0, 20) });
					Tween(Button, .25, { BackgroundTransparency = 1, Size = UDim2.new(1, -44, 0, 30) });
					SetProperty(Opened, { Value = false });
				end
			end
		end
		
		for Index, Main in next, Holder:GetChildren() do
			if Main:IsA("CanvasGroup") then
				local Opened, SameName = Main.Value, (Main.Name == Name);
				local Scroll = Main:FindFirstChild("ScrollingFrame");
				
				if SameName and not Opened.Value then
					Opened.Value = true
					Main.Visible = true
					
					Tween(Main, .3, { GroupTransparency = 0 });
					Tween(Scroll["UIPadding"], .3, { PaddingTop = UDim.new(0, 5) });
					
				elseif not SameName and Opened.Value then
					Opened.Value = false

					Tween(Main, .15, { GroupTransparency = 1 });
					Tween(Scroll["UIPadding"], .15, { PaddingTop = UDim.new(0, 15) });	
					
					task.delay(.2, function()
						Main.Visible = false
					end)
				end
			end
		end
	end
	
	function Options:AddSection(Settings: { Name: string, Order: number })
		local Example = Examples["SectionExample"];
		local Section = Clone(Example);
		
		StoredInfo["Sections"][Settings.Name] = (Settings.Order);
		SetProperty(Section, { 
			Parent = Example.Parent,
			Text = Settings.Name,
			Name = Settings.Name,
			LayoutOrder = Settings.Order,
			Visible = true
		});
	end
	
	function Options:AddTab(Settings: { Title: string, Icon: string, Section: string? })
		if StoredInfo["Tabs"][Settings.Title] then 
			error("[UI LIB]: A tab with the same name has already been created") 
		end 
				
		local Example, MainExample = Examples["TabButtonExample"], Examples["MainExample"];
		local Section = StoredInfo["Sections"][Settings.Section];
		local Main = Clone(MainExample);
		local Tab = Clone(Example);

		if not Settings.Icon then
			Destroy(Tab["ICO"]);
		else
			SetProperty(Tab["ICO"], { Image = Settings.Icon });
		end
		
		StoredInfo["Tabs"][Settings.Title] = { Tab }
		SetProperty(Tab["TextLabel"], { Text = Settings.Title });
		
		SetProperty(Main, { 
			Parent = MainExample.Parent,
			Name = Settings.Title;
		});
		
		SetProperty(Tab, { 
			Parent = Example.Parent,
			LayoutOrder = Section or #StoredInfo["Sections"] + 1,
			Name = Settings.Title;
			Visible = true;
		});
		
		Main.ScrollingFrame.Title.Text = Settings.Title
		Tab.MouseButton1Click:Connect(function()
			Options:SetTab(Tab.Name);
		end)
		
		return Main.ScrollingFrame
	end
	
	--// Component Functions
	
	function Options:GetLabels(Component)
		local Labels = Component:FindFirstChild("Labels")
		
		return Labels.Title, Labels.Description
	end
		
	function Options:AddButton(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		local Button = Clone(Components["Button"]);
		local Title, Description = Options:GetLabels(Button);
		
		Connect(Button.MouseButton1Click, Settings.Callback)
		Animations:Component(Button)
		SetProperty(Title, { Text = Settings.Title });
		SetProperty(Description, { Text = Settings.Description });
		SetProperty(Button, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddInput(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		local Input = Clone(Components["Input"]);
		local Title, Description = Options:GetLabels(Input);
		local TextBox = Input["Main"]["Input"];
		
		Connect(Input.MouseButton1Click, function() 
			TextBox:CaptureFocus()
		end)
		
		Connect(TextBox.FocusLost, function() 
			Settings.Callback(TextBox.Text)
		end)
		
		Animations:Component(Input)
		SetProperty(Title, { Text = Settings.Title });
		SetProperty(Description, { Text = Settings.Description });
		SetProperty(Input, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddToggle(Settings: { Title: string, Description: string, Tab: Instance, Callback: any }) 
		local Toggle = Clone(Components["Toggle"]);
		local Title, Description = Options:GetLabels(Toggle);
		
		local On = Toggle["Value"];
		local Main = Toggle["Main"];
		local Circle = Main["Circle"];
		
		Connect(Toggle.MouseButton1Click, function()
			local Value = not On.Value
			
			if Value then
				Tween(Main,   .2, { BackgroundColor3 = Color3.fromRGB(153, 155, 255) });
				Tween(Circle, .2, { BackgroundColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(1, -16, 0.5, 0) });

			else
				Tween(Main,   .2, { BackgroundColor3 = Theme.Interactables });
				Tween(Circle, .2, { BackgroundColor3 = Theme.Primary, Position = UDim2.new(0, 3, 0.5, 0) });
			end
			
			On.Value = Value
			Settings.Callback(Value)
		end)
		
		Animations:Component(Toggle)
		SetProperty(Title, { Text = Settings.Title });
		SetProperty(Description, { Text = Settings.Description });
		SetProperty(Toggle, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddSlider(Settings: { Title: string, Description: string, MaxValue: number, Tab: Instance, Callback: any }) 
		local Slider = Clone(Components["Slider"]);
		local Title, Description = Options:GetLabels(Slider);

		local Main = Slider["Slider"];
		local Amount = Main["Amount"].Input;
		local Slide = Main["Slide"];
		local Fire = Slide["Fire"];
		local Fill = Slide["Highlight"];
		local Circle = Fill["Circle"];

		local Active = false
		local Value = 0
		
		local Update = function() 
			local Scale = (Player.Mouse.X - Slide.AbsolutePosition.X) / Slide.AbsoluteSize.X			
			if Scale > 1 then
				Scale = 1
			elseif Scale < 0 then
				Scale = 0
			end
			
			Value =  math.round(Scale * Settings.MaxValue)
			Amount.Text = Value
			Fill.Size = UDim2.fromScale(Scale, 1)
			Settings.Callback(Value)
		end
		
		local Activate = function()
			Active = true
			
			repeat task.wait()
				Update()
			until not Active
		end
		
		Connect(Fire.MouseButton1Down, Activate)
		Connect(Services.Input.InputEnded, function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				Active = false
			end
		end)

		Fill.Size = UDim2.fromScale(Value, 1);
		Animations:Component(Slider);
		SetProperty(Title, { Text = Settings.Title });
		SetProperty(Description, { Text = Settings.Description });
		SetProperty(Slider, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	function Options:AddParagraph(Settings: { Title: string, Description: string, Tab: Instance }) 
		local Paragraph = Clone(Components["Paragraph"]);
		local Title, Description = Options:GetLabels(Paragraph);
		
		Animations:Component(Paragraph)
		SetProperty(Title, { Text = Settings.Title });
		SetProperty(Description, { Text = Settings.Description });
		SetProperty(Paragraph, {
			Name = Settings.Title,
			Parent = Settings.Tab,
			Visible = true,
		})
	end
	
	local Themes = {
		Names = {
			["Title"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Title
				end
			end,
			
			["Description"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Description
				end
			end,
			
			["TextLabel"] = function(Label)
				if Label:IsA("TextLabel") and Label.Parent:FindFirstChild("List") then
					Label.TextColor3 = Theme.Tab
				end
			end,
			
			["Main"] = function(Label)
				if Label:IsA("Frame") then
					
					if Label.Parent == Window then
						Label.BackgroundColor3 = Theme.Secondary
					else
						Label.BackgroundColor3 = Theme.Interactables

						if Label:FindFirstChild("Circle") then
							Label.Circle.BackgroundColor3 = Theme.Primary
						end
					end
				elseif Label:FindFirstChild("Padding") then
					Label.TextColor3 = Theme.Title
				end
			end,
			
			["Amount"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Theme.Interactables
				end
			end,
			
			["Slide"] = function(Label)
				if Label:IsA("Frame") then
					Label.BackgroundColor3 = Theme.Interactables
				end
			end,
			
			["Input"] = function(Label)
				if Label:IsA("TextLabel") then
					Label.TextColor3 = Theme.Title
				elseif Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Theme.Component
				elseif Label:IsA("TextBox") and Label.Parent.Name == "Main" then
					Label.TextColor3 = Theme.Title
				end
			end,
			
			["Outline"] = function(Stroke)
				if Stroke:IsA("UIStroke") then
					Stroke.Color = Theme.Outline
				end
			end,
		},

		Classes = {

			["ImageLabel"] = function(Label)
				if Label.Image ~= "rbxassetid://6644618143" then
					Label.ImageColor3 = Theme.Icon
				end
			end,
			
			["TextLabel"] = function(Label)
				if Label:FindFirstChild("Padding") then
					Label.TextColor3 = Theme.Title
				end
			end,
			
			["TextButton"] = function(Label)
				if Label:FindFirstChild("Labels") then
					Label.BackgroundColor3 = Theme.Component
				end
			end,
			
			["ScrollingFrame"] = function(Label)
				Label.ScrollBarImageColor3 = Theme.Component
			end,
		},
	}
	
	function Options:SetTheme(Info)
		Theme = Info or Theme
		
		Window.BackgroundColor3 = Theme.Primary
		Holder.BackgroundColor3 = Theme.Secondary
		Window.UIStroke.Color = Theme.Shadow
		Sidebar.Top.Underline.BackgroundColor3 = Theme.Outline
		
		for Index, Descendant in next, Window:GetDescendants() do
			local Name, Class =  Themes.Names[Descendant.Name],  Themes.Classes[Descendant.ClassName]
			
			if Name then
				Name(Descendant);
			elseif Class then
				Class(Descendant);
			end
		end
	end
		
	SetProperty(Window, { Size = Settings.Size, Visible = true, Parent = Screen });
	Animations:Open(Window, Settings.Transparency or 0)
	
	return Options
end

return Library
