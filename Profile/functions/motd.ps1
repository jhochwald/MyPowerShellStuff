﻿function Update-SysInfo {
<#
	.SYNOPSIS
		Update Information about the system
	
	.DESCRIPTION
		This function updates the informations about the systems it runs on
	
	.EXAMPLE
		PS C:\> Update-SysInfo

		# Update Information about the system, no output!
	
	.NOTES
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1
#>
	
	Set-Variable -Name Operating_System -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
	Set-Variable -Name Processor -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
	Set-Variable -Name Logical_Disk -Value $(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -Property DeviceID -eq -Value $(${Operating_System}.SystemDrive) | Select-Object -Property Size, FreeSpace)
	Set-Variable -Name Get_Date -Value $(Get-Date)
	Set-Variable -Name Get_OS_Name -Value $(${Operating_System}.Caption)
	Set-Variable -Name Get_Kernel_Info -Value $(${Operating_System}.Version)
	Set-Variable -Name Get_Uptime -Value $("$((${Get_Uptime} = ${Get_Date} - $(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
	Set-Variable -Name Get_Shell_Info -Value $("{0}.{1}" -f ${PSVersionTable}.PSVersion.Major, ${PSVersionTable}.PSVersion.Minor)
	Set-Variable -Name Get_CPU_Info -Value $(${Processor}.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
	Set-Variable -Name Get_Process_Count -Value $((Get-Process).Count)
	Set-Variable -Name Get_Current_Load -Value $(${Processor}.LoadPercentage)
	Set-Variable -Name Get_Memory_Size -Value $("{0}mb/{1}mb Used" -f (([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)) - ([math]::round(${Operating_System}.FreePhysicalMemory/1KB))), ([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)))
	Set-Variable -Name Get_Disk_Size -Value $("{0}gb/{1}gb Used" -f (([math]::round(${Logical_Disk}.Size/1GB)) - ([math]::round(${Logical_Disk}.FreeSpace/1GB))), ([math]::round(${Logical_Disk}.Size/1GB)))
}

function Get-MOTD {
<#
    .SYNOPSIS
        Displays system information to a host.

    .DESCRIPTION
        The Get-MOTD cmdlet is a system information tool written in PowerShell. 

	.EXAMPLE
		PS C:\> Get-MOTD
	
		# Display the colorful Message of the Day with an Windows Logo and some system infos

	.NOTES
        Found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

        I moved some stuff in a seperate function to make it reusable
#>
	
	# Update the Infos
	Update-SysInfo
	
	# Write to the Console
	Write-Host -Object ("")
	Write-Host -Object ("")
	Write-Host -Object ("         ,.=:^!^!t3Z3z.,                  ") -ForegroundColor Red
	Write-Host -Object ("        :tt:::tt333EE3                    ") -ForegroundColor Red
	Write-Host -Object ("        Et:::ztt33EEE ") -NoNewline -ForegroundColor Red
	Write-Host -Object (" @Ee.,      ..,     ${Get_Date}") -ForegroundColor Green
	Write-Host -Object ("       ;tt:::tt333EE7") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ;EEEEEEttttt33#     ") -ForegroundColor Green
	Write-Host -Object ("      :Et:::zt333EEQ.") -NoNewline -ForegroundColor Red
	Write-Host -Object (" SEEEEEttttt33QL     ") -NoNewline -ForegroundColor Green
	Write-Host -Object ("User: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${env:UserName}") -ForegroundColor Cyan
	Write-Host -Object ("      it::::tt333EEF") -NoNewline -ForegroundColor Red
	Write-Host -Object (" @EEEEEEttttt33F      ") -NoNewline -ForeGroundColor Green
	Write-Host -Object ("Hostname: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${env:ComputerName}") -ForegroundColor Cyan
	Write-Host -Object ("     ;3=*^``````'*4EEV") -NoNewline -ForegroundColor Red
	Write-Host -Object (" :EEEEEEttttt33@.      ") -NoNewline -ForegroundColor Green
	Write-Host -Object ("OS: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Cyan
	Write-Host -Object ("     ,.=::::it=., ") -NoNewline -ForegroundColor Cyan
	Write-Host -Object ("``") -NoNewline -ForegroundColor Red
	Write-Host -Object (" @EEEEEEtttz33QF       ") -NoNewline -ForegroundColor Green
	Write-Host -Object ("Kernel: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("NT ") -NoNewline -ForegroundColor Cyan
	Write-Host -Object ("${Get_Kernel_Info}") -ForegroundColor Cyan
	Write-Host -Object ("    ;::::::::zt33) ") -NoNewline -ForegroundColor Cyan
	Write-Host -Object ("  '4EEEtttji3P*        ") -NoNewline -ForegroundColor Green
	Write-Host -Object ("Uptime: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_Uptime}") -ForegroundColor Cyan
	Write-Host -Object ("   :t::::::::tt33.") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (":Z3z.. ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object (" ````") -NoNewline -ForegroundColor Green
	Write-Host -Object (" ,..g.        ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("Shell: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("Powershell ${Get_Shell_Info}") -ForegroundColor Cyan
	Write-Host -Object ("   i::::::::zt33F") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (" AEEEtttt::::ztF         ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("CPU: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_CPU_Info}") -ForegroundColor Cyan
	Write-Host -Object ("  ;:::::::::t33V") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (" ;EEEttttt::::t3          ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("Processes: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Cyan
	Write-Host -Object ("  E::::::::zt33L") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (" @EEEtttt::::z3F          ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("Current Load: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Cyan
	Write-Host -Object ("%") -ForegroundColor Cyan
	Write-Host -Object (" {3=*^``````'*4E3)") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (" ;EEEtttt:::::tZ``          ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("Memory: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Cyan
	Write-Host -Object ("             ``") -NoNewline -ForegroundColor Cyan
	Write-Host -Object (" :EEEEtttt::::z7            ") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("Disk: ") -NoNewline -ForegroundColor Red
	Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Cyan
	Write-Host -Object ("                 'VEzjt:;;z>*``           ") -ForegroundColor Yellow
	Write-Host -Object ("                      ````                  ") -ForegroundColor Yellow
	Write-Host -Object ("")
}

function Get-SysInfo {
<#
	.SYNOPSIS
		Displays Information about the system
	
	.DESCRIPTION
		Displays Information about the system it is started on
	
	.EXAMPLE
		PS C:\> Get-SysInfo
	
		# Display some system infos
	
	.NOTES
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1
#>
	
	# Update the Infos
	Update-SysInfo
	
	Write-Host -Object ("")
	Write-Host -Object ("${Get_Date}") -ForegroundColor Gray
	Write-Host -Object ("")
	
	Write-Host -Object ("User: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:UserName}") -ForegroundColor Gray
	
	Write-Host -Object ("Hostname: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:ComputerName}") -ForegroundColor Gray
	
	Write-Host -Object ("OS: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Gray
	
	Write-Host -Object ("Kernel: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("NT ") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("${Get_Kernel_Info}") -ForegroundColor Gray
	
	Write-Host -Object ("Uptime: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Uptime}") -ForegroundColor Gray
	
	Write-Host -Object ("Shell: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("Powershell ${Get_Shell_Info}") -ForegroundColor Gray
	
	Write-Host -Object ("CPU: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_CPU_Info}") -ForegroundColor Gray
	
	Write-Host -Object ("Processes: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Gray
	
	Write-Host -Object ("Current Load: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("%") -ForegroundColor Gray
	
	Write-Host -Object ("Memory: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Gray
	
	Write-Host -Object ("Disk: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Gray
}

# SIG # Begin signature block
# MIITegYJKoZIhvcNAQcCoIITazCCE2cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvrK2rxS1KEf4On0gYsXaOVl0
# zpWggg4LMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUbPqk74uuUW/a98VHvBhJ
# Og+iwZwwDQYJKoZIhvcNAQEBBQAEggEALpYT59tPuQJ//IZX/WQeY12OzeQrBgLG
# GJYXEfILUbnqA8F9lHSgqLzkNhgvonwp1quu+/pgu4nUZbflzzHyjYrfdLUG9uSh
# nq99ZIN3c8N+E4j9EVHdvzoX69TWnq6+1tgu6MqhcdQjhO5I0z8WEIEnlzzu8o8F
# +/bJLKL6DoIo7ooJkvc+c/JLEKAswq+YKE4yvdLKTBz/9LU7CDaN+UEUbBCEzT/j
# pCYcV/P8oPps8XPrxsag99fOBspUDkLvIhnX5Qa5G3xNgA3KIk4wtT2wUrOojyOd
# DojwepU05vn15jBvmYNODz/PJkvTGDzb0ySfrcgXWVbg5H6KRJvHBqGCAqIwggKe
# BgkqhkiG9w0BCQYxggKPMIICiwIBATBoMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyAhIRIQaggdM/2HrlgkzBa1IJTgMwCQYFKw4DAhoFAKCB/TAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTEwMTcx
# NzMyMjFaMCMGCSqGSIb3DQEJBDEWBBTPL8yGmd/I5dDlXU19lYXBbeAzXDCBnQYL
# KoZIhvcNAQkQAgwxgY0wgYowgYcwgYQEFLNjCLTUze1Pz71muVX647+xLCnmMGww
# VqRUMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgw
# JgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIQaggdM/
# 2HrlgkzBa1IJTgMwDQYJKoZIhvcNAQEBBQAEggEAV7QoL7Z24zHUsRmm/DeeRue8
# zP5kg3SL+oeNfLBrtgip/CWswATIvSF0HNAzz02VW6SXUOhnKq2lQZN3o/Y9OVzB
# jWZ1HLK4SnZxQnHm37SFoyfREHX8WQjJjm4ld5yt88ZxlFTQS6d4//NII3aaSU2Q
# YOXQPbyQLQ5nC6vlXdicOiiP19JxHRR7SfJBjFfnIOgsp+UmHcnyQCeyP1aTnAHw
# DPvTH3gdqW4dkviqrOe6FgV1Y9rQ/IrxgnpbFXIOCO5PI6Sn8G7du4Ry7XoMVJ7f
# B0QEqph9FwYTabUdnMfIOjFoDG1KzBIO1+XUoOFeKOMfPb/qCFgSPh6pLfSmQA==
# SIG # End signature block
