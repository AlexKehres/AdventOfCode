$TreeScape_Orig = Get-Content -Path ".\input.txt"

# Expand out TreeScape. We will never need more than the num rows

$TreeScape_Alt = $TreeScape_Orig | foreach {$_ * $TreeScape_Orig.Count}

# Iterate through each row, moving down/right a set number of rows/values.
# If the spot we land on contains a tree (#), TreeCount += 1
# Do this until we've reached the end of the TreeScape
# Repeat for the 5 movement scenarios.

# Down 1, Right 1

$TreeCount_1 = 0
$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i++) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount_1++}
    $t += 1
}

# Down 1, Right 3 (Solution from Part 1)

$TreeCount_2 = 0
$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i++) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount_2++}
    $t += 3
}

# Down 1, Right 5

$TreeCount_3 = 0
$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i++) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount_3++}
    $t += 5
}

# Down 1, Right 7

$TreeCount_4 = 0
$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i++) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount_4++}
    $t += 7
}

# Down 2, Right 1

$TreeCount_5 = 0
$t = 0
for ($i=0; $i -lt $TreeScape_Alt.Count; $i += 2) {
    if ($TreeScape_Alt[$i][$t] -eq "#") {$TreeCount_5++}
    $t++
}

# Once we have the number of trees for each sled pass, multiply them all together and return

$Mult = $TreeCount_1 * $TreeCount_2 * $TreeCount_3 * $TreeCount_4 * $TreeCount_5

return $Mult