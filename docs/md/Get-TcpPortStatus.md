# Get-TcpPortStatus
## SYNOPSIS
Check a TCP Port

## SYNTAX
```powershell
Get-TcpPortStatus [[-Port] <Int32>] [[-Server] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Opens a connection to a given (or default) TCP Port to a given (or default) server.
This is not a simple port ping, it creates a real connection to see if the port is alive!

## PARAMETERS
### -Port <Int32>
Default is 587
e.g. "25"
Port to use
```
Required?                    false
Position?                    1
Default value                587
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Server <String>
e.g. "outlook.office365.com" or "192.168.16.10"
SMTP Server to use
```
Required?                    false
Position?                    2
Default value
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
System.Boolean

## NOTES
Internal Helper function to check if we can reach a server via a TCP connection on a given port

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-TcpPortStatus

Check port 587/TCP on the default Server
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-TcpPortStatus -Port:25 -Server:mx.net-experts.net

True

Check port 25/TCP on Server mx.net-experts.net
```



