#Include Hotstring.ahk

Hotstring("maths","mathametics") ;Simple replacement.
Hotstring("ahk","autohotkey",1) ;Normal case sensitive replacement.
Hotstring("#now","%A_Now%") ;Will send %A_Now% as soon as #now is typed.
Hotstring("(a|A)faik","$1s far as I know.",3) ; Will check the case of the first character and use it in the replacement.
Hotstring("btw","btw") ; Goto the "btw" label instead of replacing it.
Hotstring("i)\b(red|orange|blue|green)\b","colors",3) ; will run the colors function.
Hotstring("(\d+)\/(\d+)%", "percent",3) ; One of poly's examples
Hotstring("np","this will work only in notepad.",,,"condition") ; Context sensitive hotkey . . Sortof.
return


btw:
MsgBox You typed %$%. ;$ variable will contain exactly what the user typed in labels. Always keep in mind that $ is a global variable.
return
Return

percent:
p := Round($1 / $2 * 100)
Send, %p%`%
Return

colors(choice){
	; The hotstrings will pass off what the user typed to the function, only if it has 1 or more parameter(s)
	MsgBox You chose %choice%
	return
}

condition(){
	;decides when to trigger the np hotstring.
	return, WinActive("ahk_class Notepad")
}
