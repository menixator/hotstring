Dynamic Hotstrings Library
===
This library can be used to create dynamic hotstrings, either **with** or **without** regular expression.

###Syntax:

```
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
				
		- Label/Function/Replacement: A function or a label to execute or a text replacement.
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
```

###Example:
```autohotkey
#Include Hotstring.ahk

Hotstring("maths","mathemetics") ;Simple replacement.
Hotstring("ahk","autohotkey",1) ;Normal case sensitive replacement.
Hotstring("#now","%A_Now%") ;Will send %A_Now% as soon as #now is typed.
Hotstring("(a|A)faik","$1s far as I know.",3) ; Will check the case of the first character and use it in the replacement.
Hotstring("btw","btw") ; Goto the "btw" label instead of replacing it.
Hotstring("(\d+)\/(\d+)%", "percent",3) ; One of poly's examples
return


btw:
MsgBox You typed %$%. ;$ variable will contain exactly what the user typed in labels. Always keep in mind that $ is a global variable.
return
Return

percent:
p := Round($1 / $2 * 100)
Send, %p%`%
Return
```
