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

function global:Update-SysInfo {
<#
	.SYNOPSIS
		Update Information about the system

	.DESCRIPTION
		This function updates the informations about the systems it runs on

	.EXAMPLE
		PS C:\> Update-SysInfo

		Update Information about the system, no output!

	.NOTES

	.LINK
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net

#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Call Companion to Cleanup
		if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
			Clean-SysInfo
		}
	}

	PROCESS {
		# Fill Variables with values
		Set-Variable -Name Operating_System -Scope:Global -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
		Set-Variable -Name Processor -Scope:Global -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
		Set-Variable -Name Logical_Disk -Scope:Global -Value $(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -Property DeviceID -eq -Value $(${Operating_System}.SystemDrive) | Select-Object -Property Size, FreeSpace)
		Set-Variable -Name Get_Date -Scope:Global -Value $(Get-Date -format "G")
		Set-Variable -Name Get_OS_Name -Scope:Global -Value $(${Operating_System}.Caption)
		Set-Variable -Name Get_Kernel_Info -Scope:Global -Value $(${Operating_System}.Version)
		Set-Variable -Name Get_Uptime -Scope:Global -Value $("$((${Get_Uptime} = ${Get_Date} - $(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
		Set-Variable -Name Get_Shell_Info -Scope:Global -Value $("{0}.{1}" -f ${PSVersionTable}.PSVersion.Major, ${PSVersionTable}.PSVersion.Minor)
		Set-Variable -Name Get_CPU_Info -Scope:Global -Value $(${Processor}.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
		Set-Variable -Name Get_Process_Count -Scope:Global -Value $((Get-Process).Count)
		Set-Variable -Name Get_Current_Load -Scope:Global -Value $(${Processor}.LoadPercentage)
		Set-Variable -Name Get_Memory_Size -Scope:Global -Value $("{0}mb/{1}mb Used" -f (([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)) - ([math]::round(${Operating_System}.FreePhysicalMemory/1KB))), ([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)))
		Set-Variable -Name Get_Disk_Size -Scope:Global -Value $("{0}gb/{1}gb Used" -f (([math]::round(${Logical_Disk}.Size/1GB)) - ([math]::round(${Logical_Disk}.FreeSpace/1GB))), ([math]::round(${Logical_Disk}.Size/1GB)))

		# Do we have the NET-Experts Base Module?
		if ((Get-Command Get-NETXCoreVer -errorAction SilentlyContinue)) {
			Set-Variable -Name MyPoSHver -Scope:Global -Value $(Get-NETXCoreVer -s)
		} else {
			Set-Variable -Name MyPoSHver -Scope:Global -Value $("Unknown")
		}

		# Are we Admin?
		If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
			Set-Variable -Name AmIAdmin -Scope:Global -Value $("(User)")
		} else {
			Set-Variable -Name AmIAdmin -Scope:Global -Value $("(Admin)")
		}

	# Is this a Virtual or a Real System?
		if ((Get-Command Get-IsVirtual -errorAction SilentlyContinue)) {
			if ((Get-IsVirtual) -eq $true) {
				Set-Variable -Name IsVirtual -Scope:Global -Value $("(Virtual)")
			} else {
				Set-Variable -Name IsVirtual -Scope:Global -Value $("(Real)")
			}
		} else {
			# No idea what to do without the command-let!
			Remove-Variable IsVirtual -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}

	<#
		# This is the old way (Will be removed soon)
		if (get-adminuser -errorAction SilentlyContinue) {
			if (get-adminuser -eq $true) {
				Set-Variable -Name AmIAdmin -Scope:Global -Value $("(Admin)")
			} elseif (get-adminuser -eq $false) {
				Set-Variable -Name AmIAdmin -Scope:Global -Value $("(User)")
			} else {
				Set-Variable -Name AmIAdmin -Scope:Global -Value $("")
			}
		}
	#>

		# What CPU type do we have here?
		if ((Check-SessionArch -errorAction SilentlyContinue)) {
			Set-Variable -Name CPUtype -Scope:Global -Value $(Check-SessionArch)
		}

		# Define object
		Set-Variable -Name MyPSMode -Scope:Global -Value $($host.Runspace.ApartmentState)
	}
}

function global:Clean-SysInfo {
<#
	.SYNOPSIS
		Companion for Update-SysInfo

	.DESCRIPTION
		Cleanup for variables from the Update-SysInfo function

	.EXAMPLE
		PS C:\> Clean-SysInfo

		# Cleanup for variables from the Update-SysInfo function

	.NOTES

#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Cleanup old objects
		Remove-Variable Operating_System -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Processor -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Logical_Disk -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Date -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_OS_Name -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Kernel_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Uptime -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Shell_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_CPU_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Process_Count -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Current_Load -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Memory_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable Get_Disk_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable MyPoSHver -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable AmIAdmin -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable CPUtype -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable MyPSMode -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable IsVirtual -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
}

function global:Get-MOTD {
<#
	.SYNOPSIS
		Displays system information to a host.

	.DESCRIPTION
		The Get-MOTD cmdlet is a system information tool written in PowerShell.

	.EXAMPLE
		PS C:\> Get-MOTD

		# Display the colorful Message of the Day with a Microsoft Logo and some system infos

	.NOTES
		inspired by this: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

		The Microsoft Logo, PowerShell, Windows and some others are registered Trademarks by
		Microsoft Corporation. I do not own them, i just use them here :-)

		I moved some stuff in a separate function to make it reusable
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Update the Infos
		Update-SysInfo
	}

	PROCESS {
		# Write to the Console
		Write-Host -Object ("")
		Write-Host -Object ("")
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("    Date/Time: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Date}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("         User: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${env:UserName} ${AmIAdmin}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("         Host: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${env:ComputerName}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("           OS: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("       Kernel: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("NT ") -NoNewline -ForegroundColor Gray
		Write-Host -Object ("${Get_Kernel_Info} - ${CPUtype}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
		Write-Host -Object ("       Uptime: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Uptime}") -ForegroundColor Gray
		Write-Host -Object ("") -NoNewline
		Write-Host -Object ("                                  NETX Base: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${MyPoSHver} (${localDomain} - ${environment})") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("        Shell: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("Powershell ${Get_Shell_Info} - ${MyPSMode} Mode") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("          CPU: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_CPU_Info} ${IsVirtual}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("    Processes: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("         Load: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Gray
		Write-Host -Object ("%") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("       Memory: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
		Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
		Write-Host -Object ("         Disk: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Gray
		Write-Host -Object ("      ") -NoNewline
		Write-Host -Object ("")
		Write-Host -Object ("")
	}

	END {
		# Call Cleanup
		if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
			Clean-SysInfo
		}
	}
}

function global:Get-SysInfo {
<#
	.SYNOPSIS
		Displays Information about the system

	.DESCRIPTION
		Displays Information about the system it is started on

	.EXAMPLE
		PS C:\> Get-SysInfo

		# Display some system infos

	.NOTES
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Update the Infos
		Update-SysInfo
	}

	PROCESS {
		# Write to the Console
		Write-Host -Object ("")
		Write-Host -Object ("  Date/Time: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Date}") -ForegroundColor Gray
		Write-Host -Object ("  User:      ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${env:UserName} ${AmIAdmin}") -ForegroundColor Gray
		Write-Host -Object ("  Host:      ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${env:ComputerName}") -ForegroundColor Gray
		Write-Host -Object ("  OS:        ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Gray
		Write-Host -Object ("  Kernel:    ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("NT ") -NoNewline -ForegroundColor Gray
		Write-Host -Object ("${Get_Kernel_Info} - ${CPUtype}") -ForegroundColor Gray
		Write-Host -Object ("  Uptime:    ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Uptime}") -ForegroundColor Gray
		Write-Host -Object ("  NETX Base: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${MyPoSHver} (${localDomain} - ${environment})") -ForegroundColor Gray
		Write-Host -Object ("  Shell:     ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("Powershell ${Get_Shell_Info} - ${MyPSMode} Mode") -ForegroundColor Gray
		Write-Host -Object ("  CPU:       ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_CPU_Info} ${IsVirtual}") -ForegroundColor Gray
		Write-Host -Object ("  Processes: ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Gray
		Write-Host -Object ("  Load:      ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Gray
		Write-Host -Object ("%") -ForegroundColor Gray
		Write-Host -Object ("  Memory:    ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Gray
		Write-Host -Object ("  Disk:      ") -NoNewline -ForegroundColor DarkGray
		Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Gray
		Write-Host -Object ("")
	}

	END {
		# Call Cleanup
		if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
			Clean-SysInfo
		}
	}
}