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

function global:Get-TcpPortStatus {
<#
	.SYNOPSIS
		Check a TCP Port

	.DESCRIPTION
		Opens a connection to a given (or default) TCP Port to a given (or default) server.
		This is not a simple port ping, it creates a real connection to see if the port is alive!

	.PARAMETER Port
		Default is 587
		e.g. "25"
		Port to use

	.PARAMETER Server
		e.g. "outlook.office365.com" or "192.168.16.10"
		SMTP Server to use

	.EXAMPLE
		PS C:\> Get-TcpPortStatus

		Check port 587/TCP on the default Server

	.EXAMPLE
		PS C:\> Get-TcpPortStatus -Port:25 -Server:mx.net-experts.net
		True

		Check port 25/TCP on Server mx.net-experts.net

	.OUTPUTS
		boolean

	.NOTES
		Internal Helper function to check if we can reach a server via a TCP connection on a given port

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[Int32]
		$Port = 587,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[string]
		$Server
	)

	BEGIN {
		# Cleanup
		Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# Set the defaults for some stuff
		if (!($Port)) {
			# This is the default TCP Port to Check
			Set-Variable -Name Port -Value $("587" -as ([int] -as [type]))
		}

		# Server given?
		if (!($Server)) {
			# Do we know any defaults?
			if (!($PSEmailServer)) {
				# We have a default SMTP Server, use it!
				Set-Variable -Name Server -Value $("$PSEmailServer" -as ([string] -as [type]))
			} else {
				# Aw Snap! No Server given on the command line, no Server configured as default... BAD!
				Write-PoshError -Message "No SMTP Server given, no default configured" -Stop
			}
		}

		# Create a function to open a TCP connection
		Set-Variable -Name ThePortStatus -Value $(New-Object Net.Sockets.TcpClient -ErrorAction SilentlyContinue)

		# Look if the Server is Online and the port is open
		try {
			# Try to connect to one of the on Premise Exchange front end servers
			$ThePortStatus.Connect($Server, $Port)
		} catch [System.Exception] {
			# BAD, but do nothing yet! This is something the caller must handle
		}

		# Share the info with the caller
		$ThePortStatus.Client.Connected

		# Cleanup
		Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# CLOSE THE TCP Connection
		if ($ThePortStatus.Connected) {
			# Mail works, close the connection
			$ThePortStatus.Close()
		}
	}

	END {
		# Cleanup
		Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
# Set a compatibility Alias
(set-alias IsSmtpMessageAlive Get-TcpPortStatus -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
(set-alias CheckTcpPort Get-TcpPortStatus -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
