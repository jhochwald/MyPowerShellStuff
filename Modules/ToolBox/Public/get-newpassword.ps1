#region License

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

	Redistribution and use in source and binary forms, with or without modification,
	are permitted provided that the following conditions are met:

	1. Redistributions of source code must retain the above copyright notice, this list of
	   conditions and the following disclaimer.

	2. Redistributions in binary form must reproduce the above copyright notice,
	   this list of conditions and the following disclaimer in the documentation and/or
	   other materials provided with the distribution.

	3. Neither the name of the copyright holder nor the names of its contributors may
	   be used to endorse or promote products derived from this software without
	   specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
	IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
	AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
	SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
	THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
	OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.

	By using the Software, you agree to the License, Terms and Conditions above!
#>

#endregion License

function global:Get-NewPassword {
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

	BEGIN {
		#
	}

	PROCESS {
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
		Write-Output $NewPassword
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}