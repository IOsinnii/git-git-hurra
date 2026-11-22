# Git cheatsheet — everything the course taught, on one page

## The three areas (L1)
```
working dir --add--> staging --commit--> repository
```
| | |
|---|---|
| `git init` | make this folder a repo |
| `git status` | where am I, what changed, what next |
| `git add <file>` / `git add .` | stage change(s) |
| `git commit -m "msg"` | snapshot the staged changes |

## Inspecting (L2)
| | |
|---|---|
| `git log --oneline` / `--stat` / `--graph --all` | history, compact / with files / drawn |
| `git log -p <file>` | every change to one file |
| `git log -S "text"` | commits whose diff contains text |
| `git diff` | working dir vs staging |
| `git diff --staged` | staging vs last commit ← run before every commit |
| `git show <commit>` | one commit in full |
| `.gitignore` | paths Git must pretend not to see (commit the file itself) |
| `git commit --amend` | replace the last (unpushed!) commit |

## Undo (L3)
| Mistake | Command | Destroys work? |
|---|---|---|
| bad unstaged edit | `git restore <file>` | ⚠️ yes |
| staged too much | `git restore --staged <file>` | no |
| bad local commit, keep changes staged | `git reset --soft HEAD~1` | no |
| bad local commit, keep changes in files | `git reset HEAD~1` | no |
| bad local commit, burn it all | `git reset --hard HEAD~1` | ⚠️ yes (uncommitted work) |
| bad **pushed** commit | `git revert <commit>` | no (adds anti-commit) |
| old version of one file | `git restore --source <commit> <file>` | overwrites working copy |

## Branches & merging (L4–L5)
| | |
|---|---|
| `git branch` | list (`*` = you are here) |
| `git switch -c <name>` | create + switch |
| `git switch <name>` | jump universes |
| `git merge <branch>` | bring branch into the one you're ON |
| `git branch -d <name>` | delete merged pointer (`-D` = don't ask) |
| `git merge --abort` | eject from a conflicted merge |
| conflict dance | edit file, remove `<<<<<<<`/`=======`/`>>>>>>>`, `git add`, `git commit` |

## Under the hood (L6)
```
HEAD → branch → commit → tree → blobs
       (.git/refs/heads/*)  (folder)  (file contents)
```
| | |
|---|---|
| `git cat-file -t <hash>` / `-p <hash>` | object type / contents |
| `git ls-tree HEAD` | the tree of a commit |
| `git rev-parse <ref>` | resolve any name to a hash |
| blob = contents, tree = names→blobs/trees, commit = tree+parents+author+msg | |

## Rewriting (L7) — local commits only!
| | |
|---|---|
| `git rebase main` | replay my branch onto new main |
| `git rebase -i main` | edit the story: `pick` `fixup` `reword` `drop`, reorder lines |
| `git rebase --continue` / `--abort` | after fixing a conflict / eject |
| `git cherry-pick <hash>` | copy one commit here |
| **Iron rule** | never rewrite pushed commits — `revert` instead |

## Rescue (L8)
| | |
|---|---|
| `git stash push -m "msg"` / `git stash pop` | shelve / restore messy work |
| `git tag v1.0 -a -m "msg"` | annotated release tag (tags never move) |
| `git reflog` | diary of every HEAD position ≈ undo for undos |
| `git branch rescue <hash>` | resurrect anything the reflog found |
| `git worktree add <path> <ref>` | second checkout, same repo |

## Remotes (L9)
| | |
|---|---|
| `git init --bare -b main hub.git` | a "server" repo (no working dir) |
| `git clone <url>` | copy repo + auto-set `origin` |
| `git remote -v` | list remotes |
| `git push -u origin <branch>` | publish branch (`-u` once, then just `git push`) |
| `git fetch` | download news, change nothing (`origin/main` moves, `main` doesn't) |
| `git pull` | fetch + merge |
| `git log main..origin/main` | what they have that I don't |
| push rejected? | `git pull`, resolve locally, `git push` |
| `git push origin --delete <branch>` / `git fetch --prune` | remote cleanup |

## The team loop (L10)
```
switch main → pull → switch -c feature/x → commit... → push -u
→ review (diff main...feature/x) → fix → merge --no-ff → push
→ delete branch → everyone pulls → repeat
```

## The habits
1. `git status` before and after everything.
2. `git diff --staged` before every commit.
3. Commit early, commit often — anything committed is reflog-recoverable for ~90 days.
4. Predict, then run.
