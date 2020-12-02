[int32[]]$NumList = Get-Content -Path ".\input.txt"

# Index through all numbers in NumList (i)
# For each indexed value, iterate through the remaining nums (t) and add them to i.
# If sum == 2020, multiply the two values and return the result.

for ($i=0; $i -lt $NumList.Count; $i++) {
    $t = $i + 1
    $max = $NumList.Count - 1
    while ($t -le $max) {
        $Sum = $NumList[$i] + $NumList[$t]
        if ($Sum -eq 2020) {
            $Mult = $NumList[$i] * $NumList[$t]
            return $Mult
        } else {
            $t++
        }
    }
}

Write-Error "Failed to find 2 values who's sum == 2020"