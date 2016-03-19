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
$FunctionName = "Test-TCPPort.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "Test-TCPPort" {
	Context "Must pass" {
		It "Port is open" {
			(Test-TCPPort -target '127.0.0.1' -Port '445') | Should Be $true
		}

		It "Has examples in the comment based help" {
			$help = (get-help Test-TCPPort -Examples)
			$help.examples | Should Not BeNullOrEmpty
		}
	}
	Context "Must Fail" {
		It "Port is not open" {
			(Test-TCPPort -target '127.0.0.1' -Port '3306') | Should Be $false
		}
	}
}
