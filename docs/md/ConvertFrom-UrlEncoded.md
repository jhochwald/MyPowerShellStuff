# ConvertFrom-UrlEncoded
## SYNOPSIS
Decodes a UrlEncoded string.

## SYNTAX
```powershell
ConvertFrom-UrlEncoded [-InputObject] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Decodes a UrlEncoded string.

Input can be either a positional or named parameters of type string or an
array of strings. The Cmdlet accepts pipeline input.

## PARAMETERS
### -InputObject <Object>
A description of the InputObject parameter.
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


## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertFrom-UrlEncoded 'http%3a%2f%2fwww.d-fens.ch'

http://www.d-fens.ch

# Encoded string is passed as a positional parameter to the Cmdlet.
```

 
### EXAMPLE 2
```powershell
PS C:\>ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch'

http://www.d-fens.ch

# Encoded string is passed as a named parameter to the Cmdlet.
```

 
### EXAMPLE 3
```powershell
PS C:\>ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch', 'http%3a%2f%2fwww.dfch.biz%2f'

http://www.d-fens.ch
http://www.dfch.biz/

# Encoded strings are passed as an implicit array to the Cmdlet.
```

 
### EXAMPLE 4
```powershell
PS C:\>ConvertFrom-UrlEncoded -InputObject @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f")

http://www.d-fens.ch
http://www.dfch.biz/

# Encoded strings are passed as an explicit array to the Cmdlet.
```

 
### EXAMPLE 5
```powershell
PS C:\>@("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded

http://www.d-fens.ch
http://www.dfch.biz/

Encoded strings are piped as an explicit array to the Cmdlet.
```

 
### EXAMPLE 6
```powershell
PS C:\>"http%3a%2f%2fwww.dfch.biz%2f" | ConvertFrom-UrlEncoded

http://www.dfch.biz/

# Encoded string is piped to the Cmdlet.
```

 
### EXAMPLE 7
```powershell
PS C:\>$r = @("http%3a%2f%2fwww.d-fens.ch", 0, "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded

PS C:\> $r
http://www.d-fens.ch
0
http://www.dfch.biz/

# In case one of the passed strings is not a UrlEncoded encoded string, the
# plain string is returned. The pipeline will continue to execute and all
# strings are returned.
```



