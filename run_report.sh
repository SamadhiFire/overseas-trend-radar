#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

if [[ -z "${FEISHU_WEBHOOK_URL:-}" && -f "$SCRIPT_DIR/data/webhook.txt" ]]; then
  export FEISHU_WEBHOOK_URL="$(cat "$SCRIPT_DIR/data/webhook.txt")"
fi

python3 "$SCRIPT_DIR/main.py" --send "$@"
