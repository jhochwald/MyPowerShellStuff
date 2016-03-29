# Get-ServiceStatusInfo
## SYNOPSIS
This function identifies all services that are configured to auto start with system but are in stopped state

## SYNTAX
```powershell
Get-ServiceStatusInfo [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function identifies all services that are configured to auto start with system but are in stopped state

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
Internal Helper

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\Windows\system32>Get-ServiceStatusInfo

Checking System Service status...
Total 4 services identified that have startup type configured to Auto start, but are in stopped state.
 1. Microsoft .NET Framework NGEN v4.0.30319_X86 .
 2. Microsoft .NET Framework NGEN v4.0.30319_X64 .
 3. Multimedia Class Scheduler .
 4. Software Protection .

This function identifies all services that are configured to auto start with system but are in stopped state
```



