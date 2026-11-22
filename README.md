# Git Git Hurra! 🎉

A gradual, hands-on Git course. You learn Git by **building a tiny website**, and every Git
concept appears exactly when the project makes you need it — not a moment earlier.

No prior Git knowledge required. Basic ability to create files and run terminal commands is enough.
All commands are shown for **PowerShell on Windows** (they work almost identically everywhere else).

## How this course works

- You build everything inside a `playground/` folder here (created in Lesson 1).
- Each lesson = one markdown file in `lessons/`. Do them **in order** — every lesson
  builds on the state left by the previous one.
- Each lesson has:
  - **🎯 Goal** — what you can do afterwards
  - **🧰 New tools** — the commands introduced
  - **🔨 Do it** — step-by-step build + Git work
  - **🔍 Check yourself** — how to verify you got it right
  - **⛰️ Level up** — an optional harder challenge
- The `scripts/` folder contains PowerShell scripts that simulate a **teammate** making
  commits, so you can practice collaboration and conflicts without a second human.

## The ladder

| # | Lesson | You build | You learn |
|---|--------|-----------|-----------|
| 1 | [Your first repository](lessons/01-first-repo.md) | `index.html` | `init`, `status`, `add`, `commit`, the three areas |
| 2 | [Reading history](lessons/02-reading-history.md) | `style.css` | `log`, `diff`, `show`, `.gitignore`, `commit --amend` |
| 3 | [Undoing things](lessons/03-undoing-things.md) | `script.js` | `restore`, `reset` (soft/mixed/hard), `revert` |
| 4 | [Branches](lessons/04-branches.md) | About page | `branch`, `switch`, fast-forward merge |
| 5 | [Merge conflicts](lessons/05-merge-conflicts.md) | Navigation bar | three-way merge, resolving conflicts, `merge --abort` |
| 6 | [Under the hood: Git's trees](lessons/06-under-the-hood.md) | (no new code) | blobs, **trees**, commits, refs, `HEAD`, `cat-file` |
| 7 | [Rewriting history](lessons/07-rewriting-history.md) | Contact page | `rebase`, `rebase -i`, `cherry-pick`, when NOT to rewrite |
| 8 | [The rescue kit](lessons/08-rescue-kit.md) | Dark mode | `stash`, `tag`, `reflog`, `worktree` |
| 9 | [Remotes](lessons/09-remotes.md) | Footer | bare repos, `clone`, `push`, `pull`, `fetch`, tracking branches |
| 10 | [Working in a team](lessons/10-team-workflow.md) | Gallery page | feature-branch workflow, code review, rejected pushes, the full loop |

**Bonus track:** [Palmer Penguins capstone](extras/penguins-capstone.md) — redo the whole
ladder in ~1 hour with a data-science project (Python + CSV) instead of a website.
Great as a final exam.

## Rules of the road

1. **Type every command yourself.** Copy-paste teaches your clipboard, not you.
2. **Run `git status` constantly.** Before and after almost everything. It is Git's answer
   to "wait, what just happened?"
3. **You cannot really break anything.** From Lesson 8 on you'll even know how to un-break
   the "unbreakable" — until then, worst case you delete `playground/` and redo an hour of work.
4. When a lesson says *predict first* — actually say your prediction out loud before running
   the command. This is the single highest-value habit in the course.

## Setup check

```powershell
git --version          # any version 2.30+ is fine
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

If all four run without errors, open [Lesson 1](lessons/01-first-repo.md). Hurra! 🚀
