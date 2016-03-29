# Get-EnvironmentVariables
## SYNOPSIS
Get and list all Environment Variables

## SYNTAX
```powershell
Get-EnvironmentVariables [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Dum all existing Environment Variables.
Sometimes this comes handy if you do something that changes them an you want to compare the before and after values (See examples)

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
Initial Version...

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-EnvironmentVariables

Get and list all Environment Variables
```

 
### EXAMPLE 2
```powershell
PS C:\>$before = (Get-EnvironmentVariables)

PS C:\> Installer
PS C:\> $after = (Get-EnvironmentVariables)
PS C:\> Compare-Object -ReferenceObject $before -DifferenceObject $after

Get and list all Environment Variables and save them to a variable.
Install, or do whatever you want to do... Something that might change the Environment Variables.
Get and list all Environment Variables again and save them to a variable.
Compare the 2 results...
```

 
### EXAMPLE 3
```powershell
PS C:\>(Get-EnvironmentVariables) | C:\scripts\PowerShell\export\before.txt

PS C:\> Installer
PS C:\> reboot
PS C:\> (Get-EnvironmentVariables) | C:\scripts\PowerShell\export\after.txt
PS C:\> Compare-Object -ReferenceObject 'C:\scripts\PowerShell\export\before.txt' -DifferenceObject 'C:\scripts\PowerShell\export\after.txt'

Get and list all Environment Variables and save them to a file.
Install, or do whatever you want to do... Something that might change the Environment Variables.
Get and list all Environment Variables again and save them to another file.
Compare the 2 results...
```



