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

function global:Get-Quote {
<#
	.SYNOPSIS
		Get a random Quote from an Array

	.DESCRIPTION
		Get a random Quote from an Array of Quotes I like.
		I like to put Quotes in slides and presentations, here is a collection of whose I used...


	.EXAMPLE
		PS C:\> Get-Quote

	.OUTPUTS
		System.String

	.NOTES
		Based on an idea of Jeff Hicks

		I just implemented this because it was fun to do so ;-)

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	[OutputType([System.String])]
	param ()

	BEGIN {
		# The quote should include the author separated by " - ".
		$texts = @(
			"If you don't drive your business, you will be driven out of business. - B. C. Forbes",
			"Good design is good business. - Thomas J. Watson",
			"Good is the enemy of great. - Sir Jonathan Ive",
			"There are 9 rejected ideas for every idea that works. - Sir Jonathan Ive"
			"People's interest is in the product, not in its authorship. - Sir Jonathan Ive",
			"I think it's really important to design things with a kind of personality. - Marc Newson",
			"Intelligence is the ability to adapt to change. - Stephen Hawking",
			"We are all now connected by the Internet, like neurons in a giant brain. - Stephen Hawking",
			"The best ideas start as conversations. - Sir Jonathan Ive",
			"If something is not good enough, stop doing it. - Sir Jonathan Ive",
			"There's no learning without trying lots of ideas and failing lots of times. - Sir Jonathan Ive",
			"The urge for good design is the same as the urge to go on living. - Harry Bertoia",
			"Any product that needs a manual to work is broken. - Elon Musk",
			"Fashion is architecture: it is a matter of proportions. - Coco Chanel",
			"Prophesy is a good line of business, but it is full of risks. - Mark Twain",
			"If a business does well, the stock eventually follows. - Warren Buffett",
			"As you grow in this business, you learn how to do more with less. - Morgan Freeman",
			"One thing is certain in business. You and everyone around you will make mistakes. - Richard Branson",
			"If you don't understand the details of your business you are going to fail. - Jeff Bezos",
			"A man should never neglect his family for business. - Walt Disney",
			"The business of business is relationships; the business of life is human connection. - Robin S. Sharma",
			"Business has only two functions: marketing and innovation. - Milan Kundera",
			"That's what show business is, sincere insincerity. - Benny Hill",
			"A friendship founded on business is better than a business founded on friendship. - John D. Rockefeller",
			"Just because something doesn't do what you planned it to do doesn't mean it's useless. - Thomas A. Edison",
			"Great companies are built on great products. - Elon Musk",
			"I rate enthusiasm even above professional skill. - Edward Appleton",
			"Test fast, fail fast, adjust fast. - Tom Peters",
			"I don't think it's a good idea to plan to sell a company. - Elon Musk",
			"All the things I love is what my business is all about. - Martha Stewart",
			"I believe fundamental honesty is the keystone of business. - Harvey S. Firestone",
			"Business opportunities are like buses, there's always another one coming. - Richard Branson",
			"When times are bad is when the real entrepreneurs emerge. - Robert Kiyosaki",
			"We're all working together; that's the secret. - Sam Walton",
			"Winning isn't everything, it's the only thing. - Vince Lombardi (Former NFL Coach)",
			"The only place success comes before work is in the dictionary. - Vince Lombardi (Former NFL Coach)",
			"The measure of who we are is what we do with what we have. - Vince Lombardi (Former NFL Coach)",
			"The greatest accomplishment is not in never falling, but in rising again after you fall. - Vince Lombardi (Former NFL Coach)"
			"Perfection is not attainable. But if we chase perfection, we can catch excellence. - Vince Lombardi (Former NFL Coach)",
			"Stay focused. Your start does not determine how you're going to finish. - Herm Edwards (Former NFL Coach)",
			"I'm not really in the excuse business. - Bill Parcells (Former NFL Coach)"
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
			"Coming together is a beginning; keeping together is progress; working together is success. - Henry Ford",
			"My best friend is the one who brings out the best in me. - Henry Ford",
			"Thinking is the hardest work there is, which is probably the reason why so few engage in it. - Henry Ford",
			"A business that makes nothing but money is a poor business. - Henry Ford",
			"Failure is simply an opportunity to begin again, this time more intelligently. - Henry Ford",
			"The only real mistake is the one from which we learn nothing. - Henry Ford",
			"Unthinking respect for authority is the greatest enemy of truth. - Albert Einstein",
			"If you can dream it, you can do it. - Walt Disney",
			"The difference between winning and losing is most often not quitting. - Walt Disney",
			"If you're not making mistakes, then you're not making desisions. - Catherine Cook (MeetMe Co-Founder)",
			"I have not failed. I've just found 10.000 ways that won't work. - Thomas Edison",
			"If you don't build your dream, someone will hire you to help build theirs. - Tony Gaskin (Motivational Speaker)",
			"Screw it. Let's do it. - Richard Branson",
			"Don't worry about dailure; you only have to be right once. - Drew Houston",
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
			"Don't count the days, make the days count. - Muhammad Ali",
			"Everything you can imagine is real. - Pablo Picasso",
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

		$arr | foreach -Begin {
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