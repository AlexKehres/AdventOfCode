using namespace System.Collections.Generic

[List[String]]$Rules_Raw = Get-Content .\input.txt 

$Rules = [HashTable]::new()

# Iterate through each of the input rules.

$Rules_Raw | foreach {

    ## Find Bag Key (Outermost Bag) ##
        # Match the start of the string up to "bags contain", capturing the bag color. Assign this value to Key

    [regex]$RX_Key = "^(.*) bags contain"
    $Key = $RX_Key.Match($_).Groups[1].Value

    ## Find bags that contain other bags ##
        # Capture remainig portion of rule (everything after contain) and split this into individual bag entries. 
        # For each of these entries, pull the count/color of the bag and add a bag color entry corresponding to the number of that particular internal bag.
        # Once all internal bags have been expanded/accounted for, set this value to the Key (external bag) in the hashtable. 

    [regex]$RX_All = "contain (.*)"
    $Values = $RX_All.Matches($_).Groups[1].Value.Split(",.").trim()
    $InternalBags = [List[PsObject]]::new()
    $Values | foreach {
        [regex]$RX_Indv = "(\d+) (\w* \w*) bag[s]?"
        if ($RX_Indv.Match($_).Success) {
            [int]$NumBag        = $RX_Indv.Match($_).Groups[1].Value
            $ColorBag   = $RX_Indv.Match($_).Groups[2].Value
            
            $counter = 0
            while ($counter -lt $NumBag) {
                $InternalBags.Add($ColorBag)
                $counter++
            }
        }
    }
    $Rules[$Key] = $InternalBags
}

## Find number of (non-unique) internal bags that exist for the shiny gold external bag. ## 
    # Get all the immediate internal bags for the shiny gold external bag.
    # For each of these internal bags, perform the following checks: 
        # Does the bag have any internal bags? If not, increment internal bag count, add total number of steps taken to reach final bag to internal bag count, and move on to next internal bag. 
        # If the bag does have internal bags, increment the step counter and repeat these checks for those internal bags. 
    # Repeat the above checks for all internal bags. 

[int]$InternalBagCount = 0
$Values = @($Rules['shiny gold'])
$Step = 0
while ($null -ne $Values) {
    $ValuesToCheck = @()
    foreach ($Value in $Values) {
        if (($Rules[$value]).Count -lt 1) {
            $InternalBagCount++
            $InternalBagCount += $Step
            $Step = 0
            continue
        } else {
            $Step++
            $ValuesToCheck += $Rules[$Value]
        }
    }
    if ($ValuesToCheck.Count) {
        $Values = $ValuesToCheck
    } else {
        $Values = $null
    }
}

return $InternalBagCount