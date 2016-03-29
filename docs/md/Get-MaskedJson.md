# Get-MaskedJson
## SYNOPSIS
Maks all special characters within a JSON File

## SYNTAX
```powershell
Get-MaskedJson [-json] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Maks all special characters within a JSON File.
mostly used with C# or some other windows tools.

## PARAMETERS
### -json <String>
Regular Formated JSON String or File
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
C:\PS>Get-MaskedJson '{"name":"John", "Age":"21"}'

{\"name\":\"John\", \"Age\":\"21\"}
```



