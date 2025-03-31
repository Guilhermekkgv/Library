local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
	Theme = {
		Font = "RobotoMono",
		AccentColor = Color3.fromRGB(0,175,255),
		FontColor = Color3.fromRGB(255,255,255),
		HideKey = "LeftAlt"
	}
}

local CreateModule = {
    reg = {}
}

local function AddToReg(Instance)
    table.insert(CreateModule.reg, Instance)
end

local function CreateInstance(class, props)
    local inst = Instance.new(class)
    for prop, value in next, props do
        inst[prop] = value
    end
    return inst
end

local function Darker(col, coe)
    local h, s, v = Color3.toHSV(col)
    return Color3.fromHSV(h, s, v / (coe or 1.5))
end

function Library.Main(Name)
	for i,v in next, game.CoreGui:GetChildren() do
		if v.Name == "OcerLib" then
			v:Destroy()
		end
	end

	local OcerLib = CreateInstance("ScreenGui", {
		Name = "OcerLib",
		Parent = game.CoreGui
	})

    local Load = CreateInstance("Frame", {
		Parent = OcerLib,
		BackgroundColor3 = Color3.fromRGB(30,30,35),
        BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5,-250,0.5,-175),
        Size = UDim2.new(0,500,0,350),
        ZIndex = 5
	})

    CreateInstance("UICorner", {
        Parent = Load,
        CornerRadius = UDim.new(0,5)
    })

    local Topbar = CreateInstance("Frame", {
		Parent = OcerLib,
		BackgroundColor3 = Darker(Color3.fromRGB(30,30,35),1.15),
		BorderSizePixel = 0,
		Position = UDim2.new(0.5,-250,0.5,-175),
		Size = UDim2.new(0,500,0,30),
        Active = true,
        Draggable = true,
        Visible = false,
        ZIndex = 3
	})

    CreateInstance("UICorner", {
        Parent = Topbar,
        CornerRadius = UDim.new(0,5)
    })

    Topbar.Changed:Connect(function(Property)
        if Property == "Position" then
            Load.Position = Topbar.Position
        end
    end)

	CreateInstance("TextLabel", {
		Parent = Topbar,
		Font = Enum.Font[Library.Theme.Font],
		Text = Name,
		TextSize = 16,
		TextColor3 = Library.Theme.FontColor,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,10,0,0),
		Size = UDim2.new(0,100,1,0),
        ZIndex = 3
	})

	local Container = CreateInstance("Frame", {
		Parent = Topbar,
		BackgroundColor3 = Color3.fromRGB(30,30,33),
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,1,0),
		Size = UDim2.new(1,0,0,320),
        ClipsDescendants = true
	})

    CreateInstance("UICorner", {
        Parent = Container,
        CornerRadius = UDim.new(0,5)
    })

    local Pages = CreateInstance("Frame", {
		Parent = Container,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.new(1,0,1,0)
	})

    CreateInstance("UIPageLayout", {
        Parent = Pages,
        Padding = UDim.new(0,0),
        TweenTime = 0.2,
        EasingDirection = Enum.EasingDirection.Out,
        EasingStyle = Enum.EasingStyle.Sine,
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

	local TabsButtons = CreateInstance("Frame", {
		Parent = Topbar,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.25,0,0,0),
		Size = UDim2.new(0.75,0,1,0),
        ZIndex = 3
	})

	CreateInstance("UIListLayout", {
		Parent = TabsButtons,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,5),
        HorizontalAlignment = Enum.HorizontalAlignment.Right
	})

    spawn(function()
        wait(0.2)
        TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 0}):Play()
        wait(0.45)
        TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
        Topbar.Visible = true
    end)

    InputService.InputBegan:Connect(function(input,IsTyping)
        if input.KeyCode == Enum.KeyCode[Library.Theme.HideKey] and not IsTyping then
            spawn(function()
                TweenService:Create(Load,TweenInfo.new(0.15),{BackgroundTransparency = 0}):Play()
                wait(0.2)
                TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
                Topbar.Visible = not Topbar.Visible
            end)
        end
    end)

	local InMain = {}
    local TabCount = 0

	function InMain.Tab(Text)
        TabCount = TabCount + 1

		local TabButton = CreateInstance("TextButton", {
			Parent = TabsButtons,
            BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0,80,1,0),
			Font = Enum.Font[Library.Theme.Font],
			Text = Text,
			TextSize = 14,
			TextColor3 = Darker(Library.Theme.FontColor,2),
			TextXAlignment = Enum.TextXAlignment.Center,
			AutoButtonColor = false,
            ZIndex = 3
		})

        local IsTabActive = CreateInstance("BoolValue", {
            Parent = TabButton,
            Value = (TabCount == 1)
        })

        TabButton.TextColor3 = (IsTabActive.Value and Library.Theme.FontColor or Darker(Library.Theme.FontColor,2))

		TabButton.MouseEnter:Connect(function()
            if not IsTabActive.Value then
                TweenService:Create(TabButton,TweenInfo.new(0.2),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
            end
		end)

		TabButton.MouseLeave:Connect(function()
            if not IsTabActive.Value then
			    TweenService:Create(TabButton,TweenInfo.new(0.2),{TextColor3 = Darker(Library.Theme.FontColor,2)}):Play()
            end
		end)

        local Page = CreateInstance("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,1,0),
            CanvasSize = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 4
        })

        local PageList = CreateInstance("Frame", {
            Parent = Page,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0,5,0,5),
            Size = UDim2.new(0.48,0,1,-10)
        })

        local PageList2 = CreateInstance("Frame", {
            Parent = Page,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.52,0,0,5),
            Size = UDim2.new(0.48,0,1,-10)
        })

        CreateInstance("UIListLayout", {
            Parent = PageList,
            Padding = UDim.new(0,10),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        CreateInstance("UIListLayout", {
            Parent = PageList2,
            Padding = UDim.new(0,10),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local Fader = CreateInstance("Frame", {
            Parent = Page,
            BackgroundColor3 = Color3.fromRGB(30,30,33),
            BorderSizePixel = 0,
            Size = UDim2.new(1,0,1,0),
            ZIndex = 2
        })

        CreateInstance("Frame", {
            Parent = PageList,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,0),
            LayoutOrder = -99
        })

        CreateInstance("Frame", {
            Parent = PageList,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,5),
            LayoutOrder = 999
        })

        CreateInstance("Frame", {
            Parent = PageList2,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,0),
            LayoutOrder = -99
        })

        CreateInstance("Frame", {
            Parent = PageList2,
            BackgroundTransparency = 1,
            Size = UDim2.new(0,0,0,5),
            LayoutOrder = 999
        })

        TabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do
                if v ~= Page and v:FindFirstChild("Fader") then
                    TweenService:Create(v.Fader,TweenInfo.new(0.2),{BackgroundTransparency = 0}):Play()
                    spawn(function()
                        wait(0.2)
                        Pages.UIPageLayout:JumpTo(Page)
                        TweenService:Create(Fader,TweenInfo.new(0.2),{BackgroundTransparency = 1}):Play()
                    end)
                end
            end

            for i,v in next, TabsButtons:GetChildren() do
                if v.ClassName == "TextButton" then
                    v.IsActive.Value = (v == TabButton)
                    TweenService:Create(v,TweenInfo.new(0.2),{TextColor3 = (v.IsActive.Value and Library.Theme.FontColor or Darker(Library.Theme.FontColor,2))}):Play()
                end
            end
        end)

        if TabCount == 1 then
            Pages.UIPageLayout:JumpTo(Page)
            TweenService:Create(Fader,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
        end

        local InPage = {}

        function InPage.Section(Text)
            local InSection = {}
            local Column = PageList
            if PageList.UIListLayout.AbsoluteContentSize.Y > PageList2.UIListLayout.AbsoluteContentSize.Y then
                Column = PageList2
            end

            local Section = CreateInstance("Frame", {
                Parent = Column,
                BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0,30),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            CreateInstance("UICorner", {
                Parent = Section,
                CornerRadius = UDim.new(0,5)
            })

            CreateInstance("UIStroke", {
                Parent = Section,
                Thickness = 1,
                Color = Color3.fromRGB(40,40,40),
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })

            CreateInstance("TextLabel", {
                Parent = Section,
                Font = Enum.Font[Library.Theme.Font],
                Text = Text,
                TextSize = 16,
                TextColor3 = Library.Theme.FontColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0,5,0,5),
                Size = UDim2.new(1,-10,0,20)
            })

            local SectionElements = CreateInstance("Frame", {
                Parent = Section,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0,0,0,30),
                Size = UDim2.new(1,0,0,0),
                AutomaticSize = Enum.AutomaticSize.Y
            })

            CreateInstance("UIListLayout", {
                Parent = SectionElements,
                Padding = UDim.new(0,5),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            CreateInstance("Frame", {
                Parent = SectionElements,
                BackgroundTransparency = 1,
                Size = UDim2.new(0,0,0,5),
                LayoutOrder = -999
            })

            CreateInstance("Frame", {
                Parent = SectionElements,
                BackgroundTransparency = 1,
                Size = UDim2.new(0,0,0,5),
                LayoutOrder = 999
            })

            function InSection.Button(Text, func)
                local Button = CreateInstance("TextButton", {
                    Parent = SectionElements,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.95,0,0,25),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = Text,
                    TextSize = 14,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    AutoButtonColor = false
                })

                CreateInstance("UICorner", {
                    Parent = Button,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Button,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button,TweenInfo.new(0.2),{TextColor3 = Library.Theme.FontColor}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.2),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button,TweenInfo.new(0.2),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.2),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    spawn(function() func() end)
                end)

                AddToReg(Button)
                return Button
            end

            function InSection.Checkbox(Text, func, defbool)
                local Checkbox = CreateInstance("TextButton", {
                    Parent = SectionElements,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.95,0,0,25),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = "",
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })

                local Label = CreateInstance("TextLabel", {
                    Parent = Checkbox,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0,25,0,0),
                    Size = UDim2.new(1,-25,1,0),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = Text,
                    TextSize = 14,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local IsActive = CreateInstance("BoolValue", {
                    Parent = Checkbox,
                    Value = defbool or false
                })

                local Checked = CreateInstance("Frame", {
                    Parent = Checkbox,
                    BackgroundColor3 = (IsActive.Value and Library.Theme.AccentColor or Darker(Color3.fromRGB(32,32,37),1.15)),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,5,0,5),
                    Size = UDim2.new(0,15,0,15)
                })

                CreateInstance("UICorner", {
                    Parent = Checked,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Checked,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40)
                })

                IsActive.Changed:Connect(function()
                    if IsActive.Value then
                        TweenService:Create(Label,TweenInfo.new(0.2),{TextColor3 = Library.Theme.FontColor}):Play()
                        TweenService:Create(Checked,TweenInfo.new(0.2),{BackgroundColor3 = Library.Theme.AccentColor}):Play()
                        spawn(function() func(true) end)
                    else
                        TweenService:Create(Label,TweenInfo.new(0.2),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                        TweenService:Create(Checked,TweenInfo.new(0.2),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                        spawn(function() func(false) end)
                    end
                end)

                Checkbox.MouseButton1Click:Connect(function()
                    IsActive.Value = not IsActive.Value
                end)

                AddToReg(Checkbox)
                return Checkbox
            end

            function InSection.Slider(Text, min, max, func, precise, defvalue)
                local Slider = CreateInstance("Frame", {
                    Parent = SectionElements,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.95,0,0,40)
                })

                CreateInstance("TextLabel", {
                    Parent = Slider,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,0,15),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = Text,
                    TextSize = 14,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Center
                })

                local Bar = CreateInstance("Frame", {
                    Parent = Slider,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,0,0,20),
                    Size = UDim2.new(1,0,0,15),
                    ClipsDescendants = true
                })

                local Progress = CreateInstance("Frame", {
                    Parent = Bar,
                    BackgroundColor3 = Library.Theme.AccentColor,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0,0,1,0)
                })

                local ValueLabel = CreateInstance("TextLabel", {
                    Parent = Bar,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,1,0),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = tostring(defvalue) .. "/" .. max,
                    TextSize = 12,
                    TextColor3 = Library.Theme.FontColor,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 2
                })

                CreateInstance("UICorner", {
                    Parent = Bar,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UICorner", {
                    Parent = Progress,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Bar,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40)
                })

                local function UpdateSlider(val)
                    local percent = (val - min) / (max - min)
                    percent = math.clamp(percent, 0, 1)
                    Progress:TweenSize(UDim2.new(percent,0,1,0),"Out","Sine",0.1,true)
                end

                UpdateSlider(defvalue)

                local Dragging = false
                local value = defvalue

                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = true
                    end
                end)

                Bar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        Dragging = false
                    end
                end)

                InputService.InputChanged:Connect(function(input)
                    if Dragging and input.UserInputType == Enum.UserInputType.Touch then
                        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * pos)
                        if precise then value = min + (max - min) * pos end
                        UpdateSlider(value)
                        ValueLabel.Text = tostring(value) .. "/" .. max
                        func(value)
                    end
                end)

                AddToReg(Slider)
                return Slider
            end

            function InSection.Dropdown(Text, Selectables, ind, func)
                local Dropdown = CreateInstance("Frame", {
                    Parent = SectionElements,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.95,0,0,25),
                    ClipsDescendants = true
                })

                local DropdownButton = CreateInstance("TextButton", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1,0,1,0),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = "  " .. Text,
                    TextSize = 14,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })

                CreateInstance("ImageLabel", {
                    Parent = DropdownButton,
                    AnchorPoint = Vector2.new(1,0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1,-5,0.5,0),
                    Size = UDim2.new(0,15,0,15),
                    Image = "rbxassetid://3926305904",
                    ImageRectOffset = Vector2.new(44,404),
                    ImageRectSize = Vector2.new(36,36),
                    ImageColor3 = Library.Theme.FontColor
                })

                local List = CreateInstance("ScrollingFrame", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,0,1,0),
                    Size = UDim2.new(1,0,0,0),
                    CanvasSize = UDim2.new(0,0,0,0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0
                })

                CreateInstance("UIListLayout", {
                    Parent = List,
                    Padding = UDim.new(0,5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                CreateInstance("UICorner", {
                    Parent = Dropdown,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Dropdown,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                local IsOpened = false

                DropdownButton.MouseButton1Click:Connect(function()
                    IsOpened = not IsOpened
                    if IsOpened then
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,100),"Out","Sine",0.2,true)
                        List:TweenSize(UDim2.new(1,0,0,75),"Out","Sine",0.2,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.2),{Rotation = 180}):Play()
                    else
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,25),"Out","Sine",0.2,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Sine",0.2,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.2),{Rotation = 0}):Play()
                    end
                end)

                local function NewSelectable(string, value)
                    local Selectable = CreateInstance("TextButton", {
                        Parent = List,
                        BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                        BorderSizePixel = 0,
                        Size = UDim2.new(0.95,0,0,20),
                        Font = Enum.Font[Library.Theme.Font],
                        Text = string,
                        TextSize = 14,
                        TextColor3 = Darker(Library.Theme.FontColor,1.5),
                        TextXAlignment = Enum.TextXAlignment.Center,
                        AutoButtonColor = false
                    })

                    CreateInstance("UICorner", {
                        Parent = Selectable,
                        CornerRadius = UDim.new(0,5)
                    })

                    CreateInstance("UIStroke", {
                        Parent = Selectable,
                        Thickness = 1,
                        Color = Color3.fromRGB(40,40,40),
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    })

                    Selectable.MouseEnter:Connect(function()
                        TweenService:Create(Selectable,TweenInfo.new(0.2),{TextColor3 = Library.Theme.FontColor}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.2),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                    end)

                    Selectable.MouseLeave:Connect(function()
                        TweenService:Create(Selectable,TweenInfo.new(0.2),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.2),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                    end)

                    Selectable.MouseButton1Click:Connect(function()
                        DropdownButton.Text = "  " .. string
                        spawn(function() func(string, value) end)
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,25),"Out","Sine",0.2,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Sine",0.2,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.2),{Rotation = 0}):Play()
                        IsOpened = false
                    end)
                end

                for string,value in next, Selectables do
                    if ind == 1 then
                        NewSelectable(tostring(string),tostring(value))
                    else
                        NewSelectable(tostring(value),tostring(string))
                    end
                end

                local InDropdown = {}
                function InDropdown.Refresh(selec)
                    for i,v in next, List:GetChildren() do
                        if v.ClassName == "TextButton" then
                            v:Destroy()
                        end
                    end
                    wait()
                    for string,value in next, selec do
                        if ind == 1 then
                            NewSelectable(tostring(string),tostring(value))
                        else
                            NewSelectable(tostring(value),tostring(string))
                        end
                    end
                end

                AddToReg(Dropdown)
                return InDropdown
            end

            return InSection
        end
        return InPage
	end
	return InMain
end

return Library
