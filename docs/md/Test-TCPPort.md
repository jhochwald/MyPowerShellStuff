# Test-TCPPort
## SYNOPSIS
TCP Port Ping

## SYNTAX
```powershell
Test-TCPPort [-target] <String> [-Port] <String> [[-TimeOut] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This function is used to see if a TCP Port is answering

## PARAMETERS
### -target <String>
Please specify an EndPoint (Host or IP Address)
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Port <String>
Please specify a Port
```
Required?                    true
Position?                    2
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -TimeOut <Int32>
Timeout value (Default is 1.000)
```
Required?                    false
Position?                    3
Default value                1000
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
System.Boolean

## NOTES
This function is used to see if a TCP Port is answering

## EXAMPLES
### EXAMPLE 1
```powershell
C:\PS>Test-TCPPort -target '127.0.0.1' -Port '445'

False

This function is used to see if a TCP Port is answering
```



