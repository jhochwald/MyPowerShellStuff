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

function global:JavaLove {
<#
	.SYNOPSIS
		Set the JAVAHOME Variable to use JDK and/or JRE instances withing the Session

	.DESCRIPTION
		You are still using Java Stuff?
		OK... Your choice, so we do you the favor and create/fill the variable JAVAHOME based on the JDK/JRE that we found.
		It also append the Info to the PATH variable to make things easier for you.
		But think about dropping the buggy Java crap as soon as you can. Java is not only buggy, there are also many Security issues with it!

		By the way: I hate Java!

	.EXAMPLE
		PS C:\scripts\PowerShell> JavaLove

		Find the installed JDK and/or JRE version and crate the JDK_HOME and JAVA_HOME variables for you.
		It also appends the Path to the PATH  and CLASSPATH variable to make it easier for you.

		But do you still need java?

	.NOTES
		This is just a little helper function to make the shell more flexible

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	param ()

	BEGIN {
		# Where do we want to search for the Java crap?
		Set-Variable -Name baseloc -Value $("$env:ProgramFiles\Java\")
	}

	PROCESS {
		# Show Java a little love...
		# And I have no idea why I must do that!
		if ((test-path $baseloc)) {
			# Include JDK if found
			Set-Variable -Name sdkdir -Value $(resolve-path "$baseloc\jdk*")

			# Do we have a SDK?
			if ($sdkdir -ne $null -and (test-path $sdkdir)) {
				# Set the enviroment
				$env:JDK_HOME = $sdkdir

				# Tweak the PATH
				append-path "$sdkdir\bin"
			}

			# Include JRE if found
			$jredir = (resolve-path "$baseloc\jre*")

			# Do we have a JRE?
			if ($jredir -ne $null -and (test-path $jredir)) {
				# Set the enviroment
				$env:JAVA_HOME = $jredir

				# Tweak the PATH
				append-path "$jredir\bin"
			}

			# Update the Classpath
			append-classpath "."
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
