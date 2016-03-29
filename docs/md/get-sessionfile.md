# get-sessionfile
## SYNOPSIS
Restore PowerShell Session information

## SYNTAX
```powershell
get-sessionfile [-sessionName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This command shows many PowerShell Session informations.

## PARAMETERS
### -sessionName <String>
Name of the Session you would like to dump
```
Required?                    true
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
PS C:\>get-sessionfile $O365Session

C:\Users\adm.jhochwald\AppData\Local\Temp\[PSSession]Session2

# Returns the Session File for a given Session
```

 
### EXAMPLE 2
```powershell
PS C:\>get-sessionfile

C:\Users\adm.jhochwald\AppData\Local\Temp\

# Returns the Session File of the running session, cloud be none!
```



