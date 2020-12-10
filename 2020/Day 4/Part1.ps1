$PassportDataRaw = Get-Content -Path ".\input.bat" | Out-String

$NewLine = [Environment]::NewLine

# Split input into individual passport [string] objects.
# Passport entries are delimited by empty lines. 

$PassportsSeparated = $PassportDataRaw -split "$NewLine$NewLine"

$Passports = @()
foreach ($Passport in $PassportsSeparated) {
    
    $Keys = @(
        "byr"
        "iyr"
        "eyr"
        "hgt"
        "hcl"
        "ecl"
        "pid"
    )

    # Iterate through keys and add populated values to properties array.

    $Properties = @{}
    foreach ($Key in $Keys) {
        [regex]$rx = "$($Key):(\S*)"
        $Value = $rx.Match($Passport).Groups[1].Value
        if ($Value -ne "") {
            $Properties[$Key] = $Value
        }
    }

    $Properties["NumFields"] = $Properties.Count

    $Passports += [PSCustomObject]$Properties
}

# Passports are only valid if all keys are populated. 

[int]$NumValid = ($Passports | where {$_.NumFields -eq 7} | Measure-Object).Count

return $NumValid
