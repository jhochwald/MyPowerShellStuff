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

function global:Check-SessionArch {
<#
	.SYNOPSIS
		Show the CPU architecture

	.DESCRIPTION
		You want to know if this is a 64BIT or still a 32BIT system?
		Might be useful, maybe not!

	.EXAMPLE
		PS C:\scripts\PowerShell> Check-SessionArch
		x64

		Shows that the architecture is 64BIT and that the session also supports X64

	.OUTPUTS
		String

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()

	PROCESS {
		# Figure out if this is a x64 or x86 system via NET call
		if ([System.IntPtr]::Size -eq 8) {
			Write-Output "x64"
		} elseif ([System.IntPtr]::Size -eq 4) {
			Write-Output "x86"
		} else {
			Write-Output "Unknown Type"
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
