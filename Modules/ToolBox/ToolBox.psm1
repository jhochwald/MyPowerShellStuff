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

	#################################################
	# modified by     : Joerg Hochwald
	# last modified   : 2016-03-30
	#################################################
#>

#endregion License

#region ModuleDefaults

# Temp Change to the Module Directory
Push-Location $PSScriptRoot

# Start the Module Loading Mode
$LoadingModule = $true

#endregion ModuleDefaults

#region Externals

#endregion Externals

#region Functions

#endregion Functions

#region ExportModuleStuff

# Get public and private function definition files.
$Public = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'Public') -Exclude "*.tests.*" -Recurse -ErrorAction SilentlyContinue -WarningAction:SilentlyContinue )
$Private = @( Get-ChildItem -Path (Join-Path $PSScriptRoot 'Private') -Exclude "*.tests.*" -Recurse -ErrorAction SilentlyContinue -WarningAction:SilentlyContinue )

# Dot source the files
foreach ($import in @($Public)) {
	Try {
		. $import.fullname
	} Catch {
		Write-Error -Message "Failed to import Public function $($import.fullname): $_"
	}
}

if ($loadingModule) {
	Export-ModuleMember -Function "*" -Alias "*" -Cmdlet "*" -Variable "*"
}

foreach ($import in @($Private)) {
	Try {
		. $import.fullname
	} Catch {
		Write-Error -Message "Failed to import Private function $($import.fullname): $_"
	}
}

# End the Module Loading Mode
$LoadingModule = $false

# Return to where we are before we start loading the Module
Pop-Location

#endregion ExportModuleStuff

<#
	Execute some stuff here
#>
