# Get-MicrosoftUpdateInfo
## SYNOPSIS
Gives a list of all Microsoft Updates sorted by KB number/HotfixID

## SYNTAX
```powershell
Get-MicrosoftUpdateInfo [[-raw]] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Gives a list of all Microsoft Updates sorted by KB number/HotfixID

## PARAMETERS
### -raw <SwitchParameter>
Just dum the Objects?
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
Basic Function found here: http://tomtalks.uk/2013/09/list-all-microsoftwindows-updates-with-powershell-sorted-by-kbhotfixid-get-microsoftupdate/
By Tom Arbuthnot. Lyncdup.com

We just adopted and tweaked it.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-MicrosoftUpdateInfo

Return the installed Microsoft Updates
```

 
### EXAMPLE 2
```powershell
PS C:\>$MicrosoftUpdateInfo = (Get-MicrosoftUpdateInfo -raw)

$MicrosoftUpdateInfo | where { $_.HotFixID -eq "KB3121461" }

Return the installed Microsoft Updates in a more raw format, this might be handy if you want to reuse it!
In this example we search for the Update "KB3121461" only and displays that info.
```

 
### EXAMPLE 3
```powershell
PS C:\>$MicrosoftUpdateInfo = (Get-MicrosoftUpdateInfo -raw)

[System.String](($MicrosoftUpdateInfo | where { $_.HotFixID -eq "KB3121461" }).Title)

Return the installed Microsoft Updates in a more raw format, this might be handy if you want to reuse it!
In this example we search for the Update "KB3121461" only and displays the info about that Update as String.
```



