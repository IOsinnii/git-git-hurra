# Lesson 1 — Your first repository

## 🎯 Goal
You can turn any folder into a Git repository, understand the **three areas** every file
lives in, and make clean commits.

## 🧰 New tools
`git init` · `git status` · `git add` · `git commit` · `git log --oneline`

---

## The one mental model you need today

Git tracks your project as a series of **snapshots** (commits). A file travels through
three areas on its way into a snapshot:

```
 Working directory  --git add-->   Staging area   --git commit-->   Repository
 (your real files)                (the "shopping                  (permanent
                                    cart" for the                   snapshots)
                                    next snapshot)
```

The staging area confuses beginners, so remember: **`add` puts things in the cart,
`commit` checks out the cart.** You choose what goes in each snapshot.

---

## 🔨 Do it

### 1. Create the project and the repository

From this course folder (`git-git-hurra`):

```powershell
mkdir playground
cd playground
git init
```

Git replies `Initialized empty Git repository in ...playground/.git/`.
That hidden `.git` folder **is** the repository — everything Git knows lives there.
Your files stay ordinary files; Git just watches the folder.

```powershell
git status
```

Read the output. It says: on branch `main`, no commits yet, nothing to commit. Git status
always tells you three things: *where you are, what changed, and what to do about it.*

### 2. Build something worth saving

Create `index.html` inside `playground/`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Cats of the Internet</title>
</head>
<body>
  <h1>Cats of the Internet</h1>
  <p>A very serious catalog of very serious cats.</p>
</body>
</html>
```

Open it in a browser (double-click the file) — a real, working web page.

### 3. Watch the file travel through the three areas

**Predict first:** what will `git status` say now? Then run it.

```powershell
git status
```

`index.html` is **untracked** — Git sees it but has never been told to care about it.
Put it in the cart, then check status again:

```powershell
git add index.html
git status
```

Now it's under *"Changes to be committed"* — staged. Take the snapshot:

```powershell
git commit -m "Add homepage skeleton"
```

The `-m` message answers *"what does this snapshot do?"*. Write it in the imperative,
like an order: "Add homepage", "Fix typo" — not "added" or "adding". That's the
convention the whole industry uses.

### 4. Prove the snapshot exists

```powershell
git log --oneline
git status
```

One commit with a random-looking ID (a *hash* — its true name, more in Lesson 6), and a
clean status: *"nothing to commit, working tree clean"*. Working tree clean = your files
exactly match the last snapshot. This is the calm, safe state.

### 5. The edit-stage-commit loop

Add a second cat-related paragraph to `index.html`, e.g.:

```html
  <p>Today's featured cat: <strong>Sir Fluffington III</strong>.</p>
```

Then run the loop you'll run thousands of times in your career:

```powershell
git status              # index.html is "modified"
git add index.html
git commit -m "Feature Sir Fluffington on the homepage"
git log --oneline       # two commits now
```

---

## 🔍 Check yourself

- [ ] `git log --oneline` shows exactly **2** commits, newest on top.
- [ ] `git status` says *working tree clean*.
- [ ] In one sentence each: what do `add` and `commit` do? (Cart / checkout.)
- [ ] Why does the staging area exist at all? (So a snapshot contains what you *choose*,
      not just everything that happens to be modified.)

## ⛰️ Level up

Create a second file `notes.txt` with your grocery list. Modify `index.html` too.
Now make **two separate commits**: one containing only the HTML change, one containing
only the notes file — without ever committing them together. (Hint: `git add` takes
specific filenames. That's the whole point of the cart.)
Then delete `notes.txt`, run `git status`, and figure out how to commit the deletion.
(Hint: `git add notes.txt` works on deleted files too — you're staging *the change*,
not the file.)

**Next:** [Lesson 2 — Reading history](02-reading-history.md), where the project gets
style and you get X-ray vision into what changed.
