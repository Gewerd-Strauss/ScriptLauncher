/*  */ 	; Modified by Gewerd S.Source Code at bottom
	; reworked by Gewerd S. to allow files from multiple paths to be included, as well as a variety of other small goodies.
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
	WinGetAll							| heresy (old ahk forums) 									| fetched fro/*  */m https://www.autohotkey.com/board/topic/30323-wingetall-get-all-windows-titleclasspidprocess-name/
	AddToolTip 							| retrieved from AHK-Rare Repository, original by jballi  	| fetched from https://github.com/Ixiko/AHK-Rare, original: https://www.autohotkey.com/boards/viewtopic.php?t=30079
	Quote 								| u/anonymous1184 											| fetched from https://www.reddit.com/r/AutoHotkey/comments/p2z9co/comment/h8oq1av/?utm_source=share&utm_medium=web2x&context=3
	ReadINI 							| wolf_II												   M| fetched from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
	HasVal 								| jNizM  													| https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
	EditSwap							| J. Glines 												| https://the-Automator.com/EditSwap
	ScriptObj  							| RaptorX 					 							   M| https://github.com/Gewerd-Strauss/ScriptObj/blob/master/ScriptObj.ahk, https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk

	*/
	#NoEnv
	SetBatchLines -1
	;#UseHook
	#Warn All, OutputDebug
	#Persistent
	#SingleInstance Force
	#NoTrayIcon
	; code starts line 810
					
		; last edited by Gewerd Strauss @ 27.11.2021
		; from RaptorX https://github.com/RaptorX/ScriptObj/blob/master/ScriptObj.ahk
		/**
		* ============================================================================ *
		* @Author           : RaptorX <graptorx@gmail.com>
		* @Script Name      : Script Object
		* @Script Version   : 0.20.3
		* @Homepage         :
		*
		* @Creation Date    : November 09, 2020
		* @Modification Date: July 02, 2021
		* @Modification G.S.: November 27, 2021
		; @Description Modification G.S.: added field for GitHub-link, a Forum-link 
										and a credits-field, as well as a template 
										to quickly copy out into new scripts
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

		; Template
		; global script := {base         : script
		;                  ,name         : regexreplace(A_ScriptName, "\.\w+")
		;                  ,version      : "0.1.0"
		;                  ,author       : ""
		;                  ,email        : ""
		;                  ,credits      : ""
		;                  ,creditslink  : ""
		;                  ,crtdate      : ""
		;                  ,moddate      : ""
		;                  ,homepagetext : ""
		;                  ,homepagelink : ""
		;                  ,ghlink       : ""
		;                  ,ghtext 		 : ""
		;                  ,doclink      : ""
		;                  ,doctext		 : ""
		;                  ,forumlink    : ""
		;                  ,forumtext	 : ""
		;                  ,donateLink   : ""
		;                  ,resfolder    : A_ScriptDir "\res"
		;                  ,iconfile     : A_ScriptDir "\res\sct.ico"
		;                  ,configfile   : A_ScriptDir "\settings.ini"
		;                  ,configfolder : A_ScriptDir ""
		; 				   }

		class script
		{
			static DBG_NONE     := 0
				,DBG_ERRORS   := 1
				,DBG_WARNINGS := 2
				,DBG_VERBOSE  := 3

			static name         := ""
				,version      := ""
				,author       := ""
				,email        := ""
				,credits      := ""
				,creditslink  := ""
				,crtdate      := ""
				,moddate      := ""
				,homepagetext := ""
				,homepagelink := ""
				,ghlink		:= ""
				,ghtext 		:= ""
				,doclink      := ""
				,doctext		:= ""
				,forumlink 	:= ""
				,forumtext 	:= ""
				,resfolder    := ""
				,icon         := ""
				,config       := ""
				,systemID     := ""
				,dbgFile      := ""
				,dbgLevel     := this.DBG_NONE


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
						Should be a zip file that will be unzipped by the function

				Notes:
				The versioning file should only contain a version string and nothing else.
				The matching will be performed against a SemVer format and only the three
				major components will be taken into account.

				e.g. '1.0.0'

				For more information about SemVer and its specs click here: <https://semver.org/>
			*/
			Update(vfile, rfile)
			{
				; Error Codes
				static ERR_INVALIDVFILE := 1
				,ERR_INVALIDRFILE       := 2
				,ERR_NOCONNECT          := 3
				,ERR_NORESPONSE         := 4
				,ERR_INVALIDVER         := 5
				,ERR_CURRENTVER         := 6
				,ERR_MSGTIMEOUT         := 7
				,ERR_USRCANCEL          := 8

				; A URL is expected in this parameter, we just perform a basic check
				; TODO make a more robust match
				if (!regexmatch(vfile, "^((?:http(?:s)?|ftp):\/\/)?((?:[a-z0-9_\-]+\.)+.*$)"))
					throw {code: ERR_INVALIDVFILE, msg: "Invalid URL`n`nThe version file parameter must point to a 	valid URL."}

				; This function expects a ZIP file
				if (!regexmatch(rfile, "\.zip"))
					throw {code: ERR_INVALIDRFILE, msg: "Invalid Zip`n`nThe remote file parameter must point to a zip file."}

				; Check if we are connected to the internet
				http := comobjcreate("WinHttp.WinHttpRequest.5.1")
				http.Open("GET", "https://www.google.com", true)
				http.Send()
				try
					http.WaitForResponse(1)
				catch e
					throw {code: ERR_NOCONNECT, msg: e.message}

				Progress, 50, 50/100, % "Checking for updates", % "Updating"

				; Download remote version file
				http.Open("GET", vfile, true)
				http.Send(), http.WaitForResponse()

				if !(http.responseText)
				{
					Progress, OFF
					throw {code: ERR_NORESPONSE, msg: "There was an error trying to download the ZIP file.`n"
													. "The server did not respond."}
				}
				regexmatch(this.version, "\d+\.\d+\.\d+", loVersion)
				regexmatch(http.responseText, "\d+\.\d+\.\d+", remVersion)

				Progress, 100, 100/100, % "Checking for updates", % "Updating"
				sleep 500 	; allow progress to update
				Progress, OFF

				; Make sure SemVer is used
				if (!loVersion || !remVersion)
					throw {code: ERR_INVALIDVER, msg: "Invalid version.`nThis function works with SemVer. "
													. "For more information refer to the documentation in the function"}

				; Compare against current stated version
				ver1 := strsplit(loVersion, ".")
				ver2 := strsplit(remVersion, ".")

				for i1,num1 in ver1
				{
					for i2,num2 in ver2
					{
						if (newversion)
							break

						if (i1 == i2)
							if (num2 > num1)
							{
								newversion := true
								break
							}
							else
								newversion := false
					}
				}

				if (!newversion)
					throw {code: ERR_CURRENTVER, msg: "You are using the latest version"}
				else
				{
					; If new version ask user what to do
					; Yes/No | Icon Question | System Modal
					msgbox % 0x4 + 0x20 + 0x1000
						, % "New Update Available"
						, % "There is a new update available for this application.`n"
						. "Do you wish to upgrade to v" remVersion "?"
						, 10	; timeout

					ifmsgbox timeout
						throw {code: ERR_MSGTIMEOUT, msg: "The Message Box timed out."}
					ifmsgbox no
						throw {code: ERR_USRCANCEL, msg: "The user pressed the cancel button."}

					; Create temporal dirs
					ghubname := (InStr(rfile, "github") ? regexreplace(a_scriptname, "\..*$") "-latest\" : "")
					filecreatedir % tmpDir := a_temp "\" regexreplace(a_scriptname, "\..*$")
					filecreatedir % zipDir := tmpDir "\uzip"

					; Create lock file
					fileappend % a_now, % lockFile := tmpDir "\lock"

					; Download zip file
					urldownloadtofile % rfile, % tmpDir "\temp.zip"

					; Extract zip file to temporal folder
					oShell := ComObjCreate("Shell.Application")
					oDir := oShell.NameSpace(zipDir), oZip := oShell.NameSpace(tmpDir "\temp.zip")
					oDir.CopyHere(oZip.Items), oShell := oDir := oZip := ""

					filedelete % tmpDir "\temp.zip"

					/*
					******************************************************
					* Wait for lock file to be released
					* Copy all files to current script directory
					* Cleanup temporal files
					* Run main script
					* EOF
					*******************************************************
					*/
					if (a_iscompiled){
						tmpBatch =
						(Ltrim
							:lock
							if not exist "%lockFile%" goto continue
							timeout /t 10
							goto lock
							:continue

							xcopy "%zipDir%\%ghubname%*.*" "%a_scriptdir%\" /E /C /I /Q /R /K /Y
							if exist "%a_scriptfullpath%" cmd /C "%a_scriptfullpath%"

							cmd /C "rmdir "%tmpDir%" /S /Q"
							exit
						)
						fileappend % tmpBatch, % tmpDir "\update.bat"
						run % a_comspec " /c """ tmpDir "\update.bat""",, hide
					}
					else
					{
						tmpScript =
						(Ltrim
							while (fileExist("%lockFile%"))
								sleep 10

							FileCopyDir %zipDir%\%ghubname%, %a_scriptdir%, true
							FileRemoveDir %tmpDir%, true

							if (fileExist("%a_scriptfullpath%"))
								run %a_scriptfullpath%
							else
								msgbox `% 0x10 + 0x1000
									, `% "Update Error"
									, `% "There was an error while running the updated version.``n"
										. "Try to run the program manually."
									,  10
								exitapp
						)
						fileappend % tmpScript, % tmpDir "\update.ahk"
						run % a_ahkpath " " tmpDir "\update.ahk"
					}
					filedelete % lockFile
					exitapp
				}
			}

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
			Autostart(status)
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

			/**
				Function: Splash
				Shows a custom image as a splash screen with a simple fading animation

				Parameters:
				img   (opt) - file to be displayed
				speed (opt) - fast the fading animation will be. Higher value is faster.
				pause (opt) - long in seconds the image will be paused after fully displayed.
			*/
			Splash(img:="", speed:=10, pause:=2)
			{
				global

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
			Debug(level:=1, label:=">", msg:="", vars*)
			{
				if !this.dbglevel
					return

				for i,var in vars
					varline .= "|" var

				dbgMessage := label ">" msg "`n" varline

				if (level <= this.dbglevel)
					outputdebug % dbgMessage
				if (this.dbgFile)
					FileAppend, % dbgMessage, % this.dbgFile
			}

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
			About(scriptName:="", version:="", author:="",credits:="", homepagetext:="", homepagelink:="", donateLink:="", email:="")
			{
				static doc

				scriptName := scriptName ? scriptName : this.name
				version := version ? version : this.version
				author := author ? author : this.author
				credits := credits ? credits : this.credits
				creditslink := creditslink ? creditslink : RegExReplace(this.creditslink, "http(s)?:\/\/")
				ghtext := ghtext ? ghtext : RegExReplace(this.ghtext, "http(s)?:\/\/")
				ghlink := ghlink ? ghlink : RegExReplace(this.ghlink, "http(s)?:\/\/")
				doctext := doctext ? doctext : RegExReplace(this.doctext, "http(s)?:\/\/")
				doclink := doclink ? doclink : RegExReplace(this.doclink, "http(s)?:\/\/")
				forumtext := forumtext ? forumtext : RegExReplace(this.forumtext, "http(s)?:\/\/")
				forumlink := forumlink ? forumlink : RegExReplace(this.forumlink, "http(s)?:\/\/")
				homepagetext := homepagetext ? homepagetext : RegExReplace(this.homepagetext, "http(s)?:\/\/")
				homepagelink := homepagelink ? homepagelink : RegExReplace(this.homepagelink, "http(s)?:\/\/")
				donateLink := donateLink ? donateLink : RegExReplace(this.donateLink, "http(s)?:\/\/")
				email := email ? email : this.email

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
				if creditslink and credits
				{
					; Clipboard:=html
					sTmp=
					(

								<p>credits: <a href="https://%creditslink%" target="_blank">%credits%</a></p>
								<hr>
					)
					html.=sTmp
				}
				if forumlink and forumtext
				{
					sTmp=
					(

								<p><a href="https://%forumlink%" target="_blank">%forumtext%</a></p>
					)
					html.=sTmp
				}
				if homepagelink and homepagetext
				{
					sTmp=
					(

								<p><a href="https://%homepagelink%" target="_blank">%homepagetext%</a></p>

					)
					html.=sTmp
				}
				sTmp=
				(

										</div>
							%donateSection%
						</body>
					</html>
				)
				html.=sTmp
				; Clipboard:=html
				; html.= "`n
				; (
				; 	HEllo World
				; )"
				; Clipboard:=html
				btnxPos := 300/2 - 75/2
				axHight:=12
				donateHeight := donateLink ? 6 : 0
				forumHeight := forumlink ? 1 : 0
				ghHeight := ghlink ? 1 : 0
				creditsHeight := creditslink ? 1 : 0
				homepageHeight := homepagelink ? 1 : 0
				docHeight := doclink ? 1 : 0
				axHight+=donateHeight
				axHight+=forumHeight
				axHight+=ghHeight
				axHight+=creditsHeight
				axHight+=homepageHeight
				axHight+=docHeight
				gui aboutScript:new, +alwaysontop +toolwindow, % "About " this.name
				gui margin, 2
				gui color, white
				gui add, activex, w300 r%axHight% vdoc, htmlFile
				gui add, button, w75 x%btnxPos% gaboutClose, % "&Close"
				doc.write(html)
				gui show, AutoSize
				return

				aboutClose:
					gui aboutScript:destroy
				return
			}

			/*
				Function: GetLicense
				Parameters:
				Notes:
			*/
			GetLicense()
			{
				global

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

			/*
				Function: SaveLicense
				Parameters:
				Notes:
			*/
			SaveLicense(licenseType, licenseNumber)
			{
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

			/*
				Function: IsLicenceValid
				Parameters:
				Notes:
			*/
			IsLicenceValid(licenseType, licenseNumber, URL)
			{
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

			/*
				Function: EDDRequest
				Parameters:
				Notes:
			*/
			EDDRequest(URL, Action, licenseType, licenseNumber)
			{
				strQuery := url "?edd_action=" Action
						.  "&item_id=" licenseType
						.  "&license=" licenseNumber
						.  (this.systemID ? "&url=" this.systemID : "")

				try
				{
					http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
					http.Open("GET", strQuery)
					http.SetRequestHeader("Pragma", "no-cache")
					http.SetRequestHeader("Cache-Control", "no-cache, no-store")
					http.SetRequestHeader("User-Agent", "Mozilla/4.0 (compatible; Win32)")

					http.Send()
					http.WaitForResponse()

					return http.responseText
				}
				catch err
					return err.what ":`n" err.message
			}

			; Activate()
			; 	{
			; 	strQuery := this.strEddRootUrl . "?edd_action=activate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
			; 	strJSON := Url2Var(strQuery)
			; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
			; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
			; 	return JSON.parse(strJSON)
			; 	}
			; Deactivate()
			; 	{
			; 	Loop, Parse, % "/|", |
			; 	{
			; 	strQuery := this.strEddRootUrl . "?edd_action=deactivate_license&item_id=" . this.strRequestedProductId . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId . A_LoopField
			; 	strJSON := Url2Var(strQuery)
			; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
			; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
			; 	this.oLicense := JSON.parse(strJSON)
			; 	if (this.oLicense.success)
			; 	break
			; 	}
			; 	}
			; GetVersion()
			; 	{
			; 	strQuery := this.strEddRootUrl . "?edd_action=get_version&item_id=" . this.oLicense.item_id . "&license=" . this.strEddLicense . "&url=" . this.strUniqueSystemId
			; 	strJSON := Url2Var(strQuery)
			; 	Diag(A_ThisFunc . " strQuery", strQuery, "")
			; 	Diag(A_ThisFunc . " strJSON", strJSON, "")
			; 	return JSON.parse(strJSON)
			; 	}
			; RenewLink()
			; 	{
			; 	strUrl := this.strEddRootUrl . "checkout/?edd_license_key=" . this.strEddLicense . "&download_id=" . this.oLicense.item_id
			; 	Diag(A_ThisFunc . " strUrl", strUrl, "")
			; 	return strUrl
			; 	}
			

			licenseButtonSave(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
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
				
		}
	BlockInput,On
	SysGet, Size, MonitorWorkArea
	SysGet, vMonCount,Monitorcount
	SetTitleMatchMode, 2 
	global script := { base : script
		,name : regexreplace(A_ScriptName, "\.\w+")
		,version : "2.13.1"
		,author : "Gewerd Strauss"
		,authorlink : ""
		,email : "csa-07@freenet.de"
		,credits : "AfterLemon"
		,creditslink : "https://www.autohotkey.com/board/topic/93997-list-all-ahk-scripts-in-directory-in-Gui/"
		,crtdate : "30.05.2013"
		,moddate : "06.07.2022"
		,homepagetext : ""
		,homepagelink : ""
		,ghtext 	 : "My GitHub"
		,ghlink		 : "https://github.com/Gewerd-Strauss"
		,doctext : "Documentation"
		,doclink	 : "https://github.com/Gewerd-Strauss/ScriptLauncher#scriptlauncher---first-startup"
		,forumtext 	 : ""
		,forumlink	 : ""
		,donateLink : ""
		;~ ,resfolder    : A_ScriptDir "\res"
		;~ ,iconfile     : A_ScriptDir "\res\sct.ico"
		,configfile : regexreplace(A_ScriptName, "\.\w+") ".ini"
		,configfolder : A_ScriptDir "\INI-Files\"
		,vAHK	 : A_AhkVersion}	
	
	vTimeTillReload:=1000*60*5
	
	ButtonWidth:=180 ; Can change these values
	IndentFromRight:=230
	;	
	XButtonXCoord:=ButtonWidth + 10 ; Don't change these
	XButtonXCoord2:=ButtonWidth+35
	TitleWidth:=ButtonWidth - 3*20 - 5
	SceneWidth:=ButtonWidth + 35 
	;
	GuiRight:=SizeRight - IndentFromRight - SceneWidth
	Button_Right:=SizeRight - IndentFromRight - SceneWidth
	Button_Bottom:=SizeBottom - 39
	;
	Gui, 1: Color, cFFFFFF
	SetTitleMatchMode, RegEx
	DetectHiddenWindows, On ; Detect hidden windows
	
	; variable setup
	vPIDFileNameMatrix:=[]
	aFileNameArr:=[]
	aPathArr:=[]
	aPIDarr:=[]
	aPIDassarr:=[]
	aFolderPaths:=[]
	aButtonXClosedScripts:=[]
	bKillTrueRestoreFalse:=true
	Ind:=0

	global	EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts
	SplitPath, A_ScriptName,,,,A_ScriptNameNoExt
	if FileExist(sExcludes:=script.configfolder script.configfile) ;|| if FileExist()
	{
		aTemp:=fLoadSettings(sExcludes)
		IncludedFolders:=aTemp[1]
		IncludedScripts:=aTemp[2]
		ExcludedScripts:=aTemp[3]
		IniObj:=aTemp[4]
		if IniObj["Script Behaviour Settings"].bAddSuspendButtons
			SceneWidth+=25
		aTemp:=[] ; clear array again
	}
	else
	{
		DefFileTemplate:="[Insert Folders to INCLUDE below]`n[Insert Script-Names of Scripts in added Folders to Exclude below]`n[Insert Paths to Scripts to INCLUDE below]`n[Script Behaviour Settings]`nbShowTooltips=1`nbHideOnLaunchScript=0`nbHideOnEditScript=1`nbHideOnOpenFolder=1`nbHideOnKillScript=0`nbHideOnSettingsOpened=1`nbAddSuspendButtons=1"
		FileAppend, %DefFileTemplate%,%sExcludes%
	}
	aTemp:=f_CreateFileNameAndPathArrays(IncludedFolders,IncludedScripts,aFolderPaths,aPathArr,aFileNameArr,ExcludedScripts)
	aPathArr:=aTemp[1]
	aFileNameArr:=aTemp[2]
 	aTemp:=[]
	global aAllowedToBeClosedClasses:=["AutoHotkey","AutoHotkeyGUI"] ; make sure we don't accidentally kill editors/IDEs
	f_SortArrays()

	;; Sorting must be done by this point, because we start adding buttons now
	Ind:=0
	aPIDarr:=[]
	for k,v in aPathArr
	{
		{
			YPos:=k*25-20
			Gui, 1: Add, Button, w%ButtonWidth% h20 x5 y%YPos% gRun hwndRunBtn%Ind%, % aFileNameArr[k]
			if IniObj["Script Behaviour Settings"].bShowTooltips
				AddToolTip(RunBtn%Ind% ,"Run " aFileNameArr[K])

			SetTitleMatchMode, 2
			WinGetTitle, T,% v
			WinGet,PID_T,PID,% T
			
			gosub, GetProgRunMatrix2
			Ind++
			if % aEnableKillButton[k]
			{
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% glKillScript , K
				if IniObj["Script Behaviour Settings"].bAddSuspendButtons
					Gui, 1: Add, BUtton, w20 h20 x%XButtonXCoord2% vSusButton%Ind% hwndSusBtn%Ind% y%YPos% glSusScript , S
				if IniObj["Script Behaviour Settings"].bShowTooltips
				{
					AddToolTip(KillBtn%Ind% ,"Kill " aFileNameArr[K])
					if IniObj["Script Behaviour Settings"].bAddSuspendButtons
						AddToolTip(SusBtn%Ind% ,"Suspend " aFileNameArr[K])
				}
				aPIDarr[k]:=PID_T ; "," PID_T2 "," PID_RGX "," PID_k "," PID_k_c "," PID_WinGetCleanEX 
				aPIDassarr[aFileNameArr[k]]:=PID_T
			}
			else
			{
				Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% vKillButton%Ind% hwndKillBtn%Ind% y%YPos% glKillScript disabled , K
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
	ButtonE_Ind:=Ind*3+2
	ButtonD_Ind:=Ind*3+3
	ButtonR_Ind:=Ind*3+4
	ButtonO_Ind:=Ind*3+5
	ButtonS_Ind:=Ind*3+6
	ButtonQ_Ind:=Ind*3+7
	ButtonX_Ind:=Ind*3+8
	ButtonF_Ind:=Ind*3+9
	DetectHiddenWindows, Off ; Detect hidden windows
	SetTitleMatchMode, 2
	YPos += 50
	GuiBottom:=SizeBottom - YPos
	TitlePos:=YPos - 21
	ButtonPos:=YPos - 25
	Gui, 1: Font, w700 c000000
	; Gui, 1: Add, Text, w%TitleWidth% h20 x35 y%TitlePos% Center gDrag, Scripts
	Gui, 1: Font, c000000
	Gui, 1: Add, Button, w20 h20 x5 y%ButtonPos% HwndButtonMHwnd, &M
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonEHwnd, &E
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonDHwnd, &D
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonRHwnd, &R
	Gui, 1: Add, Text, w40 h20 xp+20 y%TitlePos% gDrag, Scripts
	vRightEdgeofTitle:=TitleWidth+20
	Gui, 1: Add, Button, w20 h20 xp+40 y%ButtonPos% HwndButtonOHwnd, &O
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonSHwnd, &S
	Gui, 1: Add, Button, w20 h20 xp+20 y%ButtonPos% HwndButtonQHwnd, &?
	Gui, 1: Add, Button, w20 h20 x%XButtonXCoord% y%ButtonPos% HwndButtonXHwnd, &X
	if IniObj["Script Behaviour Settings"].bAddSuspendButtons
		Gui, 1: Add, Button, w20 h20 x%XButtonXCoord2% y%ButtonPos% HwndButtonFHwnd, &F
	Gui, 1: +AlwaysOnTop -Caption +ToolWindow +Border
	if IniObj["Script Behaviour Settings"].bShowTooltips
	{
		AddToolTip(ButtonMHwnd,"Minimise GUI")
		AddToolTip(ButtonEHwnd,"Edit Launcher")
		AddToolTip(ButtonDHwnd,"Open Launcher Directory")
		AddToolTip(ButtonRHwnd,"Reload Launcher")
		AddToolTip(ButtonSHwnd,"Swap Editors")
		AddToolTip(ButtonOHwnd,"Open Settings-file")
		AddToolTip(ButtonXHwnd,"Kill All Scripts")
		AddToolTip(ButtonQHwnd,"About and docs")
		AddToolTip(ButtonFHwnd,"Freeze/suspend all scripts")
	}
	BlockInput,Off
	gosub, lEditorSwapper
	return

	!Sc029::			; show script menu
	if WinExist("Main Window")
		Gui, 1: Cancel ;reload ;WinClose ;MsgBox, window active, lets minimise it
	else
		gosub, 2Button+
	return
	#IfWinActive, About AHK ScriptLauncher
	Esc:: gui, 1: cancel
	Drag:
	PostMessage, 0xA1, 2,,, A
	return

	Run:
	Loop
	{
		if (A_GuiControl=aFileNameArr[A_Index])
		{
			path:=aPathArr[A_Index]
			IF GetKeystate("LControl") ; open script in currently set editor
			{
				global EditorPath:="C:\Users\" A_UserName "\AppData\Local\Programs\Microsoft VS Code\Code.exe" ; set the path to your preferred editor when opening scripts || global just cuz copied in from elsewhere. It's a label, so it shouldn't matter anyways.
				EnvGet, LocalAppData, LOCALAPPDATA
				; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(path)
				fEditScript(path,LocalAppData)
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
			if (Path==A_ScriptDir "/INI-Files/" A_ScriptNameNoExt ".ini")
			{
				MsgBox, % "No Paths set to be read. Please first set a path to a specified file or folder in the respective section of the following settings file."
				run, % Path
				if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened
					Gui, 1: cancel
				return
			}
			Run, Autohotkey.exe "%Path%",	,	,PID
			aPIDarr[A_Index]:=PID
			aPIDassarr[A_GuiControl]:=PID
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
			break
		}
	}
	until (aPathArr.MaxIndex()<=A_Index)
	return
	
	lSuspend:
	suspend
	return

	lReload:
	reload
	lUpdateSettings:
	loop
	{
		; this got to be the jankiest solution to the problem I could think of probably.
	}
	until !WinExist(sEditingOptionsTitle)
	reload
	return

	GetProgRunMatrix2:
	DetectHiddenWindows, On
	WinGet, List, List, ahk_class AutoHotkey
	aEnableKillButton:=[]
	aRunningPaths:=[]
	Loop % List 
	{
		WinGetTitle, title, % "ahk_id" List%A_Index%
		aRunningPaths.push(RegExReplace(title, " - AutoHotkey v[\.0-9]+$")) ; collect all running autohotkey windows, regardless of origin
	}
	for s,w in aPathArr
	{
		if HasVal(aRunningPaths,w) ; check if any path in observed folders is active
			aEnableKillButton.push(1)
		else
			aEnableKillButton.push(0)
	}
	return

	lSusScript:
	{
		Index:=strsplit(A_GuiControl,"on").2 
		SusBtnNumber:=Index*3
		GuiControlGet, sStateCurrentScript,,Button%SusBtnNumber%
		sFileNameKill:=aFileNameArr[Index]
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


	lKillScript:
	{
		Index:=strsplit(A_GuiControl,"on").2 
		KillBtnNumber:=Index*3-1
		sFileNameKill:=aFileNameArr[Index]
		DetectHiddenWindows, On
		WinGetClass, cClass, % sFileNameKill ".ahk"
		if WinExist(sFileNameKill ".ahk") and HasVal(aAllowedToBeClosedClasses,cClass)
		{ ;A_GuiControl
			WinClose
			if WinExist(sFileNameKill ".ahk")
			{
				Process, Close, % sFileNameKill (Instr(sFileNameKill,".ahk")?:".ahk")	;; Killing via "FileName" doesn't work for some reason.
				Process, Close, % sFileNameKill											;; Killing via "FileName" doesn't work for some reason. || not sure if this is smart to leave out the .ahk. Could this kill editors? 
				if WinExist(sFileNameKill ".ahk")
					Process, Close, % aPIDarr[Index]
			}
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
	}
	return
		
	ButtonO:
	{
		run, % A_ScriptDir "/INI-Files/" A_ScriptNameNoExt ".ini"
		if IniObj["Script Behaviour Settings"].bHideOnSettingsOpened
			GUI, 1: hide
		sleep, 700
		WinGetActiveTitle, sEditingOptionsTitle
		gosub, lUpdateSettings
	}
	return

	ButtonS:
	{
		Gui,1: hide
		gosub,lShowGuiSwapper
	}
	return
	Button?:
	{
		Gui,1: hide
		script.about()
	}
	return

	GuiEscape:
	ButtonM:
	Gui, 1: Cancel
	return
	
	2Button+:
	{
		gosub, GetProgRunMatrix2
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
		if (Source="lCheckButtons")
		{
			Source:=""
			return
		}
		Source:=""
		;; Handle 2 monitors.
		CurrentMOnitor:=MWAGetMonitor()
		CurrentMonitor:=CurrentMonitor+0
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
			PositionYGui:=MonWBottom-(ButtonPos+25)
		else 
			PositionYGui:=MouseY
		
		if ((MouseX+SceneWidth)>MonRight)
			PositionXGui:=MonRight-SceneWidth
		Else
			PositionXGui:=MouseX
		
		Gui, 1: Show, w%SceneWidth% h%YPos% x%PositionXGui% y%PositionYGui% Hide, Main Window 
		guicontrol, focus, Button%ButtonM_Ind%
		Settimer, lCheckButtons,100
		WinGetPos X, Y, Width, Height, Main Window
		Gui, 1: Show
	}
	return

	lCheckButtons:
	if !WinExist("Main Window") ;; window not visible anymore, so stop the timer
		Settimer, lCheckButtons, off
	Source:=A_ThisLabel		;; return out of the '2Button+'-subroutine earlier if coming from this label.
	gosub, 2Button+
	return

	ButtonF:
	{
		for k,v in aFileNameArr
		{
			DetectHiddenWindows, On
			if WinExist(v ".ahk") ;and HasVal(aAllowedToBeClosedClasses,cClass)
			{
				str:=v ".ahk - AutoHotkey"
				PostMessage, 0x111, 65305,,, %str%   ; Suspend.
			}
			DetectHiddenWindows, Off
		}
	}
	return

	; A_ThisLabel
	ButtonX:
	2ButtonX:
	{
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
	}
	return

	ButtonE:
	{
		EnvGet, LocalAppData, LOCALAPPDATA
		fEditScript(A_ScriptFullPath,LocalAppData)
		; run, % "C:\Users\Claudius Main\AppData\Local\Programs\Microsoft VS Code\Code.exe" A_Space Quote(A_ScriptFullPath)
		; Run % LocalAppData "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(A_ScriptFullPath)
		; GUI, 1: hide
	}
	return
	ButtonD:
	{
		run, % A_ScriptDir
		Gui,1: hide
	}
	return
	ButtonR:
	reload
	return
	fEditScript(ScriptPath,LocalAppData)
	{
		run, % "C:\Users\Claudius Main\AppData\Local\Programs\Microsoft VS Code\Code.exe" A_Space Quote(ScriptPath)
		Run, % LocalAppData 						 "\Programs\Microsoft VS Code\Code.exe" A_Space Quote(ScriptPath)
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
	
	f_SortArrays()
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
	}

	f_CreateFileNameAndPathArrays(IncludedFolders,IncludedScripts,aFolderPaths,aPathArr,aFileNameArr,ExcludedScripts)
	{
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
	
	WinGetAll(Which="Title", DetectHidden="Off")
	{ ; code retrieved from heresy on the old ahk forums | https://www.autohotkey.com/board/topic/30323-wingetall-get-all-windows-titleclasspidprocess-name/
		O_DHW := A_DetectHiddenWindows, O_BL := A_BatchLines ;Save original states
		DetectHiddenWindows, % (DetectHidden != "off" && DetectHidden) ? "on" : "off"
		SetBatchLines, -1
		WinGet, all, list ;get all hwnd
		If (Which="Title") ;return Window Titles
		{
			Loop, %all%
			{
				WinGetTitle, WTitle, % "ahk_id " all%A_Index%
				If WTitle ;Prevent to get blank titles
					Output .= WTitle "`n" 
			}
		}
		Else If (Which="Process") ;return Process Names
		{
			Loop, %all%
			{
				WinGet, PName, ProcessName, % "ahk_id " all%A_Index%
				Output .= PName "`n"
			}
		}
		Else If (Which="Class") ;return Window Classes
		{
			Loop, %all%
			{
				WinGetClass, WClass, % "ahk_id " all%A_Index%
				Output .= WClass "`n"
			}
		}
		Else If (Which="hwnd") ;return Window Handles (Unique ID)
		{
			Loop, %all%
				Output .= all%A_Index% "`n"
		}
		Else If (Which="PID") ;return Process Identifiers
		{
			Loop, %all%
			{
				WinGet, PID, PID, % "ahk_id " all%A_Index%
				Output .= PID "`n" 
			}
			Sort, Output, U N ;numeric order and remove duplicates
		}
		DetectHiddenWindows, %O_DHW% ;back to original state
		SetBatchLines, %O_BL% ;back to original state
		Sort, Output, U ;remove duplicates
		return Output
	}

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
	/*
		;~ Do Not Change From Here
		Move_RemoveClosedScriptsIcons(Actions*)
		{
			static Ptr:=A_PtrSize?"UPtr":"UInt",PtrP:=Ptr "*",MyFunc
			static x32:="5589E557565383EC348B7D388B47048945CC8B47088945C88B470C8945EC8B47108945E48B45EC8945D43B45E47D068B45E48945D431C03B453C0F8D910000008B1C878B4C8704C745D000000000C745D800000000895DF08B5C8708894DE08B4DF0895DC4894DE8894DDC8B75C43975D87D568B75DC03752C31C98975C03B4DE07D2F8B75D08B5DC001CE803C0B3175118B55F08B5D3089349389D343895DF0EB0D8B55E88B5D34893493428955E841EBCC8B4DE085C9790231C98B5D20014DDCFF45D8015DD0EBA283C007E966FFFFFF8B45088B5D2040C1E0078945E085DB790231DB8D049D00000000C745E80000000031FF8945DCC745F0000000008B45E83B45247D4A8B45288B55F031C903551401F88945D83B4D207D280FB642026BF0260FB642016BC04B01F00FB6326BF60F01F03B45E08B45D80F9204084183C204EBD38B4DDC01DF014DF0FF45E8EBAE8B45202B45CCC745DC000000008945D88B55188B452403550CC745F0000000002B45C88955CC8945D08B451C034510C1E0108945E031C08B4DD0394DF00F8F9200000031C93B4DD87F748B7DDC8D14398955E831D28B75E80375283B55D47D273B55EC7D0D8B5D308B3C9301F7803F0175493B55E47D0D8B5D348B3C9301F7803F00753742EBD48B7DCC8D50018D340F8B7D400B75E08934873B55447D358B5DE831C0035D283B45EC7D0E8B7D308B34874001DEC60600EBED89D041EB878B4D20FF45F08145E000000100014DDCE964FFFFFF89D083C4345B5E5F5DC2400090"
			static x64:="4157415641554154555756534883EC28488B8424D00000008B5804895424788B780C894C2470895C24108B5808897C2408895C24148B581039DF89DF895C240C0F4D7C240831D2897C2418399424D80000000F8E8E000000448B14904531E431DB8B7C90088B6C90044489D6897C241C4489D73B5C241C7D644C63EE4C03AC24B80000004531DB4439DD7E3643807C1D0031478D341C7514488B8C24C00000004D63FA41FFC2468934B9EB11488B8C24C80000004C63FFFFC7468934B949FFC3EBC585ED41BB00000000440F49DDFFC34403A424A00000004401DEEB964883C207E965FFFFFF8B44247041BB000000008D4801C1E10783BC24A000000000440F499C24A000000031ED31F631FF468D2C9D000000003BAC24A80000007D554863DE48039C24B00000004863C74531D24C01C844399424A00000007E2D0FB65002446BE2260FB650016BD24B4401E2440FB620456BE40F4401E239CA420F92041349FFC24883C004EBC94401EF4401DEFFC5EBA244038424980000004531DB31C04531D28BBC24A00000008BAC24A80000008B9424900000002B7C241041C1E0102B6C2414035424784139EA0F8FDB0000004531C94139F90F8FB6000000438D1C1931C9394C24184189CC7E52394C24087E204C8BB424C00000004C8BBC24B0000000418B348E01DE4863F641803C37017579443964240C7E204C8BB424C80000004C8BBC24B0000000418B348E01DE4863F641803C3700755248FFC1EBA5428D340A4C8BB424E00000008D48014409C63B8C24E8000000418934867D4D31C0394424087E234C8BBC24C00000004C8BB424B0000000418B348748FFC001DE4863F641C6043600EBD74863C141FFC1E941FFFFFF41FFC24181C00000010044039C24A0000000E91EFFFFFF89C84883C4285B5E5F5D415C415D415E415FC3909090"
			;~ Do Not Remove This Line
			BCH:=A_BatchLines,Mode:=A_TitleMatchMode,CoordMode:=A_CoordModeMouse
			SetTitleMatchMode,2
			Setbatchlines,-1
			CoordMode,Mouse,Screen
			for a,b in Actions{
				Bits:=b.Bits
				for c,d in StrSplit("0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
					i:=c-1,Bits:=RegExReplace(Bits,"\Q" d "\E",(i>>5&1)(i>>4&1)(i>>3&1)(i>>2&1)(i>>1&1)(i&1))
				Bits:=RegExReplace(SubStr(Bits,1,InStr(s,"1",0,0)-1),"[^01]+"),Info:=[b.W,b.H,b.Threshold,b.Ones,b.Zeros,b.Match+0?b.Match:"100"],All:=[]
				if(b.Type="Window"){
					End:=(Start:=A_TickCount)+(b.WindowWait*1000)
					while(A_TickCount<End){
						if(WinExist(b.Area))
							Continue,2
						Sleep,100
					}Error:="Unable to find Window " """" b.Area """"
					Goto,PA_Exit
				}End:=(Start:=A_TickCount)+(b.WindowWait*1000)
				while(A_TickCount<End){
					if(WinExist(b.Area)){
						WinGet,List,List,% b.Area
						Loop,% List{
							WinGetPos,X,Y,W,H,% "ahk_id" HWND:=List%A_Index%
							All.Push({X:X,Y:Y,W:W,H:H,HWND:HWND})
						}if(!All.1){
							Error:="Unable To Find Window:`n`n`t" Area
							Goto,PA_Exit
						}Goto,PA_NextStep
					}Sleep,100
				}if(!All.Count()){
					Error:="Unable to find Window " b.Area
					Goto,PA_Exit
				}
				PA_NextStep:
					End:=(Start:=A_TickCount)+(b.Wait*1000)
					while(A_TickCount<End){
						Arr:=[]
						for c,d in All{
							K:=StrLen(Bits)*4,VarSetCapacity(In,28),VarSetCapacity(SS,d.W*d.H),VarSetCapacity(S1,K),VarSetCapacity(S0,K),VarSetCapacity(AllPos,Info.6*4)
							for e,f in [0,Info.1,Info.2,Info.4,Info.5,0,0]
								NumPut(f,&In,4*(A_Index-1),"Int")
							Cap:=VarSetCapacity(Scan,d.W*d.H*4),Stride:=((d.W*32+31)//32)*4,Win:=DllCall("GetDesktopWindow",Ptr),HDC:=DllCall("GetWindowDC",Ptr,Win,Ptr),MDC:=DllCall("CreateCompatibleDC",Ptr,HDC,Ptr),VarSetCapacity(BI,40,0),NumPut(40,BI,0,Int),NumPut(d.W,BI,4,Int),NumPut(-d.H,BI,8,Int),NumPut(1,BI,12,"Short"),NumPut(32,BI,14,"Short")
							if(hBM:=DllCall("CreateDIBSection",Ptr,MDC,Ptr,&BI,Int,0,PtrP,PPVBits,Ptr,0,Int,0,Ptr))
								OBM:=DllCall("SelectObject",Ptr,MDC,Ptr,hBM,Ptr),DllCall("BitBlt",Ptr,MDC,Int,0,Int,0,Int,d.W,Int,d.H,Ptr,HDC,Int,X,Int,Y,UInt,0x00CC0020|0x40000000),DllCall("RtlMoveMemory",Ptr,&Scan,Ptr,PPVBits,Ptr,Stride*d.H),DllCall("SelectObject",Ptr,MDC,Ptr,OBM),DllCall("DeleteObject",Ptr,hBM)
							DllCall("DeleteDC",Ptr,MDC),DllCall("ReleaseDC",Ptr,Win,Ptr,HDC)
							if(!MyFunc){
								;CodeHere
								VarSetCapacity(MyFunc,Len:=StrLen(Hex:=A_PtrSize=8?x64:x32)//2)
								Loop,%Len%
									NumPut((Value:="0x" SubStr(Hex,2*A_Index-1,2)),MyFunc,A_Index-1,"UChar")
								DllCall("VirtualProtect",Ptr,&MyFunc,Ptr,Len,"Uint",0x40,PtrP,0)
							}OK:=DllCall(&MyFunc,"UInt",Info.3,"UInt",d.X,"UInt",d.Y,Ptr,&Scan,"Int",0,"Int",0,"Int",d.W,"Int",d.H,Ptr,&SS,"AStr",Bits,Ptr,&S1,Ptr,&S0,Ptr,&In,"Int",7,Ptr,&AllPos,"Int",Info.6),Arr:=[]
							Loop,%OK%{
								if(Arr.Count()>=b.Match)
									Break,3
								Arr.Push({X:(Pos:=NumGet(AllPos,4*(A_Index-1),"Int"))&0xFFFF,Y:Pos>>16,W:Info.1,H:Info.2,HWND:HWND,Action:Action})
							}Sleep,100
						}if(Arr.1)
						Break
						Sleep,100
					}if(b.Match="return")
				return Arr
				if(!Arr.1){
					Error:="Unable to find the Pixel Group"
					Goto,PA_Exit
				}if(!Obj:=Arr[b.Match]){
					Error:="Unable to find the " b.Match " occurrence."
					Goto,PA_Exit
				}WinGetPos,X,Y,,,% "ahk_id" Obj.HWND
				if(b.Type="InsertText"){
					Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y,CB:=ClipboardAll
					while(Clipboard!=b.Text){
						Clipboard:=b.Text
						Sleep,10
					}BlockInput,On
					ControlClick,%Pos%,% "ahk_id" Obj.HWND
					if(b.SelectAll){
						Sleep,50
						Send,^a
					}Sleep,50
					Send,^v
					BlockInput,Off
					Clipboard:=CB
					Sleep,100
				}else if(b.Type="Mouse"&&b.Action!="Move"){
					;********************restore mouse position***********************************
					if(b.RestorePOS)
						MouseGetPos,RestoreX,RestoreY
					if(b.Actual){
						MouseClick,Left,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY),% b.ClickCount ;Added b.clickcount by Joe as it was missing
						if(b.RestorePOS)
							MouseMove,% RestoreX,RestoreY ;change this to an if the thing was selected
					}else{
						Pos:="x" Obj.X+Round(b.OffSetX)-X " y" Obj.Y+Round(b.OffSetY)-Y
						ControlClick,%Pos%,% "ahk_id" Obj.HWND,,% b.Action,% b.ClickCount
					}
				}else if(b.Type="Mouse"&&b.Action="Move")
				MouseMove,% Obj.X+Round(b.OffSetX),% Obj.Y+Round(b.OffSetY)
			}
			PA_Exit:
				CoordMode,Mouse,%CoordMode%
				SetTitleMatchMode,%Mode%
				SetBatchLines,%BCH%
				if(A_ThisLabel="PA_Exit"){
					MsgBox,262144,Error,%Error%
					Exit
				}
			return "ahk_id" Obj.HWND
		}
		;~ To Here
*/
	;***************************************
	; Includes: 

	lEditorSwapper:

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
	RegRead, currentEditor, % "HKCU\SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command"
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
	lShowGuiSwapper:
	Gui,EditorList: Show
	return

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

	