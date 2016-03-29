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
		"Copyright": "(c) 2012-2016 by Joerg Hochwald & Associates. All rights reserved."
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

	#################################################
	# modified by     : Joerg Hochwald
	# last modified   : 2016-03-29
	#################################################
#>

#endregion License

function Global:Get-TranslatedString {
<#
	.SYNOPSIS
		Translate mostly Russian characters back to roman

	.DESCRIPTION
		Translate mostly Russian characters back to roman
		It also replaces spaces and some other special characters

	.PARAMETER String
		String that should be translated

	.EXAMPLE
		Get-TranslatedString -String 'Привет мир'
		Privet_mir

		Translates 'Привет мир' to "Privet_mir".
		Keep in mind: It just translates the characters!
		'Привет мир' means "Hello World"

	.NOTES
		Keep in mind: It just translates the characters!

	.LINK
		Get-ADCleanNameString
		Get-TranslatedStringSimple
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([System.String])]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   HelpMessage = 'String that should be translated')]
		[ValidateNotNullOrEmpty()]
		[Alias('inString')]
		[System.String]$String
	)

	BEGIN {
		$TraslationTable = @{
			[char]' ' = "_"
			[char]'-' = "_"
			[char]'(' = "_"
			[char]')' = "_"
			[char]'а' = "a"
			[char]'А' = "A"
			[char]'б' = "b"
			[char]'Б' = "B"
			[char]'В' = "V"
			[char]'г' = "g"
			[char]'Г' = "G"
			[char]'д' = "d"
			[char]'Д' = "D"
			[char]'е' = "e"
			[char]'Е' = "E"
			[char]'ё' = "yo"
			[char]'Ё' = "Yo"
			[char]'ж' = "zh"
			[char]'Ж' = "Zh"
			[char]'з' = "z"
			[char]'З' = "Z"
			[char]'и' = "i"
			[char]'И' = "I"
			[char]'й' = "y"
			[char]'Й' = "Y"
			[char]'к' = "k"
			[char]'К' = "K"
			[char]'л' = "l"
			[char]'Л' = "L"
			[char]'м' = "m"
			[char]'М' = "M"
			[char]'н' = "n"
			[char]'Н' = "N"
			[char]'о' = "o"
			[char]'О' = "O"
			[char]'п' = "p"
			[char]'П' = "P"
			[char]'р' = "r"
			[char]'Р' = "R"
			[char]'с' = "s"
			[char]'С' = "S"
			[char]'т' = "t"
			[char]'Т' = "T"
			[char]'у' = "u"
			[char]'У' = "U"
			[char]'ф' = "f"
			[char]'Ф' = "F"
			[char]'х' = "h"
			[char]'Х' = "H"
			[char]'ц' = "c"
			[char]'Ц' = "C"
			[char]'ч' = "ch"
			[char]'Ч' = "Ch"
			[char]'ш' = "sh"
			[char]'Ш' = "Sh"
			[char]'щ' = "sch"
			[char]'Щ' = "Sch"
			[char]'ъ' = ""
			[char]'Ъ' = ""
			[char]'ы' = "y"
			[char]'Ы' = "Y"
			[char]'ь' = ""
			[char]'Ь' = ""
			[char]'э' = "e"
			[char]'Э' = "E"
			[char]'ю' = "yu"
			[char]'Ю' = "Yu"
			[char]'я' = "ya"
			[char]'Я' = "Ya"
		}

		$TranslatedString = ""
	}

	PROCESS {
		foreach ($CHR in $inCHR = $String.ToCharArray()) {
			if ($TraslationTable[$CHR] -cne $Null) {
				$TranslatedString += $TraslationTable[$CHR]
			} else {
				$TranslatedString += $CHR
			}
		}
	}

	END {
		Write-Output $TranslatedString
	}
}

function Global:Get-TranslatedStringSimple {
<#
	.SYNOPSIS
		Translate mostly Russian characters back to roman

	.DESCRIPTION
		Translate mostly Russian characters back to roman

	.PARAMETER String
		String that should be translated

	.EXAMPLE
		Get-TranslatedStringSimple -String 'Привет мир'
		Privet mir

		Translates 'Привет мир' to "Privet mir".
		Keep in mind: It just translates the characters!
		'Привет мир' means "Hello World"

	.NOTES
		Keep in mind: It just translates the characters!

	.LINK
		Get-ADCleanNameString
		Get-TranslatedString
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([System.String])]
	param
	(
		[Parameter(ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'String that should be translated')]
		[Alias('inString')]
		[System.String]$String
	)

	BEGIN {
		$TraslationTable = @{
			[char]'а' = "a"
			[char]'А' = "A"
			[char]'б' = "b"
			[char]'Б' = "B"
			[char]'В' = "V"
			[char]'г' = "g"
			[char]'Г' = "G"
			[char]'д' = "d"
			[char]'Д' = "D"
			[char]'е' = "e"
			[char]'Е' = "E"
			[char]'ё' = "yo"
			[char]'Ё' = "Yo"
			[char]'ж' = "zh"
			[char]'Ж' = "Zh"
			[char]'з' = "z"
			[char]'З' = "Z"
			[char]'и' = "i"
			[char]'И' = "I"
			[char]'й' = "y"
			[char]'Й' = "Y"
			[char]'к' = "k"
			[char]'К' = "K"
			[char]'л' = "l"
			[char]'Л' = "L"
			[char]'м' = "m"
			[char]'М' = "M"
			[char]'н' = "n"
			[char]'Н' = "N"
			[char]'о' = "o"
			[char]'О' = "O"
			[char]'п' = "p"
			[char]'П' = "P"
			[char]'р' = "r"
			[char]'Р' = "R"
			[char]'с' = "s"
			[char]'С' = "S"
			[char]'т' = "t"
			[char]'Т' = "T"
			[char]'у' = "u"
			[char]'У' = "U"
			[char]'ф' = "f"
			[char]'Ф' = "F"
			[char]'х' = "h"
			[char]'Х' = "H"
			[char]'ц' = "c"
			[char]'Ц' = "C"
			[char]'ч' = "ch"
			[char]'Ч' = "Ch"
			[char]'ш' = "sh"
			[char]'Ш' = "Sh"
			[char]'щ' = "sch"
			[char]'Щ' = "Sch"
			[char]'ъ' = ""
			[char]'Ъ' = ""
			[char]'ы' = "y"
			[char]'Ы' = "Y"
			[char]'ь' = ""
			[char]'Ь' = ""
			[char]'э' = "e"
			[char]'Э' = "E"
			[char]'ю' = "yu"
			[char]'Ю' = "Yu"
			[char]'я' = "ya"
			[char]'Я' = "Ya"
		}

		$TranslatedString = ""
	}

	PROCESS {
		foreach ($CHR in $inCHR = $String.ToCharArray()) {
			if ($TraslationTable[$CHR] -cne $Null) {
				$TranslatedString += $TraslationTable[$CHR]
			} else {
				$TranslatedString += $CHR
			}
		}
	}

	END {
		Write-Output $TranslatedString
	}
}
