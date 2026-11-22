# Lesson 5 teammate: commits a conflicting <h1> change on main.
# Run from inside playground/ while you are on the 'navbar' branch (clean status).
$ErrorActionPreference = "Stop"

if (-not (Test-Path ".git")) {
    Write-Host "Please run this from inside your playground/ folder." -ForegroundColor Red
    exit 1
}

git switch main | Out-Null

$path = "index.html"
$html = Get-Content $path -Raw -Encoding UTF8
$old  = "<h1>Cats of the Internet</h1>"
if ($html -notmatch [regex]::Escape($old)) {
    Write-Host "Could not find '$old' in index.html on main - is your homepage h1 exactly that?" -ForegroundColor Red
    git switch - | Out-Null
    exit 1
}

$cat  = [char]::ConvertFromUtf32(0x1F63B)   # smiling cat with heart-eyes
$dash = [char]0x2014                        # em dash
$new  = "<h1>$cat Cats of the Internet $dash now with 20% more cats</h1>"
$html = $html.Replace($old, $new)
[IO.File]::WriteAllText((Resolve-Path $path), $html, [Text.UTF8Encoding]::new($false))

git add index.html
git -c user.name="Taylor Teammate" -c user.email="taylor@example.com" `
    commit -m "Punch up the homepage title" | Out-Null

Write-Host ""
Write-Host "Taylor Teammate committed a new homepage title to main." -ForegroundColor Green
Write-Host "You are now on main. Continue the lesson: git log --oneline --graph --all"
