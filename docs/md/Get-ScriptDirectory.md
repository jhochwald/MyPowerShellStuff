# Get-ScriptDirectory
## SYNOPSIS
Get the Directory of the Script that invokes this function

## SYNTAX
```powershell
Get-ScriptDirectory [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the Directory of the Script that invokes this function

## PARAMETERS
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
Just a quick helper to reduce the script header overhead

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>.\test.ps1

C:\scripts\PowerShell
```



