B4A=true
Group=Default Group\DaisuyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XFlexItem.bas
'Fluent helper for configuring one flex item inside B4XFlexPanel

Sub Class_Globals
    Private mOwner As B4XFlexPanel
    Private mView As B4XView
    
    'staged values (defaults mean "use these if Flex() gets applied")
    Private pGrow As Float = 0
    Private pShrink As Float = 1
    
    Private pMinW As Int = -1
    Private pMaxW As Int = -1
    Private pMinH As Int = -1
    Private pMaxH As Int = -1
    
    Private pBasisW As Int = -1
    Private pBasisH As Int = -1
    
    Private pBasisMainPct As Float = -1
    Private pBasisCrossPct As Float = -1
    
    Private pML As Int = 0
    Private pMT As Int = 0
    Private pMR As Int = 0
    Private pMB As Int = 0
    
    Private pAlignSelf As String = "auto"
    Private pOrder As Int = 0
    Private pWrapBefore As Boolean = False
    
    Private hasFlex As Boolean = False
    Private hasBasis As Boolean = False
    Private hasBasisPct As Boolean = False
    Private hasMargins As Boolean = False
    Private hasAlignSelf As Boolean = False
    Private hasOrder As Boolean = False
    Private hasWrapBefore As Boolean = False
End Sub

Public Sub Initialize(Owner As B4XFlexPanel, v As B4XView)
    mOwner = Owner
    mView = v
End Sub

Public Sub Reset As B4XFlexItem
    pGrow = 0
    pShrink = 1
    
    pMinW = -1 : pMaxW = -1 : pMinH = -1 : pMaxH = -1
    pBasisW = -1 : pBasisH = -1
    pBasisMainPct = -1 : pBasisCrossPct = -1
    
    pML = 0 : pMT = 0 : pMR = 0 : pMB = 0
    pAlignSelf = "auto"
    pOrder = 0
    pWrapBefore = False
    
    hasFlex = False
    hasBasis = False
    hasBasisPct = False
    hasMargins = False
    hasAlignSelf = False
    hasOrder = False
    hasWrapBefore = False
    Return Me
End Sub

'========================
' Fluent methods
'========================

Public Sub Grow(Value As Float) As B4XFlexItem
    pGrow = Value
    hasFlex = True
    Return Me
End Sub

Public Sub Shrink(Value As Float) As B4XFlexItem
    pShrink = Value
    hasFlex = True
    Return Me
End Sub

Public Sub Flex(GrowValue As Float, ShrinkValue As Float) As B4XFlexItem
    pGrow = GrowValue
    pShrink = ShrinkValue
    hasFlex = True
    Return Me
End Sub

Public Sub MinW(Value As Int) As B4XFlexItem
    pMinW = Value
    hasFlex = True
    Return Me
End Sub

Public Sub MaxW(Value As Int) As B4XFlexItem
    pMaxW = Value
    hasFlex = True
    Return Me
End Sub

Public Sub MinH(Value As Int) As B4XFlexItem
    pMinH = Value
    hasFlex = True
    Return Me
End Sub

Public Sub MaxH(Value As Int) As B4XFlexItem
    pMaxH = Value
    hasFlex = True
    Return Me
End Sub

Public Sub MinSize(W As Int, H As Int) As B4XFlexItem
    pMinW = W
    pMinH = H
    hasFlex = True
    Return Me
End Sub

Public Sub MaxSize(W As Int, H As Int) As B4XFlexItem
    pMaxW = W
    pMaxH = H
    hasFlex = True
    Return Me
End Sub

Public Sub Basis(W As Int, H As Int) As B4XFlexItem
    pBasisW = W
    pBasisH = H
    hasBasis = True
    Return Me
End Sub

'Percent basis relative to container inner size
'MainPct for main axis, CrossPct for cross axis, use -1 to skip one axis
Public Sub BasisPercent(MainPct As Float, CrossPct As Float) As B4XFlexItem
    pBasisMainPct = MainPct
    pBasisCrossPct = CrossPct
    hasBasisPct = True
    Return Me
End Sub

Public Sub Margins(Left As Int, Top As Int, Right As Int, Bottom As Int) As B4XFlexItem
    pML = Left : pMT = Top : pMR = Right : pMB = Bottom
    hasMargins = True
    Return Me
End Sub

Public Sub MarginAll(Value As Int) As B4XFlexItem
    pML = Value : pMT = Value : pMR = Value : pMB = Value
    hasMargins = True
    Return Me
End Sub

Public Sub MarginX(Value As Int) As B4XFlexItem
    pML = Value : pMR = Value
    hasMargins = True
    Return Me
End Sub

Public Sub MarginY(Value As Int) As B4XFlexItem
    pMT = Value : pMB = Value
    hasMargins = True
    Return Me
End Sub

Public Sub AlignSelf(Value As String) As B4XFlexItem
    pAlignSelf = Value
    hasAlignSelf = True
    Return Me
End Sub

Public Sub Order(Value As Int) As B4XFlexItem
    pOrder = Value
    hasOrder = True
    Return Me
End Sub

Public Sub WrapBefore(Value As Boolean) As B4XFlexItem
    pWrapBefore = Value
    hasWrapBefore = True
    Return Me
End Sub

'Apply staged values + relayout once
Public Sub Apply As B4XFlexItem
    If mOwner.IsInitialized = False Then Return Me
    If mView.IsInitialized = False Then Return Me
    
    mOwner.BeginUpdate
    
    If hasFlex Then
        mOwner.SetItemFlexEx_NoRelayout(mView, pGrow, pShrink, pMinW, pMaxW, pMinH, pMaxH)
    End If
    
    If hasBasis Then
        mOwner.SetItemBasis_NoRelayout(mView, pBasisW, pBasisH)
    End If
    
    If hasBasisPct Then
        mOwner.SetItemBasisPercent_NoRelayout(mView, pBasisMainPct, pBasisCrossPct)
    End If
    
    If hasMargins Then
        mOwner.SetItemMargins_NoRelayout(mView, pML, pMT, pMR, pMB)
    End If
    
    If hasAlignSelf Then
        mOwner.SetItemAlignSelf_NoRelayout(mView, pAlignSelf)
    End If
    
    If hasOrder Then
        mOwner.SetItemOrder_NoRelayout(mView, pOrder)
    End If
    
    If hasWrapBefore Then
        mOwner.SetItemWrapBefore_NoRelayout(mView, pWrapBefore)
    End If
    
    mOwner.EndUpdate(True)
    Return Me
End Sub

'Apply staged values without relayout (use inside loops + call fp.EndUpdate(True) once)
Public Sub ApplyNoRelayout As B4XFlexItem
    If mOwner.IsInitialized = False Then Return Me
    If mView.IsInitialized = False Then Return Me
    
    If hasFlex Then mOwner.SetItemFlexEx_NoRelayout(mView, pGrow, pShrink, pMinW, pMaxW, pMinH, pMaxH)
    If hasBasis Then mOwner.SetItemBasis_NoRelayout(mView, pBasisW, pBasisH)
    If hasBasisPct Then mOwner.SetItemBasisPercent_NoRelayout(mView, pBasisMainPct, pBasisCrossPct)
    If hasMargins Then mOwner.SetItemMargins_NoRelayout(mView, pML, pMT, pMR, pMB)
    If hasAlignSelf Then mOwner.SetItemAlignSelf_NoRelayout(mView, pAlignSelf)
    If hasOrder Then mOwner.SetItemOrder_NoRelayout(mView, pOrder)
    If hasWrapBefore Then mOwner.SetItemWrapBefore_NoRelayout(mView, pWrapBefore)
    
    Return Me
End Sub

'Convenience overload
Public Sub ApplyEx(DoRelayout As Boolean) As B4XFlexItem
    If DoRelayout Then
        Return Apply
    Else
        Return ApplyNoRelayout
    End If
End Sub

Public Sub getView As B4XView
    Return mView
End Sub