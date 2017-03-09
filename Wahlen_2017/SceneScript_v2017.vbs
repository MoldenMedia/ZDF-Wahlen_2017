'-------------------------------------------------------------------------------
Dim theAuthor           As String = "Thomas Molden"
Dim theDateStarted      As String = "04.03.2007"
Dim theDateModified     As String = "09.03.2017"
Dim theContactDetails   As String = "t.molden@moldenmedia.de"
Dim theCopyrightDetails As String = "(c) 2007-2017 ff Molden Media GmbH"
Dim theClient           As String = "ZDF"
Dim theProject          As String = "moElectionSceneStructure (viz3)"
Dim theGraphics         As String = "moElectionPlayout_v00"
'-------------------------------------------------------------------------------
' TODO:
' - still a lot
'
'-------------------------------------------------------------------------------
Dim strScriptName       As String = "[moElectionGlobal]::"

Dim intDebugLevel As Integer = 1
'-------------------------------------------------------------------------------
' STRUCTURE defions
'-------------------------------------------------------------------------------
Structure structGlobalParameter
	strGlobGeomSourcePath     As String
	strGlobGeomGeneratePath   As String
	strGlobImagePath          As String
	strGlobMaterialPath       As String
	dblMaxVizValueHRWB        As Double
	dblMaxVizValueHRPZ        As Double
	dblMaxVizValueHRPZD       As Double
	dblMaxVizValueHRPD        As Double
	dblMaxVizValueHRPG        As Double
	dblMaxVizValueHRSV        As Double
	dblMaxVizValueHROW        As Double
	dblMaxVizValueHRSVB       As Double
	dblMaxVizValueUMVB        As Double
	dblMaxVizValueUMVP        As Double
	dblMaxVizValueUMVD        As Double
	dblMaxVizValueUMHP        As Double
	dblMaxVizValueUMHPD       As Double
	dblMaxVizValueUMAS        As Double
	dblMaxVizValueUMKB        As Double
	dblMaxVizValueUMKV        As Double
	dblMaxVizValueANVP        As Double
	dblMaxVizValueANVD        As Double
	dblMaxVizValueHRLabHeight As Double
	dblHRLabHeight            As Double
	dblUMLabHeight            As Double
	dblMaxVizValuePBPJ        As Double
	dblMinVizValuePBRK        As Double
	dblMaxVizValuePBRK        As Double
	dblMaxVizValueGraphWidth  As Double
	dblMaxVizValueGraphHeight As Double
End Structure
'-------------------------------------------------------------------------------
Dim sGlobalParameter As structGlobalParameter
'-------------------------------------------------------------------------------
Structure structAnimationPlayout
	strDirectorName As String
	dirAnimation    As Director
	intIndex        As Integer
End Structure
'-------------------------------------------------------------------------------
Dim aPlayoutAnimationIN, aPlayoutAnimationOUT As Array[structAnimationPlayout]
'*******************************************************************************
'-------------------------------------------------------------------------------
Dim moDebugHandler_v01 As Container

Dim iHRSVK2_Variant as Integer
'-------------------------------------------------------------------------------
'
Sub dbgOutput(intMsgType As Integer, strLocationName As String, strDebug As String)
'	moDebugHandler_v01.Script.dbgOutput(intMsgType, strLocationName, strDebug)
	println ( intMsgType & " : " & strLocationName & " " & strDebug)
End Sub
'-------------------------------------------------------------------------------
'
Sub dbgRegisterFunction(functionName As  String)
'	moDebugHandler_v01.Script.dbgRegisterFunction(functionName)
End Sub
'-------------------------------------------------------------------------------
Sub dbgPrintFlag(strFlagName As String, strText As String)
'	moDebugHandler_v01.Script.dbgPrintFlag(strFlagName, strText)
End Sub
'-------------------------------------------------------------------------------
Sub dbgPrintOnScreenError( strErrorTitle As String, strErrorMessage As String )
'	moDebugHandler_v01.Script.dbgPrintOnScreenError( strErrorTitle, strErrorMessage )
	println (strErrorTitle & " : " & strErrorMessage)
End Sub
'-------------------------------------------------------------------------------
Sub dbgClearOnScreenError()
'	moDebugHandler_v01.Script.dbgClearOnScreenError()
End Sub
'-------------------------------------------------------------------------------
'*******************************************************************************
'
Sub OnInitParameters()
	Dim strDebugLocation As String = strScriptName & "OnInitParameters():"
	Dim strInfoText As String = ""

	dbgOutput(1, strDebugLocation, "... init parameters ...")
	
	strInfoText = strInfoText & "author:        " & theAuthor & "\n"
	strInfoText = strInfoText & "date started:  " & theDateStarted & "\n"
	strInfoText = strInfoText & "date modified: " & theDateModified & "\n"
	strInfoText = strInfoText & "contact:       " & theContactDetails & "\n"
	strInfoText = strInfoText & "copyright:     " & theCopyrightDetails & "\n" 
	strInfoText = strInfoText & "client:        " & theClient & "\n"
	strInfoText = strInfoText & "project:       " & theProject & "\n"
	strInfoText = strInfoText & "graphics:      " & theGraphics & "\n"
	RegisterInfoText(strInfoText)
	
	RegisterParameterString("theGGeomSourcePath", "geometry source folder:", "GEOM*ZDFWahlen_2017/9_SHARED/geom/_ELEMENTS_/", 55, 128, "")
	RegisterParameterString("theGGeomGeneratePath", "geometry generate folder:", "GEOM*ZDFWahlen_2017/9_SHARED/geom/", 55, 128, "")
	RegisterParameterString("theGImagePath", "image folder:", "IMAGE*ZDFWahlen_2017/9_SHARED/image/", 55, 128, "")
	RegisterParameterString("theGMaterialPath", "material folder:", "MATERIAL*ZDFWahlen_2017/9_SHARED/material/", 55, 128, "")
	RegisterParameterDouble("theHRLabHeight", "label height HR", 3.8, 2.0, 100.0)
	RegisterParameterDouble("theUMLabHeight", "label height UM", 4.6, 2.0, 100.0)
	RegisterParameterDouble("theMaxVizValueHRWB", "max Viz value HRWB", 37.3, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRPZ", "max Viz value HRPZ", 167.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRPZD", "max Viz value HRPZD", 167.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRPD", "max Viz value HRPD", 81.0, 5.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRPG", "max Viz value HRPG", 167.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRSV", "max Viz value HRSV", 180.0, 0.0, 360.0)
	RegisterParameterDouble("theMaxVizValueHROW", "max Viz value HROW", 100.0, 50.0, 200.0)
	RegisterParameterDouble("theMaxVizValueHRSVB", "max Viz value HRSVB", 315.0, 50.0, 350.0)
	RegisterParameterDouble("theMaxVizValueUMVB", "max Viz value UMVB", 60.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueUMVP", "max Viz value UMVP", 167.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueUMVD", "max Viz value UMVD", 81.0, 5.0, 200.0)
	RegisterParameterDouble("theMaxVizValueUMHP", "max Viz value UMHP", 125.0, 50.0, 150.0)
	RegisterParameterDouble("theMaxVizValueUMHPD", "max Viz value UMHPD", 104.0, 50.0, 150.0)
	RegisterParameterDouble("theMaxVizValueUMAS", "max Viz value UMAS", 53.5, 5.0, 200.0)
	RegisterParameterDouble("theMaxVizValueUMKB", "max Viz value UMKB", 47.0, 10.0, 150.0)
	RegisterParameterDouble("theMaxVizValueUMKV", "max Viz value UMKV", 125.0, 0.0, 150.0)
	RegisterParameterDouble("theMaxVizValueANVP", "max Viz value ANVP", 49.0, 10.0, 200.0)
	RegisterParameterDouble("theMaxVizValueANVD", "max Viz value ANVD", 50.0, 5.0, 200.0)
	RegisterParameterDouble("theMaxVizValuePBPJ", "max Viz value PBPJ", 180.0, 0.0, 360.0)
	RegisterParameterDouble("theMinVizValuePBRK", "min Viz value PBRK", 0.138, 0.1, 1.0)
	RegisterParameterDouble("theMaxVizValuePBRK", "max Viz value PBRK", 0.768, 0.1, 1.0)
	RegisterParameterDouble("theMaxVizValueGraphHeight", "max Viz graph height", 105.0, 50.0, 150.0)
	RegisterParameterDouble("theMaxVizValueGraphWidth", "max Viz graph width", 223.0, 100.0, 300.0)
	
End Sub
'-------------------------------------------------------------------------------
'
Sub OnInit()
	moDebugHandler_v01 = Scene.FindContainer("moDebugHandler_v01")

	readGlobalParameter()
End Sub
'-------------------------------------------------------------------------------
'
Sub OnParameterChanged(parameterName As String)
	readGlobalParameter()
End Sub
'-------------------------------------------------------------------------------
Sub readGlobalParameter()
	Dim strDebugLocation As String = strScriptName & "readGlobalParameter():"
	
	sGlobalParameter.strGlobGeomSourcePath     = GetParameterString("theGGeomSourcePath")
	sGlobalParameter.strGlobGeomGeneratePath   = GetParameterString("theGGeomGeneratePath")
	sGlobalParameter.strGlobImagePath          = GetParameterString("theGImagePath")
	sGlobalParameter.strGlobMaterialPath       = GetParameterString("theGMaterialPath")
	sGlobalParameter.dblMaxVizValueHRWB        = GetParameterDouble("theMaxVizValueHRWB")
	sGlobalParameter.dblMaxVizValueHRPZ        = GetParameterDouble("theMaxVizValueHRPZ")
	sGlobalParameter.dblMaxVizValueHRPZD       = GetParameterDouble("theMaxVizValueHRPZD")
	sGlobalParameter.dblMaxVizValueHRPD        = GetParameterDouble("theMaxVizValueHRPD")
	sGlobalParameter.dblMaxVizValueHRPG        = GetParameterDouble("theMaxVizValueHRPG")
	sGlobalParameter.dblMaxVizValueHRSV        = GetParameterDouble("theMaxVizValueHRSV")
	sGlobalParameter.dblMaxVizValueHROW        = GetParameterDouble("theMaxVizValueHROW")
	sGlobalParameter.dblMaxVizValueHRSVB       = GetParameterDouble("theMaxVizValueHRSVB")
	sGlobalParameter.dblMaxVizValueUMVB        = GetParameterDouble("theMaxVizValueUMVB")
	sGlobalParameter.dblMaxVizValueUMVP        = GetParameterDouble("theMaxVizValueUMVP")
	sGlobalParameter.dblMaxVizValueUMVD        = GetParameterDouble("theMaxVizValueUMVD")
	sGlobalParameter.dblMaxVizValueUMHP        = GetParameterDouble("theMaxVizValueUMHP")
	sGlobalParameter.dblMaxVizValueUMHPD       = GetParameterDouble("theMaxVizValueUMHPD")
	sGlobalParameter.dblMaxVizValueUMAS        = GetParameterDouble("theMaxVizValueUMAS")
	sGlobalParameter.dblMaxVizValueUMKB        = GetParameterDouble("theMaxVizValueUMKB")
	sGlobalParameter.dblMaxVizValueUMKV        = GetParameterDouble("theMaxVizValueUMKV")
	sGlobalParameter.dblMaxVizValueANVP        = GetParameterDouble("theMaxVizValueANVP")
	sGlobalParameter.dblMaxVizValueANVD        = GetParameterDouble("theMaxVizValueANVD")
	sGlobalParameter.dblMaxVizValueHRLabHeight = GetParameterDouble("theHRLabHeight")
	sGlobalParameter.dblHRLabHeight            = GetParameterDouble("theHRLabHeight")
	sGlobalParameter.dblUMLabHeight            = GetParameterDouble("theUMLabHeight")
	sGlobalParameter.dblMaxVizValuePBPJ        = GetParameterDouble("theMaxVizValuePBPJ")
	sGlobalParameter.dblMinVizValuePBRK        = GetParameterDouble("theMinVizValuePBRK")
	sGlobalParameter.dblMaxVizValuePBRK        = GetParameterDouble("theMaxVizValuePBRK")
	sGlobalParameter.dblMaxVizValueGraphWidth  = GetParameterDouble("theMaxVizValueGraphWidth")
	sGlobalParameter.dblMaxVizValueGraphHeight = GetParameterDouble("theMaxVizValueGraphHeight")

	Scene.Map["sGlobalParameter"] = sGlobalParameter
End Sub
'-------------------------------------------------------------------------------
'
'*******************************************************************************
' LIBRARY FUNCTIONS
'*******************************************************************************
'-------------------------------------------------------------------------------
Dim kTextDataSubPath         As String = "$TXT_DATA"
Dim kTextValueSubPath        As String = "$TXT_VALUE"
Dim kTextValueDiffSubPath    As String = "$TXT_VALUE_DIFF"
Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Dim kValueSubPath            As String = "$txt_value"
Dim kValueDiffSubPath        As String = "$txt_diff"
Dim kTextSubPath             As String = "$txt_label"
Dim kUnitSubPath             As String = "$txt_unit"
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignLabel_3(contLabelBase As Container, strTypeOfGraphics As String, strValue As String, strLabel1 As String, strLabel2 As String, strLabel3 As String, dblValue As Double)
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignLabel_3():"
	Dim contWork1, contWork2, contWork3 As Container
	Dim strTemp As String
	
	' trim strings
	strValue.Trim()
	strLabel1.Trim()
	strLabel2.Trim()
	strLabel3.Trim()
	
	' set value text
	contWork1 = contLabelBase.FindSubContainer( kTextValueSubPath )
'	If strValue = "" And ( strTypeOfGraphics = "HRPZ" Or strTypeOfGraphics = "HRPG" Or strTypeOfGraphics = "HRWB" Or strTypeOfGraphics = "UMVP" ) Then
	If strValue = "" And strTypeOfGraphics.Match( "[HRPZ|HRPG|HRPZD|HRWB|UMVP|HROWVP|ANNQRP|ANSVZP|PBPJ|UMWW]" ) Then
		contWork1.FindSubContainer( kUnitSubPath ).Active = FALSE
	ElseIf strTypeOfGraphics.Match( "HRPD|UMVD|HROWVD|ANNQRD|ANSVZD|PBPJPD" ) Then
		contWork1.FindSubContainer( kUnitSubPath ).Active = FALSE
	Else
		contWork1.FindSubContainer( kUnitSubPath ).Active = TRUE
	End If
	' show empty labels
	contWork1.Active = TRUE
	contWork1.FindSubContainer( kValueSubPath ).Geometry.Text = strValue
	
	' set label text
	contWork1 = contLabelBase.FindSubContainer( kTextLabel1SubPath )
	contWork2 = contLabelBase.FindSubContainer( kTextLabel2SubPath )
	contWork3 = contLabelBase.FindSubContainer( kTextLabel3SubPath )

dbgOutput(1, strDebugLocation, "[strLabel1]: [" & strLabel1 & "][strLabel2]: [" & strLabel2 & "] [strLabel3]: [" & strLabel3 & "]***********")
dbgOutput(1, strDebugLocation, "[contLabelBase.name]: [" & contLabelBase.name & "]***********")
dbgOutput(1, strDebugLocation, "[contWork1.name]: [" & contWork1.name & "]***********")
dbgOutput(1, strDebugLocation, "[contWork2.name]: [" & contWork2.name & "]***********")
dbgOutput(1, strDebugLocation, "[contWork3.name]: [" & contWork3.name & "]***********")


	If strLabel3 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = TRUE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel3
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork3.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel2 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel1 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	Else
		contWork1.Active = FALSE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
	End If
	
'07.02.2017: not required anymore
	' set autofollow details
'	If dblValue >= 0 Then 
'		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 0 )
'		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", FALSE )
'	ElseIf dblValue < 0 Then
'		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 2 )
'		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", TRUE )
'	End If
	' *FUNCTION*Autofollow*Y_PREV_CENTER SET 1
	' Autofollow*PLUSS SET 1
	
End Sub
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignDiffLabel_3(contLabelBase As Container, strTypeOfGraphics As String, strValueP As String, strValueD As String, strLabel1 As String, strLabel2 As String, strLabel3 As String)
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignDiffLabel_3():"
	Dim contWork1, contWork2, contWork3 As Container
	Dim strTemp As String
	
	' trim strings
	strValueP.Trim()
	strValueD.Trim()
	strLabel1.Trim()
	strLabel2.Trim()
	strLabel3.Trim()
	
	' set value text
	If strTypeOfGraphics = "UMVPD" Or strTypeOfGraphics = "UMAS" Or strTypeOfGraphics = "HROWVPD" OR strTypeOfGraphics = "UMWW" Then
		contLabelBase.FindSubContainer( kTextValueSubPath ).Active = FALSE
		contWork1 = contLabelBase.FindSubContainer( kTextValueDiffSubPath )
		contWork1.Active = TRUE
	Else
		contWork1 = contLabelBase.FindSubContainer( kTextValueSubPath )
	End If
'	If strValueP <> "" Then
	' show empty labels
		contWork1.Active = TRUE
		contWork1.FindSubContainer( kValueSubPath ).Geometry.Text = strValueP
		contWork1.FindSubContainer( kValueDiffSubPath ).Geometry.Text = strValueD
'	Else
'		contWork1.Active = FALSE
'	End If
	
	If strValueP = "" Then
		contWork1.FindSubContainer( kUnitSubPath ).Active = FALSE
	Else
		contWork1.FindSubContainer( kUnitSubPath ).Active = TRUE
	End If

	' set label text
	contWork1 = contLabelBase.FindSubContainer( kTextLabel1SubPath )
	contWork2 = contLabelBase.FindSubContainer( kTextLabel2SubPath )
	contWork3 = contLabelBase.FindSubContainer( kTextLabel3SubPath )

	If strLabel3 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = TRUE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel3
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork3.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel2 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel1 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	Else
		contWork1.Active = FALSE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
	End If
	
	' set autofollow details 
	' only plus bars
	contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 0 )
	contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", FALSE )
	' *FUNCTION*Autofollow*Y_PREV_CENTER SET 1
	' Autofollow*PLUSS SET 1
	
End Sub
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignKoalLabel_3(contLabelBase As Container, strValue As String, strLabel1 As String, strLabel2 As String, strLabel3 As String, dblValue As Double)
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignKoalLabel_3():"
	Dim contWork1, contWork2, contWork3 As Container
	Dim strTemp As String
	
	' trim strings
	strValue.Trim()
	strLabel1.Trim()
	strLabel2.Trim()
	strLabel3.Trim()
	
	' set value text
	contWork1 = contLabelBase.FindSubContainer( kTextValueSubPath )
'	If strValue <> "" Then
	' show empty labels
		contWork1.Active = TRUE
		contWork1.FindSubContainer( kValueSubPath ).Geometry.Text = strValue
'	Else
'		contWork1.Active = FALSE
'	End If
	
	' set label text
	contWork1 = contLabelBase.FindSubContainer( kTextLabel1SubPath )
	contWork2 = contLabelBase.FindSubContainer( kTextLabel2SubPath )
	contWork3 = contLabelBase.FindSubContainer( kTextLabel3SubPath )

	If strLabel3 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = TRUE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel3
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork3.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel2 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = TRUE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel2
		contWork2.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	ElseIf strLabel1 <> "" Then
		contWork1.Active = TRUE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	Else
		contWork1.Active = FALSE
		contWork2.Active = FALSE
		contWork3.Active = FALSE
	End If
	
	' set autofollow details
	If dblValue >= 0 Then 
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 1 )
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", FALSE )
	ElseIf dblValue < 0 Then
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 2 )
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", TRUE )
	End If
	' *FUNCTION*Autofollow*Y_PREV_CENTER SET 1
	' Autofollow*PLUSS SET 1
	
End Sub
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignLabel_1(contLabelBase As Container, strValue As String, strLabel1 As String, strLabel2 As String, strLabel3 As String, dblValue As Double)
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignLabel_1():"
	Dim contWork1, contWork2, contWork3 As Container
	Dim strTemp As String
	
	' trim strings
	strValue.Trim()
	strLabel1.Trim()
	
	' set value text
	contWork1 = contLabelBase.FindSubContainer( kTextValueSubPath )
	contWork2 = contLabelBase.FindSubContainer( kUnitSubPath )

	' show empty labels
	contWork1.Active = TRUE
	contWork1.FindSubContainer( kValueSubPath ).Geometry.Text = strValue

	If strValue <> "" Then
		contWork2.Active = TRUE
	ElseIf strValue = "" Then
'		contWork1.Active = FALSE
		contWork2.Active = FALSE
	End If
	
	' set label text
	contWork1 = contLabelBase.FindSubContainer( kTextLabel1SubPath )

	If strLabel1 <> "" Then
		contWork1.Active = TRUE
		contWork1.FindSubContainer( kTextSubPath ).Geometry.Text = strLabel1
	Else
		contWork1.Active = FALSE
	End If
	
	' set autofollow details
	If dblValue >= 0 Then 
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 0 )
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", FALSE )
	ElseIf dblValue < 0 Then
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 2 )
		contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", TRUE )
	End If
	' *FUNCTION*Autofollow*Y_PREV_CENTER SET 1
	' Autofollow*PLUSS SET 1
	
End Sub
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignDiffLabel_1(contLabelBase As Container, strTypeOfGraphics As String, strValueP As String, strValueD As String, strLabel1 As String, strLabel2 As String, strLabel3 As String)
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignDiffLabel_1():"
	Dim contWork1, contWork2, contWork3 As Container
	Dim strTemp As String
	
	' trim strings
	strValueP.Trim()
	strValueD.Trim()
	strLabel1.Trim()
	strLabel2.Trim()
	strLabel3.Trim()
	
	' set value text
	If strTypeOfGraphics = "UMVBPD" Then
		contLabelBase.FindSubContainer( kTextValueSubPath ).Active = FALSE
		contWork1 = contLabelBase.FindSubContainer( kTextValueDiffSubPath )
		contWork2 = contWork1.FindSubContainer( kUnitSubPath )
		contWork1.Active = TRUE
		If strValueP <> "" Then
			contWork2.Active = TRUE
		Else
			contWork2.Active = FALSE
		End If

	Else
		contWork1 = contLabelBase.FindSubContainer( kTextValueSubPath )
	End If
'	If strValueP <> "" Then
	' show empty labels
		contWork1.Active = TRUE
		contWork1.FindSubContainer( kValueSubPath ).Geometry.Text = strValueP
		contWork1.FindSubContainer( kValueDiffSubPath ).Geometry.Text = strValueD
'	Else
'		contWork1.Active = FALSE
'	End If

	' set autofollow details 
	' only plus bars
	contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterInt( "Y_PREV_CENTER", 0 )
	contLabelBase.GetFunctionPluginInstance("Autofollow").SetParameterBool( "PLUSS", FALSE )
	' *FUNCTION*Autofollow*Y_PREV_CENTER SET 1
	' Autofollow*PLUSS SET 1

End Sub
'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------
Dim kPieTextValueSubPath As String = "$TEXT_VALUE"
Dim kPieValueSubPath     As String = "$txt_value"
Dim kPieDiffSubPath      As String = "$txt_diff"
Dim kPieTextSubPath      As String = "$txt_name"
Dim kPieTextLabelSubPath As String = "$TEXT_"
Dim kPieMaxLabelLines    As Integer = 4
'-------------------------------------------------------------------------------
'
'Dim kTextDataSubPath         As String = "$TXT_DATA"
'Dim kTextLabel1SubPath       As String = "$TXT_LABEL_1"
'Dim kTextLabel2SubPath       As String = "$TXT_LABEL_2"
'Dim kTextLabel3SubPath       As String = "$TXT_LABEL_3"
Sub _updateScene_assignPieLabel( contLabelBase As Container, strValue As String, aPieLabel As Array[String] )
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignPieLabel():"
	Dim strTemp As String
	Dim i, numLines As Integer
	
	' get number of labels
	numLines = aPieLabel.UBound
	
	' trim strings
	strValue.Trim()
	For i = 0 To numLines
		aPieLabel[i].Trim()
'println "_updateScene_assignPieLabel: [aPieLabel[" & i & "]: [" & aPieLabel[i] & "]______________________________"
	Next
		
'println "_updateScene_assignPieLabel: [strValue]: [" & strValue & "]______________________________"
	' set value text
'	If strValue <> "" Then
		contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active = TRUE
		contLabelBase.FindSubContainer( kPieTextValueSubPath & kPieValueSubPath ).Geometry.Text = strValue
'	Else
'		contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active = FALSE
'	End If
'println "_updateScene_assignPieLabel: [contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active]: [" & contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active & "]______________________________"
	
	' set label text
' ##############################################################################
'  hier viertes Label für Bremen ###############################################
' ##############################################################################

	If aPieLabel[4] <> "" Then
		updateScene_setPieLabelText( 5, contLabelBase, aPieLabel )
	ElseIf aPieLabel[3] <> "" Then
		updateScene_setPieLabelText( 4, contLabelBase, aPieLabel )
	ElseIf aPieLabel[2] <> "" Then
		updateScene_setPieLabelText( 3, contLabelBase, aPieLabel )
	ElseIf aPieLabel[1] <> "" Then
		updateScene_setPieLabelText( 2, contLabelBase, aPieLabel )
	ElseIf aPieLabel[0] <> "" Then
		updateScene_setPieLabelText( 1, contLabelBase, aPieLabel )
	Else
		updateScene_setPieLabelText( 0, contLabelBase, aPieLabel )
	End If
	
End Sub
'-------------------------------------------------------------------------------
'
Sub _updateScene_assignPieLabelPD( contLabelBase As Container, strValue As String, strDiff As String, aPieLabel As Array[String] )
	Dim strDebugLocation As String = strScriptName & "_updateScene_assignPieLabel():"
	Dim strTemp As String
	Dim i, numLines As Integer
	
	' get number of labels
	numLines = aPieLabel.UBound
	
	' trim strings
	strValue.Trim()
	For i = 0 To numLines
		aPieLabel[i].Trim()
'println "_updateScene_assignPieLabel: [aPieLabel[" & i & "]: [" & aPieLabel[i] & "]______________________________"
	Next
		
'println "_updateScene_assignPieLabel: [strValue]: [" & strValue & "]______________________________"
	' set value text
'	If strValue <> "" Then
		contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active = TRUE
		contLabelBase.FindSubContainer( kPieTextValueSubPath & kPieValueSubPath ).Geometry.Text = strValue
		contLabelBase.FindSubContainer( kPieTextValueSubPath & kPieDiffSubPath ).Geometry.Text = strDiff
'	Else
'		contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active = FALSE
'	End If
'println "_updateScene_assignPieLabel: [contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active]: [" & contLabelBase.FindSubContainer( kPieTextValueSubPath ).Active & "]______________________________"
	
	' set label text
	If aPieLabel[3] <> "" Then
		updateScene_setPieLabelText( 4, contLabelBase, aPieLabel )
	ElseIf aPieLabel[2] <> "" Then
		updateScene_setPieLabelText( 3, contLabelBase, aPieLabel )
	ElseIf aPieLabel[1] <> "" Then
		updateScene_setPieLabelText( 2, contLabelBase, aPieLabel )
	ElseIf aPieLabel[0] <> "" Then
		updateScene_setPieLabelText( 1, contLabelBase, aPieLabel )
	Else
		updateScene_setPieLabelText( 0, contLabelBase, aPieLabel )
	End If
	
End Sub
'-------------------------------------------------------------------------------
'
Sub	updateScene_setPieLabelText( nLines As Integer, contLabelBase As Container, aPieLabel As Array[String] )
	Dim i As Integer
	Dim aString As Array[String]
	'swap order of labels
	aString.Clear
	For i = nLines-1 To 0 Step -1
	  aString.Push( aPieLabel[i] )
	Next
	' activate required
	For i = 1 To nLines
		contlabelBase.FindSubContainer( kPieTextLabelSubPath & CStr(i) ).Active = TRUE
		
		contlabelBase.FindSubContainer( kPieTextLabelSubPath & CStr(i) & kPieTextSubPath ).Geometry.Text = aString[i-1]
'println "[kPieTextLabelSubPath & CStr(i) & kPieTextSubPath] [aPieLabel[" & kPieTextLabelSubPath & CStr(i) & kPieTextSubPath & "] [" & i-1 & "]: [" &aPieLabel[i-1] & "] visible -----"
	
	Next
	' hide all container	
	For i = nLines+1 To kPieMaxLabelLines
		contlabelBase.FindSubContainer( kPieTextLabelSubPath & CStr(i) ).Active = FALSE
	Next
End Sub
'-------------------------------------------------------------------------------
'
Function _calcSumOfValue( aValueNum As Array[String], nValues As Integer ) As Double
	Dim iCnt As Integer
	Dim dblSum As Double
	
	dblSum = 0.0
	For iCnt = 0 To nValues - 1
		dblSum += CDbl( aValueNum[iCnt] )
	Next
	_calcSumOfValue = dblSum
End Function
'-------------------------------------------------------------------------------
'
Function _getAbsMaxBaxValue( aValueNum As Array[String] ) As Double
	Dim iCnt As Integer
	Dim dblValue, dblMaxValue As Double
	
	dblValue = 0.0
	dblMaxValue = 0.0
	For iCnt = 0 To aValueNum.UBound
		dblValue = CDbl( aValueNum[iCnt] )
		dblValue = Abs( dblValue )
		If dblValue > dblMaxValue Then
			dblMaxValue = dblValue
		End If
	Next
	_getAbsMaxBaxValue = dblMaxValue
End Function
'-------------------------------------------------------------------------------
'
Function _getAbsMinBaxValue( aValueNum As Array[String] ) As Double
	Dim iCnt As Integer
	Dim dblValue, dblMinValue As Double
	
	dblValue = 0.0
	dblMinValue = 0.0
	For iCnt = 0 To aValueNum.UBound
		dblValue = CDbl( aValueNum[iCnt] )
		dblValue = Abs( dblValue )
		If dblValue > dblMinValue Then
			dblMinValue = dblValue
		End If
	Next
	_getAbsMinBaxValue = dblMinValue
End Function
'-------------------------------------------------------------------------------
'
Function _getMaxBaxValue( aValueNum As Array[String] ) As Double
	Dim iCnt As Integer
	Dim dblValue, dblMaxValue As Double
	
	dblValue = 0.0
	dblMaxValue = 0.0
	For iCnt = 0 To aValueNum.UBound
		dblValue = CDbl( aValueNum[iCnt] )
		dblValue = dblValue
		If dblValue > dblMaxValue Then
			dblMaxValue = dblValue
		End If
	Next
	_getMaxBaxValue = dblMaxValue
End Function
'-------------------------------------------------------------------------------
'
Function _getMinBaxValue( aValueNum As Array[String] ) As Double
	Dim iCnt As Integer
	Dim dblValue, dblMinValue As Double
	
	dblValue = 0.0
	dblMinValue = 0.0
	For iCnt = 0 To aValueNum.UBound
		dblValue = CDbl( aValueNum[iCnt] )
		If dblValue < dblMinValue Then
			dblMinValue = dblValue
		End If
	Next
	_getMinBaxValue = dblMinValue
End Function
'-------------------------------------------------------------------------------
'
Function _validateMinBarValue( dblValue As Double, dblMinValue As Double ) As Double
	Dim dblReturn As Double

	If Abs(dblValue) < dblMinValue And dblValue < 0 Then
		dblReturn = (-1)*dblMinValue
	ElseIf Abs(dblValue) < dblMinValue And dblValue >= 0 Then
		dblReturn = dblMinValue
	Else
		dblReturn = dblValue
	End If
	_validateMinBarValue = dblReturn
End Function
'-------------------------------------------------------------------------------
'
Sub _PlayoutAnimationClear( strAction As String )
	If strAction = "ALL" Then
		aPlayoutAnimationIN.Clear()
		aPlayoutAnimationOUT.Clear()
	ElseIf strAction = "IN" Then
		aPlayoutAnimationIN.Clear()
	ElseIf strAction = "OUT" Then
		aPlayoutAnimationOUT.Clear()
	End If
End Sub
'-------------------------------------------------------------------------------
'
Sub _PlayoutAnimationSwap()
'	_PlayoutAnimationClear( "OUT" )
	aPlayoutAnimationOUT = aPlayoutAnimationIN
End Sub
'-------------------------------------------------------------------------------
'
Sub _PlayoutAnimationAdd( contMerged As Container, strAnimOrderFlag As String )
	Dim sAnimationPlayout As structAnimationPlayout

	sAnimationPlayout.strDirectorName = contMerged.name
	sAnimationPlayout.dirAnimation    = contMerged.GetDirectorOfMergedGeometry()
	sAnimationPlayout.intIndex        = CInt( strAnimOrderFlag )
	aPlayoutAnimationIN.Push( sAnimationPlayout )

'println "[_PlayoutAnimationAdd]:: [intIndex] [dirAnimation.name] [vizID]: [" & sAnimationPlayout.intIndex & "] [" & sAnimationPlayout.dirAnimation.name & "] [" & sAnimationPlayout.dirAnimation.vizID & "]"
End Sub
'-------------------------------------------------------------------------------
'
Sub _PlayoutAnimationDirectorNameAdd( strDirectorName As String, strAnimOrderFlag As String )
	Dim sAnimationPlayout As structAnimationPlayout
	Dim contBlenderIN As Container
	Dim dirEAnimIN As Director	

'	contBlenderIN   = Scene.FindContainer("$ALL$CONTENT$ELE_PLAYOUT$ELE_ANIMATION$moBLENDER$IN$ELEMENT")
'	dirEAnimIN  = contBlenderIN.GetDirectorOfMergedGeometry()

	sAnimationPlayout.strDirectorName = strDirectorName
'	sAnimationPlayout.dirAnimation    = dirEAnimIN.FindSubDirector( "$" & strDirectorName )
	sAnimationPlayout.dirAnimation    = Stage.FindDirector( "$" & strDirectorName )
	sAnimationPlayout.intIndex = CInt( strAnimOrderFlag )
	aPlayoutAnimationIN.Push( sAnimationPlayout )
'println "[_PlayoutAnimationDirectorNameAdd]:: [intIndex] [dirAnimation.name] [vizID]:  [" & sAnimationPlayout.intIndex & "] [" & sAnimationPlayout.dirAnimation.name & "] [" & sAnimationPlayout.dirAnimation.vizID & "]"
End Sub
'-------------------------------------------------------------------------------
'
Sub _PlayoutAnimationSubDirectorAdd( contMerged As Container, strSubDirectorName As String, intIdxOffest As Integer )
	Dim sAnimationPlayout As structAnimationPlayout
	Dim dirAnimation As Director
	Dim iAni, cntAni As Integer

	cntAni = 0
'println	"[_PlayoutAnimationKoalSplitAdd]:: [aPlayoutAnimationIN.UBound]: [" & aPlayoutAnimationIN.UBound & "]"
	For iAni = 0 To aPlayoutAnimationIN.UBound - 1
		If aPlayoutAnimationIN[iAni].intIndex >= cntAni Then
			cntAni = aPlayoutAnimationIN[iAni].intIndex + 1
'println "[_PlayoutAnimationKoalSplitAdd]:: [aPlayoutAnimationIN[" & iAni & "].intIndex] [cntAni]: [" & aPlayoutAnimationIN[iAni].intIndex & "] [" & cntAni & "]"
		End If
	Next
	dirAnimation = contMerged.GetDirectorOfMergedGeometry()
	sAnimationPlayout.strDirectorName = strSubDirectorName
	sAnimationPlayout.dirAnimation    = dirAnimation.FindSubDirector( strSubDirectorName )
	sAnimationPlayout.intIndex        = cntAni + intIdxOffest
	aPlayoutAnimationIN.Push( sAnimationPlayout )

'println "[_PlayoutAnimationKoalSplitAdd]:: [dirAnimation.name] [cntAni]: [" & sAnimationPlayout.dirAnimation.name & "] [" & cntAni & "]"
End Sub
''-------------------------------------------------------------------------------
'Structure structAnimationPlayout
'	strDirectorName As String
'	dirAnimation    As Director
'	intIndex        As Integer
'End Structure
''-------------------------------------------------------------------------------
'Dim aPlayoutAnimationIN As Array[structAnimationPlayout]
'*******************************************************************************
' strType: ANI_IO, ANI_DATA
Structure structPlayoutAnimEvent
	strType         As String
	intIndex        As Integer
	strDirectorName As String
	dirAnimation    As Director
	strKeyStart     As String
	strKeyEnd       As String
End Structure
'-------------------------------------------------------------------------------
Dim aPlayoutEventListIN  As Array[structPlayoutAnimEvent]
Dim aPlayoutEventListOUT As Array[structPlayoutAnimEvent]
'-------------------------------------------------------------------------------
' clear playout animation event list
Sub _POA_ClearEvents( strAction As String )
	If strAction = "ALL" Then
		aPlayoutEventListIN.Clear()
		aPlayoutEventListOUT.Clear()
	ElseIf strAction = "IN" Then
		aPlayoutEventListIN.Clear()
	ElseIf strAction = "OUT" Then
		aPlayoutEventListOUT.Clear()
	End If
End Sub
'-------------------------------------------------------------------------------
' swap playout animation event list
Sub _POA_SwapEventList()
	aPlayoutEventListOUT = aPlayoutEventListIN
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_AddEvent_vizDirector( strType As String, strAnimIndex As String, strKeyStart As String, strKeyEnd As String, dirDirector As Director )
	Dim sPlayoutAnimEvent As structPlayoutAnimEvent
	
	sPlayoutAnimEvent.strType         = strType
	sPlayoutAnimEvent.intIndex        = CInt( strAnimIndex )
	sPlayoutAnimEvent.strKeyStart     = strKeyStart
	sPlayoutAnimEvent.strKeyEnd       = strKeyEnd
	sPlayoutAnimEvent.dirAnimation    = dirDirector
	sPlayoutAnimEvent.strDirectorName = sPlayoutAnimEvent.dirAnimation.Name

	aPlayoutEventListIN.Push( sPlayoutAnimEvent )
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_AddEvent_DirectorName( strType As String, strAnimIndex As String, strKeyStart As String, strKeyEnd As String, directorName As String )
	Dim sPlayoutAnimEvent As structPlayoutAnimEvent
	
	sPlayoutAnimEvent.strType         = strType
	sPlayoutAnimEvent.intIndex        = CInt( strAnimIndex )
	sPlayoutAnimEvent.strKeyStart     = strKeyStart
	sPlayoutAnimEvent.strKeyEnd       = strKeyEnd
	sPlayoutAnimEvent.dirAnimation    = Stage.FindDirector( directorName )
	sPlayoutAnimEvent.strDirectorName = sPlayoutAnimEvent.dirAnimation.Name

	aPlayoutEventListIN.Push( sPlayoutAnimEvent )
End Sub
'-------------------------------------------------------------------------------
' add director of merged container to playout event list
Sub _POA_AddEvent_MergedContainerDirector( strType As String, strAnimIndex As String, strKeyStart As String, strKeyEnd As String, contMerged As Container )
	Dim sPlayoutAnimEvent As structPlayoutAnimEvent
	
	sPlayoutAnimEvent.strType         = strType
	sPlayoutAnimEvent.intIndex        = CInt( strAnimIndex )
	sPlayoutAnimEvent.strKeyStart     = strKeyStart
	sPlayoutAnimEvent.strKeyEnd       = strKeyEnd
	sPlayoutAnimEvent.dirAnimation    = contMerged.GetDirectorOfMergedGeometry()
	sPlayoutAnimEvent.strDirectorName = sPlayoutAnimEvent.dirAnimation.Name

	aPlayoutEventListIN.Push( sPlayoutAnimEvent )
End Sub
'-------------------------------------------------------------------------------
' add subdirector of merged container to playout event list
Sub _POA_AddEvent_MergedContainerSubDirector( strType As String, strAnimIndex As String, strKeyStart As String, strKeyEnd As String, contMerged As Container, strSubDirectorName As String )
	Dim sPlayoutAnimEvent As structPlayoutAnimEvent
	Dim dirAnimation As Director
	
	sPlayoutAnimEvent.strType         = strType
	dirAnimation = contMerged.GetDirectorOfMergedGeometry()
	sPlayoutAnimEvent.intIndex        = CInt( strAnimIndex )
	sPlayoutAnimEvent.strKeyStart     = strKeyStart
	sPlayoutAnimEvent.strKeyEnd       = strKeyEnd
	sPlayoutAnimEvent.dirAnimation    = dirAnimation.FindSubDirector( strSubDirectorName )
	sPlayoutAnimEvent.strDirectorName = sPlayoutAnimEvent.dirAnimation.Name

'println "---- _POA_AddEvent_MergedContainerSubDirector():: [Type] [intIndex] [KeyStart] [KeyEnd] [name] [vizID]: [" & sPlayoutAnimEvent.strType & "] [" & sPlayoutAnimEvent.intIndex & "] [" & sPlayoutAnimEvent.strKeyStart & "] [" & sPlayoutAnimEvent.strKeyEnd & "] [" & sPlayoutAnimEvent.strDirectorName & "] [" & sPlayoutAnimEvent.dirAnimation.vizID & "]"
	aPlayoutEventListIN.Push( sPlayoutAnimEvent )
End Sub
'-------------------------------------------------------------------------------
'
Function _POA_getNextPOIndex() As String
	Dim iAni, cntAni As Integer

	cntAni = 0
	For iAni = 0 To aPlayoutEventListIN.UBound - 1
		If aPlayoutEventListIN[iAni].intIndex >= cntAni Then
			cntAni = aPlayoutEventListIN[iAni].intIndex + 1
		End If
	Next
	_POA_getNextPOIndex = CStr( cntAni )
End Function

'-------------------------------------------------------------------------------
'
Sub _POA_PlayGoToTrioIdx( strType As String, strEventList As String, intIndex As Integer )
	Dim iCnt As Integer
	Dim strVizCommand As String
	Dim aPOEventList  As Array[structPlayoutAnimEvent]
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If intIndex = aPOEventList[iCnt].intIndex And strType = aPOEventList[iCnt].strType Then
			strVizCommand = "#" & aPOEventList[iCnt].dirAnimation.vizID & " GOTO_TRIO " & aPOEventList[iCnt].strKeyStart & " " & aPOEventList[iCnt].strKeyEnd
			System.SendCommand( strVizCommand )
'println "---- _POA_PlayGoToTrioIdx():: [Type] [intIndex] [KeyStart] [KeyEnd] [name] [vizID]: [" & sPlayoutAnimEvent.strType & "] [" & sPlayoutAnimEvent.intIndex & "] [" & sPlayoutAnimEvent.strKeyStart & "] [" & sPlayoutAnimEvent.strKeyEnd & "] [" & sPlayoutAnimEvent.strDirectorName & "] [" & sPlayoutAnimEvent.dirAnimation.vizID & "]"
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_PlayGoToTrioALL( strType As String, strEventList As String )
	Dim iCnt As Integer
	Dim strVizCommand As String
	Dim aPOEventList  As Array[structPlayoutAnimEvent]
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If strType = aPOEventList[iCnt].strType Then
			strVizCommand = "#" & aPOEventList[iCnt].dirAnimation.vizID & " GOTO_TRIO " & aPOEventList[iCnt].strKeyStart & " " & aPOEventList[iCnt].strKeyEnd
			System.SendCommand( strVizCommand )
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_PlayShowStartALL( strType As String, strEventList As String )
	Dim iCnt As Integer
	Dim aPOEventList  As Array[structPlayoutAnimEvent]
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If strType = aPOEventList[iCnt].strType Then
			System.SendCommand( "#" & aPOEventList[iCnt].dirAnimation.vizID & " SHOW " & aPOEventList[iCnt].strKeyStart )
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_PlayShowEndALL( strType As String, strEventList As String )
	Dim iCnt As Integer
	Dim aPOEventList  As Array[structPlayoutAnimEvent]
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If strType = aPOEventList[iCnt].strType Then
			System.SendCommand( "#" & aPOEventList[iCnt].dirAnimation.vizID & " SHOW " & aPOEventList[iCnt].strKeyEnd )
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_PlayAnimGoToTrioCmdALL( strType As String, strEventList As String, strTrioCmd As String )
	Dim iCnt As Integer
	Dim aPOEventList  As Array[structPlayoutAnimEvent]
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If strType = aPOEventList[iCnt].strType Then
			System.SendCommand( "#" & aPOEventList[iCnt].dirAnimation.vizID & " GOTO_TRIO " & strTrioCmd )
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
Sub _POA_PlayAnimGoToTrioFindSubDirectorALL( strType As String, strEventList As String, strTrioCmd As String, dirParent As Director )	
	Dim iCnt As Integer
	Dim aPOEventList As Array[structPlayoutAnimEvent]
	Dim dirAnimation As Director
	
	If strEventList = "EventIN" Then
		aPOEventList = aPlayoutEventListIN
	ElseIf strEventList = "EventOUT" Then
		aPOEventList = aPlayoutEventListOUT
	End If

	For iCnt = 0 To aPOEventList.UBound
		If strType = aPOEventList[iCnt].strType Then
			dirAnimation = dirParent.FindSubDirector( aPOEventList[iCnt].strDirectorName )
			System.SendCommand( "#" & dirAnimation.vizID & " GOTO_TRIO " & strTrioCmd )
		End If
	Next
End Sub
'-------------------------------------------------------------------------------
'
' Scene._POA_PlayAnimCmdSearchALL( "ANI_IO", "GOTO_TRIO $START $IN", dirEAnimIN )
Sub _POA_PlayAnimCmdSearchALL( strDirectorName As String, strAnimationCmd As String, dirDirector As Director )
	Dim dirChild1, dirChild2, dirChild3 As Director
	Dim iCnt, jCnt, kCnt, totalCnt As Integer

	iCnt = 0
	jCnt = 0
	kCnt = 0
	totalCnt = 0

'	println "......................................................................."
'	println "[strDirectorName] [strAnimationCmd] [dirDirector.name] [dirDirector.vizID]: [" & strDirectorName & "] [" & strAnimationCmd & "] [" & dirDirector.name & "] [" & dirDirector.vizID & "]"
'	println ".. [dirDirector.vizID] [dirDirector.Name]: [" & dirDirector.vizID & "] [" & dirDirector.Name & "]"
	dirChild1 = dirDirector.ChildDirector

	Do 
		If dirChild1.Name = strDirectorName Then
'			println ".. [dirChild1.vizID] [dirChild1.Name]: [" & dirChild1.vizID & "] [" & dirChild1.Name & "]"
'			println ".. [vizCommand]: [" & "#" & dirChild1.vizID & " " & strAnimationCmd & "]"
			System.SendCommand( "#" & dirChild1.vizID & " " & strAnimationCmd )
		End If

		dirChild2 = dirChild1.ChildDirector
		Do 
			If dirChild2.Name = strDirectorName Then
'				println "...... [dirChild2.vizID] [dirChild2.Name]: [" & dirChild2.vizID & "] [" & dirChild2.Name & "]"
'				println ".. [vizCommand]: [" & "#" & dirChild2.vizID & " " & strAnimationCmd & "]"
				System.SendCommand( "#" & dirChild2.vizID & " " & strAnimationCmd )
			End If

			dirChild3 = dirChild2.ChildDirector
			Do 
				If dirChild3.Name = strDirectorName Then
'					println "........ [dirChild3.vizID] [dirChild3.Name]: [" & dirChild3.vizID & "] [" & dirChild3.Name & "]"
'					println ".. [vizCommand]: [" & "#" & dirChild3.vizID & " " & strAnimationCmd & "]"
					System.SendCommand( "#" & dirChild3.vizID & " " & strAnimationCmd )
				End If
			
				dirChild3 = dirChild3.NextDirector
				kCnt++
				totalCnt++
			Loop While kCnt < 100 And dirChild3.vizID <> 0
			kCnt = 0

			dirChild2 = dirChild2.NextDirector
			jCnt++
			totalCnt++
		Loop While jCnt < 60 And dirChild2.vizID <> 0
		jCnt = 0
	
		dirChild1 = dirChild1.NextDirector
		iCnt++	
		totalCnt++
	Loop	While iCnt < 350 And dirChild1.vizID <> 0
	iCnt = 0
	
'	println "DEBUG: SceneScript::[strDirName] [strAniCmd] [dirDir.Name] [totalCnt]: [" & strDirectorName & "] [" & strAnimationCmd & "] [" & dirDirector.Name & "] [" & totalCnt & "]"

End Sub
'-------------------------------------------------------------------------------
'
'-------------------------------------------------------------------------------
' STRUCTURE defions 4 Interactive
'-------------------------------------------------------------------------------
Structure struct_parameter
	sParameterType  As String
	sParameterName  As String
	sParameterValue As String
End Structure
'-------------------------------------------------------------------------------
Structure struct_GraphicsDetails
	sSceneType  As String
	sScriptCont As String
	iStops      As Integer
	iGroup      As Integer
	iElement    As Integer
	iDataId     As Integer
	oTransition As Array[struct_parameter]
	oHeadline   As Array[struct_parameter]
	oParameter  As Array[struct_parameter]
	oLegende    As Array[struct_parameter]
End Structure
'-------------------------------------------------------------------------------
Structure struct_GraphicsHandler
	nGraphics As Integer
	currPos   As Integer
	oGraphics As Array[struct_GraphicsDetails]
End Structure
'-------------------------------------------------------------------------------
'
Sub SetHRSVK2_Variant(iVariant as Integer)
	iHRSVK2_Variant = iVariant
End Sub

Function GetHRSVK2_Variant() as Integer
	GetHRSVK2_Variant = iHRSVK2_Variant
End Function
