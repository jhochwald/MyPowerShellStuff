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

function global:Get-IsVirtual {
<#
	.SYNOPSIS
		Check if this is a Virtual Machine

	.DESCRIPTION
		If this is a virtual System the Boolean is True, if not it is False

	.EXAMPLE
		PS C:\> Get-IsVirtual
		True

		If this is a virtual System the Boolean is True, if not it is False

	.EXAMPLE
		PS C:\> Get-IsVirtual
		False

		If this is not a virtual System the Boolean is False, if so it is True

	.OUTPUTS
		boolean

	.NOTES
		The Function name is changed!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param ()

	BEGIN {
		# Cleanup
		Remove-Variable SysInfo_IsVirtual -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable SysInfoVirtualType -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable WMI_BIOS -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable WMI_ComputerSystem -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		# Get some System infos via NET (WMI) call
		Set-Variable -Name "WMI_BIOS" -Scope:Script -Value $($WMI_BIOS = (Get-WmiObject -Class 'Win32_BIOS' -ErrorAction Stop | Select-Object -Property 'Version', 'SerialNumber'))
		Set-Variable -Name "WMI_ComputerSystem" -Scope:Script -Value $((Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction Stop | Select-Object -Property 'Model', 'Manufacturer'))

		# First we try to figure out if this is a Virtual Machine based on the
		# Bios Serial information that we get via WMI
		if ($WMI_BIOS.SerialNumber -like "*VMware*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VMWare")
		} elseif ($WMI_BIOS.Version -like "VIRTUAL") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Hyper-V")
		} elseif ($WMI_BIOS.Version -like "A M I") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Virtual PC")
		} elseif ($WMI_BIOS.Version -like "*Xen*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Xen")
		} elseif (($WMI_BIOS.Version -like "PRLS*") -and ($WMI_BIOS.SerialNumber -like "Parallels-*")) {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Parallels")
		}

		# Looks like this is not a Virtual Machine, but to make sure that figure it out!
		# So we try some other information that we have via WMI :-)
		if (-not ($SysInfo_IsVirtual) -eq $true) {
			if ($WMI_ComputerSystem.Manufacturer -like "*Microsoft*") {
				Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
				Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Hyper-V")
			} elseif ($WMI_ComputerSystem.Manufacturer -like "*VMWare*") {
				Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
				Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VMWare")
			} elseif ($WMI_ComputerSystem.Manufacturer -like "*Parallels*") {
				Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
				Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Parallels")
			} elseif ($wmisystem.model -match "VirtualBox") {
				Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
				Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VirtualBox")
			} elseif ($wmisystem.model -like "*Virtual*") {
				Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
				Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Unknown Virtual Machine")
			}
		}

		# OK, this does not look like a Virtual Machine to us!
		if (-not ($SysInfo_IsVirtual) -eq $true) {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($false)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Not a Virtual Machine")
		}

		# Dump the Boolean Info!
		Write-Output "$SysInfo_IsVirtual"

		# Write some Debug Infos ;-)
		Write-Debug -Message "$SysInfoVirtualType"
	}

	END {
		# Cleanup
		Remove-Variable SysInfo_IsVirtual -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable SysInfoVirtualType -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable WMI_BIOS -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable WMI_ComputerSystem -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
}
