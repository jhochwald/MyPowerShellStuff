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

function Global:Get-PendingReboot {
<#
	.SYNOPSIS
		Gets the pending reboot status on a local or remote computer.

	.DESCRIPTION
		This function will query the registry on a local or remote computer and determine if the
		system is pending a reboot, from either Microsoft Patching or a Software Installation.
		For Windows 2008+ the function will query the CBS registry key as another factor in determining
		pending reboot state.  "PendingFileRenameOperations" and "Auto Update\RebootRequired" are observed
		as being consistant across Windows Server 2003 & 2008.

		CBServicing = Component Based Servicing (Windows 2008)
		WindowsUpdate = Windows Update / Auto Update (Windows 2003 / 2008)
		CCMClientSDK = SCCM 2012 Clients only (DetermineIfRebootPending method) otherwise $null value
		PendFileRename = PendingFileRenameOperations (Windows 2003 / 2008)

	.PARAMETER ComputerName
		A single Computer or an array of computer names. The default is localhost ($env:COMPUTERNAME).

	.EXAMPLE
		PS C:\> Get-PendingReboot -ComputerName (Get-Content C:\ServerList.txt) | Format-Table -AutoSize

		Computer CBServicing WindowsUpdate CCMClientSDK PendFileRename PendFileRenVal RebootPending
		-------- ----------- ------------- ------------ -------------- -------------- -------------
		DC01     False   False           False      False
		DC02     False   False           False      False
		FS01     False   False           False      False

		This example will capture the contents of C:\ServerList.txt and query the pending reboot
		information from the systems contained in the file and display the output in a table. The
		null values are by design, since these systems do not have the SCCM 2012 client installed,
		nor was the PendingFileRenameOperations value populated.

	.EXAMPLE
		PS C:\> Get-PendingReboot

		Computer     : WKS01
		CBServicing  : False
		WindowsUpdate      : True
		CCMClient    : False
		PendComputerRename : False
		PendFileRename     : False
		PendFileRenVal     :
		RebootPending      : True

		This example will query the local machine for pending reboot information.

	.EXAMPLE
		PS C:\> $Servers = Get-Content C:\Servers.txt
		PS C:\> Get-PendingReboot -Computer $Servers | Export-Csv C:\PendingRebootReport.csv -NoTypeInformation

		This example will create a report that contains pending reboot information.

	.NOTES
		Based on an idea of Brian Wilhite

	.LINK
		Component-Based Servicing: http://technet.microsoft.com/en-us/library/cc756291(v=WS.10).aspx

	.LINK
		PendingFileRename/Auto Update: http://support.microsoft.com/kb/2723674

	.LINK
		http://technet.microsoft.com/en-us/library/cc960241.aspx

	.LINK
		http://blogs.msdn.com/b/hansr/archive/2006/02/17/patchreboot.aspx

	.LINK
		SCCM 2012/CCM_ClientSDK: http://msdn.microsoft.com/en-us/library/jj902723.aspx
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0,
				   HelpMessage = 'A single Computer or an array of computer names.')]
		[Alias('CN', 'Computer')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME"
	)

	BEGIN {
		#
	}

	PROCESS {
		Foreach ($Computer in $ComputerName) {
			Try {
				# Setting pending values to false to cut down on the number of else statements
				$CompPendRen, $PendFileRename, $Pending, $SCCM = $false, $false, $false, $false

				# Setting CBSRebootPend to null since not all versions of Windows has this value
				Remove-Variable -Name "CBSRebootPend" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

				# Querying WMI for build version
				$WMI_OS = Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber, CSName -ComputerName $Computer -ErrorAction Stop

				# Making registry connection to the local/remote computer
				Set-Variable -Name "HKLM" -Value $([UInt32] "0x80000002")
				Set-Variable -Name "WMI_Reg" -Value $([WMIClass] "\\$Computer\root\default:StdRegProv")

				# If Vista/2008 & Above query the CBS Reg Key
				If ([Int32]$WMI_OS.BuildNumber -ge 6001) {
					Set-Variable -Name "RegSubKeysCBS" -Value $($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\"))
					Set-Variable -Name "$CBSRebootPend" -Value $($RegSubKeysCBS.sNames -contains "RebootPending")
				}

				# Query WUAU from the registry
				Set-Variable -Name "RegWUAURebootReq" -Value $($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\"))
				Set-Variable -Name "WUAURebootReq" -Value $($RegWUAURebootReq.sNames -contains "RebootRequired")

				# Query PendingFileRenameOperations from the registry
				Set-Variable -Name "RegSubKeySM" -Value $($WMI_Reg.GetMultiStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\Session Manager\", "PendingFileRenameOperations"))
				Set-Variable -Name "RegValuePFRO" -Value $($RegSubKeySM.sValue)

				# Query ComputerName and ActiveComputerName from the registry
				Set-Variable -Name "ActCompNm" -Value $($WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\", "ComputerName"))
				Set-Variable -Name "CompNm" -Value $($WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\", "ComputerName"))


				If ($ActCompNm -ne $CompNm) {
					Set-Variable -Name "CompPendRen" -Value $($true)
				}

				# If PendingFileRenameOperations has a value set $RegValuePFRO variable to $true
				If ($RegValuePFRO) {
					Set-Variable -Name "PendFileRename" -Value $($true)
				}

				# Determine SCCM 2012 Client Reboot Pending Status
				# To avoid nested 'if' statements and unneeded WMI calls to determine if the CCM_ClientUtilities class exist, setting EA = 0
				Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

				$CCMSplat = @{
					NameSpace = 'ROOT\ccm\ClientSDK'
					Class = 'CCM_ClientUtilities'
					Name = 'DetermineIfRebootPending'
					ComputerName = $Computer
					ErrorAction = 'Stop'
				}


				Try {
					Set-Variable -Name "CCMClientSDK" -Value $(Invoke-WmiMethod @CCMSplat)
				} Catch [System.UnauthorizedAccessException] {
					Set-Variable -Name "CcmStatus" -Value $(Get-Service -Name CcmExec -ComputerName $Computer -ErrorAction SilentlyContinue)

					If ($CcmStatus.Status -ne 'Running') {
						Write-Warning "$Computer`: Error - CcmExec service is not running."
						Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
					}
				} Catch {
					Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				}

				If ($CCMClientSDK) {
					If ($CCMClientSDK.ReturnValue -ne 0) {
						Write-Warning "Error: DetermineIfRebootPending returned error code $($CCMClientSDK.ReturnValue)"
					}

					If ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending) {
						Set-Variable -Name "SCCM" -Value $($true)
					}
				} Else {
					Remove-Variable -Name "SCCM" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				}

				## Creating Custom PSObject and Select-Object Splat
				$SelectSplat = @{
					Property = (
					'Computer',
					'CBServicing',
					'WindowsUpdate',
					'CCMClientSDK',
					'PendComputerRename',
					'PendFileRename',
					'PendFileRenVal',
					'RebootPending'
					)
				}

				New-Object -TypeName PSObject -Property @{
					Computer = $WMI_OS.CSName
					CBServicing = $CBSRebootPend
					WindowsUpdate = $WUAURebootReq
					CCMClientSDK = $SCCM
					PendComputerRename = $CompPendRen
					PendFileRename = $PendFileRename
					PendFileRenVal = $RegValuePFRO
					RebootPending = ($CompPendRen -or $CBSRebootPend -or $WUAURebootReq -or $SCCM -or $PendFileRename)
				} | Select-Object @SelectSplat

			} Catch {
				Write-Warning "$Computer`: $_"
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