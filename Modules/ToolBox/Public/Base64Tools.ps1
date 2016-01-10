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

function Global:ConvertTo-Base64 {
<#
	.SYNOPSIS
		Convert a String to a Base 64 encoded String

	.DESCRIPTION
		Convert a String to a Base 64 encoded String

	.PARAMETER plain
		Unencodes Input String

	.EXAMPLE
		PS C:\> ConvertTo-Base64 -plain "Hello World"
		SABlAGwAbABvACAAVwBvAHIAbABkAA==

		Convert a String to a Base 64 encoded String

	.EXAMPLE
		PS C:\> "Just a String" | ConvertTo-Base64
		SgB1AHMAdAAgAGEAIABTAHQAcgBpAG4AZwA=

		Convert a String to a Base 64 encoded String via Pipe(line)

	.NOTES
		N.N.
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Unencodes Input String')]
		[ValidateNotNullOrEmpty()]
		[Alias('unencoded')]
		[System.String]$plain
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "GetBytes" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "EncodedString" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# GetBytes .NET
		Set-Variable -Name "GetBytes" -Value $([System.Text.Encoding]::Unicode.GetBytes($plain))

		#  Cobert to Base64 via .NET
		Set-Variable -Name "EncodedString" -Value $([Convert]::ToBase64String($GetBytes))
	}

	END {
		# Dump the Info
		Write-Output -InputObject $EncodedString
	}
}

function Global:ConvertFrom-Base64 {
<#
	.SYNOPSIS
		Decode a Base64 encoded String back to a plain String

	.DESCRIPTION
		Decode a Base64 encoded String back to a plain String

	.PARAMETER encoded
		Base64 encoded String

	.EXAMPLE

		PS C:\> ConvertFrom-Base64 -encoded "SABlAGwAbABvACAAVwBvAHIAbABkAA=="
		Hello World

		Decode a Base64 encoded String back to a plain String

	.EXAMPLE
		PS C:\> "SABlAGwAbABvACAAVwBvAHIAbABkAA==" | ConvertFrom-Base64
		Hello World

		Decode a Base64 encoded String back to a plain String via Pipe(line)

	.NOTES
		N.N.
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Base64 encoded String')]
		[ValidateNotNullOrEmpty()]
		[System.String]$encoded
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "DecodedString" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# Decode the Base64 encoded string back
		Set-Variable -Name "DecodedString" -Value $(([System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($encoded))) -as ([string] -as [type]))
	}

	END {
		# Dump the Info
		Write-Output -InputObject $DecodedString

		# Cleanup
		Remove-Variable -Name "DecodedString" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
}