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


# Make Powershell more Uni* like
function global:Load-Test {
<#
	.SYNOPSIS
		Load Pester Module

	.DESCRIPTION
		Load the Pester PowerShell Module to the Global context.
		Pester is a Mockup, Unit Test and Function Test Module for PowerShell

	.NOTES
		Pester Module must be installed

	.LINK
		Pester: https://github.com/pester/Pester

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Lets check if the Pester PowerShell Module is installed
		if (Get-Module -ListAvailable -Name Pester -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) {
			try {
				#Make sure we remove the Pester Module (if loaded)
				Remove-Module -name [P]ester -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

				# Import the Pester PowerShell Module in the Global context
				Import-Module -Name [P]ester -DisableNameChecking -force -Scope Global -ErrorAction stop -WarningAction SilentlyContinue
			} catch {
				# Sorry, Pester PowerShell Module is not here!!!
				Write-Error -Message:"Error: Pester Module was not imported..." -ErrorAction:Stop

				# Still here? Make sure we are done!
				break

				# Aw Snap! We are still here? Fix that the Bruce Willis way: DIE HARD!
				exit 1
			}
		} else {
			# Sorry, Pester PowerShell Module is not here!!!
			Write-Warning  "Pester Module is not installed! Go to https://github.com/pester/Pester to get it!"
		}
	}
}
# Set a compatibility Alias
(set-alias Load-Pester Load-Test -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
