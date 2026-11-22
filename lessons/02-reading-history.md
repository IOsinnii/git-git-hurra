# Lesson 2 — Reading history

## 🎯 Goal
You can answer "what changed, when, and in which commit?" without guessing, keep junk
files out of Git, and fix a bad last commit.

## 🧰 New tools
`git log` (grown-up version) · `git diff` · `git diff --staged` · `git show` ·
`.gitignore` · `git commit --amend`

*Prerequisite: your `playground/` from Lesson 1 with 2+ commits.*

---

## 🔨 Do it

### 1. Give the site some style

Create `style.css` in `playground/`:

```css
body {
  font-family: Georgia, serif;
  max-width: 640px;
  margin: 2rem auto;
  line-height: 1.6;
}

h1 {
  color: darkslateblue;
}
```

Link it from `index.html` by adding this line inside `<head>`:

```html
  <link rel="stylesheet" href="style.css">
```

Refresh the browser — styled! **Don't commit yet.** First, let's inspect.

### 2. `git diff` — what did I change?

```powershell
git diff
```

You see the `index.html` change (lines starting with `+` are added, `-` removed) but
**not** `style.css`. `git diff` compares *working directory vs staging area*, and diff
only speaks about files Git already tracks. New untracked files show up in `status`, not
`diff`.

Now stage everything and look again:

```powershell
git add .
git diff              # silence! everything is staged
git diff --staged     # there it is: staging area vs last commit
```

Memorize the pair:
- `git diff` → "what have I changed **but not yet staged**?"
- `git diff --staged` → "what **will** the next commit contain?"

Run `git diff --staged` before every commit (ideally). It catches the
debug line you forgot to delete, the file you staged by accident.

```powershell
git commit -m "Add stylesheet with basic typography"
```

### 3. Junk happens — `.gitignore`

Editors and operating systems drop litter into project folders. Simulate it:

```powershell
"imagine editor settings here" | Out-File .vscode-junk.txt
mkdir dist
"pretend this is a built file" | Out-File dist/site-bundle.txt
git status
```

Two new untracked things you never want committed: local editor junk and `dist/`
(built output that can be regenerated — never commit what a machine can rebuild).
Create a file named exactly `.gitignore`:

```
# editor litter
.vscode-junk.txt

# build output — regenerate with the build tool, never commit
dist/
```

```powershell
git status
```

The junk vanished from status. Git now pretends those paths don't exist. Note the
irony you should embrace: **`.gitignore` itself gets committed** — the whole team shares
the same "what to ignore" rules.

```powershell
git add .gitignore
git commit -m "Ignore editor junk and build output"
```

### 4. Grown-up `git log`

```powershell
git log                          # full: author, date, message
git log --oneline                # one line per commit
git log --oneline --stat         # + which files changed
git log -p style.css             # every change ever made to one file, with diffs
git show HEAD                    # the newest commit in full detail
git show HEAD~1                  # its parent (~1 = "one step back")
```

`HEAD` = "the commit I'm standing on" (almost always the newest one, for now).
`HEAD~1`, `HEAD~2` = parent, grandparent. You'll meet `HEAD` properly in Lesson 6.

### 5. Fix a bad last commit — `--amend`

Make a deliberately sloppy commit. Add this to `style.css`:

```css
p {
  color: #333;
}
```

```powershell
git add style.css
git commit -m "asdfgh"        # oops. we've all done it
```

A garbage message, and — oh no — you also meant to include a tweak. Add to `style.css`:

```css
strong {
  color: crimson;
}
```

Fix both problems in one move:

```powershell
git add style.css
git commit --amend -m "Style paragraphs and highlighted text"
git log --oneline
```

Still the same *number* of commits — `--amend` doesn't add a fix-up commit, it **replaces**
the last one with a corrected version. Compare the hash before and after: it changed,
because it's a genuinely new commit wearing the old one's position.

> ⚠️ Rule you'll understand fully in Lesson 9: only amend commits you haven't **pushed**
> (shared with others) yet. Replacing history that only exists on your machine: always fine.

---

## 🔍 Check yourself

- [ ] Without running them — what does `git diff` compare? And `git diff --staged`?
- [ ] `git log --oneline` shows ~5 commits and *no* commit called "asdfgh".
- [ ] `git status` is clean even though `dist/` and the junk file still exist on disk.
- [ ] Why do we commit `.gitignore` but not `dist/`?

## ⛰️ Level up

1. `git log --oneline --stat` — find which commit touched the most files.
2. Use `git log -S "Fluffington"` — it finds commits whose *diff contains* that string
   (the "pickaxe"). This is how you answer "when was this line added?" in real projects.
3. Try `git show HEAD~2 --stat` and explain to your rubber duck what you're looking at.

**Next:** [Lesson 3 — Undoing things](03-undoing-things.md). You'll make mistakes on purpose and erase them at all three stages.
