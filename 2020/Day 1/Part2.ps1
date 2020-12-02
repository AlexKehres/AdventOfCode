[int32[]]$NumList = Get-Content -Path ".\input.txt"

# Index through all numbers in NumList
# For each indexed value (i), iterate through the remaining nums (t).
# Finally, for each value (t), iterate through the remaining nums (z).
# If sum(i,t,z) == 2020, multiply the three values and return the result.

for ($i=0; $i -lt $NumList.Count; $i++) {
    $t = $i + 1
    $max = $NumList.Count - 1
    while ($t -le $max) {
        $z = $t + 1
        while ($z -le $max) {
            $Sum = $NumList[$i] + $NumList[$t] + $NumList[$z]
            if ($Sum -eq 2020) {
                $Mult = $NumList[$i] * $NumList[$t] * $NumList[$z]
                return $Mult
            } else {
                $z++
            }
        }
        $t++
    }
}

Write-Error "Failed to find 3 values who's sum == 2020"