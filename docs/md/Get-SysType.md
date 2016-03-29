# Get-SysType
## SYNOPSIS
Show if the system is Workstation or a Server

## SYNTAX
```powershell
Get-SysType [[-d]] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function shows of the system is a server or a workstation.
Additionally it can show more detailed infos (like Domain Membership)

## PARAMETERS
### -d <SwitchParameter>
Shows a more detailed information, including the domain level
```
Required?                    false
Position?                    1
Default value                False
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
Wrote this for myself to see what system I was connected to via Remote PowerShell

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-SysType

Workstation

# The system is a Workstation (with or without Domain membership)
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-SysType -d

Standalone Server

# The system is a non domain joined server.
```



