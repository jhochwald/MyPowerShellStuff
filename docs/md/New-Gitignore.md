# New-Gitignore
## SYNOPSIS
Create a new .gitignore file with my default settings

## SYNTAX
```powershell
New-Gitignore [[-Source] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Downloads my default .gitignore from GitHub and creates it within the directory from where this function is called.

## PARAMETERS
### -Source <String>
The Source for the .gitignore
```
Required?                    false
Position?                    1
Default value                https://raw.githubusercontent.com/jhochwald/MyPowerShellStuff/master/.gitignore
Accept pipeline input?       true (ByValue)
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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\scripts\PowerShell\test>New-Gitignore

Creating C:\scripts\PowerShell\test\.gitignore
C:\scripts\PowerShell\test\.gitignore successfully created.


The default: We downloaded the default .gitignore from GitHub
```

 
### EXAMPLE 2
```powershell
PS C:\scripts\PowerShell\test\>New-Gitignore

WARNING: You already have a .gitignore in this dir.
Fetch a fresh one from GitHub?
Removing existing .gitignore.
Creating C:\scripts\PowerShell\test\.gitignore
C:\scripts\PowerShell\test\.gitignore successfully created.


In this example we had an existing .gitignore and downloaded the default one from GitHub...
```

 
### EXAMPLE 3
```powershell
PS C:\scripts\PowerShell\test>New-Gitignore

WARNING: You already have a .gitignore in this dir.
Fetch a fresh one from GitHub?
Existing .gitignore will not be changed.


In this Example we had an existing .gitignore and we decided to stay with em!
```



