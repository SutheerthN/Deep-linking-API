# backdate_index_commits.ps1

$commitCount = 15
$indexPath = "index.js"
$baseDate = Get-Date "2025-01-01T10:00:00"

# Ensure index.js exists
if (!(Test-Path $indexPath)) {
    Write-Error "index.js not found!"
    exit
}

for ($i = 1; $i -le $commitCount; $i++) {
    # Generate a random minute offset (1–4 minutes between commits)
    $minuteOffset = Get-Random -Minimum 1 -Maximum 5
    $commitTime = $baseDate.AddMinutes($i * $minuteOffset)
    $timestamp = $commitTime.ToString("yyyy-MM-ddTHH:mm:ss")

    # Append a realistic comment
    Add-Content $indexPath "`n// Commit #$i on 2025-01-01"

    # Stage the change
    git add $indexPath

    # Set backdated timestamps
    $env:GIT_AUTHOR_DATE = "$timestamp"
    $env:GIT_COMMITTER_DATE = "$timestamp"

    # Commit with escaped colon
    git commit -m "Commit #$i`: update on 2025-01-01 at $(${timestamp}.Split('T')[1])"

    Write-Host "Committed change #$i at $timestamp"
}

# Push to GitHub
git push origin main
