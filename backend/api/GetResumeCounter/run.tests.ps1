# run.tests.ps1

Describe "GetResumeCounter Logic" {
    
    Context "When a visitor hits the API" {
        
        It "Should increment the database count by 1" {
            # 1. ARRANGE: Create fake data to feed the function
            $fakeInputDocument = [PSCustomObject]@{ count = 5 }
            $fakeRequest = @{} 

            # Mock the Azure Push-OutputBinding cmdlet so it doesn't try to talk to the real cloud during the test
            Mock Push-OutputBinding { }

            # 2. ACT: Run your local script with the fake data
            . "$PSScriptRoot/run.ps1" -Request $fakeRequest -inputDocument $fakeInputDocument

            # 3. ASSERT: Did the math work? (5 + 1 should be 6)
            $fakeInputDocument.count | Should -Be 6
        }

        It "Should call Push-OutputBinding twice (once for DB, once for HTTP Response)" {
            # ASSERT: Did it try to save to the database and send a web response?
            Assert-MockCalled Push-OutputBinding -Times 2
        }
    }
}