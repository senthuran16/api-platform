#!/usr/bin/env bash
# Shared helpers sourced by setup.sh / demo.sh / teardown.sh

RED=$'\033[0;31m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
BLUE=$'\033[0;34m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
NC=$'\033[0m'

CONTAINER_NAME="mcp-poison-evil-server"
EVIL_SERVER_PORT="${EVIL_SERVER_PORT:-8089}"
EVIL_SERVER_URL="${EVIL_SERVER_URL:-http://localhost:${EVIL_SERVER_PORT}/mcp}"

log_header() { printf "\n%s%s== %s ==%s\n" "$BOLD" "$BLUE" "$1" "$NC"; }
log_info()   { printf "%s%s%s %s\n" "$BLUE" "➜" "$NC" "$1"; }
log_ok()     { printf "%s%s%s %s\n" "$GREEN" "✔" "$NC" "$1"; }
log_warn()   { printf "%s%s%s %s\n" "$YELLOW" "⚠" "$NC" "$1"; }
log_err()    { printf "%s%s%s %s\n" "$RED" "✘" "$NC" "$1" >&2; }

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log_err "Required command '$1' not found. Please install it and re-run."
    exit 1
  fi
}

# mcp_request <url> <json-body> [bearer-token]
# Minimal JSON-RPC-over-HTTP POST helper. Not a spec-complete MCP transport
# (no session negotiation) -- it's just enough to demonstrate tools/list
# filtering for this demo.
mcp_request() {
  local url="$1" body="$2" token="${3:-}"
  local -a headers=(-H "Content-Type: application/json" -H "Accept: application/json, text/event-stream")
  if [[ -n "$token" ]]; then
    headers+=(-H "Authorization: Bearer $token")
  fi
  curl -sS --max-time 10 -X POST "$url" "${headers[@]}" -d "$body"
}
