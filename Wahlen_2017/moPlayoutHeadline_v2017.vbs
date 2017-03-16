'-------------------------------------------------------------------------------
Dim theAuthor           As String = "tm"
Dim theDateStarted      As String = "25.10.2007"
Dim theDateModified     As String = "15.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "Headline - moHeadline_v00"
'-------------------------------------------------------------------------------
Dim strScriptName As String = "[" & this.name & "]::"
'-------------------------------------------------------------------------------

Dim dirAnimElementIN_IN   As Director
Dim dirAnimElementIN_OUT  As Director
Dim dirAnimElementOUT_IN  As Director
Dim dirAnimElementOUT_OUT As Director

Dim dirAnimHeadline As Director

Dim dirBlenderAB   As Director
Dim curPOChannel   As String = "CHANNEL_A"
Dim contPOChannelA As Container
Dim contPOChannelB As Container

Dim strPOChannel As String
Dim contBlender As Container

Dim contElePhonenumberAll As Container

Dim nextTypeOfGraphics, prevTypeOfGraphics As String
Dim blnNextSBoxFlag As Boolean = FALSE
Dim blnPrevSBoxFlag As Boolean = FALSE

Dim strCredit As String

'-------------------------------------------------------------------------------
' contaner definitions
'-------------------------------------------------------------------------------
Dim contHeadlineIN  As Container
Dim contHeadlineOUT As Container
Dim contCredit      As Container

'-------------------------------------------------------------------------------
' STRUCTURE definitions
'-------------------------------------------------------------------------------
Structure structHeadline
	strText  As String
	strStyle As String
End Structure
'-------------------------------------------------------------------------------
Structure structHeadlineData
	strHeadlineType   As String
	strModerationType As String
	aHeadline         As Array[structHeadline]
End Structure
'-------------------------------------------------------------------------------
Dim sHeadlineDataNext, sHeadlineDataPrev As structHeadlineData
'-------------------------------------------------------------------------------
'
Sub OnInit()
	Dim i As Integer
	Scene.dbgRegisterFunction( strScriptName )
	
	contHeadlineIN  = Scene.FindContainer("$ALL$CONTENT$ELE_HEADLINE$IN")
	contHeadlineOUT = Scene.FindContainer("$ALL$CONTENT$ELE_HEADLINE$OUT")
	contCredit      = Scene.FindContainer("$ALL$CONTENT$ELE_CREDIT")
	dirAnimHeadline = Stage.FindDirector("ANI_HEADLINE")
	
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
	
	RegisterParameterString("theHeadline1", "headline 1 [hl 1]:", "hl 1", 55, 75, "")
	RegisterParameterString("theHeadline2", "headline 2 [hl 2]:", "hl 2", 55, 75, "")
	RegisterParameterString("theHeadline3", "headline 3 [hl 3]:", "hl 3", 55, 75, "")
	RegisterParameterString("theHeadline4", "headline 4 [hl 4]:", "hl 4", 55, 75, "")
	RegisterParameterString("theHeadline5", "headline 5 [hl 5]:", "hl 5", 55, 75, "")
	RegisterParameterString("theHeadline6", "headline 6 [hl 6]:", "hl 6", 55, 75, "")

	RegisterParameterString("theHeadlineStyle", "headline style [<NORMAL,BOLD,SUPERBOLD>|...|...]:", "BOLD|NORMAL|NORMAL", 50, 100, "")
	RegisterParameterString("theModerationType", "moderation type [<WAHL>|<POLITBAROMETER>]:", "WAHL", 50, 100, "")
	
	RegisterParameterString("theCredit", "credit: [Forschungsgruppe Wahlen]", "Forschungsgruppe Wahlen", 55, 75, "")
	
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
		Scene.dbgOutput(1, strDebugLocation, "... button 11 pressed ...")
		System.SendCommand("#" & dirAnimHeadline.vizID & " SHOW $OUT")
		readHeadlineData()
		updateScene_assignData( "assignValues" )
	ElseIf buttonID = 21 Then
		Scene.dbgOutput(1, strDebugLocation, "... button 21 pressed ...")
		readHeadlineData()
		updateScene_assignData( "assignValuesDirect" )
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub readHeadlineData()
	Dim strDebugLocation  As String = strScriptName & "readHeadlineData():"
	Dim sHeadline         As structHeadline
	Dim strHeadlineStyle  As String
	Dim aheadlineStyle    As Array[String]
	Dim cntLine, numLines As Integer
	Dim strHeadlineType   As String

	
	sHeadlineDataNext.aHeadline.Clear
	sHeadlineDataNext.strModerationType = GetParameterString( "theModerationType" )
	strHeadlineStyle = GetParameterString( "theHeadlineStyle" )
	strHeadlineStyle.Split( "|", aHeadlineStyle )
	
	For cntLine = 1 To 6
		sHeadline.strText  = GetParameterString( "theHeadline" & CStr(cntLine) )
		sHeadline.strStyle = aHeadlineStyle[cntLine-1]
		sHeadlineDataNext.aHeadline.Push( sHeadline )
	Next
	' check for numHeadlines
	numLines = 0
	For cntLine = 1 To 3
		If sHeadlineDataNext.aHeadline[cntLine-1].strText <> "" Then
			numLines++
		End If
	Next	
	If numLines <= 2 Then
		strHeadlineType = "$ELE_LINES_2x"
	Else
		strHeadlineType = "$ELE_LINES_3x"
	End If
	sHeadlineDataNext.strHeadlineType = strHeadlineType
	
	'read Credit 
	strCredit = GetParameterString("theCredit")
	

End Sub

'-------------------------------------------------------------------------------
'Structure structHeadline
'	strText  As String
'	strStyle As String
'End Structure
'-------------------------------------------------------------------------------
'Structure structHeadlineData
'	strModerationType As String
'	aHeadline         As Array[structHeadline]
'End Structure
'-------------------------------------------------------------------------------
'Dim sHeadline     As structHeadline
'Dim sHeadlineData As structHeadlineData

'-------------------------------------------------------------------------------
'
Sub updateScene_assignData( strAction As String )
	Dim strDebugLocation As String = strScriptName & "updateScene_assignData():"
	Dim cntLine          As Integer
	
	' swap on assignValues
	If strAction = "assignValues" Then
		updateScene_Headline( contHeadlineOUT, sHeadlineDataPrev.aHeadline, sHeadlineDataPrev.strHeadlineType, sHeadlineDataPrev.strModerationType )
	End If
	' allways assign new headline text
	updateScene_Headline( contHeadlineIN, sHeadlineDataNext.aHeadline, sHeadlineDataNext.strHeadlineType, sHeadlineDataNext.strModerationType )

	sHeadlineDataPrev = sHeadlineDataNext
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_Headline( contHeadline As Container, aHeadline As Array[structHeadline], strHeadlineType As String, strModerationType As String )
	Dim cntLine As Integer
	Dim contWork As Container

	contHeadline.FindSubContainer( "$TYPO_LEFT$ELE_LINES_2x" ).Active = FALSE
	contHeadline.FindSubContainer( "$TYPO_LEFT$ELE_LINES_3x" ).Active = FALSE
	contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType ).Active = TRUE
	For cntLine = 1 To 3
		If aHeadline[cntLine-1].strStyle = "NORMAL" Then
			contWork = contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine )
'			.Active = TRUE
'			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine ).Geometry.Text = aHeadline[cntLine-1].strText
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine )
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_bold" ).Active = FALSE
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_superbold" ).Active = FALSE	
		ElseIf aHeadline[cntLine-1].strStyle = "BOLD" Then
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine ).Active = FALSE
			contWork =  contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_bold" )
'			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_bold" ).Geometry.Text = aHeadline[cntLine-1].strText
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_superbold" ).Active = FALSE
		ElseIf aHeadline[cntLine-1].strStyle = "SUPERBOLD" Then
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine ).Active = FALSE
			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_bold" ).Active = FALSE
			contWork = contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_superbold" )
'			contHeadline.FindSubContainer( "$TYPO_LEFT" & strHeadlineType & "$txt_line_" & cntLine & "_superbold" ).Geometry.Text = aHeadline[cntLine-1].strText
		End If
		contWork.Active = TRUE
		contWork.Geometry.Text = aHeadline[cntLine-1].strText
		contWork.GetFunctionPluginInstance("TFxAlpha").SetParameterBool("ignore_space", FALSE)
		contWork.GetFunctionPluginInstance("TFxAlpha").SetParameterBool("ignore_space", TRUE)
		' update right lines
		contHeadline.FindSubContainer( "$TYPO_RIGHT$txt_text_" & cntLine ).Geometry.Text = aHeadline[cntLine+2].strText
	Next
	' set moderation type
	If sHeadlineDataNext.strModerationType = "WAHL" Then
		contHeadline.FindSubContainer( "TYPO_RIGHT" ).Active = TRUE
		contCredit.Active = TRUE
		contCredit.FindSubContainer("txt_fgw_credit").Geometry.Text = strCredit
		contCredit.FindSubContainer("txt_fgw_credit_h").Geometry.Text = strCredit
		contCredit.Alpha.Value = 100.0
		contHeadline.FindSubContainer( "TYPO_RIGHT_POLITBAROMETER" ).Active = FALSE
	ElseIf sHeadlineDataNext.strModerationType = "POLITBAROMETER" Then
		contHeadline.FindSubContainer( "TYPO_RIGHT" ).Active = FALSE
		contCredit.Active = FALSE
		contCredit.FindSubContainer("txt_fgw_credit").Geometry.Text = strCredit
		contCredit.FindSubContainer("txt_fgw_credit_h").Geometry.Text = strCredit
		contCredit.Alpha.Value = 0.0
		contHeadline.FindSubContainer( "TYPO_RIGHT_POLITBAROMETER" ).Active = TRUE
	End If
'<WAHL>|<POLITBAROMETER>
	
' #108995*FUNCTION*TFxAlpha*ignore_space SET 0 	
End Sub
'-------------------------------------------------------------------------------
'<NORMAL,BOLD,SUPERBOLD>



