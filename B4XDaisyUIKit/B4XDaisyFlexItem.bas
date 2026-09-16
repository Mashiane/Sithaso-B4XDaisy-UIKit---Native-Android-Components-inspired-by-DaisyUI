B4A=true
Group=Default Group\DaisyUIKit
ModulesStructureVersion=1
Type=Class
Version=13.4
@EndOfDesignText@

'B4XDaisyFlexItem.bas
'Fluent helper for configuring one flex item inside B4XDaisyFlexPanel

#IgnoreWarnings:12,9
Sub Class_Globals
    Private mOwner As B4XDaisyFlexPanel
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

Public Sub Initialize(Owner As B4XDaisyFlexPanel, vView As B4XView)
    mOwner = Owner
    mView = vView
End Sub

Public Sub Reset As B4XDaisyFlexItem
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

'-
' Fluent methods
'-

Public Sub Grow(fValue As Float) As B4XDaisyFlexItem
    pGrow = fValue
    hasFlex = True
    Return Me
End Sub

Public Sub Shrink(fValue As Float) As B4XDaisyFlexItem
    pShrink = fValue
    hasFlex = True
    Return Me
End Sub

Public Sub Flex(fGrowValue As Float, fShrinkValue As Float) As B4XDaisyFlexItem
    pGrow = fGrowValue
    pShrink = fShrinkValue
    hasFlex = True
    Return Me
End Sub

' TailwindCSS: flex-1 (grow:1, shrink:1, basis:0%)
Public Sub Flex1 As B4XDaisyFlexItem
    pGrow = 1
    pShrink = 1
    hasFlex = True
    pBasisW = 0
    pBasisH = 0
    hasBasis = True
    Return Me
End Sub

' TailwindCSS: flex-auto (grow:1, shrink:1, basis:auto)
Public Sub FlexAuto As B4XDaisyFlexItem
    pGrow = 1
    pShrink = 1
    hasFlex = True
    pBasisW = -1
    pBasisH = -1
    hasBasis = True
    Return Me
End Sub

' TailwindCSS: flex-initial (grow:0, shrink:1, basis:auto)
Public Sub FlexInitial As B4XDaisyFlexItem
    pGrow = 0
    pShrink = 1
    hasFlex = True
    pBasisW = -1
    pBasisH = -1
    hasBasis = True
    Return Me
End Sub

' TailwindCSS: flex-none (grow:0, shrink:0)
Public Sub FlexNone As B4XDaisyFlexItem
    pGrow = 0
    pShrink = 0
    hasFlex = True
    Return Me
End Sub

Public Sub MinW(iValue As Int) As B4XDaisyFlexItem
    pMinW = iValue
    hasFlex = True
    Return Me
End Sub

Public Sub MaxW(iValue As Int) As B4XDaisyFlexItem
    pMaxW = iValue
    hasFlex = True
    Return Me
End Sub

Public Sub MinH(iValue As Int) As B4XDaisyFlexItem
    pMinH = iValue
    hasFlex = True
    Return Me
End Sub

Public Sub MaxH(iValue As Int) As B4XDaisyFlexItem
    pMaxH = iValue
    hasFlex = True
    Return Me
End Sub

Public Sub MinSize(iW As Int, iH As Int) As B4XDaisyFlexItem
    pMinW = iW
    pMinH = iH
    hasFlex = True
    Return Me
End Sub

Public Sub MaxSize(iW As Int, iH As Int) As B4XDaisyFlexItem
    pMaxW = iW
    pMaxH = iH
    hasFlex = True
    Return Me
End Sub

Public Sub Basis(iW As Int, iH As Int) As B4XDaisyFlexItem
    pBasisW = iW
    pBasisH = iH
    hasBasis = True
    Return Me
End Sub

'Percent basis relative to container inner size
'MainPct for main axis, CrossPct for cross axis, use -1 to skip one axis
Public Sub BasisPercent(fMainPct As Float, fCrossPct As Float) As B4XDaisyFlexItem
    pBasisMainPct = fMainPct
    pBasisCrossPct = fCrossPct
    hasBasisPct = True
    Return Me
End Sub

Public Sub Margins(iLeft As Int, iTop As Int, iRight As Int, iBottom As Int) As B4XDaisyFlexItem
    pML = iLeft : pMT = iTop : pMR = iRight : pMB = iBottom
    hasMargins = True
    Return Me
End Sub

Public Sub MarginAll(iValue As Int) As B4XDaisyFlexItem
    pML = iValue : pMT = iValue : pMR = iValue : pMB = iValue
    hasMargins = True
    Return Me
End Sub

Public Sub MarginX(iValue As Int) As B4XDaisyFlexItem
    pML = iValue : pMR = iValue
    hasMargins = True
    Return Me
End Sub

Public Sub MarginY(iValue As Int) As B4XDaisyFlexItem
    pMT = iValue : pMB = iValue
    hasMargins = True
    Return Me
End Sub

Public Sub AlignSelf(sValue As String) As B4XDaisyFlexItem
    pAlignSelf = sValue
    hasAlignSelf = True
    Return Me
End Sub

Public Sub Order(iValue As Int) As B4XDaisyFlexItem
    pOrder = iValue
    hasOrder = True
    Return Me
End Sub

Public Sub WrapBefore(bValue As Boolean) As B4XDaisyFlexItem
    pWrapBefore = bValue
    hasWrapBefore = True
    Return Me
End Sub

'Apply staged values + relayout once
Public Sub Apply As B4XDaisyFlexItem
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
Public Sub ApplyNoRelayout As B4XDaisyFlexItem
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
Public Sub ApplyEx(bDoRelayout As Boolean) As B4XDaisyFlexItem
    If bDoRelayout Then
        Return Apply
    Else
        Return ApplyNoRelayout
    End If
End Sub

Public Sub View As B4XView
	Dim empty As B4XView
	If mView.IsInitialized = False Then Return empty
	Return mView
End Sub
