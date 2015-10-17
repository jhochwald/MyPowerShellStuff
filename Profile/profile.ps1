<#
.SYNOPSIS
	PowerShell Profile Example

.DESCRIPTION
	PoSH (PowerShell) example Profile Script for PowerShell Session Login

.NOTES
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

.LINK
	hochwald.net http://hochwald.net
	Support Site https://support.net-experts.net
#>

# Interactive mode
$Global:RunEnv = "Terminal"

#
$BasePath = "C:\scripts\PowerShell"

# Load the Base Module
$BaseModule = "$BasePath\modules\base.psm1"

try {
	Import-Module $BaseModule -DisableNameChecking -force -Scope Global -ErrorAction stop -WarningAction SilentlyContinue
} catch {
	# Aw SNAP! That is so bad...
	Write-Error -Message:"Error: PoSH Base Module was not imported..." -ErrorAction:Stop
	
	# Still here? Make sure we are done!
	break
	
	# Aw Snap! We are still here? Fix that the Bruce Willis way: DIE HARD!
	exit 1
}

# Do a garbage collection
if (Get-Command run-gc -errorAction SilentlyContinue) {
	run-gc
}

# Gets back the default colors parameters
[console]::ResetColor()

# Change the Window
function global:Set-WinStyle {
	$console = $host.UI.RawUI
	$buffer = $console.BufferSize
	$buffer.Width = 128
	$buffer.Height = 2000
	$console.BufferSize = $buffer
	
	$size = $console.WindowSize
	$size.Width = 128
	$size.Height = 50
	$console.WindowSize = $size
}

# Make the Windows dark blue
function global:Set-RegularMode {
	# Reformat the Windows
	if ((Get-Command Set-WinStyle -errorAction SilentlyContinue)) {
		Set-WinStyle  > $null 2>&1 3>&1
		Set-WinStyle  > $null 2>&1 3>&1
	}
	
	# Change Color
	$console = $host.UI.RawUI
	$console.ForegroundColor = "Gray"
	$console.BackgroundColor = "DarkBlue"
	$console.CursorSize = 10
	
	# Text
	$colors = $host.PrivateData
	$colors.VerboseForegroundColor = "Yellow"
	$colors.VerboseBackgroundColor = "DarkBlue"
	$colors.WarningForegroundColor = "Yellow"
	$colors.WarningBackgroundColor = "DarkBlue"
	$colors.ErrorForegroundColor = "Red"
	$colors.ErrorBackgroundColor = "DarkBlue"
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
	
	# Clean screen
	Clear-Host
}

# Make the window white
function global:Set-LightMode {
	# Reformat the Windows
	if ((Get-Command Set-WinStyle -errorAction SilentlyContinue)) {
		Set-WinStyle  > $null 2>&1 3>&1
		Set-WinStyle  > $null 2>&1 3>&1
	}
	
	# Change Color
	$console = $host.UI.RawUI
	$console.ForegroundColor = "black"
	$console.BackgroundColor = "white"
	$console.CursorSize = 10
	
	# Text
	$colors = $host.PrivateData
	$colors.VerboseForegroundColor = "blue"
	$colors.VerboseBackgroundColor = "white"
	$colors.WarningForegroundColor = "Magenta"
	$colors.WarningBackgroundColor = "white"
	$colors.ErrorForegroundColor = "Red"
	$colors.ErrorBackgroundColor = "white"
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
	
	# Clean screen
	Clear-Host
}

# Modify the PATH
function script:append-path {
	<#
	.SYNOPSIS
	Appends a given path to the path variable

	.DESCRIPTION
	Appends a given path to the path variable, very useful if you want to execute something from a directory that is not included on the systemwide path variable

	.PARAMETER path
	Path that you want to include

	.EXAMPLE
	append-path (resolve-path "C:\scripts\PowerShell")
	Check if the path "C:\scripts\PowerShell" exists and include it to the PATH variable

	.NOTES
	This is just a little helper function to make the shell more flexible

	.LINK
	kreativsign.net http://kreativsign.net
	#>
	if (-not $env:PATH.contains($args)) {
		$env:PATH += ';' + $args
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}
# Include this to the PATH
append-path (resolve-path "$BasePath")

function script:LoadScripts {
	# Load all the PoSH functions from *.ps1 files
	$ToolsPath = "$BasePath\functions\*.ps1"
	
	# Exclude Test scripts
	$ExcludeName = ".Tests."
	
	# Load them all
	Get-ChildItem -Path $ToolsPath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where { $_.psIsContainer -eq $false } | Where { $_.Name -like "*.ps1" } | Where { $_.Name -ne $ExcludeName } | foreach-object -process { .$_.FullName } > $null 2>&1 3>&1
}
LoadScripts

If ($host.Name -eq 'ConsoleHost') {
	# Console Mode
	
	# Set the Environment variable
	if (-not ($RunEnv)) {
		$global:RunEnv = "Terminal"
	}
	
	# Style the Window
	if ((Get-Command Set-RegularMode -errorAction SilentlyContinue)) {
		Set-RegularMode > $null 2>&1 3>&1
	}
	
	# Change Window Title
	$a = (Get-Host).UI.RawUI
	$WhoAmI = ([Environment]::UserName)
	$a.WindowTitle = "$WhoAmI > Windows PoSH"
	$WhoAmI = $null
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE
	
	# Set the Environment variable
	if (-not ($RunEnv)) {
		$global:RunEnv = "Terminal"
	}
	
	# Style the Window
	if ((Get-Command Set-LightMode -errorAction SilentlyContinue)) {
		Set-RegularMode > $null 2>&1 3>&1
	}
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we runnung in a GUI
	
	# Set the Environment variable
	if (-not ($RunEnv)) {
		$global:RunEnv = "GUI"
	}
} else {
	# Not in the Console, not ISE... Where to hell are we?
}

# Change the prompt
function global:prompt {
	Write ("PS " + (Get-Location) + "> ")
	return " "
}

# Where the windows Starts
set-location $BasePath

# Display some infos
function info {
	""
	("Today is: " + $(Get-Date))
	""
	if ((Get-Command Get-PoSHBaseVer -errorAction SilentlyContinue)) {
		Get-PoSHBaseVer
	}
	""
}

function motd {
	# Display MOTD
	foreach ($HD in (GET-WMIOBJECT –query "SELECT * from win32_logicaldisk where DriveType = 3")) {
		$Free = $($HD.FreeSpace / 1GB -as [int])
		$Total = $($HD.Size / 1GB -as [int])
		
		if ($Free -le 5) {
			Write-Host "Drive $($HD.DeviceID) has $($Free)GB of $($Total)GB available" -ForegroundColor "Red"
		} else {
			Write-Host "Drive $($HD.DeviceID) has $($Free)GB of $($Total)GB available"
		}
	}
	
	Write-Host ""
	
	#
	if ((Get-Command Get-Uptime -errorAction SilentlyContinue)) {
		Get-Uptime
	}
	
	Write-Host ""
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}


# unregister events, in case they weren't unregistered properly before.
# Just error siliently if they don't exist
Unregister-Event ConsoleStopped -ErrorAction SilentlyContinue
Unregister-Event FileCreated -ErrorAction SilentlyContinue
Unregister-Event FileChanged -ErrorAction SilentlyContinue
Unregister-Event TimerTick -ErrorAction SilentlyContinue



# Try the new auto connect feature or authenticate manual via Auth-O365
if (Get-Command tryAutoLogin -errorAction SilentlyContinue) {
	tryAutoLogin
} elseif (Get-Command Auth-O365 -errorAction SilentlyContinue) {
	# Fallback to the old and manual way
	Auth-O365
}

# Enable strict mode
#Set-StrictMode -Version Latest

# Where are we?
If ($host.Name -eq 'ConsoleHost') {
	# Console Mode
	
	# Make a clean screen
	Clear-Host
	
	# Welcome message
	If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		$MyUserInfo = $env:Username.ToUpper()
		Write-Host "Entering PowerShell as $MyUserInfo with user permissions on $env:COMPUTERNAME" -ForegroundColor "White"
	} else {
		$MyUserInfo = $env:Username.ToUpper()
		Write-Host "Entering PowerShell as $MyUserInfo with admin permissions on $env:COMPUTERNAME" -ForegroundColor "Green"
	}
	
	# Show infos
	if (Get-Command info -errorAction SilentlyContinue) {
		info
	}
	
	# Show message of the day
	if (Get-Command motd -errorAction SilentlyContinue) {
		motd
	}
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we runnung in a GUI
} else {
	# Not in the Console, not ISE... Where to hell are we?
}

# Do a garbage collection
if (Get-Command run-gc -errorAction SilentlyContinue) {
	run-gc
}

# SIG # Begin signature block
# MIITegYJKoZIhvcNAQcCoIITazCCE2cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUxLWwwdCkI/XeRhvXh9EyUygK
# 4W+ggg4LMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUO/j26mxjHWbJFIMKN1yh
# i/YcUNwwDQYJKoZIhvcNAQEBBQAEggEAcIzhNK6PJOxSt+ZayyxrzRoPfnenhpsy
# WgSbYRoD5iI1q7y1qeF3pR2BquOczscpxE+wNp+Y2aOGX2AkKaxNg/+2UV+DUvkR
# jkzUsb4x1qe1yu1PmBzQuqHVqAKYjOygAEbCp28WUuvZ9o4ozB5v/lk4xpWjY2uT
# 8QTjracVrQNFusrYAs646fXWQx2ZMIU252/m3eF19QqB8Bo86+u3rxxAUSlau/6P
# +UBnd+5Q+p2ZxKLS0iUZJjtzZCLAkNYZN8n7gaubmU4RLiIzxR6Js/13TC3GUfbT
# 9BcDgV0YeeJl16kwIoS2bKQFzVMd38da1n1+yLk0dfCRauxAWBrijKGCAqIwggKe
# BgkqhkiG9w0BCQYxggKPMIICiwIBATBoMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyAhIRIQaggdM/2HrlgkzBa1IJTgMwCQYFKw4DAhoFAKCB/TAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTEwMTcx
# ODU2NDhaMCMGCSqGSIb3DQEJBDEWBBRQn8TLB0YsuaV2tRAqgkhGssBGDTCBnQYL
# KoZIhvcNAQkQAgwxgY0wgYowgYcwgYQEFLNjCLTUze1Pz71muVX647+xLCnmMGww
# VqRUMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgw
# JgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIQaggdM/
# 2HrlgkzBa1IJTgMwDQYJKoZIhvcNAQEBBQAEggEArA3qIBoTrQmFgGKIk9z+Y/7Q
# VtxsWJwU5HGlc58eXiFAGfa93dWwz4T+d4osxeYma9cLoQZKMNGgKB1HXR0qMUKZ
# heU1U5CX0WE00+vTvfxdSSoN/PabQuXus0G3MAySA7Wy8Qyna6W7KhEsdiac9Ow0
# f2VS5i0++D35DTIBAXpoVQMmt4prNgb2fWkmcxxXu8vmylKdPvWw3G5n5ilgWxvm
# l8OK4TIvVWQO9/7fjMXRcAhZoOX/zxhk/G/Fv+miifHtEEMrM7UYWWsISorFUms/
# CBLlUKuEcfrenb6VLA9LU4FR6rkBsF/Ov6yLsAEEl4TwmWeGjWOXw8UJbuf8OA==
# SIG # End signature block
