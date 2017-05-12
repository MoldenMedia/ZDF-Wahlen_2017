'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "10.10.2007"
Dim theDateModified     As String = "12.04.2017 tm"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden Media GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "UMFRAGE: Horizontale Balken - moPlayoutUMHX_v00"
'-------------------------------------------------------------------------------
' LAST MODIFICATONS:
' BG: fix max bars and labels for HP & HPD
' 
'-------------------------------------------------------------------------------
' global definitions
'-------------------------------------------------------------------------------
Dim strScriptName    As String = "[" & this.name & "]::"

Dim strGroupSeparator   As String = "#"
Dim strElementSeparator As String = "|"

Dim fMaxVizValue As Double 
Dim fMaxVizValueNoGrp as double
Dim fMaxBarValue As Double 
Dim fLabelHeight As Double = 3.5

' container definitions
Dim contElementPool As Container
Dim contBlenderElementIN  As Container
Dim contBlenderElementOUT As Container

'Dim cont

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

Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextDiffSubPath         As String = "$TXT_VALUE_DIFF"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kTextSubPath             As String = "$txt_value"
Dim kValueSubPath            As String = "$txt_value"
Dim kValueDiffSubPath        As String = "$txt_diff"
Dim kLabelSubPath            As String = "$txt_label"
Dim kUnitSubPath             As String = "$txt_unit"
Dim kInfoPercentSubPath      As String = "$INFO_PERCENT"

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
	
	RegisterParameterString("theTypeOfGraphic", "type of graphic [UMHP|UMHPD]:", "UMHP", 50, 75, "")
'	RegisterParameterString("theElementName", "element name [gUMHP_3333]:", "/UMFRAGE/gUMHP_3333", 50, 75, "")
	RegisterParameterString("theNumElements", "number of elements in groups [3#3#...]:", "3#3#3#3", 25, 55, "")

	RegisterParameterString("theGroupLabel", "group label line [gLabel1#gLabel2#...]:", "gLabel1#gLabel2#gLabel3#gLabel4", 55, 256, "")
	RegisterParameterString("theLabel1", "label line 1 [lab1lin1|lab2lin1#...]:", "lab11|lab12|lab13#lab21|lab22|lab23#lab31|lab32|lab33#lab41|lab42|lab43", 55, 256, "")
	RegisterParameterString("theLabel2", "label line 2 [CDU/CSU|SPD#...]:", "||#||#||#||", 55, 256, "")
	RegisterParameterString("theLabel3", "label line 3 [CDU/CSU|SPD#...]:", "||#||#||#||", 55, 256, "")

	RegisterParameterString("theValueNum", "values number [63.5|67.6|...]:", "43.5|42.6|41.2#33.2|32.3|31.2#23.3|22.1|21.5#13.1|12.2|11.4", 55, 256, "")
	RegisterParameterString("theValueTxt", "values formatted [63,5|67,6|...]:", "43,5|42,6|41,2#33,2|32,3|31,2#23,3|22,1|21,5#13,1|12,2|11,4", 55, 256, "")
	RegisterParameterString("theDiffNum", "difference number [-4|3.4|...]:", "-4.3|4.2|-4.1#3.3|-3.2|3.1#2.3|-2.2|2.1#-1.3|1.2|-1.1", 55, 256, "")
	RegisterParameterString("theDiffTxt", "difference formatted [-5,0|3,4|...]:", "-4,3|4,2|-4,1#3,3|-3,2|3,1#-2,3|2,2|-2,1#1,3|-1,2|1,1", 55, 256, "")

	RegisterParameterString("theAnimOrderFlag", "animation order flags [1|2#...]:", "1|2|3#4|5|6#7|7|7#8|8|8", 55, 55, "")
	RegisterParameterString("theMaterial", "material [material1|material2]:", "cdu|spd|fdp#cdu|spd|fdp#cdu|spd|fdp#cdu|spd|fdp", 55, 256, "")
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
	Dim iGroup As Integer
	Dim dblTempValue As Double
	
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
		
		' check for max value
		dblTempValue = Scene._getMaxBaxValue( sGroupData.aValueNum )
		If dblTempValue > fMaxBarValue Then
			fMaxBarValue = dblTempValue
		End If

		' add group to graphics
		sGraphicsData.aGroup.Push( sGroupData )
	Next

	' get maxVizValue
	If sGraphicsData.strTypeOfGraphic = "UMHPD" Or sGraphicsData.strTypeOfGraphic = "UMHD" Then
		fMaxVizValue = sGlobalParameter.dblMaxVizValueUMHPD
		fMaxVizValueNoGrp = sGlobalParameter.dblMaxVizValueUMHPD_noGrp
	Else
		fMaxVizValue = sGlobalParameter.dblMaxVizValueUMHP
		fMaxVizValueNoGrp = sGlobalParameter.dblMaxVizValueUMHP_noGrp
	End If
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
	Dim contGroup, contElement As Container
	Dim tmpGroupName, tmpElementName, strHelp As String
	Dim tmpMaterial As Material
	Dim cntIdx As Integer
	Dim dblValue As Double
	Dim iGroup, iElement As Integer
	Dim fObjGeomPosX, fobjGeomMax, fTxtDataPosX, fTxtDataDiffPosX, fTxtLabelPosX, fObjLabelBGHeight As Double

	' remember previous animation details
	Scene._PlayoutAnimationSwap()
	' clear animation
	Scene._PlayoutAnimationClear( "IN" )

	' set visibility of info percent label
	contBlenderElementIN.FindSubcontainer( kInfoPercentSubPath ).Active = sGraphicsData.blnInfoPercentFlag

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

		' define graph values depending on group label content
		strHelp.Trim()
		If strHelp = "" Then

			fObjGeomPosX      = 23.0
			fobjGeomMax       = fMaxVizValueNoGrp  ' 285.7
			fTxtDataPosX      = -25.0
			fTxtDataDiffPosX  = 330.5
			fTxtLabelPosX     = -140.5
			fObjLabelBGHeight = 248.85

		Else

			fObjGeomPosX      = 118.5
			fobjGeomMax       = fMaxVizValue  ' 150.0 190.4
			fTxtDataPosX      = 70.5
			fTxtDataDiffPosX  = 235.0
			fTxtLabelPosX     = -103.0
			fObjLabelBGHeight = 205.0

		End If
		
		For iElement = 0 To sGraphicsData.aGroup[iGroup].nElements - 1
			Scene.dbgOutput(1, strDebugLocation, "updating [iElement]: [" & iElement & "] ..................................................")
			
			' get reference to element container
			tmpElementName = kElementBaseName & iElement+1
			contElement = contGroup.FindSubcontainer( kTransSubPath & tmpGroupName & tmpElementName )
			Scene.dbgOutput(1, strDebugLocation, "[contElement.Name]: [" & contElement.Name & "]")
			
			' set graph values depending on group label content
			contElement.FindSubContainer("$DATA$obj_geom").Position.X = fObjGeomPosX
			contElement.FindSubContainer(kDataSubPath & kTextDataSubPath).Position.X = fTxtDataPosX
			fMaxVizValue = fobjGeomMax
			contElement.FindSubContainer(kDataSubPath & kTextLabel1SubPath & kLabelSubPath).Position.X = fTxtLabelPosX
			'contElement.FindSubContainer(kDataSubPath & kTextLabel1SubPath & "$objLabelBG").Geometry.PluginInstance.SetParameterDouble("height", fObjLabelBGHeight)
			contElement.FindSubContainer(kDataSubPath & kTextLabel1SubPath & "$objLabelBG").FindKeyframeOfObject("k_value").FloatValue = fObjLabelBGHeight
			' calculate and set animation value
			dblValue = CDbl( sGraphicsData.aGroup[iGroup].aValueNum[iElement] )
			dblValue = dblValue * fMaxVizValue / fMaxBarValue
			contElement.FindSubContainer( kDataSubPath & kBarColoredSubPath ).FindKeyframeOfObject("k_value").FloatValue = dblValue
'			contElement.FindSubContainer("$DATA$obj_geom").FindKeyframeOfObject("k_value").FloatValue = dblValue

			' set text value and labels
			If sGraphicsData.strTypeOfGraphic = "UMHPD" Or sGraphicsData.strTypeOfGraphic = "UMHD" Then
				contElement.FindSubContainer(kDataSubPath & kTextValueSubPath & kValueSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				' set text value and labels
				Scene._updateScene_assignLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue )
				' set text difference value
				contElement.FindSubContainer(kDataSubPath & kTextDiffSubPath).Active = TRUE
				contElement.FindSubContainer(kDataSubPath & kTextDiffSubPath & kValueDiffSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].aDiffTxt[iElement]
				contElement.FindSubContainer(kDataSubPath & kTextDiffSubPath & kValueDiffSubPath).Position.X = fTxtDataDiffPosX
				'			Scene._updateScene_assignDiffLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aDiffTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement] )
			Else
				contElement.FindSubContainer(kDataSubPath & kTextValueSubPath & kValueSubPath).Geometry.Text = sGraphicsData.aGroup[iGroup].aValueTxt[iElement]
				contElement.FindSubContainer(kDataSubPath & kTextDiffSubPath).Active = FALSE
				' set text value and labels
				Scene._updateScene_assignLabel_3( contElement.FindSubContainer(kDataSubPath & kTextDataSubPath), sGraphicsData.strTypeOfGraphic, sGraphicsData.aGroup[iGroup].aValueTxt[iElement], sGraphicsData.aGroup[iGroup].aLabel1[iElement], sGraphicsData.aGroup[iGroup].aLabel2[iElement], sGraphicsData.aGroup[iGroup].aLabel3[iElement], dblValue )
			End If
			
			' set visibility of unit percent
			If sGraphicsData.blnInfoPercentFlag = True Then
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = False
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.x = 1.0
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.y = 1.0
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.z = 1.0
			Else
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$txt_unit").Active = True
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.x = 0.8
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.y = 0.8
				contElement.FindSubContainer(kDataSubPath & kTextDataSubPath & kTextValueSubPath & "$JUSTIFY").Scaling.z = 0.8
			End If

			' set element material
			Scene.dbgOutput(1, strDebugLocation, "[tmpMaterial]: [" & kServerMaterialPath  & sGraphicsData.aGroup[iGroup].aMaterial[iElement] & "]")
			tmpMaterial = contElement.FindSubContainer("$DATA$obj_geom").CreateMaterial(kServerMaterialPath & sGraphicsData.aGroup[iGroup].aMaterial[iElement] )
			contElement.FindSubContainer("$DATA$obj_geom").Material = tmpMaterial

			' add animation index to playout control
			Scene._PlayoutAnimationAdd( contElement, sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] )
			Scene.dbgOutput(1, strDebugLocation, "[director name] [animOrderFlag]: [" & contElement.Name & "] [" & sGraphicsData.aGroup[iGroup].aAnimOrderFlag[iElement] & "]")

		Next
		
	Next	
	
End Sub
'-------------------------------------------------------------------------------



