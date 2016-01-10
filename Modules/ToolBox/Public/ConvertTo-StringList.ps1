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

function Global:ConvertTo-StringList {
<#
	.SYNOPSIS
		Function to convert an array into a string list with a delimiter.

	.DESCRIPTION
		Function to convert an array into a string list with a delimiter.

	.PARAMETER Array
		Specifies the array to process.

	.PARAMETER Delimiter
		Separator between value, default is ","

	.EXAMPLE
		$Computers = "Computer1","Computer2"
		ConvertTo-StringList -Array $Computers

		Output:
		Computer1,Computer2

	.EXAMPLE
		$Computers = "Computer1","Computer2"
		ConvertTo-StringList -Array $Computers -Delimiter "__"

		Output:
		Computer1__Computer2

	.EXAMPLE
		$Computers = "Computer1"
		ConvertTo-StringList -Array $Computers -Delimiter "__"

		Output:
		Computer1

	.NOTES
		Based on an idea of Francois-Xavier Cat

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   HelpMessage = 'Specifies the array to process.')]
		[ValidateNotNullOrEmpty()]
		[System.Array]
		$Array,
		[Parameter(HelpMessage = 'Separator between value')]
		[system.string]
		$Delimiter = ","
	)

	BEGIN {
		Remove-Variable -Name "StringList" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# Be verbose
		Write-Verbose -Message "Array: $Array"

		# Loop over each iten in the array
		foreach ($item in $Array) {
			# Adding the current object to the list
			$StringList += "$item$Delimiter"
		}

		# Be verbose
		Write-Verbose "StringList: $StringList"
	}

	END {
		try {
			if ($StringList) {
				$lenght = $StringList.Length

				# Be verbose
				Write-Verbose -Message "StringList Lenght: $lenght"

				# Output Info without the last delimiter
				$StringList.Substring(0, ($lenght - $($Delimiter.length)))
			}
		} catch {
			Write-Warning -Message "[END] Something wrong happening when output the result"
			$Error[0].Exception.Message
		} finally {
			Remove-Variable -Name "StringList" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}
}