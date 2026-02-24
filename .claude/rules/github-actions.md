---
paths:
  - ".github/**"
---

# GitHub Actions

Pin actions to SHA hashes with version comments:
```yaml
- uses: actions/checkout@<full-sha>  # vX.Y.Z
  with:
    persist-credentials: false
```

## Dependabot Cooldowns
Configure Dependabot with 7-day cooldowns to protect against supply chain attacks:
```yaml
# .github/dependabot.yml - repeat for: pip, npm, github-actions
- package-ecosystem: <ecosystem>
  directory: /
  schedule:
      interval: weekly
  cooldown:
      default-days: 7
  groups:
      all:
          patterns: ["*"]
```

## Linting
- `actionlint .github/workflows/` - validate workflow syntax
- `zizmor .github/workflows/` - security audit
