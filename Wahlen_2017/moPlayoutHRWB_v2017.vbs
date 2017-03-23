'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "05.10.2007"
Dim theDateModified     As String = "23.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "HOCHRECHNUNG: Wahlbeteiligung - moPlayoutHRWB_v00"
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim fMaxVizValue As Double
Dim fMaxBarValue As Double
Dim fLabelHeight As Double = 3.5

' NOTE:
' Noggi Width  = 736.5 is 1920 pixel screen size -> factor 2.6069
' Noggi Height = 414.2 is 1080 pixel screen size -> factor 2.6074
Dim kHRWBWidth As Double = 265.0    ' 101.65 pixel

Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"
Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

' container definitions
Dim contElementPool As Container
Dim contBlenderElementIN  As Container
Dim contBlenderElementOUT As Container

Dim sGlobalParameter As Scene.structGlobalParameter

'-------------------------------------------------------------------------------
' Graphic structure definitions
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contBarObj1, contBarObj2 As Container
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
End Structure
'-------------------------------------------------------------------------------
Structure structGraphicsData
	strElemName        As String
	strTypeOfGraphic   As String
	blnInfoPercentFlag As Boolean
	nGroups            As Integer
	aGroup             As Array[structGroupData]
	strDifference      As String
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
	
	RegisterParameterString("theElementName", "element name [gHRWB]:", "gHRWB", 25, 55, "")
	RegisterParameterString("theNumElements", "number of elements in groups [3]:", "3", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "2005||2009", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "63.5|2.5|67.6", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "63,5|2,5|67,6", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "||", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "||", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2|2", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "neutral_1||neutral_1", 55, 256, "")
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
	Dim aEleAnimOrder As Array[String]
	Dim iGroup, nMaxLabel As Integer
	Dim dblTempValue As Double
	
	' set type of graphics
	sGraphicsData.strTypeOfGraphic = "HRWB"
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
	
	nMaxLabel = 0 
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
		
'Scene.dbgOutput(1, "readGraphicsData(): ", "..[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")
		aEleLabel1[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel2[iGroup].Substitute("[|]", "", TRUE)
		aEleLabel3[iGroup].Substitute("[|]", "", TRUE)
		
		If aEleLabel1[iGroup] <> "" And nMaxLabel < 1 Then
			nMaxLabel = 1
		End If
		If aEleLabel2[iGroup] <> "" And nMaxLabel < 2 Then
			nMaxLabel = 2
		End If
		If aEleLabel3[iGroup] <> "" And nMaxLabel < 3 Then
			nMaxLabel = 3
		End If
		dblTempValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
		If dblTempValue > fMaxBarValue Then
			fMaxBarValue = dblTempValue
		End If
		
'Scene.dbgOutput(1, "readGraphicsData(): ", "....[aEleLabel1[" & iGroup & "]]: [" & aEleLabel1[iGroup] & "]")

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	fMaxVizValue = sGlobalParameter.dblMaxVizValueHRWB - (nMaxLabel-1)*sGlobalParameter.dblMaxVizValueHRLabHeight
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
			Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.aGroup[" & iGroup & "].aAnimOrderFlag[" & iElement & "]]: [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
		Next
		
	Next

	Scene.dbgOutput(1, strDebugLocation, "[sGraphicsData.strDifference]: [" & sGraphicsData.strDifference & "]")
	

	Scene.dbgOutput(1, strDebugLocation, "....done [sGraphicsData]----------------------------------------")
	
End Sub
'-------------------------------------------------------------------------------
'
Dim kGroupBaseName           As String = "$G"
Dim kElementBaseName         As String = "_E"

Dim kTransSubPath            As String = "$TRANS"
Dim kTextGroupLabelSubPath   As String = "$GROUP_LABEL$TRANS$txt_info"
Dim kDataSubPath             As String = "$DATA"

Dim kBarColoredSubPath       As String = "$obj_geom"
Dim kArrowSubPath            As String = "$TRANS$ELE_ARROW"
Dim kArrowUpObjSubPath       As String = "$obj_arrow_up"
Dim kArrowUnchObjSubPath     As String = "$obj_arrow_unch"
Dim kArrowDownObjSubPath     As String = "$obj_arrow_down"

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim contGroup, contElement As Container
	Dim tmpGroupName, tmpElementName As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue As Double
	Dim iGroup, iElement As Integer

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' set visibility of info percent label
	contBlenderElementIN.FindSubcontainer( kTransSubPath & kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

	For iGroup = 0 To sGraphicsData.nGroups
		Scene.dbgOutput(1, strDebugLocation, "updating [iGroup]: [" & iGroup & "] ----------------------------------------------------")

		' get reference to group container
		tmpGroupName = kGroupBaseName & iGroup+1
		contGroup = contBlenderElementIN.FindSubcontainer( kTransSubPath & tmpGroupName )
		Scene.dbgOutput(1, strDebugLocation, "[tmpGroupName]: [" & tmpGroupName & "]")
		' update group label
		contGroup.FindSubcontainer( kTextGroupLabelSubPath ).Geometry.Text = sGraphicsData.aGroup[iGroup].strLabel
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1

			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[strContPath] [contElement.Name]: [" & kTransSubPath & tmpGroupName & tmpElementName & "] [" & contElement.Name & "]")

			' process 1st and 3rd bar only
			If iElement = 0 Or iElement = 2 Then

				' calculate and set animation value
				dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
				dblValue = dblValue * fMaxVizValue / fMaxBarValue
				contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
	
				' set text value and labels
				Scene.dbgOutput(1, strDebugLocation, "[kDataSubPath & kTextDataSubPath] [aValueTxt]: [" & kDataSubPath & kTextDataSubPath & "] [" & sGraphicsData.aGroup[iGroup].aValueTxt[iElement] & "] [" & sGraphicsData.aGroup[iGroup].aLabel1[iElement] & "]")
				Scene._updateScene_assignLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue )
				
				' set element material
				Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath & "]" & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
				tmpMaterial = contElement.FindSubContainer("$DATA$obj_geom").CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
				contElement.FindSubContainer("$DATA$obj_geom").Material = tmpMaterial
				contElement.FindSubContainer("$DATA$obj_geom").FindKeyframeOfObject("k_value").FloatValue = dblValue

			ElseIf iElement = 1 Then

				' set rotation angle
				If CDbl( sGraphicsData.aGroup[0].aValueNum[1] ) = 0.0 Then
					contElement.FindSubContainer( kDataSubPath & kArrowUpObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowUnchObjSubPath ).Active = TRUE
					contElement.FindSubContainer( kDataSubPath & kArrowDownObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowUnchObjSubPath ).Rotation.Z = 0.0
					' set arrow label
					contElement.FindSubContainer( kDataSubPath & kTextValueSubPath & kTextSubPath ).Geometry.Text = "±" & sGraphicsData.aGroup[0].aValueTxt[1]
				ElseIf CDbl( sGraphicsData.aGroup[0].aValueNum[1] ) > 0 Then
					contElement.FindSubContainer( kDataSubPath & kArrowUpObjSubPath ).Active = TRUE
					contElement.FindSubContainer( kDataSubPath & kArrowUnchObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowDownObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowUpObjSubPath ).Rotation.Z = 20.0
					' set arrow label
					contElement.FindSubContainer( kDataSubPath & kTextValueSubPath & kTextSubPath ).Geometry.Text = "+" & sGraphicsData.aGroup[0].aValueTxt[1]
				ElseIf CDbl( sGraphicsData.aGroup[0].aValueNum[1] ) < 0 Then
					contElement.FindSubContainer( kDataSubPath & kArrowUpObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowUnchObjSubPath ).Active = FALSE
					contElement.FindSubContainer( kDataSubPath & kArrowDownObjSubPath ).Active = TRUE
					contElement.FindSubContainer( kDataSubPath & kArrowDownObjSubPath ).Rotation.Z = -20.0
					' set arrow label
					contElement.FindSubContainer( kDataSubPath & kTextValueSubPath & kTextSubPath ).Geometry.Text = sGraphicsData.aGroup[0].aValueTxt[1]
				End If

				' check for empty label
				If sGraphicsData.aGroup[0].aValueTxt[1] = "" Then
					contElement.FindSubContainer( kDataSubPath & kTextValueSubPath & kTextSubPath ).Geometry.Text = ""
				End If
			
			End If

			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")
			
		Next
		
	Next	
	
End Sub
'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------



