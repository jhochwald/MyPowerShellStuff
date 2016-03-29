# Get-NewPassword
## SYNOPSIS
Generates a New password with varying length and Complexity,

## SYNTAX
```powershell
Get-NewPassword [[-PasswordLength] <Int32>] [[-Complexity] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generate a New Password for a User.  Defaults to 8 Characters
with Moderate Complexity.  Usage

GET-NEWPASSWORD or

GET-NEWPASSWORD $Length $Complexity

Where $Length is an integer from 1 to as high as you want
and $Complexity is an Integer from 1 to 4

## PARAMETERS
### -PasswordLength <Int32>
Password Length
```
Required?                    false
Position?                    1
Default value                8
Accept pipeline input?       false
Accept wildcard characters?  false
```
 
### -Complexity <Int32>
Complexity Level
```
Required?                    false
Position?                    2
Default value                3
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
The Complexity falls into the following setup for the Complexity level
1 - Pure lowercase Ascii
2 - Mix Uppercase and Lowercase Ascii
3 - Ascii Upper/Lower with Numbers
4 - Ascii Upper/Lower with Numbers and Punctuation

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-NewPassword

zemermyya784vKx93

Create New Password based on the defaults
```

 
### EXAMPLE 2
```powershell
PS C:\>Get-NewPassword 9 1

zemermyya

Generate a Password of strictly Uppercase letters that is 9 letters long
```

 
### EXAMPLE 3
```powershell
PS C:\>Get-NewPassword 5

zemermyya784vKx93K2sqG

Generate a Highly Complex password 5 letters long
```

 
### EXAMPLE 4
```powershell
C:\PS>$MYPASSWORD=ConvertTo-SecureString (Get-NewPassword 8 2) -asplaintext -force

Create a new 8 Character Password of Uppercase/Lowercase and store
as a Secure.String in Variable called $MYPASSWORD
```



