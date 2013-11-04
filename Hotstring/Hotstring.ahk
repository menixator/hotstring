/*
Hotstring(String/Regex,Label/Replacement/Function,Mode,Backscpace, Condition)
Function: Dynamic Hotstrings.
		- Dynamically add hotstrings.
		- Can be regular expressions.
		- Can run a label, function or do a text replacement when the hotstring is triggered.
		- Can be context sensitive.

Params:
		- String/Regex: Can be either a normal string or a regular expression.
				For regex to work, Mode should be set to 3.
				Subpatterns can be captured in regex mode.
				In regex mode, be sure to escape the necessary characters.
				
		- Label/Function/Replacement: What to do when the hotstring is triggered.
				If a label is not found, the script searches for a function with that name.
				If a function has also not been found, a replacement is done.
				The captured subpatters can be accessed with $n.$1 is the first subpattern, $2 is the second one and so on.
		
		- Mode: Can be either 0,1 or 2.
				Mode 0[Default]: Normal + Case insenstive.
				Mode 1: Normal + Case sensitive.
				Mode 2: Regex. (You can use the case insensitive "i)" with regex.)
		
		- Backspace: A boolean value that decides whether to delete the trigger.
				Can be either 0 or 1[Default] (or true[Default] or false)
				
		- Condition: Used to set context sensitive hotstrings.
				Everytime the hotstring is triggered, the Condition function is called.
				If the function returns true only, the hotstring is executed.
*/
Hotstring(string,label,Mode := 0,BS:=1, Func := ""){
	static typed := "",Keysbinded,hotstrings := {}
	global $
	Symbols := "!""#$%&'()*+,-./0123456789:;<=>?@[\]^_``{|}~" Alpha := "abcdefghijklmnopqrstuvwxyz",KeysThatMatter := "BS,Return,Tab,Space",breakChars := "Left,Right,Up,Down,Home,End,RButton,LButton,LControl,RControl,LAlt,RAlt,AppsKey,Lwin,Rwin,f1,f2,f3,f4,f5,f6,f7,f8,f9,f6,f7,f9,f10,f11,f12",NumpadButtons := "Numpad0,Numpad1,Numpad2,Numpad3,Numpad4,Numpad5,Numpad6,Numpad7,Numpad8,Numpad9,NumpadDot,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter"
	if (!Keysbinded){
		Loop,Parse,Alpha
			Hotkey,~*$%A_LoopField%,_____hotstring
		Loop,Parse,Symbols
			Hotkey,~$%A_LoopField%,_____hotstring
		Loop,Parse,KeysThatMatter,`,
			Hotkey,~*$%A_LoopField%,_____hotstring
		Loop,Parse,breakChars,`,
			Hotkey,~*$%A_LoopField%,_____hotstring
		Loop,Parse,NumpadButtons,`,
			Hotkey,~*$%A_LoopField%,_____hotstring
		Keysbinded := 1
	}
	if (string == "" && label == ""){

		;Remove modifiers.
		HK := RegExReplace(A_ThisHotkey,"~\*?\$")
		; Check if the uppercase version was intended.
		Shift := GetKeyState("CapsLock","T") && !GetKeyState("Shift","P") || !GetKeyState("CapsLock","T") && GetKeyState("Shift","P")
		if (Shift && Instr("abcdefghijklmnopqrstuvwxyz",HK)){
			StringUpper,HK,HK
		}
		
		if HK in %breakChars%
			typed := ""
		; If key in BS,Space,Tab
		else if (HK = "BS")
			StringTrimRight,typed,typed,1
		else if (HK = "Space")
			typed .= A_Space
		else if (HK = "Tab")
			typed .= "`t"
		else if HK in Enter,Return,NumpadEnter
			typed .= "`n"
		else if (RegExMatch(HK,"Numpad(.+?)$",np)){
			if (np1 ~= "\d")
				typed .= np1
			else {
				typed .= np1 == "Dot" ? "." : np1 == "Div" ? "/" : np1 == "Mult" ? "*" : np1 == "Add" ? "+" : np1 == "Sub" ? "-" : ""
			}
		} else
			typed .= HK
		
		for hotstring in hotstrings
		{
			Mode := hotstrings[hotstring].mode
			Label :=  hotstrings[hotstring].label
			Cond := hotstrings[hotstring].func
			If (IsFunc(Cond)){
				f_Cond := Func(Cond)
				if !f_Cond.()
					continue
			}
			if Mode in 0,1
			{
				if ( InstPos := Instr(typed,hotstring,Mode,0)){
					$ := hotstring
					toSend := Label
					typed := ""
					gosub, _____simplify
					}
			} else if (Mode == 3){
				if RegExMatch(typed,hotstring . "$",$){
					toSend := RegExReplace($,hotstring,label)
					typed := ""
					gosub, _____simplify
				}				
			}
		}
		if StrLen(typed) > 1500
			StringTrimLeft,typed,typed,750
	} else {
		if hotstrings.HasKey(string){
			hotstrings.Remove(string)
			return
		}
		hotstrings[string] := {}
		hotstrings[string].label := label
		hotstrings[string].func := Func
		hotstrings[string].mode := mode
	}
	return
	
	_____hotstring:
	Hotstring("","","")
	return
	
	_____simplify:
	toSend := RegExReplace(toSend,"([!#\+\^\{\}])","{$1}")
	if (BS)
		SendInput, % "{BS " . (Mode == 3 ? Strlen($) : Strlen(Hotstring)) . " }"
	If IsLabel(Label)
		gosub, %Label%
	else if (IsFunc(Label)){
		f := Func(Label)
		if (f.MinParams == 1){
			E := f.($)
		} else
			E := f.()
	} else {
	while regmatch := RegExMatch(toSend,"[^``](%([\w_]+)%)",Match, regmatch ? regmatch+StrLen(Match) : 1)
		StringReplace,toSend,toSend,%Match1%,% %Match2%
	SendInput %toSend%
	}
	return
}
