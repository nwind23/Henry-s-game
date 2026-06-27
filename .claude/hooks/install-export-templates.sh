#!/usr/bin/env bash
#
# Install Godot 4.7 *web* export templates so `godot --export-release "Web"`
# works in this (ephemeral) environment.
#
# The official export templates package (.tpz) is ~1.28 GB and contains every
# platform. We download it, extract ONLY the web_*.zip templates into the
# version directory, and delete the archive. This is NOT wired into the
# SessionStart hook (too heavy to run every session) — run it on demand.
#
# Idempotent: skips the download if the web release template is already present.

set -euo pipefail

GODOT_VERSION="4.7-stable"
TPL_DIR="${HOME}/.local/share/godot/export_templates/4.7.stable"
TPZ_URL="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_export_templates.tpz"

if [ -f "${TPL_DIR}/web_release.zip" ] && [ -f "${TPL_DIR}/web_nothreads_release.zip" ]; then
  echo "install-export-templates: web templates already present in ${TPL_DIR}"
  exit 0
fi

mkdir -p "$TPL_DIR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "install-export-templates: downloading export templates (~1.28 GB)..."
curl -fL --retry 4 --retry-delay 2 -o "${TMP}/templates.tpz" "$TPZ_URL"

echo "install-export-templates: extracting web_* templates..."
unzip -o -j "${TMP}/templates.tpz" 'templates/web_*' -d "$TPL_DIR" >/dev/null

echo "install-export-templates: done. Installed:"
ls -1 "$TPL_DIR" | grep '^web_'
