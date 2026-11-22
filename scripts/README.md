# Teammate scripts

These scripts play the role of a colleague so you can practice collaboration solo.
Each is a few lines of PowerShell — **read them before running**; by the lesson that
uses them, you'll understand every line.

| Script | Used in | What the "teammate" does |
|---|---|---|
| `lesson-05-teammate.ps1` | Lesson 5 | Commits a conflicting title change to `main` |
| `lesson-07-teammate.ps1` | Lesson 7 | Commits a CSS tweak to `main` so your branch needs a rebase |
| `lesson-09-teammate.ps1` | Lesson 9 | Pushes a footer change from the colleague clone, so your push gets rejected |
| `lesson-10-teammate.ps1` | Lesson 10 | Clones the hub into a temp folder, pushes a homepage change, cleans up |

Run them **from inside `playground/`**, e.g.:

```powershell
..\scripts\lesson-05-teammate.ps1
```

If Windows refuses to run scripts (`...running scripts is disabled...`), allow local
scripts once for your user:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

All teammate commits are authored as **Taylor Teammate `<taylor@example.com>`**, so you
can always tell in `git log` which commits were yours.
