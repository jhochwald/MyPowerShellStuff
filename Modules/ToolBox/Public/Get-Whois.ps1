#region Info

<#
	#################################################
	# modified by     : Joerg Hochwald
	# last modified   : 2016-04-03
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

function global:Get-Whois {
<#
	.SYNOPSIS
		Script to retrieve WhoIs information from a list of domains

	.DESCRIPTION
		This script will, by default, create a report of WhoIs information on 1 or more Internet domains.
		Not all Top-Level Domains support Whois queries! e.g. .de (Germany) domains!

		Report options are CSV, Json, XML, HTML, and object (default) output.
		Dates in the CSV, Json, and HTML options are formatted for the culture settings on the PC.
		Columns in HTML report are also sortable, just click on the headers.

	.PARAMETER Domain
		One or more domain names to check. Accepts pipeline.

	.PARAMETER Path
		Path Where-Object the resulting HTML or CSV report will be saved. Default is: C:\scripts\PowerShell\export
		Default is C:\scripts\PowerShell\export

	.PARAMETER RedThresold
		If the number of days left before the domain expires falls below this number the entire row will be highlighted in Red (HTML reports only). Default is 30 (Days)

	.PARAMETER YellowThresold
		If the number of days left before the domain expires falls below this number the entire row will be highlighted in Yellow (HTML reports only). Default is 90 (Days)

	.PARAMETER GreyThresold
		If the number of days left before the domain expires falls below this number the entire row will be highlighted in Grey (HTML reports only). Default is 365 (Days)

	.PARAMETER OutputType
		Specify what kind of report you want.  Valid types are Json, XML,HTML, CSV, or Object. The default is Object.

	.EXAMPLE
		PS C:\> Get-Whois -Domain "NET-Experts.net","timberforest.com"

		Will create object Whois output of the domain registration data.

	.EXAMPLE
		PS C:\> Get-Whois -Domain "NET-Experts.net" -OutputType json

		Will create Json Whois Report of the domain registration data.

	.NOTES
		Based on an idea of Martin Pugh (Martin Pugh)

	.LINK
		Source: http://community.spiceworks.com/scripts/show/2809-whois-report-Get-whois-ps1

	.LINK
		NET-Experts http://www.net-experts.net

	.LINK
		Support https://github.com/jhochwald/NETX/issues
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0,
				   HelpMessage = 'One or more domain names to check. Accepts pipeline.')]
		[System.String]$Domain,
		[Parameter(HelpMessage = 'Path Where-Object the resulting HTML or CSV report will be saved. Default is: C:\scripts\PowerShell\export')]
		[System.String]$Path = "C:\scripts\PowerShell\export",
		[Parameter(HelpMessage = 'If the number of days left before the domain expires falls below this number the entire row will be highlighted in Red (HTML reports only). Default is 30 (Days)')]
		[System.Int32]$RedThresold = 30,
		[Parameter(HelpMessage = 'If the number of days left before the domain expires falls below this number the entire row will be highlighted in Yellow (HTML reports only). Default is 90 (Days)')]
		[System.Int32]$YellowThresold = 90,
		[Parameter(HelpMessage = 'If the number of days left before the domain expires falls below this number the entire row will be highlighted in Grey (HTML reports only). Default is 365 (Days)')]
		[System.Int32]$GreyThresold = 365,
		[Parameter(ValueFromPipeline = $true,
				   Position = 1,
				   HelpMessage = 'Specify what kind of report you want.  Valid types are Json, XML,HTML, CSV, or Object. The default is Object.')]
		[ValidateSet('object', 'json', 'csv', 'html', 'html', 'xml')]
		[System.String]$OutputType = 'object'
	)

	BEGIN {
		# Be Verbose
		Write-Verbose "$(Get-Date): Get-WhoIs script beginning."

		# Validate the path
		If ($Path) {
			If (Test-Path $Path) {
				If (-not (Get-Item $Path).PSisContainer) {
					# Aw Snap!
					Write-Error  "You cannot specify a file in the Path parameter, must be a folder: $Path"

					# Die headers
					exit 1
				}
			} Else {
				# Aw Snap!
				Write-Error  "Unable to locate: $Path"

				# Die hard!
				exit 1
			}
		} Else {
			$Path = Split-Path $MyInvocation.MyCommand.Path
		}

		# Create the Web Proxy instance
		$WC = (New-WebServiceProxy 'http://www.webservicex.net/whois.asmx?WSDL')

		# Cleanup
		$Data = @()
	}

	PROCESS {
		# Loop over the given domains
		$Data += ForEach ($Dom in $Domain) {
			# Be Verbose
			Write-Verbose "$(Get-Date): Querying for $Dom"

			# Cleanup
			$DNError = ""

			Try {
				$Raw = $WC.GetWhoIs($Dom)
			} Catch {
				# Some domains throw an error, I assume because the WhoIs server isn't returning standard output
				$DNError = "$($Dom.ToUpper()): Unknown Error retrieving WhoIs information"
			}

			# Test if the domain name is good or if the data coming back is ok--Google.Com just returns a list of domain names so no good
			If ($Raw -match "No match for") {
				$DNError = "$($Dom.ToUpper()): Unable to find registration for domain"
			} ElseIf ($Raw -notmatch "Domain Name: (.*)") {
				$DNError = "$($Dom.ToUpper()): WhoIs data not in correct format"
			}

			If ($DNError) {
				# Use 999899 to tell the script later that this is a bad domain and color it properly in HTML (if HTML output requested)
				[PSCustomObject]@{
					DomainName = $DNError
					Registrar = ""
					WhoIsServer = ""
					NameServers = ""
					DomainLock = ""
					LastUpdated = ""
					Created = ""
					Expiration = ""
					DaysLeft = 999899
				}

				# Bad!
				Write-Warning -message "$DNError"
			} Else {
				# Parse out the DNS servers
				$NS = ForEach ($Match in ($Raw | Select-String -Pattern "Name Server: (.*)" -AllMatches).Matches) {
					$Match.Groups[1].Value
				}

				#Parse out the rest of the data
				[PSCustomObject]@{
					# Real Objects
					DomainName = ($Raw | Select-String -Pattern "Domain Name: (.*)").Matches.Groups[1].Value
					Registrar = ($Raw | Select-String -Pattern "Registrar: (.*)").Matches.Groups[1].Value
					WhoIsServer = ($Raw | Select-String -Pattern "WhoIs Server: (.*)").Matches.Groups[1].Value
					NameServers = $NS -join ", "
					DomainLock = ($Raw | Select-String -Pattern "Status: (.*)").Matches.Groups[1].Value
					LastUpdated = [datetime]($Raw | Select-String -Pattern "Updated Date: (.*)").Matches.Groups[1].Value
					Created = [datetime]($Raw | Select-String -Pattern "Creation Date: (.*)").Matches.Groups[1].Value
					Expiration = [datetime]($Raw | Select-String -Pattern "Expiration Date: (.*)").Matches.Groups[1].Value
					DaysLeft = (New-TimeSpan -Start (Get-Date) -End ([datetime]($Raw | Select-String -Pattern "Expiration Date: (.*)").Matches.Groups[1].Value)).Days
				}
			}
		}
	}

	END {
		# Be Verbose
		Write-Verbose "$(Get-Date): Producing $OutputType report"

		#
		$WC.Dispose()

		# Sort the Domain Data
		$Data = $Data | Sort-Object DomainName

		# What kind of output?
		Switch ($OutputType) {
			"object"
			{
				# Dump to Console
				Write-Output $Data | Select-Object DomainName, Registrar, WhoIsServer, NameServers, DomainLock, LastUpdated, Created, Expiration, @{ Name = "DaysLeft"; Expression = { If ($_.DaysLeft -eq 999899) { 0 } Else { $_.DaysLeft } } }
			}
			"csv"
			{
				# Export a CSV
				$ReportPath = Join-Path -Path $Path -ChildPath "WhoIs.CSV"
				$Data | Select-Object DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{ Name = "LastUpdated"; Expression = { Get-Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Created"; Expression = { Get-Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Expiration"; Expression = { Get-Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, DaysLeft | Export-Csv $ReportPath -NoTypeInformation
			}
			"xml"
			{
				# Still like XML?
				$ReportPath = Join-Path -Path $Path -ChildPath "WhoIs.XML"
				$Data | Select-Object DomainName, Registrar, WhoIsServer, NameServers, DomainLock, LastUpdated, Created, Expiration, @{ Name = "DaysLeft"; Expression = { If ($_.DaysLeft -eq 999899) { 0 } Else { $_.DaysLeft } } } | Export-Clixml $ReportPath
			}
			"json"
			{
				# I must admin: I like Json...
				$ReportPath = Join-Path -Path $Path -ChildPath "WhoIs.json"
				$JsonData = ($Data | Select-Object DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{ Name = "LastUpdated"; Expression = { Get-Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Created"; Expression = { Get-Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Expiration"; Expression = { Get-Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, DaysLeft)
				ConvertTo-Json -InputObject $JsonData -Depth 10 > $ReportPath
			}
			"html"
			{
				# OK, HTML is should be!
				$Header = @"
<script src="http://kryogenix.org/code/browser/sorttable/sorttable.js"></script>
<style>
TABLE {border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TR:Hover TD {Background-Color: #C1D5F8;}
TH {border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color: #6495ED;cursor: pointer;}
TD {border-width: 1px;padding: 3px;border-style: solid;border-color: black;}
</style>
<title>
WhoIS Report
</title>
"@

				$PreContent = @"
<p><h1>WhoIs Report</h1></p>
"@

				$PostContent = @"
<p><br/><h3>Legend</h3>
<pre><span style="background-color:red">    </span>  Expires in under $RedThreshold days
<span style="background-color:yellow">    </span>  Expires in under $YellowThreshold days
<span style="background-color:#B0C4DE">    </span>  Expires in under $GreyThreshold days
<span style="background-color:#DEB887">    </span>  Problem retrieving information about domain/Domain not found</pre></p>
<h6><br/>Run on: $(Get-Date)</h6>
"@

				$RawHTML = ($Data | Select-Object DomainName, Registrar, WhoIsServer, NameServers, DomainLock, @{ Name = "LastUpdated"; Expression = { Get-Date $_.LastUpdated -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Created"; Expression = { Get-Date $_.Created -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, @{ Name = "Expiration"; Expression = { Get-Date $_.Expiration -Format (Get-Culture).DateTimeFormat.ShortDatePattern } }, DaysLeft | ConvertTo-Html -Head $Header -PreContent $PreContent -PostContent $PostContent)

				$HTML = ForEach ($Line in $RawHTML) {
					if ($Line -like "*<tr><td>*") {
						$Value = [float](([xml]$Line).SelectNodes("//td").'#text'[-1])

						if ($Value) {
							if ($Value -eq 999899) {
								$Line.Replace("<tr><td>", "<tr style=""background-color: #DEB887;""><td>").Replace("<td>999899</td>", "<td>0</td>")
							} elseif ($Value -lt $RedThreshold) {
								$Line.Replace("<tr><td>", "<tr style=""background-color: red;""><td>")
							} elseif ($Value -lt $YellowThreshold) {
								$Line.Replace("<tr><td>", "<tr style=""background-color: yellow;""><td>")
							} elseif ($Value -lt $GreyThreshold) {
								$Line.Replace("<tr><td>", "<tr style=""background-color: #B0C4DE;""><td>")
							} else {
								$Line
							}
						}
					} elseif ($Line -like "*<table>*") {
						$Line.Replace("<table>", "<table class=""sortable"">")
					} else {
						$Line
					}
				}

				# File name
				$ReportPath = (Join-Path -Path $Path -ChildPath "WhoIs.html")

				# Dump the HTML
				$HTML | Out-File $ReportPath -Encoding ASCII

				# Immediately display the html if in debug mode
				if ($PSCmdlet.MyInvocation.BoundParameters["Debug"].IsPresent) {
					& $ReportPath
				}
			}
		}

		# Be Verbose
		Write-Verbose "$(Get-Date): Get-WhoIs script completed!"
	}
}

# SIG # Begin signature block
# MIIfOgYJKoZIhvcNAQcCoIIfKzCCHycCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUEIxl2cWB9u92k7QsLduXzca4
# h9ugghnLMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
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
# MCMGCSqGSIb3DQEJBDEWBBRiGDOTpU932pqyHjMVX3AZ4YgZSTANBgkqhkiG9w0B
# AQEFAASCAQA8VFxR/ChmHbVYtbuUXM0KtjIN4nlkt/SLoGzIXYOlN+7UPCBh6rXQ
# +DTBVhspydBOyZRpYxeP23U8vy9ekgXdrH53cl1FAEpdF8vKi3ovjuAT/7Vsnflc
# IYtzO2+DCrvFVFK+6SJHrir6HxlFtgcL1Q/VHoU8Gwl00TpZVst9SZpwzDqQG346
# 9lQ43IalH/H8Qqtq7kPSThD0fnb0n0uq+tbOa49kAawBiOaxxSlR5brzunuy3HHm
# 7UtidSxTy6GGUSHaPJpNhsYcOdjVQ6gc8nkIYgkT1ZTkcgKjvZpMOD8rwEzC1GGM
# /1nXJ+3AbBZQEAT2kfAun0WAMsDpRU0ToYICojCCAp4GCSqGSIb3DQEJBjGCAo8w
# ggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
# c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh
# BqCB0z/YeuWCTMFrUglOAzAJBgUrDgMCGgUAoIH9MBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDQwMzIxMzcwM1owIwYJKoZIhvcN
# AQkEMRYEFLrhUBdF7pOyJgEHr5l/ZQ1fGNTiMIGdBgsqhkiG9w0BCRACDDGBjTCB
# ijCBhzCBhAQUs2MItNTN7U/PvWa5Vfrjv7EsKeYwbDBWpFQwUjELMAkGA1UEBhMC
# QkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNp
# Z24gVGltZXN0YW1waW5nIENBIC0gRzICEhEhBqCB0z/YeuWCTMFrUglOAzANBgkq
# hkiG9w0BAQEFAASCAQAAF+7rq97Mj0N5cjG99Y9nDMXvBeLcSloxU3tvXBxyH/wL
# riKTm1+F04kKXbIGzneXcs12vZKv5JMdoqeWZCn5iIdUbTdOqODhcQv97KMYLLQT
# 4m3+hC8bu8izkBfeYCqLXlSuXzvDDirQzMAta05MnprieWNEn6jKWzh8BZdYkdH+
# nUC1d0tn+mxonMkjKoqu9/BiXRlf1tpsNmHZCoCLtt2zhkPozXUbYG98KK/E4lDu
# bgfmTdeVFWmxZRCBUHfdNJrXKIAPK21ClIhlfx0zcTb28pqOgkIA1O72mrNWgGB2
# Z5IeOQmsPrCDuuA2KfWkbAwUICcOHXO7LPzMp53l
# SIG # End signature block
