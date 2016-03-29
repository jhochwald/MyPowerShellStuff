# Convert-IPtoDecimal
## SYNOPSIS
Converts an IP address to decimal.

## SYNTAX
```powershell
Convert-IPtoDecimal [-IPAddress] <String> [<CommonParameters>]
```

## DESCRIPTION
Converts an IP address to decimal value.

## PARAMETERS
### -IPAddress <String>
An IP Address you want to check
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```

## INPUTS


## OUTPUTS
System.Management.Automation.PSObject

## NOTES
Sometimes I need to have that info, so I decided it would be great to have a functions who do the job!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Convert-IPtoDecimal -IPAddress '127.0.0.1','192.168.0.1','10.0.0.1'

decimal        IPAddress
-------        ---------
2130706433    127.0.0.1
3232235521    192.168.0.1
167772161    10.0.0.1
```

 
### EXAMPLE 2
```powershell
PS C:\>Convert-IPtoDecimal '127.0.0.1','192.168.0.1','10.0.0.1'

decimal        IPAddress
-------        ---------
2130706433    127.0.0.1
3232235521    192.168.0.1
167772161    10.0.0.1
```

 
### EXAMPLE 3
```powershell
PS C:\>'127.0.0.1','192.168.0.1','10.0.0.1' |  Convert-IPtoDecimal

decimal        IPAddress
-------        ---------
2130706433    127.0.0.1
3232235521    192.168.0.1
167772161    10.0.0.1
```



