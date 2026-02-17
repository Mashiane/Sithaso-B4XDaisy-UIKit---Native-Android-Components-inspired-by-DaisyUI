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
#DesignerProperty: Key: WebViewFallback, DisplayName: WebView Fallback, FieldType: Boolean, DefaultValue: True, Description: Use WebView renderer when native SVG parsing fails

Sub Class_Globals
	Private mEventName As String 'ignore
	Private mCallBack As Object 'ignore
	Public mBase As B4XView
	Private xui As XUI

	Private ivNative As B4XView
	Private wvIcon As WebView

	Private mWidth As Float = 24dip
	Private mHeight As Float = 24dip
	Private SvgAssetPath As String = ""
	Private SvgMarkup As String = ""
	Private IconColor As Int = 0xFF3B82F6
	Private PreserveColors As Boolean = False
	Private EnableWebViewFallback As Boolean = True
	Private LastRenderer As String = ""
	Private mTag As Object
End Sub

Public Sub Initialize (Callback As Object, EventName As String)
	mEventName = EventName
	mCallBack = Callback
End Sub

Public Sub CreateView(Width As Int, Height As Int) As B4XView
	Dim p As Panel
	p.Initialize("")
	Dim b As B4XView = p
	b.Color = xui.Color_Transparent
	b.SetLayoutAnimated(0, 0, 0, Width, Height)
	Dim dummy As Label
	DesignerCreateView(b, dummy, CreateMap())
	Return mBase
End Sub

Public Sub DesignerCreateView (Base As Object, Lbl As Label, Props As Map)
	mBase = Base
	mTag = mBase.Tag
	mBase.Tag = Me
	mBase.Color = xui.Color_Transparent

	Dim iv As ImageView
	iv.Initialize("")
	ivNative = iv
	ivNative.Color = xui.Color_Transparent
	mBase.AddView(ivNative, 0, 0, 1dip, 1dip)

	Dim w As WebView
	w.Initialize("wvIcon")
	wvIcon = w
	Dim xw As B4XView = wvIcon
	xw.Color = xui.Color_Transparent
	mBase.AddView(xw, 0, 0, 1dip, 1dip)

	ConfigureNativeView
	ConfigureWebView
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

Private Sub ConfigureWebView
	#If B4A
	Try
		Dim jo As JavaObject = wvIcon
		jo.RunMethod("setBackgroundColor", Array(0))
		jo.RunMethod("setVerticalScrollBarEnabled", Array(False))
		jo.RunMethod("setHorizontalScrollBarEnabled", Array(False))
		Dim settings As JavaObject = jo.RunMethodJO("getSettings", Null)
		settings.RunMethod("setBuiltInZoomControls", Array(False))
		settings.RunMethod("setDisplayZoomControls", Array(False))
		settings.RunMethod("setSupportZoom", Array(False))
	Catch
		Log("B4XDaisySvgIcon.ConfigureWebView: " & LastException.Message)
	End Try
	#End If
End Sub

Private Sub ApplyDesignerProps(Props As Map)
	mWidth = B4XDaisyVariants.TailwindSizeToDip("6", 24dip)
	mHeight = B4XDaisyVariants.TailwindSizeToDip("6", 24dip)
	SvgAssetPath = ""
	SvgMarkup = ""
	IconColor = 0xFF3B82F6
	PreserveColors = False
	EnableWebViewFallback = True
	LastRenderer = ""

	If Props.IsInitialized = False Then
		RenderSvg
		Return
	End If

	mWidth = Max(1dip, GetPropSizeDip(Props, "Width", mWidth))
	mHeight = Max(1dip, GetPropSizeDip(Props, "Height", mHeight))
	IconColor = GetPropColor(Props, "Color", IconColor)
	PreserveColors = GetPropBool(Props, "PreserveColors", PreserveColors)
	EnableWebViewFallback = GetPropBool(Props, "WebViewFallback", EnableWebViewFallback)
	SetSvgAsset(GetPropString(Props, "SvgAsset", SvgAssetPath))
End Sub

Public Sub Base_Resize (Width As Double, Height As Double)
	If mBase.IsInitialized = False Then Return
	If ivNative.IsInitialized = False Then Return
	If wvIcon.IsInitialized = False Then Return

	Dim hostW As Int = Max(1dip, Width)
	Dim hostH As Int = Max(1dip, Height)
	Dim drawW As Int = Min(hostW, Max(1dip, mWidth))
	Dim drawH As Int = Min(hostH, Max(1dip, mHeight))
	Dim x As Int = (hostW - drawW) / 2
	Dim y As Int = (hostH - drawH) / 2

	ivNative.SetLayoutAnimated(0, x, y, drawW, drawH)
	Dim xw As B4XView = wvIcon
	xw.SetLayoutAnimated(0, x, y, drawW, drawH)
	RenderSvg
End Sub

Public Sub ResizeToParent(ParentView As B4XView)
	If ParentView.IsInitialized = False Then Return
	Base_Resize(ParentView.Width, ParentView.Height)
End Sub

Public Sub AddToParent(Parent As B4XView)
	AddToParentAt(Parent, 0, 0, Parent.Width, Parent.Height)
End Sub

Public Sub AddToParentAt(Parent As B4XView, Left As Int, Top As Int, Width As Int, Height As Int)
	If Parent.IsInitialized = False Then Return
	Dim w As Int = Max(1dip, Width)
	Dim h As Int = Max(1dip, Height)
	Dim v As B4XView = CreateView(w, h)
	Parent.AddView(v, Left, Top, w, h)
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
	RenderSvg
End Sub

Public Sub getSvgAsset As String
	Return SvgAssetPath
End Sub

Public Sub setSvgContent(Content As String)
	If Content = Null Then Content = ""
	SvgMarkup = Content.Trim
	RenderSvg
End Sub

Public Sub getSvgContent As String
	Return SvgMarkup
End Sub

Public Sub setColor(Value As Int)
	IconColor = Value
	RenderSvg
End Sub

Public Sub getColor As Int
	Return IconColor
End Sub

Public Sub setPreserveOriginalColors(Value As Boolean)
	PreserveColors = Value
	RenderSvg
End Sub

Public Sub getPreserveOriginalColors As Boolean
	Return PreserveColors
End Sub

Public Sub setWebViewFallbackEnabled(Value As Boolean)
	EnableWebViewFallback = Value
	RenderSvg
End Sub

Public Sub getWebViewFallbackEnabled As Boolean
	Return EnableWebViewFallback
End Sub

Public Sub getLastRenderer As String
	Return LastRenderer
End Sub

Public Sub setWidth(Value As Object)
	mWidth = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mWidth))
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getWidth As Float
	Return mWidth
End Sub

Public Sub setHeight(Value As Object)
	mHeight = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, mHeight))
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub getHeight As Float
	Return mHeight
End Sub

Public Sub setSize(Value As Object)
	Dim s As Float = Max(1dip, B4XDaisyVariants.TailwindSizeToDip(Value, Min(mWidth, mHeight)))
	mWidth = s
	mHeight = s
	If mBase.IsInitialized Then Base_Resize(mBase.Width, mBase.Height)
End Sub

Public Sub Refresh
	RenderSvg
End Sub

Private Sub RenderSvg
	If ivNative.IsInitialized = False Then Return
	If wvIcon.IsInitialized = False Then Return
	Dim svg As String = GetResolvedSvgContent
	If svg.Length = 0 Then svg = DefaultFallbackSvg

	If TryRenderNative(svg) Then
		ShowRenderer(True)
		LastRenderer = "native"
		Return
	End If

	If EnableWebViewFallback Then
		Dim html As String = BuildHtml(svg)
		LoadHtmlWithAssetsBase(html)
		ShowRenderer(False)
		LastRenderer = "webview"
	Else
		LastRenderer = "none"
	End If
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

Private Sub ShowRenderer(UseNative As Boolean)
	If ivNative.IsInitialized Then ivNative.Visible = UseNative
	If wvIcon.IsInitialized Then
		Dim xw As B4XView = wvIcon
		xw.Visible = Not(UseNative)
	End If
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

Private Sub BuildHtml(Svg As String) As String
	Dim colorHex As String = ColorToCssHex(IconColor)
	Dim tintCss As String
	If PreserveColors Then
		tintCss = ""
	Else
		tintCss = "#host svg [fill]:not([fill='none']){fill:currentColor!important;}" & _
			"#host svg [stroke]:not([stroke='none']){stroke:currentColor!important;}" & _
			"#host svg path:not([fill]),#host svg circle:not([fill]),#host svg rect:not([fill]),#host svg polygon:not([fill]),#host svg polyline:not([fill]),#host svg ellipse:not([fill]){fill:currentColor!important;}"
	End If
	Dim sb As StringBuilder
	sb.Initialize
	sb.Append("<!doctype html><html><head><meta charset='utf-8'/>")
	sb.Append("<meta name='viewport' content='width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no'/>")
	sb.Append("<style>")
	sb.Append("html,body{margin:0;padding:0;background:transparent;overflow:hidden;width:100%;height:100%;}")
	sb.Append("#host{width:100%;height:100%;display:flex;align-items:center;justify-content:center;color:")
	sb.Append(colorHex)
	sb.Append(";}")
	sb.Append("#host svg{width:100%;height:100%;display:block;}")
	sb.Append(tintCss)
	sb.Append("</style></head><body><div id='host'>")
	sb.Append(Svg)
	sb.Append("</div></body></html>")
	Return sb.ToString
End Sub

Private Sub LoadHtmlWithAssetsBase(Html As String)
	#If B4A
	Try
		Dim jo As JavaObject = wvIcon
		jo.RunMethod("loadDataWithBaseURL", Array("file:///android_asset/", Html, "text/html", "utf-8", Null))
	Catch
		Log("B4XDaisySvgIcon.LoadHtmlWithAssetsBase: " & LastException.Message)
		wvIcon.LoadHtml(Html)
	End Try
	#Else
	wvIcon.LoadHtml(Html)
	#End If
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

Private Sub ColorToCssHex(Color As Int) As String
	Dim r As Int = Bit.And(Bit.ShiftRight(Color, 16), 0xFF)
	Dim g As Int = Bit.And(Bit.ShiftRight(Color, 8), 0xFF)
	Dim b As Int = Bit.And(Color, 0xFF)
	Return "#" & ByteToHex(r) & ByteToHex(g) & ByteToHex(b)
End Sub

Private Sub ByteToHex(Value As Int) As String
	Dim n As Int = Bit.And(Value, 0xFF)
	Dim h As String = Bit.ToHexString(n)
	If h.Length = 1 Then Return "0" & h
	If h.Length > 2 Then Return h.SubString(h.Length - 2)
	Return h
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

Private Sub GetPropSizeDip(Props As Map, Key As String, DefaultDipValue As Float) As Float
	If Props.ContainsKey(Key) = False Then Return DefaultDipValue
	Dim o As Object = Props.Get(Key)
	Return B4XDaisyVariants.TailwindSizeToDip(o, DefaultDipValue)
End Sub

#If Java
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.util.Xml;
import org.xmlpull.v1.XmlPullParser;
import java.io.StringReader;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
		while (eventType != XmlPullParser.END_DOCUMENT) {
			if (eventType == XmlPullParser.START_TAG) {
				String tag = parser.getName();
				Path path = buildPathFromElement(parser, tag);
				if (path != null) {
					drawElement(canvas, parser, path, tintColor, preserveColors);
				}
			}
			eventType = parser.next();
		}
		canvas.restore();
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

private static void drawElement(Canvas canvas, XmlPullParser parser, Path path, int tintColor, boolean preserveColors) {
	Map<String, String> style = parseStyle(getAttr(parser, "style"));
	String fillValue = coalesce(getAttr(parser, "fill"), style.get("fill"));
	String strokeValue = coalesce(getAttr(parser, "stroke"), style.get("stroke"));
	String strokeWidthValue = coalesce(getAttr(parser, "stroke-width"), style.get("stroke-width"));
	String fillOpacityValue = coalesce(getAttr(parser, "fill-opacity"), style.get("fill-opacity"));
	String strokeOpacityValue = coalesce(getAttr(parser, "stroke-opacity"), style.get("stroke-opacity"));
	String opacityValue = coalesce(getAttr(parser, "opacity"), style.get("opacity"));
	String lineCap = coalesce(getAttr(parser, "stroke-linecap"), style.get("stroke-linecap"));
	String lineJoin = coalesce(getAttr(parser, "stroke-linejoin"), style.get("stroke-linejoin"));

	boolean fillNone = isNone(fillValue);
	boolean strokeNone = isNone(strokeValue);

	float opacity = clamp01(parseSvgNumber(opacityValue, 1f));
	float fillOpacity = clamp01(parseSvgNumber(fillOpacityValue, 1f));
	float strokeOpacity = clamp01(parseSvgNumber(strokeOpacityValue, 1f));
	float strokeWidth = Math.max(0f, parseSvgNumber(strokeWidthValue, 1f));

	int fillColor = preserveColors ? parseColor(fillValue, Color.BLACK, tintColor) : tintColor;
	int strokeColor = preserveColors ? parseColor(strokeValue, Color.TRANSPARENT, tintColor) : tintColor;

	if (!fillNone) {
		Paint fillPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
		fillPaint.setStyle(Paint.Style.FILL);
		fillPaint.setColor(applyAlpha(fillColor, opacity * fillOpacity));
		canvas.drawPath(path, fillPaint);
	}

	if (!strokeNone && strokeWidth > 0f) {
		Paint strokePaint = new Paint(Paint.ANTI_ALIAS_FLAG);
		strokePaint.setStyle(Paint.Style.STROKE);
		strokePaint.setStrokeWidth(strokeWidth);
		strokePaint.setColor(applyAlpha(strokeColor, opacity * strokeOpacity));
		strokePaint.setStrokeCap(parseLineCap(lineCap));
		strokePaint.setStrokeJoin(parseLineJoin(lineJoin));
		canvas.drawPath(path, strokePaint);
	}
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
		Class<?> c = Class.forName("androidx.core.graphics.PathParser");
		Method m = c.getDeclaredMethod("createPathFromPathData", String.class);
		Object p = m.invoke(null, data);
		if (p instanceof Path) return (Path) p;
	} catch (Throwable ignored) {}
	return null;
}
#End If
