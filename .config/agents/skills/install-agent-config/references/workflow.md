# Install agent configuration workflow

## Contents

- Source and targets
- Preview
- Install
- Public plugins
- Validate

## Source and targets

Resolve `~` with the active user's home directory. Never embed a username in a path.

| Component | Source | Target |
|---|---|---|
| Shared instructions | `~/.config/agents/AGENTS.md` | `~/.codex/AGENTS.md` symlink |
| Claude adapter | tracked by dotfiles | `~/.claude/CLAUDE.md` |
| Codex defaults | `~/.config/agents/codex/config.toml` | `~/.codex/config.toml` merge |
| Hooks | `~/.config/agents/hooks/*.sh` | referenced in both client settings |

The Claude adapter imports the shared instructions. The Codex adapter is a relative symlink. The
dotfiles checkout normally creates both adapters; repair them only after the user confirms.

## Preview

1. Confirm every source file exists and each hook is executable.
2. Read the live Codex configuration if present.
3. Build a proposed merge where tracked shared keys win and target-only keys remain unchanged.
4. Preserve machine-local tables such as `projects`, `hooks.state`, and model migration records.
5. Remove literal MCP credentials. The Exa server forwards `EXA_API_KEY` with `env_vars`.
6. Show a diff or concise key-level summary and ask for confirmation before writing.

## Install

After confirmation:

1. Create `~/.codex` if needed.
2. Merge the Codex defaults without replacing the complete target file.
3. Verify the instruction symlink and Claude import adapter.
4. Set executable mode on every canonical hook.
5. Leave `~/.codex/rules`, authentication stores, plugin caches, and unrelated skills unchanged.

If `EXA_API_KEY` is unavailable, finish the file installation and report that Exa remains disabled
until the user provides the variable through an untracked environment or credential mechanism.

## Public plugins

Inspect configured marketplaces and installed plugins before mutating them. Skip entries that
already exist.

Register these public marketplaces when missing:

```bash
codex plugin marketplace add trailofbits/skills
codex plugin marketplace add esultanik/skills
```

Install these public plugins when missing:

```bash
codex plugin add culture-index@trailofbits
codex plugin add github-triage@trailofbits
codex plugin add interslavic@esultanik-skills
```

Stop on an authentication, validation, or compatibility failure. Do not substitute another source
or copy plugin content into the dotfiles repository.

## Validate

Run these checks after installation:

```bash
python3 -c 'import os,tomllib;tomllib.load(open(os.path.expanduser("~/.codex/config.toml"),"rb"))'
codex --strict-config doctor --summary
codex plugin list --json
jq empty "$HOME/.claude/settings.json"
shellcheck "$HOME"/.config/agents/hooks/*.sh
shfmt -i 2 -d "$HOME"/.config/agents/hooks/*.sh
```

Report installed, merged, preserved, and skipped components. Recommend starting fresh Claude and
Codex sessions when instructions, hooks, plugins, or Codex defaults changed.
