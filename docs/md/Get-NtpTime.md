# Get-NtpTime
## SYNOPSIS
Get the NTP Time from a given Server

## SYNTAX
```powershell
Get-NtpTime [[-Server] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get the NTP Time from a given Server.

## PARAMETERS
### -Server <String>
NTP Server to use. The default is de.pool.ntp.org
```
Required?                    false
Position?                    1
Default value                de.pool.ntp.org
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
System.DateTime

## NOTES
This sends an NTP time packet to the specified NTP server and reads back the response.
The NTP time packet from the server is decoded and returned.

Note: this uses NTP (rfc-1305: http://www.faqs.org/rfcs/rfc1305.html) on UDP 123.
Because the function makes a single call to a single server this is strictly a
SNTP client (rfc-2030).
Although the SNTP protocol data is similar (and can be identical) and the clients
and servers are often unable to distinguish the difference.  Where SNTP differs is that
is does not accumulate historical data (to enable statistical averaging) and does not
retain a session between client and server.

An alternative to NTP or SNTP is to use Daytime (rfc-867) on TCP port 13 â€“
although this is an old protocol and is not supported by all NTP servers.

## EXAMPLES

