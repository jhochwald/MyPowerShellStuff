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

function global:rdp {
<#
	.SYNOPSIS
		Wrapper for the Windows RDP Client

	.DESCRIPTION
		Just a wrapper for the Windows Remote Desktop Protocol (RDP) Client.

	.PARAMETER rdphost
		String

		The Host could be a host name or an IP address

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp SNOOPY

		Opens a Remote Desktop Session to the system with the Name SNOOPY

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:"deepblue.fra01.kreativsign.net"

		Opens a Remote Desktop Session to the system deepblue.fra01.kreativsign.net

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:10.10.16.10

		Opens a Remote Desktop Session to the system with the IPv4 address 10.10.16.10

	.NOTES
		Additional information about the function.

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
				   HelpMessage = 'The Host could be a host name or an IP address')]
		[ValidateNotNullOrEmpty()]
		[Alias('host')]
		[string]
		$rdphost
	)

	PROCESS {
		# What do we have?
		if (!($rdphost)) {
			Write-PoshError -Message "Mandatory Parameter HOST is missing" -Stop
		} else {
			Start-Process -FilePath mstsc -ArgumentList "/admin /w:1024 /h:768 /v:$rdphost"
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
