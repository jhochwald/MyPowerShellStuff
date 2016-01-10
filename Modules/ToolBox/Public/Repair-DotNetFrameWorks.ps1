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

function global:Repair-DotNetFrameWorks {
<#
	.SYNOPSIS
		Optimize all installed NET Frameworks

	.DESCRIPTION
		Optimize all installed NET Frameworks by executing NGEN.EXE for each.

		This could be useful to improve the performance and sometimes the
		installation of new NET Frameworks, or even patches, makes them use
		a single (the first) core only.

		Why Microsoft does not execute the NGEN.EXE with each installation... no idea!

	.EXAMPLE
		PS C:\> Repair-DotNetFrameWorks

		Optimize all installed NET Frameworks

	.NOTES
		The Function name is changed!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Cleanup
		Remove-Variable frameworks -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# Get all NET framework paths and build an array with it
		$frameworks = @("$env:SystemRoot\Microsoft.NET\Framework")

		# If we run on an 64Bit system (what we should), we add these frameworks to
		If (Test-Path "$env:SystemRoot\Microsoft.NET\Framework64") {
			# Add the 64Bit Path to the array
			$frameworks += "$env:SystemRoot\Microsoft.NET\Framework64"
		}

		# Loop over all NET frameworks that we found.
		ForEach ($framework in $frameworks) {
			# Find the latest version of NGEN.EXE in the current framework path
			$ngen_path = Join-Path (Join-Path $framework -childPath (Get-ChildItem $framework | Where-Object { ($_.PSIsContainer) -and (Test-Path (Join-Path $_.FullName -childPath "ngen.exe")) } | Sort-Object Name -Descending | Select-Object -First 1).Name) -childPath "ngen.exe"

			# Execute the optimization command and suppress the output, we also prevent a new window
			Write-Output "$ngen_path executeQueuedItems"
			Start-Process $ngen_path -ArgumentList "executeQueuedItems" -NoNewWindow -Wait -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -LoadUserProfile:$false -RedirectStandardOutput null
		}
	}

	END {
		# Cleanup
		Remove-Variable frameworks -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
}
