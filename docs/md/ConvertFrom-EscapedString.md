# ConvertFrom-EscapedString
## SYNOPSIS
Convert an encoded (escaped) string back into the original representation

## SYNTAX
```powershell
ConvertFrom-EscapedString [-String] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
If you have a escaped String this function make it human readable again.
Some Webservices returns strings an escaped format, so we convert an encoded (escaped) string back into the original representation

## PARAMETERS
### -String <String>
String to un-escape
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
System.String

## NOTES
This function has a companion: ConvertTo-EscapeString
The companion escapes any given regular string.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertFrom-EscapedString -String "Hello%20World"

Hello World

In this example we un-escape the space in the string "Hello%20World"
```

 
### EXAMPLE 2
```powershell
PS C:\>"http%3A%2F%2Fhochwald.net" | ConvertFrom-EscapedString

http://hochwald.net

In this example we un-escape the masked (escaped) URL string
```



