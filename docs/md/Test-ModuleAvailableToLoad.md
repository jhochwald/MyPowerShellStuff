# Test-ModuleAvailableToLoad
## SYNOPSIS
Test if the given Module exists

## SYNTAX
```powershell
Test-ModuleAvailableToLoad [-modname] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Test if the given Module exists

## PARAMETERS
### -modname <String[]>
Name of the Module
```
Required?                    true
Position?                    1
Default value
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
System.Boolean

## NOTES
Quick helper function

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Test-ModuleAvailableToLoad EXISTINGMOD

True

This module exists
```

 
### EXAMPLE 2
```powershell
PS C:\>Test-ModuleAvailableToLoad WRONGMODULE

False

This Module does not esist
```

 
### EXAMPLE 3
```powershell
C:\PS>$MSOLModname = "MSOnline"

$MSOLTrue = (Test-ModuleAvailableToLoad $MSOLModName)
```



