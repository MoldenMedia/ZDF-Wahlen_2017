ToDo:
- center graphics on screen
- calculate distance between groups!!

- PLAYOUT SCRIPTS!!!
- ANMATIONS!!!

NOTE:
Noggi Width  = 736.5 is 1920 pixel screen size
Noggi Height = 414.2 is 1080 pixel screen size

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
