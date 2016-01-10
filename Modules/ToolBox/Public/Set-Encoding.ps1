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

function global:Set-Encoding {
<#
	.SYNOPSIS
		Converts Encoding of text files

	.DESCRIPTION
		Allows you to change the encoding of files and folders.
		It supports file extension agnostic
		Please note: Overwrites original file if destination equals the path

	.PARAMETER path
		Folder or file to convert

	.PARAMETER dest
		If you want so save the newly encoded file/files to a new location

	.PARAMETER encoding
		Encoding method to use for the Patch or File

	.EXAMPLE
		PS C:\scripts\PowerShell> Set-Encoding -path "c:\windows\temps\folder1" -encoding "UTF8"

		# Converts all Files in the Folder c:\windows\temps\folder1 in the UTF8 format

	.EXAMPLE
		PS C:\scripts\PowerShell> Set-Encoding -path "c:\windows\temps\folder1" -dest "c:\windows\temps\folder2" -encoding "UTF8"

		# Converts all Files in the Folder c:\windows\temps\folder1 in the UTF8 format and save them to c:\windows\temps\folder2

	.EXAMPLE
		PS C:\scripts\PowerShell> (Get-Content -path "c:\temp\test.txt") | Set-Content -Encoding UTF8 -Path "c:\temp\test.txt"

		This converts a single File via hardcore PowerShell without a Script.
		Might be useful if you want to convert this script after a transfer!

	.NOTES
		BETA!!!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Alias('PathName')]
		[string]
		$path,
		[Parameter(Mandatory = $false)]
		[Alias('Destination')]
		[string]
		$dest = $path,
		[Parameter(Mandatory = $true)]
		[Alias('enc')]
		[string]
		$encoding
	)

	BEGIN {
		# ensure it is a valid path
		if (-not (Test-Path -Path $path)) {
			# Aw, Snap!
			throw "File or directory not found at {0}" -f $path
		}
	}

	PROCESS {
		# if the path is a file, else a directory
		if (Test-Path $path -PathType Leaf) {
			# if the provided path equals the destination
			if ($path -eq $dest) {
				# get file extension
				Set-Variable -Name ext -Value $([System.IO.Path]::GetExtension($path))

				#create destination
				Set-Variable -Name dest -Value $($path.Replace([System.IO.Path]::GetFileName($path), ("temp_encoded{0}" -f $ext)))

				# output to file with encoding
				Get-Content $path | Out-File -FilePath $dest -Encoding $encoding -Force

				# copy item to original path to overwrite (note move-item loses encoding)
				Copy-Item -Path $dest -Destination $path -Force -PassThru | ForEach-Object { Write-Output -inputobject ("{0} encoded {1}" -f $encoding, $_) }

				# remove the extra file
				Remove-Item $dest -Force -Confirm:$false
			} else {
				# output to file with encoding
				Get-Content $path | Out-File -FilePath $dest -Encoding $encoding -Force
			}

		} else {
			# get all the files recursively
			foreach ($i in Get-ChildItem -Path $path -Recurse) {
				if ($i.PSIsContainer) {
					continue
				}

				# get file extension
				Set-Variable -Name ext -Value $([System.IO.Path]::GetExtension($i))

				# create destination
				Set-Variable -Name dest -Value $("$path\temp_encoded{0}" -f $ext)

				# output to file with encoding
				Get-Content $i.FullName | Out-File -FilePath $dest -Encoding $encoding -Force

				# copy item to original path to overwrite (note move-item loses encoding)
				Copy-Item -Path $dest -Destination $i.FullName -Force -PassThru | ForEach-Object { Write-Output -inputobject ("{0} encoded {1}" -f $encoding, $_) }

				# remove the extra file
				Remove-Item $dest -Force -Confirm:$false
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
# Set a compatibility Alias
(set-alias Set-TextEncoding Set-Encoding -option:AllScope -scope:Global -force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) > $null 2>&1 3>&1
