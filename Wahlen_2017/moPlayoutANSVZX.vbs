'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "11.05.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "ANALYSE: ANSVZP|ANSVZD|ANSVZPD - moPlayoutANSVZX_v00"
'
' note: [jn] i think the ANSVZD graphic has internal position issues because i have
' 			 to treat the y positions different - instead of y = x, y = y + x
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim fMinVizValue As Double
Dim fMaxVizValue As Double
Dim fMinBarValue As Double
Dim fMaxBarValue As Double
Dim fLabelHeight As Double

Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' definitions for multi-line labels
' height of banner 1x line
Dim kBannerHeight  As Double = 24
Dim kBannerStep    As Double = 12

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kTextGroupLabelTrans     As String = "$GROUP_LABEL$TRANS"
Dim kTextGroupLabelSubPath   As String = "$GROUP_LABEL$TRANS$txt_group"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"
Dim kBarColoredPathPos     	 As String = "$DATA$obj_geom_pos"
Dim kBarColoredPathNeg     	 As String = "$DATA$obj_geom_neg"
Dim kArrowSubPath            As String = "$TRANS$ELE_ARROW"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextValueDiffSubPath    As String = "$TXT_VALUE_DIFF"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"
Dim kDiffSubPath             As String = "$txt_diff"
Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"

Dim kEleRefText              As String = "$ELE_REF_TEXT"
Dim kEleRefPlane             As String = "$ELE_REF_PLANE"
Dim kEleBottom    			 As String = "$bg_bottom"

Dim kBannerSubPath           As String = "$objBanner"
Dim kGroupBGSubPath          As String = "$objGroupBG"

Dim kBarBGSubPath            As String = "$objBarBG"
Dim kServerMaterialPath      As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim nVisibleLabel As Integer

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structGroupData
	strLabel       As String
	nElements      As Integer
	aLabel1        As Array[String]
	aLabel2        As Array[String]
	aLabel3        As Array[String]
	aMaterial      As Array[String]
	aValueNum      As Array[String]
	aValueTxt      As Array[String]
	aDiffNum       As Array[String]
	aDiffTxt       As Array[String]
	aAnimOrderFlag As Array[String]
	dblMinValue    As Double
	dblMaxValue    As Double
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName        As String
	strTypeOfGraphic   As String
	blnInfoPercentFlag As Boolean
	nGroups            As Integer
	dblRefValue        As Double
	aGroup             As Array[structGroupData]
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

	RegisterParameterString("theTypeOfGraphic", "type of graphic [ANSVZP|ANSVZD|ANSVZPD]:", "ANSVZP", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gANSVZPD_4x]:", "gANSVZPD_4x", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [1#1#...]:", "1#1#1#1#1", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "gLab1#gLab2#glab3#gLab4#gLab5", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "lab1lin1#lab2lin1#lab3lin1#lab4lin1#lab5lin1", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "####", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "####", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "63#57#51#42#33", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "63#57#51#42#33", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4#-3#3#1#0", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-4#-3#+3#+1#0", 55, 256, "")
	RegisterParameterString("theReferenceNum", "reference value [23.5]:", "23.5", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1#2#3#4#5", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu#cdu#cdu#cdu#cdu", 55, 256, "")
	RegisterParameterString("theRangeValues", "min/max values [0|45#0|65...]:", "0|0#0|0", 25, 55, "")
	RegisterParameterBool("thePercentInfoFlag", "Show Info Percent", TRUE)

	RegisterPushButton("btAssignValues", "assign values", 11)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btAssignValuesDirect", "assign values direct", 21)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Scene.dbgRegisterFunction( strScriptName )

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
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readGraphicsData()
	Dim strDebugLocation As String = strScriptName & "readGraphicsData():"
	Dim strTemp As String
	Dim aGroupLabList, aGroupEleList, aEleLabel1, aEleLabel2, aEleLabel3 As Array[String]
	Dim aEleMaterial, aEleValueNum, aEleValueTxt, aEleDiffNum, aEleDiffTxt As Array[String]
	Dim aEleAnimOrder, aEleRangeValues, aStrHelp As Array[String]
	Dim iGroup, nMaxLabel As Integer
	Dim dblTempValue As Double
	Dim dblTempMinValue, dblTempMaxValue As Double

	' get type of graphics
	sGraphicsData.strTypeOfGraphic = GetParameterString("theTypeOfGraphic")
	' get info percent label flag
	sGraphicsData.blnInfoPercentFlag = GetParameterBool("thePercentInfoFlag")
	' get group data
	strTemp = GetParameterString("theNumElements")
	strTemp.Split( strGroupSeparator, aGroupEleList )
	strTemp = GetParameterString("theGroupLabel")
	strTemp.Split( strGroupSeparator, aGroupLabList )
	strTemp = GetParameterString("theLabel1")
	strTemp.Split( strGroupSeparator, aEleLabel1 )
	strTemp = GetParameterString("theLabel2")
	strTemp.Split( strGroupSeparator, aEleLabel2 )
	strTemp = GetParameterString("theLabel3")
	strTemp.Split( strGroupSeparator, aEleLabel3 )
	strTemp = GetParameterString("theMaterial")
	strTemp.Split( strGroupSeparator, aEleMaterial )
	strTemp = GetParameterString("theValueNum")
	strTemp.Split( strGroupSeparator, aEleValueNum )
	strTemp = GetParameterString("theValueTxt")
	strTemp.Split( strGroupSeparator, aEleValueTxt )
	strTemp = GetParameterString("theDiffNum")
	strTemp.Split( strGroupSeparator, aEleDiffNum )
	strTemp = GetParameterString("theDiffTxt")
	strTemp.Split( strGroupSeparator, aEleDiffTxt )
	strTemp = GetParameterString("theAnimOrderFlag")
	strTemp.Split( strGroupSeparator, aEleAnimOrder )

	strTemp = GetParameterString("theReferenceNum")
	sGraphicsData.dblRefValue = CDbl(strTemp)
	sGraphicsData.nGroups = aGroupEleList.UBound

	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strGroupSeparator, aEleRangeValues )

	nMaxLabel = 1
	fMinBarValue = 0.0
	fMaxBarValue = 0.0
	dblTempMaxValue = 0.0
	' read group and element details
	sGraphicsData.aGroup.Clear()
	For iGroup = 0 To sGraphicsData.nGroups

		Scene.dbgOutput( 1, strDebugLocation, "reading data of [iGroup]: [" & iGroup & "]" )
		sGroupData.nElements = CInt( aGroupEleList[ iGroup ] )
		sGroupData.strLabel  = aGroupLabList[ iGroup ]

		aEleLabel1[iGroup].Split( strElementSeparator, sGroupData.aLabel1 )
		aEleLabel2[iGroup].Split( strElementSeparator, sGroupData.aLabel2 )
		aEleLabel3[iGroup].Split( strElementSeparator, sGroupData.aLabel3 )
		aEleMaterial[iGroup].Split( strElementSeparator, sGroupData.aMaterial )
		aEleValueNum[iGroup].Split( strElementSeparator, sGroupData.aValueNum )
		aEleValueTxt[iGroup].Split( strElementSeparator, sGroupData.aValueTxt )
		aEleDiffNum[iGroup].Split( strElementSeparator, sGroupData.aDiffNum )
		aEleDiffTxt[iGroup].Split( strElementSeparator, sGroupData.aDiffTxt )
		aEleAnimOrder[iGroup].Split( strElementSeparator, sGroupData.aAnimOrderFlag )
		aEleRangeValues[iGroup].Split( strElementSeparator, aStrHelp )
		sGroupData.dblMinValue = CDbl( aStrHelp[0] )
		sGroupData.dblMaxValue = CDbl( aStrHelp[1] )

		'Scene.dbgOutput(1, "readGraphicsData(): ", "..sGroupData.strLabel=[" & sGroupData.strLabel & "] lines.cnt="& sGroupData.strLabel.Find("_"))
		aEleLabel1[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel2[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel3[iGroup].Substitute("[|]", "", TRUE)

		' dont know if that fits for all
		dim b as Array[String]
		sGroupData.strLabel.split("_", b)

		If b.UBound >= 2 and nMaxLabel < 3 then
			nMaxLabel = 3
		Elseif b.UBound >= 1 and nMaxLabel < 2 Then
			nMaxLabel = 2
		ElseIf b.UBound >= 0 and nMaxLabel < 1 then
			nMaxLabel = 1
		End If

		' get maxDblValue depending on typeOfGraphics [ANSVZP, ANSVZPD, ANSVZD]
		If sGroupData.dblMinValue = 0.0 And sGroupData.dblMaxValue = 0.0 Then

			If sGraphicsData.strTypeOfGraphic = "ANSVZD" Then
				dblTempMinValue = 0.0
				dblTempMaxValue = getMaxStrArrayValueAbs( sGroupData.aDiffNum, dblTempMaxValue )
			Else
				dblTempMinValue = 0.0
				dblTempMaxValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
			End If
			If dblTempMaxValue > fMaxBarValue Then
				fMaxBarValue = dblTempMaxValue
			End If
			If dblTempMinValue < fMinBarValue Then
				fMinBarValue = dblTempMinValue
			End If

		Else

			If sGroupData.dblMinValue < sGroupData.dblMaxValue Then
				fMinBarValue = sGroupData.dblMinValue
				fMaxBarValue = sGroupData.dblMaxValue
			Else
				fMinBarValue = sGroupData.dblMaxValue
				fMaxBarValue = sGroupData.dblMinValue
			End If
		End If

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	'Scene.dbgOutput(1, "readGraphicsData(): ", "dblTempMinValue="& dblTempMinValue &" dblTempMaxValue="& dblTempMaxValue)

	' compare fMaxBarValue to refValue
	If sGraphicsData.strTypeOfGraphic <> "ANSVZD" Then
		If sGraphicsData.dblRefValue > fMaxBarValue Then
			fMaxBarValue = sGraphicsData.dblRefValue
'			nMaxlabel = nMaxlabel + 1
		End If
	End If

	For iGroup = 0 To sGraphicsData.nGroups
		sGraphicsData.aGroup[iGroup].dblMinValue = fMinBarValue
		sGraphicsData.aGroup[iGroup].dblMaxValue = fMaxBarValue
	Next

	Dim bannerOffset As Double = (nMaxLabel-1)*kBannerStep

	' get maxVizValue [ANSVZP, ANSVZPD, ANSVZD]
	If sGraphicsData.strTypeOfGraphic = "ANSVZD" Then
		fMinVizValue = 0.0
		fMaxVizValue = 81 - bannerOffset/2
	ElseIf sGraphicsData.strTypeOfGraphic = "ANSVZPD" Then
		fMinVizValue = 0.0
		fMaxVizValue = 135 - bannerOffset
	Else
		fMinVizValue = 0.0
		fMaxVizValue = 163 - bannerOffset
	End If

	nVisibleLabel = nMaxLabel

	'Scene.dbgOutput(1, strDebugLocation, "fMaxVizValue="& fMaxVizValue &" fMaxBarValue="& fMaxBarValue &" bannerOffset="& bannerOffset &" label.cnt="& nVisibleLabel)

End Sub

Function getMaxStrArrayValueAbs( aValueNum As Array[String], deflt as Double ) As Double
	Dim iCnt As Integer
	Dim t, ret As Double

	ret = deflt
	For iCnt = 0 To aValueNum.UBound
		t = Abs(CDbl( aValueNum[iCnt] ))

		If t > ret Then
			ret = t
		End If
	Next
	getMaxStrArrayValueAbs = ret
End Function
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
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel1[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel1[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel2[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel2[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aLabel3[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aLabel3[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aMaterial[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aValueTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aDiffNum[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aDiffNum[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aDiffTxt[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aDiffTxt[iElement] & "]")
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aAnimOrderFlag[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
		Next

	Next

	Scene.dbgOutput(1, strDebugLocation, "....done [sGraphicsData]----------------------------------------")

End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' calculate scale factor and zero plane position
	Dim fMinRange, fMaxRange As Double
	fMinRange = sGraphicsData.aGroup[0].dblMinValue
	fMaxRange = sGraphicsData.aGroup[0].dblMaxValue

	Dim contBlenderElementIN  As Container
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")

	Dim dblValue, dblScaleFactor As Double

	If sGraphicsData.strTypeOfGraphic = "ANSVZD" Then
		dblScaleFactor = ( fMaxVizValue - fMinVizValue) / ( fMaxRange - fMinRange )
		dblValue = dblScaleFactor * sGraphicsData.dblRefValue

	ElseIf sGraphicsData.strTypeOfGraphic = "ANSVZPD" Then
		dblScaleFactor = ( fMaxVizValue - fMinVizValue) / ( fMaxRange - fMinRange )
		dblValue = dblScaleFactor * sGraphicsData.dblRefValue

		Dim refOffset As Double = (nVisibleLabel-1)*kBannerStep + (kBannerHeight+4)

		contBlenderElementIN.FindSubcontainer( kEleRefText ).Position.Y = dblValue + 1.0 +  refOffset
		contBlenderElementIN.FindSubcontainer( kEleRefText & kTextSubPath ).Geometry.Text = DoubleToString( sGraphicsData.dblRefValue, 0 )
		contBlenderElementIN.FindSubcontainer( kEleRefPlane ).Position.Y = dblValue + refOffset
	else
		dblScaleFactor = ( fMaxVizValue - fMinVizValue) / ( fMaxRange - fMinRange )
		dblValue = dblScaleFactor * sGraphicsData.dblRefValue

		Dim bannerOffset As Double = (nVisibleLabel-1)*kBannerStep

		contBlenderElementIN.FindSubcontainer( kEleRefText ).Position.Y = dblValue + 1.0 +  bannerOffset
		contBlenderElementIN.FindSubcontainer( kEleRefText & kTextSubPath ).Geometry.Text = DoubleToString( sGraphicsData.dblRefValue, 0 )
		contBlenderElementIN.FindSubcontainer( kEleRefPlane ).Position.Y = dblValue + bannerOffset
	End If

	'println "DEBUG: ------------------------------------------------"
	'println "DEBUG: [sGlobalParameter.dblUMLabHeight]: ["	& sGlobalParameter.dblUMLabHeight & "]"
	'println "DEBUG: [fMinVizValue] [fMaxVizValue]: ["	& fMinVizValue & "] [" & fMaxVizValue & "]"
	'println "DEBUG: [fMinRangeValue] [fMaxRangeValue]: ["	& fMinRange & "] [" & fMaxRange & "]"
	'println "DEBUG: [dblScaleFactor] [dblZeroPosY]: ["	& dblScaleFactor & "] [" & dblZeroPosY & "]"
	'println "DEBUG: [dblZeroPosY]: ["	& dblZeroPosY & "]"
	'println "DEBUG: [scaleFactor = (fMaxVizValue-fMinVizValue-2*labelHeigth)/(fMaxRange-fMinRange)]: ["	& dblScaleFactor & "=(" & fMaxVizValue & "-" & fMinVizValue & "-2*" & sGlobalParameter.dblUMLabHeight & ")/(" & fMaxRange & "-" & fMinRange & ") = " & dblScaleFactor
	'println "DEBUG: [zeroPosY]: ["	& dblZeroPosY & "]"

	' set visibility of info percent label
	contBlenderElementIN.FindSubcontainer( kTransSubPath & kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

	UpdateGroupBgPosition(sGraphicsData.strTypeOfGraphic, contBlenderElementIN, nVisibleLabel)

	Dim iGroup As Integer
	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		Dim tmpGroupName As String
		tmpGroupName = kGroupBaseName & iGroup+1

		Dim contGroup As Container
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "tmpGroup="& tmpGroupName)
		' update group label

		' set offsets for multi-line banner
		UpdateGroupLabel(sGraphicsData.strTypeOfGraphic, contGroup, nVisibleLabel, sGraphicsData.aGroup[iGroup].strLabel)

		'Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue, nVisibleLabel )

		Dim iElement As Integer
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")

			' get reference to element container
			Dim tmpElementName As String
			tmpElementName = kElementBaseName & iElement+1

			Dim contElement As Container
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "contElement.Name=" & contElement.Name & " scaleFactor="& dblScaleFactor)

			' calculate and set animation value separate for each variant [ANSVZP|ANSVZD|ANSVZPD]
			If sGraphicsData.strTypeOfGraphic = "ANSVZP" Then
				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )

				Scene.dbgOutput(1, strDebugLocation, "updating k_value=" & dblValue)

				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue

				UpdateElementPosition(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)

				' set offsets for multi-line banner
				UpdateLabelOffsetElement(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)

				' set text value and labels
				Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], "", "", "", dblValue, nVisibleLabel )

				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag

				' set element material
				'Scene.dbgOutput(1, strDebugLocation, "tmpMaterial=" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement])
				Dim coloredBar as Container
				coloredBar = contElement.FindSubContainer("$DATA$obj_geom")

				Dim tmpMaterial As Material
				tmpMaterial = coloredBar.CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
				coloredBar.Material = tmpMaterial

			ElseIf sGraphicsData.strTypeOfGraphic = "ANSVZD" Then

				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aDiffNum[iElement] )

				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )

				'Scene.dbgOutput(1, "MY!!!", "input="& sGraphicsData.aGroup[iGroup].aDiffNum[iElement] &" dblValue="& dblValue & " dblZeroPosY="& dblZeroPosY & " dblScaleFactor="& dblScaleFactor)

				' set animation keyframe and visibility
				If dblValue > 0 Then
					contElement.FindSubContainer( kBarColoredPathPos ).Active = TRUE
					contElement.FindSubContainer( kBarColoredPathNeg ).Active = FALSE
					contElement.FindSubContainer( kBarColoredPathPos ).FindKeyframeOfObject("k_value").FloatValue = Abs(dblValue)
				ElseIf dblValue < 0 Then
					contElement.FindSubContainer( kBarColoredPathPos ).Active = FALSE
					contElement.FindSubContainer( kBarColoredPathNeg ).Active = TRUE
					contElement.FindSubContainer( kBarColoredPathNeg ).FindKeyframeOfObject("k_value").FloatValue = Abs(dblValue)
				Else
					contElement.FindSubContainer( kBarColoredPathPos ).Active = FALSE
					contElement.FindSubContainer( kBarColoredPathNeg ).Active = FALSE
				End If

				UpdateElementPosition(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)

				' set offsets for multi-line banner
				UpdateLabelOffsetElement(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)

				' set text value and labels
				Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], "", "", "", dblValue, nVisibleLabel )
				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag

				' set element material
				'Scene.dbgOutput(1, strDebugLocation, "tmpMaterial=" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement])
				Dim coloredBar as Container
				Dim tmpMaterial As Material

				coloredBar = contElement.FindSubContainer(kBarColoredPathPos)
				tmpMaterial = coloredBar.CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
				coloredBar.Material = tmpMaterial

				coloredBar = contElement.FindSubContainer(kBarColoredPathNeg)
				tmpMaterial = coloredBar.CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
				coloredBar.Material = tmpMaterial

			ElseIf sGraphicsData.strTypeOfGraphic = "ANSVZPD" Then

				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )

				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
				
				UpdateElementPosition(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)

'				' set offsets for multi-line banner
				UpdateLabelOffsetElement(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)
				' set text value and labels
				Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], "", "", "", dblValue, nVisibleLabel )
				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag
				' set diff value (bottom)
				contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & kTextValueDiffSubPath & kDiffSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].aDiffTxt[iElement]

				' set element material
				'Scene.dbgOutput(1, strDebugLocation, "tmpMaterial=" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement])
				Dim coloredBar as Container
				coloredBar = contElement.FindSubContainer("$DATA$obj_geom")

				Dim tmpMaterial As Material
				tmpMaterial = coloredBar.CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
				coloredBar.Material = tmpMaterial
			End If

			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
		Next

	Next

End Sub

'-------------------------------------------------------------------------------
' called once to set the background area and the banner
Sub UpdateGroupBgPosition(typeOfGraphic As String, contGroup As Container, nLabels As integer)
	Dim bannerOffset As Double = (nLabels-1)*kBannerStep

	Dim bggrp as Container
	Dim banner as Container

	If typeOfGraphic = "ANSVZD" Then

		bggrp  = contGroup.FindSubcontainer( "$objGroupBGpos" )

		Dim bggrpneg as Container
		bggrpneg  = contGroup.FindSubcontainer( "$objGroupBGneg" )

		' white rect below labels
		banner  = contGroup.FindSubcontainer( kBannerSubPath )
		' set height of banner animation end keyframe
		banner.FindKeyframeOfObject("k_value").FloatValue = kBannerHeight + bannerOffset
 
		bggrp.Geometry.PluginInstance.SetParameterDouble("height", 127 - bannerOffset / 2.0)
		bggrpneg.Geometry.PluginInstance.SetParameterDouble("height", 81.2 - bannerOffset / 2.0)
	Else
		bggrp  = contGroup.FindSubcontainer( kGroupBGSubPath )

		' set background height
		If typeOfGraphic = "ANSVZPD" Then
			bggrp.Geometry.PluginInstance.SetParameterDouble("height", 193.0 - bannerOffset)
		Else
			bggrp.Geometry.PluginInstance.SetParameterDouble("height", 221.0 - bannerOffset)
		End If

		bggrp.Position.Y = bannerOffset

		banner = contGroup.FindSubcontainer( kBannerSubPath )
		' set height of banner animation end keyframe
		banner.FindKeyframeOfObject("k_value").FloatValue = kBannerHeight + bannerOffset
		' set Y position for center of banner
		banner.Position.Y = bannerOffset/2.0
	End If

	'Scene.dbgOutput(1, strScriptName, "UpdateGroupBgPosition.group.PosY="& bggrp.Position.Y &" bg.PosY="& banner.Position.Y &" banner.height="& banner.Geometry.PluginInstance.GetParameterDouble("height"))
End Sub
'-------------------------------------------------------------------------------
'
Sub UpdateGroupLabel(typeOfGraphic As String, contGroup As Container, nLabels As integer, labelOrig As String)
	Dim strHelp As String
	strHelp = labelOrig

	Dim labelRows As Integer
	labelRows = strHelp.Substitute("[_]", "\n", TRUE) + 1
	if labelRows > 3 then
		labelRows = 3
	end if

	contGroup.FindSubcontainer( kTextGroupLabelSubPath ).Geometry.Text = strHelp

	' this is the parent of the group-text object
	Dim labeltrans as Container
	labeltrans  = contGroup.FindSubcontainer( kTextGroupLabelTrans )

	Dim bannerOffset As Double = (nLabels-1)*kBannerStep

	If typeOfGraphic = "ANSVZD" Then

		if labelRows = 1 then
			labeltrans.Position.Y = 85
		elseif labelRows = 2 then
			labeltrans.Position.Y = 79
		elseif labelRows = 3 then
			labeltrans.Position.Y = 71
		end if
	Else
		' set Y position for center of grouplabel text - should be same as for banner
		labeltrans.Position.Y = labeltrans.Position.Y + bannerOffset/2.0
	End if

	'Scene.dbgOutput(1, strScriptName, "UpdateGroupLabel.labelOrig="& labelOrig &" subCnt="& subCnt &" nLabels="& nLabels)
End Sub
'-------------------------------------------------------------------------------
'
Sub UpdateLabelOffsetElement(typeOfGraphic As String, contElement As Container, nLabels As integer)
	' moving the blue box
	Dim bannerOffset As Double = (nLabels-1)*kBannerStep

	If typeOfGraphic = "ANSVZD" Then
		' nothing ?!
	Else
		Dim bgMaxHeight As Double

		If typeOfGraphic = "ANSVZPD" Then
			bgMaxHeight = 138
			contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueDiffSubPath & kTransSubPath).Position.Y = (-1)*bannerOffset
		Else
			bgMaxHeight = 163.5
		End If

		' set height of animation end keyframe
		contElement.FindSubContainer( kBarBGSubPath ).FindKeyframeOfObject("k_value").FloatValue = bgMaxHeight - bannerOffset

		'Scene.dbgOutput(1, strScriptName, "LabelOffsetElement.bgMaxHeight="& bgMaxHeight &" bannerOffset="& bannerOffset &" kvalue="& (maxHeight))
	End if
End Sub
'-------------------------------------------------------------------------------
'
Sub UpdateElementPosition(typeOfGraphic As String, contElement As Container, nLabels As integer)
	Dim bannerOffset As Double = (nLabels-1)*kBannerStep

	If typeOfGraphic = "ANSVZD" Then
		Dim cbgBottom as Container

		' the bar background
		Dim ctransppos as Container
		ctransppos = contElement.FindSubContainer( "$DATA$GFX_ELE$transparent_pos" )
		
		Dim ctranspneg as Container
		ctranspneg = contElement.FindSubContainer( "$DATA$GFX_ELE$transparent_neg" )

		' the colored bar pos
		Dim credpos as Container
		credpos = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath & "_pos")

		Dim credneg as Container
		credneg = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath & "_neg")

		' blue value rectangle
		Dim ctextdata as Container
		ctextdata = contElement.FindSubContainer(kDataSubPath & kTextDataSubPath)

		ctextdata.Position.Y =  bannerOffset / 2.0

		credpos.Position.Y = 0.0 + bannerOffset / 2.0
		ctransppos.Position.Y = 0.0 + bannerOffset / 2.0

		credneg.Position.Y = -75.5 - bannerOffset / 2.0
		ctranspneg.Position.Y = -75.5 - bannerOffset / 2.0

		dim transpnoggi As Double
		if nLabels = 1 then
			transpnoggi = 100
		elseif nLabels = 2 then
			transpnoggi = 93
		elseif nLabels = 3 then
			transpnoggi = 86
		end if

		ctransppos.FindKeyframeOfObject("k_value").FloatValue = transpnoggi
		ctranspneg.FindKeyframeOfObject("k_value").FloatValue = transpnoggi

		'Scene.dbgOutput(1, strScriptName & "UpdateElementPosition", "ele.PosY=" & contElement.Position.Y  &" label.cnt="& nLabels &" noggi="& transpnoggi &" bannerOffset="&bannerOffset)
	else ' !ANSVZD
		' the bar background
		Dim ctransppos as Container
		ctransppos = contElement.FindSubContainer( "$DATA$GFX_ELE$transparent" )
		' the colored bar pos

		Dim credpos as Container
		credpos = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath )
		
		' blue value rectangle
		Dim ctextdata as Container
		ctextdata = contElement.FindSubContainer(kDataSubPath & kTextDataSubPath)

		If typeOfGraphic = "ANSVZPD" Then
			credpos.Position.Y = bannerOffset
			ctextdata.Position.Y = bannerOffset
			ctransppos.Position.Y = 0
			ctransppos.FindKeyframeOfObject("k_value").FloatValue = 81

			' set Y position of bar element
			contElement.Position.Y = 0 'bannerOffset
		else

			dim transpnoggi As Double
			if nLabels = 1 then
				transpnoggi = 98
			elseif nLabels = 2 then
				transpnoggi = 91
			elseif nLabels = 3 then
				transpnoggi = 84
			end if

			ctransppos.FindKeyframeOfObject("k_value").FloatValue = transpnoggi

			' set Y position of bar element
			contElement.Position.Y = bannerOffset

		end if

		'Scene.dbgOutput(1, strScriptName & "UpdateElementPosition", "typ="& typeOfGraphic &" ele.PosY=" & contElement.Position.Y  &" labels="& nLabels &" transpnoggi="& transpnoggi)
	end if

End Sub
'-------------------------------------------------------------------------------





