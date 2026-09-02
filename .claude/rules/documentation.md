---
paths:
  - "**/*.md"
  - "**/*.mdx"
  - "**/*.rst"
  - "docs/**"
---

These rules only apply to technical documentation; you can ignore them, e.g., for Markdown
files used for other purposes.

# Technical Documentation

Follow the [Google developer documentation style guide](https://developers.google.com/style).
Distilled below; check the [word list](https://developers.google.com/style/word-list) for terms
not covered here.

## Voice
- Second person ("you"), active voice, present tense
- Conversational, not cute—no slang, pop culture, metaphors, or exclamation marks
- Never call a task "simple," "easy," or "just" one step—it isn't, for someone
- Drop filler: "please note," "obviously," "of course"
- Omit "currently," "at this time," "new," "latest"—give a version or date instead

## Structure
- Sentence case for every title and heading
- State the condition or location before the action: "In the settings page, click **Save**"
- Numbered lists for sequences, bulleted for collections, description lists for term/value pairs
- Every procedural step starts with an imperative verb; one action per step
- A single-step procedure is a bullet, not a numbered list
- Prefix optional steps with "Optional:"—not parentheses
- No directional references ("above," "below")—name or link the section

## Formatting
- Code font for code, filenames, paths, flags, and literal values
- Bold for UI elements the reader acts on
- Descriptive link text—never "click here," "this link," or a bare URL
- Unambiguous dates: 2026-09-02 or September 2, 2026, never 9/2/26
- Serial commas; Oxford comma; American spelling
- Alt text on every image; vector or high-resolution sources

## Words to avoid
| Don't | Use |
|-------|-----|
| allows you to | lets you |
| e.g. / i.e. | for example / that is |
| etc. | list the items |
| and/or | pick one, or rewrite |
| impact (verb) | affect |
| access (verb) | view, edit, use, find |
| comprise | consist of, contain |
| blacklist / whitelist | denylist / allowlist |
| master / slave | primary / replica, controller / worker |
| hang, kill, nuke | stop responding, stop, remove |
| blind to, cripple, dumb down | ignore, slow down, simplify |
| guys | everyone, folks |
| man-in-the-middle | on-path attacker |

Write for readers whose first language isn't English: no idioms, no figures of speech, no jargon
the document hasn't defined.
