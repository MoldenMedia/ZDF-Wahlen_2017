ToDo:
- adapt moPlayoutHRPX_v2017.vbs script

General:
- center graphics on screen

NOTE:
Noggi Width  = 736.5 is 1920 pixel screen size
Noggi Height = 414.2 is 1080 pixel screen size
------------------------------------------------------------------------------
DONE:
General     : Headline,Legende (teilweise)
Hochrechnung: HRPZ, HRPD, HRPD, HRPG, HRWB, HROW_2x/3x/4x/5x/6x/7x
Umfrage     : UMVP, UMVD, UMVB_2x/3x, UMKV3 (teilweise)

------------------------------------------------------------------------------
TODO:
--> maxSize for UMVD
--> maxSize for UMVD needs to be fixed
--> range scaling

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.04.06:
moGenerateUM_v2017:
- UMKB bars are using horizontal bars in the layout 2017

moPlayoutUMKB_v2017:
- started support for layout 2017

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.04.01/04/05:
SceneScript_v2017:
- add dblMaxVizValueHROWP, dblMaxVizValueHROWPD
- set dblMaxVizValueUMKB to 190
- move definition of default values into script code

moGenerateUM_v2017:
- UMKB bars are using horizontal bars in the layout 2017

moPlayoutUMHX_v2017:
- add support for difference value labels 

moPlayoutHROW_v2017:
- add support for difference value labels 

moPlayoutUMKB_v2017:
- started support for layout 2017

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.28:
moPlayoutANNQRX_v2017:
- fix color and visibility for ANNQRD 

SceneScript_v2017:
- height for UMHX

Bug fixes and minor changes:
. moPlayoutANNQRX_v2017
. moPlayoutANSVZX_v2017
. moPlayoutUMHX_v2017

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.27:
moPlayout-Scripts:
- add thePercentInfoFlag set visibility of txt_unit (percent sign)
   . moPlayoutANNQRX_v2017 (ANNQRP, ANNQRPD, ANNQRD)
   . moPlayoutANSVZX_v2017 (ANSVZP, ANSVZPD)
   . moPlayoutHRPX_v2017
   . moPlayoutUMVX_v2017
   . moPlayoutHROW_v2017

moGenerateUM_v2017:
- set position.x of info percent label

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.26:
scene - Geometry:
- create gUMHP_Base
- create gUMHP_Group
- create gUMUP_57h
- modify gUMVP_Base
- modify gUMVD_Base

moGenerateUM_v2017:
- cleanup and remove checking for maxGroups and maxBars
- adapt functions for horizontal bar variants
  . readGeometryDetails()
  . createGeometry()
- major cleanup of unused functions and variables

moPlayoutUMHX_v2017:
- bug fixing
- dynamic transform between two bar variants depending on group label content

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.24/25:
moGenerateUM_v2017:
- add dimensions for horizontal bar variants

moPlayoutUMHX_v2017:
- started
- adapted material path and assignments
- removed mirror and arrow references
- add thePercentInfoFlag

SceneScript_v2017:
- set dblMaxVizValueUMHP  = 165.0
- set dblMaxVizValueUMHPD = 120.0

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.22/23:
SceneScript_v2017
- set max Viz value ANVPD  = 138.0

moPlayout-Scripts:
- add thePercentInfoFlag
   . moPlayoutANSVZX_v2017*
   . moPlayoutANNQRX_v2017*
   . moPlayoutHROW_v2017
   . moPlayoutHRPX_v2017
   . moPlayoutHRSVS1_v2017
   . moPlayoutHRWB_v2017
   . moPlayoutUMKV_v2017
   . moPlayoutUMKV3_v2017
   . moPlayoutUMVB_v2017
   . moPlayoutUMVX_v2017

moPlayoutHRPX_v2017:
- cleanup

moPlayoutANNQRX_v2017:
- multi-line-label support for ANNQRP
- multi-line-label support for ANNQRPD

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.18:
scene - Geometry:
- prepare element HRPG_1-5b for multi-line-label support
- prepare graphic gHRPG_2x for multi-line-label support
- prepare element HRPZD_1-5b for multi-line-label support
- prepare graphic gHRPZD_2x for multi-line-label support

SceneScript_v2017
- set max Viz value HRPG  = 138.0
- add strTemp.Trim() to _updateScene_assignLabel_3_2017()

moPlayoutHRPX_v2017:
- multi-line-label support for HRPG
- multi-line-label support for HRPZD

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.17:
scene - Geometry:
- prepare element HRPZ_1-5b for multi-line-label support
- prepare graphic gHRPZ_2x for multi-line-label support

moPlayoutHRPX_v2017:
- multi-line-label support for HRPZ

SceneScript_v2017:
- add sub _updateScene_assignLabel_3_2017 for mulit-line-label support 

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.15/16:
scene - Geometry:
- adapted gANSVZP_2x geometry
- adapted gANSVZPD_2x geometry

SceneScript_v2017:
- set max Viz value ANVP = 167.0
- define and set theANLabHeight to 3.8

moPlayout-Scripts:
- comment out ANSItoUTF8
   . moPlayoutHROW_v2017
   . moPlayoutHRPX_v2017
   . moPlayoutHRSVS1_v2017
   . moPlayoutHRWB_v2017
   . moPlayoutLegends_v2017
   . moPlayoutUMKV_v2017
   . moPlayoutUMVB_v2017
   . moPlayoutUMVX_v2017
   . moPlayoutHeadline_v2017
   . moPlayoutUMKV3_v2017
   . moPlayoutANSVZX_v2017

moPlayoutANSVZX_v2017:
- started adaptation

moPlayoutANNQRX_v2017:
- started adaptation

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.10:
scene - Geometry:
- fixed gHRWB geometry
- fixed gHROW banner width animation in geometry gHWOW_7x

SceneScript_v2017
- set max Viz value HRWB  = 167.0
- set max Viz value HROW  = 195.0
- set max Viz value UMVB  =  65.0

moPlayoutHRWB_v2017
- fix maxSize calculation for 1x line labels HRWB

moPlayoutHROW_v2017
- fix maxSize calculation

moPlayoutUMVB_v2017
- fix maxSize calculation for 1x line labels UMVB

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.09:
SceneScript_v2017
- set max Viz value HRPZ  = 167.0
- set max Viz value HRPD  =  81.0
- set max Viz value HRPZD = 167.0
- set max Viz value HRPG  = 167.0
- set max Viz value UMVP  = 167.0
- set max Viz value UMVD  =  81.0
- add OnParameterChanged function

moPlayoutHRPX_v2017
- fix maxSize calculation for 1x line labels HRPZ, HRPG, HRPZD, HRPD

moPlayoutUMVX_v2017
- fix maxSize calculation for 1x line labels UMVP, UMVD

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.07:
scene - Geometry:
- continued gHRSVS1 adaptation

moPlayoutHRSVS1_v2017
- adapted playout control for Legends (position.X)
- cleanup script

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.03.06:
scene - Geometry:
- started gHRSVS1 adaptation
- removed mirror geometries
- adapt label for Gesamtsitze and Majority

moPlayoutHRSVS1_v2017
- adapted playout control for Legends (container path, material, material)

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
2017.02.27:
scene - Geometry:
- started gUMKV3 adaptation

moPlayoutLegends_v2017
- adapted playout control for Legends (container path, visibility, animation keyframe, material)

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
