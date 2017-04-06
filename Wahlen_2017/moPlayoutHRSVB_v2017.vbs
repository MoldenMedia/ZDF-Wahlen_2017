'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "02.12.2009"
Dim theDateModified     As String = "04.04.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden Media GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "HOCHRECHNUNG - moPlayoutHRSVB_v00"
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

Dim strColorUnterAbsMH As String
Dim strColorOberAbsMH As String

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kTextGroupLabelSubPath   As String = "$GROUP_LABEL$TRANS$txt_group"
Dim kDataSubPath             As String = "$DATA"

'Dim kDotGroupSubPath         As String = "$GROUP_LABEL$TRANS$DOTS"
'Dim kDotGroupBaseName        As String = "$DOT_x"
'Dim kDotEleBaseName          As String = "$dot"

'Dim kAbsMHGroupPath          As String = "$TRANS$absMHgroup"
'Dim kAbsMHText               As String = "$absMH"
'Dim kGesamtText              As String = "$TRANS$gesamt"

Dim kBarKoalSubPathBase      As String = "$COLOR_KOAL$COLOR_"
Dim kBarKoalColoredSubPath   As String = "$obj_color"
Dim kBarColoredSubPath       As String = "$obj_geom"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextValueDiffSubPath    As String = "$TXT_VALUE_DIFF"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"
Dim kTextDiffSubPath         As String = "$txt_value_diff"
Dim kValueSubPath            As String = "$txt_value"
Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"

Dim kEleRefText              As String = "$ELE_REF_TEXT"
Dim kEleRefPlane             As String = "$ELE_REF_PLANE"

Dim kServerMaterialPath      As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj2 As Container

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structGroupData
	strLabel       As String
	dblGValueNum   As Double
	strGValueTxt   As String
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
	aGroup             As Array[structGroupData]
	strSitzeGesamt     As String
	strSitzeMehrheit   As String
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
	
	RegisterParameterString("theTypeOfGraphic", "type of graphic [HRSVB]:", "HRSVB", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gHRSVB_2x]:", "gGenerated", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [2#2#...]:", "2#4#1", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "glbl1#glbl2#glbl3", 55, 256, "")
	RegisterParameterString("theGroupNum", "group values number [63#67.6#...]:", "40#50#60", 55, 256, "")
	RegisterParameterString("theGroupTxt", "group values formatted [63#67.6#...]:", "40#50#60", 55, 256, "")
	
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "lab1lin1|lab2lin1#lab3lin1|lab4lin1|lab5lin1|lab6lin1|lab7lin1|lab8lin1", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "|#|||||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "|#|||||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "50.0|40.0#30.0|20.0|15.0|10.0|5.0|1.0", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "50.0|40.0#30.0|20.0|15.0|10.0|5.0|1.0", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-5.0|-4.0#-3.0|-2.0|0.0|2.0|5.0", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-5.0|-4.0#-3.0|-2.0|0.0|2.0|5.0", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2#3|3|4|5|6|7", 55, 55, "")
'	RegisterParameterString("theAnimStopFlag", "animation stop flags [1|1#...]:", "1|1|1|0|1|1|1|1", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu|spd#fdp|linke|oedp|rep|mlpd|dvu", 55, 256, "")
	
	RegisterParameterString("theSummary", "Sitze gesamt | absol. Mehrheit:", "160|81", 55, 256, "")
	
	RegisterParameterString("theRangeValues", "min/max values [0|45#0|65...]:", "0|0#0|0", 25, 55, "")
	
	'Color for bars
	RegisterParameterString("theColorUnterAbsMH", "Color fuer Bar unter AbsMH", "zdf_orange", 25, 55, "")
	RegisterParameterString("theColorOberAbsMH", "Color fuer Bar ueber AbsMH", "ja", 25, 55, "")
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
	Dim aGroupLabList, aGroupValueNumList, aGroupValueTxtList, aGroupEleList, aEleLabel1, aEleLabel2, aEleLabel3 As Array[String]
	Dim aEleMaterial, aEleValueNum, aEleValueTxt, aEleDiffNum, aEleDiffTxt, aEleSummary As Array[String]
	Dim aEleAnimOrder, aEleRangeValues, aStrHelp As Array[String]
	Dim iGroup As Integer
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
	strTemp = GetParameterString("theGroupNum")
	strTemp.Split( strGroupSeparator, aGroupValueNumList )
	strTemp = GetParameterString("theGroupTxt")
	strTemp.Split( strGroupSeparator, aGroupValueTxtList )
	
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
	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strGroupSeparator, aEleRangeValues )
	
	'read summary
	strTemp = GetParameterString("theSummary")
	strTemp.Split( strElementSeparator, aEleSummary )
	
	sgraphicsData.strSitzeGesamt = aEleSummary[0]
	sgraphicsData.strSitzeMehrheit = aEleSummary[1]

	sGraphicsData.nGroups = aGroupEleList.UBound

	fMaxBarValue = 0.0

	'read color of bars
	strColorUnterAbsMH = GetParameterString("theColorUnterAbsMH")
	strColorOberAbsMH = GetparameterString("theColorOberAbsMH")

	' read group and element details
	sGraphicsData.aGroup.Clear()
	For iGroup = 0 To sGraphicsData.nGroups
	
		Scene.dbgOutput( 1, strDebugLocation, "reading data of [iGroup]: [" & iGroup & "]" )
		sGroupData.nElements = CInt( aGroupEleList[ iGroup ] )
		sGroupData.strLabel  = aGroupLabList[ iGroup ]
		sGroupData.dblGValueNum = CDbl( aGroupValueNumList[ iGroup ] )
		sGroupData.strGValueTxt = aGroupValueTxtList[ iGroup ]

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
		
		' check for max value
		If sGroupData.dblMinValue = 0.0 And sGroupData.dblMaxValue = 0.0 Then

			dblTempMinValue = 0.0
			dblTempMaxValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
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

	' get maxVizValue
	fMaxVizValue = sGlobalParameter.dblMaxVizValueUMKB
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
	Dim contGroup, contElement, contMH, contMHText, contGEText As Container
	Dim tmpGroupName, tmpElementName, strHelp As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue, dblScaleFactor, dblZeroPosY As Double
	Dim iGroup, iElement As Integer
	Dim fMinRange, fMaxRange, dblMHScaleFactor As Double

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' calculate scaling factor and posY of zero plane
	fMinRange = sGraphicsData.aGroup[0].dblMinValue
	fMaxRange = sGraphicsData.aGroup[0].dblMaxValue
	dblScaleFactor = ( fMaxVizValue - fMinVizValue ) / ( fMaxRange - fMinRange )
	
	' calculate reference line position
	dblValue = dblScaleFactor * sGraphicsData.dblRefValue
	contBlenderElementIN.FindSubcontainer( kEleRefText ).Position.Y = dblValue
	contBlenderElementIN.FindSubcontainer( kEleRefText & kTextSubPath ).Geometry.Text = DoubleToString( sGraphicsData.dblRefValue, 0 )
	contBlenderElementIN.FindSubcontainer( kEleRefPlane ).Position.Y = dblValue

	For iGroup = 0 To sGraphicsData.nGroups

		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		tmpGroupName = kGroupBaseName & iGroup+1
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "[tmpGroupName]: [" & tmpGroupName & "]")
		' update group label
		strHelp = sGraphicsData.aGroup[iGroup].strLabel
		strHelp.Substitute("[_]", "\n", TRUE)
		contGroup.FindSubcontainer( kTextGroupLabelSubPath ).Geometry.Text = strHelp

		' show correct number of dots
		contGroup.FindSubContainer( kDotGroupSubPath ).GetFunctionPluginInstance( "Omo" ).SetParameterInt( "vis_con", sGraphicsData.aGroup[iGroup].nElements - 1 )
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")

			' calculate and set animation value
			If iElement = 0 Then
				' calculate and set animation value
				dblValue = dblScaleFactor * sGraphicsData.aGroup[iGroup].dblGValueNum
				' always show some color
				dblValue =  Scene._validateMinBarValue( dblValue, 0.1 )
				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
				
				If sGraphicsData.aGroup[iGroup].dblGValueNum >= CDbl(sGraphicsData.strSitzeMehrheit) Then
					tmpMaterial = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).CreateMaterial(kServerMaterialPath & strColorOberAbsMH)
					contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).material = tmpMaterial
				ElseIf sGraphicsData.aGroup[iGroup].dblGValueNum < CDbl(sGraphicsData.strSitzeMehrheit) Then
					tmpMaterial = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).CreateMaterial(kServerMaterialPath & strColorUnterAbsMH)
					contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).material = tmpMaterial
				End If
				
				' set text value and labels
				contElement.FindSubContainer(kDataSubPath & kTextValueSubPath & kValueSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].strGValueTxt
'println "...DEBUG:: [" & iElement & "] [$" & contElement.Name & kDataSubPath & kTextValueSubPath & kValueSubPath & "] [" & sGraphicsData.aGroup[iGroup].strGValueTxt & "]"
			End If
		
			' set element material
			Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")

'		' show correct number of dots
'		contGroup.FindSubContainer( kDotGroupSubPath ).GetFunctionPluginInstance( "Omo" ).SetParameterInt( "vis_con", sGraphicsData.aGroup[iGroup].nElements - 1 )

			tmpMaterial = contGroup.FindSubContainer( kDotGroupSubPath & kDotGroupBasename & CStr(sGraphicsData.aGroup[iGroup].nElements) & kDotEleBaseName & CStr(iElement+1) ).CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
			contGroup.FindSubContainer( kDotGroupSubPath & kDotGroupBasename & CStr(sGraphicsData.aGroup[iGroup].nElements) & kDotEleBaseName & CStr(iElement+1) ).Material = tmpMaterial


'println "---DEBUG:: [$" & contGroup.Name & kDotGroupSubPath & kDotGroupBasename & CStr(sGraphicsData.aGroup[iGroup].nElements) & kDotEleBaseName & CStr(iElement+1) & "] [" & contGroup.FindSubContainer( kDotGroupSubPath & kDotGroupBasename & CStr(sGraphicsData.aGroup[iGroup].nElements) & kDotEleBaseName & CStr(iElement+1) ).vizID & "]"

'			tmpMaterial = contElement.FindSubContainer("$DATA$obj_geom").CreateMaterial("MATERIAL*ZDFWahlen_v3/9_SHARED/material/" & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
'			contElement.FindSubContainer("$DATA$obj_geom").Material = tmpMaterial
						
			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")

		Next

	Next	
	
	' calc position of abs line
	' set lable sitze insgesamt and absolute mehrheit
		dblMHScaleFactor = ( kMaxMHScaleFactor ) / ( fMaxRange - fMinRange )
		'println "kMaxMHScaleFactor = " & kMaxMHScaleFactor & " fMaxRange = " & fMaxRange & " fMinRange = " & fMinRange
		'println "dblMHScaleFactor = " & dblMHScaleFactor
		
	    contMHText = contBlenderElementIN.FindSubContainer(kLegendePath & kAbsMHGroupPath & kAbsMHText)
		contGEText = contBlenderElementIN.FindSubContainer(kLegendePath & kGesamtText)
		
		contMHText.Geometry.Text = "absolute Mehrheit " & sGraphicsData.strSitzeMehrheit
		contGEText.Geometry.Text = "Sitze gesamt " & sGraphicsData.strSitzeGesamt
		
		If CInt(sGraphicsData.strSitzeMehrheit) < 100 Then
			contMHText.Position.x = 3.5
		ElseIf CInt(sGraphicsData.strSitzeMehrheit) > 100 Then
			contMHText.Position.x = 4.0 
		End If
		
		contMH = contBlenderElementIN.FindSubContainer(kLegendePath & kAbsMHGroupPath)
		contMH.Position.x = CInt(sGraphicsData.strSitzeMehrheit) * dblMHScaleFactor
		'println "contMH.Position.x = " & contMH.Position.x
		
	
End Sub
'-------------------------------------------------------------------------------





