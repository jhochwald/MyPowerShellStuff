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

function global:Set-FileTime {
<#
	.SYNOPSIS
		Change file Creation + Modification + Last Access times

	.DESCRIPTION
		The touch utility sets the Creation + Modification + Last Access times of files.

		If any file does not exist, it is created with default permissions by default.
		To prevent this, please use the -NoCreate parameter!

	.PARAMETER Path
		Path to the File that we would like to change

	.PARAMETER AccessTime
		Change the Access Time Only

	.PARAMETER WriteTime
		Change the Write Time Only

	.PARAMETER CreationTime
		Change the Creation Time Only

	.PARAMETER NoCreate
		Do not create a new file, if the given one does not exist.

	.PARAMETER Date
		Date to set

	.EXAMPLE
		touch foo.txt

		Change the Creation + Modification + Last Access Date/time and if the file
		does not already exist, create it with the default permissions.

		We use the alias touch instead of Set-FileTime to make it more *NIX like!

	.EXAMPLE
		Set-FileTime foo.txt -NoCreate

		Change the Creation + Modification + Last Access Date/time if this file exists.
		the -NoCreate makes sure, that the file will not be created!

	.EXAMPLE
		Set-FileTime foo.txt -only_modification

		Change only the modification time

	.EXAMPLE
		Set-FileTime foo.txt -only_access

		Change only the last access time

	.EXAMPLE
		dir . -recurse -filter "*.xls" | Set-FileTime

		Change multiple files

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net

	.LINK
		Based on this: http://ss64.com/ps/syntax-touch.html
#>

	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   HelpMessage = 'Path to the File')]
		[string]
		$Path,
		[Parameter(HelpMessage = 'Change the Access Time Only')]
		[switch]
		$AccessTime,
		[Parameter(HelpMessage = 'Change the Write Time Only')]
		[switch]
		$WriteTime,
		[Parameter(HelpMessage = 'Change the Creation Time Only')]
		[switch]
		$CreationTime,
		[switch]
		$NoCreate,
		[Parameter(HelpMessage = 'Date to set')]
		[datetime]
		$Date
	)

	BEGIN {
		#
	}

	PROCESS {
		# Let us test if the given file exists
		if (Test-Path $Path) {
			if ($Path -is [System.IO.FileSystemInfo]) {
				Set-Variable -Name "FileSystemInfoObjects" -Scope:Global -Value $($Path)
			} else {
				Set-Variable -Name "FileSystemInfoObjects" -Scope:Global -Value $($Path | Resolve-Path -erroraction SilentlyContinue | Get-Item)
			}

			# Now we loop over all objects
			foreach ($fsInfo in $FileSystemInfoObjects) {

				if (($Date -eq $null) -or ($Date -eq "")) {
					$Date = Get-Date
				}

				# Set the Access time
				if ($AccessTime) {
					$fsInfo.LastAccessTime = $Date
				}

				# Set the Last Write time
				if ($WriteTime) {
					$fsInfo.LastWriteTime = $Date
				}

				# Set the Creation time
				if ($CreationTime) {
					$fsInfo.CreationTime = $Date
				}

				# On, no parameter given?
				# We set all time stamps!
				if (($AccessTime -and $ModificationTime -and $CreationTime) -eq $false) {
					$fsInfo.CreationTime = $Date
					$fsInfo.LastWriteTime = $Date
					$fsInfo.LastAccessTime = $Date
				}
			}
		} elseif (-not $NoCreate) {
			# Let us create the file for ya!
			Set-Content -Path $Path -Value $null
			Set-Variable -Name "fsInfo" -Scope:Global -Value $($Path | Resolve-Path -erroraction SilentlyContinue | Get-Item)

			# OK, now we set the date to the given one
			# We ignore all given parameters here an set all time stamps!
			# If you want to change it, re-run the command!
			if (($Date -ne $null) -and ($Date -ne "")) {
				$fsInfo.CreationTime = $Date
				$fsInfo.LastWriteTime = $Date
				$fsInfo.LastAccessTime = $Date
			}
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
# Every *NIX user known touch and we miss that on PowerShell ;-)
(set-alias touch Set-FileTime -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
