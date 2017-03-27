'-------------------------------------------------------------------------------
Dim theAuthor           As String = "Thomas Molden"
Dim theDateStarted      As String = "25.09.2007"
Dim theDateModified     As String = "27.03.2017"
Dim theContactDetails   As String = "thomas@molden.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden Media GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "ElectionSceneStructure (Redesign 2017)"
Dim theGraphics         As String = "GENERATE: Generate Geometries - moGenerateUMXX_v00"
'-------------------------------------------------------------------------------
' global definitions
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupBaseName As String = "G"
Dim strElemBaseName  As String = "_E"

Dim strGeomExportPath As String = " /ZDFWahlen_2017/9_SHARED/geom"

Dim contEleDestination As Container
Dim sGlobalParameter   As Scene.structGlobalParameter

Dim aTypeOfBar   As Array[String]
Dim aTypeOfGraph As Array[String]
'-------------------------------------------------------------------------------
Dim knMaxGroups    As Integer = 20 ' max number of groups set to 20!
Dim knMaxTotalBars As Integer = 50 ' max number of total bars set to 50!

' NOTE:
' Noggi Width  = 736.5 is 1920 pixel screen size -> factor 2.6069
' Noggi Height = 414.2 is 1080 pixel screen size -> factor 2.6074
Dim kVizToPixelRatio = 1/2.6072

' basic dimensions in pixel
Dim kBaseOffsetX   As Double =    0.0  ' offset from right corner :   91 pixel
Dim kMaxWidth      As Double = 1738.0  ' maximal diagram width    : 1738 pixel
Dim kVBarGap       As Double =   25.0  ' gap between bars         :   25 pixel
Dim kVGroupGap     As Double =   80.0  ' gap between groups       :   80 pixel

' bar width dimensions for Hochrechnung
Dim kHRBarWidth_1_5  As Double = 245
Dim kHRBarWidth_6_7  As Double = 208
Dim kHRBarWidth_8    As Double = 195
Dim kHRBarWidth_9    As Double = 170


' bar width dimensions for SVZ and NQR
' use this values when bar prototypes had been built 
Dim kVBarWidth_1_5   As Double = 245.0
Dim kVBarWidth_6_7   As Double = 245.0
Dim kVBarWidth_8     As Double = 170.0
Dim kVBarWidth_9     As Double = 164.0

' horizontal bar definitions
Dim kHBarWidth      As Double = 16.0
Dim kHBarGap        As Double =  4.0
Dim kHGroupGap      As Double =  4.0
Dim knHMaxGroups    As Integer = 20
Dim knHMaxTotalBars As Integer = 20

Dim kHBarWidth_100h As Double = 100.0
Dim kHBarBaGap_100h As Double = 12.0
Dim kHBarGrGap_100h As Double = 100.0
Dim kHBarWidth_78h  As Double = 78.0
Dim kHBarBaGap_78h  As Double = 12.0
Dim kHBarGrGap_78h  As Double = 72.0
Dim kHBarWidth_57h  As Double = 57.0
Dim kHBarBaGap_57h  As Double = 9.0
Dim kHBarGrGap_57h  As Double = 56.0
Dim kHBarWidth_48hw As Double = 48.0
Dim kHBarBaGap_48hw As Double = 7.0
Dim kHBarGrGap_48hw As Double = 48.0
Dim kHBarWidth_48hs As Double = 48.0 
Dim kHBarBaGap_48hs As Double = 7.0
Dim kHBarGrGap_48hs As Double = 7.0

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
' fGroupGap and fElemGap are constant and not required for the 2017
' we leave it for furture changes 
Structure structGraphicDetails
	strTypeOfGraph   As String
	strTypeOfBar     As String
	strGraphicName   As String
	strGRefBaseName  As String
	strGRefGroupName As String
	strGRefBarName   As String
	strNumBars       As String
	fGroupGap        As Double 
	fElemGap         As Double
	fElemWidth       As Double
	fXOffset         As Double
End Structure
'-------------------------------------------------------------------------------
Dim sGraphicDetails As structGraphicDetails
'*******************************************************************************

'-------------------------------------------------------------------------------
'
Sub setGeometryText(contText As Container, strText As String)
	system.SendCommand("#" & contText.vizID & "*GEOM*TEXT SET " & strText)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInitParameters()
	Dim strDebugLocation As String = strScriptName & "OnInitParameters():"
	Dim strInfoText As String = ""
	Dim aUpdateState As Array[String]

	Scene.dbgOutput(1, strDebugLocation, "... init parameters ...")
	
	strInfoText = strInfoText & "author:        " & theAuthor & "\n"
	strInfoText = strInfoText & "date started:  " & theDateStarted & "\n"
	strInfoText = strInfoText & "date modified: " & theDateModified & "\n"
	strInfoText = strInfoText & "contact:       " & theContactDetails & "\n"
	strInfoText = strInfoText & "copyright:     " & theCopyrightDetails & "\n" 
	strInfoText = strInfoText & "client:        " & theClient & "\n"
	strInfoText = strInfoText & "project:       " & theProject & "\n"
	strInfoText = strInfoText & "graphics:      " & theGraphics & "\n"
	RegisterInfoText(strInfoText)
    ' define type of graphs
	aTypeOfGraph.Clear
	aTypeOfGraph.Push("HRPZ")
	aTypeOfGraph.Push("HRPD")
	aTypeOfGraph.Push("HRPZD")
	aTypeOfGraph.Push("HRPG")
	aTypeOfGraph.Push("UMVP")
	aTypeOfGraph.Push("UMVPD")
	aTypeOfGraph.Push("UMVD")
	aTypeOfGraph.Push("UMKB")
	aTypeOfGraph.Push("UMHP")
	aTypeOfGraph.Push("UMHPD")
    ' define type of bars
	aTypeOfBar.Clear
	aTypeOfBar.Push("1-5b")
	aTypeOfBar.Push("6-7b")
	aTypeOfBar.Push("8b")
	aTypeOfBar.Push("9b")
	aTypeOfBar.Push("100h")
	aTypeOfBar.Push("78h")
	aTypeOfBar.Push("57h")
	aTypeOfBar.Push("48hw")
	aTypeOfBar.Push("48hs")
	
	RegisterParameterString("theGraphicName", "graphic name [gUMVP_24]:", "/GENERATED/gUMVP_24", 25, 55, "")
	RegisterParameterString("theTypeOfGraph", "type of graph [UMVP|UMVD|...]:", "UMVP", 25, 55, "")
	RegisterParameterString("theTypeOfBar", "type of bar [gUMVP_8b|...]:", "gUMVP_8b", 25, 55, "")
	RegisterRadioButton("theTypeOfBarSelect", "type of bar select:", 0, aTypeOfBar)
	RegisterRadioButton("theTypeOfGraphSelect", "type of graph select:", 0, aTypeOfGraph)
'	RegisterParameterDouble("theGroupGap", "distance between groups [8.0]:", 8.0, 0.0, 300.0)
	RegisterParameterString("theNumBars", "number of bars in groups [2#3#3]:", "2#4", 25, 55, "")
'	RegisterParameterDouble("theElementGap", "distance between elements [2.0]:", 2.0, 0.0, 100.0)
'	RegisterParameterDouble("theElementWidth", "width of elements [20.0]:", 20.0, 0.0, 100.0)
	
'	aUpdateState.Clear
'	aUpdateState.push("ON")
'	aUpdateState.push("OFF")
'	RegisterRadioButton("theUpdateState", "update state:", 0, aUpdateState)
	
	RegisterPushButton("btCreateGeometry", "create geometry", 11)
	RegisterPushButton("btExportGeometry", "export geometry", 21)
	RegisterPushButton("btDeleteGeometry", "delete geometry", 31)
	
End Sub
'-------------------------------------------------------------------------------
'
Sub OnParameterChanged(parameterName As String)
	Dim strBarName, strTemp As String
	
	If parameterName = "theTypeOfGraphSelect" Or parameterName = "theTypeOfBarSelect" Then

		this.ScriptPluginInstance.SetParameterString( "theTypeOfGraph", aTypeOfGraph[ GetParameterInt("theTypeOfGraphSelect") ] )
		this.ScriptPluginInstance.SetParameterString( "theTypeOfBar", aTypeOfBar[ GetParameterInt("theTypeOfBarSelect") ] )

	End If
	
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()

	Scene.dbgRegisterFunction( strScriptName )
	
	sGlobalParameter = (Scene.structGlobalParameter) Scene.Map["sGlobalParameter"]
	contEleDestination = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	
	Scene.dbgClearOnScreenError()
	
End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecAction(buttonId As Integer)
	Dim strDebugLocation As String = strScriptName & "OnExecAction():"

	Scene.dbgClearOnScreenError()
	Scene.dbgOutput(1, strDebugLocation, "[buttonId]: [" & buttonId & "]")

	If buttonID = 11 Then

		' create geometry
		deleteGeometry()
		deleteChildren()
		createGeometry()

	ElseIf buttonID = 21 Then

		' get global parameter
		sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]
		' export geometry
		exportGeometry( sGlobalParameter.strGlobGeomSourcePath, sGraphicDetails.strGraphicName )
		deleteChildren()

	ElseIf buttonID = 31 Then

		deleteChildren()
'		deleteGeometry()

	End If

End Sub

'-------------------------------------------------------------------------------
'
Sub readGeometryDetails( strTypeOfGraphics As String )
	Dim strDebugLocation As String = strScriptName & "readGeometryDetails():"

	Scene.dbgOutput(1, strDebugLocation, "reading geometry details .START.")

	If strTypeOfGraphics = "UMVerticalX" Then
	
		sGraphicDetails.strGraphicName   = GetParameterString( "theGraphicName" )
		sGraphicDetails.strTypeOfGraph   = GetParameterString( "theTypeOfGraph" )
		
		' set strTypeOfBar for UMVPD=UMVP
		If sGraphicDetails.strTypeOfGraph = "UMVPD" Then
			sGraphicDetails.strTypeOfGraph = "UMVP"
		End If
		
		' theTypeOfBarSelect
		sGraphicDetails.strTypeOfBar     = GetParameterString( "theTypeOfBar" ) 
		sGraphicDetails.strGRefBaseName  = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_Base"
		sGraphicDetails.strGRefGroupName = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_Group"
		sGraphicDetails.strGRefBarName   = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_" & sGraphicDetails.strTypeOfBar
		sGraphicDetails.strNumBars       = GetParameterString( "theNumBars" )

		' assign width and gaps defined by type of bar
		Select Case sGraphicDetails.strTypeOfBar
			Case "1-5b"
				 sGraphicDetails.fElemWidth = kVBarWidth_1_5
				 sGraphicDetails.fGroupGap  = kVGroupGap
				 sGraphicDetails.fElemGap   = kVBarGap
			Case "6-7b"
				 sGraphicDetails.fElemWidth = kVBarWidth_6_7
				 sGraphicDetails.fGroupGap  = kVGroupGap
				 sGraphicDetails.fElemGap   = kVBarGap
			Case "8b"
				 sGraphicDetails.fElemWidth = kVBarWidth_8
				 sGraphicDetails.fGroupGap  = kVGroupGap
				 sGraphicDetails.fElemGap   = kVBarGap
			Case "9b"
				 sGraphicDetails.fElemWidth = kVBarWidth_9
				 sGraphicDetails.fGroupGap  = kVGroupGap
				 sGraphicDetails.fElemGap   = kVBarGap
			Case Else
				 sGraphicDetails.fElemWidth = kVBarWidth_1_5
				 sGraphicDetails.fGroupGap  = kVGroupGap
				 sGraphicDetails.fElemGap   = kVBarGap
		End Select

		sGraphicDetails = calcGapsAndOffset_UMVerticalX( sGraphicDetails )
	
	ElseIf strTypeOfGraphics = "UMHorizontalX" Then
	
		sGraphicDetails.strGraphicName   = GetParameterString( "theGraphicName" )
		sGraphicDetails.strTypeOfGraph   = GetParameterString( "theTypeOfGraph" ) 
	
		' theTypeOfBarSelect
		sGraphicDetails.strTypeOfBar     = GetParameterString( "theTypeOfBar" ) 
		sGraphicDetails.strGRefBaseName  = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_Base"
		sGraphicDetails.strGRefGroupName = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_Group"
		sGraphicDetails.strGRefBarName   = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfGraph & "_" & sGraphicDetails.strTypeOfBar
		sGraphicDetails.strNumBars       = GetParameterString( "theNumBars" )
		
		' set initial horizontal offset
		sGraphicDetails.fXOffset = 0.0
		' assign width and gaps defined by type of bar
		Select Case sGraphicDetails.strTypeOfBar
			Case "100h"
				 sGraphicDetails.fElemWidth = kHBarWidth_100h
				 sGraphicDetails.fGroupGap  = kHBarGrGap_100h
				 sGraphicDetails.fElemGap   = kHBarBaGap_100h
			Case "78h"
				 sGraphicDetails.fElemWidth = kHBarWidth_78h
				 sGraphicDetails.fGroupGap  = kHBarGrGap_78h
				 sGraphicDetails.fElemGap   = kHBarBaGap_78h
			Case "57h"
				 sGraphicDetails.fElemWidth = kHBarWidth_57h
				 sGraphicDetails.fGroupGap  = kHBarGrGap_57h
				 sGraphicDetails.fElemGap   = kHBarBaGap_57h
			Case "48hw"
				 sGraphicDetails.fElemWidth = kHBarWidth_48hw
				 sGraphicDetails.fGroupGap  = kHBarGrGap_48hw
				 sGraphicDetails.fElemGap   = kHBarBaGap_48hw
			Case "48hs"
				 sGraphicDetails.fElemWidth = kHBarWidth_48hs
				 sGraphicDetails.fGroupGap  = kHBarGrGap_48hs
				 sGraphicDetails.fElemGap   = kHBarBaGap_48hs
			Case Else
				 sGraphicDetails.fElemWidth = kHBarWidth_57h
				 sGraphicDetails.fGroupGap  = kHBarGrGap_57h
				 sGraphicDetails.fElemGap   = kHBarBaGap_57h
		End Select

	End If	
	
	Scene.dbgOutput(1, strDebugLocation, "[strTypeOfGraph]: [" & sGraphicDetails.strTypeOfGraph & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strTypeOfBar]: [" & sGraphicDetails.strTypeOfBar & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGraphicName]: [" & sGraphicDetails.strGraphicName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefBaseName]: [" & sGraphicDetails.strGRefBaseName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefGroupName]: [" & sGraphicDetails.strGRefGroupName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefBarName]: [" & sGraphicDetails.strGRefBarName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strNumBars]: [" & sGraphicDetails.strNumBars & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fGroupGap]: [" & sGraphicDetails.fGroupGap & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fElemGap]: [" & sGraphicDetails.fElemGap & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fElemWidth]: [" & sGraphicDetails.fElemWidth & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fXOffset]: [" & sGraphicDetails.fXOffset & "]")

	Scene.dbgOutput(1, strDebugLocation, "reading geometry details .DONE.")

End Sub
'-------------------------------------------------------------------------------
'
Sub createGeometry()
	Dim strDebugLocation As String = strScriptName & "createGeometry():"

	Scene.dbgOutput(1, strDebugLocation, "creating geometry .START.")

	' get global parameter
	sGlobalParameter = (Scene.structGlobalParameter) Scene.Map["sGlobalParameter"]
	
	' moHack: read theTypeOfBar
	sGraphicDetails.strTypeOfGraph = GetParameterString( "theTypeOfGraph" ) 
	Scene.dbgOutput(2, strDebugLocation, "[sGraphicDetails.strTypeOfGraph]: [" & sGraphicDetails.strTypeOfGraph & "]")

	' set strTypeOfBar for UMVPD=UMVP
	If sGraphicDetails.strTypeOfGraph = "UMVPD" Then
		sGraphicDetails.strTypeOfGraph = "UMVP"
	End If

	' Vertical Bars
	If sGraphicDetails.strTypeOfGraph = "UMVP" Or sGraphicDetails.strTypeOfGraph = "UMVD" Or sGraphicDetails.strTypeOfGraph = "UMKB" Then
	
		Scene.dbgOutput(3, strDebugLocation, "creating geometry [" & sGraphicDetails.strTypeOfGraph & "]..")
		' read geometry details
		readGeometryDetails("UMVerticalX")
		' build geometry
		createGeometry_UMVerticalX()

	' Horizontal Bars
	ElseIf sGraphicDetails.strTypeOfGraph = "UMHP" Or sGraphicDetails.strTypeOfGraph = "UMHPD" Then

		Scene.dbgOutput(4, strDebugLocation, "creating geometry [" & sGraphicDetails.strTypeOfGraph & "]....")
		' read geometry details
		readGeometryDetails("UMHorizontalX")
		' build geometry
		createGeometry_UMHorizontalX()

	End If

	Scene.dbgOutput(5, strDebugLocation, "creating geometry .DONE.")
End Sub

'-------------------------------------------------------------------------------
'
Sub createGeometry_UMVerticalX()
	Dim strDebugLocation As String = strScriptName & "createGeometry_UMVerticalX():"
	Dim contGeomBase, contGroup, contElement, contGroupGfxEle As Container
	Dim aContElement As Array [Container]
	Dim iGroup, iElem As Integer
	Dim aString As Array[String]
	Dim tmpString, strPostfix, strBarReferenceName As String
	Dim strEleBaseName, strEleGroupName As String
	Dim fGroupPosX, fElemPosX, fOffsetX, fBannerWidth, fHelp As Double
	Dim vBoundingBox As Vertex
	
	Scene.dbgOutput(1, strDebugLocation, "create .START.")

	' create base container and assign name
	contGeomBase = contEleDestination.AddContainer(TL_DOWN)
	contGeomBase.Name = sGraphicDetails.strGraphicName
	contGeomBase.CreateGeometry( sGraphicDetails.strGRefBaseName )
	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
	sGraphicDetails.strNumBars.Split("#", aString)
	
	' create groups and elements
	For iGroup = 1 To aString.UBound + 1
	
		Scene.dbgOutput(1, strDebugLocation, "processing [iGroup] [nElem]: [" & iGroup & "] [" & aString[iGroup-1] & "]")
		contGroup = contGeomBase.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
		contGroup.Name = strGroupBaseName & iGroup
		contGroup.CreateGeometry( sGraphicDetails.strGRefGroupName ) 
		System.SendCommand( "#" & contGroup.vizID & "*GEOM SPLIT" )

		' Calculate banner and background width
		contGroupGfxEle = contGroup.FindSubContainer("$GFX_ELE")
		fBannerWidth = (CInt(aString[iGroup-1])-1)*kVBarGap + CInt(aString[iGroup-1])*sGraphicDetails.fElemWidth
Scene.dbgOutput(1, strDebugLocation, "[fBannerWidth]: [" & fBannerWidth & "] ...............in pixel........")
		fBannerWidth = fBannerWidth * kVizToPixelRatio
Scene.dbgOutput(1, strDebugLocation, "[kVizToPixelRatio]: [" & kVizToPixelRatio & "] ...............kVizToPixelRatio........")
Scene.dbgOutput(1, strDebugLocation, "[fBannerWidth]: [" & fBannerWidth & "] ...............in viz units........")
		contGroupGfxEle.FindSubContainer("$objBanner").Geometry.PluginInstance.SetParameterDouble("width", fBannerWidth)
		
        If sGraphicDetails.strTypeOfGraph = "UMVD" Then
		' set background for pos and neg panel
			contGroupGfxEle.FindSubContainer("$objGroupBG_pos").Geometry.PluginInstance.SetParameterDouble("width", fBannerWidth)
			contGroupGfxEle.FindSubContainer("$objGroupBG_neg").Geometry.PluginInstance.SetParameterDouble("width", fBannerWidth)
		Else
		' set background for all other panel
			contGroupGfxEle.FindSubContainer("$objGroupBG").Geometry.PluginInstance.SetParameterDouble("width", fBannerWidth)
		End If

		' set position
		If iGroup = 1 Then

			fGroupPosX = sGraphicDetails.fXOffset * kVizToPixelRatio
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosX & "]")
			contGroup.Position.X = fGroupPosX
			' set Position.X of info percent label
			contGeomBase.FindSubContainer( "$INFO_PERCENT$TRANS" ).Position.x = fGroupPosX
			
		ElseIf iGroup > 1 Then

			' fGroupPosX is fBannerWidth of previous group + GroupGap*VizToPixelRatio
			fHelp = (CInt(aString[iGroup-2])-1)*sGraphicDetails.fElemGap + CInt(aString[iGroup-2])*sGraphicDetails.fElemWidth
			fGroupPosX = fGroupPosX + (fHelp + sGraphicDetails.fGroupGap) * kVizToPixelRatio
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosX & "]")
			contGroup.Position.X = fGroupPosX

		End If
		
		' create elements in group
		For iElem = 1 To CInt(aString[iGroup-1])

			Scene.dbgOutput(1, strDebugLocation, "processing [iElem]: [" & iElem & "]")
			contElement = contGroup.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
			contElement.Name = strGroupBaseName & iGroup & strElemBaseName & iElem
			tmpString = sGlobalParameter.strGlobGeomSourcePath & sGraphicDetails.strGraphicName
			Scene.dbgOutput(1, strDebugLocation, "[tmpString]: [" & tmpString & "]")
			contElement.CreateGeometry( sGraphicDetails.strGRefBarName ) 
'			contElement.CreateGeometry( sGraphicDetails.strTypeOfBar ) 
'			System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )

			' set position
			If iElem = 1 Then

				fElemPosX = 0.5*sGraphicDetails.fElemWidth
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetX]: [" & fElemPosX & "]")
				contElement.Position.X = fElemPosX * kVizToPixelRatio

			ElseIf iElem > 1 Then

				fElemPosX = ( iElem-1 )*( sGraphicDetails.fElemGap + sGraphicDetails.fElemWidth ) + 0.5*sGraphicDetails.fElemWidth
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetX]: [" & fElemPosX & "]")
				contElement.Position.X = fElemPosX * kVizToPixelRatio

			End If

		Next
		
		' set group label position
		contGroup.FindSubContainer("$GROUP_LABEL").Position.X = 0.0

	Next

	Scene.dbgOutput(1, strDebugLocation, "create .DONE.")
	
End Sub

'-------------------------------------------------------------------------------
'
Function calcGapsAndOffset_UMVerticalX( sGraphicDetails As structGraphicDetails ) As structGraphicDetails
	Dim strDebugLocation As String = strScriptName & "calcGapsAndOffset_UMVerticalX():"
	Dim tmpString As String
	Dim aNumBars As Array[String]
	Dim iGroup, numGroups, numBars As Integer
	Dim fTotalWidth As Double

	Scene.dbgOutput(1, strDebugLocation, "[sGraphicDetails.strNumBars]: [" & sGraphicDetails.strNumBars & "]")

	tmpString = sGraphicDetails.strNumBars
	tmpString.Split("#", aNumBars)

	' get number of groups and total number of bars
	numBars = 0
	numGroups = aNumBars.UBound

	For iGroup = 0 To numGroups
		numBars = numBars + CInt(aNumBars[iGroup])
	Next

	Scene.dbgOutput(1, strDebugLocation, "[numGroups] [numBars]: [" & numGroups & "] [" & numBars & "]")
	' calculate total width of graphic
	fTotalWidth = numBars*sGraphicDetails.fElemWidth + (numBars-1)*sGraphicDetails.fElemGap + numGroups*sGraphicDetails.fGroupGap 
	' offset graph to left
	sGraphicDetails.fXOffset = (-0.5)*fTotalWidth

	Scene.dbgOutput(1, strDebugLocation, "[fTotalWidth]: [" & fTotalWidth & "]")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicDetails.fXOffset]: [" & sGraphicDetails.fXOffset & "]")
	
	calcGapsAndOffset_UMVerticalX = sGraphicDetails
	
End Function
'-------------------------------------------------------------------------------
'
Sub createGeometry_UMHorizontalX()
	Dim strDebugLocation As String = strScriptName & "createGeometry_UMHorizontalX()):"
	Dim contGeomBase, contGroup, contElement, contGroupGfxEle As Container
	Dim aContElement As Array [Container]
	Dim iGroup, iElem As Integer
	Dim aString As Array[String]
	Dim tmpString, strPostfix, strBarReferenceName As String
	Dim strEleBaseName, strEleGroupName As String
	Dim fBGHeight, fGroupPosY, fElemPosY, fOffsetY, fHelp As Double
	Dim vBoundingBox As Vertex
	
	Scene.dbgOutput(1, strDebugLocation, "create .START.")

	' create base container and assign name
	contGeomBase = contEleDestination.AddContainer(TL_DOWN)
	contGeomBase.Name = sGraphicDetails.strGraphicName
	contGeomBase.CreateGeometry( sGraphicDetails.strGRefBaseName )
	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
	sGraphicDetails.strNumBars.Split("#", aString)
	Scene.dbgOutput(1, strDebugLocation, "[strGraphicName] [strGRefBaseName]: [" & sGraphicDetails.strGraphicName & "] [" & sGraphicDetails.strGRefBaseName & "]")

	' create groups and elements
	fGroupPosY = sGraphicDetails.fXOffset

	For iGroup = 1 To aString.UBound + 1
	
		Scene.dbgOutput(1, strDebugLocation, "processing [iGroup] [nElem]: [" & iGroup & "] [" & aString[iGroup-1] & "]")
		contGroup = contGeomBase.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
		contGroup.Name = strGroupBaseName & iGroup
		
		contGroup.CreateGeometry( sGraphicDetails.strGRefGroupName ) 
		System.SendCommand( "#" & contGroup.vizID & "*GEOM SPLIT" )

		' Calculate banner and background width
		contGroupGfxEle = contGroup.FindSubContainer("$GFX_ELE")
		fBGHeight = (CInt(aString[iGroup-1])-1)*sGraphicDetails.fElemGap + CInt(aString[iGroup-1])*sGraphicDetails.fElemWidth
Scene.dbgOutput(1, strDebugLocation, "[fBGHeight]: [" & fBGHeight & "] ...............in pixel........")
		fBGHeight = fBGHeight * kVizToPixelRatio
Scene.dbgOutput(1, strDebugLocation, "[kVizToPixelRatio]: [" & kVizToPixelRatio & "] ...............kVizToPixelRatio........")
Scene.dbgOutput(1, strDebugLocation, "[fBGHeight]: [" & fBGHeight & "] ...............in viz units........")
		contGroupGfxEle.FindSubContainer("$objGroupBG").Geometry.PluginInstance.SetParameterDouble("width", fBGHeight)

		' calculate and set vertical position.Y
		If iGroup = 1 Then

			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosY & "]")
			contGroup.Position.Y = fGroupPosY

		ElseIf iGroup > 1 Then

			fHelp = (CInt(aString[iGroup-2])-1)*sGraphicDetails.fElemGap + CInt(aString[iGroup-2])*sGraphicDetails.fElemWidth
			fGroupPosY = fGroupPosY + (fHelp + sGraphicDetails.fGroupGap) * kVizToPixelRatio
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosY]: [" & fGroupPosY & "]")
			contGroup.Position.Y = (-1)*fGroupPosY

		End If
		
		' create elements in group
		For iElem = 1 To CInt(aString[iGroup-1])

			Scene.dbgOutput(1, strDebugLocation, "processing [iElem]: [" & iElem & "]")
			contElement = contGroup.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
			contElement.Name = strGroupBaseName & iGroup & strElemBaseName & iElem
			tmpString = sGlobalParameter.strGlobGeomSourcePath & sGraphicDetails.strGraphicName
			Scene.dbgOutput(1, strDebugLocation, "[tmpString]: [" & tmpString & "]")
			contElement.CreateGeometry( sGraphicDetails.strGRefBarName ) 
'			System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
println "..... [strGRefBarName]: ["	& sGraphicDetails.strGRefBarName & "]"

			' set position
			If iElem > 1 Then
			
				fElemPosY = ( iElem-1 )*( sGraphicDetails.fElemGap + sGraphicDetails.fElemWidth ) * kVizToPixelRatio
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetY]: [" & fElemPosY & "]")
				contElement.Position.Y = (-1)*fElemPosY
				
			End If

		Next

	Next
	Scene.dbgOutput(1, strDebugLocation, "create .DONE.")
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_PosX( fGroupGap As Double, fElemGap As Double, fElemWidth As Double )
	Dim strDebugLocation As String = strScriptName & "updateScene_PosX():"
	Dim contGeomBase, contGroup, contElement As Container
	Dim fGroupPosX, fElemPosX, fOffsetX As Double
	Dim aString As Array[String]
	
	contGeomBase = contEleDestination.FindSubcontainer( sGraphicDetails.strGraphicName )
	sGraphicDetails.strNumBars.Split("#", aString)

	' set positionX for groups and elements
	fGroupPosX = 0.0
	For iGroup = 1 To aString.UBound + 1
		Scene.dbgOutput(1, strDebugLocation, "[iGroup] [nElem]: [" & iGroup & "] [" & aString[iGroup-1] & "]")
		contGroup = contGeomBase.FindSubcontainer( strGroupBaseName & iGroup )
		' set position
		If iGroup > 1 Then
			fGroupPosX = fGroupPosX + fGroupGap + CDbl(aString[iGroup-2])*(fElemWidth+fElemGap) - fElemGap
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosX & "]")
			contGroup.Position.X = fGroupPosX
		End If
		' create elements in group
		For iElem = 1 To CInt(aString[iGroup-1])
			Scene.dbgOutput(1, strDebugLocation, "[iElem]: [" & iElem & "]")
			contElement = contGroup.FindSubcontainer( strGroupBaseName & iGroup & strElemBaseName & iElem )
			' set position
			If iElem > 1 Then
				fOffsetX = ( iElem-1 )*( fElemGap + fElemWidth )
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetX]: [" & fOffsetX & "]")
				contElement.Position.X = fOffsetX
			End If
		Next
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub exportGeometry(strExportPath As String, strGeomName As String)
	Dim strDebugLocation As String = strScriptName & "exportGeometry():"
	Dim contGeomBase, contGroup, contElement As Container
	
	contGeomBase = contEleDestination.FindSubcontainer( sGraphicDetails.strGraphicName )
	Scene.dbgOutput(1, strDebugLocation, "[contGeomBase.Name]: [" & contGeomBase.Name & "]")
	' merge container
	Scene.dbgOutput(1, strDebugLocation, "[SendCommand]: [" & "#" & contGeomBase.vizID & "*GEOM MERGE 1" & "]")
	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM MERGE 1" )
	' save geometry to database
	Scene.dbgOutput(1, strDebugLocation, "[SendCommand]: [" & "GEOM SAVE_TO_DATABASE GEOM*#" & contGeomBase.Geometry.vizID & strGeomExportPath & strGeomName & "]")
	System.SendCommand( "GEOM SAVE_TO_DATABASE GEOM*#" & contGeomBase.Geometry.vizID & strGeomExportPath & strGeomName )
End Sub
'-------------------------------------------------------------------------------
'
Sub deleteChildren()
	contEleDestination.DeleteChildren()
End Sub
'-------------------------------------------------------------------------------
'
Sub deleteGeometry()
	Dim contGeomBase As Container
	
'	contGeomBase = contEleDestination.FindSubcontainer( sGraphicDetails.strGraphicName )
'	contGeomBase.Delete()
	contEleDestination.DeleteGeometry()
End Sub
'-------------------------------------------------------------------------------
'
'
'-------------------------------------------------------------------------------

