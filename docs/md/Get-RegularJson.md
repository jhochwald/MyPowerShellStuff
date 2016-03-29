# Get-RegularJson
## SYNOPSIS
Converts a C# dumped JSON to regular JSON

## SYNTAX
```powershell
Get-RegularJson [-csjson] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
A detailed description of the Get-RegularJson function.

## PARAMETERS
### -csjson <String>
C# formated JSON (The one with mased characters)
```
Required?                    true
Position?                    1
Default value
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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
C:\PS>Get-RegularJson '{\"name\":\"John\", \"Age\":\"21\"}'

{"name":"John", "Age":"21"}
```



