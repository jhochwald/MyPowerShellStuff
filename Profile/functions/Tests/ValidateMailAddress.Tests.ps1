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
$FunctionName = "Approve-MailAddress.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

Describe "Approve-MailAddress" {
	Context "Must pass" {
		It "Valid address" {
			(Approve-MailAddress -Email:"noreply@bewoelkt.net") | Should Be "True"
		}

		It "Has examples in the comment based help" {
			$help = (get-help Approve-MailAddress -Examples)
			$help.examples | Should Not BeNullOrEmpty
		}
	}
	Context "Must fail" {
		It "With BLANK" {
			(Approve-MailAddress -Email:"no reply@bewoelkt.net") | Should not Be "True"
		}
		It "Missing AT" {
			(Approve-MailAddress -Email:"noreplybewoelkt.net") | Should not Be "True"
		}
		It "Missing TLD" {
			(Approve-MailAddress -Email:"noreply@bewoelkt") | Should not Be "True"
		}
		It "German Umlaut" {
			(Approve-MailAddress -Email:"Jörg.Hochwald@gmail.com") | Should not Be "True"
		}
	}
}
