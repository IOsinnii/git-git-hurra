# Lesson 9 — Remotes: publishing your work

## 🎯 Goal
You understand what GitHub-like services actually are (no magic: just another Git repo),
and you can clone, push, pull, and fetch — including the classic "push rejected" moment
and what it means.

## 🧰 New tools
bare repositories · `git clone` · `git remote` · `git push` · `git fetch` · `git pull` ·
`origin`, tracking branches, `origin/main`

*Prerequisite: `playground/` from Lesson 8. Everything happens on your disk — no account,
no network needed. That's the point: a "server" is just a repo in another folder.*

---

## Demystifying GitHub in one paragraph

A remote is **any other copy of the repository** that you exchange commits with. GitHub
is a computer running a plain Git repository plus a pretty website around it. The
repository on the server is **bare**: it has the `.git` database (objects, refs — all of
Lesson 6) but *no working directory*, because nobody edits files on the server — it
exists only to receive and serve commits. We'll build one right now, three folders away.

---

## 🔨 Do it

### 1. Create your own "GitHub" and connect to it

From the course root (`git-git-hurra`):

```powershell
git init --bare -b main hub.git
```

(`-b main` names its default branch explicitly, so it matches yours no matter what your
global config says.) Peek inside `hub.git` — recognize `refs/`, `HEAD`, `objects/` from Lesson 6? It's the
*inside* of a `.git` folder, promoted to be the whole repo. Now tell your playground
about it:

```powershell
cd playground
git remote add origin ..\hub.git
git remote -v
```

`origin` is not a keyword — just the conventional nickname for "the main remote".
(A repo can have several remotes; each is just a name → location pair.)

### 2. Push: publish your commits

```powershell
git push -u origin main
git push origin v1.0            # tags are not pushed by default
```

Push copies your commits (objects!) to the remote and moves the remote's `main` ref.
The `-u` (once per branch) links your `main` to `origin/main` so future `git push` /
`git pull` need no arguments. Check the log:

```powershell
git log --oneline -3
```

Note the decoration: `(HEAD -> main, origin/main)`. **`origin/main` is a new kind of
pointer**: *"where `main` was on the remote, last time I looked."* Git never moves it by
itself — only `push`/`fetch`/`pull` update it.

### 3. Clone: be your own teammate

From the course root:

```powershell
cd ..
git clone hub.git playground-colleague
cd playground-colleague
git log --oneline -5
```

A clone = full copy of the database + a checkout + `origin` already pointing back where
it came from. This is exactly what happens when anyone clones from GitHub. You now have
the setup of every real project: **central bare repo, two developers** (both of them you).

### 4. The full round trip

As the *colleague* (in `playground-colleague/`), add a footer to `index.html` before
`</body>`:

```html
  <footer>
    <p>© 2026 Cats of the Internet — no cats were harmed.</p>
  </footer>
```

```powershell
git add index.html
git commit -m "Add footer with copyright"
git push
```

Now switch hats — back in `playground/`:

```powershell
cd ..\playground
git log --oneline -2      # no footer commit. Of course: nothing moves automatically
git fetch
git log --oneline --all -3
```

After `fetch`: the footer commit **is in your database** and `origin/main` points at it,
but your `main` (and your files) haven't moved. Fetch = *download news, change nothing*.
Look at what's incoming, then integrate:

```powershell
git log main..origin/main --oneline    # "what do they have that I don't?"
git merge origin/main                  # fast-forward
```

`git pull` is exactly `fetch` + `merge` in one step. Use `pull` for convenience;
remember it's two steps so that when something goes odd, you can reason about it.

### 5. The rite of passage: push rejected

Both developers now commit without syncing first. In `playground/`, change the footer
year to 2027, commit (`"Update copyright year"`), **don't push yet**. Then run the
teammate script (it makes the *colleague* clone commit a `<a href="#top">` back-to-top
link into the footer and push it):

```powershell
..\scripts\lesson-09-teammate.ps1
```

Now push yours:

```powershell
git push
```

```
! [rejected]  main -> main (fetch first)
```

Read the message — Git refuses because the remote has commits you've never seen;
pushing would require the server to either discard them or merge, and **a bare repo
never merges** (no working directory — nowhere to resolve conflicts). *You* integrate,
locally, then push a history that already contains everything:

```powershell
git pull --no-rebase        # fetch + merge; both touched the footer → maybe a conflict!
                            # if so: resolve exactly like Lesson 5, add, commit
git log --oneline --graph -5
git push                    # accepted
```

That's the eternal rhythm of collaboration: **pull, resolve locally, push.** The server
stays dumb; humans (and their working directories) do the thinking.

---

## 🔍 Check yourself

- [ ] What's in a bare repo, and what's missing? Why is it missing?
- [ ] What is `origin`? What is `origin/main`, and who moves it?
- [ ] `fetch` vs `pull` — precise difference?
- [ ] Why was your push rejected, and why is that Git protecting you?
- [ ] Does `git commit` send anything anywhere? (No. Local until pushed — which is also
      why amend/rebase were safe all this time.)

## ⛰️ Level up

1. In the colleague clone, run `git fetch` then `git log --oneline main..origin/main`
   and the reverse `origin/main..main` — read both directions of "who's ahead".
2. Push a *branch*: create `experiment` in one clone, `git push -u origin experiment`,
   then in the other clone `git fetch` + `git switch experiment`. Notice Git
   auto-creates the local branch tracking the remote one.
3. Delete it remotely when done: `git push origin --delete experiment`.

**Next:** [Lesson 10 — Working in a team](10-team-workflow.md): the branch-review-merge
cycle every software team runs daily, plus your capstone.
