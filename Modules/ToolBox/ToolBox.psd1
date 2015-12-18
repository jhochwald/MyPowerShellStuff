@{
	
	# Script module or binary module file associated with this manifest
	ModuleToProcess = 'ToolBox.psm1'
	
	# Version number of this module.
	ModuleVersion = '1.1.0.0'
	
	# ID used to uniquely identify this module
	GUID = '90d8013a-4e1f-4b43-b481-e27af7c213f3'
	
	# Author of this module
	Author = 'Joerg Hochwald'
	
	# Company or vendor of this module
	CompanyName = 'Joerg Hochwald'
	
	# Copyright statement for this module
	Copyright = '(c) 2015. All rights reserved.'
	
	# Description of the functionality provided by this module
	Description = 'PowerShell Basic ToolBox Module'
	
	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '4.0'
	
	# Name of the Windows PowerShell host required by this module
	PowerShellHostName = ''
	
	# Minimum version of the Windows PowerShell host required by this module
	PowerShellHostVersion = ''
	
	# Minimum version of the .NET Framework required by this module
	DotNetFrameworkVersion = '4.5'
	
	# Minimum version of the common language runtime (CLR) required by this module
	CLRVersion = ''
	
	# Processor architecture (None, X86, Amd64, IA64) required by this module
	ProcessorArchitecture = 'None'
	
	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules = @('ActiveDirectory')
	
	# Assemblies that must be loaded prior to importing this module
	RequiredAssemblies = @()
	
	# Script files (.ps1) that are run in the caller's environment prior to
	# importing this module
	ScriptsToProcess = @()
	
	# Type files (.ps1xml) to be loaded when importing this module
	TypesToProcess = @()
	
	# Format files (.ps1xml) to be loaded when importing this module
	FormatsToProcess = @()
	
	# Modules to import as nested modules of the module specified in
	# ModuleToProcess
	NestedModules = @()
	
	# Functions to export from this module
	FunctionsToExport = @('*')
	
	# Cmdlets to export from this module
	CmdletsToExport = @('*')
	
	# Variables to export from this module
	VariablesToExport = @('*')
	
	# Aliases to export from this module
	AliasesToExport = @('*')
	
	# List of all modules packaged with this module
	ModuleList = @()
	
	# List of all files packaged with this module
	FileList = @()
	
	# Private data to pass to the module specified in ModuleToProcess
	PrivateData = @{
		# PSData is module packaging and gallery metadata embedded in PrivateData
		# It's for rebuilding PowerShellGet (and PoshCode) NuGet-style packages
		# We had to do this because it's the only place we're allowed to extend the manifest
		# https://connect.microsoft.com/PowerShell/feedback/details/421837
		PSData = @{
			
			# The primary categorization of this module (from the TechNet Gallery tech tree).
			Category = "Scripting Techniques"
			
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('powershell', 'ActiveDirectory')
			
			# A URL to the license for this module.
			# LicenseUri = ''
			
			# A URL to the main website for this project.
			ProjectUri = 'http://support.net-experts.net'
			
			# A URL to an icon representing this module.
			# IconUri = ''
			
			# ReleaseNotes of this module
			# ReleaseNotes = ''
			
			# If true, the LicenseUrl points to an end-user license (not just a source license) which requires the user agreement before use.
			# RequireLicenseAcceptance = ""
			
			# Indicates this is a pre-release/testing version of the module.
			IsPrerelease = 'False'
			
		} # End of PSData hashtable
		
	} # End of PrivateData hashtable
}
