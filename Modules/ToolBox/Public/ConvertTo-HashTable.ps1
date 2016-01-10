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

Function Global:ConvertTo-HashTable {
<#
	.Synopsis
		Convert an object to a HashTable

	.Description
		Convert an object to a HashTable excluding certain types.  For example, ListDictionaryInternal doesn't support serialization therefore
		can't be converted to JSON.

	.Parameter InputObject
		Object to convert

	.Parameter ExcludeTypeName
		Array of types to skip adding to resulting HashTable.  Default is to skip ListDictionaryInternal and Object arrays.

	.Parameter MaxDepth
		Maximum depth of embedded objects to convert.  Default is 4.

	.Example
		$bios = get-ciminstance win32_bios
		$bios | ConvertTo-HashTable

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	Param (
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)]
		[Object]$InputObject,
		[string[]]$ExcludeTypeName = @("ListDictionaryInternal","Object[]"),
		[ValidateRange(1,10)][Int]$MaxDepth = 4
	)

	BEGIN {
		#
		Write-Verbose "Converting to hashtable $($InputObject.GetType())"
	}

	PROCESS {
		#$propNames = Get-Member -MemberType Properties -InputObject $InputObject | Select-Object -ExpandProperty Name
		$propNames = $InputObject.psobject.Properties | Select-Object -ExpandProperty Name

		$hash = @{}

		$propNames | % {
			if ($InputObject.$_ -ne $null) {
				if ($InputObject.$_ -is [string] -or (Get-Member -MemberType Properties -InputObject ($InputObject.$_) ).Count -eq 0) {
					$hash.Add($_,$InputObject.$_)
				} else {
					if ($InputObject.$_.GetType().Name -in $ExcludeTypeName) {
						Write-Verbose "Skipped $_"
					} elseif ($MaxDepth -gt 1) {
						$hash.Add($_,(ConvertTo-HashTable -InputObject $InputObject.$_ -MaxDepth ($MaxDepth - 1)))
					}
				}
			}
		}

		Write-Output $hash
	}
}