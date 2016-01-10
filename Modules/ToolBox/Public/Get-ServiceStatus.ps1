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

function Global:Get-ServiceStatus {
<#
	.SYNOPSIS
		List Services where StartMode is AUTOMATIC that are NOT running

	.DESCRIPTION
		This functionwill list services from a local or remote computer where the StartMode property is set to "Automatic" and where the state is different from RUNNING (so mostly where the state is NOT RUNNING)

	.PARAMETER ComputerName
		Computer Name to execute the function

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-ServiceStatus
		DisplayName                                  Name                           StartMode State
		-----------                                  ----                           --------- -----
		Microsoft .NET Framework NGEN v4.0.30319_X86 clr_optimization_v4.0.30319_32 Auto      Stopped
		Microsoft .NET Framework NGEN v4.0.30319_X64 clr_optimization_v4.0.30319_64 Auto      Stopped
		Multimedia Class Scheduler                   MMCSS                          Auto      Stopped

	.NOTES
		Just an inital Version of the Function, it might still need some optimization.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Position = 0,
				   HelpMessage = 'Computer Name to execute the function')]
		[string]
		$ComputerName = "$env:COMPUTERNAME"
	)

	PROCESS {
		if ($pscmdlet.ShouldProcess("Target", "Operation")) {
			# Try one or more commands
			try {
				# Cleanup
				Remove-Variable -Name "ServiceStatus" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

				# Get the Infos
				Set-Variable -Name "ServiceStatus" -Value $(Get-WmiObject Win32_Service -ComputerName $ComputerName | where { ($_.startmode -like "*auto*") -and ($_.state -notlike "*running*") } | select DisplayName, Name, StartMode, State | ft -AutoSize)

				# Dump it to the Console
				Write-Output -InputObject $ServiceStatus
			} catch {
				# Whoopsie!!!
				Write-Warning -Message 'Could not get the list of services for $ComputerName'
			} finally {
				# Cleanup
				Remove-Variable -Name "ServiceStatus" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
			}
		}
	}
}