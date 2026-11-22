# Lesson 9 teammate: the colleague clone commits a footer change and PUSHES it,
# so your next push from playground/ gets rejected.
# Run from inside playground/. Requires ../playground-colleague from Lesson 9 step 3.
$ErrorActionPreference = "Stop"

$colleague = Join-Path (Split-Path -Parent (Get-Location)) "playground-colleague"
if (-not (Test-Path (Join-Path $colleague ".git"))) {
    Write-Host "Could not find ../playground-colleague - do Lesson 9 step 3 (git clone) first." -ForegroundColor Red
    exit 1
}

Push-Location $colleague
try {
    git switch main | Out-Null
    git pull | Out-Null

    $path = "index.html"
    $html = Get-Content $path -Raw -Encoding UTF8
    if ($html -notmatch "</footer>") {
        Write-Host "No <footer> found in the colleague's index.html - commit and push the footer first (Lesson 9 step 4)." -ForegroundColor Red
        exit 1
    }
    $nl   = if ($html -match "`r`n") { "`r`n" } else { "`n" }
    $link = '    <p><a href="#top">Back to top</a></p>' + $nl + '  </footer>'
    $html = $html -replace "\s*</footer>", ($nl + $link)
    [IO.File]::WriteAllText((Resolve-Path $path), $html, [Text.UTF8Encoding]::new($false))

    git add index.html
    git -c user.name="Taylor Teammate" -c user.email="taylor@example.com" `
        commit -m "Add back-to-top link in footer" | Out-Null
    git push --quiet
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Taylor Teammate pushed a footer change to the hub from the colleague clone." -ForegroundColor Green
Write-Host "Back in playground/, try your push now: git push"
