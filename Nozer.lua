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
		Position = UDim2.new(0.3,0,0.25,0),
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
		Position = UDim2.new(0.3,0,0.25,0),
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
		Size = UDim2.new(0.2,0,1,0),
        ZIndex = 3
	})

	local Container = CreateInstance("Frame", {
		Parent = Topbar,
		BackgroundColor3 = Color3.fromRGB(30,30,33),
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,1,-5),
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
        Padding = UDim.new(0,10),
        TweenTime = 0,
        EasingDirection = Enum.EasingDirection.Out,
        EasingStyle = Enum.EasingStyle.Sine,
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })

	local TabsButtons = CreateInstance("Frame", {
		Parent = Topbar,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0.3,0,0,0),
		Size = UDim2.new(0.7,0,1,0),
        ZIndex = 3
	})

	CreateInstance("UIListLayout", {
		Parent = TabsButtons,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,10)
	})

    Load.Size = UDim2.new(0,500,0,345)
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
			Position = UDim2.new(0,0,0,0),
			Size = UDim2.new(0.15,0,1,0),
			Font = Enum.Font[Library.Theme.Font],
			Text = Text,
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Center,
			AutoButtonColor = false,
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 3
		})

        local IsTabActive = CreateInstance("BoolValue", {
            Parent = TabButton,
            Value = (TabCount == 1)
        })

        TabButton.TextColor3 = (IsTabActive.Value and Library.Theme.FontColor or Darker(Library.Theme.FontColor,2))

		TabButton.MouseEnter:Connect(function()
            if IsTabActive.Value then
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Library.Theme.FontColor}):Play()
            else
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
            end
		end)

		TabButton.MouseLeave:Connect(function()
            if not IsTabActive.Value then
			    TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,2)}):Play()
            else
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,1.2)}):Play()
            end
		end)

        local Page = CreateInstance("ScrollingFrame", {
            Parent = Pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0,0,0,0),
            Size = UDim2.new(0.95,0,1,0),
            CanvasSize = UDim2.new(0,0,0,0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ScrollBarImageTransparency = 1
        })

        local PageList = CreateInstance("Frame", {
            Parent = Page,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.015,0,0.015,0),
            Size = UDim2.new(0.5,0,1,0)
        })

        local PageList2 = CreateInstance("Frame", {
            Parent = Page,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.52,0,0.015,0),
            Size = UDim2.new(0.5,0,1,0)
        })

        CreateInstance("UIListLayout", {
            Parent = PageList,
            Padding = UDim.new(0,15),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        CreateInstance("UIListLayout", {
            Parent = PageList2,
            Padding = UDim.new(0,15),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local Fader = CreateInstance("Frame", {
            Parent = Page,
            BackgroundColor3 = Color3.fromRGB(30,30,33),
            BorderSizePixel = 0,
            Position = UDim2.new(0,0,0,0),
            Size = UDim2.new(1,0,1,0),
            ZIndex = 2
        })

        CreateInstance("Frame", {
            Parent = PageList,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0,0,0,0),
            LayoutOrder = -99
        })

        CreateInstance("Frame", {
            Parent = PageList,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0,0,0,5),
            LayoutOrder = 999
        })

        CreateInstance("Frame", {
            Parent = PageList2,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0,0,0,0),
            LayoutOrder = -99
        })

        CreateInstance("Frame", {
            Parent = PageList2,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0,0,0,5),
            LayoutOrder = 999
        })

        TabButton.MouseButton1Click:Connect(function()
            for i,v in next, Pages:GetChildren() do
                if v.Name ~= Text and v:FindFirstChild("Fader") then
                    TweenService:Create(v.Fader,TweenInfo.new(0.3),{BackgroundTransparency = 0}):Play()
                    spawn(function()
                        wait(0.32)
                        Pages.UIPageLayout:JumpTo(Page)
                        TweenService:Create(Fader,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
                    end)
                end
            end

            for i,v in next, TabsButtons:GetChildren() do
                if v.ClassName == "TextButton" and v.Name ~= Text then
                    v.IsActive.Value = false
                    TweenService:Create(v,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,2)}):Play()
                end
            end
            IsTabActive.Value = true
            TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Library.Theme.FontColor}):Play()
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
                Size = UDim2.new(0.95,0,0,30),
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
                Position = UDim2.new(0,5,0,1),
                Size = UDim2.new(1,0,0,20)
            })

            local SectionElements = CreateInstance("Frame", {
                Parent = Section,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,1,0)
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
                BorderSizePixel = 0,
                Size = UDim2.new(0,0,0,20),
                LayoutOrder = -999
            })

            CreateInstance("Frame", {
                Parent = SectionElements,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(0,0,0,0),
                LayoutOrder = 999
            })

            function InSection.Button(Text, func)
                local Button = CreateInstance("TextButton", {
                    Parent = SectionElements,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                    BorderSizePixel = 1,
                    BorderColor3 = Color3.fromRGB(40,40,40),
                    Size = UDim2.new(0.95,0,0,20),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = Text,
                    TextSize = 16,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
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
                    TweenService:Create(Button,TweenInfo.new(0.3),{TextColor3 = Library.Theme.FontColor}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
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
                    Size = UDim2.new(0.95,0,0,20),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = "",
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false
                })

                CreateInstance("UICorner", {
                    Parent = Checkbox,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Checkbox,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                local Label = CreateInstance("TextLabel", {
                    Parent = Checkbox,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,27,0,0),
                    Size = UDim2.new(1,-25,1,0),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local IsActive = CreateInstance("BoolValue", {
                    Parent = Checkbox,
                    Value = defbool or false
                })

                Label.TextColor3 = (IsActive.Value and Library.Theme.FontColor or Darker(Library.Theme.FontColor,1.5))

                local Checked = CreateInstance("Frame", {
                    Parent = Checkbox,
                    BackgroundTransparency = 0,
                    BackgroundColor3 = (IsActive.Value and Library.Theme.AccentColor or Darker(Color3.fromRGB(32,32,37),1.15)),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,5,0.5,0),
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
                        TweenService:Create(Label,TweenInfo.new(0.3),{TextColor3 = Library.Theme.FontColor}):Play()
                        TweenService:Create(Checked,TweenInfo.new(0.3),{BackgroundColor3 = Library.Theme.AccentColor}):Play()
                        spawn(function() func(IsActive.Value) end)
                    else
                        TweenService:Create(Checked,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                        TweenService:Create(Label,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                        spawn(function() func(IsActive.Value) end)
                    end
                end)

                Checkbox.MouseButton1Click:Connect(function()
                    IsActive.Value = not IsActive.Value
                end)

                AddToReg(Checkbox)
                return Checkbox
            end

            function InSection.Slider(Text, min, max, func, precise, defvalue)
                local Slider = CreateInstance("TextLabel", {
                    Parent = SectionElements,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0.95,0,0,40),
                    Font = Enum.Font[Library.Theme.Font],
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    Text = Text,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Top
                })

                local Bar = CreateInstance("Frame", {
                    Parent = Slider,
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,0,0.75,0),
                    Size = UDim2.new(1,0,0,20),
                    ClipsDescendants = true
                })

                local ValueLabel = CreateInstance("TextLabel", {
                    Parent = Bar,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1,0,1,0),
                    Font = Enum.Font[Library.Theme.Font],
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    Text = tostring(defvalue) .. "/" .. max,
                    TextSize = 16,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ZIndex = 2
                })

                local Progress = CreateInstance("Frame", {
                    Parent = Bar,
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05),
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2.new(0,0.5),
                    Position = UDim2.new(0,0,0.5,0),
                    Size = UDim2.new(0,0,1,0)
                })

                CreateInstance("UICorner", {
                    Parent = Bar,
                    CornerRadius = UDim.new(0,5)
                })

                CreateInstance("UIStroke", {
                    Parent = Bar,
                    Thickness = 1,
                    Color = Color3.fromRGB(40,40,40)
                })

                CreateInstance("UICorner", {
                    Parent = Progress,
                    CornerRadius = UDim.new(0,5)
                })

                local Mouse = game.Players.LocalPlayer:GetMouse()

				local function UpdateSlider(val)
					local percent = (val - min) / (max - min)
					percent = math.clamp(percent, 0, 1)
					Progress:TweenSize(UDim2.new(percent, 0, 1, 0),"Out","Sine",0.2,true)
				end

				UpdateSlider(defvalue)

				local Dragging = false
				local RealValue = defvalue
				local value

				local function move(Pressed)
					local pos = UDim2.new(math.clamp((Pressed.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1), 0, 1, 0)
					Progress:TweenSize(pos, "Out", "Quart", 0.2, true)
					RealValue = (((pos.X.Scale * max) / max) * (max - min) + min)
					value = (precise and string.format("%.1f", RealValue)) or math.floor(RealValue)
					ValueLabel.Text = tostring(value) .. "/" .. max 
					func(value)
				end

				Bar.InputBegan:Connect(function(Pressed)
					if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
                        move(Pressed)
                        TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library.Theme.AccentColor,1.2)}):Play()
					end
				end)

				Bar.InputEnded:Connect(function(Pressed)
					if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
                        TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library.Theme.AccentColor,1.7)}):Play()
                        move(Pressed)
					end
				end)

				InputService.InputChanged:Connect(function(Pressed)
					if Dragging and Pressed.UserInputType == Enum.UserInputType.MouseMovement then
                        move(Pressed)
					end
				end)

				Bar.MouseEnter:Connect(function()
					TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library.Theme.AccentColor,1.7)}):Play()
				end)

				Bar.MouseLeave:Connect(function()
					if not Dragging then
						TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05)}):Play()
					end
                    if Dragging then
                        spawn(function()
                            repeat wait() until not Dragging
                            TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05)}):Play()
                        end)
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
                    Size = UDim2.new(0.95,0,0,20),
                    ClipsDescendants = true
                })

                local DropdownButton = CreateInstance("TextButton", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1,0,0,20),
                    Font = Enum.Font[Library.Theme.Font],
                    Text = "  " .. Text,
                    TextSize = 16,
                    TextColor3 = Darker(Library.Theme.FontColor,1.5),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Center,
                    AutoButtonColor = false
                })

                CreateInstance("ImageLabel", {
                    Parent = DropdownButton,
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0.9, 0, 0.5, 0),
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = "rbxassetid://3926305904",
                    ImageColor3 = Color3.fromRGB(136, 136, 136),
                    ImageRectOffset = Vector2.new(44, 404),
                    ImageRectSize = Vector2.new(36, 36)
                })

                local List = CreateInstance("ScrollingFrame", {
                    Parent = Dropdown,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0,0,0,20),
                    Size = UDim2.new(1,0,0,0),
                    CanvasSize = UDim2.new(0,0,0,0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    ScrollBarImageTransparency = 1
                })

                CreateInstance("UIListLayout", {
                    Parent = List,
                    Padding = UDim.new(0,5),
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                CreateInstance("Frame", {
                    Parent = List,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0,0,0,0),
                    LayoutOrder = -99999
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
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,120),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,100),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.3),{Rotation = 180}):Play()
                    else
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,20),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.3),{Rotation = 0}):Play()
                    end
                end)

                local function NewSelectable(string, value)
                    local Selectable = CreateInstance("TextButton", {
                        Parent = List,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0.95,0,0,20),
                        Font = Enum.Font[Library.Theme.Font],
                        Text = "  " .. string,
                        TextSize = 16,
                        TextColor3 = Darker(Library.Theme.FontColor,1.5),
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center,
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
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{TextColor3 = Library.Theme.FontColor}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                    end)

                    Selectable.MouseLeave:Connect(function()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{TextColor3 = Darker(Library.Theme.FontColor,1.5)}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                    end)

                    Selectable.MouseButton1Click:Connect(function()
                        spawn(function() func(string,value) end)
                        DropdownButton.Text = "  " .. string
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,20),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownButton:FindFirstChildOfClass("ImageLabel"),TweenInfo.new(0.3),{Rotation = 0}):Play()
                        IsOpened = false
                    end)
                end

                for string,value in next, Selectables do
                    if ind == 1 then
                        NewSelectable(tostring(string),tostring(value))
                    elseif ind == 2 then
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
                        elseif ind == 2 then
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
