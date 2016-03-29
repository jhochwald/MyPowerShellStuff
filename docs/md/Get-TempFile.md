# Get-TempFile
## SYNOPSIS
Creates a string with a temp file

## SYNTAX
```powershell
Get-TempFile [[-Extension] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a string with a temp file

## PARAMETERS
### -Extension <String>
File Extension as a string.
The default is "tmp"
```
Required?                    false
Position?                    1
Default value                tmp
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
Helper to avoid "System.IO.Path]::GetTempFileName()" usage.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>New-TempFile

C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.tmp

Returns a String of the Temp File with the extension TMP.
```

 
### EXAMPLE 2
```powershell
PS C:\>New-TempFile -Extension txt

C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.txt

Returns a String of the Temp File with the extension TXT
```

 
### EXAMPLE 3
```powershell
PS C:\>$foo = (New-TempFile)

PS C:\> New-Item -Path $foo -Force -Confirm:$false
PS C:\> Add-Content -Path:$LogPath -Value:"Test" -Encoding UTF8 -Force
C:\Users\josh\AppData\Local\Temp\d08cec6f-8697-44db-9fba-2c369963a017.tmp

Creates a temp File: C:\Users\josh\AppData\Local\Temp\d08cec6f-8697-44db-9fba-2c369963a017.tmp
And fill the newly created file with the String "Test"
```



