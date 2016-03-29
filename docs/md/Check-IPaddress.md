# Check-IPaddress
## SYNOPSIS
Check if a given IP Address seems to be valid

## SYNTAX
```powershell
Check-IPaddress [-IPAddress] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Check if a given IP Address seems to be valid.
We use the .NET function to do so. This is not 100% reliable,
but is enough most times.

## PARAMETERS
### -IPAddress <String>
An IP Address you want to check
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByPropertyName)
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
System.Boolean

## NOTES
This is just a little helper function to make the shell more flexible

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Check-IPaddress
```



