# ConvertTo-binhex
## SYNOPSIS
Convert a String to HEX

## SYNTAX
```powershell
ConvertTo-binhex [[-array] <Object>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Converts a given String or Array to HEX and dumps it

## PARAMETERS
### -array <Object>
Array that should be converted to HEX
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
PS C:\>ConvertTo-binhex 1234

# Return the HEX Value (4d2) of the String 1234
```



