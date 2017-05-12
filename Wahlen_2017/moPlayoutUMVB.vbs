'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "23.04.2017 ao"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "UMFRAGE: Balken-Bilder - moPlayoutUMVB_v00"
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

' container definitions


Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextValueDiffSubPath    As String = "$TXT_VALUE_DIFF"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"
Dim kTextDiffSubPath         As String = "$txt_value_diff"
Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"

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
	aImageName     As Array[String]
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
	
	RegisterParameterString("theTypeOfGraphic", "type of graphic [UMVB|UMVBPD]:", "UMVB", 50, 75, "")
	RegisterParameterString("theElementName", "element name [gUMVB]:", "gGenerated", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [2#2#...]:", "1#1#1", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "lab1lin1#lab2lin1#lab3lin1", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [CDU/CSU|SPD#...]:", "v1. name1#v2. name2#v3. name3", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "##", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "##", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "63.5#57.6#51.23", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "63,5#57,6#51,2", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4#-3.4#3.7", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-5,0#-3,4#+3,7", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1#2#3", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu#spd#fdp", 55, 256, "")
	RegisterParameterString("theImageName", "Image [image1|image2]:", "merkel#beck#lafontaine", 55, 256, "")
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
	Dim aGroupLabList, aGroupEleList, aEleLabel1, aEleLabel2, aEleLabel3 As Array[String]
	Dim aEleMaterial, aEleValueNum, aEleValueTxt, aEleDiffNum, aEleDiffTxt As Array[String]
	Dim aEleAnimOrder, aEleImageName, aEleRangeValues, aStrHelp As Array[String]
	
	' get type of graphics
	sGraphicsData.strTypeOfGraphic = GetParameterString("theTypeOfGraphic")
	' get info percent label flag
	sGraphicsData.blnInfoPercentFlag = GetParameterBool("thePercentInfoFlag")
	
	' get group data
	Dim strTemp As String
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
	strTemp = GetParameterString("theImageName")
	strTemp.Split( strGroupSeparator, aEleImageName )
	strTemp = GetParameterString("theRangeValues")
	strTemp.Split( strGroupSeparator, aEleRangeValues )

	sGraphicsData.nGroups = aGroupEleList.UBound
	
	nVisibleLabel = 1 

	Dim fMinBarValue, fMaxBarValue As Double
	fMaxBarValue = 0.0
	fMinBarValue = 0.0

	' read group and element details
	sGraphicsData.aGroup.Clear()

	Dim iGroup As Integer
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
		aEleImageName[iGroup].Split( strElementSeparator, sGroupData.aImageName )
		aEleAnimOrder[iGroup].Split( strElementSeparator, sGroupData.aAnimOrderFlag )
		aEleRangeValues[iGroup].Split( strElementSeparator, aStrHelp )
		
		do while aStrHelp.ubound < 2
			aStrHelp.push("0")
		loop

		sGroupData.dblMinValue = CDbl( aStrHelp[0] )
		sGroupData.dblMaxValue = CDbl( aStrHelp[1] )
		
		aEleLabel1[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel2[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel3[iGroup].Substitute("[|]", "", TRUE)
		
		do while sGroupData.aLabel1.ubound < 3
			sGroupData.aLabel1.push("")
		loop
		do while sGroupData.aLabel2.ubound < 3
			sGroupData.aLabel2.push("")
		loop
		do while sGroupData.aLabel3.ubound < 3
			sGroupData.aLabel3.push("")
		loop

		If aEleLabel1[iGroup] <> "" And nVisibleLabel < 1 Then
			nVisibleLabel = 1
		End If
		If aEleLabel2[iGroup] <> "" And nVisibleLabel < 2 Then
			nVisibleLabel = 2
		End If
		If aEleLabel3[iGroup] <> "" And nVisibleLabel < 3 Then
			nVisibleLabel = 3
		End If

		sGroupData.dblMaxValue = Scene._getMaxStrArrayValue( sGroupData.aValueNum, sGroupData.dblMaxValue )
		If iGroup = 0 or sGroupData.dblMaxValue > fMaxBarValue Then
			fMaxBarValue = sGroupData.dblMaxValue
		End If

		sGroupData.dblMinValue = Scene._getMinStrArrayValue( sGroupData.aValueNum, sGroupData.dblMinValue )
		If iGroup = 0 or sGroupData.dblMinValue < fMinBarValue Then
			fMinBarValue = sGroupData.dblMinValue
		End If

		println "DEBUG: GRP [fMinBarValue] [fMaxBarValue]: [" & fMinBarValue & "] [" & fMaxBarValue & "]" 

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	println "DEBUG: FINAL [fMinBarValue] [fMaxBarValue]: [" & fMinBarValue & "] [" & fMaxBarValue & "]" 
	println "DEBUG: [nVisibleLabel]: ["	& nVisibleLabel & "]" 

	' now override local groups minmax with global
	For iGroup = 0 To sGraphicsData.nGroups
		sGraphicsData.aGroup[iGroup].dblMinValue = fMinBarValue
		sGraphicsData.aGroup[iGroup].dblMaxValue = fMaxBarValue
	Next

'	dumpData()
End Sub
'-------------------------------------------------------------------------------
'
Sub dumpData()
	Dim strDebugLocation As String = strScriptName & "dumpData():"

	Scene.dbgOutput(1, strDebugLocation, "start... [sGraphicsData]----------------------------------------")
	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.nGroups]: [" & sGraphicsData.nGroups & "]")

	Dim iGroup As Integer
	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "printing [iGroup]: [" & iGroup & "] ----------------------------------------------------")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].strLabel]: [" & sGraphicsData.aGroup[iGroup].strLabel & "]")
		Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].nElements]: [" & sGraphicsData.aGroup[iGroup].nElements & "]")
		
		Dim iElement As Integer
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
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aImagename[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aImagename[iElement] & "]")
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

	' calculate posY of zero plane
	Dim fMinRange, fMaxRange As Double
	fMinRange = sGraphicsData.aGroup[0].dblMinValue ' these are equal for all groups
	fMaxRange = sGraphicsData.aGroup[0].dblMaxValue

	' get maxVizValue 
	Dim fMinVizValue As Double 
	fMinVizValue = 0.0

	Dim fMaxVizValue As Double 
	if nVisibleLabel = 1 then
		fMaxVizValue = 56
	elseif nVisibleLabel = 2 then
		fMaxVizValue = 45
	elseif nVisibleLabel = 3 then
		fMaxVizValue = 33
	end if

	Scene.dbgOutput(1, strDebugLocation, "[fMaxVizValue] [fMinRange] [fMaxRange]: [" & fMaxVizValue & "] [" & fMinRange & "] [" & fMaxRange & "]" )

	Dim dblScaleFactor As Double
	dblScaleFactor = ( fMaxVizValue - fMinVizValue ) / ( fMaxRange - fMinRange )

	'println "DEBUG: ------------------------------------------------"
	'println "DEBUG: [sGlobalParameter.dblUMLabHeight]: ["	& sGlobalParameter.dblUMLabHeight & "]" 
	'println "DEBUG: [fMinVizValue] [fMaxVizValue]: ["	& fMinVizValue & "] [" & fMaxVizValue & "]" 
	'println "DEBUG: [fMinRangeValue] [fMaxRangeValue]: ["	& fMinRange & "] [" & fMaxRange & "]" 
	'println "DEBUG: [dblScaleFactor] [dblZeroPosY]: ["	& dblScaleFactor & "] [" & dblZeroPosY & "]" 
	'println "DEBUG: [dblZeroPosY]: ["	& dblZeroPosY & "]" 
	'println "DEBUG: [scaleFactor = (fMaxVizValue-fMinVizValue-2*labelHeigth)/(fMaxRange-fMinRange)]: ["	& dblScaleFactor & "=(" & fMaxVizValue & "-" & fMinVizValue & "-2*" & sGlobalParameter.dblUMLabHeight & ")/(" & fMaxRange & "-" & fMinRange & ") = " & dblScaleFactor
	'println "DEBUG: [zeroPosY]: ["	& dblZeroPosY & "]" 

	' set visibility of info percent label
	Dim contBlenderElementIN  As Container
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderElementIN.FindSubcontainer( kTransSubPath & kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

	Dim iGroup As Integer
	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		Dim contGroup As Container
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & kGroupBaseName & (iGroup+1) )
		Scene.dbgOutput(1, strDebugLocation, "[contGroup.Name]: [" & contGroup.Name & "]")

		' white rect
		if true then
			dim theC as Container
			theC = contGroup.FindSubcontainer( "$objBanner" )

			dim valKe as double

			if nVisibleLabel = 1 then
				theC.Position.Y = 0
				valKe = 24
			elseif nVisibleLabel = 2 then
				theC.Position.Y = 6
				valKe = 36
			elseif nVisibleLabel = 3 then
				theC.Position.Y = 12
				valKe = 48
			end if
			
			theC.FindKeyframeOfObject("k_value").FloatValue = valKe
		end if
		
		Dim iElement As Integer
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			Dim contElement As Container
			contElement = contGroup.FindSubcontainer( kTransSubPath & "$" & contGroup.Name & kElementBaseName & (iElement+1) )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")

			' calculate and set animation value
			Dim dblValue As Double
			dblValue = dblScaleFactor * CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
			' always show some color
			dblValue =  Scene._validateMinBarValue( dblValue, 0.3 )

			' colored bar rectangle
			Dim colorBarC As Container
			colorBarC = contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath )
			colorBarC.FindKeyframeOfObject("k_value").FloatValue = dblValue

			Dim justifyC As Container
			justifyC = contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY")

			Dim blueBgC As Container
			blueBgC = contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$bg")

			Dim lab1C, lab2C, lab3C As Container
			lab1C = contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & "$TXT_LABEL_1" )
			lab2C = contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & "$TXT_LABEL_2" ) 
			lab3C = contElement.FindSubContainer( kDataSubPath & kTextDataSubPath & "$TXT_LABEL_3" )

			' colored bar rectangle
			Dim transparC As Container
			transparC = contElement.FindSubContainer( kDataSubPath & "$GFX_ELE$transparent" )

			dim transparNog as double

			if nVisibleLabel = 1 then
				colorBarC.Position.Y = 0
				justifyC.Position.Y = 0
				blueBgC.Position.Y = -20.45
				lab1C.Position.Y = -60
				lab2C.Position.Y = -60
				lab3C.Position.Y = -60
				transparC.Position.Y = 0
				transparNog = 100
			elseif nVisibleLabel = 2 then
				colorBarC.Position.Y = 11.5
				justifyC.Position.Y = 12.4
				blueBgC.Position.Y = -8.45
				lab1C.Position.Y = -48
				lab2C.Position.Y = -48
				lab3C.Position.Y = -48
				transparC.Position.Y = 12
				transparNog = 93
			elseif nVisibleLabel = 3 then
				colorBarC.Position.Y = 23.5
				justifyC.Position.Y = 24.4
				blueBgC.Position.Y = 3.45
				lab1C.Position.Y = -36
				lab2C.Position.Y = -36
				lab3C.Position.Y = -36
				transparC.Position.Y = 24
				transparNog = 86
			end if

			transparC.Geometry.PluginInstance.SetParameterDouble("height", transparNog)

			dim textVaC as Container
			textVaC = contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath)
			
			dim textDifC as Container
			textDifC = contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueDiffSubPath)

			dim textLabC as Container
			textLabC = contElement.FindSubContainer(kDataSubPath & kTextDataSubPath)

			If sGraphicsData.strTypeOfGraphic = "UMVBPD" Then
				' set text value and labels
				textVaC.Active = false
				textDifC.Active = true
				
				Scene._updateScene_assignDiffLabel_3_2017( textLabC, sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], nVisibleLabel )
			Else
				' set text value and labels
				textVaC.Active = true
				textDifC.Active = false
				
				Scene._updateScene_assignLabel_3_2017( textLabC, sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue, nVisibleLabel )
			End If

			' set visibility of unit percent
			contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = not sGraphicsData.blnInfoPercentFlag
		
			' set element material
			Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")

			Dim tmpMaterial As Material
			tmpMaterial = colorBarC.CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
			colorBarC.Material = tmpMaterial
			colorBarC.FindKeyframeOfObject("k_value").FloatValue = dblValue
						
			' set image
			contElement.FindSubContainer( kDataSubPath & "$GFX_IMAGE$img_front" ).CreateTexture( sGlobalParameter.strGlobImagePath & "wahlen/politiker/" & sGraphicsData.aGroup[iGroup].aImageName[iElement] )

			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
		Next
		
	Next	
	
End Sub
'-------------------------------------------------------------------------------


