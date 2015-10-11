<#
	if ($Statement) { Write-Output "Code is poetry" }

	Copyright (c) 2012 - 2015 by Joerg Hochwald <joerg.hochwald@outlook.de>

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

	Except as contained in this notice, the name of the Software, NET-experts
	or Joerg Hochwald shall not be used in advertising or otherwise to promote
	the sale, use or other dealings in this Software without prior written
	authorization from Joerg Hochwald
#>

function global:Check-SessionArch {
<#
	.SYNOPSIS
		Show the CPU architectire

	.DESCRIPTION
		You want to know if this is a 64BIT or still a 32BIT system?
		Might be useful, maybee not!

	.EXAMPLE
		PS C:\scripts\PowerShell> Check-SessionArch
		x64

		# Shows that the architecture is 64BIT and that the session also supports X64

	.OUTPUTS
		String

	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	if ([System.IntPtr]::Size -eq 8) {
		return "x64"
	} elseif ([System.IntPtr]::Size -eq 4) {
		return "x86"
	} else {
		Return "Unknown Type"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Global:CheckTcpPort {
<#
	.SYNOPSIS
		Check a TCP Port

	.DESCRIPTION
		Opens a connection to a given (or default) TCP Port to a given (or default) server.
		This is not a simple port ping, it creates a real connection to see if the port is alive!

	.PARAMETER Port
		 Default is 587
		 e.g. "25"
		 Port to use

	.PARAMETER Server
		 e.g. "outlook.office365.com" or "192.168.16.10"
		 SMTP Server to use

	.EXAMPLE
		PS C:\> CheckTcpPort

		# Check port 587/TCP on the default Server

	.EXAMPLE
		PS C:\> CheckTcpPort -Port:25 -Server:mx.net-experts.net

		# Check port 25/TCP on Server mx.net-experts.net

	.OUTPUTS
		boolean
		Value is True or False

	.NOTES
		Internal Helper function to check if we can reach a server via a TCP connection on a given port
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[Int32]
		$Port,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[string]
		$Server
	)
	
	# Cleanup
	Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Set the defaults for some stuff
	if (!($Port)) {
		# This is the default TCP Port to Check
		$Port = "587"
	}
	
	if (!($Server)) {
		# Do we know any defaults?
		if (!($PSEmailServer)) {
			# We have a default SMTP Server, use it!
			$Server = ($PSEmailServer)
		} else {
			# Aw Snap! No Server given on the commandline, no Server configured as default... BAD!
			Write-PoshError -Message "No SMTP Server given, no default configured" -Stop
		}
	}
	
	# Create a function to open a TCP connection
	$ThePortStatus = New-Object Net.Sockets.TcpClient -ErrorAction SilentlyContinue
	
	# Look if the Server is online and the port is open
	try {
		# Try to connect to one of the on Premise Exchange front end servers
		$ThePortStatus.Connect($Server, $Port)
	} catch [System.Exception]
	{
		# BAD, but do nothing yet! This is something the the caller must handle
	}
	
	# Share the info with the caller
	$ThePortStatus.Client.Connected
	
	# Cleanup
	Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# CLOSE THE TCP Connection
	if ($ThePortStatus.Connected) {
		# Mail works, close the connection
		$ThePortStatus.Close()
	}
	
	# Cleanup
	Remove-Variable ThePortStatus -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:convert-frombinhex([string]$binhex) {
<#
	.SYNOPSIS
		Convert a HEX Value to a String

	.DESCRIPTION
		Converts a given HEX value back to human readable strings

	.PARAMETER HEX
		HEX String that you like to convert

	.EXAMPLE
		PS C:\> convert-frombinhex 0c

		# Return the regular Value (12) of the given HEX 0c

	.NOTES
		This is just a little helper function to make the shell more flexible
#>
	$arr = new-object byte[] ($binhex.Length/2)
	for ($i = 0; $i -lt $arr.Length; $i++) {
		$arr[$i] = [Convert]::ToByte($binhex.substring($i * 2, 2), 16)
	}
	return $arr
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:convert-tobinhex($array) {
<#
	.SYNOPSIS
		Convert a String to HEX

	.DESCRIPTION
		Converts a given String or Array to HEX and dumps it

	.PARAMETER array
		Array that should be converted to HEX

	.EXAMPLE
		PS C:\> convert-tobinhex 1234

		# Return the HEX Value (4d2) of the String 1234

	.INPUTS
		String
		Array

	.OUTPUTS
		String

	.NOTES
		This is just a little helper function to make the shell more flexible
#>
	$str = new-object system.text.stringbuilder
	$array | %{
		[void]$str.Append($_.ToString('x2'));
	}
	return $str.ToString()
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:ConvertTo-PlainText {
<#
	.SYNOPSIS
		Convert a secure string back to plain text

	.DESCRIPTION
		Convert a secure string back to plain text

	.PARAMETER secure
		Secure String to convert

	.NOTES
		Helpper function

	.LINK
		hochwald.net http://hochwald.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Secure String to convert')]
		[ValidateNotNullOrEmpty()]
		[security.securestring]
		$secure
	)
	
	$marshal = [Runtime.InteropServices.Marshal];
	return $marshal::PtrToStringAuto($marshal::SecureStringToBSTR($secure));
	
	###
	# Do a garbage collection
	###
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Global:Create-ZIP {
<#
	.SYNOPSIS
		Create a ZIP archive of a given file

	.DESCRIPTION
		Create a ZIP archive of a given file.
		By default within the same directory and the same name as the input file.
		This can be changed via command line parameters

	.PARAMETER InputFile
		Mandatory

		The parameter InputFile is the file that should be compressed.
		You can use it like this: "ClutterReport-20150617171648.csv",
		or with a full path like this: "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv"

	.PARAMETER OutputFile
		Optional

		You can use it like this: "ClutterReport-20150617171648",
		or with a full path like this: "C:\scripts\PowerShell\export\ClutterReport-20150617171648"
		Do not append the extension!

	.PARAMETER OutputPath
		Optional

		By default the new archive will be created in the same directory as the inpufile,
		if you would like to have it in another directory specify it here like this: "C:\temp\"
		The directory must exist!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv"

		# This will create the archive "ClutterReport-20150617171648.zip" from the given inputfile
		# "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		# The new archive will be located in "C:\scripts\PowerShell\export\"!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport"

		# This will create the archive "NewClutterReport.zip" from the given inputfile
		# "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		# The new archive will be located in "C:\scripts\PowerShell\export\"!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputPath "C:\temp\"

		# This will create the archive "ClutterReport-20150617171648.zip" from the given inputfile
		# "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		# The new archive will be located in "C:\temp\"! The directory must exist!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport" -OutputPath "C:\temp\"

		# This will create the archive "NewClutterReport.zip" from the given inputfile
		# "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		# The new archive will be located in "C:\temp\"! The directory must exist!

	.OUTPUTS
		Compress File

	.NOTES
		Notes

	.INPUTS
		Parameters above
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   HelpMessage = 'The parameter InputFile is the file that should be compressed (Mandatory)')]
		[ValidateNotNullOrEmpty()]
		[Alias('Input')]
		[string]
		$InputFile,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[Alias('Output')]
		[string]
		$OutputFile,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[string]
		$OutputPath
	)
	
	# Cleanup the variables
	Remove-Variable MyFileName -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable MyFilePath -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable OutArchiv -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable zip -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Extract the Filename, without PATH and EXTENSION
	$MyFileName = ((Get-Item $InputFile).Name)
	
	# Check if the parameter "OutputFile" is given
	if (-not ($OutputFile)) {
		# Extract the Filename, without PATH
		$OutputFile = ((Get-Item $InputFile).BaseName)
	}
	
	# Append the ZIP extension
	$OutputFile = ($OutputFile + ".zip")
	
	# Is the OutputPath Parameter given?
	if (-not ($OutputPath)) {
		# Build the new Path Variable
		$MyFilePath = ((Split-Path -Path $InputFile -Parent) + "\")
	} else {
		# Strip the trailing backslash if it exists
		$OutputPath = ($OutputPath.TrimEnd("\"))
		
		# Build the new Path Variable based on the given OutputPath Parameter
		$MyFilePath = (($OutputPath) + "\")
	}
	
	# Build a new Filename with Path
	$OutArchiv = (($MyFilePath) + ($OutputFile))
	
	# Check if the Archive exists and delete it if so
	If (Test-Path $OutArchiv) {
		# If the File is locked, Unblock it!
		Unblock-File -Path:$OutArchiv -Confirm:$false -ErrorAction:Ignore -WarningAction:Ignore
		
		# Remove the Archive
		Remove-Item -Path:$OutArchiv -Force -Confirm:$false -ErrorAction:Ignore -WarningAction:Ignore
	}
	
	# The ZipFile class is not available by default in Windows PowerShell because the
	# System.IO.Compression.FileSystem assembly is not loaded by default.
	Add-Type -AssemblyName "System.IO.Compression.FileSystem"
	
	# Create a new Archive
	$zip = [System.IO.Compression.ZipFile]::Open($OutArchiv, "Create")
	
	# Add input to the Archive
	$null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $InputFile, $MyFileName, "optimal")
	
	# Close the archive file
	$zip.Dispose()
	
	# Waiting for compression to complete...
	do {
		# Wait 1 second and try again if working entries are not null
		Start-sleep -Seconds:"1"
	} while (($zip.Entries.count) -ne 0)
	
	# Extended Support for unattended mode
	if (($RunUnattended) -eq $true) {
		# Inform the Robot (Just pass the Archive Filename)
		Write-Output "$OutArchiv"
	} else {
		# Inform the operator
		Write-Output "Compressed: $InputFile"
		Write-Output "Archive: $OutArchiv"
	}
	
	# If the File is locked, Unblock it!
	Unblock-File -Path:$OutArchiv -Confirm:$false -ErrorAction:Ignore -WarningAction:Ignore
	
	# Cleanup the variables
	Remove-Variable MyFileName -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable MyFilePath -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable OutArchiv -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable zip -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:Edit-HostsFile {
<#
	.SYNOPSIS
		Edit the Windows Hostfile

	.DESCRIPTION
		Shortcut to quickly edit the Windows host File. Might be usefull for testing things without changing the regular DNS.
		Handle with care!

	.EXAMPLE
		PS C:\> Edit-HostsFile

		# Opens the Editor configured within the VisualEditor variable to edit the Windows Host file

	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	if (!($VisualEditor)) {
		# Aw SNAP! The VisualEditor is not configured...
		Write-PoshError -Message "System is not configured! The Visual Editor is not given..." -Stop
		
		# If you want to skip my VisualEditor function, add the following here instead of the Write-Error:
		# Start-Process -FilePath notepad -ArgumentList "$env:windir\system32\drivers\etc\hosts"
	} else {
		# Here we go: Edit the Host file...
		Start-Process -FilePath $VisualEditor -ArgumentList "$env:windir\system32\drivers\etc\hosts"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:Expand-CompressedItem {
<#
	.SYNOPSIS
		Expands a compressed archive or container.

	.DESCRIPTION
		Expands a compressed archive or container.

		Currently only ZIP files are supported. Per default the contents of the ZIP
		is expanded in the current directory. If an item already exists, you will
		be visually prompted to overwrite it, skip it, or to have a second copy of
		the item exanded. This is due to the mechanism how this is implemented (via
		Shell.Application).

	.PARAMETER InputObject
		Specifies the archive to expand. You can either pass this parameter as a path and name to the archive or as a FileInfo object. You can also pass an array of archives to the parameter. In addition you can pipe a single archive or an array of archives to this parameter as well.

	.PARAMETER Path
		Specifies the destination path where to expand the archive. By default this is the current directory.

	.PARAMETER Format
		A description of the Format parameter.

	.EXAMPLE
		PS C:\> Expands an archive 'mydata.zip' to the current directory.

		# Expand-CompressedItem mydata.zip

	.EXAMPLE
		# Expands an archive 'mydata.zip' to the current directory and prompts for
		# every item to be extracted.

		PS C:\> Expand-CompressedItem mydata.zip -Confirm

	.EXAMPLE
		PS C:\> Get-ChildItem Y:\Source\*.zip | Expand-CompressedItem -Path Z:\Destination -Format ZIP -Confirm

		# You can also pipe archives to the Cmdlet.
		# Enumerate all ZIP files in 'Y:\Source' and pass them to the Cmdlet. Each item
		# to be extracted must be confirmed.

	.EXAMPLE
		# Expands archives 'data1.zip' and 'data2.zip' to the current directory.

		PS C:\> Expand-CompressedItem "Y:\Source\data1.zip","Y:\Source\data2.zip"

	.EXAMPLE
		# Expands archives 'data1.zip' and 'data2.zip' to the current directory.

		PS C:\> @("Y:\Source\data1.zip","Y:\Source\data2.zip") | Expand-CompressedItem

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
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		Log-Debug -fn $fn -msg ("CALL. InputObject: '{0}'. Path '{1}'" -f $InputObject.FullName, $Path.FullName) -fac 1;
		
		# Currently only ZIP is supported
		switch ($Format) {
			"ZIP"
			{
				# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
				$ShellApplication = new-object -com Shell.Application;
			}
			default {
				# We use the Shell to extract the ZIP file. If using .NET v4.5 we could have used .NET classes directly more easily.
				$ShellApplication = new-object -com Shell.Application;
			}
		}
		$CopyHereOptions = 4 + 1024 + 16;
	}
	
	PROCESS {
		$fReturn = $false;
		$OutputParameter = $null;
		
		foreach ($Object in $InputObject) {
			$Object = Get-Item $Object;
			if ($PSCmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $Object.Name, $Path.FullName))) {
				Log-Debug $fn ("Extracting '{0}' to '{1}' ..." -f $Object.Name, $Path.FullName)
				$CompressedObject = $ShellApplication.NameSpace($Object.FullName);
				foreach ($Item in $CompressedObject.Items()) {
					if ($PSCmdlet.ShouldProcess(("Extract '{0}' to '{1}'" -f $Item.Name, $Path.FullName))) {
						$ShellApplication.Namespace($Path.FullName).CopyHere($Item, $CopyHereOptions);
					}
				}
			}
		}
		return $OutputParameter;
	}
	
	END {
		# Cleanup
		if ($ShellApplication) {
			$ShellApplication = $null;
		}
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}

function global:explore {
<#
	.SYNOPSIS
		Open explorer in this directory

	.DESCRIPTION
		Open the Windows Explorer in this directory

	.PARAMETER loc
		A description of the loc parameter.

	.EXAMPLE
		PS C:\> explore

		# Open the Windows Explorer in this directory

	.NOTES
		Just a little helper function
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param
	(
		[string]
		$loc = '.'
	)
	
	explorer "/e,"$loc""
}

function global:get-hash($value, $hashalgo = 'MD5') {
<#
	.SYNOPSIS
		Show the HASH Value of a given File

	.DESCRIPTION
		Shows the MD5 Hash value of a given File

	.PARAMETER File
		Filename that hash should be shown of

	.EXAMPLE
		PS C:\scripts\PowerShell> get-hash .\profile.ps1

		81d84c612566cb633aff63e3f4f27a28

		#Return the MD5 Hash of .\profile.ps1

	.OUTPUTS
		String

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	$tohash = $value
	
	if ($value -is [string]) {
		$tohash = [text.encoding]::UTF8.GetBytes($value)
	}
	
	$hash = [security.cryptography.hashalgorithm]::Create($hashalgo)
	
	return convert-tobinhex($hash.ComputeHash($tohash));
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

<#
	if ($Statement) { Write-Output "Code is poetry" }

	Copyright (c) 2012 - 2015 by Joerg Hochwald <joerg.hochwald@outlook.de>

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

	Except as contained in this notice, the name of the Software, NET-experts
	or Joerg Hochwald shall not be used in advertising or otherwise to promote
	the sale, use or other dealings in this Software without prior written
	authorization from Joerg Hochwald
#>
function global:get-myprocess {
<#
	.SYNOPSIS
		Get our own process information

	.DESCRIPTION
		Get our own process information about the PowerShell Session

	.EXAMPLE
		PS C:\scripts\PowerShell> get-myprocess

		Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id ProcessName
		-------  ------    -----      ----- -----   ------     -- -----------
		    511      44    79252      93428   664   11,653   3932 powershell

	.OUTPUTS
		process information

	.NOTES
		Just a little helper function that might be usefull if you have a long running shell session
#>
	# Do a garbage collection
	run-gc
	
	# Get the info
	[diagnostics.process]::GetCurrentProcess()
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:get-syntax([string]$cmdlet) {
<#
	.SYNOPSIS
		Get the syntax of a cmdlet, even if we have no help for it

	.DESCRIPTION
		Helper function to get the syntax of a alias or cmdlet, even if we have no help for it

	.PARAMETER cmdlet
		commandlet that you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> get-syntax get-syntax

		# Get the syntax and parameters for the cmdlet "get-syntax".
		# Makes no sense at all, but this is just an example!

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	get-command $cmdlet -syntax
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

<#
	if ($Statement) { Write-Output "Code is poetry" }

	Copyright (c) 2012 - 2015 by Joerg Hochwald <joerg.hochwald@outlook.de>

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the "Software"),
	to deal in the Software without restriction, including without limitation
	the rights to use, copy, modify, merge, publish, distribute, sublicense,
	and/or sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
	DEALINGS IN THE SOFTWARE.

	Except as contained in this notice, the name of the Software, NET-experts
	or Joerg Hochwald shall not be used in advertising or otherwise to promote
	the sale, use or other dealings in this Software without prior written
	authorization from Joerg Hochwald
#>
# Uni* like Uptime
function global:Get-Uptime {
<#
	.SYNOPSIS
		Show how long system has been running

	.DESCRIPTION
		Uni* like Uptime - The uptime utility displays the current time, the length of time the system has been up

	.EXAMPLE
		PS C:\> Get-Uptime
		Uptime: 0 days, 2 hours, 11 minutes

		# Returns the uptime of the system, the time since last reboot/startup

	.NOTES
		Make PowerShell even more Uni* like

	.LINK
		http://hochwald.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param ()
	$os = Get-WmiObject win32_operatingsystem
	$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
	$Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
	Write-Output $Display
}

# Old implementation of the above GREP tool
# More complex but even more UNI* like
function global:GnuGrep {
<#
	.SYNOPSIS
		File pattern searcher

	.DESCRIPTION
		This command emulates the wel known (and loved?) GNU file pattern searcher

	.PARAMETER pattern
		 Pattern (STRING) - Mandatory

	.PARAMETER filefilter
		 File (STRING) - Mandatory

	.PARAMETER r
		 Recurse

	.PARAMETER i
		 Ignore case

	.PARAMETER l
		 List filenames

	.NOTES
		More complex but even more UNI* like

	.LINK
		hochwald.net http://hochwald.net
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = ' Pattern (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[string]
		$pattern,
		[Parameter(Mandatory = $true,
				   Position = 1,
				   HelpMessage = ' File (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[string]
		$filefilter,
		[switch]
		$r,
		[switch]
		$i,
		[switch]
		$l
	)
	
	$path = $pwd
	
	# need to add filter for files only, no directories
	$files = Get-ChildItem $path -include "$filefilter" -recurse:$r
	if ($l) {
		$files | foreach
		{
			if ($(Get-Content $_ | select-string -pattern $pattern -caseSensitive:$i).Count > 0) {
				$_ | Select-Object path
			}
		}
		select-string $pattern $files -caseSensitive:$i
	} else {
		$files | foreach
		{
			$_ | select-string -pattern $pattern -caseSensitive:$i
		}
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:head {
<#
	.SYNOPSIS
		display first lines of a file

	.DESCRIPTION
		This filter displays the first count lines or bytes of each of the specified files,
		or of the standard input if no files are specified.
		If count is omitted it defaults to 10.

	.PARAMETER file
		Filename

	.PARAMETER count
		A description of the count parameter.

	.NOTES
		Make PowerShell more like Uni*

	.LINK
		hochwald.net http://hochwald.net
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Filename')]
		[ValidateNotNullOrEmpty()]
		[string]
		$file,
		[int]
		$count = 10
	)
	
	if ((Test-Path $file) -eq $False) {
		Write-Error -Message:"Unable to locate file $file" -ErrorAction:Stop
		return;
	}
	
	return Get-Content $file | Select-Object -First $count
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:help {
<#
	.SYNOPSIS
		Wrapper that use the cmdlet Get-Help -full

	.DESCRIPTION
		Wrapper that use the regular cmdlet Get-Help -full to show all technical informations about the given command

	.EXAMPLE
		PS C:\scripts\PowerShell> help get-item

		# Show the full technical informations of the get-item cmdlet

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER cmdlet
		commandlet

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	clear-host
	Get-Help $args[0] -full
}

function global:Initialize-Modules {
<#
	.SYNOPSIS
		Initialize PowerShell Modules

	.DESCRIPTION
		Initialize PowerShell Modules

	.NOTES
		Needs to be documented

	.LINK
		hochwald.net http://hochwald.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	Get-Module | Where-Object { Test-Method $_.Name $_.Name } | foreach
	{
		$functionName = $_.Name
		Write-Verbose "Initializing Module $functionName"
		Invoke-Expression $functionName | Out-Null
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:Invoke-VisualEditor {
<#
	.SYNOPSIS
		Wrapper to edit files

	.DESCRIPTION
		This is a quick wrapper that edits files with editor ftom the VisualEditor variable

	.PARAMETER Filename
		File that you would like to edit

	.EXAMPLE
		PS C:\scripts\PowerShell> Invoke-VisualEditor example.txt

		# Invokes Note++ or ISE and edits "example.txt".
		# This is possible, even if the File does not exists... The editor should ask you if it should create it for you

	.EXAMPLE
		PS C:\scripts\PowerShell> Invoke-VisualEditor
		# Invokes Note++ or ISE without opening a file

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	# Call the newly set Editor
	if (!($VisualEditor)) {
		# Aw SNAP! The VisualEditor is not configured...
		Write-PoshError -Message:"System is not configured well! The Visual Editor is not given..." -Stop
	} else {
		# Yeah! Do it...
		Start-Process -FilePath $VisualEditor -ArgumentList "$args"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:append-classpath {
<#
	.SYNOPSIS
		Append a given path to the Classpath

	.DESCRIPTION
		Appends a given path to the Java Classpath. Useful if you still need that old java crap!

	.EXAMPLE
		PS C:\scripts\PowerShell> append-classpath "."
		Include the directory where you are to the Java Classpath

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER path
		Path to include in the Java Classpath

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'Medium')]
	param ()
	if ([String]::IsNullOrEmpty($env:CLASSPATH)) {
		$env:CLASSPATH = $args
	} else {
		$env:CLASSPATH += ';' + $args
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:JavaLove {
<#
	.SYNOPSIS
		Set the JAVAHOME Variable to use JDK and/or JRE instances withing the Session

	.DESCRIPTION
		You are still using Java Stuff?
		OK... Your choice, so we do you the faivor and create/fill the variable JAVAHOME based on the JDK/JRE that we found.
		It also append the Info to the PATH variable to make things easier for you.
		But think about dropping the buggy Java crap as soon as you can. Java is not only buggy, there are also many Security issues with it!

	.EXAMPLE
		PS C:\scripts\PowerShell> JavaLove

		# Find the installed JDK and/or JRE version and crate the JDK_HOME and JAVA_HOME variables for you.
		# It also appends the Path to the PATH  and CLASSPATH variable to make it easier for you.
		#
		# But do you still need java?

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'Medium')]
	param ()
	# Where do we want to search for the Java crap?
	$baseloc = "$env:ProgramFiles\Java\"
	
	# Show Java a little love...
	# And I have no idea why I must do that!
	if ((test-path $baseloc)) {
		# Include JDK if found
		$sdkdir = (resolve-path "$baseloc\jdk*")
		
		if ($sdkdir -ne $null -and (test-path $sdkdir)) {
			# Set the enviroment
			$env:JDK_HOME = $sdkdir
			
			# Tweak the PATH
			append-path "$sdkdir\bin"
		}
		
		# Include JRE if found
		$jredir = (resolve-path "$baseloc\jre*")
		
		if ($jredir -ne $null -and (test-path $jredir)) {
			# Set the enviroment
			$env:JAVA_HOME = $jredir
			
			# Tweak the PATH
			append-path "$jredir\bin"
		}
		
		# Update the Classpath
		append-classpath "."
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Make Powershell more Uni* like
function global:ll {
<#
	.SYNOPSIS
		Quick helper to mak my PowerShell a bit more like *nix

	.DESCRIPTION
		Everyone ever used a modern Unix and/or Linux system knows and love the colored output of LL
		This function is hack to emmulate that on PowerShell.

	.PARAMETER dir
		Directory

	.PARAMETER all
		A description of the all parameter.

	.NOTES
		Additional information about the function.
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		$dir = ".",
		$all = $false
	)
	
	$origFg = $Host.UI.RawUI.ForegroundColor
	if ($all) {
		$toList = Get-ChildItem -force $dir
	} else {
		$toList = Get-ChildItem $dir
	}
	
	foreach ($Item in $toList) {
		Switch ($Item.Extension) {
			".exe" { $Host.UI.RawUI.ForegroundColor = "DarkYellow" }
			".hta" { $Host.UI.RawUI.ForegroundColor = "DarkYellow" }
			".cmd" { $Host.UI.RawUI.ForegroundColor = "DarkRed" }
			".ps1" { $Host.UI.RawUI.ForegroundColor = "DarkGreen" }
			".html" { $Host.UI.RawUI.ForegroundColor = "Cyan" }
			".htm" { $Host.UI.RawUI.ForegroundColor = "Cyan" }
			".7z" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
			".zip" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
			".gz" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
			".rar" { $Host.UI.RawUI.ForegroundColor = "Magenta" }
			Default { $Host.UI.RawUI.ForegroundColor = $origFg }
		}
		
		if ($item.Mode.StartsWith("d")) {
			$Host.UI.RawUI.ForegroundColor = "DarkGray"
		}
		
		$item
	}
	$Host.UI.RawUI.ForegroundColor = $origFg
}

# Make Powershell more Uni* like
function global:man {
<#
	.SYNOPSIS
		Wrapper of Get-Help

	.DESCRIPTION
		This wrapper uses Get-Help -full for a given cmdlet and shows eversthing paged. This is very much like the typical *nix like man

	.EXAMPLE
		PS C:\scripts\PowerShell> man get-item

		# Shows the complete help text of the cmdlet "get-item", page by page

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER cmdlet
		commandlet

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	clear-host
	Get-Help $args[0] -full | Out-Host -paging
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Make Powershell more Uni* like
function global:mkdir {
<#
	.SYNOPSIS
		Wrapper of New-Item

	.DESCRIPTION
		Wrapper of New-Item to create a directory

	.PARAMETER Directory
		Directory name to create

	.PARAMETER path
		Name of the directory that you would like to create

	.EXAMPLE
		PS C:\scripts\PowerShell> mkdir test

		# Creates a directory with the name "test"

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Directory name to create')]
		[ValidateNotNullOrEmpty()]
		[Alias('dir')]
		$Directory
	)
	
	New-Item -type directory -path $args -ErrorAction:stop
}

# Make Powershell more Uni* like
function global:myls {
<#
	.SYNOPSIS
		Wrapper for Get-ChildItem

	.DESCRIPTION
		This wrapper for Get-ChildItem shows all directories and files (even hidden ones)

	.PARAMETER loc
		A description of the loc parameter.

	.PARAMETER location
		This optional parameters is usefull if you would like to see the content of another directory

	.EXAMPLE
		PS C:\scripts\PowerShell> myls

		# Show the content of the directory where you are

	.EXAMPLE
		PS C:\scripts\PowerShell> myls c:\

		# Show the content of "c:\"

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[string]
		$loc = '.'
	)
	
	Get-ChildItem -force -att !a "$loc"
	Get-ChildItem -force -att !d "$loc"
}

function global:New-Guid {
<#
	.SYNOPSIS
		Creates a new Guid object and displays it to the screen

	.DESCRIPTION
		Uses static System.Guid.NewGuid() method to create a new Guid object

	.EXAMPLE
		PS C:\scripts\PowerShell> New-Guid
		fd6bd476-db80-44e7-ab34-47437adeb8e3

		# Creates a new Guid object and displays its GUI to the screen

	.NOTES
		This is just a quick & dirty helper function to generate GUID's
		this is neat if you need a new GUID for an PowerShell Module.
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param ()
	[System.Guid]$guidObject = [System.Guid]::NewGuid()
	Write-Host $guidObject.Guid
}

function global:PoSHModuleLoader {
	<#
	.SYNOPSIS
		Loads all Script modules

	.DESCRIPTION
		Loads all Script modules

	.NOTES
		Needs to be documented

	.LINK
		hochwald.net http://hochwald.net
#>
	
	# Load some PoSH modules
	Get-Module -ListAvailable | Where-Object { $_.ModuleType -eq "Script" } | Import-Module -DisableNameChecking -force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
}

<#
	Simple Functions to save and restore PowerShell session information
#>
function global:get-sessionfile([string]$sessionName) {
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
		kreativsign.net http://kreativsign.net
#>
	return "$([io.path]::GetTempPath())$sessionName";
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
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

		But still can be very handy and usefull. If you type in some sneaky commands,
		or some very complex things and you did not copied these to another file or script
		it can save you a lot of time if you need to do it again (And this is often the case)

		Even if you just want to dump it quick to copy it somewhen later to a documentation or
		script this might be usefull.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	param ([string]
		$sessionName = "session-$(get-date -f yyyyMMddhh)")
	
	$file = (get-sessionfile $sessionName)
	
	(pwd).Path > "$file-pwd.ps1session"
	
	get-history | export-csv "$file-hist.ps1session"
	
	Write-Output "Session $sessionName saved"
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:import-session([string]$sessionName) {
<#
	.SYNOPSIS
		Import a PowerShell session info from file

	.DESCRIPTION
		This is a (very) poor man approach to restore some session infos

	Our concept of session is simple and only considers:
		- history
		- The current directory

		But still can be very handy and usefull. If you type in some sneaky commands,
		or some very complex things and you did not copied these to another file or script
		it can save you a lot of time if you need to do it again (And this is often the case)

		Even if you just want to dump it quick to copy it somewhen later to a documentation or
		script this might be usefull.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	$file = (get-sessionfile $sessionName)
	
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

function global:rdp {
<#
	.SYNOPSIS
		wrapper for the Windows RDP Client

	.DESCRIPTION
		Just a wrapper for the Windows Remote Desktop Protocoll (RDP) Client.

	.PARAMETER rdphost
		String

		The Host could be a hostname or an IP address

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp SNOOPY

		# Opens a Remote Desktop Session to the system with the Name SNOOPY

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:"deepblue.fra01.kreativsign.net"

		# Opens a Remote Desktop Session to the system deepblue.fra01.kreativsign.net

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:10.10.16.10

		# Opens a Remote Desktop Session to the system with the IPv4 address 10.10.16.10

	.NOTES
		Additional information about the function.

	.INPUTS
		String
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'The Host could be a hostname or an IP address')]
		[ValidateNotNullOrEmpty()]
		[Alias('host')]
		[string]
		$rdphost
	)
	
	if (!($rdphost)) {
		Write-PoshError -Message "Mandatory Parameter HOST is missing" -Stop
	} else {
		Start-Process -FilePath mstsc -ArgumentList "/admin /w:1024 /h:768 /v:$rdphost"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Reload-Module
function global:Reload-Module {
<#
	.SYNOPSIS
		Reloads a PowerShell Module

	.DESCRIPTION
		Reloads a PowerShell Module

	.PARAMETER ModuleName
		Name of the Module

	.NOTES
		Needs to be documented

	.LINK
		hochwald.net http://hochwald.net
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Name of the Module')]
		[ValidateNotNullOrEmpty()]
		$ModuleName
	)
	
	if ((get-module -all | where{ $_.name -eq "$ModuleName" } | measure-object).count -gt 0) {
		remove-module $ModuleName
		Write-Verbose "Module $ModuleName Unloaded"
		
		$pwd = Get-ScriptDirectory
		$file_path = $ModuleName;
		
		if (Test-Path (join-Path $pwd "$ModuleName.psm1")) {
			$file_path = (join-Path $pwd "$ModuleName.psm1")
		}
		
		import-module "$file_path" -DisableNameChecking -verbose:$false
		Write-Verbose "Module $ModuleName Loaded"
	} else {
		Write-Warning "Module $ModuleName Doesn't Exist"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:Set-VisualEditor {
<#
	.SYNOPSIS
		Set the VisualEditor variable

	.DESCRIPTION
		Setup the VisualEditor variable. Checks if the free (GNU licensed) Notepadd++ is installed,
		if so it uses this great free editor. If not the fallback is the PowerShell ISE.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		kreativsign.net http://kreativsign.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	# Do we have the Sublime Editor installed?
	$SublimeText = Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "Sublime*") "Sublime_text*");
	
	# Check if the GNU licensed Note++ is installed
	$NotepadPlusPlus = Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "notepad*") "notepad*");
	(resolve-path "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	
	# What Editor to use?
	if ($SublimeText -ne $null -and (test-path $SublimeText)) {
		# We have Sublime Editor installed, so we use it
		$global:VisualEditor = ($SublimeText.Path)
	} elseif ($NotepadPlusPlus -ne $null -and (test-path $NotepadPlusPlus)) {
		# We have Notepad++ installed, Sublime Editor is not here... use Notepad++
		$global:VisualEditor = ($NotepadPlusPlus.Path)
	} else {
		# No fancy editor, so we use ISE instead
		$global:VisualEditor = "PowerShell_ISE.exe"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Uni* like SuDo
function global:SuDo {
<#
	.SYNOPSIS
		Uni* like Superuser Do (Sudo)

	.DESCRIPTION
		Uni* like Superuser Do (Sudo)

	.PARAMETER file
		 Script/Program to run

	.EXAMPLE
		PS C:\scripts\PowerShell> SuDo C:\scripts\PowerShell\profile.ps1

	.EXAMPLE
		SuDo

	.NOTES
		Still a internal Beta function!

	.LINK

#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = ' Script/Program to run')]
		[ValidateNotNullOrEmpty()]
		[string]
		$file
	)
	
	$sudo = new-object System.Diagnostics.ProcessStartInfo
	$sudo.Verb = "runas";
	$sudo.FileName = "$pshome\PowerShell.exe"
	$sudo.windowStyle = "Normal"
	$sudo.WorkingDirectory = (Get-Location)
	if ($file) {
		if ((Test-Path $file) -eq $True) {
			$sudo.Arguments = "-executionpolicy unrestricted -NoExit -noprofile -Command $file"
		} else {
			write-error -Message:"Error: File does not exist - $file" -ErrorAction:Stop
		}
	} else {
		$sudo.Arguments = "-executionpolicy unrestricted -NoExit -Command  &{set-location '" + (get-location).Path + "'}"
	}
	
	[System.Diagnostics.Process]::Start($sudo) | out-null
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:tail {
<#
	.SYNOPSIS
		Make the PowerShell a bit more *NIX like

	.DESCRIPTION
		Wrapper for the PowerShell command Get-Content. It opens a given file and shows the content...
		Get-Content normally exists as soon as the end of the given file is reached, this wrapper keeps it open
		and display every new informations as soon as it appears. This could be very usefull for parsing logfiles.

		Everyone ever used Unix or Linux known tail ;-)

	.PARAMETER file
		File to open

	.EXAMPLE
		PS C:\scripts\PowerShell> tail C:\scripts\PowerShell\logs\create_new_OU_Structure.log

		# Opens the given Logfile (C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows every new entry until you break it (CTRL + C)

	.OUTPUTS
		String

	.NOTES
		Additional information about the function.

	.INPUTS
		String
#>
	
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'File to open')]
		[ValidateNotNullOrEmpty()]
		$file
	)
	
	if (!($file)) {
		# Aw SNAP! That sucks...
		Write-Error -Message:"Error: File to tail is missing..." -ErrorAction:Stop
	} else {
		# tailing the file for you, Sir! ;-)
		Get-Content $file -Wait
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:Test-Method {
<#
	.SYNOPSIS
		Short description

	.DESCRIPTION
		Detailed description

	.PARAMETER moduleName
		A description of the moduleName parameter.

	.PARAMETER functionName
		A description of the functionName parameter.

	.PARAMETER parameter
		Description of parameter

	.EXAMPLE
		Example text

	.OUTPUTS


	.NOTES


	.INPUTS


	.LINK
		hochwald.net http://hochwald.net
#>
	
	param
	(
		$moduleName,
		$functionName
	)
	
	(get-command -module $moduleName | Where-Object { $_.Name -eq "$functionName" } | Measure-Object).Count -eq 1;
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:time {
<#
	.SYNOPSIS
		Timing How Long it Takes a Script or Command to Run

	.DESCRIPTION
		This is a quick wrapper for Measure-Command Cmdlet

		Make the PowerShell a bit more *NIX like

		Everyone ever used Unix or Linux known time ;-)

	.PARAMETER file
		Script or command to execute

	.EXAMPLE
		PS C:\> time new-Bulk-devices.ps1

		# Runs the script new-Bulk-devices.ps1 and shows how log it takes to execute

	.EXAMPLE
		PS C:\> time Get-Service | Export-Clixml c:\scripts\test.xml

		# When you run this command, service information will be saved to the file Test.xml
		# It also shows how log it takes to execute

	.OUTPUTS
		String

	.NOTES
		Additional information about the function.

	.INPUTS
		String
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Script or command to execute')]
		[ValidateNotNullOrEmpty()]
		$file
	)
	
	if (!($file)) {
		# Aw SNAP! That sucks...
		Write-Error -Message:"Error: File to tail is missing..." -ErrorAction:Stop
	} else {
		# Measure the execution for you, Sir! ;-)
		Measure-Command { $file }
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:to-hex {
<#
	.SYNOPSIS
		Short description

	.DESCRIPTION
		Detailed description

	.PARAMETER dec
		N.A.

	.EXAMPLE
		PS C:\scripts\PowerShell> to-hex "100"
		0x64

	.OUTPUTS
		HEX Value of the given Integer

	.NOTES
		Just a little helper function

	.INPUTS
		Integer
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([long])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[long]
		$dec
	)
	
	return "0x" + $dec.ToString("X")
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Every *NIX user known Tocu and we miss that on PowerShell ;-)
function global:touch {
<#
	.SYNOPSIS
		Change file access and modification times

	.DESCRIPTION
		The touch utility sets the modification and access times of files.
		Touch changes both modification and access times.

		If any file does not exist, it is created with default permissions.

	.PARAMETER file
		The File to Touch

	.NOTES
		Make Powershell more Uni* like

	.LINK
		hochwald.net http://hochwald.net
#>
	
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = 'The File to Touch')]
		[ValidateNotNullOrEmpty()]
		[string]
		$file
	)
	
	if (test-path -ErrorAction SilentlyContinue -WarningAction SilentlyContinue $file) {
		$TouchFile = get-item $file;
		$DateNow = get-date
		$TouchFile.LastWriteTime = $DateNow
	} else {
		"" | out-file -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -FilePath $file -Encoding ASCII
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:ConvertFrom-UrlEncoded {
<#
	.SYNOPSIS
		Decodes a UrlEncoded string.

	.DESCRIPTION
		Decodes a UrlEncoded string.

		Input can be either a positional or named parameters of type string or an
		array of strings. The Cmdlet accepts pipeline input.

	.PARAMETER InputObject
		A description of the InputObject parameter.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch

		# Encoded string is passed as a positional parameter to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch

		# Encoded string is passed as a named parameter to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell>  ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch', 'http%3a%2f%2fwww.dfch.biz%2f'
		http://www.d-fens.ch
		http://www.dfch.biz/

		# Encoded strings are passed as an implicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f")
		http://www.d-fens.ch
		http://www.dfch.biz/

		# Encoded strings are passed as an explicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		http://www.d-fens.ch
		http://www.dfch.biz/

		Encoded strings are piped as an explicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> "http%3a%2f%2fwww.dfch.biz%2f" | ConvertFrom-UrlEncoded
		http://www.dfch.biz/

		# Encoded string is piped to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> $r = @("http%3a%2f%2fwww.d-fens.ch", 0, "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		PS C:\scripts\PowerShell> $r
		http://www.d-fens.ch
		0
		http://www.dfch.biz/

		# In case one of the passed strings is not a UrlEncoded encoded string, the
		# plain string is returned. The pipeline will continue to execute and all
		# strings are returned.

	.NOTES


	.LINK
		Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/
#>
	
	[CmdletBinding(HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		$InputObject
	)
	
	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		$OutputParameter = $null;
		Log-Debug -fn $fn -msg ("CALL. InputObject.Count: '{0}'" -f $InputObject.Count) -fac 1;
	}
	
	PROCESS {
		foreach ($Object in $InputObject) {
			$fReturn = $false;
			$OutputParameter = $null;
			
			$OutputParameter = [System.Web.HttpUtility]::UrlDecode($InputObject);
			$OutputParameter;
		}
		$fReturn = $true;
	}
	
	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}

function global:ConvertTo-UrlEncoded {
	[CmdletBinding(HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertTo-UrlEncoded/')]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]
		$InputObject
	)
	
	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		Log-Debug -fn $fn -msg ("CALL. Length '{0}'" -f $InputObject.Length) -fac 1;
	}
	PROCESS {
		$fReturn = $false;
		$OutputParameter = $null;
		
		$OutputParameter = [System.Web.HttpUtility]::UrlEncode($InputObject);
		return $OutputParameter;
	}
	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}

function global:uuidgen {
<#
	.SYNOPSIS
		Generates a UUID String

	.DESCRIPTION
		Generates a UUID String and is a uuidgen.exe replacement

	.EXAMPLE
		PS C:\scripts\PowerShell> uuidgen
		a08cdabe-f598-4930-a537-80e7d9f15dc3

		# Generates a UUID String

	.OUTPUTS
		UUID String like 32f35f41-3dcb-436f-baa9-77b621b90af0

	.NOTES
		Just a little helper function
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([string])]
	param ()
	[guid]::NewGuid().ToString('d')
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:ValidateMailAddress {
<#
	.SYNOPSIS
		Regex check to see if a given Email address is valid

	.DESCRIPTION
		Checks a given Mail Address against a REGEX Filter to see if it is RfC822 complaint

	.PARAMETER Email
		e.g. "joerg.hochwald@sartorius.com"
		Email address to check

	.EXAMPLE
		PS C:\> ValidateMailAddress -Email:"Robot.Noreply@Sartorius.com"

		# Checks a given Mail Address (Robot.Noreply@Sartorius.com) against a REGEX Filter to see if it is RfC822 complaint

	.OUTPUTS
		boolean
		Value is True or False

	.NOTES
		Internal Helper function to check Mail addresses via REGEX to see if they are RfC822 complaint before use them.

	.INPUTS
		Mail Adress to check against the RfC822 REGEX Filter
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   HelpMessage = 'Enter the Mail Address that you would like to check (Mandatory)')]
		[ValidateNotNullOrEmpty()]
		[Alias('Mail')]
		[string]
		$Email
	)
	
	return $Email -match "^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$"
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function global:whoami {
<#
	.SYNOPSIS
		Shows the windows login info

	.DESCRIPTION
		Make PowerShell a bit more like *NIX! Shows the Login info as you might know it from Unix/Linux

	.EXAMPLE
		PS C:\scripts\PowerShell> whoami
		BART\josh

		# Login (User) Josh on the system named BART

	.OUTPUTS
		String
#>
	[System.Security.Principal.WindowsIdentity]::GetCurrent().Name
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}


Export-ModuleMember `
Check-SessionArch `
, CheckTcpPort `
, convert-frombinhex `
, convert-tobinhex `
, ConvertTo-PlainText `
, Create-ZIP `
, Edit-HostsFile `
, Expand-CompressedItem `
, explore `
, get-hash `
, get-myprocess `
, get-syntax `
, Get-Uptime `
, GnuGrep `
, head `
, help `
, Initialize-Modules `
, Invoke-VisualEditor `
, append-classpath `
, JavaLove `
, ll `
, man `
, mkdir `
, myls `
, New-Guid `
, PoSHModuleLoader `
, get-sessionfile `
, export-session `
, import-session `
, rdp `
, Reload-Module `
, Set-VisualEditor `
, SuDo `
, tail `
, Test-Method `
, time `
, to-hex `
, touch `
, ConvertFrom-UrlEncoded `
, ConvertTo-UrlEncoded `
, uuidgen `
, ValidateMailAddress `
, wc `
, whoami

# SIG # Begin signature block
# MIITegYJKoZIhvcNAQcCoIITazCCE2cCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUvGrClzpKRdWT6Xpk7uXNJCJB
# Y/Oggg4LMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNTAyMDMwMDAw
# MDBaFw0yNjAzMDMwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCAMtwHjRygnJ08Kug9IYtZoU1+zETOA75+qrzE5ntz
# u0vxiNqQTnU3KDhjudcrD1SpVs53OZcwc82b2dkFRRyNpLgDXU/ZHC6Y4OmI5uzX
# BX5WKnv3FlujrY+XJRKEG7JcY0oK0u8QVEeChDVpKJwM5B8UFiT6ddx0cm5OyuNq
# Q6/PfTZI0b3pBpEsL6bIcf3PvdidIZj8r9veIoyvp/N3753co3BLRBrweIUe8qWM
# ObXciBw37a0U9QcLJr2+bQJesbiwWGyFOg32/1onDMXeU+dUPFZMyU5MMPbyXPsa
# jMKCvq1ZkfYbTVV7z1sB3P16028jXDJHmwHzwVEURoqbMIIFTDCCBDSgAwIBAgIQ
# FtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAwMDAwWhcNMTgwNzE2MjM1OTU5WjCB
# kDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1NTc2MQ8wDQYDVQQIDAZIZXNzZW4x
# EDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkMD0JhaG5ob2ZzcGxhdHogMTEZMBcG
# A1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcGA1UEAwwQS3JlYXRpdlNpZ24gR21i
# SDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8jDmF0TO09qJndJ9eG
# Fqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8kE5sL4/dMhuTOp+SMt0tI/SON6BY3
# 208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD8AIyrTH9b27wDNX4rC914Ka4EBI8
# sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSazE9yyRTuffidmtHV49DHPr+ql4ji
# NJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUukpzdCaA0UzygGUdDfgy0htSSp8MR9
# Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnkq0bXUIC6H0Zolnfl4fanvVYyvD88
# qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaAFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kGHucShjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEE
# BAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwIwKzApBggrBgEFBQcCARYd
# aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ29kZVNpZ25pbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LmNvbW9k
# b2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNydDAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMGA1UdEQQcMBqBGGhvY2h3YWxkQGty
# ZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsFAAOCAQEASSZkxKo3EyEk/qW0ZCs7
# CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqdwFkuQYJxzknqm2JMvwIK6BtfWc64
# WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPjen60W+L66oNEXiBuIsOcJ9e7tH6Vn
# 9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4LDHEpYpLRVQnuxoc38mmd+NfjcD2
# /o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ3trqmH6e3Cpm8Ut5UkoSONZdkYWw
# rzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnrHRReihZ0zwN+HkXO1XEnd3hm+08j
# LzGCBNkwggTVAgEBMIGRMH0xCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
# IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBD
# QSBMaW1pdGVkMSMwIQYDVQQDExpDT01PRE8gUlNBIENvZGUgU2lnbmluZyBDQQIQ
# FtT3Ux2bGCdP8iZzNFGAXDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU/JTcqwiuOQRFpxW7Kzub
# 2SZitvswDQYJKoZIhvcNAQEBBQAEggEAlrNjztu0HS1MT8uScvRgTe1c9OtZs5gX
# TlJkxsx3o4u5nZsh627PpVSZIUnMnVhgug25qDjlvAohn6YbDkD+JQuOBXXQ44E6
# jgWIokKWqjFVusnROoo9xdXUMU3niDFZL0/xwzNsvlxR7yCNwW/amTtK6FCLA8/U
# ocXpJI7JF0OudYqVmkxOyLzKgBjj6O5dKh9uEbTcQXzKYDQJjZY04lxT/TdTCJ9q
# DbVz9fUgVvHGQl/4xIvx4XRZLGuvyhqyyTBZYrvjCntrFP926Mgyg2vtyPyIRUbS
# pn5TNKOeVm0TuTrp/dWic5EU5PCgsP4qh05pRKc5KI7NBA4NYgNT66GCAqIwggKe
# BgkqhkiG9w0BCQYxggKPMIICiwIBATBoMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyAhIRIQaggdM/2HrlgkzBa1IJTgMwCQYFKw4DAhoFAKCB/TAY
# BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xNTEwMTEx
# NjI4MTVaMCMGCSqGSIb3DQEJBDEWBBQP3lfJprCUNMD1SRUy4BkUSIGuhTCBnQYL
# KoZIhvcNAQkQAgwxgY0wgYowgYcwgYQEFLNjCLTUze1Pz71muVX647+xLCnmMGww
# VqRUMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSgw
# JgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFtcGluZyBDQSAtIEcyAhIRIQaggdM/
# 2HrlgkzBa1IJTgMwDQYJKoZIhvcNAQEBBQAEggEAEIIJUtfz7AyqEmbVac9XlnyQ
# xh27NdR4s6/gku0OqFGPNN9hkdxcLc9/flgyz9eW89QyulLRgW567f8k6UuTLbaR
# P9qIIh2/SaS3Quj6S59OxAlz5PtkvQMmzIgLa/BuHXkeaD+oluWg2ZgJaTzZOiHH
# XQ7QfzCxbZb1aMUlVtGsOtBRRlaUnMsUJpcL6ssGdxMF06OWuR7sz9lRPW71w20E
# TcZ87B3kjW+FkzXaiQH8mBehVeWGVdY4ubkK0kkEBGK5hTW9MpVvmZCMIQsb1VtX
# CVGFDfacbUf8bx1u8Z5T7HRhHWqZit157gQ7qLn5bta1u6EUuEeCm6j6Gue3Og==
# SIG # End signature block
