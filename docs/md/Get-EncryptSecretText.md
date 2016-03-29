# Get-EncryptSecretText
## SYNOPSIS
Encrypts a given string with a given certificate

## SYNTAX
```powershell
Get-EncryptSecretText [-CertificatePath] <String> [-PlainText] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sometimes you might need to transfer a password (or another secret) via Mail (or any other insecure media) here a strong encryption is very handy.
Get-EncryptSecretText uses a given Certificate to encrypt a given String.

## PARAMETERS
### -CertificatePath <String>
Path to the certificate that you would like to use
```
Required?                    true
Position?                    1
Default value
Accept pipeline input?       true (ByValue)
Accept wildcard characters?  false
```
 
### -PlainText <String>
Plain text string that you would like to encyt with the certificate
```
Required?                    true
Position?                    2
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
You need Get-DecryptSecretText to make it human radable again

## EXAMPLES
### EXAMPLE 1
```powershell
PS C:\>Get-EncryptSecretText -CertificatePath "Cert:\CurrentUser\My\XYZ" -PlainText "My Secret Text"

MIIB9QYJKoZIhvcNAQcDoIIB5jCCAeICAQAxggGuMIIBqgIBADCBkTB9MQswCQYDVQQGEwJHQjEbnBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8
gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEBbU91MdmxgnT/ImczrRgFwwDQYJKoZIhvcNAQEBBQAEggEAi5M7w7k/siGdGiYW8z8izVUNfI15HaHqHJs/t3VIZkgfSc
GAKUpZjwJW7xMZHoKppw0eL/mUZr4823M276swiktXnpRbol8g8Kqvy2c7dUx2lNJm/+s8YLG0rsK70EhSPzAEbNtFAqlWj5ETnskTlfuEiJdB2tFjC42oweWKRokQ0exyztY1sN7V7vImkMtCS7JHeJF23SyNv
PbFw0hE0QtiKVdu8DESO2CB9H1bVYIxVWTvpvT71yDQCFFOwg0JdGJpCI6l+YxPqHqKhFcdWZtuP8JMvNZ8UbxveNVmBOrasM5ZTHfHljWIT6V6tDxy5jOd9cTiuayh/X1A2eKA/DArBgkqhkiG9w0BBwEwFAYI
KoZIhvcNAwcECFjYhWLX5qsEgAgjq1toxGP5GQ==

In this example the Certificate with the Fingerprint "XYZ" from the certificate store of the user is used.
```



