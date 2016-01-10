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

function Global:Clear-OldFiles {
<#
	.SYNOPSIS
		Removes old Logfiles

	.DESCRIPTION
		Convenience function to cleanup old Files (House Keeping)

	.PARAMETER days
		Files older then this will be deleted, the Default is 7 (For 7 Days)

	.PARAMETER Path
		The Path where the Logs are located, default is C:\scripts\PowerShell\log

	.PARAMETER Extension
		The File Extension that you would like to remove, the drfault is ALL (*)

	.EXAMPLE
		PS C:\> Clear-OldFiles

		Will remove all files older then 7 days from C:\scripts\PowerShell\log
		You need to confirm every action!

	.EXAMPLE
		PS C:\> Clear-OldFiles -Confirm:$false

		Will remove all files older then 7 days from C:\scripts\PowerShell\log
		You do not need to confirm any action!

	.EXAMPLE
		PS C:\> Clear-OldFiles -days:"30" -Confirm:$false

		Will remove all files older then 30 days from C:\scripts\PowerShell\log
		You do not need to confirm any action!

	.EXAMPLE
		PS C:\> Clear-OldFiles -Extension:".csv" -days:"365" -Path:"C:\scripts\PowerShell\export" -Confirm:$false

		Will remove all csv files older then 365 days from C:\scripts\PowerShell\export
		You do not need to confirm any action!

	.NOTES
		Want to clean out old logfiles?
#>

	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $false)]
	param
	(
		[Parameter(HelpMessage = 'Files older then this will be deleted, the Default is 7 (For 7 Days)')]
		[ValidateNotNullOrEmpty()]
		[int]$Days = 7,
		[Parameter(HelpMessage = 'The Path where the Logs are located, default is C:\scripts\PowerShell\log')]
		[ValidateNotNullOrEmpty()]
		[System.String]$Path = "C:\scripts\PowerShell\log",
		[Parameter(HelpMessage = 'The File Extension that you would like to remove, the drfault is ALL (*)')]
		[ValidateNotNullOrEmpty()]
		[Alias('ext')]
		[System.String]$Extension = "*"
	)

	PROCESS {
		Get-ChildItem $Path -Recurse -Include $Extension | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(0 - $days) } | ForEach-Object {
			# Generate the TimeStamp
			$TimeStamp = New-TimeSpan $_.CreationTime $(get-date)

			try {
				Remove-Item $_.FullName -Force -ErrorAction:Stop
				Write-Output "Deleted $_.FullName"
			} catch {
				Write-Warning -Message 'Can not Delete $_.FullName'
			}
		}
	}
}
