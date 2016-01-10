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

function Global:Get-NetStat {
<#
	.SYNOPSIS
		This function will get the output of netstat -n and parse the output

	.DESCRIPTION
		This function will get the output of netstat -n and parse the output

	.NOTES
		Based on an idea of Francois-Xavier Cat

	.LINK
		Idea: http://www.lazywinadmin.com/2014/08/powershell-parse-this-netstatexe.html

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Get the output of netstat
		Set-Variable -Name "data" -Value $(netstat -n)

		# Keep only the line with the data (we remove the first lines)
		Set-Variable -Name "data" -Value $($data[4..$data.count])

		# Each line need to be splitted and get rid of unnecessary spaces
		foreach ($line in $data) {
			# Get rid of the first whitespaces, at the beginning of the line
			Set-Variable -Name "line" -Value $($line -replace '^\s+', '')

			# Split each property on whitespaces block
			Set-Variable -Name "line" -Value $($line -split '\s+')

			# Define the properties
			$properties = @{
				Protocole = $line[0]
				LocalAddressIP = ($line[1] -split ":")[0]
				LocalAddressPort = ($line[1] -split ":")[1]
				ForeignAddressIP = ($line[2] -split ":")[0]
				ForeignAddressPort = ($line[2] -split ":")[1]
				State = $line[3]
			}

			# Output the current line
			New-Object -TypeName PSObject -Property $properties
		}
	}
}