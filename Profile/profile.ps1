<#
.SYNOPSIS
	PowerShell Profile Example

.DESCRIPTION
	NET-Experts example Profile Script for PowerShell Session Login

.NOTES
	Copyright (C) 2011-2015, Joerg Hochwald

	Permission is hereby granted, free of charge, to any person obtaining a copy of this
	software and associated documentation files (the "Software"), to deal in the Software
	without restriction, including without limitation the rights to use, copy, modify, merge,
	publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
	to whom the Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all copies or
	substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
	INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
	PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
	FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
	OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

	Except as contained in this notice, the name of the Software, NET-Experts or Joerg Hochwald
	shall not be used in advertising or otherwise to promote the sale, use or other dealings in
	this Software without prior written authorization from NET-Experts or KreativSign GmbH

	By using the Software, you agree to the License, Terms and Conditions above!

.LINK
	Support Site https://support.net-experts.net
#>

# By default, when you import Microsofts ActiveDirectory PowerShell module which
# ships with Server 2008 R2 and is a part of the free RSAT tools,
# it will import AD cmdlets and also install an AD: PowerShell drive.
#
# If you do not want to install that drive set the variable to 0
$env:ADPS_LoadDefaultDrive = 0

# Resetting Console Colors
[System.Console]::ResetColor()

# Interactive mode
Set-Variable -Name RunEnv -Scope:Global -Value $("Terminal")

# This is our Base location
Set-Variable -Name BasePath -Scope:Global -Value $("C:\scripts\PowerShell")

# Fall-back: Load the Core Module
Set-Variable -Name BaseModule -Value $("$BasePath\modules\NETX.Core\NETX.Core.psm1")

if (Get-Module -ListAvailable -Name NETX.Core -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) {
	try {
		# Make sure we remove the Core Module (if loaded)
		Remove-Module -name NETX.Core -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# Import the Core PowerShell Module in the Global context
		Import-Module -Name NETX.Core -DisableNameChecking -force -Scope Global -ErrorAction stop -WarningAction SilentlyContinue
	} catch {
		# Sorry, Core PowerShell Module is not here!!!
		Write-Error -Message:"NET-Experts Core Module was not imported..." -ErrorAction:Stop

		# Still here? Make sure we are done!
		break

		# Aw Snap! We are still here? Fix that the Bruce Willis way: DIE HARD!
		exit 1
	}
} elseif (test-path $BaseModule -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) {
	try {
		# Make sure we remove the Core Module (if loaded)
		Remove-Module $BaseModule -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# Import the Core PowerShell Module in the Global context
		Import-Module $BaseModule -DisableNameChecking -force -Scope Global -ErrorAction stop -WarningAction SilentlyContinue
	} catch {
		# Aw SNAP! That is so bad...
		Write-Error -Message:"Error: NET-Experts Core Module $BaseModule was not imported..." -ErrorAction:Stop

		# Still here? Make sure we are done!
		break

		# Aw Snap! We are still here? Fix that the Bruce Willis way: DIE HARD!
		exit 1
	}
} else {
	# Sorry, Core PowerShell Module is not here!!!
	Write-Warning  "NET-Experts Core Module is not installed!"
}

# Do a garbage collection
if (Get-Command run-gc -errorAction SilentlyContinue) {
	run-gc
}

# Gets back the default colors parameters
[console]::ResetColor()

# Change the Window
function global:Set-WinStyle {
	Set-Variable -Name console -Value $($host.UI.RawUI)
	Set-Variable -Name buffer -Value $($console.BufferSize)

	$buffer.Width = 128
	$buffer.Height = 2000
	$console.BufferSize = $buffer

	Set-Variable -Name size -Value $($console.WindowSize)

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
	Set-Variable -Name console -Value $($host.UI.RawUI)
	$console.ForegroundColor = "Gray"
	$console.BackgroundColor = "DarkBlue"
	$console.CursorSize = 10

	# Text
	Set-Variable -Name colors -Value $($host.PrivateData)
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
	Set-Variable -Name console -Value $($host.UI.RawUI)
	$console.ForegroundColor = "black"
	$console.BackgroundColor = "white"
	$console.CursorSize = 10

	# Text
	Set-Variable -Name colors -Value $($host.PrivateData)
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

# Include this to the PATH
if ((append-path run-gc -errorAction SilentlyContinue)) {
	try {
		append-path (resolve-path "$BasePath")
	} catch {
		Write-Warning "Could not append $BasePath to the Path!"
	}
}

# Helper Function, see below
function script:LoadScripts {
	# Load all the NET-Experts PowerShell functions from *.ps1 files
	Set-Variable -Name ToolsPath -Value $("$BasePath\functions\*.ps1")

	# Exclude (Pester) Test scripts
	Set-Variable -Name ExcludeName -Value $(".Tests.")

	# Load them all
	Get-ChildItem -Path $ToolsPath -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Where { $_.psIsContainer -eq $false } | Where { $_.Name -like "*.ps1" } | Where { $_.Name -ne $ExcludeName } | foreach-object -process { .$_.FullName } > $null 2>&1 3>&1
}

# Load the Functions from each file in the "functions" directory
LoadScripts

# Configure the CONSOLE itself
If ($host.Name -eq 'ConsoleHost') {
	# Console Mode

	# Set the Environment variable
	if (-not ($RunEnv)) {
		Set-Variable -Name RunEnv -Scope:Global -Value $("Terminal")
	}

	# Style the Window
	if ((Get-Command Set-RegularMode -errorAction SilentlyContinue)) {
		# Set the Default Mode!
		Set-RegularMode > $null 2>&1 3>&1
	}

	# Change Window Title
	Set-Variable -Name a -Value $((Get-Host).UI.RawUI)
	Set-Variable -Name WhoAmI -Value $([Environment]::UserName)

	$a.WindowTitle = "$WhoAmI > Windows PoSH"

	Remove-Variable WhoAmI -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE

	# Set the Environment variable
	if (-not ($RunEnv)) {
		# We are in a Console!
		Set-Variable -Name RunEnv -Scope:Global -Value $("Terminal")
	}

	# Style the Window
	if ((Get-Command Set-LightMode -errorAction SilentlyContinue)) {
		# Set the Default Mode!
		Set-RegularMode > $null 2>&1 3>&1
	}
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we running in a GUI - Ask yourself why you run the profile!
	Write-Debug "Running a a GUI based Environment and execute a Console Profile!"

	# Set the Environment variable
	if (-not ($RunEnv)) {
		Set-Variable -Name RunEnv -Scope:Global -Value $("GUI")
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
	if ((Get-Command Get-NETXCoreVer -errorAction SilentlyContinue)) {
		#Dump the Version info
		Get-NETXCoreVer
	}
	""
}

# The Message of the Day (MOTD) function
function motd {
	# Display Disk Informations
	# We try toi display regular Disk only, no fancy disk drives
	foreach ($HD in (GET-WMIOBJECT -query "SELECT * from win32_logicaldisk where DriveType = 3")) {
		# Free Disk Space function
		Set-Variable -Name Free -Value $($HD.FreeSpace / 1GB -as [int])
		Set-Variable -Name Total -Value $($HD.Size / 1GB -as [int])

		# How much Disk Space do we have here?
		if ($Free -le 5) {
			# Less then 5 GB available - WARN!
			Write-Host "Drive $($HD.DeviceID) has $($Free)GB of $($Total)GB available" -ForegroundColor "Yellow"
		} elseif ($Free -le 2) {
			# Less then 2 GB available - WARN a bit more aggresiv!!!
			Write-Host "Drive $($HD.DeviceID) has $($Free)GB of $($Total)GB available" -ForegroundColor "Red"
		} else {
			# Regular Disk Free Space- GREAT!
			# With more then 5 GB available
			Write-Host "Drive $($HD.DeviceID) has $($Free)GB of $($Total)GB available"
		}
	}

	Write-Host ""

	#
	if ((Get-Command Get-Uptime -errorAction SilentlyContinue)) {
		# Get the Uptime...
		Get-Uptime
	}

	Write-Host ""

	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# unregister events, in case they weren't unregistered properly before.
# Just error silently if they don't exist
Unregister-Event ConsoleStopped -ErrorAction SilentlyContinue
Unregister-Event FileCreated -ErrorAction SilentlyContinue
Unregister-Event FileChanged -ErrorAction SilentlyContinue
Unregister-Event TimerTick -ErrorAction SilentlyContinue

# Try the new auto connect feature or authenticate manual via Auth-O365
if (Get-Command tryAutoLogin -errorAction SilentlyContinue) {
	# Lets try the new command
	get-tryAutoLogin
} elseif (Get-Command Auth-O365 -errorAction SilentlyContinue) {
	# Fall-back to the old and manual way
	Auth-O365
}

# Enable strict mode
<#
	Set-StrictMode -Version Latest
#>

# Where are we?
If ($host.Name -eq 'ConsoleHost') {
	# Console Mode - Make a clean screen
	Clear-Host

	# Is this a user or an admin account?
	# This has nothing to do with the user / User rights!
	# We look for the Session: Is it started as Admin, or not!
	If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		# Make the Name ALL Lower case
		$MyUserInfo = $env:Username.ToUpper()

		# This is a regular user Account!
		Write-Host "Entering PowerShell as $MyUserInfo with user permissions on $env:COMPUTERNAME" -ForegroundColor "White"
	} else {
		# Make the Name ALL Lower case
		$MyUserInfo = $env:Username.ToUpper()

		# This is an elevated session!
		Write-Host "Entering PowerShell as $MyUserInfo with admin permissions on $env:COMPUTERNAME" -ForegroundColor "Green"
	}

	# Show infos
	if (Get-Command info -errorAction SilentlyContinue) {
		info
	}

	# Show message of the day
	if (Get-Command motd -errorAction SilentlyContinue) {
		# This is the function from above.
		# If you want, you might use Get-MOTD here.
		motd
	}
} elseif (($host.Name -eq 'Windows PowerShell ISE Host') -and ($psISE)) {
	# Yeah, we run within the ISE
	# We do not support this Environment :)
} elseif ($host.Name -eq 'PrimalScriptHostImplementation') {
	# Oh, we running in a GUI
	# We do not support this Environment :)
} elseif ($host.Name -eq 'DefaultHost') {
	# Look who is using our PowerShell Web Proxy Server...
	# We do not support this Environment :)
} else {
	# Not in the Console, not ISE... Where to hell are we right now?
}


# Workaround
(Remove-Module -name NETX.ActiveDirectory -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
(Import-Module -Name NETX.ActiveDirectory -DisableNameChecking -force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue) > $null 2>&1 3>&1
(Remove-Module -name NETX.ActiveDirectory -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1


# Do a garbage collection
if (Get-Command run-gc -errorAction SilentlyContinue) {
	run-gc
}

# SIG # Begin signature block
# MIIfOgYJKoZIhvcNAQcCoIIfKzCCHycCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUF+2oWQh9m3GG4ahGsRgpioqt
# yE6gghnLMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# MCMGCSqGSIb3DQEJBDEWBBTQNRgbTWyWrNIVKCDj0h/TougC+TANBgkqhkiG9w0B
# AQEFAASCAQCoPlBnWpFIZRsW5pPs+B+AF0xnU9hcciUYp+uXi1Y1FlnFNAe9hzpB
# 9TChVk4fILGxhiXtGaXJ+L6wfB7rh2vGlKDnQfTXt5nuXFZimZRguqeyxpwfbdR+
# ImprgIRxF/4bbkR+rOOi9JqXzsoJkkB17lNM91OF6yNN7SdUPwIpV6lNMX8DgKRl
# PemTm6DZdmWEbPK86sv39JGqaaiJcp0bKdHdYBKO0btSbqQavdyzt4JqDbFLJ1ll
# 1Oa2LnovDtdaODiTdvAiZ66J9+nhGQx4OJbz7mfa7dJr6xEbjm0sUUmpfOd7bvSs
# hKFIMUb4OHd+1WUP9GvIdv8nGDylvqzuoYICojCCAp4GCSqGSIb3DQEJBjGCAo8w
# ggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
# c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh
# BqCB0z/YeuWCTMFrUglOAzAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE1MTIxODEwNDMyOVowIwYJKoZIhvcN
# AQkEMRYEFP2YUfElw8bDFeJTJiq7+ruAy/NNMIGdBgsqhkiG9w0BCRACDDGBjTCB
# ijCBhzCBhAQUs2MItNTN7U/PvWa5Vfrjv7EsKeYwbDBWpFQwUjELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gRzICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkq
# hkiG9w0BAQEFAASCAQApV+u04lK+U/GTACDHBuFi5w6rVOVRIVEEso0x1KOqmbH8
# yMeUJhvsVreaZdf3/O3FWvKCPtABnKXsPQqFuY0kQRg8c5jRRSmeBa/jL6rT/Mll
# USfNdHVzXANTG5ZIS6EpmffiuiEZPft1cjxAp5wO6oHxKgiMMZGXBPnwniyb8I8b
# U1q3ph3XUFOsePlFIUx6ExhUSb7brcSMtpmClTZIS/BTv/hzGE0cQRfklM6sK47f
# JAe1cWNiVYZDczFcVlCQ54MyOBbuFwRSvwJBzMIh9i9ngKLvYQpCUU10PAwFJ+h0
# OgEjGk/O3E9vD+HbFIWLqC7HldDYJa2NObLtJfiv
# SIG # End signature block
