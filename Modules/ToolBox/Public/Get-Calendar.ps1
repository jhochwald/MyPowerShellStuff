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

function Global:Get-Calendar {
<#
	.SYNOPSIS
		Dumps a Calendar to the Colsole

	.DESCRIPTION
		Dumps a Calendar to the Colsole
		You might find it handy to have that on a core Server or in a remote PowerShell Session

	.PARAMETER StartDate
		The Date the Calendar should start

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(HelpMessage = 'The Date the Calendar should start')]
		[ValidateNotNullOrEmpty()]
		[datetime]$StartDate = (Get-Date)
	)

	BEGIN {
		$startDay = Get-Date (Get-Date $StartDate -Format "yyyy-MM-01")
	}

	PROCESS {
		Write-Host (Get-Date $startDate -Format "MMMM yyyy")
		Write-Host "Mo Tu We Th Fr Sa Su"
		For ($i = 1; $i -lt (get-date $startDay).dayOfWeek.value__; $i++) {
			Write-Host "   " -noNewLine
		}

		$processDate = $startDay
		while ($processDate -lt $startDay.AddMonths(1)) {
			Write-Host (Get-Date $processDate -Format "dd ") -NoNewLine

			if ((get-date $processDate).dayOfWeek.value__ -eq 0) { Write-Host "" }
			$processDate = $processDate.AddDays(1)
		}
		Write-Host ""
	}
}