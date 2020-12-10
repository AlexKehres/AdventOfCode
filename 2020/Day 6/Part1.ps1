using namespace System.Collections.Generic

$NL = [System.Environment]::NewLine

# Separate input into groups by loading input.txt as a string and splitting it on empty lines.
# This leaves us with an array of str objects for each group.

[List[String]]$AnswerList   = Get-Content .\input.txt | Out-String
[List[String]]$GroupList    = $AnswerList -split "$NL$NL"

# Loop through groups and iterate through characters (answers) in each group. 
# If we find a unique answer, add this char to Unique Answers List
# Once done w/ each group, add the number of unique characters (answers) to the total.

[Int]$Total = 0
foreach ($IndvGroup in $GroupList) {
    $UniqueAnswers = [List[String]]::new()
    for ($i=0;$i -lt $IndvGroup.Length;$i++) {
        [string]$Char = $IndvGroup[$i]
        if (($Char -match "\w") -and !($UniqueAnswers.Contains($Char))) {
            $UniqueAnswers.Add($Char)
        }
    }
    $Total += $UniqueAnswers.Count
}

# Once finished w/ all groups, return total. 

return $Total