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

function global:Get-TempFile {
<#
	.SYNOPSIS
		Creates a string with a temp file

	.DESCRIPTION
		Creates a string with a temp file

	.PARAMETER Extension
		File Extension as a string.
		The default is "tmp"

	.EXAMPLE
		PS C:\> New-TempFile
		C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.tmp

		Returns a String of the Temp File with the extension TMP.

	.EXAMPLE
		PS C:\> New-TempFile -Extension txt
		C:\Users\josh\AppData\Local\Temp\332ddb9a-5e52-4687-aa01-1d67ab6ae2b1.txt

		Returns a String of the Temp File with the extension TXT

	.EXAMPLE
		PS C:\> $foo = (New-TempFile)
		PS C:\> New-Item -Path $foo -Force -Confirm:$false
		PS C:\> Add-Content -Path:$LogPath -Value:"Test" -Encoding UTF8 -Force
		C:\Users\josh\AppData\Local\Temp\d08cec6f-8697-44db-9fba-2c369963a017.tmp

		Creates a temp File: C:\Users\josh\AppData\Local\Temp\d08cec6f-8697-44db-9fba-2c369963a017.tmp
		And fill the newly created file with the String "Test"

	.OUTPUTS
		String

	.NOTES
		Helper to avoid "System.IO.Path]::GetTempFileName()" usage.

	.LINK
		Idea: http://powershell.com/cs/blogs/tips/archive/2015/10/15/creating-temporary-filenames.aspx

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
		[Parameter(HelpMessage = 'File Extension as a string. like tmp')]
		[string]
		$Extension = 'tmp'
	)

	PROCESS {
		# Define objects
		$elements = @()
		$elements += [System.IO.Path]::GetTempPath()
		$elements += [System.Guid]::NewGuid()
		$elements += $Extension.TrimStart('.')

		# Here we go: This is a Teampfile
		'{0}{1}.{2}' -f $elements
	}
}
