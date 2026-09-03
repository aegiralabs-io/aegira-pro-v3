#!/usr/bin/env bash
set -euo pipefail

BIN="${1:-./target/release/aegira}"

if [[ ! -x "$BIN" ]]; then
  echo "Binary not found or not executable: $BIN" >&2
  exit 1
fi

"$BIN" --help >/dev/null
"$BIN" version
"$BIN" show-rules >/dev/null

echo "Aegira CLI smoke test passed."
echo "Run the documented service/container recovery tests on a real Linux test host before release."
