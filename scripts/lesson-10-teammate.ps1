# Lesson 10 teammate: clones the hub into a temp folder, pushes a homepage change
# to main, and cleans up after itself. Run it more than once - it makes a different
# commit each time. Run from inside playground/.
$ErrorActionPreference = "Stop"

$hub = Join-Path (Split-Path -Parent (Get-Location)) "hub.git"
if (-not (Test-Path $hub)) {
    Write-Host "Could not find ../hub.git - do Lesson 9 step 1 (git init --bare) first." -ForegroundColor Red
    exit 1
}

$tmp = Join-Path $env:TEMP ("taylor-" + [guid]::NewGuid().ToString("N").Substring(0, 8))
git clone --quiet $hub $tmp

Push-Location $tmp
try {
    $path  = "index.html"
    $html  = Get-Content $path -Raw -Encoding UTF8
    $nl    = if ($html -match "`r`n") { "`r`n" } else { "`n" }
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm"

    if ($html -match '<p class="news">') {
        $html = $html -replace '<p class="news">[^<]*</p>', "<p class=`"news`">News ($stamp): the cats remain excellent.</p>"
        $msg  = "Update news ticker"
    }
    elseif ($html -match '<h1>[^<]*</h1>') {
        $html = $html -replace '(<h1>[^<]*</h1>)', ('$1' + $nl + "  <p class=`"news`">News ($stamp): breaking - a gallery has appeared!</p>")
        $msg  = "Add news ticker to homepage"
    }
    else {
        Write-Host "Could not find an <h1> in index.html on the hub - is your homepage pushed?" -ForegroundColor Red
        exit 1
    }

    [IO.File]::WriteAllText((Resolve-Path $path), $html, [Text.UTF8Encoding]::new($false))
    git add index.html
    git -c user.name="Taylor Teammate" -c user.email="taylor@example.com" `
        commit -m $msg | Out-Null
    git push --quiet
}
finally {
    Pop-Location
    Remove-Item -Recurse -Force $tmp
}

Write-Host ""
Write-Host "Taylor Teammate pushed to main on the hub: $msg" -ForegroundColor Green
Write-Host "Remember: your clones will not see it until you fetch or pull."
