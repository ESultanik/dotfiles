#!/usr/bin/env python3
"""Validate JSON files and reject duplicate object keys.

`jq empty` accepts duplicate keys and silently keeps the last one. That hid a
Claude Code hook entry with two `command` keys, where the surviving value
pointed at a path that did not exist, so the hook never ran.
"""

from __future__ import annotations

import json
import pathlib
import sys
from typing import Any


def reject_duplicates(pairs: list[tuple[str, Any]]) -> dict[str, Any]:
    """Build an object from its key-value pairs, refusing repeated keys.

    Args:
        pairs: Key-value pairs for one JSON object, in document order.

    Returns:
        The object as a dict.

    Raises:
        ValueError: If a key appears more than once.
    """
    seen: set[str] = set()
    for key, _ in pairs:
        if key in seen:
            raise ValueError(f"duplicate key: {key}")
        seen.add(key)
    return dict(pairs)


def main(paths: list[str]) -> int:
    """Check every path, reporting the first problem found in each file."""
    failed = False
    for path in paths:
        try:
            text = pathlib.Path(path).read_text(encoding="utf-8")
            json.loads(text, object_pairs_hook=reject_duplicates)
        except (OSError, ValueError) as error:
            print(f"{path}: {error}", file=sys.stderr)
            failed = True
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
