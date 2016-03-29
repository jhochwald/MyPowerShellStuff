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
	# last modified   : 2016-03-29
	#################################################
#>

#endregion License

function global:Open-InternetExplorer {
<#
	.SYNOPSIS
		Workaround for buggy internetexplorer.application

	.DESCRIPTION
		This Workaround is neat, because the native implementation is unable to bring the new Internet Explorer Window to the front (give em focus).
		It needs his companion: Add-NativeHelperType

	.PARAMETER Url
		The URL you would like to open in Internet Explorer

	.PARAMETER Foreground
		Should the new Internet Explorer start in the foreground? The default is YES.

	.PARAMETER FullScreen
		Should the new Internet Explorer Session start in Full Screen, the Default is NO

	.EXAMPLE
		PS C:\> Open-InternetExplorer -Url http://hochwald.net -FullScreen -InForeground

		Start Internet Explorer in Foreground and fullscreen, it also opens http://hochwald.net

	.EXAMPLE
		PS C:\> Open-InternetExplorer -Url https://portal.office.com

		Start Internet Explorer in Foreground with the URL https://portal.office.com

	.LINK
		Source: http://superuser.com/questions/848201/focus-ie-window-in-powershell

	.LINK
		Info: https://msdn.microsoft.com/en-us/library/windows/desktop/ms633539(v=vs.85).aspx

	.NOTES
		It needs his companion: Add-NativeHelperType
		Based on a snippet from Crippledsmurf
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'The URL you would like to open in Internet Explorer')]
		[System.String]$Url = "http://support.net-experts.net",
		[Parameter(HelpMessage = 'Should the new Internet Explorer start in the foreground? The default is YES.')]
		[Alias('fg')]
		[switch]$Foreground = $true,
		[Parameter(HelpMessage = 'Should the new Internet Explorer Session start in Full Screen, the Default is NO')]
		[Alias('fs')]
		[switch]$FullScreen = $False
	)
	BEGIN {
		# If we want to start in Foreground, we use our helper
		if ($Foreground) {
			Add-NativeHelperType
		}
	}

	PROCESS {
		# Initiate a new IE
		$internetExplorer = new-object -com "InternetExplorer.Application"

		# The URL to open
		$internetExplorer.navigate($Url)

		# Should is be Visible?
		$internetExplorer.Visible = $true

		# STart un fullscreen?
		$internetExplorer.FullScreen = $FullScreen

		# Here is the Magic!
		if ($Foreground) {
			[NativeHelper]::SetForeground($internetExplorer.HWND) > $null 2>&1 3>&1
		}
	}

	END {
		# Be verbose
		Write-Verbose -Message "$internetExplorer"
	}
}
