# Get-IsSessionElevated
## SYNOPSIS
Is the Session started as admin (Elevated)

## SYNTAX
```powershell
Get-IsSessionElevated [<CommonParameters>]
```

## DESCRIPTION
Quick Helper that return if the session is started as admin (Elevated)
It returns a Boolean (True or False) and sets a global variable (IsSessionElevated) with
this Boolean value. This might be useful for further use!

## PARAMETERS
## INPUTS


## OUTPUTS
System.Boolean

## NOTES
Quick Helper that return if the session is started as admin (Elevated)

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-IsSessionElevated

True
# If the session is elevated
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-IsSessionElevated

False
# If the session is not elevated
```



