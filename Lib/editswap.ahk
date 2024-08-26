
EditorSwapper()
{
    SplitPath A_ScriptName,,,,A_ScriptNameNoExt
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
    IniRead editHistory, %Configuration%, % "History"
    global currentEditor
    RegRead currentEditor, % "HKCU\SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command"
    global currentEditor2:=currentEditor
    If	(!InStr( FileExist(script.configfolder script.configfile),"D"))
    {
        FileCreateDir % script.configfolder
    }

    SplitPath currentEditor, currentEditorEXE,,, currentEditorName

    Gui EditorList:new
    Gui font, s12, SegoeUI
    Gui add, text, vCurrentEditorTitle, % "Current Editor: " format("{:T}", regexreplace(currentEditorEXE, "\s.*"))
    Gui add, text,, % "Previous Editors:"
    Gui font

    Gui add, listview, w600 Sort, % "Name|Path"
    Gui add, button, w75 x370 gSetEditor, % "Set Selected"
    Gui add, button, w75 x+10 gAddEditor, % "Add New"
    Gui add, button, w75 x+10 gEditorListGuiClose, % "Exit"

    if (editHistory != ""){
        editorlist := StrSplit(editHistory, "`n", "`r")
        for i,editor in editorlist{
            cEdit := StrSplit(editor, "=")
            LV_Add("", format("{:T}", cEdit[1]), cEdit[2])
        }
    }else{
        LV_Add("", format("{:T}", currentEditorName), currentEditor)

        IniWrite % currentEditor, %Configuration%, % "History", % currentEditorName
        IniWrite % currentEditor, %Configuration%, % "Current", % currentEditorName
    }

    LV_ModifyCol()
    return
}

fShowGuiSwapper()
{
    Gui EditorList: Show
    return
}

AddEditor(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
    FileSelectFile newEditorPath

    if (!newEditorPath){
        MsgBox % 0x10
            , % "Error"
            , % "No Editor was selected.`nExiting the app"
        return
    }

    saveEditor(newEditorPath " ""%1""")

    MsgBox % 0x40
        , % "Operation Complete"
        , % "New editor Saved correctly: " newEditorPath

    return
}

SetEditor(CtrlHwnd, GuiEvent, EventInfo, ErrLevel:="")
{
    Gui EditorList:Default

    row := LV_GetNext(0, "F")
    LV_GetText(sEditorPath, row, 2)
    LV_Delete(row)

    if (!sEditorPath){
        MsgBox % 0x10
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
    Gui EditorList:Default

    SplitPath newEditorPath, newEditorEXE,,, newEditorName
    newEditorEXE := StrReplace(newEditorEXE, " ""%1""")
    GuiControl move, CurrentEditorTitle, % "w" StrLen("Current Editor: " newEditorEXE)*8
    GuiControl,, CurrentEditorTitle, % "Current Editor: " format("{:T}", newEditorEXE)

    IniDelete %Configuration%, % "Current"
    IniWrite % newEditorPath, %Configuration%, % "Current", % newEditorName
    IniWrite % newEditorPath, %Configuration%, % "History", % newEditorName

    RegWrite % "REG_SZ", % "HKCU\SOFTWARE\Classes\AutoHotkeyScript\Shell\Edit\Command",, % newEditorPath

    LV_Add("", format("{:T}", newEditorName), newEditorPath)
    return
}

EditorListGuiClose:
EditorListGuiEscape:
;ExitApp, 0
reload
