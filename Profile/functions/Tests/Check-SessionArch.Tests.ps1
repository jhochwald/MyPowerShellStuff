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
$FunctionName = "Check-SessionArch.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "Check-SessionArch" {
	Context "Must pass" {
		It "x64" {
			(Check-SessionArch) | Should MatchExactly "x64"
		}

		It "Has examples in the comment based help" {
				$help = (get-help Check-SessionArch -Examples)
				$help.examples | Should Not BeNullOrEmpty
			}
	}
	Context "Must fail" {
		It "Not x64" {
			(Check-SessionArch) | Should not Be "x86"
		}
		It "Not x64" {
			(Check-SessionArch) | Should not Be "Unknown Type"
		}
	}
}
