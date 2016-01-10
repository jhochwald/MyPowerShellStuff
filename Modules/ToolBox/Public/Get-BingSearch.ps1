<#
	Basic Function found somewhere on the Internet.
	Unknown license and unknown copyright.

	We just adopted and tweaked it.
#>

function global:Get-BingSearch {
<#
	.SYNOPSIS
		Get the Bing results for a string

	.DESCRIPTION
		Get the latest Bin search results for a given string and presents it on the console

	.PARAMETER searchstring
		String to search for on Bing

	.EXAMPLE
		PS C:\> Get-BingSearch -searchstring:"Joerg Hochwald"

		Return the Bing Search Results for "Joerg Hochwald"

	.EXAMPLE
		PS C:\> Get-BingSearch -searchstring:"KreativSign GmbH"

		Return the Bing Search Results for "KreativSign GmbH" as a formated List (fl = Format-List)

	.NOTES
		This is a function that Michael found useful, so we adopted and tweaked it a bit.
		The original function was found somewhere on the Internet!

	.LINK
		Joerg Hochwald: http://hochwald.net

	.LINK
		Support: http://support.net-experts.net
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[ValidateNotNullOrEmpty()]
		[Alias('Search')]
		[string]
		$searchstring = $(throw "Please specify a search string.")
	)

	BEGIN {
		# Use the native .NET Client implementation
		$client = New-Object System.Net.WebClient

		# What to call?
		$url = "http://www.bing.com/search?q={0}`&format=rss" -f $searchstring
	}

	PROCESS {
		# By the way: This is XML ;-)
		[xml]$results = $client.DownloadString($url)

		# Save the info to a variable
		$channel = $results.rss.channel

		# Now we loop over the return
		foreach ($item in $channel.item) {
			# Create a new Object
			$result = New-Object PSObject

			# Fill the new Object
			$result | Add-Member NoteProperty Title -value $item.title
			$result | Add-Member NoteProperty Link -value $item.link
			$result | Add-Member NoteProperty Description -value $item.description
			$result | Add-Member NoteProperty PubDate -value $item.pubdate
			$sb = {
				$ie = New-Object -com internetexplorer.application
				$ie.navigate($this.link)
				$ie.visible = $true
			}
			$result | Add-Member ScriptMethod Open -value $sb

			# Dump it to the console
			Write-Output $result
		}
	}

	END {
		# Do a garbage collection
		if ((Get-Command run-gc -errorAction SilentlyContinue)) {
			run-gc
		}
	}
}
