# Get-AdminUser
## SYNOPSIS
Small function to see if we are Admin

## SYNTAX
```powershell
Get-AdminUser [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Check if the user have started the PowerShell Session as Admin

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
System.Boolean

## NOTES
Just a little helper function

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-AdminUser

Return a boolean (True if the user is Admin and False if not)
```

 
### EXAMPLE 2
```powershell
PS C:\>if ( Get-AdminUser ) {write-Output "Hello Admin User"}

Prints "Hello Admin User" to the Console if the session is started as Admin!
```



