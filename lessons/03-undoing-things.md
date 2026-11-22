# Lesson 3 — Undoing things

## 🎯 Goal
For any mistake — unstaged, staged, or committed — you know the right undo command and,
just as important, which ones are **destructive**.

## 🧰 New tools
`git restore` · `git restore --staged` · `git reset` (soft / mixed / hard) · `git revert`

*Prerequisite: `playground/` from Lesson 2.*

---

## The undo map

A mistake lives in one of the three areas. Each has its own eraser:

| The mistake is... | Undo with | Destroys work? |
|---|---|---|
| in the working directory (not staged) | `git restore <file>` | ⚠️ YES — edits gone |
| staged (added, not committed) | `git restore --staged <file>` | No — just un-carts it |
| committed, only on my machine | `git reset` | depends on flavor |
| committed and shared/pushed | `git revert` | No — adds an anti-commit |

---

## 🔨 Do it

### 1. The site gets a brain — and you get a mess

Create `script.js`:

```js
const cats = ["Sir Fluffington III", "Baron von Whiskers", "Miss Marple the Tabby"];

function featuredCat() {
  const today = new Date().getDate();
  return cats[today % cats.length];
}

document.addEventListener("DOMContentLoaded", () => {
  const strong = document.querySelector("strong");
  if (strong) strong.textContent = featuredCat();
});
```

Add before `</body>` in `index.html`:

```html
  <script src="script.js"></script>
```

Commit this working state — a clean commit is your safety net for the chaos ahead:

```powershell
git add .
git commit -m "Rotate featured cat daily via script"
```

Refresh the browser: the featured cat now changes with the date.

### 2. Undo level 1: ruin a file, restore it

Open `script.js` and vandalize it — delete half the lines, type garbage. Confirm the
damage with `git diff`. Now:

```powershell
git restore script.js
git diff        # silence — the file matches the last commit again
```

`restore` copies the file back out of the last snapshot. Your vandalism is **gone
forever** — Git never saw it (it was never added), so Git can't get it back. This is
the one everyday command that truly destroys work. Respect it.

### 3. Undo level 2: un-stage without losing anything

Add a useful line to `script.js` (e.g. a fourth cat in the array) and also create
`secret-passwords.txt` with anything inside. Then be careless:

```powershell
git add .
git status      # both staged — but the secrets must NOT be committed!
```

```powershell
git restore --staged secret-passwords.txt
git status
```

The secrets file is back to untracked; your `script.js` change stays staged. Nothing
was deleted — `--staged` only takes things out of the cart. Clean up and commit:

```powershell
Remove-Item secret-passwords.txt
git commit -m "Add fourth cat to rotation"
```

### 4. Undo level 3: the commit itself was a mistake — `git reset`

Make a commit you'll regret. Add to `index.html` before `</body>`:

```html
  <marquee>🔥🔥 BEST CAT SITE EVER — CLICK NOW 🔥🔥</marquee>
```

```powershell
git add .
git commit -m "Add tasteful advertising"
git log --oneline
```

`reset` moves your branch back to an older commit. The three flavors differ only in
what happens to the changes from the abandoned commit:

```powershell
git reset --soft HEAD~1     # commit undone; changes kept, still staged
git status                  # see it, then re-commit? no — reset again:
git reset HEAD~1            # (default = --mixed) changes kept, unstaged
git status
```

Run those one at a time and read `status` after each. Finally decide the marquee must die:

```powershell
git reset --hard HEAD       # make working dir match the current commit exactly
git status                  # clean; marquee gone from the file too
```

Summary — `reset <target>` moves the branch, then:
- `--soft` — touch nothing else (changes stay staged)
- `--mixed` — clear the staging area (changes stay in files) ← default
- `--hard` — ⚠️ make files match too. **Destroys uncommitted work.**

### 5. Undo level 4: the commit is already public — `git revert`

Once a commit is shared with teammates (Lesson 9), you must not make it vanish — their
repos still have it, and chaos follows. Instead, revert: **a new commit that does the
opposite.**

Commit a bad idea:

```html
  <p style="font-size: 60px">SUBSCRIBE TO OUR NEWSLETTER!!!</p>
```

```powershell
git add .
git commit -m "Add newsletter banner"
git revert HEAD --no-edit
git log --oneline
```

History now shows **both** commits: "Add newsletter banner" *and* "Revert 'Add newsletter
banner'". The file is clean, and the historical record is honest. That's the difference:
`reset` rewrites the past, `revert` adds to it.

---

## 🔍 Check yourself

Cover the table above and answer:
- [ ] You edited a file into a mess, never staged it. Command?
- [ ] You staged a file that must not be committed. Command?
- [ ] Your last (unshared) commit should not exist, but you want to keep the code. Command + flag?
- [ ] A commit from last week is already on the team server and it's wrong. Command?
- [ ] Which two commands in this lesson can permanently destroy work? (`restore <file>`,
      `reset --hard`.)

## ⛰️ Level up

`git restore` can pull a file from **any** commit, not just the last one:
`git restore --source HEAD~3 style.css` puts the 3-commits-ago version of the stylesheet
in your working directory (nothing is committed — it's just a modified file now).
Use it to look at your old CSS, then `git restore style.css` to snap back. This is how
you recover "the version from before the redesign" in real life.

**Next:** [Lesson 4 — Branches](04-branches.md). The killer feature. Everything so far
was one straight line; now the timeline forks.
