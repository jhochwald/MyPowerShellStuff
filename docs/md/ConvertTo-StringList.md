# ConvertTo-StringList
## SYNOPSIS
Function to convert an array into a string list with a delimiter.

## SYNTAX
```powershell
ConvertTo-StringList [-Array] <Array> [[-Delimiter] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Function to convert an array into a string list with a delimiter.

## PARAMETERS
### -Array <Array>
Specifies the array to process.
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -Delimiter <String>
Separator between value, default is ","
```
Required?                    false
Position?                    2
Default value                ,
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
Based on an idea of Francois-Xavier Cat

## EXAMPLES
### EXAMPLE 1
```powershell
C:\PS>$Computers = "Computer1","Computer2"

ConvertTo-StringList -Array $Computers

Output:
Computer1,Computer2
```

 
### EXAMPLE 2
```powershell
C:\PS>$Computers = "Computer1","Computer2"

ConvertTo-StringList -Array $Computers -Delimiter "__"

Output:
Computer1__Computer2
```

 
### EXAMPLE 3
```powershell
C:\PS>$Computers = "Computer1"

ConvertTo-StringList -Array $Computers -Delimiter "__"

Output:
Computer1
```



