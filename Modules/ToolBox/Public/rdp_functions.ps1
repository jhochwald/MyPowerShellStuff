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
		"Copyright": "(c) 2012-2016 by Joerg Hochwald & Associates. All rights reserved."
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

	#################################################
	# modified by     : Joerg Hochwald
	# last modified   : 2016-03-16
	#################################################
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
		Support https://github.com/jhochwald/MyPowerShellStuff/issues
#>

	param
	(
		[Parameter(HelpMessage = 'Specifies the message to show')]
		[System.String]$Message
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
		[String[]]$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)

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
		[String[]]$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]$CimSession
	)

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

# SIG # Begin signature block
# MIIfOgYJKoZIhvcNAQcCoIIfKzCCHycCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBtotyJY54eQCr0wuGfSR3fLm
# xjSgghnLMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNTAyMDMwMDAw
# MDBaFw0yNjAzMDMwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCAMtwHjRygnJ08Kug9IYtZoU1+zETOA75+qrzE5ntz
# u0vxiNqQTnU3KDhjudcrD1SpVs53OZcwc82b2dkFRRyNpLgDXU/ZHC6Y4OmI5uzX
# BX5WKnv3FlujrY+XJRKEG7JcY0oK0u8QVEeChDVpKJwM5B8UFiT6ddx0cm5OyuNq
# Q6/PfTZI0b3pBpEsL6bIcf3PvdidIZj8r9veIoyvp/N3753co3BLRBrweIUe8qWM
# ObXciBw37a0U9QcLJr2+bQJesbiwWGyFOg32/1onDMXeU+dUPFZMyU5MMPbyXPsa
# jMKCvq1ZkfYbTVV7z1sB3P16028jXDJHmwHzwVEURoqbMIIFTDCCBDSgAwIBAgIQ
# FtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAwMDAwWhcNMTgwNzE2MjM1OTU5WjCB
# kDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1NTc2MQ8wDQYDVQQIDAZIZXNzZW4x
# EDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkMD0JhaG5ob2ZzcGxhdHogMTEZMBcG
# A1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcGA1UEAwwQS3JlYXRpdlNpZ24gR21i
# SDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8jDmF0TO09qJndJ9eG
# Fqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8kE5sL4/dMhuTOp+SMt0tI/SON6BY3
# 208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD8AIyrTH9b27wDNX4rC914Ka4EBI8
# sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSazE9yyRTuffidmtHV49DHPr+ql4ji
# NJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUukpzdCaA0UzygGUdDfgy0htSSp8MR9
# Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnkq0bXUIC6H0Zolnfl4fanvVYyvD88
# qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaAFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kGHucShjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEE
# BAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwIwKzApBggrBgEFBQcCARYd
# aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ29kZVNpZ25pbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LmNvbW9k
# b2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNydDAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMGA1UdEQQcMBqBGGhvY2h3YWxkQGty
# ZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsFAAOCAQEASSZkxKo3EyEk/qW0ZCs7
# CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqdwFkuQYJxzknqm2JMvwIK6BtfWc64
# WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPjen60W+L66oNEXiBuIsOcJ9e7tH6Vn
# 9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4LDHEpYpLRVQnuxoc38mmd+NfjcD2
# /o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ3trqmH6e3Cpm8Ut5UkoSONZdkYWw
# rzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnrHRReihZ0zwN+HkXO1XEnd3hm+08j
# LzCCBdgwggPAoAMCAQICEEyq+crbY2/gH/dO2FsDhp0wDQYJKoZIhvcNAQEMBQAw
# gYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
# BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
# VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEwMDEx
# OTAwMDAwMFoXDTM4MDExODIzNTk1OVowgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQI
# ExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoT
# EUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmlj
# YXRpb24gQXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# kehUktIKVrGsDSTdxc9EZ3SZKzejfSNwAHG8U9/E+ioSj0t/EFa9n3Byt2F/yUsP
# F6c947AEYe7/EZfH9IY+Cvo+XPmT5jR62RRr55yzhaCCenavcZDX7P0N+pxs+t+w
# gvQUfvm+xKYvT3+Zf7X8Z0NyvQwA1onrayzT7Y+YHBSrfuXjbvzYqOSSJNpDa2K4
# Vf3qwbxstovzDo2a5JtsaZn4eEgwRdWt4Q08RWD8MpZRJ7xnw8outmvqRsfHIKCx
# H2XeSAi6pE6p8oNGN4Tr6MyBSENnTnIqm1y9TBsoilwie7SrmNnu4FGDwwlGTm0+
# mfqVF9p8M1dBPI1R7Qu2XK8sYxrfV8g/vOldxJuvRZnio1oktLqpVj3Pb6r/SVi+
# 8Kj/9Lit6Tf7urj0Czr56ENCHonYhMsT8dm74YlguIwoVqwUHZwK53Hrzw7dPamW
# oUi9PPevtQ0iTMARgexWO/bTouJbt7IEIlKVgJNp6I5MZfGRAy1wdALqi2cVKWlS
# ArvX31BqVUa/oKMoYX9w0MOiqiwhqkfOKJwGRXa/ghgntNWutMtQ5mv0TIZxMOmm
# 3xaG4Nj/QN370EKIf6MzOi5cHkERgWPOGHFrK+ymircxXDpqR+DDeVnWIBqv8mqY
# qnK8V0rSS527EPywTEHl7R09XiidnMy/s1Hap0flhFMCAwEAAaNCMEAwHQYDVR0O
# BBYEFLuvfgI9+qbxPISOre44mOzZMjLUMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB
# Af8EBTADAQH/MA0GCSqGSIb3DQEBDAUAA4ICAQAK8dVGhLeuUbtssk1BFACTTJzL
# 5cBUz6AljgL5/bCiDfUgmDwTLaxWorDWfhGS6S66ni6acrG9GURsYTWimrQWEmla
# jOHXPqQa6C8D9K5hHRAbKqSLesX+BabhwNbI/p6ujyu6PZn42HMJWEZuppz01yfT
# ldo3g3Ic03PgokeZAzhd1Ul5ACkcx+ybIBwHJGlXeLI5/DqEoLWcfI2/LpNiJ7c5
# 2hcYrr08CWj/hJs81dYLA+NXnhT30etPyL2HI7e2SUN5hVy665ILocboaKhMFrEa
# mQroUyySu6EJGHUMZah7yyO3GsIohcMb/9ArYu+kewmRmGeMFAHNaAZqYyF1A4CI
# im6BxoXyqaQt5/SlJBBHg8rN9I15WLEGm+caKtmdAdeUfe0DSsrw2+ipAT71VpnJ
# Ho5JPbvlCbngT0mSPRaCQMzMWcbmOu0SLmk8bJWx/aode3+Gvh4OMkb7+xOPdX9M
# i0tGY/4ANEBwwcO5od2mcOIEs0G86YCR6mSceuEiA6mcbm8OZU9sh4de826g+XWl
# m0DoU7InnUq5wHchjf+H8t68jO8X37dJC9HybjALGg5Odu0R/PXpVrJ9v8dtCpOM
# pdDAth2+Ok6UotdubAvCinz6IPPE5OXNDajLkZKxfIXstRRpZg6C583OyC2mUX8h
# wTVThQZKXZ+tuxtfdDCCBeAwggPIoAMCAQICEC58h8wOk0pS/pT9HLfNNK8wDQYJ
# KoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1h
# bmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
# aW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9y
# aXR5MB4XDTEzMDUwOTAwMDAwMFoXDTI4MDUwODIzNTk1OVowfTELMAkGA1UEBhMC
# R0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9y
# ZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBS
# U0EgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAppiQY3eRNH+K0d3pZzER68we/TEds7liVz+TvFvjnx4kMhEna7xRkafPnp4l
# s1+BqBgPHR4gMA77YXuGCbPj/aJonRwsnb9y4+R1oOU1I47Jiu4aDGTH2EKhe7VS
# A0s6sI4jS0tj4CKUN3vVeZAKFBhRLOb+wRLwHD9hYQqMotz2wzCqzSgYdUjBeVoI
# zbuMVYz31HaQOjNGUHOYXPSFSmsPgN1e1r39qS/AJfX5eNeNXxDCRFU8kDwxRstw
# rgepCuOvwQFvkBoj4l8428YIXUezg0HwLgA3FLkSqnmSUs2HD3vYYimkfjC9G7WM
# crRI8uPoIfleTGJ5iwIGn3/VCwIDAQABo4IBUTCCAU0wHwYDVR0jBBgwFoAUu69+
# Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjto
# dHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9j
# cnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUF
# BzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIB
# AAI/AjnD7vjKO4neDG1NsfFOkk+vwjgsBMzFYxGrCWOvq6LXAj/MbxnDPdYaCJT/
# JdipiKcrEBrgm7EHIhpRHDrU4ekJv+YkdK8eexYxbiPvVFEtUgLidQgFTPG3UeFR
# AMaH9mzuEER2V2rx31hrIapJ1Hw3Tr3/tnVUQBg2V2cRzU8C5P7z2vx1F9vst/dl
# CSNJH0NXg+p+IHdhyE3yu2VNqPeFRQevemknZZApQIvfezpROYyoH3B5rW1CIKLP
# DGwDjEzNcweU51qOOgS6oqF8H8tjOhWn1BUbp1JHMqn0v2RH0aofU04yMHPCb7d4
# gp1c/0a7ayIdiAv4G6o0pvyM9d1/ZYyMMVcx0DbsR6HPy4uo7xwYWMUGd8pLm1Gv
# TAhKeo/io1Lijo7MJuSy2OU4wqjtxoGcNWupWGFKCpe0S0K2VZ2+medwbVn4bSoM
# fxlgXwyaiGwwrFIJkBYb/yud29AgyonqKH4yjhnfe0gzHtdl+K7J+IMUk3Z9ZNCO
# zr41ff9yMU2fnr0ebC+ojwwGUPuMJ7N2yfTm18M04oyHIYZh/r9VdOEhdwMKaGy7
# 5Mmp5s9ZJet87EUOeWZo6CLNuO+YhU2WETwJitB/vCgoE/tqylSNklzNwmWYBp7O
# SFvUtTeTRkF8B93P+kPvumdh/31J4LswfVyA4+YWOUunMYIE2TCCBNUCAQEwgZEw
# fTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
# A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNV
# BAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5nIENBAhAW1PdTHZsYJ0/yJnM0UYBc
# MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3
# DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEV
# MCMGCSqGSIb3DQEJBDEWBBS+uE/1SMWw01+tGvC5LAqPqu9kNDANBgkqhkiG9w0B
# AQEFAASCAQAvBRLDHerll+DGkmPNo8nEkLYF3Lv6P+vAu0I0mu52Xcq1XaNKs3r4
# oJje5V4qFgGhNljYhl84Wz0QPgXI9jbghb/yxxxPD8ue4PhM7Wn/t2fV5hXMh1s3
# W820G8UXVKbANHKAsld9BX5dxRlnY+sm7lepDc3Zxm+i7ljcQSHYbad4MZ1AqkiG
# NHGTYSxquuAECbEdbmVHbCk9SEOZ7niTdvv0jRfdGu5DGMq1wX46EPI7LBD13Z95
# MwLmtwVl22IV2bTSv/uWkPiieAAVy8e8/k26+Rs4M2KZnkVK7e/ULC0/Bq8DMar1
# 23FbTbIdVIM538YmU0mUZ200G1mcHP/ioYICojCCAp4GCSqGSIb3DQEJBjGCAo8w
# ggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
# c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh
# BqCB0z/YeuWCTMFrUglOAzAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDMxOTIyMjMzNlowIwYJKoZIhvcN
# AQkEMRYEFC8/wkStFJvrbd5xTlRIevJRlr3HMIGdBgsqhkiG9w0BCRACDDGBjTCB
# ijCBhzCBhAQUs2MItNTN7U/PvWa5Vfrjv7EsKeYwbDBWpFQwUjELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gRzICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkq
# hkiG9w0BAQEFAASCAQAdDoeOI+qiGwFCXehDsirhe9l3PgtI8/yK/Kmw2OB3JzOT
# IZrTrL/OQ/FSHp2pzjge0Ht31SaVsm4KJxsr5MGlLJODgb4+YNYfJ9pFcqaT5BEO
# 6Ez5o0bBysARrLC8CGUvMFArDL+p/lKvmBK2ANkL/QPPkZ5W2vpDupBW3PyD10xi
# x7r54pP5Zsa71KC3+N5CICExv4Jlwa8i4X6Y9PulNDZwXHGZuJLEx9PHHVnz/cSR
# qKBgV/l5YPWya715D2iGb3L7HDWE2HluFIC6qlA6o7Y490Mlx5N+twTlGE+q3R4h
# pR4OTEvl4TbsTzJViDJwS5b4zWCFkv2jsMrMMbs6
# SIG # End signature block
