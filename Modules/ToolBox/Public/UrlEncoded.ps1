function global:ConvertFrom-UrlEncoded {
<#
	.SYNOPSIS
		Decodes a UrlEncoded string.

	.DESCRIPTION
		Decodes a UrlEncoded string.

		Input can be either a positional or named parameters of type string or an
		array of strings. The Cmdlet accepts pipeline input.

	.PARAMETER InputObject
		A description of the InputObject parameter.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch

		# Encoded string is passed as a positional parameter to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch'
		http://www.d-fens.ch

		# Encoded string is passed as a named parameter to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell>  ConvertFrom-UrlEncoded -InputObject 'http%3a%2f%2fwww.d-fens.ch', 'http%3a%2f%2fwww.dfch.biz%2f'
		http://www.d-fens.ch
		http://www.dfch.biz/

		# Encoded strings are passed as an implicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> ConvertFrom-UrlEncoded -InputObject @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f")
		http://www.d-fens.ch
		http://www.dfch.biz/

		# Encoded strings are passed as an explicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> @("http%3a%2f%2fwww.d-fens.ch", "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		http://www.d-fens.ch
		http://www.dfch.biz/

		Encoded strings are piped as an explicit array to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> "http%3a%2f%2fwww.dfch.biz%2f" | ConvertFrom-UrlEncoded
		http://www.dfch.biz/

		# Encoded string is piped to the Cmdlet.

	.EXAMPLE
		PS C:\scripts\PowerShell> $r = @("http%3a%2f%2fwww.d-fens.ch", 0, "http%3a%2f%2fwww.dfch.biz%2f") | ConvertFrom-UrlEncoded
		PS C:\scripts\PowerShell> $r
		http://www.d-fens.ch
		0
		http://www.dfch.biz/

		# In case one of the passed strings is not a UrlEncoded encoded string, the
		# plain string is returned. The pipeline will continue to execute and all
		# strings are returned.

	.NOTES


	.LINK
		Online Version: http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/
#>

	[CmdletBinding(ConfirmImpact = 'None',
				   HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertFrom-UrlEncoded/',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $true,
				   ValueFromPipeline = $true,
				   Position = 0)]
		[ValidateNotNullOrEmpty()]
		$InputObject
	)

	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		$OutputParameter = $null;
		Log-Debug -fn $fn -msg ("CALL. InputObject.Count: '{0}'" -f $InputObject.Count) -fac 1;
	}

	PROCESS {
		foreach ($Object in $InputObject) {
			$fReturn = $false;
			$OutputParameter = $null;

			$OutputParameter = [System.Web.HttpUtility]::UrlDecode($InputObject);
			$OutputParameter;
		}
		$fReturn = $true;
	}

	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
} # function

function global:ConvertTo-UrlEncoded {
	[CmdletBinding(ConfirmImpact = 'None',
				   HelpUri = 'http://dfch.biz/biz/dfch/PS/System/Utilities/ConvertTo-UrlEncoded/',
				   SupportsShouldProcess = $true)]
	[OutputType([string])]
	param
	(
		[Parameter(Mandatory = $false,
				   ValueFromPipeline = $true,
				   ValueFromPipelineByPropertyName = $true,
				   Position = 0)]
		[string]
		$InputObject
	)

	BEGIN {
		$datBegin = [datetime]::Now;
		[string]$fn = $MyInvocation.MyCommand.Name;
		Log-Debug -fn $fn -msg ("CALL. Length '{0}'" -f $InputObject.Length) -fac 1;
	}

	PROCESS {
		$fReturn = $false;
		$OutputParameter = $null;

		$OutputParameter = [System.Web.HttpUtility]::UrlEncode($InputObject);
		return $OutputParameter;
	}

	END {
		$datEnd = [datetime]::Now;
		Log-Debug -fn $fn -msg ("RET. fReturn: [{0}]. Execution time: [{1}]ms. Started: [{2}]." -f $fReturn, ($datEnd - $datBegin).TotalMilliseconds, $datBegin.ToString('yyyy-MM-dd HH:mm:ss.fffzzz')) -fac 2;
	}
}
