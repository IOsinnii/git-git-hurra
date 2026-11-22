# Bonus capstone — Palmer Penguins 🐧

Replay the entire course ladder in ~1 hour on a **data-science project** instead of a
website. Minimal hand-holding: each stage names the skills and the goal; the *how* is
yours (peek at the [CHEATSHEET](../CHEATSHEET.md) when stuck, lessons when very stuck).

**Why do this?** Skills you've used in only one context are fragile. The second domain
makes them permanent — and proves Git doesn't care whether your files are HTML or Python.

**Setup:** Python 3 (`python --version`), plain standard library — no pandas needed.
The dataset: [`data/penguins-sample.csv`](data/penguins-sample.csv) ships with this
course (24 rows, offline-friendly). If you want the real thing (344 rows), grab
[penguins.csv from the palmerpenguins repo](https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins.csv)
— same columns, plus some empty (`NA`) cells your code will need to survive.

---

## Stage 1 — Repo & first commits *(Lessons 1–2)*

Create `penguin-lab/` next to `playground/`, make it a repo, and build up **three clean
commits**:

1. Copy the CSV in as `penguins.csv` — commit.
2. Add `analysis.py` — commit:

```python
import csv

def load(path="penguins.csv"):
    with open(path, newline="") as f:
        return list(csv.DictReader(f))

def mean_body_mass(rows, species):
    masses = [float(r["body_mass_g"]) for r in rows
              if r["species"] == species and r["body_mass_g"] not in ("", "NA")]
    return sum(masses) / len(masses)

if __name__ == "__main__":
    rows = load()
    for sp in ("Adelie", "Chinstrap", "Gentoo"):
        print(f"{sp:>10}: mean body mass {mean_body_mass(rows, sp):.0f} g")
```

3. Run it (`python analysis.py`), then add a `.gitignore` for `__pycache__/` and
   `output/` — commit.

✅ *Gate: `git log --oneline` = 3 commits; `git diff --staged` was run before each.*

## Stage 2 — Break it, undo it *(Lesson 3)*

- Vandalize `analysis.py`, don't stage — recover with one command.
- Commit a print statement spamming 1000 lines, then remove that commit but **keep the
  edit in your files** (choose the right `reset` flavor).
- Commit something bad again and erase it with `revert` instead. Compare the two `log`s.

✅ *Gate: you can say aloud when `reset` vs `revert` is the right tool.*

## Stage 3 — Branch, fork, conflict *(Lessons 4–5)*

- On branch `flipper-stats`, add a `mean_flipper_length(rows, species)` function and
  print it in the main loop. Two commits.
- Meanwhile **on `main`** (this time *you* are your own meddling teammate), change the
  print format of the body-mass line (e.g. add `±` or change decimals). One commit.
- Merge `flipper-stats` into `main`. Both branches touched the print loop → resolve the
  conflict so the output shows **both** statistics in the **new** format.

✅ *Gate: `git log --oneline --graph` shows a diamond; `python analysis.py` prints both stats.*

## Stage 4 — Look under the hood *(Lesson 6)*

- `cat-file -p` your merge commit: confirm **two parents**.
- Walk commit → tree → the `penguins.csv` blob; confirm the blob hash is **identical**
  in the newest and the very first commit (you never changed the data — so it's stored once).

✅ *Gate: you found the same blob hash reachable from two different commits.*

## Stage 5 — Clean history like a pro *(Lessons 7–8)*

- On branch `sample-counts`, add a per-species row count in three sloppy commits
  ("wip", "typo", "fix"). Then `rebase -i` them into **one** well-named commit and merge.
- Tag the result `v1.0 -a`.
- Deliberately `git reset --hard HEAD~2` on a scratch branch, then restore it via the
  reflog.

✅ *Gate: published history contains no "wip"; the "lost" commits are back.*

## Stage 6 — Publish & collaborate *(Lessons 9–10)*

- Create `penguin-hub.git` (bare), add it as `origin`, push `main` and `v1.0`.
- Clone a `penguin-lab-colleague/`. Run the full **feature-branch loop** for one last
  feature — `feature/island-report`: a function printing penguin counts per **island**
  — developed in one clone, *reviewed* (diff read + script run) in the other, merged
  with `--no-ff`, branch deleted on both sides and on the remote.
- Engineer one rejected push (commit in both clones without pulling) and untangle it.

✅ *Gate: both clones' `git log --oneline --graph` are identical, ending in the merge diamond.*

---

## Done?

Then you have shipped version-controlled work in **two domains** with branching, history
surgery, disaster recovery, and a review workflow. There is no Git situation in a junior
(or frankly mid-level) job you haven't already survived here.

Final flex: `git log --oneline --graph --all` in both projects, side by side. 🐧🐈 Hurra!
