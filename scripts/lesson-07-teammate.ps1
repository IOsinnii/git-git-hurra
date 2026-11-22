# Lesson 7 teammate: commits a small CSS improvement to main,
# so your 'contact-page' branch falls behind and needs a rebase.
# Run from inside playground/ (any branch, clean status).
$ErrorActionPreference = "Stop"

if (-not (Test-Path ".git")) {
    Write-Host "Please run this from inside your playground/ folder." -ForegroundColor Red
    exit 1
}

git switch main | Out-Null

$path = "style.css"
$css  = Get-Content $path -Raw -Encoding UTF8
$nl   = if ($css -match "`r`n") { "`r`n" } else { "`n" }
$css += "$nl" + "a {$nl  color: mediumvioletred;$nl}$nl"
[IO.File]::WriteAllText((Resolve-Path $path), $css, [Text.UTF8Encoding]::new($false))

git add style.css
git -c user.name="Taylor Teammate" -c user.email="taylor@example.com" `
    commit -m "Give links a friendlier color" | Out-Null

Write-Host ""
Write-Host "Taylor Teammate committed a CSS tweak to main." -ForegroundColor Green
Write-Host "You are now on main. Continue the lesson: git switch contact-page"
