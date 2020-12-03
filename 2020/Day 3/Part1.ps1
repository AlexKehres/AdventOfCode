$TreeScape_Orig = Get-Content -Path ".\input.txt"

# Expand out TreeScape. We will never need more than the num rows

$TreeScape_Alt = $TreeScape_Orig | foreach {$_ * $TreeScape_Orig.Count}

$TreeCount = 0

# Iterate through each row, moving down 1 and 3 to the right on each pass.
# If the spot we land on contains a tree (#), TreeCount += 1
# Do this until we've reached the end of the TreeScape

$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i++) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount++}
    $t += 3
}

# Return total number of trees hit

return $TreeCount