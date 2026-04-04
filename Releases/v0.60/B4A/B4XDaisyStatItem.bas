B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#Region Events
#Event: Click (Tag As Object)
#End Region

#Region Designer Properties
#DesignerProperty: Key: Title, DisplayName: Title, FieldType: String, DefaultValue: , Description: The stat title.
#DesignerProperty: Key: Value, DisplayName: Value, FieldType: String, DefaultValue: , Description: The stat value.
#DesignerProperty: Key: Description, DisplayName: Description, FieldType: String, DefaultValue: , Description: The stat description.
#DesignerProperty: Key: ValueColor, DisplayName: Value Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Text color variant for the value label.
#DesignerProperty: Key: DescriptionColor, DisplayName: Description Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Text color variant for the description label.
#DesignerProperty: Key: Variant, DisplayName: Background Variant, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Background color variant.
#DesignerProperty: Key: FigureType, DisplayName: Figure Type, FieldType: String, DefaultValue: none, List: none|svg|image|radial, Description: Type of figure to display in the figure slot.
#DesignerProperty: Key: FigureSource, DisplayName: Figure Source, FieldType: String, DefaultValue: , Description: SVG asset filename, image path, or initial radial value.
#DesignerProperty: Key: FigureSize, DisplayName: Figure Size, FieldType: Int, DefaultValue: 48, Description: Size of the figure in dip.
#DesignerProperty: Key: FigureColor, DisplayName: Figure Color, FieldType: String, DefaultValue: none, List: none|neutral|primary|secondary|accent|info|success|warning|error, Description: Color variant for the figure.
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: String, DefaultValue: px-6 py-4, Description: Tailwind padding utilities (e.g. px-6 py-4).
#DesignerProperty: Key: GapX, DisplayName: Column Gap, FieldType: Int, DefaultValue: 16, Description: Gap between text column and figure (in dip).
#DesignerProperty: Key: CenterItems, DisplayName: Center Items, FieldType: Boolean, DefaultValue: False, Description: Center align all items.
#DesignerProperty: Key: Visible, DisplayName: Visible, FieldType: Boolean, DefaultValue: True, Description: Visible state.
#DesignerProperty: Key: Enabled, DisplayName: Enabled, FieldType: Boolean, DefaultValue: True, Description: Enabled state.
#End Region

#Region Variables
#IgnoreWarnings:12
Sub Class_Globals
    Private xui As XUI
    Public mBase As B4XView
    Private mEventName As String
    Private mCallBack As Object
    Private mTag As Object
    
    ' Internal views
    Private mFigureSlot As B4XDaisyDivision
    Private mTitleLabel As B4XDaisyText
    Private mValueLabel As B4XDaisyText
    Private mDescLabel As B4XDaisyText
    Private mActionsSlot As B4XDaisyDivision
    
    ' Figure sub-components (created on demand by UpdateFigure)
    Private mFigureIcon As B4XDaisySvgIcon
    Private mFigureAvatar As B4XDaisyAvatar
    Private mFigureRadial As B4XDaisyRadialProgress
    
    ' Local properties
    Private mTitle As String = ""
    Private mValue As String = ""
    Private mDescription As String = ""
    Private mValueColor As String = "none"
    Private mDescriptionColor As String = "none"
    Private mVariant As String = "none"
    Private mFigureType As String = "none"
    Private mFigureSource As String = ""
    Private mFigureSize As Int = 48
    Private mFigureColor As String = "none"
    Private mPadding As String = "px-6 py-4"
    Private mGapX As Int = 16
    Private mCenterItems As Boolean = False
    Private mIsResizing As Boolean = False
    Private mOrientation As String = "horizontal"
    Private mShowSeparator As Boolean = False
    Private mSepPanel As Panel   ' Persistent separator line ? no canvas needed
    Private mContentWidth As Int = 0
    Private mContentHeight As Int = 0
    
    ' Cached resolved padding values (in pixels)
    Private mPadX As Int = 0
    Private mPadY As Int = 0
End Sub

' removed forwarding helpers; use B4XDaisyVariants directly

''' Resolves the Padding utility string into mPadX / mPadY pixel values.
Private Sub ResolvePadding
    Dim padModel As Map = B4XDaisyBoxModel.CreateDefaultModel
    B4XDaisyBoxModel.ApplyPaddingUtilities(padModel, mPadding, False)
    mPadX = padModel.Get("padding_left")
    mPadY = padModel.Get("padding_top")
End Sub
#End Region

#Region Initialization
Public Sub Initialize(Callback As Object, EventName As String)
    mCallBack = Callback
    mEventName = EventName
End Sub

Public Sub DesignerCreateView(Base As Object, Lbl As Label, Props As Map)
    mBase = Base
    If mTag = Null Then mTag = mBase.Tag
    mBase.Tag = Me
    mBase.Color = xui.Color_Transparent
    
    ' Create Slots/Parts
    Dim p1 As Panel : p1.Initialize("")
    mFigureSlot.Initialize(Me, "mFigureSlot")
    mFigureSlot.DesignerCreateView(p1, Null, CreateMap("Visible": False))
    mBase.AddView(mFigureSlot.mBase, 0, 0, 0, 0)
    
    Dim tp1 As Panel : tp1.Initialize("")
    mTitleLabel.Initialize(Me, "mTitleLabel")
    mTitleLabel.DesignerCreateView(tp1, Null, CreateMap("TextSize": "text-xs", "TextColor": "text-base-content/60"))
    mBase.AddView(mTitleLabel.mBase, 0, 0, 0, 0)
    
    Dim tp2 As Panel : tp2.Initialize("")
    mValueLabel.Initialize(Me, "mValueLabel")
    ' CSS .stat-value: font-size: 2rem (32sp); font-weight: 800 (extrabold)
    mValueLabel.DesignerCreateView(tp2, Null, CreateMap("TextSize": "32", "FontBold": True))
    mBase.AddView(mValueLabel.mBase, 0, 0, 0, 0)
    
    Dim tp3 As Panel : tp3.Initialize("")
    mDescLabel.Initialize(Me, "mDescLabel")
    mDescLabel.DesignerCreateView(tp3, Null, CreateMap("TextSize": "text-xs", "TextColor": "text-base-content/60"))
    mBase.AddView(mDescLabel.mBase, 0, 0, 0, 0)
    
    Dim p2 As Panel : p2.Initialize("")
    mActionsSlot.Initialize(Me, "mActionsSlot")
    mActionsSlot.DesignerCreateView(p2, Null, CreateMap("Visible": False))
    mBase.AddView(mActionsSlot.mBase, 0, 0, 0, 0)
    mActionsSlot.mBase.Visible = False   ' Division ignores Visible prop ? force it
    
    ' Separator panel ? persistent 1dip child, positioned at right or bottom edge
    mSepPanel.Initialize("")
    mBase.AddView(mSepPanel, 0, 0, 0, 0)
    
    ' Load properties - only if not already set programmatically
    If mTitle = "" Then mTitle = B4XDaisyVariants.GetPropString(Props, "Title", "")
    If mValue = "" Then mValue = B4XDaisyVariants.GetPropString(Props, "Value", "")
    If mDescription = "" Then mDescription = B4XDaisyVariants.GetPropString(Props, "Description", "")
    If mCenterItems = False Then mCenterItems = B4XDaisyVariants.GetPropBool(Props, "CenterItems", False)
    If mValueColor = "none" Or mValueColor = "" Then mValueColor = B4XDaisyVariants.GetPropString(Props, "ValueColor", "none")
    If mDescriptionColor = "none" Or mDescriptionColor = "" Then mDescriptionColor = B4XDaisyVariants.GetPropString(Props, "DescriptionColor", "none")
    If mVariant = "none" Or mVariant = "" Then mVariant = B4XDaisyVariants.GetPropString(Props, "Variant", "none")
    If mFigureType = "none" Or mFigureType = "" Then mFigureType = B4XDaisyVariants.GetPropString(Props, "FigureType", "none")
    If mFigureSource = "" Then mFigureSource = B4XDaisyVariants.GetPropString(Props, "FigureSource", "")
    If mFigureSize = 0 Or mFigureSize = 48 Then mFigureSize = B4XDaisyVariants.GetPropInt(Props, "FigureSize", 48)
    If mFigureColor = "none" Or mFigureColor = "" Then mFigureColor = B4XDaisyVariants.GetPropString(Props, "FigureColor", "none")
    If mPadding = "" Or mPadding = "px-6 py-4" Then mPadding = B4XDaisyVariants.GetPropString(Props, "Padding", "px-6 py-4")
    If mGapX = 0 Or mGapX = 16 Then mGapX = B4XDaisyVariants.GetPropInt(Props, "GapX", 16)
    
    ResolvePadding
    UpdateFigure
    Refresh
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
    Dim p As Panel
    p.Initialize("")
    Dim b As B4XView = p
    b.Color = xui.Color_Transparent
    Dim props As Map
    props.Initialize
    Dim dummy As Label
    DesignerCreateView(b, dummy, props)
    Base_Resize(Width, Height)
    Return mBase
End Sub
#End Region

#Region Public API
''' Returns the content-driven width after layout.
Public Sub getContentWidth As Int
    Return mContentWidth
End Sub

''' Returns the content-driven height after layout.
Public Sub getContentHeight As Int
    Return mContentHeight
End Sub

Public Sub UpdateTheme
    If mBase.IsInitialized = False Then Return
    Refresh
End Sub

Public Sub Refresh
    If mBase.IsInitialized = False Then Return
    
    ' Ensure resolved padding values are available
    If mPadX = 0 And mPadY = 0 Then ResolvePadding
    
    mTitleLabel.Text = mTitle
    mTitleLabel.mBase.Visible = (mTitle <> "")
    
    mValueLabel.Text = mValue
    mValueLabel.mBase.Visible = (mValue <> "")
    
    mDescLabel.Text = mDescription
    mDescLabel.mBase.Visible = (mDescription <> "")
    
    ' Apply background variant and resolve text colors
    ' Variant: changes both background AND all text colors (title, value, desc)
    ' ValueColor: changes only the value label text color (overrides Variant for value)
    ' DescriptionColor: changes only the description label text color (overrides Variant for desc)
    ' FigureColor: changes only the figure component color (handled in UpdateFigure)
    Dim hasVariant As Boolean = (mVariant <> "none" And mVariant <> "")
    
    If hasVariant Then
        mBase.Color = B4XDaisyVariants.ResolveBackgroundColorVariant(mVariant, xui.Color_Transparent)
    Else
        mBase.Color = xui.Color_Transparent
    End If
    
    ' Resolve text colors
    Dim titleDescColor As Int
    Dim valueColor As Int
    
    If hasVariant Then
        ' Variant sets all text to the variant's content color
        Dim variantContentColor As Int = B4XDaisyVariants.ResolveTextColorVariant(mVariant, xui.Color_White)
        titleDescColor = variantContentColor
        valueColor = variantContentColor
    Else
        ' Default: title/desc are muted base-content @ 60% alpha, value is full base-content
        Dim baseContentRaw As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_Gray)
        Dim bcR As Int = Bit.And(Bit.ShiftRight(baseContentRaw, 16), 0xFF)
        Dim bcG As Int = Bit.And(Bit.ShiftRight(baseContentRaw, 8), 0xFF)
        Dim bcB As Int = Bit.And(baseContentRaw, 0xFF)
        titleDescColor = xui.Color_ARGB(153, bcR, bcG, bcB) ' 60% alpha (153/255)
        valueColor = baseContentRaw
    End If
    
    ' ValueColor overrides the value label color (regardless of Variant)
    ' e.g. "primary" ? text-primary ? --color-primary (the variant hue itself, not -content)
    If mValueColor <> "none" And mValueColor <> "" Then
        valueColor = B4XDaisyVariants.ResolveTextColor(mValueColor, valueColor)
    End If
    
    ' DescriptionColor overrides the description label color (regardless of Variant)
    If mDescriptionColor <> "none" And mDescriptionColor <> "" Then
        titleDescColor = B4XDaisyVariants.ResolveTextColor(mDescriptionColor, titleDescColor)
    End If
    
    If mCenterItems Then
        mTitleLabel.HAlign = "CENTER"
        mValueLabel.HAlign = "CENTER"
        mDescLabel.HAlign = "CENTER"
    Else
        mTitleLabel.HAlign = "LEFT"
        mValueLabel.HAlign = "LEFT"
        mDescLabel.HAlign = "LEFT"
    End If
    
    mTitleLabel.setTextColor(titleDescColor)
    mDescLabel.setTextColor(titleDescColor)
    mValueLabel.setTextColor(valueColor)
    
    ' Trigger layout ? always remeasure from content (inline-grid: shrink-wrap).
    Base_Resize(0, 0)
End Sub

' Estimates the preferred width based on content (Title, Value, Description measured widths)
Public Sub EstimatePreferredWidth As Float
    Dim neededWidth As Float = 0
    If mTitleLabel.mBase.Visible Then neededWidth = Max(neededWidth, mTitleLabel.MeasureTextWidth)
    If mValueLabel.mBase.Visible Then neededWidth = Max(neededWidth, mValueLabel.MeasureTextWidth)
    If mDescLabel.mBase.Visible Then neededWidth = Max(neededWidth, mDescLabel.MeasureTextWidth)
    If mActionsSlot.mBase.Visible Then neededWidth = Max(neededWidth, 120dip)
    
    If mPadX = 0 Then ResolvePadding
    Dim total As Float = neededWidth + (mPadX * 2)
    
    ' If figure is visible on the right (and not centered)
    If mFigureSlot.mBase.Visible And mCenterItems = False Then
        total = total + DipToCurrent(mGapX) + DipToCurrent(mFigureSize)
    End If
    
    Return Max(total, 120dip) ' Minimum width
End Sub

' Returns the measured preferred height using actual font metrics.
Public Sub EstimatePreferredHeight As Float
    If mBase.IsInitialized = False Then Return 60dip
    If mPadY = 0 Then ResolvePadding
    Dim gapBetween As Int = 2dip
    Dim contentH As Int = 0
    Dim numRows As Int = 0
    If mTitleLabel.mBase.Visible Then : contentH = contentH + Ceil(mTitleLabel.MeasureTextHeight) : numRows = numRows + 1 : End If
    If mValueLabel.mBase.Visible Then : contentH = contentH + Ceil(mValueLabel.MeasureTextHeight) : numRows = numRows + 1 : End If
    If mDescLabel.mBase.Visible Then : contentH = contentH + Ceil(mDescLabel.MeasureTextHeight) : numRows = numRows + 1 : End If
    If mActionsSlot.mBase.Visible Then : contentH = contentH + 36dip : numRows = numRows + 1 : End If
    contentH = contentH + Max(0, numRows - 1) * gapBetween
    Return Max(contentH + (mPadY * 2), 60dip)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
    If Parent.IsInitialized = False Then Return mBase
    CheckBase(Width, Height)
    Parent.AddView(mBase, Left, Top, Width, Height)
    Return mBase
End Sub

Private Sub CheckBase(Width As Int, Height As Int)
    If mBase.IsInitialized Then Return
    CreateView(Width, Height)
    Refresh
End Sub

Public Sub setOrientation(Value As String)
    mOrientation = Value
End Sub

Public Sub setShowSeparator(Value As Boolean)
    mShowSeparator = Value
End Sub

Public Sub setCenterItems(Value As Boolean)
    mCenterItems = Value
End Sub

Public Sub getCenterItems As Boolean
    Return mCenterItems
End Sub

Public Sub getFigure As B4XView
    CheckBase(100dip, 100dip)
    mFigureSlot.mBase.Visible = True
    ' Pre-size to mFigureSize so children added to this slot are not clipped to 0x0
    Dim figSz As Int = DipToCurrent(mFigureSize)
    If mFigureSlot.mBase.Width < figSz Or mFigureSlot.mBase.Height < figSz Then
        mFigureSlot.mBase.SetLayoutAnimated(0, mFigureSlot.mBase.Left, mFigureSlot.mBase.Top, figSz, figSz)
    End If
    Return mFigureSlot.mBase
End Sub

Public Sub setFigure(v As B4XView)
    CheckBase(100dip, 100dip)
    mFigureSlot.mBase.RemoveAllViews
    mFigureSlot.mBase.AddView(v, 0, 0, mFigureSlot.mBase.Width, mFigureSlot.mBase.Height)
    mFigureSlot.mBase.Visible = True
    Refresh
End Sub

Public Sub getActions As B4XView
    CheckBase(100dip, 100dip)
    mActionsSlot.mBase.Visible = True
    Return mActionsSlot.mBase
End Sub

''' Adds a B4XDaisyButton to the stat-actions slot.
''' The button is created inside the actions slot automatically ? no external AddToParent needed.
''' Usage: item.AddAction(btn)
Public Sub AddAction(btn As B4XDaisyButton)
    CheckBase(100dip, 100dip)
    mActionsSlot.mBase.Visible = True
    btn.AddToParent(mActionsSlot.mBase, 0, 0, 80dip, 30dip)
End Sub

''' Creates / updates the figure child component based on FigureType.
''' Clears any previous figure content. Called from DesignerCreateView and property setters.
Private Sub UpdateFigure
    If mBase.IsInitialized = False Then Return   ' view tree not yet created
    If mFigureSlot.mBase.IsInitialized = False Then Return
    
    ' Clear previous figure children
    mFigureSlot.mBase.RemoveAllViews
    
    If mFigureType = "none" Or mFigureType = "" Then
        mFigureSlot.mBase.Visible = False
        Return
    End If
    
    ' Pre-size the slot as a square at mFigureSize dip
    Dim figSz As Int = DipToCurrent(mFigureSize)
    mFigureSlot.mBase.Visible = True
    mFigureSlot.mBase.SetLayoutAnimated(0, mFigureSlot.mBase.Left, mFigureSlot.mBase.Top, figSz, figSz)
    
    Select mFigureType
        Case "svg"
            mFigureIcon.Initialize(Me, "")
            mFigureIcon.AddToParent(mFigureSlot.mBase, 0, 0, figSz, figSz)
            ' Resolve figure color from FigureVariant, fall back to ValueColor, then gray
            Dim figCol As Int = ResolveFigureColor
            mFigureIcon.setColor(figCol)
            Dim s As String = mFigureSource.Trim
            If s.ToLowerCase.EndsWith(".svg") Then
                mFigureIcon.setSvgAsset(s)
            Else If s.Length > 0 Then
                mFigureIcon.setSvgContent(s)
            End If
            
        Case "image"
            mFigureAvatar.Initialize(Me, "")
            mFigureAvatar.AddToParent(mFigureSlot.mBase, 0, 0, figSz, figSz)
            mFigureAvatar.setAvatarSize(figSz)
            If mFigureSource.Trim.Length > 0 Then mFigureAvatar.setImage(mFigureSource.Trim)
            
        Case "radial"
            mFigureRadial.Initialize(Me, "")
            mFigureRadial.AddToParent(mFigureSlot.mBase, 0, 0, figSz, figSz)
            mFigureRadial.setSize(figSz)
            ' FigureSource holds the initial numeric value as string
            Dim radVal As Int = 0
            If IsNumber(mFigureSource) Then radVal = mFigureSource
            mFigureRadial.setValue(radVal)
            ' Apply variant
            Dim rv As String = mFigureColor
            If rv = "none" Then rv = mValueColor
            If rv <> "none" Then mFigureRadial.setVariant(rv)
    End Select
End Sub

''' Resolves the figure icon color: prefers FigureColor, fallback to ValueColor, fallback to gray.
Private Sub ResolveFigureColor As Int
    Dim variant As String = mFigureColor
    If variant = "none" Or variant = "" Then variant = mValueColor
    If variant = "none" Or variant = "" Then Return xui.Color_RGB(156, 163, 175) ' gray-400
    Return B4XDaisyVariants.ResolveTextColor(variant, xui.Color_RGB(156, 163, 175))
End Sub

Public Sub setTitle(Value As String)
    mTitle = Value
    If mBase.IsInitialized = False Then Return
End Sub

Public Sub getTitle As String
    Return mTitle
End Sub

Public Sub setValue(Value As String)
    mValue = Value
    If mBase.IsInitialized = False Then Return
End Sub

Public Sub getValue As String
    Return mValue
End Sub


Public Sub setDescription(Value As String)
    mDescription = Value
    If mBase.IsInitialized = False Then Return
End Sub

Public Sub getDescription As String
    Return mDescription
End Sub

' === New designer properties ===

''' Sets the color variant for the value label (none|primary|secondary|...).
Public Sub setValueColor(Value As String)
    mValueColor = Value
End Sub

Public Sub getValueColor As String
    Return mValueColor
End Sub

''' Sets the color variant for the description label (none|primary|secondary|...).
Public Sub setDescriptionColor(Value As String)
    mDescriptionColor = Value
End Sub

Public Sub getDescriptionColor As String
    Return mDescriptionColor
End Sub

''' Sets the background color variant for this item.
Public Sub setVariant(Value As String)
    mVariant = Value
End Sub

Public Sub getVariant As String
    Return mVariant
End Sub

''' Sets the figure type (none|svg|image|radial).
''' Changing this recreates the figure child component.
Public Sub setFigureType(Value As String)
    mFigureType = Value
    UpdateFigure
End Sub

Public Sub getFigureType As String
    Return mFigureType
End Sub

''' Sets the figure source (SVG asset filename, image path, or radial initial value).
Public Sub setFigureSource(Value As String)
    mFigureSource = Value
    UpdateFigure
End Sub

Public Sub getFigureSource As String
    Return mFigureSource
End Sub

''' Sets the figure display size in dip.
Public Sub setFigureSize(Value As Int)
    mFigureSize = Value
    UpdateFigure
End Sub

Public Sub getFigureSize As Int
    Return mFigureSize
End Sub

''' Sets the figure color variant (for SVG icon tint or radial progress).
Public Sub setFigureColor(Value As String)
    mFigureColor = Value
    UpdateFigure
End Sub

Public Sub getFigureColor As String
    Return mFigureColor
End Sub

''' Sets the radial progress value directly (shortcut for radial figure type).
Public Sub setFigureValue(v As Int)
    mFigureSource = v
    If mFigureType = "radial" And mFigureRadial.IsInitialized Then
        mFigureRadial.setValue(v)
    End If
End Sub

''' Sets the Tailwind padding utilities (e.g. "px-6 py-4").
Public Sub setPadding(Value As String)
    mPadding = Value
    ResolvePadding
End Sub

Public Sub getPadding As String
    Return mPadding
End Sub

''' Sets the column gap between text and figure (in dip).
Public Sub setGapX(Value As Int)
    mGapX = Value
End Sub

Public Sub getGapX As Int
    Return mGapX
End Sub

Public Sub setTag(Value As Object)
    mTag = Value
End Sub

Public Sub getTag As Object
    Return mTag
End Sub

''' Logs the individual label measured widths to the IDE log for debugging.
Public Sub LogLabelWidths(Tag As String)
    Log("=== " & Tag & " label widths ===")
    Log("  Title '" & mTitle & "' (12sp): " & mTitleLabel.MeasureTextWidth & "px")
    Log("  Value '" & mValue & "' (32sp bold): " & mValueLabel.MeasureTextWidth & "px")
    Log("  Desc  '" & mDescription & "' (12sp): " & mDescLabel.MeasureTextWidth & "px")
    Log("  ContentWidth (item total): " & mContentWidth & "px")
    Log("  ContentHeight (item total): " & mContentHeight & "px")
End Sub
#End Region

#Region Base Events
' Layout engine: bottom-up, content-driven ? mirrors CSS inline-grid behaviour.
' Sizing flow:
'   1. Measure each label's natural text width (whitespace-nowrap) and height (font metrics).
'   2. Compute target item width: content width + px-6 padding (+ figure column if present).
'   3. Compute target item height: sum of label heights + gaps + py-4 padding.
'   4. Resize mBase to those computed dimensions.
'   5. Position labels top-down starting from paddingY.
'   6. Place figure slot (right column, vertically centred).
' When Width > 2dip the parent is explicitly stretching us (e.g. stats-vertical); honour it.
Public Sub Base_Resize(Width As Double, Height As Double)
    If mIsResizing Then Return
    mIsResizing = True
    
    ' Resolve padding from Tailwind utilities; GapX and FigureSize are in dip
    If mPadX = 0 And mPadY = 0 Then ResolvePadding
    Dim paddingX  As Int = mPadX
    Dim paddingY  As Int = mPadY
    Dim gapBetween  As Int = 2dip    ' tight row gap between parts
    Dim figureSize  As Int = DipToCurrent(mFigureSize)
    Dim figureGapX  As Int = DipToCurrent(mGapX)
    
    ' -- Step 1: measure each label's natural text width ----------------------
    Dim textColW As Int = 40dip      ' minimum floor
    If mTitleLabel.mBase.Visible Then textColW = Max(textColW, Ceil(mTitleLabel.MeasureTextWidth))
    If mValueLabel.mBase.Visible  Then textColW = Max(textColW, Ceil(mValueLabel.MeasureTextWidth))
    If mDescLabel.mBase.Visible   Then textColW = Max(textColW, Ceil(mDescLabel.MeasureTextWidth))
    If mActionsSlot.mBase.Visible Then textColW = Max(textColW, 120dip)
    
    ' -- Step 2: measure each label's natural text height (font metrics) -------
    Dim titleH As Int = IIf(mTitleLabel.mBase.Visible,  Max(1dip, Ceil(mTitleLabel.MeasureTextHeight)), 0)
    Dim valueH As Int = IIf(mValueLabel.mBase.Visible,  Max(1dip, Ceil(mValueLabel.MeasureTextHeight)), 0)
    Dim descH  As Int = IIf(mDescLabel.mBase.Visible,   Max(1dip, Ceil(mDescLabel.MeasureTextHeight)),  0)
    Dim actH   As Int = IIf(mActionsSlot.mBase.Visible, 36dip, 0)
    
    ' -- Step 3: sum content height -------------------------------------------
    Dim contentH As Int = 0
    Dim numRows  As Int = 0
    If titleH > 0 Then : contentH = contentH + titleH : numRows = numRows + 1 : End If
    If valueH > 0 Then : contentH = contentH + valueH : numRows = numRows + 1 : End If
    If descH  > 0 Then : contentH = contentH + descH  : numRows = numRows + 1 : End If
    If actH   > 0 Then : contentH = contentH + actH   : numRows = numRows + 1 : End If
    contentH = contentH + Max(0, numRows - 1) * gapBetween
    
    ' -- Step 4: compute target item dimensions -------------------------------
    ' Content-driven height (CSS inline-grid: shrink-wrap).
    ' Exception: if the caller (B4XDaisyStat Phase-3 horizontal) passes an explicit
    ' Height > 2dip, honour it so all items in a row share the tallest item height.
    Dim contentTargetH As Int = contentH + (paddingY * 2)
    If mFigureSlot.mBase.Visible Then
        contentTargetH = Max(contentTargetH, figureSize + (paddingY * 2))
    End If
    Dim targetHeight As Int
    If Height > 2dip Then
        targetHeight = Max(contentTargetH, Height)  ' stretch but never squash below content
    Else
        targetHeight = contentTargetH
    End If
    
    ' Width: respect parent-given width (stats-vertical stretches all items to same width),
    '        otherwise shrink-wrap to content (inline-grid behaviour).
    Dim targetWidth As Int
    If Width > 2dip Then
        targetWidth = Width
    Else
        If mFigureSlot.mBase.Visible And mCenterItems = False Then
            targetWidth = paddingX + textColW + figureGapX + figureSize + paddingX
        Else
            targetWidth = paddingX + textColW + paddingX
        End If
    End If
    
    ' -- Step 5: store computed sizes and resize mBase ------------------------
    mContentWidth = targetWidth
    mContentHeight = targetHeight
    mBase.SetLayoutAnimated(0, mBase.Left, mBase.Top, targetWidth, targetHeight)
    mIsResizing = False
    Sleep(0)
    
    ' -- Step 6: position labels top-down from paddingY -----------------------
    ' Re-derive the text column width from the final targetWidth so stretched items
    ' fill correctly when the parent has expanded us beyond content size.
    Dim actualTextColW As Int = targetWidth - (paddingX * 2)
    If mFigureSlot.mBase.Visible And mCenterItems = False Then
        actualTextColW = targetWidth - (paddingX * 2) - figureGapX - figureSize
    End If
    actualTextColW = Max(40dip, actualTextColW)
    
    Dim currentTop  As Int = paddingY
    Dim contentLeft As Int = paddingX
    
    If mTitleLabel.mBase.Visible Then
        mTitleLabel.Base_Resize(actualTextColW, titleH)
        mTitleLabel.mBase.Left = contentLeft
        mTitleLabel.mBase.Top  = currentTop
        currentTop = currentTop + titleH + gapBetween
    End If
    
    If mValueLabel.mBase.Visible Then
        mValueLabel.Base_Resize(actualTextColW, valueH)
        mValueLabel.mBase.Left = contentLeft
        mValueLabel.mBase.Top  = currentTop
        currentTop = currentTop + valueH + gapBetween
    End If
    
    If mDescLabel.mBase.Visible Then
        mDescLabel.Base_Resize(actualTextColW, descH)
        mDescLabel.mBase.Left = contentLeft
        mDescLabel.mBase.Top  = currentTop
        currentTop = currentTop + descH + gapBetween
    End If
    
    If mActionsSlot.mBase.Visible Then
        mActionsSlot.mBase.SetLayoutAnimated(0, contentLeft, currentTop, actualTextColW, actH)
        mActionsSlot.Base_Resize(actualTextColW, actH)
        currentTop = currentTop + actH + gapBetween
    End If
    
    ' -- Step 7: figure ? right column, vertically centred --------------------
    If mFigureSlot.mBase.Visible Then
        If mCenterItems Then
            ' Centered layout: figure above text block
            mFigureSlot.mBase.SetLayoutAnimated(0, (targetWidth - figureSize) / 2, paddingY, figureSize, figureSize)
        Else
            ' CSS .stat-figure: col-start-2, place-self-center, justify-self-end
            mFigureSlot.mBase.SetLayoutAnimated(0, targetWidth - paddingX - figureSize, (targetHeight - figureSize) / 2, figureSize, figureSize)
        End If
        mFigureSlot.Base_Resize(figureSize, figureSize)
    End If
    
    DrawSeparator(targetWidth, targetHeight)
End Sub

Private Sub DrawSeparator(W As Int, H As Int)
    If mSepPanel.IsInitialized = False Then Return
    
    ' CSS: color-mix(in oklab, currentColor 10%, #0000) — 10% alpha of base-content
    Dim sepBase As Int = B4XDaisyVariants.GetTokenColor("--color-base-content", xui.Color_LightGray)
    Dim sepR As Int = Bit.And(Bit.ShiftRight(sepBase, 16), 0xFF)
    Dim sepG As Int = Bit.And(Bit.ShiftRight(sepBase, 8), 0xFF)
    Dim sepB As Int = Bit.And(sepBase, 0xFF)
    Dim borderColor As Int = xui.Color_ARGB(26, sepR, sepG, sepB) ' 10% alpha (26/255)
    
    If mShowSeparator = False Then
        mSepPanel.Visible = False
        Return
    End If
    
    mSepPanel.Visible = True
    mSepPanel.Color = borderColor
    
    If mOrientation = "horizontal" Then
        ' CSS border-inline-end: 1px dashed ? right edge, full height
        mSepPanel.SetLayoutAnimated(0, W - 1dip, 0, 1dip, H)
    Else
        ' CSS border-block-end: 1px dashed ? bottom edge, full width
        mSepPanel.SetLayoutAnimated(0, 0, H - 1dip, W, 1dip)
    End If
End Sub

Private Sub mBase_Click
    RaiseClick
End Sub

Private Sub RaiseClick
    Dim payload As Object = mTag
    If payload = Null Then payload = mBase
    If xui.SubExists(mCallBack, mEventName & "_Click", 1) Then
        CallSub2(mCallBack, mEventName & "_Click", payload)
    Else If xui.SubExists(mCallBack, mEventName & "_Click", 0) Then
        CallSub(mCallBack, mEventName & "_Click")
    End If
End Sub
#End Region

#Region Cleanup
Public Sub GetComputedHeight As Int
	If mBase.IsInitialized = False Then Return 0
	Return mBase.Height
End Sub

Public Sub RemoveViewFromParent
	If mBase.IsInitialized Then mBase.RemoveViewFromParent
End Sub
#End Region
