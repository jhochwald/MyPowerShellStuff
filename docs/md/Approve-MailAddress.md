# Approve-MailAddress
## SYNOPSIS
REGEX check to see if a given Email address is valid

## SYNTAX
```powershell
Approve-MailAddress [-Email] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Checks a given Mail Address against a REGEX Filter to see if it is RfC822 complaint
Not directly related is the REGEX check. Most mailer will not be able to handle it if there
are non standard chars within the Mail Address...

## PARAMETERS
### -Email <String>
e.g. "joerg.hochwald@outlook.com"
Email address to check
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
System.Boolean

## NOTES
Internal Helper function to check Mail addresses via REGEX to see if they are
RfC822 complaint before use them.

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Approve-MailAddress -Email:"No.Reply@bewoelkt.net"

True

Checks a given Mail Address (No.Reply@bewoelkt.net) against a REGEX Filter to see if
it is RfC822 complaint
```

 
### EXAMPLE 2
```powershell
PS C:\>Approve-MailAddress -Email:"Jörg.hochwald@gmail.com"

False

Checks a given Mail Address (JÃ¶rg.hochwald@gmail.com) against a REGEX Filter to see if
it is RfC822 complaint, and it is NOT
```

 
### EXAMPLE 3
```powershell
PS C:\>Approve-MailAddress -Email:"Joerg hochwald@gmail.com"

False

Checks a given Mail Address (Joerg hochwald@gmail.com) against a REGEX Filter to see
if it is RfC822 complaint, and it is NOT
```

 
### EXAMPLE 4
```powershell
PS C:\>Approve-MailAddress -Email:"Joerg.hochwald@gmail"

False

Checks a given Mail Address (Joerg.hochwald@gmail) against a REGEX Filter to see
if it is RfC822 complaint, and it is NOT
```



