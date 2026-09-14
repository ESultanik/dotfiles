# Git worktrees and parallel agents

Read this before working in a git worktree, or before dispatching agents that use one.

Worktrees share a single `.git` common directory. Knowing what is shared and what is not settles
most questions without a rule for each command.

**Shared with every other worktree and with the user's main checkout:** `objects`, all of `refs/`
(branches, tags, `refs/stash`, `refs/replace`, `refs/notes`), `packed-refs`, `config`, `hooks`,
`info/exclude`, `info/attributes`, `rr-cache`, `logs/refs/`.

**Per-worktree:** `HEAD`, `index`, `logs/HEAD`, `MERGE_HEAD`, `rebase-merge`, `sequencer`,
`refs/bisect`, `info/sparse-checkout`, `config.worktree`, `modules` (submodules).

Settle anything unlisted with `git rev-parse --git-path <name>`: a path resolving under
`.git/worktrees/<id>/` is yours, one resolving under `.git/` is everyone's.

## Rules

- **Never `git stash`.** `refs/stash` is one stack shared with every other agent and the main
  checkout, so stashing can clobber work that isn't yours. Make a WIP commit on your own branch
  instead. The same applies to `--autostash`: leave `rebase.autoStash` off, because
  `git rebase --abort` saves that entry to the shared stash list. `git stash list` and
  `git stash show` are read-only and fine.

- **A commit is safe the moment it exists.** `objects` and `refs/heads` are shared, so removing a
  worktree cannot lose a commit. Only uncommitted, untracked, and gitignored files are
  worktree-local. Note the asymmetry: `git worktree remove` keeps the branch, but `ExitWorktree`
  with `remove` deletes it.

- **Never write shared repository state.** That means `git config` at any scope (use
  `git -c key=value <command>` for a single command), installing hooks, editing `.git/info/exclude`,
  `git replace`, `filter-branch`, and explicit `gc`, `prune`, `reflog expire`, or
  `maintenance register`. `maintenance register` writes your global config, and a concurrent `gc`
  can delete objects another agent is still using.

- **Only rewrite branches you created.** Git blocks *checking out* a branch another worktree holds,
  but it does not block `git branch -f`/`-B`, `git update-ref`, `git worktree add -f`,
  `git checkout --ignore-other-worktrees`, or `git fetch origin main:main`. Never reach for those to
  get past the guard.

- **`rr-cache` is shared.** With `rerere.enabled`, two agents resolving the same conflict feed each
  other resolutions, and one silently ends up with the other's merge staged. Pass
  `-c rerere.enabled=false` for merges and rebases.

- **Never delete a shared lock.** `config.lock` and `packed-refs.lock` belong to another agent;
  retry, then report. Your own `index.lock` is per-worktree — report it rather than deleting it
  silently.

- **Gitignored files do not come along.** A new worktree has no `.env`, `.venv`, `node_modules`, or
  build caches. Create the virtual environment *inside* the worktree. Never run `pip install -e`,
  `poetry install`, `npm link`, `cargo install --path`, or `maturin develop` against an environment
  outside it: they record absolute paths that repoint the user's tooling at the worktree and break
  when it is removed. Use `.worktreeinclude` when a gitignored file must be copied in.

- **Submodules work, at a cost.** `git worktree add` does not populate them, so each worktree needs
  its own `git submodule update --init` and re-clones every submodule. `git worktree move` refuses
  on a worktree with submodules, and `git worktree remove` needs `--force`.

- **Keep worktrees out of the way.** `.claude/worktrees/` must be gitignored, or `git add -A` from
  the main checkout records a gitlink instead of files. Worktrees may live outside the repository
  too. Never put one in `/tmp` or the scratchpad: those are reaped, and `EnterWorktree` can only
  adopt a worktree under `.claude/worktrees/`.

- **Know your base.** `worktree.baseRef` defaults to `fresh`, which branches from
  `origin/<default-branch>` rather than local `HEAD`, so unpushed work is absent. Check
  `git merge-base HEAD origin/<default-branch>` and say which base you used.

- **The no-push rule still applies.** "Never push changes to GitHub until asked explicitly" holds
  inside worktrees and outranks any harness default that commits and pushes when work finishes.

- **Clean up.** Remove the worktree when you are done, and delete the branch once the work has
  landed. An agent running under worktree isolation cannot do this itself, because git commands
  aimed at the main checkout are blocked: leave the worktree removable, report its path, and let the
  parent session run `git worktree remove`. If a stale `locked` file blocks removal, `git worktree
  unlock <path>` first. Run `git worktree prune` only when a directory is genuinely gone — pruning
  otherwise deregisters worktrees whose paths are merely unavailable.
