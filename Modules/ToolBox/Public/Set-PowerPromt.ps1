function Global:Set-PowerPrompt {
<#
	.SYNOPSIS
		Multicolored prompt with marker for windows started as Admin and marker for providers outside filesystem

	.DESCRIPTION
		Multicolored prompt with marker for windows started as Admin and marker for providers outside filesystem

	.EXAMPLE
		[Admin] C:\Windows\System32>

	.EXAMPLE
		[Registry] HKLM:\SOFTWARE\Microsoft\Windows>

	.EXAMPLE
		[Admin] [Registry] HKLM:\SOFTWARE\Microsoft\Windows>

	.NOTES
		Just an internal function to make my life easier!

	.LINK
		Source: http://www.snowland.se/2010/02/23/nice-powershell-prompt/
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()

	function Global:prompt {
		[CmdletBinding(ConfirmImpact = 'None')]
		param ()

		# New nice WindowTitle
		$Host.UI.RawUI.WindowTitle = "PowerShell v" + (get-host).Version.Major + "." + (get-host).Version.Minor + " (" + $pwd.Provider.Name + ") " + $pwd.Path

		# Am I Admin?
		if ((New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
			# Admin-mark in WindowTitle
			$Host.UI.RawUI.WindowTitle = "[Admin] " + $Host.UI.RawUI.WindowTitle

			# Admin-mark on prompt
			Write-Host "[" -nonewline -foregroundcolor DarkGray
			Write-Host "Admin" -nonewline -foregroundcolor Red
			Write-Host "] " -nonewline -foregroundcolor DarkGray
		}

		# Show providername if you are outside FileSystem
		if ($pwd.Provider.Name -ne "FileSystem") {
			Write-Host "[" -nonewline -foregroundcolor DarkGray
			Write-Host $pwd.Provider.Name -nonewline -foregroundcolor Gray
			Write-Host "] " -nonewline -foregroundcolor DarkGray
		}

		# Split path and write \ in a gray
		$pwd.Path.Split("\") | foreach {
			Write-Host $_ -nonewline -foregroundcolor Yellow
			Write-Host "\" -nonewline -foregroundcolor Gray
		}

		# Backspace last \ and write >
		Write-Host "`b>" -nonewline -foregroundcolor Gray

		return " "
	}
}