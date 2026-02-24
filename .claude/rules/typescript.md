---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "package.json"
---

# Node/TypeScript

**Runtime:** Node 22 LTS

| purpose      | tool                           |
|--------------|--------------------------------|
| lint         | `oxlint`                       |
| format       | `oxfmt`                        |
| test         | `vitest`                       |
| types        | `tsc --noEmit`                 |

Use the [Oxc toolchain](https://oxc.rs/) (Rust-powered, 50-100x faster than ESLint/Prettier).
Use [Vitest](https://vitest.dev/) for testing - native ESM/TypeScript, drop-in Jest replacement.

## Commands
```bash
oxlint .
oxfmt --write .
vitest run
tsc --noEmit
```

## Security
```bash
# MANDATORY before any install
pnpm config set minimumReleaseAge 1440  # 24-hour delay
pnpm config set ignore-scripts true     # Block postinstall attacks
# For packages that need scripts (review first!)
pnpm install --ignore-scripts && pnpm rebuild <package-name>
```

- Never install packages < 24 hours old
- Never enable postinstall scripts without review
- Audit first: `pnpm audit --audit-level=moderate`
- Pin exact versions (no `^` or `~`) in production
- Review package.json changes in PRs for suspicious scripts
