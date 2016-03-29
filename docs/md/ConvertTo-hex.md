# ConvertTo-hex
## SYNOPSIS
Converts a given integer to HEX

## SYNTAX
```powershell
ConvertTo-hex [-dec] <Int64> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Converts any given Integer (INT) to Hex and dumps it to the Console

## PARAMETERS
### -dec <Int64>
N.A.
```
Required?                    true
Position?                    1
Default value                0
Accept pipeline input?       false
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
System.Int64

## NOTES
Renamed function
Just a little helper function

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertTo-hex "100"

0x64
```



