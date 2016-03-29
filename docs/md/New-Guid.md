# New-Guid
## SYNOPSIS
Creates a new Guid object and displays it to the screen

## SYNTAX
```powershell
New-Guid [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Uses static System.Guid.NewGuid() method to create a new Guid object

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
This is just a quick & dirty helper function to generate GUID's
this is neat if you need a new GUID for an PowerShell Module.

If you have Visual Studio, you might find this function useless!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>New-Guid

fd6bd476-db80-44e7-ab34-47437adeb8e3

Creates a new Guid object and displays its GUI to the screen
```



