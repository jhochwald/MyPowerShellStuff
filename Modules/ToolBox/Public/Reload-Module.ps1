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

# Reload-Module
function global:Reload-Module {
<#
	.SYNOPSIS
		Reloads a PowerShell Module

	.DESCRIPTION
		Reloads a PowerShell Module

	.PARAMETER ModuleName
		Name of the Module

	.NOTES
		Needs to be documented

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
				   HelpMessage = 'Name of the Module')]
		[ValidateNotNullOrEmpty()]
		[Alias('Module')]
		$ModuleName
	)

	BEGIN {
		#
	}

	PROCESS {
		# What to do?
		if ((get-module -all | where{ $_.name -eq "$ModuleName" } | measure-object).count -gt 0) {
			# Unload the Module
			remove-module $ModuleName

			# Verbose Message
			Write-Verbose "Module $ModuleName Unloaded"

			# Define objects
			Set-Variable -Name pwd -Value $(Get-ScriptDirectory)
			Set-Variable -Name file_path -Value $($ModuleName;)

			# is this a module?
			if (Test-Path (join-Path $pwd "$ModuleName.psm1")) {
				Set-Variable -Name file_path -Value $(join-Path $pwd "$ModuleName.psm1")
			}

			# Load the module
			import-module "$file_path" -DisableNameChecking -verbose:$false

			# verbose message
			Write-Verbose "Module $ModuleName Loaded"
		} else {
			Write-Warning "Module $ModuleName Doesn't Exist"
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
