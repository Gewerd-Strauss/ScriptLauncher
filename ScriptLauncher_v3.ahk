/* 	; Modified by Gewerd S.Source Code at bottom
; reworked by Gewerd S. to allow files from multiple paths to be included, as well as a variety of other small goodies.
;; TODO: functionalise everything, rework cleanly.
Please see documentation on github, found in the "About ScriptLauncher"-Menu (pressing '?' while GUI is visible)
Default, hardcoded hotkey to open GUI: !Sc029 (that is the caret/"^"/Ctrl-Modifiersymbol itself. Can be changed on line 987, or by searching for the string "::".)
/*

;; M= modified, if unsure not marked as such
based on original | AfterLemon 												| https://www.autohotkey.com/board/topic/93997-list-all-ahk-scripts-in-directory-in-gui/

Code by others:
MWAGetMonitor						| Maestr0 													| fetched from https://www.autohotkey.com/boards/viewtopic.php?p=342716#p342716
fTrayRefresh 						| Courtesy of masato, original by Noesis 					| fetched from https://www.autohotkey.com/boards/viewtopic.php?p=156072&sid=f3233e93ef8f9df2aaf4d3dd88f320d0#p156072
f_SortArrays 						| u/astrosofista											| fetched from https://www.reddit.com/r/AutoHotkey/comments/qx0nho/comment/hl6ig7a/?utm_source=share&utm_medium=web2x&context=3
PID by script name 					| just me													| fetched from https://www.autohotkey.com/board/topic/90589-how-to-get-pid-just-by-a-scripts-name/?p=572448
AddToolTip 							| retrieved from AHK-Rare Repository, original by jballi  	| fetched from https://github.com/Ixiko/AHK-Rare, original: https://www.autohotkey.com/boards/viewtopic.php?t=30079
Quote 								| u/anonymous1184 											| fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
ReadINI 							| wolf_II												   M| fetched from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
HasVal 								| jNizM  													| https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
EditSwap							| J. Glines 												| https://the-Automator.com/EditSwap
ScriptObj  							| Gewerd S, RaptorX 					 				   M| https://github.com/Gewerd-Strauss/ScriptObj/blob/master/ScriptObj.ahk, https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk

*/
#Requires AutoHotkey v1.1+
#NoEnv
#Persistent
#SingleInstance Force
#InstallKeybdHook
#KeyHistory 1
#MaxThreads 250
#MaxThreadsBuffer On
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
AutoTrim On
DetectHiddenWindows Off
FileEncoding UTF-8
ListLines Off
CoordMode Mouse, Screen
CoordMode Pixel, Screen
CoordMode ToolTip, Screen
CoordMode Caret, Screen
CoordMode Menu, Screen
SendMode Input
SetTitleMatchMode 2
SetTitleMatchMode Fast
SetWorkingDir % A_ScriptDir
SetKeyDelay -1, -1
SetBatchLines -1
SetWinDelay -1
SetControlDelay -1
;#UseHook
#Warn All, OutputDebug
#NoTrayIcon


BlockInput On
SysGet Size, MonitorWorkArea
SysGet vMonCount,Monitorcount
SetTitleMatchMode 2
FileGetTime ModDate,%A_ScriptFullPath%,M
FileGetTime CrtDate,%A_ScriptFullPath%,C
CrtDate:=SubStr(CrtDate,7, 2) "." SubStr(CrtDate,5,2) "." SubStr(CrtDate,1,4)
ModDate:=SubStr(ModDate,7, 2) "." SubStr(ModDate,5,2) "." SubStr(ModDate,1,4)
global script := new script()
script := { base : script.base
		,name : regexreplace(A_ScriptName, "\.\w+")
		,crtdate : "30.05.2013"
		,moddate : ModDate     
		,resfolder : A_ScriptDir "\res"
		,aboutPath : A_ScriptDir "\res\About.html"
		,reqInternet: false
		,version : "3.17.2"
		,moddate : "26.08.2024"
		,configfile : regexreplace(A_ScriptName, "\.\w+") ".ini"
		,configfolder : A_ScriptDir "\INI-Files\"
		,vAHK	 : A_AhkVersion}
; variable setup
script.loadCredits(script.resfolder "\credits.txt")
	, script.loadMetadata(script.resfolder "\meta.txt")
vTimeTillReload:=1000*60*5
global EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts
global aAllowedToBeClosedClasses:=["AutoHotkey","AutoHotkeyGUI"] ; make sure we don't accidentally kill editors/IDEs

	, ButtonWidth:=180 ; Can change these values
	, IndentFromRight:=230
;
	, XButtonXCoord:=ButtonWidth + 10 ; Don't change these
	, XButtonXCoord2:=ButtonWidth+35
	, TitleWidth:=ButtonWidth - 3*20 - 5
	, SceneWidth:=ButtonWidth + 35
;
	, GuiRight:=SizeRight - IndentFromRight - SceneWidth
	, Button_Right:=SizeRight - IndentFromRight - SceneWidth
	, Button_Bottom:=SizeBottom - 39
;
	, vPIDFileNameMatrix:=[]
	, aPIDarr:=[]
	, aPIDassarr:=[]
	, aButtonXClosedScripts:=[]
	, bKillTrueRestoreFalse:=true
	, Ind:=0
gui 1: new
gui 1: +hwndhwndScriptLauncher
Gui 1: Color, cFFFFFF
SetTitleMatchMode RegEx
DetectHiddenWindows On ; Detect hidden windows


SplitPath A_ScriptName,,,,A_ScriptNameNoExt
if FileExist(sExcludes:=script.configfolder script.configfile) ;|| if FileExist()
{
	aTemp:=fLoadSettings(sExcludes)
		, IncludedFolders:=aTemp[1]
		, IncludedScripts:=aTemp[2]
		, ExcludedScripts:=aTemp[3]
		, IniObj:=aTemp[4]
	if IniObj["Script Behaviour Settings"].bAddSuspendButtons
		SceneWidth+=25
	aTemp:=[] ; clear array again
}
else
{
	DefFileTemplate:="[Insert Folders to INCLUDE below]`n[Insert Script-Names of Scripts in added Folders to Exclude below]`n[Insert Paths to Scripts to INCLUDE below]`n[Script Behaviour Settings]`nbShowTooltips=1`nbHideOnLaunchScript=0`nbHideOnEditScript=1`nbHideOnOpenFolder=1`nbHideOnKillScript=0`nbHideOnSettingsOpened=1`nbAddSuspendButtons=1`nbReloadToKill=1"
	FileAppend %DefFileTemplate%,%sExcludes%
}
aTemp:=f_CreateFileNameAndPathArrays(IncludedFolders,IncludedScripts,ExcludedScripts)
aTemp:=f_SortArrays(aTemp[1],aTemp[2])

;; Sorting must be done by this point, because we start adding buttons now
	, aPathArr:=aTemp[1]
	, aFileNameArr:=aTemp[2]
aPathArr_United:=aPathArr.Clone()
aPathArr:=fSplitObjInHalf(aPathArr)
if IsObject(aPathArr[1])
{
	for k,v in aPathArr[1]
	{
		YPos:=k*25-20
		Gui 1: Add, Button, w%ButtonWidth% h20 x5 y%YPos% gRun hwndRunBtn%Ind%, % aFileNameArr[k]
		if IniObj["Script Behaviour Settings"].bShowTooltips
			AddToolTip(RunBtn%Ind% ,"Run " aFileNameArr[K])

		SetTitleMatchMode 2
		WinGetTitle T,% v
		WinGet PID_T,PID,% T

		aEnableKillButton:=GetProgRunMatrix2(aPathArr)
		Ind++
		if % aEnableKillButton[k]
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " aFileNameArr[K])
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " aFileNameArr[K])
			}
			aPIDarr[k]:=PID_T ; "," PID_T2 "," PID_RGX "," PID_k "," PID_k_c "," PID_WinGetCleanEX
				, aPIDassarr[aFileNameArr[k]]:=PID_T
		}
		else
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " aFileNameArr[K])
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " aFileNameArr[K])
			}
		}
	}
	XButtonXCoordOld:=XButtonXCoord
		, XButtonXCoord2Old:=XButtonXCoord2
		, XButtonXCoord:=XButtonXCoord+235
		, XButtonXCoord2:=XButtonXCoord2+235
	if !IniObj["Script Behaviour Settings"].bAddSuspendButtons
	{
		XButtonXCoord:=XButtonXCoord-25
		XButtonXCoord2:=XButtonXCoord2-25
		; XButtonXCoord:=XButtonXCoord-(XButtonXCoord2Old-XButtonXCoordOld)
		; , XButtonXCoord2:=XButtonXCoord2-(XButtonXCoord2Old-XButtonXCoordOld)
		XPosSecondRow:=240
	}
	; TotalWidth:=
	for k,v in aPathArr[2]
	{

		YPos:=k*25-20
		SplitPath % v, , , vExt, Name
		vc:=(vExt=".exe"?".exe *":(vExt="py"?".py *":""))
		if (A_Index=15) {

		}
		if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			Gui 1: Add, Button, w%ButtonWidth% h20 x240 y%YPos% gRun hwndRunBtn%Ind%, %  Name vc
		else
		{
			Gui 1: Add, Button, w%ButtonWidth% h20 x215 y%YPos% gRun hwndRunBtn%Ind%, %  Name vc
		}
		if IniObj["Script Behaviour Settings"].bShowTooltips
			AddToolTip(RunBtn%Ind% ,"Run " Name (vExt="exe"?" *":""))

		SetTitleMatchMode 2
		WinGetTitle T,% v
		WinGet PID_T,PID,% T

		aEnableKillButton:=GetProgRunMatrix2(aPathArr)
		Ind++
		if % aEnableKillButton[k]
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " Name)
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " Name)
			}
			aPIDarr[k]:=PID_T ; "," PID_T2 "," PID_RGX "," PID_k "," PID_k_c "," PID_WinGetCleanEX
				, aPIDassarr[Name]:=PID_T
		}
		else
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " Name)
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " Name)
			}
		}
	}

}
else
{
	for k,v in aPathArr
	{
		YPos:=k*25-20
		Gui 1: Add, Button, w%ButtonWidth% h20 x5 y%YPos% gRun hwndRunBtn%Ind%, % aFileNameArr[k]
		if IniObj["Script Behaviour Settings"].bShowTooltips
			AddToolTip(RunBtn%Ind% ,"Run " aFileNameArr[K])

		SetTitleMatchMode 2
		WinGetTitle T,% v
		WinGet PID_T,PID,% T

		aEnableKillButton:=GetProgRunMatrix2(aPathArr)
		Ind++
		if % aEnableKillButton[k]
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " aFileNameArr[K])
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " aFileNameArr[K])
			}
			aPIDarr[k]:=PID_T ; "," PID_T2 "," PID_RGX "," PID_k "," PID_k_c "," PID_WinGetCleanEX
				, aPIDassarr[aFileNameArr[k]]:=PID_T
		}
		else
		{
			Gui 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
			if IniObj["Script Behaviour Settings"].bShowTooltips
			{
				AddToolTip(KillBtn%Ind% ,"Kill " aFileNameArr[K])
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					AddToolTip(SusBtn%Ind% ,"Suspend " aFileNameArr[K])
			}
		}
	}
}
ButtonM_Ind:=Ind*(IniObj["Script Behaviour Settings"].bAddSuspendButtons?3:2)+1
	, ButtonE_Ind:=Ind*3+2
	, ButtonD_Ind:=Ind*3+3
	, ButtonR_Ind:=Ind*3+4
	, ButtonO_Ind:=Ind*3+5
	, ButtonS_Ind:=Ind*3+6
	, ButtonQ_Ind:=Ind*3+7
	, ButtonX_Ind:=Ind*3+8
	, ButtonF_Ind:=Ind*3+9
	, YPos += 50
GuiBottom:=SizeBottom - YPos
	, TitlePos:=YPos - 21
	, TitlePos:=YPos - 21
	, ButtonPos:=YPos - 25
DetectHiddenWindows Off ; Detect hidden windows
SetTitleMatchMode 2
Gui 1: Font, w700 c000000
; Gui, 1: Add, Text, w%TitleWidth% h20 x35 y%TitlePos% Center gDrag, Scripts
Gui 1: Font, c000000
if Mod(Ind,2)
{
	TitlePos:=Titlepos - 25
		, ButtonPos:=ButtonPos - 25
		, YPos:=YPos-25
}
Gui 1: Add, Button, w20 h20 x5 y%ButtonPos% HwndButtonMHwnd gButtonM, &M
Gui 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonEHwnd gButtonE, &E
Gui 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonDHwnd gButtonD, &D
Gui 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonRHwnd gButtonR, &R
Gui 1: Add, Text, w40 h20 xp+20 y%TitlePos% gDrag HwndTitleHwnd, Scripts
global ActiveScripts:=CountIf(aEnableKillButton,true)
global TotalScripts:=aEnableKillButton.Count()
AddToolTip(TitleHwnd,"Total Scripts:" TotalScripts "`nActive:" ActiveScripts )

Gui 1: Add, Button, w20 h20 xp+40 y%ButtonPos% HwndButtonOHwnd gButtonO, &O
Gui 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonSHwnd gButtonS, &S
Gui 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonQHwnd gButtonQ, &?
Gui 1: Add, Button, w20 h20 x%XButtonXCoordOld% y%ButtonPos% HwndButtonXHwnd gButtonX, &X
TotalWidth:=XButtonXCoord2+15+2*5
if IniObj["Script Behaviour Settings"].bAddSuspendButtons
	Gui 1: Add, Button, w20 h20 x%XButtonXCoord2Old% y%ButtonPos% HwndButtonFHwnd gButtonF, &F
else
	TotalWidth:=TotalWidth-(XButtonXCoord2Old-XButtonXCoordOld) ;; remove width margin for suspend-row
Gui 1: +AlwaysOnTop -Caption +ToolWindow +Border
if WinActive("ahk_exe Code.exe")
	Gui 1: -AlwaysOnTop
if IniObj["Script Behaviour Settings"].bShowTooltips
{
	AddToolTip(ButtonMHwnd,"Minimise GUI")
		, AddToolTip(ButtonEHwnd,"Edit Launcher")
		, AddToolTip(ButtonDHwnd,"Open Launcher Directory")
		, AddToolTip(ButtonRHwnd,"Reload Launcher")
		, AddToolTip(ButtonSHwnd,"Swap Editors")
		, AddToolTip(ButtonOHwnd,"Open Settings-file")
		, AddToolTip(ButtonXHwnd,"Kill All Scripts")
		, AddToolTip(ButtonQHwnd,"About and docs")
		, AddToolTip(ButtonFHwnd,"Freeze/suspend all scripts")
}
BlockInput Off
EditorSwapper()
if WinActive("ahk_exe Code.exe")
	ttip(script.name " - Finished loading.",,1200)
return

fIsRunning(Path)
{
	DetectHiddenWindows On
	WinGet List, List, ahk_class AutoHotkey
	Loop % List
	{
		WinGetTitle title, % "ahk_id" List%A_Index%
		if Instr(title,Path)
			return true
	}
	return false
}

fSplitObjInHalf(Obj)
{
	Length:=Obj.Count()
		, Obj1:=[]
		, Obj2:=[]
	for k,v in Obj
	{
		if (k<=floor(Length/2))
			Obj1.push(v)
		else
			Obj2.push(v)
	}
	return [Obj1,Obj2]
}

!Sc029::			; show script menu
if WinActive("Main Window") {
	Gui 1: cancel
	Gui 2: cancel
} ;reload ;WinClose ;MsgBox, window active, lets minimise it
else
{

	ToggleActiveButtons(aPathArr,IniObj)
	fGuiShow(YPos,TotalWidth,ButtonPos,aFileNameArr)
}
return

#IfWinActive About AHK ScriptLauncher
Esc:: 
Gui 1: cancel
Gui 2: cancel
return
#if WinActive("ahk_id " hwndScriptLauncher)
^F::Search()
BackSpace::SearchEdit(aFileNameArr)
Drag()
{
	PostMessage 0xA1, 2,,, A
	return
}

CountIf(Object, Condition)
{
	out:=0
	for k,v in Object
	{
		if (v=Condition)
			out++
	}
	return out + 0
}
Search() {
	global
	gui 1: default

	aEnableKillButton:=GetProgRunMatrix2(aPathArr)
	;toggleScriptButtons(aFileNameArr,false,true)
	ActiveScripts:=CountIf(aEnableKillButton,true)
	gui 2: destroy
	lastlength:=0
	firstsearchrun:=true
	gui 2: new
	gui 2: +AlwaysOnTop -Caption +ToolWindow +Border
	onSearch:=Func("SearchEdit").Bind(aFileNameArr)
	gui 2: add, edit, hwndhwndSearchEdit vSearchTerm
	guicontrol +g, %hwndSearchEdit%, % onSearch

	gui 2: show, autosize Center

}
2GuiEscape() {
	global
	gui 2: destroy
	gui 1: default
	toggleScriptButtons(aFileNameArr,true)
}
toggleScriptButtons(aFileNameArr,OnorOff:=true,indeces:=1) {
	i:=idx:={}
	global vSearchTerm
	gui 1: default
	for each, name in aFileNameArr { ;; hide all
		i[name]:=0
		if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			HideBtnIndex:=A_Index*3+1
		Else
			HideBtnIndex:=A_Index*3-2
		idx[name]:=HideBtnIndex
		if IsObject(indeces) {
			HBIDX:=idx[name]
			guiControl % (indeces[each]?"show":"hide"), Button%HideBtnIndex%

		} else {
			guiControl % "show", Button%HideBtnIndex%

		}
	}
	if IsObject(indeces) {
		guiControl % indeces[each]?"show":"hide", Button1
	} else {
		guiControl % OnorOff?"show":"hide", Button1
	}
	return
}
SearchEdit(aFileNameArr) {
	global
	static lastLength
	if (lastLength="") {
		lastLength:=0
	}
	gui 2: submit, nohide
	enabledindeces:={}
	for each, filename in aFileNameArr {
		enabledindeces.push((InStr(filename,SearchTerm)?1:0))
	}
	toggleScriptButtons(aFileNameArr,true,enabledindeces)
	if (!firstsearchrun) {
		if (strLen(SearchTerm)-1<0) {
			2GuiEscape()
			return
		}
	}
	firstsearchrun:=false
	lastLength:=StrLen(SearchTerm)

}
Run()
{
	global ;; no clue how to properly functionalise this one here.
	Loop
	{
		if (A_GuiControl=aFileNameArr[A_Index])
		{
			path:=aPathArr_United[A_Index]
			if GetKeyState("LShift")
			{
				;; TODO: add auto-execute functionality
			}
			if GetKeystate("LAlt") && GetKeystate("LControl")
			{
				EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
				EnvGet LocalAppData, LOCALAPPDATA
				SplitPath path, , Dir
				; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
				fEditScript(Dir,LocalAppData,currentEditor)
				if IniObj["Script Behaviour Settings"].bHideOnEditScript {
					Gui 1: cancel
					Gui 2: cancel
				}
				return

			}
			else if GetKeystate("LAlt")
			{
				SplitPath Path,, sContainingFolder
				run % sContainingFolder
				if IniObj["Script Behaviour Settings"].bHideOnOpenFolder {
					Gui 1: cancel
					Gui 2: cancel
				}
				return
			}
			else IF GetKeystate("LControl") ; open script in currently set editor
			{
				EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
				EnvGet LocalAppData, LOCALAPPDATA
				; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
				fEditScript(path,LocalAppData,currentEditor)
				if IniObj["Script Behaviour Settings"].bHideOnEditScript {
					Gui 1: cancel
					Gui 2: cancel
				}
				return
				EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
				EnvGet LocalAppData, LOCALAPPDATA
				; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
				fEditScript(path,LocalAppData,currentEditor)
				if IniObj["Script Behaviour Settings"].bHideOnEditScript {
					Gui 1: cancel
					Gui 2: cancel
				}
				return
			}
			;; todo: autodetect script's ahk-version so that the launcher can run v1 and v2 scripts.
			SplitPath % Path,,, PathExt
			if (PathExt="exe") {
				run % Quote(Path),,,PID
			} else if (PathExt="py") {
				Run % ComSpec " /K python " Quote(Path),,,PID
			} else {
				if ScriptIsV2(Path)
					Run % A_ProgramFiles "\AutoHotkey\v2\AutoHotkey.exe"	 A_Space Quote(Path),,,PID
				else
					Run "%Path%",	,	,PID
			}
			aPIDarr[A_Index]:=PID
				, aPIDassarr[A_GuiControl]:=PID
				, ProcessRun:=A_Index
			GuiControlGet out, focus
			ProcessRun:=SubStr(out, 7, strLen(out)-6)
				, KillBtnNumber:=ProcessRun+1
				, SusBtnNumber:=ProcessRun+2
			guiControl enable, Button%KillBtnNumber%
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				guiControl enable, Button%SusBtnNumber%
			if IniObj["Script Behaviour Settings"].bHideOnLaunchScript {
				Gui 1: cancel
				Gui 2: cancel
			}
			ToggleActiveButtons(aPathArr,IniObj)
			break
		}
		else if InStr(A_GuiControl,"/INI-Files/" A_ScriptNameNoExt)
		{
			path:=aPathArr_United[A_Index]
			if FileExist(path)
			{
				MsgBox % "No Paths set to be read. Please first set a path to a specified file or folder in the respective section of the following settings file."
				run % Path
				if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened {
					Gui 1: cancel
					Gui 2: cancel
				}
				return
			}
		}
	}
	ToggleActiveButtons(aPathArr,IniObj)
	return
}
ScriptIsV2(path)
{
	FileRead FileString, % path
	;Res:=IdentifyBySyntax(FileString)
	RegExMatch(FileString, "i)\#Requires Autohotkey v*(?<Version>(\d|\.|\+)*)", v)

	return (SubStr(vVersion,1,1)=2?true:false)
}

get_identify_regex()
{
	FileRead needle, % A_ScriptDir "/AHK_Version_Regex.txt"
	return needle
}


IdentifyBySyntax(code)
{
	static identify_regex := quote(get_identify_regex())
	p := 1, count_1 := count_2 := 0, version := marks := ""
	while (p := RegExMatch(code, identify_regex, m, p)) {
		p += m.Len()
		if SubStr(m.mark,1,1) = "v" {
			switch SubStr(m.mark,2,1) {
				case "1": count_1++
				case "2": count_2++
			}
			if !InStr(marks, m.mark)
				marks .= m.mark " "
		}
	}
	if !(count_1 || count_2)
		return {v: 0, r: "no tell-tale matches"}
	; Use a simple, cautious approach for now: select a version only if there were
	; matches for exactly one version.
	if count_1 && count_2
	{
		out:={v: 0, r: Format(            count_1 > count_2 ? "v1 {1}:{2} - {3}" : count_2 > count_1 ? "v2 {2}:{1} - {3}" : "? {1}:{2} - {3}",            count_1, count_2, Trim(marks)        )}
		return out
	}
	out:={v: count_1 ? 1 : 2, r: Trim(marks)}
	return out
}











fUpdateSettings(PID)
{
	WinWait % "ahk_pid " PID
	WinWaitClose % "ahk_pid " PID
	reload
	return
}

GetProgRunMatrix2(aPathArr)
{
	DetectHiddenWindows On
	WinGet List, List, ahk_class AutoHotkey
	aEnableKillButton:=[]
		, aRunningPaths:=[]
	Loop % List
	{
		WinGetTitle title, % "ahk_id" List%A_Index%
		aRunningPaths.push(RegExReplace(title, " - AutoHotkey v[\.0-9]+$")) ; collect all running autohotkey windows, regardless of origin
	}
	if IsObject(aPathArr[1])
	{
		for s,w in aPathArr[1]
			aEnableKillButton.push(!!(HasVal(aRunningPaths,w))+0)
		for s,w in aPathArr[2]
			aEnableKillButton.push(!!(HasVal(aRunningPaths,w))+0)
	}
	else
	{
		for s,w in aPathArr
			aEnableKillButton.push(!!(HasVal(aRunningPaths,w))+0)
	}
	return aEnableKillButton
}

lSusScript()
{
	GuiControlGet out, focus
	ProcessRun:=SubStr(out, 7, strLen(out)-6)
	KillBtnNumber:=ProcessRun+1
	SusBtnNumber:=ProcessRun+2
	ProcessRun:=SubStr(out, 7, strLen(out)-6)
	SusBtnNumber:=ProcessRun
	GuiControlGet sFileNameKill,,% "Button" ProcessRun - 2

	GuiControlGet sStateCurrentScript,,Button%SusBtnNumber%

	DetectHiddenWindows On
	WinGetClass cClass, % sFileNameKill ".ahk"
	aAllowedToBeClosedClasses:=["AutoHotkey","AutoHotkeyGUI"] ; make sure we don't accidentally kill editors/IDEs
	if WinExist(sFileNameKill ".ahk") ;and HasVal(aAllowedToBeClosedClasses,cClass)
	{ ;A_GuiControl
		str:=sFileNameKill ".ahk - AutoHotkey"
		PostMessage 0x111, 65305,,, %str%   ; Suspend.
		if (sStateCurrentScript="S")
		{
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(SusBtn%Index% ,"Continue " sFileNameKill)
			guicontrol,,Button%SusBtnNumber%,C
		}
		else
		{
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(SusBtn%Index%,"Suspend " sFileNameKill )
			guicontrol,,Button%SusBtnNumber%,S
		}
		if IniObj["Script Behaviour Settings"].bHideOnKillScript {
			Gui 1: cancel
			Gui 2: cancel
		}
		fTray_Refresh() ; remove dead icons
	}
}
return


fKillScript() ;; TODO: actually rework this so I don't need the 'global' anymore.
{
	global
	Index:=strsplit(A_GuiControl,"on").2
	if IniObj["Script Behaviour Settings"].bAddSuspendButtons
		KillBtnNumber:=Index*3-1
	else
		KillBtnNumber:=Index*2-1
	sFileNameKill:=aFileNameArr[Index]
	if IsObject(aPathArr)
	{
		if (Index>aPathArr[1].Count())
			sPathToKill:=aPathArr[2,(Index-aPathArr[1].Count())]
		else
			sPathToKill:=aPathArr[1,Index]
	}
	else
		sPathToKill:=aPathArr[Index]
	DetectHiddenWindows On
	WinGetClass cClass, % sFileNameKill ".ahk"
	if WinExist(sFileNameKill ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
	{ ;A_GuiControl
		WinClose
		WinKill % "ahk_exe " WinExist(sPathToKill)
		if d:=WinExist(sFileNameKill ".ahk")
		{
			str:=sFileNameKill ".ahk - AutoHotkey"
			PostMessage 0x0112, 0xF060,,, %str%  ; 0x0112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
			str:=sPathToKill " - AutoHotkey"
			PostMessage 0x0112, 0xF060,,, %str%  ; 0x0112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
			Process close, % d
			loop,
			{
				if !WinExist(sFileNameKill ".ahk")
					break
				Process Close, % sFileNameKill (Instr(sFileNameKill,".ahk")?:".ahk")	;; Killing via "FileName" doesn't work for some reason.
				Process Close, % sFileNameKill											;; Killing via "FileName" doesn't work for some reason. || not sure if this is smart to leave out the .ahk. Could this kill editors?
				if WinExist(sFileNameKill ".ahk")
					Process Close, % aPIDarr[Index]
				if WinExist(sFileNameKill ".ahk")
				{
					WinGet PID, PID, % sFileNameKill ".ahk",,, - Visual Studio Code
					WinGet PIDs_Class,PID, % "ahk_pid " PID
					WinGet PIDs_exe, ProcessName, % "ahk_pid " PID
					if PIDs_exe!="AutoHotkey.exe"
						break
					WinGet PID, PID, % sFileNameKill ".ahk"
					Process Close, % PID
				}
			}
			until (A_Index>15)
		}
		if WinExist(sFileNameKill ".ahk") && IniObj["Script Behaviour Settings"].bReloadToKill
		{
			if ScriptIsV2(sPathToKill)
				Run % A_ProgramFiles "\AutoHotkey\v2\AutoHotkey.exe"	 A_Space Quote(sPathToKill),,,PIDa
			else
				Run Autohotkey.exe "%sPathToKill%",	,	,PIDa
			ttip(PIDa,,0)
			Process Close, % PIDa
		}

		if !IniObj["Script Behaviour Settings"].bAddSuspendButtons
			KillBtnNumber:=KillBtnNumber+1
		GuiControl Disable, Button%KillBtnNumber%
		if IniObj["Script Behaviour Settings"].bAddSuspendButtons
		{
			SusBtnNumber:=KillBtnNumber+1
			GuiControl Disable, Button%SusBtnNumber%
			GuiControl,, Button%SusBtnNumber%, S
		}
		if IniObj["Script Behaviour Settings"].bHideOnKillScript {
			Gui 1: cancel
			Gui 2: cancel
		}
		ToggleActiveButtons(aPathArr,IniObj)
		fTray_Refresh() ; remove dead icons
	}
	return
}

;----
;----
;----

ButtonM()
{
	Gui 1: cancel
	Gui 2: cancel
}
ButtonE()
{
	global
	EnvGet LocalAppData, LOCALAPPDATA
	fEditScript(A_ScriptFullPath,LocalAppData,currentEditor)
	return
}
ButtonD()
{
	run % A_ScriptDir
	Gui 1: cancel
	Gui 2: cancel
	return
}
ButtonR()
{
	reload
	return
}

;----
;----


ButtonO()
{
	Run % A_ScriptDir "/INI-Files/" script.name ".ini",,,RunPID
	if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened {
		Gui 1: cancel
		Gui 2: cancel
	}
	; sleep, 700
	fUpdateSettings(RunPID)
}
return
ButtonS()
{
	Gui 1: cancel
	Gui 2: cancel
	fShowGuiSwapper()
}
return
ButtonQ()
{
	Gui 1: cancel
	Gui 2: cancel
	script.about()
}
return
ButtonX()
{
	global
	; Gui, 1: hide ;ExitApp
	if bKillTrueRestoreFalse
	{
		for k,v in aFileNameArr
		{
			DetectHiddenWindows On
			WinGetClass cClass, % v ".ahk"
			if WinExist(v ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
			{
				WinClose
				if WinExist(v ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
				{
					Process Close, % v (Instr(v,".ahk")?:".ahk")	;; Killing via "FileName" doesn't work for some reason.
					Process Close, % v											;; Killing via "FileName" doesn't work for some reason. || not sure if this is smart to leave out the .ahk. Could this kill editors?
					if WinExist(v ".ahk")
						Process Close, % aPIDarr[A_Index]

				}
				if !HasVal(aButtonXClosedScripts,v)
					aButtonXClosedScripts.push(v)
			}
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			{
				KillBtnNumber:=k*3-1
				SusBtnNumber:=k*3
				GuiControl disable, Button%KillBtnNumber%
				GuiControl disable, Button%SusBtnNumber%
				GuiControl,, Button%SusBtnNumber%, S
			}
			else
				KillBtnNumber:=k*2
			GuiControl disable, Button%KillBtnNumber%

			DetectHiddenWindows Off
		}
		bKillTrueRestoreFalse:=false
	}
	else if (2<1)
	{
		for k,v in aButtonXClosedScripts
		{
			for s,w in aFileNameArr
			{
				if (v==w)
				{
					Path:=aPathArr[s]
					Run Autohotkey.exe "%Path%",	,	,PID
					aPIDarr[A_Index]:=PID
					aPIDassarr[v]:=PID
					ProcessRun:=A_Index								;; get the current pid'
					KillBtnNumber:=ProcessRun*3-1
					guiControl enable, Button%KillBtnNumber%
					if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					{
						SusBtnNumber:=KillBtnNumber+1
						guiControl enable, Button%SusBtnNumber%
					}
					if IniObj["Script Behaviour Settings"].bHideOnLaunchScript {
						Gui 1: cancel
						Gui 2: cancel
					}
					if HasVal(aButtonXClosedScripts,v)
						aButtonXClosedScripts.Remove(HasVal(aButtonXClosedScripts,v))
				}

			}
		}
		bKillTrueRestoreFalse:=true
	}
	ToggleActiveButtons(aPathArr,IniObj)
	fTray_Refresh()
	return
}

/* 		;; WOrking on detecting suspension state
ButtonF:
{
for k,v in aFileNameArr
{
DetectHiddenWindows, On
if WinExist(v ".ahk") ;and HasVal(aAllowedToBeClosedClasses,cClass)
{
str:=v ".ahk - AutoHotkey"
PostMessage, 0x111, 65305,,, %str%   ; Suspend.
WinGetTitle, cT, % str
}
DetectHiddenWindows, Off
}
if IniObj["Script Behaviour Settings"].bHideOnKillScript
Gui, 1: hide
fTray_Refresh() ; remove dead icons
}
return
*/
ButtonF()
{
	global
	for k,v in aFileNameArr
	{
		DetectHiddenWindows On
		if WinExist(v ".ahk")
		{
			str:=v ".ahk - AutoHotkey"
			PostMessage 0x111, 65305,,, %str%   ; Suspend.
		}
		DetectHiddenWindows Off
	}
	return
}

;----
;----
;----

GuiEscape()
{
	Gui 1: Cancel
	gui 2: cancel
	return
}

ToggleActiveButtons(aPathArr,IniObj)
{
	global
	aEnableKillButton:=GetProgRunMatrix2(aPathArr)
	ActiveScripts:=CountIf(aEnableKillButton,true)
	;ttip(["Total Scripts:" aEnableKillButton.Count() "`nActive:" ActiveScripts,A_ThisFunc])
	AddToolTip(TitleHwnd,"",false)
	AddToolTip(TitleHwnd,"Test")
	AddToolTip(TitleHwnd,"Total Scripts:" aEnableKillButton.Count() "`nActive:" ActiveScripts)
	for k,v in aEnableKillButton		;; logical array
	{
		if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			KillBtnNumber:=A_Index*3-1
		Else
			KillBtnNumber:=A_Index*2
		if v			;; check for true's in logical array "aEnableKillButton"
		{
			guicontrol enable, Button%KillBtnNumber%
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			{
				SusBtnNumber:=KillBtnNumber+1
				guicontrol enable, Button%SusBtnNumber%
			}
		}
		else
		{
			guicontrol disable, Button%KillBtnNumber%
			SusBtnNumber:=KillBtnNumber+1
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				guicontrol disable, Button%SusBtnNumber%
		}
	}
}
return

fGuiShow(YPos,Width,ButtonPos,aFileNameArr)
{
	CurrentMOnitor:=MWAGetMonitor()+0
	SysGet MonCount, MonitorCount
	if (MonCount>1)
	{
		SysGet Mon, Monitor,% CurrentMonitor
		SysGet MonW,MonitorWorkArea, % CurrentMonitor
	}
	else
	{
		SysGet Mon, Monitor, 1
		SysGet MonW,MonitorWorkArea, 1
	}
	MonWidth:=(MonLeft?MonLeft:MonRight)
	MonWidth:=MonRight-MonLeft
	if SubStr(MonWidth, 1,1)="-"
		MonWidth:=SubStr(MonWidth,2)
	CoordModeMouse:=A_CoordModeMouse
	CoordMode Mouse,Screen
	MouseGetPos MouseX,MouseY
	CoordMode Mouse, %CoordModeMouse%
	; ButtonPos:=ButtonPos+25
	if ((MouseY+ButtonPos)>MonWBottom)
	{
		if ((MouseY-ButtonPos)<MonWTop)
			PositionYGui:=0
		Else
			PositionYGui:=MonWBottom-YPos
	}
	else
		PositionYGui:=MouseY

	if ((MouseX+Width)>MonRight)
		PositionXGui:=MonRight-Width
	Else
		PositionXGui:=MouseX
	if (Width<TotalWidth)
		Width:=TotalWidth
	; if (PositionYGui<0) ;; list is longer than screen is high
	toggleScriptButtons(aFileNameArr,true,1)
	Gui 1: Show, w%Width% h%YPos% x%PositionXGui% y%PositionYGui% Hide, Main Window
	guicontrol focus, Button%ButtonM_Ind%
	Settimer lCheckButtons,100
	WinGetPos X, Y, Width, Height, Main Window
	Gui 1: Show,, Main Window
}



lCheckButtons()
{
	if !WinExist("Main Window") ;; window not visible anymore, so stop the timer
		Settimer lCheckButtons, off
	return
}








fEditScript(ScriptPath,LocalAppData,cEDT)
{
	;ProgramPath:= LocalAppData "\Programs\Microsoft VS Code\Code.exe" ;; original one.
	ProgramPath2:=strsplit(cEDT,".exe").1 ".exe"
	;ProgramPath2:="D:\Downloads\Installationen\VSC Testing\VSCode Portable\Code.exe"
	Run % ProgramPath2 A_Space Quote(ScriptPath),,UseErrorLevel,pid

	; Run "code " "D:\Dokumente neu\Repositories\AHK\BSM" ""
	if ErrorLevel && FileExist(ProgramPath2) ;; fallback on
	{
		ttip("fallback")
		Run "code " quote(ScriptPath)
		; Run % ProgramPath A_Space Quote(ScriptPath)
	}
	return
}


fLoadSettings(sExcludes)
{
	IniObj:=fReadIni(sExcludes) ; just used to get the settings. The rest of the INI-file is not conforming to this function, and is also not supposed to do so because it only has to store filepaths.
	FileRead Text, %sExcludes%
	if Instr(Text,"[Insert Script-Names of Scripts in added Folders to Exclude below]`r`n")
	{
		IncludedFolders:=strsplit(Text,"[Insert Script-Names of Scripts in added Folders to Exclude below]`r`n").1
		ExcludedScripts:=strsplit(Text,"[Insert Script-Names of Scripts in added Folders to Exclude below]`r`n").2
		ExcludedScripts:=StrSplit(ExcludedScripts,"[Insert Paths to Scripts to INCLUDE below]").1
		IncludedScripts:=strsplit(Text,"[Insert Paths to Scripts to INCLUDE below]`r`n").2
		IncludedScripts:=StrSplit(IncludedScripts,"[Script Behaviour Settings]").1
	}
	IncludedScripts:=StrSplit(IncludedScripts,"`r`n")
	ExcludedScripts:=StrSplit(ExcludedScripts,"`r`n")
	IncludedFolders:=SubStr(IncludedFolders,36)
	IncludedFolders:=strsplit(IncludedFolders,"`r`n")
	return [IncludedFolders,IncludedScripts,ExcludedScripts,IniObj]
}




f_SortArrays(aPathArr,aFileNameArr)
{ ; thank you to u/astrosofista on the ahk-subreddit  https://www.reddit.com/r/AutoHotkey/comments/qx0nho/comment/hl6ig7a/?utm_source=share&utm_medium=web2x&context=3
	global
	assocNum:={}
	arrPathsSorted:=[]
	for k,v in aFileNameArr
		assocNum[v]:=k
	aFileNameArr:=[]
	for k,v in assocNum
	{
		Position:=assocNum[k]
		aFileNameArr.push(k)
		arrPathsSorted.push(aPathArr[Position])
	}
	aPathArr:=arrPathsSorted
	return [aPathArr,aFileNameArr]
}

f_CreateFileNameAndPathArrays(IncludedFolders,IncludedScripts,ExcludedScripts)
{
	aFolderPaths:=[]
		, aPathArr:=[]
		, aFileNameArr:=[]
	for k,v in IncludedFolders
		if (v!="")
			aFolderPaths.push(v)
	A_IndexCount:=0
	for k,v in aFolderPaths
	{
		loop, %v%\*.ahk, R
		{ ; A_LoopFileName
			; check:=(A_LoopFileName   (Instr(A_LoopFileName,".ahk"?:".ahk")))
			if (A_LoopFileName <> A_ScriptName) && !HasVal(ExcludedScripts, A_LoopFileName) && !HasVal(ExcludedScripts, strsplit(A_LoopFileName,".").1)
			{
				A_IndexCount++
				YPos:=A_IndexCount * 25 - 20
				StringTrimRight FileName%A_IndexCount%, A_LoopFileName, 4
				aPathArr.push(A_LoopFileFullPath)
				aFileNameArr.push(StrSplit(A_LoopFileName,".").1)
			}
			else
				continue
		}
	}
	for k,v in IncludedScripts
	{
		SplitPath v ,fName, IncludedScriptsDirectory,,fNameNoExt
		;SplitPath, InputVar [, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive]
		loop, %IncludedScriptsDirectory%\*.ahk, R
		{
			if (A_LoopFileName <> A_ScriptName) && !HasVal(ExcludedScripts, A_LoopFileName) && (HasVal(IncludedScripts,A_LoopFileFullPath) || HasVal(IncludedScripts,A_LoopFileName) )
			{
				; A_LoopFileFullPath
				; A_IndexCount:=A_Index
				A_IndexCount++
				; If A_IndexCountMinus
				; 	A_IndexCount -= A_IndexCountMinus
				YPos:=A_IndexCount * 25 - 20
				; StringTrimRight, FileName%A_IndexCount%, A_LoopFileName, 4
				aPathArr.push(A_LoopFileFullPath)
				aFileNameArr.push(StrSplit(A_LoopFileName,".").1)
			}
			else
				continue
		}
		loop, %IncludedScriptsDirectory%\*.exe, R
		{
			if (A_LoopFileName <> A_ScriptName) && !HasVal(ExcludedScripts, A_LoopFileName) && (HasVal(IncludedScripts,A_LoopFileFullPath) || HasVal(IncludedScripts,A_LoopFileName) )
			{
				; A_LoopFileFullPath
				; A_IndexCount:=A_Index
				A_IndexCount++
				; If A_IndexCountMinus
				; 	A_IndexCount -= A_IndexCountMinus
				YPos:=A_IndexCount * 25 - 20
				; StringTrimRight, FileName%A_IndexCount%, A_LoopFileName, 4
				aPathArr.push(A_LoopFileFullPath)
				aFileNameArr.push(StrSplit(A_LoopFileName,".").1 . " *")
			}
			else
				continue
		}
		loop, %IncludedScriptsDirectory%\*.py, R
		{
			if (A_LoopFileName <> A_ScriptName) && !HasVal(ExcludedScripts, A_LoopFileName) && (HasVal(IncludedScripts,A_LoopFileFullPath) || HasVal(IncludedScripts,A_LoopFileName) )
			{
				; A_LoopFileFullPath
				; A_IndexCount:=A_Index
				A_IndexCount++
				; If A_IndexCountMinus
				; 	A_IndexCount -= A_IndexCountMinus
				YPos:=A_IndexCount * 25 - 20
				; StringTrimRight, FileName%A_IndexCount%, A_LoopFileName, 4
				aPathArr.push(A_LoopFileFullPath)
				aFileNameArr.push(StrSplit(A_LoopFileName,".").1 . ".py *")
			}
			else
				continue
		}
	}
	if aPathArr.MaxIndex()="" ; fallback if no folders are set up.
	{
		; msgbox, % "No folders added"
		SplitPath A_ScriptName,,,,A_ScriptNameNoExt
		aPathArr:=[A_ScriptDir "/INI-Files/" A_ScriptNameNoExt ".ini"]
		aFileNameArr:=["Add files and folders to include"]

	}
	return [aPathArr,aFileNameArr]
}


;________________________________
;________________________________
;________________________________
; Original Scriptlauncher-Script by AfterLemon below, Source:
; http://www.autohotkey.com/board/topic/93997-list-all-ahk-scripts-in-directory-in-Gui/
;________________________________
;________________________________
;________________________________
#Include <script>
#Include <IsDebug>
#Include <ttip>
#Include <editswap>
#Include <AddToolTip>
#Include <HasVal>
#Include <MWAGetMonitor>
#Include <Quote>
#Include <fReadIni>
#Include <fTray_Refresh>
