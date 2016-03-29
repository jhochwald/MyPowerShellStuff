# Get-Uptime
## SYNOPSIS
Show how long system has been running

## SYNTAX
```powershell
Get-Uptime [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uni* like Uptime - The uptime utility displays the current time,
the length of time the system has been up

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
Make PowerShell a bit more like *NIX!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-Uptime

Uptime: 0 days, 2 hours, 11 minutes

Returns the uptime of the system, the time since last reboot/startup
```



