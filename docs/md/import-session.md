# import-session
## SYNOPSIS
Import a PowerShell session info from file

## SYNTAX
```powershell
import-session [-sessionName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This is a (very) poor man approach to restore some session infos

Our concept of session is simple and only considers:
- history
- The current directory

But still can be very handy and useful. If you type in some sneaky commands,
or some very complex things and you did not copied these to another file or script
it can save you a lot of time if you need to do it again (And this is often the case)

Even if you just want to dump it quick to copy it some when later to a documentation or
script this might be useful.

## PARAMETERS
### -sessionName <String>

```
Required?                    true
Position?                    1
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
System.String

## NOTES
This is just a little helper function to make the shell more flexible

## EXAMPLES

