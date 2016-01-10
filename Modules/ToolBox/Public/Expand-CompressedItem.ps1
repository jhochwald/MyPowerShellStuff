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

function global:Expand-CompressedItem {
<#
	.SYNOPSIS
		Expands a compressed archive or container.

	.DESCRIPTION
		Expands a compressed archive or container.

		Currently only ZIP files are supported. Per default the contents of the ZIP
		is expanded in the current directory. If an item already exists, you will
		be visually prompted to overwrite it, skip it, or to have a second copy of
		the item expanded. This is due to the mechanism how this is implemented (via
		Shell.Application).

	.PARAMETER InputObject
		Specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object. You can also pass an array of archives to the parameter. In addition you can pipe a single archive or an array of archives to this parameter as well.

	.PARAMETER Path
		Specifies the destination path where to expand the archive. By default this is the current directory.

	.PARAMETER Format
		A description of the Format parameter.

	.EXAMPLE
		PS C:\> Expands an archive 'mydata.zip' to the current directory.

		Expand-CompressedItem mydata.zip

	.EXAMPLE
		PS C:\> Expand-CompressedItem mydata.zip -Confirm

		Expands an archive 'mydata.zip' to the current directory and
		prompts for every item to be extracted.

	.EXAMPLE
		PS C:\> Get-ChildItem Y:\Source\*.zip | Expand-CompressedItem -Path Z:\Destination -Format ZIP -Confirm

		You can also pipe archives to the Cmdlet.
		Enumerate all ZIP files in 'Y:\Source' and pass them to the Cmdlet.
		Each item to be extracted must be confirmed.

	.EXAMPLE
		PS C:\> Expand-CompressedItem "Y:\Source\data1.zip","Y:\Source\data2.zip"

		Expands archives 'data1.zip' and 'data2.zip' to the current directory.

	.EXAMPLE
		PS C:\> @("Y:\Source\data1.zip","Y:\Source\data2.zip") | Expand-CompressedItem

		Expands archives 'data1.zip' and 'data2.zip' to the current directory.

	.OUTPUTS
		This Cmdlet has no return value.

	.NOTES
		See module manifest for required software versions and dependencies at:
		http://dfch.biz/biz/dfch/PS/System/Utilities/biz.dfch.PS.System.Utilities.psd1/

		.HELPURI

	.INPUTS
		InputObject can either be a full path to an archive or a FileInfo object. In
		addition it can also be an array of these objects.

		Path expects a directory or a DirectoryInfo object.

	.LINK
		Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/Expand-CompressedItem/
#>

	[CmdletBinding(ConfirmImpact = 'Low',
				   HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/Expand-CompressedItem/',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object. You can also pass an array of archives to the parameter. In addition you can pipe a single archive or an array of archives to this parameter as well.')]
		[ValidateScript({ Test-Path($_); })]
		[string]
		$InputObject,
		[Parameter(Mandatory = $false,
				   Position = 1)]
		[ValidateScript({ Test-Path($_); })]
		[System.IO.DirectoryInfo]
		$Path = $PWD.Path,
		[Parameter(Mandatory = $false)]
		[ValidateSet('default', 'ZIP')]
		[string]
		$Format = 'default'
	)

	BEGIN {
		# Define the Date
		$datBegin = [datetime]::Now;

		# Build a string
		[string]$fn = $MyInvocation.MyCommand.Name;

		# Log to debug (if we have to)
		Log-Debug -fn $fn -msg ("CALL. InputObject: '{0}'. Path '{1}'" -f $InputObject.FullName, $Path.FullName) -fac 1;

		# Currently only ZIP is supported
		switch ($Format) {
			"ZIP"
			{
				# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
				Set-Variable -Name ShellApplication -Value $(new-object -com Shell.Application;)
			}
			default {
				# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
				Set-Variable -Name ShellApplication -Value $(new-object -com Shell.Application;)
			}
		}

		# Set the Variable
		Set-Variable -Name CopyHereOptions -Value $(4 + 1024 + 16;)
	}

	PROCESS {
		# Define a variable
		Set-Variable -Name fReturn -Value $($false;)

		# Remove a variable that we do not need anymore
		Remove-Variable OutputParameter -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue

		# Loop over what we have
		foreach ($Object in $InputObject) {
			# Define a new variable
			Set-Variable -Name $Object -Value $(Get-Item $Object;)

			# Check what we have here
			if ($PSCmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $Object.Name, $Path.FullName))) {
				# Log to debug (if we have to)
				Log-Debug $fn ("Extracting '{0}' to '{1}' ..." -f $Object.Name, $Path.FullName)

				# Set a new variable
				Set-Variable -Name CompressedObject -Value $($ShellApplication.NameSpace($Object.FullName);)

				# Loop over what we have
				foreach ($Item in $CompressedObject.Items()) {
					if ($PSCmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $Item.Name, $Path.FullName))) {
						$ShellApplication.Namespace($Path.FullName).CopyHere($Item, $CopyHereOptions);
					}
				}
			}
		}

		# Show what we have
		return $OutputParameter;
	}

	END {
		# Cleanup
		if ($ShellApplication) {
			# Remove a no longer needed variable
			Remove-Variable ShellApplication -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
		# Set another variable
		Set-Variable -Name datEnd -Value $([datetime]::Now;)

		# Log to debug (if we have to)
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}

# You might want to add an Alias "unzip" as well
# Set-Alias -Name 'Unzip' -Value 'Expand-CompressedItem';
# if($MyInvocation.ScriptName) { Export-ModuleMember -Function Expand-CompressedItem -Alias Unzip; }
if ($MyInvocation.ScriptName) { Export-ModuleMember -Function Expand-CompressedItem; }
