---
paths:
  - "**/*.py"
  - "pyproject.toml"
  - "uv.lock"
---

# Python

**Runtime:** 3.13 with `uv venv`

| purpose          | tool                           |
|------------------|--------------------------------|
| deps & venv      | `uv`                           |
| lint & format    | `ruff check` · `ruff format`   |
| static types     | `ty --strict`                  |
| tests            | `pytest -q`                    |

Always use `uv` instead of pip - it's faster and handles venvs automatically.
Build with `hatchling` - simpler than setuptools, just `[build-system]` in pyproject.toml.
Lint with `ruff` only - replaces black/pylint/flake8, use `extend-exclude` not `exclude`.
Use official actions - `astral-sh/ruff-action@<sha>  # vX.Y.Z`
Linting versions - Keep flexible (`ruff>=0.12.0,<1.0`) - newer versions find more bugs, can't break working code.
Remove pip fallbacks - no `pip || uv` patterns, pick one tool and commit.
Test modernizations - always verify: `uv build`, `uv tool install dist/*.whl`, `uv tool install -e .`
Update all references - every README, Makefile, CI config must be updated.
Let tools auto-detect - Don't specify versions in CI that tools can read from pyproject.toml

## Type Checking with `ty`
- **New projects**: `ty --strict` is mandatory—no untyped code accepted
- **Existing projects**: Add type checking incrementally when modifying code
- Run `uv run ty check` before committing Python changes
- Add `py.typed` marker file to indicate typed packages

## Commands
```bash
uv run ruff check --fix
uv run ty check
pytest -q
rg "pip|setup.py|black|pylint" -g "*.md" -g "*.yml"  # Find outdated tooling
```

## Security
- Use `uv` lockfiles (`uv.lock`) - ensures reproducible, verified installs
- Run `pip-audit` or `safety check` before deploying
- Pin exact versions in production (`==` not `>=`)
- Verify package hashes: `uv pip install --require-hashes`
