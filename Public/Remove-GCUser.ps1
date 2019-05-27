function Remove-GCUser {
	[cmdletbinding()]

	param (
		[Parameter(ValueFromPipelineByPropertyName)]
		[String[]]$username,

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
			$Uri = "/system/user"
		}
	}

	process {
		foreach ( $ThisUser in $Username ) {
			$Body = [PSCustomObject]@{
				action = "delete"
				confirm = $true
				username = $ThisUser
			}

			pwsh-gc-post-request -Uri $Uri -Body $Body -ApiKey $Key -Raw:$Raw.IsPresent
		}
	}
}
