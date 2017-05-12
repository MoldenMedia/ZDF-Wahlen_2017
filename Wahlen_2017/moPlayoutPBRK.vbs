'-------------------------------------------------------------------------------
Dim theAuthor           As String = "Thomas Molden"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "11.05.2017"
Dim theContactDetails   As String = "thomas@molden.de"
Dim theCopyrightDetails As String = "(c) 2007, 2008 Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "POLITBAROMETER: Ranking - moPlayoutPBRK_v00"
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim fMinVizValue, fMaxVizValue As Double 
Dim fMinBarValue, fMaxBarValue As Double

Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------

Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kTextGroupLabelSubPath   As String = "$GROUP_LABEL$TRANS$txt_info"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"
Dim kBarColoredSubPathMirror As String = "$obj_geom_mirror"
Dim kArrowSubPath            As String = "$TRANS$ELE_ARROW"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"

Dim kImage_front             As String = "$GFX_IMAGE$img_front"
Dim kImage_shadow            As String = "$GFX_IMAGE$img_shadow"
Dim kName                    As String = "$GFX_IMAGE$txt_name"
Dim kParteiLabel             As String = "$GFX_IMAGE$txt_partei"


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
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName As String
	nGroups     As Integer
	aGroup      As Array[structGroupData]
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
	
	RegisterParameterString("theElementName", "element name [gPBRK]:", "/POLITBAROMETER/gPBRK", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [10]:", "10", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "lab1lin1#lab2lin1#lab3lin1", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [name1|name2|...]:", "name1|name2|name3|name4|name5|name6|name7|name8|name9|name10", 55, 512, "")
	RegisterParameterString("theLabel2", "label line 2 [...]:", "|||||||||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [...]:", "|||||||||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [2.8|2.7|...]:", "2.8|2.7|2.4|1.9|1.3|1.0|0.3|-0.2|-0.5|-1.5", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [+2,8|+2,7|...]:", "+2,8|+2,7|+2,4|+1,9|+1,3|+1,0|+0,3|-0,2|-0,5|-1,5", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [1|1|...]:", "1|1|1|0|1|-1|2|-1|-1|-1", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [1|1|...]:", "1|1|1|0|1|-1|2|-1|-1|-1", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2|...]:", "1|2|3|4|5|6|7|8|9|10", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "currently|not|used|||||||", 55, 256, "")
	RegisterParameterString("theImageName", "Image [image1|image2]:", "polneu_steinbrueck|polneu_merkel|polneu_lafontaine|polneu_stoiber|polneu_beck|polneu_steinmeier|polneu_von_der_leyen|polneu_schaeuble|polneu_westerwelle|polneu_muentefering", 100, 512, "")
	
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
	Dim aEleAnimOrder, aEleImageName As Array[String]
	Dim iGroup As Integer
	Dim dblTempMinValue, dblTempMaxValue As Double
	
	' get group data
	strTemp = GetParameterString("theNumElements")
	strTemp.Split( strGroupSeparator, aGroupEleList )
	
'!!! workarround for names	 !!!
'	strTemp = GetParameterString("theGroupLabel")
	strTemp = GetParameterString("theLabel2")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aGroupLabList )
	strTemp = GetParameterString("theLabel1")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleLabel1 )
	strTemp = GetParameterString("theLabel2")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleLabel2 )
	strTemp = GetParameterString("theLabel3")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleLabel3 )
	strTemp = GetParameterString("theMaterial")
	strTemp.Split( strGroupSeparator, aEleMaterial )
	strTemp = GetParameterString("theValueNum")
	strTemp.Split( strGroupSeparator, aEleValueNum )
	strTemp = GetParameterString("theValueTxt")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleValueTxt )
	strTemp = GetParameterString("theDiffNum")
	strTemp.Split( strGroupSeparator, aEleDiffNum )
	strTemp = GetParameterString("theDiffTxt")
	strTemp.AnsiToUTF8()
	strTemp.Split( strGroupSeparator, aEleDiffTxt )
	strTemp = GetParameterString("theAnimOrderFlag")
	strTemp.Split( strGroupSeparator, aEleAnimOrder )
	strTemp = GetParameterString("theImageName")
	strTemp.Split( strGroupSeparator, aEleImageName )

	sGraphicsData.nGroups = aGroupEleList.UBound
	
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
		aEleImageName[iGroup].Split( strElementSeparator, sGroupData.aImageName )
		aEleAnimOrder[iGroup].Split( strElementSeparator, sGroupData.aAnimOrderFlag )
		
		' get maxDblValue
		dblTempMaxValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
		dblTempMinValue = Scene._getMinBaxValue( sGroupData.aValueNum )

		If dblTempMaxValue > fMaxBarValue Then
			fMaxBarValue = dblTempMaxValue
		End If
		If dblTempMinValue < fMinBarValue Then
			fMinBarValue = dblTempMinValue
		End If

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	' get maxVizValue
	fMaxVizValue = sGlobalParameter.dblMaxVizValuePBRK
	fMinVizValue = sGlobalParameter.dblMinVizValuePBRK

	Scene.dbgOutput(1, strDebugLocation, "[fMinVizValue] [fMaxVizValue] [fMinBarValue] [fMaxBarValue]: ["	& fMinVizValue & "] [" & fMaxVizValue & "] [" & fMinBarValue & "] [" & fMaxBarValue & "]" )
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

	Dim contBlenderElementIN  As Container
	contBlenderElementIN  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")

	Dim iGroup As Integer
	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		Dim tmpGroupName As String
		tmpGroupName = kGroupBaseName & iGroup+1

		Dim contGroup As Container
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "[tmpGroupName]: [" & tmpGroupName & "]")
		' update group label
		' !!! group label inside element structure !!!
		' contGroup.FindSubcontainer( kTextGroupLabelSubPath ).Geometry.Text = sGraphicsData.aGroup[iGroup].strLabel
		
		Dim iElement As Integer
		For iElement = sGraphicsData.aGroup[iGroup].nElements - 1 To 0 Step -1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			Dim tmpElementName As String
			tmpElementName = kElementBaseName & iElement + 1

			Dim contElement As Container
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")
			
			'Dim dblValue As Double
			' set scaling of bars dependend on values
			'dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[9-iElement] )
			'dblValue = fMinVizValue + (dblValue - fMinBarValue) * (fMaxVizValue - fMinVizValue) / (fMaxBarValue - fMinBarValue)
			'println "...... [aValueNum[" & iElement & "]] [dblValue] [fminVizValue] [fMaxVizValue] [fMinBarValue] [fMaxBarValue]: [" & sGraphicsData.aGroup[iGroup].aValueNum[9-iElement] & "] [" & dblValue & "] [" & fminVizValue & "] [" & fMaxVizValue & "] [" & fMinBarValue & "] ["	& fMaxBarValue & "]"
			
			'contElement.FindSubContainer( "$DATA$obj_geom" ).FindKeyframeOfObject("k_end").XyzValue.Y = dblValue
			'contElement.FindSubContainer( "$DATA$obj_geom_mirror" ).FindKeyframeOfObject("k_end").XyzValue.Y = dblValue
						
			' set text value and labels
			contElement.FindSubContainer( "$DATA$GFX_DATA$txt_ranking" ).Geometry.Text = CStr( 10 - iElement )
			contElement.FindSubContainer( "$DATA$GFX_DATA$txt_name" ).Geometry.Text = sGraphicsData.aGroup[iGroup].aLabel1[9-iElement]

			' set label and arrow
			contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$TXT_CHANGE$txt_value" ).Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[9-iElement]

			' disable this completely, it is not used.
			contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$TXT_CHANGE$txt_unchanged" ).Active = FALSE
			contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$TXT_CHANGE$txt_up" ).Active = FALSE
			contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$TXT_CHANGE$txt_down" ).Active = FALSE

			' arrow
			dim contarrowunch as Container
			contarrowunch = contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$ELE_ARROW$obj_unchanged" )
			
			dim contarrowup as Container
			contarrowup = contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$ELE_ARROW$obj_up" )
			
			dim contarrowdown as Container
			contarrowdown = contElement.FindSubContainer( "$DATA$GFX_DATA$LABEL$ELE_ARROW$obj_down" )

			dim tnr as integer
			tnr = CInt( sGraphicsData.aGroup[iGroup].aDiffNum[9-iElement] )

			If tnr = 0 Then
				' unchanged
				contarrowunch.Active = true
				contarrowup.Active = FALSE
				contarrowdown.Active = FALSE
			ElseIf tnr = -1 Then
				' down
				contarrowunch.Active = FALSE
				contarrowup.Active = FALSE
				contarrowdown.Active = true
			ElseIf tnr = 1 Then
				' up
				contarrowunch.Active = FALSE
				contarrowup.Active = true
				contarrowdown.Active = FALSE
			ElseIf tnr = 2 Then
				' nothing
				contarrowunch.Active = FALSE
				contarrowup.Active = FALSE
				contarrowdown.Active = FALSE
			End If

			' set image
			contElement.FindSubContainer("$DATA$GFX_DATA$img_image" ).CreateTexture( sGlobalParameter.strGlobImagePath & "wahlen/politiker/" & sGraphicsData.aGroup[iGroup].aImageName[9-iElement] )

			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[9-iElement] & "]")
			
			println "************[ANIM_PBRK] []: [ANIM_PBRK] [" & CStr(CInt(sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement]) + 1 ) & "]"
		Next
	Next	

	'	Scene._PlayoutAnimationSubDirectorAdd( Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT"), "ANIM_PBRK" )
	'	Scene._PlayoutAnimationDirectorNameAdd( "ANIM_PBRK", CStr(CInt(sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement]) + 1) )
	'	Scene._PlayoutAnimationDirectorNameAdd( "ANIM_PBRK", CStr(CInt(sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement]) + 1 ) )
		Scene._PlayoutAnimationDirectorNameAdd( "ANIM_PBRK", "11" )
	
End Sub
'-------------------------------------------------------------------------------

