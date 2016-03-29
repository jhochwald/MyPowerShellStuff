# Get-Pause
## SYNOPSIS
Wait for user to press any key

## SYNTAX
```powershell
Get-Pause [[-PauseMessage] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Shows a console message and waits for user to press any key.

Optional: The message to display could be set by a command line parameter.

## PARAMETERS
### -PauseMessage <String>
This optional parameter is the text that the function displays.
If this is not set, it uses a default text "Press any key..."
```
Required?                    false
Position?                    2
Default value                Press any key...
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -WhatIf <SwitchParameter>

```
Required?                    false
Position?                    named
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Confirm <SwitchParameter>

```
Required?                    false
Position?                    named
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```

## INPUTS


## OUTPUTS
System.String

## NOTES
PowerShell have no build in function like this

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>pause

Display a console message and wait for user to press any key.
It shows the default Text "Press any key..."
```

 
### EXAMPLE 2
```powershell
PS C:\>pause "Please press any key"

Display a console message and wait for user to press any key.
It shows the Text "Please press any key"
```

 
### EXAMPLE 3
```powershell
PS C:\>pause -PauseMessage "Please press any key"

Display a console message and wait for user to press any key.
It shows the Text "Please press any key"
```



