Dynamic Hotstrings Library
===
This library can be used to create dynamic hotstrings, either **with** or **without** regular expression.

The sytax of the function is as follows:

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