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
		last modified   : 2016-03-01

	.LINK
		Pester https://github.com/pester/Pester
#>

# Build some Test Variables
$MyRunPath = (Split-Path -Parent $MyInvocation.MyCommand.Path)
$FunctionDir = $MyRunPath + "\..\"
$FunctionName = "get-hash.ps1"
$FunctionCall = $FunctionDir + $FunctionName

# Load Function
. $FunctionCall

# What to test
$TestFile = $MyRunPath + "\get-hash.txt"

<#

Describe "get-hash" {
	Context "Must pass" {
		It "Match" {
			(get-hash -File $TestFile -Hash 'MD5') | Should Be "4706C9D7FE56FEDE7F9FF91CBAEA05ED"
		}
		It "Match" {
			(get-hash -File $TestFile -Hash 'RIPEMD160') | Should Be "E3DFC00413657FB88698773F6F769AB710416337"
		}
		It "Match" {
			(get-hash -File $TestFile -Hash 'SHA1') | Should Be "062A1E0C877AEAFC4774BA4D2AFC6C51E05F2FF8"
		}
		It "Match" {
			(get-hash -File $TestFile -Hash 'SHA256') | Should Be "1EC15CF6C04D8D72721C5E7E59641CCB777916F41CC95BA34816397096433389"
		}
		It "Match" {
			(get-hash -File $TestFile -Hash 'SHA384') | Should Be "FCFE2075336A376EB11989EF2FABF70BAC435AA5260C5535A93F9F595559F2E0509F952094EE20A0DC7D162D64C00DAB"
		}
		It "Match" {
			(get-hash -File $TestFile -Hash 'SHA512') | Should Be "0DFC5038F8ACC6C63CF23D4EBC8CC504AD18BD9A0EBF8111504ED3C9D58D3AE82D70B40917D5687BD88918F72B65D3F4E55B7715F56FBE5C2DC99C372B8E5B1A"
		}
	}
	Context "Must fail" {
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'MACTripleDES') | Should not Be "C06750D6CEFA11AFCD1B26C3BFA23BFA"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'MD5') | Should not Be "6932B77B43B6ED0A"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'RIPEMD160') | Should not Be "6932B77B43B6ED0A"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'SHA1') | Should not Be "6932B77B43B6ED0A"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'SHA256') | Should not Be "8E368C84B798FA4E9E7325BE9787311EECB88560"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'SHA384') | Should not Be "8E368C84B798FA4E9E7325BE9787311EECB88560"
		}
		It "Not Match" {
			(get-hash -File $TestFile -Hash 'SHA512') | Should not Be "8E368C84B798FA4E9E7325BE9787311EECB88560"
		}
	}
}

#>
