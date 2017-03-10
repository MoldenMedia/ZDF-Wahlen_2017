'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "01.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "UMFRAGE: Kurven - moPlayoutUMKV_v00"
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
Dim kGroupLabelBasePath      As String = "$GFX_ELE$TRANS$GFX_ELE_"
Dim kDataSubPath             As String = "$DATA"
Dim kGroupTextSubPath        As String = "$txt_text"

'Dim kBar1SubPath             As String = "$TRANS$G1_E1$DATA"
'Dim kBar2SubPath             As String = "$TRANS$G1_E2$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"
Dim kBarColoredSubPathMirror As String = "$obj_geom_mirror"
Dim kArrowSubPath            As String = "$TRANS$ELE_ARROW"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"

Dim nMaxNumGraphs            As Integer = 5

Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj1Mirror As Container
Dim contBarObj2, contBarObj2Mirror As Container

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structGroupData
	strLabel       As String
	nElements      As Integer
	aMaterial      As Array[String]
	aValueNum      As Array[String]
	aValueTxt      As Array[String]
	aAnimOrderFlag As Array[String]
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName As String
	nGroups     As Integer
	aGroup      As Array[structGroupData]
	dblMinValue As Double
	dblMaxValue As Double
End Structure
'-------------------------------------------------------------------------------
Dim sGroupData    As structGroupData
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
	RegisterParameterString("theElementName", "element name [gUMKV]:", "/UMFRAGE/gUMKV", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [5#5#5#5#5#5]:", "5#5#5#5#5#5", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "Juli#August#September#Oktober I#Oktober II#November", 75, 256, "")
'	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "lab1lin1|lab2lin1|lab3lin1|lab4lin1|lab5lin1|lab6lin1|lab7lin1|lab8lin1", 55, 256, "")
'	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "12|22||42||||", 55, 256, "")
'	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "13|23||||||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [39|36|15#...]:", "40|30|15|8|5#41|31|17|8|5#39|29|14|10|4#42|32|14|10|4#38|28|14|9|3#43|33|16|9|5", 75, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [39|36|15#...]:", "40|30|15|8|5#41|31|17|8|5#39|29|14|10|4#42|32|14|10|4#38|28|14|9|3#43|33|16|9|5", 75, 256, "")
'	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4|-3.4|3.7|1.3|0.1|3.9|-3.6", 55, 256, "")
'	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-5,0|-3,4|+3,7|+1,3|+0,1|+3,9|-3,6", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2|3|4|5|6#1|2|3|4|5|6#1|2|3|4|5|6#1|2|3|4|5|6#1|2|3|4|5|6#1|2|3|4|5|6", 75, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu|spd|gruene|linke|fdp#cdu|spd|gruene|linke|fdp#cdu|spd|gruene|linke|fdp#cdu|spd|gruene|linke|fdp#cdu|spd|gruene|linke|fdp#cdu|spd|gruene|linke|fdp", 75, 300, "")

	RegisterParameterString("theRangeValues", "min/max values [0|45]:", "0|45", 25, 55, "")
	
	RegisterPushButton("btAssignValues", "assign values", 11)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btAssignValuesDirect", "assign values direct", 21)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btSetLabelPosY", "set label posY", 31)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Scene.dbgRegisterFunction( strScriptName )
	
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderElementOUT = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")
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
		setGraphLabelPosY()
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readGraphicsData()
	Dim strDebugLocation As String = strScriptName & "readGraphicsData():"
	Dim strTemp As String
	Dim aGroupLabList, aGroupEleList, aRangeValues As Array[String]
	Dim aEleMaterial, aEleValueNum, aEleValueTxt As Array[String]
	Dim aEleAnimOrder As Array[String]
	Dim iGroup, nMaxLabel As Integer
	Dim dblTempValue As Double

'	sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]
	sGlobalParameter = Scene.sGlobalParameter

	fMaxVizValue = sGlobalParameter.dblMaxVizValueHRPZ 
	fLabelHeight = sGlobalParameter.dblMaxVizValueHRLabHeight 
	
	' get min/max values
	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strElementSeparator, aRangeValues )
	sGraphicsData.dblMinValue = CDbl( aRangeValues[0] )
	sGraphicsData.dblMaxValue = CDbl( aRangeValues[1] )
	' get group data
	strTemp = GetParameterString("theNumElements")
	strTemp.Split( strGroupSeparator, aGroupEleList )
	strTemp = GetParameterString("theGroupLabel")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aGroupLabList )
	strTemp = GetParameterString("theMaterial")
	strTemp.Split( strGroupSeparator, aEleMaterial )
	strTemp = GetParameterString("theValueNum")
	strTemp.Split( strGroupSeparator, aEleValueNum )
	strTemp = GetParameterString("theValueTxt")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleValueTxt )
	strTemp = GetParameterString("theAnimOrderFlag")
	strTemp.Split( strGroupSeparator, aEleAnimOrder )

	sGraphicsData.nGroups = aGroupEleList.UBound
	
	nMaxLabel = 0 
	fMaxBarValue = 0.0
	' read group and element details
	sGraphicsData.aGroup.Clear()
	For iGroup = 0 To sGraphicsData.nGroups
	
		Scene.dbgOutput( 1, strDebugLocation, "reading data of [iGroup]: [" & iGroup & "]" )
		sGroupData.nElements = CInt( aGroupEleList[ iGroup ] )
		sGroupData.strLabel  = aGroupLabList[ iGroup ]

		aEleMaterial[iGroup].Split( strElementSeparator, sGroupData.aMaterial )
		aEleValueNum[iGroup].Split( strElementSeparator, sGroupData.aValueNum )
		aEleValueTxt[iGroup].Split( strElementSeparator, sGroupData.aValueTxt )
		aEleAnimOrder[iGroup].Split( strElementSeparator, sGroupData.aAnimOrderFlag )
		
		dblTempValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
		If dblTempValue > fMaxBarValue Then
			fMaxBarValue = dblTempValue
		End If
		
'Scene.dbgOutput(1, "readGraphicsData(): ", "....[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next
	fMaxVizValue = sGlobalParameter.dblMaxVizValueHRPZ - (nMaxLabel-1)*sGlobalParameter.dblMaxVizValueHRLabHeight
	Scene.dbgOutput(1, strDebugLocation, "[fMaxVizValue] [fMaxBarValue]: ["	& fMaxVizValue & "] [" & fMaxBarValue & "]" )
	' print data
	dumpData()

End Sub
'-------------------------------------------------------------------------------
'
Sub dumpData()
	Dim strDebugLocation As String = strScriptName & "dumpData():"
	Dim iGroup, iElement As Integer

	Scene.dbgOutput(1, strDebugLocation, "start... [sGraphicsData]----------------------------------------")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.nGroups]: [" & sGraphicsData.nGroups & "]")

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "printing [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].strLabel]: [" & sGraphicsData.aGroup[iGroup].strLabel & "]")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].nElements]: [" & sGraphicsData.aGroup[iGroup].nElements & "]")
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "printing [iElement]: [" & iElement & "] ..................................................")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aMaterial[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aAnimOrderFlag[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
		Next
		
	Next

	Scene.dbgOutput(1, strDebugLocation, "....done [sGraphicsData]----------------------------------------")
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim contGroup, contElement, contLabel As Container
	Dim tmpGroupName, tmpElementName As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue As Double
	Dim iGroup, iElement As Integer

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup+1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = TRUE
		' update group label
		contLabel = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupLabelBasePath & CStr(iGroup+1) & kGroupTextSubPath )
		contLabel.Geometry.Text = sGraphicsData.aGroup[iGroup].strLabel

		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1	

			' !! works but faulty !!
			If iGroup = iElement Then
				' set material of graph 
				Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[0].aMaterial[iElement] & "]")
				tmpMaterial = contGroup.FindSubContainer("$obj_graph").CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[0].aMaterial[iElement] )
				contGroup.FindSubContainer("$obj_graph").Material = tmpMaterial

				' add animation index to playout control - take settings from first group
				Scene._PlayoutAnimationAdd( contGroup, sGraphicsData.aGroup[0].aAnimOrderFlag[iElement] )
				Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contGroup.Name & "] [" & sGraphicsData.aGroup[0].aAnimOrderFlag[iElement] & "]")
			End If

		Next

	Next

	Dim i As Integer	
	Dim contGraph, contGraphBase As Container
	For i = 1 To nMaxNumGraphs
		contGraphBase = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupBaseName & CStr(i) )
		contGraph = contGraphBase.FindSubcontainer( "$obj_graph" )
		println "[i] [contGraph.name]: ["	 & i & "] [" & contGraph.name & "]-----------------------------------------------------"
		For iGroup = 0 To sGraphicsData.nGroups
	'		For iElement = 0 To sGraphicsData.aGroup[0].nElements - 1
				dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[i-1] )
				println "[dblValue] [sGlobalParameter.dblMaxVizValueGraphHeight] [sGraphicsData.dblMinValue] [sGraphicsData.dblMaxValue]: [" & dblValue & "] [" & sGlobalParameter.dblMaxVizValueGraphHeight & "] [" & sGraphicsData.dblMinValue & "] [" & sGraphicsData.dblMaxValue & "]"
				dblValue = dblValue * sGlobalParameter.dblMaxVizValueGraphHeight / ( sGraphicsData.dblMaxValue - sGraphicsData.dblMinValue )
				contGraph.Geometry.SetParameterDouble( "Y" & CStr(iGroup), dblValue )
				println "[iGroup] [i] [sGraphicsData.aGroup[0].aValueNum[" & i-1 & "]] [dblValue]: ["	& contGraph.name & "] [" & contGraph.vizID & "] [" & sGraphicsData.aGroup[iGroup].aValueNum[i-1] & "] [" & dblValue & "]++++++++++++++++"
				
				' update graph label
				If iGroup = 0 Then
					contGraphBase.FindSubContainer("$LABEL_L$TYPO$txt_value").Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[i-1]
					If sGraphicsData.aGroup[iGroup].aValueTxt[i-1] <> "" Then
						contGraphBase.FindSubContainer("$LABEL_L$TYPO$txt_unit").Active = TRUE
					Else
						contGraphBase.FindSubContainer("$LABEL_L$TYPO$txt_unit").Active = FALSE
					End If
				ElseIf iGroup = sGraphicsData.nGroups Then
					contGraphBase.FindSubContainer("$LABEL_R$TYPO$txt_value").Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[i-1]
					If sGraphicsData.aGroup[iGroup].aValueTxt[i-1] <> "" Then
						contGraphBase.FindSubContainer("$LABEL_R$TYPO$txt_unit").Active = TRUE
					Else
						contGraphBase.FindSubContainer("$LABEL_R$TYPO$txt_unit").Active = FALSE
					End If
				Else
					contGraphBase.FindSubContainer("$LABEL_M$LABEL_" & CStr(iGroup) & "$TYPO$txt_value").Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[i-1]
				End If
	'		Next
		Next
	Next


	' hide rest graphs
	For iGroup = sGraphicsData.aGroup[0].nElements To nMaxNumGraphs
		' get reference to group container
		tmpGroupName = kGroupBaseName & CStr( iGroup+1 )
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & tmpGroupName )
		contGroup.Active = FALSE
	Next
	
End Sub
'-------------------------------------------------------------------------------
'
Sub	setGraphLabelPosY()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim cntIdx As Integer
	Dim dblValue As Double
	Dim iGroup, iElement As Integer
	Dim contWork As Container

	Dim i As Integer	
	Dim contGraph, contGraphBase As Container
	For i = 1 To nMaxNumGraphs
		contGraphBase = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupGfxGraphSubPath & kGroupBaseName & CStr(i) )
		contGraph = contGraphBase.FindSubcontainer( "$obj_graph" )
		println "[i] [contGraph.name]: ["	 & i & "] [" & contGraph.name & "]-----------------------------------------------------"
		For iGroup = 0 To sGraphicsData.nGroups
			dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[i-1] )
			println "[dblValue] [sGlobalParameter.dblMaxVizValueGraphHeight] [sGraphicsData.dblMinValue] [sGraphicsData.dblMaxValue]: [" & dblValue & "] [" & sGlobalParameter.dblMaxVizValueGraphHeight & "] [" & sGraphicsData.dblMinValue & "] [" & sGraphicsData.dblMaxValue & "]"
			dblValue = dblValue * sGlobalParameter.dblMaxVizValueGraphHeight / ( sGraphicsData.dblMaxValue - sGraphicsData.dblMinValue )
			
 				' update graph label
			If iGroup = 0 Then
				contGraphBase.FindSubContainer("$LABEL_L").Position.Y = 17.0 + dblValue * (150.0 -15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
			ElseIf iGroup = sGraphicsData.nGroups Then
				contGraphBase.FindSubContainer("$LABEL_R").Position.Y = 17.0 + dblValue * (150.0 -15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
			Else
				contGraphBase.FindSubContainer("$LABEL_M$LABEL_" & CStr(iGroup)).Position.Y = 17.0 + dblValue * (150.0 -15.0) / sGlobalParameter.dblMaxVizValueGraphHeight
			End If
		Next
	Next
End Sub
'-------------------------------------------------------------------------------
'
' 150 / 15

