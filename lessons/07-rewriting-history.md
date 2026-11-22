# Lesson 7 — Rewriting history

## 🎯 Goal
You can turn a messy pile of work-in-progress commits into a clean, reviewable story —
and you know the one iron rule about when rewriting is forbidden.

## 🧰 New tools
`git rebase` · `git rebase -i` (squash, reword, drop, reorder) · `git cherry-pick`

*Prerequisite: `playground/` from Lesson 6, on `main`, clean status. Lesson 6's insight —
commits are immutable, branches are movable pointers — is doing all the work today.*

---

## "Rewriting" is a lie (a useful one)

Commits are content-addressed objects — they **cannot be changed** (Lesson 6). Every
"history rewriting" command actually does this: *manufacture new commits that look the
way you want, then move your branch pointer to the new ones.* The old commits still
exist, unreferenced, until garbage collection. Keep that image and nothing in this
lesson is scary.

**The iron rule:** rewrite only commits that exist *solely on your machine*. Once a
commit is pushed and teammates build on it, rewriting it forces everyone into
repair work. Local = your drafts, rewrite freely. Pushed = published, use `revert`.

---

## 🔨 Do it

### 1. Produce an honest mess

Real feature development is messy. Recreate that honestly — build a Contact page in
sloppy increments:

```powershell
git switch -c contact-page
```

Commit 1 — create `contact.html` with a typo (`Contcat`) in the `<h1>`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Contact — Cats of the Internet</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Contcat us</h1>
  <p>Email: meow@cats.example</p>
  <p><a href="index.html">← Back home</a></p>
</body>
</html>
```

```powershell
git add contact.html
git commit -m "wip contact"
```

Commit 2 — fix the typo (`Contcat` → `Contact`):

```powershell
git add contact.html
git commit -m "typo"
```

Commit 3 — add the nav link in `index.html` (add `| <a href="contact.html">Contact</a>`
inside the `<nav>`):

```powershell
git add index.html
git commit -m "link contact from nav"
```

Meanwhile, `main` moved on (the teammate script commits a small CSS improvement to `main`):

```powershell
..\scripts\lesson-07-teammate.ps1
git log --oneline --graph --all     # forked again, like Lesson 5
```

### 2. Rebase: replay your work on the new base

You *could* merge `main` into your branch (fine, common). Rebase is the tidier
alternative: **pick up your three commits and replay them on top of the new `main`**,
as if you'd started today.

```powershell
git switch contact-page
git rebase main
git log --oneline --graph --all
```

The fork is gone — one straight line, your three commits sitting on top of the
teammate's CSS commit. Check the hashes of your three commits against before: **all
new**. New parents ⇒ new content ⇒ new hashes. Freshly manufactured commits, old ones
abandoned. (If a conflict appears: resolve like Lesson 5, then `git rebase --continue`;
eject button is `git rebase --abort`.)

### 3. Interactive rebase: edit the story before publishing

"wip contact / typo / link contact from nav" is a shameful story for reviewers. A typo
fix for a typo *introduced in the same branch* is noise — squash it away:

```powershell
git rebase -i main
```

Your editor opens with the three commits, **oldest first**:

```
pick a1a1a1a wip contact
pick b2b2b2b typo
pick c3c3c3c link contact from nav
```

It's a *script* Git will execute. Edit it to:

```
pick a1a1a1a wip contact
fixup b2b2b2b typo
reword c3c3c3c link contact from nav
```

- `fixup` — melt this commit into the previous one, discard its message
- `reword` — keep the commit, let me retype the message

Save and close. Git executes: it pauses to let you reword — write
`Link contact page from navigation`. Then fix the first commit's lazy message too:

```powershell
git rebase -i main    # change first "pick" to "reword" → "Add contact page"
git log --oneline
```

Two clean commits: `Add contact page`, `Link contact page from navigation`. *This*
is what your teammates will see. Nobody needs to know about `Contcat`. Ship it:

```powershell
git switch main
git merge contact-page        # fast-forward — rebase made that possible
git branch -d contact-page
```

### 4. Cherry-pick: steal one commit

Sometimes you want *one* commit from elsewhere — a hotfix from a feature branch, not
the whole unfinished branch.

```powershell
git switch -c half-baked
```

Make **two** commits: (1) fix something real — in `script.js`, guard against an empty
cats array (`if (cats.length === 0) return "No cats today 😿";` at the top of
`featuredCat`) — commit as `Guard against empty cat list`; (2) something unfinished —
add `<p>TODO: giant redesign</p>` to `index.html`, commit as `wip redesign`.

Now `main` wants the guard fix *today*, but not the redesign:

```powershell
git log --oneline             # copy the hash of the GUARD commit
git switch main
git cherry-pick <guard-hash>
git log --oneline             # the fix is on main; the redesign stays quarantined
```

Cherry-pick manufactures a **copy** of that commit (same change, new hash — you know
why by now) on your current branch. Clean up: `git branch -D half-baked`.

---

## 🔍 Check yourself

- [ ] What does rebase *actually* do to your commits? (Manufactures new ones on a new
      parent, moves the branch pointer; originals abandoned.)
- [ ] Merge vs rebase result: what does the graph look like after each?
- [ ] In `rebase -i`: what do `pick`, `fixup`, `reword` do? What happens if you *delete*
      a line? (That commit is dropped from history.)
- [ ] The iron rule — when must you never rebase?
- [ ] Cherry-picked commit: same hash as the original or new? Why?

## ⛰️ Level up

1. In a `rebase -i`, **reorder** two lines and see history rearranged. Then engineer a
   reorder that *conflicts* (two commits editing the same line — order matters) and
   resolve it with `git rebase --continue`.
2. Try `git commit --fixup <hash>` + `git rebase -i --autosquash main` — the
   professional's way to queue corrections to earlier commits automatically.

**Next:** [Lesson 8 — The rescue kit](08-rescue-kit.md): stash, tags, and the reflog —
the command that makes "abandoned" commits recoverable and you effectively unbreakable.
