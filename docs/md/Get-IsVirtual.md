# Get-IsVirtual
## SYNOPSIS
Check if this is a Virtual Machine

## SYNTAX
```powershell
Get-IsVirtual [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
If this is a virtual System the Boolean is True, if not it is False

## PARAMETERS
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
System.Boolean

## NOTES
The Function name is changed!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-IsVirtual

True

If this is a virtual System the Boolean is True, if not it is False
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-IsVirtual

False

If this is not a virtual System the Boolean is False, if so it is True
```



