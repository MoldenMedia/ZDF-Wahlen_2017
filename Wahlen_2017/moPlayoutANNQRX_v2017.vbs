'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "27.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "ANALYSE: ANNQRP|ANNQRD|ANNQRPD - moPlayoutANNQRX_v00"
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

' container definitions
Dim contElementPool As Container
Dim contBlenderElementIN  As Container
Dim contBlenderElementOUT As Container

Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kTextGroupLabelSubPath   As String = "$GROUP_LABEL$TRANS$txt_group"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"
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

Dim kBannerSubPath           As String = "$objBanner"
Dim kGroupBGSubPath          As String = "$objGroupBG"
Dim kBarBGSubPath            As String = "$objBarBG"
Dim kServerMaterialPath      As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' definitions for multi-line labels
' height of banner 1x line
Dim kBannerHeight  As Double = 24
Dim kBannerStep    As Double = 12
Dim kBGMaxHeightPZ As Double = 214.5
Dim kBGMaxHeightPD As Double = 186.0

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj2 As Container
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
	strElemName      As String
	strTypeOfGraphic As String
	blnInfoPercentFlag As Boolean
	nGroups          As Integer
	aGroup           As Array[structGroupData]
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
	
	RegisterParameterString("theTypeOfGraphic", "type of graphic [ANNQRP|ANNQRD|ANNQRPD]:", "ANNQRP", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gANNQRPD_4x]:", "gANNQRPD_4x", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [2#2#...]:", "7", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "lab1lin1|lab2lin1|lab3lin1|lab4lin1|lab5lin1|lab6lin1|lab7lin1|lab8lin1", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "|||||||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "|||||||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "63|57|51|42|33|22|11|5", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "63|57|51|42|33|22|11|5", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4|-3|3|1|0|3|-3", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-4|-3|3|1|0|3|-3", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2|3|3|4|5|6|7", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu|spd|fdp|linke|oedp|rep|mlpd|dvu", 55, 256, "")
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
	
	sGlobalParameter = (Scene.structGlobalParameter)	Scene.Map["sGlobalParameter"]

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

	sGraphicsData.nGroups = aGroupEleList.UBound
	
	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strGroupSeparator, aEleRangeValues )
		
	nMaxLabel = 0 
	fMinBarValue = 0.0
	fMaxBarValue = 0.0
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
		
'Scene.dbgOutput(1, "readGraphicsData(): ", "..[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")
		aEleLabel1[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel2[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel3[iGroup].Substitute("[|]", "", TRUE)
		
		' get maxDblValue depending on typeOfGraphics [ANNQRP, ANNQRPD, ANNQRD]
		' get max number of labels
		If aEleLabel1[iGroup] <> "" And nMaxLabel < 1 Then
			nMaxLabel = 1
		End If
		If aEleLabel2[iGroup] <> "" And nMaxLabel < 2 Then
			nMaxLabel = 2
		End If
		If aEleLabel3[iGroup] <> "" And nMaxLabel < 3 Then
			nMaxLabel = 3
		End If
		
		' get maxDblValue depending on typeOfGraphics [ANNQRP, ANNQRPD, ANNQRD]
		If sGroupData.dblMinValue = 0.0 And sGroupData.dblMaxValue = 0.0 Then

			If sGraphicsData.strTypeOfGraphic = "ANNQRD" Then
				dblTempMinValue = Scene._getMinBaxValue( sGroupData.aDiffNum )
				dblTempMaxValue = Scene._getMaxBaxValue( sGroupData.aDiffNum )
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

	For iGroup = 0 To sGraphicsData.nGroups
		sGraphicsData.aGroup[iGroup].dblMinValue = fMinBarValue
		sGraphicsData.aGroup[iGroup].dblMaxValue = fMaxBarValue
	Next

	' get maxVizValue [ANNQRP, ANNQRPD, ANNQRD]
	If sGraphicsData.strTypeOfGraphic = "ANNQRD" Then
		fMinVizValue = 0.0
		fMaxVizValue = sGlobalParameter.dblMaxVizValueANVD
	Else
		fMinVizValue = 0.0
		fMaxVizValue = sGlobalParameter.dblMaxVizValueANVP - (nMaxlabel-1)*sGlobalParameter.dblANLabHeight
	End If

	nVisibleLabel = nMaxLabel

	Scene.dbgOutput(1, strDebugLocation, "[fMaxVizValue] [fMaxBarValue]: ["	& fMaxVizValue & "] [" & fMaxBarValue & "]" )

'println "DEBUG: ------------------------------------------------"
'println "DEBUG: [2*sGlobalParameter.dblMaxVizValueHRLabHeight]: ["	& 2*sGlobalParameter.dblMaxVizValueHRLabHeight & "]" 
'println "DEBUG: [fMinVizValue] [fMaxVizValue]: ["	& fMinVizValue & "] [" & fMaxVizValue & "]" 
'println "DEBUG: [fMinRangeValue] [fMaxRangeValue]: ["	& sGraphicsData.aGroup[0].dblMinValue & "] [" & sGraphicsData.aGroup[0].dblMaxValue & "]" 
''println "DEBUG: [dblScaleFactor] [dblZeroPosY]: ["	& dblScaleFactor & "] [" & dblZeroPosY & "]" 
'println "DEBUG: [nVisibleLabel]: ["	& nVisibleLabel & "]" 
'	' print data
'	dumpData()

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
	Dim contGroup, contElement, contHelp As Container
	Dim tmpGroupName, tmpElementName As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue, dblScaleFactor, dblZeroPosY As Double
	Dim iGroup, iElement As Integer
	Dim fMinRange, fMaxRange As Double

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' calculate posY of zero plane
	fMinRange = sGraphicsData.aGroup[0].dblMinValue
	fMaxRange = sGraphicsData.aGroup[0].dblMaxValue

	If sGraphicsData.strTypeOfGraphic = "ANNQRD" Then
		dblScaleFactor = ( fMaxVizValue - fMinVizValue) / ( fMaxRange - fMinRange )
'		dblScaleFactor = ( fMaxVizValue - fMinVizValue - 2*(nVisibleLabel)*sGlobalParameter.dblUMLabHeight - 2.0*7.0) / ( fMaxRange - fMinRange )
'		dblZeroPosY = (-1)*( dblScaleFactor * fMinRange ) + (nVisibleLabel)*sGlobalParameter.dblUMLabHeight + 7.0 + fMinVizValue

'		' set posY of zero plane required to adapt scaling range
'		contBlenderElementIN.FindSubcontainer( "$ELE_ZERO_PLANE" ).Position.Y = dblZeroPosY 
	Else
		dblScaleFactor = ( fMaxVizValue - fMinVizValue - (nVisibleLabel-1)*kBannerStep) / ( fMaxRange - fMinRange )
'		dblScaleFactor = ( fMaxVizValue - fMinVizValue ) / ( fMaxRange - fMinRange )
	End If

'println "DEBUG: ------------------------------------------------"
'println "DEBUG: [sGlobalParameter.dblUMLabHeight]: ["	& sGlobalParameter.dblUMLabHeight & "]" 
'println "DEBUG: [fMinVizValue] [fMaxVizValue]: ["	& fMinVizValue & "] [" & fMaxVizValue & "]" 
'println "DEBUG: [fMinRangeValue] [fMaxRangeValue]: ["	& fMinRange & "] [" & fMaxRange & "]" 
'println "DEBUG: [dblScaleFactor] [dblZeroPosY]: ["	& dblScaleFactor & "] [" & dblZeroPosY & "]" 
'println "DEBUG: [dblZeroPosY]: ["	& dblZeroPosY & "]" 
'println "DEBUG: [scaleFactor = (fMaxVizValue-fMinVizValue-2*labelHeigth)/(fMaxRange-fMinRange)]: ["	& dblScaleFactor & "=(" & fMaxVizValue & "-" & fMinVizValue & "-2*" & sGlobalParameter.dblUMLabHeight & ")/(" & fMaxRange & "-" & fMinRange & ") = " & dblScaleFactor
'println "DEBUG: [zeroPosY]: ["	& dblZeroPosY & "]" 
'
	' set visibility of info percent label
	contBlenderElementIN.FindSubcontainer( kTransSubPath & kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		tmpGroupName = kGroupBaseName & iGroup+1
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "[tmpGroupName]: [" & tmpGroupName & "]")
		
' remove if not required
' double check scene !!
'		' update group label
'		contGroup.FindSubcontainer( kTextGroupLabelSubPath ).Geometry.Text = sGraphicsData.aGroup[iGroup].strLabel

		' set offsets for multi-line banner
		updateScene_LabelOffsetGroup(sGraphicsData.strTypeOfGraphic, contGroup, nVisibleLabel)

		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")

			' calculate and set animation value separate for each variant [ANNQRP|ANNQRD|ANNQRPD]
			If sGraphicsData.strTypeOfGraphic = "ANNQRP" Then
				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )
				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
				' set offsets for multi-line banner
				updateScene_LabelOffsetElement(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)
				' set text value and labels
				Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue, nVisibleLabel )
				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag
	
'				' set text value and labels
'				Scene._updateScene_assignLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue )

			ElseIf sGraphicsData.strTypeOfGraphic = "ANNQRD" Then
				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aDiffNum[iElement] )
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )

'println "DEBUG: [iGroup] [iElement] [dblValue]: ["	& iGroup & "] [" & iElement & "] [" & dblValue & "]" 
				' set posY of element
				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).Position.Y = dblZeroPosY

				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue

				' set text value and labels
				Scene._updateScene_assignLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue )
				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag

			ElseIf sGraphicsData.strTypeOfGraphic = "ANNQRPD" Then

				' calculate and set animation value
				dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )
				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
				' set offsets for multi-line banner
				updateScene_LabelOffsetElement(sGraphicsData.strTypeOfGraphic, contElement, nVisibleLabel)
				' set text value and labels
				Scene._updateScene_assignLabel_3_2017( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue, nVisibleLabel )
				contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & kTextValueDiffSubPath & kDiffSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].aDiffTxt[iElement]
				' set visibility of unit percent
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag

'				' set text value and labels
'				Scene._updateScene_assignDiffLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement] )

		End If

			' set element material
			Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			tmpMaterial = contElement.FindSubContainer("$DATA$obj_geom").CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
			contElement.FindSubContainer("$DATA$obj_geom").Material = tmpMaterial
'			contElement.FindSubContainer("$DATA$obj_geom").FindKeyframeOfObject("k_value").FloatValue = dblValue
			
			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")

		Next
		
	Next	
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_LabelOffsetGroup(typeOfGraphic As String, contGroup As Container, nLabels As Double)
	Dim bgMaxHeight As Double

	If typeOfGraphic = "ANNQRP" Then
		bgMaxHeight = kBGMaxHeightPZ
	ElseIf typeOfGraphic = "ANNQRPD" Then
		bgMaxHeight = kBGMaxHeightPD
	Else
		bgMaxHeight = kBGMaxHeightPZ
	End If
	
	' set height of banner animation end keyframe
	contGroup.FindSubContainer( kBannerSubPath ).FindKeyframeOfObject("k_value").FloatValue = kBannerHeight + (nLabels-1)*kBannerStep
	' set Y position for center of banner
	contGroup.FindSubContainer( kBannerSubPath ).Position.Y = (nLabels-1)*kBannerStep/2.0
	' set height of group background
	contGroup.FindSubContainer( kGroupBGSubPath ).Geometry.PluginInstance.SetParameterDouble("height", bgMaxHeight - (nLabels-1)*kBannerStep)
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_LabelOffsetElement(typeOfGraphic As String, contElement As Container, nLabels As Double)
	Dim bgMaxHeight As Double

	If typeOfGraphic = "ANNQRP" Then
		bgMaxHeight = sGlobalParameter.dblMaxVizValueANVP
	ElseIf typeOfGraphic = "ANNQRPD" Then
		bgMaxHeight = sGlobalParameter.dblMaxVizValueANVPD
		contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueDiffSubPath & kTransSubPath).Position.Y = (-1)*(nLabels-1)*kBannerStep
	Else
		bgMaxHeight = sGlobalParameter.dblMaxVizValueANVP
	End If

	' set Y position of bar element
	contElement.Position.Y = (nLabels-1)*kBannerStep
	' set height of animation end keyframe
	contElement.FindSubContainer( kBarBGSubPath ).FindKeyframeOfObject("k_value").FloatValue = bgMaxHeight - (nLabels-1)*kBannerStep
End Sub
'-------------------------------------------------------------------------------


