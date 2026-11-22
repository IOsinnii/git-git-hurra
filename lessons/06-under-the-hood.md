# Lesson 6 — Under the hood: blobs, trees, commits, refs

## 🎯 Goal
You stop believing in magic. You can explain what a commit *physically is*, what a
**tree** is, why hashes look like that, and what `HEAD` really points to. After this
lesson, every weird Git behavior becomes predictable.

## 🧰 New tools
`git cat-file -t / -p` · `git hash-object` · `git ls-tree` · `rev-parse` ·
reading `.git/` with your own eyes

*Prerequisite: `playground/` from Lesson 5. No new website code today — today we dissect.*

---

## The big secret

Git is not a "diff manager". Underneath, Git is a tiny **content-addressed database**
storing exactly four kinds of objects:

| Object | Stores | Analogy |
|---|---|---|
| **blob** | contents of one file (no name!) | a file's body in a jar |
| **tree** | a directory: names + permissions → pointers to blobs/subtrees | a folder listing |
| **commit** | pointer to one tree + parent commit(s) + author + message | a labeled snapshot |
| tag | a named, signed pointer (Lesson 8) | a wax seal |

Every object is named by the **SHA-1 hash of its own content**. Same content ⇒ same
hash, always, on every computer on Earth. Different content ⇒ different hash. The hash
*is* the address. That's the whole trick.

---

## 🔨 Do it

### 1. Hash something by hand

```powershell
"hello cats" | git hash-object --stdin
```

You get `a30e35f...` (some 40-hex-character hash). Run it again — **same hash**. Ask a
friend on a Mac to run it — same hash. Content determines identity.

### 2. Dissect a real commit

```powershell
git log --oneline -1        # note the hash of your newest commit, e.g. f3a91c2
git cat-file -t f3a91c2     # -t = type → "commit"   (use YOUR hash)
git cat-file -p f3a91c2     # -p = pretty-print the contents
```

You'll see something like:

```
tree 8f2d1b4...
parent 1a2b3c4...
parent 9d8e7f6...          ← two parents? then it's your merge commit from Lesson 5!
author You <you@example.com> 1720425600 +0200
committer You <you@example.com> 1720425600 +0200

Merge branch 'navbar'
```

A commit is **five lines of text**. No diffs, no file contents — just a pointer to a
`tree`, pointer(s) to parent(s), who, when, why.

### 3. Follow the tree 🌳

Take the `tree` hash from the commit and open it:

```powershell
git cat-file -p 8f2d1b4     # YOUR tree hash
```

```
100644 blob e69de29...    .gitignore
100644 blob 7c4a013...    about.html
100644 blob 9ab8f21...    index.html
100644 blob 4d5e6f7...    script.js
100644 blob 2b3c4d5...    style.css
```

**This is a tree object: a snapshot of one directory** — filenames, modes, and the hash
of each file's blob. If you had a subfolder, it would appear here as another `tree`,
which contains its own listing — trees nest, exactly like folders. Now open a blob:

```powershell
git cat-file -p 9ab8f21    # YOUR index.html blob hash
```

Your actual HTML, verbatim. So the full chain of custody is:

```
branch → commit → tree → (subtrees →) blobs
"main"    who/when   folder        file
          /why       structure     contents
```

Two beautiful consequences, now obvious:

- **Unchanged files are free.** New commit, but `style.css` didn't change? Same content
  ⇒ same blob hash ⇒ the new tree just points at the *existing* blob. Nothing is copied.
  That's why 10,000 commits don't take 10,000× the space.
- **History is tamper-proof.** The commit hash covers the tree hash, which covers every
  blob hash, plus the parent hash — change one byte anywhere in history and every hash
  after it changes. A commit hash is a fingerprint of *the entire past*.

Compare two commits' trees quickly:

```powershell
git ls-tree HEAD            # tree of the newest commit
git ls-tree HEAD~3          # three commits ago — spot the differing blob hashes
```

### 4. Branches with your own eyes

You were promised a branch is a 41-byte file. Collect:

```powershell
Get-Content .git\refs\heads\main      # ...it's just a commit hash + newline
git rev-parse main                    # same hash, asked politely
git switch -c demo
Get-Content .git\refs\heads\demo      # same hash — new sticky note, same commit
```

Make any commit on `demo` (touch a file, add, commit) and re-read both files: `demo`
moved, `main` didn't. *That's all branching is.* Switch back to `main` and
`git branch -D demo`. The file under `refs/heads/` disappears — that's the deletion.

### 5. And HEAD?

```powershell
Get-Content .git\HEAD
```

```
ref: refs/heads/main
```

`HEAD` is a file containing *the name of the branch you're on*. The full chain:
**HEAD → branch → commit → tree → blobs.** When you `git switch`, Git rewrites this one
line and rebuilds your working directory from the target commit's tree. When you
commit, Git creates blob(s) + tree(s) + a commit, then moves the branch that HEAD names.
Every command you've learned is just choreography of these pointers.

---

## 🔍 Check yourself

- [ ] What are the four object types, and what does each store?
- [ ] Where are file *names* stored — in blobs or trees? (Trees! A blob is anonymous content.)
- [ ] Why does renaming a file not duplicate its storage? (New tree entry, same blob.)
- [ ] How many parents does a merge commit have? How did you verify it?
- [ ] What is `HEAD`? What is a branch? (One-line files of pointers.)

## ⛰️ Level up

1. `git cat-file -p main^{tree}` — a shortcut straight to a branch's tree.
2. Create a folder `pages/`, move `about.html` into it (`git mv about.html pages/about.html`,
   fix the links, commit). Now `git cat-file -p HEAD^{tree}` shows a **tree pointing to a
   tree** — print the subtree too. Check that `about.html`'s blob hash is *unchanged*
   (the move cost ~zero bytes: same blob, new tree entry).
3. Count all objects in your database: `git count-objects -v`.

**Next:** [Lesson 7 — Rewriting history](07-rewriting-history.md). Now that you know
commits are immutable objects and branches are pointers, "rewriting history" will make
sense: you never *edit* commits — you build new ones and move the sticky notes.
