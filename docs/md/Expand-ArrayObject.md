# Expand-ArrayObject
## SYNOPSIS
You get an array of objects and performs an expansion of data separated by a spacer

## SYNTAX
```powershell
Expand-ArrayObject [-array] <Array> [-field] <String> [-delimiter <Char>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
You get an array of objects and performs an expansion of data separated by a spacer

## PARAMETERS
### -array <Array>
Input Array
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -field <String>
Field to extract from the Array
```
Required?                    true
Position?                    2
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -delimiter <Char>
Delimiter within the Array, default is ";"
```
Required?                    false
Position?                    named
Default value                ;
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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
C:\PS>$arr | Expand-ArrayObject fieldX
```



