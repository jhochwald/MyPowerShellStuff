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

function Global:Get-NetFramework {
<#
	.SYNOPSIS
		This function will retrieve the list of Framework Installed on the computer.

	.DESCRIPTION
		A detailed description of the Get-NetFramework function.

	.PARAMETER ComputerName
		Computer Name

	.PARAMETER Credentials
		Credentials to use

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-NetFramework

		PSChildName                                   Version
		-----------                                   -------
		v2.0.50727                                    2.0.50727.4927
		v3.0                                          3.0.30729.4926
		Windows Communication Foundation              3.0.4506.4926
		Windows Presentation Foundation               3.0.6920.4902
		v3.5                                          3.5.30729.4926
		Client                                        4.5.51641
		Full                                          4.5.51641
		Client                                        4.0.0.0

	.NOTES

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(HelpMessage = 'Computer Name')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(HelpMessage = 'Credentials to use')]
		$Credentials = $Credential
	)

	BEGIN {
		$Splatting = @{
			ComputerName = $ComputerName
		}
	}

	PROCESS {
		if ($PSBoundParameters['Credential']) {
			$Splatting.credential = $Credentials
		}

		Invoke-Command @Splatting -ScriptBlock {
			Write-Verbose -Message "$pscomputername"

			# Get the Net Framework Installed
			$netFramework = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
			Get-ItemProperty -name Version -EA 0 |
			Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } |
			Select-Object -Property PSChildName, Version

			# Prepare output
			$Properties = @{
				ComputerName = "$($env:Computername)$($env:USERDNSDOMAIN)"
				PowerShellVersion = $psversiontable.PSVersion.Major
				NetFramework = $netFramework
			}

			New-Object -TypeName PSObject -Property $Properties
		}
	}
}