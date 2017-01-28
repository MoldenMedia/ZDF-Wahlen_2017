'-------------------------------------------------------------------------------
Dim theAuthor           As String = "Thomas Molden"
Dim theDateStarted      As String = "25.09.2007"
Dim theDateModified     As String = "24.01.2017"
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
Dim knMaxGroups    As Integer = 12
Dim knMaxTotalBars As Integer = 12

' basic dimensions in pixel
Dim kBaseOffsetX   As Double =   0.0  ' offset from right corner :   91 pixel
Dim kMaxWidth      As Double = 142.0  ' maximal diagram width    : 1738 pixel
Dim kBarGap        As Double = 0.08   ' gap between bars         :   25 pixel
Dim kGroupGap      As Double = 0.40   ' gap between groups       :   80 pixel

' bar width deimensions for Hochrechnung
Dim kHRBarWidth_1_5  As Double = 245
Dim kHRBarWidth_6_7  As Double = 208
Dim kHRBarWidth_8    As Double = 195
Dim kHRBarWidth_9    As Double = 170

' bar width deimensions for SVZ and NQR
Dim kBarWidth_1_5    As Double = 245.0
Dim kBarWidth_6_7    As Double = 245.0
Dim kBarWidth_8      As Double = 170.0
Dim kBarWidth_9      As Double = 164.0

Dim kBarWidth_2_3  As Double = 25.0
Dim kBarGap_2_3    As Double =  0.08
Dim kGroupGap_2_3  As Double =  0.40
'Dim kBarGap_2_3    As Double =   7.0 units
'Dim kGroupGap_2_3  As Double =  35.0 units
'Dim kBarGap_2_3    As Double =  0.1
'Dim kGroupGap_2_3  As Double =  0.5

Dim kBarWidth_4_6  As Double = 21.0

Dim kBarWidth_7    As Double = 18.0
Dim kBarGap_7      As Double =  0.05
Dim kGroupGap_7    As Double =  0.30

Dim kBarWidth_8_12 As Double = 12.0
'Dim kBarWidth_8_12 As Double = 75.0

Dim kHBarWidth      As Double = 16.0
Dim kHBarGap        As Double =  4.0
Dim kHGroupGap      As Double =  4.0
Dim knHMaxGroups    As Integer = 20
Dim knHMaxTotalBars As Integer = 20
'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
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
	blnValidated     As Boolean
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

	RegisterParameterString("theGraphicName", "graphic name [gUMVP_24]:", "/GENERATED/gUMVP_24", 25, 55, "")
	RegisterParameterString("theTypeOfBar", "type of bar [UMVP|UMVD|...]:", "UMVP", 25, 55, "")
	RegisterRadioButton("theTypeOfBarSelect", "type of bar select:", 0, aTypeOfBar)
	RegisterRadioButton("theTypeOfGraphSelect", "type of graph select:", 0, aTypeOfGraph)
	RegisterParameterDouble("theGroupGap", "distance between groups [8.0]:", 8.0, 0.0, 300.0)
	RegisterParameterString("theNumBars", "number of bars in groups [2#3#3]:", "2#4", 25, 55, "")
	RegisterParameterDouble("theElementGap", "distance between elements [2.0]:", 2.0, 0.0, 100.0)
	RegisterParameterDouble("theElementWidth", "width of elements [20.0]:", 20.0, 0.0, 100.0)
	
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
	Dim strGraphicName, strTemp As String
	
	If parameterName = "theTypeOfGraphSelect" Or parameterName = "theTypeOfBarSelect" Then
        strGraphicName = "g" & aTypeOfGraph[ GetParameterInt("theTypeOfGraphSelect") ] & "_" & aTypeOfBar[ GetParameterInt("theTypeOfBarSelect") ]
		this.ScriptPluginInstance.SetParameterString( "theTypeOfBar", strGraphicName )
	End If
	
'	If parameterName = "theGroupGap" Or parameterName = "theElementGap" Then
'		readGeometryDetails("")
'		updateScene_PosX( sGraphicDetails.fGroupGap, sGraphicDetails.fElemGap, sGraphicDetails.fElemWidth )
'	End If

' 24.01.2017 not required anymore
'	' build default geom name
'	If parameterName = "theTypeOfGraphSelect" Or parameterName = "theTypeOfGroup" Or parameterName = "theNumBars" Then
'		strTemp = GetParameterString("theNumBars")
'		strTemp.Substitute("[|#]", "", TRUE)
'       strGraphicName = "g" & aTypeOfGraph[ GetParameterInt("theTypeOfGraphSelect") ] & "_" & aTypeOfBar[ GetParameterInt("theTypeOfBarSelect") ]
''		this.ScriptPluginInstance.SetParameterString("theGraphicName", strGraphicName)
''		this.Update()
'	End If
	
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
		Scene.dbgOutput(1, strDebugLocation, "... button 11 pressed ...")
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
		sGraphicDetails.strTypeOfBar     = GetParameterString( "theTypeOfBar" ) 
		' set strTypeOfBar for UMVPD=UMVP
		If sGraphicDetails.strTypeOfBar = "UMVPD" Then
			sGraphicDetails.strTypeOfBar = "UMVP"
		End If
		sGraphicDetails.strGRefBaseName  = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfBar & "_Base"
		sGraphicDetails.strGRefGroupName = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfBar & "_Group"
		sGraphicDetails.strGRefBarName   = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGraphicDetails.strTypeOfBar & "_"
		sGraphicDetails.strNumBars       = GetParameterString( "theNumBars" )
	
		sGraphicDetails = calcGapsAndOffset_UMVerticalX( sGraphicDetails )
	
	ElseIf strTypeOfGraphics = "UMHorizontalX" Then

		sGraphicDetails.strGraphicName   = GetParameterString( "theGraphicName" )
		sGraphicDetails.strTypeOfBar     = GetParameterString( "theTypeOfBar" ) 
		sGraphicDetails.strGRefBaseName  = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/gUMHX_Base"
		sGraphicDetails.strGRefGroupName = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/gUMHX_Group"
		sGraphicDetails.strGRefBarName   = "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/gUMHX_"
		sGraphicDetails.strNumBars       = GetParameterString( "theNumBars" )
	
		sGraphicDetails = calcGapsAndOffset_UMHorizontalX( sGraphicDetails )
	
	End If	
	
	Scene.dbgOutput(1, strDebugLocation, "[strGraphicName]: [" & sGraphicDetails.strGraphicName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefBaseName]: [" & sGraphicDetails.strGRefBaseName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefGroupName]: [" & sGraphicDetails.strGRefGroupName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strGRefBarName]: [" & sGraphicDetails.strGRefBarName & "]")
	Scene.dbgOutput(1, strDebugLocation, "[strNumBars]: [" & sGraphicDetails.strNumBars & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fGroupGap]: [" & sGraphicDetails.fGroupGap & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fElemGap]: [" & sGraphicDetails.fElemGap & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fElemWidth]: [" & sGraphicDetails.fElemWidth & "]")
	Scene.dbgOutput(1, strDebugLocation, "[fXOffset]: [" & sGraphicDetails.fXOffset & "]")
	Scene.dbgOutput(1, strDebugLocation, "[blnValidated]: [" & sGraphicDetails.blnValidated & "]")

	Scene.dbgOutput(1, strDebugLocation, "reading geometry details .DONE.")
	
End Sub
'-------------------------------------------------------------------------------
'
Sub createGeometry()
	Dim strDebugLocation As String = strScriptName & "createGeometry():"

	Scene.dbgOutput(1, strDebugLocation, "creating geometry .START.")

	' get global parameter
	sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]
'	' get element base name
'	strEleBaseName = "GEOM*ZDFWahlen_v3/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGeometryDetails.strBarBaseName & "_Base"
'	' get element group name
'	strEleGroupName = "GEOM*ZDFWahlen_v3/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGeometryDetails.strBarBaseName & "_Group"
'	' get bar base postfix
'	strPostfix = getBarBasePostfix( sGeometryDetails.strNumBars )
	
	' moHack: read theTypeOfBar
	sGraphicDetails.strTypeOfBar = GetParameterString( "theTypeOfBar" ) 
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicDetails.strTypeOfBar]: [" & sGraphicDetails.strTypeOfBar & "]")

	' set strTypeOfBar for UMVPD=UMVP
	If sGraphicDetails.strTypeOfBar = "UMVPD" Then
		sGraphicDetails.strTypeOfBar = "UMVP"
	End If

	If sGraphicDetails.strTypeOfBar = "UMVP" Or sGraphicDetails.strTypeOfBar = "UMVD" Or sGraphicDetails.strTypeOfBar = "UMKB" Then
	
		Scene.dbgOutput(1, strDebugLocation, "creating geometry [" & sGraphicDetails.strTypeOfBar & "]..")
		' read geometry details
		readGeometryDetails("UMVerticalX")

		If sGraphicDetails.blnValidated = TRUE Then
			' build geometry
			createGeometry_UMVerticalX()
		End If

	ElseIf sGraphicDetails.strTypeOfBar = "UMHP" Or sGraphicDetails.strTypeOfBar = "UMHPD" Then

		Scene.dbgOutput(1, strDebugLocation, "creating geometry [" & sGraphicDetails.strTypeOfBar & "]....")
		' read geometry details
		readGeometryDetails("UMHorizontalX")

		If sGraphicDetails.blnValidated = TRUE Then
			' build geometry
			createGeometry_UMHorizontalX()
		End If

	End If

	Scene.dbgOutput(1, strDebugLocation, "creating geometry .DONE.")
End Sub

'	' swap geometry
'	contBlenderOUT.deleteGeometry()
'	contBlenderOUT.Geometry = contBlenderIN.Geometry
'	contBlenderIN.deleteGeometry()
'	contBlenderIN.CreateGeometry( Scene.sGlobalParameter.strGlobGeomGeneratePath & GetParameterString("theTypeOfGraphics") )
' 	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM MERGE 0" )

'-------------------------------------------------------------------------------
' modified 08.01.2017 by tm
'
Sub createGeometry_UMVerticalX()
	Dim strDebugLocation As String = strScriptName & "createGeometry_UMVerticalX():"
	Dim contGeomBase, contGroup, contElement As Container
	Dim aContElement As Array [Container]
	Dim iGroup, iElem As Integer
	Dim aString As Array[String]
	Dim tmpString, strPostfix, strBarReferenceName As String
	Dim strEleBaseName, strEleGroupName As String
	Dim fGroupPosX, fElemPosX, fOffsetX As Double
	Dim vBoundingBox As Vertex
	
	Scene.dbgOutput(1, strDebugLocation, "create .START.")
	' build name of reference bar
'		strBarReferenceName = "GEOM*ZDFWahlen_v3/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGeometryDetails.strBarBaseName & "_" & strPostfix

	' create base container and assign name
	contGeomBase = contEleDestination.AddContainer(TL_DOWN)
	contGeomBase.Name = sGraphicDetails.strGraphicName
	contGeomBase.CreateGeometry( sGraphicDetails.strGRefBaseName )
	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
	sGraphicDetails.strNumBars.Split("#", aString)
	' create groups and elements
	fGroupPosX = sGraphicDetails.fXOffset
	For iGroup = 1 To aString.UBound + 1
		Scene.dbgOutput(1, strDebugLocation, "processing [iGroup] [nElem]: [" & iGroup & "] [" & aString[iGroup-1] & "]")
		contGroup = contGeomBase.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
		contGroup.Name = strGroupBaseName & iGroup
		contGroup.CreateGeometry( sGraphicDetails.strGRefGroupName ) 
		System.SendCommand( "#" & contGroup.vizID & "*GEOM SPLIT" )
		' set position
		If iGroup = 1 Then
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosX & "]")
			contGroup.Position.X = fGroupPosX
		ElseIf iGroup > 1 Then
			fGroupPosX = fGroupPosX + sGraphicDetails.fGroupGap + CDbl(aString[iGroup-2])*(sGraphicDetails.fElemWidth+sGraphicDetails.fElemGap) - sGraphicDetails.fElemGap
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
'			System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
			' set position
			If iElem > 1 Then
				fElemPosX = ( iElem-1 )*( sGraphicDetails.fElemGap + sGraphicDetails.fElemWidth )
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetX]: [" & fElemPosX & "]")
				contElement.Position.X = fElemPosX
			End If
		Next
		' set group label position
		contGroup.FindSubContainer("$GROUP_LABEL").Position.X = 0.0
'		contGroup.FindSubContainer("$GROUP_LABEL").Position.X = -0.5*sGraphicDetails.fElemWidth
'		contGroup.FindSubContainer("$GROUP_LABEL").Position.X = 0.5*(sGraphicDetails.fElemWidth*CDbl(aString[iGroup-1]) + sGraphicDetails.fElemGap*(CDbl(aString[iGroup-1])-1))
	Next
	Scene.dbgOutput(1, strDebugLocation, "create .DONE.")
	
End Sub
'-------------------------------------------------------------------------------
'
'Structure structGraphicDetails
'	strGraphicName   As String
'	strGRefGroupName As String
'	strGRefBarName   As String
'	strNumBars       As String
'	fGroupGap        As Double
'	fElemGap         As Double
'	fElemWidth       As Double
'	fXOffset         As Double
'	blnValidated     As Boolean
'End Structure

'Dim kBarWidth_2_3  As Double = 25.0
'Dim kBarGap_2_3    As Double = 0.10
'Dim kGroupGap_2_3  As Double = 0.40


'-------------------------------------------------------------------------------
' modified 08.01.2017 by tm
'
Function calcGapsAndOffset_UMVerticalX( sGraphicDetails As structGraphicDetails ) As structGraphicDetails
	Dim strDebugLocation As String = strScriptName & "calcGapsAndOffset_UMVerticalX():"
	Dim strErrorTitle, strErrorMessage As String
	Dim strPostfix, tmpString As String
	Dim aNumBars As Array[String]
	Dim iGroup, numGroups, numBars, numBarsInGroup As Integer
	Dim fTotalWidth As Double

	Scene.dbgOutput(1, strDebugLocation, "[sGraphicDetails.strNumBars]: [" & sGraphicDetails.strNumBars & "]")
	
	strPostfix = ""
	tmpString = sGraphicDetails.strNumBars
	tmpString.Split("#", aNumBars)
	
	If aNumBars.UBound <= knMaxGroups Then

		numBars = 0
		numGroups = aNumBars.UBound
		For iGroup = 0 To numGroups
			numBars = numBars + CInt(aNumBars[iGroup])
		Next
		Scene.dbgOutput(1, strDebugLocation, "[aNumBars.UBound] [numBars]: [" & aNumBars.UBound & "] [" & numBars & "]")
	
		If numBars <= knMaxTotalBars Then
			If numBars >= 2 And numBars <= 3 Then
				strPostfix = "2-3b"
				sGraphicDetails.fElemWidth = kBarWidth_2_3
				sGraphicDetails.fGroupGap  = kBarWidth_2_3 * kGroupGap_2_3
				sGraphicDetails.fElemGap   = kBarWidth_2_3 * kBarGap_2_3
			ElseIf numBars >= 4 And numBars <= 6 Then
				strPostfix = "4-6b"
				sGraphicDetails.fElemWidth = kBarWidth_4_6
				sGraphicDetails.fGroupGap  = kBarWidth_4_6 * kGroupGap_2_3
				sGraphicDetails.fElemGap   = kBarWidth_4_6 * kBarGap_2_3
			ElseIf numBars = 7 Then
				strPostfix = "7b"
				sGraphicDetails.fElemWidth = kBarWidth_7
				sGraphicDetails.fGroupGap  = kBarWidth_7 * kGroupGap_7
				sGraphicDetails.fElemGap   = kBarWidth_7 * kBarGap_7
			ElseIf numBars >= 8 And numBars <= 12 Then
				strPostfix = "8-12b"
				sGraphicDetails.fElemWidth = kBarWidth_8_12
				sGraphicDetails.fGroupGap  = kBarWidth_8_12 * kGroupGap_2_3
				sGraphicDetails.fElemGap   = kBarWidth_8_12 * kBarGap_2_3
			Else
				strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
				strErrorMessage = "wrong number of total bars: [" & numBars & "]\n"
				strErrorMessage = strErrorMessage & "number of total bars allowed: [2...12]"
				Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
			End If
			
			If strPostfix <> "" Then
				sGraphicDetails.strGRefBarName = sGraphicDetails.strGRefBarName & strPostfix
				
				
'				fTotalWidth = sGraphicDetails.fElemWidth * (numBars + (numGroups - 1)*sGraphicDetails.fGroupGap + (numBars - numGroups)*sGraphicDetails.fElemGap )
println strDebugLocation & "[numGroups]: [" & numGroups & "]........................................."
println strDebugLocation & "[numBars]: [" & numBars & "]........................................."
println strDebugLocation & "[fElemWidth]: [" & sGraphicDetails.fElemWidth & "]........................................."
println strDebugLocation & "[fGroupGap]: [" & sGraphicDetails.fGroupGap & "]........................................."
println strDebugLocation & "[fElemGap]: [" & sGraphicDetails.fElemGap & "]........................................."
				
				fTotalWidth = sGraphicDetails.fElemWidth * numBars
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "].....bars..........................."
				fTotalWidth = fTotalWidth + (numGroups - 1) * sGraphicDetails.fGroupGap
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "].....bars+groups...................."
				fTotalWidth = fTotalWidth + (numBars - numGroups - 1) * sGraphicDetails.fElemGap
				

				Scene.dbgOutput(1, strDebugLocation, "[fTotalWidth]: [" & fTotalWidth & "]")
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "]........................................."
				
'				sGraphicDetails.fXOffset = 0.5 * (kMaxWidth - fTotalWidth) + kBaseOffsetX
				sGraphicDetails.fXOffset = 0.0
println strDebugLocation & "[fXOffset]: [" & sGraphicDetails.fXOffset & "]........................................."

				sGraphicDetails.blnValidated = TRUE
			Else
				sGraphicDetails.blnValidated = FALSE
			End If
		Else
			strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
			strErrorMessage = "current number of total bars: [" & numBars & "]\n"
			strErrorMessage = strErrorMessage & "max number of total bars allowed: [" & knMaxTotalBars & "]"
			Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
		End If
		
	Else
		strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
		strErrorMessage = "current number of groups: [" & aNumBars.UBound & "]\n"
		strErrorMessage = strErrorMessage & "max number of groups allowed: [" & knMaxGroups & "]"
		Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
	End If
	
	calcGapsAndOffset_UMVerticalX = sGraphicDetails
	
End Function
'-------------------------------------------------------------------------------
'
Sub createGeometry_UMHorizontalX()
	Dim strDebugLocation As String = strScriptName & "createGeometry_UMHorizontalX()):"
	Dim contGeomBase, contGroup, contElement As Container
	Dim aContElement As Array [Container]
	Dim iGroup, iElem As Integer
	Dim aString As Array[String]
	Dim tmpString, strPostfix, strBarReferenceName As String
	Dim strEleBaseName, strEleGroupName As String
	Dim fGroupPosY, fElemPosY, fOffsetY As Double
	Dim vBoundingBox As Vertex
	
	Scene.dbgOutput(1, strDebugLocation, "create .START.")
	' build name of reference bar
'		strBarReferenceName = "GEOM*ZDFWahlen_v3/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/g" & sGeometryDetails.strBarBaseName & "_" & strPostfix

	' create base container and assign name
	contGeomBase = contEleDestination.AddContainer(TL_DOWN)
	contGeomBase.Name = sGraphicDetails.strGraphicName
	contGeomBase.CreateGeometry( sGraphicDetails.strGRefBaseName )
	System.SendCommand( "#" & contGeomBase.vizID & "*GEOM SPLIT" )
	sGraphicDetails.strNumBars.Split("#", aString)
println "..... [strGraphicName]: ["	& sGraphicDetails.strGraphicName & "]"
println "..... [strGRefBaseName]: ["	& sGraphicDetails.strGRefBaseName & "]"
	' create groups and elements
	fGroupPosY = sGraphicDetails.fXOffset
println "..... [sGraphicDetails.fXOffset]: ["	& sGraphicDetails.fXOffset & "]"
	For iGroup = 1 To aString.UBound + 1
		Scene.dbgOutput(1, strDebugLocation, "processing [iGroup] [nElem]: [" & iGroup & "] [" & aString[iGroup-1] & "]")
		contGroup = contGeomBase.FindSubContainer("$TRANS").AddContainer(TL_DOWN)
		contGroup.Name = strGroupBaseName & iGroup
		
		If CInt( aString[iGroup-1] ) <= 4 Then
			contGroup.CreateGeometry( sGraphicDetails.strGRefGroupName & "_" & aString[iGroup-1] & "b" ) 
		Else
			contGroup.CreateGeometry( sGraphicDetails.strGRefGroupName & "_4b" ) 
		End If
		
		System.SendCommand( "#" & contGroup.vizID & "*GEOM SPLIT" )
println "..... [strGRefGroupName]: ["	& sGraphicDetails.strGRefGroupName & "]"
		' set position
		If iGroup = 1 Then
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosY & "]")
			contGroup.Position.Y = fGroupPosY
		ElseIf iGroup > 1 Then
			fGroupPosY = fGroupPosY + sGraphicDetails.fGroupGap + CDbl(aString[iGroup-2])*(sGraphicDetails.fElemWidth+sGraphicDetails.fElemGap) - sGraphicDetails.fElemGap
			Scene.dbgOutput(1, strDebugLocation, "[fGroupPosX]: [" & fGroupPosY & "]")
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
				fElemPosY = ( iElem-1 )*( sGraphicDetails.fElemGap + sGraphicDetails.fElemWidth )
				Scene.dbgOutput(1, strDebugLocation, "[fOffsetX]: [" & fElemPosY & "]")
				contElement.Position.Y = (-1)*fElemPosY
			End If
		Next

	Next
	Scene.dbgOutput(1, strDebugLocation, "create .DONE.")
	
End Sub
'-------------------------------------------------------------------------------
'
Function calcGapsAndOffset_UMHorizontalX( sGraphicDetails As structGraphicDetails ) As structGraphicDetails
	Dim strDebugLocation As String = strScriptName & "calcGapsAndOffset_UMHorizontalX():"
	Dim strErrorTitle, strErrorMessage As String
	Dim strPostfix, tmpString As String
	Dim aNumBars As Array[String]
	Dim iGroup, numGroups, numBars, numBarsInGroup As Integer
	Dim fTotalWidth As Double

	Scene.dbgOutput(1, strDebugLocation, "[sGraphicDetails.strNumBars]: [" & sGraphicDetails.strNumBars & "]")
	
	strPostfix = ""
	tmpString = sGraphicDetails.strNumBars
	tmpString.Split("#", aNumBars)
	
	If aNumBars.UBound <= knHMaxGroups Then

		numBars = 0
		numGroups = aNumBars.UBound
		For iGroup = 0 To numGroups
			numBars = numBars + CInt(aNumBars[iGroup])
		Next
		Scene.dbgOutput(1, strDebugLocation, "[aNumBars.UBound] [numBars]: [" & aNumBars.UBound & "] [" & numBars & "]")
	
		If numBars <= knHMaxTotalBars Then
		
'Dim kHBarWidth     As Double = 16.0
'Dim kHBarGap       As Double =  4.0
'Dim kHGroupGap     As Double =  4.0
			If numBars >= 2 And numBars <= knHMaxTotalBars Then
				strPostfix = "2_12b"
				sGraphicDetails.fElemWidth = kHBarWidth
				sGraphicDetails.fGroupGap  = kHGroupGap
				sGraphicDetails.fElemGap   = kHBarGap
			Else
				strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
				strErrorMessage = "wrong number of total bars: [" & numBars & "]\n"
				strErrorMessage = strErrorMessage & "number of total bars allowed: [2...12]"
				Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
			End If
			
			If strPostfix <> "" Then
'				sGraphicDetails.strGRefBarName   = "GEOM*ZDFWahlen_v3/9_SHARED/geom/_ELEMENTS_/_UMFRAGE_/gUMHX_" & strPostfix
				sGraphicDetails.strGRefBarName = sGraphicDetails.strGRefBarName & strPostfix
				
				
'				fTotalWidth = sGraphicDetails.fElemWidth * (numBars + (numGroups - 1)*sGraphicDetails.fGroupGap + (numBars - numGroups)*sGraphicDetails.fElemGap )
println strDebugLocation & "[numGroups]: [" & numGroups & "]........................................."
println strDebugLocation & "[numBars]: [" & numBars & "]........................................."
println strDebugLocation & "[fElemWidth]: [" & sGraphicDetails.fElemWidth & "]........................................."
println strDebugLocation & "[fGroupGap]: [" & sGraphicDetails.fGroupGap & "]........................................."
println strDebugLocation & "[fElemGap]: [" & sGraphicDetails.fElemGap & "]........................................."
				
				fTotalWidth = sGraphicDetails.fElemWidth * numBars
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "].....bars..........................."
				fTotalWidth = fTotalWidth + (numGroups - 1) * sGraphicDetails.fGroupGap
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "].....bars+groups...................."
				fTotalWidth = fTotalWidth + (numBars - numGroups - 1) * sGraphicDetails.fElemGap
				

				Scene.dbgOutput(1, strDebugLocation, "[fTotalWidth]: [" & fTotalWidth & "]")
println strDebugLocation & "[fTotalWidth]: [" & fTotalWidth & "]........................................."
				
				sGraphicDetails.fXOffset = 0.0
println strDebugLocation & "[fXOffset]: [" & sGraphicDetails.fXOffset & "]........................................."

				sGraphicDetails.blnValidated = TRUE
			Else
				sGraphicDetails.blnValidated = FALSE
			End If
		Else
			strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
			strErrorMessage = "current number of total bars: [" & numBars & "]\n"
			strErrorMessage = strErrorMessage & "max number of total bars allowed: [" & knHMaxTotalBars & "]"
			Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
		End If
		
	Else
		strErrorTitle   = "ERROR: [" & strDebugLocation & "]"
		strErrorMessage = "current number of groups: [" & aNumBars.UBound & "]\n"
		strErrorMessage = strErrorMessage & "max number of groups allowed: [" & knHMaxGroups & "]"
		Scene.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
	End If
	
	calcGapsAndOffset_UMHorizontalX = sGraphicDetails
	
End Function
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

