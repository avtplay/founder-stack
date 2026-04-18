#!/usr/bin/env bash
# founder-stack — one-command install
# Claude will run this automatically when asked to install founder-stack

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$SCRIPT_DIR/scripts/setup-wsl.sh"
