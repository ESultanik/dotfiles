# Coding Standards

## Code Quality
1. ≤ 50 code lines / function
2. Cyclomatic complexity ≤ 8
3. ≤ 5 positional params, ≤ 12 branches, ≤ 6 returns
4. 100‑char line length
5. Ban relative (`..`) imports
6. Google‑style docstrings on non-trivial public APIs
7. Follow project's existing test conventions; for new projects, use language defaults (Python: `tests/` directory, Node/TS: colocated `*.test.ts`)
8. No scheduled CI without code changes - activity without progress is theater
9. All code must pass type checking—no `type: ignore` without justification (Python: `ty --strict`, TypeScript: `tsc --noEmit`)

## Philosophy
- **No speculative features** - Don't add "might be useful" functionality
- **No premature abstraction** - Don't create utilities until you've written the same code three times
- **Justify new dependencies** - Each dependency is attack surface and maintenance burden
- **No unnecessary configuration** - Don't add flags unless users actively need them
- **No phantom features** - Don't document or validate features that aren't implemented
- **No hardcoded paths** - Use environment variables or config files, not `/Users/yourname/...`

## Comments
- No comments that repeat what code does
- No commented-out code (delete it)
- No obvious comments ("increment counter")
- No comments instead of good naming
- No comments about updates to old code ("<- now supports xyz")

Principle: Code should be self-documenting. If you need a comment to explain WHAT the code does, refactor to make it clearer.

## Error Handling
- Fail fast with clear error messages
- Never swallow exceptions silently
- Include context in errors (what operation, what input)

## CLI Tools
| tool | replaces | usage |
|------|----------|--------|
| `rg` (ripgrep) | grep | `rg "pattern"` - 10x faster regex search |
| `fd` | find | `fd "*.py"` - fast file finder (`fdfind` on Debian/Ubuntu) |
| `ast-grep` | - | `ast-grep --pattern '$FUNC($$$)' --lang py` - AST-based code search |
| `shellcheck` | - | `shellcheck script.sh` - shell script linter |
| `shfmt` | - | `shfmt -i 2 -w script.sh` - shell formatter |
| `actionlint` | - | `actionlint .github/workflows/` - GitHub Actions linter |
| `zizmor` | - | `zizmor .github/workflows/` - Actions security audit |

ast-grep: `$NAME` = identifier, `$$$` = any code. Languages: py, js, ts, rust, go.

## Workflow

When making changes:
1. Always run linters and type checker before committing
2. Run relevant tests (not full suite) after changes
3. Use `git diff` to verify changes before committing

General rules:
- Never commit changes that break any rule above—refactor instead
- Never push changes to GitHub until asked explicitly to do so
- If asked to write PRs or Issues, don't be hyperbolic in your writeups

## Version Verification
When adding or updating dependencies, CI actions, or tool versions:
1. **Always web search** for the current stable version before specifying any version number
2. Training data versions are stale—never assume a version from memory is current
3. Check the official source (PyPI, npm, GitHub releases) for latest stable
4. Exception: Only skip web search if user explicitly provides the version to use

## Git
- Commit messages: imperative mood, ≤72 char subject line
- One logical change per commit
- Never amend/rebase commits already pushed to shared branches

## When Uncertain
- If requirements are ambiguous, state your assumptions and then ask for clarification
- If a change could have significant unintended consequences, ask before proceeding

## Secrets
- Never commit secrets, API keys, or credentials
- Use `.env` files (gitignored) for local dev
- Reference secrets via environment variables

## Testing

**Mock boundaries, not logic.** Only mock things that are slow (network, filesystem, databases), non-deterministic (time, randomness), or external services you don't control.

Don't mock the code you're testing, pure functions, or dependencies just because they're dependencies. If your test would pass with the implementation deleted, you've mocked too much.

**Verify tests catch failures.** When writing a test:
1. Write the test for the bug/behavior you're preventing
2. Temporarily break the code to verify the test fails
3. Fix and verify it passes
4. Document what specific failure the test prevents

Integration tests catch what unit tests miss. When in doubt, test the real interaction.
