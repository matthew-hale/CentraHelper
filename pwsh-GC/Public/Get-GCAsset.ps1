function Get-GCAsset {

	[CmdletBinding()]
	param (
		[System.String]$Search,

		[ValidateSet("on","off")][System.String]$Status,

		[ValidateRange(0,3)][Int32]$Risk,

		[Parameter(Mandatory=$false,ValueFromPipeline=$true)]
		[PSTypeName("GCLabel")]$Label,

		[PSTypeName("GCAsset")]$Asset,

		[ValidateRange(0,1000)][Int32]$Limit = 20,

		[ValidateRange(0,500000)][Int32]$Offset,

		[Switch]$Raw,

		[PSTypeName("GCApiKey")]$ApiKey
	)
	begin {
		if (GCApiKey-present $ApiKey) {
			if ($ApiKey) {
				$Key = $ApiKey
			} else {
				$Key = $global:GCApiKey
			}
			$Uri = "/assets"
		}
	}

	process {
		# Handling pipeline input
		$LabelIDs += foreach ($L in $Label) {
			$L.id
		}
	}

	end {
		# Building the request body with given parameters
		$Body = @{
			search = $Search
			status = $Status
			risk_level = $Risk
			labels = $LabelIDs -join ","
			asset = $Asset.id -join ","
			limit = $Limit
			offset = $Offset
		}

		# Removing empty hashtable keys
		$RequestBody = Remove-EmptyKeys $Body

		# Making the call
		if ($Raw) {
			pwsh-GC-get-request -Raw -Uri $Uri -Body $RequestBody -ApiKey $Key
		} else {
			pwsh-GC-get-request -Uri $Uri -Body $RequestBody -ApiKey $Key | foreach {$_.PSTypeNames.Clear(); $_.PSTypeNames.Add("GCAsset"); $_}
		}
	}
}