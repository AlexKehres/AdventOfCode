function FindTrees {

    param( 
        [Parameter(Mandatory)][Array]$TreeScape,
        [Parameter(Mandatory)][int]$Down,
        [Parameter(Mandatory)][int]$Right
    )

    # Iterate through each row, moving down/right a set number of rows/values.
    # If the spot we land on contains a tree (#), TreeCount += 1
    # Do this until we've reached the end of the TreeScape

    $TreeCount = 0
    $t = 0
    for ($i=0; $i -lt $TreeScape.Count; $i += $Down) {
        if ($TreeScape[$i][$t] -eq "#") {$TreeCount++}
        $t += $Right
    }

    return $TreeCount

}

## MAIN ##

$TreeScape_Orig = Get-Content -Path ".\input.txt"

# Expand out TreeScape. We will never need more than the num rows

$TreeScape_Alt = $TreeScape_Orig | foreach {$_ * $TreeScape_Orig.Count}

# Determine number of trees hit for the 5 passes

$Pass1 = FindTrees -TreeScape $TreeScape_Alt -Down 1 -Right 1
$Pass2 = FindTrees -TreeScape $TreeScape_Alt -Down 1 -Right 3
$Pass3 = FindTrees -TreeScape $TreeScape_Alt -Down 1 -Right 5
$Pass4 = FindTrees -TreeScape $TreeScape_Alt -Down 1 -Right 7
$Pass5 = FindTrees -TreeScape $TreeScape_Alt -Down 2 -Right 1

# Once we have the number of trees for each sled pass, multiply them all together and return

$Mult = $Pass1 * $Pass2 * $Pass3 * $Pass4 * $Pass5

return $Mult