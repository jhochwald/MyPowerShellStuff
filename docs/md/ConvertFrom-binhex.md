# ConvertFrom-binhex
## SYNOPSIS
Convert a HEX Value to a String

## SYNTAX
```powershell
ConvertFrom-binhex [[-binhex] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Converts a given HEX value back to human readable strings

## PARAMETERS
### -binhex <Object>

```
Required?                    false
Position?                    1
Default value
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
System.String

## NOTES
This is just a little helper function to make the shell more flexible

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertFrom-binhex 0c

# Return the regular Value (12) of the given HEX 0c
```



