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

    # Iterate through keys and only add properties that are populated and pass data validation.

    $Properties = @{}
    foreach ($Key in $Keys) {
        
        [regex]$rx = "$($Key):(\S*)"
        $Value = $rx.Match($Passport).Groups[1].Value
        if ($Value -eq "") {
            continue
        }

        ## Perform Data Validation ##

        # byr: four digits; at least 1920 and at most 2002.
        if ($Key -eq "byr" -and [string]$Value.Length -eq 4 -and [int]$Value -ge 1920 -and [int]$Value -le 2002) {
            $Properties[$Key] = $Value
            continue
        }

        # iyr: four digits; at least 2010 and at most 2020.
        if ($Key -eq "iyr" -and [string]$Value.Length -eq 4 -and [int]$Value -ge 2010 -and [int]$Value -le 2020) {
            $Properties[$Key] = $Value
            continue
        }

        # eyr: four digits; at least 2020 and at most 2030.
        if ($Key -eq "eyr" -and [string]$Value.Length -eq 4 -and [int]$Value -ge 2020 -and [int]$Value -le 2030) {
            $Properties[$Key] = $Value
            continue
        }

        # hgt: a number followed by either cm or in:
            # If cm, the number must be at least 150 and at most 193.
            # If in, the number must be at least 59 and at most 76.
        if ($Key -eq "hgt") {
            [regex]$rx_hgt  = "(\d*)(cm|in)"
            [int]$NumUOM    = $rx_hgt.Match($Value).Groups[1].Value
            [string]$UOM    = $rx_hgt.Match($Value).Groups[2].Value
            if ($UOM -eq "cm" -and $NumUOM -ge 150 -and $NumUOM -le 193) {
                $Properties[$Key] = $Value
                continue
            } elseif ($UOM -eq "in" -and $NumUOM -ge 59 -and $NumUOM -le 76) {
                $Properties[$Key] = $Value
                continue
            } else{
                continue
            }
        }

        # hcl: a # followed by exactly six characters 0-9 or a-f.
        if ($Key -eq "hcl" -and [string]$Value -match "#[0-9|a-f]{6}") {
            $Properties[$Key] = $Value
            continue
        }

        # ecl: exactly one of: amb blu brn gry grn hzl oth.
        if ($Key -eq "ecl" -and [string]$Value -match "(amb|blu|brn|gry|grn|hzl|oth)") {
            $Properties[$Key] = $Value
            continue
        }

        # pid: a nine-digit number, including leading zeroes.
        if ($Key -eq "pid" -and [string]$Value -match "^[0-9]{9}$") {
            $Properties[$Key] = $Value
            continue
        }
        
    }

    $Properties["NumFields"] = $Properties.Count

    $Passports += [PSCustomObject]$Properties
}

# Passports are only valid if all keys are populated. 

[int]$NumValid = ($Passports | where {$_.NumFields -eq 7} | Measure-Object).Count

return $NumValid
