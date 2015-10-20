<#
	if ($Statement) { Write-Output "Code is poetry" }

	Copyright (c) 2012 - 2015 by Joerg Hochwald <joerg.hochwald@outlook.de>

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

	Except as contained in this notice, the name of the Software, NET-experts
	or Joerg Hochwald shall not be used in advertising or otherwise to promote
	the sale, use or other dealings in this Software without prior written
	authorization from Joerg Hochwald
#>

function Global:Update-SysInfo {
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
	# Call Companion to Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
	
	# Fill Variables with values
	Set-Variable -Name Operating_System -Scope:Global -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
	Set-Variable -Name Processor -Scope:Global -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
	Set-Variable -Name Logical_Disk -Scope:Global -Value $(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -Property DeviceID -eq -Value $(${Operating_System}.SystemDrive) | Select-Object -Property Size, FreeSpace)
	Set-Variable -Name Get_Date -Scope:Global -Value $(Get-Date)
	Set-Variable -Name Get_OS_Name -Scope:Global -Value $(${Operating_System}.Caption)
	Set-Variable -Name Get_Kernel_Info -Scope:Global -Value $(${Operating_System}.Version)
	Set-Variable -Name Get_Uptime -Scope:Global -Value $("$((${Get_Uptime} = ${Get_Date} - $(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
	Set-Variable -Name Get_Shell_Info -Scope:Global -Value $("{0}.{1}" -f ${PSVersionTable}.PSVersion.Major, ${PSVersionTable}.PSVersion.Minor)
	Set-Variable -Name Get_CPU_Info -Scope:Global -Value $(${Processor}.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
	Set-Variable -Name Get_Process_Count -Scope:Global -Value $((Get-Process).Count)
	Set-Variable -Name Get_Current_Load -Scope:Global -Value $(${Processor}.LoadPercentage)
	Set-Variable -Name Get_Memory_Size -Scope:Global -Value $("{0}mb/{1}mb Used" -f (([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)) - ([math]::round(${Operating_System}.FreePhysicalMemory/1KB))), ([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)))
	Set-Variable -Name Get_Disk_Size -Scope:Global -Value $("{0}gb/{1}gb Used" -f (([math]::round(${Logical_Disk}.Size/1GB)) - ([math]::round(${Logical_Disk}.FreeSpace/1GB))), ([math]::round(${Logical_Disk}.Size/1GB)))
}

function Global:Clean-SysInfo {
	<#
	.SYNOPSIS
		Companion for Update-SysInfo

	.DESCRIPTION
		Cleanup for variables from the Update-SysInfo function

	.EXAMPLE
		PS C:\> Clean-SysInfo

		# Cleanup for variables from the Update-SysInfo function

	.NOTES

#>
	Remove-Variable Operating_System -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Processor -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Logical_Disk -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Date -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_OS_Name -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Kernel_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Uptime -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Shell_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_CPU_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Process_Count -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Current_Load -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Memory_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Disk_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
}

function Global:Get-MOTD {
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
	
	# Call Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
}

function Global:Get-SysInfo {
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
	
	Write-Host -Object ("")
	
	# Call Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
}

# SIG # Begin signature block
# MIIfOgYJKoZIhvcNAQcCoIIfKzCCHycCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUbYZ9f5M7KpyYG5O3DwruJvVi
# 3Q+gghnLMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# LzCCBdgwggPAoAMCAQICEEyq+crbY2/gH/dO2FsDhp0wDQYJKoZIhvcNAQEMBQAw
# gYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
# BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
# VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEwMDEx
# OTAwMDAwMFoXDTM4MDExODIzNTk1OVowgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQI
# ExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoT
# EUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmlj
# YXRpb24gQXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# kehUktIKVrGsDSTdxc9EZ3SZKzejfSNwAHG8U9/E+ioSj0t/EFa9n3Byt2F/yUsP
# F6c947AEYe7/EZfH9IY+Cvo+XPmT5jR62RRr55yzhaCCenavcZDX7P0N+pxs+t+w
# gvQUfvm+xKYvT3+Zf7X8Z0NyvQwA1onrayzT7Y+YHBSrfuXjbvzYqOSSJNpDa2K4
# Vf3qwbxstovzDo2a5JtsaZn4eEgwRdWt4Q08RWD8MpZRJ7xnw8outmvqRsfHIKCx
# H2XeSAi6pE6p8oNGN4Tr6MyBSENnTnIqm1y9TBsoilwie7SrmNnu4FGDwwlGTm0+
# mfqVF9p8M1dBPI1R7Qu2XK8sYxrfV8g/vOldxJuvRZnio1oktLqpVj3Pb6r/SVi+
# 8Kj/9Lit6Tf7urj0Czr56ENCHonYhMsT8dm74YlguIwoVqwUHZwK53Hrzw7dPamW
# oUi9PPevtQ0iTMARgexWO/bTouJbt7IEIlKVgJNp6I5MZfGRAy1wdALqi2cVKWlS
# ArvX31BqVUa/oKMoYX9w0MOiqiwhqkfOKJwGRXa/ghgntNWutMtQ5mv0TIZxMOmm
# 3xaG4Nj/QN370EKIf6MzOi5cHkERgWPOGHFrK+ymircxXDpqR+DDeVnWIBqv8mqY
# qnK8V0rSS527EPywTEHl7R09XiidnMy/s1Hap0flhFMCAwEAAaNCMEAwHQYDVR0O
# BBYEFLuvfgI9+qbxPISOre44mOzZMjLUMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB
# Af8EBTADAQH/MA0GCSqGSIb3DQEBDAUAA4ICAQAK8dVGhLeuUbtssk1BFACTTJzL
# 5cBUz6AljgL5/bCiDfUgmDwTLaxWorDWfhGS6S66ni6acrG9GURsYTWimrQWEmla
# jOHXPqQa6C8D9K5hHRAbKqSLesX+BabhwNbI/p6ujyu6PZn42HMJWEZuppz01yfT
# ldo3g3Ic03PgokeZAzhd1Ul5ACkcx+ybIBwHJGlXeLI5/DqEoLWcfI2/LpNiJ7c5
# 2hcYrr08CWj/hJs81dYLA+NXnhT30etPyL2HI7e2SUN5hVy665ILocboaKhMFrEa
# mQroUyySu6EJGHUMZah7yyO3GsIohcMb/9ArYu+kewmRmGeMFAHNaAZqYyF1A4CI
# im6BxoXyqaQt5/SlJBBHg8rN9I15WLEGm+caKtmdAdeUfe0DSsrw2+ipAT71VpnJ
# Ho5JPbvlCbngT0mSPRaCQMzMWcbmOu0SLmk8bJWx/aode3+Gvh4OMkb7+xOPdX9M
# i0tGY/4ANEBwwcO5od2mcOIEs0G86YCR6mSceuEiA6mcbm8OZU9sh4de826g+XWl
# m0DoU7InnUq5wHchjf+H8t68jO8X37dJC9HybjALGg5Odu0R/PXpVrJ9v8dtCpOM
# pdDAth2+Ok6UotdubAvCinz6IPPE5OXNDajLkZKxfIXstRRpZg6C583OyC2mUX8h
# wTVThQZKXZ+tuxtfdDCCBeAwggPIoAMCAQICEC58h8wOk0pS/pT9HLfNNK8wDQYJ
# KoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1h
# bmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
# aW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9y
# aXR5MB4XDTEzMDUwOTAwMDAwMFoXDTI4MDUwODIzNTk1OVowfTELMAkGA1UEBhMC
# R0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9y
# ZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBS
# U0EgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAppiQY3eRNH+K0d3pZzER68we/TEds7liVz+TvFvjnx4kMhEna7xRkafPnp4l
# s1+BqBgPHR4gMA77YXuGCbPj/aJonRwsnb9y4+R1oOU1I47Jiu4aDGTH2EKhe7VS
# A0s6sI4jS0tj4CKUN3vVeZAKFBhRLOb+wRLwHD9hYQqMotz2wzCqzSgYdUjBeVoI
# zbuMVYz31HaQOjNGUHOYXPSFSmsPgN1e1r39qS/AJfX5eNeNXxDCRFU8kDwxRstw
# rgepCuOvwQFvkBoj4l8428YIXUezg0HwLgA3FLkSqnmSUs2HD3vYYimkfjC9G7WM
# crRI8uPoIfleTGJ5iwIGn3/VCwIDAQABo4IBUTCCAU0wHwYDVR0jBBgwFoAUu69+
# Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjto
# dHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9j
# cnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUF
# BzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIB
# AAI/AjnD7vjKO4neDG1NsfFOkk+vwjgsBMzFYxGrCWOvq6LXAj/MbxnDPdYaCJT/
# JdipiKcrEBrgm7EHIhpRHDrU4ekJv+YkdK8eexYxbiPvVFEtUgLidQgFTPG3UeFR
# AMaH9mzuEER2V2rx31hrIapJ1Hw3Tr3/tnVUQBg2V2cRzU8C5P7z2vx1F9vst/dl
# CSNJH0NXg+p+IHdhyE3yu2VNqPeFRQevemknZZApQIvfezpROYyoH3B5rW1CIKLP
# DGwDjEzNcweU51qOOgS6oqF8H8tjOhWn1BUbp1JHMqn0v2RH0aofU04yMHPCb7d4
# gp1c/0a7ayIdiAv4G6o0pvyM9d1/ZYyMMVcx0DbsR6HPy4uo7xwYWMUGd8pLm1Gv
# TAhKeo/io1Lijo7MJuSy2OU4wqjtxoGcNWupWGFKCpe0S0K2VZ2+medwbVn4bSoM
# fxlgXwyaiGwwrFIJkBYb/yud29AgyonqKH4yjhnfe0gzHtdl+K7J+IMUk3Z9ZNCO
# zr41ff9yMU2fnr0ebC+ojwwGUPuMJ7N2yfTm18M04oyHIYZh/r9VdOEhdwMKaGy7
# 5Mmp5s9ZJet87EUOeWZo6CLNuO+YhU2WETwJitB/vCgoE/tqylSNklzNwmWYBp7O
# SFvUtTeTRkF8B93P+kPvumdh/31J4LswfVyA4+YWOUunMYIE2TCCBNUCAQEwgZEw
# fTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
# A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNV
# BAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5nIENBAhAW1PdTHZsYJ0/yJnM0UYBc
# MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3
# DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEV
# MCMGCSqGSIb3DQEJBDEWBBSWjkwvtKxdHP9OpqN2RWR+aqrkEjANBgkqhkiG9w0B
# AQEFAASCAQA5em3dpOyQSkQW4VQiyEcMNdKWgG64W4PtLj/29Vyn5ibi6h0eBTdJ
# xxWiYGsqxhcALhMII8MNxaVhk0P58Zrt3wpI4xWDVu7cIFVjZ18uqZtAXrPAtIHr
# 48D3m9pFvJiYsvgZHn4cugZt3GKi1AaKbb0H1uHoqMkyu3Pey+k2x2UugRMT+mH8
# diP0dnJ/xRyU2wXiUTpJfUgHX3rq4AfopUYCWiH/kQ3J7uirXRRnLaB3vEO2xZFv
# PXkDbB9k4FjuQmDWl5dGfSN6fmK9y0lV5Ozjgohcg6seTHYgzfE5GEQRk61FSceB
# RqPNQLGZ2s9fLgsIF/hFPR8qqvpBUiFaoYICojCCAp4GCSqGSIb3DQEJBjGCAo8w
# ggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
# c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh
# BqCB0z/YeuWCTMFrUglOAzAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTAyMDIyNTgwNVowIwYJKoZIhvcN
# AQkEMRYEFA2zHuW21H9uMwXZ8oftqGJknRYNMIGdBgsqhkiG9w0BCRACDDGBjTCB
# ijCBhzCBhAQUs2MItNTN7U/PvWa5Vfrjv7EsKeYwbDBWpFQwUjELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gRzICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkq
# hkiG9w0BAQEFAASCAQA1u8HSUAaBGm4XM55JGXm47tMJ2aPOssnKJ9Dv5OKLwfEW
# otXHvA7oAJNZAsawZHEQTfeYKLkav5GQPg5XBQWwC2EZ+kn4Aa2+tdSglzduCWVQ
# 3bDJervxeBTMqipT5cSkDZYVhe7dccsOIAXUT4L/6J1d/w9sPSTqxxIikjUUjrUC
# UtSN4Qh8FOX241sshuh1dM/hxG0QA3N7AirR2LwNaDX1qizN177v6Oaovj08p/F8
# YVWRWadfOtHMwsSlRqs+ejC7JJ0REWl91fyyZ2Q0cdHEcKFLqYPLrQDybdx2UlQe
# Ezop96QrrsLHACx3wfdNQx/0qDNl0xKdEKIo4RA0
# SIG # End signature block
