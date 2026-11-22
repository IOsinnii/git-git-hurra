# Lesson 4 — Branches

## 🎯 Goal
You can develop a feature on a branch while `main` stays deployable, and merge it back
when it's done.

## 🧰 New tools
`git branch` · `git switch` · `git switch -c` · `git merge` (fast-forward) ·
`git branch -d` · `git log --graph`

*Prerequisite: `playground/` from Lesson 3, clean status.*

---

## Why branches exist

Right now your history is a straight line and `main` is sometimes broken mid-edit.
In real work that's unacceptable: `main` is the version that's *live* — it must always
work. So: new work happens on a **branch**, a parallel line of commits. `main` stays
untouched until the feature is finished, then the branch is **merged** in.

A branch in Git is embarrassingly cheap: it's just a **movable sticky note pointing at a
commit** (literally a 41-byte file — you'll see it with your own eyes in Lesson 6).
Creating one copies nothing. This is why Git users branch for *everything*.

---

## 🔨 Do it

### 1. See where you are

```powershell
git branch
```

One branch, `main`, with a `*` = you are here. `HEAD` points to `main`, `main` points
to the newest commit.

### 2. Branch off and build the About page

```powershell
git switch -c about-page      # -c = create AND switch to it
git branch                    # * moved
```

Create `about.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>About — Cats of the Internet</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>About this site</h1>
  <p>Founded by cat enthusiasts, for cat enthusiasts. Est. today.</p>
  <p><a href="index.html">← Back home</a></p>
</body>
</html>
```

Commit it, then link it from the homepage — add to `index.html` after the `<h1>`:

```html
  <p><a href="about.html">About us</a></p>
```

```powershell
git add about.html
git commit -m "Add about page"
git add index.html
git commit -m "Link about page from homepage"
```

### 3. The magic trick: switch back

**Predict first:** you're about to run `git switch main`. What will happen to `about.html` on your disk?

```powershell
git switch main
ls                    # about.html is GONE
git log --oneline     # the two new commits are gone too
```

Not deleted — it lives on the `about-page` branch, and `main` never had it. Switching branches rewinds your entire working directory to that branch's snapshot. Refresh the browser: the About link is gone. Switch back:

```powershell
git switch about-page
ls                    # it's back
```

Everything is exactly where you left it. **Branches are parallel universes and `switch` is the portal.** This is the moment Git clicks for most people — take a second to enjoy it.

### 4. Merge: bring the feature home

The feature is done and `main` should get it:

```powershell
git switch main             # always merge FROM the branch you're ON
git merge about-page
```

Read Git's output: `Fast-forward`. Since `main` had **no new commits** of its own while you worked, Git didn't need to combine anything — it just slid the `main` sticky note forward to where `about-page` already was. Same line, no fork, nothing could conflict.

```powershell
git log --oneline --graph --all
```

Straight line, both branch names on the same commit.

### 5. Delete the sticky note

The branch did its job:

```powershell
git branch -d about-page
git branch
```

The **commits are untouched** — you only removed a pointer. (`-d` even refuses to delete
a branch that isn't merged yet; that's the safety catch. The evil twin `-D` doesn't ask.)

---

## 🔍 Check yourself

- [ ] What is a branch, physically? (A movable pointer to a commit.)
- [ ] Feature branch workflow from memory: `switch -c` → commits → `switch main` →
      `merge` → `branch -d`.
- [ ] Why was the merge a "fast-forward"? What would break that condition?
      (Answer: new commits on `main` in the meantime — that's Lesson 5.)
- [ ] You're on a branch and files vanish after `git switch`. Are they lost?

## ⛰️ Level up

1. Create branch `experiment` , make 2 commits (any silly change), switch away, and delete it with `-D` **without merging**. The commits are now unreachable... or are they? Keep this question for Lesson 8 (reflog).
2. Run `git switch -c oldschool HEAD~5` — a branch starting *five commits in the past*.
   Look around with `ls` and `git log --oneline`, feel the time travel, switch back to
   `main`, and delete it.

**Next:** [Lesson 5 — Merge conflicts](05-merge-conflicts.md). Two branches edit the
same line, and you become the judge.
