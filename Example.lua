local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
	Title = "Arc",
	Size = UDim2.fromOffset(500, 300),
	Transparency = 0.05,
	Blurring = true,
	Theme = "Light",
})

local Themes = {
	Light = {
		--// Frames:
		Primary = Color3.fromRGB(232, 232, 232),
		Secondary = Color3.fromRGB(255, 255, 255),
		Component = Color3.fromRGB(245, 245, 245),
		Interactables = Color3.fromRGB(235, 235, 235),

		--// Text:
		Tab = Color3.fromRGB(50, 50, 50),
		Title = Color3.fromRGB(0, 0, 0),
		Description = Color3.fromRGB(100, 100, 100),

		--// Outlines:
		Shadow = Color3.fromRGB(255, 255, 255),
		Outline = Color3.fromRGB(210, 210, 210),

		--// Image:
		Icon = Color3.fromRGB(100, 100, 100),
	},
	
	Dark = {
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
	},

}

--// Sections

Window:AddSection({
	Name = "Main",
	Order = 1,
})

Window:AddSection({
	Name = "Settings",
	Order = 2,
})

--// Tab [MAIN]

local Main = Window:AddTab({
	Title = "Components",
	Section = "Main",
})

Window:AddParagraph({
	Title = "components",
	Description = "this one of them",
	Tab = Main
}) 

Window:AddButton({
	Title = "Button",
	Description = "clicking",
	Tab = Main,
	Callback = function() 
		warn("You have pressed the button!");
	end,
}) 

Window:AddSlider({
	Title = "Slider",
	Description = "sliding",
	Tab = Main,
	MaxValue = 100,
	Callback = function(Amount) 
		warn(Amount);
	end,
}) 

Window:AddToggle({
	Title = "Toggle",
	Description = "switchy",
	Tab = Main,
	Callback = function(Boolean) 
		warn(Boolean);
	end,
}) 

Window:AddInput({
	Title = "Input",
	Description = "dont",
	Tab = Main,
	Callback = function(Text) 
		warn(Text);
	end,
}) 

--// Tab [SETTINGS]

local Edit = Window:AddTab({
	Title = "Edit",
	Section = "Settings",
	Icon = "rbxassetid://11432847075",
})

Window:AddDropdown({
	Title = "Test",
	Description = "PLease select",
	Tab = Edit,
	Options = {
		["This is the name!"] = "And this is the value that gets sent!",
		
		
		["aahhahaha"] = "Value",
		["cocos pov dropdown"] = "whos cocos pov",
		["HMMM"] = "i clciked hmmm",
		["Lol."] = "lol lol",
		["hello"] = "hi",
		["wha tthe"] = "what",
		["brrbrbbr"] = "brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr",

	},
	Callback = function(Option) 
		warn(Option)
	end,
}) 

Window:SetTheme(Themes.Light)
