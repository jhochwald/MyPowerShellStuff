# Test-ProxyBypass
## SYNOPSIS
Testing URLs for Proxy Bypass

## SYNTAX
```powershell
Test-ProxyBypass [[-url] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
If you'd like to find out whether a given URL goes through a proxy or is accessed directly

## PARAMETERS
### -url <String>
URL to check for Proxy Bypass
```
Required?                    false
Position?                    1
Default value                http://support.net-experts.net
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
Initial version of the function

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Test-ProxyBypass -url 'Value1'
```



