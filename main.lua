local toolbar = plugin:CreateToolbar("DeveloperPixels")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService("Selection")
local CurrentGui
local ProceedImg
local Opening = false
local ChildName = ""
local ReplaceWith = nil
local TopParent = nil
local UseFindFirstChild = false

if settings().Studio.Theme == "Dark" then
	ProceedImg = "rbxassetid://4458901886"
else
	ProceedImg = "rbxassetid://7653797535"
end

local PluginButton = toolbar:CreateButton("Replacer", "Replacer by DeveloperPixels", ProceedImg)
PluginButton.ClickableWhenViewportHidden = true

local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	true, 
	false,  
	500,    
	600,   
	350,    
	300     
)

local widgetInfo2 = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	true, 
	false,  
	221,    
	126,   
	221,    
	126     
)

local widget = plugin:CreateDockWidgetPluginGui("Replacer", widgetInfo)
widget.Enabled = false
widget.Title = "Replacer"

local selecting = plugin:CreateDockWidgetPluginGui("Replacer | Selecting", widgetInfo2)
selecting.Enabled = false
selecting.Title = "Selecting"


CurrentGui = script.Parent:WaitForChild("GUI"):WaitForChild("Frame")
CurrentGui.Parent = widget
local mouse = plugin:GetMouse()    
script.Parent:WaitForChild("SelectingMode"):WaitForChild("Frame").Parent = selecting

local Contents = CurrentGui:WaitForChild("Contents")

local function PluginButtonClicked()
	CurrentGui.Log.Visible = false
	widget.Enabled = not widget.Enabled
end

function LogEr(ctext,tex)
	CurrentGui.Log.Text = tex
	CurrentGui.Log.TextColor3 = ctext
	CurrentGui.Log.Visible = true

end

function Proceed()
	CurrentGui.Log.Visible = false
	ChildName = Contents.ChildName.TextBox.Text
	
	if TopParent == nil and ReplaceWith == nil then
		warn("Please select top parent and thing to replace first.")
		LogEr(Color3.fromRGB(255, 0, 0),"Please select top parent and thing to replace first.")
		return
	end
	if TopParent == nil and ReplaceWith == nil and ChildName == "" then
		warn("Please select top parent, thing to replace and ChildName first.")
		LogEr(Color3.fromRGB(255, 0, 0),"Please select top parent, thing to replace and ChildName first.")
		return
	end
	if TopParent == nil then
		warn("Please select top parent first.")
		LogEr(Color3.fromRGB(255, 0, 0),"Please select top parent first.")
		return
	end
	if ReplaceWith == nil then
		warn("Please select thing to replace first.")
		LogEr(Color3.fromRGB(255, 0, 0),"Please select thing to replace first.")
		return
	end
	if ChildName == "" then
		LogEr(Color3.fromRGB(255, 0, 0),"Please type ChildName first.")
		warn("Please type ChildName first.")
		return
	end
	
	Contents.Parent.ButtonPressPrevent.Visible = true

	local all2 = TopParent:GetChildren()
	
	for i = 1,#all2,1 do
		local tthi = all2[i]
		if UseFindFirstChild == true then
			if tthi:FindFirstChild(ChildName) then
				tthi:FindFirstChild(ChildName):Destroy()
				local nnnew = ReplaceWith:Clone()
				nnnew.Parent = tthi
			end
		else
			if tthi.Name == ChildName then
				tthi:Destroy()
				local nnnew = ReplaceWith:Clone()
				nnnew.Parent = TopParent
			end
		end
		wait(0)
	end
	Contents.Parent.ButtonPressPrevent.Visible = false

	LogEr(Color3.fromRGB(0, 255, 0),"Successfully Replaced!")
	
end

function SelectMode()
	Contents.Parent.ButtonPressPrevent.Visible = true

	while wait(0) do
		local current = Selection:Get()[1]

	
		if current ~= nil then
			selecting.Enabled = false
			Contents.Parent.ButtonPressPrevent.Visible = false
			return current
		end
		
		if selecting.Enabled == false then
			selecting.Enabled = true
			Contents.Parent.ButtonPressPrevent.Visible = true
		end
	end
end

function TopParentSelect()
	TopParent = SelectMode()
	if TopParent ~= nil then
		Contents.Top.TextBox.Text = TopParent:GetFullName()
	else
		Contents.Top.TextBox.Text = "Click here to locate object"
	end
end

function ReplaceWithSelect()
	ReplaceWith = SelectMode()
	if ReplaceWith ~= nil then
		Contents.ReplaceWith.TextBox.Text = ReplaceWith:GetFullName()
	else
		Contents.ReplaceWith.TextBox.Text = "Click here to locate object"
	end
	if ReplaceWith.Parent:IsA("DataModel") then
		ReplaceWith = nil
		Contents.ReplaceWith.TextBox.Text = "Click here to locate object"
		LogEr(Color3.fromRGB(255, 0, 0),"You cannot set Replace With to any Services")
	end
end

function SetUseFindFirstChild()
	if UseFindFirstChild == false then
		UseFindFirstChild = true
		Contents.UseFindFirstChild.TextButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	else
		UseFindFirstChild = false
		Contents.UseFindFirstChild.TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	end
end


PluginButton.Click:Connect(PluginButtonClicked)
Contents:WaitForChild("TextButton").MouseButton1Click:Connect(Proceed)
Contents:WaitForChild("Top"):WaitForChild("TextBox").MouseButton1Click:Connect(TopParentSelect)
Contents:WaitForChild("ReplaceWith"):WaitForChild("TextBox").MouseButton1Click:Connect(ReplaceWithSelect)
Contents:WaitForChild("UseFindFirstChild"):WaitForChild("TextButton").MouseButton1Click:Connect(SetUseFindFirstChild)
