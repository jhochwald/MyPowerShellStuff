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

<#
	Simple Functions to save and restore PowerShell session information
#>
function global:get-sessionfile {
<#
	.SYNOPSIS
		Restore PowerShell Session information

	.DESCRIPTION
		This command shows many PowerShell Session informations.

	.PARAMETER sessionName
		Name of the Session you would like to dump

	.EXAMPLE
		PS C:\scripts\PowerShell> get-sessionfile $O365Session
		C:\Users\adm.jhochwald\AppData\Local\Temp\[PSSession]Session2

		# Returns the Session File for a given Session

	.EXAMPLE
		PS C:\scripts\PowerShell> get-sessionfile
		C:\Users\adm.jhochwald\AppData\Local\Temp\

		# Returns the Session File of the running session, cloud be none!

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('Session')]
		[string]
		$sessionName
	)

	PROCESS {
		# DUMP
		return "$([io.path]::GetTempPath())$sessionName";
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

function global:export-session {
<#
	.SYNOPSIS
		Export PowerShell session info to a file

	.DESCRIPTION
		This is a (very) poor man approach to save some session infos

		Our concept of session is simple and only considers:
		- history
		- The current directory

		But still can be very handy and useful. If you type in some sneaky commands,
		or some very complex things and you did not copied these to another file or script
		it can save you a lot of time if you need to do it again (And this is often the case)

		Even if you just want to dump it quick to copy it some when later to a documentation or
		script this might be useful.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ([string]
		$sessionName = "session-$(get-date -f yyyyMMddhh)")

	# Define object
	Set-Variable -Name file -Value $(get-sessionfile $sessionName)

	#
	(pwd).Path > "$file-pwd.ps1session"

	#
	get-history | export-csv "$file-hist.ps1session"

	# Dump what we have
	Write-Output "Session $sessionName saved"

	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:import-session {
<#
	.SYNOPSIS
		Import a PowerShell session info from file

	.DESCRIPTION
		This is a (very) poor man approach to restore some session infos

	Our concept of session is simple and only considers:
		- history
		- The current directory

		But still can be very handy and useful. If you type in some sneaky commands,
		or some very complex things and you did not copied these to another file or script
		it can save you a lot of time if you need to do it again (And this is often the case)

		Even if you just want to dump it quick to copy it some when later to a documentation or
		script this might be useful.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('Session')]
		[string]
		$sessionName
	)

	# Define object
	Set-Variable -Name file -Value $(get-sessionfile $sessionName)

	# What do we have?
	if (-not [io.file]::Exists("$file-pwd.ps1session")) {
		write-error -Message:"Session file doesn't exist" -ErrorAction:Stop
	} else {
		cd (gc "$file-pwd.ps1session")
		import-csv "$file-hist.ps1session" | add-history
	}

	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}
