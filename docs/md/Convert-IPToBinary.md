# Convert-IPToBinary
## SYNOPSIS
Converts an IP address string to it's binary string equivalent

## SYNTAX
```powershell
Convert-IPToBinary [[-IP] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Takes a IP as a string and returns the same IP address as a binary string with no decimal points

## PARAMETERS
### -IP <String>
The IP address which will be converted to a binary string
```
Required?                    false
Position?                    2
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
System.Management.Automation.PSObject

## NOTES
Works with IPv4 addresses only!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Convert-IPToBinary -IP '10.211.55.1'

Binary                                                          IPAddress
------                                                          ---------
00001010110100110011011100000001                                10.211.55.1

Converts 10.211.55.1 to it's binary string equivalent 00001010110100110011011100000001
```



