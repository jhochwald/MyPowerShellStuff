# Get-DiskInfo
## SYNOPSIS
Show free Diskspace for all Disks

## SYNTAX
```powershell
Get-DiskInfo [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function gets your System Disk Information

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
PS C:\>Get-DiskInfo

Loading system disk free space information...
 C Drive has 24,77 GB of free space.
  D Drive has 1,64 GB of free space.

Show free Diskspace for all Disks
```



