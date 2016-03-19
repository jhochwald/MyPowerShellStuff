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
$FunctionName = "EscapeStringTools.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "ConvertFrom-EscapedString" {
	Context "Must pass" {
		It "Correct" {
			(ConvertFrom-EscapedString -String "Hello%20World") | Should Be 'Hello World'
		}

		It "Has examples in the comment based help" {
			$help = (get-help ConvertFrom-EscapedString -Examples)
			$help.examples | Should Not BeNullOrEmpty
		}
	}
	Context "Must Fail" {
		It "Not correct" {
			(ConvertFrom-EscapedString -String "Hello%20World") | Should not Be 'Hello%20World'
		}
	}
}
