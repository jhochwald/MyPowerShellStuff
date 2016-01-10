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

function Get-HostFileEntry {
<#
	.SYNOPSIS
		Dumps the HOSTS File to the Console

	.DESCRIPTION
		Dumps the HOSTS File to the Console
		It dumps the WINDIR\System32\drivers\etc\hosts

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-HostFileEntry

		IP                                                              Hostname
		--                                                              --------
		10.211.55.123                                                   GOV13714W7
		10.211.55.10                                                    jhwsrv08R2
		10.211.55.125                                                   KSWIN07DEV

		Dumps the HOSTS File to the Console

	.NOTES
		This is just a little helper function to make the shell more flexible
		Sometimes I need to know what is set in the HOSTS File... So I came up with that approach.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Cleanup
		$HostOutput = @()

		# Which File to load
		Set-Variable -Name "HostFile" -Scope:Script -Value $($env:windir + "\System32\drivers\etc\hosts")

		# REGEX Filter
		[regex]$r = "\S"
	}

	PROCESS {
		# Open the File from above
		Get-Content $HostFile | ? {
			(($r.Match($_)).value -ne "#") -and ($_ -notmatch "^\s+$") -and ($_.Length -gt 0)
		} | % {
			$_ -match "(?<IP>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<HOSTNAME>\S+)" | Out-Null
			$HostOutput += New-Object -TypeName PSCustomObject -Property @{ 'IP' = $matches.ip; 'Hostname' = $matches.hostname }
		}

		# Dump it to the Console
		Write-Output $HostOutput
	}
}