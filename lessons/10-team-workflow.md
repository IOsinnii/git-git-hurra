# Lesson 10 — Working in a team: the full workflow

## 🎯 Goal
You can run the complete professional cycle — feature branch → push → review → merge →
sync — and you graduate by shipping a feature end-to-end with a (simulated) teammate
committing around you.

## 🧰 New tools
No new commands. Today is choreography: everything from Lessons 1–9, in the order real
teams use it.

*Prerequisite: `playground/`, `playground-colleague/`, and `hub.git` from Lesson 9,
everything pushed, both clones in sync (`git pull` in both).*

---

## The feature-branch workflow

Every serious team, whatever they call it (GitHub Flow, trunk-based, ...), runs some
version of this loop:

```
        ①  git switch main; git pull            (start fresh)
        ②  git switch -c feature/<name>          (branch off)
        ③  ...work, commit, work, commit...      (small commits)
        ④  git push -u origin feature/<name>     (publish the branch)
        ⑤  open a Pull Request                   (ask for review)
        ⑥  review, discuss, fix, push again      (the PR updates)
        ⑦  merge into main (often squash-merged) (ship it)
        ⑧  delete the branch; everyone pulls     (back to ①)
```

`main` is sacred: nothing lands on it except reviewed merges. A **Pull Request** is not
a Git feature — it's a website feature (GitHub/GitLab) wrapped around `git merge`, adding
discussion and approval. Since our "hub" has no website, one of your two personas will
play reviewer — which is a feature, not a bug: you'll see exactly which parts are Git
and which parts are GitHub.

---

## 🔨 Do it — ship the gallery, by the book

### ① – ③ Developer you: build on a branch

In `playground/`:

```powershell
git switch main
git pull
git switch -c feature/gallery
```

Create `gallery.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Gallery — Cats of the Internet</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <h1>Cat Gallery</h1>
  <div class="gallery">
    <figure><span class="cat-emoji">😸</span><figcaption>Sir Fluffington III</figcaption></figure>
    <figure><span class="cat-emoji">😼</span><figcaption>Baron von Whiskers</figcaption></figure>
    <figure><span class="cat-emoji">😺</span><figcaption>Miss Marple the Tabby</figcaption></figure>
  </div>
  <p><a href="index.html">← Back home</a></p>
</body>
</html>
```

Commit. Then style it — append to `style.css`:

```css
.gallery {
  display: flex;
  gap: 1rem;
}

.gallery figure {
  margin: 0;
  text-align: center;
}

.cat-emoji {
  font-size: 4rem;
}
```

Commit. Then add `| <a href="gallery.html">Gallery</a>` to the nav in `index.html`.
Commit. Three commits, each one coherent — review your own story:

```powershell
git log --oneline main..HEAD     # exactly what the "PR" will contain
git diff main...HEAD --stat      # and its total footprint
```

*(Optional polish, Lesson 7 style: `git rebase -i main` to squash/reword before
publishing. This is the last cheap moment to do it — the branch isn't pushed yet.)*

### ④ – ⑤ Publish and "open the PR"

```powershell
git push -u origin feature/gallery
```

On GitHub you'd now click "Create Pull Request". Here, the PR is a message you imagine
sending: *"feature/gallery ready for review — adds gallery page, styles, nav link."*

### ⑥ Reviewer you: check out the branch and review

Switch hats. In `playground-colleague/`:

```powershell
git fetch
git switch feature/gallery
git log --oneline main..HEAD          # read the story
git diff main...feature/gallery      # read every changed line, like a reviewer
```

Open `gallery.html` in the browser — reviewers run the code. Verdict: nice, but the
gallery wraps badly on small screens. Request a change! ...and as developer-you (back in
`playground/`), address it — append to `style.css`:

```css
.gallery {
  flex-wrap: wrap;
}
```

```powershell
git add style.css
git commit -m "Allow gallery to wrap on narrow screens"
git push                              # the "PR" updates automatically
```

Reviewer pulls (`git pull` in the colleague clone, still on `feature/gallery`),
re-checks, approves. ✅

### ⑦ – ⑧ Merge, ship, clean up

The reviewer (or a bot) merges. In `playground-colleague/`:

```powershell
git switch main
git pull
git merge feature/gallery --no-ff -m "Merge feature/gallery: cat gallery page"
git push
git push origin --delete feature/gallery
git branch -d feature/gallery
```

(`--no-ff` forces a merge commit even when fast-forward is possible — many teams want
the "this was one reviewed unit" diamond visible in the graph forever.)

Developer-you syncs and prunes:

```powershell
cd ..\playground
git switch main
git pull
git branch -d feature/gallery
git fetch --prune                     # forget remote branches that no longer exist
git log --oneline --graph -8
```

Look at that graph. That diamond is a shipped, reviewed feature. **That's the loop.
You now know the workflow used to build approximately all modern software.**

### 🎓 Capstone: one more feature, under fire

Prove it — ship one more feature with zero hand-holding, while the teammate script
periodically pushes to `main` around you (run it once *before* you branch and once
*while* your branch is unpushed, to guarantee you'll need to sync):

```powershell
..\scripts\lesson-10-teammate.ps1
```

Your mission, using only the loop above: add a **"Cat of the Month"** section to the
homepage (any HTML/CSS you like) via `feature/cat-of-the-month`, get it reviewed by
colleague-you, handle whatever conflicts the teammate causes (Lessons 5/9), and merge
it clean. If anything goes sideways: `git status` first, reflog if desperate (Lesson 8).

When your graph shows the merged feature and both clones are in sync — **you've
graduated.** 🎉

---

## 🔍 Check yourself — final exam (no peeking)

1. The three areas, and the command moving a change between each pair.
2. Fast-forward vs three-way merge vs rebase — draw the resulting graphs.
3. What is physically inside a commit object? A tree object? What does a branch file
   under `.git/refs/heads/` contain?
4. Undo matrix: wrong unstaged edit / wrong staged file / bad local commit / bad pushed
   commit — one command each.
5. Why does a push get rejected, and what's the fix?
6. When is rebase forbidden, and what do you do instead?

## Where to go next

- **[Palmer Penguins capstone](../extras/penguins-capstone.md)** — replay the whole
  ladder in one hour on a data-science project. Highly recommended: skills transfer to
  a second domain is when they become permanent.
- Get a real [GitHub](https://github.com) account, push `playground` there
  (`git remote add github <url>`, `git push github main`), and open a real PR — every
  step will feel familiar, because you've already done all of it. That's the hurra. 🐈
