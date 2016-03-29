# ConvertTo-HumanReadable
## SYNOPSIS
Converts a given number to a more human readable format

## SYNTAX
```powershell
ConvertTo-HumanReadable [-num] <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Converts a given number to a more human readable format, it conerts 1024 to 1KB as example.

## PARAMETERS
### -num <Int64>
Input Number
```
Required?                    true
Position?                    1
Default value                0
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
PS C:\>ConvertTo-HumanReadable -num '1024'

1,0 KB
```

 
### EXAMPLE 2
```powershell
PS C:\>(Get-Item 'C:\scripts\PowerShell\profile.ps1').Length | ConvertTo-HumanReadable

25 KB

Get the Size of a File (C:\scripts\PowerShell\profile.ps1 in this case) and make it human understanable
```



