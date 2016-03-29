# Get-TinyURL
## SYNOPSIS
Get a Short URL

## SYNTAX
```powershell
Get-TinyURL [-URL] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get a Short URL using the TINYURL.COM Service

## PARAMETERS
### -URL <String>
Long URL
```
Required?                    true
Position?                    1
Default value
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
Still a beta Version!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-TinyURL -URL 'http://hochwald.net'

http://tinyurl.com/yc63nbh

Request the TINYURL for http://hochwald.net.
In this example the return is http://tinyurl.com/yc63nbh
```



