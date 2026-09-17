#!/usr/bin/env bash
# Validates the installed agent configuration for both clients. Run after
# install-agent-config writes the live files.

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
readonly script_dir
readonly check_json="${script_dir}/check-json.py"
readonly agent_root="${HOME}/.config/agents"
readonly codex_config="${HOME}/.codex/config.toml"
readonly claude_settings="${HOME}/.claude/settings.json"
readonly stale_hook_re='([~]|[$]HOME)/[.](codex|claude)/hooks/'

fail() {
  printf 'Agent configuration validation failed: %s\n' "$1" >&2
  exit 1
}

command -v python3 >/dev/null 2>&1 || fail "python3 is required."
command -v rg >/dev/null 2>&1 || fail "rg is required."
[[ -f "${codex_config}" ]] || fail "Missing ${codex_config}."
[[ -f "${claude_settings}" ]] || fail "Missing ${claude_settings}."
[[ -f "${check_json}" ]] || fail "Missing ${check_json}."

python3 -c 'import sys,tomllib; tomllib.load(open(sys.argv[1], "rb"))' "${codex_config}" ||
  fail "${codex_config} is not valid TOML."
python3 "${check_json}" "${claude_settings}" ||
  fail "${claude_settings} is not valid JSON, or repeats an object key."

if rg -n --regexp "${stale_hook_re}" "${codex_config}" "${claude_settings}"; then
  fail "Live settings reference a legacy hook directory."
fi

for hook in "${agent_root}"/hooks/*.sh; do
  [[ -f "${hook}" ]] || fail "No canonical hooks were found."
  [[ -x "${hook}" ]] || fail "Hook is not executable: ${hook}."
  for config in "${codex_config}" "${claude_settings}"; do
    rg -q --fixed-strings ".config/agents/hooks/${hook##*/}" "${config}" ||
      fail "Hook is not registered in ${config}: ${hook}."
  done
  printf '{}\n' | "${hook}" >/dev/null || fail "Hook smoke test failed: ${hook}."
done

printf 'Agent configuration validation passed.\n'
