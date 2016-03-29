# Clear-AllEventLogs
## SYNOPSIS
Delete all EventLog entries

## SYNTAX
```powershell
Clear-AllEventLogs [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Delete all EventLog entries

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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Clear-AllEventLogs

Ask if it should delete all EventLog entries and you need to confirm it
```

 
### EXAMPLE 2
```powershell
PS C:\>Clear-AllEventLogs -Confirm:$false

Delete all EventLog entries and you do not need to confirm it
```



