#!/usr/bin/env bash
# PreToolUse(Bash) guard: refuse a mutating `git stash` inside a linked worktree, where
# refs/stash is one stack shared with every other worktree and the user's main checkout.
# Fails open: any unexpected condition allows the command through.

set -uo pipefail

payload=''
IFS='' read -r -d '' payload || true

command -v jq >/dev/null 2>&1 || exit 0
command -v git >/dev/null 2>&1 || exit 0

cmd=$(jq -r '.tool_input.command // empty' <<<"$payload" 2>/dev/null) || exit 0
cwd=$(jq -r '.cwd // empty' <<<"$payload" 2>/dev/null) || exit 0
[ -n "$cmd" ] || exit 0

stash_re='git[[:space:]]+(-C[[:space:]]+[^[:space:]]+[[:space:]]+)?stash'
[[ $cmd =~ ${stash_re}([[:space:]]|$) ]] || exit 0
[[ $cmd =~ ${stash_re}[[:space:]]+(list|show)([[:space:]]|$) ]] && exit 0

target=$cwd
if [[ $cmd =~ git[[:space:]]+-C[[:space:]]+([^[:space:]]+) ]]; then
  target=${BASH_REMATCH[1]}
fi
[ -n "$target" ] && [ -d "$target" ] || exit 0

gitdir=$(git -C "$target" rev-parse --absolute-git-dir 2>/dev/null) || exit 0
common=$(git -C "$target" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || exit 0
[ "$gitdir" != "$common" ] || exit 0

cat >&2 <<'MSG'
Blocked: mutating `git stash` inside a linked worktree.

refs/stash is a single stack shared with every other worktree and with the user's
main checkout, so this can clobber work that is not yours.

Use a WIP commit on your own branch instead:

    git add -A && git commit -m "wip: <what you were doing>"

Commits are safe across worktree removal — objects and refs/heads are shared.
See ~/.claude/reference/git-worktrees.md for the full shared-state map.
MSG
exit 2
