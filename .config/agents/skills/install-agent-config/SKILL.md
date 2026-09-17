---
name: install-agent-config
description: >-
  Install or update the shared Claude and Codex configuration from the user's
  neutral agent configuration tree. Use for fresh-machine setup or when syncing
  the tracked global instructions, hooks, Codex defaults, and public plugins.
---

# Install agent config

## Contents

- Workflow
- Safety
- references/workflow.md

Install the tracked cross-client configuration without replacing machine-local state.

## Workflow

1. Read [references/workflow.md](references/workflow.md).
2. Use `~/.config/agents` as the source. Do not fetch configuration from a remote repository.
3. Inventory the live Claude and Codex files, then show the proposed merge before writing.
4. Install only the components the user confirms.
5. Run the validation steps and report any credential or restart follow-up.

## Safety

- Preserve Codex project trust, hook trust, generated rules, authentication, and target-only keys.
- Never copy credentials into the tracked template or live configuration.
- Treat downloaded plugin content as untrusted until the user approves its source.
- Limit plugin setup to the public marketplaces and plugins listed in the workflow.
