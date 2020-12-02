$PassList = Get-Content -Path ".\input.txt"

$counter = 0

foreach ($PassEntry in $PassList) {

    # Regex capture components from password entry and assign to vars

    $PassVars = $PassEntry | Select-String -Pattern '^(\d*)-(\d*)\s(.*):\s(.*)$' -ErrorAction Stop 
    $MinCharCount = $PassVars.Matches.Groups[1].Value
    $MaxCharCount = $PassVars.Matches.Groups[2].Value
    $Char = $PassVars.Matches.Groups[3].Value
    $Password = $PassVars.Matches.Groups[4].Value

    # Count number of $char charaters present in password entry 

    $NumChar = [regex]::matches($Password,$Char).count

    # If the number of characters in the password is between the alloted min/max values, counter += 1

    if ($NumChar -ge $MinCharCount -and $NumChar -le $MaxCharCount) {
        $counter++
    }

}

return $counter