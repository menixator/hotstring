explorer := ComObjCreate("Shell.Application")

nameFormat := "New Folder" ;The script will first check if a folder with this name exists. If it doesn't this name will be used.
;Otherwise the fallbackFormat will be used.
fallbackFormat := "New Folder (%d)" ;%d is where the number goes.

#if Explorer_IsActive()
<^N::
window := "", path := "", createName := ""
window := Explorer_Get(explorer)
if (window.locationUrl == "" && window.locationName == "Computer"){
	return
} else {
	path := PathCreateFromUrl(window.locationUrl)
	if (!FileExist(path)){
		; a nearly impossible case.
		return
	} else {
		createName := Get_NextFileName(path, nameFormat,fallbackFormat)
		window.Document.Folder.NewFolder(createName)
		createdFolder := window.Document.Folder.parseName(createName)
		for item in window.Document.SelectedItems()
			window.Document.selectItem(item,0)
		window.Document.selectItem(createdFolder,3) ; edit
	}
}
return
#if

Explorer_Get(explorer){
	local activeHwnd := WinExist("A")
	
	for window in ComObjCreate("Shell.Application").Windows{
		if (window.Name == "Windows Internet Explorer")
			continue
		if (window.HWND == activeHwnd){
			return window
		}
	}
	return -1
}

Explorer_IsActive(){
	return Winactive("ahk_exe explorer.exe")
}

Get_NextFileName(path, pattern, fallbackPattern){
	path := RegExReplace(path, "\\$")
	if (!FileExist(path . "\" . pattern)){
		return pattern
	}
	Loop
	{
		searchName := RegExReplace(fallbackPattern, "%d", A_Index)
		searchPath := path . "\" . searchName
		if (!FileExist(searchPath)){
			return searchName
		}
	}
}

PathCreateFromUrl(Url){
	Size := VarSetCapacity(Output,260,0)
	DllCall("Shlwapi.dll\PathCreateFromUrl", "Ptr", &Url, "Ptr", &Output,"UInt*", &Size, "UInt",0)
	VarSetCapacity(Output,-1)
	return Output
}