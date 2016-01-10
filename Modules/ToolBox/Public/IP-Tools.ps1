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

function global:Convert-IPtoDecimal {
<#
	.SYNOPSIS
		Converts an IP address to decimal.

	.DESCRIPTION
		Converts an IP address to decimal value.

	.PARAMETER IPAddress
		An IP Address you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> Convert-IPtoDecimal -IPAddress '127.0.0.1','192.168.0.1','10.0.0.1'

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.EXAMPLE
		PS C:\scripts\PowerShell> Convert-IPtoDecimal '127.0.0.1','192.168.0.1','10.0.0.1'

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.EXAMPLE
		PS C:\scripts\PowerShell> '127.0.0.1','192.168.0.1','10.0.0.1' |  Convert-IPtoDecimal

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.NOTES
		Sometimes I need to have that info, so I decided it would be great to have a functions who do the job!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding()]
	[OutputType([psobject])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'An IP Address you want to check')]
		[Alias('IP')]
		[string]
		$IPAddress
	)

	BEGIN {
		# Dummy block - We so nothing here
	}

	PROCESS {
		# OK make sure the we have a string here!
		# Then we split everthing based on the DOTs.
		[String[]]$IP = $IPAddress.Split('.')

		# Create a new object and transform it to Decimal
		$Object = New-Object -TypeName psobject -Property (@{
			'IPAddress' = $($IPAddress);
			'Decimal' = [Int64](
			([Int32]::Parse($IP[0]) * [Math]::Pow(2, 24) +
			([Int32]::Parse($IP[1]) * [Math]::Pow(2, 16) +
			([Int32]::Parse($IP[2]) * [Math]::Pow(2, 8) +
			([Int32]::Parse($IP[3])
			)
			)
			)
			)
			)
		})
	}

	END {
		# Dump the info to the console
		Write-Output $Object
	}
}

function global:Check-IPaddress {
<#
	.SYNOPSIS
		Check if a given IP Address seems to be valid

	.DESCRIPTION
		Check if a given IP Address seems to be valid.
		We use the .NET function to do so. This is not 100% reliable,
		but is enough most times.

	.PARAMETER IPAddress
		An IP Address you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> Check-IPaddress

	.NOTES
		This is just a little helper function to make the shell more flexible

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
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0,
				   HelpMessage = 'An IP Address you want to check')]
		[ValidateScript({
			$_ -match [IPAddress]
			$_
		})]
		[Alias('IP')]
		[string]
		$IPAddress
	)

	BEGIN {
		#
	}

	PROCESS {
		# Use the .NET Call to figure out if the given address is valid or not.
		Set-Variable -Name "IsValid" -Scope:Script -Value $(($IPAddress -As [IPAddress]) -As [Bool])
	}

	END {
		# Dump the bool value to the console
		Write-Output $IsValid
	}
}

function global:Get-NtpTime {
<#
	.SYNOPSIS
		Get the NTP Time from a given Server

	.DESCRIPTION
		Get the NTP Time from a given Server.

	.PARAMETER Server
		NTP Server to use. The default is de.pool.ntp.org

	.NOTES
		This sends an NTP time packet to the specified NTP server and reads back the response.
		The NTP time packet from the server is decoded and returned.

		Note: this uses NTP (rfc-1305: http://www.faqs.org/rfcs/rfc1305.html) on UDP 123.
		Because the function makes a single call to a single server this is strictly a
		SNTP client (rfc-2030).
		Although the SNTP protocol data is similar (and can be identical) and the clients
		and servers are often unable to distinguish the difference.  Where SNTP differs is that
		is does not accumulate historical data (to enable statistical averaging) and does not
		retain a session between client and server.

		An alternative to NTP or SNTP is to use Daytime (rfc-867) on TCP port 13 –
		although this is an old protocol and is not supported by all NTP servers.

	.LINK
		Source: https://chrisjwarwick.wordpress.com/2012/08/26/getting-ntpsntp-network-time-with-powershell/
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([datetime])]
	param
	(
		[Parameter(HelpMessage = 'NTP Server to use. The default is de.pool.ntp.org')]
		[Alias('NETServer')]
		[string]
		$Server = 'de.pool.ntp.org'
	)

	PROCESS {
		# Construct client NTP time packet to send to specified server
		# (Request Header: [00=No Leap Warning; 011=Version 3; 011=Client Mode]; 00011011 = 0x1B)
		[Byte[]]$NtpData =, 0 * 48
		$NtpData[0] = 0x1B

		# Create the connection
		$Socket = New-Object Net.Sockets.Socket([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Dgram, [Net.Sockets.ProtocolType]::Udp)

		# Configure the connection
		$Socket.Connect($Server, 123)
		[Void]$Socket.Send($NtpData)

		# Returns length – should be 48
		[Void]$Socket.Receive($NtpData)

		# Close the connection
		$Socket.Close()

		<#
			Decode the received NTP time packet

			We now have the 64-bit NTP time in the last 8 bytes of the received data.
			The NTP time is the number of seconds since 1/1/1900 and is split into an
			integer part (top 32 bits) and a fractional part, multipled by 2^32, in the
			bottom 32 bits.
		#>

		# Convert Integer and Fractional parts of 64-bit NTP time from byte array
		$IntPart = 0; Foreach ($Byte in $NtpData[40..43]) { $IntPart = $IntPart * 256 + $Byte }
		$FracPart = 0; Foreach ($Byte in $NtpData[44..47]) { $FracPart = $FracPart * 256 + $Byte }

		# Convert to Millseconds (convert fractional part by dividing value by 2^32)
		[UInt64]$Milliseconds = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)

		# Create UTC date of 1 Jan 1900,
		# add the NTP offset and convert result to local time
		(New-Object DateTime(1900, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)).AddMilliseconds($Milliseconds).ToLocalTime()
	}
}
# Set a compatibility Alias
(set-alias Get-AtomicTime Get-NtpTime -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
