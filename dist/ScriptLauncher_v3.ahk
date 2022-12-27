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
#Requires AutoHotkey v1.1.33+
#NoEnv
#Persistent
#SingleInstance				, Force
#InstallKeybdHook
#KeyHistory 				, 1
#MaxThreads					, 250
#MaxThreadsBuffer			, On
#MaxHotkeysPerInterval 		, 99000000
#HotkeyInterval 			, 99000000
AutoTrim                    , On
DetectHiddenWindows			, Off
FileEncoding                , UTF-8
ListLines 					, Off
CoordMode                 	, Mouse, Screen
CoordMode                 	, Pixel, Screen
CoordMode                 	, ToolTip, Screen
CoordMode                 	, Caret, Screen
CoordMode                 	, Menu, Screen
SendMode                   	, Input
SetTitleMatchMode     		, 2
SetTitleMatchMode     		, Fast
SetWorkingDir				, % A_ScriptDir
SetKeyDelay                	, -1, -1
SetBatchLines           	, -1
SetWinDelay                	, -1
SetControlDelay          	, -1
	;#UseHook
#Warn All, OutputDebug
#NoTrayIcon
; from RaptorX https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk
/**
 * ============================================================================ *
 * @Author           : RaptorX <graptorx@gmail.com>
 * @Script Name      : Script Object
 * @Script Version   : 0.27.3
 * @Homepage         :
 *
 * @Creation Date    : November 09, 2020
 * @Modification Date: November 16, 2022
 * @Modification G.S.: 08.2022
 ; @Description Modification G.S.:
    - Load()-method always returns false if File
	  passed to parameter "INI_File" does not exist
    - Load()-method always returns -1 if File
	  passed to parameter "INI_File" does not contain
	  any values
	- Load()-method can be set up to not warn in
	  case of a missing ini-file.
	- added field for GitHub-link, a Forum-link 
	  and a credits-field, as well as a template 
	  to quickly copy out into new scripts
	  Contains methods for saving and loading 
	  config-files containing an array - 
	  basically an integration of Wolf_II's
	  WriteIni/ReadIni with some adjustments
	  added Update()-functionality for non-zipped
	  remote files so that one can update a 
	  A_ScriptFullPath-contained script from 
	  f.e. GH.
	- Reworked the Update()-Method with help of 
	  u/anonymous1184.
	- Added filter to not engange Update-method 
	  if vfile contains the words "REPOSITORY_NAME" 
	  or "BRANCH_NAME", indicating a template has
	  not been adjusted yet - or is not intended to
	- added autoformatting for ingesting credits via
	  the "CreditsRaw"-continuation-section in the 
	  template below
								
 * 
 * @Description      :
 * -------------------
 * This is an object used to have a few common functions between scripts
 * Those are functions and variables related to basic script information,
 * upgrade and configuration.
 *
 * ============================================================================ *
 */
; scriptName   (opt) - Name of the script which will be
; 		                     shown as the title of the window and the main header
; 		version      (opt) - Script Version in SimVer format, a "v"
; 		                     will be added automatically to this value
; 		author       (opt) - Name of the author of the script
; 		credits 	 (opt) - Name of credited people
; 		creditslink  (opt) - Link to credited file, if any
; 		crtdate		 (opt) - Date of creation
; 		moddate		 (opt) - Date of modification
; 		homepagetext (opt) - Display text for the script website
; 		homepagelink (opt) - Href link to that points to the scripts
; 		                     website (for pretty links and utm campaing codes)
; 		ghlink 		 (opt) - GitHubLink
; 		ghtext 		 (opt) - GitHubtext
; 		forumlink    (opt) - forumlink to the scripts forum page
; 		forumtext    (opt) - forumtext 
; 		donateLink   (opt) - Link to a donation site
; 		email        (opt) - Developer email

; /Template_Start
/*
for creditsRaw, use "/" in the "URL"-field when the snippet is not published yet (e.g. for code you've written yourself and not published yet)
space author, SnippetNameX and URLX out by spaces or tabs, and remember to include "-" inbetween both fields
when 2+ snippets are located at the same url, concatenate them with "|" and treat them as a single one when putting together the URL's descriptor string
finally, make sure toingest 'CreditsRaw' into the 'credits'-field of the template below.
*/
; CreditsRaw=
; (LTRIM
; author1   -		 snippetName1		   		  			-	URL1
; author2,author3   -		 snippetName1		   		  			-	URL2,URL3
; ScriptObj  							- Gewerd S, original by RaptorX							    - https://github.com/Gewerd-Strauss/ScriptObj/blob/master/ScriptObj.ahk, https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk
; )
; FileGetTime, ModDate,%A_ScriptFullPath%,M
; FileGetTime, CrtDate,%A_ScriptFullPath%,C
; CrtDate:=SubStr(CrtDate,7,  2) "." SubStr(CrtDate,5,2) "." SubStr(CrtDate,1,4)
; ModDate:=SubStr(ModDate,7,  2) "." SubStr(ModDate,5,2) "." SubStr(ModDate,1,4)
; global script := {   base         : script
;                     ,name         : regexreplace(A_ScriptName, "\.\w+")
;                     ,version      : FileOpen(A_ScriptDir "\version.ini","r").Read()
;                     ,author       : "Gewerd Strauss"
; 					,authorID	  : "Laptop-C"
; 					,authorlink   : ""
;                     ,email        : ""
;                     ,credits      : CreditsRaw
; 					,creditslink  : ""
;                     ,crtdate      : CrtDate
;                     ,moddate      : ModDate
;                     ,homepagetext : ""
;                     ,homepagelink : ""
;                     ,ghtext 	  : "GH-Repo"
;                     ,ghlink       : "https://github.com/Gewerd-Strauss/REPOSITORY_NAME"
;                     ,doctext	  : ""
;                     ,doclink	  : ""
;                     ,forumtext	  : ""
;                     ,forumlink	  : ""
;                     ,donateLink	  : ""
;                     ,resfolder    : A_ScriptDir "\res"
;                     ,iconfile	  : ""
;					  ,reqInternet: false
; 					,rfile  	  : "https://github.com/Gewerd-Strauss/REPOSITORY_NAME/archive/refs/heads/BRANCH_NAME.zip"
; 					,vfile_raw	  : "https://raw.githubusercontent.com/Gewerd-Strauss/REPOSITORY_NAME/BRANCH_NAME/version.ini" 
; 					,vfile 		  : "https://raw.githubusercontent.com/Gewerd-Strauss/REPOSITORY_NAME/BRANCH_NAME/version.ini" 
; 					,vfile_local  : A_ScriptDir "\version.ini" 
;					,DataFolder:	A_ScriptDir ""
;                     ,config:		[]
; 					,configfile   : A_ScriptDir "\INI-Files\" regexreplace(A_ScriptName, "\.\w+") ".ini"
;                     ,configfolder : A_ScriptDir "\INI-Files"}
/*	
	; For throwing errors via script.debug
	script.Error:={	 Level		:""
					,Label		:""
					,Message	:""	
					,Error		:""		
					,Vars:		:[]
					,AddInfo:	:""}
	if script.error
		script.Debug(script.error.Level,script.error.Label,script.error.Message,script.error.AddInfo,script.error.Vars)
*/
; script.Load()
; , script.Update(,,,,,)  ;; DO NOT ACTIVATE THISLINE UNTIL YOU DUMBO HAS FIXED THE DAMN METHOD. God damn it.
; /Template_End
class script
{
	static DBG_NONE     := 0
	      ,DBG_ERRORS   := 1
	      ,DBG_WARNINGS := 2
	      ,DBG_VERBOSE  := 3

	static name       := ""
        ,version      := ""
        ,author       := ""
		,authorID	  := ""
        ,authorlink   := ""
        ,email        := ""
        ,credits      := ""
        ,creditslink  := ""°
        ,crtdate      := ""
        ,moddate      := ""
        ,homepagetext := ""
        ,homepagelink := ""
        ,ghtext 	  := ""
        ,ghlink       := ""
        ,doctext	  := ""
        ,doclink	  := ""
        ,forumtext	  := ""
        ,forumlink	  := ""
        ,donateLink   := ""
        ,resfolder    := ""
        ,iconfile     := ""
		,vfile_local  := ""
		,vfile_remote := ""
        ,config       := ""
        ,configfile   := ""
        ,configfolder := ""
		,icon         := ""
		,systemID     := ""
		,dbgFile      := ""
		,rfile		  := ""
		,vfile		  := ""
		,dbgLevel     := this.DBG_NONE
		,versionScObj := "0.21.3"

	SetIcon(Param:=true)
	{

			/**
			Function: SetIcon
			TO BE DONE: Sets iconfile as tray-icon if applicable

			Parameters:
			Option - Option to execute
					Set 'true' to set this.res "\" this.iconfile as icon
					Set 'false' to hide tray-icon
					Set '-1' to set icon back to ahk's default icon
					Set 'pathToIconFile' to specify an icon from a specific path
					Set 'dll,iconNumber' to use the icon extracted from the given dll - NOT IMPLEMENTED YET.
			
			Examples:
			; 
			; script.SetIcon(0) 									;; hides icon
			; ttip("custom from script.iconfile",5)
			script.SetIcon(1)										;; custom from script.iconfile
			; ttip("reset ahk's default",5)
			; script.SetIcon(-1)									;; ahk's default icon
			; ttip("set from path",5)
			; script.SetIcon(PathToSpecificIcon)					;; sets icon specified by path as icon

			e.g. '1.0.0'

			For more information about SemVer and its specs click here: <https://semver.org/>
		*/
		if (Param=true)
		{ ;; set script.iconfile as icon, shows icon
			Menu, Tray, Icon,% this.resfolder "\" this.iconfile ;; this does not work for unknown reasons
			menu, tray, Icon
			; menu, tray, icon, hide
			;; menu, taskbar, icon, % this.resfolder "/" this.iconfilea
		}
		else if (Param=false)
		{ ;; set icon to default ahk icon, shows icon

			; ttip_ScriptObj("Figure out how to hide autohotkey's icon mid-run")
			menu, tray, NoIcon
		}
		else if (Param=-1)
		{ ;; hide icon
			Menu, Tray, Icon, *

		}
		else ;; Param=path to custom icon, not set up as script.iconfile
		{ ;; set "Param" as path to iconfile
			;; check out GetWindowIcon & SetWindowIcon in AHK_Library
			if !FileExist(Param)
			{
				try
					throw exception("Invalid  Icon-Path '" Param "'. Check the path provided.","script.SetIcon()","T")
				Catch, e
					msgbox, 8240,% this.Name " > scriptObj -  Invalid ressource-path", % e.Message "`n`nPlease provide a valid path to an existing file. Resuming normal operation."
			}
				
			Menu, Tray, Icon,% Param
			menu, tray, Icon
		}
		return
	}


	Update(vfile:="", rfile:="",bSilentCheck:=false,Backup:=true,DataOnly:=false)
	{
			/**
				Function: Update
				Checks for the current script version
				Downloads the remote version information
				Compares and automatically downloads the new script file and reloads the script.

				Parameters:
				vfile - Version File
						Remote version file to be validated against.
				rfile - Remote File
						Script file to be downloaded and installed if a new version is found.
						Should be a zip file that w°ll be unzipped by the function

				Notes:
				The versioning file should only contain a version string and nothing else.
				The matching will be performed against a SemVer format and only the three
				major components will be taken into account.

				e.g. '1.0.0'

				For more information about SemVer and its specs click here: <https://semver.org/>
			*/
		; Error Codes
		static ERR_INVALIDVFILE := 1
			,ERR_INVALIDRFILE       := 2
			,ERR_NOCONNECT          := 3
			,ERR_NORESPONSE         := 4
			,ERR_INVALIDVER         := 5
			,ERR_CURRENTVER         := 6
			,ERR_MSGTIMEOUT         := 7
			,ERR_USRCANCEL          := 8
		vfile:=(vfile=="")?this.vfile:vfile
		,rfile:=(rfile=="")?this.rfile:rfile
		if RegexMatch(vfile,"\d+") || RegexMatch(rfile,"\d+")	 ;; allow skipping of the routine by simply returning here
			return
		; Error Codes
		if (vfile="") 											;; disregard empty vfiles
			return
		if (!regexmatch(vfile, "^((?:http(?:s)?|ftp):\/\/)?((?:[a-z0-9_\-]+\.)+.*$)"))
			exception({code: ERR_INVALIDVFILE, msg: "Invalid URL`n`nThe version file parameter must point to a 	valid URL."})
		if  (regexmatch(vfile, "(REPOSITORY_NAME|BRANCH_NAME)"))
			Return												;; let's not throw an error when this happens because fixing it is irrelevant to development in 95% of all cases

		; This function expects a ZIP file
		if (!regexmatch(rfile, "\.zip"))
			exception({code: ERR_INVALIDRFILE, msg: "Invalid Zip`n`nThe remote file parameter must point to a zip file."})

		; Check if we are connected to the internet
		http := comobjcreate("WinHttp.WinHttpRequest.5.1")
		, http.Open("GET", "https://www.google.com", true)
		, http.Send()
		try
			http.WaitForResponse(1)
		catch e
		{
			bScriptObj_IsConnected:=ScriptObj_IsConnected()
			if !bScriptObj_IsConnected && !this.reqInternet && (this.reqInternet!="") ;; if internet not required - just abort update checl
			{ ;; TODO: replace with msgbox-query asking to start script or not - 
				ttip_ScriptObj(script.name ": No internet connection established - aborting update check. Continuing Script Execution",,,,,,,,18)
				return
			}
			if !bScriptObj_IsConnected && this.reqInternet ;; if internet is required - abort script
			{
					gui, +OwnDialogs
					OnMessage(0x44, "OnMsgBoxScriptObj")
					MsgBox 0x11,% this.name " - No internet connection",% "No internet connection could be established. `n`nAs " this.name " requires an active internet connection`, the program will shut down now.`n`n`n`nExiting."
					OnMessage(0x44, "")

					IfMsgBox OK, {
						ExitApp
					} Else IfMsgBox Cancel, {
						reload
					}
					
			}

				
		}
			; throw {code: ERR_NOCONNECT, msg: e.message} ;; TODO: detect if offline
		if (!bSilentCheck)
				Progress, 50, 50/100, % "Checking for updates", % "Updating"

		; Download remote version file
		http.Open("GET", vfile, true)
		http.Send()
		try
			http.WaitForResponse(1)
		catch
		{

		}

		if !(http.responseText)
		{
			Progress, OFF
			try
				throw exception("There was an error trying to download the ZIP file for the update.`n","script.Update()","The server did not respond.")
			Catch, e 
				msgbox, 8240,% this.Name " > scriptObj -  No response from server", % e.Message "`n`nCheck again later`, or contact the author/provider. Script will resume normal operation."
		}
		regexmatch(this.version, "\d+\.\d+\.\d+", loVersion)		;; as this.version is not updated automatically, instead read the local version file
		
		; FileRead, loVersion,% A_ScriptDir "\version.ini"
		d:=http.responseText
		regexmatch(http.responseText, "\d+\.\d+\.\d+", remVersion)
		if (!bSilentCheck)
		{
			Progress, 100, 100/100, % "Checking for updates", % "Updating"
			sleep 500 	; allow progress to update
		}
		Progress, OFF

		; Make sure SemVer is used
		if (!loVersion || !remVersion)
		{
			try
				throw exception("Invalid version.`n The update-routine of this script works with SemVer.","script.Update()","For more information refer to the documentation in the file`n" )
			catch, e 
				msgbox, 8240,% " > scriptObj - Invalid Version", % e.What ":" e.Message "`n`n" e.Extra "'" e.File "'."
		}
		; Compare against current stated version
		ver1 := strsplit(loVersion, ".")
		, ver2 := strsplit(remVersion, ".")
		, bRemoteIsGreater:=[0,0,0]
		, newversion:=false
		for i1,num1 in ver1
		{
			for i2,num2 in ver2
			{
				if (i1 == i2)
				{
					if (num2 > num1)
					{
						bRemoteIsGreater[i1]:=true
						break
					}
					else if (num2 = num1)
						bRemoteIsGreater[i1]:=false
					else if (num2 < num1)
						bRemoteIsGreater[i1]:=-1
				}
			}
		}
		if (!bRemoteIsGreater[1] && !bRemoteIsGreater[2]) ;; denotes in which position (remVersion>loVersion) → 1, (remVersion=loVersion) → 0, (remVersion<loVersion) → -1 
			if (bRemoteIsGreater[3] && bRemoteIsGreater[3]!=-1)
				newversion:=true
		if (bRemoteIsGreater[1] || bRemoteIsGreater[2])
			newversion:=true
		if (bRemoteIsGreater[1]=-1)
			newversion:=false
		if (bRemoteIsGreater[2]=-1) && (bRemoteIsGreater[1]!=1)
			newversion:=false
		if (!newversion)
		{
			if (!bSilentCheck)
				msgbox, 8256, No new version available, You are using the latest version.`n`nScript will continue running.
			return
		}
		else
		{
			; If new version ask user what to do				"C:\Users\CLAUDI~1\AppData\Local\Temp\AHK_LibraryGUI
			; Yes/No | Icon Question | System Modal
			msgbox % 0x4 + 0x20 + 0x1000
				, % "New Update Available"
				, % "There is a new update available for this application.`n"
				. "Do you wish to upgrade to v" remVersion "?"
				, 10	; timeout

			ifmsgbox timeout
			{
				try
					throw exception("The message box timed out.","script.Update()","Script will not be updated.")
				Catch, e
					msgbox, 4144,% this.Name " - " "New Update Available" ,   % e.Message "`nNo user-input received.`n`n" e.Extra "`nResuming normal operation now.`n"
				return
			}
			ifmsgbox no
			{		;; decide if you want to have this or not. 
				; try
				; 	throw exception("The user pressed the cancel button.","script.Update()","Script will not be updated.") ;{code: ERR_USRCANCEL, msg: "The user pressed the cancel button."}
				; catch, e
				; 	msgbox, 4144,% this.Name " - " "New Update Available" ,   % e.Message "`n`n" e.Extra "`nResuming normal operation now.`n"
				return
			}

			; Create temporal dirs
			ghubname := (InStr(rfile, "github") ? regexreplace(a_scriptname, "\..*$") "-latest\" : "")
			filecreatedir % Update_Temp := a_temp "\" regexreplace(a_scriptname, "\..*$")
			filecreatedir % zipDir := Update_Temp "\uzip"

			; ; Create lock file
			; fileappend % a_now, % lockFile := Update_Temp "\lock"

			; Download zip file
			urldownloadtofile % rfile, % file:=Update_Temp "\temp.zip"

			; Extract zip file to temporal folder
			shell := ComObjCreate("Shell.Application")

			; Make backup of current folder
			if !Instr(FileExist(Backup_Temp:= A_Temp "\Backup " regexreplace(a_scriptname, "\..*$") " - " StrReplace(loVersion,".","_")),"D")
				FileCreateDir, % Backup_Temp
			else
			{
				FileDelete, % Backup_Temp
				FileCreateDir, % Backup_Temp
			}
			; Gui +OwnDialogs
			MsgBox 0x34,% this.Name " - " "New Update Available", % "Last Chance to abort Update.`n`nDo you want to continue the Update?"
			IfMsgBox Yes 
			{
				Err:=CopyFolderAndContainingFiles(A_ScriptDir, Backup_Temp,1) 		;; backup current folder with all containing files to the backup pos. 
				, Err2:=CopyFolderAndContainingFiles(Backup_Temp ,A_ScriptDir,0) 	;; and then copy over the backup into the script folder as well
				, items1 := shell.Namespace(file).Items								;; and copy over any files not contained in a subfolder
				for item_ in items1 
				{

					if DataOnly ;; figure out how to detect and skip files based on directory, so that one can skip updating script and settings and so on, and only query the scripts' data-files 
					{
						
					}
					root := item_.Path
					, items:=shell.Namespace(root).Items
					for item in items
						shell.NameSpace(A_ScriptDir).CopyHere(item, 0x14)
				}
				MsgBox, 0x40040,,Update Finished
				FileRemoveDir, % Backup_Temp,1
				FileRemoveDir, % Update_Temp,1
				reload
			}
			Else IfMsgBox No
			{	; no update, cleanup the previously downloaded files from the tmp
				MsgBox, 0x40040,,Update Aborted
				FileRemoveDir, % Backup_Temp,1
				FileRemoveDir, % Update_Temp,1

			}
			if (err1 || err2)
			{
				;; todo: catch error
			}
		}
		
	}

	
	Autostart(status,UseRegistry:=0)
	{
		/**
		Function: Autostart
		This Adds the current script to the autorun section for the current
		user.

		Parameters:
		status - Autostart status
		         It can be either true or false.
		         Setting it to true would add the registry value.
		         Setting it to false would delete an existing registry value.
		*/
		if (UseRegistry)
		{
			if (status)
			{
				RegWrite, REG_SZ
						, HKCU\SOFTWARE\microsoft\windows\currentversion\run
						, %a_scriptname%
						, %a_scriptfullpath%
			}
			else
				regdelete, HKCU\SOFTWARE\microsoft\windows\currentversion\run
						, %a_scriptname%
		}
		else
		{
			startUpDir:=(A_Startup "\" A_ScriptName " - Shortcut.lnk")
			if (status) ; add to startup
				FileCreateShortcut, % A_ScriptFullPath, % startUpDir
			else
				FileDelete, % startUpDir
		}

		
	}

	
	Splash(img:="", speed:=10, pause:=2)
	{
		/**
		Function: Splash
		Shows a custom image as a splash screen with a simple fading animation

		Parameters:
		img   (opt) - file to be displayed
		speed (opt) - fast the fading animation will be. Higher value is faster.
		pause (opt) - long in seconds the image will be paused after fully displayed.
		*/
		; global

			gui, splash: -caption +lastfound +border +alwaysontop +owner
		$hwnd := winexist(), alpha := 0
		winset, transparent, 0

		gui, splash: add, picture, x0 y0 vpicimage, % img
		guicontrolget, picimage, splash:pos
		gui, splash: show, w%picimagew% h%picimageh%

		setbatchlines 3
		loop, 255
		{
			if (alpha >= 255)
				break
			alpha += speed
			winset, transparent, %alpha%
		}

		; pause duration in seconds
		sleep pause * 1000

		loop, 255
		{
			if (alpha <= 0)
				break
			alpha -= speed
			winset, transparent, %alpha%
		}
		setbatchlines -1

		gui, splash:destroy
		return
	}

	
	Debug(level:=1, label:=">", msg:="", AddInfo:="",InvocationLine:="", vars*)
	{
		/**
		Funtion: Debug
		Allows sending conditional debug messages to the debugger and a log file filtered
		by the current debug level set on the object.

		Parameters:
		level - Debug Level, which can be:
		        * this.DBG_NONE
		        * this.DBG_ERRORS
		        * this.DBG_WARNINGS
		        * this.DBG_VERBOSE

		If you set the level for a particular message to *this.DBG_VERBOSE* this message
		wont be shown when the class debug level is set to lower than that (e.g. *this.DBG_WARNINGS*).

		label - Message label, mainly used to show the name of the function or label that triggered the message
		msg   - Arbitrary message that will be displayed on the debugger or logged to the log file
		vars* - Aditional parameters that whill be shown as passed. Useful to show variable contents to the debugger.

		Notes:
		The point of this function is to have all your debug messages added to your script and filter them out
		by just setting the object's dbgLevel variable once, which in turn would disable some types of messages.
		*/

		if !this.dbglevel
			return
		if (InvocationLine!="")
			DebugInvokedOn:="Source Code: Function invoked on line " RegexReplace(InvocationLine,"\D") "`nError invoked in function body of " " on line " Exception("",-1).Line
		for i,var in vars
		{
			if IsObject(var)
				var:=RegExReplace(ScriptObj_Obj2Str(var),"\.\d* = ","")
			varline .= "`n" var
		}
		dbgMessage := label " [invoked on " RegexReplace(InvocationLine,"\D") "]" "`n" DebugInvokedOn "`n>" msg "`n" varline

 		if (level <= this.dbglevel)
			outputdebug % dbgMessage
		else if this.dbgFile
			FileAppend, % dbgMessage, % this.dbgFile
		else
			MsgBox 0x10, % this.Name " - " "Error encountered: " this.Error.Error , % Clipboard:=dbgmessage
			; script.Error:={	 Level		:""
            ;     ,Label		:""
            ;     ,Message	:""	
            ;     ,Error		:""		
            ;     ,Vars		:[]
            ;     ,AddInfo	:""}
		script.ErrorCache[A_Now]:=script.Error
	}

	
	About(scriptName:="", version:="", author:="",credits:="", homepagetext:="", homepagelink:="", donateLink:="", email:="")
	{
		/**
		Function: About
		Shows a quick HTML Window based on the object's variable information

		Parameters:
		scriptName   (opt) - Name of the script which will be
		                     shown as the title of the window and the main header
		version      (opt) - Script Version in SimVer format, a "v"
		                     will be added automatically to this value
		author       (opt) - Name of the author of the script
		credits 	 (opt) - Name of credited people
		ghlink 		 (opt) - GitHubLink
		ghtext 		 (opt) - GitHubtext
		doclink 	 (opt) - DocumentationLink
		doctext 	 (opt) - Documentationtext
		forumlink    (opt) - forumlink
		forumtext    (opt) - forumtext
		homepagetext (opt) - Display text for the script website
		homepagelink (opt) - Href link to that points to the scripts
		                     website (for pretty links and utm campaing codes)
		donateLink   (opt) - Link to a donation site
		email        (opt) - Developer email

		Notes:
		The function will try to infer the paramters if they are blank by checking
		the class variables if provided. This allows you to set all information once
		when instatiating the class, and the about GUI will be filled out automatically.
		*/
		static doc
		scriptName := scriptName ? scriptName : this.name
		, version := version ? version : this.version
		, author := author ? author : this.author
		, credits := credits ? credits : this.credits
		, creditslink := creditslink ? creditslink : RegExReplace(this.creditslink, "http(s)?:\/\/")
		, ghtext := ghtext ? ghtext : RegExReplace(this.ghtext, "http(s)?:\/\/")
		, ghlink := ghlink ? ghlink : RegExReplace(this.ghlink, "http(s)?:\/\/")
		, doctext := doctext ? doctext : RegExReplace(this.doctext, "http(s)?:\/\/")
		, doclink := doclink ? doclink : RegExReplace(this.doclink, "http(s)?:\/\/")
		, forumtext := forumtext ? forumtext : RegExReplace(this.forumtext, "http(s)?:\/\/")
		, forumlink := forumlink ? forumlink : RegExReplace(this.forumlink, "http(s)?:\/\/")
		, homepagetext := homepagetext ? homepagetext : RegExReplace(this.homepagetext, "http(s)?:\/\/")
		, homepagelink := homepagelink ? homepagelink : RegExReplace(this.homepagelink, "http(s)?:\/\/")
		, donateLink := donateLink ? donateLink : RegExReplace(this.donateLink, "http(s)?:\/\/")
		, email := email ? email : this.email
		
 		if (donateLink)
		{
			donateSection =
			(
				<div class="donate">
					<p>If you like this tool please consider <a href="https://%donateLink%">donating</a>.</p>
				</div>
				<hr>
			)
		}

		html =
		(
			<!DOCTYPE html>
			<html lang="en" dir="ltr">
				<head>
					<meta charset="utf-8">
					<meta http-equiv="X-UA-Compatible" content="IE=edge">
					<style media="screen">
						.top {
							text-align:center;
						}
						.top h2 {
							color:#2274A5;
							margin-bottom: 5px;
						}
						.donate {
							color:#E83F6F;
							text-align:center;
							font-weight:bold;
							font-size:small;
							margin: 20px;
						}
						p {
							margin: 0px;
						}
					</style>
				</head>
				<body>
					<div class="top">
						<h2>%scriptName%</h2>
						<p>v%version%</p>
						<hr>
						<p>by %author%</p>
		)
		if ghlink and ghtext
		{
			sTmp=
			(

						<p><a href="https://%ghlink%" target="_blank">%ghtext%</a></p>
			)
			html.=sTmp
		}
		if doclink and doctext
		{
			sTmp=
			(

						<p><a href="https://%doclink%" target="_blank">%doctext%</a></p>
			)
			html.=sTmp
		}
		; Clipboard:=html
		if (creditslink and credits) || IsObject(credits) || RegexMatch(credits,"(?<Author>(\w|)*)(\s*\-\s*)(?<Snippet>(\w|\|)*)\s*\-\s*(?<URL>.*)")
		{
			if RegexMatch(credits,"(?<Author>(\w|)*)(\s*\-\s*)(?<Snippet>(\w|\|)*)\s*\-\s*(?<URL>.*)")
			{
				CreditsLines:=strsplit(credits,"`n")
				Credits:={}
				for k,v in CreditsLines
				{
					if ((InStr(v,"author1") && InStr(v,"snippetName1") && InStr(v,"URL1")) || (InStr(v,"snippetName2|snippetName3")) || (InStr(v,"author2,author3") && Instr(v, "URL2,URL3")))
						continue
					val:=strsplit(strreplace(v,"`t"," ")," - ")
					Credits[Trim(val.2)]:=Trim(val.1) "|" Trim((strlen(val.3)>5?val.3:""))
				}
			}
			; Clipboard:=html
			if IsObject(credits)  
			{
				if (1<0)
				{

					if (credits.Count()>0)
					{
						CreditsAssembly:="credits for used code:`n"
						for k,v in credits
						{
							if (k="")
								continue
							if (strsplit(v,"|").2="")
								CreditsAssembly.="<p>" k " - " strsplit(v,"|").1 "`n"
							else
								CreditsAssembly.="<p><a href=" """" strsplit(v,"|").2 """" ">" k " - " strsplit(v,"|").1 "</a></p>`n"
						}
						html.=CreditsAssembly
						; Clipboard:=html
					}
				}
				else
				{
					if (credits.Count()>0)
					{
						CreditsAssembly:="credits for used code:`n"
						for Author,v in credits
						{
							if (k="")
								continue
							if (strsplit(v,"|").2="")
								CreditsAssembly.="<p>" Author " - " strsplit(v,"|").1 "`n"
							else
							{
								Name:=strsplit(v,"|").1
								Credit_URL:=strsplit(v,"|").2
								if Instr(Author,",") && Instr(Credit_URL,",")
								{
									tmpAuthors:=""
									AllCurrentAuthors:=strsplit(Author,",")
									for s,w in strsplit(Credit_URL,",")
									{
										currentAuthor:=AllCurrentAuthors[s]
										tmpAuthors.="<a href=" """" w """" ">" trim(currentAuthor) "</a>"
										if (s!=AllCurrentAuthors.MaxIndex())
											tmpAuthors.=", "
									}
									CreditsAssembly.="<p>" tmpAuthors "</p> - " Name "`n" ;; figure out how to force this to be on one line, instead of the mess it is right now.
								}
								else
									CreditsAssembly.="<p><a href=" """" Credit_URL """" ">" Author " - " Name "</a></p>`n"
							}
						}
						html.=CreditsAssembly
						; Clipboard:=html
					}
				}
			}
			else
			{
				sTmp=
				(
							<p>credits: <a href="https://%creditslink%" target="_blank">%credits%</a></p>
							<hr>
				)
				html.=sTmp
			}
			; Clipboard:=html
		}
		if forumlink and forumtext
		{
			sTmp=
			(

						<p><a href="https://%forumlink%" target="_blank">%forumtext%</a></p>
			)
			html.=sTmp
			; Clipboard:=html
		}
		if homepagelink and homepagetext
		{
			sTmp=
			(

						<p><a href="https://%homepagelink%" target="_blank">%homepagetext%</a></p>

			)
			html.=sTmp
			; Clipboard:=html
		}
		sTmp=
		(

								</div>
					%donateSection%
				</body>
			</html>
		)
		html.=sTmp
 		btnxPos := 300/2 - 75/2
		, axHight:=12
		, donateHeight := donateLink ? 6 : 0
		, forumHeight := forumlink ? 1 : 0
		, ghHeight := ghlink ? 1 : 0
		, creditsHeight := creditslink ? 1 : 0
		, creditsHeight+= (credits.Count()>0)?credits.Count()*1.5:0 ; + d:=(credits.Count()>0?2.5:0)
		, homepageHeight := homepagelink ? 1 : 0
		, docHeight := doclink ? 1 : 0
		, axHight+=donateHeight
		, axHight+=forumHeight
		, axHight+=ghHeight
		, axHight+=creditsHeight
		, axHight+=homepageHeight
		, axHight+=docHeight
		if (axHight="")
			axHight:=12
		gui aboutScript:new, +alwaysontop +toolwindow, % "About " this.name
		gui margin, 2
		gui color, white
		gui add, activex, w500 r%axHight% vdoc, htmlFile
		gui add, button, w75 x%btnxPos% gaboutClose, % "&Close"
		doc.write(html)
		gui show, AutoSize
		return

		aboutClose:
		gui aboutScript:destroy
		return
	}

	
	GetLicense()
	{
		/*
		Function: GetLicense
		Parameters:
		Notes:
		*/
		this.systemID := this.GetSystemID()
		cleanName := RegexReplace(A_ScriptName, "\..*$")
		for i,value in ["Type", "License"]
			RegRead, %value%, % "HKCU\SOFTWARE\" cleanName, % value

		if (!License)
		{
			MsgBox, % 0x4 + 0x20
			      , % "No license"
			      , % "Seems like there is no license activated on this computer.`n"
			        . "Do you have a license that you want to activate now?"

			IfMsgBox, Yes
			{
				Gui, license:new
				Gui, add, Text, w160, % "Paste the License Code here"
				Gui, add, Edit, w160 vLicenseNumber
				Gui, add, Button, w75 vTest, % "Save"
				Gui, add, Button, w75 x+10, % "Cancel"
				Gui, show

				saveFunction := Func("licenseButtonSave").bind(this)
				GuiControl, +g, test, % saveFunction
				Exit
			}

			MsgBox, % 0x30
			      , % "Unable to Run"
			      , % "This program cannot run without a license."

			ExitApp, 1
		}

		return {"type"    : Type
		       ,"number"  : License}
	}

	
	SaveLicense(licenseType, licenseNumber)
	{
		/*
		Function: SaveLicense
		Parameters:
		Notes:
		*/
		cleanName := RegexReplace(A_ScriptName, "\..*$")

		Try
		{
			RegWrite, % "REG_SZ"
			        , % "HKCU\SOFTWARE\" cleanName
			        , % "Type", % licenseType

			RegWrite, % "REG_SZ"
			        , % "HKCU\SOFTWARE\" cleanName
			        , % "License", % licenseNumber

			return true
		}
		catch
			return false
	}

	
	IsLicenceValid(licenseType, licenseNumber, URL)
	{
		/*
		Function: IsLicenceValid
		Parameters:
		Notes:
		*/
		res := this.EDDRequest(URL, "check_license", licenseType ,licenseNumber)

		if InStr(res, """license"":""inactive""")
			res := this.EDDRequest(URL, "activate_license", licenseType ,licenseNumber)

		if InStr(res, """license"":""valid""")
			return true
		else
			return false
	}

	GetSystemID()
	{
		wmi := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2")
		(wmi.ExecQuery("Select * from Win32_BaseBoard")._newEnum)[Computer]
		return Computer.SerialNumber
	}

	
	EDDRequest(URL, Action, licenseType, licenseNumber)
	{
		/*
		Function: EDDRequest
		Parameters:
		Notes:
		*/
		strQuery := url "?edd_action=" Action
		         .  "&item_id=" licenseType
		         .  "&license=" licenseNumber
		         .  (this.systemID ? "&url=" this.systemID : "")

		try
		{
			http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
			, http.Open("GET", strQuery)
			, http.SetRequestHeader("Pragma", "no-cache")
			, http.SetRequestHeader("Cache-Control", "no-cache, no-store")
			, http.SetRequestHeader("User-Agent", "Mozilla/4.0 (compatible; Win32)")
			, http.Send()
			, http.WaitForResponse()

			return http.responseText
		}
		catch err
			return err.what ":`n" err.message
	}

/*

	Activate()
	{
		strQuery := this.strEddRootUrl . "?edd_action=activate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
		strJSON := Url2Var(strQuery)
		Diag(A_ThisFunc . " strQuery", strQuery, "")
		Diag(A_ThisFunc . " strJSON", strJSON, "")
		return JSON.parse(strJSON)
	}
	Deactivate()
	{
		Loop, Parse, % "/|", |
		{
			strQuery := this.strEddRootUrl . "?edd_action=deactivate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId . A_LoopField
			strJSON := Url2Var(strQuery)
			Diag(A_ThisFunc . " strQuery", strQuery, "")
			Diag(A_ThisFunc . " strJSON", strJSON, "")
			this.oLicense := JSON.parse(strJSON)
			if (this.oLicense.success)
			break	
		}
	}

	GetVersion()
	{
		strQuery := this.strEddRootUrl . "?edd_action=get_version&item_id=" . this.oLicense.item_id . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
		strJSON := Url2Var(strQuery)
		Diag(A_ThisFunc . " strQuery", strQuery, "")
		Diag(A_ThisFunc . " strJSON", strJSON, "")
		return JSON.parse(strJSON)
	}

	RenewLink()
	{
		strUrl := this.strEddRootUrl . "checkout/?edd_license_key=" . this.strEddLicense . "&download_id=" . this.oLicense.item_id
		Diag(A_ThisFunc . " strUrl", strUrl, "")
		return strUrl
	}


*/

	Load(INI_File:="", bSilentReturn:=0)
	{
		if (INI_File="")
			INI_File:=this.configfile
		Result := []
		, OrigWorkDir:=A_WorkingDir
		if (d_fWriteINI_st_count(INI_File,".ini")>0)
		{
			INI_File:=d_fWriteINI_st_removeDuplicates(INI_File,".ini") ;. ".ini" ;; reduce number of ".ini"-patterns to 1
			if (d_fWriteINI_st_count(INI_File,".ini")>0)
				INI_File:=SubStr(INI_File,1,StrLen(INI_File)-4) ;		 and remove the last instance
		}
			if !FileExist(INI_File ".ini") ;; create new INI_File if not existing
			{ 
				if !bSilentReturn
					msgbox, 8240,% this.Name " > scriptObj -  No Save File found", % "No save file was found.`nPlease reinitialise settings if possible."
				return false
			}
			SplitPath, INI_File, INI_File_File, INI_File_Dir, INI_File_Ext, INI_File_NNE, INI_File_Drive
			if !Instr(d:=FileExist(INI_File_Dir),"D:")
				FileCreateDir, % INI_File_Dir
			if !FileExist(INI_File_File ".ini") ;; check for ini-file file ending
				FileAppend,, % INI_File ".ini"
			SetWorkingDir, INI-Files
			IniRead, SectionNames, % INI_File ".ini"
			for each, Section in StrSplit(SectionNames, "`n") {
				IniRead, OutputVar_Section, % INI_File ".ini", %Section%
				for each, Haystack in StrSplit(OutputVar_Section, "`n")
				{
					If (Instr(Haystack,"="))
					{
						RegExMatch(Haystack, "(.*?)=(.*)", $)
						, Result[Section, $1] := $2
					}
					else
						Result[Section, Result[Section].MaxIndex()+1]:=Haystack
				}
			}
			if A_WorkingDir!=OrigWorkDir
				SetWorkingDir, %OrigWorkDir%
			this.config:=Result
		return (this.config.Count()?true:-1) ; returns true if this.config contains values. returns -1 otherwhise to distinguish between a missing config file and an empty config file
	}
	Save(INI_File:="")
	{
		if (INI_File="")
			INI_File:=this.configfile
		SplitPath, INI_File, INI_File_File, INI_File_Dir, INI_File_Ext, INI_File_NNE, INI_File_Drive
		if (d_fWriteINI_st_count(INI_File,".ini")>0)
		{
			INI_File:=d_fWriteINI_st_removeDuplicates(INI_File,".ini") ;. ".ini" ; reduce number of ".ini"-patterns to 1
			if (d_fWriteINI_st_count(INI_File,".ini")>0)
				INI_File:=SubStr(INI_File,1,StrLen(INI_File)-4) ; and remove the last instance
		}
		if !Instr(d:=FileExist(INI_File_Dir),"D:")
			FileCreateDir, % INI_File_Dir
		if !FileExist(INI_File_File ".ini") ; check for ini-file file ending
			FileAppend,, % INI_File ".ini"
		for SectionName, Entry in this.config
		{
			Pairs := ""
			for Key, Value in Entry
			{
				WriteInd++
				if !Instr(Pairs,Key "=" Value "`n")
					Pairs .= Key "=" Value "`n"
			}
			IniWrite, %Pairs%, % INI_File ".ini", %SectionName%
		}
 	}
}

d_fWriteINI_st_removeDuplicates(string, delim="`n")
{ ; remove all but the first instance of 'delim' in 'string'
	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
	/*
		RemoveDuplicates
		Remove any and all consecutive lines. A "line" can be determined by
		the delimiter parameter. Not necessarily just a `r or `n. But perhaps
		you want a | as your "line".

		string = The text or symbols you want to search for and remove.
		delim  = The string which defines a "line".

		example: st_removeDuplicates("aaa|bbb|||ccc||ddd", "|")
		output:  aaa|bbb|ccc|ddd
	*/
	delim:=RegExReplace(delim, "([\\.*?+\[\{|\()^$])", "\$1")
	Return RegExReplace(string, "(" delim ")+", "$1")
}
d_fWriteINI_st_count(string, searchFor="`n")
{ ; count number of occurences of 'searchFor' in 'string'
	; copy of the normal function to avoid conflicts.
	; from StringThings-library by tidbit, Version 2.6 (Fri May 30, 2014)
	/*
		Count
		Counts the number of times a tolken exists in the specified string.

		string    = The string which contains the content you want to count.
		searchFor = What you want to search for and count.

		note: If you're counting lines, you may need to add 1 to the results.

		example: st_count("aaa`nbbb`nccc`nddd", "`n")+1 ; add one to count the last line
		output:  4
	*/
	StringReplace, string, string, %searchFor%, %searchFor%, UseErrorLevel
	return ErrorLevel
}

	




licenseButtonSave(this, CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
	GuiControlGet, LicenseNumber
	if this.IsLicenceValid(this.eddID, licenseNumber, "https://www.the-automator.com")
	{
		this.SaveLicense(this.eddID, LicenseNumber)
		MsgBox, % 0x30
		      , % "License Saved"
		      , % "The license was applied correctly!`n"
		        . "The program will start now."
		
		Reload
	}
	else
	{
		MsgBox, % 0x10
		      , % "Invalid License"
		      , % "The license you entered is invalid and cannot be activated."

		ExitApp, 1
	}
}
licenseButtonCancel(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
	MsgBox, % 0x30
	      , % "Unable to Run"
	      , % "This program cannot run without a license."

	ExitApp, 1
}


CopyFolderAndContainingFiles(SourcePattern, DestinationFolder, DoOverwrite = false)
{
	; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
	; returns the number of files/folders that could not be copied.
    ; First copy all the files (but not the folders):
    ; FileCopy, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ; ErrorCount := ErrorLevel
    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileCopyDir, % A_LoopFileFullPath, % DestinationFolder "\" A_LoopFileName , % DoOverwrite
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
            MsgBox,% "Could not copy " A_LoopFileFullPath " into " DestinationFolder "."
    }
    return ErrorCount
}

ttip_ScriptObj(text:="TTIP: Test",mode:=1,to:=4000,xp:="NaN",yp:="NaN",CoordMode:=-1,to2:=1750,Times:=20,currTip:=20)
{
	/*
		v.0.2.1
		Date: 24 Juli 2021 19:40:56: 
		
		Modes:  
		1: remove tt after "to" milliseconds 
		2: remove tt after "to" milliseconds, but show again after "to2" milliseconds. Then repeat 
		3: not sure anymore what the plan was lol - remove 
		4: shows tooltip slightly offset from current mouse, does not repeat
		5: keep that tt until the function is called again  

		CoordMode:
		-1: Default: currently set behaviour
		1: Screen
		2: Window

		to: 
		Timeout in milliseconds
		
		xp/yp: 
		xPosition and yPosition of tooltip. 
		"NaN": offset by +50/+50 relative to mouse
		IF mode=4, 
		----  Function uses tooltip 20 by default, use parameter
		"currTip" to select a tooltip between 1 and 20. Tooltips are removed and handled
		separately from each other, hence a removal of ttip20 will not remove tt14 

		---
		v.0.2.1
		- added Obj2Str-Conversion via "ScriptObj_Obj2Str()"
		v.0.1.1 
		- Initial build, 	no changelog yet
	
	*/
	
	;if (text="TTIP: Test")
		;m(to)
		cCoordModeTT:=A_CoordModeToolTip
	if (text="") || (text=-1)
		gosub, lScriptObj_TTIP_Removettip
	if IsObject(text)
		text:=ScriptObj_Obj2Str(text)
	static ttip_text
	static lastcall_tip
	static currTip2
	global ttOnOff
	currTip2:=currTip
	cMode:=(CoordMode=1?"Screen":(CoordMode=2?"Window":cCoordModeTT))
	CoordMode, % cMode
	tooltip,

	
	ttip_text:=text
	lUnevenTimers:=false 
	MouseGetPos,xp1,yp1
	if (mode=4) ; set text offset from cursor
	{
		yp:=yp1+15
		xp:=xp1
	}	
	else
	{
		if (xp="NaN")
			xp:=xp1 + 50
		if (yp="NaN")
			yp:=yp1 + 50
	}
	tooltip, % ttip_text,xp,yp,% currTip
	if (mode=1) ; remove after given time
	{
		SetTimer, lScriptObj_TTIP_Removettip, % "-" to
	}
	else if (mode=2) ; remove, but repeatedly show every "to"
	{
		; gosub,  A
		global to_1:=to
		global to2_1:=to2
		global tTimes:=Times
		Settimer,lScriptObj_TTIP_SwitchOnOff,-100
	}
	else if (mode=3)
	{
		lUnevenTimers:=true
		SetTimer, lScriptObj_RpeatedShow, %  to
	}
	else if (mode=5) ; keep until function called again
	{
		
	}
	CoordMode, % cCoordModeTT
	return text
	lScriptObj_TTIP_SwitchOnOff:
	ttOnOff++
	if mod(ttOnOff,2)	
	{
		gosub, lScriptObj_TTIP_Removettip
		sleep, % to_1
	}
	else
	{
		tooltip, % ttip_text,xp,yp,% currTip
		sleep, % to2_1
	}
	if (ttOnOff>=ttimes)
	{
		Settimer, lScriptObj_TTIP_SwitchOnOff, off
		gosub, lScriptObj_TTIP_Removettip
		return
	}
	Settimer, lScriptObj_TTIP_SwitchOnOff, -100
	return

	lScriptObj_RpeatedShow:
	ToolTip, % ttip_text,,, % currTip2
	if lUnevenTimers
		sleep, % to2
	Else
		sleep, % to
	return
	lScriptObj_TTIP_Removettip:
	ToolTip,,,,currTip2
	return
}
ScriptObj_Obj2Str(Obj,FullPath:=1,BottomBlank:=0){
	static String,Blank
	if(FullPath=1)
		String:=FullPath:=Blank:=""
	if(IsObject(Obj)){
		for a,b in Obj{
			if(IsObject(b))
				ScriptObj_Obj2Str(b,FullPath "." a,BottomBlank)
			else{
				if(BottomBlank=0)
					String.=FullPath "." a " = " b "`n"
				else if(b!="")
					String.=FullPath "." a " = " b "`n"
				else
					Blank.=FullPath "." a " =`n"
			}
	}}
	return String Blank
}
ScriptObj_IsConnected(URL="https://autohotkey.com/boards/") {                            	;-- Returns true if there is an available internet connection
	return DllCall("Wininet.dll\InternetCheckConnection", "Str", URL,"UInt", 1, "UInt",0, "UInt")
}
OnMsgBoxScriptObj() {
						DetectHiddenWindows, On
						Process, Exist
						If (WinExist("ahk_class #32770 ahk_pid " . ErrorLevel)) {
							ControlSetText Button2, Retry
						}
					}

	BlockInput,On
	SysGet, Size, MonitorWorkArea
	SysGet, vMonCount,Monitorcount
	SetTitleMatchMode, 2 
	CreditsRaw=
	(LTRIM
	Original 							- AfterLemon 												- https://www.autohotkey.com/board/topic/93997-list-all-ahk-scripts-in-directory-in-gui/
	MWAGetMonitor						- Maestr0 													- https://www.autohotkey.com/boards/viewtopic.php?p=342716#p342716
	fTrayRefresh 						- Courtesy of masato, original by Noesis 					- https://www.autohotkey.com/boards/viewtopic.php?p=156072&sid=f3233e93ef8f9df2aaf4d3dd88f320d0#p156072
	f_SortArrays 						- u/astrosofista											- https://www.reddit.com/r/AutoHotkey/comments/qx0nho/comment/hl6ig7a/?utm_source=share&utm_medium=web2x&context=3
	PID by script name 					- just me													- https://www.autohotkey.com/board/topic/90589-how-to-get-pid-just-by-a-scripts-name/?p=572448
	AddToolTip 							- retrieved from AHK-Rare Repository, original by jballi  	- https://github.com/Ixiko/AHK-Rare, https://www.autohotkey.com/boards/viewtopic.php?t=30079
	Quote 								- u/anonymous1184 											- https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
	ReadINI 							- wolf_II												    - https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	HasVal 								- jNizM  													- https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
	EditSwap							- J. Glines 												- https://the-Automator.com/EditSwap
	ScriptObj  							- Gewerd S, original by RaptorX							    - https://github.com/Gewerd-Strauss/ScriptObj/blob/master/ScriptObj.ahk, https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk
	)
	global script := { base : script
		,name : regexreplace(A_ScriptName, "\.\w+")
		,version : "3.16.2"
		,author : "Gewerd Strauss"
		,authorlink : ""
		,email : "csa-07@freenet.de"
		,credits      : CreditsRaw
		,creditslink  : ""
		,crtdate : "30.05.2013"
		,moddate : "22.11.2022"
		,homepagetext : ""
		,homepagelink : ""
		,ghtext 	 : "My GitHub"
		,ghlink		 : "https://github.com/Gewerd-Strauss"
		,doctext : "Documentation"
		,doclink	 : "https://github.com/Gewerd-Strauss/ScriptLauncher#scriptlauncher---first-startup"
		,forumtext 	 : ""
		,forumlink	 : ""
		,donateLink : ""
		,configfile : regexreplace(A_ScriptName, "\.\w+") ".ini"
		,configfolder : A_ScriptDir "\INI-Files\"
		,vAHK	 : A_AhkVersion}	
	; variable setup
	
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
	Gui, 1: Color, cFFFFFF
	SetTitleMatchMode, RegEx
	DetectHiddenWindows, On ; Detect hidden windows
	

	SplitPath, A_ScriptName,,,,A_ScriptNameNoExt
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
		DefFileTemplate:="[Insert Folders to INCLUDE below]`n[Insert Script-Names of Scripts in added Folders to Exclude below]`n[Insert Paths to Scripts to INCLUDE below]`n[Script Behaviour Settings]`nbShowTooltips=1`nbHideOnLaunchScript=0`nbHideOnEditScript=1`nbHideOnOpenFolder=1`nbHideOnKillScript=0`nbHideOnSettingsOpened=1`nbAddSuspendButtons=1"
		FileAppend, %DefFileTemplate%,%sExcludes%
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
			Gui, 1: Add, Button, w%ButtonWidth% h20 x5 y%YPos% gRun hwndRunBtn%Ind%, % aFileNameArr[k]
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(RunBtn%Ind% ,"Run " aFileNameArr[K])

			SetTitleMatchMode, 2
			WinGetTitle, T,% v
			WinGet,PID_T,PID,% T
			
			aEnableKillButton:=GetProgRunMatrix2(aPathArr)
			Ind++
			if % aEnableKillButton[k]
			{
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
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
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
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
			SplitPath, % v, , , , Name
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				Gui, 1: Add, Button, w%ButtonWidth% h20 x240 y%YPos% gRun hwndRunBtn%Ind%, % Name
			else
			{
				Gui, 1: Add, Button, w%ButtonWidth% h20 x215 y%YPos% gRun hwndRunBtn%Ind%, % Name
			}
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(RunBtn%Ind% ,"Run " Name)

			SetTitleMatchMode, 2
			WinGetTitle, T,% v
			WinGet,PID_T,PID,% T
			
			aEnableKillButton:=GetProgRunMatrix2(aPathArr)
			Ind++
			if % aEnableKillButton[k]
			{
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
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
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
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
			Gui, 1: Add, Button, w%ButtonWidth% h20 x5 y%YPos% gRun hwndRunBtn%Ind%, % aFileNameArr[k]
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(RunBtn%Ind% ,"Run " aFileNameArr[K])

			SetTitleMatchMode, 2
			WinGetTitle, T,% v
			WinGet,PID_T,PID,% T
			
			aEnableKillButton:=GetProgRunMatrix2(aPathArr)
			Ind++
			if % aEnableKillButton[k]
			{
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
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
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% gfKillScript disabled , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript disabled, S
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
	DetectHiddenWindows, Off ; Detect hidden windows
	SetTitleMatchMode, 2
	Gui, 1: Font, w700 c000000
	; Gui, 1: Add, Text, w%TitleWidth% h20 x35 y%TitlePos% Center gDrag, Scripts
	Gui, 1: Font, c000000
	if Mod(Ind,2)
	{
		TitlePos:=Titlepos - 25
		, ButtonPos:=ButtonPos - 25
		, YPos:=YPos-25
	}
	Gui, 1: Add, Button, w20 h20 x5 y%ButtonPos% HwndButtonMHwnd gButtonM, &M
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonEHwnd gButtonE, &E
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonDHwnd gButtonD, &D
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonRHwnd gButtonR, &R
	Gui, 1: Add, Text, w40 h20 xp+20 y%TitlePos% gDrag, Scripts
	
	Gui, 1: Add, Button, w20 h20 xp+40 y%ButtonPos% HwndButtonOHwnd gButtonO, &O
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonSHwnd gButtonS, &S
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonQHwnd gButtonQ, &?
	Gui, 1: Add, Button, w20 h20 x%XButtonXCoordOld% y%ButtonPos% HwndButtonXHwnd gButtonX, &X
	TotalWidth:=XButtonXCoord2+15+2*5
	if IniObj["Script Behaviour Settings"].bAddSuspendButtons
		Gui, 1: Add, Button, w20 h20 x%XButtonXCoord2Old% y%ButtonPos% HwndButtonFHwnd gButtonF, &F
	else
		TotalWidth:=TotalWidth-(XButtonXCoord2Old-XButtonXCoordOld) ;; remove width margin for suspend-row
 	Gui, 1: +AlwaysOnTop -Caption +ToolWindow +Border
	if WinActive("ahk_exe Code.exe")
		Gui, 1: -AlwaysOnTop
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
	BlockInput,Off
	EditorSwapper()
	if WinActive("ahk_exe Code.exe")
		ttip(script.name " - Finished loading.",,1200)
	return

	fIsRunning(Path)
	{
		DetectHiddenWindows, On
		WinGet, List, List, ahk_class AutoHotkey
		Loop % List 
		{
			WinGetTitle, title, % "ahk_id" List%A_Index%
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
	if WinActive("Main Window")
		Gui, 1: Cancel ;reload ;WinClose ;MsgBox, window active, lets minimise it
	else
	{
		ToggleActiveButtons(aPathArr,IniObj)
		fGuiShow(YPos,TotalWidth,ButtonPos)
	}
	return

	#IfWinActive, About AHK ScriptLauncher
	Esc:: gui, 1: cancel


	Drag()
	{
		PostMessage, 0xA1, 2,,, A
		return
	}	

	Run()
	{
		global ;; no clue how to properly functionalise this one here.
		Loop
		{
			if (A_GuiControl=aFileNameArr[A_Index])
			{
				path:=aPathArr_United[A_Index]
				if GetKeystate("LAlt") && GetKeystate("LControl")
				{
					EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
					EnvGet, LocalAppData, LOCALAPPDATA
					SplitPath, path, , Dir
					; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
					fEditScript(Dir,LocalAppData,currentEditor)
					if IniObj["Script Behaviour Settings"].bHideOnEditScript
						Gui, 1: cancel				
					return

				}
				else if GetKeystate("LAlt") 
				{
					SplitPath, Path,, sContainingFolder
					run, % sContainingFolder
					if IniObj["Script Behaviour Settings"].bHideOnOpenFolder
						Gui, 1: cancel
					return
				}
				else IF GetKeystate("LControl") ; open script in currently set editor
				{
					EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
					EnvGet, LocalAppData, LOCALAPPDATA
					; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
					fEditScript(path,LocalAppData,currentEditor)
					if IniObj["Script Behaviour Settings"].bHideOnEditScript
						Gui, 1: cancel				
					return
					EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
					EnvGet, LocalAppData, LOCALAPPDATA
					; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
					fEditScript(path,LocalAppData,currentEditor)
					if IniObj["Script Behaviour Settings"].bHideOnEditScript
						Gui, 1: cancel				
					return
				}
				;; todo: autodetect script's ahk-version so that the launcher can run v1 and v2 scripts.
				Run, Autohotkey.exe "%Path%",	,	,PID
				aPIDarr[A_Index]:=PID
				, aPIDassarr[A_GuiControl]:=PID
				, ProcessRun:=A_Index	
				GuiControlGet, out, focus
				ProcessRun:=SubStr(out, 7, strLen(out)-6)
				, KillBtnNumber:=ProcessRun+1
				, SusBtnNumber:=ProcessRun+2
				guiControl, enable, Button%KillBtnNumber%
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					guiControl, enable, Button%SusBtnNumber%
				if IniObj["Script Behaviour Settings"].bHideOnLaunchScript
					Gui, 1: cancel
				break
			}
			else if (A_GuiControl="Scriptlauncher/INI-Files/" A_ScriptNameNoExt)
			{
				path:=aPathArr_United[A_Index]
				if (Path==A_ScriptDir "/INI-Files/" A_ScriptNameNoExt ".ini")?
				{
					MsgBox, % "No Paths set to be read. Please first set a path to a specified file or folder in the respective section of the following settings file."
					run, % Path
					if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened
						Gui, 1: cancel
					return
				}
			}
		}
		return
	}
	
	

	fUpdateSettings(PID)
	{
		WinWait, % "ahk_pid " PID
		WinWaitClose, % "ahk_pid " PID
		reload 
	}
	return

	GetProgRunMatrix2(aPathArr)
	{
		DetectHiddenWindows, On
		WinGet, List, List, ahk_class AutoHotkey
		aEnableKillButton:=[]
		, aRunningPaths:=[]
		Loop % List 
		{
			WinGetTitle, title, % "ahk_id" List%A_Index%
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
				GuiControlGet, out, focus
				ProcessRun:=SubStr(out, 7, strLen(out)-6)
				KillBtnNumber:=ProcessRun+1
				SusBtnNumber:=ProcessRun+2
				ProcessRun:=SubStr(out, 7, strLen(out)-6)
				SusBtnNumber:=ProcessRun
				GuiControlGet, sFileNameKill,,% "Button" ProcessRun - 2

		GuiControlGet, sStateCurrentScript,,Button%SusBtnNumber%

		DetectHiddenWindows, On
		WinGetClass, cClass, % sFileNameKill ".ahk"
		aAllowedToBeClosedClasses:=["AutoHotkey","AutoHotkeyGUI"] ; make sure we don't accidentally kill editors/IDEs
		if WinExist(sFileNameKill ".ahk") ;and HasVal(aAllowedToBeClosedClasses,cClass)
		{ ;A_GuiControl
			str:=sFileNameKill ".ahk - AutoHotkey"
			PostMessage, 0x111, 65305,,, %str%   ; Suspend.
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
			if IniObj["Script Behaviour Settings"].bHideOnKillScript
				Gui, 1: hide
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
		DetectHiddenWindows, On
		WinGetClass, cClass, % sFileNameKill ".ahk"
		if WinExist(sFileNameKill ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
		{ ;A_GuiControl
			WinClose
			WinKill,% "ahk_exe " WinExist(sPathToKill)
			if d:=WinExist(sFileNameKill ".ahk")
			{
				str:=sFileNameKill ".ahk - AutoHotkey"
				PostMessage, 0x0112, 0xF060,,, %str%  ; 0x0112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
				str:=sPathToKill " - AutoHotkey"
				PostMessage, 0x0112, 0xF060,,, %str%  ; 0x0112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
				Process, close, % d
				loop,
				{
					if !WinExist(sFileNameKill ".ahk")
						break
					Process, Close, % sFileNameKill (Instr(sFileNameKill,".ahk")?:".ahk")	;; Killing via "FileName" doesn't work for some reason.
					Process, Close, % sFileNameKill											;; Killing via "FileName" doesn't work for some reason. || not sure if this is smart to leave out the .ahk. Could this kill editors? 
					if WinExist(sFileNameKill ".ahk")
						Process, Close, % aPIDarr[Index]
					if WinExist(sFileNameKill ".ahk")
					{
						WinGet, PID, PID, % sFileNameKill ".ahk"
						Process, Close, % PID
					}
				}
				until (A_Index>15)
			}
			if !IniObj["Script Behaviour Settings"].bAddSuspendButtons
			KillBtnNumber:=KillBtnNumber+1
			GuiControl, Disable, Button%KillBtnNumber%
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			{
				SusBtnNumber:=KillBtnNumber+1
				GuiControl, Disable, Button%SusBtnNumber%
				GuiControl,, Button%SusBtnNumber%, S
			}
			if IniObj["Script Behaviour Settings"].bHideOnKillScript
				Gui, 1: hide
			fTray_Refresh() ; remove dead icons
		}
		return
	}
	
	;----
	;----
	;----
		
	ButtonM()
	{
		gui, 1: hide
	}
	ButtonE()
	{
		global
		EnvGet, LocalAppData, LOCALAPPDATA
		fEditScript(A_ScriptFullPath,LocalAppData,currentEditor)
		return
	}
	ButtonD()
	{
		run, % A_ScriptDir
		Gui,1: hide
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
		Run, % A_ScriptDir "/INI-Files/" script.name ".ini",,,RunPID
		if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened
			GUI, 1: hide
		; sleep, 700
		fUpdateSettings(RunPID)
	}
	return
	ButtonS()
	{
		Gui,1: hide
		fShowGuiSwapper()
	}
	return
	ButtonQ()
	{
		Gui,1: hide
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
				DetectHiddenWindows, On
				WinGetClass, cClass, % v ".ahk"
				if WinExist(v ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
				{
					WinClose, 
					if WinExist(v ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
					{
						Process, Close, % v (Instr(v,".ahk")?:".ahk")	;; Killing via "FileName" doesn't work for some reason.
						Process, Close, % v											;; Killing via "FileName" doesn't work for some reason. || not sure if this is smart to leave out the .ahk. Could this kill editors? 
						if WinExist(v ".ahk")
							Process, Close, % aPIDarr[A_Index]

					}
					if !HasVal(aButtonXClosedScripts,v)
						aButtonXClosedScripts.push(v)
				}
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				{
					KillBtnNumber:=k*3-1
					SusBtnNumber:=k*3
					GuiControl, disable, Button%KillBtnNumber%
					GuiControl, disable, Button%SusBtnNumber%
					GuiControl,, Button%SusBtnNumber%, S
				}
				else
					KillBtnNumber:=k*2
				GuiControl, disable, Button%KillBtnNumber%
				
				DetectHiddenWindows, Off
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
						Run, Autohotkey.exe "%Path%",	,	,PID
						aPIDarr[A_Index]:=PID
						aPIDassarr[v]:=PID
						ProcessRun:=A_Index								;; get the current pid'
						KillBtnNumber:=ProcessRun*3-1
						guiControl, enable, Button%KillBtnNumber%
						if IniObj["Script Behaviour Settings"].bAddSuspendButtons
						{
							SusBtnNumber:=KillBtnNumber+1
							guiControl, enable, Button%SusBtnNumber%
						}
						if IniObj["Script Behaviour Settings"].bHideOnLaunchScript
							Gui, 1: cancel

					if HasVal(aButtonXClosedScripts,v)
							aButtonXClosedScripts.Remove(HasVal(aButtonXClosedScripts,v))
					}

				}
			}
			bKillTrueRestoreFalse:=true
		}
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
			DetectHiddenWindows, On
			if WinExist(v ".ahk")
			{
				str:=v ".ahk - AutoHotkey"
				PostMessage, 0x111, 65305,,, %str%   ; Suspend.
			}
			DetectHiddenWindows, Off
		}
		return
	}

	;----
	;----
	;----

	GuiEscape()
	{
		Gui, 1: Cancel
		return
	}
	
	ToggleActiveButtons(aPathArr,IniObj)
	{
		aEnableKillButton:=GetProgRunMatrix2(aPathArr)
		for k,v in aEnableKillButton		;; logical array
		{
			if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				KillBtnNumber:=A_Index*3-1
			Else
				KillBtnNumber:=A_Index*2
			if v			;; check for true's in logical array "aEnableKillButton"
			{
				guicontrol, enable, Button%KillBtnNumber%
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
				{
					SusBtnNumber:=KillBtnNumber+1
					guicontrol, enable, Button%SusBtnNumber%
				}
			}
			else
			{
				guicontrol, disable, Button%KillBtnNumber%
				SusBtnNumber:=KillBtnNumber+1
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					guicontrol, disable, Button%SusBtnNumber%
			}
		}
	}
	return

	fGuiShow(YPos,Width,ButtonPos)
	{
		CurrentMOnitor:=MWAGetMonitor()+0
		SysGet, MonCount, MonitorCount
		if (MonCount>1)
		{
			SysGet, Mon, Monitor,% CurrentMonitor
			SysGet, MonW,MonitorWorkArea, % CurrentMonitor
		}
		else 
		{
			SysGet, Mon, Monitor, 1
			SysGet,MonW,MonitorWorkArea, 1
		}
		MonWidth:=(MonLeft?MonLeft:MonRight)
		MonWidth:=MonRight-MonLeft
		if SubStr(MonWidth, 1,1)="-"
			MonWidth:=SubStr(MonWidth,2)
		CoordModeMouse:=A_CoordModeMouse
		CoordMode,Mouse,Screen
		MouseGetPos,MouseX,MouseY
		CoordMode, Mouse, %CoordModeMouse%
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
		Gui, 1: Show, w%Width% h%YPos% x%PositionXGui% y%PositionYGui% Hide, Main Window 
		guicontrol, focus, Button%ButtonM_Ind%
		Settimer, lCheckButtons,100
		WinGetPos X, Y, Width, Height, Main Window
		Gui, 1: Show,, Main Window
	}



	lCheckButtons()
	{
		if !WinExist("Main Window") ;; window not visible anymore, so stop the timer
			Settimer, lCheckButtons, off
		return
	}

	



	
	
	
	fEditScript(ScriptPath,LocalAppData,cEDT)
	{
		ProgramPath:= LocalAppData "\Programs\Microsoft VS Code\Code.exe" ;; original one.
		ProgramPath2:=strsplit(cEDT,".exe").1 ".exe"
		;m((ProgramPath==ProgramPath2),ProgramPath,ProgramPath2)
		Run, % ProgramPath2 A_Space Quote(ScriptPath),,UseErrorLevel

		if ErrorLevel && FileExist(ProgramPath) ;; fallback on 
		{
			ttip("fallback")
			Run, % ProgramPath A_Space Quote(ScriptPath) 
		}
		if !FileExist(ProgramPath) && !FileExist(ProgramPath2)
			MsgBox, % 0x10
			, % "Error"
			, % "No editor is available or set up by editswap."
		; Clipboard:="ScriptPath: " ScriptPath "`n||`nLocalAppData: " LocalAppData "`n||`nRunCMD: " ProgramPath A_Space Quote(ScriptPath)
		GUI, 1: hide
		return
	}

	fReadINI(INI_File) ; return 2D-array from INI-file
	{ ; Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
		Result := []
		OrigWorkDir:=A_WorkingDir
		SetWorkingDir, INI-Files
		IniRead, SectionNames, %INI_File%
		for each, Section in StrSplit(SectionNames, "`n") {
			IniRead, OutputVar_Section, %INI_File%, %Section%
			for each, Haystack in StrSplit(OutputVar_Section, "`n")
				RegExMatch(Haystack, "(.*?)=(.*)", $)
			, Result[Section, $1] := $2
		}
		if A_WorkingDir!=OrigWorkDir
			SetWorkingDir, %OrigWorkDir%
		return Result
		/* Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
		;-------------------------------------------------------------------------------
			ReadINI(INI_File) { ; return 2D-array from INI-file
		;-------------------------------------------------------------------------------
				Result := []
				IniRead, SectionNames, %INI_File%
				for each, Section in StrSplit(SectionNames, "`n") {
					IniRead, OutputVar_Section, %INI_File%, %Section%
					for each, Haystack in StrSplit(OutputVar_Section, "`n")
						RegExMatch(Haystack, "(.*?)=(.*)", $)
				, Result[Section, $1] := $2
				}
				return Result
		*/

	}
	
	fLoadSettings(sExcludes)
	{
		IniObj:=fReadIni(sExcludes) ; just used to get the settings. The rest of the INI-file is not conforming to this function, and is also not supposed to do so because it only has to store filepaths. 
		FileRead, Text, %sExcludes%
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


	Quote(String)
	{ ; u/anonymous1184 | fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
		return """" String """"
	}


	MWAGetMonitor(Mx := "", My := "")
	{ ; Maestr0 | fetched from https://www.autohotkey.com/boards/viewtopic.php?p=342716#p342716
		if  (!Mx or !My) 
		{
			; if Mx or My is empty, revert to the mouse cursor placement
			Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
			MouseGetPos, Mx, My
		}
		
		SysGet, MonitorCount, 80	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
		Loop, %MonitorCount%
		{
			SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars
			
			if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
			{
				ActiveMon := A_Index
				break
			}
		}
		return ActiveMon
	}


	fTray_Refresh()
	{ ; Courtesy of masato, original version by Noesis: https://www.autohotkey.com/boards/viewtopic.php?p=156072&sid=f3233e93ef8f9df2aaf4d3dd88f320d0#p156072
				/*		Remove any dead icon from the tray menu
					*		Should work both for W7 & W10
					
		*/
		
		WM_MOUSEMOVE:=0x200
		detectHiddenWin:=A_DetectHiddenWindows
		DetectHiddenWindows, On

		allTitles:=["ahk_class Shell_TrayWnd"
		, "ahk_class NotifyIconOverflowWindow"]
		allControls:=["ToolbarWindow321"
		,"ToolbarWindow322"
		,"ToolbarWindow323"
		,"ToolbarWindow324"
		,"ToolbarWindow325"
		,"ToolbarWindow326"]
		allIconSizes:=[24,32]

		for id, title in allTitles 
		{
			for id, controlName in allControls
			{
				for id, iconSize in allIconSizes
				{
					ControlGetPos, xTray,yTray,wdTray,htTray,% controlName,% title
					y:=htTray - 10
					While (y > 0)
					{
						x:=wdTray - iconSize/2
						While (x > 0)
						{
							point:=(y << 16) + x
							PostMessage,% WM_MOUSEMOVE, 0,% point,% controlName,% title
							x -= iconSize/2
						}
						y -= iconSize/2
					}
				}
			}
		}

		DetectHiddenWindows, %detectHiddenWin%
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
					StringTrimRight, FileName%A_IndexCount%, A_LoopFileName, 4
					aPathArr.push(A_LoopFileFullPath)
					aFileNameArr.push(StrSplit(A_LoopFileName,".").1)
				}
				else
					continue
			}
		}
		for k,v in IncludedScripts
		{
			SplitPath, v ,fName, IncludedScriptsDirectory,,fNameNoExt
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
		}
		if aPathArr.MaxIndex()="" ; fallback if no folders are set up.
		{
			; msgbox, % "No folders added"
			SplitPath, A_ScriptName,,,,A_ScriptNameNoExt
			aPathArr:=[A_ScriptDir "/INI-Files/" A_ScriptNameNoExt ".ini"]
			aFileNameArr:=["Add files and folders to include"]

		}
		return [aPathArr,aFileNameArr]
	}
	
	HasVal(haystack, needle) 
	{	; code from jNizM on the ahk forums: https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
		if !(IsObject(haystack)) || (haystack.Length() = 0)
			return 0
		for index, value in haystack
			if (value = needle)
			return index
		return 0
	}
	
    ; --uID:4226315121
     ; Metadata:
      ; Snippet: ttip  ;  (v.1.3)
      ; --------------------------------------------------------------
      ; Author: Gewerd Strauss
      ; License: WTFPL
      ; --------------------------------------------------------------
      ; Library: Personal Library
      ; Section: 21 - ToolTips
      ; Dependencies: /
      ; AHK_Version: /
      ; --------------------------------------------------------------
      ; Keywords: TOOLTIP
    
     ;; Description:
      ;; small tooltip handler
    
     ttip(text:="TTIP: Test",mode:=1,to:=4000,xp:="NaN",yp:="NaN",CoordMode:=-1,to2:=1750,Times:=20,currTip:=20)
     {
     	/*
     		v.0.2.1
     		Date: 24 Juli 2021 19:40:56: 
     		
     		Modes:  
     		1: remove tt after "to" milliseconds 
     		2: remove tt after "to" milliseconds, but show again after "to2" milliseconds. Then repeat 
     		3: not sure anymore what the plan was lol - remove 
     		4: shows tooltip slightly offset from current mouse, does not repeat
     		5: keep that tt until the function is called again  
     
     		CoordMode:
     		-1: Default: currently set behaviour
     		1: Screen
     		2: Window
     
     		to: 
     		Timeout in milliseconds
     		
     		xp/yp: 
     		xPosition and yPosition of tooltip. 
     		"NaN": offset by +50/+50 relative to mouse
     		IF mode=4, 
     		----  Function uses tooltip 20 by default, use parameter
     		"currTip" to select a tooltip between 1 and 20. Tooltips are removed and handled
     		separately from each other, hence a removal of ttip20 will not remove tt14 
     
     		---
     		v.0.2.1
     		- added Obj2Str-Conversion via "ttip_Obj2Str()"
     		v.0.1.1 
     		- Initial build, 	no changelog yet
     	
     	*/
     	
     	;if (text="TTIP: Test")
     		;m(to)
     		cCoordModeTT:=A_CoordModeToolTip
     	if (text="") || (text=-1)
     		gosub, llTTIP_RemoveTTIP
     	if IsObject(text)
     		text:=ttip_Obj2Str(text)
     	static ttip_text
     	static lastcall_tip
     	static currTip2
     	global ttOnOff
     	currTip2:=currTip
     	cMode:=(CoordMode=1?"Screen":(CoordMode=2?"Window":cCoordModeTT))
     	CoordMode, % cMode
     	tooltip,
     
     	
     	ttip_text:=text
     	lUnevenTimers:=false 
     	MouseGetPos,xp1,yp1
     	if (mode=4) ; set text offset from cursor
     	{
     		yp:=yp1+15
     		xp:=xp1
     	}	
     	else
     	{
     		if (xp="NaN")
     			xp:=xp1 + 50
     		if (yp="NaN")
     			yp:=yp1 + 50
     	}
     	tooltip, % ttip_text,xp,yp,% currTip
     	if (mode=1) ; remove after given time
     	{
     		SetTimer, llTTIP_RemoveTTIP, % "-" to
     	}
     	else if (mode=2) ; remove, but repeatedly show every "to"
     	{
     		; gosub,  A
     		global to_1:=to
     		global to2_1:=to2
     		global tTimes:=Times
     		Settimer,lTTIP_SwitchOnOff,-100
     	}
     	else if (mode=3)
     	{
     		lUnevenTimers:=true
     		SetTimer, llTTIP_RepeatedShow, %  to
     	}
     	else if (mode=5) ; keep until function called again
     	{
     		
     	}
     	CoordMode, % cCoordModeTT
     	return text
     	lTTIP_SwitchOnOff:
     	ttOnOff++
     	if mod(ttOnOff,2)	
     	{
     		gosub, llTTIP_RemoveTTIP
     		sleep, % to_1
     	}
     	else
     	{
     		tooltip, % ttip_text,xp,yp,% currTip
     		sleep, % to2_1
     	}
     	if (ttOnOff>=ttimes)
     	{
     		Settimer, lTTIP_SwitchOnOff, off
     		gosub, llTTIP_RemoveTTIP
     		return
     	}
     	Settimer, lTTIP_SwitchOnOff, -100
     	return
     
     	llTTIP_RepeatedShow:
     	ToolTip, % ttip_text,,, % currTip2
     	if lUnevenTimers
     		sleep, % to2
     	Else
     		sleep, % to
     	return
     	llTTIP_RemoveTTIP:
     	ToolTip,,,,currTip2
     	return
     }
     
     ttip_Obj2Str(Obj,FullPath:=1,BottomBlank:=0){
     	static String,Blank
     	if(FullPath=1)
     		String:=FullPath:=Blank:=""
     	if(IsObject(Obj)){
     		for a,b in Obj{
     			if(IsObject(b))
     				ttip_Obj2Str(b,FullPath "." a,BottomBlank)
     			else{
     				if(BottomBlank=0)
     					String.=FullPath "." a " = " b "`n"
     				else if(b!="")
     					String.=FullPath "." a " = " b "`n"
     				else
     					Blank.=FullPath "." a " =`n"
     			}
     	}}
     	return String Blank
     }
     
    
    
    ; --uID:4226315121
	AddToolTip(_CtrlHwnd, _TipText, _Modify = 0) 			;-- very easy to use function to add a tooltip to a control
	{ ; AddToolTip | retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

		; retrieved from AHK-Rare Repository, original by jballi: https://www.autohotkey.com/boards/viewtopic.php?t=30079

			/*                              	DESCRIPTION

					Adds Multi-line ToolTips to any Gui Control
					AHK basic, AHK ANSI, Unicode x86/x64 compatible

					Thanks Superfraggle & Art: http://www.autohotkey.com/forum/viewtopic.php?p=188241
					Heavily modified by Rseding91 3/4/2014:
					Version: 1.0
					* Fixed 64 bit support
					* Fixed multiple GUI support
					* Changed the _Modify parameter
							* blank/0/false:                                	Create/update the tool tip.
							* -1:                                           		Delete the tool tip.
							* any other value:                             Update an existing tool tip - same as blank/0/false
																						but skips unnecessary work if the tool tip already
																						exists - silently fails if it doesn't exist.
					* Added clean-up methods:
							* AddToolTip(YourGuiHwnd, "Destroy", -1):       		Cleans up and erases the cached tool tip data created
																					for that GUI. Meant to be used in conjunction with
																					GUI, Destroy.
								* AddToolTip(YourGuiHwnd, "Remove All", -1):	   	Removes all tool tips from every control in the GUI.
																					Has the same effect as "Destroy" but first removes
																					every tool tip from every control. This is only used
																					when you want to remove every tool tip but not destroy
																					the entire GUI afterwords.
							* NOTE: Neither of the above are required if
										your script is closing.

					- 'Text' and 'Picture' Controls requires a g-label to be defined.
					- 'ComboBox' = Drop-Down button + Edit (Get hWnd of the 'Edit'   control using "ControlGet" command).
					- 'ListView' = ListView + Header       (Get hWnd of the 'Header' control using "ControlGet" command).

		*/

		Static TTHwnds, GuiHwnds, Ptr
		, LastGuiHwnd
		, LastTTHwnd
		, TTM_DELTOOLA := 1029
		, TTM_DELTOOLW := 1075
		, TTM_ADDTOOLA := 1028
		, TTM_ADDTOOLW := 1074
		, TTM_UPDATETIPTEXTA := 1036
		, TTM_UPDATETIPTEXTW := 1081
		, TTM_SETMAXTIPWIDTH := 1048
		, WS_POPUP := 0x80000000
		, BS_AUTOCHECKBOX = 0x3
		, CW_USEDEFAULT := 0x80000000

		Ptr := A_PtrSize ? "Ptr" : "UInt"

			/*                              	NOTE

						This is used to remove all tool tips from a given GUI and to clean up references used
						This can be used if you want to remove every tool tip but not destroy the GUI
						When a GUI is destroyed all Windows tool tip related data is cleaned up.
						The cached Hwnd's in this function will be removed automatically if the caching code
						ever matches them to a new GUI that doesn't actually own the Hwnd's.
						It's still possible that a new GUI could have the same Hwnd as a previously destroyed GUI
						If such an event occurred I have no idea what would happen. Either the tool tip
						To avoid that issue, do either of the following:
							* Don't destroy a GUI once created
						NOTE: You do not need to do the above if you're exiting the script Windows will clean up
						all tool tip related data and the cached Hwnd's in this function are lost when the script
						exits anyway.AtEOF
		*/

		If (_TipText = "Destroy" Or _TipText = "Remove All" And _Modify = -1)
		{
			; Check if the GuiHwnd exists in the cache list of GuiHwnds
			; If it doesn't exist, no tool tips can exist for the GUI.
			;
			; If it does exist, find the cached TTHwnd for removal.
			Loop, Parse, GuiHwnds, |
				If (A_LoopField = _CtrlHwnd)
			{
				TTHwnd := A_Index
				, TTExists := True
				Loop, Parse, TTHwnds, |
					If (A_Index = TTHwnd)
					TTHwnd := A_LoopField
			}

			If (TTExists)
			{
				If (_TipText = "Remove All")
				{
					WinGet, ChildHwnds, ControlListHwnd, ahk_id %_CtrlHwnd%

					Loop, Parse, ChildHwnds, `n
						AddToolTip(A_LoopField, "", _Modify) ;Deletes the individual tooltip for a given control if it has one

					DllCall("DestroyWindow", Ptr, TTHwnd)
				}

				GuiHwnd := _CtrlHwnd
				; This sub removes 'GuiHwnd' and 'TTHwnd' from the cached list of Hwnds
				GoSub, RemoveCachedHwnd
			}

			return
		}

		If (!GuiHwnd := DllCall("GetParent", Ptr, _CtrlHwnd, Ptr))
			return "Invalid control Hwnd: """ _CtrlHwnd """. No parent GUI Hwnd found for control."

		; If this GUI is the same one as the potential previous one
		; else look through the list of previous GUIs this function
		; has operated on and find the existing TTHwnd if one exists.
		If (GuiHwnd = LastGuiHwnd)
			TTHwnd := LastTTHwnd
		Else
		{
			Loop, Parse, GuiHwnds, |
				If (A_LoopField = GuiHwnd)
			{
				TTHwnd := A_Index
				Loop, Parse, TTHwnds, |
					If (A_Index = TTHwnd)
					TTHwnd := A_LoopField
			}
		}

		; If the TTHwnd isn't owned by the controls parent it's not the correct window handle
		If (TTHwnd And GuiHwnd != DllCall("GetParent", Ptr, TTHwnd, Ptr))
		{
			GoSub, RemoveCachedHwnd
			TTHwnd := ""
		}

		; Create a new tooltip window for the control's GUI - only one needs to exist per GUI.
		; The TTHwnd's are cached for re-use in any subsequent calls to this function.
		If (!TTHwnd)
		{
			TTHwnd := DllCall("CreateWindowEx"
				, "UInt", 0 ;dwExStyle
				, "Str", "TOOLTIPS_CLASS32" ;lpClassName
				, "UInt", 0 ;lpWindowName
				, "UInt", WS_POPUP | BS_AUTOCHECKBOX ;dwStyle
				, "UInt", CW_USEDEFAULT ;x
				, "UInt", 0 ;y
				, "UInt", 0 ;nWidth
				, "UInt", 0 ;nHeight
				, "UInt", GuiHwnd ;hWndParent
				, "UInt", 0 ;hMenu
				, "UInt", 0 ;hInstance
			, "UInt", 0) ;lpParam

			; TTM_SETWINDOWTHEME
			DllCall("uxtheme\SetWindowTheme"
				, Ptr, TTHwnd
				, Ptr, 0
			, Ptr, 0)

			; Record the TTHwnd and GuiHwnd for re-use in any subsequent calls.
			TTHwnds .= (TTHwnds ? "|" : "") TTHwnd
			, GuiHwnds .= (GuiHwnds ? "|" : "") GuiHwnd
		}

		; Record the last-used GUIHwnd and TTHwnd for re-use in any immediate future calls.
		LastGuiHwnd := GuiHwnd
		, LastTTHwnd := TTHwnd
			/*
				*TOOLINFO STRUCT*

				UINT        cbSize
				UINT        uFlags
				HWND        hwnd
				UINT_PTR    uId
				RECT        rect
				HINSTANCE   hinst
				LPTSTR      lpszText
				#if (_WIN32_IE >= 0x0300)
					LPARAM    lParam;
				#endif
				#if (_WIN32_WINNT >= Ox0501)
					void      *lpReserved;
				#endif
		*/

		, TInfoSize := 4 + 4 + ((A_PtrSize ? A_PtrSize : 4) * 2) + (4 * 4) + ((A_PtrSize ? A_PtrSize : 4) * 4)
		, Offset := 0
		, Varsetcapacity(TInfo, TInfoSize, 0)
		, Numput(TInfoSize, TInfo, Offset, "UInt"), Offset += 4 ; cbSize
		, Numput(1 | 16, TInfo, Offset, "UInt"), Offset += 4 ; uFlags
		, Numput(GuiHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; hwnd
		, Numput(_CtrlHwnd, TInfo, Offset, Ptr), Offset += A_PtrSize ? A_PtrSize : 4 ; UINT_PTR
		, Offset += 16 ; RECT (not a pointer but the entire RECT)
		, Offset += A_PtrSize ? A_PtrSize : 4 ; hinst
		, Numput(&_TipText, TInfo, Offset, Ptr) ; lpszText
		; The _Modify flag can be used to skip unnecessary removal and creation if
		; the caller follows usage properly but it won't hurt if used incorrectly.
		If (!_Modify Or _Modify = -1)
		{
			If (_Modify = -1)
			{
				; Removes a tool tip if it exists - silently fails if anything goes wrong.
				DllCall("SendMessage"
					, Ptr, TTHwnd
					, "UInt", A_IsUnicode ? TTM_DELTOOLW : TTM_DELTOOLA
					, Ptr, 0
				, Ptr, &TInfo)

				return
			}

			; Adds a tool tip and assigns it to a control.
			DllCall("SendMessage"
				, Ptr, TTHwnd
				, "UInt", A_IsUnicode ? TTM_ADDTOOLW : TTM_ADDTOOLA
				, Ptr, 0
			, Ptr, &TInfo)

			; Sets the preferred wrap-around width for the tool tip.
			DllCall("SendMessage"
				, Ptr, TTHwnd
				, "UInt", TTM_SETMAXTIPWIDTH
				, Ptr, 0
			, Ptr, A_ScreenWidth)
		}

		; Sets the text of a tool tip - silently fails if anything goes wrong.
		DllCall("SendMessage"
			, Ptr, TTHwnd
			, "UInt", A_IsUnicode ? TTM_UPDATETIPTEXTW : TTM_UPDATETIPTEXTA
			, Ptr, 0
		, Ptr, &TInfo)

		return
		RemoveCachedHwnd:
			Loop, Parse, GuiHwnds, |
				NewGuiHwnds .= (A_LoopField = GuiHwnd ? "" : ((NewGuiHwnds = "" ? "" : "|") A_LoopField))

			Loop, Parse, TTHwnds, |
				NewTTHwnds .= (A_LoopField = TTHwnd ? "" : ((NewTTHwnds = "" ? "" : "|") A_LoopField))

			GuiHwnds := NewGuiHwnds
			, TTHwnds := NewTTHwnds
			, LastGuiHwnd := ""
			, LastTTHwnd := ""
		return
	}
	
	EditorSwapper()
	{
		SplitPath, A_ScriptName,,,,A_ScriptNameNoExt
		; global script := {base         : script
		;  ,name         : regexreplace(A_ScriptName, "\.\w+")
		;  ,version      : "0.2.0"
		;  ,author       : "Joe Glines"
		;  ,email        : "Joe@the-automator.com"
		;  ,crtdate      : "April 14, 2021"
		;  ,moddate      : "July 14, 2021"
		;  ,homepagetext : "the-Automator.com/EditSwap"
		;  ,homepagelink : ""
		;  ,donateLink   : "https://www.paypal.com/donate?hosted_button_id=MBT5HSD9G94N6"
		;  ;~ ,resfolder    : A_ScriptDir "\res"
		;  ;~ ,iconfile     : A_ScriptDir "\res\sct.ico"
		;  ,configfile   :  regexreplace(A_ScriptName, "\.\w+") ".ini"
		;  ,configfolder : A_ScriptDir "\INI-Files\"}


		global Configuration:=script.configfolder script.configfile
		IniRead, editHistory, %Configuration%, % "History"
		global currentEditor
		RegRead, currentEditor, % "HKCU\SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command"
		global currentEditor2:=currentEditor
		If	(!InStr( FileExist(script.configfolder script.configfile),"D"))
		{
			FileCreateDir, % script.configfolder
		}

		SplitPath, currentEditor, currentEditorEXE,,, currentEditorName

		Gui, EditorList:new
		Gui, font, s12, SegoeUI
		Gui, add, text, vCurrentEditorTitle, % "Current Editor: " format("{:T}", regexreplace(currentEditorEXE, "\s.*"))
		Gui, add, text,, % "Previous Editors:"
		Gui, font

		Gui, add, listview, w600 Sort, % "Name|Path"
		Gui, add, button, w75 x370 gSetEditor, % "Set Selected"
		Gui, add, button, w75 x+10 gAddEditor, % "Add New"
		Gui, add, button, w75 x+10 gEditorListGuiClose, % "Exit"

		if (editHistory != ""){
			editorlist := StrSplit(editHistory, "`n", "`r")
			for i,editor in editorlist{
				cEdit := StrSplit(editor, "=")
				LV_Add("", format("{:T}", cEdit[1]), cEdit[2])
			}
		}else{
			LV_Add("", format("{:T}", currentEditorName), currentEditor)

			IniWrite, % currentEditor, %Configuration%, % "History", % currentEditorName
			IniWrite, % currentEditor, %Configuration%, % "Current", % currentEditorName
		}

		LV_ModifyCol()
		return
	}

	fShowGuiSwapper()
	{
		Gui,EditorList: Show
		return
	}

	AddEditor(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
	{
		FileSelectFile, newEditorPath

		if (!newEditorPath){
			MsgBox, % 0x10
			, % "Error"
			, % "No Editor was selected.`nExiting the app"
			return
		}

		saveEditor(newEditorPath " ""%1""")

		MsgBox, % 0x40
		, % "Operation Complete"
		, % "New editor Saved correctly: " newEditorPath

		return
	}

	SetEditor(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
	{
		Gui, EditorList:Default

		row := LV_GetNext(0, "F")
		LV_GetText(sEditorPath, row, 2)
		LV_Delete(row)

		if (!sEditorPath){
			MsgBox, % 0x10
			, % "Error"
			, % "You must select an editor from the history to set it"
			return
		}

		saveEditor(sEditorPath)
		return
	}

	saveEditor(newEditorPath)
	{
		global currentEditor, currentEditorName, CurrentEditorTitle
		Gui, EditorList:Default

		SplitPath, newEditorPath, newEditorEXE,,, newEditorName
		newEditorEXE := StrReplace(newEditorEXE, " ""%1""")
		GuiControl, move, CurrentEditorTitle, % "w" StrLen("Current Editor: " newEditorEXE)*8 
		GuiControl,, CurrentEditorTitle, % "Current Editor: " format("{:T}", newEditorEXE)

		IniDelete, %Configuration%, % "Current"
		IniWrite, % newEditorPath, %Configuration%, % "Current", % newEditorName
		IniWrite, % newEditorPath, %Configuration%, % "History", % newEditorName

		RegWrite, % "REG_SZ", % "HKCU\SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command",, % newEditorPath

		LV_Add("", format("{:T}", newEditorName), newEditorPath)
		return
	}

	EditorListGuiClose:
	EditorListGuiEscape:
		;ExitApp, 0
		reload


	;________________________________
	;________________________________
	;________________________________
	; Original Scriptlauncher-Script by AfterLemon below, Source:
	; http://www.autohotkey.com/board/topic/93997-list-all-ahk-scripts-in-directory-in-Gui/
	;________________________________
	;________________________________
	;________________________________

	