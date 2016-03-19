<#
	.SYNOPSIS
		Pester Unit Test

	.DESCRIPTION
		Pester is a BDD based test runner for PowerShell.

	.EXAMPLE
		PS C:\> Invoke-Pester

	.NOTES
		PESTER PowerShell Module must be installed!

		modified by     : Joerg Hochwald
		last modified   : 2016-03-10

	.LINK
		Pester https://github.com/pester/Pester
#>

# Build some Test Variables
$MyRunPath = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$FunctionDir = $MyRunPath + "\..\"
$FunctionName = "Get-RelativePath.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "Get-RelativePath" {
	Context "Must pass" {
		It "Correct" {
			(Get-RelativePath -Folder 'C:\dev' -FilePath 'C:\scripts\') | Should Be '..\scripts\'
		}

		It "Has examples in the comment based help" {
			$help = (get-help Get-RelativePath -Examples)
			$help.examples | Should Not BeNullOrEmpty
		}
	}
	Context "Must Fail" {
		It "Not correct" {
			(Get-RelativePath -Folder 'C:\dev' -FilePath 'C:\scripts\PowerShell') | Should not Be '\scripts\'
		}
	}
}
