ToDo:
- create gHRPG graphics
- adapt moPlayoutHRPX_v2017.vbs script

General:
- center graphics on screen

- PLAYOUT SCRIPTS!!!
- ANMATIONS!!!

NOTE:
Noggi Width  = 736.5 is 1920 pixel screen size
Noggi Height = 414.2 is 1080 pixel screen size
------------------------------------------------------------------------------
DONE:
General     : Headline
Hochrechnung: HRPZ, HRPD, HRPD, HRPG, HRWB, HROW_7x
Umfrage     : UMVP, UMVD, UMVB_2x

------------------------------------------------------------------------------
TODO:
create gHROW_2b, gHROW_3b, gHROW_4b, gHROW_5b, gHROW_6b, gHROW_8b, gHROW_9b analog gHROW_7b
create gHRPG_6b, gHRPG_7b, gHRPG_8b, gHRPG_9b

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.26:
scene - Geometry:
- created gHROW_7b

moPlayoutHROW_v2017
- adapted playout control for UMVD (container path, visibility, animation keyframe, material)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.26:
scene - Geometry:
- created gUMVD_1-5b
- created gUMVD_6-7b
- created gUMVD_8b
- created gUMVD_9b
- created gHRWB (Hochrechnung - Wahlbeteiligung)
- created gUMVB_2x (Umfrage - Balken Bild 2x)

moPlayoutUMVX_v2017
- adapted playout control for UMVD (container path, visibility, animation keyframe, material)

moPlayoutHRWB_v2017
- adapted playout control for HRWB (container path, geometries, animation keyframe, material)

moGenerateUM_v2017.vbs
- set width of pos and neg backgroud panel for UMVD graphs

moPlayoutUMVB_v2017
- adapted playout control for UMVB (container path, geometries, animation keyframe, material)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.22:
scene - Geometry:
- clean up
- fixed base geometries

- created HRPD_1-5b
- created gHRPD_2b
- created gHRPD_3b
- created gHRPD_4b
- created gHRPD_5b

moGenerateUM_v2017.vbs
- reset bar width to UM bar width

moPlayoutHRPX_v2017
- adapted playout control for HRPD (container path, visibility, animation keyframe)
- !!! SET MAX VIZ HEIGHT TO 100.00 max height of noggi!!

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.21:
scene - Geometry:
- created gHRPG_2b
- created gHRPG_3b
- created gHRPG_4b
- created gHRPG_5b
- modified HRPG_1-5b -fixed nameing of containers showing arrows

- created HRPZD_1-5b
- created gHRPZD_2b
- created gHRPZD_3b
- created gHRPZD_4b
- created gHRPZD_5b

moPlayoutHRPX_v2017
- some cleanup

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.20:
scene - Geometry:
- updated HRVP_1-5b
- updated HRVP_6-7b
- updated HRVP_8b
- updated HRVP_9b
- created gHRPZ_2b ... 9b
- created HRPG_1-5b


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.17:
scene - Geometry:
- updated headline geometry
- typo left
- typo right
- politbarometer

moPlayoutHRPX_v2017
- removed all mirror references
- added kServerMaterialPath

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

2017.02.16:
scene - Geometry:
- updated label structure in geometry gUMVP_1-5b
- updated label structure in geometry gUMVP_6-7b
- updated label structure in geometry gUMVP_8b
- updated label structure in geometry gUMVP_9b

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.15:
scene - Geometry:
- updated geometry gUMVP_6-7b
- updated geometry gUMVP_8b
- updated geometry gUMVP_9b

moPlayoutUMVX_v2017.vbs
- testing

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.14:
moGenerateUM_v2017.vbs
- calculate distance between groups
- cleanup Script

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.13:
scene - Geometry:
- updated geometry gUMVP_Base
- updated geometry gUMVP_Group
- updated geometry gUMVP_1-5b

moGenerateUM_v2017.vbs
- fixed calculation for bargaps
- added kVizToPixelFactor
- fixed calculation of banner and background Width

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.11:
moTransitionGfx_v2017.vbs:
- started analyzing transition Script
- started to adapt transition animation of base elements

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.07:
moGenerateUM_v2017.vbs
- fixed animations for gUMVB_6-7b
- set group width to value of banner width (bug in calculation)

moPlayoutUMVX_v2017.vbs
- removed all mirror references
- added kServerMaterialPath
- 

SceneScript_v2017.vbs
- _updateScene_assignLabel_3: comment autofollow settings

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.01:
- set correct gap between groups for 1-5b and 6-7b
- calculate the width of the label background -> first draft

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.01.31: 
- use correct selected type of bar to create graph
- set correct gap between groups for 1-5b and 6-7b
  currently only one geometry prototype is available for testing !!!!
  --> set the same bar width for all type of bars.
  
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.01.30: 
- use correct values for gap between bars and groups
- fix selecting the correct bar type

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.01.25: 
- basic generation of bars

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.01.24: 
-> continue with moGenerateUM_v00->createGeometry_UMVerticalX()
