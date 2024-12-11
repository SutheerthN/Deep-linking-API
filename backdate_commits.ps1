# backdate_commits.ps1
$startDate = Get-Date "2024-12-11"
$endDate = Get-Date "2025-01-01"
$totalCommits = 32
$files = @("README.md", "app.json", "index.js" , "tsconfig.json", "package.json")
$rand = New-Object System.Random

for ($i = 1; $i -le $totalCommits; $i++) {
    $range = ($endDate - $startDate).Days
    $randomOffset = $rand.Next(0, $range + 1)
    $commitDate = $startDate.AddDays($randomOffset).ToString("yyyy-MM-dd")

    $file = $files[$rand.Next(0, $files.Length)]

    # Make a small change
    $line = "// Commit #$i on $commitDate"
    Add-Content $file $line

    git add $file

    $env:GIT_AUTHOR_DATE = "$commitDate 05:47:00"
    $env:GIT_COMMITTER_DATE = "$commitDate 05:47:00"

    git commit -m "Backdated commit #$i on $commitDate"
}
