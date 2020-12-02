$PassList = Get-Content -Path ".\input.txt"

$counter = 0

foreach ($PassEntry in $PassList) {

    # Regex capture components from password entry and assign to vars

    $PassVars = $PassEntry | Select-String -Pattern '^(\d*)-(\d*)\s(.*):\s(.*)$' -ErrorAction Stop 
    $FirstIndex = $PassVars.Matches.Groups[1].Value
    $SecondIndex = $PassVars.Matches.Groups[2].Value
    $Char = $PassVars.Matches.Groups[3].Value
    $Password = $PassVars.Matches.Groups[4].Value

    # If the password entry contains $char "key" character at EITHER the first index OR the second index, counter += 1.
    # Subtract 1 to index since no index of zero

    if (($Password[$FirstIndex - 1] -eq $Char) -xor ($Password[$SecondIndex - 1] -eq $Char)) {
        $counter++
    }

}

return $counter