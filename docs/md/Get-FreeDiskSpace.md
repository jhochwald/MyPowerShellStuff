# Get-FreeDiskSpace
## SYNOPSIS
Show the Free Disk Space of all Disks

## SYNTAX
```powershell
Get-FreeDiskSpace [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This is a Uni* DF like command that shows the available Disk space.
It's human readable (e.g. more like df -h)

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
System.Array

## NOTES
Just a quick hack to make Powershell more Uni* like

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\scripts\PowerShell>Get-FreeDiskSpace

Name Disk Size(GB) Free (%)
---- ------------- --------
C          64         42%
D           2         84%

Show the Free Disk Space of all Disks
```



