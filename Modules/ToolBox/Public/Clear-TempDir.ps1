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

function global:Clear-TempDir {
<#
	.SYNOPSIS
		Cleanup the TEMP Directory

	.DESCRIPTION
		Cleanup the TEMP Directory

	.PARAMETER Days
		Number of days, older files will be removed!

	.PARAMETER Confirm
		A description of the Confirm parameter.

	.PARAMETER Whatif
		A description of the Whatif parameter.

	.EXAMPLE
		PS C:\scripts\PowerShell> Clear-TempDir
		Freed 439,58 MB disk space

		Will delete all Files older then 30 Days (This is the default)
		You have to confirm every item before it is deleted

	.EXAMPLE
		PS C:\scripts\PowerShell> Clear-TempDir -Days:60 -Confirm:$false
		Freed 407,17 MB disk space

		Will delete all Files older then 30 Days (This is the default)
		You do not have to confirm every item before it is deleted

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[OutputType([string])]
	param
	(
		[Parameter(Position = 0,
				   HelpMessage = 'Number of days, older files will be removed!')]
		[Alias('RemoveOlderThen')]
		[int]
		$Days = 30,
		[switch]
		$Confirm = $true,
		[Switch]
		$Whatif = $false
	)

	# Do we want to confirm?
	if ($confirm -eq $false) {
		Set-Variable -Name "_Confirm" -Value $($false -as ([bool] -as [type]))
	} elseif ($confirm -eq $true) {
		Set-Variable -Name "_Confirm" -Value $($true -as ([bool] -as [type]))
	}

	# Is there a WhatIf?
	if ($Whatif -eq $false) {
		Set-Variable -Name "_WhatIf" -Value $("#")
	} elseif ($Whatif -eq $true) {
		Set-Variable -Name "_WhatIf" -Value $("-WhatIf")
	}

	# Set the Cut Off Date
	Set-Variable -Name "cutoff" -Value $((Get-Date) - (New-TimeSpan -Days $Days))

	# Save what we have before we start the Clean up
	Set-Variable -Name "before" -Value $((Get-ChildItem $env:temp | Measure-Object Length -Sum).Sum)

	# Find all Files within the TEMP Directory and process them
	Get-ChildItem $env:temp |
	Where-Object { $_.Length -ne $null } |
	Where-Object { $_.LastWriteTime -lt $cutoff } |
	Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$_Confirm

	# How much do we have now?
	Set-Variable -Name "after" -Value $((Get-ChildItem $env:temp | Measure-Object Length -Sum).Sum)

	'Freed {0:0.00} MB disk space' -f (($before - $after)/1MB)
}