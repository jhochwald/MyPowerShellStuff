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

function Global:Save-CommandHistory {
<#
	.SYNOPSIS
		Dump the Command History to an XML File

	.DESCRIPTION
		Dump the Command History to an XML File.
		This file is located in the User Profile.
		You can then restore it via Load-CommandHistory

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Where to store the XML History Dump
		Set-Variable -Name "CommandHistoryDump" -Value $((Join-Path (Split-Path $profile.CurrentUserAllHosts) "commandHistory.xml") -as ([string] -as [type]))

		# Be verbose
		Write-Debug -Message "Save History to $($CommandHistoryDump)"

		# Dump the History
		Get-History | Export-Clixml -Path $CommandHistoryDump -Force -Confirm:$false -Encoding utf8
	}
}

function Global:Load-CommandHistory {
<#
	.SYNOPSIS
		Load the old History dumped via Save-CommandHistory

	.DESCRIPTION
		This is the companion Command for Save-CommandHistory
		It loads the old History from a XML File in the users Profile.

	.NOTES
		Additional information about the function.
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	PROCESS {
		# Where to Find the XML History Dump
		Set-Variable -Name "CommandHistoryDump" -Value $((Join-Path (Split-Path $profile.CurrentUserAllHosts) "commandHistory.xml") -as ([string] -as [type]))

		# Be verbose
		Write-Debug -Message "Clear History to keep things clean"

		# Clear History to keep things clean
		# UP (Cursor) will sill show the existing command history
		Clear-History -Confirm:$false

		# Be verbose
		Write-Debug -Message "Load History from $($CommandHistoryDump)"

		# Import the History
		Add-History -InputObject (Import-Clixml -Path $CommandHistoryDump)
	}
}