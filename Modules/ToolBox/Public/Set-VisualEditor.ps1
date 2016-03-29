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

function global:Set-VisualEditor {
<#
	.SYNOPSIS
		Set the VisualEditor variable

	.DESCRIPTION
		Setup the VisualEditor variable. Checks if the free (GNU licensed) Notepad++ is installed,
		if so it uses this great free editor. If not the fall back is the PowerShell ISE.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support https://github.com/jhochwald/MyPowerShellStuff/issues
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Do we have the Sublime Editor installed?
		Set-Variable -Name SublimeText -Value $(Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "Sublime*") "Sublime_text*"))

		# Check if the GNU licensed Note++ is installed
		Set-Variable -Name NotepadPlusPlus -Value $(Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "notepad*") "notepad*"))

		# Do we have it?
		(resolve-path "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)

		# What Editor to use?
		if ($SublimeText -ne $null -and (test-path $SublimeText)) {
			# We have Sublime Editor installed, so we use it
			Set-Variable -Name VisualEditor -Scope:Global -Value $($SublimeText.Path)
		} elseif ($NotepadPlusPlus -ne $null -and (test-path $NotepadPlusPlus)) {
			# We have Notepad++ installed, Sublime Editor is not here... use Notepad++
			Set-Variable -Name VisualEditor -Scope:Global -Value $($NotepadPlusPlus.Path)
		} else {
			# No fancy editor, so we use ISE instead
			Set-Variable -Name VisualEditor -Scope:Global -Value $("PowerShell_ISE.exe")
		}
	}
}

# Execute the function above
Set-VisualEditor
