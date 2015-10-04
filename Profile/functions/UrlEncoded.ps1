function ConvertFrom-UrlEncoded {
<#
	.SYNOPSIS
		Decodes a UrlEncoded string.
	
	.DESCRIPTION
		Decodes a UrlEncoded string.
		
		Input can be either a positional or named parameters of type string or an
		array of strings. The Cmdlet accepts pipeline input.
	
	.PARAMETER InputObject
		A description of the InputObject parameter.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch
		
		# Encoded string is passed as a positional parameter to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch
		
		# Encoded string is passed as a named parameter to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell>  ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch', 'http%3a%2f%2fwww.dfch.biz%2f'
		http://www.d-fens.ch
		http://www.dfch.biz/
		
		# Encoded strings are passed as an implicit array to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f")
		http://www.d-fens.ch
		http://www.dfch.biz/
		
		# Encoded strings are passed as an explicit array to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		http://www.d-fens.ch
		http://www.dfch.biz/
		
		Encoded strings are piped as an explicit array to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> "http%3a%2f%2fwww.dfch.biz%2f" | ConvertFrom-UrlEncoded
		http://www.dfch.biz/
		
		# Encoded string is piped to the Cmdlet.
	
	.EXAMPLE
		PS C:\scripts\PowerShell> $r = @("http%3a%2f%2fwww.d-fens.ch", 0, "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		PS C:\scripts\PowerShell> $r
		http://www.d-fens.ch
		0
		http://www.dfch.biz/
		
		# In case one of the passed strings is not a UrlEncoded encoded string, the
		# plain string is returned. The pipeline will continue to execute and all
		# strings are returned.
	
	.NOTES
		
	
	.LINK
		Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/
#>
	
	[CmdletBinding(HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		$InputObject
	)
	
	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		$OutputParameter = $null;
		Log-Debug -fn $fn -msg ("CALL. InputObject.Count: '{0}'" -f $InputObject.Count) -fac 1;
	}
	
	PROCESS {
		foreach ($Object in $InputObject) {
			$fReturn = $false;
			$OutputParameter = $null;
			
			$OutputParameter = [System.Web.HttpUtility]::UrlDecode($InputObject);
			$OutputParameter;
		}
		$fReturn = $true;
	}
	
	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
} # function
if ($MyInvocation.ScriptName) { Export-ModuleMember -Function ConvertFrom-UrlEncoded; }


function ConvertTo-UrlEncoded {
	[CmdletBinding(HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertTo-UrlEncoded/')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]
		$InputObject
	)
	
	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		Log-Debug -fn $fn -msg ("CALL. Length '{0}'" -f $InputObject.Length) -fac 1;
	}
	PROCESS {
		$fReturn = $false;
		$OutputParameter = $null;
		
		$OutputParameter = [System.Web.HttpUtility]::UrlEncode($InputObject);
		return $OutputParameter;
	}
	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}

# SIG # Begin signature block
# MIITegYJKoZIhvcNAQcCoIITazCCE2cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU//xnTAty8RDaF61bTPjJ4xxS
# Uiuggg4LMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNTAyMDMwMDAw
# MDBaFw0yNjAzMDMwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCAMtwHjRygnJ08Kug9IYtZoU1+zETOA75+qrzE5ntz
# u0vxiNqQTnU3KDhjudcrD1SpVs53OZcwc82b2dkFRRyNpLgDXU/ZHC6Y4OmI5uzX
# BX5WKnv3FlujrY+XJRKEG7JcY0oK0u8QVEeChDVpKJwM5B8UFiT6ddx0cm5OyuNq
# Q6/PfTZI0b3pBpEsL6bIcf3PvdidIZj8r9veIoyvp/N3753co3BLRBrweIUe8qWM
# ObXciBw37a0U9QcLJr2+bQJesbiwWGyFOg32/1onDMXeU+dUPFZMyU5MMPbyXPsa
# jMKCvq1ZkfYbTVV7z1sB3P16028jXDJHmwHzwVEURoqbMIIFTDCCBDSgAwIBAgIQ
# FtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAwMDAwWhcNMTgwNzE2MjM1OTU5WjCB
# kDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1NTc2MQ8wDQYDVQQIDAZIZXNzZW4x
# EDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkMD0JhaG5ob2ZzcGxhdHogMTEZMBcG
# A1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcGA1UEAwwQS3JlYXRpdlNpZ24gR21i
# SDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8jDmF0TO09qJndJ9eG
# Fqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8kE5sL4/dMhuTOp+SMt0tI/SON6BY3
# 208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD8AIyrTH9b27wDNX4rC914Ka4EBI8
# sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSazE9yyRTuffidmtHV49DHPr+ql4ji
# NJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUukpzdCaA0UzygGUdDfgy0htSSp8MR9
# Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnkq0bXUIC6H0Zolnfl4fanvVYyvD88
# qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaAFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kGHucShjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEE
# BAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwIwKzApBggrBgEFBQcCARYd
# aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ29kZVNpZ25pbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LmNvbW9k
# b2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNydDAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMGA1UdEQQcMBqBGGhvY2h3YWxkQGty
# ZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsFAAOCAQEASSZkxKo3EyEk/qW0ZCs7
# CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqdwFkuQYJxzknqm2JMvwIK6BtfWc64
# WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPjen60W+L66oNEXiBuIsOcJ9e7tH6Vn
# 9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4LDHEpYpLRVQnuxoc38mmd+NfjcD2
# /o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ3trqmH6e3Cpm8Ut5UkoSONZdkYWw
# rzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnrHRReihZ0zwN+HkXO1XEnd3hm+08j
# LzGCBNkwggTVAgEBMIGRMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBD
# QSBMaW1pdGVkMSMwIQYDVQQDExpDT01PRE8gUlNBIENvZGUgU2lnbmluZyBDQQIQ
# FtT3Ux2bGCdP8iZzNFGAXDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUoCys6e8JSYNRQb7+Ucri
# AU0YSY4wDQYJKoZIhvcNAQEBBQAEggEAdB7Dz1kNob6kboFMy7btcdbjEOnyvdWh
# ce7c3loOthcgrEwZMWnXsGYN/IuMhRzkCqSZJse2G+oVZOVx/2EpBggU7R60ooXM
# D0HUZXuTrcFKxbbwqMg+XtIKYaj3kbOecZou2g46T6bLDl78oFz3s3lBHV2rgohT
# Sxk7WMSNtwOJ5RUHBZhhjAkjBnFUrony2WxroaEHTLH+YTMP77fVjspDb0bD7z4E
# vg6wXIsjraXyg6qVfuZ1iJ5iP0Z4I6WvtND5jYUiJthh8Q8yG4As0CagC4Dvcx6Q
# 71fiZlIv2qriRMSnwRMLqnoO4iVH1J/0DH43wJkd5mrDuNZIAQF7WqGCAqIwggKe
# BgkqhkiG9w0BCQYxggKPMIICiwIBATBoMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyAhIRIQaggdM/2HrlgkzBa1IJTgMwCQYFKw4DAhoFAKCB/TAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTEwMDQx
# NTE0MThaMCMGCSqGSIb3DQEJBDEWBBRVwYroFflH5IT43rqaCM8Ly4I1qDCBnQYL
# KoZIhvcNAQkQAgwxgY0wgYowgYcwgYQEFLNjCLTUze1Pz71muVX647+xLCnmMGww
# VqRUMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgw
# JgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIQaggdM/
# 2HrlgkzBa1IJTgMwDQYJKoZIhvcNAQEBBQAEggEAIpBfrUsBk7BoeVZ9DuoxgCKW
# pzScjY0UzwhLo8LKCn9KwFxRk/O+jh32unNSzWGb7NdJjlhdth2n2dP3zi+pud1K
# ecZP6uJiT0/OVJFfUVzPsYbjDILl+CUMaCcJsi20PPfzIn0SB1JwA5OFDt8wPrFP
# hkChB/7pulLHEgLL0eIalbMrYekjHIxwZuhE35Tu2euhhUwHLE8fQWue0DbNrcJD
# V3zV7gEJQDdXsm8CTL2nXx01OynPODsrD9QNjhg4W/itkBll/Zm9Bl+0wL98xKD+
# tnaZTfSrU9TOKHbJ7qPtppA4N3IdrE3FecNDlnLBfjaMjR3yMxnG0D8qaebBCQ==
# SIG # End signature block
