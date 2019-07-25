InModuleScope pwsh-GC {
    Describe Get-GCPolicy {
        $ApiKey = [PSCustomObject]@{
            PSTypeName = "GCApiKey"
            Uri = "test"
            Token = "test"
        }

        Context "Simple function test" {

            Mock GCApiKey-present {
                $true
            }
    
            Mock pwsh-GC-get-request {
                Invoke-RestMethod -Uri $Uri -Method "get"
            }
    
            Mock Invoke-RestMethod {
                [PSCustomObject]@{
                    Method = $Method
                    Called = $true
                    Uri = $Uri
                }
            }
    
            $Result = Get-Policy -ApiKey $ApiKey
    
            It "Successfully calls Invoke-RestMethod" {
                $Current = $Result.Called
                $Should = $true
    
                $Current | Should -Be $Should
            }
    
            It "Calls Invoke-RestMethod using a 'get' method" {
                $Current = $Result.Method
                $Should = "get"
    
                $Current | Should -Be $Should
            }
    
            It "Passes the correct Uri to pwsh-GC-get-request" {
                $Current = $Result.Uri
                $Should = "/visibility/policy/rules?limit=20"

                $Current | Should -Be $Should
            }
        }
    }
}

