'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "25.10.2007"
Dim theDateModified     As String = "15.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "LEGENDEN: Legenden - moLegends_v00"
'-------------------------------------------------------------------------------
Dim strScriptName As String = "[" & this.name & "]::"
'-------------------------------------------------------------------------------

Dim contBlenderEleIN As Container
Dim cntFieldDelay As Integer = 0
Dim blnExecPerField As Boolean = FALSE
Dim numFieldDelay As Integer

Dim kServerMaterialPath As String = "MATERIAL*ZDFWahlen_2017/9_SHARED/material/"

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structLegende
	strText     As String
	strMaterial As String
End Structure
'-------------------------------------------------------------------------------
Dim aLegendenData As Array[structLegende]
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Dim i As Integer
	Scene.dbgRegisterFunction( strScriptName )
	contBlenderEleIN = Scene.FindContainer( "$ALL$CONTENT$ELE_PLAYOUT$moBLENDER$IN$ELEMENT" )
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInitParameters()
	Dim strDebugLocation As String = strScriptName & "OnInitParameters(): "
	Dim strInfoText As String = ""

	Scene.dbgOutput(1, strDebugLocation, "... init parameters ...")

	' create gui
	strInfoText = strInfoText & "author:        " & theAuthor & "\n"
	strInfoText = strInfoText & "date started:  " & theDateStarted & "\n"
	strInfoText = strInfoText & "date modified: " & theDateModified & "\n"
	strInfoText = strInfoText & "contact:       " & theContactDetails & "\n"
	strInfoText = strInfoText & "copyright:     " & theCopyrightDetails & "\n" 
	strInfoText = strInfoText & "client:        " & theClient & "\n"
	strInfoText = strInfoText & "project:       " & theProject & "\n"
	strInfoText = strInfoText & "graphics:      " & theGraphics & "\n"

	RegisterParameterString("theLegend1", "legend 1 [leg1|mat1]:", "CDUCSU|cducsu", 55, 75, "")
	RegisterParameterString("theLegend2", "legend 2 [leg2|mat2]:", "SPD|spd", 55, 75, "")
	RegisterParameterString("theLegend3", "legend 3 [leg3|mat3]:", "FDP|fdp", 55, 75, "")
	RegisterParameterString("theLegend4", "legend 4 [leg4|mat4]:", "leg4|mat4", 55, 75, "")
	RegisterParameterString("theLegend5", "legend 5 [leg5|mat5]:", "leg5|mat5", 55, 75, "")

	RegisterParameterInt("theNumFieldDelay", "playout delay [25] fields:", 10, 1, 100)
	RegisterPushButton("btAssignValues", "assign values", 11)
	RegisterInfoText(strInfoText)
	RegisterPushButton("btAssignValuesDirect", "assign values direct", 21)
End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecAction(buttonId As Integer)
	Dim strDebugLocation As String = strScriptName & "OnExecAction():"
	
	Scene.dbgOutput(1, strDebugLocation, "[buttonId]: [" & buttonId & "]")
	If buttonID = 11 Then
		readLegendenData()
		updateScene_assignData()
	ElseIf buttonID = 21 Then
		readLegendenData()
		updateScene_assignData()
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecPerField()
	If blnExecPerField = TRUE Then
		cntFieldDelay = cntFieldDelay + 1
		If cntFieldDelay > numFieldDelay Then
			updateScene_AutofollowDeactivate()
			cntFieldDelay = 0
			blnExecPerField = FALSE
println "DEBUG: [blnExecPerField] = [FALSE]"
		End If
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readLegendenData()
	Dim strDebugLocation As String = strScriptName & "readLegendenData():"
	Dim sLegende         As structLegende
	Dim cntLeg           As Integer
	Dim strTemp          As String
	Dim aStrTemp         As Array[String]
	
	aLegendenData.Clear
	
	For cntLeg  = 1 To 5
		strTemp = GetParameterString( "theLegend" & CStr(cntLeg) )
		strTemp.Split( "|", aStrTemp )
		sLegende.strText     = aStrTemp[0]
		sLegende.strMaterial = aStrTemp[1]
		sLegende.strText.Trim()
		sLegende.strMaterial.Trim()
		aLegendenData.Push( sLegende )
		Scene.dbgOutput(1, strDebugLocation, "sLegende[i].[strText] [Material]: [" & cntLeg & "] [" & sLegende.strText & "] [" & sLegende.strMaterial & "]")
	Next
End Sub
'-------------------------------------------------------------------------------
'Dim aLegendenData As Array[structLegende]
'-------------------------------------------------------------------------------
'
Sub updateScene_assignData()
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim cntLeg           As Integer
	Dim contLegendeBase  As Container
	Dim tmpMaterial      As Material
	
	' read num field delay
	numFieldDelay = GetParameterInt("theNumFieldDelay")

	For cntLeg = 0 To 4
		contLegendeBase = contBlenderEleIN.FindSubContainer( "ELE_LEGENDE$TRANS$LEGENDE_0" & CStr(cntLeg+1) )
		If aLegendenData[cntLeg].strText <> "" And aLegendenData[cntLeg].strMaterial <> "" Then
			If cntLeg > 0 Then
				contLegendeBase.GetFunctionPluginInstance("Autofollow").Active = TRUE
			End If
			contLegendeBase.Active = TRUE
			contLegendeBase.FindSubContainer( "txt_text" ).Geometry.Text = aLegendenData[cntLeg].strText
			tmpMaterial = contLegendeBase.FindSubContainer("$obj_color").CreateMaterial(kServerMaterialPath & aLegendenData[cntLeg].strMaterial )
			contLegendeBase.FindSubContainer("$obj_color").Material = tmpMaterial
		Else
			contLegendeBase.Active = FALSE
		End If
	Next
	' activate OnExecPerField
	blnExecPerField = TRUE
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_AutofollowDeactivate()
	Dim contLeg         As Integer
	Dim contLegendeBase As Container
	
	For cntLeg = 1 To 4
		contLegendeBase = contBlenderEleIN.FindSubContainer( "ELE_LEGENDE$TRANS$LEGENDE_0" & CStr(cntLeg+1) )
		contLegendeBase.GetFunctionPluginInstance("Autofollow").Active = FALSE
	Next
End Sub
'-------------------------------------------------------------------------------
'



