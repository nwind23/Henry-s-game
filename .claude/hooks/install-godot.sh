#!/usr/bin/env bash
#
# Install Godot 4.7 (headless-capable) into /usr/local/bin/godot.
#
# Godot's standard Linux editor binary supports running without a display
# via the `--headless` flag, so no separate "server" build is needed.
#
# This script is idempotent: it does nothing if the correct version is
# already installed. It is intended to be run from a SessionStart hook so
# Godot is available in every (ephemeral) web session.

set -euo pipefail

GODOT_VERSION="4.7-stable"
EXPECTED_VERSION="4.7.stable"
INSTALL_PATH="/usr/local/bin/godot"

# Pick the matching arch asset.
case "$(uname -m)" in
  x86_64)  ASSET="Godot_v${GODOT_VERSION}_linux.x86_64.zip" ;;
  aarch64|arm64) ASSET="Godot_v${GODOT_VERSION}_linux.arm64.zip" ;;
  *) echo "install-godot: unsupported arch $(uname -m)" >&2; exit 1 ;;
esac

# Already installed at the right version? Bail early.
if [ -x "$INSTALL_PATH" ] && "$INSTALL_PATH" --version 2>/dev/null | grep -q "^${EXPECTED_VERSION}"; then
  echo "install-godot: ${EXPECTED_VERSION} already installed at ${INSTALL_PATH}"
  exit 0
fi

URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/${ASSET}"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

echo "install-godot: downloading ${URL}"
curl -fL --retry 4 --retry-delay 2 -o "${TMPDIR}/godot.zip" "$URL"
unzip -o -q "${TMPDIR}/godot.zip" -d "$TMPDIR"

BIN="$(find "$TMPDIR" -maxdepth 1 -type f -name 'Godot_v*' | head -1)"
if [ -z "$BIN" ]; then
  echo "install-godot: could not find extracted Godot binary" >&2
  exit 1
fi

install -m 755 "$BIN" "$INSTALL_PATH"
echo "install-godot: installed $("$INSTALL_PATH" --version) at ${INSTALL_PATH}"
