# Lesson 5 — Merge conflicts

## 🎯 Goal
Merge conflicts stop being scary. You can read conflict markers, resolve them calmly,
and bail out when you'd rather not.

## 🧰 New tools
three-way merge (merge commits) · conflict markers · `git merge --abort` ·
`git log --graph` (for real this time)

*Prerequisite: `playground/` from Lesson 4, on `main`, clean status.*

---

## When merges stop being "fast-forward"

Last lesson `main` politely stood still while you worked. Real life: while you build a
feature, someone (a teammate, or future-you on another branch) commits to `main`. Now
the history genuinely **forks**:

```
          o---o   feature
         /
...--o--o---o     main
```

Merging now needs a **merge commit** — a commit with *two parents* that combines both
lines. Git merges automatically when the branches touched *different* lines. When both
sides changed the **same lines**, Git refuses to guess and makes *you* decide. That's a
conflict: not an error, a question.

---

## 🔨 Do it

### 1. Set the stage: two branches touch the same file

You'll build a navigation bar on a branch, while "someone" edits the same header area
on `main`. There's a script that plays that someone:

```powershell
git switch -c navbar
```

In `index.html`, replace the `<h1>` line **and** the About link line with:

```html
  <nav>
    <a href="index.html">Home</a> |
    <a href="about.html">About</a>
  </nav>
  <h1>Cats of the Internet</h1>
```

```powershell
git add index.html
git commit -m "Add navigation bar"
```

Now simulate the meddling teammate on `main` (run from `playground/`):

```powershell
..\scripts\lesson-05-teammate.ps1
```

(The script switches to `main`, changes the `<h1>` text to something fancier, commits,
and leaves you back on `main`. Read the script — it's 10 lines.)

Look at the fork you created:

```powershell
git log --oneline --graph --all
```

Two lines diverging from a common ancestor. This picture is the whole lesson.

### 2. Merge and hit the conflict

You're on `main`. **Predict first:** both branches edited the `<h1>` line. What happens?

```powershell
git merge navbar
```

```
CONFLICT (content): Merge conflict in index.html
Automatic merge failed; fix conflicts and then commit the result.
```

Don't panic — first, gather information:

```powershell
git status
```

Status says exactly what's going on: *"You have unmerged paths"*, `index.html` is
*"both modified"*, and it tells you the way out (*fix conflicts and run `git commit`*).

### 3. Read the battlefield

Open `index.html`. Git wrote both versions into the file, fenced with markers:

```
<<<<<<< HEAD
  <h1>😻 Cats of the Internet — now with 20% more cats</h1>
=======
  <nav>
    <a href="index.html">Home</a> |
    <a href="about.html">About</a>
  </nav>
  <h1>Cats of the Internet</h1>
>>>>>>> navbar
```

- `<<<<<<< HEAD` to `=======` — the version on the branch you're standing on (`main`)
- `=======` to `>>>>>>> navbar` — the version being merged in

Your job: **edit this into what the file should actually say**, then delete all three
marker lines. Usually the right answer is neither side verbatim but a combination:

```html
  <nav>
    <a href="index.html">Home</a> |
    <a href="about.html">About</a>
  </nav>
  <h1>😻 Cats of the Internet — now with 20% more cats</h1>
```

(Navbar from your branch, fancy title from the teammate. Everyone wins.)

Refresh the browser to confirm the page looks right — the file is just a normal file
right now, and *the browser doesn't lie*.

### 4. Tell Git you've decided

```powershell
git add index.html      # "this file's conflict is resolved"
git status              # "All conflicts fixed but you are still merging"
git commit --no-edit    # completes the merge with a default message
git log --oneline --graph
```

The graph shows the diamond: fork, two lines, and a **merge commit** joining them.
Delete the branch: `git branch -d navbar`.

### 5. The eject button

Create another conflict quickly (or just remember this): if you're mid-conflict and
overwhelmed —

```powershell
git merge --abort
```

— returns everything to the moment before `git merge`. No shame in it. Regroup, look at
both branches with `git diff main..navbar`, try again.

---

## 🔍 Check yourself

- [ ] What makes a merge produce a conflict? (Both branches changed the *same lines* —
      or one deleted a file the other edited.)
- [ ] In the markers, which chunk is yours and which is theirs?
- [ ] The three-step resolution dance: edit file → `git add` → `git commit`.
- [ ] Panic button? (`git merge --abort`.)
- [ ] Is a conflict an error? (No — a question only a human can answer.)

## ⛰️ Level up

Engineer a conflict where branch A **edits** `about.html` while branch B **deletes** it,
then merge. Read `git status` carefully — this is a *modify/delete* conflict and there
are no `<<<<<<<` markers at all; you resolve it purely with `git add about.html` (keep)
or `git rm about.html` (delete), then commit. Decide like a product owner.

**Next:** [Lesson 6 — Under the hood](06-under-the-hood.md). We open the `.git` folder
and meet the objects everything so far was made of: blobs, **trees**, commits, refs.
