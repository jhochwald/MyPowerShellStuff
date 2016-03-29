# Check-SessionArch
## SYNOPSIS
Show the CPU architecture

## SYNTAX
```powershell
Check-SessionArch [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
You want to know if this is a 64BIT or still a 32BIT system?
Might be useful, maybe not!

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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Check-SessionArch

x64

Shows that the architecture is 64BIT and that the session also supports X64
```



