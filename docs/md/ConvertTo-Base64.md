# ConvertTo-Base64
## SYNOPSIS
Convert a String to a Base 64 encoded String

## SYNTAX
```powershell
ConvertTo-Base64 [[-plain] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Convert a String to a Base 64 encoded String

## PARAMETERS
### -plain <String>
Unencodes Input String
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
PS C:\>ConvertTo-Base64 -plain "Hello World"

SABlAGwAbABvACAAVwBvAHIAbABkAA==

Convert a String to a Base 64 encoded String
```

 
### EXAMPLE 2
```powershell
PS C:\>"Just a String" | ConvertTo-Base64

SgB1AHMAdAAgAGEAIABTAHQAcgBpAG4AZwA=

Convert a String to a Base 64 encoded String via Pipe(line)
```



