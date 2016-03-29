# Get-UUID
## SYNOPSIS
Generates a UUID String

## SYNTAX
```powershell
Get-UUID [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generates a UUID String and is a uuidgen.exe replacement

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
Just a little helper function
If you have Visual Studio installed, you might find the function useless!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-UUID

a08cdabe-f598-4930-a537-80e7d9f15dc3

Generates a UUID String
```



