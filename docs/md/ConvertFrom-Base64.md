# ConvertFrom-Base64
## SYNOPSIS
Decode a Base64 encoded String back to a plain String

## SYNTAX
```powershell
ConvertFrom-Base64 [[-encoded] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Decode a Base64 encoded String back to a plain String

## PARAMETERS
### -encoded <String>
Base64 encoded String
```
Required?                    false
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
N.N.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>ConvertFrom-Base64 -encoded "SABlAGwAbABvACAAVwBvAHIAbABkAA=="

Hello World

Decode a Base64 encoded String back to a plain String
```

 
### EXAMPLE 2
```powershell
PS C:\>"SABlAGwAbABvACAAVwBvAHIAbABkAA==" | ConvertFrom-Base64

Hello World

Decode a Base64 encoded String back to a plain String via Pipe(line)
```



