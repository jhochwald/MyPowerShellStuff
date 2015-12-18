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

	Except as contained in this notice, the name of the Software, NET-Experts
	or Joerg Hochwald shall not be used in advertising or otherwise to promote
	the sale, use or other dealings in this Software without prior written
	authorization from Joerg Hochwald
#>

function Approve-MailAddress {
<#
	.SYNOPSIS
		REGEX check to see if a given Email address is valid

	.DESCRIPTION
		Checks a given Mail Address against a REGEX Filter to see if it is RfC822 complaint
		Not directly related is the REGEX check. Most mailer will not be able to handle it if there
		are non standard chars within the Mail Address...

	.PARAMETER Email
		e.g. "joerg.hochwald@outlook.com"
		Email address to check

	.EXAMPLE
		PS C:\> Approve-MailAddress -Email:"No.Reply@bewoelkt.net"
		True

		Checks a given Mail Address (No.Reply@bewoelkt.net) against a REGEX Filter to see if
		it is RfC822 complaint

	.EXAMPLE
		PS C:\> Approve-MailAddress -Email:"Jörg.hochwald@gmail.com"
		False

		Checks a given Mail Address (JÃ¶rg.hochwald@gmail.com) against a REGEX Filter to see if
		it is RfC822 complaint, and it is NOT

	.EXAMPLE
		PS C:\> Approve-MailAddress -Email:"Joerg hochwald@gmail.com"
		False

		Checks a given Mail Address (Joerg hochwald@gmail.com) against a REGEX Filter to see
		if it is RfC822 complaint, and it is NOT

	.EXAMPLE
		PS C:\> Approve-MailAddress -Email:"Joerg.hochwald@gmail"
		False

		Checks a given Mail Address (Joerg.hochwald@gmail) against a REGEX Filter to see
		if it is RfC822 complaint, and it is NOT

	.OUTPUTS
		boolean

	.NOTES
		The Function name is changed!

		Internal Helper function to check Mail addresses via REGEX to see if they are
		RfC822 complaint before use them.

	.INPUTS
		Mail Address to check against the RfC822 REGEX Filter

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Enter the Mail Address that you would like to check (Mandatory)')]
		[ValidateNotNullOrEmpty()]
		[Alias('Mail')]
		[string]
		$Email
	)
	
	# Old REGEX check
	Set-Variable -Name EmailRegexOld -Value $("^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$")
	
	# New REGEX check
	Set-Variable -Name EmailRegex -Value $('^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$';)
	
	# Check that the given Address is valid.
	if (($Email -match $EmailRegexOld) -and ($Email -match $EmailRegex)) {
		# Email seems to be valid
		Write-Output "True"
	} else {
		# Wow, that looks bad!
		Write-Output "False"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Check-SessionArch {
<#
	.SYNOPSIS
		Show the CPU architecture

	.DESCRIPTION
		You want to know if this is a 64BIT or still a 32BIT system?
		Might be useful, maybe not!

	.EXAMPLE
		PS C:\scripts\PowerShell> Check-SessionArch
		x64

		Shows that the architecture is 64BIT and that the session also supports X64

	.OUTPUTS
		String

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()
	
	# Figure out if this is a x64 or x86 system via NET call
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

function Get-TcpPortStatus {
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
		PS C:\> Get-TcpPortStatus

		Check port 587/TCP on the default Server

	.EXAMPLE
		PS C:\> Get-TcpPortStatus -Port:25 -Server:mx.net-experts.net
		True

		Check port 25/TCP on Server mx.net-experts.net

	.OUTPUTS
		boolean

	.NOTES
		Internal Helper function to check if we can reach a server via a TCP connection on a given port

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false)]
		[Int32]
		$Port = 587,
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
		Set-Variable -Name Port -Value $("587")
	}
	
	# Server given?
	if (!($Server)) {
		# Do we know any defaults?
		if (!($PSEmailServer)) {
			# We have a default SMTP Server, use it!
			Set-Variable -Name Server -Value $($PSEmailServer)
		} else {
			# Aw Snap! No Server given on the command line, no Server configured as default... BAD!
			Write-PoshError -Message "No SMTP Server given, no default configured" -Stop
		}
	}
	
	# Create a function to open a TCP connection
	Set-Variable -Name ThePortStatus -Value $(New-Object Net.Sockets.TcpClient -ErrorAction SilentlyContinue)
	
	# Look if the Server is Online and the port is open
	try {
		# Try to connect to one of the on Premise Exchange front end servers
		$ThePortStatus.Connect($Server, $Port)
	} catch [System.Exception] {
		# BAD, but do nothing yet! This is something the caller must handle
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

function Clear-TempDir {
<#
	.SYNOPSIS
		Cleanup the TEMP Directory

	.DESCRIPTION
		Cleanup the TEMP Directory

	.PARAMETER Days
		Number of days, older files will be removed!

	.PARAMETER Confirm
		A description of the Confirm parameter.

	.PARAMETER Whatif
		A description of the Whatif parameter.

	.EXAMPLE
		PS C:\scripts\PowerShell> Clear-TempDir
		Freed 439,58 MB disk space

		Will delete all Files older then 30 Days (This is the default)
		You have to confirm every item before it is deleted

	.EXAMPLE
		PS C:\scripts\PowerShell> Clear-TempDir -Days:60 -Confirm:$false
		Freed 407,17 MB disk space

		Will delete all Files older then 30 Days (This is the default)
		You do not have to confirm every item before it is deleted

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[OutputType([string])]
	param
	(
		[Parameter(Position = 0,
				   HelpMessage = 'Number of days, older files will be removed!')]
		[Alias('RemoveOlderThen')]
		[int]
		$Days = 30,
		[switch]
		$Confirm = $true,
		[Switch]
		$Whatif = $false
	)
	
	# Do we want to confirm?
	if ($confirm -eq $false) {
		Set-Variable -Name "_Confirm" -Value $($false)
	} elseif ($confirm -eq $true) {
		Set-Variable -Name "_Confirm" -Value $($true)
	}
	
	# Is there a WhatIf?
	if ($Whatif -eq $false) {
		Set-Variable -Name "_WhatIf" -Value $("#")
	} elseif ($Whatif -eq $true) {
		Set-Variable -Name "_WhatIf" -Value $("-WhatIf")
	}
	
	# Set the Cut Off Date
	Set-Variable -Name "cutoff" -Value $((Get-Date) - (New-TimeSpan -Days $Days))
	
	# Save what we have before we start the Clean up
	Set-Variable -Name "before" -Value $((Get-ChildItem $env:temp | Measure-Object Length -Sum).Sum)
	
	# Find all Files within the TEMP Directory and process them
	Get-ChildItem $env:temp |
	Where-Object { $_.Length -ne $null } |
	Where-Object { $_.LastWriteTime -lt $cutoff } |
	Remove-Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$_Confirm
	
	# How much do we have now?
	Set-Variable -Name "after" -Value $((Get-ChildItem $env:temp | Measure-Object Length -Sum).Sum)
	
	'Freed {0:0.00} MB disk space' -f (($before - $after)/1MB)
}

function ConvertFrom-binhex {
<#
	.SYNOPSIS
		Convert a HEX Value to a String

	.DESCRIPTION
		Converts a given HEX value back to human readable strings

	.PARAMETER HEX
		HEX String that you like to convert

	.EXAMPLE
		PS C:\> ConvertFrom-binhex 0c

		# Return the regular Value (12) of the given HEX 0c

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
		[ValidateNotNullOrEmpty()]
		$binhex
	)
	
	# Define a default
	Set-Variable -Name arr -Value $(new-object byte[] ($binhex.Length/2))
	
	# Loop over the given string
	for ($i = 0; $i -lt $arr.Length; $i++) {
		$arr[$i] = [Convert]::ToByte($binhex.substring($i * 2, 2), 16)
	}
	
	# Return the new value
	return $arr
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function ConvertTo-binhex {
<#
	.SYNOPSIS
		Convert a String to HEX

	.DESCRIPTION
		Converts a given String or Array to HEX and dumps it

	.PARAMETER array
		Array that should be converted to HEX

	.EXAMPLE
		PS C:\> ConvertTo-binhex 1234

		# Return the HEX Value (4d2) of the String 1234

	.INPUTS
		String
		Array

	.OUTPUTS
		String

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
		[ValidateNotNullOrEmpty()]
		$array
	)
	
	# Define a default
	Set-Variable -Name str -Value $(new-object system.text.stringbuilder)
	
	# Loop over the String
	$array | %{
		[void]$str.Append($_.ToString('x2'));
	}
	
	# Print the String
	return $str.ToString()
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function ConvertTo-HashTable {
<#
	.Synopsis
		Convert an object to a HashTable

	.Description
		Convert an object to a HashTable excluding certain types.  For example, ListDictionaryInternal doesn't support serialization therefore
		can't be converted to JSON.

	.Parameter InputObject
		Object to convert

	.Parameter ExcludeTypeName
		Array of types to skip adding to resulting HashTable.  Default is to skip ListDictionaryInternal and Object arrays.

	.Parameter MaxDepth
		Maximum depth of embedded objects to convert.  Default is 4.

	.Example
		$bios = get-ciminstance win32_bios
		$bios | ConvertTo-HashTable

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
		[Object]
		$InputObject,
		[string[]]
		$ExcludeTypeName = @("ListDictionaryInternal", "Object[]"),
		[ValidateRange(1, 10)]
		[Int]
		$MaxDepth = 4
	)
	
	Process {
		Write-Verbose "Converting to hashtable $($InputObject.GetType())"
		#$propNames = Get-Member -MemberType Properties -InputObject $InputObject | Select-Object -ExpandProperty Name
		$propNames = $InputObject.psobject.Properties | Select-Object -ExpandProperty Name
		$hash = @{ }
		$propNames | % {
			if ($InputObject.$_ -ne $null) {
				if ($InputObject.$_ -is [string] -or (Get-Member -MemberType Properties -InputObject ($InputObject.$_)).Count -eq 0) {
					$hash.Add($_, $InputObject.$_)
				} else {
					if ($InputObject.$_.GetType().Name -in $ExcludeTypeName) {
						Write-Verbose "Skipped $_"
					} elseif ($MaxDepth -gt 1) {
						$hash.Add($_, (ConvertTo-HashTable -InputObject $InputObject.$_ -MaxDepth ($MaxDepth - 1)))
					}
				}
			}
		}
		$hash
	}
}

function ConvertTo-hex {
<#
	.SYNOPSIS
		Converts a given integer to HEX

	.DESCRIPTION
		Converts any given Integer (INT) to Hex and dumps it to the Console

	.PARAMETER dec
		N.A.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertTo-hex "100"
		0x64

	.OUTPUTS
		HEX Value of the given Integer

	.NOTES
		Renamed function
		Just a little helper function

	.INPUTS
		Integer

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([long])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[long]
		$dec
	)
	
	# Print
	return "0x" + $dec.ToString("X")
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function ConvertTo-PlainText {
<#
	.SYNOPSIS
		Convert a secure string back to plain text

	.DESCRIPTION
		Convert a secure string back to plain text

	.PARAMETER secure
		Secure String to convert

	.NOTES
		Helper function

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
				   HelpMessage = 'Secure String to convert')]
		[ValidateNotNullOrEmpty()]
		[Alias('SecureString')]
		[security.securestring]
		$secure
	)
	
	# Define the Marshal Variable
	# We use the native .NET Call to do so!
	$marshal = [Runtime.InteropServices.Marshal];
	
	# Return what we have
	# We use the native .NET Call to do so!
	return $marshal::PtrToStringAuto($marshal::SecureStringToBSTR($secure));
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function ConvertTo-StringList {
<#
	.SYNOPSIS
		Function to convert an array into a string list with a delimiter.

	.DESCRIPTION
		Function to convert an array into a string list with a delimiter.

	.PARAMETER Array
		Specifies the array to process.

	.PARAMETER Delimiter
		Separator between value, default is ","

	.EXAMPLE
		$Computers = "Computer1","Computer2"
		ConvertTo-StringList -Array $Computers

		Output:
		Computer1,Computer2

	.EXAMPLE
		$Computers = "Computer1","Computer2"
		ConvertTo-StringList -Array $Computers -Delimiter "__"

		Output:
		Computer1__Computer2

	.EXAMPLE
		$Computers = "Computer1"
		ConvertTo-StringList -Array $Computers -Delimiter "__"

		Output:
		Computer1

	.NOTES
		Based on an idea of Francois-Xavier Cat

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
				   ValueFromPipeline = $true,
				   HelpMessage = 'Specifies the array to process.')]
		[ValidateNotNullOrEmpty()]
		[System.Array]
		$Array,
		[Parameter(HelpMessage = 'Separator between value')]
		[system.string]
		$Delimiter = ","
	)
	
	BEGIN {
		Remove-Variable -Name "StringList" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
	PROCESS {
		# Be verbose
		Write-Verbose -Message "Array: $Array"
		
		# Loop over each iten in the array
		foreach ($item in $Array) {
			# Adding the current object to the list
			$StringList += "$item$Delimiter"
		}
		
		# Be verbose
		Write-Verbose "StringList: $StringList"
	}
	END {
		try {
			if ($StringList) {
				$lenght = $StringList.Length
				
				# Be verbose
				Write-Verbose -Message "StringList Lenght: $lenght"
				
				# Output Info without the last delimiter
				$StringList.Substring(0, ($lenght - $($Delimiter.length)))
			}
		} catch {
			Write-Warning -Message "[END] Something wrong happening when output the result"
			$Error[0].Exception.Message
		} finally {
			Remove-Variable -Name "StringList" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}
}

function Create-ZIP {
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

		By default the new archive will be created in the same directory as the input file,
		if you would like to have it in another directory specify it here like this: "C:\temp\"
		The directory must exist!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv"

		This will create the archive "ClutterReport-20150617171648.zip" from the given input file
		"C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		The new archive will be located in "C:\scripts\PowerShell\export\"!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport"

		This will create the archive "NewClutterReport.zip" from the given input file
		"C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		The new archive will be located in "C:\scripts\PowerShell\export\"!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputPath "C:\temp\"

		This will create the archive "ClutterReport-20150617171648.zip" from the given input file
		"C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		The new archive will be located in "C:\temp\"! The directory must exist!

	.EXAMPLE
		PS C:\> Create-ZIP -InputFile "C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv" -OutputFile "NewClutterReport" -OutputPath "C:\temp\"

		This will create the archive "NewClutterReport.zip" from the given input file
		"C:\scripts\PowerShell\export\ClutterReport-20150617171648.csv".
		The new archive will be located in "C:\temp\"! The directory must exist!

	.OUTPUTS
		Compress File

	.NOTES
		Notes

	.INPUTS
		Parameters above

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
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
	Set-Variable -Name MyFileName -Value $((Get-Item $InputFile).Name)
	
	# Check if the parameter "OutputFile" is given
	if (-not ($OutputFile)) {
		# Extract the Filename, without PATH
		Set-Variable -Name OutputFile -Value $((Get-Item $InputFile).BaseName)
	}
	
	# Append the ZIP extension
	Set-Variable -Name OutputFile -Value $($OutputFile + ".zip")
	
	# Is the OutputPath Parameter given?
	if (-not ($OutputPath)) {
		# Build the new Path Variable
		Set-Variable -Name MyFilePath -Value $((Split-Path -Path $InputFile -Parent) + "\")
	} else {
		# Strip the trailing backslash if it exists
		Set-Variable -Name OutputPath -Value $($OutputPath.TrimEnd("\"))
		
		# Build the new Path Variable based on the given OutputPath Parameter
		Set-Variable -Name MyFilePath -Value $(($OutputPath) + "\")
	}
	
	# Build a new Filename with Path
	Set-Variable -Name OutArchiv -Value $(($MyFilePath) + ($OutputFile))
	
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
	# We use the native .NET Call to do so!
	Set-Variable -Name zip -Value $([System.IO.Compression.ZipFile]::Open($OutArchiv, "Create"))
	
	# Add input to the Archive
	# We use the native .NET Call to do so!
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

function Edit-HostsFile {
<#
	.SYNOPSIS
		Edit the Windows Host file

	.DESCRIPTION
		Shortcut to quickly edit the Windows host File. Might be useful for testing things without changing the regular DNS.
		Handle with care!

	.EXAMPLE
		PS C:\> Edit-HostsFile

		Opens the Editor configured within the VisualEditor variable to edit the Windows Host file

	.NOTES
		Additional information about the function.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Open the Host file with...
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

function Expand-CompressedItem {
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

function explore {
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
		[Alias('Location')]
		[string]
		$loc = '.'
	)
	
	# That is easy!
	explorer "/e,"$loc""
}

function Get-BingSearch {
<#
	.SYNOPSIS
		Get the Bing results for a string

	.DESCRIPTION
		Get the latest Bin search results for a given string and presents it on the console

	.PARAMETER searchstring
		String to search for on Bing

	.EXAMPLE
		PS C:\> Get-BingSearch -searchstring:"Joerg Hochwald"

		Return the Bing Search Results for "Joerg Hochwald"

	.EXAMPLE
		PS C:\> Get-BingSearch -searchstring:"KreativSign GmbH"

		Return the Bing Search Results for "KreativSign GmbH" as a formated List (fl = Format-List)

	.NOTES
		This is a function that Michael found useful, so we adopted and tweaked it a bit.
		The original function was found somewhere on the Internet!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Search')]
		[string]
		$searchstring = $(throw "Please specify a search string.")
	)
	
	# Use the native .NET Client implementation
	$client = New-Object System.Net.WebClient
	
	# What to call?
	$url = "http://www.bing.com/search?q={0}`&format=rss" -f $searchstring
	
	# By the way: This is XML ;-)
	[xml]$results = $client.DownloadString($url)
	
	# Save the info to a variable
	$channel = $results.rss.channel
	
	# Now we loop over the return
	foreach ($item in $channel.item) {
		# Create a new Object
		$result = New-Object PSObject
		
		# Fill the new Object
		$result | Add-Member NoteProperty Title -value $item.title
		$result | Add-Member NoteProperty Link -value $item.link
		$result | Add-Member NoteProperty Description -value $item.description
		$result | Add-Member NoteProperty PubDate -value $item.pubdate
		$sb = {
			$ie = New-Object -com internetexplorer.application
			$ie.navigate($this.link)
			$ie.visible = $true
		}
		$result | Add-Member ScriptMethod Open -value $sb
		
		# Dump it to the console
		$result
	}
}

function get-hash {
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

		Return the MD5 Hash of .\profile.ps1

	.OUTPUTS
		String

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
		[Parameter(Mandatory = $true,
				   Position = 0)]
		[Alias('File')]
		[string]
		$value
	)
	
	# Define a Default
	Set-Variable -Name hashalgo -Value 'MD5'
	
	# Define a new working variable
	Set-Variable -Name tohash -Value $($value)
	
	# Is this a string?
	if ($value -is [string]) {
		# Define a new working variable
		Set-Variable -Name tohash -Value $([text.encoding]::UTF8.GetBytes($value))
	}
	
	# Define a new working variable
	Set-Variable -Name hash -Value $([security.cryptography.hashalgorithm]::Create($hashalgo))
	
	# What do we have?
	return convert-tobinhex($hash.ComputeHash($tohash));
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Get-HostFileEntry {
<#
	.SYNOPSIS
		Dumps the HOSTS File to the Console

	.DESCRIPTION
		Dumps the HOSTS File to the Console
		It dumps the WINDIR\System32\drivers\etc\hosts

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-HostFileEntry

		IP                                                              Hostname
		--                                                              --------
		10.211.55.123                                                   GOV13714W7
		10.211.55.10                                                    jhwsrv08R2
		10.211.55.125                                                   KSWIN07DEV

		Dumps the HOSTS File to the Console

	.NOTES
		This is just a little helper function to make the shell more flexible
		Sometimes I need to know what is set in the HOSTS File... So I came up with that approach.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Cleanup
	$HostOutput = @()
	
	# Which File to load
	Set-Variable -Name "HostFile" -Scope:Script -Value $($env:windir + "\System32\drivers\etc\hosts")
	
	# REGEX Filter
	[regex]$r = "\S"
	
	# Open the File from above
	Get-Content $HostFile | ? {
		(($r.Match($_)).value -ne "#") -and ($_ -notmatch "^\s+$") -and ($_.Length -gt 0)
	} | % {
		$_ -match "(?<IP>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(?<HOSTNAME>\S+)" | Out-Null
		$HostOutput += New-Object -TypeName PSCustomObject -Property @{ 'IP' = $matches.ip; 'Hostname' = $matches.hostname }
	}
	
	# Dump it to the Console
	$HostOutput
}

function Get-IsSessionElevated {
<#
	.SYNOPSIS
		Is the Session started as admin (Elevated)

	.DESCRIPTION
		Quick Helper that return if the session is started as admin (Elevated)
		It returns a Boolean (True or False) and sets a global variable (IsSessionElevated) with
		this Boolean value. This might be useful for further use!

	.EXAMPLE
		PS C:\> Get-IsSessionElevated

		True
		# If the session is elevated

	.EXAMPLE
		PS C:\> Get-IsSessionElevated

		False
		# If the session is not elevated

	.OUTPUTS
		System.Boolean

	.NOTES
		Quick Helper that return if the session is started as admin (Elevated)

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	[OutputType([bool])]
	param ()
	
	# Build the current Principal variable
	[System.Security.Principal.WindowsPrincipal]$currentPrincipal = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent());
	
	# Do we have admin permission?
	[System.Security.Principal.WindowsBuiltInRole]$administratorsRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;
	
	if ($currentPrincipal.IsInRole($administratorsRole)) {
		# Yep! We have some power...
		return $true;
		
		# Set the Variable
		Set-Variable -Name IsSessionElevated -Scope:Global -Value $true
	} else {
		# Nope! Regular User Session!
		return $false;
		
		# Set the Variable
		Set-Variable -Name IsSessionElevated -Scope:Global -Value $false
	}
}

function Get-IsVirtual {
<#
	.SYNOPSIS
		Check if this is a Virtual Machine

	.DESCRIPTION
		If this is a virtual System the Boolean is True, if not it is False

	.EXAMPLE
		PS C:\> Get-IsVirtual
		True

		If this is a virtual System the Boolean is True, if not it is False

	.EXAMPLE
		PS C:\> Get-IsVirtual
		False

		If this is not a virtual System the Boolean is False, if so it is True

	.OUTPUTS
		boolean

	.NOTES
		The Function name is changed!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param ()
	
	# Cleanup
	Remove-Variable SysInfo_IsVirtual -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable SysInfoVirtualType -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable WMI_BIOS -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable WMI_ComputerSystem -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Get some System infos via NET (WMI) call
	Set-Variable -Name "WMI_BIOS" -Scope:Script -Value $($WMI_BIOS = (Get-WmiObject -Class 'Win32_BIOS' -ErrorAction Stop | Select-Object -Property 'Version', 'SerialNumber'))
	Set-Variable -Name "WMI_ComputerSystem" -Scope:Script -Value $((Get-WmiObject -Class 'Win32_ComputerSystem' -ErrorAction Stop | Select-Object -Property 'Model', 'Manufacturer'))
	
	# First we try to figure out if this is a Virtual Machine based on the
	# Bios Serial information that we get via WMI
	if ($WMI_BIOS.SerialNumber -like "*VMware*") {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VMWare")
	} elseif ($WMI_BIOS.Version -like "VIRTUAL") {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Hyper-V")
	} elseif ($WMI_BIOS.Version -like "A M I") {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Virtual PC")
	} elseif ($WMI_BIOS.Version -like "*Xen*") {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Xen")
	} elseif (($WMI_BIOS.Version -like "PRLS*") -and ($WMI_BIOS.SerialNumber -like "Parallels-*")) {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Parallels")
	}
	
	# Looks like this is not a Virtual Machine, but to make sure that figure it out!
	# So we try some other information that we have via WMI :-)
	if (-not ($SysInfo_IsVirtual) -eq $true) {
		if ($WMI_ComputerSystem.Manufacturer -like "*Microsoft*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Hyper-V")
		} elseif ($WMI_ComputerSystem.Manufacturer -like "*VMWare*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VMWare")
		} elseif ($WMI_ComputerSystem.Manufacturer -like "*Parallels*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Parallels")
		} elseif ($wmisystem.model -match "VirtualBox") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("VirtualBox")
		} elseif ($wmisystem.model -like "*Virtual*") {
			Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($true)
			Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Unknown Virtual Machine")
		}
	}
	
	# OK, this does not look like a Virtual Machine to us!
	if (-not ($SysInfo_IsVirtual) -eq $true) {
		Set-Variable -Name "SysInfo_IsVirtual" -Scope:Script -Value $($false)
		Set-Variable -Name "SysInfoVirtualType" -Scope:Script -Value $("Not a Virtual Machine")
	}
	
	# Dump the Boolean Info!
	Write-Output "$SysInfo_IsVirtual"
	
	# Write some Debug Infos ;-)
	Write-Debug -Message "$SysInfoVirtualType"
	
	# Cleanup
	Remove-Variable SysInfo_IsVirtual -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable SysInfoVirtualType -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable WMI_BIOS -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable WMI_ComputerSystem -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
}

function get-myprocess {
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
		Just a little helper function that might be useful if you have a long running shell session

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
	
	# Get the info
	[diagnostics.process]::GetCurrentProcess()
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Get-NetFramework {
<#
	.SYNOPSIS
		This function will retrieve the list of Framework Installed on the computer.

	.DESCRIPTION
		A detailed description of the Get-NetFramework function.

	.PARAMETER ComputerName
		Computer Name

	.PARAMETER Credentials
		Credentials to use

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-NetFramework

		PSChildName                                   Version
		-----------                                   -------
		v2.0.50727                                    2.0.50727.4927
		v3.0                                          3.0.30729.4926
		Windows Communication Foundation              3.0.4506.4926
		Windows Presentation Foundation               3.0.6920.4902
		v3.5                                          3.5.30729.4926
		Client                                        4.5.51641
		Full                                          4.5.51641
		Client                                        4.0.0.0

	.NOTES

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'High',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(HelpMessage = 'Computer Name')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(HelpMessage = 'Credentials to use')]
		$Credentials = $Credential
	)
	
	$Splatting = @{
		ComputerName = $ComputerName
	}
	
	if ($PSBoundParameters['Credential']) { $Splatting.credential = $Credentials }
	
	Invoke-Command @Splatting -ScriptBlock {
		Write-Verbose -Message "$pscomputername"
		
		# Get the Net Framework Installed
		
		$netFramework = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
		Get-ItemProperty -name Version -EA 0 |
		Where-Object { $_.PSChildName -match '^(?!S)\p{L}' } |
		Select-Object -Property PSChildName, Version
		
		# Prepare output
		$Properties = @{
			ComputerName = "$($env:Computername)$($env:USERDNSDOMAIN)"
			PowerShellVersion = $psversiontable.PSVersion.Major
			NetFramework = $netFramework
		}
		
		New-Object -TypeName PSObject -Property $Properties
	}
}

function Get-NetStat {
<#
	.SYNOPSIS
		This function will get the output of netstat -n and parse the output

	.DESCRIPTION
		This function will get the output of netstat -n and parse the output

	.NOTES
		Based on an idea of Francois-Xavier Cat

	.LINK
		Idea: http://www.lazywinadmin.com/2014/08/powershell-parse-this-netstatexe.html

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	PROCESS {
		# Get the output of netstat
		Set-Variable -Name "data" -Value $(netstat -n)
		
		# Keep only the line with the data (we remove the first lines)
		Set-Variable -Name "data" -Value $($data[4..$data.count])
		
		# Each line need to be splitted and get rid of unnecessary spaces
		foreach ($line in $data) {
			# Get rid of the first whitespaces, at the beginning of the line
			Set-Variable -Name "line" -Value $($line -replace '^\s+', '')
			
			# Split each property on whitespaces block
			Set-Variable -Name "line" -Value $($line -split '\s+')
			
			# Define the properties
			$properties = @{
				Protocole = $line[0]
				LocalAddressIP = ($line[1] -split ":")[0]
				LocalAddressPort = ($line[1] -split ":")[1]
				ForeignAddressIP = ($line[2] -split ":")[0]
				ForeignAddressPort = ($line[2] -split ":")[1]
				State = $line[3]
			}
			
			# Output the current line
			New-Object -TypeName PSObject -Property $properties
		}
	}
}

function Get-NewPassword {
<#
	.SYNOPSIS
		Generates a New password with varying length and Complexity,

	.DESCRIPTION
		Generate a New Password for a User.  Defaults to 8 Characters
		with Moderate Complexity.  Usage

		GET-NEWPASSWORD or

		GET-NEWPASSWORD $Length $Complexity

		Where $Length is an integer from 1 to as high as you want
		and $Complexity is an Integer from 1 to 4

	.PARAMETER PasswordLength
		Password Length

	.PARAMETER Complexity
		Complexity Level

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-NewPassword
		zemermyya784vKx93

		Create New Password based on the defaults

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-NewPassword 9 1
		zemermyya

		Generate a Password of strictly Uppercase letters that is 9 letters long

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-NewPassword 5
		zemermyya784vKx93K2sqG

		Generate a Highly Complex password 5 letters long

	.EXAMPLE
		$MYPASSWORD=ConvertTo-SecureString (Get-NewPassword 8 2) -asplaintext -force

		Create a new 8 Character Password of Uppercase/Lowercase and store
		as a Secure.String in Variable called $MYPASSWORD

	.NOTES
		The Complexity falls into the following setup for the Complexity level
		1 - Pure lowercase Ascii
		2 - Mix Uppercase and Lowercase Ascii
		3 - Ascii Upper/Lower with Numbers
		4 - Ascii Upper/Lower with Numbers and Punctuation

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
		[Parameter(HelpMessage = 'Password Length')]
		[ValidateNotNullOrEmpty()]
		[Alias('Length')]
		[int]
		$PasswordLength = '8',
		[Parameter(HelpMessage = 'Complexity Level')]
		[ValidateNotNullOrEmpty()]
		[Alias('Level')]
		[int]
		$Complexity = '3'
	)
	
	# Delare an array holding what I need.  Here is the format
	# The first number is a the number of characters (Ie 26 for the alphabet)
	# The Second Number is WHERE it resides in the Ascii Character set
	# So 26,97 will pick a random number representing a letter in Asciii
	# and add it to 97 to produce the ASCII Character
	#
	[int32[]]$ArrayofAscii = 26, 97, 26, 65, 10, 48, 15, 33
	
	# Complexity can be from 1 - 4 with the results being
	# 1 - Pure lowercase Ascii
	# 2 - Mix Uppercase and Lowercase Ascii
	# 3 - Ascii Upper/Lower with Numbers
	# 4 - Ascii Upper/Lower with Numbers and Punctuation
	If ($Complexity -eq $NULL) {
		Set-Variable -Name "Complexity" -Scope:Script -Value $(3)
	}
	
	# Password Length can be from 1 to as Crazy as you want
	#
	If ($PasswordLength -eq $NULL) {
		Set-Variable -Name "PasswordLength" -Scope:Script -Value $(10)
	}
	
	# Nullify the Variable holding the password
	Remove-Variable -Name "NewPassword" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Here is our loop
	Foreach ($counter in 1..$PasswordLength) {
		
		# What we do here is pick a random pair (4 possible)
		# in the array to generate out random letters / numbers
		Set-Variable -Name "pickSet" -Scope:Script -Value $((GET-Random $complexity) * 2)
		
		# Pick an Ascii Character and add it to the Password
		# Here is the original line I was testing with
		# [char] (GET-RANDOM 26) +97 Which generates
		# Random Lowercase ASCII Characters
		# [char] (GET-RANDOM 26) +65 Which generates
		# Random Uppercase ASCII Characters
		# [char] (GET-RANDOM 10) +48 Which generates
		# Random Numeric ASCII Characters
		# [char] (GET-RANDOM 15) +33 Which generates
		# Random Punctuation ASCII Characters
		Set-Variable -Name "NewPassword" -Scope:Script -Value $($NewPassword + [char]((get-random $ArrayOfAscii[$pickset]) + $ArrayOfAscii[$pickset + 1]))
	}
	
	# When we're done we Return the $NewPassword
	# BACK to the calling Party
	Return $NewPassword
}

function Get-PendingReboot {
<#
	.SYNOPSIS
		Gets the pending reboot status on a local or remote computer.

	.DESCRIPTION
		This function will query the registry on a local or remote computer and determine if the
		system is pending a reboot, from either Microsoft Patching or a Software Installation.
		For Windows 2008+ the function will query the CBS registry key as another factor in determining
		pending reboot state.  "PendingFileRenameOperations" and "Auto Update\RebootRequired" are observed
		as being consistant across Windows Server 2003 & 2008.

		CBServicing = Component Based Servicing (Windows 2008)
		WindowsUpdate = Windows Update / Auto Update (Windows 2003 / 2008)
		CCMClientSDK = SCCM 2012 Clients only (DetermineIfRebootPending method) otherwise $null value
		PendFileRename = PendingFileRenameOperations (Windows 2003 / 2008)

	.PARAMETER ComputerName
		A single Computer or an array of computer names. The default is localhost ($env:COMPUTERNAME).

	.EXAMPLE
		PS C:\> Get-PendingReboot -ComputerName (Get-Content C:\ServerList.txt) | Format-Table -AutoSize

		Computer CBServicing WindowsUpdate CCMClientSDK PendFileRename PendFileRenVal RebootPending
		-------- ----------- ------------- ------------ -------------- -------------- -------------
		DC01     False   False           False      False
		DC02     False   False           False      False
		FS01     False   False           False      False

		This example will capture the contents of C:\ServerList.txt and query the pending reboot
		information from the systems contained in the file and display the output in a table. The
		null values are by design, since these systems do not have the SCCM 2012 client installed,
		nor was the PendingFileRenameOperations value populated.

	.EXAMPLE
		PS C:\> Get-PendingReboot

		Computer     : WKS01
		CBServicing  : False
		WindowsUpdate      : True
		CCMClient    : False
		PendComputerRename : False
		PendFileRename     : False
		PendFileRenVal     :
		RebootPending      : True

		This example will query the local machine for pending reboot information.

	.EXAMPLE
		PS C:\> $Servers = Get-Content C:\Servers.txt
		PS C:\> Get-PendingReboot -Computer $Servers | Export-Csv C:\PendingRebootReport.csv -NoTypeInformation

		This example will create a report that contains pending reboot information.

	.NOTES
		Based on an idea of Brian Wilhite

	.LINK
		Component-Based Servicing: http://technet.microsoft.com/en-us/library/cc756291(v=WS.10).aspx

	.LINK
		PendingFileRename/Auto Update: http://support.microsoft.com/kb/2723674

	.LINK
		http://technet.microsoft.com/en-us/library/cc960241.aspx

	.LINK
		http://blogs.msdn.com/b/hansr/archive/2006/02/17/patchreboot.aspx

	.LINK
		SCCM 2012/CCM_ClientSDK: http://msdn.microsoft.com/en-us/library/jj902723.aspx
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0,
				   HelpMessage = 'A single Computer or an array of computer names.')]
		[Alias('CN', 'Computer')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME"
	)
	
	Begin {
		#
	}
	Process {
		Foreach ($Computer in $ComputerName) {
			Try {
				# Setting pending values to false to cut down on the number of else statements
				$CompPendRen, $PendFileRename, $Pending, $SCCM = $false, $false, $false, $false
				
				# Setting CBSRebootPend to null since not all versions of Windows has this value
				Remove-Variable -Name "CBSRebootPend" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				
				# Querying WMI for build version
				$WMI_OS = Get-WmiObject -Class Win32_OperatingSystem -Property BuildNumber, CSName -ComputerName $Computer -ErrorAction Stop
				
				# Making registry connection to the local/remote computer
				Set-Variable -Name "HKLM" -Value $([UInt32] "0x80000002")
				Set-Variable -Name "WMI_Reg" -Value $([WMIClass] "\\$Computer\root\default:StdRegProv")
				
				# If Vista/2008 & Above query the CBS Reg Key
				If ([Int32]$WMI_OS.BuildNumber -ge 6001) {
					Set-Variable -Name "RegSubKeysCBS" -Value $($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\"))
					Set-Variable -Name "$CBSRebootPend" -Value $($RegSubKeysCBS.sNames -contains "RebootPending")
				}
				
				# Query WUAU from the registry
				Set-Variable -Name "RegWUAURebootReq" -Value $($WMI_Reg.EnumKey($HKLM, "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\"))
				Set-Variable -Name "WUAURebootReq" -Value $($RegWUAURebootReq.sNames -contains "RebootRequired")
				
				# Query PendingFileRenameOperations from the registry
				Set-Variable -Name "RegSubKeySM" -Value $($WMI_Reg.GetMultiStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\Session Manager\", "PendingFileRenameOperations"))
				Set-Variable -Name "RegValuePFRO" -Value $($RegSubKeySM.sValue)
				
				# Query ComputerName and ActiveComputerName from the registry
				Set-Variable -Name "ActCompNm" -Value $($WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\", "ComputerName"))
				Set-Variable -Name "CompNm" -Value $($WMI_Reg.GetStringValue($HKLM, "SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\", "ComputerName"))
				
				
				If ($ActCompNm -ne $CompNm) {
					Set-Variable -Name "CompPendRen" -Value $($true)
				}
				
				# If PendingFileRenameOperations has a value set $RegValuePFRO variable to $true
				If ($RegValuePFRO) {
					Set-Variable -Name "PendFileRename" -Value $($true)
				}
				
				# Determine SCCM 2012 Client Reboot Pending Status
				# To avoid nested 'if' statements and unneeded WMI calls to determine if the CCM_ClientUtilities class exist, setting EA = 0
				Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				
				$CCMSplat = @{
					NameSpace = 'ROOT\ccm\ClientSDK'
					Class = 'CCM_ClientUtilities'
					Name = 'DetermineIfRebootPending'
					ComputerName = $Computer
					ErrorAction = 'Stop'
				}
				
				
				Try {
					Set-Variable -Name "CCMClientSDK" -Value $(Invoke-WmiMethod @CCMSplat)
				} Catch [System.UnauthorizedAccessException] {
					Set-Variable -Name "CcmStatus" -Value $(Get-Service -Name CcmExec -ComputerName $Computer -ErrorAction SilentlyContinue)
					
					If ($CcmStatus.Status -ne 'Running') {
						Write-Warning "$Computer`: Error - CcmExec service is not running."
						Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
					}
				} Catch {
					Remove-Variable -Name "CCMClientSDK" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				}
				
				If ($CCMClientSDK) {
					If ($CCMClientSDK.ReturnValue -ne 0) {
						Write-Warning "Error: DetermineIfRebootPending returned error code $($CCMClientSDK.ReturnValue)"
					}
					
					If ($CCMClientSDK.IsHardRebootPending -or $CCMClientSDK.RebootPending) {
						Set-Variable -Name "SCCM" -Value $($true)
					}
				} Else {
					Remove-Variable -Name "SCCM" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
				}
				
				## Creating Custom PSObject and Select-Object Splat
				$SelectSplat = @{
					Property = (
					'Computer',
					'CBServicing',
					'WindowsUpdate',
					'CCMClientSDK',
					'PendComputerRename',
					'PendFileRename',
					'PendFileRenVal',
					'RebootPending'
					)
				}
				
				New-Object -TypeName PSObject -Property @{
					Computer = $WMI_OS.CSName
					CBServicing = $CBSRebootPend
					WindowsUpdate = $WUAURebootReq
					CCMClientSDK = $SCCM
					PendComputerRename = $CompPendRen
					PendFileRename = $PendFileRename
					PendFileRenVal = $RegValuePFRO
					RebootPending = ($CompPendRen -or $CBSRebootPend -or $WUAURebootReq -or $SCCM -or $PendFileRename)
				} | Select-Object @SelectSplat
				
			} Catch {
				Write-Warning "$Computer`: $_"
			}
		}
	}
	
	End {
		#
	}
}

function Get-ServiceStatus {
<#
	.SYNOPSIS
		List Services where StartMode is AUTOMATIC that are NOT running

	.DESCRIPTION
		This functionwill list services from a local or remote computer where the StartMode property is set to "Automatic" and where the state is different from RUNNING (so mostly where the state is NOT RUNNING)

	.PARAMETER ComputerName
		Computer Name to execute the function

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-ServiceStatus
		DisplayName                                  Name                           StartMode State
		-----------                                  ----                           --------- -----
		Microsoft .NET Framework NGEN v4.0.30319_X86 clr_optimization_v4.0.30319_32 Auto      Stopped
		Microsoft .NET Framework NGEN v4.0.30319_X64 clr_optimization_v4.0.30319_64 Auto      Stopped
		Multimedia Class Scheduler                   MMCSS                          Auto      Stopped

	.NOTES
		Just an inital Version of the Function, it might still need some optimization.

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Position = 0,
				   HelpMessage = 'Computer Name to execute the function')]
		[string]
		$ComputerName = "$env:COMPUTERNAME"
	)
	
	if ($pscmdlet.ShouldProcess("Target", "Operation")) {
		# Try one or more commands
		try {
			# Cleanup
			Remove-Variable -Name "ServiceStatus" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
			
			# Get the Infos
			Set-Variable -Name "ServiceStatus" -Value $(Get-WmiObject Win32_Service -ComputerName $ComputerName | where { ($_.startmode -like "*auto*") -and ($_.state -notlike "*running*") } | select DisplayName, Name, StartMode, State | ft -AutoSize)
			
			# Dump it to the Console
			Write-Output -InputObject $ServiceStatus
		} catch {
			# Whoopsie!!!
			Write-Warning -Message 'Could not get the list of services for $ComputerName'
		} finally {
			# Cleanup
			Remove-Variable -Name "ServiceStatus" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		}
	}
}

function get-syntax {
<#
	.SYNOPSIS
		Get the syntax of a cmdlet, even if we have no help for it

	.DESCRIPTION
		Helper function to get the syntax of a alias or cmdlet, even if we have no help for it

	.PARAMETER cmdlet
		command-let that you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> get-syntax get-syntax

		# Get the syntax and parameters for the cmdlet "get-syntax".
		# Makes no sense at all, but this is just an example!

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Command')]
		$cmdlet
	)
	
	# Use Get-Command to show the syntax
	Get-Command $cmdlet -syntax
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Get-TempFile {
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
	
	# Define objects
	$elements = @()
	$elements += [System.IO.Path]::GetTempPath()
	$elements += [System.Guid]::NewGuid()
	$elements += $Extension.TrimStart('.')
	
	# Here we go: This is a Teampfile
	'{0}{1}.{2}' -f $elements
}

function Get-TimeStamp {
<#
	.SYNOPSIS
		Get-TimeStamp

	.DESCRIPTION
		Get-TimeStamp

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-TimeStamp
		2015-12-13 18:05:18

		Get a Timestamp as i would like it.

	.OUTPUTS

	.NOTES
		This is just a little helper function to make the shell more flexible
		It is just a kind of a leftover: Used that within my old logging functions a lot

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

function Get-TopProcesses {
<#
	.SYNOPSIS
		Make the PowerShell a bit more *NIX like

	.DESCRIPTION
		This is a PowerShell Version of the well known *NIX like TOP

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Define objects
	Set-Variable -Name SetValX -Value $([Console]::CursorLeft)
	Set-Variable -Name SetValY -Value $([Console]::CursorTop)
	
	# figure out what uses the most CPU Time
	While ($true) {
		# Get the fist 30 items
		Get-Process | Sort-Object -Descending CPU | Select-Object -First 30;
		
		# Wait 2 seconds
		Start-Sleep -Seconds 2;
		
		# Dump the Info
		[Console]::SetCursorPosition(${SetValX}, ${SetValY} + 3)
	}
}

# Uni* like Uptime
function Get-Uptime {
<#
	.SYNOPSIS
		Show how long system has been running

	.DESCRIPTION
		Uni* like Uptime - The uptime utility displays the current time,
		the length of time the system has been up

	.EXAMPLE
		PS C:\> Get-Uptime
		Uptime: 0 days, 2 hours, 11 minutes

		Returns the uptime of the system, the time since last reboot/startup

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()
	
	# Define objects
	$os = Get-WmiObject win32_operatingsystem
	$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
	$Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
	
	# Dump the Infos
	Write-Output $Display
}

function Get-uuid {
<#
	.SYNOPSIS
		Generates a UUID String

	.DESCRIPTION
		Generates a UUID String and is a uuidgen.exe replacement

	.EXAMPLE
		PS C:\scripts\PowerShell> Get-uuid
		a08cdabe-f598-4930-a537-80e7d9f15dc3

		Generates a UUID String

	.OUTPUTS
		UUID String like 32f35f41-3dcb-436f-baa9-77b621b90af0

	.NOTES
		Just a little helper function
		If you have Visual Studio installed, you might find the function useless!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()
	
	# Call NET function
	[guid]::NewGuid().ToString('d')
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Old implementation of the above GREP tool
# More complex but even more UNI* like
function GnuGrep {
<#
	.SYNOPSIS
		File pattern searcher

	.DESCRIPTION
		This command emulates the well known (and loved?) GNU file pattern searcher

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
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net

#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   Position = 0,
				   HelpMessage = ' Pattern (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('PaternString')]
		[string]
		$pattern,
		[Parameter(Mandatory = $true,
				   Position = 1,
				   HelpMessage = ' File (STRING) - Mandatory')]
		[ValidateNotNullOrEmpty()]
		[Alias('FFilter')]
		[string]
		$filefilter,
		[Alias('Recursive')]
		[switch]
		$r,
		[Alias('IgnoreCase')]
		[switch]
		$i,
		[Alias('ListFilenames')]
		[switch]
		$l
	)
	
	# Define object
	Set-Variable -Name path -Value $($pwd)
	
	# need to add filter for files only, no directories
	Set-Variable -Name files -Value $(Get-ChildItem $path -include "$filefilter" -recurse:$r)
	
	# What to do?
	if ($l) {
		# Do we need to loop?
		$files | foreach
		{
			# What is it?
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

function head {
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
	The Default is 10.

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Filename')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		[string]
		$file,
		[Alias('Counter')]
		[int]
		$count = 10
	)
	
	# Does this exist?
	if ((Test-Path $file) -eq $False) {
		# Aw Snap!
		Write-Error -Message:"Unable to locate file $file" -ErrorAction:Stop
		return;
	}
	
	# Show the fist X entries
	return Get-Content $file | Select-Object -First $count
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function help {
<#
	.SYNOPSIS
		Wrapper that use the cmdlet Get-Help -full

	.DESCRIPTION
		Wrapper that use the regular cmdlet Get-Help -full to show all technical informations about the given command

	.EXAMPLE
		PS C:\scripts\PowerShell> help get-item

		Show the full technical informations of the get-item cmdlet

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER cmdlet
		command-let

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Make the console clean
	clear-host
	
	# Get the FULL Help Message for the given command-let
	Get-Help $args[0] -full
}

function Initialize-Modules {
<#
	.SYNOPSIS
		Initialize PowerShell Modules

	.DESCRIPTION
		Initialize PowerShell Modules

	.NOTES
		Needs to be documented

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# is this a module?
	Get-Module | Where-Object { Test-Method $_.Name $_.Name } | foreach
	{
		# Define object
		Set-Variable -Name functionName -Value $($_.Name)
		
		# Show a verbose message
		Write-Verbose "Initializing Module $functionName"
		
		# Execute
		Invoke-Expression $functionName | Out-Null
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Invoke-VisualEditor {
<#
	.SYNOPSIS
		Wrapper to edit files

	.DESCRIPTION
		This is a quick wrapper that edits files with editor from the VisualEditor variable

	.PARAMETER args
		Arguments

	.PARAMETER Filename
		File that you would like to edit

	.EXAMPLE
		PS C:\scripts\PowerShell> Invoke-VisualEditor example.txt

		# Invokes Note++ or ISE and edits "example.txt".
		# This is possible, even if the File does not exists... The editor should ask you if it should create it for you

	.EXAMPLE
		PS C:\scripts\PowerShell> Invoke-VisualEditor

		Invokes Note++ or ISE without opening a file

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $false,
				   Position = 0)]
		[Alias('File')]
		[string]
		$args
	)
	
	# Call the newly set Editor
	if (!($VisualEditor)) {
		# Aw SNAP! The VisualEditor is not configured...
		Write-PoshError -Message:"System is not configured well! The Visual Editor is not given..." -Stop
	} else {
		# Yeah! Do it...
		if (-not ($args)) {
			#
			Start-Process -FilePath $VisualEditor
		} else {
			#
			Start-Process -FilePath $VisualEditor -ArgumentList "$args"
		}
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Convert-IPtoDecimal {
<#
	.SYNOPSIS
		Converts an IP address to decimal.

	.DESCRIPTION
		Converts an IP address to decimal value.

	.PARAMETER IPAddress
		An IP Address you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> Convert-IPtoDecimal -IPAddress '127.0.0.1','192.168.0.1','10.0.0.1'

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.EXAMPLE
		PS C:\scripts\PowerShell> Convert-IPtoDecimal '127.0.0.1','192.168.0.1','10.0.0.1'

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.EXAMPLE
		PS C:\scripts\PowerShell> '127.0.0.1','192.168.0.1','10.0.0.1' |  Convert-IPtoDecimal

		decimal		IPAddress
		-------		---------
		2130706433	127.0.0.1
		3232235521	192.168.0.1
		167772161	10.0.0.1

	.NOTES
		Sometimes I need to have that info, so I decided it would be great to have a functions who do the job!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding()]
	[OutputType([psobject])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'An IP Address you want to check')]
		[Alias('IP')]
		[string]
		$IPAddress
	)
	
	BEGIN {
		# Dummy block - We so nothing here
	}
	PROCESS {
		# OK make sure the we have a string here!
		# Then we split everthing based on the DOTs.
		[String[]]$IP = $IPAddress.Split('.')
		
		# Create a new object and transform it to Decimal
		$Object = New-Object -TypeName psobject -Property (@{
			'IPAddress' = $($IPAddress);
			'Decimal' = [Int64](
			([Int32]::Parse($IP[0]) * [Math]::Pow(2, 24) +
			([Int32]::Parse($IP[1]) * [Math]::Pow(2, 16) +
			([Int32]::Parse($IP[2]) * [Math]::Pow(2, 8) +
			([Int32]::Parse($IP[3])
			)
			)
			)
			)
			)
		})
	}
	END {
		# Dump the info to the console
		$Object
	}
}

function Check-IPaddress {
<#
	.SYNOPSIS
		Check if a given IP Address seems to be valid

	.DESCRIPTION
		Check if a given IP Address seems to be valid.
		We use the .NET function to do so. This is not 100% reliable,
		but is enough most times.

	.PARAMETER IPAddress
		An IP Address you want to check

	.EXAMPLE
		PS C:\scripts\PowerShell> Check-IPaddress

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([bool])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0,
				   HelpMessage = 'An IP Address you want to check')]
		[ValidateScript({
			$_ -match [IPAddress]
			$_
		})]
		[Alias('IP')]
		[string]
		$IPAddress
	)
	
	BEGIN {
		# Dummy block - We so nothing here
	}
	PROCESS {
		# Use the .NET Call to figure out if the given address is valid or not.
		Set-Variable -Name "IsValid" -Scope:Script -Value $(($IPAddress -As [IPAddress]) -As [Bool])
	}
	END {
		# Dump the bool value to the console
		$IsValid
	}
}

function Get-NtpTime {
<#
	.SYNOPSIS
		Get the NTP Time from a given Server

	.DESCRIPTION
		Get the NTP Time from a given Server.

	.PARAMETER Server
		NTP Server to use. The default is de.pool.ntp.org

	.NOTES
		This sends an NTP time packet to the specified NTP server and reads back the response.
		The NTP time packet from the server is decoded and returned.

		Note: this uses NTP (rfc-1305: http://www.faqs.org/rfcs/rfc1305.html) on UDP 123.
		Because the function makes a single call to a single server this is strictly a
		SNTP client (rfc-2030).
		Although the SNTP protocol data is similar (and can be identical) and the clients
		and servers are often unable to distinguish the difference.  Where SNTP differs is that
		is does not accumulate historical data (to enable statistical averaging) and does not
		retain a session between client and server.

		An alternative to NTP or SNTP is to use Daytime (rfc-867) on TCP port 13 –
		although this is an old protocol and is not supported by all NTP servers.

	.LINK
		Source: https://chrisjwarwick.wordpress.com/2012/08/26/getting-ntpsntp-network-time-with-powershell/
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([datetime])]
	param
	(
		[Parameter(HelpMessage = 'NTP Server to use. The default is de.pool.ntp.org')]
		[Alias('NETServer')]
		[string]
		$Server = 'de.pool.ntp.org'
	)
	
	# Construct client NTP time packet to send to specified server
	# (Request Header: [00=No Leap Warning; 011=Version 3; 011=Client Mode]; 00011011 = 0x1B)
	[Byte[]]$NtpData =, 0 * 48
	$NtpData[0] = 0x1B
	
	# Create the connection
	$Socket = New-Object Net.Sockets.Socket([Net.Sockets.AddressFamily]::InterNetwork, [Net.Sockets.SocketType]::Dgram, [Net.Sockets.ProtocolType]::Udp)
	
	# Configure the connection
	$Socket.Connect($Server, 123)
	[Void]$Socket.Send($NtpData)
	
	# Returns length – should be 48
	[Void]$Socket.Receive($NtpData)
	
	# Close the connection
	$Socket.Close()
	
	<#
		Decode the received NTP time packet

		We now have the 64-bit NTP time in the last 8 bytes of the received data.
		The NTP time is the number of seconds since 1/1/1900 and is split into an
		integer part (top 32 bits) and a fractional part, multipled by 2^32, in the
		bottom 32 bits.
	#>
	
	# Convert Integer and Fractional parts of 64-bit NTP time from byte array
	$IntPart = 0; Foreach ($Byte in $NtpData[40..43]) { $IntPart = $IntPart * 256 + $Byte }
	$FracPart = 0; Foreach ($Byte in $NtpData[44..47]) { $FracPart = $FracPart * 256 + $Byte }
	
	# Convert to Millseconds (convert fractional part by dividing value by 2^32)
	[UInt64]$Milliseconds = $IntPart * 1000 + ($FracPart * 1000 / 0x100000000)
	
	# Create UTC date of 1 Jan 1900,
	# add the NTP offset and convert result to local time
	(New-Object DateTime(1900, 1, 1, 0, 0, 0, [DateTimeKind]::Utc)).AddMilliseconds($Milliseconds).ToLocalTime()
}

function append-classpath {
<#
	.SYNOPSIS
		Append a given path to the Classpath

	.DESCRIPTION
		Appends a given path to the Java Classpath. Useful if you still need that old java crap!

		By the way: I hate Java!

	.EXAMPLE
		PS C:\scripts\PowerShell> append-classpath "."

		Include the directory where you are to the Java Classpath

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER path
		Path to include in the Java Classpath

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Do we have a class path?
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

function JavaLove {
<#
	.SYNOPSIS
		Set the JAVAHOME Variable to use JDK and/or JRE instances withing the Session

	.DESCRIPTION
		You are still using Java Stuff?
		OK... Your choice, so we do you the favor and create/fill the variable JAVAHOME based on the JDK/JRE that we found.
		It also append the Info to the PATH variable to make things easier for you.
		But think about dropping the buggy Java crap as soon as you can. Java is not only buggy, there are also many Security issues with it!

		By the way: I hate Java!

	.EXAMPLE
		PS C:\scripts\PowerShell> JavaLove

		Find the installed JDK and/or JRE version and crate the JDK_HOME and JAVA_HOME variables for you.
		It also appends the Path to the PATH  and CLASSPATH variable to make it easier for you.

		But do you still need java?

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Where do we want to search for the Java crap?
	Set-Variable -Name baseloc -Value $("$env:ProgramFiles\Java\")
	
	# Show Java a little love...
	# And I have no idea why I must do that!
	if ((test-path $baseloc)) {
		# Include JDK if found
		Set-Variable -Name sdkdir -Value $(resolve-path "$baseloc\jdk*")
		
		# Do we have a SDK?
		if ($sdkdir -ne $null -and (test-path $sdkdir)) {
			# Set the enviroment
			$env:JDK_HOME = $sdkdir
			
			# Tweak the PATH
			append-path "$sdkdir\bin"
		}
		
		# Include JRE if found
		$jredir = (resolve-path "$baseloc\jre*")
		
		# Do we have a JRE?
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
function ll {
<#
	.SYNOPSIS
		Quick helper to make my PowerShell a bit more like *nix

	.DESCRIPTION
		Everyone ever used a modern Unix and/or Linux system knows and love the colored output of LL
		This function is hack to emulate that on PowerShell.

	.PARAMETER dir
		Show the content of this Directory

	.PARAMETER all
		Show all files, included the hidden ones!

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Alias('Directory')]
		$dir = ".",
		[Alias('ShowAll')]
		$all = $false
	)
	
	# Define object
	Set-Variable -Name origFg -Value $($Host.UI.RawUI.ForegroundColor)
	
	# What to do?
	if ($all) {
		Set-Variable -Name toList -Value $(Get-ChildItem -force $dir)
	} else {
		Set-Variable -Name toList -Value $(Get-ChildItem $dir)
	}
	
	# Define the display colors for given extensions
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
		
		# All directories a Dark Grey
		if ($item.Mode.StartsWith("d")) {
			$Host.UI.RawUI.ForegroundColor = "DarkGray"
		}
		
		# Dump it
		$item
	}
	$Host.UI.RawUI.ForegroundColor = $origFg
}

# Make Powershell more Uni* like
function Load-Test {
<#
	.SYNOPSIS
		Load Pester Module

	.DESCRIPTION
		Load the Pester PowerShell Module to the Global context.
		Pester is a Mockup, Unit Test and Function Test Module for PowerShell

	.NOTES
		Pester Module must be installed

	.LINK
		Pester: https://github.com/pester/Pester

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Lets check if the Pester PowerShell Module is installed
	if (Get-Module -ListAvailable -Name Pester -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue) {
		try {
			#Make sure we remove the Pester Module (if loaded)
			Remove-Module -name [P]ester -force -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
			
			# Import the Pester PowerShell Module in the Global context
			Import-Module -Name [P]ester -DisableNameChecking -force -Scope Global -ErrorAction stop -WarningAction SilentlyContinue
		} catch {
			# Sorry, Pester PowerShell Module is not here!!!
			Write-Error -Message:"Error: Pester Module was not imported..." -ErrorAction:Stop
			
			# Still here? Make sure we are done!
			break
			
			# Aw Snap! We are still here? Fix that the Bruce Willis way: DIE HARD!
			exit 1
		}
	} else {
		# Sorry, Pester PowerShell Module is not here!!!
		Write-Warning  "Pester Module is not installed! Go to https://github.com/pester/Pester to get it!"
	}
}

# Make Powershell more Uni* like
function man {
<#
	.SYNOPSIS
		Wrapper of Get-Help

	.DESCRIPTION
		This wrapper uses Get-Help -full for a given cmdlet and shows everything paged. This is very much like the typical *nix like man

	.EXAMPLE
		PS C:\scripts\PowerShell> man get-item

		# Shows the complete help text of the cmdlet "get-item", page by page

	.NOTES
		This is just a little helper function to make the shell more flexible

	.PARAMETER cmdlet
		command-let

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Cleanup the console
	clear-host
	
	# get the Help for given command-let
	Get-Help $args[0] -full | Out-Host -paging
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Make Powershell more Uni* like
function mkdir {
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

		Creates a directory with the name "test"

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'Directory name to create')]
		[Alias('dir')]
		[string]
		$Directory
	)
	
	# Do it: Create the directory
	New-Item -type directory -path $Directory -ErrorAction:stop
}

function Update-SysInfo {
<#
	.SYNOPSIS
		Update Information about the system

	.DESCRIPTION
		This function updates the informations about the systems it runs on

	.EXAMPLE
		PS C:\> Update-SysInfo

		Update Information about the system, no output!

	.NOTES

	.LINK
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net

#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Call Companion to Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
	
	# Fill Variables with values
	Set-Variable -Name Operating_System -Scope:Global -Value $(Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -Property LastBootUpTime, TotalVisibleMemorySize, FreePhysicalMemory, Caption, Version, SystemDrive)
	Set-Variable -Name Processor -Scope:Global -Value $(Get-CimInstance -ClassName Win32_Processor | Select-Object -Property Name, LoadPercentage)
	Set-Variable -Name Logical_Disk -Scope:Global -Value $(Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object -Property DeviceID -eq -Value $(${Operating_System}.SystemDrive) | Select-Object -Property Size, FreeSpace)
	Set-Variable -Name Get_Date -Scope:Global -Value $(Get-Date)
	Set-Variable -Name Get_OS_Name -Scope:Global -Value $(${Operating_System}.Caption)
	Set-Variable -Name Get_Kernel_Info -Scope:Global -Value $(${Operating_System}.Version)
	Set-Variable -Name Get_Uptime -Scope:Global -Value $("$((${Get_Uptime} = ${Get_Date} - $(${Operating_System}.LastBootUpTime)).Days) days, $(${Get_Uptime}.Hours) hours, $(${Get_Uptime}.Minutes) minutes")
	Set-Variable -Name Get_Shell_Info -Scope:Global -Value $("{0}.{1}" -f ${PSVersionTable}.PSVersion.Major, ${PSVersionTable}.PSVersion.Minor)
	Set-Variable -Name Get_CPU_Info -Scope:Global -Value $(${Processor}.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' ')
	Set-Variable -Name Get_Process_Count -Scope:Global -Value $((Get-Process).Count)
	Set-Variable -Name Get_Current_Load -Scope:Global -Value $(${Processor}.LoadPercentage)
	Set-Variable -Name Get_Memory_Size -Scope:Global -Value $("{0}mb/{1}mb Used" -f (([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)) - ([math]::round(${Operating_System}.FreePhysicalMemory/1KB))), ([math]::round(${Operating_System}.TotalVisibleMemorySize/1KB)))
	Set-Variable -Name Get_Disk_Size -Scope:Global -Value $("{0}gb/{1}gb Used" -f (([math]::round(${Logical_Disk}.Size/1GB)) - ([math]::round(${Logical_Disk}.FreeSpace/1GB))), ([math]::round(${Logical_Disk}.Size/1GB)))
	
	# Do we have the NET-Experts Base Module?
	if ((Get-Command Get-NETXCoreVer -errorAction SilentlyContinue)) {
		Set-Variable -Name MyPoSHver -Scope:Global -Value $(Get-NETXCoreVer -s)
	} else {
		Set-Variable -Name MyPoSHver -Scope:Global -Value $("Unknown")
	}
	
	# Are we Admin?
	If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		Set-Variable -Name AmIAdmin -Scope:Global -Value $("(User)")
	} else {
		Set-Variable -Name AmIAdmin -Scope:Global -Value $("(Admin)")
	}
	
	# Is this a Virtual or a Real System?
	if ((Get-Command Get-IsVirtual -errorAction SilentlyContinue)) {
		if ((Get-IsVirtual) -eq $true) {
			Set-Variable -Name IsVirtual -Scope:Global -Value $("(Virtual)")
		} else {
			Set-Variable -Name IsVirtual -Scope:Global -Value $("(Real)")
		}
	} else {
		# No idea what to do without the command-let!
		Remove-Variable IsVirtual -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
	
<#
	# This is the old way (Will be removed soon)
	if (get-adminuser -errorAction SilentlyContinue) {
		if (get-adminuser -eq $true) {
			Set-Variable -Name AmIAdmin -Scope:Global -Value $("(Admin)")
		} elseif (get-adminuser -eq $false) {
			Set-Variable -Name AmIAdmin -Scope:Global -Value $("(User)")
		} else {
			Set-Variable -Name AmIAdmin -Scope:Global -Value $("")
		}
	}
#>
	
	# What CPU type do we have here?
	if ((Check-SessionArch -errorAction SilentlyContinue)) {
		Set-Variable -Name CPUtype -Scope:Global -Value $(Check-SessionArch)
	}
	
	# Define object
	Set-Variable -Name MyPSMode -Scope:Global -Value $($host.Runspace.ApartmentState)
}

function Clean-SysInfo {
<#
	.SYNOPSIS
		Companion for Update-SysInfo

	.DESCRIPTION
		Cleanup for variables from the Update-SysInfo function

	.EXAMPLE
		PS C:\> Clean-SysInfo

		# Cleanup for variables from the Update-SysInfo function

	.NOTES

#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Cleanup old objects
	Remove-Variable Operating_System -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Processor -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Logical_Disk -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Date -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_OS_Name -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Kernel_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Uptime -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Shell_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_CPU_Info -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Process_Count -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Current_Load -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Memory_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable Get_Disk_Size -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable MyPoSHver -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable AmIAdmin -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable CPUtype -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable MyPSMode -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	Remove-Variable IsVirtual -Scope:Global -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
}

function Get-MOTD {
<#
	.SYNOPSIS
		Displays system information to a host.

	.DESCRIPTION
		The Get-MOTD cmdlet is a system information tool written in PowerShell.

	.EXAMPLE
		PS C:\> Get-MOTD

		# Display the colorful Message of the Day with a Microsoft Logo and some system infos

	.NOTES
		inspired by this: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1

		The Microsoft Logo, PowerShell, Windows and some others are registered Trademarks by
		Microsoft Corporation. I do not own them, i just use them here :-)

		I moved some stuff in a separate function to make it reusable
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Update the Infos
	Update-SysInfo
	
	# Write to the Console
	Write-Host -Object ("")
	Write-Host -Object ("")
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("    Date/Time: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Date}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("         User: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:UserName} ${AmIAdmin}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("         Host: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:ComputerName}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("           OS: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("       Kernel: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("NT ") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("${Get_Kernel_Info} - ${CPUtype}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Red
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Green
	Write-Host -Object ("       Uptime: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Uptime}") -ForegroundColor Gray
	Write-Host -Object ("") -NoNewline
	Write-Host -Object ("                                  NETX Base: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${MyPoSHver} (${localDomain} - ${environment})") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("        Shell: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("Powershell ${Get_Shell_Info} - ${MyPSMode} Mode") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("          CPU: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_CPU_Info} ${IsVirtual}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("    Processes: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("         Load: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("%") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("       Memory: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Blue
	Write-Host -Object (" ███████████") -NoNewline -ForegroundColor Yellow
	Write-Host -Object ("         Disk: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Gray
	Write-Host -Object ("      ") -NoNewline
	Write-Host -Object ("")
	Write-Host -Object ("")
	
	# Call Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
}

function Get-SysInfo {
<#
	.SYNOPSIS
		Displays Information about the system

	.DESCRIPTION
		Displays Information about the system it is started on

	.EXAMPLE
		PS C:\> Get-SysInfo

		# Display some system infos

	.NOTES
		Based on an idea found here: https://github.com/michalmillar/ps-motd/blob/master/Get-MOTD.ps1
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Update the Infos
	Update-SysInfo
	
	# Write to the Console
	Write-Host -Object ("")
	Write-Host -Object ("  Date/Time: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Date}") -ForegroundColor Gray
	Write-Host -Object ("  User:      ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:UserName} ${AmIAdmin}") -ForegroundColor Gray
	Write-Host -Object ("  Host:      ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${env:ComputerName}") -ForegroundColor Gray
	Write-Host -Object ("  OS:        ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_OS_Name}") -ForegroundColor Gray
	Write-Host -Object ("  Kernel:    ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("NT ") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("${Get_Kernel_Info} - ${CPUtype}") -ForegroundColor Gray
	Write-Host -Object ("  Uptime:    ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Uptime}") -ForegroundColor Gray
	Write-Host -Object ("  NETX Base: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${MyPoSHver} (${localDomain} - ${environment})") -ForegroundColor Gray
	Write-Host -Object ("  Shell:     ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("Powershell ${Get_Shell_Info} - ${MyPSMode} Mode") -ForegroundColor Gray
	Write-Host -Object ("  CPU:       ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_CPU_Info} ${IsVirtual}") -ForegroundColor Gray
	Write-Host -Object ("  Processes: ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Process_Count}") -ForegroundColor Gray
	Write-Host -Object ("  Load:      ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Current_Load}") -NoNewline -ForegroundColor Gray
	Write-Host -Object ("%") -ForegroundColor Gray
	Write-Host -Object ("  Memory:    ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Memory_Size}") -ForegroundColor Gray
	Write-Host -Object ("  Disk:      ") -NoNewline -ForegroundColor DarkGray
	Write-Host -Object ("${Get_Disk_Size}") -ForegroundColor Gray
	Write-Host -Object ("")
	
	# Call Cleanup
	if ((Get-Command Clean-SysInfo -errorAction SilentlyContinue)) {
		Clean-SysInfo
	}
}

# Make Powershell more Uni* like
function myls {
<#
	.SYNOPSIS
		Wrapper for Get-ChildItem

	.DESCRIPTION
		This wrapper for Get-ChildItem shows all directories and files (even hidden ones)

	.PARAMETER loc
		A description of the loc parameter.

	.PARAMETER location
		This optional parameters is useful if you would like to see the content of another directory

	.EXAMPLE
		PS C:\scripts\PowerShell> myls

		Show the content of the directory where you are

	.EXAMPLE
		PS C:\scripts\PowerShell> myls c:\

		Show the content of "c:\"

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net

#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Alias('Location')]
		[string]
		$loc = '.'
	)
	
	# Execute GCI
	Get-ChildItem -force -att !a "$loc"
	Get-ChildItem -force -att !d "$loc"
}

function New-Guid {
<#
	.SYNOPSIS
		Creates a new Guid object and displays it to the screen

	.DESCRIPTION
		Uses static System.Guid.NewGuid() method to create a new Guid object

	.EXAMPLE
		PS C:\scripts\PowerShell> New-Guid
		fd6bd476-db80-44e7-ab34-47437adeb8e3

		Creates a new Guid object and displays its GUI to the screen

	.NOTES
		This is just a quick & dirty helper function to generate GUID's
		this is neat if you need a new GUID for an PowerShell Module.

		If you have Visual Studio, you might find this function useless!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()
	
	# Define object via NET
	[System.Guid]$guidObject = [System.Guid]::NewGuid()
	
	# Dump the new Object
	Write-Host $guidObject.Guid
}

function PoSHModuleLoader {
<#
	.SYNOPSIS
		Loads all Script modules

	.DESCRIPTION
		Loads all Script modules

	.NOTES
		Needs to be documented

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Load some PoSH modules
	Get-Module -ListAvailable | Where-Object { $_.ModuleType -eq "Script" } | Import-Module -DisableNameChecking -force -Scope Global -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
}

<#
	Simple Functions to save and restore PowerShell session information
#>
function get-sessionfile {
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
	
	# DUMP
	return "$([io.path]::GetTempPath())$sessionName";
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function export-session {
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

function import-session {
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

function rdp {
<#
	.SYNOPSIS
		Wrapper for the Windows RDP Client

	.DESCRIPTION
		Just a wrapper for the Windows Remote Desktop Protocol (RDP) Client.

	.PARAMETER rdphost
		String

		The Host could be a host name or an IP address

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp SNOOPY

		Opens a Remote Desktop Session to the system with the Name SNOOPY

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:"deepblue.fra01.kreativsign.net"

		Opens a Remote Desktop Session to the system deepblue.fra01.kreativsign.net

	.EXAMPLE
		PS C:\scripts\PowerShell> rdp -host:10.10.16.10

		Opens a Remote Desktop Session to the system with the IPv4 address 10.10.16.10

	.NOTES
		Additional information about the function.

	.INPUTS
		String

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'The Host could be a host name or an IP address')]
		[ValidateNotNullOrEmpty()]
		[Alias('host')]
		[string]
		$rdphost
	)
	
	# What do we have?
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

function Get-DefaultMessage {
<#
	.SYNOPSIS
		Helper Function to show default message used in VERBOSE/DEBUG/WARNING

	.DESCRIPTION
		Helper Function to show default message used in VERBOSE/DEBUG/WARNING
		and... HOST in some case.
		This is helpful to standardize the output messages

	.PARAMETER Message
		Specifies the message to show

	.NOTES
		Based on an ideas of Francois-Xavier Cat

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	param
	(
		[Parameter(HelpMessage = 'Specifies the message to show')]
		[string]
		$Message
	)
	
	# Set the Variables
	Set-Variable -Name "DateFormat" -Scope:Script -Value $(Get-Date -Format 'yyyy/MM/dd-HH:mm:ss:ff')
	Set-Variable -Name "FunctionName" -Scope:Script -Value $((Get-Variable -Scope 1 -Name MyInvocation -ValueOnly).MyCommand.Name)
	
	# Dump to the console
	Write-Output "[$DateFormat][$FunctionName] $Message"
}

function Disable-RemoteDesktop {
<#
	.SYNOPSIS
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.

	.DESCRIPTION
		The function Disable-RemoteDesktop will disable RemoteDesktop on a local or remote machine.

	.PARAMETER ComputerName
		Specifies the computername

	.PARAMETER Credential
		Specifies the credential to use

	.PARAMETER CimSession
		Specifies one or more existing CIM Session(s) to use

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -ComputerName DC01 -Credential (Get-Credential -cred "FX\SuperAdmin")

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session

	.EXAMPLE
		PS C:\> Disable-RemoteDesktop -CimSession $Session1,$session2,$session3

	.NOTES
		Based on an idea of Francois-Xavier Cat
#>
	
	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Specifies the computername')]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]
		$CimSession
	)
	
	BEGIN {
		#
	}
	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				$CIMComputer = $($Cim.ComputerName).ToUpper()
				
				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						CimSession = $Cim
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessGetCimInstance"
					}
					
					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName = "SetAllowTSConnections"
						Arguments = @{
							AllowTSConnections = 0;
							ModifyFirewallException = 0
						}
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessInvokeCim"
					}
					
					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - disable Remote Desktop (and Modify Firewall Exception")
					
					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} catch {
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")
					
					if ($ErrorProcessGetCimInstance) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance")
					}
					if ($ErrorProcessInvokeCim) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod")
					}
					
					Write-Warning -Message $Error[0].Exception.Message
				} finally {
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}
		foreach ($Computer in $ComputerName) {
			# Set a variable with the computername all upper case
			Set-Variable -Name "Computer" -Value $($Computer.ToUpper())
			
			try {
				# Be verbose
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")
				
				if (Test-Connection -Computer $Computer -count 1 -quiet) {
					$Splatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						ComputerName = $Computer
						ErrorAction = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}
					
					if ($PSBoundParameters['Credential']) {
						$Splatting.credential = $Credential
					}
					
					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - disable Remote Desktop")
					
					# disable Remote Desktop
					(Get-WmiObject @Splatting).SetAllowTsConnections(0, 0) | Out-Null
					
					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")
				
				if ($ErrorProcessGetWmi) {
					Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject")
				}
				
				Write-Warning -MEssage $Error[0].Exception.Message
			} finally {
				$Splatting.Clear()
			}
		}
	}
}

function Enable-RemoteDesktop {
<#
	.SYNOPSIS
		The function Enable-RemoteDesktop will enable RemoteDesktop on a local or remote machine.

	.DESCRIPTION
		The function Enable-RemoteDesktop will enable RemoteDesktop on a local or remote machine.

	.PARAMETER ComputerName
		Specifies the computername

	.PARAMETER Credential
		Specifies the credential to use

	.PARAMETER CimSession
		Specifies one or more existing CIM Session(s) to use

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -ComputerName DC01

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -ComputerName DC01 -Credential (Get-Credential -cred "FX\SuperAdmin")

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -CimSession $Session

	.EXAMPLE
		PS C:\> Enable-RemoteDesktop -CimSession $Session1,$session2,$session3

	.NOTES
		Based on an idea of Francois-Xavier Cat
#>
	
	[CmdletBinding(DefaultParameterSetName = 'CimSession',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(ParameterSetName = 'Main',
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Specifies the computername')]
		[Alias('CN', '__SERVER', 'PSComputerName')]
		[String[]]
		$ComputerName = "$env:COMPUTERNAME",
		[Parameter(ParameterSetName = 'Main',
				   HelpMessage = 'Specifies the credential to use')]
		[System.Management.Automation.Credential()]
		[Alias('RunAs')]
		$Credential = '[System.Management.Automation.PSCredential]::Empty',
		[Parameter(ParameterSetName = 'CimSession',
				   HelpMessage = 'Specifies one or more existing CIM Session(s) to use')]
		[Microsoft.Management.Infrastructure.CimSession[]]
		$CimSession
	)
	
	BEGIN {
		#
	}
	PROCESS {
		if ($PSBoundParameters['CimSession']) {
			foreach ($Cim in $CimSession) {
				# Create a Variable with an all upper case computer name
				Set-Variable -Name "CIMComputer" -Value $($($Cim.ComputerName).ToUpper())
				
				try {
					# Parameters for Get-CimInstance
					$CIMSplatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						CimSession = $Cim
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessGetCimInstance"
					}
					
					# Parameters for Invoke-CimMethod
					$CIMInvokeSplatting = @{
						MethodName = "SetAllowTSConnections"
						Arguments = @{
							AllowTSConnections = 1;
							ModifyFirewallException = 1
						}
						ErrorAction = 'Stop'
						ErrorVariable = "ErrorProcessInvokeCim"
					}
					
					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Enable Remote Desktop (and Modify Firewall Exception")
					
					#
					Get-CimInstance @CIMSplatting | Invoke-CimMethod @CIMInvokeSplatting
				} CATCH {
					# Whoopsie!
					Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - CIMSession - Something wrong happened")
					
					if ($ErrorProcessGetCimInstance) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Get-CimInstance")
					}
					
					if ($ErrorProcessInvokeCim) {
						Write-Warning -Message (Get-DefaultMessage -Message "$CIMComputer - Issue with Invoke-CimMethod")
					}
					
					Write-Warning -Message $Error[0].Exception.Message
				} FINALLY {
					# Cleanup
					$CIMSplatting.Clear()
					$CIMInvokeSplatting.Clear()
				}
			}
		}
		foreach ($Computer in $ComputerName) {
			# Creatre a Variable with the all upper case Computername
			Set-Variable -Name "Computer" -Value $($Computer.ToUpper())
			
			try {
				Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Test-Connection")
				if (Test-Connection -Computer $Computer -count 1 -quiet) {
					$Splatting = @{
						Class = "Win32_TerminalServiceSetting"
						NameSpace = "root\cimv2\terminalservices"
						ComputerName = $Computer
						ErrorAction = 'Stop'
						ErrorVariable = 'ErrorProcessGetWmi'
					}
					
					if ($PSBoundParameters['Credential']) {
						$Splatting.credential = $Credential
					}
					
					# Be verbose
					Write-Verbose -Message (Get-DefaultMessage -Message "$Computer - Get-WmiObject - Enable Remote Desktop")
					
					# Enable Remote Desktop
					(Get-WmiObject @Splatting).SetAllowTsConnections(1, 1) | Out-Null
					
					# Disable requirement that user must be authenticated
					#(Get-WmiObject -Class Win32_TSGeneralSetting @Splatting -Filter TerminalName='RDP-tcp').SetUserAuthenticationRequired(0)  Out-Null
				}
			} catch {
				# Whoopsie!
				Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Something wrong happened")
				
				if ($ErrorProcessGetWmi) {
					Write-Warning -Message (Get-DefaultMessage -Message "$Computer - Issue with Get-WmiObject")
				}
				
				Write-Warning -MEssage $Error[0].Exception.Message
			} finally {
				# Cleanup
				$Splatting.Clear()
			}
		}
	}
}

# Reload-Module
function Reload-Module {
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
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Name of the Module')]
		[ValidateNotNullOrEmpty()]
		[Alias('Module')]
		$ModuleName
	)
	
	# What to do?
	if ((get-module -all | where{ $_.name -eq "$ModuleName" } | measure-object).count -gt 0) {
		# Unload the Module
		remove-module $ModuleName
		
		# Verbose Message
		Write-Verbose "Module $ModuleName Unloaded"
		
		# Define objects
		Set-Variable -Name pwd -Value $(Get-ScriptDirectory)
		Set-Variable -Name file_path -Value $($ModuleName;)
		
		# is this a module?
		if (Test-Path (join-Path $pwd "$ModuleName.psm1")) {
			Set-Variable -Name file_path -Value $(join-Path $pwd "$ModuleName.psm1")
		}
		
		# Load the module
		import-module "$file_path" -DisableNameChecking -verbose:$false
		
		# verbose message
		Write-Verbose "Module $ModuleName Loaded"
	} else {
		Write-Warning "Module $ModuleName Doesn't Exist"
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function Repair-DotNetFrameWorks {
<#
	.SYNOPSIS
		Optimize all installed NET Frameworks

	.DESCRIPTION
		Optimize all installed NET Frameworks by executing NGEN.EXE for each.

		This could be useful to improve the performance and sometimes the
		installation of new NET Frameworks, or even patches, makes them use
		a single (the first) core only.

		Why Microsoft does not execute the NGEN.EXE with each installation... no idea!

	.EXAMPLE
		PS C:\> Repair-DotNetFrameWorks

		Optimize all installed NET Frameworks

	.NOTES
		The Function name is changed!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Cleanup
	Remove-Variable frameworks -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	
	# Get all NET framework paths and build an array with it
	$frameworks = @("$env:SystemRoot\Microsoft.NET\Framework")
	
	# If we run on an 64Bit system (what we should), we add these frameworks to
	If (Test-Path "$env:SystemRoot\Microsoft.NET\Framework64") {
		# Add the 64Bit Path to the array
		$frameworks += "$env:SystemRoot\Microsoft.NET\Framework64"
	}
	
	# Loop over all NET frameworks that we found.
	ForEach ($framework in $frameworks) {
		# Find the latest version of NGEN.EXE in the current framework path
		$ngen_path = Join-Path (Join-Path $framework -childPath (Get-ChildItem $framework | Where-Object { ($_.PSIsContainer) -and (Test-Path (Join-Path $_.FullName -childPath "ngen.exe")) } | Sort-Object Name -Descending | Select-Object -First 1).Name) -childPath "ngen.exe"
		
		# Execute the optimization command and suppress the output, we also prevent a new window
		Write-Output "$ngen_path executeQueuedItems"
		Start-Process $ngen_path -ArgumentList "executeQueuedItems" -NoNewWindow -Wait -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue -LoadUserProfile:$false -RedirectStandardOutput null
	}
	
	# Cleanup
	Remove-Variable frameworks -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
}

function Set-DebugOn {
<#
	.SYNOPSIS
		Turn Debug on

	.DESCRIPTION
		Turn Debug on

	.NOTES
		Just an internal function to make my life easier!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	
	Set-Variable -Name DebugPreference -Scope:Global -Value:"Continue" -Option AllScope -Visibility Public -Confirm:$False
	Set-Variable -Name NETXDebug -Scope:Global -Value:"$True" -Option AllScope -Visibility Public -Confirm:$False
}

function Set-DebugOff {
<#
	.SYNOPSIS
		Turn Debug off

	.DESCRIPTION
		Turn Debug on

	.NOTES
		Just an internal function to make my life easier!
#>
	
	[CmdletBinding(ConfirmImpact = 'None')]
	param ()
	
	Set-Variable -Name DebugPreference -Scope:Global -Value:"SilentlyContinue" -Option AllScope -Visibility Public -Confirm:$False
	Set-Variable -Name NETXDebug -Scope:Global -Value:"$False" -Option AllScope -Visibility Public -Confirm:$False
}

function Set-Encoding {
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
	
	# ensure it is a valid path
	if (-not (Test-Path -Path $path)) {
		# Aw, Snap!
		throw "File or directory not found at {0}" -f $path
	}
	
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
			
			# Do a garbage collection
			if ((Get-Command run-gc -errorAction SilentlyContinue)) {
				run-gc
			}
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
			
			# Do a garbage collection
			if ((Get-Command run-gc -errorAction SilentlyContinue)) {
				run-gc
			}
		}
	}
}

function Set-VisualEditor {
<#
	.SYNOPSIS
		Set the VisualEditor variable

	.DESCRIPTION
		Setup the VisualEditor variable. Checks if the free (GNU licensed) Notepad++ is installed,
		if so it uses this great free editor. If not the fall back is the PowerShell ISE.

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param ()
	
	# Do we have the Sublime Editor installed?
	Set-Variable -Name SublimeText -Value $(Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "Sublime*") "Sublime_text*");)
	
	# Check if the GNU licensed Note++ is installed
	Set-Variable -Name NotepadPlusPlus -Value $(Resolve-Path (join-path (join-path "$env:PROGRAMW6432*" "notepad*") "notepad*");)
	
	# Do we have it?
	(resolve-path "${env:ProgramFiles(x86)}\Notepad++\notepad++.exe" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue)
	
	# What Editor to use?
	if ($SublimeText -ne $null -and (test-path $SublimeText)) {
		# We have Sublime Editor installed, so we use it
		Set-Variable -Name VisualEditor -Scope:Global -Value $($SublimeText.Path)
	} elseif ($NotepadPlusPlus -ne $null -and (test-path $NotepadPlusPlus)) {
		# We have Notepad++ installed, Sublime Editor is not here... use Notepad++
		Set-Variable -Name VisualEditor -Scope:Global -Value $($NotepadPlusPlus.Path)
	} else {
		# No fancy editor, so we use ISE instead
		Set-Variable -Name VisualEditor -Scope:Global -Value $("PowerShell_ISE.exe")
	}
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Uni* like SuDo
function SuDo {
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
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = ' Script/Program to run')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		[string]
		$file
	)
	
	# Define some defaults
	$sudo = new-object System.Diagnostics.ProcessStartInfo
	$sudo.Verb = "runas";
	$sudo.FileName = "$pshome\PowerShell.exe"
	$sudo.windowStyle = "Normal"
	$sudo.WorkingDirectory = (Get-Location)
	
	# What to execute?
	if ($file) {
		if ((Test-Path $file) -eq $True) {
			$sudo.Arguments = "-executionpolicy unrestricted -NoExit -noprofile -Command $file"
		} else {
			write-error -Message:"Error: File does not exist - $file" -ErrorAction:Stop
		}
	} else {
		# No file given, so we open a Shell (Console)
		$sudo.Arguments = "-executionpolicy unrestricted -NoExit -Command  &{set-location '" + (get-location).Path + "'}"
	}
	
	# NET call to execute SuDo
	[System.Diagnostics.Process]::Start($sudo) | out-null
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function tail {
<#
	.SYNOPSIS
		Make the PowerShell a bit more *NIX like

	.DESCRIPTION
		Wrapper for the PowerShell command Get-Content. It opens a given file and shows the content...
		Get-Content normally exists as soon as the end of the given file is reached, this wrapper keeps it open
		and display every new informations as soon as it appears. This could be very useful for parsing log files.

		Everyone ever used Unix or Linux known tail ;-)

	.PARAMETER file
		File to open

	.EXAMPLE
		PS C:\scripts\PowerShell> tail C:\scripts\PowerShell\logs\create_new_OU_Structure.log

		Opens the given Log file (C:\scripts\PowerShell\logs\create_new_OU_Structure.log) and shows every new entry until you break it (CTRL + C)

	.OUTPUTS
		String

	.NOTES
		Make PowerShell a bit more like *NIX!

	.INPUTS
		String

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'File to open')]
		[ValidateNotNullOrEmpty()]
		[Alias('FileName')]
		$file
	)
	
	# Is the File given?
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

function Test-Method {
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
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Alias('Module')]
		[string]
		$moduleName,
		[Alias('Function')]
		[string]
		$functionName
	)
	
	(get-command -module $moduleName | Where-Object { $_.Name -eq "$functionName" } | Measure-Object).Count -eq 1;
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

function time {
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

		When you run this command, service information will be saved to the file Test.xml
		It also shows how log it takes to execute

	.OUTPUTS
		String

	.NOTES
		Make PowerShell a bit more like *NIX!

	.INPUTS
		String

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Script or command to execute')]
		[ValidateNotNullOrEmpty()]
		[Alias('Command')]
		$file
	)
	
	# Does the file exist?
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

function Set-FileTime {
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
	
	process {
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
		
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}

function ConvertFrom-UrlEncoded {
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
	
	[CmdletBinding(ConfirmImpact = 'None',
				   HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
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

function ConvertTo-UrlEncoded {
	[CmdletBinding(ConfirmImpact = 'None',
				   HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertTo-UrlEncoded/',
				   SupportsShouldProcess = $true)]
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

function Get-TinyURL {
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
	
	try {
		# Request
		Set-Variable -Name tinyURL -Value $(Invoke-WebRequest -Uri "http://tinyurl.com/api-create.php?url=$URL" | Select-Object -ExpandProperty Content)
		
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

function Get-IsGdURL {
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
	
	try {
		# Request
		Set-Variable -Name isgdURL -Value $(Invoke-WebRequest -Uri "http://is.gd/api.php?longurl=$URL" | Select-Object -ExpandProperty Content)
		
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

function Get-TrImURL {
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
	
	try {
		# Request
		Set-Variable -Name trimURL -Value $(Invoke-WebRequest -Uri "http://api.tr.im/api/trim_simple?url=$URL" | Select-Object -ExpandProperty Content)
		
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

function Get-LongURL {
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
	
	try {
		# Request
		Set-Variable -Name longURL -Value $(Invoke-WebRequest -Uri "http://untiny.me/api/1.0/extract?url=$URL&format=text" | Select-Object -ExpandProperty Content)
		
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

function whoami {
<#
	.SYNOPSIS
		Shows the windows login info

	.DESCRIPTION
		Make PowerShell a bit more like *NIX! Shows the Login info as you might know it from Unix/Linux

	.EXAMPLE
		PS C:\scripts\PowerShell> whoami
		BART\josh

		Login (User) Josh on the system named BART

	.OUTPUTS
		String

	.NOTES
		Make PowerShell a bit more like *NIX!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>
	
	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param ()
	
	# Call the NET function
	[System.Security.Principal.WindowsIdentity]::GetCurrent().Name
	
	# Do a garbage collection
	if ((Get-Command run-gc -errorAction SilentlyContinue)) {
		run-gc
	}
}

# Export Module Stuff
if ($loadingModule) {
	Export-ModuleMember -Function * -Alias *
}

<#
	Execute some stuff here
#>

# SIG # Begin signature block
# MIIT0QYJKoZIhvcNAQcCoIITwjCCE74CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUUEB7nt/ZRxazRaL6W9u0OgPW
# VjKgghEQMIIFTDCCBDSgAwIBAgIQFtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0B
# AQsFADB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
# MRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEj
# MCEGA1UEAxMaQ09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAw
# MDAwWhcNMTgwNzE2MjM1OTU5WjCBkDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1
# NTc2MQ8wDQYDVQQIDAZIZXNzZW4xEDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkM
# D0JhaG5ob2ZzcGxhdHogMTEZMBcGA1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcG
# A1UEAwwQS3JlYXRpdlNpZ24gR21iSDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAK8jDmF0TO09qJndJ9eGFqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8k
# E5sL4/dMhuTOp+SMt0tI/SON6BY3208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD
# 8AIyrTH9b27wDNX4rC914Ka4EBI8sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSa
# zE9yyRTuffidmtHV49DHPr+ql4jiNJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUuk
# pzdCaA0UzygGUdDfgy0htSSp8MR9Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnk
# q0bXUIC6H0Zolnfl4fanvVYyvD88qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaA
# FCmRYP+KTfrr+aZquM/55ku9Sc4SMB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kG
# HucShjAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggr
# BgEFBQcDAzARBglghkgBhvhCAQEEBAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIx
# AQIBAwIwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9D
# UFMwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09N
# T0RPUlNBQ29kZVNpZ25pbmdDQS5jcmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUF
# BzAChjJodHRwOi8vY3J0LmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmlu
# Z0NBLmNydDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMG
# A1UdEQQcMBqBGGhvY2h3YWxkQGtyZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsF
# AAOCAQEASSZkxKo3EyEk/qW0ZCs7CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqd
# wFkuQYJxzknqm2JMvwIK6BtfWc64WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPje
# n60W+L66oNEXiBuIsOcJ9e7tH6Vn9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4
# LDHEpYpLRVQnuxoc38mmd+NfjcD2/o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ
# 3trqmH6e3Cpm8Ut5UkoSONZdkYWwrzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnr
# HRReihZ0zwN+HkXO1XEnd3hm+08jLzCCBdgwggPAoAMCAQICEEyq+crbY2/gH/dO
# 2FsDhp0wDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJH
# cmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNP
# TU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRp
# b24gQXV0aG9yaXR5MB4XDTEwMDExOTAwMDAwMFoXDTM4MDExODIzNTk1OVowgYUx
# CzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
# BAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQD
# EyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAkehUktIKVrGsDSTdxc9EZ3SZKzejfSNwAHG8
# U9/E+ioSj0t/EFa9n3Byt2F/yUsPF6c947AEYe7/EZfH9IY+Cvo+XPmT5jR62RRr
# 55yzhaCCenavcZDX7P0N+pxs+t+wgvQUfvm+xKYvT3+Zf7X8Z0NyvQwA1onrayzT
# 7Y+YHBSrfuXjbvzYqOSSJNpDa2K4Vf3qwbxstovzDo2a5JtsaZn4eEgwRdWt4Q08
# RWD8MpZRJ7xnw8outmvqRsfHIKCxH2XeSAi6pE6p8oNGN4Tr6MyBSENnTnIqm1y9
# TBsoilwie7SrmNnu4FGDwwlGTm0+mfqVF9p8M1dBPI1R7Qu2XK8sYxrfV8g/vOld
# xJuvRZnio1oktLqpVj3Pb6r/SVi+8Kj/9Lit6Tf7urj0Czr56ENCHonYhMsT8dm7
# 4YlguIwoVqwUHZwK53Hrzw7dPamWoUi9PPevtQ0iTMARgexWO/bTouJbt7IEIlKV
# gJNp6I5MZfGRAy1wdALqi2cVKWlSArvX31BqVUa/oKMoYX9w0MOiqiwhqkfOKJwG
# RXa/ghgntNWutMtQ5mv0TIZxMOmm3xaG4Nj/QN370EKIf6MzOi5cHkERgWPOGHFr
# K+ymircxXDpqR+DDeVnWIBqv8mqYqnK8V0rSS527EPywTEHl7R09XiidnMy/s1Ha
# p0flhFMCAwEAAaNCMEAwHQYDVR0OBBYEFLuvfgI9+qbxPISOre44mOzZMjLUMA4G
# A1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MA0GCSqGSIb3DQEBDAUAA4IC
# AQAK8dVGhLeuUbtssk1BFACTTJzL5cBUz6AljgL5/bCiDfUgmDwTLaxWorDWfhGS
# 6S66ni6acrG9GURsYTWimrQWEmlajOHXPqQa6C8D9K5hHRAbKqSLesX+BabhwNbI
# /p6ujyu6PZn42HMJWEZuppz01yfTldo3g3Ic03PgokeZAzhd1Ul5ACkcx+ybIBwH
# JGlXeLI5/DqEoLWcfI2/LpNiJ7c52hcYrr08CWj/hJs81dYLA+NXnhT30etPyL2H
# I7e2SUN5hVy665ILocboaKhMFrEamQroUyySu6EJGHUMZah7yyO3GsIohcMb/9Ar
# Yu+kewmRmGeMFAHNaAZqYyF1A4CIim6BxoXyqaQt5/SlJBBHg8rN9I15WLEGm+ca
# KtmdAdeUfe0DSsrw2+ipAT71VpnJHo5JPbvlCbngT0mSPRaCQMzMWcbmOu0SLmk8
# bJWx/aode3+Gvh4OMkb7+xOPdX9Mi0tGY/4ANEBwwcO5od2mcOIEs0G86YCR6mSc
# euEiA6mcbm8OZU9sh4de826g+XWlm0DoU7InnUq5wHchjf+H8t68jO8X37dJC9Hy
# bjALGg5Odu0R/PXpVrJ9v8dtCpOMpdDAth2+Ok6UotdubAvCinz6IPPE5OXNDajL
# kZKxfIXstRRpZg6C583OyC2mUX8hwTVThQZKXZ+tuxtfdDCCBeAwggPIoAMCAQIC
# EC58h8wOk0pS/pT9HLfNNK8wDQYJKoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdC
# MRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQx
# GjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNB
# IENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEzMDUwOTAwMDAwMFoXDTI4MDUw
# ODIzNTk1OVowfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hl
# c3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0
# ZWQxIzAhBgNVBAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5nIENBMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAppiQY3eRNH+K0d3pZzER68we/TEds7li
# Vz+TvFvjnx4kMhEna7xRkafPnp4ls1+BqBgPHR4gMA77YXuGCbPj/aJonRwsnb9y
# 4+R1oOU1I47Jiu4aDGTH2EKhe7VSA0s6sI4jS0tj4CKUN3vVeZAKFBhRLOb+wRLw
# HD9hYQqMotz2wzCqzSgYdUjBeVoIzbuMVYz31HaQOjNGUHOYXPSFSmsPgN1e1r39
# qS/AJfX5eNeNXxDCRFU8kDwxRstwrgepCuOvwQFvkBoj4l8428YIXUezg0HwLgA3
# FLkSqnmSUs2HD3vYYimkfjC9G7WMcrRI8uPoIfleTGJ5iwIGn3/VCwIDAQABo4IB
# UTCCAU0wHwYDVR0jBBgwFoAUu69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYE
# FCmRYP+KTfrr+aZquM/55ku9Sc4SMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8E
# CDAGAQH/AgEAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEGA1UdIAQKMAgwBgYEVR0g
# ADBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01P
# RE9SU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMw
# OwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFk
# ZFRydXN0Q0EuY3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5j
# b20wDQYJKoZIhvcNAQEMBQADggIBAAI/AjnD7vjKO4neDG1NsfFOkk+vwjgsBMzF
# YxGrCWOvq6LXAj/MbxnDPdYaCJT/JdipiKcrEBrgm7EHIhpRHDrU4ekJv+YkdK8e
# exYxbiPvVFEtUgLidQgFTPG3UeFRAMaH9mzuEER2V2rx31hrIapJ1Hw3Tr3/tnVU
# QBg2V2cRzU8C5P7z2vx1F9vst/dlCSNJH0NXg+p+IHdhyE3yu2VNqPeFRQevemkn
# ZZApQIvfezpROYyoH3B5rW1CIKLPDGwDjEzNcweU51qOOgS6oqF8H8tjOhWn1BUb
# p1JHMqn0v2RH0aofU04yMHPCb7d4gp1c/0a7ayIdiAv4G6o0pvyM9d1/ZYyMMVcx
# 0DbsR6HPy4uo7xwYWMUGd8pLm1GvTAhKeo/io1Lijo7MJuSy2OU4wqjtxoGcNWup
# WGFKCpe0S0K2VZ2+medwbVn4bSoMfxlgXwyaiGwwrFIJkBYb/yud29AgyonqKH4y
# jhnfe0gzHtdl+K7J+IMUk3Z9ZNCOzr41ff9yMU2fnr0ebC+ojwwGUPuMJ7N2yfTm
# 18M04oyHIYZh/r9VdOEhdwMKaGy75Mmp5s9ZJet87EUOeWZo6CLNuO+YhU2WETwJ
# itB/vCgoE/tqylSNklzNwmWYBp7OSFvUtTeTRkF8B93P+kPvumdh/31J4LswfVyA
# 4+YWOUunMYICKzCCAicCAQEwgZEwfTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdy
# ZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
# T0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5n
# IENBAhAW1PdTHZsYJ0/yJnM0UYBcMAkGBSsOAwIaBQCgcDAQBgorBgEEAYI3AgEM
# MQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUKxoABqNhZcNBKUh0UqS9mUOs
# 3RUwDQYJKoZIhvcNAQEBBQAEggEAGqkx/wX316yy5xKxG+v99M44XGHaxa4hP0K3
# CfwxnVvX0dsrWQGugctobmopukRyNzDp0BDzp4jzy1IYZDonc6OeIm4HAqYa+WkK
# anE9HaXstPmUdRFE55It7eMuWrZ5fGUuWZJ91W7iew9QgJwTxYA57MGFm6WafZso
# sxHlGiNJL2u+ISOQnTjCefabwvoznZFpvqygTo7Qn5E/Dvi3fULXzcS+/Ko2H/2k
# gvp2LHLx1XAgrYEjfiaJxYgarDLUgaKyl+FwuGMuCfj8KlgoYFlqMqg3g7/OQNFe
# Vn6lE2TjJ8Jqm4cQgZBU/GgsF5LPIJKWDjJQH6Q0tv4EYX5ugA==
# SIG # End signature block
