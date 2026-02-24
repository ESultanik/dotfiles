---
paths:
  - "**/*.sh"
  - "**/*.bash"
---

# Bash

All bash scripts must start with strict mode (`set -euo pipefail` exits on errors, undefined vars, and pipeline failures):
```bash
#!/bin/bash
set -euo pipefail
```

Lint and format before committing:
```bash
shellcheck script.sh
shfmt -d script.sh  # Check formatting (-w to fix)
```
