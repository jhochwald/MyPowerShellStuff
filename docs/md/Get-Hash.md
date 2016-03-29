# Get-Hash
## SYNOPSIS
Dumps the MD5 hash for the given File

## SYNTAX
```powershell
Get-Hash [-File] <String> [[-Hash] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Dumps the MD5 hash for the given File

## PARAMETERS
### -File <String>
File or path to dump MD5 Hash for
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -Hash <String>
Specifies the cryptographic hash function to use for computing the hash value of the contents of the specified file.
```
Required?                    false
Position?                    2
Default value                MD5
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
System.String

## NOTES
Re-factored to make it more flexible (cryptographic hash is now a parameter)
This is just a little helper function to make the shell more flexible

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-FileHash -File 'C:\scripts\PowerShell\PesterDocs.ps1'

069DF9587DB0A8D3BA6D8E840099A2D9

Dumps the MD5 hash for the given File
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-Hash -File 'C:\scripts\PowerShell\PesterDocs.ps1' -Hash SHA1

BC6B28A939CB3DBB82C9A7BDA5D80A191E8F06AE

Dumps the SHA1 hash for the given File
```



