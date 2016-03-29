# Get-ShortDate
## SYNOPSIS
Get the Date as short String

## SYNTAX
```powershell
Get-ShortDate [[-FilenameCompatibleFormat]] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the Date as short String

## PARAMETERS
### -FilenameCompatibleFormat <SwitchParameter>
Make sure it is compatible to File Dates
```
Required?                    false
Position?                    1
Default value                False
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
Helper Function based on an idea of Robert D. Biddle

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-ShortDate

19.03.16
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-ShortDate -FilenameCompatibleFormat

19.03.16
```



