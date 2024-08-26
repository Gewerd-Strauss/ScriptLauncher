
HasVal(haystack, needle)
{	; code from jNizM on the ahk forums: https://www.autohotkey.com/boards/viewtopic.php?p=109173&sid=e530e129dcf21e26636fec1865e3ee30#p109173
    if !(IsObject(haystack)) || (haystack.Length() = 0)
        return 0
    for index, value in haystack
        if (value = needle)
            return index
    return 0
}
