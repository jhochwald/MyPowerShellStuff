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

function global:Get-TinyURL {
<#
	.SYNOPSIS
		Get a Short URL

	.DESCRIPTION
		Get a Short URL using the TINYURL.COM Service

	.PARAMETER URL
		Long URL

	.EXAMPLE
		PS C:\> Get-TinyURL -URL 'http://hochwald.net'
		http://tinyurl.com/yc63nbh

		Request the TINYURL for http://hochwald.net.
		In this example the return is http://tinyurl.com/yc63nbh

	.NOTES
		Still a beta Version!

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
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Tiny')]
		[string]
		$URL
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "tinyURL" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name "tinyURL" -Value $(Invoke-WebRequest -Uri "http://tinyurl.com/api-create.php?url=$URL" | Select-Object -ExpandProperty Content)

			# Do we have the TinyURL?
			if (($tinyURL)) {
				# Dump to the Console
				write-output "$tinyURL"
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Output "Whoopsie... Houston, we have a problem!"
		} finally {
			# Cleanup
			Remove-Variable tinyURL -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

function global:Get-IsGdURL {
<#
	.SYNOPSIS
		Get a Short URL

	.DESCRIPTION
		Get a Short URL using the IS.GD Service

	.PARAMETER URL
		Long URL

	.EXAMPLE
		PS C:\> Get-IsGdURL -URL 'http://hochwald.net'
		http://is.gd/FkMP5v

		Request the IS.GD for http://hochwald.net.
		In this example the return is http://is.gd/FkMP5v

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2GD')]
		[string]
		$URL
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "isgdURL" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name "isgdURL" -Value $(Invoke-WebRequest -Uri "http://is.gd/api.php?longurl=$URL" | Select-Object -ExpandProperty Content)

			# Do we have the short URL?
			if (($isgdURL)) {
				# Dump to the Console
				write-output "$isgdURL"
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Output "Whoopsie... Houston, we have a problem!"
		} finally {
			# Cleanup
			Remove-Variable isgdURL -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

function global:Get-TrImURL {
<#
	.SYNOPSIS
		Get a Short URL

	.DESCRIPTION
		Get a Short URL using the TR.IM Service

	.PARAMETER URL
		Long URL

	.EXAMPLE
		PS C:\> Get-TrImURL -URL 'http://hochwald.net'

	.NOTES
		The service is offline at the moment!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = 'Long URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Trim')]
		[string]
		$URL
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "trimURL" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name "trimURL" -Value $(Invoke-WebRequest -Uri "http://api.tr.im/api/trim_simple?url=$URL" | Select-Object -ExpandProperty Content)

			# Do we have a trim URL?
			if (($trimURL)) {
				# Dump to the Console
				write-output "$trimURL"
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Output "Whoopsie... Houston, we have a problem!"
		} finally {
			# Cleanup
			Remove-Variable trimURL -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

function global:Get-LongURL {
<#
	.SYNOPSIS
		Expand a Short URL

	.DESCRIPTION
		Expand a Short URL via the untiny.me
		This service supports all well known (and a lot other) short UR L services!

	.PARAMETER URL
		Short URL

	.EXAMPLE
		PS C:\> Get-LongURL -URL 'http://cutt.us/KX5CD'
		http://hochwald.net

		Get the Long URL (http://hochwald.net) for a given Short URL

	.NOTES
		This service supports all well known (and a lot other) short UR L services!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = 'Short URL')]
		[ValidateNotNullOrEmpty()]
		[Alias('URL2Exapnd')]
		[string]
		$URL
	)

	BEGIN {
		# Cleanup
		Remove-Variable -Name "longURL" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}

	PROCESS {
		try {
			# Request
			Set-Variable -Name "longURL" -Value $(Invoke-WebRequest -Uri "http://untiny.me/api/1.0/extract?url=$URL&format=text" | Select-Object -ExpandProperty Content)

			# Do we have the long URL?
			if (($longURL)) {
				# Dump to the Console
				write-output "$longURL"
			} else {
				# Aw Snap!
				throw
			}
		} catch {
			# Something bad happed
			Write-Output "Whoopsie... Houston, we have a problem!"
		} finally {
			# Cleanup
			Remove-Variable longURL -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}