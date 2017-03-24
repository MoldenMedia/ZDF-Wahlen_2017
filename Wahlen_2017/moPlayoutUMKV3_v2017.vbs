'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "23.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "UMFRAGE: Kurven - moPlayoutUMKV3_v00"
'-------------------------------------------------------------------------------
'*******************************************************************************
'__________CHANGELOG____________________________________________________________
'	04.08.2010 (me) fix delimitter issues with linechart plugin (convert double to string, set seperator to |) in updateScene_assignData()
'	04.10.2010 (ie) Button Prozente an / aus zugefügt
'	23.06.2014 (ie) Labelpositionierung zugefügt Label 2 / 3 -> Label 1 noch nicht verwendet
'					leer -> keine Verschiebung / 0 = automatisch mittig / <> 0 = Mittig plus Offset
'*******************************************************************************
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim fMaxVizValue As Double 
Dim fMaxBarValue As Double
Dim fLabelHeight As Double 

' container definitions
Dim contElementPool As Container
Dim contBlenderElementIN  As Container
Dim contBlenderElementOUT As Container

'Dim cont

Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$GRAPH"
'Dim kElementBaseName         As String = "_E"

Dim kGroupGfxGraphSubPath    As String = "$GFX_GRAPH"
Dim kTransSubPath            As String = "$TRANS"
Dim kGroupLabelSubPath       As String = "$ELE_LABEL"
Dim kDataSubPath             As String = "$DATA"
Dim kGroupTextSubPath        As String = "$txt_text"
Dim kLabelText1SubPath       As String = "$txt_label_1"
Dim kLabelText2SubPath       As String = "$txt_label_2"
Dim kLabelText3SubPath       As String = "$txt_label_3"

Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"
Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTypoSubPath							 As String = "$TYPO"
Dim kTextSubPath             As String = "$txt_value"
Dim kUnitSubPath             As String = "$txt_unit"
Dim kUnitSubPathRen          As String = "$txt_unit_off"
Dim kUnitSubName             As String = "txt_unit"
Dim kUnitSubNameRen          As String = "txt_unit_off"

Dim nMaxNumGraphs            As Integer = 5

Dim kMaxVizWidthUMKV         As Double = 315.0

Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj1Mirror As Container
Dim contBarObj2, contBarObj2Mirror As Container

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structGraphData
	nElements        As Integer
	strMaterial      As String
	aValueNum        As Array[String]
	aValueTxt        As Array[String]
	aValuePos        As Array[String]
	aLabel1          As Array[String]  'INGO
	aLabel2          As Array[String]		'INGO
	aLabel3          As Array[String]		'INGO
	strAnimOrderFlag As String
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName        As String
	nGroups            As Integer
	aGroup             As Array[structGraphData]
	aGraphLabel        As Array[String]
	dblMinValue        As Double
	dblMaxValue        As Double
	dblMaxPos          As Double
	blnInfoPercentFlag As Boolean
End Structure
'-------------------------------------------------------------------------------
Dim sGraphData    As structGraphData
Dim sGraphicsData As structGraphicsData

'*******************************************************************************
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
	
'	RegisterParameterString("theTypeOfGraphic", "type of graphic [HRPZ|HRPD|HRPG]:", "HRPZ", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gUMKV]:", "/UMFRAGE/gUMKV3", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [5#5#5#5#5#5]:", "10#10#10", 25, 55, "")

	RegisterParameterString("theGraphLabel", "graph label  [gLabel1#gLabel2#...]:", "Juli#August#September", 75, 256, "")

	RegisterParameterString("theLabel1", "label line 1 [CDU/CSU|SPD#...]:", "v1. name1#v2. name2#v3. name3", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "##", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "##", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [39|36|15#...]:", "40|42|41|44|43|46|45|48|47|49#30|32|31|34|33|36|35|38|37|39#20|22|21|24|23|26|25|28|27|29", 75, 2048, "")
	RegisterParameterString("theValueTxt", "values formatted [39|36|15#...]:", "40|42*|41|44|43|46|45|48|47|49#30|32|31*|34|33|36|35|38|37|39#20|22|21|24*|23|26|25|28|27|29", 75, 2048, "")
	RegisterParameterString("theValuePos", "value position [1|2|3#...]:", "1|2|3|4|5|6|7|8|9|10#1|2|3|4|5|6|7|8|9|10#1|2|3|4|5|6|7|8|9|10", 75, 2048, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1#2#3", 75, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu#spd#gruene", 75, 300, "")
	RegisterParameterString("theRangeValues", "min/max values [0|50]:", "0|50", 25, 55, "")
	RegisterParameterBool("thePercentInfoFlag", "Show Info Percent", TRUE)

	RegisterPushButton("btAssignValues", "assign values", 11)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btAssignValuesDirect", "assign values direct", 21)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btSetLabelPosXY", "set label posXY", 31)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btSetLabelPerc", "Prozent an / aus", 41)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Scene.dbgRegisterFunction( strScriptName )
	
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderElementOUT = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")

	sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]
End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecAction(buttonId As Integer)
	Dim strDebugLocation As String = strScriptName & "OnExecAction():"
	
	Scene.dbgOutput(1, strDebugLocation, "[buttonId]: [" & buttonId & "]")
	If buttonID = 11 Then
		Scene.dbgOutput(1, strDebugLocation, "... button 11 pressed ...")
		readGraphicsData()
		updateScene_assignData()
	ElseIf buttonID = 21 Then
		Scene.dbgOutput(1, strDebugLocation, "... button 21 pressed ...")
		readGraphicsData()
		updateScene_assignData()
	ElseIf buttonID = 31 Then
		setGraphLabelPosXY()
	ElseIf buttonID = 41 Then
		setGraphLabelPerc()
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readGraphicsData()
	Dim strDebugLocation As String = strScriptName & "readGraphicsData():"
	Dim strTemp As String
	Dim aGraphLabList, aGroupEleList, aRangeValues As Array[String]

	'********************************************************
	' INGO: Parameter zum Schubsen der Label
	'********************************************************
	Dim aLabel1, aLabel2, aLabel3 As Array[String]
	'********************************************************

	Dim aEleMaterial, aEleValueNum, aEleValueTxt, aEleValuePos As Array[String]
	Dim aEleAnimOrder As Array[String]
	Dim iGroup, nMaxLabel, intTempValue As Integer
	Dim dblTempValue, dblTempPos As Double

'	fMaxVizValue = sGlobalParameter.dblMaxVizValueUMKV 
'	fLabelHeight = sGlobalParameter.dblMaxVizValueHRLabHeight 
	
	' get info percent label flag
	sGraphicsData.blnInfoPercentFlag = GetParameterBool("thePercentInfoFlag")
	' get min/max values
	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strElementSeparator, aRangeValues )
	sGraphicsData.dblMinValue = CDbl( aRangeValues[0] )
	sGraphicsData.dblMaxValue = CDbl( aRangeValues[1] )
	println sGraphicsData.dblMaxValue 
	' get group data
	strTemp = GetParameterString("theNumElements")
	strTemp.Split( strGroupSeparator, aGroupEleList )
	strTemp = GetParameterString("theGraphLabel")
	strTemp.Split( strGroupSeparator, aGraphLabList )

	'********************************************************
	' INGO: Parameter zum Schubsen der Label
	' Zerlegung in Gruppen
	'********************************************************
	strTemp = GetParameterString("theLabel1")
	strTemp.Split( strGroupSeparator, aLabel1 )
	strTemp = GetParameterString("theLabel2")
	strTemp.Split( strGroupSeparator, aLabel2 )
	strTemp = GetParameterString("theLabel3")
	strTemp.Split( strGroupSeparator, aLabel3 )
	'********************************************************

	strTemp = GetParameterString("theMaterial")
	strTemp.Split( strGroupSeparator, aEleMaterial )
	strTemp = GetParameterString("theValueNum")
	strTemp.Substitute(",", ".", true)
	strTemp.Split( strGroupSeparator, aEleValueNum )
	strTemp = GetParameterString("theValueTxt")
	strTemp.Split( strGroupSeparator, aEleValueTxt )
	strTemp = GetParameterString("theValuePos")
	strTemp.Split( strGroupSeparator, aEleValuePos )
	strTemp = GetParameterString("theAnimOrderFlag")
	strTemp.Split( strGroupSeparator, aEleAnimOrder )

	sGraphicsData.nGroups     = aGroupEleList.UBound
	sGraphicsData.aGraphLabel = aGraphLabList
	
	nMaxLabel = 0 
	fMaxBarValue = 0.0
	dblTempValue = 0.0
	dblTempPos   = 0.0
	sGraphicsData.dblMaxPos = 0.0
	' read group and element details
	sGraphicsData.aGroup.Clear()
	For iGroup = 0 To sGraphicsData.nGroups
	
		Scene.dbgOutput( 1, strDebugLocation, "reading data of [iGroup]: [" & iGroup & "]" )
		sGraphData.nElements = CInt( aGroupEleList[ iGroup ] )

		sGraphData.strMaterial = aEleMaterial[iGroup]
		aEleValueNum[iGroup].Split( strElementSeparator, sGraphData.aValueNum )
		aEleValueTxt[iGroup].Split( strElementSeparator, sGraphData.aValueTxt )
		aEleValuePos[iGroup].Split( strElementSeparator, sGraphData.aValuePos )

		'********************************************************
		' INGO: Parameter zum Schubsen der Label
		' Zerlegung in Elemente
		'********************************************************
		aLabel1[iGroup].Split( strElementSeparator, sGraphData.aLabel1 )
		aLabel2[iGroup].Split( strElementSeparator, sGraphData.aLabel2 )
		aLabel3[iGroup].Split( strElementSeparator, sGraphData.aLabel3 )
		'********************************************************

		sGraphData.strAnimOrderFlag = aEleAnimOrder[iGroup]
		
		dblTempValue = Scene._getMaxBaxValue( sGraphData.aValueNum )
		If dblTempValue > fMaxBarValue Then
			fMaxBarValue = dblTempValue
		End If
''''		dblTempPos = Scene._getMaxBaxValue( sGraphData.aValuePos )
		dblTempPos = Scene._getMaxBaxValue( sGraphData.aValuePos ) - 1
		If dblTempPos > sGraphicsData.dblMaxPos Then
			sGraphicsData.dblMaxPos  = dblTempPos
		End If
'Scene.dbgOutput(1, "readGraphicsData(): ", "....[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")

		' add group to graphics
		sGraphicsData.aGroup.Push( sGraphData )
	Next
	fMaxVizValue = sGlobalParameter.dblMaxVizValueUMKV
	Scene.dbgOutput(1, strDebugLocation, "[fMaxVizValue] [fMaxBarValue]: ["	& fMaxVizValue & "] [" & fMaxBarValue & "]" )

	' print data
	dumpData()
'	println fMaxBarValue
'	println sGraphicsData.dblMaxPos
	
	'Manus Fix Max Value
	If sGraphicsData.dblMaxValue = 0 Then
		sGraphicsData.dblMaxValue = fMaxBarValue
	End If
	
	
	'Manus Fix Value 80 Problem
'	If sGraphicsData.dblMaxValue = 80 Then
'		sGraphicsData.dblMaxValue = fMaxBarValue + 1
'	End If
	'End Manu
	
End Sub
'-------------------------------------------------------------------------------
'
Sub dumpData()
	Dim strDebugLocation As String = strScriptName & "dumpData():"
	Dim iGroup, iElement As Integer

	Scene.dbgOutput(1, strDebugLocation, "start... [sGraphicsData]----------------------------------------")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.nGroups]: [" & sGraphicsData.nGroups & "]")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.dblMinValue]: [" & sGraphicsData.dblMinValue & "]")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.dblMaxValue]: [" & sGraphicsData.dblMaxValue & "]")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.dblMaxPos]: [" & sGraphicsData.dblMaxPos & "]")

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGraphLabel[" & iGroup & "]]: [" & sGraphicsData.aGraphLabel[iGroup] & "]")

		Scene.dbgOutput(1, strDebugLocation, "printing [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].nElements]: [" & sGraphicsData.aGroup[iGroup].nElements & "]")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].strMaterial]: [" & sGraphicsData.aGroup[iGroup].strMaterial & "]")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].strAnimOrderFlag]: [" & sGraphicsData.aGroup[iGroup].strAnimOrderFlag & "]")
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "printing [iElement]: [" & iElement & "] ..................................................")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValuePos[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValuePos[iElement] & "]")
		Next
		
	Next

	Scene.dbgOutput(1, strDebugLocation, "....done [sGraphicsData]----------------------------------------")
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim contGroup, contElement, contLabel As Container
	Dim tmpGroupName, tmpElementName, tmpString As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValueX, dblValueY As Double
	Dim strValueX, strValueY As String 	
	Dim iGroup, iElement, iLabel, nLabels As Integer

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' set visibility of info percent label
	contBlenderElementIN.FindSubcontainer( kTransSubPath & kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

	' set graph labels
	If sGraphicsData.aGraphLabel.UBound = 0 Then
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Active = FALSE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[0]
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Active = FALSE
	ElseIf sGraphicsData.aGraphLabel.UBound = 1 Then
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[0]
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Active = FALSE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[1]
	ElseIf sGraphicsData.aGraphLabel.UBound = 2 Then
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[0]
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[1]
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Active = TRUE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Geometry.Text = sGraphicsData.aGraphLabel[2]
	Else
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText1SubPath ).Active = FALSE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText2SubPath ).Active = FALSE
		contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupLabelSubPath & kLabelText3SubPath ).Active = FALSE
	End If
	
	' process group data
	Dim contGraph As Container

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup+1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = TRUE

		' set material of graph 
		Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].strMaterial & "]")
		tmpMaterial = contGroup.FindSubContainer("$obj_graph").CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].strMaterial )
		contGroup.FindSubContainer("$obj_graph").Material = tmpMaterial

		' add animation index to playout control - take settings from first group
		Scene._PlayoutAnimationAdd( contGroup, sGraphicsData.aGroup[iGroup].strAnimOrderFlag )
		Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contGroup.Name & "] [" & sGraphicsData.aGroup[iGroup].strAnimOrderFlag & "]")

		contGraph = contGroup.FindSubcontainer( "$obj_graph" )

		nLabels = 1

		' reset string values
		strValueX = ""
		strValueY = ""
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1 
			' calc x value
''''			dblValueX = CDbl( sGraphicsData.aGroup[iGroup].aValuePos[iElement] ) 
			dblValueX = CDbl( sGraphicsData.aGroup[iGroup].aValuePos[iElement] ) - 1
			dblValueX = dblValueX * kMaxVizWidthUMKV / sGraphicsData.dblMaxPos 
'			strValueX = strValueX & CStr(dblValueX) & "," _______________________________ORIGINAL WITH COMMA
			strValueX = strValueX & DoubleToString(dblValueX, 4) & "|"
'			contGraph.Geometry.SetParameterDouble( "X" & CStr(iElement), dblValueX )
'			println "[iGroup] [sGraphicsData.aGroup[0].aValueNum[" & iElement-1 & "]] [dblValue]: ["	& contGraph.name & "] [" & contGraph.vizID & "] [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "] [" & dblValueX & "]++++++++++++++++"
			' calc y value
			dblValueY = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
'			println "[dblValueY] [sGlobalParameter.dblMaxVizValueGraphHeight] [sGraphicsData.dblMinValue] [sGraphicsData.dblMaxValue]: [" & dblValueY & "] [" & sGlobalParameter.dblMaxVizValueGraphHeight & "] [" & sGraphicsData.dblMinValue & "] [" & sGraphicsData.dblMaxValue & "]"
			dblValueY = dblValueY * sGlobalParameter.dblMaxVizValueUMKV / ( sGraphicsData.dblMaxValue - sGraphicsData.dblMinValue )
'			contGraph.Geometry.SetParameterDouble( "Y" & CStr(iElement), dblValueY )
'			strValueY = strValueY & CStr(dblValueY) & "," _______________________________ORIGINAL WITH COMMA
			strValueY = strValueY & DoubleToString(dblValueY, 4) & "|"
'			println "[iGroup] [sGraphicsData.aGroup[0].aValueNum[" & iElement-1 & "]] [dblValue]: ["	& contGraph.name & "] [" & contGraph.vizID & "] [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "] [" & dblValueY & "]++++++++++++++++"
			contGraph.FindKeyframeOfObject("$k_end").FloatValue = kMaxVizWidthUMKV
'			' update graph label
			If iElement = 0 Then
				contGroup.FindSubContainer("$LABEL_L$TYPO$txt_value").Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				If sGraphicsData.aGroup[iGroup].aValueTxt[iElement] <> "" Then
					contGroup.FindSubContainer("$LABEL_L$TYPO$txt_unit").Active = TRUE
				Else
					contGroup.FindSubContainer("$LABEL_L$TYPO$txt_unit").Active = FALSE
				End If
			ElseIf iElement = sGraphicsData.aGroup[iGroup].nElements-1 Then
				contGroup.FindSubContainer("$LABEL_R$TYPO$txt_value").Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				If sGraphicsData.aGroup[iGroup].aValueTxt[iElement] <> "" Then
					contGroup.FindSubContainer("$LABEL_R$TYPO$txt_unit").Active = TRUE
				Else
					contGroup.FindSubContainer("$LABEL_R$TYPO$txt_unit").Active = FALSE
				End If
			ElseIf sGraphicsData.aGroup[iGroup].aValueTxt[iElement].EndsWith("*") Then
				contLabel = contGroup.FindSubContainer("$LABEL_M$LABEL_" & CStr(nLabels) )
				contLabel.Active = TRUE
				
				tmpString = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				tmpString.Substitute("[*]", "", TRUE)
				contLabel.FindSubContainer("$TYPO$txt_value").Geometry.Text = tmpString
				nLabels = nLabels + 1
			End If
			
			
			
			
		Next


		' update vizualdatatool graph
		
		contGraph.Geometry.SetParameterString( "DataX", strValueX )
		contGraph.Geometry.SetParameterString( "DataY", strValueY )
		
		For iLabel = nLabels To 4 
			contGroup.FindSubContainer("$LABEL_M$LABEL_" & CStr(iLabel) ).Active = False
		Next

		'********************************************************
		' INGO: Schubsen der Label
		' Aufruf des Unterprogramms
		'********************************************************
		' Wenn etwas in Label2 steht -> Linkes Label anpassen
		if sGraphicsData.aGroup[iGroup].aLabel2[0] <> "" then
			setLabelPosIngo( iGroup, "L", Cint(sGraphicsData.aGroup[iGroup].aLabel2[0]) ) 
		end if		
		' Wenn etwas in Label3 steht -> Rechtes Label anpassen
		if sGraphicsData.aGroup[iGroup].aLabel3[0] <> "" then
			setLabelPosIngo( iGroup, "R", Cint(sGraphicsData.aGroup[iGroup].aLabel3[0]) ) 
		end if	
		'********************************************************

	Next

	' hide rest graphs
	For iGroup = sGraphicsData.nGroups + 1 To nMaxNumGraphs
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup+1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = FALSE
	Next
	
End Sub
'-------------------------------------------------------------------------------
'
Sub	setGraphLabelPosXY()
	Dim strDebugLocation As String = strScriptName & "setGraphLabelPosXY():"
	Dim contGroup, contElement, contLabel As Container
	Dim tmpGroupName, tmpElementName, tmpString As String
	Dim dblValueX, dblValueY As Double
	Dim iGroup, iElement, iLabel, nLabels As Integer

	' process group data
	Dim contGraph As Container

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup+1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = TRUE

		contGraph = contGroup.FindSubcontainer( "$obj_graph" )

		nLabels = 1
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements
			' calc x value
''''			dblValueX = CDbl( sGraphicsData.aGroup[iGroup].aValuePos[iElement] )
			dblValueX = CDbl( sGraphicsData.aGroup[iGroup].aValuePos[iElement] ) - 1
			dblValueX = dblValueX * kMaxVizWidthUMKV / sGraphicsData.dblMaxPos 
			' calc y value
			dblValueY = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
'			println "[dblValueY] [sGlobalParameter.dblMaxVizValueGraphHeight] [sGraphicsData.dblMinValue] [sGraphicsData.dblMaxValue]: [" & dblValueY & "] [" & sGlobalParameter.dblMaxVizValueGraphHeight & "] [" & sGraphicsData.dblMinValue & "] [" & sGraphicsData.dblMaxValue & "]"
			dblValueY = dblValueY * sGlobalParameter.dblMaxVizValueUMKV / ( sGraphicsData.dblMaxValue - sGraphicsData.dblMinValue )
'			' update graph label
			If iElement = 0 Then
				contGroup.FindSubContainer("$LABEL_L").Position.Y = 17.0 + dblValueY * (150.0 - 15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
			ElseIf iElement = sGraphicsData.aGroup[iGroup].nElements-1 Then
				contGroup.FindSubContainer("$LABEL_R").Position.Y = 17.0 + dblValueY * (150.0 - 15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
			ElseIf sGraphicsData.aGroup[iGroup].aValueTxt[iElement].EndsWith("*") Then
				contLabel = contGroup.FindSubContainer("$LABEL_M$LABEL_" & CStr(nLabels) )
				contLabel.Active = TRUE
				' set position
				contLabel.Position.X = dblValueX * 400 / kMaxVizWidthUMKV -10
				contLabel.Position.Y = 17.0 + dblValueY * (150.0 - 15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
				
				tmpString = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				tmpString.Substitute("[*]", "", TRUE)
				nLabels = nLabels + 1
			End If
		Next
		For iLabel = nLabels To 4 
			contGroup.FindSubContainer("$LABEL_M$LABEL_" & CStr(iLabel) ).Active = False
		Next
	Next

End Sub

'********************************************************
' INGO: Schubsen der Label
' Das Unterprogramm
'********************************************************
Sub	setLabelPosIngo(whichGroup As Integer, whichLabel As String, offset As Integer)
	Dim contGroup, contElement, contLabel As Container
	Dim tmpGroupName, tmpElementName, tmpString As String
	Dim dblValueY As Double

	' process group data
	Dim contGraph As Container

	' get reference to group container
	tmpGroupName = kGroupBaseName & CStr( whichGroup + 1 )
	contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
	contGroup.Active = TRUE

	contGraph = contGroup.FindSubcontainer( "$obj_graph" )

	' calc y value
	if whichLabel = "L" then
		'Y-Pos für ersten Wert berechnen
		dblValueY = CDbl( sGraphicsData.aGroup[whichGroup].aValueNum[0] )
	else 
		'Y-Pos für letzten Wert berechnen
		dblValueY = CDbl( sGraphicsData.aGroup[whichGroup].aValueNum[sGraphicsData.aGroup[whichGroup].nElements-1] )
	end if	
	' Verrechnen mit glbalen Parametern und Min/Max
	dblValueY = dblValueY * sGlobalParameter.dblMaxVizValueUMKV / ( sGraphicsData.dblMaxValue - sGraphicsData.dblMinValue )
	' Label verschieben
	contGroup.FindSubContainer("$LABEL_" & whichLabel).Position.Y = (17.0 + dblValueY * (150.0 - 15.0) / sGlobalParameter.dblMaxVizValueGraphHeight) + offset

End Sub
'********************************************************


'-------------------------------------------------------------------------------
'
Sub	setGraphLabelPerc()
	Dim strDebugLocation As String = strScriptName & "setGraphLabelPerc():"
	Dim contGroup As Container
	Dim tmpGroupName As String
	Dim tmp As Container
	Dim start_cont As Container
	Dim geom_uuid As String
	Dim iGroup As Integer
	Dim XwithPerc As Double = -8.7
	Dim YwithPerc As Double = -28.7
	Dim XwithoutPerc As Double = -2.4
	Dim YwithoutPerc As Double = -26.0

	' process group data
	Dim contGraph As Container

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup + 1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = TRUE

		contGraph = contGroup.FindSubcontainer( "$obj_graph" )
		
		'Wenn Container nicht umbenamt ist, sind die Prozente an
		If contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kUnitSubPath).Name = kUnitSubName then
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kUnitSubPath).Active = False
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kTextSubPath).Position.X = XwithoutPerc
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kTextSubPath).Position.Y = YwithoutPerc
			'Container umbenennen
			System.SendCommand( "#" & contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kUnitSubPath).VizID & "*NAME SET " & kUnitSubNameRen )
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kUnitSubPath).Active = False
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kTextSubPath).Position.X = XwithoutPerc
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kTextSubPath).Position.Y = YwithoutPerc
			'Container umbenennen
			System.SendCommand( "#" & contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kUnitSubPath).VizID & "*NAME SET " & kUnitSubNameRen )
		Else 
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kUnitSubPathRen).Active = True
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kTextSubPath).Position.X = XwithPerc
			contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kTextSubPath).Position.Y = YwithPerc
			'Container umbenennen
			System.SendCommand( "#" & contGroup.FindSubContainer("$LABEL_L" & kTypoSubPath & kUnitSubPathRen).VizID & "*NAME SET "& kUnitSubName )
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kUnitSubPathRen).Active = True
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kTextSubPath).Position.X = XwithPerc
			contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kTextSubPath).Position.Y = YwithPerc
			'Container umbenennen
			System.SendCommand( "#" & contGroup.FindSubContainer("$LABEL_R" & kTypoSubPath & kUnitSubPathRen).VizID & "*NAME SET "& kUnitSubName )
		End If						

	Next

	start_cont = Scene.FindContainer("moBLENDER").FindSubContainer("IN")
	tmp = start_cont.FindSubContainer("ELEMENT")
	'UUID der Geometrie (enthält Name und eindeutige Zuordung im DB-Pfad
	geom_uuid = tmp.Geometry.Uuid.FullString
	'Splitten und Mergen - braucht man damit eine Veränderung erkannt wird und der Speicherprozess möglich ist
'	System.SendCommand( "#" & tmp.vizID & "*GEOM SPLIT 1" )
	'System.SendCommand( "#" & tmp.vizID & "*GEOM MERGE 1" )

	'Geometrie abspeichern 
	System.SendCommand( "GEOM SAVE_TO_DATABASE GEOM*#" & tmp.Geometry.vizID & " " & geom_uuid )
	'Geometrie neu laden
	System.SendCommand( "GEOM*#" & tmp.Geometry.vizID & "*POOL_LOCATION DEACTIVATE")
	tmp.DeleteGeometry()
	tmp.CreateGeometry(geom_uuid)
End Sub
'-------------------------------------------------------------------------------









