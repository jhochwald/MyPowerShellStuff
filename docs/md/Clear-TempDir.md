# Clear-TempDir
## SYNOPSIS
Cleanup the TEMP Directory

## SYNTAX
```powershell
Clear-TempDir [[-Days] <Int32>] [-Confirm] [-Whatif] [<CommonParameters>]
```

## DESCRIPTION
Cleanup the TEMP Directory

## PARAMETERS
### -Days <Int32>
Number of days, older files will be removed!
```
Required?                    false
Position?                    1
Default value                30
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Confirm <SwitchParameter>
A description of the Confirm parameter.
```
Required?                    false
Position?                    named
Default value                True
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Whatif <SwitchParameter>
A description of the Whatif parameter.
```
Required?                    false
Position?                    named
Default value                False
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
PS C:\>Clear-TempDir

Freed 439,58 MB disk space

Will delete all Files older then 30 Days (This is the default)
You have to confirm every item before it is deleted
```

 
### EXAMPLE 2
```powershell
PS C:\>Clear-TempDir -Days:60 -Confirm:$false

Freed 407,17 MB disk space

Will delete all Files older then 30 Days (This is the default)
You do not have to confirm every item before it is deleted
```



