# Lesson 8 — The rescue kit: stash, tags, reflog, worktrees

## 🎯 Goal
You can pause work instantly, mark releases, recover "permanently lost" commits, and
have two branches checked out at once. After this lesson you are functionally
un-breakable in a local repo.

## 🧰 New tools
`git stash` · `git tag` (lightweight & annotated) · `git reflog` · `git worktree`

*Prerequisite: `playground/` from Lesson 7, on `main`, clean status.*

---

## 🔨 Do it

### 1. Stash: the "someone's at the door" command

Start building dark mode. Add to `style.css`:

```css
@media (prefers-color-scheme: dark) {
  body {
    background: #1a1a2e;
    color: #eee;
  }
```

(Yes, missing closing brace — you're *mid-thought*.) Suddenly: "URGENT — typo on the
About page, fix it NOW." Your options so far were bad: commit half-broken work, or lose
it. Enter stash:

```powershell
git stash push -m "dark mode, half done"
git status                    # clean! the mess is on a shelf
```

Fix the emergency: correct any word in `about.html` (pretend it was a typo), then:

```powershell
git add about.html
git commit -m "Fix typo on about page"
```

Get your work back:

```powershell
git stash list                # stash@{0}: On main: dark mode, half done
git stash pop                 # reapplies AND removes from the shelf
git status                    # style.css modified again, mid-thought restored
```

Now finish dark mode properly — close the brace, and add a dark style for headings:

```css
  h1 {
    color: #a5b4fc;
  }
}
```

```powershell
git add style.css
git commit -m "Add dark mode via prefers-color-scheme"
```

(`stash apply` = reapply but keep the shelf copy; `stash drop` = discard. Stash is a
shelf, not an archive — for anything you care about overnight, prefer a branch.)

### 2. Tags: naming a release

The site has pages, style, script, dark mode — call it a release. Two kinds of tag:

```powershell
git tag v1.0 -a -m "First public release: 3 pages, dark mode"   # annotated
git tag quick-bookmark                                          # lightweight
git tag
git show v1.0
```

An annotated tag is a real object (the 4th type from Lesson 6!) with author, date,
message — use it for releases. A lightweight tag is just a sticky note like a branch,
except **it never moves**. Branches advance with commits; tags stay planted forever.
Clean up the throwaway: `git tag -d quick-bookmark`.

### 3. Reflog: the undo for your undos

Time to answer Lesson 4's cliffhanger. Stage a disaster:

```powershell
git switch -c doomed
```

Create `masterpiece.txt` containing your finest ASCII cat, commit it
(`git commit -m "My masterpiece"` after adding). Now destroy it the worst way possible:

```powershell
git switch main
git branch -D doomed          # -D: no safety catch, unmerged, GONE
git log --oneline --all       # masterpiece: nowhere. Panic? No.
```

The commit object still exists (Lesson 6: objects aren't deleted, only unreferenced).
You just need its hash. Git kept a diary of **every position HEAD has ever had**:

```powershell
git reflog
```

```
3f9e2d1 HEAD@{0}: checkout: moving from doomed to main
a7c5b12 HEAD@{1}: commit: My masterpiece        ← there it is
...
```

Resurrect:

```powershell
git branch doomed-reborn a7c5b12    # YOUR hash from the reflog
git switch doomed-reborn
ls                                  # masterpiece.txt lives
```

**This works for almost every disaster**: branch deleted, `reset --hard` too far, botched
rebase (the pre-rebase commits are all in the reflog). The reflog keeps entries ~90 days.
The only things it cannot save: changes that were *never committed* (Lesson 3's
`restore` / `reset --hard` warnings stand). Corollary: **commit early, commit often —
any committed state is recoverable for months.**

Merge the masterpiece if you like it, or clean up:
`git switch main`, `git branch -D doomed-reborn`.

### 4. Worktrees: two branches at once

Sometimes `switch` isn't enough — you want the release *and* your work-in-progress open
side by side (e.g., to compare in two browser tabs, or to hotfix v1.0 while mid-feature
without stashing). A **worktree** is a second working directory attached to the *same*
repository:

```powershell
git worktree add ..\playground-v1 v1.0
```

Look in the parent folder: a full checkout of `v1.0` in `playground-v1/`, while
`playground/` stays on `main`. Open both `index.html`s in two tabs — two versions of
the site, live, same repo, one `.git` object database (Lesson 6 explains why that's
cheap: same blobs). Commits made in either worktree are instantly visible in the other's
`git log`.

```powershell
git worktree list
git worktree remove ..\playground-v1
```

---

## 🔍 Check yourself

- [ ] Mid-messy-edit, urgent interruption. Two commands to shelve and later restore?
- [ ] Branch vs tag — both are pointers; the difference? (Branches move, tags don't.)
- [ ] You `reset --hard` and lost three committed commits. Recovery plan? (reflog →
      find hash → `git branch rescue <hash>`.)
- [ ] What can the reflog **not** recover?
- [ ] When is a worktree better than `git switch`?

## ⛰️ Level up

1. Stash a change, then run `git stash branch dark-mode-2` — it creates a branch from
   where you stashed and pops the stash there. The professional stash exit.
2. Do a `git reset --hard HEAD~2` on purpose (on a test branch!), then restore the
   branch to exactly where it was using only the reflog.

**Next:** [Lesson 9 — Remotes](09-remotes.md). Everything so far lived on one machine.
Time to publish.
