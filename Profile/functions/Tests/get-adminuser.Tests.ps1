<#
	.SYNOPSIS
		Pester Unit Test Script

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
$FunctionName = "Get-AdminUser.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "Are-We-Admin" {
	Context "Must pass" {
		It "Executed as Admin" {
			(get-adminuser) | Should Be "True"
		}

		It "Has examples in the comment based help" {
			$help = (get-help get-adminuser -Examples)
			$help.examples | Should Not BeNullOrEmpty
		}
	}
}
