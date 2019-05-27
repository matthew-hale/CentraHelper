function New-GCUser {
	[cmdletbinding()]

	param (
		[Parameter(Mandatory)]
		[String]$Name,

		[String]$Description,

		[Parameter(Mandatory)]
		[String]$Email,

		[Parameter(Mandatory)]
		[String[]]$Permissions,

		[Switch]$TwoFactor,

		[Parameter(Mandatory)]
		[String]$Password,

		[Switch]$IncidentPasswordAccess,

		[Switch]$Raw,

		[PSTypeName("GCApiKey")]$ApiKey
	)

	if ( GCApiKey-present $ApiKey ) {
		if ( $ApiKey ) {
			$Key = $ApiKey
		} else {
			$Key = $global:GCApiKey
		} 
		$Uri = "/system/user"
	}

	if ( -not $Description ) {
		$Description = "Created by the API"
	}

	$Body = [PSCustomObject]@{
		action = "create"
		can_access_passwords = $IncidentPasswordAccess.IsPresent
		description = $Description
		email = $Email
		password = $Password
		password_confirm = $Password
		permission_scheme_ids = @($Permissions)
		two_factor_auth_enabled = $TwoFactor.IsPresent
		username = $Name
	}

	pwsh-gc-post-request -Uri $Uri -Body $Body -ApiKey $Key -Raw:$Raw.IsPresent
}

