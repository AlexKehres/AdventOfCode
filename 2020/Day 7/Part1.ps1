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
            [int]$NumBag    = $RX_Indv.Match($_).Groups[1].Value
            $ColorBag       = $RX_Indv.Match($_).Groups[2].Value
            
            $counter = 0
            while ($counter -lt $NumBag) {
                $InternalBags.Add($ColorBag)
                $counter++
            }
        }
    }
    $Rules[$Key] = $InternalBags
}

## Find Number of External Bags that contain a shiny gold bag (at some level) ## 
    # Iterate through all external bags (keys) and grab all unique internal bags. 
    # Iterate through all internal bags (values) and perform the following checks
        # Is the internal bag a shiny gold bag? If so, add the external bag to the Valid Bags and move on to next external. 
        # Do the internal bags of this internal bag immediately contain a shiny gold bag? If so, add to ValidBags and move on to next external.
        # Does this internal bag not have any internal bags remaining? If so, move on to the next inernal bag. 
        # Does this internal bag have internal bags remaining but no immediate gold bags? Add these values as additional values to check and move on to the next internal bag. 
    # Repeat the abaove process for all external bags. 

$ValidKeys = [List[String]]::new() 
$Keys = $Rules.Keys
foreach ($Key in $Keys) {
    $Values = $Rules[$Key] | Get-Unique
    while ($null -ne $Values) {
        $ValuesToCheck = @()
        foreach ($Value in $Values) {
            if ($Value -eq "shiny gold") {
                $ValidKeys.Add($Key)
                $ValuesToCheck = $null
                break
            } elseif ("shiny gold" -in $Rules[$Value]) {
                $ValidKeys.Add($Key)
                $ValuesToCheck = $null
                break
            } elseif (($Rules[$value] | Get-Unique).Count -lt 1) {
                continue
            } else { 
                $RemainingBags = $Rules[$Value] | Get-Unique
                $ValuesToCheck += $RemainingBags
            }
        }
        if ($ValuesToCheck.Count) {
            $Values = $ValuesToCheck
        } else {
            $Values = $null
        }
    }
}

return $ValidKeys.Count