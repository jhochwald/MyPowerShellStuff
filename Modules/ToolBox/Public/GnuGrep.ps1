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

# Old implementation of the above GREP tool
# More complex but even more UNI* like
function global:GnuGrep {
<#
	.SYNOPSIS
		File pattern searcher

	.DESCRIPTION
		This command emulates the well known (and loved?) GNU file pattern searcher

	.PARAMETER pattern
		Pattern (STRING) - Mandatory

	.PARAMETER filefilter
		File (STRING) - Mandatory

	.PARAMETER r
		Recurse

	.PARAMETER i
		Ignore case

	.PARAMETER l
		List filenames

	.NOTES
		Make PowerShell a bit more like *NIX!

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
				   Position = 0,
				   HelpMessage = ' Pattern (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('PaternString')]
		[string]
		$pattern,
		[Parameter(Mandatory = $true,
				   Position = 1,
				   HelpMessage = ' File (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('FFilter')]
		[string]
		$filefilter,
		[Alias('Recursive')]
		[switch]
		$r,
		[Alias('IgnoreCase')]
		[switch]
		$i,
		[Alias('ListFilenames')]
		[switch]
		$l
	)

	BEGIN {
		# Define object
		Set-Variable -Name path -Value $($pwd)

		# need to add filter for files only, no directories
		Set-Variable -Name files -Value $(Get-ChildItem $path -include "$filefilter" -recurse:$r)
	}

	PROCESS {
		# What to do?
		if ($l) {
			# Do we need to loop?
			$files | foreach
			{
				# What is it?
				if ($(Get-Content $_ | select-string -pattern $pattern -caseSensitive:$i).Count > 0) {
					$_ | Select-Object path
				}
			}
			select-string $pattern $files -caseSensitive:$i
		} else {
			$files | foreach
			{
				$_ | select-string -pattern $pattern -caseSensitive:$i
			}
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
