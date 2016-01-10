#region License

<#
	{
		"info": {
			"Statement": "Code is poetry",
			"Author": "Joerg Hochwald",
			"Contact": "joerg.hochwald@outlook.com",
			"Link": "http://hochwald.net",
			"Support": "https://github.com/jhochwald/MyPowerShellStuff/issues"
		},
		"Copyright": "(c) 2012-2015 by Joerg Hochwald. All rights reserved."
	}

	Redistribution and use in source and binary forms, with or without modification,
	are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this list of
	   conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation and/or
	   other materials provided with the distribution.

	3. Neither the name of the copyright holder nor the names of its contributors may
	   be used to endorse or promote products derived from this software without
	   specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
	IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
	AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.

	By using the Software, you agree to the License, Terms and Conditions above!
#>

#endregion License

function global:Write-ToLog {
<#
	.SYNOPSIS
		Write Log to file and screen

	.DESCRIPTION
		Write Log to file and screen
		Each line has a UTC Timestamp

	.PARAMETER LogFile
		Name of the Logfile

	.NOTES
		Early Beta Version...
		Based on an idea/script of Michael Bayer

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(HelpMessage = 'Name of the Logfile')]
		[Alias('Log')]
		[string]$LogFile
	)

	BEGIN {
		# No Logfile?
		If ($LogFile -ne '') {
			# UTC Timestamp
			Set-Variable -Name "UtcTime" -Value $((Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%d %H:%M (UTC)')

			# Check for the LogFile
			If (Test-Path $LogFile) {
				# OK, we have a LogFile
				Write-Warning -Message "$LogFile already exists"
				Write-Output "Logging will append to $LogFile"
			} Else {
				# Create a brand new LogFile
				Write-Output "Logfile: $LogFile"
				New-Item -Path $LogFile -ItemType file | Out-Null
			}

			# Here is our LogFile
			Set-Variable -Name "MyLogFileName" -Scope:Script  -Value $($LogFile)

			# Create a start Header
			Add-Content $Script:MyLogFileName -Value "Logging start at $UtcTime `n"
		}

		# Have a buffer?
		If ($Script:MyLogBuffer -eq $null) {
			# Nope!
			$Script:MyLogBuffer = @()
		}
	}

	PROCESS {
		# UTC Timestamp
		Set-Variable -Name "UtcTime" -Value $((Get-Date).ToUniversalTime() | Get-Date -UFormat '%Y-%m-%d %H:%M:%S')

		# Create the Message Array
		$messages = @()

		# Fill the messages
		$messages += ('' + ($_ | Out-String)).TrimEnd().Split("`n")

		# Loop over the messages
		foreach ($message in $messages) {
			# Write a line
			Set-Variable -Name "LogMsg" -Value $($UtcTime + ': ' + ($message -replace "`n|`r", "").TrimEnd())

			# Inform
			Write-Output $LogMsg
			$Script:MyLogBuffer += $LogMsg
		}
	}

	END {
		try {
			# Dump the buffers
			$Script:MyLogBuffer | Add-Content $Script:MyLogFileName
		} catch {
			# Whoopsie!
			Write-PoshError -Message "Cannot write log into $MyLogFileName" -Stop
		}

		# Remove the Variable
		Remove-Variable -Name "MyLogBuffer" -Scope:Script -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}