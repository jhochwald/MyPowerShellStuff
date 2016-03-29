# ConvertTo-Objects
## SYNOPSIS
You receive a result of a query and converts it to an array of objects which is

## SYNTAX
```powershell
ConvertTo-Objects [-Input] <Object[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
You receive a result of a query and converts it to an array of objects which is
more legible to understand

## PARAMETERS
### -Input <Object[]>
Input Objects
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
System.Array

## NOTES
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
C:\PS>$input = Select-SqlCeServer 'SELECT * FROM TABLE1' 'Data Source=C:\Users\cdbody05\Downloads\VisorImagenesNacional\VisorImagenesNacional\DIVIPOL.sdf;'

$input | ConvertTo-Objects
```



