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

function global:tail {
<#
	.SYNOPSIS
		Make the PowerShell a bit more *NIX like

	.DESCRIPTION
		Wrapper for the PowerShell command Get-Content. It opens a given file and shows the content...
		Get-Content normally exists as soon as the end of the given file is reached, this wrapper keeps it open and display every new informations as soon as it appears. This could be very useful for parsing log files.

		Everyone ever used Unix or Linux known tail ;-)

	.PARAMETER f
		Follow

	.PARAMETER file
		File to open

	.EXAMPLE
		PS C:\> tail C:\scripts\PowerShell\logs\create_new_OU_Structure.log

		Opens the given Log file (C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows every new entry until you break it (CTRL + C)

	.OUTPUTS
		String

	.NOTES
		Make PowerShell a bit more like *NIX!

	.INPUTS
		String

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(HelpMessage = 'Follow')]
		[switch]$f,
		[Parameter(Mandatory = $true,
				   HelpMessage = 'File to open')]
		[ValidateNotNullOrEmpty()]
		$file
	)

	BEGIN {
		#
	}

	PROCESS {
		if ($f) {
			# Follow is enabled, dump the last 10 lines and follow the stream
			Get-Content $file -Tail 10 -Wait
		} else {
			# Follow is not enabled, just dump the last 10 lines
			Get-Content $file -Tail 10
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

<#
	This is the former version...
	Deprecated and will be removed soon!
#>
function global:tail2 {
<#
	.SYNOPSIS
		Make the PowerShell a bit more *NIX like

	.DESCRIPTION
		Wrapper for the PowerShell command Get-Content. It opens a given file and shows the content...
		Get-Content normally exists as soon as the end of the given file is reached, this wrapper keeps it open
		and display every new informations as soon as it appears. This could be very useful for parsing log files.

		Everyone ever used Unix or Linux known tail ;-)

	.PARAMETER file
		File to open

	.EXAMPLE
		PS C:\> tail2 C:\scripts\PowerShell\logs\create_new_OU_Structure.log

		Opens the given Log file (C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows every new entry until you break it (CTRL + C)

	.OUTPUTS
		String

	.NOTES
		Make PowerShell a bit more like *NIX!

	.INPUTS
		String

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
				   HelpMessage = 'File to open')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		$file
	)

	BEGIN {
		#
	}

	PROCESS {
		# Is the File given?
		if (!($file)) {
			# Aw SNAP! That sucks...
			Write-Error -Message:"Error: File to tail is missing..." -ErrorAction:Stop
		} else {
			# tailing the file for you, Sir! ;-)
			Get-Content $file -Wait
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
