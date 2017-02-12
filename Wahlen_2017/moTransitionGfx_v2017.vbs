'-------------------------------------------------------------------------------
Dim theAuthor           As String = "Thomas Molden|Stefan Glatzl"
Dim theDateStarted      As String = "15.09.2007"
Dim theDateModified     As String = "11.02.2017"
Dim theContactDetails   As String = "support@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden Media GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "Transition - moElectionPlayout_v00"
'-------------------------------------------------------------------------------
' 11.01.27: Add blnShortAnim for HRSVS2, HRSVK2
'-------------------------------------------------------------------------------
Dim strScriptName As String = "[" & this.name & "]::"
'-------------------------------------------------------------------------------
Dim contHeadlineScript As Container

Dim contIn As Container
Dim contOut As Container
Dim contOutEle As Container
Dim contElePool As Container
Dim contNextEle As Container

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

Dim contLogGfx2FileScript As Container
Dim contLogGfx2LoggerScript As Container
'-------------------------------------------------------------------------------

Dim cntFieldDelay As Integer = 0
Dim blnRunAnimation As Boolean = FALSE
Dim numFieldDelay As Integer

Dim dirTransition, dirEAnimIN, dirEAnimOUT As Director

'Radiobutton Group for gHRSVK2
Dim rbPieGroup as Array[String]
rbPieGroup.push("Original")
rbPieGroup.push("Pie1 to split")
rbPieGroup.push("Pie1 orig; 2 to split")

Dim iHRSVK2_Variant as Integer
Dim bPie2Split as Boolean = False

'-------------------------------------------------------------------------------
'
Sub OnInit()
	Dim i As Integer
	Scene.dbgRegisterFunction( strScriptName )
	
	dirBlenderAB    = Stage.FindDirector("ANI_BLENDER_AB")
	contPOChannelA  = Scene.FindContainer("$ALL$ELE_PLAYOUT$moBLENDER$CHANNEL_A")
	contPOChannelB  = Scene.FindContainer("$ALL$ELE_PLAYOUT$moBLENDER$CHANNEL_B")
	dirAnimHeadline = Stage.FindDirector("ANI_HEADLINE")
	
	contHeadlineScript = Scene.FindContainer("$ALL$SCRIPTING_POOL$PLAYOUT$moHeadline_v00")
	contLogGfx2FileScript   = Scene.FindContainer("$ALL$SCRIPTING_POOL$LOGGING$moLogGfx2File_v00")
	contLogGfx2LoggerScript = Scene.FindContainer("$ALL$SCRIPTING_POOL$LOGGING$moLogGfx2Logger_v00")
'	contBlender = Scene.FindContainer("$ALL$ELE_PLAYOUT$moBLENDER")

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

'	RegisterParameterString("theTypeOfGraphics", "type of graphics:", "/CLEAR", 50, 100, "")
	RegisterParameterString("theGraphicName", "the graphic name :", "b,5,pd", 50, 100, "")
	RegisterParameterString("theElementName", "the element name:", "/HOCHRECHNUNG/gHRDM_2x", 50, 100, "")
	RegisterParameterText("theTypeOfGraphicsNames", "/CLEAR\n/HOCHRECHNUNG/gHRDM_2x\n/HOCHRECHNUNG/gHRSVS1\n/HOCHRECHNUNG/gHRPZ_2x\n/HOCHRECHNUNG/gHRPZ_4x\n/HOCHRECHNUNG/gHRPZ_6x\n/HOCHRECHNUNG/gHRPZ_8x", 300, 120)	
	
	RegisterPushButton("btTransitionAni", "transition to next graphics", 20)
	RegisterInfoText(strInfoText)
	
	RegisterParameterInt("theNumFieldDelay", "playout delay [25] fields:", 10, 1, 200)
	RegisterParameterInt("theNextBarAnimationIdx", "next bar animation idx [1]:", 1, 1, 20)
'	RegisterPushButton("btRunNextBarAnimation", "run next bar animation", 35)

	RegisterPushButton("btAnimCtrlBack", "anim back", 31)
'	RegisterPushButton("btAnimCtrlPlay", "anim play", 32)
'	RegisterPushButton("btAnimCtrlPause", "anim pause", 33)
'	RegisterPushButton("btAnimCtrlStop", "anim stop", 34)
	RegisterPushButton("btAnimCtrlContinue", "anim continue", 35)
	RegisterPushButton("btAnimCtrlEnd", "anim end", 36)

	RegisterPushButton("btAnimCtrlJump2Intro", "jump 2 intro", 37)
	RegisterPushButton("btAnimCtrlJump2Bar", "jump 2 bar", 38)
	RegisterPushButton("btAnimCtrlGo2Next", "go 2 next", 39)
	RegisterPushButton("btAnimCtrlStartFromEmpty", "start from empty", 40)

	RegisterParameterBool("rdAnimCtrlJump2Intro", "rd jump 2 intro", FALSE)
	RegisterParameterBool("rdAnimCtrlJump2Bar", "rd jump 2 bar", FALSE)
	RegisterParameterBool( "theAniShortFlag", "use short animation", FALSE )
	
'	RegisterRadioButton("theHRSVK2_Variant", "HRSVK2 Variant", 0, rbPieGroup)

End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecAction(buttonId As Integer)

	If buttoniD = 20 Then
	' btTransition
		updateScene_TransitionAnimation()
	ElseIf buttonID = 31 Then
	' anim back
		updateScene_runBarAnimShowStart()
	ElseIf buttonID = 32 Then
	' anim play
	ElseIf buttonID = 33 Then
	' anim pause
	ElseIf buttonID = 34 Then
	' anim stop
	ElseIf buttonID = 35 Then
	' anim continue
		updateScene_runBarAnimContinue()
'println "ePlayoutMaster::OnExecAction:(btAnimCtrlContinue) [buttonID]: [" & buttonID & "]-------------------"
	ElseIf buttonID = 36 Then
	' anim end
		updateScene_runBarAnimShowEnd()
	ElseIf buttonID = 37 Then
	' anim intro
		updateScene_runAmimJump2Intro()
'		updateScene_runAnimIntro()
	ElseIf buttonID = 38 Then
		updateScene_runAmimJump2Bar()
	End If

End Sub
'-------------------------------------------------------------------------------
'
Sub OnExecPerField()
	If blnRunAnimation = TRUE Then
		cntFieldDelay = cntFieldDelay + 1
		If cntFieldDelay > numFieldDelay Then
			updateScene_RunTransitionAnimation()
			cntFieldDelay = 0
			blnRunAnimation = FALSE
		End If
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_setTypeOfGraphics(contPlayout As Container)
	Dim strDebugLocation As String = strScriptName & "updateScene_setTypeOfGraphics: "
	Dim contCurrPOChannel, contNextPOChannel As Container
	
	Scene.dbgOutput(1, strDebugLocation, "[contPlayout]: [" & contPlayout.name & "]")

End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_TransitionAnimation()
	Dim strDebugLocation As String = strScriptName & "updateScene_TransitionAnimation(): "
	Dim contBlenderIN, contBlenderOUT, contElementPool As Container
	Dim strAniTrio As String
	Dim dblKeyTime As Double
	Dim dirAniIO, dirAniData As Director
	Dim strHelp As String
'	Dim dirTransition, dirEAnimIN, dirEAnimOUT As Director
	
	' read type of graphics
	prevTypeOfGraphics = nextTypeOfGraphics
	nextTypeOfGraphics = GetParameterString("theElementName")

	' read num field delay
	numFieldDelay = GetParameterInt("theNumFieldDelay")
	
	' get container references
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderOUT  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")
	
	' swap geometry
	contBlenderOUT.deleteGeometry()
	contBlenderOUT.Geometry = contBlenderIN.Geometry
	contBlenderIN.deleteGeometry()

	If nextTypeOfGraphics.Match("gHRSVS1|gHRSVS2|gHRSVK1|gHRSVK2|gHRWK") Then
'println "DEBUG: updateScene_TransitionAnimation(): If nextTypeOfGraphics.Match() Then ... [nextTypeOfGraphics]: [" & nextTypeOfGraphics & "]"
		strHelp = nextTypeOfGraphics
		strHelp.Substitute("/HOCHRECHNUNG/", "", TRUE)
		contBlenderIN.Geometry = contElementPool.FindSubcontainer( strHelp ).Geometry
		'Set HRSVK2_Variant
		updateScene_SetHRSVK2_Variant()
	Else
		contBlenderIN.CreateGeometry( Scene.sGlobalParameter.strGlobGeomGeneratePath & GetParameterString("theElementName") )
	End If
	
	dirTransition = Stage.FindDirector("ANI_TRANSITION")
	System.SendCommand("#" & dirTransition.vizID & " SHOW $OUT")

	dirEAnimIN  = contBlenderIN.GetDirectorOfMergedGeometry()
	dirEAnimOUT = contBlenderOUT.GetDirectorOfMergedGeometry()
	System.SendCommand("#" & dirEAnimIN.vizID & " SHOW F0")

	'SGL 17.08.2011 -> Fix 4 gHRWK
	If  nextTypeOfGraphics.Match("gHRWK") Then
		Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", " SHOW $VALUE0", dirEAnimIN )
	Else
'		Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "GOTO_TRIO $START $IN", dirEAnimIN )
		Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", " SHOW $START", dirEAnimIN )
	End If

	dirAniData = Stage.FindDirector( "$ANIM_PBRK$ANI_DATA" )

'println "DEBUG: [prevTypeOfGraphics] [nextTypeOfGraphics]: [" & prevTypeOfGraphics & "] [" &  nextTypeOfGraphics& "]"
	If  nextTypeOfGraphics.Match("gPBRK") Then
		contBlenderOUT.deleteGeometry()
'		System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $ELE_0 $ELE_1")
		Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", " SHOW $START", dirEAnimIN )

		System.SendCommand( "#" & dirAniData.vizID & " SHOW F0")
		dirTransition = Stage.FindDirector("ANI_TRANSITION")
		System.SendCommand("#" & dirTransition.vizID & " SHOW $OUT")

'println "DEBUG: curr=gPBRK - [" & "#" & dirTransition.vizID & " SHOW $IN]" 
	ElseIf prevTypeOfGraphics.Match("gHRSVK2|gHRSVS2") = FALSE Then
		System.SendCommand( "#" & dirAniData.vizID & " SHOW $END")
'println "DEBUG: gPBRK [no] - [" & "#" & dirAniData.vizID & " SHOW $END]" 
	ElseIf  prevTypeOfGraphics.Match("gPBRK") Then
		System.SendCommand( "#" & dirAniData.vizID & " SHOW $END")
'println "DEBUG: prev=gPBRK - [" & "#" & dirAniData.vizID & " SHOW $END]" 
	End If

	' run headline animation
'	contHeadlineScript.ScriptPluginInstance.PushButton("btAssignValues")
	System.SendCommand("#" & dirAnimHeadline.vizID & " SHOW $OUT")
'---	System.SendCommand("#" & dirAnimHeadline.vizID & " GOTO_TRIO $OUT $IN")
	
	If Not GetParameterBool("rdAnimCtrlJump2Intro") Then
		blnRunAnimation = TRUE
	End If
	
	' write logging details
	contLogGfx2FileScript.ScriptPluginInstance.SetParameterString( "theLogGfxDetail", nextTypeOfGraphics )
	contLogGfx2FileScript.ScriptPluginInstance.PushButton( "btLogNow" )

	contLogGfx2LoggerScript.ScriptPluginInstance.SetParameterString( "theLogText1", GetParameterString("theGraphicName") )
	contLogGfx2LoggerScript.ScriptPluginInstance.SetParameterString( "theLogText2", nextTypeOfGraphics )
	contLogGfx2LoggerScript.ScriptPluginInstance.PushButton( "btLogStatusIN" )

End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_RunTransitionAnimation()
	Dim dirAniIO, dirAniData As Director
	Dim contBlenderIN, contBlenderOUT, contElementPool As Container
	Dim strHelp As String

	' get container references
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderOUT  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")

	dirEAnimIN  = contBlenderIN.GetDirectorOfMergedGeometry()
	dirEAnimOUT = contBlenderOUT.GetDirectorOfMergedGeometry()

	' run anim depending on type of graphics
	If  nextTypeOfGraphics.Match("gPBRK") Then
		' run animation
'		dirTransition = Stage.FindDirector("ANI_TRANSITION")
'		System.SendCommand("#" & dirTransition.vizID & " GOTO_TRIO $OUT $IN")
		' run headline animation
'		System.SendCommand("#" & dirAnimHeadline.vizID & " SHOW $OUT")
'		contHeadlineScript.ScriptPluginInstance.PushButton("btAssignValues")
		System.SendCommand("#" & dirAnimHeadline.vizID & " GOTO_TRIO $OUT $IN")
	Else
	
		If GetParameterBool("rdAnimCtrlJump2Bar") Then
			dirTransition = Stage.FindDirector("ANI_TRANSITION")
			System.SendCommand("#" & dirTransition.vizID & " SHOW $IN")

			Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "SHOW $IN", dirEAnimIN )

			' run animation OUT
			Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "SHOW $OUT", dirEAnimOUT )

			' run general ani_io animation
			System.SendCommand("#" & dirEAnimOUT.FindSubDirector("$ANI_IO").vizID & " SHOW $OUT")

			' run headline animation
			System.SendCommand("#" & dirAnimHeadline.vizID & " SHOW $IN")
		Else
			'SGL 17.08.2011 -> Fix 4 gHRWK, reset ANI_DATA to VALUE0
			If nextTypeOfGraphics.Match("gHRWK") Then
				updateScene_runBarAnimShowStart()
			End If
			
			dirTransition = Stage.FindDirector("ANI_TRANSITION")

			If Not GetParameterBool("rdAnimCtrlJump2Intro") Then
				System.SendCommand("#" & dirTransition.vizID & " GOTO_TRIO $OUT $IN")
			End If

			Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "GOTO_TRIO $START $IN", dirEAnimIN )
'			Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", "SHOW $START", dirEAnimIN )

			' run animation OUT
			Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "GOTO_TRIO $IN $OUT", dirEAnimOUT )

			' run general ani_io animation
			System.SendCommand("#" & dirEAnimOUT.FindSubDirector("$ANI_IO").vizID & " GOTO_TRIO $IN $OUT")

			' run headline animation
			System.SendCommand("#" & dirAnimHeadline.vizID & " GOTO_TRIO $OUT $IN")
		End If

		' reset animation index
		System.SendCommand("#" & This.vizID & "*SCRIPT*INSTANCE*theNextBarAnimationIdx SET 1")

	End If

	' reset jump 2 bar flag in transition animation
	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Bar SET 0")

	' reset jump 2 intro flag in transition animation
	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Intro SET 0")
	
	'reset bPie2Split
	bPie2Split = False
	
End Sub
'-------------------------------------------------------------------------------
'
Function getMaxAnimationIndex() As Integer
	Dim iIdx, iMaxIdx, iCnt As Integer
	iMaxIdx = 0
	For iCnt = 0 To Scene.aPlayoutAnimationIN.UBound
		iIdx = Scene.aPlayoutAnimationIN[iCnt].intIndex
		If iMaxIdx < iIdx Then
			iMaxIdx = iIdx
		End If
	Next
	getMaxAnimationIndex = iMaxIdx
End Function
'-------------------------------------------------------------------------------
'
Sub updateScene_runBarAnimContinue()
	Dim strDebugLocation As String = strScriptName & "updateScene_runBarAnimContinue(): "
	Dim iAnim, idxAnim As Integer
	Dim dirAniData As Director
	Dim strElementName As String
	Dim contBlenderIN, contBlenderOUT, contElementPool As Container
	Dim dirAnimIntro, dirAniHeadlineIO As Director

	idxAnim = GetParameterInt("theNextBarAnimationIdx")
	
	' run animation IN
	' Scene._POA_PlayGoToTrioIdx( strType As String, intIndex As Integer, strEventList As String )
'	Scene._POA_PlayGoToTrioIdx( "ANI_DATA", "EventIN", idxAnim )
	
Dim blnShortAnim As Boolean
Dim strHelp As String
blnShortAnim = GetParameterBool( "theAniShortFlag" )
strHelp = GetParameterString("theElementName")

	If Not GetParameterBool("rdAnimCtrlJump2Intro") Then

		For iAnim = 0 To Scene.aPlayoutAnimationIN.UBound

			strElementName = GetParameterString("theElementName")
	
			If Not strElementName.Match("gHRWK") Then
	
				If Scene.aPlayoutAnimationIN[iAnim].intIndex = idxAnim Then

'println "updateScene_runBarAnimContinue():: iAnim=[" & iAnim & "]; UBound=[" & Scene.aPlayoutAnimationIN.UBound & "]"

					Dim dirAniDirector As Director
					dirAniDirector = Scene.aPlayoutAnimationIN[iAnim].dirAnimation
'println "updateScene_runBarAnimContinue():: dirAniDirector - vizID=[" & dirAniDirector.vizID & "]; Name=[" & dirAniDirector.Name & "]"


					If dirAniDirector.Name = "ANI_PIE1TO2" And blnShortAnim = TRUE Then
'println "... found ..."
						dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
						System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")

						Dim ii, iMax As Integer
						If strHelp.Match("gHRSVK2") Then
							iMax = getMaxAnimationIndex() - 2
						Else
							iMax = getMaxAnimationIndex()
						End If
						For ii = iAnim To Scene.aPlayoutAnimationIN.UBound
'println "... ii=[" & ii & "]; iMax=[" & iMax & "]; intIndex=[" & Scene.aPlayoutAnimationIN[ii].intIndex & "]"
							If  Scene.aPlayoutAnimationIN[ii].intIndex <= iMax Then
								dirAniData = Scene.aPlayoutAnimationIN[ii].dirAnimation.FindSubDirector( "$ANI_DATA" )
								System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
							End If
						Next
						
						idxAnim = iMax
'println "... ii=[" & ii & "]; idxAnim=[" & idxAnim & "]"

		System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*theNextBarAnimationIdx SET " & idxAnim+1)
					Else
						
	'							dirAniData = dirEAnimIN.FindSubDirector( "$" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "$ANI_DATA" )
						dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
						
						If strHelp.Match("gHRSVK2") = False Then
							System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
		
							Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [strDirectorVizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & Scene.aPlayoutAnimationIN[iAnim].dirAnimation.vizID & "]")
						Else
							If iHRSVK2_Variant = 0 Then
								System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
								'println "dirAniDirector.Name = " & dirAniDirector.Name
								
							ElseIf iHRSVK2_Variant = 1 Then
								If dirAniDirector.Name.Match("ANI_KOAL_SPLIT1|ANI_MARKER_1|ANI_PIE1TO2|ANI_KOAL_SPLIT2|ANI_MARKER_2") Then
									System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
								Else
									'println "dirAniDirector.Name = " & dirAniDirector.Name
									'If dirAniDirector.Name.Match("G1_E1|LABEL_PS1|LABEL_PS2") Then 
									If dirAniDirector.Name.Match("G1_E1|LABEL_PS") Then
										dirAniData.Time = 2.0
									Else
										dirAniData.Time = 1.0
									End If
								End If
								
							ElseIf iHRSVK2_Variant = 2 Then 
								If dirAniDirector.Name.Match("ANI_PIE1TO2") Then
									bPie2Split = True
									'println "dirAniDirector.Name = " & dirAniDirector.Name & " bPie2Split = " & bPie2Split 
								End If
								
								If bPie2Split = False Then
									System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
									'println "IF dirAniDirector.Name = " & dirAniDirector.Name
								Else
									'println "ELSE dirAniDirector.Name = " & dirAniDirector.Name
									If dirAniDirector.Name.Match("ANI_KOAL_SPLIT1|ANI_MARKER_1|ANI_PIE1TO2|ANI_KOAL_SPLIT2|ANI_MARKER_2") Then
										System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
									ElseIf dirAniDirector.Name.Match("G1_E1|LABEL_PS") Then 
										dirAniData.Time = 2.0
									Else
										dirAniData.Time = 1.0
									End If
								End If
							End If
						End If
					
					
						If strHelp.Match("gUMWW") = True AND blnShortAnim = TRUE Then
							'println "gUMWW dirAniDirector.Name = " & dirAniDirector.Name
							If dirAniDirector.Name.Match("G1_E1") Then
									'System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $START $END")
									Scene.FindContainer("CONTENT").FindSubContainer("moBLENDER$IN$ELEMENT$TRANS$SHORT_ANIM").GetDirector().StartAnimation()
							End If				
						End If					
					
					End If
'println "updateScene_runNextBarAnimation():: [iAnim] [strDirectorName] [strDirectorVizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & Scene.aPlayoutAnimationIN[iAnim].dirAnimation.vizID & "]"
				End If

			Else
				dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
'				System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $VALUE" & CStr(idxAnim) & " $VALUE" & CStr(idxAnim+1) )
				System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $VALUE" & CStr(idxAnim-1) & " $VALUE" & CStr(idxAnim) )
'	println "DEBUG: [" & "#" & dirAniData.vizID & " GOTO_TRIO $VALUE" & CStr(idxAnim-1) & " $VALUE" & CStr(idxAnim) & "]"
	'			Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [strDirectorVizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & Scene.aPlayoutAnimationIN[iAnim].dirAnimation.vizID & "]")
	
			End If
	
			If strElementName.Match("gPBRK") Then
				If Scene.aPlayoutAnimationIN[iAnim].intIndex = idxAnim-1 Then
					dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
					System.SendCommand( "#" & dirAniData.vizID & " GOTO_TRIO $END $OUT")
				End If
			End If
		Next
	
		System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*theNextBarAnimationIdx SET " & idxAnim+1)

	Else
		' set playdelay for ANI_DATA_IO
		numFieldDelay = 150
		blnRunAnimation = TRUE

		' handle animations
		dirAnimIntro = Stage.FindDirector("$ANIM_INTRO")
		dirAniHeadlineIO = Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IO")
		System.SendCommand( "#" & dirAnimIntro.vizID & " GOTO_TRIO $START $END" )
		System.SendCommand( "#" & dirAniHeadlineIO.vizID & " GOTO_TRIO $OUT $IN" )
	'	Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_OUT").Time = 5.0
		Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IN").Time = 5.0

'		' reset jump 2 intro flag
'		System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Intro SET 0")

	End If
	
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_runBarAnimShowStart()
	Dim strDebugLocation As String = strScriptName & "updateScene_runBarAnimShowStart(): "
	Dim dirAniData As Director
	Dim contBlenderIN As Container
	Dim iAnim As Integer
	Dim strHelp As String
	
	' set animation IN
	' Scene._POA_PlayShowStartALL( strType As String, strEventList As String )
'	Scene._POA_PlayShowStartALL( "ANI_DATA", "EventIN" )
	
	strHelp = GetParameterString("theElementName")

	For iAnim = 0 To Scene.aPlayoutAnimationIN.UBound
		If Not strHelp.Match("gHRWK") Then
'			dirAniData = dirEAnimIN.FindSubDirector( "$" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "$ANI_DATA" )
			dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
			System.SendCommand("#" & dirAniData.vizID & " SHOW $START")

			Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [dirAniIO.vizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & dirAniData.vizID & "]")
'			Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [strDirectorVizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & Scene.aPlayoutAnimationIN[iAnim].dirAnimation.vizID & "]")
		Else
			dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
			System.SendCommand("#" & dirAniData.vizID & " SHOW $VALUE0")
		End If
	Next

	' reset special directors
	Stage.FindDirector("$ANIM_HRSK2$ANI_PIE1TO2").Time = 0.0
	dirAniData = Stage.FindDirector("$ANIM_PBRK$ANI_DATA")

'println "DEBUG: [theTypeOfGraphics]: [" & strHelp & "]"
	If strHelp.Match("gPBRK") Then
		contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
		dirEAnimIN  = contBlenderIN.GetDirectorOfMergedGeometry()
		System.SendCommand("#" & dirAniData.vizID & " SHOW $ELE_0")
'		dirEAnimIN  = contBlenderIN.GetDirectorOfMergedGeometry()
'		Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", " SHOW $START", dirEAnimIN )
'		Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", " SHOW $START", dirEAnimIN )
		Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", " SHOW F0", dirEAnimIN )
		Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", " SHOW F0", dirEAnimIN )
		dirTransition = Stage.FindDirector("ANI_TRANSITION")
		System.SendCommand("#" & dirTransition.vizID & " SHOW $OUT")
	Else
		System.SendCommand("#" & dirAniData.vizID & " SHOW $END")
	End If
	
	System.SendCommand( "#" & this.vizID & "*SCRIPT*INSTANCE*theNextBarAnimationIdx SET 1" )

End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_runBarAnimShowEnd()
	Dim strDebugLocation As String = strScriptName & "updateScene_runBarAnimShowEnd(): "
	Dim dirAniData, dirAniKoal, dirAniIN As Director
	Dim iAnim As Integer
	Dim strHelp As String
	Dim contBlenderIN As Container	
	' set animation END
	' Scene._POA_PlayShowEndALL( strType As String, strEventList As String )
'	Scene._POA_PlayShowEndALL( "ANI_DATA", "EventIN" )
	
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")

	strHelp = GetParameterString("theElementName")

	For iAnim = 0 To Scene.aPlayoutAnimationIN.UBound
		If Not strHelp.Match("gHRWK") Then
'			dirAniData = dirEAnimIN.FindSubDirector( "$" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "$ANI_DATA" )
			dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
			System.SendCommand("#" & dirAniData.vizID & " SHOW $END")

			Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [dirAniIO.vizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & dirAniData.vizID & "]")
			Scene.dbgOutput(1, strDebugLocation, "[iAnim] [strDirectorName] [strDirectorVizID]: ["	& iAnim & "] [" & Scene.aPlayoutAnimationIN[iAnim].strDirectorName & "] [" & Scene.aPlayoutAnimationIN[iAnim].dirAnimation.vizID & "]")
		Else
			dirAniData = Scene.aPlayoutAnimationIN[iAnim].dirAnimation.FindSubDirector( "$ANI_DATA" )
			System.SendCommand("#" & dirAniData.vizID & " SHOW $VALUE1")
		End If
	Next

'println "DEBUG: [strHelp] [GetParameterString(theElementName)]: [" & strHelp & "] [" & GetParameterString("theElementName") & "]"
'	If strHelp.Match("gHRSVS2") Or strHelp.Match("gHRSVK2") Then
	If strHelp.Match("gHRSVK2|gHRSVS2") = TRUE Then
'println "DEBUG: If strHelp.Match() Then ........"
		dirAniData = Stage.FindDirector("$ANIM_HRSK2$ANI_PIE1TO2")
		System.SendCommand("#" & dirAniData.vizID & " SHOW $END")
		dirAniData.Time = 1.0
'		dirAniData = dirAniIN.FindSubDirector("$ANIM_HRSK2$ANI_PIE1TO2")
'		System.SendCommand("#" & dirAniData.vizID & " SHOW $END")
		Scene._POA_PlayAnimCmdSearchALL( "ANI_DATA", "SHOW $END", contBlenderIN.GetDirectorOfMergedGeometry() )
		If strHelp.Match("gHRSVK2") Then
			dirAniIN = contBlenderIN.GetDirectorOfMergedGeometry()
			dirAniKoal = dirAniIN.FindSubDirector("$KOAL_LABEL_PIE1")
			dirAniKoal.Time = 0.0
		End If
	ElseIf GetParameterString("theElementName") = "/POLITBAROMETER/gPBRK" Then
		dirAniData = Stage.FindDirector("$ANIM_PBRK$ANI_DATA")
		System.SendCommand("#" & dirAniData.vizID & " SHOW $END")
		dirTransition = Stage.FindDirector("ANI_TRANSITION")
		System.SendCommand("#" & dirTransition.vizID & " SHOW $IN")
	End If
	
	System.SendCommand( "#" & this.vizID & "*SCRIPT*INSTANCE*theNextBarAnimationIdx SET 100" )

End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_runAnimIntro()
	Dim contBlenderIN, contBlenderOUT, contElementPool As Container
	Dim dirAnimIntro, dirAniHeadlineIO As Director

	' get container references
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderOUT  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")
	
	' swap geometry
	contBlenderOUT.deleteGeometry()
	contBlenderIN.deleteGeometry()

	this.ScriptPluginInstance.PushButton("btTransitionAni")
	
	' handle animations
	dirAnimIntro = Stage.FindDirector("$ANIM_INTRO")
	dirAniHeadlineIO = Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IO")
	System.SendCommand( "#" & dirAnimIntro.vizID & " GOTO_TRIO $START $END" )
	System.SendCommand( "#" & dirAniHeadlineIO.vizID & " GOTO_TRIO $OUT $IN" )
'	Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_OUT").Time = 5.0
	Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IN").Time = 5.0
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_RunIOAnim_PBRK()
	Dim dirAnimIO As Director
	Dim contBlenderIN, contElementPool As Container

	' get container references
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")

	dirAnimIO  = contBlenderIN.GetDirectorOfMergedGeometry()

	Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "GOTO_TRIO $START $IN", dirAnimIO )
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_runAmimJump2Bar()
	' set jump 2 bar flag
	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Bar SET 1")
	' update scene
	updateScene_TransitionAnimation()
	' reset jump 2 bar flag in transition animation
'	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Bar SET 0")
End Sub
'-------------------------------------------------------------------------------
'
Sub updateScene_runAmimJump2Intro()
	Dim contBlenderIN, contBlenderOUT, contElementPool As Container
	Dim dirAnimIntro, dirAniHeadlineIO As Director

	' reset jump 2 intro flag
	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Intro SET 1")

	' get container references
	contElementPool = Scene.FindContainer("$ALL$ELEMENT_POOL")
	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
	contBlenderOUT  = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$OUT$ELEMENT")
	
	' swap geometry
	contBlenderOUT.deleteGeometry()
	contBlenderIN.deleteGeometry()

	' update scene
	updateScene_TransitionAnimation()

	dirTransition = Stage.FindDirector("ANI_TRANSITION")
	System.SendCommand("#" & dirTransition.vizID & " SHOW $IN")

	' handle animations
	dirAnimIntro = Stage.FindDirector("$ANIM_INTRO")
	dirAniHeadlineIO = Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IO")
	System.SendCommand( "#" & dirAnimIntro.vizID & " SHOW $START" )
	System.SendCommand( "#" & dirAniHeadlineIO.vizID & " SHOW $OUT" )
'	Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_OUT").Time = 5.0
	Stage.FindDirector("$ANI_HEADLINE$ANI_HEADLINE_IN").Time = 5.0
	
	' reset jump 2 bar flag in transition animation
'	System.SendCommand("#" & this.vizID & "*SCRIPT*INSTANCE*rdAnimCtrlJump2Bar SET 0")
End Sub
'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------
'
Sub updateScene_SetHRSVK2_Variant()
	'get Variant from Input
	
	iHRSVK2_Variant = GetParameterInt("theHRSVK2_Variant")
	'println "HRSVK2_Variant = " & iVariant
	
	Scene.SetHRSVK2_Variant(iHRSVK2_Variant)
End Sub





