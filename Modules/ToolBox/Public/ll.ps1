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

# Make Powershell more Uni* like
function global:ll {
<#
	.SYNOPSIS
		Quick helper to make my PowerShell a bit more like *nix

	.DESCRIPTION
		Everyone ever used a modern Unix and/or Linux system knows and love the colored output of LL
		This function is hack to emulate that on PowerShell.

	.PARAMETER dir
		Show the content of this Directory

	.PARAMETER all
		Show all files, included the hidden ones!

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Alias('Directory')]
		$dir = ".",
		[Alias('ShowAll')]
		$all = $false
	)

	BEGIN {
		# Define object
		Set-Variable -Name origFg -Value $($Host.UI.RawUI.ForegroundColor)
	}

	PROCESS {
		# What to do?
		if ($all) {
			Set-Variable -Name toList -Value $(Get-ChildItem -force $dir)
		} else {
			Set-Variable -Name toList -Value $(Get-ChildItem $dir)
		}

		# Define the display colors for given extensions
		foreach ($Item in $toList) {
			Switch ($Item.Extension) {
				".exe" { $Host.UI.RawUI.ForegroundColor = "DarkYellow" }
				".hta" { $Host.UI.RawUI.ForegroundColor = "DarkYellow" }
				".cmd" { $Host.UI.RawUI.ForegroundColor = "DarkRed" }
				".ps1" { $Host.UI.RawUI.ForegroundColor = "DarkGreen" }
				".html" { $Host.UI.RawUI.ForegroundColor = "Cyan" }
				".htm" { $Host.UI.RawUI.ForegroundColor = "Cyan" }
				".7z" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
				".zip" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
				".gz" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
				".rar" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
				Default { $Host.UI.RawUI.ForegroundColor = $origFg }
			}

			# All directories a Dark Grey
			if ($item.Mode.StartsWith("d")) {
				$Host.UI.RawUI.ForegroundColor = "DarkGray"
			}

			# Dump it
			$item
		}
	}

	END {
		$Host.UI.RawUI.ForegroundColor = $origFg
	}
}