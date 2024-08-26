
fReadINI(INI_File) ; return 2D-array from INI-file
{ ; Original File from https://www.autohotkey.com/boards/viewtopic.php?p=256714#p256714
    Result := []
    OrigWorkDir:=A_WorkingDir
    SetWorkingDir INI-Files
    IniRead SectionNames, %INI_File%
    for each, Section in StrSplit(SectionNames, "`n") {
        IniRead OutputVar_Section, %INI_File%, %Section%
        for each, Haystack in StrSplit(OutputVar_Section, "`n")
            RegExMatch(Haystack, "(.*?)=(.*)", $)
            , Result[Section, $1] := $2
    }
    if A_WorkingDir!=OrigWorkDir
        SetWorkingDir %OrigWorkDir%
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
