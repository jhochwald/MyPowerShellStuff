# Get-DecryptSecretText
## SYNOPSIS
Decrypts a given String, encrypted by Get-EncryptSecretText

## SYNTAX
```powershell
Get-DecryptSecretText [-EncryptedText] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Get-Decrypt makes a string encrypted by Get-EncryptSecretText decrypts it to and humnan readable again.

## PARAMETERS
### -EncryptedText <String>
The encrypted test string
```
Required?                    true
Position?                    1
Default value
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
System.String

## NOTES
You need the certificate that was used with Get-EncryptSecretText to encryt the string

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>$Foo = (Get-EncryptSecretText -CertificatePath "Cert:\CurrentUser\My\XYZ" -PlainText "My Secret Text")

PS C:\> Get-DecrypSecretText -EncryptedText $Foo
My Secret Text

Get-Decrypt makes a string encrypted by Get-EncryptSecretText humnan readable again.
In this example the Certificate with the Fingerprint "XYZ" from the certificate store of the user is used.
```



