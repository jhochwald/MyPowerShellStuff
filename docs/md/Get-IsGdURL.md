# Get-IsGdURL
## SYNOPSIS
Get a Short URL

## SYNTAX
```powershell
Get-IsGdURL [-URL] <String> [<CommonParameters>]
```

## DESCRIPTION
Get a Short URL using the IS.GD Service

## PARAMETERS
### -URL <String>
Long URL
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
Additional information about the function.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-IsGdURL -URL 'http://hochwald.net'

http://is.gd/FkMP5v

Request the IS.GD for http://hochwald.net.
In this example the return is http://is.gd/FkMP5v
```



