B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

#DesignerProperty: Key: SvgAsset, DisplayName: SVG Asset, FieldType: String, DefaultValue:, Description: SVG file name from assets or full local path
#DesignerProperty: Key: Width, DisplayName: Width, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size (eg 6, 24px, 2rem)
#DesignerProperty: Key: Height, DisplayName: Height, FieldType: String, DefaultValue: 6, Description: Tailwind size token or CSS size (eg 6, 24px, 2rem)
#DesignerProperty: Key: Color, DisplayName: Color, FieldType: Color, DefaultValue: 0xFF3B82F6, Description: Icon color used when Preserve Colors is False
#DesignerProperty: Key: PreserveColors, DisplayName: Preserve Original Colors, FieldType: Boolean, DefaultValue: False, Description: Keep original SVG colors instead of applying tint color
#DesignerProperty: Key: Padding, DisplayName: Padding, FieldType: Int, DefaultValue: 0, Description: Inner padding in dip around the icon
#DesignerProperty: Key: BorderWidth, DisplayName: Border Width, FieldType: Int, DefaultValue: 0, Description: Border width in dip
#DesignerProperty: Key: BorderColor, DisplayName: Border Color, FieldType: Color, DefaultValue: 0x00000000, Description: Border color (transparent by default)
#DesignerProperty: Key: BackgroundColor, DisplayName: Background Color, FieldType: Color, DefaultValue: 0x00000000, Description: Background fill color (transparent by default)
#DesignerProperty: Key: RoundedBox, DisplayName: Rounded Box, FieldType: Boolean, DefaultValue: False, Description: Applies rounded-box corner radius

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI

	Private ivNative As B4XView

	Private mWidth As Float = 24dip
	Private mHeight As Float = 24dip
	Private mWidthExplicit As Boolean = False
	Private mHeightExplicit As Boolean = False
	Private SvgAssetPath As String = ""
	Private SvgMarkup As String = ""
	Private IconColor As Int = 0xFF3B82F6
	Private PreserveColors As Boolean = False
	Private LastRenderer As String = ""
	Private mPadding As Float = 0dip
	Private mBorderWidth As Float = 0dip
	Private mBorderColor As Int = xui.Color_Transparent
	Private mBackgroundColor As Int = xui.Color_Transparent
	Private mRoundedBox As Boolean = False
	Private mTag As Object
	Private CustProps As Map
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
	SetDefaults
End Sub

'Public Sub CreateView(Width As Int, Height As Int) As B4XView
'	Dim p As Panel
'	p.Initialize("")
'	Dim b As B4XView = p
'	b.Color = xui.Color_Transparent
'	b.SetLayoutAnimated(0, 0, 0, Width, Height)
'	Dim dummy As Label
'	DesignerCreateView(b, dummy, CreateMap())
'	Return mBase
'End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	If mTag = Null Then mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim iv As ImageView
	iv.Initialize("")
	ivNative = iv
	ivNative.Color = xui.Color_Transparent
	mBase.AddView(ivNative, 0, 0, 1dip, 1dip)

	ConfigureNativeView
	ApplyDesignerProps(Props)
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Private Sub ConfigureNativeView
	#If B4A
	Try
		Dim jo As JavaObject = ivNative
		jo.RunMethod("setBackgroundColor", Array(0))
		jo.RunMethod("setScaleType", Array(CreateScaleTypeFitXy))
	Catch
		Log("B4XDaisySvgIcon.ConfigureNativeView: " & LastException.Message)
	End Try
	#End If
End Sub

Private Sub CreateScaleTypeFitXy As Object
	#If B4A
	Dim jo As JavaObject
	jo.InitializeStatic("android.widget.ImageView$ScaleType")
	Return jo.GetField("FIT_XY")
	#Else
	Return Null
	#End If
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	If CustProps.IsInitialized = False Then SetDefaults
	SetProperties(Props)
	Dim p As Map = CustProps
	mWidth = B4XDaisyVariants.TailwindSizeToDip("6", 24dip)
	mHeight = B4XDaisyVariants.TailwindSizeToDip("6", 24dip)
	mWidthExplicit = False
	mHeightExplicit = False
	SvgAssetPath = ""
	SvgMarkup = ""
	IconColor = 0xFF3B82F6
	PreserveColors = False
	LastRenderer = ""
	mPadding = 0dip
	mBorderWidth = 0dip
	mBorderColor = xui.Color_Transparent
	mBackgroundColor = xui.Color_Transparent
	mRoundedBox = False

	If p.IsInitialized = False Then
		RenderSvg
		Return
	End If

	mWidth = Max(1dip, GetPropSizeDip(p, "Width", ResolveWidthBase(mWidth)))
	mHeight = Max(1dip, GetPropSizeDip(p, "Height", ResolveHeightBase(mHeight)))
	IconColor = GetPropColor(p, "Color", IconColor)
	PreserveColors = GetPropBool(p, "PreserveColors", PreserveColors)
	mPadding = Max(0, GetPropDip(p, "Padding", mPadding))
	mBorderWidth = Max(0, GetPropDip(p, "BorderWidth", mBorderWidth))
	mBorderColor = GetPropColor(p, "BorderColor", mBorderColor)
	mBackgroundColor = GetPropColor(p, "BackgroundColor", mBackgroundColor)
	mRoundedBox = GetPropBool(p, "RoundedBox", mRoundedBox)
	If p.ContainsKey("Width") Then mWidthExplicit = True
	If p.ContainsKey("Height") Then mHeightExplicit = True
	SetSvgAsset(GetPropString(p, "SvgAsset", SvgAssetPath))
End Sub

Public Sub SetDefaults
	CustProps.Initialize
	CustProps.Put("SvgAsset", SvgAssetPath)
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Color", IconColor)
	CustProps.Put("PreserveColors", PreserveColors)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
	CustProps.Put("BackgroundColor", mBackgroundColor)
	CustProps.Put("RoundedBox", mRoundedBox)
End Sub

Public Sub SetProperties(Props As Map)
	If Props.IsInitialized = False Then Return
	Dim src As Map
	src.Initialize
	For Each k As String In Props.Keys
		src.Put(k, Props.Get(k))
	Next
	CustProps.Initialize
	For Each k As String In src.Keys
		CustProps.Put(k, src.Get(k))
	Next
End Sub

Public Sub GetProperties As Map
	CustProps.Initialize
	CustProps.Put("SvgAsset", SvgAssetPath)
	CustProps.Put("Width", mWidth)
	CustProps.Put("Height", mHeight)
	CustProps.Put("Color", IconColor)
	CustProps.Put("PreserveColors", PreserveColors)
	CustProps.Put("Padding", mPadding)
	CustProps.Put("BorderWidth", mBorderWidth)
	CustProps.Put("BorderColor", mBorderColor)
	CustProps.Put("BackgroundColor", mBackgroundColor)
	CustProps.Put("RoundedBox", mRoundedBox)
	CustProps.Put("Tag", mTag)
	Return CustProps
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	If ivNative.IsInitialized = False Then Return

	Dim hostW As Int = Max(1dip, Width)
	Dim hostH As Int = Max(1dip, Height)
	Dim box As Map = BuildBoxModel
	Dim hostRect As B4XRect
	hostRect.Initialize(0, 0, hostW, hostH)
	Dim borderRect As B4XRect = B4XDaisyBoxModel.ResolveBorderRect(hostRect, box)
	Dim contentAbs As B4XRect = B4XDaisyBoxModel.ResolveContentRect(borderRect, box)
	Dim contentRect As B4XRect = B4XDaisyBoxModel.ToLocalRect(contentAbs, hostRect)
	ApplySurfaceStyle(box)
	Dim contentW As Int = Max(1dip, Round(contentRect.Width))
	Dim contentH As Int = Max(1dip, Round(contentRect.Height))
	Dim drawW As Int = Min(contentW, Max(1dip, Round(mWidth)))
	Dim drawH As Int = Min(contentH, Max(1dip, Round(mHeight)))
	Dim x As Int = Round(contentRect.Left + (contentW - drawW) / 2)
	Dim y As Int = Round(contentRect.Top + (contentH - drawH) / 2)

	ivNative.SetLayoutAnimated(0, x, y, drawW, drawH)
	RenderSvg
End Sub

Public Sub ResizeToParent(ParentView As B4XView)
	If ParentView.IsInitialized = False Then Return
	Base_Resize(ParentView.Width, ParentView.Height)
End Sub

Public Sub AddToParent(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int) As B4XView
	Dim empty As B4XView
	If Parent.IsInitialized = False Then Return empty
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, w, h)
	Dim snap As Map = GetProperties
	Dim props As Map
	props.Initialize
	For Each k As String In snap.Keys
		props.Put(k, snap.Get(k))
	Next
	If mWidthExplicit = False Then props.Put("Width", Max(1, Round(w / 1dip)) & "px")
	If mHeightExplicit = False Then props.Put("Height", Max(1, Round(h / 1dip)) & "px")
	Dim dummy As Label
	DesignerCreateView(b, dummy, props)
	Parent.AddView(mBase, Left, Top, w, h)
	Return mBase
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mBase.IsInitialized = False Then Return empty
	Return mBase
End Sub

Public Sub setSvgAsset(Path As String)
	If Path = Null Then Path = ""
	SvgAssetPath = Path.Trim
	SvgMarkup = ""
	If mBase.IsInitialized = False Then Return
	RenderSvg
End Sub

Public Sub getSvgAsset As String
	Return SvgAssetPath
End Sub

Public Sub setSvgContent(Content As String)
	If Content = Null Then Content = ""
	SvgMarkup = Content.Trim
	If mBase.IsInitialized = False Then Return
	RenderSvg
End Sub

Public Sub getSvgContent As String
	Return SvgMarkup
End Sub

Public Sub setColor(Value As Int)
	IconColor = Value
	If mBase.IsInitialized = False Then Return
	RenderSvg
End Sub

Public Sub getColor As Int
	Return IconColor
End Sub

Public Sub setColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", IconColor)
	setColor(c)
End Sub

Public Sub setPreserveOriginalColors(Value As Boolean)
	PreserveColors = Value
	If mBase.IsInitialized = False Then Return
	RenderSvg
End Sub

Public Sub getPreserveOriginalColors As Boolean
	Return PreserveColors
End Sub

Public Sub setPreserveColors(Value As Boolean)
	PreserveColors = Value
	If mBase.IsInitialized = False Then Return
	RenderSvg
End Sub

Public Sub getPreserveColors As Boolean
	Return getPreserveOriginalColors
End Sub

Public Sub getLastRenderer As String
	Return LastRenderer
End Sub

Public Sub setTag(Value As Object)
	mTag = Value
End Sub

Public Sub getTag As Object
	Return mTag
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveWidthBase(mWidth)))
	mWidthExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, ResolveHeightBase(mHeight)))
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setPadding(Value As Float)
	mPadding = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getPadding As Float
	Return mPadding
End Sub

Public Sub setBorderWidth(Value As Float)
	mBorderWidth = Max(0, Value)
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getBorderWidth As Float
	Return mBorderWidth
End Sub

Public Sub setBorderColor(Value As Int)
	mBorderColor = Value
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getBorderColor As Int
	Return mBorderColor
End Sub

Public Sub setBorderColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "border", mBorderColor)
	setBorderColor(c)
End Sub

Public Sub setBackgroundColor(Value As Int)
	mBackgroundColor = Value
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getBackgroundColor As Int
	Return mBackgroundColor
End Sub

Public Sub setBackgroundColorVariant(VariantName As String)
	Dim c As Int = B4XDaisyVariants.ResolveVariantColor(B4XDaisyVariants.DefaultPalette, VariantName, "back", mBackgroundColor)
	setBackgroundColor(c)
End Sub

Public Sub setRoundedBox(Value As Boolean)
	mRoundedBox = Value
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getRoundedBox As Boolean
	Return mRoundedBox
End Sub

Public Sub setSize(Value As Object)
	Dim s As Float = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, Min(mWidth, mHeight)))
	mWidth = s
	mHeight = s
	mWidthExplicit = True
	mHeightExplicit = True
	If mBase.IsInitialized = False Then Return
	Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Refresh
	RenderSvg
End Sub

Private Sub RenderSvg
	If ivNative.IsInitialized = False Then Return
	Dim svg As String = GetResolvedSvgContent
	If svg.Length = 0 Then svg = DefaultFallbackSvg

	If TryRenderNative(svg) Then
		ivNative.Visible = True
		LastRenderer = "native"
		Return
	End If

	ivNative.Visible = False
	LastRenderer = "none"
End Sub

Private Sub TryRenderNative(Svg As String) As Boolean
	#If B4A
	Try
		Dim w As Int = Max(1dip, ivNative.Width)
		Dim h As Int = Max(1dip, ivNative.Height)
		Dim jo As JavaObject = Me
		Dim o As Object = jo.RunMethod("nativeRenderSvgToBitmap", Array(Svg, w, h, IconColor, PreserveColors))
		If o = Null Then Return False
		Dim bmp As B4XBitmap = o
		If bmp.IsInitialized = False Then Return False
		ivNative.SetBitmap(bmp)
		Return True
	Catch
		Log("B4XDaisySvgIcon.TryRenderNative: " & LastException.Message)
	End Try
	#End If
	Return False
End Sub

Private Sub GetResolvedSvgContent As String
	Dim raw As String = SvgMarkup.Trim
	If raw.Length = 0 And SvgAssetPath.Length > 0 Then raw = ReadTextFromPath(SvgAssetPath).Trim
	If raw.Length = 0 Then Return ""
	If raw.StartsWith("<?xml") Then
		Dim endPi As Int = raw.IndexOf("?>")
		If endPi >= 0 Then raw = raw.SubString(endPi + 2).Trim
	End If
	Return raw
End Sub

Private Sub DefaultFallbackSvg As String
	Return "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'>" & _
		"<circle cx='12' cy='12' r='10' fill='none' stroke='currentColor' stroke-width='2'/>" & _
		"<path d='M7 12h10M12 7v10' stroke='currentColor' stroke-width='2' stroke-linecap='round'/></svg>"
End Sub

Private Sub ReadTextFromPath(Path As String) As String
	If Path = Null Then Return ""
	Dim p As String = Path.Trim
	If p.Length = 0 Then Return ""

	Try
		Dim slash1 As Int = p.LastIndexOf("/")
		Dim slash2 As Int = p.LastIndexOf("\")
		Dim slash As Int = Max(slash1, slash2)
		If slash >= 0 Then
			Dim dir As String = p.SubString2(0, slash)
			Dim fn As String = p.SubString(slash + 1)
			If dir.Length > 0 And fn.Length > 0 And File.Exists(dir, fn) Then
				Return File.ReadString(dir, fn)
			End If
		End If
		If File.Exists(File.DirAssets, p) Then Return File.ReadString(File.DirAssets, p)
	Catch
		Log("B4XDaisySvgIcon.ReadTextFromPath: " & LastException.Message)
	End Try
	Return ""
End Sub

Private Sub GetPropString(Props As Map, Key As String, DefaultValue As String) As String
	Return B4XDaisyVariants.GetPropString(Props, Key, DefaultValue)
End Sub

Private Sub GetPropBool(Props As Map, Key As String, DefaultValue As Boolean) As Boolean
	Return B4XDaisyVariants.GetPropBool(Props, Key, DefaultValue)
End Sub

Private Sub GetPropColor(Props As Map, Key As String, DefaultValue As Int) As Int
	If Props.IsInitialized = False Then Return DefaultValue
	If Props.ContainsKey(Key) = False Then Return DefaultValue
	Dim v As Object = Props.Get(Key)
	If v = Null Then Return DefaultValue
	Return v
End Sub

Private Sub ResolveWidthBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Width > 0 Then Return parent.Width
		If mBase.Width > 0 Then Return mBase.Width
	End If
	Return DefaultValue
End Sub

Private Sub ResolveHeightBase(DefaultValue As Float) As Float
	If mBase.IsInitialized Then
		Dim parent As B4XView = mBase.Parent
		If parent.IsInitialized And parent.Height > 0 Then Return parent.Height
		If mBase.Height > 0 Then Return mBase.Height
	End If
	Return DefaultValue
End Sub

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

Private Sub GetPropDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.IsInitialized = False Then Return DefaultDipValue
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	If o = Null Then Return DefaultDipValue
	Return o
End Sub

Private Sub BuildBoxModel As Map
	Dim box As Map = B4XDaisyBoxModel.CreateDefaultModel
	box.Put("padding_left", mPadding)
	box.Put("padding_top", mPadding)
	box.Put("padding_right", mPadding)
	box.Put("padding_bottom", mPadding)
	box.Put("border_width", mBorderWidth)
	box.Put("radius", IIf(mRoundedBox, B4XDaisyVariants.GetRadiusBoxDip(8dip), 0))
	Return box
End Sub

Private Sub ApplySurfaceStyle(Box As Map)
	Dim bw As Int = Max(0, Box.GetDefault("border_width", 0))
	Dim radius As Float = Max(0, Box.GetDefault("radius", 0))
	mBase.SetColorAndBorder(mBackgroundColor, bw, mBorderColor, radius)
End Sub

#If Java
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.DashPathEffect;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.util.Xml;
import org.xmlpull.v1.XmlPullParser;
import java.io.StringReader;
import java.lang.reflect.Method;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

private static final Pattern NUMBER_PATTERN = Pattern.compile("[-+]?((\\d+\\.?\\d*)|(\\.\\d+))(?:[eE][-+]?\\d+)?");
private static final Pattern TRANSFORM_PATTERN = Pattern.compile("([a-zA-Z]+)\\s*\\(([^\\)]*)\\)");

private static class RenderState {
	final Map<String, String> style = new HashMap<String, String>();
	final Matrix matrix = new Matrix();
	boolean hidden = false;
	float opacityMul = 1f;

	RenderState copy() {
		RenderState r = new RenderState();
		r.style.putAll(style);
		r.matrix.set(matrix);
		r.hidden = hidden;
		r.opacityMul = opacityMul;
		return r;
	}
}

private static class ShapeDef {
	final Path path;
	final Map<String, String> style;
	final Matrix matrix;
	final float opacityMul;

	ShapeDef(Path sourcePath, Map<String, String> sourceStyle, Matrix sourceMatrix, float sourceOpacityMul) {
		this.path = new Path(sourcePath);
		this.style = new HashMap<String, String>(sourceStyle);
		this.matrix = new Matrix(sourceMatrix);
		this.opacityMul = sourceOpacityMul;
	}
}

public Bitmap nativeRenderSvgToBitmap(String svg, int width, int height, int tintColor, boolean preserveColors) {
	try {
		if (svg == null) return null;
		width = Math.max(1, width);
		height = Math.max(1, height);
		String raw = stripXmlProlog(svg);
		float[] vb = parseViewBox(raw);
		float minX = 0f, minY = 0f, vbW = 24f, vbH = 24f;
		if (vb != null && vb.length == 4 && vb[2] > 0 && vb[3] > 0) {
			minX = vb[0];
			minY = vb[1];
			vbW = vb[2];
			vbH = vb[3];
		} else {
			float[] wh = parseRootWidthHeight(raw);
			if (wh != null && wh[0] > 0 && wh[1] > 0) {
				vbW = wh[0];
				vbH = wh[1];
			}
		}

		Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		Canvas canvas = new Canvas(bmp);
		float sx = (float) width / vbW;
		float sy = (float) height / vbH;
		float scale = Math.min(sx, sy);
		float tx = (width - vbW * scale) / 2f;
		float ty = (height - vbH * scale) / 2f;
		canvas.save();
		canvas.translate(tx, ty);
		canvas.scale(scale, scale);
		canvas.translate(-minX, -minY);

		XmlPullParser parser = Xml.newPullParser();
		parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false);
		parser.setInput(new StringReader(raw));

		int eventType = parser.getEventType();
		boolean drewAny = false;
		int defsDepth = 0;
		Deque<RenderState> states = new ArrayDeque<RenderState>();
		Map<String, ShapeDef> defs = new HashMap<String, ShapeDef>();
		states.push(new RenderState());

		while (eventType != XmlPullParser.END_DOCUMENT) {
			if (eventType == XmlPullParser.START_TAG) {
				String tagRaw = parser.getName();
				String tag = tagRaw == null ? "" : tagRaw.toLowerCase(Locale.US);
				RenderState parent = states.peek();
				RenderState state = parent == null ? new RenderState() : parent.copy();
				applyStateFromTag(state, parser);
				states.push(state);

				if ("defs".equals(tag)) defsDepth++;

				if ("use".equals(tag)) {
					if (!state.hidden && defsDepth == 0 && drawUseElement(canvas, parser, defs, state, tintColor, preserveColors)) {
						drewAny = true;
					}
				} else {
					Path path = buildPathFromElement(parser, tag);
					if (path != null) {
						String id = normalizeId(getAttr(parser, "id"));
						if (id != null && id.length() > 0) defs.put(id, new ShapeDef(path, state.style, state.matrix, state.opacityMul));
						if (!state.hidden && defsDepth == 0) {
							Path drawPath = new Path(path);
							if (!state.matrix.isIdentity()) drawPath.transform(state.matrix);
							if (drawElement(canvas, drawPath, tintColor, preserveColors, state.style, state.opacityMul)) drewAny = true;
						}
					}
				}
			} else if (eventType == XmlPullParser.END_TAG) {
				String tagRaw = parser.getName();
				String tag = tagRaw == null ? "" : tagRaw.toLowerCase(Locale.US);
				if ("defs".equals(tag) && defsDepth > 0) defsDepth--;
				if (states.size() > 1) states.pop();
			}
			eventType = parser.next();
		}
		canvas.restore();
		if (!drewAny) return null;
		return bmp;
	} catch (Throwable t) {
		return null;
	}
}

private static String stripXmlProlog(String s) {
	if (s == null) return "";
	String trimmed = s.trim();
	if (trimmed.startsWith("<?xml")) {
		int idx = trimmed.indexOf("?>");
		if (idx >= 0) return trimmed.substring(idx + 2).trim();
	}
	return trimmed;
}

private static float[] parseViewBox(String svg) {
	Matcher m = Pattern.compile("viewBox\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]", Pattern.CASE_INSENSITIVE).matcher(svg);
	if (!m.find()) return null;
	return parseFloatList(m.group(1), 4);
}

private static float[] parseRootWidthHeight(String svg) {
	Matcher m = Pattern.compile("<svg[^>]*>", Pattern.CASE_INSENSITIVE).matcher(svg);
	if (!m.find()) return null;
	String root = m.group();
	Matcher mw = Pattern.compile("width\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]", Pattern.CASE_INSENSITIVE).matcher(root);
	Matcher mh = Pattern.compile("height\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]", Pattern.CASE_INSENSITIVE).matcher(root);
	if (!mw.find() || !mh.find()) return null;
	float w = parseSvgNumber(mw.group(1), -1f);
	float h = parseSvgNumber(mh.group(1), -1f);
	if (w <= 0 || h <= 0) return null;
	return new float[]{w, h};
}

private static float[] parseFloatList(String text, int expectedAtLeast) {
	if (text == null) return null;
	String[] parts = text.trim().replace(",", " ").split("\\s+");
	if (parts.length < expectedAtLeast) return null;
	float[] out = new float[parts.length];
	for (int i = 0; i < parts.length; i++) {
		out[i] = parseSvgNumber(parts[i], 0f);
	}
	return out;
}

private static float parseSvgNumber(String text, float fallback) {
	if (text == null) return fallback;
	String s = text.trim().toLowerCase(Locale.US);
	if (s.isEmpty()) return fallback;
	s = s.replace("px", "").replace("%", "").trim();
	try {
		return Float.parseFloat(s);
	} catch (Throwable t) {
		return fallback;
	}
}

private static void applyStateFromTag(RenderState state, XmlPullParser parser) {
	Map<String, String> inlineStyle = parseStyle(getAttr(parser, "style"));

	int n = parser.getAttributeCount();
	for (int i = 0; i < n; i++) {
		String keyRaw = parser.getAttributeName(i);
		String valueRaw = parser.getAttributeValue(i);
		if (keyRaw == null || valueRaw == null) continue;
		String key = keyRaw.trim().toLowerCase(Locale.US);
		String value = valueRaw.trim();
		if (key.length() == 0 || value.length() == 0) continue;
		if ("transform".equals(key)) continue;
		if ("id".equals(key) || "href".equals(key) || "xlink:href".equals(key)) continue;
		state.style.put(key, value);
	}

	for (Map.Entry<String, String> e : inlineStyle.entrySet()) {
		state.style.put(e.getKey(), e.getValue());
	}

	String display = firstNonEmpty(inlineStyle.get("display"), getAttr(parser, "display"));
	String visibility = firstNonEmpty(inlineStyle.get("visibility"), getAttr(parser, "visibility"));
	if (equalsIgnoreCase(display, "none") || equalsIgnoreCase(visibility, "hidden") || equalsIgnoreCase(visibility, "collapse")) {
		state.hidden = true;
	}

	String opacityText = firstNonEmpty(inlineStyle.get("opacity"), getAttr(parser, "opacity"));
	if (opacityText != null) {
		state.opacityMul = state.opacityMul * clamp01(parseSvgNumber(opacityText, 1f));
	}

	String transformText = firstNonEmpty(inlineStyle.get("transform"), getAttr(parser, "transform"));
	Matrix local = parseTransform(transformText);
	if (local != null) state.matrix.postConcat(local);
}

private static Matrix parseTransform(String text) {
	if (text == null) return null;
	String s = text.trim();
	if (s.length() == 0) return null;
	Matrix out = new Matrix();
	Matcher m = TRANSFORM_PATTERN.matcher(s);
	boolean found = false;
	while (m.find()) {
		String fn = m.group(1).toLowerCase(Locale.US);
		float[] args = parseNumberList(m.group(2));
		Matrix step = new Matrix();
		if ("translate".equals(fn)) {
			float tx = args.length > 0 ? args[0] : 0f;
			float ty = args.length > 1 ? args[1] : 0f;
			step.postTranslate(tx, ty);
			found = true;
		} else if ("scale".equals(fn)) {
			float sx = args.length > 0 ? args[0] : 1f;
			float sy = args.length > 1 ? args[1] : sx;
			step.postScale(sx, sy);
			found = true;
		} else if ("rotate".equals(fn)) {
			float deg = args.length > 0 ? args[0] : 0f;
			if (args.length >= 3) step.postRotate(deg, args[1], args[2]);
			else step.postRotate(deg);
			found = true;
		} else if ("matrix".equals(fn) && args.length >= 6) {
			float[] vals = new float[]{args[0], args[2], args[4], args[1], args[3], args[5], 0f, 0f, 1f};
			step.setValues(vals);
			found = true;
		} else if ("skewx".equals(fn) && args.length >= 1) {
			float t = (float) Math.tan(Math.toRadians(args[0]));
			float[] vals = new float[]{1f, t, 0f, 0f, 1f, 0f, 0f, 0f, 1f};
			step.setValues(vals);
			found = true;
		} else if ("skewy".equals(fn) && args.length >= 1) {
			float t = (float) Math.tan(Math.toRadians(args[0]));
			float[] vals = new float[]{1f, 0f, 0f, t, 1f, 0f, 0f, 0f, 1f};
			step.setValues(vals);
			found = true;
		}
		out.postConcat(step);
	}
	if (!found || out.isIdentity()) return null;
	return out;
}

private static float[] parseNumberList(String text) {
	if (text == null) return new float[0];
	List<Float> values = new ArrayList<Float>();
	Matcher m = NUMBER_PATTERN.matcher(text);
	while (m.find()) {
		try {
			values.add(Float.parseFloat(m.group()));
		} catch (Throwable ignored) {}
	}
	float[] out = new float[values.size()];
	for (int i = 0; i < values.size(); i++) out[i] = values.get(i);
	return out;
}

private static String firstNonEmpty(String a, String b) {
	if (a != null) {
		String aa = a.trim();
		if (aa.length() > 0) return aa;
	}
	if (b != null) {
		String bb = b.trim();
		if (bb.length() > 0) return bb;
	}
	return null;
}

private static boolean equalsIgnoreCase(String a, String b) {
	if (a == null || b == null) return false;
	return a.trim().equalsIgnoreCase(b.trim());
}

private static String normalizeId(String id) {
	if (id == null) return null;
	String s = id.trim();
	if (s.length() == 0) return null;
	if (s.startsWith("#")) s = s.substring(1);
	return s;
}

private static Path buildPathFromElement(XmlPullParser parser, String tagName) {
	if (tagName == null) return null;
	String tag = tagName.toLowerCase(Locale.US);
	switch (tag) {
		case "path":
			return buildPathTag(parser);
		case "rect":
			return buildRectTag(parser);
		case "circle":
			return buildCircleTag(parser);
		case "ellipse":
			return buildEllipseTag(parser);
		case "line":
			return buildLineTag(parser);
		case "polyline":
			return buildPolyTag(parser, false);
		case "polygon":
			return buildPolyTag(parser, true);
		default:
			return null;
	}
}

private static boolean drawUseElement(Canvas canvas, XmlPullParser parser, Map<String, ShapeDef> defs, RenderState state, int tintColor, boolean preserveColors) {
	String href = firstNonEmpty(getAttr(parser, "href"), getAttr(parser, "xlink:href"));
	String id = normalizeId(href);
	if (id == null || id.length() == 0) return false;
	ShapeDef def = defs.get(id);
	if (def == null) return false;

	Path path = new Path(def.path);
	Matrix m = new Matrix(def.matrix);
	float x = parseSvgNumber(getAttr(parser, "x"), 0f);
	float y = parseSvgNumber(getAttr(parser, "y"), 0f);
	if (x != 0f || y != 0f) {
		Matrix offset = new Matrix();
		offset.postTranslate(x, y);
		m.postConcat(offset);
	}
	if (!state.matrix.isIdentity()) m.postConcat(state.matrix);
	if (!m.isIdentity()) path.transform(m);

	Map<String, String> mergedStyle = new HashMap<String, String>(def.style);
	mergedStyle.putAll(state.style);
	float opacity = def.opacityMul * state.opacityMul;
	return drawElement(canvas, path, tintColor, preserveColors, mergedStyle, opacity);
}

private static Path buildPathTag(XmlPullParser parser) {
	String d = getAttr(parser, "d");
	if (d == null || d.trim().isEmpty()) return null;
	return createPathFromPathDataCompat(d.trim());
}

private static Path buildRectTag(XmlPullParser parser) {
	float x = parseSvgNumber(getAttr(parser, "x"), 0f);
	float y = parseSvgNumber(getAttr(parser, "y"), 0f);
	float w = parseSvgNumber(getAttr(parser, "width"), 0f);
	float h = parseSvgNumber(getAttr(parser, "height"), 0f);
	if (w <= 0f || h <= 0f) return null;
	float rx = parseSvgNumber(getAttr(parser, "rx"), 0f);
	float ry = parseSvgNumber(getAttr(parser, "ry"), 0f);
	Path p = new Path();
	RectF r = new RectF(x, y, x + w, y + h);
	if (rx > 0f || ry > 0f) {
		if (rx <= 0f) rx = ry;
		if (ry <= 0f) ry = rx;
		p.addRoundRect(r, rx, ry, Path.Direction.CW);
	} else {
		p.addRect(r, Path.Direction.CW);
	}
	return p;
}

private static Path buildCircleTag(XmlPullParser parser) {
	float cx = parseSvgNumber(getAttr(parser, "cx"), 0f);
	float cy = parseSvgNumber(getAttr(parser, "cy"), 0f);
	float r = parseSvgNumber(getAttr(parser, "r"), 0f);
	if (r <= 0f) return null;
	Path p = new Path();
	p.addCircle(cx, cy, r, Path.Direction.CW);
	return p;
}

private static Path buildEllipseTag(XmlPullParser parser) {
	float cx = parseSvgNumber(getAttr(parser, "cx"), 0f);
	float cy = parseSvgNumber(getAttr(parser, "cy"), 0f);
	float rx = parseSvgNumber(getAttr(parser, "rx"), 0f);
	float ry = parseSvgNumber(getAttr(parser, "ry"), 0f);
	if (rx <= 0f || ry <= 0f) return null;
	Path p = new Path();
	p.addOval(new RectF(cx - rx, cy - ry, cx + rx, cy + ry), Path.Direction.CW);
	return p;
}

private static Path buildLineTag(XmlPullParser parser) {
	float x1 = parseSvgNumber(getAttr(parser, "x1"), 0f);
	float y1 = parseSvgNumber(getAttr(parser, "y1"), 0f);
	float x2 = parseSvgNumber(getAttr(parser, "x2"), 0f);
	float y2 = parseSvgNumber(getAttr(parser, "y2"), 0f);
	Path p = new Path();
	p.moveTo(x1, y1);
	p.lineTo(x2, y2);
	return p;
}

private static Path buildPolyTag(XmlPullParser parser, boolean closePath) {
	String pts = getAttr(parser, "points");
	if (pts == null || pts.trim().isEmpty()) return null;
	String[] parts = pts.trim().replace(",", " ").split("\\s+");
	if (parts.length < 4) return null;
	Path p = new Path();
	float x0 = parseSvgNumber(parts[0], 0f);
	float y0 = parseSvgNumber(parts[1], 0f);
	p.moveTo(x0, y0);
	for (int i = 2; i + 1 < parts.length; i += 2) {
		float x = parseSvgNumber(parts[i], x0);
		float y = parseSvgNumber(parts[i + 1], y0);
		p.lineTo(x, y);
	}
	if (closePath) p.close();
	return p;
}

private static boolean drawElement(Canvas canvas, Path path, int tintColor, boolean preserveColors, Map<String, String> style, float opacityMul) {
	if (style == null) style = new HashMap<String, String>();
	String fillValue = style.get("fill");
	String strokeValue = style.get("stroke");
	String strokeWidthValue = style.get("stroke-width");
	String fillOpacityValue = style.get("fill-opacity");
	String strokeOpacityValue = style.get("stroke-opacity");
	String lineCap = style.get("stroke-linecap");
	String lineJoin = style.get("stroke-linejoin");
	String fillRule = style.get("fill-rule");
	String dashArrayText = style.get("stroke-dasharray");
	String dashOffsetText = style.get("stroke-dashoffset");

	boolean fillNone = isNone(fillValue);
	boolean strokeNone = isNone(strokeValue);

	float fillOpacity = clamp01(parseSvgNumber(fillOpacityValue, 1f));
	float strokeOpacity = clamp01(parseSvgNumber(strokeOpacityValue, 1f));
	float strokeWidth = Math.max(0f, parseSvgNumber(strokeWidthValue, 1f));

	int currentColor = tintColor;
	if (preserveColors) {
		String colorValue = style.get("color");
		if (colorValue != null && colorValue.trim().length() > 0) {
			currentColor = parseColor(colorValue, tintColor, tintColor);
		}
	}

	int fillColor = preserveColors ? parseColor(fillValue, Color.BLACK, currentColor) : tintColor;
	int strokeColor = preserveColors ? parseColor(strokeValue, Color.TRANSPARENT, currentColor) : tintColor;
	boolean drew = false;

	if (!fillNone) {
		Path drawPath = path;
		if ("evenodd".equalsIgnoreCase(fillRule)) {
			drawPath = new Path(path);
			drawPath.setFillType(Path.FillType.EVEN_ODD);
		}
		Paint fillPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
		fillPaint.setStyle(Paint.Style.FILL);
		fillPaint.setColor(applyAlpha(fillColor, opacityMul * fillOpacity));
		canvas.drawPath(drawPath, fillPaint);
		drew = true;
	}

	if (!strokeNone && strokeWidth > 0f) {
		Paint strokePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
		strokePaint.setStyle(Paint.Style.STROKE);
		strokePaint.setStrokeWidth(strokeWidth);
		strokePaint.setColor(applyAlpha(strokeColor, opacityMul * strokeOpacity));
		strokePaint.setStrokeCap(parseLineCap(lineCap));
		strokePaint.setStrokeJoin(parseLineJoin(lineJoin));
		float miter = parseSvgNumber(style.get("stroke-miterlimit"), 4f);
		if (miter > 0f) strokePaint.setStrokeMiter(miter);

		float[] dashValues = parseNumberList(dashArrayText);
		if (!isNone(dashArrayText) && dashValues.length > 0) {
			if (dashValues.length == 1) {
				float d = Math.max(1f, dashValues[0]);
				dashValues = new float[]{d, d};
			} else if ((dashValues.length % 2) == 1) {
				float[] expanded = new float[dashValues.length * 2];
				for (int i = 0; i < expanded.length; i++) expanded[i] = dashValues[i % dashValues.length];
				dashValues = expanded;
			}
			float dashOffset = parseSvgNumber(dashOffsetText, 0f);
			strokePaint.setPathEffect(new DashPathEffect(dashValues, dashOffset));
		}
		canvas.drawPath(path, strokePaint);
		drew = true;
	}
	return drew;
}

private static Paint.Cap parseLineCap(String value) {
	if (value == null) return Paint.Cap.BUTT;
	String v = value.trim().toLowerCase(Locale.US);
	if ("round".equals(v)) return Paint.Cap.ROUND;
	if ("square".equals(v)) return Paint.Cap.SQUARE;
	return Paint.Cap.BUTT;
}

private static Paint.Join parseLineJoin(String value) {
	if (value == null) return Paint.Join.MITER;
	String v = value.trim().toLowerCase(Locale.US);
	if ("round".equals(v)) return Paint.Join.ROUND;
	if ("bevel".equals(v)) return Paint.Join.BEVEL;
	return Paint.Join.MITER;
}

private static int parseColor(String value, int fallback, int currentColor) {
	if (value == null || value.trim().isEmpty()) return fallback;
	String s = value.trim().toLowerCase(Locale.US);
	if ("currentcolor".equals(s)) return currentColor;
	if ("none".equals(s) || "transparent".equals(s)) return Color.TRANSPARENT;
	if (s.startsWith("url(")) return fallback;
	try {
		if (s.startsWith("rgba(") && s.endsWith(")")) {
			String body = s.substring(5, s.length() - 1);
			String[] p = body.split(",");
			if (p.length == 4) {
				int r = Math.round(parseSvgNumber(p[0], 0f));
				int g = Math.round(parseSvgNumber(p[1], 0f));
				int b = Math.round(parseSvgNumber(p[2], 0f));
				float a = clamp01(parseSvgNumber(p[3], 1f));
				return Color.argb(Math.round(a * 255f), clamp255(r), clamp255(g), clamp255(b));
			}
		}
		if (s.startsWith("rgb(") && s.endsWith(")")) {
			String body = s.substring(4, s.length() - 1);
			String[] p = body.split(",");
			if (p.length == 3) {
				int r = Math.round(parseSvgNumber(p[0], 0f));
				int g = Math.round(parseSvgNumber(p[1], 0f));
				int b = Math.round(parseSvgNumber(p[2], 0f));
				return Color.rgb(clamp255(r), clamp255(g), clamp255(b));
			}
		}
		if (s.startsWith("#") && s.length() == 4) {
			char r = s.charAt(1), g = s.charAt(2), b = s.charAt(3);
			s = "#" + r + r + g + g + b + b;
		}
		return Color.parseColor(s);
	} catch (Throwable t) {
		return fallback;
	}
}

private static int applyAlpha(int color, float alphaMul) {
	float mul = clamp01(alphaMul);
	int a = Math.round(Color.alpha(color) * mul);
	return Color.argb(clamp255(a), Color.red(color), Color.green(color), Color.blue(color));
}

private static int clamp255(int v) {
	return Math.max(0, Math.min(255, v));
}

private static float clamp01(float v) {
	return Math.max(0f, Math.min(1f, v));
}

private static boolean isNone(String value) {
	if (value == null) return false;
	String v = value.trim().toLowerCase(Locale.US);
	return "none".equals(v) || "transparent".equals(v);
}

private static String coalesce(String a, String b) {
	return (a != null && !a.trim().isEmpty()) ? a : b;
}

private static Map<String, String> parseStyle(String styleText) {
	Map<String, String> out = new HashMap<String, String>();
	if (styleText == null) return out;
	String[] rules = styleText.split(";");
	for (String rule : rules) {
		if (rule == null) continue;
		String s = rule.trim();
		if (s.isEmpty()) continue;
		int p = s.indexOf(':');
		if (p <= 0 || p >= s.length() - 1) continue;
		String k = s.substring(0, p).trim().toLowerCase(Locale.US);
		String v = s.substring(p + 1).trim();
		if (!k.isEmpty() && !v.isEmpty()) out.put(k, v);
	}
	return out;
}

private static String getAttr(XmlPullParser parser, String name) {
	if (parser == null || name == null) return null;
	String v = parser.getAttributeValue(null, name);
	if (v != null) return v;
	int n = parser.getAttributeCount();
	for (int i = 0; i < n; i++) {
		String an = parser.getAttributeName(i);
		if (an != null && an.equalsIgnoreCase(name)) {
			return parser.getAttributeValue(i);
		}
	}
	return null;
}

private static Path createPathFromPathDataCompat(String data) {
	if (data == null || data.trim().isEmpty()) return null;
	try {
		Class<?> c = Class.forName("android.util.PathParser");
		Method m = c.getDeclaredMethod("createPathFromPathData", String.class);
		Object p = m.invoke(null, data);
		if (p instanceof Path) return (Path) p;
	} catch (Throwable ignored) {}
	try {
		Class<?> c = Class.forName("android.graphics.PathParser");
		Method m = c.getDeclaredMethod("createPathFromPathData", String.class);
		Object p = m.invoke(null, data);
		if (p instanceof Path) return (Path) p;
	} catch (Throwable ignored) {}
	try {
		Class<?> c = Class.forName("androidx.core.graphics.PathParser");
		Method m = c.getDeclaredMethod("createPathFromPathData", String.class);
		Object p = m.invoke(null, data);
		if (p instanceof Path) return (Path) p;
	} catch (Throwable ignored) {}
	try {
		Class<?> c = Class.forName("android.support.v4.graphics.PathParser");
		Method m = c.getDeclaredMethod("createPathFromPathData", String.class);
		Object p = m.invoke(null, data);
		if (p instanceof Path) return (Path) p;
	} catch (Throwable ignored) {}
	return parsePathDataManual(data);
}

private static Path parsePathDataManual(String data) {
	Path out = new Path();
	if (data == null) return out;
	PathScanner sc = new PathScanner(data);
	float currentX = 0f, currentY = 0f, startX = 0f, startY = 0f;
	float lastC2X = 0f, lastC2Y = 0f, lastQX = 0f, lastQY = 0f;
	char cmd = 0;
	char prevCmd = 0;

	while (sc.hasMore()) {
		if (sc.peekIsCommand()) {
			cmd = sc.nextCommand();
		} else if (cmd == 0) {
			break;
		}

		boolean rel = Character.isLowerCase(cmd);
		char u = Character.toUpperCase(cmd);
		switch (u) {
			case 'M': {
				if (!sc.hasNumber()) break;
				float x = sc.nextFloat();
				float y = sc.nextFloat();
				if (rel) { x += currentX; y += currentY; }
				out.moveTo(x, y);
				currentX = x; currentY = y; startX = x; startY = y;
				while (sc.hasNumber()) {
					x = sc.nextFloat();
					y = sc.nextFloat();
					if (rel) { x += currentX; y += currentY; }
					out.lineTo(x, y);
					currentX = x; currentY = y;
				}
				lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'L': {
				while (sc.hasNumber()) {
					float x = sc.nextFloat();
					float y = sc.nextFloat();
					if (rel) { x += currentX; y += currentY; }
					out.lineTo(x, y);
					currentX = x; currentY = y;
				}
				lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'H': {
				while (sc.hasNumber()) {
					float x = sc.nextFloat();
					if (rel) x += currentX;
					out.lineTo(x, currentY);
					currentX = x;
				}
				lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'V': {
				while (sc.hasNumber()) {
					float y = sc.nextFloat();
					if (rel) y += currentY;
					out.lineTo(currentX, y);
					currentY = y;
				}
				lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'C': {
				while (sc.hasNumber()) {
					float x1 = sc.nextFloat(), y1 = sc.nextFloat();
					float x2 = sc.nextFloat(), y2 = sc.nextFloat();
					float x = sc.nextFloat(), y = sc.nextFloat();
					if (rel) {
						x1 += currentX; y1 += currentY;
						x2 += currentX; y2 += currentY;
						x += currentX; y += currentY;
					}
					out.cubicTo(x1, y1, x2, y2, x, y);
					lastC2X = x2; lastC2Y = y2;
					currentX = x; currentY = y;
				}
				lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'S': {
				while (sc.hasNumber()) {
					float x2 = sc.nextFloat(), y2 = sc.nextFloat();
					float x = sc.nextFloat(), y = sc.nextFloat();
					float x1 = currentX, y1 = currentY;
					char p = Character.toUpperCase(prevCmd);
					if (p == 'C' || p == 'S') {
						x1 = 2 * currentX - lastC2X;
						y1 = 2 * currentY - lastC2Y;
					}
					if (rel) {
						x2 += currentX; y2 += currentY;
						x += currentX; y += currentY;
					}
					out.cubicTo(x1, y1, x2, y2, x, y);
					lastC2X = x2; lastC2Y = y2;
					currentX = x; currentY = y;
				}
				lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			case 'Q': {
				while (sc.hasNumber()) {
					float x1 = sc.nextFloat(), y1 = sc.nextFloat();
					float x = sc.nextFloat(), y = sc.nextFloat();
					if (rel) {
						x1 += currentX; y1 += currentY;
						x += currentX; y += currentY;
					}
					out.quadTo(x1, y1, x, y);
					lastQX = x1; lastQY = y1;
					currentX = x; currentY = y;
				}
				lastC2X = currentX; lastC2Y = currentY;
				prevCmd = cmd;
				break;
			}
			case 'T': {
				while (sc.hasNumber()) {
					float x = sc.nextFloat(), y = sc.nextFloat();
					float x1 = currentX, y1 = currentY;
					char p = Character.toUpperCase(prevCmd);
					if (p == 'Q' || p == 'T') {
						x1 = 2 * currentX - lastQX;
						y1 = 2 * currentY - lastQY;
					}
					if (rel) { x += currentX; y += currentY; }
					out.quadTo(x1, y1, x, y);
					lastQX = x1; lastQY = y1;
					currentX = x; currentY = y;
				}
				lastC2X = currentX; lastC2Y = currentY;
				prevCmd = cmd;
				break;
			}
			case 'A': {
				while (sc.hasNumber()) {
					float rx = sc.nextFloat(), ry = sc.nextFloat();
					float angle = sc.nextFloat();
					float laf = sc.nextFloat();
					float sf = sc.nextFloat();
					float x = sc.nextFloat(), y = sc.nextFloat();
					if (rel) { x += currentX; y += currentY; }
					if (!addSimpleArc(out, currentX, currentY, x, y, rx, ry, angle, laf != 0f, sf != 0f)) {
						out.lineTo(x, y);
					}
					currentX = x; currentY = y;
					lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				}
				prevCmd = cmd;
				break;
			}
			case 'Z': {
				out.close();
				currentX = startX; currentY = startY;
				lastC2X = currentX; lastC2Y = currentY; lastQX = currentX; lastQY = currentY;
				prevCmd = cmd;
				break;
			}
			default: {
				sc.skipToNextCommand();
				prevCmd = cmd;
				break;
			}
		}
	}
	return out;
}

private static boolean addSimpleArc(Path path, float x0, float y0, float x1, float y1, float rx, float ry, float rotation, boolean largeArc, boolean sweep) {
	// Lightweight arc support: for complex elliptical arcs fallback to line segment.
	if (rx <= 0f || ry <= 0f) return false;
	if (Math.abs(rotation) > 0.001f) return false;
	if (Math.abs(rx - ry) > 0.001f) return false;
	float r = rx;
	float midX = (x0 + x1) * 0.5f;
	float midY = (y0 + y1) * 0.5f;
	float dx = x1 - x0, dy = y1 - y0;
	float d = (float) Math.sqrt(dx * dx + dy * dy);
	if (d == 0f) return false;
	float half = d * 0.5f;
	if (r < half) r = half;
	float h = (float) Math.sqrt(Math.max(0f, r * r - half * half));
	float ux = -dy / d;
	float uy = dx / d;
	float cx1 = midX + ux * h;
	float cy1 = midY + uy * h;
	float cx2 = midX - ux * h;
	float cy2 = midY - uy * h;
	float startA1 = (float) Math.toDegrees(Math.atan2(y0 - cy1, x0 - cx1));
	float endA1 = (float) Math.toDegrees(Math.atan2(y1 - cy1, x1 - cx1));
	float sweep1 = normalizeSweep(startA1, endA1, sweep, largeArc);
	float startA2 = (float) Math.toDegrees(Math.atan2(y0 - cy2, x0 - cx2));
	float endA2 = (float) Math.toDegrees(Math.atan2(y1 - cy2, x1 - cx2));
	float sweep2 = normalizeSweep(startA2, endA2, sweep, largeArc);
	float chosen = Math.abs(sweep1) >= Math.abs(sweep2) ? sweep1 : sweep2;
	float chosenStart = Math.abs(sweep1) >= Math.abs(sweep2) ? startA1 : startA2;
	float chosenCx = Math.abs(sweep1) >= Math.abs(sweep2) ? cx1 : cx2;
	float chosenCy = Math.abs(sweep1) >= Math.abs(sweep2) ? cy1 : cy2;
	RectF oval = new RectF(chosenCx - r, chosenCy - r, chosenCx + r, chosenCy + r);
	path.arcTo(oval, chosenStart, chosen);
	return true;
}

private static float normalizeSweep(float startDeg, float endDeg, boolean sweepPositive, boolean largeArc) {
	float sweep = endDeg - startDeg;
	while (sweep > 360f) sweep -= 360f;
	while (sweep < -360f) sweep += 360f;
	if (sweepPositive && sweep < 0f) sweep += 360f;
	if (!sweepPositive && sweep > 0f) sweep -= 360f;
	if (largeArc && Math.abs(sweep) < 180f) sweep += sweep >= 0f ? 360f : -360f;
	if (!largeArc && Math.abs(sweep) > 180f) sweep += sweep >= 0f ? -360f : 360f;
	return sweep;
}

private static class PathScanner {
	private final String s;
	private final int len;
	private int i = 0;

	PathScanner(String data) {
		s = data == null ? "" : data;
		len = s.length();
	}

	boolean hasMore() {
		skipSeparators();
		return i < len;
	}

	boolean peekIsCommand() {
		skipSeparators();
		return i < len && isCommand(s.charAt(i));
	}

	char nextCommand() {
		return i < len ? s.charAt(i++) : 0;
	}

	boolean hasNumber() {
		skipSeparators();
		if (i >= len) return false;
		char c = s.charAt(i);
		return c == '+' || c == '-' || c == '.' || (c >= '0' && c <= '9');
	}

	float nextFloat() {
		skipSeparators();
		int start = i;
		if (i < len && (s.charAt(i) == '+' || s.charAt(i) == '-')) i++;
		boolean hasDot = false;
		boolean hasExp = false;
		while (i < len) {
			char c = s.charAt(i);
			if (c >= '0' && c <= '9') {
				i++;
			} else if (c == '.' && !hasDot) {
				hasDot = true;
				i++;
			} else if ((c == 'e' || c == 'E') && !hasExp) {
				hasExp = true;
				i++;
				if (i < len && (s.charAt(i) == '+' || s.charAt(i) == '-')) i++;
			} else {
				break;
			}
		}
		String token = s.substring(start, i).trim();
		if (token.length() == 0 || "+".equals(token) || "-".equals(token) || ".".equals(token)) return 0f;
		try {
			return Float.parseFloat(token);
		} catch (Throwable t) {
			return 0f;
		}
	}

	void skipToNextCommand() {
		while (i < len && !isCommand(s.charAt(i))) i++;
	}

	private void skipSeparators() {
		while (i < len) {
			char c = s.charAt(i);
			if (Character.isWhitespace(c) || c == ',') i++;
			else break;
		}
	}

	private static boolean isCommand(char c) {
		switch (c) {
			case 'M': case 'm': case 'Z': case 'z':
			case 'L': case 'l': case 'H': case 'h':
			case 'V': case 'v': case 'C': case 'c':
			case 'S': case 's': case 'Q': case 'q':
			case 'T': case 't': case 'A': case 'a':
				return true;
			default:
				return false;
		}
	}
}
#End If
