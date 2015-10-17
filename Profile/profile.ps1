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
	foreach ($HD in (Get-WmiObject -query "SELECT * from win32_logicaldisk where DriveType = 3")) {
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

