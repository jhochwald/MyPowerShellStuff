<#
	This functions are based on the work of Robert Nees
	Licensed under the Apache License, Version 2.0 (the "License");

	More Infos: http://sushihangover.blogspot.com

	I just adopted them and tweak them a bit to fit in my code
#>

function Global:Compress-GZip {
<#
	.SYNOPSIS
		GZip Compress (.gz)

	.DESCRIPTION
		A buffered GZip (.gz) Compress function that support pipelined input

	.PARAMETER FullName
		Input File

	.PARAMETER GZipPath
		Name of the GZ Archive

	.PARAMETER Force
		Enforce it?

	.Example
		Get-ChildItem .\NotCompressFile.xml | Compress-GZip -Verbose -WhatIf

	.Example
		Compress-GZip -FullName NotCompressFile.xml -NewName Compressed.xml.funkyextension

	.NOTES
		Copyright 2013 Robert Nees
		Licensed under the Apache License, Version 2.0 (the "License");

	.LINK
		http://sushihangover.blogspot.com
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Input File')]
		[Alias('PSPath')]
		[System.String]$FullName,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Name of the GZ Archive')]
		[Alias('NewName')]
		[System.String]$GZipPath,
		[Parameter(Mandatory = $false,
				   HelpMessage = 'Enforce it?')]
		[switch]$Force
	)

	PROCESS {
		$_BufferSize = 1024 * 8
		if (Test-Path -Path $FullName -PathType Leaf) {
			# Be Verbose
			Write-Verbose "Reading from: $FullName"

			if ($GZipPath.Length -eq 0) {
				$tmpPath = (Get-ChildItem -Path $FullName)
				$GZipPath = (Join-Path -Path ($tmpPath.DirectoryName) -ChildPath ($tmpPath.Name + '.gz'))
			}

			if (Test-Path -Path $GZipPath -PathType Leaf -IsValid) {
				Write-Verbose "Compressing to: $GZipPath"
			} else {
				Write-Error -Message "$FullName is not a valid path/file"
				return
			}
		} else {
			Write-Error -Message "$GZipPath does not exist"
			return
		}

		if (Test-Path -Path $GZipPath -PathType Leaf) {
			If ($Force.IsPresent) {
				if ($pscmdlet.ShouldProcess("Overwrite Existing File @ $GZipPath")) {
					Set-FileTime $GZipPath
				}
			}
		} else {
			if ($pscmdlet.ShouldProcess("Create new Compressed File @ $GZipPath")) {
				Set-FileTime $GZipPath
			}
		}

		if ($pscmdlet.ShouldProcess("Creating Compress File @ $GZipPath")) {
			# Be Verbose
			Write-Verbose "Opening streams and file to save compressed version to..."

			$input = (New-Object System.IO.FileStream (Get-ChildItem -path $FullName).FullName, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read))
			$output = (New-Object System.IO.FileStream (Get-ChildItem -path $GZipPath).FullName, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None))
			$gzipStream = (New-Object System.IO.Compression.GzipStream $output, ([IO.Compression.CompressionMode]::Compress))

			try {
				$buffer = (New-Object byte[]($_BufferSize))
				while ($true) {
					$read = ($input.Read($buffer, 0, ($_BufferSize)))
					if ($read -le 0) {
						break;
					}
					$gzipStream.Write($buffer, 0, $read)
				}
			} finally {
				# Be Verbose
				Write-Verbose "Closing streams and newly compressed file"

				$gzipStream.Close();
				$output.Close();
				$input.Close();
			}
		}
	}
}

function Global:Expand-GZip {
<#
	.SYNOPSIS
		GZip Decompress (.gz)

	.DESCRIPTION
		A buffered GZip (.gz) Decompress function that support pipelined input

	.PARAMETER FullName
		The input file

	.PARAMETER GZipPath
		Name of the GZip Archive

	.PARAMETER Force
		Enforce it?

	.Example
		Get-ChildItem .\RegionName.cs.gz | Expand-GZip -Verbose -WhatIf

	.Example
		Expand-GZip -FullName CompressFile.xml.gz -NewName NotCompressed.xml

	.NOTES
		Copyright 2013 Robert Nees
		Licensed under the Apache License, Version 2.0 (the "License");

	.LINK
		http://sushihangover.blogspot.com
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'The input file')]
		[Alias('PSPath')]
		[System.String]$FullName,
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $false,
				   ValueFromPipelineByPropertyName = $true,
				   HelpMessage = 'Name of the GZip Archive')]
		[Alias('NewName')]
		[System.String]$GZipPath = $null,
		[Parameter(Mandatory = $false,
				   HelpMessage = 'Enforce it?')]
		[switch]$Force
	)

	PROCESS {
		if (Test-Path -Path $FullName -PathType Leaf) {
			# Be Verbose
			Write-Verbose "Reading from: $FullName"

			if ($GZipPath.Length -eq 0) {
				$tmpPath = (Get-ChildItem -Path $FullName)
				$GZipPath = (Join-Path -Path ($tmpPath.DirectoryName) -ChildPath ($tmpPath.BaseName))
			}

			if (Test-Path -Path $GZipPath -PathType Leaf -IsValid) {
				Write-Verbose "Decompressing to: $GZipPath"
			} else {
				Write-Error -Message "$GZipPath is not a valid path/file"
				return
			}
		} else {
			Write-Error -Message "$FullName does not exist"
			return
		}
		if (Test-Path -Path $GZipPath -PathType Leaf) {
			If ($Force.IsPresent) {
				if ($pscmdlet.ShouldProcess("Overwrite Existing File @ $GZipPath")) {
					Set-FileTime $GZipPath
				}
			}
		} else {
			if ($pscmdlet.ShouldProcess("Create new decompressed File @ $GZipPath")) {
				Set-FileTime $GZipPath
			}
		}
		if ($pscmdlet.ShouldProcess("Creating Decompressed File @ $GZipPath")) {
			# Be Verbose
			Write-Verbose "Opening streams and file to save compressed version to..."

			$input = (New-Object System.IO.FileStream (Get-ChildItem -path $FullName).FullName, ([IO.FileMode]::Open), ([IO.FileAccess]::Read), ([IO.FileShare]::Read))
			$output = (New-Object System.IO.FileStream (Get-ChildItem -path $GZipPath).FullName, ([IO.FileMode]::Create), ([IO.FileAccess]::Write), ([IO.FileShare]::None))
			$gzipStream = (New-Object System.IO.Compression.GzipStream $input, ([IO.Compression.CompressionMode]::Decompress))

			try {
				$buffer = (New-Object byte[](1024);)
				while ($true) {
					$read = ($gzipStream.Read($buffer, 0, 1024))
					if ($read -le 0) {
						break;
					}
					$output.Write($buffer, 0, $read)
				}
			} finally {
				# Be Verbose
				Write-Verbose "Closing streams and newly decompressed file"

				$gzipStream.Close();
				$output.Close();
				$input.Close();
			}
		}
	}
}
