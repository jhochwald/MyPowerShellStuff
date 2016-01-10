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

function Global:Get-DefaultMessage {
<#
	.SYNOPSIS
		Helper Function to show default message used in VERBOSE/DEBUG/WARNING

	.DESCRIPTION
		Helper Function to show default message used in VERBOSE/DEBUG/WARNING
		and... HOST in some case.
		This is helpful to standardize the output messages

	.PARAMETER Message
		Specifies the message to show

	.NOTES
		Based on an ideas of Francois-Xavier Cat

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	param
	(
		[Parameter(HelpMessage = 'Specifies the message to show')]
		[string]
		$Message
	)

	PROCESS {
		# Set the Variables
		Set-Variable -Name "DateFormat" -Scope:Script -Value $(Get-Date -Format 'yyyy/MM/dd-HH:mm:ss:ff')
		Set-Variable -Name "FunctionName" -Scope:Script -Value $((Get-Variable -Scope 1 -Name MyInvocation -ValueOnly).MyCommand.Name)

		# Dump to the console
		Write-Output "[$DateFormat][$FunctionName] $Message"
	}
}

function Global:Disable-RemoteDesktop {
<#
	.SYNOPSIS
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.

	.DESCRIPTION
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.

	.PARAMETER ComputerName
		Specifies the computername

	.PARAMETER Credential
		Specifies the credential to use

	.PARAMETER CimSession
		Specifies one or more existing CIM Session(s) to use

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01 -Credential (Get-Credential -cred "FX\SuperAdmin")

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session1,$session2,$session3

	.NOTES
		Based on an idea of Francois-Xavier Cat
#>

	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Specifies the computername')]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]
		$CimSession
	)

	BEGIN {
		#
	}

	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				$CIMComputer = $($Cim.ComputerName).ToUpper()

				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						CimSession = $Cim
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessGetCimInstance"
					}

					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName = "SetAllowTSConnections"
						Arguments = @{
							AllowTSConnections = 0;
							ModifyFirewallException = 0
						}
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessInvokeCim"
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - disable Remote Desktop (and Modify Firewall Exception")

					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} catch {
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")

					if ($ErrorProcessGetCimInstance) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance")
					}
					if ($ErrorProcessInvokeCim) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod")
					}

					Write-Warning -Message $Error[0].Exception.Message
				} finally {
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}

		foreach ($Computer in $ComputerName) {
			# Set a variable with the computername all upper case
			Set-Variable -Name "Computer" -Value $($Computer.ToUpper())

			try {
				# Be verbose
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")

				if (Test-Connection -Computer $Computer -count 1 -quiet) {
					$Splatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						ComputerName = $Computer
						ErrorAction = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}

					if ($PSBoundParameters['Credential']) {
						$Splatting.credential = $Credential
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - disable Remote Desktop")

					# disable Remote Desktop
					(Get-WmiObject @Splatting).SetAllowTsConnections(0, 0) | Out-Null

					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")

				if ($ErrorProcessGetWmi) {
					Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject")
				}

				Write-Warning -MEssage $Error[0].Exception.Message
			} finally {
				$Splatting.Clear()
			}
		}
	}
}

function Global:Enable-RemoteDesktop {
<#
	.SYNOPSIS
		The function Enable-RemoteDesktop will enable RemoteDesktop on a local or remote machine.

	.DESCRIPTION
		The function Enable-RemoteDesktop will enable RemoteDesktop on a local or remote machine.

	.PARAMETER ComputerName
		Specifies the computername

	.PARAMETER Credential
		Specifies the credential to use

	.PARAMETER CimSession
		Specifies one or more existing CIM Session(s) to use

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -ComputerName DC01

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -ComputerName DC01 -Credential (Get-Credential -cred "FX\SuperAdmin")

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -CimSession $Session

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -CimSession $Session1,$session2,$session3

	.NOTES
		Based on an idea of Francois-Xavier Cat
#>

	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Specifies the computername')]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]
		$CimSession
	)

	BEGIN {
		#
	}

	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				# Create a Variable with an all upper case computer name
				Set-Variable -Name "CIMComputer" -Value $($($Cim.ComputerName).ToUpper())

				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						CimSession = $Cim
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessGetCimInstance"
					}

					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName = "SetAllowTSConnections"
						Arguments = @{
							AllowTSConnections = 1;
							ModifyFirewallException = 1
						}
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessInvokeCim"
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Enable Remote Desktop (and Modify Firewall Exception")

					#
					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} CATCH {
					# Whoopsie!
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")

					if ($ErrorProcessGetCimInstance) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance")
					}

					if ($ErrorProcessInvokeCim) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod")
					}

					Write-Warning -Message $Error[0].Exception.Message
				} FINALLY {
					# Cleanup
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}

		foreach ($Computer in $ComputerName) {
			# Creatre a Variable with the all upper case Computername
			Set-Variable -Name "Computer" -Value $($Computer.ToUpper())

			try {
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")
				if (Test-Connection -Computer $Computer -count 1 -quiet) {
					$Splatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						ComputerName = $Computer
						ErrorAction = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}

					if ($PSBoundParameters['Credential']) {
						$Splatting.credential = $Credential
					}

					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - Enable Remote Desktop")

					# Enable Remote Desktop
					(Get-WmiObject @Splatting).SetAllowTsConnections(1, 1) | Out-Null

					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				# Whoopsie!
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")

				if ($ErrorProcessGetWmi) {
					Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject")
				}

				Write-Warning -MEssage $Error[0].Exception.Message
			} finally {
				# Cleanup
				$Splatting.Clear()
			}
		}
	}
}