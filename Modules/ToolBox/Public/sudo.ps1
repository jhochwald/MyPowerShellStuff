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

# Uni* like SuDo
function global:SuDo {
<#
	.SYNOPSIS
		Uni* like Superuser Do (Sudo)

	.DESCRIPTION
		Uni* like Superuser Do (Sudo)

	.PARAMETER file
		Script/Program to run

	.EXAMPLE
		PS C:\scripts\PowerShell> SuDo C:\scripts\PowerShell\profile.ps1

	.EXAMPLE
		SuDo

	.NOTES
		Still a internal Beta function!
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = ' Script/Program to run')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		[string]
		$file
	)

	BEGIN {
		#
	}

	PROCESS {
		# Define some defaults
		$sudo = new-object System.Diagnostics.ProcessStartInfo
		$sudo.Verb = "runas";
		$sudo.FileName = "$pshome\PowerShell.exe"
		$sudo.windowStyle = "Normal"
		$sudo.WorkingDirectory = (Get-Location)

		# What to execute?
		if ($file) {
			if ((Test-Path $file) -eq $True) {
				$sudo.Arguments = "-executionpolicy unrestricted -NoExit -noprofile -Command $file"
			} else {
				write-error -Message:"Error: File does not exist - $file" -ErrorAction:Stop
			}
		} else {
			# No file given, so we open a Shell (Console)
			$sudo.Arguments = "-executionpolicy unrestricted -NoExit -Command  &{set-location '" + (get-location).Path + "'}"
		}

		# NET call to execute SuDo
		[System.Diagnostics.Process]::Start($sudo) | out-null
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
