'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "07.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "HOCHRECHNUNG: Sitzverteilung - moPlayoutHRSVS1_v00"
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strPieSeparator     As String = "@"
Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

'Dim fMaxVizValue As Double = 150.0
'Dim fMaxBarValue As Double = 100.0
Dim fMaxVizValue As Double = 180.0
Dim fMaxBarValue As Double 
Dim fLabelHeight As Double = 3.5

'-Dim fGlobPieLabelLinesPosY As Double

' container definitions
Dim contElementPool As Container
Dim contBlenderElementIN  As Container
Dim contBlenderElementOUT As Container

'Dim cont

Dim sGlobalParameter As Scene.structGlobalParameter
'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------
Dim kMaxElementInGroup       As Integer = 7
Dim kMaxLabelWidth           As Double = 446.50

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredGeomSubPath   As String = "$TRANS$obj_geom"
Dim kBarColoredSubPath       As String = "$TRANS$obj_geom"

' sample path: [kLabelBaseSubPath & kLabelSVSubPath & kLabelPlusSubPath & kLabelBigSubPath & kLabelBigLineBase & iCnt]
Dim kLabelBaseSubPath        As String = "$LABELS"
Dim kLabelSVSubPath          As String = "$LABEL_SV"
Dim kLabelSVTopSubPath       As String = "$LABEL_SV_TOPV"
Dim kLabelPlusSubPath        As String = "$LABEL_PLUS"
Dim kLabelDiffSubPath        As String = "$LABEL_DIFF"
Dim kLabelSubPath            As String = "$LABEL_TRANS"
Dim kLabelLineBase           As String = "$LABEL_PB"

Dim kLabelSummarySubPath     As String = "$LABEL_SUMMARY"
Dim kSummaryWertSubPath      As String = "$TYPO_SUMMARY$txt_wert"
Dim kMajorityWertSubPath     As String = "$TYPO_MAJORITY$txt_wert"

Dim kMarkerBaseSubPath       As String = "$MARKER"

Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj2 As Container
'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structGroupData
	strLabel           As String
	nElements          As Integer
	aLabel1            As Array[String]
	aLabel2            As Array[String]
	aLabel3            As Array[String]
	aLabel4            As Array[String]
	aMaterial          As Array[String]
	aValueNum          As Array[String]
	aValueTxt          As Array[String]
	aDiffNum           As Array[String]
	aDiffTxt           As Array[String]
	aAnimOrderFlag     As Array[String]
	aAnimDirectionFlag As Array[String]
	aTypeOfLabel       As Array[String]
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName      As String
	strTypeOfGraphic As String
	nGroups          As Integer
	fTotalPieValue   As Double
	aGroup           As Array[structGroupData]
	nBigLabel        As Integer
	nSmallLabel      As Integer
	strSitzeGesamt   As String
	strSitzeMehreit  As String
	aMarkerFlag      As Array[String]
End Structure
'-------------------------------------------------------------------------------
Dim sGroupData     As structGroupData
Dim aGraphicsData  As Array[structGraphicsData]
Dim gBlnShowLabels As Boolean
Dim gBlnColoredLabels As Boolean
'-------------------------------------------------------------------------------
Dim aaString As Array[Array[String]]
'-------------------------------------------------------------------------------
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
	
	RegisterParameterString("theTypeOfGraphic", "type of graphic [HRSVS1|HRSVS1PD]:", "HRSVS", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gHRSVS1]:", "HOCHRECHNUNG/gHRSVS1", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [1..7#1..7]:", "5@6", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "CDUCSU|SPD|FDP|Linke|ÖDP@CDUCSU|SPD|FDP|Linke|ÖDP|REP", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "||||@|||||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "||||@|||||", 55, 256, "")
	RegisterParameterString("theLabel4", "label line 4 [CDU/CSU|SPD#...]:", "||||@|||||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "63|57|51|42|33@63|57|51|42|33|22", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "63|57|51|42|33@63|57|51|42|33|22", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4|-3|3|1|0@-4|-3|3|1|0|3", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-4|-3|+3|+1|0@-4|-3|+3|+1|0|+3", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2|3|4|5@6|7|8|9|10|11", 55, 55, "")
	RegisterParameterString("theAnimDirectionFlag", "animation direction flags [L|R#...]:", "R|L|L|R|L@R|L|L|R|L|L", 55, 55, "")
	RegisterParameterString("thePartySizeFlag", "party size flags [B|S#...]:", "B|B|B|B|B@B|B|B|B|B|B", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu|spd|fdp|linke|oedp@cdu|spd|fdp|linke|oedp|rep", 55, 256, "")
	RegisterParameterString("theSummary", "Sitze gesamt | absol. Mehrheit:", "160|81@162|82", 55, 256, "")
	RegisterParameterString("theMarkerFlag", "Marker Flag 1, 2, 3 [1|1|0] - not assigned:", "0|0|0", 55, 10, "")
	
	RegisterParameterBool( "theColoredLabelFlag", "use colored labels", TRUE )
	
	RegisterPushButton("btAssignValues", "assign values", 11)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btAssignValuesDirect", "assign values direct", 21)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Scene.dbgRegisterFunction( strScriptName )
	
	sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]

	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderElementOUT = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")
End Sub
'-------------------------------------------------------------------------------
'
Dim cntFields As Integer = 0
Dim blnRunAnim As Boolean = FALSE
'-------------------------------------------------------------------------------
'
Sub OnExecAction(buttonId As Integer)
	Dim strDebugLocation As String = strScriptName & "OnExecAction():"
	
	Scene.dbgOutput(1, strDebugLocation, "[buttonId]: [" & buttonId & "]")
	If buttonID = 11 Then
		Scene.dbgOutput(1, strDebugLocation, "... button 11 pressed ...")
blnRunAnim = TRUE
'		readGraphicsData()
'		updateScene_assignData()
	ElseIf buttonID = 21 Then
		Scene.dbgOutput(1, strDebugLocation, "... button 21 pressed ...")
blnRunAnim = TRUE
'		readGraphicsData()
'		updateScene_assignData()
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecPerField()
	If blnRunAnim = TRUE Then
		cntFields++
		If cntFields > 5 Then
			readGraphicsData()
			updateScene_assignData()
			blnRunAnim = FALSE
			cntFields = 0
		End If
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readGraphicsData()
	Dim strDebugLocation As String = strScriptName & "readGraphicsData():"
	Dim strTemp, strValueTxt As String
	Dim aGroupLabList, aGroupEleList, aEleLabel1, aEleLabel2, aEleLabel3, aEleLabel4 As Array[String]
	Dim aEleMaterial, aEleValueNum, aEleValueTxt, aEleDiffNum, aEleDiffTxt As Array[String]
	Dim aEleAnimOrder, aEleAnimDirection, aEleTypeOfLabel, aEleSummary, aTemp, aEleMarkerFlag As Array[String]
	Dim iPie, iGroup, iElement As Integer
	Dim dblTempValue As Double
	
	Dim aPGroupLabList, aPGroupEleList, aPEleLabel1, aPEleLabel2, aPEleLabel3, aPEleLabel4 As Array[String]
	Dim aPEleMaterial, aPEleValueNum, aPEleValueTxt, aPEleDiffNum, aPEleDiffTxt As Array[String]
	Dim aPEleAnimOrder, aPEleAnimDirection, aPEleTypeOfLabel, aPEleSummary, aPTemp, aPEleMarkerFlag As Array[String]
	
	Dim sGraphicsData As structGraphicsData
	
	' colored label flag
	gBlnColoredLabels = GetParameterBool( "theColoredLabelFlag" )
	
	' get type of graphics
	sGraphicsData.strTypeOfGraphic = GetParameterString("theTypeOfGraphic")
	' get pie data
	strTemp = GetParameterString("theNumElements")
	strTemp.Split( strPieSeparator, aPGroupEleList )
	strTemp = GetParameterString("theGroupLabel")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPGroupLabList )
	strTemp = GetParameterString("theLabel1")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleLabel1 )
	strTemp = GetParameterString("theLabel2")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleLabel2 )
	strTemp = GetParameterString("theLabel3")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleLabel3 )
	strTemp = GetParameterString("theLabel4")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleLabel4 )
	strTemp = GetParameterString("theMaterial")
	strTemp.Split( strPieSeparator, aPEleMaterial )
	strTemp = GetParameterString("theValueNum")
	strTemp.Split( strPieSeparator, aPEleValueNum )
	
	
	' check for labels
	strTemp = GetParameterString("theValueTxt")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleValueTxt )
	strValueTxt = strTemp
'println "DEBUG: vorher [strValueTxt]: [" & strValueTxt & "]"	
	strValueTxt.Substitute("[|#@]", "", TRUE)
'println "DEBUG: nachher [strValueTxt]: [" & strValueTxt & "]"	
	If strValueTxt = "" Then
		gBlnShowLabels = FALSE
	Else
		gBlnShowLabels = TRUE
	End If
	
	strTemp = GetParameterString("theDiffNum")
	strTemp.Split( strPieSeparator, aPEleDiffNum )
	strTemp = GetParameterString("theDiffTxt")
	strTemp.AnsiToUTF8()
	strTemp.Split( strPieSeparator, aPEleDiffTxt )
	strTemp = GetParameterString("theAnimOrderFlag")
	strTemp.Split( strPieSeparator, aPEleAnimOrder )
	strTemp = GetParameterString("theAnimDirectionFlag")
	strTemp.Split( strPieSeparator, aPEleAnimDirection )
	strTemp = GetParameterString("thePartySizeFlag")
	strTemp.Split( strPieSeparator, aPEleTypeOfLabel )

	strTemp = GetParameterString("theSummary")
	strTemp.Split( strPieSeparator, aPEleSummary )
	
	strTemp = GetParameterString("theMarkerFlag")
	strTemp.Split( strPieSeparator, aPEleMarkerFlag )
	
	
aGraphicsData.Clear	
For iPie = 0 To 0 
	
	aPGroupEleList[iPie].Split( strGroupSeparator,  aGroupEleList )
	aPGroupLabList[iPie].Split( strGroupSeparator,  aGroupLabList )
	aPEleLabel1[iPie].Split( strGroupSeparator,  aEleLabel1 )
	aPEleLabel2[iPie].Split( strGroupSeparator,  aEleLabel2 )
	aPEleLabel3[iPie].Split( strGroupSeparator,  aEleLabel3 )
	aPEleLabel4[iPie].Split( strGroupSeparator,  aEleLabel4 )
	aPEleMaterial[iPie].Split( strGroupSeparator,  aEleMaterial )
	aPEleValueNum[iPie].Split( strGroupSeparator,  aEleValueNum )
	aPEleValueTxt[iPie].Split( strGroupSeparator,  aEleValueTxt )
	aPEleDiffNum[iPie].Split( strGroupSeparator,  aEleDiffNum )
	aPEleDiffTxt[iPie].Split( strGroupSeparator,  aEleDiffTxt )
	aPEleAnimOrder[iPie].Split( strGroupSeparator,  aEleAnimOrder )
	aPEleAnimDirection[iPie].Split( strGroupSeparator,  aEleAnimDirection )
	aPEleTypeOfLabel[iPie].Split( strGroupSeparator,  aEleTypeOfLabel )

	aPEleSummary[iPie].Split( strElementSeparator,  aEleSummary )

	aPEleMarkerFlag[iPie].Split( strElementSeparator,  sGraphicsData.aMarkerFlag )
	
	sGraphicsData.strSitzeGesamt  = aEleSummary[0]
	sGraphicsData.strSitzeMehreit = aEleSummary[1]

	sGraphicsData.nGroups = aGroupEleList.UBound
	' reset number of labels
	sGraphicsData.nBigLabel = 0
	sGraphicsData.nSmallLabel = 0
	
	sGraphicsData.fTotalPieValue = 0.0
'	fMaxBarValue = 0.0
	' read group and element details
	sGraphicsData.aGroup.Clear()
	For iGroup = 0 To sGraphicsData.nGroups
	
		Scene.dbgOutput( 1, strDebugLocation, "reading data of [iGroup]: [" & iGroup & "]" )
		sGroupData.nElements = CInt( aGroupEleList[ iGroup ] )
		sGroupData.strLabel  = aGroupLabList[ iGroup ]

		aEleLabel1[iGroup].Split( strElementSeparator, sGroupData.aLabel1 )
		aEleLabel2[iGroup].Split( strElementSeparator, sGroupData.aLabel2 )
		aEleLabel3[iGroup].Split( strElementSeparator, sGroupData.aLabel3 )
		aEleLabel4[iGroup].Split( strElementSeparator, sGroupData.aLabel4 )
		aEleMaterial[iGroup].Split( strElementSeparator, sGroupData.aMaterial )
		aEleValueNum[iGroup].Split( strElementSeparator, sGroupData.aValueNum )
		aEleValueTxt[iGroup].Split( strElementSeparator, sGroupData.aValueTxt )
		aEleDiffNum[iGroup].Split( strElementSeparator, sGroupData.aDiffNum )
		aEleDiffTxt[iGroup].Split( strElementSeparator, sGroupData.aDiffTxt )
		aEleAnimOrder[iGroup].Split( strElementSeparator, sGroupData.aAnimOrderFlag )
		aEleAnimDirection[iGroup].Split( strElementSeparator, sGroupData.aAnimDirectionFlag )
		aEleTypeOfLabel[iGroup].Split( strElementSeparator, sGroupData.aTypeOfLabel )

		' check if one element has 0 seats
		For iElement = 0 To sGroupData.aValueNum.UBound 
			If CDbl( sGroupData.aValueNum[iElement] ) < 1.0 Then
				sGroupData.aLabel1.Erase(iElement)
				sGroupData.aLabel2.Erase(iElement)
				sGroupData.aLabel3.Erase(iElement)
				sGroupData.aLabel4.Erase(iElement)
				sGroupData.aMaterial.Erase(iElement)
				sGroupData.aValueNum.Erase(iElement)
				sGroupData.aValueTxt.Erase(iElement)
				sGroupData.aDiffNum.Erase(iElement)
				sGroupData.aDiffTxt.Erase(iElement)
				sGroupData.aAnimOrderFlag.Erase(iElement)
				sGroupData.aAnimDirectionFlag.Erase(iElement)
				sGroupData.aTypeOfLabel.Erase(iElement)
				sGroupData.nElements --
				iElement --
			Else
				If sGroupData.aTypeOfLabel[iElement] = "B" Then
					sGraphicsData.nBigLabel ++
				ElseIf sGroupData.aTypeOfLabel[iElement] = "S" Then
					sGraphicsData.nSmallLabel ++
				End If
Scene.dbgOutput(1, strDebugLocation & "--------------------------------", "..[sGroupData.aTypeOfLabel[" & iElement & "]]: [" & sGroupData.aTypeOfLabel[iElement] & "]")
'println "..[sGroupData.aTypeOfLabel[" & iElement & "]]: [" & sGroupData.aTypeOfLabel[iElement] & "]"
			End If
		Next
		
Scene.dbgOutput(1, strDebugLocation & "--------------------------------", "..[sGraphicsData.nBigLabel] [sGraphicsData.nSmallLabel]: [" & sGraphicsData.nBigLabel & "] [" & sGraphicsData.nSmallLabel & "]")
'Scene.dbgOutput(1, "readGraphicsData(): ", "..[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")
		aEleLabel1[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel2[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel3[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel4[iGroup].Substitute("[|]", "", TRUE)

		' get sum of all values in groups
		sGraphicsData.fTotalPieValue += Scene._calcSumOfValue( sGroupData.aValueNum, sGroupData.nElements )
		Scene.dbgOutput(1, strDebugLocation, "[fMaxBarValue]: [" & fMaxBarValue & "]" )

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	fMaxVizValue = sGlobalParameter.dblMaxVizValueHRSV
	Scene.dbgOutput(1, strDebugLocation, "[fMaxVizValue] [fMaxBarValue]: ["	& fMaxVizValue & "] [" & fMaxBarValue & "]" )
	
	' print data
'	dumpData( sGraphicsData )

aGraphicsData.Push( sGraphicsData )
Next

End Sub
'-------------------------------------------------------------------------------
'
Sub dumpData( sGraphicsData As structGraphicsData )
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
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel1[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel1[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel2[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel2[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel3[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel3[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel4[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel4[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aMaterial[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aDiffNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aDiffNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aDiffTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aDiffTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aAnimOrderFlag[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aAnimDirectionFlag[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] & "]")
		Next
		
	Next

	Scene.dbgOutput(1, strDebugLocation, "....done [sGraphicsData]----------------------------------------")
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim contPie, contGroup, contElement, contWork As Container
	Dim tmpGroupName, tmpElementName, strTemp As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue, dblStart, dblStartLeft, dblStartRight, dblLabelDistance, dblLabelPosX As Double
	Dim iPie, iGroup, iElement, cntLeft, cntRight As Integer
	Dim aEleValueLabel As Array[String]
	Dim cntSLbl, cntBLbl, iCnt As Integer
	Dim strLabelPDSubPath As String
	Dim sGraphicsData As structGraphicsData

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

'- update 07.03.2017 -> define this value as global constant
	dblLabelDistance = 89.3

For iPie = 0 To 0

sGraphicsData = aGraphicsData[iPie]

	' used for pie offset rotation
	dblStart      = 0.0
	dblStartLeft  = 0.0
	dblStartRight = 0.0
	' used for pie label position
	cntLeft  = 0
	cntRight = 0
	' counter for labels
	cntBLbl = 1
	cntSLbl = 1
	' get base pie container
	contPie = contBlenderElementIN.FindSubcontainer( "$PIE_" & CStr(iPie+1) )

	' check for difference labels
	If sGraphicsData.strTypeOfGraphic = "HRSVS1PD" Then
		strLabelPDSubPath = kLabelDiffSubPath
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & kLabelPlusSubPath ).Active = FALSE
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & kLabelDiffSubPath ).Active = TRUE
	Else
		strLabelPDSubPath = kLabelPlusSubPath
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & kLabelPlusSubPath ).Active = TRUE
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & kLabelDiffSubPath ).Active = FALSE
	End If

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		tmpGroupName = kGroupBaseName & iGroup+1
		contGroup = contPie.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "[contGroup.Name]: [$" & contPie.Name & "$PIE_" & CStr(iPie+1) & kTransSubPath & tmpGroupName & "]")
				
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container and set active
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kDataSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [$" & contGroup.Name & kDataSubPath & tmpGroupName & tmpElementName & "]")
			contElement.Active = TRUE

			' calculate and set animation value
			dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
			dblValue = dblValue * fMaxVizValue / sGraphicsData.fTotalPieValue

			If sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "L" Then
				dblStart = dblStartLeft
				strTemp = "*EXPERT*MIRROR SET MIRROR_NONE"
				' calc label positionX
				dblLabelPosX = cntLeft * dblLabelDistance
				cntLeft++
			ElseIf sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "R" Then
				dblStart = dblStartRight
				strTemp = "*EXPERT*MIRROR SET MIRROR_X"
				' calc label positionX
				dblLabelPosX = kMaxLabelWidth - (cntRight * dblLabelDistance)
				cntRight++
			End If

println "DEBUG: [sGraphicsData.aGroup[iGroup].aTypeOfLabel[iElement]] [dblStart] [dblLabelPosX]: [" & sGraphicsData.aGroup[iGroup].aTypeOfLabel[iElement] & "] [" & dblStart & "] [" & dblLabelPosX & "]"

			contElement.FindSubContainer( kTransSubPath ).Rotation.Z = dblStart
			System.SendCommand( "#" & contElement.FindSubContainer( kTransSubPath ).vizID & strTemp )
			Scene.dbgOutput(1, strDebugLocation, "[animDirFlag] [dblValue] [dblStartLeft] [dblStartRight] [dblStart]: [" & sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] & "] [" & dblValue & "] [" & dblStartLeft & "] [" & dblStartRight & "] [" & dblStart & "]" )
			
'contElement.FindSubContainer( kBarColoredSubPath & CStr(iSlice) ).Active = TRUE
    		contElement.FindSubContainer( kBarColoredSubPath ).FindKeyframeOfObject("k_end").FloatValue = dblValue

			' set element material
			Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			tmpMaterial = contElement.FindSubContainer( kBarColoredGeomSubPath ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
			contElement.FindSubContainer( kBarColoredGeomSubPath ).Material = tmpMaterial
			tmpMaterial = contElement.FindSubContainer( kBarColoredGeomSubPath ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] ) 
			contElement.FindSubContainer( kBarColoredGeomSubPath ).Material = tmpMaterial

			' calculate next start value
			' calculate and set animation value
			If sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "L" Then
				dblStartLeft -= dblValue
'				dblStart = dblStartLeft
			ElseIf sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "R" Then
				dblStartRight += dblValue
'				dblStart = dblStartRight
			End If

			' set text value and labels
			aEleValueLabel.Clear
			aEleValueLabel.Push( sGraphicsData.aGroup[iGroup].aLabel1[iElement] )
			aEleValueLabel.Push( sGraphicsData.aGroup[iGroup].aLabel2[iElement] )
			aEleValueLabel.Push( sGraphicsData.aGroup[iGroup].aLabel3[iElement] )
			aEleValueLabel.Push( sGraphicsData.aGroup[iGroup].aLabel4[iElement] )

' sample path: [kLabelBaseSubPath & kLabelSVSubPath & strLabelPDSubPath & kLabelBigSubPath & kLabelBigLineBase & iCnt]
			' set front view labels
If iPie = 0 Then
'println "[sGraphicsData.aGroup[" & iGroup & "].aTypeOfLabel[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aTypeOfLabel[iElement] & "]"
			If sGraphicsData.aGroup[iGroup].aTypeOfLabel[iElement] = "B" Then
'				contWork = contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & strLabelPDSubPath & kLabelBigSubPath & kLabelBigLineBase & iElement+1 )
				contWork = contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & strLabelPDSubPath & kLabelSubPath & kLabelLineBase & cntBLbl )
				contWork.Active = TRUE
				contWork.Position.X = dblLabelPosX
'println "DEBUG: [sGraphicsData.strTypeOfGraphic]: [" & sGraphicsData.strTypeOfGraphic & "]..."
				If sGraphicsData.strTypeOfGraphic = "HRSVS1PD" Then
					Scene._updateScene_assignPieLabelPD( contWork, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], aEleValueLabel )
'println "DEBUG: [sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]] [sGraphicsData.aGroup[" & iGroup & "].aDiffTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "] [" & sGraphicsData.aGroup[iGroup].aDiffTxt[iElement] & "]"
				Else
					Scene._updateScene_assignPieLabel( contWork, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], aEleValueLabel )
				End If

				cntBLbl++
			ElseIf sGraphicsData.aGroup[iGroup].aTypeOfLabel[iElement] = "S" Then

				If sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "L"	Then
					cntLeft--
				ElseIf sGraphicsData.aGroup[iGroup].aAnimDirectionFlag[iElement] = "R"	Then
					cntRight--
				End If				

'println "DEBUG: [sGraphicsData.strTypeOfGraphic]: [" & sGraphicsData.strTypeOfGraphic & "]..."
				If sGraphicsData.strTypeOfGraphic = "HRSVS1PD" Then
					Scene._updateScene_assignPieLabelPD( contWork, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], aEleValueLabel )
'println "DEBUG: [sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]] [sGraphicsData.aGroup[" & iGroup & "].aDiffTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "] [" & sGraphicsData.aGroup[iGroup].aDiffTxt[iElement] & "]"
				Else
					Scene._updateScene_assignPieLabel( contWork, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], aEleValueLabel )
				End If
'println "[cntSLbl] [contWork.name] [contWork.vizID]: [" & kLabelBaseSubPath & kLabelSVSubPath & strLabelPDSubPath & kLabelSmallSubPath & kLabelSmallLineBase & cntSLbl & "] [" & contWork.vizID & "]"
				cntSLbl++
			End If
			
			' add animation for label
			Scene._PlayoutAnimationAdd( contWork, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			
			' set material of colored line
			
			contWork.FindSubContainer( "$col_linie" ).Active = gBlnColoredLabels

			If gBlnColoredLabels = TRUE Then
				tmpMaterial = contWork.FindSubContainer( "$col_linie" ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] ) 
'				tmpMaterial = contElement.FindSubContainer( kBarColoredGeomSubPath ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] ) 
			End If
			
End If
			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")

			' set topview label 
			Scene._updateScene_assignPieLabel( contWork, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], aEleValueLabel )

If iPie = 1 Then
			' add animation for label
			Scene._PlayoutAnimationAdd( contWork, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			
			' set material of colored line

			contWork.FindSubContainer( "$col_linie" ).Active = gBlnColoredLabels
			If gBlnColoredLabels = TRUE Then
				tmpMaterial = contWork.FindSubContainer( "$col_linie" ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] ) 
'				tmpMaterial = contElement.FindSubContainer( kBarColoredGeomSubPath ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] ) 
			End If
End If
		Next

		' hide rest elements in group
		For iElement = sGraphicsData.aGroup[iGroup].nElements To kMaxElementInGroup
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container and set inactive
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kDataSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")
			contElement.Active = FALSE
		Next
	Next	
	
'- 06.03.2017: not required in design 2017
'If iPie = 0 Then
'	' hide not required big labels
'	For iElement = sGraphicsData.nBigLabel To kMaxElementInGroup
'		contWork = contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSVSubPath & strLabelPDSubPath & kLabelSubPath & kLabelLineBase & iElement+1 )
'		contWork.Active = FALSE
'	Next
'End If

' set summary label
	If gBlnShowLabels = TRUE Then
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSummarySubPath & kSummaryWertSubPath ).Geometry.Text = sGraphicsData.strSitzeGesamt
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSummarySubPath & kMajorityWertSubPath ).Geometry.Text = sGraphicsData.strSitzeMehreit
	Else
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSummarySubPath & kSummaryWertSubPath ).Geometry.Text = ""
		contPie.FindSubcontainer( kLabelBaseSubPath & kLabelSummarySubPath & kMajorityWertSubPath ).Geometry.Text = ""
	End If
		
'	' set marker flags
'	For iCnt = 0 To 2
'		If sGraphicsData.aMarkerFlag[iCnt] = "1" Then
'			contPie.FindSubcontainer( kMarkerBaseSubPath & "$MARKER" & CStr(iCnt+1) ).Active = TRUE
'		Else
'			contPie.FindSubcontainer( kMarkerBaseSubPath & "$MARKER" & CStr(iCnt+1) ).Active = FALSE
'		End If
'	Next
	' add animation for marker flags
	Scene._PlayoutAnimationSubDirectorAdd( contBlenderElementIN, "ANI_MARKER_" & CStr(iPie+1), -1 )

Next
	
End Sub
'-------------------------------------------------------------------------------
