#region Info

<#
	#################################################
	# modified by     : Joerg Hochwald
	# last modified   : 2016-04-21
	#################################################

	Support: https://github.com/jhochwald/NETX/issues
#>

#endregion Info

#region License

<#
	Copyright (c) 2012-2016, NET-Experts <http:/www.net-experts.net>.
	All rights reserved.

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

function global:Get-Quote {
<#
	.SYNOPSIS
		Get a random Quote from an Array

	.DESCRIPTION
		Get a random Quote from an Array of Quotes I like.
		I like to put Quotes in slides and presentations, here is a collection of whose I used...


	.EXAMPLE
		PS C:\> Get-Quote
		*******************************************************************
		*  The only real mistake is the one from which we learn nothing.  *
		*                                                     Henry Ford  *
		*******************************************************************

		Description
		-----------
		Get a random Quote from an Array

	.NOTES
		Based on an idea of Jeff Hicks

		I just implemented this because it was fun to do so ;-)

	.LINK
		NET-Experts http://www.net-experts.net

	.LINK
		Support https://github.com/jhochwald/NETX/issues
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([System.String])]
	param ()

	BEGIN {
		# The quote should include the author separated by " - ".
		$texts = @(
		"It was a mistake to think that GUIs ever would, could, or even should, eliminate CLIs. - Jeffrey Snover",
		"Leader who don't Listen will eventually be surrounded by people who have nothing to say. - @AndyStanley",
		"Good is the enemy of great. - Sir Jonathan Ive",
		"There are 9 rejected ideas for every idea that works. - Sir Jonathan Ive"
		"People's interest is in the product, not in its authorship. - Sir Jonathan Ive",
		"I think it's really important to design things with a kind of personality. - Marc Newson",
		"Intelligence is the ability to adapt to change. - Stephen Hawking",
		"We are all now connected by the Internet, like neurons in a giant brain. - Stephen Hawking",
		"The best ideas start as conversations. - Sir Jonathan Ive",
		"If something is not good enough, stop doing it. - Sir Jonathan Ive",
		"There's no learning without trying lots of ideas and failing lots of times. - Sir Jonathan Ive",
		"Any product that needs a manual to work is broken. - Elon Musk",
		"Business has only two functions: marketing and innovation. - Milan Kundera",
		"Just because something doesn't do what you planned it to do doesn't mean it's useless. - Thomas A. Edison",
		"Great companies are built on great products. - Elon Musk",
		"Test fast, fail fast, adjust fast. - Tom Peters",
		"Winning isn't everything, it's the only thing. - Vince Lombardi (Former NFL Coach)",
		"The only place success comes before work is in the dictionary. - Vince Lombardi (Former NFL Coach)",
		"The measure of who we are is what we do with what we have. - Vince Lombardi (Former NFL Coach)",
		"The greatest accomplishment is not in never falling, but in rising again after you fall. - Vince Lombardi (Former NFL Coach)"
		"Perfection is not attainable. But if we chase perfection, we can catch excellence. - Vince Lombardi (Former NFL Coach)",
		"Stay focused. Your start does not determine how you're going to finish. - Herm Edwards (Former NFL Coach)",
		"Nobody who ever gave his best regretted it. - George S. Halas (Former NFL Coach)",
		"Don't let the noise of others' opinions drown out your own inner voice. - Steve Jobs",
		"One way to remember who you are is to remember who your heroes are. - Walter Isaacson (Steve Jobs)",
		"Why join the navy if you can be a pirate? - Steve Jobs",
		"Innovation distinguishes between a leader and a follower. - Steve Jobs",
		"Sometimes life hits you in the head with a brick. Don't lose faith. - Steve Jobs",
		"Design is not just what it looks like and feels like. Design is how it works. - Steve Jobs",
		"We made the buttons on the screen look so good you'll want to lick them. - Steve Jobs",
		"Things don't have to change the world to be important. - Steve Jobs",
		"Your most unhappy customers are your greatest source of learning. - Bill Gates",
		"Software is a great combination between artistry and engineering. - Bill Gates",
		"Success is a lousy teacher. It seduces smart people into thinking they can't lose. - Bill Gates",
		"If you can't make it good, at least make it look good. - Bill Gates",
		"If you're not making mistakes, then you're not making decisions. - Catherine Cook (MeetMe Co-Founder)",
		"I have not failed. I've just found 10.000 ways that won't work. - Thomas Edison",
		"If you don't build your dream, someone will hire you to help build theirs. - Tony Gaskin (Motivational Speaker)",
		"Don't count the days, make the days count. - Muhammad Ali",
		"Everything you can imagine is real. - Pablo Picasso",
		"In three words I can sum up everything I've learned about life: it goes on. - Robert Frost"
		)

		# get random text
		Set-Variable -Name "text" -Value $(Get-Random $texts)
	}

	PROCESS {
		# split the text to an array on ' - '
		Set-Variable -Name "split" -Value $($text -split " - ")
		Set-Variable -Name "quote" -Value $($split[0].Trim())
		Set-Variable -Name "author" -Value $($split[1].Trim())

		# turn the quote into an array of characters
		Set-Variable -Name "arr" -Value $($quote.ToCharArray())

		$arr | ForEach-Object -Begin {
			# define an array of colors
			#$colors = "Red", "Green", "White", "Magenta"

			# insert a few blank lines
			write-host "`n"

			# insert top border
			write-host ("*" * $($quote.length + 6))

			# insert side border
			write-host "*  " -NoNewline
		} -process {

			# write each character in a different holiday color
			Write-Host "$_" -ForegroundColor White -NoNewline
		} -end {
			write-host "  *"

			# insert side border
			Write-Host "* " -NoNewline

			# write the author
			# Write-Host "- $author  *".padleft($quote.length + 4)
			Write-Host "$author  *".padleft($quote.length + 4)

			# insert bottom border
			write-Host ("*" * $($quote.length + 6))
			Write-Host "`n"
		}
	}

	END {
		# Cleanup
		Remove-Variable -Name "texts" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "text" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "split" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "quote" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "author" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
		Remove-Variable -Name "arr" -Force -Confirm:$false -ErrorAction:SilentlyContinue -WarningAction:SilentlyContinue
	}
}

<# MORE Stuff:
		"I'm not really in the excuse business. - Bill Parcells (Former NFL Coach)"
		"Remember, if you ever need a helping hand, it is at the end of your arm. - Audrey Hepburn",
		"When you talk, you are only repeating what you already know. But if you listen, you may learn something new. - Dalai Lama",
		"I can accept failure, but I can't accept not trying. - Michael Jordan",
		"If you don't drive your business, you will be driven out of business. - B. C. Forbes",
		"Good design is good business. - Thomas J. Watson",
		"The urge for good design is the same as the urge to go on living. - Harry Bertoia",
		"Fashion is architecture: it is a matter of proportions. - Coco Chanel",
		"Prophesy is a good line of business, but it is full of risks. - Mark Twain",
		"If a business does well, the stock eventually follows. - Warren Buffett",
		"As you grow in this business, you learn how to do more with less. - Morgan Freeman",
		"One thing is certain in business. You and everyone around you will make mistakes. - Richard Branson",
		"If you don't understand the details of your business you are going to fail. - Jeff Bezos",
		"A man should never neglect his family for business. - Walt Disney",
		"The business of business is relationships; the business of life is human connection. - Robin S. Sharma",
		"That's what show business is, sincere insincerity. - Benny Hill",
		"A friendship founded on business is better than a business founded on friendship. - John D. Rockefeller",
		"I rate enthusiasm even above professional skill. - Edward Appleton",
		"I don't think it's a good idea to plan to sell a company. - Elon Musk",
		"All the things I love is what my business is all about. - Martha Stewart",
		"I believe fundamental honesty is the keystone of business. - Harvey S. Firestone",
		"Business opportunities are like buses, there's always another one coming. - Richard Branson",
		"When times are bad is when the real entrepreneurs emerge. - Robert Kiyosaki",
		"We're all working together; that's the secret. - Sam Walton",
		"Coming together is a beginning; keeping together is progress; working together is success. - Henry Ford",
		"My best friend is the one who brings out the best in me. - Henry Ford",
		"Thinking is the hardest work there is, which is probably the reason why so few engage in it. - Henry Ford",
		"A business that makes nothing but money is a poor business. - Henry Ford",
		"Failure is simply an opportunity to begin again, this time more intelligently. - Henry Ford",
		"The only real mistake is the one from which we learn nothing. - Henry Ford",
		"Unthinking respect for authority is the greatest enemy of truth. - Albert Einstein",
		"If you can dream it, you can do it. - Walt Disney",
		"The difference between winning and losing is most often not quitting. - Walt Disney",
		"Screw it. Let's do it. - Richard Branson",
		"Don't worry about failure; you only have to be right once. - Drew Houston",
		"Ideas are easy. Implementation is hard - Guy Kawasaki",
		"Courage is grace under pressure. - Ernest Hemingway",
		"Sometimes you can't see yourself clearly until you see yourself through the eyes of others. - Ellen DeGeneres",
		"It does not matter how slowly you go, so long as you do not stop. - Confucius",
		"Someone is sitting in the shade today because someone planted a tree a long time ago. - Warren Buffett",
		"You only live once, but if you do it right, once is enough. - Mae West",
		"Failure is another steppingstone to greatness. - Oprah Winfrey",
		"In order to be irreplaceable one must always be different. - Coco Chanel",
		"You miss 100% of the shots you don't take. - Wayne Gretzky",
		"I believe every human has a finite number of heartbeats. I don't intend to waste any of mine. - Neil Armstrong",
		"If you don't stand for something you'll fall for anything. - Malcolm X",
		"The two most important days in your life are the day you are born and the day you find out why. - Mark Twain",
		"It often requires more courage to dare to do right than to fear to do wrong. - Abraham Lincoln",
		"If at first you don't succeed, try, try, try again. - William Edward Hickson",
		"If you are going through hell, keep going. - Sir Winston Churchill",
		"A dream doesn't become reality through magic; it takes sweat, determination and hard work. - Colin Powell",
		"Do one thing every day that scares you. - Eleanor Roosevelt",
		"The purpose of our lives is to be happy. - Dalai Lama",
		"Don't be afraid to give up the good to go for the great. - John D. Rockefeller",
		"Don't worry about failure; you only have to be right once. - Drew Houston",
		"Nothing great was ever achieved without enthusiasm. - Ralph Waldo Emerson",
		"All our dreams can come true if we have the courage to pursue them. - Walt Disney",
		"Be yourself. Everyone else is already taken. - Oscar Wilde",
		"Education is the most powerful weapon which you can use to change the world. - Nelson Mandela",
		"Your time is limited, so don't waste it living someone else's life. - Steve Jobs",
		"Success isn't about how much money you make. It's about the difference you make in people's lives. - Michelle Obama",
		"The best way of learning about anything is by doing. - Richard Branson",
		"Don't let the fear of striking out hold you back. - Babe Ruth",
		"Either write something worth reading or do something worth writing. - Benjamin Franklin",
		"If there is no struggle, there is no progress. - Frederick Douglass",
		"If something is important enough, even if the odds are against you, you should still do it. - Elon Musk",
		"Whether you think you can or you think you can't, you're right. - Henry Ford",
#>

# SIG # Begin signature block
# MIIfOgYJKoZIhvcNAQcCoIIfKzCCHycCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFHogCc1GhMLZ5GsMwTClU+dK
# 5JagghnLMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNTAyMDMwMDAw
# MDBaFw0yNjAzMDMwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCAMtwHjRygnJ08Kug9IYtZoU1+zETOA75+qrzE5ntz
# u0vxiNqQTnU3KDhjudcrD1SpVs53OZcwc82b2dkFRRyNpLgDXU/ZHC6Y4OmI5uzX
# BX5WKnv3FlujrY+XJRKEG7JcY0oK0u8QVEeChDVpKJwM5B8UFiT6ddx0cm5OyuNq
# Q6/PfTZI0b3pBpEsL6bIcf3PvdidIZj8r9veIoyvp/N3753co3BLRBrweIUe8qWM
# ObXciBw37a0U9QcLJr2+bQJesbiwWGyFOg32/1onDMXeU+dUPFZMyU5MMPbyXPsa
# jMKCvq1ZkfYbTVV7z1sB3P16028jXDJHmwHzwVEURoqbMIIFTDCCBDSgAwIBAgIQ
# FtT3Ux2bGCdP8iZzNFGAXDANBgkqhkiG9w0BAQsFADB9MQswCQYDVQQGEwJHQjEb
# MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRow
# GAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RPIFJTQSBD
# b2RlIFNpZ25pbmcgQ0EwHhcNMTUwNzE3MDAwMDAwWhcNMTgwNzE2MjM1OTU5WjCB
# kDELMAkGA1UEBhMCREUxDjAMBgNVBBEMBTM1NTc2MQ8wDQYDVQQIDAZIZXNzZW4x
# EDAOBgNVBAcMB0xpbWJ1cmcxGDAWBgNVBAkMD0JhaG5ob2ZzcGxhdHogMTEZMBcG
# A1UECgwQS3JlYXRpdlNpZ24gR21iSDEZMBcGA1UEAwwQS3JlYXRpdlNpZ24gR21i
# SDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAK8jDmF0TO09qJndJ9eG
# Fqra1lf14NDhM8wIT8cFcZ/AX2XzrE6zb/8kE5sL4/dMhuTOp+SMt0tI/SON6BY3
# 208v/NlDI7fozAqHfmvPhLX6p/TtDkmSH1sD8AIyrTH9b27wDNX4rC914Ka4EBI8
# sGtZwZOQkwQdlV6gCBmadar+7YkVhAbIIkSazE9yyRTuffidmtHV49DHPr+ql4ji
# NJ/K27ZFZbwM6kGBlDBBSgLUKvufMY+XPUukpzdCaA0UzygGUdDfgy0htSSp8MR9
# Rnq4WML0t/fT0IZvmrxCrh7NXkQXACk2xtnkq0bXUIC6H0Zolnfl4fanvVYyvD88
# qIECAwEAAaOCAbIwggGuMB8GA1UdIwQYMBaAFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MB0GA1UdDgQWBBSeVG4/9UvVjmv8STy4f7kGHucShjAOBgNVHQ8BAf8EBAMCB4Aw
# DAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDAzARBglghkgBhvhCAQEE
# BAMCBBAwRgYDVR0gBD8wPTA7BgwrBgEEAbIxAQIBAwIwKzApBggrBgEFBQcCARYd
# aHR0cHM6Ly9zZWN1cmUuY29tb2RvLm5ldC9DUFMwQwYDVR0fBDwwOjA4oDagNIYy
# aHR0cDovL2NybC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQ29kZVNpZ25pbmdDQS5j
# cmwwdAYIKwYBBQUHAQEEaDBmMD4GCCsGAQUFBzAChjJodHRwOi8vY3J0LmNvbW9k
# b2NhLmNvbS9DT01PRE9SU0FDb2RlU2lnbmluZ0NBLmNydDAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuY29tb2RvY2EuY29tMCMGA1UdEQQcMBqBGGhvY2h3YWxkQGty
# ZWF0aXZzaWduLm5ldDANBgkqhkiG9w0BAQsFAAOCAQEASSZkxKo3EyEk/qW0ZCs7
# CDDHKTx3UcqExigsaY0DRo9fbWgqWynItsqdwFkuQYJxzknqm2JMvwIK6BtfWc64
# WZhy0BtI3S3hxzYHxDjVDBLBy91kj/mddPjen60W+L66oNEXiBuIsOcJ9e7tH6Vn
# 9eFEUjuq5esoJM6FV+MIKv/jPFWMp5B6EtX4LDHEpYpLRVQnuxoc38mmd+NfjcD2
# /o/81bu6LmBFegHAaGDpThGf8Hk3NVy0GcpQ3trqmH6e3Cpm8Ut5UkoSONZdkYWw
# rzkmzFgJyoM2rnTMTh4ficxBQpB7Ikv4VEnrHRReihZ0zwN+HkXO1XEnd3hm+08j
# LzCCBdgwggPAoAMCAQICEEyq+crbY2/gH/dO2FsDhp0wDQYJKoZIhvcNAQEMBQAw
# gYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAO
# BgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSswKQYD
# VQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTEwMDEx
# OTAwMDAwMFoXDTM4MDExODIzNTk1OVowgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQI
# ExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoT
# EUNPTU9ETyBDQSBMaW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmlj
# YXRpb24gQXV0aG9yaXR5MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# kehUktIKVrGsDSTdxc9EZ3SZKzejfSNwAHG8U9/E+ioSj0t/EFa9n3Byt2F/yUsP
# F6c947AEYe7/EZfH9IY+Cvo+XPmT5jR62RRr55yzhaCCenavcZDX7P0N+pxs+t+w
# gvQUfvm+xKYvT3+Zf7X8Z0NyvQwA1onrayzT7Y+YHBSrfuXjbvzYqOSSJNpDa2K4
# Vf3qwbxstovzDo2a5JtsaZn4eEgwRdWt4Q08RWD8MpZRJ7xnw8outmvqRsfHIKCx
# H2XeSAi6pE6p8oNGN4Tr6MyBSENnTnIqm1y9TBsoilwie7SrmNnu4FGDwwlGTm0+
# mfqVF9p8M1dBPI1R7Qu2XK8sYxrfV8g/vOldxJuvRZnio1oktLqpVj3Pb6r/SVi+
# 8Kj/9Lit6Tf7urj0Czr56ENCHonYhMsT8dm74YlguIwoVqwUHZwK53Hrzw7dPamW
# oUi9PPevtQ0iTMARgexWO/bTouJbt7IEIlKVgJNp6I5MZfGRAy1wdALqi2cVKWlS
# ArvX31BqVUa/oKMoYX9w0MOiqiwhqkfOKJwGRXa/ghgntNWutMtQ5mv0TIZxMOmm
# 3xaG4Nj/QN370EKIf6MzOi5cHkERgWPOGHFrK+ymircxXDpqR+DDeVnWIBqv8mqY
# qnK8V0rSS527EPywTEHl7R09XiidnMy/s1Hap0flhFMCAwEAAaNCMEAwHQYDVR0O
# BBYEFLuvfgI9+qbxPISOre44mOzZMjLUMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMB
# Af8EBTADAQH/MA0GCSqGSIb3DQEBDAUAA4ICAQAK8dVGhLeuUbtssk1BFACTTJzL
# 5cBUz6AljgL5/bCiDfUgmDwTLaxWorDWfhGS6S66ni6acrG9GURsYTWimrQWEmla
# jOHXPqQa6C8D9K5hHRAbKqSLesX+BabhwNbI/p6ujyu6PZn42HMJWEZuppz01yfT
# ldo3g3Ic03PgokeZAzhd1Ul5ACkcx+ybIBwHJGlXeLI5/DqEoLWcfI2/LpNiJ7c5
# 2hcYrr08CWj/hJs81dYLA+NXnhT30etPyL2HI7e2SUN5hVy665ILocboaKhMFrEa
# mQroUyySu6EJGHUMZah7yyO3GsIohcMb/9ArYu+kewmRmGeMFAHNaAZqYyF1A4CI
# im6BxoXyqaQt5/SlJBBHg8rN9I15WLEGm+caKtmdAdeUfe0DSsrw2+ipAT71VpnJ
# Ho5JPbvlCbngT0mSPRaCQMzMWcbmOu0SLmk8bJWx/aode3+Gvh4OMkb7+xOPdX9M
# i0tGY/4ANEBwwcO5od2mcOIEs0G86YCR6mSceuEiA6mcbm8OZU9sh4de826g+XWl
# m0DoU7InnUq5wHchjf+H8t68jO8X37dJC9HybjALGg5Odu0R/PXpVrJ9v8dtCpOM
# pdDAth2+Ok6UotdubAvCinz6IPPE5OXNDajLkZKxfIXstRRpZg6C583OyC2mUX8h
# wTVThQZKXZ+tuxtfdDCCBeAwggPIoAMCAQICEC58h8wOk0pS/pT9HLfNNK8wDQYJ
# KoZIhvcNAQEMBQAwgYUxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1h
# bmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBM
# aW1pdGVkMSswKQYDVQQDEyJDT01PRE8gUlNBIENlcnRpZmljYXRpb24gQXV0aG9y
# aXR5MB4XDTEzMDUwOTAwMDAwMFoXDTI4MDUwODIzNTk1OVowfTELMAkGA1UEBhMC
# R0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9y
# ZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNVBAMTGkNPTU9ETyBS
# U0EgQ29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
# AQEAppiQY3eRNH+K0d3pZzER68we/TEds7liVz+TvFvjnx4kMhEna7xRkafPnp4l
# s1+BqBgPHR4gMA77YXuGCbPj/aJonRwsnb9y4+R1oOU1I47Jiu4aDGTH2EKhe7VS
# A0s6sI4jS0tj4CKUN3vVeZAKFBhRLOb+wRLwHD9hYQqMotz2wzCqzSgYdUjBeVoI
# zbuMVYz31HaQOjNGUHOYXPSFSmsPgN1e1r39qS/AJfX5eNeNXxDCRFU8kDwxRstw
# rgepCuOvwQFvkBoj4l8428YIXUezg0HwLgA3FLkSqnmSUs2HD3vYYimkfjC9G7WM
# crRI8uPoIfleTGJ5iwIGn3/VCwIDAQABo4IBUTCCAU0wHwYDVR0jBBgwFoAUu69+
# Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYEFCmRYP+KTfrr+aZquM/55ku9Sc4S
# MA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMBMGA1UdJQQMMAoG
# CCsGAQUFBwMDMBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjto
# dHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0
# aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9j
# cnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0EuY3J0MCQGCCsGAQUF
# BzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQADggIB
# AAI/AjnD7vjKO4neDG1NsfFOkk+vwjgsBMzFYxGrCWOvq6LXAj/MbxnDPdYaCJT/
# JdipiKcrEBrgm7EHIhpRHDrU4ekJv+YkdK8eexYxbiPvVFEtUgLidQgFTPG3UeFR
# AMaH9mzuEER2V2rx31hrIapJ1Hw3Tr3/tnVUQBg2V2cRzU8C5P7z2vx1F9vst/dl
# CSNJH0NXg+p+IHdhyE3yu2VNqPeFRQevemknZZApQIvfezpROYyoH3B5rW1CIKLP
# DGwDjEzNcweU51qOOgS6oqF8H8tjOhWn1BUbp1JHMqn0v2RH0aofU04yMHPCb7d4
# gp1c/0a7ayIdiAv4G6o0pvyM9d1/ZYyMMVcx0DbsR6HPy4uo7xwYWMUGd8pLm1Gv
# TAhKeo/io1Lijo7MJuSy2OU4wqjtxoGcNWupWGFKCpe0S0K2VZ2+medwbVn4bSoM
# fxlgXwyaiGwwrFIJkBYb/yud29AgyonqKH4yjhnfe0gzHtdl+K7J+IMUk3Z9ZNCO
# zr41ff9yMU2fnr0ebC+ojwwGUPuMJ7N2yfTm18M04oyHIYZh/r9VdOEhdwMKaGy7
# 5Mmp5s9ZJet87EUOeWZo6CLNuO+YhU2WETwJitB/vCgoE/tqylSNklzNwmWYBp7O
# SFvUtTeTRkF8B93P+kPvumdh/31J4LswfVyA4+YWOUunMYIE2TCCBNUCAQEwgZEw
# fTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
# A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxIzAhBgNV
# BAMTGkNPTU9ETyBSU0EgQ29kZSBTaWduaW5nIENBAhAW1PdTHZsYJ0/yJnM0UYBc
# MAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3
# DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEV
# MCMGCSqGSIb3DQEJBDEWBBSQSgDwuWtTMsHPQx0Df0+qvLR+uDANBgkqhkiG9w0B
# AQEFAASCAQBY0RAIYSiQpAQvQ52EXp9StlfVMlBejmgGPI+CUM7mfLpOeY9L/4I/
# PoGGGDowYZev8f3S09rJ3a3Sg0bs5GYPKFT1+SmBp4UnljahJkGNDuGao8u8CqvJ
# W8S8mc6doTozgsJSoo63PjeN8rW+sXj+RxSDNG/5KrsfHZ7qvUNdTPbQ4nS5sUGn
# ok8exzEreeJ1tMArlHGHfEtrDqjbNzGBoQ0/2SWTVhZlsvxU3IGIif0U4YoQf/0n
# JpYPapSbGYq2QdUFHq4x0Z+CVBNXM2PGBI1l/VZ/yMBO7zEMZzreinRwLwOEyKnz
# RKikzWJZzIBDU2o8OCKZncJUUYEnbfiZoYICojCCAp4GCSqGSIb3DQEJBjGCAo8w
# ggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
# c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh
# BqCB0z/YeuWCTMFrUglOAzAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDQyODEyNDI1M1owIwYJKoZIhvcN
# AQkEMRYEFERT1ZXknDZKucbY8oZvXONEClRQMIGdBgsqhkiG9w0BCRACDDGBjTCB
# ijCBhzCBhAQUs2MItNTN7U/PvWa5Vfrjv7EsKeYwbDBWpFQwUjELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gRzICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkq
# hkiG9w0BAQEFAASCAQBkrEjpRZycRJ+7oDbLodPeoFaHNDoHjmzI9ak9VVoFXWYO
# Qt4+mLfI4FW+uU8H6j5nQo3pYGHcBVZ+0gUQrd6zjOdF1+iQbpHPTmzTaHgWpl+U
# +2UAUDIDq/EaRR5nOLC5faeqR6quN4FvVuXb63qxXQwT4dQE+1mRZ954PDxiKuNS
# TOfYeviKRQpDot4kG1ssBbkOZqXBcCiTwMaFKYWuAVmzOfYvMKhOhwS3VkUddbAs
# NWJ25Ew8aU7hYs/KUHhO533cs7D3afu61mQtDt3DxXnmJiOVBuZ60SwKM6IZCE/m
# SJkTC0l2XNDjkN09op6EYfuHM/F9+/skQOCDoJ9G
# SIG # End signature block
