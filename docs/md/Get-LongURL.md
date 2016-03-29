# Get-LongURL
## SYNOPSIS
Expand a Short URL

## SYNTAX
```powershell
Get-LongURL [-URL] <String> [<CommonParameters>]
```

## DESCRIPTION
Expand a Short URL via the untiny.me
This service supports all well known (and a lot other) short UR L services!

## PARAMETERS
### -URL <String>
Short URL
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       false
Accept wildcard characters?  false
```

## INPUTS


## OUTPUTS
System.String

## NOTES
This service supports all well known (and a lot other) short UR L services!

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-LongURL -URL 'http://cutt.us/KX5CD'

http://hochwald.net

Get the Long URL (http://hochwald.net) for a given Short URL
```



