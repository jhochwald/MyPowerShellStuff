# ConvertTo-EscapeString
## SYNOPSIS
HTML on web pages uses tags and other special characters to define the page.

## SYNTAX
```powershell
ConvertTo-EscapeString [-String] <String> [<CommonParameters>]
```

## DESCRIPTION
HTML on web pages uses tags and other special characters to define the page.
To make sure text is not misinterpreted as HTML tags, you may want to escape text and automatically convert any ambiguous text character in an encoded format.

## PARAMETERS
### -String <String>
String to escape
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```

## INPUTS


## OUTPUTS
System.String

## NOTES
This function has a companion: ConvertFrom-EscapedString
The companion reverses the escaped strings back to regular ones.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertTo-EscapeString -String "Hello World"

Hello%20World

In this example we escape the space in the string "Hello World"
```

 
### EXAMPLE 2
```powershell
PS C:\>"http://hochwald.net" | ConvertTo-EscapeString

http%3A%2F%2Fhochwald.net

In this example we escape the URL string
```



