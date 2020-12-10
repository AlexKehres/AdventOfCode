using namespace System.Collections.Generic

# Load input into AnswerList w/ each line being a separate entry.

[List[String]]$AnswerList = Get-Content .\input.txt

$AllGroups = [List[PsObject]]::new()

# Index through AnswerList, adding each row to an IndvGroup list until we hit a empty line.
# Once we've hit the empty line, add the IndvGroup list to AllGroups and initialize another IndvGroup list. 
# Repeat this process until we've cleared all lines. Add the final IndvGroup to AllGroups once finished. 
# This will leave us with a list of IndvGroup lists. 

$IndvGroup = [List[String]]::new()
for ($i=0;$i -lt $AnswerList.Count;$i++) {
    if ([string]::IsNullOrEmpty($AnswerList[$i])) {
        $AllGroups.Add($IndvGroup)
        $IndvGroup = [List[String]]::new()
    } else {
        $IndvGroup.Add($AnswerList[$i])
    }
}
$AllGroups.Add($IndvGroup)

# Iterate through each Group in AllGroups. 
# For each group, set the first set of answers for that group as the reference. 
# Index through the remaining answer sets for that group and compare them to the reference. Each time removing answers (chars) not present in the reference. 
# Once done, we will only be left w/ answers that are present in each of the answer sets for that group. 
# Add the number of answers left to the total and return it once complete. 

[int]$Total = 0
foreach ($Group in $AllGroups) {
    [List[String]]$RefAnswers = $Group[0].ToCharArray()
    for ($i=1;$i -lt $Group.Count;$i++) {
        [List[String]]$DiffAnswers = $Group[$i].ToCharArray()
        ($RefAnswers | Compare-Object $DiffAnswers).InputObject | % {$RefAnswers.Remove($_) | Out-Null}
    }
    $Total += $RefAnswers.Count
}

return $Total